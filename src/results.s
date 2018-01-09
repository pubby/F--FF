.include "globals.inc"

.import nmi_return
.import ppu_setup_text_chr
.import time_digit_table
.import update_return
.import init_menu
.import read_gamepads
.import penguin_process
.import penguin_set_song

.export init_results

pal_ptr = l1100 ; 2 bytes
pal_index = l1100 + 2 ; 1 bytes

.segment "RODATA"
.scope strings
    .include "strings.inc"
.endscope

.segment "CODE"
.proc results_nmi
    bit PPUSTATUS
    storePPUADDR #$3F00
    ldy #0
:
    lda (pal_ptr), y
    sta PPUDATA
    iny
    cpy #16
    bne :-

    lda #0
    sta PPUSCROLL
    ldx two_player
    bne twoP
    lda #192
twoP:
    sta PPUSCROLL

    lda #PPUMASK_BG_ON | PPUMASK_NO_BG_CLIP
    sta PPUMASK
    lda #PPUCTRL_NMI_ON | PPUCTRL_8X16_SPR
    ldx two_player
    bne twoP2
    ora #PPUCTRL_NT_2800
twoP2:
    sta PPUCTRL

    jsr penguin_process

    inc nmi_counter
    jmp nmi_return
.endproc

.segment "RODATA"
results_pal0:
    .byt $0F,$01,$01,$0F
results_pal1:
    .byt $0F,$02,$02,$00
results_pal2:
    .byt $0F,$13,$13,$10
results_pal3:
    .byt $0F,$14,$14,$20

.segment "CODE"

.proc init_results
    lda #0
    sta $4015
    sta PPUMASK
    sta PPUCTRL
    sta pal_index

    store16into #results_fade_in, update_ptr
    store16into #results_pal0, pal_ptr
    store16into #results_nmi, nmi_ptr

    ldy #0
    jsr ppu_setup_text_chr

    storePPUADDR #$3F00
    ldy #0
:
    lda results_pal0, y
    sta PPUDATA
    iny
    cpy #4
    bne :-

    ; Clear NT
    bit PPUSTATUS
    ldx #$20
    stx PPUADDR
    ldx #$00
    stx PPUADDR
    txa
    .repeat 4
    :
        sta PPUDATA
        inx
        bne :-
    .endrepeat
    ldx #$28
    stx PPUADDR
    ldx #$00
    stx PPUADDR
    txa
    .repeat 4
    :
        sta PPUDATA
        inx
        bne :-
    .endrepeat

    ; Adjust p2_lap
    lax p2_lap
    axs #.lobyte(-4)
    stx p2_lap

    ; Adjust the lap times to be correct
    jsr calc_lap_times

    ; Write strings
    p1x = 6
    p1y = 4

    p2x = 6
    p2y = 17

    storePPUADDR #XYADDR $2000, p1x, p1y+0
    ldy #strings::player1
    jsr write_string

    storePPUADDR #XYADDR $2000, p1x, p1y+2
    ldy #strings::lap1
    jsr write_string
    ldy #0
    jsr p1_write_lap_time

    storePPUADDR #XYADDR $2000, p1x, p1y+4
    ldy #strings::lap2
    jsr write_string
    ldy #1
    jsr p1_write_lap_time

    storePPUADDR #XYADDR $2000, p1x, p1y+6
    ldy #strings::lap3
    jsr write_string
    ldy #2
    jsr p1_write_lap_time

    storePPUADDR #XYADDR $2000, p1x, p1y+8
    ldy #strings::total_time
    jsr write_string
    jsr p1_write_total_time

    lda two_player
    beq done2p

    storePPUADDR #XYADDR $2000, p2x, p2y+0
    ldy #strings::player2
    jsr write_string

    storePPUADDR #XYADDR $2000, p2x, p2y+2
    ldy #strings::lap1
    jsr write_string
    ldy #4
    jsr p2_write_lap_time

    storePPUADDR #XYADDR $2000, p2x, p2y+4
    ldy #strings::lap2
    jsr write_string
    ldy #5
    jsr p2_write_lap_time

    storePPUADDR #XYADDR $2000, p2x, p2y+6
    ldy #strings::lap3
    jsr write_string
    ldy #6
    jsr p2_write_lap_time

    storePPUADDR #XYADDR($2000, p2x, p2y+8)
    ldy #strings::total_time
    jsr write_string
    jsr p2_write_total_time
done2p:

    ldx #3
    jsr penguin_set_song

    lda #PPUCTRL_NMI_ON | PPUCTRL_8X16_SPR
    bit PPUSTATUS
    sta PPUCTRL

    jmp update_return
.endproc

.proc results_fade_in
    lax pal_index
    anc #%01111100
    adc #.lobyte(results_pal0)
    sta pal_ptr+0
    lda #.hibyte(results_pal0)
    adc #0
    sta pal_ptr+1
    cpx #3*4
    bcs :+
    inx
:
    stx pal_index

    jsr read_gamepads
    lda p1_buttons_pressed
    and #BUTTON_START
    beq :+
    store16into #results_fade_out, update_ptr
:

    jmp update_return
.endproc

.proc results_fade_out
    lax pal_index
    anc #%01111100
    adc #.lobyte(results_pal0)
    sta pal_ptr+0
    lda #.hibyte(results_pal0)
    adc #0
    sta pal_ptr+1
    dex
    bmi doneFadeOut
    stx pal_index
    jmp update_return
doneFadeOut:
    jmp init_menu
.endproc


.proc calc_lap_times
    ; Save the lap time
    lda 2+lap_time_sub
    sta 3+lap_time_sub
    lda 6+lap_time_sub
    sta 7+lap_time_sub
    .repeat 4, k
        lda 2+LAPTIME k
        sta 3+LAPTIME k
        lda 6+LAPTIME k
        sta 7+LAPTIME k
    .endrepeat

    ldx #2
    ldy #1
    jsr calc
    jsr calc
    ldx #2+4
    ldy #1+4
    jsr calc
    ; fall-through
calc:
    sec
    lda lap_time_sub, x
    sbc lap_time_sub, y
    bcs :+
    adc #60
    clc
:
    sta lap_time_sub, x
.repeat 4, i
    lda LAPTIME i, x
    sbc LAPTIME i, y
    bcs :+
    .if (i & 1) = 0
        adc #10
    .else
        adc #6
    .endif
    clc
:
    sta LAPTIME i, x
.endrepeat
    dex
    dey
    rts
.endproc

.proc p1_write_lap_time
    cpy p1_lap
    bcc ppu_write_lap_time
    ldy #strings::na
    jmp write_string
.endproc

.proc p2_write_lap_time
    cpy p2_lap
    bcc ppu_write_lap_time
    ldy #strings::na
    jmp write_string
.endproc

.proc p1_write_total_time
    ldy #3
    cpy p1_lap
    beq ppu_write_lap_time
    ldy #strings::crashed
    jmp write_string
.endproc

.proc p2_write_total_time
    ldy #7
    cpy p2_lap
    beq ppu_write_lap_time
    ldy #strings::crashed
    jmp write_string
.endproc

.proc ppu_write_lap_time
    ldx #$1A ; comma
    lda lap_time_3, y
    ora #$20
    sta PPUDATA
    lda lap_time_2, y
    ora #$20
    sta PPUDATA
    stx PPUDATA
    lda lap_time_1, y
    ora #$20
    sta PPUDATA
    lda lap_time_0, y
    ora #$20
    sta PPUDATA
    stx PPUDATA
    lax lap_time_sub, y
    lda time_digit_table, x
    and #%00001111
    ora #$20
    sta PPUDATA
    lda time_digit_table, x
    alr #%11110000
    lsr
    lsr
    lsr
    ora #$20
    sta PPUDATA
    rts
.endproc

.proc write_string
:
    lda strings::game_strings, y
    beq return
    sta PPUDATA
    iny
    jmp :-
return:
    rts
.endproc

.include "globals.inc"
.include "sfx.inc"

.import clear_remaining_cpu_oam
.import nmi_return
.import prepare_menu_sprites
.import ppu_copy_palette_buffer
.import palette
.import update_return
.import decompress_tokumaru
.import sprites_chr, rad_chr
.import read_gamepads
.import init_game
.import menu_palette
.import penguin_process
.import penguin_set_song

.export init_menu
.export update_menu

.segment "B2_CODE"
.include "rad.inc"

.segment "NMI_CODE"
.proc menu_nmi
    ; Do OAM DMA.
    lda #.hibyte(CPU_OAM)
    sta OAMDMA

    bit PPUSTATUS
    jsr ppu_copy_palette_buffer

    lda two_player
    beq not2p
    jsr rad2_nt_swaps
    jmp doneNTSwaps
not2p:
    jsr rad_nt_swaps
doneNTSwaps:

    ldx #0
    stx PPUADDR
    stx PPUADDR
    stx PPUSCROLL
    lda menu_scroll
    sta PPUSCROLL

    lda #PPUMASK_BG_ON | PPUMASK_NO_BG_CLIP| PPUMASK_SPR_ON | PPUMASK_NO_SPR_CLIP
    sta PPUMASK
    lda #PPUCTRL_NMI_ON | PPUCTRL_8X16_SPR | PPUCTRL_NT_2000
    sta PPUCTRL

    jsr penguin_process

    inc nmi_counter
    jmp nmi_return
.endproc

.segment "CODE"
.proc init_menu
    ldx #0
    stx $4015
    stx PPUMASK
    stx PPUCTRL
    stx menu_scroll
    jsr clear_remaining_cpu_oam
    store16into #update_menu, update_ptr
    store16into #menu_nmi, nmi_ptr

    lda #0
    sta PPUADDR
    sta PPUADDR
    bankswitch_to sprites_chr
    store16into #rad_chr, ptr_temp
    jsr decompress_tokumaru
    store16into #sprites_chr, ptr_temp
    jsr decompress_tokumaru

    storePPUADDR #$2000
    tax                 ; X = 0
    .repeat 4, i
    :
        sta PPUDATA
        dex
        bne :-
    .endrepeat

    bankswitch_to rad_nt
    storePPUADDR #$2800
    tax                 ; X = 0
    .repeat 4, i
    :
        lda rad_nt+i*256, x
        sta PPUDATA
        inx
        bne :-
    .endrepeat

    ldx #0
paletteLoop:
    lda menu_palette, x
    sta palette_buffer, x
    inx
    cpx #32
    bne paletteLoop

    ldx #2
    jsr penguin_set_song

    lda #PPUCTRL_NMI_ON | PPUCTRL_8X16_SPR
    bit PPUSTATUS
    sta PPUCTRL
    bankswitch_to init_scroll_in
    jmp init_scroll_in
.endproc

.proc update_menu
    jsr read_gamepads

    lda p1_buttons_pressed
    and #BUTTON_SELECT
    ora p2_buttons_pressed
    and #BUTTON_START | BUTTON_SELECT
    beq doneChangePlayers
    lda two_player
    eor #1
    sta two_player
    bankswitch 1
    jsr triangle_sfx_0
doneChangePlayers:

    lda p1_buttons_pressed
    ora p2_buttons_pressed
    and #BUTTON_UP
    beq doneUp
    ldx track_number
    dex
    bpl :+
    ldx #2
:
    stx track_number
    bankswitch 1
    jsr triangle_sfx_0
doneUp:

    lda p1_buttons_pressed
    ora p2_buttons_pressed
    and #BUTTON_DOWN
    beq doneDown
    ldx track_number
    inx
    cpx #3
    bcc :+
    ldx #0
:
    stx track_number
    bankswitch 1
    jsr triangle_sfx_0
doneDown:

    bankswitch_to update_scroll_in
    jmp (menu_update_ptr)
.endproc
menu_update_return:
    jsr prepare_menu_sprites
    jmp update_return

.segment "B2_CODE"

.proc init_scroll_in
    store16into #update_scroll_in, menu_update_ptr
    store8into #16, timer
    jmp menu_update_return
.endproc

.proc update_scroll_in
    lda menu_scroll
    lsr
    sec
    adc menu_scroll
    bcc :+
    lda #239
:
    sta menu_scroll

    dec timer
    bne :+
    jmp init_text_in
:
    jmp menu_update_return
.endproc


.proc init_text_in
    store16into #update_text_in, menu_update_ptr
    jmp menu_update_return
.endproc

.proc update_text_in
    lda menu_icy_x
    lsr
    sec
    adc menu_icy_x
    bcc :+
    lda #239
:
    sta menu_icy_x

    cmp #32
    bcc doneSpicy
    lda menu_spicy_x
    lsr
    sec
    adc menu_spicy_x
    bcc :+
    lda #239
:
    sta menu_spicy_x
doneSpicy:

    cmp #32
    bcc doneDicey
    lda menu_dicey_x
    lsr
    sec
    adc menu_dicey_x
    bcc :+
    lda #239
:
    sta menu_dicey_x
    lda menu_state
    ora #MENU_SHOW_CURSOR
    sta menu_state
doneDicey:

    bcc doneStart
    lda p1_buttons_pressed
    and #BUTTON_START
    beq doneStart
    jmp init_text_out
    stx track_number
doneStart:

    ldx track_number
    bne notCursor0
        lda #$2C
        jmp storePalette
notCursor0:
    dex
    bne notCursor1
        lda #$25
        jmp storePalette
notCursor1:
        lda #$29
storePalette:
    sta palette_buffer+3
    sta palette_buffer+11

    jmp menu_update_return
.endproc

.proc init_text_out
    lda menu_state
    and #$FF ^ MENU_SHOW_CURSOR
    sta menu_state
    store8into #36, timer
    ldx track_number
    lda update_text_lo, x
    sta menu_update_ptr+0
    lda update_text_hi, x
    sta menu_update_ptr+1
    jmp menu_update_return
.endproc

.proc update_text_out
icy:
    lsr menu_icy_x
    bne done
    lsr menu_spicy_x
    bne done
    lsr menu_dicey_x
    bne done
    beq scrollOut
spicy:
    lsr menu_spicy_x
    bne done
    lsr menu_icy_x
    bne done
    lsr menu_dicey_x
    bne done
    beq scrollOut
dicey:
    lsr menu_dicey_x
    bne done
    lsr menu_spicy_x
    bne done
    lsr menu_icy_x
    bne done
scrollOut:
    lda menu_scroll
    alr #%11111110
    adc menu_scroll
    ror 
    sta menu_scroll
done:
    dec timer
    beq init_fadeout
    jmp menu_update_return
.endproc

update_text_lo:
    .byt .lobyte(update_text_out::icy)
    .byt .lobyte(update_text_out::spicy)
    .byt .lobyte(update_text_out::dicey)
update_text_hi:
    .byt .hibyte(update_text_out::icy)
    .byt .hibyte(update_text_out::spicy)
    .byt .hibyte(update_text_out::dicey)

.proc init_fadeout
    store8into #30, timer
    store16into #update_fadeout, menu_update_ptr
    jmp menu_update_return
.endproc

.proc update_fadeout
    lda timer
    lsr
    bcc done
    ldx #31
loop:
    sec
    lda palette_buffer, x
    sbc #$10
    bcs :+
    lda #$0F
:
    sta palette_buffer, x
    dex
    bne loop
done:
    dec timer
    bne :+
    jmp init_game
:
    jmp menu_update_return
.endproc

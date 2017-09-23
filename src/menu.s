.include "globals.inc"

.import nmi_return
.import prepare_menu_sprites
.import ppu_copy_palette_buffer
.import palette
.import update_return
.import decompress_tokumaru
.import sprites_chr, rad_chr
.import read_gamepads
.import init_game

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

    lda menu_data
    and #MENU_2P
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

    inc nmi_counter
    jmp nmi_return
.endproc

.segment "CODE"
.proc init_menu
    lda #0
    sta menu_scroll
    sta PPUMASK
    sta PPUCTRL
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
    lda palette, x
    sta palette_buffer, x
    inx
    cpx #32
    bne paletteLoop

    lda #PPUCTRL_NMI_ON | PPUCTRL_8X16_SPR
    bit PPUSTATUS
    sta PPUCTRL
    jmp init_scroll_in
.endproc

.proc update_menu
    jsr read_gamepads
    jsr prepare_menu_sprites

    lda p1_buttons_pressed
    and #BUTTON_SELECT
    ora p2_buttons_pressed
    and #BUTTON_START | BUTTON_SELECT
    beq doneChangePlayers
    lda menu_data
    eor #MENU_2P
    sta menu_data
doneChangePlayers:

    lda p1_buttons_pressed
    ora p2_buttons_pressed
    and #BUTTON_UP
    beq doneUp
    ldx menu_cursor
    dex
    bpl :+
    ldx #2
:
    stx menu_cursor
doneUp:

    lda p1_buttons_pressed
    ora p2_buttons_pressed
    and #BUTTON_DOWN
    beq doneDown
    ldx menu_cursor
    inx
    cpx #3
    bcc :+
    ldx #0
:
    stx menu_cursor
doneDown:

    bankswitch_to update_scroll_in
    jmp (menu_update_ptr)
.endproc

.segment "B2_CODE"

.proc init_scroll_in
    store16into #update_scroll_in, menu_update_ptr
    store8into #16, menu_timer
    jmp update_return
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

    dec menu_timer
    bne :+
    jmp init_text_in
:
    jmp update_return
.endproc


.proc init_text_in
    store16into #update_text_in, menu_update_ptr
    jmp update_return
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
    stx menu_cursor
doneStart:

    ldx menu_cursor
    bne notCursor0
        lda #$33
        jmp storePalette
notCursor0:
    dex
    bne notCursor1
        lda #$35
        jmp storePalette
notCursor1:
        lda #$39
storePalette:
    sta palette_buffer+3
    sta palette_buffer+11

    jmp update_return
.endproc

.proc init_text_out
    lda menu_state
    and #$FF ^ MENU_SHOW_CURSOR
    sta menu_state
    store8into #36, menu_timer
    store16into #update_text_out, menu_update_ptr
    jmp update_return
.endproc

.proc update_text_out
    lsr menu_icy_x
    bne done
    lsr menu_spicy_x
    bne done
    lsr menu_dicey_x
    bne done
    lda menu_scroll
    alr #%11111110
    adc menu_scroll
    ror 
    sta menu_scroll
    bne done
done:
    dec menu_timer
    beq init_fadeout
    jmp update_return
.endproc

.proc init_fadeout
    store8into #16, menu_timer
    store16into #update_fadeout, menu_update_ptr
    jmp update_return
.endproc

.proc update_fadeout
    lda frame_number
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
    dec menu_timer
    bne :+
    jmp init_game
:
    jmp update_return
.endproc

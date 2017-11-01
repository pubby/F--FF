.include "globals.inc"

.import decompress_tokumaru
.import prepare_game_sprites
.import setup_cos, setup_sin
.importzp multiply_store
.import copy_multiply_code
.import p1_move, p2_move
.import p1_render, p2_render
.import init_menu
.import read_gamepads
.import init_flag
.import ppu_copy_palette_buffer
.import icy_palette
.import init_game_sprites

.export main, nmi_handler, irq_handler, nmi_return
.export update_return
.export sprites_chr, rad_chr
.export init_game

.segment "BANK0_END"
.byt 0
.segment "BANK1_END"
.byt 1
.segment "BANK2_END"
.byt 2
.segment "BANK3_END"
.byt 3

.segment "CODE"
track_size: .byt 64

.segment "LEVELS"
.scope l1
    .include "foo.level.inc"
.endscope
.scope l2
    .include "foo.level.inc"
.endscope
.scope l3
    .include "foo.level.inc"
.endscope

.segment "NMI_CODE"

.proc game_nmi
    lsr subframes_left
    bne :+ 
    lda frame_ready
    bne renderFrame
:

    ; Do OAM DMA
    lda #.hibyte(CPU_OAM)
    sta OAMDMA

    jsr ppu_copy_palette_buffer

    ldx #$00
    stx PPUMASK
    ldx #$20
.repeat 3, i
:
    lda $00
    dex
    bne :-
.endrepeat
    ldx #$83
:
    lda $00
    dex
    bne :-
    
    jmp return

renderFrame:
    ; Do OAM DMA (without reading controllers)
    lda #.hibyte(CPU_OAM) ; A = $03
    sta OAMDMA
    ;lda #%111
    sta subframes_left

    bit PPUSTATUS
    lda #$20
    sta PPUADDR
    ldx #$00
    stx PPUADDR
    stx PPUMASK
    lda #$FF
    .repeat 2, i
    :
        .repeat 64, j
            ldy nt_buffer+(i*256)+j, x
            sty PPUDATA
        .endrepeat
        axs #.lobyte(-64)
        beq :+
        jmp :-
    :
    .endrepeat
    .repeat 32*22-512, i
        lda nt_buffer+i+512
        sta PPUDATA
    .endrepeat

    inc nmi_counter
return:
    stx PPUSCROLL
    stx PPUSCROLL
    stx PPUADDR
    stx PPUADDR

    lda #PPUMASK_BG_ON | PPUMASK_NO_BG_CLIP| PPUMASK_SPR_ON | PPUMASK_NO_SPR_CLIP
    sta PPUMASK
    lda #PPUCTRL_NMI_ON | PPUCTRL_8X16_SPR
    sta PPUCTRL

    jmp nmi_return
.endproc

.segment "CODE"

; 4+3+3+4+3+2+4+5 = 28 cycles
.proc nmi_handler
    pha
    stx nmi_x
    sty nmi_y
    lda $BFFF ; current bank
    sta nmi_bank
    bankswitch_to game_nmi
    jmp (nmi_ptr)
.endproc

.proc nmi_return
    ; Restore registers and return.
    ldy nmi_bank
    bankswitch_y
    ldx nmi_x
    ldy nmi_y
    pla
    rti
.endproc

.proc irq_handler
    rti
.endproc

update_return:
    lda nmi_counter
:
    cmp nmi_counter
    beq :-
    jmp (update_ptr)


.proc update_game
    lda #0
    sta frame_ready
    ;sta debug
    inc frame_number

    jsr prepare_game_sprites

    bankswitch_to clear_nt_buffer
    jsr clear_nt_buffer
    jsr read_gamepads

    jsr p1_move
    lda #SPLITSCREEN_LEFT
    ;sta line_splitscreen
    jsr p1_render

    ;jsr p2_move
    ;lda #SPLITSCREEN_RIGHT
    ;sta line_splitscreen
    ;jsr p2_render

    clc
    lda time_sub
    adc #2
    sta time_sub
    sbc #60-1
    bne doneDigitUpdate
    sta time_sub
    lda #10
    isc time_digits+0
    bne doneDigitUpdate
    sta time_digits+0
    lda #6
    isc time_digits+1
    bne doneDigitUpdate
    sta time_digits+1
    lda #10
    isc time_digits+2
    bne doneDigitUpdate
    sta time_digits+2
    lda #6
    isc time_digits+3
    bne doneDigitUpdate
    sta time_digits+3
doneDigitUpdate:

    lda frame_number
    lsr
    bcc doneRainbowPalette

    ldx #%11110000
    ldy #1
rainbowPaletteLoop:
    lda palette_buffer, y
    sax subroutine_temp
    anc #%00001111
    adc #1
    cmp #$D
    bne :+
    lda #$1
:
    ora subroutine_temp
    sta palette_buffer, y
    lda next_palette_index, y
    tay
    bne rainbowPaletteLoop
doneRainbowPalette:


    lda #1 
    ;sta debug
    sta frame_ready
    jmp update_return
.endproc

next_palette_index:
.byt 0,  2,  3,  5
.byt 0,  6,  7,  9
.byt 0, 10, 11, 13
.byt 0, 14, 15,  0

main:
    ;jmp init_menu
    jmp init_flag
.proc init_game
    ldx #0
    stx PPUMASK
    stx PPUCTRL
    stx subframes_left
    inx                 ; X = 1
    stx frame_ready
    store16into #game_nmi, nmi_ptr
    store16into #update_game, update_ptr

    lda #PLAYERS_2
    sta game_flags

    lda #64
    sta p1_boost_tank

    ; Setup attributes.
    bit PPUSTATUS
    storePPUADDR #$23C0
    lda #%00000000
    ldx #8
:
    sta PPUDATA
    dex
    bne :-
    lda #%01010101
    ldx #8
:
    sta PPUDATA
    dex
    bne :-
    lda #%10101010
    ldx #16
:
    sta PPUDATA
    dex
    bne :-
    lda #%11111111
    ldx #32
:
    sta PPUDATA
    dex
    bne :-

    jsr copy_multiply_code


    ; Palette
    ldx #0
paletteLoop:
    lda icy_palette, x
    sta palette_buffer, x
    inx
    cpx #32
    bne paletteLoop

    ; Sprites
    jsr init_game_sprites

    lda #140
    sta camera_height

    ; setup pointers (TODO)
    store16into #l1::ltx_lo, lx_lo_ptr
    store16into #l1::ltx_hi, lx_hi_ptr
    store16into #l1::lty_lo, ly_lo_ptr
    store16into #l1::lty_hi, ly_hi_ptr
    store16into #l1::rtx_lo, rx_lo_ptr
    store16into #l1::rtx_hi, rx_hi_ptr
    store16into #l1::rty_lo, ry_lo_ptr
    store16into #l1::rty_hi, ry_hi_ptr
    store16into #l1::tf, tf_ptr
    ; TODO
    ;bankswitch_to track_size
    lda #l1::track_size
    sta level_length

    bankswitch_to ppu_load_4x4_pixels_chr
    jsr ppu_load_4x4_pixels_chr

    lda #0
    sta p1_dir_speed
    sta p1_dir+0
    ;lda #180
    ;sta p1_dir+1

    lda #PPUCTRL_NMI_ON | PPUCTRL_8X16_SPR
    bit PPUSTATUS
    sta PPUCTRL
    jmp update_return
.endproc

.segment "SMALL_TABLES"
top_pixel_pattern_table:
.repeat 16, i
    .if i & %0100 && i & %1000
        .byt %11111111
    .elseif i & %0100
        .byt %00001111
    .elseif i & %1000
        .byt %11110000
    .else
        .byt %00000000
    .endif
.endrepeat
bottom_pixel_pattern_table:
.repeat 16, i
    .if i & %0001 && i & %0010
        .byt %11111111
    .elseif i & %0001
        .byt %00001111
    .elseif i & %0010
        .byt %11110000
    .else
        .byt %00000000
    .endif
.endrepeat

.segment "B2_CODE"
.proc clear_nt_buffer
    lda #0
    .repeat 32*22, i
        sta nt_buffer+i
    .endrepeat
    rts
.endproc

.segment "CHR"
sprites_chr:
    .incbin "sprpack.cchr"
rad_chr:
    .incbin "rad.cchr"

.proc ppu_load_4x4_pixels_chr
    ldx #0
    stx PPUADDR
    stx PPUADDR
loop:
    txa
    and #%00001111
    tay
    jsr writeHalfTile
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    jsr writeHalfTile
    inx
    bne loop
    rts
writeHalfTile:
    lda top_pixel_pattern_table, y
    jsr store
    lda bottom_pixel_pattern_table, y
store:
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    rts
.endproc

    ;.incbin "bullets.chr"

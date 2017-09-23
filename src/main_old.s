.include "globals.inc"

.import decompress_tokumaru
.import ppu_set_palette
.import prepare_game_sprites
.import setup_cos, setup_sin
.importzp multiply_store
.import copy_multiply_code
.import p1_move, p2_move
.import render
.import ppu_init_rad_menu
.import menu_nmi
.import update_menu
.import read_gamepads

.export main, nmi_handler, irq_handler, nmi_return

.segment "P0B"
.byt 0
.segment "P1B"
.byt 1
.segment "P2B"
.byt 2

.segment "LEVELS"
.include "foo.level.inc"

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

    ldx #$00
    stx PPUMASK
.repeat 2, i
:
    lda $00
    dex
    bne :-
.endrepeat
    ldx #$A8
:
    lda $00
    dex
    bne :-
    
    jmp return

renderFrame:
    jmp return ; TODO
    ; Do OAM DMA (without reading controllers)
    lda #.hibyte(CPU_OAM) ; A = $03
    sta OAMDMA
    sta subframes_left

    bit PPUSTATUS

    lda #$20
    sta PPUADDR
    ldx #$00
    stx PPUADDR
    stx PPUMASK

    .repeat 32*22, i
        lda nt_buffer+i
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

.proc nmi_handler
    pha
    stx nmi_x
    sty nmi_y
    lda $8000 ; current bank
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

; TODO
.proc ppu_clear_attributes
    rts
.endproc

.proc main
    ;store16into #menu_nmi, nmi_ptr
    store16into #game_nmi, nmi_ptr
    ldx #0
    stx PPUCTRL
    stx PPUMASK
    stx frame_number
    stx subframes_left
    inx                 ; X = 1
    stx frame_ready

    bit PPUSTATUS
    jsr ppu_set_palette

.repeat 2, i
    bit PPUSTATUS
    lda #$23 + $08*i
    sta PPUADDR
    lda #$C0
    sta PPUADDR
    lda #0
    ldx #64
:
    sta PPUDATA
    dex
    bne :-
.endrepeat

    bit PPUSTATUS
    lda #$23
    sta PPUADDR
    lda #$C0
    sta PPUADDR
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

    lda #128
    sta camera_height

    ; TODO
    lda #63;+128
    jsr setup_sin
    lda #.lobyte(-$2020)
    sta multiply_store
    lda #.hibyte(-$2020)
    jsr multiply
;:
    ;jmp :-


    ; setup pointers (TODO)
    store16into #ltx_lo, lx_lo_ptr
    store16into #ltx_hi, lx_hi_ptr
    store16into #lty_lo, ly_lo_ptr
    store16into #lty_hi, ly_hi_ptr
    store16into #rtx_lo, rx_lo_ptr
    store16into #rtx_hi, rx_hi_ptr
    store16into #rty_lo, ry_lo_ptr
    store16into #rty_hi, ry_hi_ptr
    lda #12
    sta level_length

    bankswitch_to ppu_load_4x4_pixels_chr
    jsr ppu_load_4x4_pixels_chr
    store16into #sprites_chr, ptr_temp
    jsr decompress_tokumaru
.if 0
    ldx #0
    stx PPUADDR
    stx PPUADDR
    store16into #sprites_chr, ptr_temp
    jsr decompress_tokumaru
    store16into #menu_sprites_chr, ptr_temp
    jsr decompress_tokumaru
    jsr ppu_init_rad_menu
.endif

    lda #128
    sta p1_dir


    lda #PPUCTRL_NMI_ON | PPUCTRL_8X16_SPR
    sta PPUCTRL
loop:
    lda nmi_counter
:
    cmp nmi_counter
    beq :-

    lda #0
    sta frame_ready

    jsr read_gamepads

    ;bankswitch_to update_menu
    ;jsr update_menu

    bankswitch_to clear_nt_buffer
    jsr clear_nt_buffer

    ;lda #PPUMASK_BG_ON | PPUMASK_GRAYSCALE | PPUMASK_EMPHASIZE_B | PPUMASK_NO_BG_CLIP
    ;ora #PPUMASK_SPR_ON | PPUMASK_NO_SPR_CLIP
    ;sta PPUMASK

    jsr p1_move
    ;lda #SPLITSCREEN_LEFT
    lda #0
    sta line_splitscreen
    jsr render
    ;lda #SPLITSCREEN_RIGHT
    ;sta line_splitscreen
    ;jsr render

    ;lda #PPUMASK_BG_ON | PPUMASK_GRAYSCALE | PPUMASK_EMPHASIZE_R | PPUMASK_NO_BG_CLIP
    ;ora #PPUMASK_SPR_ON | PPUMASK_NO_SPR_CLIP
    ;sta PPUMASK

    jsr prepare_game_sprites

    lda #1 
    sta frame_ready
    inc frame_number
    jmp loop

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
    .incbin "spr16.cchr"
    .incbin "rad.cchr"
menu_sprites_chr:
    .incbin "rad316.cchr"

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

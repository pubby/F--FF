.include "globals.inc"

.import ppu_set_palette
.import prepare_game_sprites
.import setup_cos, setup_sin
.importzp multiply_store
.import copy_multiply_code
.import p1_move, p2_move
.import render
.import draw_line

.export main, nmi_handler, irq_handler

.segment "CODE"

.proc nmi_handler
    pha
    stx nmi_x
    sty nmi_y

    lsr subframes_left
    bne :+ 
    lsr frame_ready
    bcs renderFrame
:

    ; Do OAM DMA and then read the controllers.
    lda #.hibyte(CPU_OAM)
    sta OAMDMA
    ldx #1
    stx p1_buttons_held    ; even odd even
    stx $4016          ; odd even odd even
    dex                ; odd even
    stx $4016          ; odd even odd even
readControllerLoop:
    lda $4017          ; odd even odd EVEN <- loop code must take an even number of cycles total
    lsr
    rol p2_buttons_held, x
    lda $4016          ; odd even odd EVEN
    lsr
    rol p1_buttons_held
    bcc readControllerLoop ; even odd [even]

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
    lda #PPUCTRL_NMI_ON
    sta PPUCTRL

    ; Restore registers and return.
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
    lda #0
    sta PPUCTRL
    sta PPUMASK
    sta frame_number
    sta subframes_left
    lda #1
    sta frame_ready

    bit PPUSTATUS
    jsr ppu_set_palette

    bit PPUSTATUS
.repeat 2, i
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

    jsr copy_multiply_code

    ; TODO
    lda #63;+128
    jsr setup_sin
    lda #.lobyte(-$2020)
    sta multiply_store
    lda #.hibyte(-$2020)
    jsr multiply
;:
    ;jmp :-


    bankswitch_to ppu_load_4x4_pixels_chr
    jsr ppu_load_4x4_pixels_chr

    lda #128
    sta p1_dir

    lda #PPUCTRL_NMI_ON
    sta PPUCTRL
loop:
    lda nmi_counter
:
    cmp nmi_counter
    beq :-

    bankswitch_to clear_nt_buffer
    jsr clear_nt_buffer

    lda #PPUMASK_BG_ON | PPUMASK_GRAYSCALE | PPUMASK_EMPHASIZE_B | PPUMASK_NO_BG_CLIP
    ora #PPUMASK_SPR_ON | PPUMASK_NO_SPR_CLIP
    ;sta PPUMASK

    jsr p1_move
    jsr render

.if 0
    bankswitch 0
    lda #129
    sta from_x+0
    sta from_y+0
    sta to_x+0
    lda #128
    sta to_y+0
    lda #0
    sta from_x+1
    sta from_y+1
    sta to_x+1
    sta to_y+1
    jsr draw_line
.endif

    lda #PPUMASK_BG_ON | PPUMASK_GRAYSCALE | PPUMASK_EMPHASIZE_R | PPUMASK_NO_BG_CLIP
    ora #PPUMASK_SPR_ON | PPUMASK_NO_SPR_CLIP
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


    ;.incbin "line.chr"
    ;.incbin "bullets.chr"

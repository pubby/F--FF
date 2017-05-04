.include "globals.inc"

.import random_byte
.import ppu_set_palette
.import draw_line3, draw_line5
.import prepare_game_sprites

.export main, nmi_handler, irq_handler

.segment "CODE"

.proc nmi_handler
    pha

    ; Do OAM DMA.
    lda #.hibyte(CPU_OAM)
    sta OAMDMA
    ldx #1             ; even odd          <- strobe code must take an odd number of cycles total
    stx p1_buttons_held    ; even odd even
    stx $4016          ; odd even odd even
    dex                ; odd even
    stx $4016          ; odd even odd even
readControllerLoop:
    lda $4017          ; odd even odd EVEN <- loop code must take an even number of cycles total
    and #3             ; odd even
    cmp #1             ; odd even
    rol p2_buttons_held, x ; odd even odd even odd even (X = 0; waste 1 cycle and 0 bytes for alignment)
    lda $4016          ; odd even odd EVEN
    and #3             ; odd even
    cmp #1             ; odd even
    rol p1_buttons_held    ; odd even odd even odd
    bcc readControllerLoop ; even odd [even]

    bit PPUSTATUS

    lda #$20
    sta PPUADDR
    lda #$00
    sta PPUADDR
    sta PPUMASK

    .repeat 704, i
        lda nt_buffer+i
        sta PPUDATA
    .endrepeat

    lda #0
    sta PPUSCROLL
    sta PPUSCROLL
    sta PPUADDR
    sta PPUADDR

    ;lda #PPUMASK_BG_ON | PPUMASK_GRAYSCALE | PPUMASK_EMPHASIZE_G | PPUMASK_NO_BG_CLIP
    ;ora #PPUMASK_SPR_ON | PPUMASK_NO_SPR_CLIP
    lda #PPUMASK_BG_ON | PPUMASK_NO_BG_CLIP| PPUMASK_SPR_ON | PPUMASK_NO_SPR_CLIP
    sta PPUMASK
    lda #PPUCTRL_NMI_ON
    sta PPUCTRL

    ; Restore registers and return.
    inc nmi_counter
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

    bit PPUSTATUS
    jsr ppu_set_palette

    lda #$82
    sta rng_state+0
    lda #$39
    sta rng_state+1

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

    bankswitch_to ppu_load_4x4_pixels_chr
    jsr ppu_load_4x4_pixels_chr


    lda #64
    sta from_x
    sta px
    lda #32
    sta from_y
    sta py

    lda #0
    sta from_x+1
    sta from_y+1
    sta px+1
    sta py+1


    lda #PPUCTRL_NMI_ON
    sta PPUCTRL
loop:
    lda nmi_counter
:
    cmp nmi_counter
    beq :-

    lda #0
    .repeat 704, i
        sta nt_buffer+i
    .endrepeat

    .repeat 1700
        nop
    .endrepeat

    lda p1_buttons_held
    and #BUTTON_LEFT
    beq :+
    sec
    lda px+0
    sbc #1
    sta px+0
    bcs :+
    dec px+1
:
    lda p1_buttons_held
    and #BUTTON_RIGHT
    beq :+
    clc
    lda px+0
    adc #1
    sta px+0
    bcc :+
    inc px+1
:
    lda p1_buttons_held
    and #BUTTON_UP
    beq :+
    sec
    lda py+0
    sbc #1
    sta py+0
    bcs :+
    dec py+1
:
    lda p1_buttons_held
    and #BUTTON_DOWN
    beq :+
    clc
    lda py+0
    adc #1
    sta py+0
    bcc :+
    inc py+1
:

    lda p2_buttons_held
    and #BUTTON_LEFT
    beq :+
    sec
    lda fx+0
    sbc #1
    sta fx+0
    bcs :+
    dec fx+1
:
    lda p2_buttons_held
    and #BUTTON_RIGHT
    beq :+
    clc
    lda fx+0
    adc #1
    sta fx+0
    bcc :+
    inc fx+1
:
    lda p2_buttons_held
    and #BUTTON_UP
    beq :+
    sec
    lda fy+0
    sbc #1
    sta fy+0
    bcs :+
    dec fy+1
:
    lda p2_buttons_held
    and #BUTTON_DOWN
    beq :+
    clc
    lda fy+0
    adc #1
    sta fy+0
    bcc :+
    inc fy+1
:

.repeat 2, i
    lda px+i
    sta to_x+i
    lda py+i
    sta to_y+i

    lda fx+i
    sta from_x+i
    lda fy+i
    sta from_y+i
.endrepeat

    lda #PPUMASK_BG_ON | PPUMASK_GRAYSCALE | PPUMASK_EMPHASIZE_B | PPUMASK_NO_BG_CLIP
    ora #PPUMASK_SPR_ON | PPUMASK_NO_SPR_CLIP
    sta PPUMASK

.repeat 1
    jsr draw_line5
.endrepeat

    lda #PPUMASK_BG_ON | PPUMASK_GRAYSCALE | PPUMASK_EMPHASIZE_R | PPUMASK_NO_BG_CLIP
    ora #PPUMASK_SPR_ON | PPUMASK_NO_SPR_CLIP
    sta PPUMASK

    jsr prepare_game_sprites

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

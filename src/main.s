.include "globals.inc"

.import random_byte
.import read_gamepad
.import ppu_set_palette
.import draw_line, draw_line2, draw_line3

.export main, nmi_handler, irq_handler

.segment "CODE"

.proc nmi_handler
    pha
    bit PPUSTATUS

    lda #$20
    sta PPUADDR
    lda #$00
    sta PPUADDR
    sta PPUMASK

    .repeat 720, i
        lda nt_buffer+i
        sta PPUDATA
    .endrepeat

    lda #0
    sta PPUSCROLL
    sta PPUSCROLL
    sta PPUADDR
    sta PPUADDR

    lda #PPUMASK_BG_ON
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

    lda #PPUCTRL_NMI_ON
    sta PPUCTRL
loop:
    lda nmi_counter
:
    cmp nmi_counter
    beq :-

    lda #0
    .repeat 720, i
        sta nt_buffer+i
    .endrepeat

    jsr read_gamepad

    lda #0
    sta from_x
    sta from_y

    lda #8
    sta to_x
    lda frame_number
    and #%00011111
    sta to_y

    lda #PPUMASK_BG_ON | PPUMASK_GRAYSCALE | PPUMASK_EMPHASIZE_B
    sta PPUMASK

.repeat 8
    jsr draw_line3
.endrepeat

    lda #PPUMASK_BG_ON | PPUMASK_GRAYSCALE | PPUMASK_EMPHASIZE_R
    sta PPUMASK

    inc frame_number
    jmp loop

.endproc

.segment "CHR"
    .incbin "line.chr"
    ;.incbin "bullets.chr"

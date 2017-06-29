.include "globals.inc"

.import setup_cos, setup_sin
.import setup_multiply
.importzp multiply_store

.export p1_move, p2_move

.segment "CODE"

.repeat 2, i
.proc P i, _move 
    ldy P i, _buttons_held       ; Keep buttons_held in Y.

    ; Left/Right: Change direction
    ldx P i, _dir
    tya
    and #BUTTON_LEFT
    beq notPressingLeft
    txa
    axs #2
notPressingLeft:
    tya
    and #BUTTON_RIGHT
    beq notPressingRight
    txa
    axs #.lobyte(-2)
notPressingRight:
    stx P i, _dir

    ; Up/Down: Move forwards/backwards
    tya
    and #BUTTON_UP
    beq notPressingUp

    lda P i, _dir
    jsr setup_cos
    lda #64
    sta multiply_store
    lda #0
    jsr multiply
    clc
    adc P i, _x
    sta P i, _x
    txa
    adc 1 + P i, _x
    sta 1 + P i, _x

    lda P i, _dir
    jsr setup_sin
    lda #64
    sta multiply_store
    lda #0
    jsr multiply
    clc
    adc P i, _y
    sta P i, _y
    txa
    adc 1 + P i, _y
    sta 1 + P i, _y
notPressingUp:

    ; Up/Down: Move forwards/backwards
    lda p1_buttons_held
    and #BUTTON_DOWN
    beq notPressingDown

    lda P i, _dir
    clc
    adc #128
    jsr setup_cos
    lda #64
    sta multiply_store
    lda #0
    jsr multiply
    clc
    adc P i, _x
    sta P i, _x
    txa
    adc 1 + P i, _x
    sta 1 + P i, _x

    lda P i, _dir
    clc
    adc #128
    jsr setup_sin
    lda #64
    sta multiply_store
    lda #0
    jsr multiply
    clc
    adc P i, _y
    sta P i, _y
    txa
    adc 1 + P i, _y
    sta 1 + P i, _y
notPressingDown:

    ; Check if we're ahead
    ;int a = to_signed(c.x - l[0].x) * to_signed(l[1].y - l[0].y);
    ;int b = to_signed(c.y - l[0].y) * to_signed(l[1].x - l[0].x);
    ;return a < b;

    ;int a = to_signed(c.x - lx) * to_signed(ry - ly);
    ;int b = to_signed(c.y - ly) * to_signed(rx - lx);

    result_lo = scratchpad + 0
    result_hi = scratchpad + 1

    ldy #0

    ; player_x - track_x
    sec
    lda 0+P i, _x
    sbc (lx_lo_ptr), y
    tax
    lda 1+P i, _x
    sbc (lx_hi_ptr), y
    jsr setup_multiply
    sec
    lda (ry_lo_ptr), y
    sbc (ly_lo_ptr), y
    sta multiply_store
    lda (ry_hi_ptr), y
    sbc (ly_hi_ptr), y
    jsr multiply
    sta result_lo
    stx result_hi

    sec
    lda 0+P i, _y
    sbc (ly_lo_ptr), y
    tax
    lda 1+P i, _y
    sbc (ly_hi_ptr), y
    jsr setup_multiply
    sec
    lda (rx_lo_ptr), y
    sbc (lx_lo_ptr), y
    sta multiply_store
    lda (rx_hi_ptr), y
    sbc (lx_hi_ptr), y
    jsr multiply

    sec
    sbc result_lo
    txa
    sbc result_hi
    bvc :+
    eor #$80
:
    bmi doneAdvanceTrack

    lda #$FF
    sta debug

    ldx lx_lo_ptr
    inx
    stx lx_lo_ptr
    stx lx_hi_ptr
    stx ly_lo_ptr
    stx ly_hi_ptr
    stx rx_lo_ptr
    stx rx_hi_ptr
    stx ry_lo_ptr
    stx ry_hi_ptr



    rts
doneAdvanceTrack:
    lda #$00
    sta debug
    rts
.endproc
.endrepeat


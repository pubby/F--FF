.include "globals.inc"

.import setup_cos, setup_sin
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
    axs #.lobyte(-1)
notPressingLeft:
    tya
    and #BUTTON_RIGHT
    beq notPressingRight
    txa
    axs #1
notPressingRight:
    stx P i, _dir

    ; Up/Down: Move forwards/backwards
    tya
    and #BUTTON_UP
    beq notPressingUp

    lda P i, _dir
    jsr setup_cos
    lda #32
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
    lda #32
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
    lda #32
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
    lda #32
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

    rts
.endproc
.endrepeat


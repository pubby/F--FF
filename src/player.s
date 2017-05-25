.include "globals.inc"

.export p1_move, p2_move

.segment "CODE"

.repeat 2, i
.proc P i, move 
    ldy P i, buttons_held       ; Keep buttons_held in Y.

    ; Left/Right: Change direction
    ldx P i, dir
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
    stx P i, dir

    ; Up/Down: Move forwards/backwards
    tya
    and #BUTTON_UP
    beq notPressingUp
    inc P i, speed
notPressingUp:

    ; Up/Down: Move forwards/backwards
    tya
    and #BUTTON_DOWN
    beq notPressingDown
    dec P i, speed
notPressingDown:

    rts
.endproc
.endrepeat


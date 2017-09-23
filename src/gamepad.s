.include "globals.inc"

.export read_gamepads

.segment "CODE"
; Sets button flags of 'buttons_held' and 'buttons_pressed'.
; Clobbers A, X, Y.
.proc read_gamepads
    ldx p1_buttons_held
    ldy #1
    sty p1_buttons_held
    sty $4016
    dey
    sty $4016
    ldy p2_buttons_pressed
readControllerLoop:
    lda $4017
    lsr
    rol p2_buttons_held
    lda $4016
    lsr
    rol p1_buttons_held
    bcc readControllerLoop

    txa
    eor #$FF
    and p1_buttons_held
    sta p1_buttons_pressed

    tya
    eor #$FF
    and p2_buttons_held
    sta p2_buttons_pressed
    rts
.endproc



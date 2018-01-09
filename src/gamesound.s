.include "globals.inc"

.export init_game_sound
.export process_game_sound

.segment "CODE"

gs_temp = gs_zp+0
ticker = gs_zp+1 ; 2 bytes

.proc init_game_sound
    lda #%00001000
    sta $4001
    sta $4005

    lda #%00001111
    sta $4015

    ldx #%11110000
    stx $4008
    stx $400C
    stx $400F

    rts
.endproc

vol_table:
    .byt 2, 4, 6, 8, 10, 12, 14, 16
    .byt 16, 14, 12, 10, 8, 6, 4, 2

.proc process_game_sound
    lda $BFFF ; current bank
    pha
    bankswitch 1
    jsr process_game_sound_impl
    pla
    tay
    bankswitch_y
    rts
.endproc

.segment "B1_CODE"

.proc process_game_sound_impl
.repeat 2, i
    lda needs_completion
    and #i+1
    bne :+
    jmp @nextThing
:

    clc
    lda P i, _speed
    adc P i, _boost
    sec
    sbc P i, _slowdown
    beq @zero
    bcs @carrySet
@zero:
    jmp @nextThing
@carrySet:
    sta gs_temp
    clc
    adc ticker+0
    sta ticker+0
    bcc :+
    inc ticker+1
    inc ticker+1
:

    lda #$FF
    sec
    sbc gs_temp
    lsr
    lsr
    alr #%00111100
    adc #32
    ldx P i, _jump
    sec
    sbc ship_jump_table, x
    lsr
    alr #%00011110
    tax
    lda P i, _boost_timer
    asl
    bne :+
    inx
:
    lda P i, _buttons_held
    and #BUTTON_LEFT | BUTTON_RIGHT
    bne :+
    inx
    ;bpl :+
    ;ldx #0
:
    txa
    ldx P i, _boost_timer
    bmi :+
    ora #%10001000
:
    sta $400E

    lda ticker+1
    lsr
    lsr
    and #%00000011
    ora #%00001000
    ldx P i, _boost_timer
    bmi :+
    eor ticker+1
    anc #%00001111
    ora #%00000100
    adc #3
:
    ldx P i, _jump
    beq :+
    ora #%00000010
    clc
    adc #3
:
    tax
    lda P i, _boost_timer
    asl
    beq :+
    inx
    inx
:
    lda P i, _buttons_held
    and #BUTTON_LEFT | BUTTON_RIGHT
    beq :+
    inx
:

    cpx #16
    bcc :+
    ldx #15
:
    txa

    sec
    sbc #5
bcs :+
    lda #0
:
    ora #%00110000
    sta $400C
    rts
@nextThing:
.if i = 0
    foo:
.endif
.endrepeat
    lda #%00110000
    sta $400C
    rts
.endproc

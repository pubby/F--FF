.include "globals.inc"

.export init_game_sound
.export process_game_sound

.segment "CODE"

gs_temp = penguin_zp+0
ticker = penguin_zp+1 ; 2 bytes

.proc init_game_sound
    lda #%00001000
    sta $4001
    sta $4005

    lda #%00001000
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

.if 0
.proc process_game_sound
.repeat 1, i
    clc
    lda P i, _speed
    adc P i, _boost
    sec
    sbc P i, _slowdown
    bcs :+
    lda #0
:
    sta gs_temp
.endrepeat
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
    ldx #0
    stx gs_temp
    asl
    rol gs_temp
    asl
    rol gs_temp
    asl
    sta $4002
    lda gs_temp
    rol
    cmp sq1_hi
    beq :+
    sta $4003
    sta sq1_hi
:

    lda ticker+1
    and #%00000111
    ldx p1_jump
    beq :+
    ora #%00000100
:
    tax
    lda vol_table, x
    ldx p1_boost_timer
    bpl :+
    ora #%10110000
    jmp :++
:
    ora #%01110000
:
    sta $4000

    rts
.endproc
.else
.proc process_game_sound
.repeat 1, i
    clc
    lda P i, _speed
    adc P i, _boost
    sec
    sbc P i, _slowdown
    bcs :+
    lda #0
:
    sta gs_temp
.endrepeat
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
    ldx p1_jump
    sec
    sbc ship_jump_table, x
    lsr
    alr #%00011110
    tax
    lda p1_boost_timer
    asl
    bne :+
    inx
:
    lda p1_buttons_held
    and #BUTTON_LEFT | BUTTON_RIGHT
    bne :+
    inx
    ;bpl :+
    ;ldx #0
:
    txa
    ldx p1_boost_timer
    bmi :+
    ora #%10001000
:
    sta $400E

    lda ticker+1
    lsr
    lsr
    and #%00000011
    ora #%00001000
    ldx p1_boost_timer
    bmi :+
    eor ticker+1
    anc #%00001111
    ora #%00000100
    adc #3
:
    ldx p1_jump
    beq :+
    ora #%00000010
    clc
    adc #3
:
    tax
    lda p1_boost_timer
    asl
    beq :+
    inx
    inx
:
    lda p1_buttons_held
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
.endproc
.endif

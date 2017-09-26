.include "globals.inc"

.import setup_cos, setup_sin
.import setup_multiply
.importzp multiply_store

.export p1_move, p2_move

.segment "CODE"

PSPEED = 128*3/2
PTURN = 3*3/2

dir_accel_table_left:
.repeat 8, i
    .byt .lobyte((20*i)-1)
.endrepeat
dir_accel_table_right:
.repeat 8, i
    .byt (20*i)
.endrepeat

.repeat 2, i
.proc P i, _move 
    ;ldy frames_since_movement_update
    ;bne :+
    ;rts
;:
    ;cpy #8
    ;bcc :+
    ;ldy #8
;:

    ; Left/Right: Change direction
    lax P i, _buttons_held
    anc #BUTTON_LEFT | BUTTON_RIGHT
    bne checkLeft
    ; TODO
    lda P i, _dir_speed
    cmp #$80
    ;arr #$FF
    ror
    sta P i, _dir_speed
    jmp doneLeftRight
checkLeft:
    anc #BUTTON_LEFT    ; Clears carry
    beq notPressingLeft
    lda P i, _dir_speed
    ;sbc dir_accel_table_left, y
    sbc #50-1
    bvs :+
    sta P i, _dir_speed
:
notPressingLeft:
    txa                 ; X = buttons_held
    anc #BUTTON_RIGHT   ; Clears carry
    beq notPressingRight
    lda P i, _dir_speed
    adc #50
    bvs :+
    sta P i, _dir_speed
:
notPressingRight:
doneLeftRight:

    ; A: Turn (debug)
    ldy p1_lift
    txa                 ; X = buttons_held
    and #BUTTON_A
    bne pressingA
    iny
    cpy #7
    bcc storeLift
    ldy #7
    jmp storeLift
pressingA:
    dey
    cpy #4
    bcs storeLift
    ldy #4
storeLift:
    sty p1_lift


    ; B: Accelerate
    txa                 ; X = buttons_held
    anc #BUTTON_B       ; Clears carry
    beq notPressingB
    lda P i, _speed
    adc #4
    cmp #140
    bcc storeSpeed
    jmp doneAccelerate
notPressingB:
    ; De-accelerate
    lda P i, _speed
    sbc #3
    bcs storeSpeed
    lda #0
storeSpeed:
    sta P i, _speed
doneAccelerate:

    ; Apply dir_speed to dir
    ldx #0
    lda P i, _dir_speed ; set N flag for setup_multiply
    clv                 ; set V flag for setup_multiply
    jsr setup_multiply

    lda P i, _speed
    sta multiply_store
    ldx #0
    jsr multiply+1
    stx subroutine_temp
    .repeat 4
        asl
        rol subroutine_temp
    .endrepeat
    clc
    adc 0+P i, _dir
    sta 0+P i, _dir
    lda subroutine_temp
    adc 1+P i, _dir
    sta 1+P i, _dir

    ; Apply speed
    lda 1+P i, _dir
    jsr setup_cos
    lda P i, _speed
    sta multiply_store
    ldx #0
    jsr multiply+1
    clc
    adc P i, _x
    sta P i, _x
    txa
    adc 1 + P i, _x
    sta 1 + P i, _x

    lda 1+P i, _dir
    jsr setup_sin
    lda P i, _speed
    sta multiply_store
    lda #0
    jsr multiply
    clc
    adc P i, _y
    sta P i, _y
    txa
    adc 1 + P i, _y
    sta 1 + P i, _y


    ;lda P i, _buttons_held
    ;and #BUTTON_A
    ;beq :+
    ;inc camera_height
    ;inc camera_height
;:

    ;lda P i, _buttons_held
    ;and #BUTTON_B
    ;beq :+
    ;dec camera_height
    ;dec camera_height
;:

    ; Check if we're ahead
    ;int a = to_signed(c.x - l[0].x) * to_signed(l[1].y - l[0].y);
    ;int b = to_signed(c.y - l[0].y) * to_signed(l[1].x - l[0].x);
    ;return a < b;

    ;int a = to_signed(c.x - lx) * to_signed(ry - ly);
    ;int b = to_signed(c.y - ly) * to_signed(rx - lx);

    front_edge_result_lo = scratchpad + 0
    front_edge_result_hi = scratchpad + 1
    left_edge_result_lo = scratchpad + 2
    left_edge_result_hi = scratchpad + 3

    ; Front railing (and set up multiply for left railing)
    ldy #1
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
    sta front_edge_result_lo
    stx front_edge_result_hi

    ; Left railing
    ldy #128
    lda (ly_lo_ptr), y  ; (ly[1] - ly[0]) is stored in Y=128
    sta multiply_store
    lda (ly_hi_ptr), y
    jsr multiply
    sta left_edge_result_lo
    stx left_edge_result_hi

    ; Front railing
    ldy #1
    sec
    lda 0+P i, _y
    sbc (ly_lo_ptr), y
    tax
    lda 1+P i, _y
    sbc (ly_hi_ptr), y
    jsr setup_multiply

    ; Left railing
    ldy #128
    lda (lx_lo_ptr), y  ; (lx[1] - lx[0]) is stored in Y=128
    sta multiply_store
    lax (lx_hi_ptr), y
    jsr multiply+1      ; +1 to skip TAX
    cmp left_edge_result_lo
    txa
    sbc left_edge_result_hi
    bvc :+
    eor #$80
:
    bpl doneOutsideLeftRailing

    lda #1
    ;sta debug
    jmp poop
doneOutsideLeftRailing:
    lda #0
    ;sta debug
poop:

    ; Front railing
    ldy #1
    sec
    lda (rx_lo_ptr), y
    sbc (lx_lo_ptr), y
    sta multiply_store
    lda (rx_hi_ptr), y
    sbc (lx_hi_ptr), y
    jsr multiply
    cmp front_edge_result_lo
    txa
    sbc front_edge_result_hi
    bvc :+
    eor #$80
:
    bpl doneOutsideFrontRailing

    ; Increment the level pointers.
    ldx lx_lo_ptr
    inx
    cpx level_length
    bcc :+
    ldx #0
:
    stx lx_lo_ptr
    stx lx_hi_ptr
    stx ly_lo_ptr
    stx ly_hi_ptr
    stx rx_lo_ptr
    stx rx_hi_ptr
    stx ry_lo_ptr
    stx ry_hi_ptr
doneOutsideFrontRailing:

    rts
.endproc
.endrepeat


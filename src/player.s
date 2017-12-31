.include "globals.inc"

.import setup_cos, setup_sin
.import setup_multiply
.importzp multiply_store

.export p1_move, p2_move
.export p1_solo_move

.segment "CODE"

dir_accel_table_left:
.repeat 8, i
    .byt .lobyte((20*i)-1)
.endrepeat
dir_accel_table_right:
.repeat 8, i
    .byt (20*i)
.endrepeat

.macro handle_move i, mul, div
    ; Left/Right: Change direction
    lax P i, _buttons_held
    ldy P i, _pre_explosion
    bne doneLeftRight
    and #BUTTON_LEFT | BUTTON_RIGHT
    bne checkLeft
applyDirSlowdown:
    lda P i, _dir_speed
    bmi :+
    sec
    sbc #32*mul/div
    bpl @store
    bmi @load0
:
    clc
    adc #32*mul/div
    bmi @store
@load0:
    lda #0
@store:
    sta P i, _dir_speed
    jmp doneLeftRight
checkLeft:
    anc #BUTTON_LEFT    ; Clears carry
    beq notPressingLeft
    lda P i, _dir_speed
    sbc #12*mul/div-1
    bvs @cap
    bpl @store
    cmp #.lobyte(-56*mul/div)
    bcs @store
@cap:
    lda #.lobyte(-56*mul/div)
@store:
    sta P i, _dir_speed
    dec 1+P i, _dir
notPressingLeft:
    txa                 ; X = buttons_held
    anc #BUTTON_RIGHT   ; Clears carry
    beq notPressingRight
    lda P i, _dir_speed
    adc #12*mul/div
    bvs @cap
    bmi @store
    cmp #.lobyte(56*mul/div)
    bcc @store
@cap:
    lda #.lobyte(56*mul/div)
@store:
    sta P i, _dir_speed
    inc 1+P i, _dir
notPressingRight:
doneLeftRight:

    ; A: Boost
    lda P i, _pre_explosion
    bne notBoosting
    lda P i, _buttons_pressed
    asl                 ; Test for button A
    bcc notPressingA
    lda P i, _boost_tank
    sbc #20
    bcc notBoosting
    beq notBoosting
    sta P i, _boost_tank
    lda P i, _boost_timer
    and #%10000000
    ora #21*2/3
    sta P i, _boost_timer
notBoosting:
notPressingA:

    ; B: Accelerate
    lda P i, _pre_explosion
    bne doneAccelerate
    txa                 ; X = buttons_held
    anc #BUTTON_B       ; Clears carry
    beq notPressingB
    lda P i, _speed
    adc #4*mul/div
    cmp #120*mul/div
    bcc storeSpeed
    lda #120*mul/div
    jmp storeSpeed
notPressingB:
    ; De-accelerate
    lda P i, _speed
    sbc #4*mul/div
    bcs storeSpeed
    lda #0
storeSpeed:
    sta P i, _speed
doneAccelerate:

    ; Slowdown
    lax P i, _boost_timer
    asl
    bcc addSlowdown
reduceSlowdown:
    lda P i, _slowdown
    sbc #4*mul/div
    bcs storeSlowdown
    lda #0
    beq storeSlowdown   ; Guaranteed branch
addSlowdown:
    lda P i, _slowdown
    adc #2*mul/div
    cmp #16*mul/div
    bcc storeSlowdown
    lda #16*mul/div
storeSlowdown:
    sta P i, _slowdown

    ; Boost
    txa                 ; X = _boost_timer
    anc #%01111111      ; Clears carry
    bne boost
    lda palette_buffer+18+4*i
    and #$10 ^ $FF
    sta palette_buffer+18+4*i
    lda P i, _boost
    sec
    sbc #2*mul/div
    bcs storeBoost
    lda #0
    beq storeBoost      ; Guaranteed branch
boost:
    lda palette_buffer+18+4*i
    eor #$10
    sta palette_buffer+18+4*i
    dec P i, _boost_timer
    lda P i, _boost
    adc #12*mul/div
    cmp #48*mul/div
    bcc storeBoost
    lda #48*mul/div
storeBoost:
    sta P i, _boost
doneBoost:

    lax P i, _jump
    axs #2*mul/div
    bcs :+
    ldx #0
:
    stx P i, _jump

.endmacro

explosion_palette_table:
    .byt $15, $30, $25, $15, $0F

.repeat 2, i
.proc P i, _handle_explosion
    lda frame_number
    and #1
    beq :+
    inx
:
    cpx #5
    bcs doneExplosion
    stx P i, _explosion
    lda explosion_palette_table, x
    sta palette_buffer+16
    rts
doneExplosion:
    lda #(i+1) ^ $FF
    and needs_completion
    sta needs_completion
    rts
.endproc

.proc P i, _move 
    front_edge_result_lo = scratchpad + 0
    front_edge_result_hi = scratchpad + 1
    back_edge_result_lo = scratchpad + 0
    back_edge_result_hi = scratchpad + 1
    left_edge_result_lo = scratchpad + 2
    left_edge_result_hi = scratchpad + 3
    right_edge_result_lo = scratchpad + 2
    right_edge_result_hi = scratchpad + 3
    oob = scratchpad+4

    lda P i, _pre_explosion
    beq :+
    dec P i, _pre_explosion
    bne :+
    inc P i, _explosion
:
    ldx P i, _explosion
    bne P i, _handle_explosion

    lda needs_completion
    and #i+1
    bne :+
    jmp entrance
:

    handle_move i, 3, 2

entrance:

    ; lift
    ldy P i, _lift
    lda P i, _boost_timer
    bmi liftUp
    lda frame_number
    and #%00000011
    bne liftUp
    dey 
    dey 
    cpy #4
    bcs storeLift
    ldy #4
    jmp storeLift
liftUp:
    iny
    cpy #7
    bcc storeLift
    ldy #7
storeLift:
    sty P i, _lift


    ; Apply dir_speed to dir
    ldx #0
    lda P i, _dir_speed ; set N flag for setup_multiply
    clv                 ; set V flag for setup_multiply
    jsr setup_multiply
    clc
    lda P i, _speed
    adc P i, _boost
    sec
    sbc P i, _slowdown
    bcs :+
    lda #0
:
    sta multiply_store
    ldx #0
    jsr multiply+1
    stx subroutine_temp
    .repeat 3
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
    ldx #0
    jsr multiply+1
    clc
    adc P i, _y
    sta P i, _y
    txa
    adc 1 + P i, _y
    sta 1 + P i, _y

    ; Check if we're ahead
    ;int a = to_signed(c.x - l[0].x) * to_signed(l[1].y - l[0].y);
    ;int b = to_signed(c.y - l[0].y) * to_signed(l[1].x - l[0].x);
    ;return a < b;

    ;int a = to_signed(c.x - lx) * to_signed(ry - ly);
    ;int b = to_signed(c.y - ly) * to_signed(rx - lx);


    ; Levels are in bank 2
    bankswitch 2

    lda P i, _track_index
    sta lx_lo_ptr
    sta ly_lo_ptr
    sta rx_lo_ptr
    sta ry_lo_ptr
    ora #128
    sta lx_hi_ptr
    sta ly_hi_ptr
    sta rx_hi_ptr
    sta ry_hi_ptr
    asl
    asl tf_ptr
    ror
    sta tf_ptr

    lda #0
    sta oob

    ; Back railing (and set up multiply for right railing)
    tay                 ; Y = 0
    sec
    lda 0+P i, _x
    sbc (rx_lo_ptr), y
    tax
    lda 1+P i, _x
    sbc (rx_hi_ptr), y
    jsr setup_multiply
    sec
    lda (ly_lo_ptr), y
    sbc (ry_lo_ptr), y
    sta multiply_store
    lda (ly_hi_ptr), y
    sbc (ry_hi_ptr), y
    jsr multiply
    sta back_edge_result_lo
    stx back_edge_result_hi

    ; Right railing
    sec
    lda (ry_lo_ptr), y
    iny                 ; Y = 1
    sbc (ry_lo_ptr), y
    sta multiply_store
    dey                 ; Y = 0
    lda (ry_hi_ptr), y
    iny                 ; Y = 1
    sbc (ry_hi_ptr), y
    jsr multiply
    sta right_edge_result_lo
    stx right_edge_result_hi

    ; Back railing
    dey                 ; Y = 0
    sec
    lda 0+P i, _y
    sbc (ry_lo_ptr), y
    tax
    lda 1+P i, _y
    sbc (ry_hi_ptr), y
    jsr setup_multiply

    ; Right railing
    sec
    lda (rx_lo_ptr), y
    iny                 ; Y = 1
    sbc (rx_lo_ptr), y
    sta multiply_store
    dey                 ; Y = 0
    lda (rx_hi_ptr), y
    iny                 ; Y = 1
    sbc (rx_hi_ptr), y
    jsr multiply
    cmp right_edge_result_lo
    txa
    sbc right_edge_result_hi
    bvc :+
    eor #$80
:
    ora oob
    sta oob

    ; Back railing
    dey                 ; Y = 0
    sec
    lda (lx_lo_ptr), y
    sbc (rx_lo_ptr), y
    sta multiply_store
    lda (lx_hi_ptr), y
    sbc (rx_hi_ptr), y
    jsr multiply
    cmp back_edge_result_lo
    txa
    sbc back_edge_result_hi
    bvc :+
    eor #$80
:
    ora oob
    sta oob

    ; Front railing (and set up multiply for left railing)
    iny                 ; Y = 1
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
    sec
    lda (ly_lo_ptr), y
    dey                 ; Y = 0
    sbc (ly_lo_ptr), y
    sta multiply_store
    iny                 ; Y = 1
    lda (ly_hi_ptr), y
    dey                 ; Y = 0
    sbc (ly_hi_ptr), y
    jsr multiply
    sta left_edge_result_lo
    stx left_edge_result_hi

    ; Front railing
    iny                 ; Y = 1
    sec
    lda 0+P i, _y
    sbc (ly_lo_ptr), y
    tax
    lda 1+P i, _y
    sbc (ly_hi_ptr), y
    jsr setup_multiply

    ; Left railing (lx[1] - lx[0])
    sec
    lda (lx_lo_ptr), y
    dey                 ; Y = 0
    sbc (lx_lo_ptr), y
    sta multiply_store
    iny                 ; Y = 1
    lda (lx_hi_ptr), y
    dey                 ; Y = 0
    sbc (lx_hi_ptr), y
    jsr multiply
    cmp left_edge_result_lo
    txa
    sbc left_edge_result_hi
    bvc :+
    eor #$80
:
    ora oob
    sta oob

    ; Front railing
    iny                 ; Y = 1
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

    ; Initiate jump
    lda P i, _pre_explosion
    bne doneJump
    lda oob
    bmi doneJump
    bankswitch 0 ; level flags in bank 0
    lda (tf_ptr), y
    and #TF_JUMP
    beq doneJump
    lda #60-6
    sta P i, _jump
doneJump:
    bankswitch 2

    ; Increment the level pointers.
    ldx P i, _track_index
    inx
    cpx level_length
    bcc :+
    lda #30 ; TODO
    sta P i, _text_timer
    ; Save the lap time
    lax P i, _lap
    .if i > 0
        axs #.lobyte(-4)
    .endif
    lda time_sub
    sta lap_time_sub, x
    .repeat 4, k
        lda time_digits+k
        sta LAPTIME k, x
    .endrepeat
    inc P i, _lap
    ldx #0
:
    stx P i, _track_index
    lda P i, _lap
    cmp #3
    bcc doneOutsideFrontRailing
    ; Handle completion
    lda #(i+1) ^ $FF
    and needs_completion
    sta needs_completion
doneOutsideFrontRailing:

    lda P i, _pre_explosion
    bne doneBounds
    lda P i, _jump
    bne inBounds
    ldy #0
    bankswitch_y ; level flags in bank 0
    lda (tf_ptr), y
    and #TF_JUMP | TF_BLANK
    bne outOfBounds
    lda oob
    bpl inBounds
outOfBounds:
    lda P i, _boost_timer
    and #%01111111
    sta P i, _boost_timer

    lda needs_completion
    and #i+1
    beq notDead

    sec
    lda P i, _boost_tank_sub
    ldy two_player
    beq :+
    sbc #128
:
    sta P i, _boost_tank_sub
    lda P i, _boost_tank
    sbc #1
    bcs :+
    lda #0
:
    sta P i, _boost_tank
    bne notDead
    lda #25
    sta P i, _pre_explosion
notDead:
doneBounds:
    rts
inBounds:
    lda P i, _boost_timer
    ora #%10000000
    sta P i, _boost_timer

    clc
    lda #128
    ldy two_player
    beq :+
    lda #128*3/2
:
    adc P i, _boost_tank_sub
    sta P i, _boost_tank_sub
    lda P i, _boost_tank
    adc #0
    cmp #64
    bcc :+
    lda #64
:
    sta P i, _boost_tank
doneRegen:
    rts
.endproc

.endrepeat

.proc p1_solo_move
    lda p1_pre_explosion
    beq :+
    dec p1_pre_explosion
    bne :+
    inc p1_explosion
:
    ldx p1_explosion
    beq :+
    jmp p1_handle_explosion
:

    lda needs_completion
    and #1
    bne :+
    jmp p1_move::entrance
:

    handle_move 0, 2, 2
    jmp p1_move::entrance
.endproc 


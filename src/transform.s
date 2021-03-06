.include "globals.inc"
.include "intercept.inc"

.import draw_line
.import setup_cos, setup_sin
.importzp multiply_store
.import setup_depth
.import clip_from_y_top_sub
.import clip_from_y_top_add
.import clip_to_y_top_sub
.import clip_to_y_top_add
.import OAM_OPP

.export p1_render, p2_render

SPR_NT = 1
.define PATTERN(i) ((i) * 2 + SPR_NT)

.segment "CODE"

.macro wall_line nth, offset
from:
.if nth
    jmp doneReuse
    ; Reuse previous calculations.
    lda depthpad_lx_lo+offset, y
    sta from_x+0
    lda depthpad_lx_hi+offset, y
    sta from_x+1 
    lda depthpad_ly_lo+offset, y
    sta from_y+0
    lda depthpad_ly_hi+offset, y
    sta from_y+1
    jmp to
.endif
doneReuse:
    lda scratchpad_lx_lo+offset, y
    sta from_x+0
    lda scratchpad_lx_hi+offset, y
    sta from_x+1 
    ldx scratchpad_ly_lo+offset, y     ; Keep in X for later.
    stx from_y+0
    lda scratchpad_ly_hi+offset, y
    sta from_y+1
    bne :+
    jmp @zeroHi
:
    bmi @negative
    jmp @positive
@negative:
    ldx scratchpad_ly_hi+1+offset, y   ; Check if entire line is behind camera.
    bpl :+
    jmp cull                           ; Cull line.
:
    ; Clip line so Y=0.
    ; Find Dy
    sec
    lda scratchpad_ly_lo+1+offset, y
    sbc from_y+0
    sta Dy+0
    txa                 ; X = ly_hi+1
    sbc from_y+1
    sta Dy+1

    ldx #0              ; Keep 0 in X for later.
    stx from_x_sub
    stx from_y_sub
    stx Dx_sub
    stx Dy_sub

    ; Find Dx
    sec
    lda scratchpad_lx_lo+1+offset, y
    sbc from_x+0
    sta Dx+0
    lda scratchpad_lx_hi+1+offset, y
    sbc from_x+1
    sta Dx+1
    bvc :+
    eor #$80
:
    bmi :+
    jmp @posDx
:
    sec
    txa                 ; X = 0
    sbc Dx+0
    sta Dx+0
    txa                 ; X = 0
    sbc Dx+1
    sta Dx+1
    ; Neg Dx
    jsr clip_from_y_top_sub
    jmp @doneCalcIntercept
@posDx:
    jsr clip_from_y_top_add
@doneCalcIntercept:
    ldy y_temp
    ldx #0
    stx from_y+1
    stx from_y+0
@zeroHi:
    ; ly_lo (from_y+0) in X.
    bankswitch_to recip_asl_table
    lda recip_asl_table, x
    sta multiply_label jump_pos, 1
    clc
    adc #.lobyte(negative_asl - positive_asl)
    sta multiply_label jump_neg, 1
    lda #$80            ; SKB
    .byt $0C            ; IGN to skip next LDA.
@positive:
    lda #$60            ; RTS
    sta multiply_label r2, 0

    bankswitch_to recip_asl_table
    jsr multiply_from
    bankswitch_to draw_line
to:
    lda scratchpad_lx_lo+1+offset, y
    sta to_x+0
    lda scratchpad_lx_hi+1+offset, y
    sta to_x+1 
    ldx scratchpad_ly_lo+1+offset, y   ; Keep in X for later.
    stx to_y+0
    lda scratchpad_ly_hi+1+offset, y
    sta to_y+1
    bne :+
    jmp @zeroHi
:
    bmi @negative
    jmp @positive
@negative:
    ; Clip line so Y=0.
    ; Find Dy
    sec
    lda scratchpad_ly_lo+offset, y
    sbc to_y+0
    sta Dy+0
    lda scratchpad_ly_hi+offset, y
    sbc to_y+1
    sta Dy+1

    ldx #0              ; Keep 0 in X for later.
    stx to_x_sub
    stx to_y_sub
    stx Dx_sub
    stx Dy_sub

    ; Find Dx
    sec
    lda scratchpad_lx_lo+offset, y
    sbc to_x+0
    sta Dx+0
    lda scratchpad_lx_hi+offset, y
    sbc to_x+1
    sta Dx+1
    bvc :+
    eor #$80
:
    bmi :+
    jmp @posDx
:
    sec
    txa                 ; X = 0
    sbc Dx+0
    sta Dx+0
    txa                 ; X = 0
    sbc Dx+1
    sta Dx+1
    ; Neg Dx
    jsr clip_to_y_top_sub
    jmp @doneCalcIntercept
@posDx:
    jsr clip_to_y_top_add
@doneCalcIntercept:
    ldy y_temp
    ldx #0
    stx to_y+1
    stx to_y+0
@zeroHi:
    ; ly_lo (to_y+0) in X.
    bankswitch_to recip_asl_table
    lda recip_asl_table, x
    sta multiply_label jump_pos, 1
    clc
    adc #.lobyte(negative_asl - positive_asl)
    sta multiply_label jump_neg, 1
    lda #$80            ; SKB
    .byt $0C            ; IGN to skip next LDA.
@positive:
    lda #$60            ; RTS
    sta multiply_label r2, 0

    bankswitch_to recip_asl_table
    jsr multiply_to
    bankswitch_to draw_line

    lda to_x+0
    sta depthpad_lx_lo+1+offset, y
    lda to_x+1
    sta depthpad_lx_hi+1+offset, y
    lda to_y+0
    sta depthpad_ly_lo+1+offset, y
    lda to_y+1
    sta depthpad_ly_hi+1+offset, y
    lda (tf_ptr), y
    and #TF_BLANK | TF_JUMP
    bne cull
    jsr draw_line
cull:
    ldy y_temp
.endmacro

.macro floor_line
from:
    lda scratchpad_ly_hi, y
    bmi @doneReuse
    lda depthpad_lx_lo, y
    sta from_x+0
    lda depthpad_lx_hi, y
    sta from_x+1 
    lda depthpad_ly_lo, y
    sta from_y+0
    lda depthpad_ly_hi, y
    sta from_y+1
    jmp to
@doneReuse:
    lda scratchpad_lx_lo, y
    sta from_x+0
    lda scratchpad_lx_hi, y
    sta from_x+1 
    ldx scratchpad_ly_lo, y     ; Keep in X for later.
    stx from_y+0
    lda scratchpad_ly_hi, y
    sta from_y+1
    bne :+
    jmp @zeroHi
:
    bmi @negative
    jmp @positive
@negative:
    ldx scratchpad_ry_hi, y   ; Check if entire line is behind camera.
    bpl :+
    jmp cull                         ; Cull line.
:
    ; Clip line so Y=0.
    ; Find Dy
    sec
    lda scratchpad_ry_lo, y
    sbc from_y+0
    sta Dy+0
    txa                 ; X = ly_hi+1
    sbc from_y+1
    sta Dy+1

    ldx #0              ; Keep 0 in X for later.
    stx from_x_sub
    stx from_y_sub
    stx Dx_sub
    stx Dy_sub

    ; Find Dx
    sec
    lda scratchpad_rx_lo, y
    sbc from_x+0
    sta Dx+0
    lda scratchpad_rx_hi, y
    sbc from_x+1
    sta Dx+1
    bvc :+
    eor #$80
:
    bmi :+
    jmp @posDx
:
    sec
    txa                 ; X = 0
    sbc Dx+0
    sta Dx+0
    txa                 ; X = 0
    sbc Dx+1
    sta Dx+1
    ; Neg Dx
    jsr clip_from_y_top_sub
    jmp @doneCalcIntercept
@posDx:
    jsr clip_from_y_top_add
@doneCalcIntercept:
    ldy y_temp
    ldx #0
    stx from_y+1
    stx from_y+0
@zeroHi:
    ; ly_lo (from_y+0) in X.
    bankswitch_to recip_asl_table
    lda recip_asl_table, x
    sta multiply_label jump_pos, 1
    clc
    adc #.lobyte(negative_asl - positive_asl)
    sta multiply_label jump_neg, 1
    lda #$80            ; SKB
    .byt $0C            ; IGN to skip next LDA.
@positive:
    lda #$60            ; RTS
    sta multiply_label r2, 0

    bankswitch_to recip_asl_table
    jsr multiply_from
    bankswitch_to draw_line
to:
    lda scratchpad_ry_hi, y
    bmi @doneReuse
    lda depthpad_rx_lo, y
    sta to_x+0
    lda depthpad_rx_hi, y
    sta to_x+1 
    lda depthpad_ry_lo, y
    sta to_y+0
    lda depthpad_ry_hi, y
    sta to_y+1
    jmp draw
@doneReuse:
    lda scratchpad_rx_lo, y
    sta to_x+0
    lda scratchpad_rx_hi, y
    sta to_x+1 
    ldx scratchpad_ry_lo, y   ; Keep in X for later.
    stx to_y+0
    lda scratchpad_ry_hi, y
    sta to_y+1
    bne :+
    jmp @zeroHi
:
    bmi @negative
    jmp @positive
@negative:
    ; Clip line so Y=0.
    ; Find Dy
    sec
    lda scratchpad_ly_lo, y
    sbc to_y+0
    sta Dy+0
    lda scratchpad_ly_hi, y
    sbc to_y+1
    sta Dy+1

    ldx #0              ; Keep 0 in X for later.
    stx to_x_sub
    stx to_y_sub
    stx Dx_sub
    stx Dy_sub

    ; Find Dx
    sec
    lda scratchpad_lx_lo, y
    sbc to_x+0
    sta Dx+0
    lda scratchpad_lx_hi, y
    sbc to_x+1
    sta Dx+1
    bvc :+
    eor #$80
:
    bmi :+
    jmp @posDx
:
    sec
    txa                 ; X = 0
    sbc Dx+0
    sta Dx+0
    txa                 ; X = 0
    sbc Dx+1
    sta Dx+1
    ; Neg Dx
    jsr clip_to_y_top_sub
    jmp @doneCalcIntercept
@posDx:
    jsr clip_to_y_top_add
@doneCalcIntercept:
    ldy y_temp
    ldx #0
    stx to_y+1
    stx to_y+0
@zeroHi:
    ; ly_lo (to_y+0) in X.
    bankswitch_to recip_asl_table
    lda recip_asl_table, x
    sta multiply_label jump_pos, 1
    clc
    adc #.lobyte(negative_asl - positive_asl)
    sta multiply_label jump_neg, 1
    lda #$80            ; SKB
    .byt $0C            ; IGN to skip next LDA.
@positive:
    lda #$60            ; RTS
    sta multiply_label r2, 0

    bankswitch_to recip_asl_table
    jsr multiply_to
    bankswitch_to draw_line
draw:
    lda (tf_ptr), y
    and #TF_BLANK
    bne cull
    jsr draw_line
cull:
    ldy y_temp
.endmacro

.proc multiply_from
    ldx from_y+1
    lda recip_index_table, x
    sta recip_ptr+1
    lda from_y+0
    jsr setup_depth
    lda from_y+0
    clc
    adc local_camera_height
    sta multiply_store
    bcc :+
    inx
:
    jsr multiply+1      ; +1 to skip TAX.
    sta from_y+0
    dex
    stx from_y+1
    lda from_x+0
    sta multiply_store
    ldx from_x+1
    jsr multiply+1      ; +1 to skip TAX.
    clc
    adc #128
    sta from_x+0
    txa
    adc #0
    bvc :+
    lda #.lobyte((1 << 15) - 1)
    sta from_x+0
    lda #.hibyte((1 << 15) - 1)
:
    sta from_x+1
    rts
.endproc

.proc multiply_to
    ldx to_y+1
    lda recip_index_table, x
    sta recip_ptr+1
    lda to_y+0
    jsr setup_depth
    lda to_y+0
    clc
    adc local_camera_height
    sta multiply_store
    bcc :+
    inx
:
    jsr multiply+1      ; +1 to skip TAX.
    sta to_y+0
    dex
    txa
    sta to_y+1
    lda to_x+0
    sta multiply_store
    ldx to_x+1
    jsr multiply+1      ; +1 to skip TAX.
    clc
    adc #128
    sta to_x+0
    txa
    adc #0
    bvc :+
    lda #.lobyte((1 << 15) - 1)
    sta to_x+0
    lda #.hibyte((1 << 15) - 1)
:
    sta to_x+1
    rts
.endproc

.repeat 2, i
.proc P i, _render 
    o = (1 - i)
    ; Levels are in bank 2
    bankswitch 2

    ldx P i, _jump
    lda ship_jump_table, x
    asl
    asl
    adc camera_height
    sbc P i, _boost
    sta local_camera_height


    sec
    lda #64
    sbc 1+P i, _dir
    jsr setup_cos

.if i = 0
    lda two_player
    beq @done2p
.endif
    sec
    lda 0+P o, _x
    sbc 0+P i, _x
    sta multiply_store
    lda 1+P o, _x
    sbc 1+P i, _x
    jsr multiply
    sta from_x+0
    stx from_x+1

    sec
    lda 0+P o, _y
    sbc 0+P i, _y
    sta multiply_store
    lda 1+P o, _y
    sbc 1+P i, _y
    jsr multiply
    sta from_y+0
    stx from_y+1
    ldy #4
    .byt $0C ; IGN to skip next ldy
@done2p:
    ldy #6
    sty draw_distance
    dey
    sty draw_distance_minus_one
cosLoop:
    sec
    lda (ly_lo_ptr), y
    sbc 0+P i, _y
    sta multiply_store
    lda (ly_hi_ptr), y
    sbc 1+P i, _y
    jsr multiply
    sta scratchpad_ly_lo, y
    txa
    sta scratchpad_ly_hi, y

    sec
    lda (lx_lo_ptr), y
    sbc 0+P i, _x
    sta multiply_store
    lda (lx_hi_ptr), y
    sbc 1+P i, _x
    jsr multiply
    sta scratchpad_lx_lo, y
    txa
    sta scratchpad_lx_hi, y

    sec
    lda (ry_lo_ptr), y
    sbc 0+P i, _y
    sta multiply_store
    lda (ry_hi_ptr), y
    sbc 1+P i, _y
    jsr multiply
    sta scratchpad_ry_lo, y
    txa
    sta scratchpad_ry_hi, y

    sec
    lda (rx_lo_ptr), y
    sbc 0+P i, _x
    sta multiply_store
    lda (rx_hi_ptr), y
    sbc 1+P i, _x
    jsr multiply
    sta scratchpad_rx_lo, y
    txa
    sta scratchpad_rx_hi, y

    dey
    bpl cosLoop

    sec
    lda #64
    sbc 1+P i, _dir
    jsr setup_sin

.if i = 0
    lda two_player
    beq @done2p
.endif
    sec
    lda 0+P o, _y
    sbc 0+P i, _y
    sta multiply_store
    lda 1+P o, _y
    sbc 1+P i, _y
    jsr multiply
    sec
    sbc from_x+0
    sta from_x+0
    txa
    sbc from_x+1
    sta from_x+1

    sec
    lda 0+P o, _x
    sbc 0+P i, _x
    sta multiply_store
    lda 1+P o, _x
    sbc 1+P i, _x
    jsr multiply
    clc
    adc from_y+0
    bcc :+
    inx
    clc
:
    adc #200
    sta from_y+0
    txa
    adc from_y+1
    sta from_y+1
@done2p:

    ldy draw_distance_minus_one
sinLoop:
    sec
    lda (ly_lo_ptr), y
    sbc 0+P i, _y
    sta multiply_store
    lda (ly_hi_ptr), y
    sbc 1+P i, _y
    jsr multiply
    sec
    sbc scratchpad_lx_lo, y
    sta scratchpad_lx_lo, y
    txa
    sbc scratchpad_lx_hi, y
    sta scratchpad_lx_hi, y

    sec
    lda (lx_lo_ptr), y
    sbc 0+P i, _x
    sta multiply_store
    lda (lx_hi_ptr), y
    sbc 1+P i, _x
    jsr multiply
    clc
    adc scratchpad_ly_lo, y
    bcc :+
    inx
    clc
:
    adc #200
    sta scratchpad_ly_lo, y
    txa
    adc scratchpad_ly_hi, y
    sta scratchpad_ly_hi, y

    sec
    lda (ry_lo_ptr), y
    sbc 0+P i, _y
    sta multiply_store
    lda (ry_hi_ptr), y
    sbc 1+P i, _y
    jsr multiply
    sec
    sbc scratchpad_rx_lo, y
    sta scratchpad_rx_lo, y
    txa
    sbc scratchpad_rx_hi, y
    sta scratchpad_rx_hi, y

    sec
    lda (rx_lo_ptr), y
    sbc 0+P i, _x
    sta multiply_store
    lda (rx_hi_ptr), y
    sbc 1+P i, _x
    jsr multiply
    clc
    adc scratchpad_ry_lo, y
    bcc :+
    inx
    clc
:
    adc #200
    sta scratchpad_ry_lo, y
    txa
    adc scratchpad_ry_hi, y
    sta scratchpad_ry_hi, y

    dey
    bpl sinLoop

    jsr transform_setup_mult

    lda two_player
    beq @cull
    bankswitch_to recip_asl_table
    lda from_y+1
    bmi @cull
    bne @positive
@zeroHi:
    ldx from_y+0
    lda recip_asl_table, x
    sta multiply_label jump_pos, 1
    clc
    adc #.lobyte(negative_asl - positive_asl)
    sta multiply_label jump_neg, 1
    lda #$80            ; SKB
    .byt $0C            ; IGN to skip next LDA.
@positive:
    lda #$60            ; RTS
    sta multiply_label r2, 0
    jsr multiply_from

    lda from_x+1
    ora from_y+1
    bne @cull

.if i = 0
    lda from_x+0
    alr #%11111110
    sbc #2
    bcc @cull
    sta 0*4+OAM_OPP+3 ; Set sprite's x-position.
    lda from_y+0
    clc
    adc #38-16
    sta 0*4+OAM_OPP+0 ; Set sprite's y-position.
    lda #PATTERN($4C)
    sta 0*4+OAM_OPP+1 ; Set sprite's pattern.
    lda #1
    sta 0*4+OAM_OPP+2 ; Set sprite's attributes.
.else
    lda from_x+0
    alr #%11111110
    sbc #2
    bcc @cull
    ora #128
    sta 1*4+OAM_OPP+3 ; Set sprite's x-position.
    lda from_y+0
    clc
    adc #38-16
    sta 1*4+OAM_OPP+0 ; Set sprite's y-position.
    lda #PATTERN($4B)
    sta 1*4+OAM_OPP+1 ; Set sprite's pattern.
    lda #0
    sta 1*4+OAM_OPP+2 ; Set sprite's attributes.
.endif
    jmp draw_lines_and_shit
@cull:
    lda #$FF
    sta i*4+OAM_OPP+0 ; Set sprite's y-position.
    jmp draw_lines_and_shit
.endproc
.endrepeat

.proc transform_setup_mult
    ; Setup self-modifying multiplication code.
    ldx #$A5            ; LDA (zero page)
    stx multiply_label la, 0
    ldx #multiply_label r2, 1
    stx multiply_label la, 1
    ldx #$A2            ; LDX (immediate)
    stx multiply_label r3, 0

    ldx #$86            ; STX
    stx multiply_label stx_temp, 0
    ldx #subroutine_temp
    stx multiply_label stx_temp, 1

    ldx #$10            ; BPL
    stx multiply_label last_branch, 0
    ldx #3
    stx multiply_label last_branch, 1

    ldx #$4C            ; JMP
    stx multiply_label jump_neg, 0
    rts
.endproc

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Draw the lines and shit ;
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;
.proc draw_lines_and_shit
    ; Setup color shit
    lda #%1100
    sta  l1100
    ldx #%1010
    stx  l1010
    sax  l1000
    lsr ;%0110
    sta  l0110
    ldx #%0101
    stx  l0101
    sax  l0100
    lsr ;%0011
    sta  l0011
    ldx #%1001
    stx  l1001
    sax  l0001
    lda #%0010
    sta  l0010


    bankswitch_to draw_line

    ldy #0
    sty ptr_temp+0
    sty y_temp
    jmp doneReuse
renderWallsLoop:
    wall_line 0, 0
    .scope right
        beq right::doneReuse        ; Zero flag = Y
        wall_line 1, (scratchpad_rx_lo - scratchpad_lx_lo)
    .endscope
nextIteration:
    iny
    sty y_temp
    cpy draw_distance_minus_one
    bcs :+
    jmp renderWallsLoop
:

    ; Setup color shit
    lda #%1100 << 4
    sta  l1100
    ldx #%1010 << 4
    stx  l1010
    sax  l1000
    lsr ;%0110
    sta  l0110
    ldx #%0101 << 4
    stx  l0101
    sax  l0100
    lsr ;%0011
    sta  l0011
    ldx #%1001 << 4
    stx  l1001
    sax  l0001
    lda #%0010 << 4
    sta  l0010

    ldy #1
renderFloorsLoop:
    sty y_temp
    .scope floor
        floor_line
    .endscope
nextFloorIteration:
    iny
    cpy draw_distance
    bcs :+
    jmp renderFloorsLoop
:
return:

.repeat 6, i
    lda mvar_stx_temp+i
    sta multiply_label stx_temp, i
.endrepeat

    rts
.endproc

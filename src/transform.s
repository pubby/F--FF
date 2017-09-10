.include "globals.inc"
.include "intercept.inc"

.import draw_line
.import setup_cos, setup_sin
.importzp multiply_store
.import setup_depth
.import asl_code
.import clip_from_y_top_sub
.import clip_from_y_top_add
.import clip_to_y_top_sub
.import clip_to_y_top_add

.export render

draw_distance = 4

.segment "CODE"

.macro wall_line offset
from:
    lda scratchpad_ly_hi+offset, y
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

    jsr multiply_to

    lda to_x+0
    sta depthpad_lx_lo+1+offset, y
    lda to_x+1
    sta depthpad_lx_hi+1+offset, y
    lda to_y+0
    sta depthpad_ly_lo+1+offset, y
    lda to_y+1
    sta depthpad_ly_hi+1+offset, y

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

    jsr multiply_to
draw:
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
    adc camera_height
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
    adc camera_height
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

.proc render
    ; Levels are in bank 2
    bankswitch 2

    sec
    lda #64
    sbc p1_dir
    jsr setup_cos
    ldy #draw_distance - 1
cosLoop:
    sec
    lda (ly_lo_ptr), y
    sbc p1_y+0
    sta multiply_store
    lda (ly_hi_ptr), y
    sbc p1_y+1
    jsr multiply
    sta scratchpad_ly_lo, y
    txa
    sta scratchpad_ly_hi, y

    sec
    lda (lx_lo_ptr), y
    sbc p1_x+0
    sta multiply_store
    lda (lx_hi_ptr), y
    sbc p1_x+1
    jsr multiply
    sta scratchpad_lx_lo, y
    txa
    sta scratchpad_lx_hi, y

    sec
    lda (ry_lo_ptr), y
    sbc p1_y+0
    sta multiply_store
    lda (ry_hi_ptr), y
    sbc p1_y+1
    jsr multiply
    sta scratchpad_ry_lo, y
    txa
    sta scratchpad_ry_hi, y

    sec
    lda (rx_lo_ptr), y
    sbc p1_x+0
    sta multiply_store
    lda (rx_hi_ptr), y
    sbc p1_x+1
    jsr multiply
    sta scratchpad_rx_lo, y
    txa
    sta scratchpad_rx_hi, y

    dey
    bpl cosLoop

    sec
    lda #64
    sbc p1_dir
    jsr setup_sin
    ldy #draw_distance - 1
sinLoop:
    sec
    lda (ly_lo_ptr), y
    sbc p1_y+0
    sta multiply_store
    lda (ly_hi_ptr), y
    sbc p1_y+1
    jsr multiply
    sec
    sbc scratchpad_lx_lo, y
    sta scratchpad_lx_lo, y
    txa
    sbc scratchpad_lx_hi, y
    sta scratchpad_lx_hi, y

    sec
    lda (lx_lo_ptr), y
    sbc p1_x+0
    sta multiply_store
    lda (lx_hi_ptr), y
    sbc p1_x+1
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
    sbc p1_y+0
    sta multiply_store
    lda (ry_hi_ptr), y
    sbc p1_y+1
    jsr multiply
    sec
    sbc scratchpad_rx_lo, y
    sta scratchpad_rx_lo, y
    txa
    sbc scratchpad_rx_hi, y
    sta scratchpad_rx_hi, y

    sec
    lda (rx_lo_ptr), y
    sbc p1_x+0
    sta multiply_store
    lda (rx_hi_ptr), y
    sbc p1_x+1
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

    ;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Draw the lines and shit
    ;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; Gonna use line routines in bank 0.
    bankswitch 0

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

    ldy #0
    sty ptr_temp+0
    sty y_temp
    jmp doneReuse
renderWallsLoop:
    wall_line 0
    .scope right
        beq right::doneReuse        ; Zero flag = Y
        wall_line (scratchpad_rx_lo - scratchpad_lx_lo)
    .endscope
nextIteration:
    iny
    sty y_temp
    cpy #draw_distance - 1
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
    iny
    cpy #draw_distance
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

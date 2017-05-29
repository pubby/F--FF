.include "globals.inc"

.import draw_line
.import setup_cos, setup_sin
.importzp multiply_trig, trig_store
.import setup_8x16_depth_scale
.import init_trig_depth

.export render

.segment "RODATA"
.include "foo.level.inc"

.segment "CODE"

.proc render
    ; setup pointers (TODO)
    store16into #ltx_lo, lx_lo_ptr
    store16into #ltx_hi, lx_hi_ptr
    store16into #lty_lo, ly_lo_ptr
    store16into #lty_hi, ly_hi_ptr
    store16into #rtx_lo, rx_lo_ptr
    store16into #rtx_hi, rx_hi_ptr
    store16into #rty_lo, ry_lo_ptr
    store16into #rty_hi, ry_hi_ptr

    sec
    lda #64
    sbc p1_dir
    jsr setup_sin
    ldy #0
sinLoop:
    sec
    lda (ly_lo_ptr), y
    sbc p1_y+0
    sta trig_store
    lda (ly_hi_ptr), y
    sbc p1_y+1
    jsr multiply_trig
    sta scratchpad_lx_lo, y
    stx scratchpad_lx_hi, y

    sec
    lda (lx_lo_ptr), y
    sbc p1_x+0
    sta trig_store
    lda (lx_hi_ptr), y
    sbc p1_x+1
    jsr multiply_trig
    sta scratchpad_ly_lo, y
    stx scratchpad_ly_hi, y

    sec
    lda (ry_lo_ptr), y
    sbc p1_y+0
    sta trig_store
    lda (ry_hi_ptr), y
    sbc p1_y+1
    jsr multiply_trig
    sta scratchpad_rx_lo, y
    stx scratchpad_rx_hi, y

    sec
    lda (rx_lo_ptr), y
    sbc p1_x+0
    sta trig_store
    lda (rx_hi_ptr), y
    sbc p1_x+1
    jsr multiply_trig
    sta scratchpad_ry_lo, y
    stx scratchpad_ry_hi, y

    iny
    cpy #6
    bne sinLoop

    sec
    lda #64
    sbc p1_dir
    jsr setup_cos
    ldy #0
cosLoop:
    sec
    lda (lx_lo_ptr), y
    sbc p1_x+0
    sta trig_store
    lda (lx_hi_ptr), y
    sbc p1_x+1
    jsr multiply_trig
    sec
    sbc scratchpad_lx_lo, y
    sta scratchpad_lx_lo, y
    txa
    sbc scratchpad_lx_hi, y
    sta scratchpad_lx_hi, y

    sec
    lda (ly_lo_ptr), y
    sbc p1_y+0
    sta trig_store
    lda (ly_hi_ptr), y
    sbc p1_y+1
    jsr multiply_trig
    clc
    adc scratchpad_ly_lo, y
    sta scratchpad_ly_lo, y
    txa
    adc scratchpad_ly_hi, y
    sta scratchpad_ly_hi, y

    sec
    lda (rx_lo_ptr), y
    sbc p1_x+0
    sta trig_store
    lda (rx_hi_ptr), y
    sbc p1_x+1
    jsr multiply_trig
    sec
    sbc scratchpad_rx_lo, y
    sta scratchpad_rx_lo, y
    txa
    sbc scratchpad_rx_hi, y
    sta scratchpad_rx_hi, y

    sec
    lda (ry_lo_ptr), y
    sbc p1_y+0
    sta trig_store
    lda (ry_hi_ptr), y
    sbc p1_y+1
    jsr multiply_trig
    clc
    adc scratchpad_ry_lo, y
    sta scratchpad_ry_lo, y
    txa
    adc scratchpad_ry_hi, y
    sta scratchpad_ry_hi, y

    iny
    cpy #6
    bne cosLoop

    ; Draw the lines and shit
    jsr init_trig_depth
    ldy #0
    sty ptr_temp+0
renderLoop:

    sty y_temp

    lda scratchpad_ly_hi, y
    beq zeroHi
    bpl positiveFrom
    ;bit scratchpad_ly_hi+1, y   ; Check if entire line is behind camera.
    ;bmi cull
zeroHi:
    jmp nextIteration
positiveFrom:
    lda scratchpad_ly_hi+1, y
    beq zeroHi
    bpl positiveTo
    jmp nextIteration
positiveTo:

nonzeroHi:    ; Use 8x16 multiplication.
    ldx scratchpad_ly_hi, y ; TODO: tax?
    lda recip_index_table, x
    sta ptr_temp+1
    lda scratchpad_ly_lo, y
    pha
    and recip_and_table, x
    ora recip_or_table, x
    tay
    jsr setup_8x16_depth_scale  ; Preserves X.
    pla
    clc
    adc #200
    sta trig_store
    bcc :+
    inx
:
    jsr multiply_trig+1         ; +1 to skip TAX.
    sta from_y+0
    dex
    stx from_y+1

    ldy y_temp
    lda scratchpad_lx_lo, y
    sta trig_store
    ldx scratchpad_lx_hi, y
    jsr multiply_trig+1         ; +1 to skip TAX.
    clc
    adc #128
    sta from_x+0
    bcc :+
    inx
:
    stx from_x+1

    ; TO
    ldy y_temp ; TODO
    ldx scratchpad_ly_hi+1, y ; TODO: tax?
    lda recip_index_table, x
    sta ptr_temp+1
    lda scratchpad_ly_lo+1, y
    pha
    and recip_and_table, x
    ora recip_or_table, x
    tay
    jsr setup_8x16_depth_scale  ; Preserves X.
    pla
    clc
    adc #200
    sta trig_store
    bcc :+
    inx
:
    jsr multiply_trig+1         ; +1 to skip TAX.
    sta to_y+0
    dex
    stx to_y+1

    ldy y_temp
    lda scratchpad_lx_lo+1, y
    sta trig_store
    ldx scratchpad_lx_hi+1, y
    jsr multiply_trig+1         ; +1 to skip TAX.
    clc
    adc #128
    sta to_x+0
    bcc :+
    inx
:
    stx to_x+1

    ;store16into from_x, to_x
    ;store16into from_y, to_y
    ;dec from_y+1

.if 0
    lda scratchpad_lx_lo, y
    clc
    adc #128
    sta from_x+0
    lda scratchpad_lx_hi, y
    adc #0
    sta from_x+1
    lda scratchpad_ly_lo, y
    sta from_y+0
    lda scratchpad_ly_hi, y
    sta from_y+1

    lda scratchpad_lx_lo+1, y
    clc
    adc #128
    sta to_x+0
    lda scratchpad_lx_hi+1, y
    adc #0
    sta to_x+1
    lda scratchpad_ly_lo+1, y
    sta to_y+0
    lda scratchpad_ly_hi+1, y
    sta to_y+1
.endif

    bankswitch 0
    jsr draw_line

nextIteration:
    ldy y_temp
    iny
    cpy #5
    bcs return
    jmp renderLoop
return:
    rts
.endproc

; TODO code!
.if 0
    ; Clip from.
    sta from_y+1
    lda scratchpad_ly_lo, y
    sta from_y+0

    lda scratchpad_lx_lo, y
    sta from_x+0
    lda scratchpad_lx_hi, y
    sta from_x+1

    ; Find Dy
    sec
    lda scratchpad_ly_lo+1, y
    sta to_y+0
    sbc scratchpad_ly_lo, y
    sta Dy+0
    lda scratchpad_ly_hi+1, y
    sta to_y+1
    sbc scratchpad_ly_hi, y
    sta Dy+1


    ; Now find Dx
    sec
    lda scratchpad_lx_lo+1, y
    sta to_x+0
    sbc scratchpad_lx_lo, y
    sta Dx+0
    lda scratchpad_lx_hi+1, y
    sta to_x+1
    sbc scratchpad_lx_hi, y
    sta Dx+1
    bvc :+
    eor #$80
:
    bmi :+
    jmp @posDx
:
    sec
    lax #0
    sbc Dx+0
    sta Dx+0
    txa
    sbc Dx+1
    sta Dx+1
    ; Neg Dx
    .scope clipNegX
        clip sub
        bressenham sub
    .endscope
@posDx:
    .scope clipPosX
        clip add
        bressenham add
    .endscope


    ; calc Dx and Dy

    ; No clipping needed!
    lda scratchpad_ly_hi, y
    beq zeroFrom
    lda scratchpad_ly_lo, y
    jsr setup_depth_scale
    jsr multiply_trig
    sec
    sbc #256-32
    sta from_y+0
    bcs :+
    dex
:
    stx from_y+1


nonzeroHi:    ; Use 8x16 multiplication.
    ldx scratchpad_ly_hi, y ; TODO: tax?
    lda recip_index_table, x
    sta ptr_temp+1
    lda scratchpad_ly_lo, y
    and recip_and_table, x
    ora recip_or_table, x
    sta ptr_temp+0
    jsr setup_8x16_depth_scale


zeroHi:       ; Use 16x16 multiplication.
    sta multiplicand+1
    ldx scratchpad_ly_lo, y
    stx multiplicand+0
    lda recip_table_0_lo, x
    ldy recip_table_0_hi, x
    jsr prepare_16x16_depth

.endif

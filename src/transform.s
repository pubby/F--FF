.include "globals.inc"

.import draw_line
.import setup_cos, setup_sin
.importzp multiply_store
.import setup_depth
.import asl_code

.export render

draw_distance = 4

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
    sta multiply_store
    lda (ly_hi_ptr), y
    sbc p1_y+1
    jsr multiply
    sta scratchpad_lx_lo, y
    txa
    sta scratchpad_lx_hi, y

    sec
    lda (lx_lo_ptr), y
    sbc p1_x+0
    sta multiply_store
    lda (lx_hi_ptr), y
    sbc p1_x+1
    jsr multiply
    sta scratchpad_ly_lo, y
    txa
    sta scratchpad_ly_hi, y

    sec
    lda (ry_lo_ptr), y
    sbc p1_y+0
    sta multiply_store
    lda (ry_hi_ptr), y
    sbc p1_y+1
    jsr multiply
    sta scratchpad_rx_lo, y
    txa
    sta scratchpad_rx_hi, y

    sec
    lda (rx_lo_ptr), y
    sbc p1_x+0
    sta multiply_store
    lda (rx_hi_ptr), y
    sbc p1_x+1
    jsr multiply
    sta scratchpad_ry_lo, y
    txa
    sta scratchpad_ry_hi, y

    iny
    cpy #draw_distance
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
    sta multiply_store
    lda (lx_hi_ptr), y
    sbc p1_x+1
    jsr multiply
    sec
    sbc scratchpad_lx_lo, y
    sta scratchpad_lx_lo, y
    txa
    sbc scratchpad_lx_hi, y
    sta scratchpad_lx_hi, y

    sec
    lda (ly_lo_ptr), y
    sbc p1_y+0
    sta multiply_store
    lda (ly_hi_ptr), y
    sbc p1_y+1
    jsr multiply
    clc
    adc scratchpad_ly_lo, y
    sta scratchpad_ly_lo, y
    txa
    adc scratchpad_ly_hi, y
    sta scratchpad_ly_hi, y

    sec
    lda (rx_lo_ptr), y
    sbc p1_x+0
    sta multiply_store
    lda (rx_hi_ptr), y
    sbc p1_x+1
    jsr multiply
    sec
    sbc scratchpad_rx_lo, y
    sta scratchpad_rx_lo, y
    txa
    sbc scratchpad_rx_hi, y
    sta scratchpad_rx_hi, y

    sec
    lda (ry_lo_ptr), y
    sbc p1_y+0
    sta multiply_store
    lda (ry_hi_ptr), y
    sbc p1_y+1
    jsr multiply
    clc
    adc scratchpad_ry_lo, y
    sta scratchpad_ry_lo, y
    txa
    adc scratchpad_ry_hi, y
    sta scratchpad_ry_hi, y

    iny
    cpy #draw_distance
    bne cosLoop

    ; Draw the lines and shit
    ldy #0
    sty ptr_temp+0
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
    stx multiply_label jump_pos, 0
renderLoop:
    sty y_temp

fromL:
    lda scratchpad_ly_hi, y
    beq @zeroHi
    bpl @positive
    ;bit scratchpad_ly_hi+1, y   ; Check if entire line is behind camera.
    ;bmi cull
    jmp skipL
@zeroHi:
    ldx scratchpad_ly_lo, y
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

    ; FROM
    ldx scratchpad_ly_hi, y ; TODO: tax?
    lda recip_index_table, x
    sta recip_ptr+1
    lda scratchpad_ly_lo, y
    jsr setup_depth
    lda scratchpad_ly_lo, y
    clc
    adc #128
    sta multiply_store
    bcc :+
    inx
:
    jsr multiply+1      ; +1 to skip TAX.
    sta from_y+0
    dex
    stx from_y+1
    lda scratchpad_lx_lo, y
    sta multiply_store
    ldx scratchpad_lx_hi, y
    jsr multiply+1      ; +1 to skip TAX.
    clc
    adc #128
    sta from_x+0
    bcc :+
    inx
:
    stx from_x+1

toL:
    lda scratchpad_ly_hi+1, y
    beq @zeroHi
    bpl @positive
    ;bit scratchpad_ly_hi+1, y   ; Check if entire line is behind camera.
    ;bmi cull
    jmp skipL
@zeroHi:
    ldx scratchpad_ly_lo+1, y
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

    ; TO
    ldx scratchpad_ly_hi+1, y ; TODO: tax?
    lda recip_index_table, x
    sta recip_ptr+1
    lda scratchpad_ly_lo+1, y
    jsr setup_depth
    lda scratchpad_ly_lo+1, y
    clc
    adc #128
    sta multiply_store
    bcc :+
    inx
:
    jsr multiply+1      ; +1 to skip TAX.
    sta to_y+0
    dex
    stx to_y+1
    lda scratchpad_lx_lo+1, y
    sta multiply_store
    ldx scratchpad_lx_hi+1, y
    jsr multiply+1         ; +1 to skip TAX.
    clc
    adc #128
    sta to_x+0
    bcc :+
    inx
:
    stx to_x+1


    bankswitch 0
    jsr draw_line
    ldy y_temp

skipL:
fromR:
    lda scratchpad_ry_hi, y
    beq @zeroHi
    bpl @positive
    ;bit scratchpad_ly_hi+1, y   ; Check if entire line is behind camera.
    ;bmi cull
    jmp skipR
@zeroHi:
    ldx scratchpad_ry_lo, y
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

    ; FROM
    ldx scratchpad_ry_hi, y ; TODO: tax?
    lda recip_index_table, x
    sta recip_ptr+1
    lda scratchpad_ry_lo, y
    jsr setup_depth
    lda scratchpad_ry_lo, y
    clc
    adc #128
    sta multiply_store
    bcc :+
    inx
:
    jsr multiply+1      ; +1 to skip TAX.
    sta from_y+0
    dex
    stx from_y+1
    lda scratchpad_rx_lo, y
    sta multiply_store
    ldx scratchpad_rx_hi, y
    jsr multiply+1      ; +1 to skip TAX.
    clc
    adc #128
    sta from_x+0
    bcc :+
    inx
:
    stx from_x+1

toR:
    lda scratchpad_ry_hi+1, y
    beq @zeroHi
    bpl @positive
    ;bit scratchpad_ly_hi+1, y   ; Check if entire line is behind camera.
    ;bmi cull
    jmp skipR
@zeroHi:
    ldx scratchpad_ry_lo+1, y
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

    ; TO
    ldx scratchpad_ry_hi+1, y ; TODO: tax?
    lda recip_index_table, x
    sta recip_ptr+1
    lda scratchpad_ry_lo+1, y
    jsr setup_depth
    lda scratchpad_ry_lo+1, y
    clc
    adc #128
    sta multiply_store
    bcc :+
    inx
:
    jsr multiply+1      ; +1 to skip TAX.
    sta to_y+0
    dex
    stx to_y+1
    lda scratchpad_rx_lo+1, y
    sta multiply_store
    ldx scratchpad_rx_hi+1, y
    jsr multiply+1         ; +1 to skip TAX.
    clc
    adc #128
    sta to_x+0
    bcc :+
    inx
:
    stx to_x+1

    bankswitch 0
    jsr draw_line

nextIteration:
    ldy y_temp
skipR:
    iny
    cpy #draw_distance - 1
    bcs return
    jmp renderLoop
return:

.repeat 6, i
    lda mvar_stx_temp+i
    sta multiply_label stx_temp, i
.endrepeat

    rts
.endproc

; TODO code!
.if 0
    ldx scratchpad_ly_hi, y ; TODO: tax?
    lda recip_index_table, x
    sta ptr_temp+1
    lda scratchpad_ly_lo, y
    and recip_and_table, x
    ora recip_or_table, x

nonzeroHi:
    lda #0
    sta ptr_temp+0
    ldx scratchpad_ly_hi, y ; TODO: tax?
    lda recip_index_table, x
    sta ptr_temp+1
    lda scratchpad_ly_lo, y
    pha
    and recip_and_table, x
    ora recip_or_table, x
    tay
    jsr setup_depth     ; Preserves X.


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
    lda #0
    sbc Dx+0
    sta Dx+0
    lda #0
    sbc Dx+commentssharesavehidereport1
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
    jsr multiply
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

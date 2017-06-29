.include "globals.inc"

.export setup_cos, setup_sin
.exportzp multiply_store
.export copy_multiply_code
.export setup_depth
.export setup_multiply

.segment "MULT_TABLES"
square1_lo:
    .repeat 512, i
        .byt .lobyte((i*i)/4)  
    .endrepeat
square1_hi:
    .repeat 512, i
        .byt .hibyte((i*i)/4)  
    .endrepeat
square2_lo:
    .repeat 512, i
        .byt .lobyte(((i-255)*(i-255))/4)
    .endrepeat
square2_hi:
    .repeat 512, i
        .byt .hibyte(((i-255)*(i-255))/4)
    .endrepeat

.include "recip.inc"

.proc positive_asl
    .repeat 6
        asl multiply_sub
        rol
        rol subroutine_temp
        bmi max
    .endrepeat
    ldx subroutine_temp
    rts
max:
    lda #.lobyte((1 << 15) - 1)
    ldx #.hibyte((1 << 15) - 1)
    rts
.endproc

.proc negative_asl
    .repeat 6
        asl multiply_sub
        rol
        rol subroutine_temp
        bpl min
    .endrepeat
    ldx subroutine_temp
    rts
min:
    lda #.lobyte(-(1 << 15))
    ldx #.hibyte(-(1 << 15))
    rts
.endproc

; Sine tables should be on a page, but not necessarily aligned.
.include "sin.inc"

.assert .lobyte(square1_lo) = 0, error, "misaligned table"
.assert .lobyte(square1_hi) = 0, error, "misaligned table"
.assert .lobyte(square2_lo) = 0, error, "misaligned table"
.assert .lobyte(square2_hi) = 0, error, "misaligned table"
.assert .lobyte(positive_asl) = 0, error, "misaligned asl"
.assert .hibyte(sin_table_lo+128) = .hibyte(sin_table_lo), error, "sin_table misaligned"

.segment "CODE"

multiply_code:
    ; Hi * Hi
    tax
    sec
mvar_p5: 
    lda square1_lo, x
mvar_p6: 
    sbc square2_lo, x
    sta multiply_label hh2, 1
mvar_p7: 
    lda square1_hi, x
mvar_p8: 
    sbc square2_hi, x
    sta multiply_label r3, 1

    ; Hi * Lo
    sec
mvar_p1: 
    lda square1_lo, x
mvar_p2: 
    sbc square2_lo, x
    sta multiply_label hl1, 1
mvar_p3: 
    lda square1_hi, x
mvar_p4: 
    sbc square2_hi, x
    sta multiply_label hl2, 1
    dex
    inx
    bpl :+
    sec
mvar_s0: 
    sbc #0
    sta multiply_label hl2, 1
    lda multiply_label r3, 1
mvar_s1: 
    sbc #0
    sta multiply_label r3, 1
:

    ; Lo * Hi
mvar_ms: 
    ldx #0
    sec
mvar_q5: 
    lda square1_lo, x
mvar_q6: 
    sbc square2_lo, x
    sta multiply_label lh1, 1
mvar_q7: 
    lda square1_hi, x
mvar_q8: 
    sbc square2_hi, x
    clc
mvar_hh2:
    adc #0
    sta multiply_label lh2, 1
    bcc :+
    inc multiply_label r3, 1
:

    ; Lo * Lo
mvar_q1: 
    lda square1_lo, x
mvar_q2: 
    cmp square2_lo, x
mvar_q3: 
    lda square1_hi, x
mvar_q4: 
    sbc square2_hi, x
    clc
mvar_hl1:
    adc #0
    sta multiply_label ll1, 1
mvar_lh2:
    lda #0
mvar_hl2:
    adc #0
    sta multiply_label r2, 1
    bcc :+
    inc multiply_label r3, 1
    clc
:

    ; Sub
mvar_lh1:
    lda #0
mvar_ll1:
    adc #0
    sta multiply_sub
    bcc :+
    inc multiply_label r2, 1
    bne :+
    inc multiply_label r3, 1
:

mvar_la: 
    lax $00
mvar_r3: 
    axs #0              ; Sets carry.
mvar_r2: 
    eor #0
mvar_stx_temp:
    adc #0
mvar_last_branch:
    bcc :+
mvar_jump_neg:
    inx
:
    rts
    .byt .hibyte(negative_asl)
mvar_jump_pos:
    jmp positive_asl
mvar_FF:
    .byt $FF
multiply_code_end:

multiply_store = multiply_label ms, 1

.assert multiply_code_end - multiply_code < $88, error, "too much code"

setup_cos:
    clc
    adc #64
.proc setup_sin
    cmp #128
    bcc positive
    sbc #128            ; Carry set from BCC
    ldx #$A7            ; LAX (zero page)
    stx multiply_label la, 0
    ldx #multiply_label FF, 0
    stx multiply_label la, 1
    ldx #$CB            ; AXS
    stx multiply_label r3, 0
    ldx #$49            ; EOR
    stx multiply_label r2, 0
    jmp doneSign
positive:
    ldx #$A5            ; LDA (zero page)
    stx multiply_label la, 0
    ldx #multiply_label r2, 1
    stx multiply_label la, 1
    ldx #$A2            ; LDX (immediate)
    stx multiply_label r3, 0
    ldx #$60            ; RTS
    stx multiply_label r2, 0
doneSign:
    cmp #64
    bcc :+
    eor #$FF
    adc #127
:
    tax
    lda sin_table_lo, x
    sta multiply_label s0, 1
    sta multiply_label p1, 1
    sta multiply_label q1, 1
    sta multiply_label p3, 1
    sta multiply_label q3, 1
    eor #$FF
    sta multiply_label p2, 1
    sta multiply_label q2, 1
    sta multiply_label p4, 1
    sta multiply_label q4, 1

    lda sin_table_hi, x
    sta multiply_label s1, 1
    sta multiply_label p5, 1
    sta multiply_label q5, 1
    sta multiply_label p7, 1
    sta multiply_label q7, 1
    eor #$FF
    sta multiply_label p6, 1
    sta multiply_label q6, 1
    sta multiply_label p8, 1
    sta multiply_label q8, 1
    rts
.endproc

.proc copy_multiply_code
    ldx #0
loop:
    lda multiply_code, x
    sta multiply, x
    inx
    cpx #multiply_code_end - multiply_code
    bne loop
    rts
.endproc

.proc setup_depth
    and recip_and_table, x
    ora recip_or_table, x
    tay
    lda (recip_ptr), y
    sta multiply_label s0, 1
    sta multiply_label p1, 1
    sta multiply_label q1, 1
    sta multiply_label p3, 1
    sta multiply_label q3, 1
    eor #$FF
    sta multiply_label p2, 1
    sta multiply_label q2, 1
    sta multiply_label p4, 1
    sta multiply_label q4, 1
    inc recip_ptr+1
    lda (recip_ptr), y
    sta multiply_label s1, 1
    sta multiply_label p5, 1
    sta multiply_label q5, 1
    sta multiply_label p7, 1
    sta multiply_label q7, 1
    eor #$FF
    sta multiply_label p6, 1
    sta multiply_label q6, 1
    sta multiply_label p8, 1
    sta multiply_label q8, 1
    ldy y_temp
    rts
.endproc

; X in = multiplier lobyte 
; A in = multiplier hibyte
.proc setup_multiply
    pha
    bvs overflowSet
    bmi negative
positive:
    lda #$A5            ; LDA (zero page)
    sta multiply_label la, 0
    lda #multiply_label r2, 1
    sta multiply_label la, 1
    lda #$A2            ; LDX (immediate)
    sta multiply_label r3, 0
    lda #$60            ; RTS
    sta multiply_label r2, 0
    pla
    jmp store
overflowSet:
    bmi positive
negative:
    lda #$A7            ; LAX (zero page)
    sta multiply_label la, 0
    lda #multiply_label FF, 0
    sta multiply_label la, 1
    lda #$CB            ; AXS
    sta multiply_label r3, 0
    lda #$49            ; EOR
    sta multiply_label r2, 0
    txa
    eor #$FF
    clc
    adc #1
    tax
    pla
    eor #$FF
    adc #0
store:

    ; Hi
    sta multiply_label s1, 1
    sta multiply_label p5, 1
    sta multiply_label q5, 1
    sta multiply_label p7, 1
    sta multiply_label q7, 1
    eor #$FF
    sta multiply_label p6, 1
    sta multiply_label q6, 1
    sta multiply_label p8, 1
    sta multiply_label q8, 1

    ; Lo
    txa
    sta multiply_label s0, 1
    sta multiply_label p1, 1
    sta multiply_label q1, 1
    sta multiply_label p3, 1
    sta multiply_label q3, 1
    eor #$FF
    sta multiply_label p2, 1
    sta multiply_label q2, 1
    sta multiply_label p4, 1
    sta multiply_label q4, 1

    rts
.endproc

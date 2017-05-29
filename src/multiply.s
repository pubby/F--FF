.include "globals.inc"

.export setup_cos, setup_sin
.exportzp multiply_trig, trig_store
.export copy_trig_code
.export setup_8x16_depth_scale
.export init_trig_depth

.segment "MULT_TABLES"
    .byt .lobyte(16384)
square2_lo:
    .repeat 255, i
        .byt .lobyte(((i-255)*(i-255))/4)
    .endrepeat
square1_lo:
    .repeat 512, i
        .byt .lobyte((i*i)/4)  
    .endrepeat
    .byt .hibyte(16384)
square2_hi:
    .repeat 255, i
        .byt .hibyte(((i-255)*(i-255))/4)
    .endrepeat
square1_hi:
    .repeat 512, i
        .byt .hibyte((i*i)/4)  
    .endrepeat
reciprical_table:
    .byt 0
    .byt 0
    .repeat 254, i
        .byt (256 / (i + 2))
    .endrepeat

.include "recip.inc"
.include "sin.inc"

.assert .lobyte(square1_lo) = 0, error, "misaligned table"
.assert .lobyte(square1_hi) = 0, error, "misaligned table"
.assert .lobyte(square2_lo) = 1, error, "misaligned table"
.assert .lobyte(square2_hi) = 1, error, "misaligned table"

.segment "CODE"

multiply_trig = $C0

.proc multiply_trig_code
    tax
    sec
p1: lda 1111, x
p2: sbc 2222, x
    sta .lobyte(multiply_trig + (r0 - multiply_trig_code) + 1)
p3: lda 3333, x
p4: sbc 4444, x
    dex
    inx
    bpl :+
    sec
s:  sbc #0
:
    sta .lobyte(multiply_trig + (r2 - multiply_trig_code) + 1)

m:  ldx #0
q1: lda 1111, x
q2: cmp 2222, x
q3: lda 3333, x
q4: sbc 4444, x
    sta .lobyte(multiply_trig + (r1 - multiply_trig_code) + 1)
    clc
r0: lda #0
r1: adc #0
r2: ldx #0
d:  bcc :+
    inx
:
    rts
end:
.endproc

.assert multiply_trig_code::end - multiply_trig_code < $40, error, "too much code"

trig_store = .lobyte(multiply_trig + (multiply_trig_code::m - multiply_trig_code) + 1)

.define trig_label(l, o) .lobyte(multiply_trig + (multiply_trig_code::l - multiply_trig_code) + o)

.proc copy_trig_code
    ldx #0
loop:
    lda multiply_trig_code, x
    sta multiply_trig, x
    inx
    cpx #multiply_trig_code::end - multiply_trig_code
    bne loop
    rts
.endproc

setup_8x16_depth_scale:
    lda #.hibyte(square1_lo)
    sta trig_label p1, 2
    sta trig_label q1, 2
    lda #.hibyte(square2_lo)
    sta trig_label p2, 2
    sta trig_label q2, 2
    lda #.hibyte(square1_hi)
    sta trig_label p3, 2
    sta trig_label q3, 2
    lda #.hibyte(square2_hi)
    sta trig_label p4, 2
    sta trig_label q4, 2
    lda #0
    sta ptr_temp+0
    lda (ptr_temp), y
    ;lda #$20
    clc
    jmp storePositive
positive_one:
    lda #.hibyte(square1_lo + 256)
    sta trig_label p1, 2
    sta trig_label q1, 2
    lda #.hibyte(square2_lo - 1)
    sta trig_label p2, 2
    sta trig_label q2, 2
    lda #.hibyte(square1_hi + 256)
    sta trig_label p3, 2
    sta trig_label q3, 2
    lda #.hibyte(square2_hi - 1)
    sta trig_label p4, 2
    sta trig_label q4, 2
    jmp zero_lo
setup_cos:
    clc
    adc #64
setup_sin:
    ldy #$FF
    cmp #128
    bcs negative
positive:
    ldx #$38          ; sec
    stx trig_label s, -1
    ldx #$E8          ; inx
    stx trig_label d, 2
    inx               ; sbc
    stx trig_label s, 0
    ldx #$90          ; bcc
    stx trig_label d, 0
    ldx #$18          ; clc
    stx trig_label r0, -1
    ldx #$69          ; adc
    stx trig_label r1, 0
    cmp #64
    bcc :+
    eor #$FF
    adc #128
:
    cmp #62
    bcs positive_one
    tax                         ; Store A in X for later.
    lda #.hibyte(square1_lo)
    sta trig_label p1, 2
    sta trig_label q1, 2
    lda #.hibyte(square2_lo)
    sta trig_label p2, 2
    sta trig_label q2, 2
    lda #.hibyte(square1_hi)
    sta trig_label p3, 2
    sta trig_label q3, 2
    lda #.hibyte(square2_hi)
    sta trig_label p4, 2
    sta trig_label q4, 2
    lda sin_table, x            ; Use stored X.
storePositive:
    sta trig_label s, 1
    sta trig_label p1, 1
    sta trig_label q1, 1
    sta trig_label p3, 1
    sta trig_label q3, 1
    eor #$FF
    adc #1                      ; Carry clear from bcs.
    sta trig_label p2, 1
    sta trig_label q2, 1
    sta trig_label p4, 1
    sta trig_label q4, 1
    bcc :+
    inc trig_label p2, 2
    inc trig_label q2, 2
    inc trig_label p4, 2
    inc trig_label q4, 2
:
    rts
negative:
    sbc #128 
    beq positive
    ldx #$18          ; clc
    stx trig_label s, -1
    ldx #$CA          ; dex
    stx trig_label d, 2
    ldx #$69          ; adc
    stx trig_label s, 0
    ldx #$B0          ; bcs
    stx trig_label d, 0
    ldx #$38          ; sec
    stx trig_label r0, -1
    ldx #$E9          ; sbc
    stx trig_label r1, 0
    cmp #64
    bcc :+
    eor #$FF
    adc #128
:
    cmp #62
    bcs negative_one
    tax                         ; Store A in X for later.
    lda #.hibyte(square1_lo)
    sta trig_label p2, 2
    sta trig_label q1, 2
    lda #.hibyte(square2_lo)
    sta trig_label p1, 2
    sta trig_label q2, 2
    lda #.hibyte(square1_hi)
    sta trig_label p4, 2
    sta trig_label q3, 2
    lda #.hibyte(square2_hi)
    sta trig_label p3, 2
    sta trig_label q4, 2
    lda sin_table, x            ; Use stored X.
    sta trig_label s, 1
    sta trig_label p2, 1
    sta trig_label q1, 1
    sta trig_label p4, 1
    sta trig_label q3, 1
    eor #$FF
    adc #1                      ; Carry clear from bcs.
    sta trig_label p1, 1
    sta trig_label q2, 1
    sta trig_label p3, 1
    sta trig_label q4, 1
    bcc :+
    inc trig_label p1, 2
    inc trig_label q2, 2
    inc trig_label p3, 2
    inc trig_label q4, 2
:
    rts
negative_one:
    lda #.hibyte(square1_lo + 256)
    sta trig_label p2, 2
    sta trig_label q1, 2
    lda #.hibyte(square2_lo - 1)
    sta trig_label p1, 2
    sta trig_label q2, 2
    lda #.hibyte(square1_hi + 256)
    sta trig_label p4, 2
    sta trig_label q3, 2
    lda #.hibyte(square2_hi - 1)
    sta trig_label p3, 2
    sta trig_label q4, 2
zero_lo:
    lda #0
    sta trig_label s, 1
    sta trig_label p1, 1
    sta trig_label q1, 1
    sta trig_label p2, 1
    sta trig_label q2, 1
    sta trig_label p3, 1
    sta trig_label q3, 1
    sta trig_label p4, 1
    sta trig_label q4, 1
    rts

.proc init_trig_depth
    ldx #$38          ; sec
    stx trig_label s, -1
    ldx #$E8          ; inx
    stx trig_label d, 2
    inx               ; sbc
    stx trig_label s, 0
    ldx #$90          ; bcc
    stx trig_label d, 0
    ldx #$18          ; clc
    stx trig_label r0, -1
    ldx #$69          ; adc
    stx trig_label r1, 0
    rts
.endproc

depth_ptr1 =  0
depth_ptr2 =  2
depth_ptr3 =  4
depth_ptr4 =  6
depth_ptr5 =  8
depth_ptr6 = 10
depth_ptr7 = 12
depth_ptr8 = 14

mult_temp1 = 16
mult_temp2 = 18

.if 0
.proc multiply_depth
    ldy multiplicand+1
    sec
    lda (depth_ptr1), y
    sbc (depth_ptr2), y
    sta mult_temp1+0
    lda (depth_ptr3), y
    sbc (depth_ptr4), y
    sta mult_temp1+1

    sec
    lda (depth_ptr5), y
    sbc (depth_ptr6), y
    tax

    ldy multiplicand+0
    sec
    lda (depth_ptr5), y
    sbc (depth_ptr6), y
    sta mult_temp2+0
    lda (depth_ptr7), y
    sbc (depth_ptr8), y
    sta mult_temp2+1

    lda (depth_ptr1), y
    cmp (depth_ptr2), y
    lda (depth_ptr3), y
    sbc (depth_ptr4), y
    clc
    adc mult_temp1+0
    tay
    txa
    adc mult_temp1+1
    tax

    tya
    adc mult_temp2+0
    sta product+0
    txa
    adc mult_temp2+1
    sta product+1
    rts
.endproc

.proc prepare_16x16_depth
positive:
    ldx #.hibyte(square2_lo)
    stx depth_ptr2+1
    stx depth_ptr6+1
    ldx #.hibyte(square2_hi)
    stx depth_ptr4+1
    stx depth_ptr8+1
    sta mult_subtract   ; Lo in A.
    sta depth_ptr1+0
    sta depth_ptr3+0
    clc
    eor #$FF
    adc #1
    sta depth_ptr2+0
    sta depth_ptr4+0
    bcc :+
    inc depth_ptr2+1
    inc depth_ptr4+1
:
    tya                 ; Hi in Y.
    sta depth_ptr5+0
    sta depth_ptr7+0
    clc
    eor #$FF
    adc #1
    sta depth_ptr6+0
    sta depth_ptr8+0
    bcc :+
    inc depth_ptr6+1
    inc depth_ptr8+1
:
    rts
.endproc


.endif

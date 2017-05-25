.include "globals.inc"

.export setup_cos, setup_sin
.exportzp multiply_trig, trig_store
.export copy_trig_code

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
sin_table:
    .include "sin.inc"

.assert .lobyte(square1_lo) = 0, error, "misaligned table"
.assert .lobyte(square1_hi) = 0, error, "misaligned table"
.assert .lobyte(square2_lo) = 1, error, "misaligned table"
.assert .lobyte(square2_hi) = 1, error, "misaligned table"

.segment "CODE"

.if 0
setup_cos:
    clc
    adc #64
.proc setup_sin
    ldy #$FF
    cmp #128
    bcc :+
    sbc #128 
    iny
:
    sty multiplicand+1
    cmp #64
    bcc :+
    eor #$FF
    adc #128
:
    cmp #62
    bcs @one
    tay                         ; Store A in Y for later.
    lda #.hibyte(square1_lo)
    sta trig_ptr1+1
    lda #.hibyte(square2_lo)
    sta trig_ptr2+1
    lda #.hibyte(square1_hi)
    sta trig_ptr3+1
    lda #.hibyte(square2_hi)
    sta trig_ptr4+1
    lda sin_table, y            ; Use stored Y.
    sta multiplicand+0
    sta trig_ptr1+0
    sta trig_ptr3+0
    eor #$FF
    adc #1
    sta trig_ptr2+0
    sta trig_ptr4+0
    bcc :+
    inc trig_ptr2+1
    inc trig_ptr4+1
:
    rts
@one:
    lda #0
    sta trig_ptr1+0
    sta trig_ptr3+0
    sta trig_ptr2+0
    sta trig_ptr4+0
    sta multiplicand+0
    lda #.hibyte(square1_lo + 256)
    sta trig_ptr1+1
    lda #.hibyte(square2_lo - 1)
    sta trig_ptr2+1
    lda #.hibyte(square1_hi + 256)
    sta trig_ptr3+1
    lda #.hibyte(square2_hi - 1)
    sta trig_ptr4+1
    rts
.endproc

.proc multiply_trig
    ldy multiplier+1
    sec
    lda (trig_ptr1), y
    sbc (trig_ptr2), y
    sta product+0
    lda (trig_ptr3), y
    sbc (trig_ptr4), y
    sta product+1

    ldy multiplier+0
    lda (trig_ptr1), y
    cmp (trig_ptr2), y
    lda (trig_ptr3), y
    sbc (trig_ptr4), y
    clc
    adc product+0
    tay
    lda product+1
    adc #0

    bit multiplier+1
    bpl :+
    sec
    sbc multiplicand+0
:
    ;eor #$FF
    ;sta product+1
    ;dey
    ;tya
    ;eor #$FF
    ;sta product+0

    sty product+0
    sta product+1
    lda multiplicand+1
    bne return
    sec
    sbc product+0
    sta product+0
    lda #0
    sbc product+1
    sta product+1
return:
    rts
.endproc
.endif



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
    sta .lobyte(multiply_trig + (r1 - multiply_trig_code) + 1)

m:  ldx #0
q1: lda 1111, x
q2: cmp 2222, x
q3: lda 3333, x
q4: sbc 4444, x
    clc
r0: adc #0
r1: ldx #0
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

positive_one:
    lda #.hibyte(square1_lo + 256)
    sta multiply_trig + (multiply_trig_code::p1 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q1 - multiply_trig_code) + 2
    lda #.hibyte(square2_lo - 1)
    sta multiply_trig + (multiply_trig_code::p2 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q2 - multiply_trig_code) + 2
    lda #.hibyte(square1_hi + 256)
    sta multiply_trig + (multiply_trig_code::p3 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q3 - multiply_trig_code) + 2
    lda #.hibyte(square2_hi - 1)
    sta multiply_trig + (multiply_trig_code::p4 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q4 - multiply_trig_code) + 2
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
    stx multiply_trig + (multiply_trig_code::s - multiply_trig_code) - 1
    ldx #$E8          ; inx
    stx multiply_trig + (multiply_trig_code::d - multiply_trig_code) + 2
    inx               ; sbc
    stx multiply_trig + (multiply_trig_code::s - multiply_trig_code)
    ldx #$90          ; bcc
    stx multiply_trig + (multiply_trig_code::d - multiply_trig_code)
    cmp #64
    bcc :+
    eor #$FF
    adc #128
:
    cmp #62
    bcs positive_one
    tax                         ; Store A in X for later.
    lda #.hibyte(square1_lo)
    sta multiply_trig + (multiply_trig_code::p1 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q1 - multiply_trig_code) + 2
    lda #.hibyte(square2_lo)
    sta multiply_trig + (multiply_trig_code::p2 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q2 - multiply_trig_code) + 2
    lda #.hibyte(square1_hi)
    sta multiply_trig + (multiply_trig_code::p3 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q3 - multiply_trig_code) + 2
    lda #.hibyte(square2_hi)
    sta multiply_trig + (multiply_trig_code::p4 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q4 - multiply_trig_code) + 2
    lda sin_table, x            ; Use stored X.
    sta multiply_trig + (multiply_trig_code::s - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::p1 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::q1 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::p3 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::q3 - multiply_trig_code) + 1
    eor #$FF
    adc #1                      ; Carry clear from bcs.
    sta multiply_trig + (multiply_trig_code::p2 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::q2 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::p4 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::q4 - multiply_trig_code) + 1
    bcc :+
    inc multiply_trig + (multiply_trig_code::p2 - multiply_trig_code) + 2
    inc multiply_trig + (multiply_trig_code::q2 - multiply_trig_code) + 2
    inc multiply_trig + (multiply_trig_code::p4 - multiply_trig_code) + 2
    inc multiply_trig + (multiply_trig_code::q4 - multiply_trig_code) + 2
:
    rts
negative:
    sbc #128 
    beq positive
    ldx #$18          ; clc
    stx multiply_trig + (multiply_trig_code::s - multiply_trig_code) - 1
    ldx #$CA          ; dex
    stx multiply_trig + (multiply_trig_code::d - multiply_trig_code) + 2
    ldx #$69          ; adc
    stx multiply_trig + (multiply_trig_code::s - multiply_trig_code)
    ldx #$B0          ; bcs
    stx multiply_trig + (multiply_trig_code::d - multiply_trig_code)
    cmp #64
    bcc :+
    eor #$FF
    adc #128
:
    cmp #62
    bcs negative_one
    tax                         ; Store A in X for later.
    lda #.hibyte(square1_lo)
    sta multiply_trig + (multiply_trig_code::p2 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q2 - multiply_trig_code) + 2
    lda #.hibyte(square2_lo)
    sta multiply_trig + (multiply_trig_code::p1 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q1 - multiply_trig_code) + 2
    lda #.hibyte(square1_hi)
    sta multiply_trig + (multiply_trig_code::p4 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q4 - multiply_trig_code) + 2
    lda #.hibyte(square2_hi)
    sta multiply_trig + (multiply_trig_code::p3 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q3 - multiply_trig_code) + 2
    lda sin_table, x            ; Use stored X.
    sta multiply_trig + (multiply_trig_code::s - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::p2 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::q2 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::p4 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::q4 - multiply_trig_code) + 1
    eor #$FF
    adc #1                      ; Carry clear from bcs.
    sta multiply_trig + (multiply_trig_code::p1 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::q1 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::p3 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::q3 - multiply_trig_code) + 1
    bcc :+
    inc multiply_trig + (multiply_trig_code::p1 - multiply_trig_code) + 2
    inc multiply_trig + (multiply_trig_code::q1 - multiply_trig_code) + 2
    inc multiply_trig + (multiply_trig_code::p3 - multiply_trig_code) + 2
    inc multiply_trig + (multiply_trig_code::q3 - multiply_trig_code) + 2
:
    rts
negative_one:
    lda #.hibyte(square1_lo + 256)
    sta multiply_trig + (multiply_trig_code::p2 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q2 - multiply_trig_code) + 2
    lda #.hibyte(square2_lo - 1)
    sta multiply_trig + (multiply_trig_code::p1 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q1 - multiply_trig_code) + 2
    lda #.hibyte(square1_hi + 256)
    sta multiply_trig + (multiply_trig_code::p4 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q4 - multiply_trig_code) + 2
    lda #.hibyte(square2_hi - 1)
    sta multiply_trig + (multiply_trig_code::p3 - multiply_trig_code) + 2
    sta multiply_trig + (multiply_trig_code::q3 - multiply_trig_code) + 2
zero_lo:
    lda #0
    sta multiply_trig + (multiply_trig_code::s - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::p1 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::q1 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::p2 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::q2 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::p3 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::q3 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::p4 - multiply_trig_code) + 1
    sta multiply_trig + (multiply_trig_code::q4 - multiply_trig_code) + 1
    rts


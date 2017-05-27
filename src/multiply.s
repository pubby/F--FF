.include "globals.inc"

.export setup_cos, setup_sin
.exportzp multiply_trig, trig_store
.export copy_trig_code
.export setup_depth_scale

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
sin_table:
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

setup_depth_scale:
    cpx #2
    bcc positive_one
    lda #$38          ; sec
    sta trig_label s, -1
    lda #$E8          ; inx
    sta trig_label d, 2
    lda #$E9          ; inx
    sta trig_label s, 0
    lda #$90          ; bcc
    sta trig_label d, 0
    lda #$18          ; clc
    sta trig_label r0, -1
    lda #$69          ; adc
    sta trig_label r1, 0
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
    lda recriprocal_table, x
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

.proc calc_recip
    ldx foo+1
    lda ptr_table, x
    ; hibyte ready!
    lda foo+0
    and and_table, x
    ora or_table, x
    ; lobyte ready!

    tax


    lda foo+1
    bne :+
:
    lsr
    bne :+
    lda foo+0
    ror
    tax
    lda reciprocal_table, x
:
    ror foo+0
.endproc

.endproc

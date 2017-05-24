.include "globals.inc"

.export setup_cos, setup_sin
.export multiply_trig

.segment "MULT_TABLES"
square1_lo:
    .repeat 512, i
        .byt .lobyte((i*i)/4)  
    .endrepeat
square1_hi:
    .repeat 512, i
        .byt .hibyte((i*i)/4)  
    .endrepeat
    .repeat 256
        .byt .lobyte(16384)
    .endrepeat
square2_lo:
    .repeat 512, i
        .byt .lobyte(((i-255)*(i-255))/4)
    .endrepeat
    .repeat 256
        .byt .hibyte(16384)
    .endrepeat
square2_hi:
    .repeat 512, i
        .byt .hibyte(((i-255)*(i-255))/4)
    .endrepeat
sin_table:
    .include "sin.inc"

.assert .lobyte(square1_lo) = 0, error, "misaligned table"
.assert .lobyte(square1_hi) = 0, error, "misaligned table"
.assert .lobyte(square2_lo) = 0, error, "misaligned table"
.assert .lobyte(square2_hi) = 0, error, "misaligned table"

.segment "CODE"

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
    tay
    lda sin_table, y
    beq zero
    sta multiplicand+0
    sta trig_ptr1+0
    sta trig_ptr3+0
    eor #$FF
    sta trig_ptr2+0
    sta trig_ptr4+0
    lda #.hibyte(square1_lo)
    sta trig_ptr1+1
    lda #.hibyte(square2_lo)
    sta trig_ptr2+1
    lda #.hibyte(square1_hi)
    sta trig_ptr3+1
    lda #.hibyte(square2_hi)
    sta trig_ptr4+1
    rts
@one:
    ldy #0
    sty trig_ptr1+0
    sty trig_ptr3+0
    sty multiplicand+0
    dey
    sty trig_ptr2+0
    sty trig_ptr4+0
    lda #.hibyte(square1_lo + 256)
    sta trig_ptr1+1
    lda #.hibyte(square2_lo - 1)
    sta trig_ptr2+1
    lda #.hibyte(square1_hi + 256)
    sta trig_ptr3+1
    lda #.hibyte(square2_hi - 1)
    sta trig_ptr4+1
    rts
zero:
    lda #0
    sta multiplicand+0
    sta trig_ptr1+0
    sta trig_ptr3+0
    lda #$FF
    sta trig_ptr2+0
    sta trig_ptr4+0
    lda #.hibyte(square1_lo)
    sta trig_ptr1+1
    lda #.hibyte(square2_lo)
    sta trig_ptr2+1
    lda #.hibyte(square1_hi)
    sta trig_ptr3+1
    lda #.hibyte(square2_hi)
    sta trig_ptr4+1
    rts
negative:
    sbc #128 
    cmp #64
    bcc :+
    eor #$FF
    adc #128
:
    cmp #62
    bcs @one
    tay
    lda sin_table, y
    beq zero
    sta trig_ptr2+0
    sta trig_ptr4+0
    eor #$FF
    sta trig_ptr1+0
    sta trig_ptr3+0
    adc #1
    sta multiplicand+0
    lda #.hibyte(square1_lo)
    sta trig_ptr2+1
    lda #.hibyte(square2_lo)
    sta trig_ptr1+1
    lda #.hibyte(square1_hi)
    sta trig_ptr4+1
    lda #.hibyte(square2_hi)
    sta trig_ptr3+1
    lda #0
    sta multiplicand+1
    rts
@one:
    ldy #0
    sty multiplicand+0
    sty multiplicand+1
    sty trig_ptr2+0
    sty trig_ptr4+0
    dey
    sty trig_ptr1+0
    sty trig_ptr3+0
    lda #.hibyte(square1_lo + 256)
    sta trig_ptr2+1
    lda #.hibyte(square2_lo - 1)
    sta trig_ptr1+1
    lda #.hibyte(square1_hi + 256)
    sta trig_ptr4+1
    lda #.hibyte(square2_hi - 1)
    sta trig_ptr3+1
    rts
.endproc

.if 0
.proc multiply_trig_code
    ldy multiplier+1
    sec
    lda 1111, y
    sbc 2222, y
    sta product+0
    lda 3333, y
    sbc 4444, y
    tax

    ldy multiplier+0
    lda 1111, y
    cmp 2222, y
    lda 3333, y
    sbc 4444, y
    clc
    adc product+0
    sta product+0
    bcc :+
    inx
:

    bit multiplier+1
    bpl :+
    txa
    axs multiplicand
:
    dex
    stx product+1
    rts
.endproc
.endif

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


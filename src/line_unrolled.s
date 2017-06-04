.include "globals.inc"
.macro or_buffer i
        ora nt_buffer+i*32, x
        sta nt_buffer+i*32, x
.endmacro
.segment "LINE_UNROLLED"
    nop
PPxy0:
PPxy0_store___xNE:
    lda #4
    or_buffer 0
    cpx to_x
    beq PPxy0_return
    tya
    inx
    adc Dy
    bcs PPxy0_adc_SWx__
PPxy0_NWx__:
    adc Dy
    bcc PPxy0_NWxNE
    sbc rounded_Dx
PPxy0_NWxSE:
    tay
    lda #9
    or_buffer 0
    cpx to_x
    beq PPxy0_return
    tya
    inx
    adc Dy
    bcc PPxy0_SWx__
    sbc rounded_Dx
    jmp PPxy1_NWx__
PPxy0_NWxNE:
    tay
    lda #12
    or_buffer 0
    cpx to_x
    beq PPxy0_return
    tya
    inx
    adc Dy
    bcc PPxy0_NWx__
PPxy0_adc_SWx__:
    sbc rounded_Dx
PPxy0_SWx__:
    adc Dy
    bcs PPxy0_fill_SWx__
PPxy0_SWxSE:
    tay
    lda #3
PPxy0_store___xSE:
    or_buffer 0
    cpx to_x
    beq PPxy0_return
    tya
    inx
    adc Dy
    bcc PPxy0_SWx__
    sbc rounded_Dx
    jmp PPxy1_NWx__
PPxy0_return:
    rts
PPxy0___xSE:
    tay
    lda #1
    jmp PPxy0_store___xSE
PPxy0___xNE:
    tay
    jmp PPxy0_store___xNE
PPxy0_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 0
PPxy1:
PPxy1_store___xNE:
    lda #4
    or_buffer 1
    cpx to_x
    beq PPxy1_return
    tya
    inx
    adc Dy
    bcs PPxy1_adc_SWx__
PPxy1_NWx__:
    adc Dy
    bcc PPxy1_NWxNE
    sbc rounded_Dx
PPxy1_NWxSE:
    tay
    lda #9
    or_buffer 1
    cpx to_x
    beq PPxy1_return
    tya
    inx
    adc Dy
    bcc PPxy1_SWx__
    sbc rounded_Dx
    jmp PPxy2_NWx__
PPxy1_NWxNE:
    tay
    lda #12
    or_buffer 1
    cpx to_x
    beq PPxy1_return
    tya
    inx
    adc Dy
    bcc PPxy1_NWx__
PPxy1_adc_SWx__:
    sbc rounded_Dx
PPxy1_SWx__:
    adc Dy
    bcs PPxy1_fill_SWx__
PPxy1_SWxSE:
    tay
    lda #3
PPxy1_store___xSE:
    or_buffer 1
    cpx to_x
    beq PPxy1_return
    tya
    inx
    adc Dy
    bcc PPxy1_SWx__
    sbc rounded_Dx
    jmp PPxy2_NWx__
PPxy1_return:
    rts
PPxy1___xSE:
    tay
    lda #1
    jmp PPxy1_store___xSE
PPxy1___xNE:
    tay
    jmp PPxy1_store___xNE
PPxy1_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 1
PPxy2:
PPxy2_store___xNE:
    lda #4
    or_buffer 2
    cpx to_x
    beq PPxy2_return
    tya
    inx
    adc Dy
    bcs PPxy2_adc_SWx__
PPxy2_NWx__:
    adc Dy
    bcc PPxy2_NWxNE
    sbc rounded_Dx
PPxy2_NWxSE:
    tay
    lda #9
    or_buffer 2
    cpx to_x
    beq PPxy2_return
    tya
    inx
    adc Dy
    bcc PPxy2_SWx__
    sbc rounded_Dx
    jmp PPxy3_NWx__
PPxy2_NWxNE:
    tay
    lda #12
    or_buffer 2
    cpx to_x
    beq PPxy2_return
    tya
    inx
    adc Dy
    bcc PPxy2_NWx__
PPxy2_adc_SWx__:
    sbc rounded_Dx
PPxy2_SWx__:
    adc Dy
    bcs PPxy2_fill_SWx__
PPxy2_SWxSE:
    tay
    lda #3
PPxy2_store___xSE:
    or_buffer 2
    cpx to_x
    beq PPxy2_return
    tya
    inx
    adc Dy
    bcc PPxy2_SWx__
    sbc rounded_Dx
    jmp PPxy3_NWx__
PPxy2_return:
    rts
PPxy2___xSE:
    tay
    lda #1
    jmp PPxy2_store___xSE
PPxy2___xNE:
    tay
    jmp PPxy2_store___xNE
PPxy2_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 2
PPxy3:
PPxy3_store___xNE:
    lda #4
    or_buffer 3
    cpx to_x
    beq PPxy3_return
    tya
    inx
    adc Dy
    bcs PPxy3_adc_SWx__
PPxy3_NWx__:
    adc Dy
    bcc PPxy3_NWxNE
    sbc rounded_Dx
PPxy3_NWxSE:
    tay
    lda #9
    or_buffer 3
    cpx to_x
    beq PPxy3_return
    tya
    inx
    adc Dy
    bcc PPxy3_SWx__
    sbc rounded_Dx
    jmp PPxy4_NWx__
PPxy3_NWxNE:
    tay
    lda #12
    or_buffer 3
    cpx to_x
    beq PPxy3_return
    tya
    inx
    adc Dy
    bcc PPxy3_NWx__
PPxy3_adc_SWx__:
    sbc rounded_Dx
PPxy3_SWx__:
    adc Dy
    bcs PPxy3_fill_SWx__
PPxy3_SWxSE:
    tay
    lda #3
PPxy3_store___xSE:
    or_buffer 3
    cpx to_x
    beq PPxy3_return
    tya
    inx
    adc Dy
    bcc PPxy3_SWx__
    sbc rounded_Dx
    jmp PPxy4_NWx__
PPxy3_return:
    rts
PPxy3___xSE:
    tay
    lda #1
    jmp PPxy3_store___xSE
PPxy3___xNE:
    tay
    jmp PPxy3_store___xNE
PPxy3_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 3
PPxy4:
PPxy4_store___xNE:
    lda #4
    or_buffer 4
    cpx to_x
    beq PPxy4_return
    tya
    inx
    adc Dy
    bcs PPxy4_adc_SWx__
PPxy4_NWx__:
    adc Dy
    bcc PPxy4_NWxNE
    sbc rounded_Dx
PPxy4_NWxSE:
    tay
    lda #9
    or_buffer 4
    cpx to_x
    beq PPxy4_return
    tya
    inx
    adc Dy
    bcc PPxy4_SWx__
    sbc rounded_Dx
    jmp PPxy5_NWx__
PPxy4_NWxNE:
    tay
    lda #12
    or_buffer 4
    cpx to_x
    beq PPxy4_return
    tya
    inx
    adc Dy
    bcc PPxy4_NWx__
PPxy4_adc_SWx__:
    sbc rounded_Dx
PPxy4_SWx__:
    adc Dy
    bcs PPxy4_fill_SWx__
PPxy4_SWxSE:
    tay
    lda #3
PPxy4_store___xSE:
    or_buffer 4
    cpx to_x
    beq PPxy4_return
    tya
    inx
    adc Dy
    bcc PPxy4_SWx__
    sbc rounded_Dx
    jmp PPxy5_NWx__
PPxy4_return:
    rts
PPxy4___xSE:
    tay
    lda #1
    jmp PPxy4_store___xSE
PPxy4___xNE:
    tay
    jmp PPxy4_store___xNE
PPxy4_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 4
PPxy5:
PPxy5_store___xNE:
    lda #4
    or_buffer 5
    cpx to_x
    beq PPxy5_return
    tya
    inx
    adc Dy
    bcs PPxy5_adc_SWx__
PPxy5_NWx__:
    adc Dy
    bcc PPxy5_NWxNE
    sbc rounded_Dx
PPxy5_NWxSE:
    tay
    lda #9
    or_buffer 5
    cpx to_x
    beq PPxy5_return
    tya
    inx
    adc Dy
    bcc PPxy5_SWx__
    sbc rounded_Dx
    jmp PPxy6_NWx__
PPxy5_NWxNE:
    tay
    lda #12
    or_buffer 5
    cpx to_x
    beq PPxy5_return
    tya
    inx
    adc Dy
    bcc PPxy5_NWx__
PPxy5_adc_SWx__:
    sbc rounded_Dx
PPxy5_SWx__:
    adc Dy
    bcs PPxy5_fill_SWx__
PPxy5_SWxSE:
    tay
    lda #3
PPxy5_store___xSE:
    or_buffer 5
    cpx to_x
    beq PPxy5_return
    tya
    inx
    adc Dy
    bcc PPxy5_SWx__
    sbc rounded_Dx
    jmp PPxy6_NWx__
PPxy5_return:
    rts
PPxy5___xSE:
    tay
    lda #1
    jmp PPxy5_store___xSE
PPxy5___xNE:
    tay
    jmp PPxy5_store___xNE
PPxy5_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 5
PPxy6:
PPxy6_store___xNE:
    lda #4
    or_buffer 6
    cpx to_x
    beq PPxy6_return
    tya
    inx
    adc Dy
    bcs PPxy6_adc_SWx__
PPxy6_NWx__:
    adc Dy
    bcc PPxy6_NWxNE
    sbc rounded_Dx
PPxy6_NWxSE:
    tay
    lda #9
    or_buffer 6
    cpx to_x
    beq PPxy6_return
    tya
    inx
    adc Dy
    bcc PPxy6_SWx__
    sbc rounded_Dx
    jmp PPxy7_NWx__
PPxy6_NWxNE:
    tay
    lda #12
    or_buffer 6
    cpx to_x
    beq PPxy6_return
    tya
    inx
    adc Dy
    bcc PPxy6_NWx__
PPxy6_adc_SWx__:
    sbc rounded_Dx
PPxy6_SWx__:
    adc Dy
    bcs PPxy6_fill_SWx__
PPxy6_SWxSE:
    tay
    lda #3
PPxy6_store___xSE:
    or_buffer 6
    cpx to_x
    beq PPxy6_return
    tya
    inx
    adc Dy
    bcc PPxy6_SWx__
    sbc rounded_Dx
    jmp PPxy7_NWx__
PPxy6_return:
    rts
PPxy6___xSE:
    tay
    lda #1
    jmp PPxy6_store___xSE
PPxy6___xNE:
    tay
    jmp PPxy6_store___xNE
PPxy6_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 6
PPxy7:
PPxy7_store___xNE:
    lda #4
    or_buffer 7
    cpx to_x
    beq PPxy7_return
    tya
    inx
    adc Dy
    bcs PPxy7_adc_SWx__
PPxy7_NWx__:
    adc Dy
    bcc PPxy7_NWxNE
    sbc rounded_Dx
PPxy7_NWxSE:
    tay
    lda #9
    or_buffer 7
    cpx to_x
    beq PPxy7_return
    tya
    inx
    adc Dy
    bcc PPxy7_SWx__
    sbc rounded_Dx
    jmp PPxy8_NWx__
PPxy7_NWxNE:
    tay
    lda #12
    or_buffer 7
    cpx to_x
    beq PPxy7_return
    tya
    inx
    adc Dy
    bcc PPxy7_NWx__
PPxy7_adc_SWx__:
    sbc rounded_Dx
PPxy7_SWx__:
    adc Dy
    bcs PPxy7_fill_SWx__
PPxy7_SWxSE:
    tay
    lda #3
PPxy7_store___xSE:
    or_buffer 7
    cpx to_x
    beq PPxy7_return
    tya
    inx
    adc Dy
    bcc PPxy7_SWx__
    sbc rounded_Dx
    jmp PPxy8_NWx__
PPxy7_return:
    rts
PPxy7___xSE:
    tay
    lda #1
    jmp PPxy7_store___xSE
PPxy7___xNE:
    tay
    jmp PPxy7_store___xNE
PPxy7_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 7
PPxy8:
PPxy8_store___xNE:
    lda #4
    or_buffer 8
    cpx to_x
    beq PPxy8_return
    tya
    inx
    adc Dy
    bcs PPxy8_adc_SWx__
PPxy8_NWx__:
    adc Dy
    bcc PPxy8_NWxNE
    sbc rounded_Dx
PPxy8_NWxSE:
    tay
    lda #9
    or_buffer 8
    cpx to_x
    beq PPxy8_return
    tya
    inx
    adc Dy
    bcc PPxy8_SWx__
    sbc rounded_Dx
    jmp PPxy9_NWx__
PPxy8_NWxNE:
    tay
    lda #12
    or_buffer 8
    cpx to_x
    beq PPxy8_return
    tya
    inx
    adc Dy
    bcc PPxy8_NWx__
PPxy8_adc_SWx__:
    sbc rounded_Dx
PPxy8_SWx__:
    adc Dy
    bcs PPxy8_fill_SWx__
PPxy8_SWxSE:
    tay
    lda #3
PPxy8_store___xSE:
    or_buffer 8
    cpx to_x
    beq PPxy8_return
    tya
    inx
    adc Dy
    bcc PPxy8_SWx__
    sbc rounded_Dx
    jmp PPxy9_NWx__
PPxy8_return:
    rts
PPxy8___xSE:
    tay
    lda #1
    jmp PPxy8_store___xSE
PPxy8___xNE:
    tay
    jmp PPxy8_store___xNE
PPxy8_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 8
PPxy9:
PPxy9_store___xNE:
    lda #4
    or_buffer 9
    cpx to_x
    beq PPxy9_return
    tya
    inx
    adc Dy
    bcs PPxy9_adc_SWx__
PPxy9_NWx__:
    adc Dy
    bcc PPxy9_NWxNE
    sbc rounded_Dx
PPxy9_NWxSE:
    tay
    lda #9
    or_buffer 9
    cpx to_x
    beq PPxy9_return
    tya
    inx
    adc Dy
    bcc PPxy9_SWx__
    sbc rounded_Dx
    jmp PPxy10_NWx__
PPxy9_NWxNE:
    tay
    lda #12
    or_buffer 9
    cpx to_x
    beq PPxy9_return
    tya
    inx
    adc Dy
    bcc PPxy9_NWx__
PPxy9_adc_SWx__:
    sbc rounded_Dx
PPxy9_SWx__:
    adc Dy
    bcs PPxy9_fill_SWx__
PPxy9_SWxSE:
    tay
    lda #3
PPxy9_store___xSE:
    or_buffer 9
    cpx to_x
    beq PPxy9_return
    tya
    inx
    adc Dy
    bcc PPxy9_SWx__
    sbc rounded_Dx
    jmp PPxy10_NWx__
PPxy9_return:
    rts
PPxy9___xSE:
    tay
    lda #1
    jmp PPxy9_store___xSE
PPxy9___xNE:
    tay
    jmp PPxy9_store___xNE
PPxy9_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 9
PPxy10:
PPxy10_store___xNE:
    lda #4
    or_buffer 10
    cpx to_x
    beq PPxy10_return
    tya
    inx
    adc Dy
    bcs PPxy10_adc_SWx__
PPxy10_NWx__:
    adc Dy
    bcc PPxy10_NWxNE
    sbc rounded_Dx
PPxy10_NWxSE:
    tay
    lda #9
    or_buffer 10
    cpx to_x
    beq PPxy10_return
    tya
    inx
    adc Dy
    bcc PPxy10_SWx__
    sbc rounded_Dx
    jmp PPxy11_NWx__
PPxy10_NWxNE:
    tay
    lda #12
    or_buffer 10
    cpx to_x
    beq PPxy10_return
    tya
    inx
    adc Dy
    bcc PPxy10_NWx__
PPxy10_adc_SWx__:
    sbc rounded_Dx
PPxy10_SWx__:
    adc Dy
    bcs PPxy10_fill_SWx__
PPxy10_SWxSE:
    tay
    lda #3
PPxy10_store___xSE:
    or_buffer 10
    cpx to_x
    beq PPxy10_return
    tya
    inx
    adc Dy
    bcc PPxy10_SWx__
    sbc rounded_Dx
    jmp PPxy11_NWx__
PPxy10_return:
    rts
PPxy10___xSE:
    tay
    lda #1
    jmp PPxy10_store___xSE
PPxy10___xNE:
    tay
    jmp PPxy10_store___xNE
PPxy10_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 10
PPxy11:
PPxy11_store___xNE:
    lda #4
    or_buffer 11
    cpx to_x
    beq PPxy11_return
    tya
    inx
    adc Dy
    bcs PPxy11_adc_SWx__
PPxy11_NWx__:
    adc Dy
    bcc PPxy11_NWxNE
    sbc rounded_Dx
PPxy11_NWxSE:
    tay
    lda #9
    or_buffer 11
    cpx to_x
    beq PPxy11_return
    tya
    inx
    adc Dy
    bcc PPxy11_SWx__
    sbc rounded_Dx
    jmp PPxy12_NWx__
PPxy11_NWxNE:
    tay
    lda #12
    or_buffer 11
    cpx to_x
    beq PPxy11_return
    tya
    inx
    adc Dy
    bcc PPxy11_NWx__
PPxy11_adc_SWx__:
    sbc rounded_Dx
PPxy11_SWx__:
    adc Dy
    bcs PPxy11_fill_SWx__
PPxy11_SWxSE:
    tay
    lda #3
PPxy11_store___xSE:
    or_buffer 11
    cpx to_x
    beq PPxy11_return
    tya
    inx
    adc Dy
    bcc PPxy11_SWx__
    sbc rounded_Dx
    jmp PPxy12_NWx__
PPxy11_return:
    rts
PPxy11___xSE:
    tay
    lda #1
    jmp PPxy11_store___xSE
PPxy11___xNE:
    tay
    jmp PPxy11_store___xNE
PPxy11_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 11
PPxy12:
PPxy12_store___xNE:
    lda #4
    or_buffer 12
    cpx to_x
    beq PPxy12_return
    tya
    inx
    adc Dy
    bcs PPxy12_adc_SWx__
PPxy12_NWx__:
    adc Dy
    bcc PPxy12_NWxNE
    sbc rounded_Dx
PPxy12_NWxSE:
    tay
    lda #9
    or_buffer 12
    cpx to_x
    beq PPxy12_return
    tya
    inx
    adc Dy
    bcc PPxy12_SWx__
    sbc rounded_Dx
    jmp PPxy13_NWx__
PPxy12_NWxNE:
    tay
    lda #12
    or_buffer 12
    cpx to_x
    beq PPxy12_return
    tya
    inx
    adc Dy
    bcc PPxy12_NWx__
PPxy12_adc_SWx__:
    sbc rounded_Dx
PPxy12_SWx__:
    adc Dy
    bcs PPxy12_fill_SWx__
PPxy12_SWxSE:
    tay
    lda #3
PPxy12_store___xSE:
    or_buffer 12
    cpx to_x
    beq PPxy12_return
    tya
    inx
    adc Dy
    bcc PPxy12_SWx__
    sbc rounded_Dx
    jmp PPxy13_NWx__
PPxy12_return:
    rts
PPxy12___xSE:
    tay
    lda #1
    jmp PPxy12_store___xSE
PPxy12___xNE:
    tay
    jmp PPxy12_store___xNE
PPxy12_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 12
PPxy13:
PPxy13_store___xNE:
    lda #4
    or_buffer 13
    cpx to_x
    beq PPxy13_return
    tya
    inx
    adc Dy
    bcs PPxy13_adc_SWx__
PPxy13_NWx__:
    adc Dy
    bcc PPxy13_NWxNE
    sbc rounded_Dx
PPxy13_NWxSE:
    tay
    lda #9
    or_buffer 13
    cpx to_x
    beq PPxy13_return
    tya
    inx
    adc Dy
    bcc PPxy13_SWx__
    sbc rounded_Dx
    jmp PPxy14_NWx__
PPxy13_NWxNE:
    tay
    lda #12
    or_buffer 13
    cpx to_x
    beq PPxy13_return
    tya
    inx
    adc Dy
    bcc PPxy13_NWx__
PPxy13_adc_SWx__:
    sbc rounded_Dx
PPxy13_SWx__:
    adc Dy
    bcs PPxy13_fill_SWx__
PPxy13_SWxSE:
    tay
    lda #3
PPxy13_store___xSE:
    or_buffer 13
    cpx to_x
    beq PPxy13_return
    tya
    inx
    adc Dy
    bcc PPxy13_SWx__
    sbc rounded_Dx
    jmp PPxy14_NWx__
PPxy13_return:
    rts
PPxy13___xSE:
    tay
    lda #1
    jmp PPxy13_store___xSE
PPxy13___xNE:
    tay
    jmp PPxy13_store___xNE
PPxy13_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 13
PPxy14:
PPxy14_store___xNE:
    lda #4
    or_buffer 14
    cpx to_x
    beq PPxy14_return
    tya
    inx
    adc Dy
    bcs PPxy14_adc_SWx__
PPxy14_NWx__:
    adc Dy
    bcc PPxy14_NWxNE
    sbc rounded_Dx
PPxy14_NWxSE:
    tay
    lda #9
    or_buffer 14
    cpx to_x
    beq PPxy14_return
    tya
    inx
    adc Dy
    bcc PPxy14_SWx__
    sbc rounded_Dx
    jmp PPxy15_NWx__
PPxy14_NWxNE:
    tay
    lda #12
    or_buffer 14
    cpx to_x
    beq PPxy14_return
    tya
    inx
    adc Dy
    bcc PPxy14_NWx__
PPxy14_adc_SWx__:
    sbc rounded_Dx
PPxy14_SWx__:
    adc Dy
    bcs PPxy14_fill_SWx__
PPxy14_SWxSE:
    tay
    lda #3
PPxy14_store___xSE:
    or_buffer 14
    cpx to_x
    beq PPxy14_return
    tya
    inx
    adc Dy
    bcc PPxy14_SWx__
    sbc rounded_Dx
    jmp PPxy15_NWx__
PPxy14_return:
    rts
PPxy14___xSE:
    tay
    lda #1
    jmp PPxy14_store___xSE
PPxy14___xNE:
    tay
    jmp PPxy14_store___xNE
PPxy14_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 14
PPxy15:
PPxy15_store___xNE:
    lda #4
    or_buffer 15
    cpx to_x
    beq PPxy15_return
    tya
    inx
    adc Dy
    bcs PPxy15_adc_SWx__
PPxy15_NWx__:
    adc Dy
    bcc PPxy15_NWxNE
    sbc rounded_Dx
PPxy15_NWxSE:
    tay
    lda #9
    or_buffer 15
    cpx to_x
    beq PPxy15_return
    tya
    inx
    adc Dy
    bcc PPxy15_SWx__
    sbc rounded_Dx
    jmp PPxy16_NWx__
PPxy15_NWxNE:
    tay
    lda #12
    or_buffer 15
    cpx to_x
    beq PPxy15_return
    tya
    inx
    adc Dy
    bcc PPxy15_NWx__
PPxy15_adc_SWx__:
    sbc rounded_Dx
PPxy15_SWx__:
    adc Dy
    bcs PPxy15_fill_SWx__
PPxy15_SWxSE:
    tay
    lda #3
PPxy15_store___xSE:
    or_buffer 15
    cpx to_x
    beq PPxy15_return
    tya
    inx
    adc Dy
    bcc PPxy15_SWx__
    sbc rounded_Dx
    jmp PPxy16_NWx__
PPxy15_return:
    rts
PPxy15___xSE:
    tay
    lda #1
    jmp PPxy15_store___xSE
PPxy15___xNE:
    tay
    jmp PPxy15_store___xNE
PPxy15_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 15
PPxy16:
PPxy16_store___xNE:
    lda #4
    or_buffer 16
    cpx to_x
    beq PPxy16_return
    tya
    inx
    adc Dy
    bcs PPxy16_adc_SWx__
PPxy16_NWx__:
    adc Dy
    bcc PPxy16_NWxNE
    sbc rounded_Dx
PPxy16_NWxSE:
    tay
    lda #9
    or_buffer 16
    cpx to_x
    beq PPxy16_return
    tya
    inx
    adc Dy
    bcc PPxy16_SWx__
    sbc rounded_Dx
    jmp PPxy17_NWx__
PPxy16_NWxNE:
    tay
    lda #12
    or_buffer 16
    cpx to_x
    beq PPxy16_return
    tya
    inx
    adc Dy
    bcc PPxy16_NWx__
PPxy16_adc_SWx__:
    sbc rounded_Dx
PPxy16_SWx__:
    adc Dy
    bcs PPxy16_fill_SWx__
PPxy16_SWxSE:
    tay
    lda #3
PPxy16_store___xSE:
    or_buffer 16
    cpx to_x
    beq PPxy16_return
    tya
    inx
    adc Dy
    bcc PPxy16_SWx__
    sbc rounded_Dx
    jmp PPxy17_NWx__
PPxy16_return:
    rts
PPxy16___xSE:
    tay
    lda #1
    jmp PPxy16_store___xSE
PPxy16___xNE:
    tay
    jmp PPxy16_store___xNE
PPxy16_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 16
PPxy17:
PPxy17_store___xNE:
    lda #4
    or_buffer 17
    cpx to_x
    beq PPxy17_return
    tya
    inx
    adc Dy
    bcs PPxy17_adc_SWx__
PPxy17_NWx__:
    adc Dy
    bcc PPxy17_NWxNE
    sbc rounded_Dx
PPxy17_NWxSE:
    tay
    lda #9
    or_buffer 17
    cpx to_x
    beq PPxy17_return
    tya
    inx
    adc Dy
    bcc PPxy17_SWx__
    sbc rounded_Dx
    jmp PPxy18_NWx__
PPxy17_NWxNE:
    tay
    lda #12
    or_buffer 17
    cpx to_x
    beq PPxy17_return
    tya
    inx
    adc Dy
    bcc PPxy17_NWx__
PPxy17_adc_SWx__:
    sbc rounded_Dx
PPxy17_SWx__:
    adc Dy
    bcs PPxy17_fill_SWx__
PPxy17_SWxSE:
    tay
    lda #3
PPxy17_store___xSE:
    or_buffer 17
    cpx to_x
    beq PPxy17_return
    tya
    inx
    adc Dy
    bcc PPxy17_SWx__
    sbc rounded_Dx
    jmp PPxy18_NWx__
PPxy17_return:
    rts
PPxy17___xSE:
    tay
    lda #1
    jmp PPxy17_store___xSE
PPxy17___xNE:
    tay
    jmp PPxy17_store___xNE
PPxy17_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 17
PPxy18:
PPxy18_store___xNE:
    lda #4
    or_buffer 18
    cpx to_x
    beq PPxy18_return
    tya
    inx
    adc Dy
    bcs PPxy18_adc_SWx__
PPxy18_NWx__:
    adc Dy
    bcc PPxy18_NWxNE
    sbc rounded_Dx
PPxy18_NWxSE:
    tay
    lda #9
    or_buffer 18
    cpx to_x
    beq PPxy18_return
    tya
    inx
    adc Dy
    bcc PPxy18_SWx__
    sbc rounded_Dx
    jmp PPxy19_NWx__
PPxy18_NWxNE:
    tay
    lda #12
    or_buffer 18
    cpx to_x
    beq PPxy18_return
    tya
    inx
    adc Dy
    bcc PPxy18_NWx__
PPxy18_adc_SWx__:
    sbc rounded_Dx
PPxy18_SWx__:
    adc Dy
    bcs PPxy18_fill_SWx__
PPxy18_SWxSE:
    tay
    lda #3
PPxy18_store___xSE:
    or_buffer 18
    cpx to_x
    beq PPxy18_return
    tya
    inx
    adc Dy
    bcc PPxy18_SWx__
    sbc rounded_Dx
    jmp PPxy19_NWx__
PPxy18_return:
    rts
PPxy18___xSE:
    tay
    lda #1
    jmp PPxy18_store___xSE
PPxy18___xNE:
    tay
    jmp PPxy18_store___xNE
PPxy18_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 18
PPxy19:
PPxy19_store___xNE:
    lda #4
    or_buffer 19
    cpx to_x
    beq PPxy19_return
    tya
    inx
    adc Dy
    bcs PPxy19_adc_SWx__
PPxy19_NWx__:
    adc Dy
    bcc PPxy19_NWxNE
    sbc rounded_Dx
PPxy19_NWxSE:
    tay
    lda #9
    or_buffer 19
    cpx to_x
    beq PPxy19_return
    tya
    inx
    adc Dy
    bcc PPxy19_SWx__
    sbc rounded_Dx
    jmp PPxy20_NWx__
PPxy19_NWxNE:
    tay
    lda #12
    or_buffer 19
    cpx to_x
    beq PPxy19_return
    tya
    inx
    adc Dy
    bcc PPxy19_NWx__
PPxy19_adc_SWx__:
    sbc rounded_Dx
PPxy19_SWx__:
    adc Dy
    bcs PPxy19_fill_SWx__
PPxy19_SWxSE:
    tay
    lda #3
PPxy19_store___xSE:
    or_buffer 19
    cpx to_x
    beq PPxy19_return
    tya
    inx
    adc Dy
    bcc PPxy19_SWx__
    sbc rounded_Dx
    jmp PPxy20_NWx__
PPxy19_return:
    rts
PPxy19___xSE:
    tay
    lda #1
    jmp PPxy19_store___xSE
PPxy19___xNE:
    tay
    jmp PPxy19_store___xNE
PPxy19_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 19
PPxy20:
PPxy20_store___xNE:
    lda #4
    or_buffer 20
    cpx to_x
    beq PPxy20_return
    tya
    inx
    adc Dy
    bcs PPxy20_adc_SWx__
PPxy20_NWx__:
    adc Dy
    bcc PPxy20_NWxNE
    sbc rounded_Dx
PPxy20_NWxSE:
    tay
    lda #9
    or_buffer 20
    cpx to_x
    beq PPxy20_return
    tya
    inx
    adc Dy
    bcc PPxy20_SWx__
    sbc rounded_Dx
    jmp PPxy21_NWx__
PPxy20_NWxNE:
    tay
    lda #12
    or_buffer 20
    cpx to_x
    beq PPxy20_return
    tya
    inx
    adc Dy
    bcc PPxy20_NWx__
PPxy20_adc_SWx__:
    sbc rounded_Dx
PPxy20_SWx__:
    adc Dy
    bcs PPxy20_fill_SWx__
PPxy20_SWxSE:
    tay
    lda #3
PPxy20_store___xSE:
    or_buffer 20
    cpx to_x
    beq PPxy20_return
    tya
    inx
    adc Dy
    bcc PPxy20_SWx__
    sbc rounded_Dx
    jmp PPxy21_NWx__
PPxy20_return:
    rts
PPxy20___xSE:
    tay
    lda #1
    jmp PPxy20_store___xSE
PPxy20___xNE:
    tay
    jmp PPxy20_store___xNE
PPxy20_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 20
PPxy21:
PPxy21_store___xNE:
    lda #4
    or_buffer 21
    cpx to_x
    beq PPxy21_return
    tya
    inx
    adc Dy
    bcs PPxy21_adc_SWx__
PPxy21_NWx__:
    adc Dy
    bcc PPxy21_NWxNE
    sbc rounded_Dx
PPxy21_NWxSE:
    tay
    lda #9
    or_buffer 21
    cpx to_x
    beq PPxy21_return
    tya
    inx
    adc Dy
    bcc PPxy21_SWx__
    rts
    nop
    nop
    nop
    nop
PPxy21_NWxNE:
    tay
    lda #12
    or_buffer 21
    cpx to_x
    beq PPxy21_return
    tya
    inx
    adc Dy
    bcc PPxy21_NWx__
PPxy21_adc_SWx__:
    sbc rounded_Dx
PPxy21_SWx__:
    adc Dy
    bcs PPxy21_fill_SWx__
PPxy21_SWxSE:
    tay
    lda #3
PPxy21_store___xSE:
    or_buffer 21
    cpx to_x
    beq PPxy21_return
    tya
    inx
    adc Dy
    bcc PPxy21_SWx__
    rts
    nop
    nop
    nop
    nop
PPxy21_return:
    rts
PPxy21___xSE:
    tay
    lda #1
    jmp PPxy21_store___xSE
PPxy21___xNE:
    tay
    jmp PPxy21_store___xNE
PPxy21_fill_SWx__:
    sbc rounded_Dx
    tay
    lda #2
    or_buffer 21
    rts
    nop
    nop
PPyx0:
PPyx0_adc_NWx__:
    adc rounded_Dy
    inx
PPyx0_NWx__:
    sbc Dx
    bcs PPyx0_NWxSW
    adc rounded_Dy
PPyx0_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 0
    dey
    beq PPyx0_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx1_adc_NWx__
    jmp PPyx1_NEx__
PPyx0_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 0
    dey
    beq PPyx0_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx1_NWx__
    adc rounded_Dy
    jmp PPyx1_NEx__
PPyx0_adc_NEx__:
    adc rounded_Dy
PPyx0_NEx__:
    sbc Dx
    bcc PPyx0_fill_NEx__
PPyx0_NExSE:
    sta subroutine_temp
    lda #5
PPyx0_store___xSE:
    or_buffer 0
    dey
    beq PPyx0_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx1_NEx__
    adc rounded_Dy
    inx
    jmp PPyx1_NWx__
PPyx0_return:
    rts
PPyx0___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx0_store___xSE
PPyx0_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 0
    inx
PPyx0___xSW:
    lda #2
    or_buffer 0
    dey
    beq PPyx0_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx1_NWx__
    adc rounded_Dy
    jmp PPyx1_NEx__
PPyx1:
PPyx1_adc_NWx__:
    adc rounded_Dy
    inx
PPyx1_NWx__:
    sbc Dx
    bcs PPyx1_NWxSW
    adc rounded_Dy
PPyx1_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 1
    dey
    beq PPyx1_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx2_adc_NWx__
    jmp PPyx2_NEx__
PPyx1_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 1
    dey
    beq PPyx1_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx2_NWx__
    adc rounded_Dy
    jmp PPyx2_NEx__
PPyx1_adc_NEx__:
    adc rounded_Dy
PPyx1_NEx__:
    sbc Dx
    bcc PPyx1_fill_NEx__
PPyx1_NExSE:
    sta subroutine_temp
    lda #5
PPyx1_store___xSE:
    or_buffer 1
    dey
    beq PPyx1_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx2_NEx__
    adc rounded_Dy
    inx
    jmp PPyx2_NWx__
PPyx1_return:
    rts
PPyx1___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx1_store___xSE
PPyx1_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 1
    inx
PPyx1___xSW:
    lda #2
    or_buffer 1
    dey
    beq PPyx1_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx2_NWx__
    adc rounded_Dy
    jmp PPyx2_NEx__
PPyx2:
PPyx2_adc_NWx__:
    adc rounded_Dy
    inx
PPyx2_NWx__:
    sbc Dx
    bcs PPyx2_NWxSW
    adc rounded_Dy
PPyx2_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 2
    dey
    beq PPyx2_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx3_adc_NWx__
    jmp PPyx3_NEx__
PPyx2_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 2
    dey
    beq PPyx2_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx3_NWx__
    adc rounded_Dy
    jmp PPyx3_NEx__
PPyx2_adc_NEx__:
    adc rounded_Dy
PPyx2_NEx__:
    sbc Dx
    bcc PPyx2_fill_NEx__
PPyx2_NExSE:
    sta subroutine_temp
    lda #5
PPyx2_store___xSE:
    or_buffer 2
    dey
    beq PPyx2_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx3_NEx__
    adc rounded_Dy
    inx
    jmp PPyx3_NWx__
PPyx2_return:
    rts
PPyx2___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx2_store___xSE
PPyx2_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 2
    inx
PPyx2___xSW:
    lda #2
    or_buffer 2
    dey
    beq PPyx2_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx3_NWx__
    adc rounded_Dy
    jmp PPyx3_NEx__
PPyx3:
PPyx3_adc_NWx__:
    adc rounded_Dy
    inx
PPyx3_NWx__:
    sbc Dx
    bcs PPyx3_NWxSW
    adc rounded_Dy
PPyx3_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 3
    dey
    beq PPyx3_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx4_adc_NWx__
    jmp PPyx4_NEx__
PPyx3_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 3
    dey
    beq PPyx3_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx4_NWx__
    adc rounded_Dy
    jmp PPyx4_NEx__
PPyx3_adc_NEx__:
    adc rounded_Dy
PPyx3_NEx__:
    sbc Dx
    bcc PPyx3_fill_NEx__
PPyx3_NExSE:
    sta subroutine_temp
    lda #5
PPyx3_store___xSE:
    or_buffer 3
    dey
    beq PPyx3_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx4_NEx__
    adc rounded_Dy
    inx
    jmp PPyx4_NWx__
PPyx3_return:
    rts
PPyx3___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx3_store___xSE
PPyx3_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 3
    inx
PPyx3___xSW:
    lda #2
    or_buffer 3
    dey
    beq PPyx3_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx4_NWx__
    adc rounded_Dy
    jmp PPyx4_NEx__
PPyx4:
PPyx4_adc_NWx__:
    adc rounded_Dy
    inx
PPyx4_NWx__:
    sbc Dx
    bcs PPyx4_NWxSW
    adc rounded_Dy
PPyx4_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 4
    dey
    beq PPyx4_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx5_adc_NWx__
    jmp PPyx5_NEx__
PPyx4_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 4
    dey
    beq PPyx4_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx5_NWx__
    adc rounded_Dy
    jmp PPyx5_NEx__
PPyx4_adc_NEx__:
    adc rounded_Dy
PPyx4_NEx__:
    sbc Dx
    bcc PPyx4_fill_NEx__
PPyx4_NExSE:
    sta subroutine_temp
    lda #5
PPyx4_store___xSE:
    or_buffer 4
    dey
    beq PPyx4_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx5_NEx__
    adc rounded_Dy
    inx
    jmp PPyx5_NWx__
PPyx4_return:
    rts
PPyx4___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx4_store___xSE
PPyx4_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 4
    inx
PPyx4___xSW:
    lda #2
    or_buffer 4
    dey
    beq PPyx4_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx5_NWx__
    adc rounded_Dy
    jmp PPyx5_NEx__
PPyx5:
PPyx5_adc_NWx__:
    adc rounded_Dy
    inx
PPyx5_NWx__:
    sbc Dx
    bcs PPyx5_NWxSW
    adc rounded_Dy
PPyx5_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 5
    dey
    beq PPyx5_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx6_adc_NWx__
    jmp PPyx6_NEx__
PPyx5_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 5
    dey
    beq PPyx5_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx6_NWx__
    adc rounded_Dy
    jmp PPyx6_NEx__
PPyx5_adc_NEx__:
    adc rounded_Dy
PPyx5_NEx__:
    sbc Dx
    bcc PPyx5_fill_NEx__
PPyx5_NExSE:
    sta subroutine_temp
    lda #5
PPyx5_store___xSE:
    or_buffer 5
    dey
    beq PPyx5_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx6_NEx__
    adc rounded_Dy
    inx
    jmp PPyx6_NWx__
PPyx5_return:
    rts
PPyx5___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx5_store___xSE
PPyx5_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 5
    inx
PPyx5___xSW:
    lda #2
    or_buffer 5
    dey
    beq PPyx5_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx6_NWx__
    adc rounded_Dy
    jmp PPyx6_NEx__
PPyx6:
PPyx6_adc_NWx__:
    adc rounded_Dy
    inx
PPyx6_NWx__:
    sbc Dx
    bcs PPyx6_NWxSW
    adc rounded_Dy
PPyx6_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 6
    dey
    beq PPyx6_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx7_adc_NWx__
    jmp PPyx7_NEx__
PPyx6_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 6
    dey
    beq PPyx6_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx7_NWx__
    adc rounded_Dy
    jmp PPyx7_NEx__
PPyx6_adc_NEx__:
    adc rounded_Dy
PPyx6_NEx__:
    sbc Dx
    bcc PPyx6_fill_NEx__
PPyx6_NExSE:
    sta subroutine_temp
    lda #5
PPyx6_store___xSE:
    or_buffer 6
    dey
    beq PPyx6_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx7_NEx__
    adc rounded_Dy
    inx
    jmp PPyx7_NWx__
PPyx6_return:
    rts
PPyx6___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx6_store___xSE
PPyx6_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 6
    inx
PPyx6___xSW:
    lda #2
    or_buffer 6
    dey
    beq PPyx6_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx7_NWx__
    adc rounded_Dy
    jmp PPyx7_NEx__
PPyx7:
PPyx7_adc_NWx__:
    adc rounded_Dy
    inx
PPyx7_NWx__:
    sbc Dx
    bcs PPyx7_NWxSW
    adc rounded_Dy
PPyx7_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 7
    dey
    beq PPyx7_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx8_adc_NWx__
    jmp PPyx8_NEx__
PPyx7_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 7
    dey
    beq PPyx7_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx8_NWx__
    adc rounded_Dy
    jmp PPyx8_NEx__
PPyx7_adc_NEx__:
    adc rounded_Dy
PPyx7_NEx__:
    sbc Dx
    bcc PPyx7_fill_NEx__
PPyx7_NExSE:
    sta subroutine_temp
    lda #5
PPyx7_store___xSE:
    or_buffer 7
    dey
    beq PPyx7_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx8_NEx__
    adc rounded_Dy
    inx
    jmp PPyx8_NWx__
PPyx7_return:
    rts
PPyx7___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx7_store___xSE
PPyx7_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 7
    inx
PPyx7___xSW:
    lda #2
    or_buffer 7
    dey
    beq PPyx7_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx8_NWx__
    adc rounded_Dy
    jmp PPyx8_NEx__
PPyx8:
PPyx8_adc_NWx__:
    adc rounded_Dy
    inx
PPyx8_NWx__:
    sbc Dx
    bcs PPyx8_NWxSW
    adc rounded_Dy
PPyx8_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 8
    dey
    beq PPyx8_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx9_adc_NWx__
    jmp PPyx9_NEx__
PPyx8_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 8
    dey
    beq PPyx8_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx9_NWx__
    adc rounded_Dy
    jmp PPyx9_NEx__
PPyx8_adc_NEx__:
    adc rounded_Dy
PPyx8_NEx__:
    sbc Dx
    bcc PPyx8_fill_NEx__
PPyx8_NExSE:
    sta subroutine_temp
    lda #5
PPyx8_store___xSE:
    or_buffer 8
    dey
    beq PPyx8_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx9_NEx__
    adc rounded_Dy
    inx
    jmp PPyx9_NWx__
PPyx8_return:
    rts
PPyx8___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx8_store___xSE
PPyx8_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 8
    inx
PPyx8___xSW:
    lda #2
    or_buffer 8
    dey
    beq PPyx8_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx9_NWx__
    adc rounded_Dy
    jmp PPyx9_NEx__
PPyx9:
PPyx9_adc_NWx__:
    adc rounded_Dy
    inx
PPyx9_NWx__:
    sbc Dx
    bcs PPyx9_NWxSW
    adc rounded_Dy
PPyx9_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 9
    dey
    beq PPyx9_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx10_adc_NWx__
    jmp PPyx10_NEx__
PPyx9_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 9
    dey
    beq PPyx9_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx10_NWx__
    adc rounded_Dy
    jmp PPyx10_NEx__
PPyx9_adc_NEx__:
    adc rounded_Dy
PPyx9_NEx__:
    sbc Dx
    bcc PPyx9_fill_NEx__
PPyx9_NExSE:
    sta subroutine_temp
    lda #5
PPyx9_store___xSE:
    or_buffer 9
    dey
    beq PPyx9_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx10_NEx__
    adc rounded_Dy
    inx
    jmp PPyx10_NWx__
PPyx9_return:
    rts
PPyx9___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx9_store___xSE
PPyx9_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 9
    inx
PPyx9___xSW:
    lda #2
    or_buffer 9
    dey
    beq PPyx9_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx10_NWx__
    adc rounded_Dy
    jmp PPyx10_NEx__
PPyx10:
PPyx10_adc_NWx__:
    adc rounded_Dy
    inx
PPyx10_NWx__:
    sbc Dx
    bcs PPyx10_NWxSW
    adc rounded_Dy
PPyx10_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 10
    dey
    beq PPyx10_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx11_adc_NWx__
    jmp PPyx11_NEx__
PPyx10_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 10
    dey
    beq PPyx10_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx11_NWx__
    adc rounded_Dy
    jmp PPyx11_NEx__
PPyx10_adc_NEx__:
    adc rounded_Dy
PPyx10_NEx__:
    sbc Dx
    bcc PPyx10_fill_NEx__
PPyx10_NExSE:
    sta subroutine_temp
    lda #5
PPyx10_store___xSE:
    or_buffer 10
    dey
    beq PPyx10_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx11_NEx__
    adc rounded_Dy
    inx
    jmp PPyx11_NWx__
PPyx10_return:
    rts
PPyx10___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx10_store___xSE
PPyx10_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 10
    inx
PPyx10___xSW:
    lda #2
    or_buffer 10
    dey
    beq PPyx10_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx11_NWx__
    adc rounded_Dy
    jmp PPyx11_NEx__
PPyx11:
PPyx11_adc_NWx__:
    adc rounded_Dy
    inx
PPyx11_NWx__:
    sbc Dx
    bcs PPyx11_NWxSW
    adc rounded_Dy
PPyx11_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 11
    dey
    beq PPyx11_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx12_adc_NWx__
    jmp PPyx12_NEx__
PPyx11_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 11
    dey
    beq PPyx11_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx12_NWx__
    adc rounded_Dy
    jmp PPyx12_NEx__
PPyx11_adc_NEx__:
    adc rounded_Dy
PPyx11_NEx__:
    sbc Dx
    bcc PPyx11_fill_NEx__
PPyx11_NExSE:
    sta subroutine_temp
    lda #5
PPyx11_store___xSE:
    or_buffer 11
    dey
    beq PPyx11_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx12_NEx__
    adc rounded_Dy
    inx
    jmp PPyx12_NWx__
PPyx11_return:
    rts
PPyx11___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx11_store___xSE
PPyx11_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 11
    inx
PPyx11___xSW:
    lda #2
    or_buffer 11
    dey
    beq PPyx11_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx12_NWx__
    adc rounded_Dy
    jmp PPyx12_NEx__
PPyx12:
PPyx12_adc_NWx__:
    adc rounded_Dy
    inx
PPyx12_NWx__:
    sbc Dx
    bcs PPyx12_NWxSW
    adc rounded_Dy
PPyx12_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 12
    dey
    beq PPyx12_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx13_adc_NWx__
    jmp PPyx13_NEx__
PPyx12_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 12
    dey
    beq PPyx12_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx13_NWx__
    adc rounded_Dy
    jmp PPyx13_NEx__
PPyx12_adc_NEx__:
    adc rounded_Dy
PPyx12_NEx__:
    sbc Dx
    bcc PPyx12_fill_NEx__
PPyx12_NExSE:
    sta subroutine_temp
    lda #5
PPyx12_store___xSE:
    or_buffer 12
    dey
    beq PPyx12_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx13_NEx__
    adc rounded_Dy
    inx
    jmp PPyx13_NWx__
PPyx12_return:
    rts
PPyx12___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx12_store___xSE
PPyx12_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 12
    inx
PPyx12___xSW:
    lda #2
    or_buffer 12
    dey
    beq PPyx12_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx13_NWx__
    adc rounded_Dy
    jmp PPyx13_NEx__
PPyx13:
PPyx13_adc_NWx__:
    adc rounded_Dy
    inx
PPyx13_NWx__:
    sbc Dx
    bcs PPyx13_NWxSW
    adc rounded_Dy
PPyx13_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 13
    dey
    beq PPyx13_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx14_adc_NWx__
    jmp PPyx14_NEx__
PPyx13_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 13
    dey
    beq PPyx13_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx14_NWx__
    adc rounded_Dy
    jmp PPyx14_NEx__
PPyx13_adc_NEx__:
    adc rounded_Dy
PPyx13_NEx__:
    sbc Dx
    bcc PPyx13_fill_NEx__
PPyx13_NExSE:
    sta subroutine_temp
    lda #5
PPyx13_store___xSE:
    or_buffer 13
    dey
    beq PPyx13_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx14_NEx__
    adc rounded_Dy
    inx
    jmp PPyx14_NWx__
PPyx13_return:
    rts
PPyx13___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx13_store___xSE
PPyx13_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 13
    inx
PPyx13___xSW:
    lda #2
    or_buffer 13
    dey
    beq PPyx13_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx14_NWx__
    adc rounded_Dy
    jmp PPyx14_NEx__
PPyx14:
PPyx14_adc_NWx__:
    adc rounded_Dy
    inx
PPyx14_NWx__:
    sbc Dx
    bcs PPyx14_NWxSW
    adc rounded_Dy
PPyx14_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 14
    dey
    beq PPyx14_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx15_adc_NWx__
    jmp PPyx15_NEx__
PPyx14_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 14
    dey
    beq PPyx14_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx15_NWx__
    adc rounded_Dy
    jmp PPyx15_NEx__
PPyx14_adc_NEx__:
    adc rounded_Dy
PPyx14_NEx__:
    sbc Dx
    bcc PPyx14_fill_NEx__
PPyx14_NExSE:
    sta subroutine_temp
    lda #5
PPyx14_store___xSE:
    or_buffer 14
    dey
    beq PPyx14_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx15_NEx__
    adc rounded_Dy
    inx
    jmp PPyx15_NWx__
PPyx14_return:
    rts
PPyx14___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx14_store___xSE
PPyx14_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 14
    inx
PPyx14___xSW:
    lda #2
    or_buffer 14
    dey
    beq PPyx14_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx15_NWx__
    adc rounded_Dy
    jmp PPyx15_NEx__
PPyx15:
PPyx15_adc_NWx__:
    adc rounded_Dy
    inx
PPyx15_NWx__:
    sbc Dx
    bcs PPyx15_NWxSW
    adc rounded_Dy
PPyx15_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 15
    dey
    beq PPyx15_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx16_adc_NWx__
    jmp PPyx16_NEx__
PPyx15_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 15
    dey
    beq PPyx15_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx16_NWx__
    adc rounded_Dy
    jmp PPyx16_NEx__
PPyx15_adc_NEx__:
    adc rounded_Dy
PPyx15_NEx__:
    sbc Dx
    bcc PPyx15_fill_NEx__
PPyx15_NExSE:
    sta subroutine_temp
    lda #5
PPyx15_store___xSE:
    or_buffer 15
    dey
    beq PPyx15_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx16_NEx__
    adc rounded_Dy
    inx
    jmp PPyx16_NWx__
PPyx15_return:
    rts
PPyx15___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx15_store___xSE
PPyx15_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 15
    inx
PPyx15___xSW:
    lda #2
    or_buffer 15
    dey
    beq PPyx15_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx16_NWx__
    adc rounded_Dy
    jmp PPyx16_NEx__
PPyx16:
PPyx16_adc_NWx__:
    adc rounded_Dy
    inx
PPyx16_NWx__:
    sbc Dx
    bcs PPyx16_NWxSW
    adc rounded_Dy
PPyx16_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 16
    dey
    beq PPyx16_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx17_adc_NWx__
    jmp PPyx17_NEx__
PPyx16_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 16
    dey
    beq PPyx16_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx17_NWx__
    adc rounded_Dy
    jmp PPyx17_NEx__
PPyx16_adc_NEx__:
    adc rounded_Dy
PPyx16_NEx__:
    sbc Dx
    bcc PPyx16_fill_NEx__
PPyx16_NExSE:
    sta subroutine_temp
    lda #5
PPyx16_store___xSE:
    or_buffer 16
    dey
    beq PPyx16_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx17_NEx__
    adc rounded_Dy
    inx
    jmp PPyx17_NWx__
PPyx16_return:
    rts
PPyx16___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx16_store___xSE
PPyx16_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 16
    inx
PPyx16___xSW:
    lda #2
    or_buffer 16
    dey
    beq PPyx16_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx17_NWx__
    adc rounded_Dy
    jmp PPyx17_NEx__
PPyx17:
PPyx17_adc_NWx__:
    adc rounded_Dy
    inx
PPyx17_NWx__:
    sbc Dx
    bcs PPyx17_NWxSW
    adc rounded_Dy
PPyx17_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 17
    dey
    beq PPyx17_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx18_adc_NWx__
    jmp PPyx18_NEx__
PPyx17_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 17
    dey
    beq PPyx17_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx18_NWx__
    adc rounded_Dy
    jmp PPyx18_NEx__
PPyx17_adc_NEx__:
    adc rounded_Dy
PPyx17_NEx__:
    sbc Dx
    bcc PPyx17_fill_NEx__
PPyx17_NExSE:
    sta subroutine_temp
    lda #5
PPyx17_store___xSE:
    or_buffer 17
    dey
    beq PPyx17_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx18_NEx__
    adc rounded_Dy
    inx
    jmp PPyx18_NWx__
PPyx17_return:
    rts
PPyx17___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx17_store___xSE
PPyx17_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 17
    inx
PPyx17___xSW:
    lda #2
    or_buffer 17
    dey
    beq PPyx17_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx18_NWx__
    adc rounded_Dy
    jmp PPyx18_NEx__
PPyx18:
PPyx18_adc_NWx__:
    adc rounded_Dy
    inx
PPyx18_NWx__:
    sbc Dx
    bcs PPyx18_NWxSW
    adc rounded_Dy
PPyx18_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 18
    dey
    beq PPyx18_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx19_adc_NWx__
    jmp PPyx19_NEx__
PPyx18_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 18
    dey
    beq PPyx18_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx19_NWx__
    adc rounded_Dy
    jmp PPyx19_NEx__
PPyx18_adc_NEx__:
    adc rounded_Dy
PPyx18_NEx__:
    sbc Dx
    bcc PPyx18_fill_NEx__
PPyx18_NExSE:
    sta subroutine_temp
    lda #5
PPyx18_store___xSE:
    or_buffer 18
    dey
    beq PPyx18_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx19_NEx__
    adc rounded_Dy
    inx
    jmp PPyx19_NWx__
PPyx18_return:
    rts
PPyx18___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx18_store___xSE
PPyx18_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 18
    inx
PPyx18___xSW:
    lda #2
    or_buffer 18
    dey
    beq PPyx18_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx19_NWx__
    adc rounded_Dy
    jmp PPyx19_NEx__
PPyx19:
PPyx19_adc_NWx__:
    adc rounded_Dy
    inx
PPyx19_NWx__:
    sbc Dx
    bcs PPyx19_NWxSW
    adc rounded_Dy
PPyx19_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 19
    dey
    beq PPyx19_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx20_adc_NWx__
    jmp PPyx20_NEx__
PPyx19_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 19
    dey
    beq PPyx19_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx20_NWx__
    adc rounded_Dy
    jmp PPyx20_NEx__
PPyx19_adc_NEx__:
    adc rounded_Dy
PPyx19_NEx__:
    sbc Dx
    bcc PPyx19_fill_NEx__
PPyx19_NExSE:
    sta subroutine_temp
    lda #5
PPyx19_store___xSE:
    or_buffer 19
    dey
    beq PPyx19_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx20_NEx__
    adc rounded_Dy
    inx
    jmp PPyx20_NWx__
PPyx19_return:
    rts
PPyx19___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx19_store___xSE
PPyx19_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 19
    inx
PPyx19___xSW:
    lda #2
    or_buffer 19
    dey
    beq PPyx19_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx20_NWx__
    adc rounded_Dy
    jmp PPyx20_NEx__
PPyx20:
PPyx20_adc_NWx__:
    adc rounded_Dy
    inx
PPyx20_NWx__:
    sbc Dx
    bcs PPyx20_NWxSW
    adc rounded_Dy
PPyx20_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 20
    dey
    beq PPyx20_return
    lda subroutine_temp
    sbc Dx
    bcc PPyx21_adc_NWx__
    jmp PPyx21_NEx__
PPyx20_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 20
    dey
    beq PPyx20_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx21_NWx__
    adc rounded_Dy
    jmp PPyx21_NEx__
PPyx20_adc_NEx__:
    adc rounded_Dy
PPyx20_NEx__:
    sbc Dx
    bcc PPyx20_fill_NEx__
PPyx20_NExSE:
    sta subroutine_temp
    lda #5
PPyx20_store___xSE:
    or_buffer 20
    dey
    beq PPyx20_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx21_NEx__
    adc rounded_Dy
    inx
    jmp PPyx21_NWx__
PPyx20_return:
    rts
PPyx20___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx20_store___xSE
PPyx20_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 20
    inx
PPyx20___xSW:
    lda #2
    or_buffer 20
    dey
    beq PPyx20_return
    lda subroutine_temp
    sbc Dx
    bcs PPyx21_NWx__
    adc rounded_Dy
    jmp PPyx21_NEx__
PPyx21:
PPyx21_adc_NWx__:
    adc rounded_Dy
    inx
PPyx21_NWx__:
    sbc Dx
    bcs PPyx21_NWxSW
    adc rounded_Dy
PPyx21_NWxSE:
    sta subroutine_temp
    lda #9
    or_buffer 21
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
PPyx21_NWxSW:
    sta subroutine_temp
    lda #10
    or_buffer 21
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
PPyx21_adc_NEx__:
    adc rounded_Dy
PPyx21_NEx__:
    sbc Dx
    bcc PPyx21_fill_NEx__
PPyx21_NExSE:
    sta subroutine_temp
    lda #5
PPyx21_store___xSE:
    or_buffer 21
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
PPyx21_return:
    rts
PPyx21___xSE:
    sta subroutine_temp
    lda #1
    jmp PPyx21_store___xSE
PPyx21_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #4
    or_buffer 21
    inx
PPyx21___xSW:
    lda #2
    or_buffer 21
    rts
.segment "RODATA"
PPxy_lo:
.byt .lobyte(PPxy0)
.byt .lobyte(PPxy1)
.byt .lobyte(PPxy2)
.byt .lobyte(PPxy3)
.byt .lobyte(PPxy4)
.byt .lobyte(PPxy5)
.byt .lobyte(PPxy6)
.byt .lobyte(PPxy7)
.byt .lobyte(PPxy8)
.byt .lobyte(PPxy9)
.byt .lobyte(PPxy10)
.byt .lobyte(PPxy11)
.byt .lobyte(PPxy12)
.byt .lobyte(PPxy13)
.byt .lobyte(PPxy14)
.byt .lobyte(PPxy15)
.byt .lobyte(PPxy16)
.byt .lobyte(PPxy17)
.byt .lobyte(PPxy18)
.byt .lobyte(PPxy19)
.byt .lobyte(PPxy20)
.byt .lobyte(PPxy21)
PPxy_hi:
.byt .hibyte(PPxy0)
.byt .hibyte(PPxy1)
.byt .hibyte(PPxy2)
.byt .hibyte(PPxy3)
.byt .hibyte(PPxy4)
.byt .hibyte(PPxy5)
.byt .hibyte(PPxy6)
.byt .hibyte(PPxy7)
.byt .hibyte(PPxy8)
.byt .hibyte(PPxy9)
.byt .hibyte(PPxy10)
.byt .hibyte(PPxy11)
.byt .hibyte(PPxy12)
.byt .hibyte(PPxy13)
.byt .hibyte(PPxy14)
.byt .hibyte(PPxy15)
.byt .hibyte(PPxy16)
.byt .hibyte(PPxy17)
.byt .hibyte(PPxy18)
.byt .hibyte(PPxy19)
.byt .hibyte(PPxy20)
.byt .hibyte(PPxy21)
PPxy_offset:
.byt PPxy0_NWx__ - PPxy0
.byt PPxy0_SWx__ - PPxy0
.byt PPxy0___xNE - PPxy0
.byt PPxy0___xSE - PPxy0
PPyx_lo:
.byt .lobyte(PPyx0)
.byt .lobyte(PPyx1)
.byt .lobyte(PPyx2)
.byt .lobyte(PPyx3)
.byt .lobyte(PPyx4)
.byt .lobyte(PPyx5)
.byt .lobyte(PPyx6)
.byt .lobyte(PPyx7)
.byt .lobyte(PPyx8)
.byt .lobyte(PPyx9)
.byt .lobyte(PPyx10)
.byt .lobyte(PPyx11)
.byt .lobyte(PPyx12)
.byt .lobyte(PPyx13)
.byt .lobyte(PPyx14)
.byt .lobyte(PPyx15)
.byt .lobyte(PPyx16)
.byt .lobyte(PPyx17)
.byt .lobyte(PPyx18)
.byt .lobyte(PPyx19)
.byt .lobyte(PPyx20)
.byt .lobyte(PPyx21)
PPyx_hi:
.byt .hibyte(PPyx0)
.byt .hibyte(PPyx1)
.byt .hibyte(PPyx2)
.byt .hibyte(PPyx3)
.byt .hibyte(PPyx4)
.byt .hibyte(PPyx5)
.byt .hibyte(PPyx6)
.byt .hibyte(PPyx7)
.byt .hibyte(PPyx8)
.byt .hibyte(PPyx9)
.byt .hibyte(PPyx10)
.byt .hibyte(PPyx11)
.byt .hibyte(PPyx12)
.byt .hibyte(PPyx13)
.byt .hibyte(PPyx14)
.byt .hibyte(PPyx15)
.byt .hibyte(PPyx16)
.byt .hibyte(PPyx17)
.byt .hibyte(PPyx18)
.byt .hibyte(PPyx19)
.byt .hibyte(PPyx20)
.byt .hibyte(PPyx21)
PPyx_offset:
.byt PPyx0_NWx__ - PPyx0
.byt PPyx0___xSW - PPyx0
.byt PPyx0_NEx__ - PPyx0
.byt PPyx0___xSE - PPyx0
.assert .lobyte(PPxy0_NWx__) <> $FF, error, "page overlap: PPxy0_NWx__"
.assert .lobyte(PPxy0_NWxNE) <> $FF, error, "page overlap: PPxy0_NWxNE"
.assert .lobyte(PPxy0_NWxSE) <> $FF, error, "page overlap: PPxy0_NWxSE"
.assert .lobyte(PPxy0___xNE) <> $FF, error, "page overlap: PPxy0___xNE"
.assert .lobyte(PPxy0_SWx__) <> $FF, error, "page overlap: PPxy0_SWx__"
.assert .lobyte(PPxy0_SWxSE) <> $FF, error, "page overlap: PPxy0_SWxSE"
.assert .lobyte(PPxy0___xSE) <> $FF, error, "page overlap: PPxy0___xSE"
.assert .lobyte(PPxy1_NWx__) <> $FF, error, "page overlap: PPxy1_NWx__"
.assert .lobyte(PPxy1_NWxNE) <> $FF, error, "page overlap: PPxy1_NWxNE"
.assert .lobyte(PPxy1_NWxSE) <> $FF, error, "page overlap: PPxy1_NWxSE"
.assert .lobyte(PPxy1___xNE) <> $FF, error, "page overlap: PPxy1___xNE"
.assert .lobyte(PPxy1_SWx__) <> $FF, error, "page overlap: PPxy1_SWx__"
.assert .lobyte(PPxy1_SWxSE) <> $FF, error, "page overlap: PPxy1_SWxSE"
.assert .lobyte(PPxy1___xSE) <> $FF, error, "page overlap: PPxy1___xSE"
.assert .lobyte(PPxy2_NWx__) <> $FF, error, "page overlap: PPxy2_NWx__"
.assert .lobyte(PPxy2_NWxNE) <> $FF, error, "page overlap: PPxy2_NWxNE"
.assert .lobyte(PPxy2_NWxSE) <> $FF, error, "page overlap: PPxy2_NWxSE"
.assert .lobyte(PPxy2___xNE) <> $FF, error, "page overlap: PPxy2___xNE"
.assert .lobyte(PPxy2_SWx__) <> $FF, error, "page overlap: PPxy2_SWx__"
.assert .lobyte(PPxy2_SWxSE) <> $FF, error, "page overlap: PPxy2_SWxSE"
.assert .lobyte(PPxy2___xSE) <> $FF, error, "page overlap: PPxy2___xSE"
.assert .lobyte(PPxy3_NWx__) <> $FF, error, "page overlap: PPxy3_NWx__"
.assert .lobyte(PPxy3_NWxNE) <> $FF, error, "page overlap: PPxy3_NWxNE"
.assert .lobyte(PPxy3_NWxSE) <> $FF, error, "page overlap: PPxy3_NWxSE"
.assert .lobyte(PPxy3___xNE) <> $FF, error, "page overlap: PPxy3___xNE"
.assert .lobyte(PPxy3_SWx__) <> $FF, error, "page overlap: PPxy3_SWx__"
.assert .lobyte(PPxy3_SWxSE) <> $FF, error, "page overlap: PPxy3_SWxSE"
.assert .lobyte(PPxy3___xSE) <> $FF, error, "page overlap: PPxy3___xSE"
.assert .lobyte(PPxy4_NWx__) <> $FF, error, "page overlap: PPxy4_NWx__"
.assert .lobyte(PPxy4_NWxNE) <> $FF, error, "page overlap: PPxy4_NWxNE"
.assert .lobyte(PPxy4_NWxSE) <> $FF, error, "page overlap: PPxy4_NWxSE"
.assert .lobyte(PPxy4___xNE) <> $FF, error, "page overlap: PPxy4___xNE"
.assert .lobyte(PPxy4_SWx__) <> $FF, error, "page overlap: PPxy4_SWx__"
.assert .lobyte(PPxy4_SWxSE) <> $FF, error, "page overlap: PPxy4_SWxSE"
.assert .lobyte(PPxy4___xSE) <> $FF, error, "page overlap: PPxy4___xSE"
.assert .lobyte(PPxy5_NWx__) <> $FF, error, "page overlap: PPxy5_NWx__"
.assert .lobyte(PPxy5_NWxNE) <> $FF, error, "page overlap: PPxy5_NWxNE"
.assert .lobyte(PPxy5_NWxSE) <> $FF, error, "page overlap: PPxy5_NWxSE"
.assert .lobyte(PPxy5___xNE) <> $FF, error, "page overlap: PPxy5___xNE"
.assert .lobyte(PPxy5_SWx__) <> $FF, error, "page overlap: PPxy5_SWx__"
.assert .lobyte(PPxy5_SWxSE) <> $FF, error, "page overlap: PPxy5_SWxSE"
.assert .lobyte(PPxy5___xSE) <> $FF, error, "page overlap: PPxy5___xSE"
.assert .lobyte(PPxy6_NWx__) <> $FF, error, "page overlap: PPxy6_NWx__"
.assert .lobyte(PPxy6_NWxNE) <> $FF, error, "page overlap: PPxy6_NWxNE"
.assert .lobyte(PPxy6_NWxSE) <> $FF, error, "page overlap: PPxy6_NWxSE"
.assert .lobyte(PPxy6___xNE) <> $FF, error, "page overlap: PPxy6___xNE"
.assert .lobyte(PPxy6_SWx__) <> $FF, error, "page overlap: PPxy6_SWx__"
.assert .lobyte(PPxy6_SWxSE) <> $FF, error, "page overlap: PPxy6_SWxSE"
.assert .lobyte(PPxy6___xSE) <> $FF, error, "page overlap: PPxy6___xSE"
.assert .lobyte(PPxy7_NWx__) <> $FF, error, "page overlap: PPxy7_NWx__"
.assert .lobyte(PPxy7_NWxNE) <> $FF, error, "page overlap: PPxy7_NWxNE"
.assert .lobyte(PPxy7_NWxSE) <> $FF, error, "page overlap: PPxy7_NWxSE"
.assert .lobyte(PPxy7___xNE) <> $FF, error, "page overlap: PPxy7___xNE"
.assert .lobyte(PPxy7_SWx__) <> $FF, error, "page overlap: PPxy7_SWx__"
.assert .lobyte(PPxy7_SWxSE) <> $FF, error, "page overlap: PPxy7_SWxSE"
.assert .lobyte(PPxy7___xSE) <> $FF, error, "page overlap: PPxy7___xSE"
.assert .lobyte(PPxy8_NWx__) <> $FF, error, "page overlap: PPxy8_NWx__"
.assert .lobyte(PPxy8_NWxNE) <> $FF, error, "page overlap: PPxy8_NWxNE"
.assert .lobyte(PPxy8_NWxSE) <> $FF, error, "page overlap: PPxy8_NWxSE"
.assert .lobyte(PPxy8___xNE) <> $FF, error, "page overlap: PPxy8___xNE"
.assert .lobyte(PPxy8_SWx__) <> $FF, error, "page overlap: PPxy8_SWx__"
.assert .lobyte(PPxy8_SWxSE) <> $FF, error, "page overlap: PPxy8_SWxSE"
.assert .lobyte(PPxy8___xSE) <> $FF, error, "page overlap: PPxy8___xSE"
.assert .lobyte(PPxy9_NWx__) <> $FF, error, "page overlap: PPxy9_NWx__"
.assert .lobyte(PPxy9_NWxNE) <> $FF, error, "page overlap: PPxy9_NWxNE"
.assert .lobyte(PPxy9_NWxSE) <> $FF, error, "page overlap: PPxy9_NWxSE"
.assert .lobyte(PPxy9___xNE) <> $FF, error, "page overlap: PPxy9___xNE"
.assert .lobyte(PPxy9_SWx__) <> $FF, error, "page overlap: PPxy9_SWx__"
.assert .lobyte(PPxy9_SWxSE) <> $FF, error, "page overlap: PPxy9_SWxSE"
.assert .lobyte(PPxy9___xSE) <> $FF, error, "page overlap: PPxy9___xSE"
.assert .lobyte(PPxy10_NWx__) <> $FF, error, "page overlap: PPxy10_NWx__"
.assert .lobyte(PPxy10_NWxNE) <> $FF, error, "page overlap: PPxy10_NWxNE"
.assert .lobyte(PPxy10_NWxSE) <> $FF, error, "page overlap: PPxy10_NWxSE"
.assert .lobyte(PPxy10___xNE) <> $FF, error, "page overlap: PPxy10___xNE"
.assert .lobyte(PPxy10_SWx__) <> $FF, error, "page overlap: PPxy10_SWx__"
.assert .lobyte(PPxy10_SWxSE) <> $FF, error, "page overlap: PPxy10_SWxSE"
.assert .lobyte(PPxy10___xSE) <> $FF, error, "page overlap: PPxy10___xSE"
.assert .lobyte(PPxy11_NWx__) <> $FF, error, "page overlap: PPxy11_NWx__"
.assert .lobyte(PPxy11_NWxNE) <> $FF, error, "page overlap: PPxy11_NWxNE"
.assert .lobyte(PPxy11_NWxSE) <> $FF, error, "page overlap: PPxy11_NWxSE"
.assert .lobyte(PPxy11___xNE) <> $FF, error, "page overlap: PPxy11___xNE"
.assert .lobyte(PPxy11_SWx__) <> $FF, error, "page overlap: PPxy11_SWx__"
.assert .lobyte(PPxy11_SWxSE) <> $FF, error, "page overlap: PPxy11_SWxSE"
.assert .lobyte(PPxy11___xSE) <> $FF, error, "page overlap: PPxy11___xSE"
.assert .lobyte(PPxy12_NWx__) <> $FF, error, "page overlap: PPxy12_NWx__"
.assert .lobyte(PPxy12_NWxNE) <> $FF, error, "page overlap: PPxy12_NWxNE"
.assert .lobyte(PPxy12_NWxSE) <> $FF, error, "page overlap: PPxy12_NWxSE"
.assert .lobyte(PPxy12___xNE) <> $FF, error, "page overlap: PPxy12___xNE"
.assert .lobyte(PPxy12_SWx__) <> $FF, error, "page overlap: PPxy12_SWx__"
.assert .lobyte(PPxy12_SWxSE) <> $FF, error, "page overlap: PPxy12_SWxSE"
.assert .lobyte(PPxy12___xSE) <> $FF, error, "page overlap: PPxy12___xSE"
.assert .lobyte(PPxy13_NWx__) <> $FF, error, "page overlap: PPxy13_NWx__"
.assert .lobyte(PPxy13_NWxNE) <> $FF, error, "page overlap: PPxy13_NWxNE"
.assert .lobyte(PPxy13_NWxSE) <> $FF, error, "page overlap: PPxy13_NWxSE"
.assert .lobyte(PPxy13___xNE) <> $FF, error, "page overlap: PPxy13___xNE"
.assert .lobyte(PPxy13_SWx__) <> $FF, error, "page overlap: PPxy13_SWx__"
.assert .lobyte(PPxy13_SWxSE) <> $FF, error, "page overlap: PPxy13_SWxSE"
.assert .lobyte(PPxy13___xSE) <> $FF, error, "page overlap: PPxy13___xSE"
.assert .lobyte(PPxy14_NWx__) <> $FF, error, "page overlap: PPxy14_NWx__"
.assert .lobyte(PPxy14_NWxNE) <> $FF, error, "page overlap: PPxy14_NWxNE"
.assert .lobyte(PPxy14_NWxSE) <> $FF, error, "page overlap: PPxy14_NWxSE"
.assert .lobyte(PPxy14___xNE) <> $FF, error, "page overlap: PPxy14___xNE"
.assert .lobyte(PPxy14_SWx__) <> $FF, error, "page overlap: PPxy14_SWx__"
.assert .lobyte(PPxy14_SWxSE) <> $FF, error, "page overlap: PPxy14_SWxSE"
.assert .lobyte(PPxy14___xSE) <> $FF, error, "page overlap: PPxy14___xSE"
.assert .lobyte(PPxy15_NWx__) <> $FF, error, "page overlap: PPxy15_NWx__"
.assert .lobyte(PPxy15_NWxNE) <> $FF, error, "page overlap: PPxy15_NWxNE"
.assert .lobyte(PPxy15_NWxSE) <> $FF, error, "page overlap: PPxy15_NWxSE"
.assert .lobyte(PPxy15___xNE) <> $FF, error, "page overlap: PPxy15___xNE"
.assert .lobyte(PPxy15_SWx__) <> $FF, error, "page overlap: PPxy15_SWx__"
.assert .lobyte(PPxy15_SWxSE) <> $FF, error, "page overlap: PPxy15_SWxSE"
.assert .lobyte(PPxy15___xSE) <> $FF, error, "page overlap: PPxy15___xSE"
.assert .lobyte(PPxy16_NWx__) <> $FF, error, "page overlap: PPxy16_NWx__"
.assert .lobyte(PPxy16_NWxNE) <> $FF, error, "page overlap: PPxy16_NWxNE"
.assert .lobyte(PPxy16_NWxSE) <> $FF, error, "page overlap: PPxy16_NWxSE"
.assert .lobyte(PPxy16___xNE) <> $FF, error, "page overlap: PPxy16___xNE"
.assert .lobyte(PPxy16_SWx__) <> $FF, error, "page overlap: PPxy16_SWx__"
.assert .lobyte(PPxy16_SWxSE) <> $FF, error, "page overlap: PPxy16_SWxSE"
.assert .lobyte(PPxy16___xSE) <> $FF, error, "page overlap: PPxy16___xSE"
.assert .lobyte(PPxy17_NWx__) <> $FF, error, "page overlap: PPxy17_NWx__"
.assert .lobyte(PPxy17_NWxNE) <> $FF, error, "page overlap: PPxy17_NWxNE"
.assert .lobyte(PPxy17_NWxSE) <> $FF, error, "page overlap: PPxy17_NWxSE"
.assert .lobyte(PPxy17___xNE) <> $FF, error, "page overlap: PPxy17___xNE"
.assert .lobyte(PPxy17_SWx__) <> $FF, error, "page overlap: PPxy17_SWx__"
.assert .lobyte(PPxy17_SWxSE) <> $FF, error, "page overlap: PPxy17_SWxSE"
.assert .lobyte(PPxy17___xSE) <> $FF, error, "page overlap: PPxy17___xSE"
.assert .lobyte(PPxy18_NWx__) <> $FF, error, "page overlap: PPxy18_NWx__"
.assert .lobyte(PPxy18_NWxNE) <> $FF, error, "page overlap: PPxy18_NWxNE"
.assert .lobyte(PPxy18_NWxSE) <> $FF, error, "page overlap: PPxy18_NWxSE"
.assert .lobyte(PPxy18___xNE) <> $FF, error, "page overlap: PPxy18___xNE"
.assert .lobyte(PPxy18_SWx__) <> $FF, error, "page overlap: PPxy18_SWx__"
.assert .lobyte(PPxy18_SWxSE) <> $FF, error, "page overlap: PPxy18_SWxSE"
.assert .lobyte(PPxy18___xSE) <> $FF, error, "page overlap: PPxy18___xSE"
.assert .lobyte(PPxy19_NWx__) <> $FF, error, "page overlap: PPxy19_NWx__"
.assert .lobyte(PPxy19_NWxNE) <> $FF, error, "page overlap: PPxy19_NWxNE"
.assert .lobyte(PPxy19_NWxSE) <> $FF, error, "page overlap: PPxy19_NWxSE"
.assert .lobyte(PPxy19___xNE) <> $FF, error, "page overlap: PPxy19___xNE"
.assert .lobyte(PPxy19_SWx__) <> $FF, error, "page overlap: PPxy19_SWx__"
.assert .lobyte(PPxy19_SWxSE) <> $FF, error, "page overlap: PPxy19_SWxSE"
.assert .lobyte(PPxy19___xSE) <> $FF, error, "page overlap: PPxy19___xSE"
.assert .lobyte(PPxy20_NWx__) <> $FF, error, "page overlap: PPxy20_NWx__"
.assert .lobyte(PPxy20_NWxNE) <> $FF, error, "page overlap: PPxy20_NWxNE"
.assert .lobyte(PPxy20_NWxSE) <> $FF, error, "page overlap: PPxy20_NWxSE"
.assert .lobyte(PPxy20___xNE) <> $FF, error, "page overlap: PPxy20___xNE"
.assert .lobyte(PPxy20_SWx__) <> $FF, error, "page overlap: PPxy20_SWx__"
.assert .lobyte(PPxy20_SWxSE) <> $FF, error, "page overlap: PPxy20_SWxSE"
.assert .lobyte(PPxy20___xSE) <> $FF, error, "page overlap: PPxy20___xSE"
.assert .lobyte(PPxy21_NWx__) <> $FF, error, "page overlap: PPxy21_NWx__"
.assert .lobyte(PPxy21_NWxNE) <> $FF, error, "page overlap: PPxy21_NWxNE"
.assert .lobyte(PPxy21_NWxSE) <> $FF, error, "page overlap: PPxy21_NWxSE"
.assert .lobyte(PPxy21___xNE) <> $FF, error, "page overlap: PPxy21___xNE"
.assert .lobyte(PPxy21_SWx__) <> $FF, error, "page overlap: PPxy21_SWx__"
.assert .lobyte(PPxy21_SWxSE) <> $FF, error, "page overlap: PPxy21_SWxSE"
.assert .lobyte(PPxy21___xSE) <> $FF, error, "page overlap: PPxy21___xSE"
.assert .lobyte(PPyx0_NWx__) <> $FF, error, "page overlap: PPyx0_NWx__"
.assert .lobyte(PPyx0_NWxSW) <> $FF, error, "page overlap: PPyx0_NWxSW"
.assert .lobyte(PPyx0_NWxSE) <> $FF, error, "page overlap: PPyx0_NWxSE"
.assert .lobyte(PPyx0___xSE) <> $FF, error, "page overlap: PPyx0___xSE"
.assert .lobyte(PPyx0___xSW) <> $FF, error, "page overlap: PPyx0___xSW"
.assert .lobyte(PPyx0_NEx__) <> $FF, error, "page overlap: PPyx0_NEx__"
.assert .lobyte(PPyx0_NExSE) <> $FF, error, "page overlap: PPyx0_NExSE"
.assert .lobyte(PPyx1_NWx__) <> $FF, error, "page overlap: PPyx1_NWx__"
.assert .lobyte(PPyx1_NWxSW) <> $FF, error, "page overlap: PPyx1_NWxSW"
.assert .lobyte(PPyx1_NWxSE) <> $FF, error, "page overlap: PPyx1_NWxSE"
.assert .lobyte(PPyx1___xSE) <> $FF, error, "page overlap: PPyx1___xSE"
.assert .lobyte(PPyx1___xSW) <> $FF, error, "page overlap: PPyx1___xSW"
.assert .lobyte(PPyx1_NEx__) <> $FF, error, "page overlap: PPyx1_NEx__"
.assert .lobyte(PPyx1_NExSE) <> $FF, error, "page overlap: PPyx1_NExSE"
.assert .lobyte(PPyx2_NWx__) <> $FF, error, "page overlap: PPyx2_NWx__"
.assert .lobyte(PPyx2_NWxSW) <> $FF, error, "page overlap: PPyx2_NWxSW"
.assert .lobyte(PPyx2_NWxSE) <> $FF, error, "page overlap: PPyx2_NWxSE"
.assert .lobyte(PPyx2___xSE) <> $FF, error, "page overlap: PPyx2___xSE"
.assert .lobyte(PPyx2___xSW) <> $FF, error, "page overlap: PPyx2___xSW"
.assert .lobyte(PPyx2_NEx__) <> $FF, error, "page overlap: PPyx2_NEx__"
.assert .lobyte(PPyx2_NExSE) <> $FF, error, "page overlap: PPyx2_NExSE"
.assert .lobyte(PPyx3_NWx__) <> $FF, error, "page overlap: PPyx3_NWx__"
.assert .lobyte(PPyx3_NWxSW) <> $FF, error, "page overlap: PPyx3_NWxSW"
.assert .lobyte(PPyx3_NWxSE) <> $FF, error, "page overlap: PPyx3_NWxSE"
.assert .lobyte(PPyx3___xSE) <> $FF, error, "page overlap: PPyx3___xSE"
.assert .lobyte(PPyx3___xSW) <> $FF, error, "page overlap: PPyx3___xSW"
.assert .lobyte(PPyx3_NEx__) <> $FF, error, "page overlap: PPyx3_NEx__"
.assert .lobyte(PPyx3_NExSE) <> $FF, error, "page overlap: PPyx3_NExSE"
.assert .lobyte(PPyx4_NWx__) <> $FF, error, "page overlap: PPyx4_NWx__"
.assert .lobyte(PPyx4_NWxSW) <> $FF, error, "page overlap: PPyx4_NWxSW"
.assert .lobyte(PPyx4_NWxSE) <> $FF, error, "page overlap: PPyx4_NWxSE"
.assert .lobyte(PPyx4___xSE) <> $FF, error, "page overlap: PPyx4___xSE"
.assert .lobyte(PPyx4___xSW) <> $FF, error, "page overlap: PPyx4___xSW"
.assert .lobyte(PPyx4_NEx__) <> $FF, error, "page overlap: PPyx4_NEx__"
.assert .lobyte(PPyx4_NExSE) <> $FF, error, "page overlap: PPyx4_NExSE"
.assert .lobyte(PPyx5_NWx__) <> $FF, error, "page overlap: PPyx5_NWx__"
.assert .lobyte(PPyx5_NWxSW) <> $FF, error, "page overlap: PPyx5_NWxSW"
.assert .lobyte(PPyx5_NWxSE) <> $FF, error, "page overlap: PPyx5_NWxSE"
.assert .lobyte(PPyx5___xSE) <> $FF, error, "page overlap: PPyx5___xSE"
.assert .lobyte(PPyx5___xSW) <> $FF, error, "page overlap: PPyx5___xSW"
.assert .lobyte(PPyx5_NEx__) <> $FF, error, "page overlap: PPyx5_NEx__"
.assert .lobyte(PPyx5_NExSE) <> $FF, error, "page overlap: PPyx5_NExSE"
.assert .lobyte(PPyx6_NWx__) <> $FF, error, "page overlap: PPyx6_NWx__"
.assert .lobyte(PPyx6_NWxSW) <> $FF, error, "page overlap: PPyx6_NWxSW"
.assert .lobyte(PPyx6_NWxSE) <> $FF, error, "page overlap: PPyx6_NWxSE"
.assert .lobyte(PPyx6___xSE) <> $FF, error, "page overlap: PPyx6___xSE"
.assert .lobyte(PPyx6___xSW) <> $FF, error, "page overlap: PPyx6___xSW"
.assert .lobyte(PPyx6_NEx__) <> $FF, error, "page overlap: PPyx6_NEx__"
.assert .lobyte(PPyx6_NExSE) <> $FF, error, "page overlap: PPyx6_NExSE"
.assert .lobyte(PPyx7_NWx__) <> $FF, error, "page overlap: PPyx7_NWx__"
.assert .lobyte(PPyx7_NWxSW) <> $FF, error, "page overlap: PPyx7_NWxSW"
.assert .lobyte(PPyx7_NWxSE) <> $FF, error, "page overlap: PPyx7_NWxSE"
.assert .lobyte(PPyx7___xSE) <> $FF, error, "page overlap: PPyx7___xSE"
.assert .lobyte(PPyx7___xSW) <> $FF, error, "page overlap: PPyx7___xSW"
.assert .lobyte(PPyx7_NEx__) <> $FF, error, "page overlap: PPyx7_NEx__"
.assert .lobyte(PPyx7_NExSE) <> $FF, error, "page overlap: PPyx7_NExSE"
.assert .lobyte(PPyx8_NWx__) <> $FF, error, "page overlap: PPyx8_NWx__"
.assert .lobyte(PPyx8_NWxSW) <> $FF, error, "page overlap: PPyx8_NWxSW"
.assert .lobyte(PPyx8_NWxSE) <> $FF, error, "page overlap: PPyx8_NWxSE"
.assert .lobyte(PPyx8___xSE) <> $FF, error, "page overlap: PPyx8___xSE"
.assert .lobyte(PPyx8___xSW) <> $FF, error, "page overlap: PPyx8___xSW"
.assert .lobyte(PPyx8_NEx__) <> $FF, error, "page overlap: PPyx8_NEx__"
.assert .lobyte(PPyx8_NExSE) <> $FF, error, "page overlap: PPyx8_NExSE"
.assert .lobyte(PPyx9_NWx__) <> $FF, error, "page overlap: PPyx9_NWx__"
.assert .lobyte(PPyx9_NWxSW) <> $FF, error, "page overlap: PPyx9_NWxSW"
.assert .lobyte(PPyx9_NWxSE) <> $FF, error, "page overlap: PPyx9_NWxSE"
.assert .lobyte(PPyx9___xSE) <> $FF, error, "page overlap: PPyx9___xSE"
.assert .lobyte(PPyx9___xSW) <> $FF, error, "page overlap: PPyx9___xSW"
.assert .lobyte(PPyx9_NEx__) <> $FF, error, "page overlap: PPyx9_NEx__"
.assert .lobyte(PPyx9_NExSE) <> $FF, error, "page overlap: PPyx9_NExSE"
.assert .lobyte(PPyx10_NWx__) <> $FF, error, "page overlap: PPyx10_NWx__"
.assert .lobyte(PPyx10_NWxSW) <> $FF, error, "page overlap: PPyx10_NWxSW"
.assert .lobyte(PPyx10_NWxSE) <> $FF, error, "page overlap: PPyx10_NWxSE"
.assert .lobyte(PPyx10___xSE) <> $FF, error, "page overlap: PPyx10___xSE"
.assert .lobyte(PPyx10___xSW) <> $FF, error, "page overlap: PPyx10___xSW"
.assert .lobyte(PPyx10_NEx__) <> $FF, error, "page overlap: PPyx10_NEx__"
.assert .lobyte(PPyx10_NExSE) <> $FF, error, "page overlap: PPyx10_NExSE"
.assert .lobyte(PPyx11_NWx__) <> $FF, error, "page overlap: PPyx11_NWx__"
.assert .lobyte(PPyx11_NWxSW) <> $FF, error, "page overlap: PPyx11_NWxSW"
.assert .lobyte(PPyx11_NWxSE) <> $FF, error, "page overlap: PPyx11_NWxSE"
.assert .lobyte(PPyx11___xSE) <> $FF, error, "page overlap: PPyx11___xSE"
.assert .lobyte(PPyx11___xSW) <> $FF, error, "page overlap: PPyx11___xSW"
.assert .lobyte(PPyx11_NEx__) <> $FF, error, "page overlap: PPyx11_NEx__"
.assert .lobyte(PPyx11_NExSE) <> $FF, error, "page overlap: PPyx11_NExSE"
.assert .lobyte(PPyx12_NWx__) <> $FF, error, "page overlap: PPyx12_NWx__"
.assert .lobyte(PPyx12_NWxSW) <> $FF, error, "page overlap: PPyx12_NWxSW"
.assert .lobyte(PPyx12_NWxSE) <> $FF, error, "page overlap: PPyx12_NWxSE"
.assert .lobyte(PPyx12___xSE) <> $FF, error, "page overlap: PPyx12___xSE"
.assert .lobyte(PPyx12___xSW) <> $FF, error, "page overlap: PPyx12___xSW"
.assert .lobyte(PPyx12_NEx__) <> $FF, error, "page overlap: PPyx12_NEx__"
.assert .lobyte(PPyx12_NExSE) <> $FF, error, "page overlap: PPyx12_NExSE"
.assert .lobyte(PPyx13_NWx__) <> $FF, error, "page overlap: PPyx13_NWx__"
.assert .lobyte(PPyx13_NWxSW) <> $FF, error, "page overlap: PPyx13_NWxSW"
.assert .lobyte(PPyx13_NWxSE) <> $FF, error, "page overlap: PPyx13_NWxSE"
.assert .lobyte(PPyx13___xSE) <> $FF, error, "page overlap: PPyx13___xSE"
.assert .lobyte(PPyx13___xSW) <> $FF, error, "page overlap: PPyx13___xSW"
.assert .lobyte(PPyx13_NEx__) <> $FF, error, "page overlap: PPyx13_NEx__"
.assert .lobyte(PPyx13_NExSE) <> $FF, error, "page overlap: PPyx13_NExSE"
.assert .lobyte(PPyx14_NWx__) <> $FF, error, "page overlap: PPyx14_NWx__"
.assert .lobyte(PPyx14_NWxSW) <> $FF, error, "page overlap: PPyx14_NWxSW"
.assert .lobyte(PPyx14_NWxSE) <> $FF, error, "page overlap: PPyx14_NWxSE"
.assert .lobyte(PPyx14___xSE) <> $FF, error, "page overlap: PPyx14___xSE"
.assert .lobyte(PPyx14___xSW) <> $FF, error, "page overlap: PPyx14___xSW"
.assert .lobyte(PPyx14_NEx__) <> $FF, error, "page overlap: PPyx14_NEx__"
.assert .lobyte(PPyx14_NExSE) <> $FF, error, "page overlap: PPyx14_NExSE"
.assert .lobyte(PPyx15_NWx__) <> $FF, error, "page overlap: PPyx15_NWx__"
.assert .lobyte(PPyx15_NWxSW) <> $FF, error, "page overlap: PPyx15_NWxSW"
.assert .lobyte(PPyx15_NWxSE) <> $FF, error, "page overlap: PPyx15_NWxSE"
.assert .lobyte(PPyx15___xSE) <> $FF, error, "page overlap: PPyx15___xSE"
.assert .lobyte(PPyx15___xSW) <> $FF, error, "page overlap: PPyx15___xSW"
.assert .lobyte(PPyx15_NEx__) <> $FF, error, "page overlap: PPyx15_NEx__"
.assert .lobyte(PPyx15_NExSE) <> $FF, error, "page overlap: PPyx15_NExSE"
.assert .lobyte(PPyx16_NWx__) <> $FF, error, "page overlap: PPyx16_NWx__"
.assert .lobyte(PPyx16_NWxSW) <> $FF, error, "page overlap: PPyx16_NWxSW"
.assert .lobyte(PPyx16_NWxSE) <> $FF, error, "page overlap: PPyx16_NWxSE"
.assert .lobyte(PPyx16___xSE) <> $FF, error, "page overlap: PPyx16___xSE"
.assert .lobyte(PPyx16___xSW) <> $FF, error, "page overlap: PPyx16___xSW"
.assert .lobyte(PPyx16_NEx__) <> $FF, error, "page overlap: PPyx16_NEx__"
.assert .lobyte(PPyx16_NExSE) <> $FF, error, "page overlap: PPyx16_NExSE"
.assert .lobyte(PPyx17_NWx__) <> $FF, error, "page overlap: PPyx17_NWx__"
.assert .lobyte(PPyx17_NWxSW) <> $FF, error, "page overlap: PPyx17_NWxSW"
.assert .lobyte(PPyx17_NWxSE) <> $FF, error, "page overlap: PPyx17_NWxSE"
.assert .lobyte(PPyx17___xSE) <> $FF, error, "page overlap: PPyx17___xSE"
.assert .lobyte(PPyx17___xSW) <> $FF, error, "page overlap: PPyx17___xSW"
.assert .lobyte(PPyx17_NEx__) <> $FF, error, "page overlap: PPyx17_NEx__"
.assert .lobyte(PPyx17_NExSE) <> $FF, error, "page overlap: PPyx17_NExSE"
.assert .lobyte(PPyx18_NWx__) <> $FF, error, "page overlap: PPyx18_NWx__"
.assert .lobyte(PPyx18_NWxSW) <> $FF, error, "page overlap: PPyx18_NWxSW"
.assert .lobyte(PPyx18_NWxSE) <> $FF, error, "page overlap: PPyx18_NWxSE"
.assert .lobyte(PPyx18___xSE) <> $FF, error, "page overlap: PPyx18___xSE"
.assert .lobyte(PPyx18___xSW) <> $FF, error, "page overlap: PPyx18___xSW"
.assert .lobyte(PPyx18_NEx__) <> $FF, error, "page overlap: PPyx18_NEx__"
.assert .lobyte(PPyx18_NExSE) <> $FF, error, "page overlap: PPyx18_NExSE"
.assert .lobyte(PPyx19_NWx__) <> $FF, error, "page overlap: PPyx19_NWx__"
.assert .lobyte(PPyx19_NWxSW) <> $FF, error, "page overlap: PPyx19_NWxSW"
.assert .lobyte(PPyx19_NWxSE) <> $FF, error, "page overlap: PPyx19_NWxSE"
.assert .lobyte(PPyx19___xSE) <> $FF, error, "page overlap: PPyx19___xSE"
.assert .lobyte(PPyx19___xSW) <> $FF, error, "page overlap: PPyx19___xSW"
.assert .lobyte(PPyx19_NEx__) <> $FF, error, "page overlap: PPyx19_NEx__"
.assert .lobyte(PPyx19_NExSE) <> $FF, error, "page overlap: PPyx19_NExSE"
.assert .lobyte(PPyx20_NWx__) <> $FF, error, "page overlap: PPyx20_NWx__"
.assert .lobyte(PPyx20_NWxSW) <> $FF, error, "page overlap: PPyx20_NWxSW"
.assert .lobyte(PPyx20_NWxSE) <> $FF, error, "page overlap: PPyx20_NWxSE"
.assert .lobyte(PPyx20___xSE) <> $FF, error, "page overlap: PPyx20___xSE"
.assert .lobyte(PPyx20___xSW) <> $FF, error, "page overlap: PPyx20___xSW"
.assert .lobyte(PPyx20_NEx__) <> $FF, error, "page overlap: PPyx20_NEx__"
.assert .lobyte(PPyx20_NExSE) <> $FF, error, "page overlap: PPyx20_NExSE"
.assert .lobyte(PPyx21_NWx__) <> $FF, error, "page overlap: PPyx21_NWx__"
.assert .lobyte(PPyx21_NWxSW) <> $FF, error, "page overlap: PPyx21_NWxSW"
.assert .lobyte(PPyx21_NWxSE) <> $FF, error, "page overlap: PPyx21_NWxSE"
.assert .lobyte(PPyx21___xSE) <> $FF, error, "page overlap: PPyx21___xSE"
.assert .lobyte(PPyx21___xSW) <> $FF, error, "page overlap: PPyx21___xSW"
.assert .lobyte(PPyx21_NEx__) <> $FF, error, "page overlap: PPyx21_NEx__"
.assert .lobyte(PPyx21_NExSE) <> $FF, error, "page overlap: PPyx21_NExSE"
.assert PPyx0 + PPyx0_NWx__ - PPyx0 = PPyx0_NWx__, error, "ptr: PPyx0_NWx__"
.assert PPyx0 + PPyx0_NEx__ - PPyx0 = PPyx0_NEx__, error, "ptr: PPyx0_NEx__"
.assert PPyx0 + PPyx0___xSE - PPyx0 = PPyx0___xSE, error, "ptr: PPyx0___xSE"
.assert PPyx0 + PPyx0___xSW - PPyx0 = PPyx0___xSW, error, "ptr: PPyx0___xSW"
.assert PPyx1 + PPyx0_NWx__ - PPyx0 = PPyx1_NWx__, error, "ptr: PPyx1_NWx__"
.assert PPyx1 + PPyx0_NEx__ - PPyx0 = PPyx1_NEx__, error, "ptr: PPyx1_NEx__"
.assert PPyx1 + PPyx0___xSE - PPyx0 = PPyx1___xSE, error, "ptr: PPyx1___xSE"
.assert PPyx1 + PPyx0___xSW - PPyx0 = PPyx1___xSW, error, "ptr: PPyx1___xSW"
.assert PPyx2 + PPyx0_NWx__ - PPyx0 = PPyx2_NWx__, error, "ptr: PPyx2_NWx__"
.assert PPyx2 + PPyx0_NEx__ - PPyx0 = PPyx2_NEx__, error, "ptr: PPyx2_NEx__"
.assert PPyx2 + PPyx0___xSE - PPyx0 = PPyx2___xSE, error, "ptr: PPyx2___xSE"
.assert PPyx2 + PPyx0___xSW - PPyx0 = PPyx2___xSW, error, "ptr: PPyx2___xSW"
.assert PPyx3 + PPyx0_NWx__ - PPyx0 = PPyx3_NWx__, error, "ptr: PPyx3_NWx__"
.assert PPyx3 + PPyx0_NEx__ - PPyx0 = PPyx3_NEx__, error, "ptr: PPyx3_NEx__"
.assert PPyx3 + PPyx0___xSE - PPyx0 = PPyx3___xSE, error, "ptr: PPyx3___xSE"
.assert PPyx3 + PPyx0___xSW - PPyx0 = PPyx3___xSW, error, "ptr: PPyx3___xSW"
.assert PPyx4 + PPyx0_NWx__ - PPyx0 = PPyx4_NWx__, error, "ptr: PPyx4_NWx__"
.assert PPyx4 + PPyx0_NEx__ - PPyx0 = PPyx4_NEx__, error, "ptr: PPyx4_NEx__"
.assert PPyx4 + PPyx0___xSE - PPyx0 = PPyx4___xSE, error, "ptr: PPyx4___xSE"
.assert PPyx4 + PPyx0___xSW - PPyx0 = PPyx4___xSW, error, "ptr: PPyx4___xSW"
.assert PPyx5 + PPyx0_NWx__ - PPyx0 = PPyx5_NWx__, error, "ptr: PPyx5_NWx__"
.assert PPyx5 + PPyx0_NEx__ - PPyx0 = PPyx5_NEx__, error, "ptr: PPyx5_NEx__"
.assert PPyx5 + PPyx0___xSE - PPyx0 = PPyx5___xSE, error, "ptr: PPyx5___xSE"
.assert PPyx5 + PPyx0___xSW - PPyx0 = PPyx5___xSW, error, "ptr: PPyx5___xSW"
.assert PPyx6 + PPyx0_NWx__ - PPyx0 = PPyx6_NWx__, error, "ptr: PPyx6_NWx__"
.assert PPyx6 + PPyx0_NEx__ - PPyx0 = PPyx6_NEx__, error, "ptr: PPyx6_NEx__"
.assert PPyx6 + PPyx0___xSE - PPyx0 = PPyx6___xSE, error, "ptr: PPyx6___xSE"
.assert PPyx6 + PPyx0___xSW - PPyx0 = PPyx6___xSW, error, "ptr: PPyx6___xSW"
.assert PPyx7 + PPyx0_NWx__ - PPyx0 = PPyx7_NWx__, error, "ptr: PPyx7_NWx__"
.assert PPyx7 + PPyx0_NEx__ - PPyx0 = PPyx7_NEx__, error, "ptr: PPyx7_NEx__"
.assert PPyx7 + PPyx0___xSE - PPyx0 = PPyx7___xSE, error, "ptr: PPyx7___xSE"
.assert PPyx7 + PPyx0___xSW - PPyx0 = PPyx7___xSW, error, "ptr: PPyx7___xSW"
.assert PPyx8 + PPyx0_NWx__ - PPyx0 = PPyx8_NWx__, error, "ptr: PPyx8_NWx__"
.assert PPyx8 + PPyx0_NEx__ - PPyx0 = PPyx8_NEx__, error, "ptr: PPyx8_NEx__"
.assert PPyx8 + PPyx0___xSE - PPyx0 = PPyx8___xSE, error, "ptr: PPyx8___xSE"
.assert PPyx8 + PPyx0___xSW - PPyx0 = PPyx8___xSW, error, "ptr: PPyx8___xSW"
.assert PPyx9 + PPyx0_NWx__ - PPyx0 = PPyx9_NWx__, error, "ptr: PPyx9_NWx__"
.assert PPyx9 + PPyx0_NEx__ - PPyx0 = PPyx9_NEx__, error, "ptr: PPyx9_NEx__"
.assert PPyx9 + PPyx0___xSE - PPyx0 = PPyx9___xSE, error, "ptr: PPyx9___xSE"
.assert PPyx9 + PPyx0___xSW - PPyx0 = PPyx9___xSW, error, "ptr: PPyx9___xSW"
.assert PPyx10 + PPyx0_NWx__ - PPyx0 = PPyx10_NWx__, error, "ptr: PPyx10_NWx__"
.assert PPyx10 + PPyx0_NEx__ - PPyx0 = PPyx10_NEx__, error, "ptr: PPyx10_NEx__"
.assert PPyx10 + PPyx0___xSE - PPyx0 = PPyx10___xSE, error, "ptr: PPyx10___xSE"
.assert PPyx10 + PPyx0___xSW - PPyx0 = PPyx10___xSW, error, "ptr: PPyx10___xSW"
.assert PPyx11 + PPyx0_NWx__ - PPyx0 = PPyx11_NWx__, error, "ptr: PPyx11_NWx__"
.assert PPyx11 + PPyx0_NEx__ - PPyx0 = PPyx11_NEx__, error, "ptr: PPyx11_NEx__"
.assert PPyx11 + PPyx0___xSE - PPyx0 = PPyx11___xSE, error, "ptr: PPyx11___xSE"
.assert PPyx11 + PPyx0___xSW - PPyx0 = PPyx11___xSW, error, "ptr: PPyx11___xSW"
.assert PPyx12 + PPyx0_NWx__ - PPyx0 = PPyx12_NWx__, error, "ptr: PPyx12_NWx__"
.assert PPyx12 + PPyx0_NEx__ - PPyx0 = PPyx12_NEx__, error, "ptr: PPyx12_NEx__"
.assert PPyx12 + PPyx0___xSE - PPyx0 = PPyx12___xSE, error, "ptr: PPyx12___xSE"
.assert PPyx12 + PPyx0___xSW - PPyx0 = PPyx12___xSW, error, "ptr: PPyx12___xSW"
.assert PPyx13 + PPyx0_NWx__ - PPyx0 = PPyx13_NWx__, error, "ptr: PPyx13_NWx__"
.assert PPyx13 + PPyx0_NEx__ - PPyx0 = PPyx13_NEx__, error, "ptr: PPyx13_NEx__"
.assert PPyx13 + PPyx0___xSE - PPyx0 = PPyx13___xSE, error, "ptr: PPyx13___xSE"
.assert PPyx13 + PPyx0___xSW - PPyx0 = PPyx13___xSW, error, "ptr: PPyx13___xSW"
.assert PPyx14 + PPyx0_NWx__ - PPyx0 = PPyx14_NWx__, error, "ptr: PPyx14_NWx__"
.assert PPyx14 + PPyx0_NEx__ - PPyx0 = PPyx14_NEx__, error, "ptr: PPyx14_NEx__"
.assert PPyx14 + PPyx0___xSE - PPyx0 = PPyx14___xSE, error, "ptr: PPyx14___xSE"
.assert PPyx14 + PPyx0___xSW - PPyx0 = PPyx14___xSW, error, "ptr: PPyx14___xSW"
.assert PPyx15 + PPyx0_NWx__ - PPyx0 = PPyx15_NWx__, error, "ptr: PPyx15_NWx__"
.assert PPyx15 + PPyx0_NEx__ - PPyx0 = PPyx15_NEx__, error, "ptr: PPyx15_NEx__"
.assert PPyx15 + PPyx0___xSE - PPyx0 = PPyx15___xSE, error, "ptr: PPyx15___xSE"
.assert PPyx15 + PPyx0___xSW - PPyx0 = PPyx15___xSW, error, "ptr: PPyx15___xSW"
.assert PPyx16 + PPyx0_NWx__ - PPyx0 = PPyx16_NWx__, error, "ptr: PPyx16_NWx__"
.assert PPyx16 + PPyx0_NEx__ - PPyx0 = PPyx16_NEx__, error, "ptr: PPyx16_NEx__"
.assert PPyx16 + PPyx0___xSE - PPyx0 = PPyx16___xSE, error, "ptr: PPyx16___xSE"
.assert PPyx16 + PPyx0___xSW - PPyx0 = PPyx16___xSW, error, "ptr: PPyx16___xSW"
.assert PPyx17 + PPyx0_NWx__ - PPyx0 = PPyx17_NWx__, error, "ptr: PPyx17_NWx__"
.assert PPyx17 + PPyx0_NEx__ - PPyx0 = PPyx17_NEx__, error, "ptr: PPyx17_NEx__"
.assert PPyx17 + PPyx0___xSE - PPyx0 = PPyx17___xSE, error, "ptr: PPyx17___xSE"
.assert PPyx17 + PPyx0___xSW - PPyx0 = PPyx17___xSW, error, "ptr: PPyx17___xSW"
.assert PPyx18 + PPyx0_NWx__ - PPyx0 = PPyx18_NWx__, error, "ptr: PPyx18_NWx__"
.assert PPyx18 + PPyx0_NEx__ - PPyx0 = PPyx18_NEx__, error, "ptr: PPyx18_NEx__"
.assert PPyx18 + PPyx0___xSE - PPyx0 = PPyx18___xSE, error, "ptr: PPyx18___xSE"
.assert PPyx18 + PPyx0___xSW - PPyx0 = PPyx18___xSW, error, "ptr: PPyx18___xSW"
.assert PPyx19 + PPyx0_NWx__ - PPyx0 = PPyx19_NWx__, error, "ptr: PPyx19_NWx__"
.assert PPyx19 + PPyx0_NEx__ - PPyx0 = PPyx19_NEx__, error, "ptr: PPyx19_NEx__"
.assert PPyx19 + PPyx0___xSE - PPyx0 = PPyx19___xSE, error, "ptr: PPyx19___xSE"
.assert PPyx19 + PPyx0___xSW - PPyx0 = PPyx19___xSW, error, "ptr: PPyx19___xSW"
.assert PPyx20 + PPyx0_NWx__ - PPyx0 = PPyx20_NWx__, error, "ptr: PPyx20_NWx__"
.assert PPyx20 + PPyx0_NEx__ - PPyx0 = PPyx20_NEx__, error, "ptr: PPyx20_NEx__"
.assert PPyx20 + PPyx0___xSE - PPyx0 = PPyx20___xSE, error, "ptr: PPyx20___xSE"
.assert PPyx20 + PPyx0___xSW - PPyx0 = PPyx20___xSW, error, "ptr: PPyx20___xSW"
.assert PPyx21 + PPyx0_NWx__ - PPyx0 = PPyx21_NWx__, error, "ptr: PPyx21_NWx__"
.assert PPyx21 + PPyx0_NEx__ - PPyx0 = PPyx21_NEx__, error, "ptr: PPyx21_NEx__"
.assert PPyx21 + PPyx0___xSE - PPyx0 = PPyx21___xSE, error, "ptr: PPyx21___xSE"
.assert PPyx21 + PPyx0___xSW - PPyx0 = PPyx21___xSW, error, "ptr: PPyx21___xSW"
.assert PPxy0 + PPxy0_NWx__ - PPxy0 = PPxy0_NWx__, error, "ptr: PPxy0_NWx__"
.assert PPxy0 + PPxy0_SWx__ - PPxy0 = PPxy0_SWx__, error, "ptr: PPxy0_SWx__"
.assert PPxy0 + PPxy0___xNE - PPxy0 = PPxy0___xNE, error, "ptr: PPxy0___xNE"
.assert PPxy0 + PPxy0___xSE - PPxy0 = PPxy0___xSE, error, "ptr: PPxy0___xSE"
.assert PPxy1 + PPxy0_NWx__ - PPxy0 = PPxy1_NWx__, error, "ptr: PPxy1_NWx__"
.assert PPxy1 + PPxy0_SWx__ - PPxy0 = PPxy1_SWx__, error, "ptr: PPxy1_SWx__"
.assert PPxy1 + PPxy0___xNE - PPxy0 = PPxy1___xNE, error, "ptr: PPxy1___xNE"
.assert PPxy1 + PPxy0___xSE - PPxy0 = PPxy1___xSE, error, "ptr: PPxy1___xSE"
.assert PPxy2 + PPxy0_NWx__ - PPxy0 = PPxy2_NWx__, error, "ptr: PPxy2_NWx__"
.assert PPxy2 + PPxy0_SWx__ - PPxy0 = PPxy2_SWx__, error, "ptr: PPxy2_SWx__"
.assert PPxy2 + PPxy0___xNE - PPxy0 = PPxy2___xNE, error, "ptr: PPxy2___xNE"
.assert PPxy2 + PPxy0___xSE - PPxy0 = PPxy2___xSE, error, "ptr: PPxy2___xSE"
.assert PPxy3 + PPxy0_NWx__ - PPxy0 = PPxy3_NWx__, error, "ptr: PPxy3_NWx__"
.assert PPxy3 + PPxy0_SWx__ - PPxy0 = PPxy3_SWx__, error, "ptr: PPxy3_SWx__"
.assert PPxy3 + PPxy0___xNE - PPxy0 = PPxy3___xNE, error, "ptr: PPxy3___xNE"
.assert PPxy3 + PPxy0___xSE - PPxy0 = PPxy3___xSE, error, "ptr: PPxy3___xSE"
.assert PPxy4 + PPxy0_NWx__ - PPxy0 = PPxy4_NWx__, error, "ptr: PPxy4_NWx__"
.assert PPxy4 + PPxy0_SWx__ - PPxy0 = PPxy4_SWx__, error, "ptr: PPxy4_SWx__"
.assert PPxy4 + PPxy0___xNE - PPxy0 = PPxy4___xNE, error, "ptr: PPxy4___xNE"
.assert PPxy4 + PPxy0___xSE - PPxy0 = PPxy4___xSE, error, "ptr: PPxy4___xSE"
.assert PPxy5 + PPxy0_NWx__ - PPxy0 = PPxy5_NWx__, error, "ptr: PPxy5_NWx__"
.assert PPxy5 + PPxy0_SWx__ - PPxy0 = PPxy5_SWx__, error, "ptr: PPxy5_SWx__"
.assert PPxy5 + PPxy0___xNE - PPxy0 = PPxy5___xNE, error, "ptr: PPxy5___xNE"
.assert PPxy5 + PPxy0___xSE - PPxy0 = PPxy5___xSE, error, "ptr: PPxy5___xSE"
.assert PPxy6 + PPxy0_NWx__ - PPxy0 = PPxy6_NWx__, error, "ptr: PPxy6_NWx__"
.assert PPxy6 + PPxy0_SWx__ - PPxy0 = PPxy6_SWx__, error, "ptr: PPxy6_SWx__"
.assert PPxy6 + PPxy0___xNE - PPxy0 = PPxy6___xNE, error, "ptr: PPxy6___xNE"
.assert PPxy6 + PPxy0___xSE - PPxy0 = PPxy6___xSE, error, "ptr: PPxy6___xSE"
.assert PPxy7 + PPxy0_NWx__ - PPxy0 = PPxy7_NWx__, error, "ptr: PPxy7_NWx__"
.assert PPxy7 + PPxy0_SWx__ - PPxy0 = PPxy7_SWx__, error, "ptr: PPxy7_SWx__"
.assert PPxy7 + PPxy0___xNE - PPxy0 = PPxy7___xNE, error, "ptr: PPxy7___xNE"
.assert PPxy7 + PPxy0___xSE - PPxy0 = PPxy7___xSE, error, "ptr: PPxy7___xSE"
.assert PPxy8 + PPxy0_NWx__ - PPxy0 = PPxy8_NWx__, error, "ptr: PPxy8_NWx__"
.assert PPxy8 + PPxy0_SWx__ - PPxy0 = PPxy8_SWx__, error, "ptr: PPxy8_SWx__"
.assert PPxy8 + PPxy0___xNE - PPxy0 = PPxy8___xNE, error, "ptr: PPxy8___xNE"
.assert PPxy8 + PPxy0___xSE - PPxy0 = PPxy8___xSE, error, "ptr: PPxy8___xSE"
.assert PPxy9 + PPxy0_NWx__ - PPxy0 = PPxy9_NWx__, error, "ptr: PPxy9_NWx__"
.assert PPxy9 + PPxy0_SWx__ - PPxy0 = PPxy9_SWx__, error, "ptr: PPxy9_SWx__"
.assert PPxy9 + PPxy0___xNE - PPxy0 = PPxy9___xNE, error, "ptr: PPxy9___xNE"
.assert PPxy9 + PPxy0___xSE - PPxy0 = PPxy9___xSE, error, "ptr: PPxy9___xSE"
.assert PPxy10 + PPxy0_NWx__ - PPxy0 = PPxy10_NWx__, error, "ptr: PPxy10_NWx__"
.assert PPxy10 + PPxy0_SWx__ - PPxy0 = PPxy10_SWx__, error, "ptr: PPxy10_SWx__"
.assert PPxy10 + PPxy0___xNE - PPxy0 = PPxy10___xNE, error, "ptr: PPxy10___xNE"
.assert PPxy10 + PPxy0___xSE - PPxy0 = PPxy10___xSE, error, "ptr: PPxy10___xSE"
.assert PPxy11 + PPxy0_NWx__ - PPxy0 = PPxy11_NWx__, error, "ptr: PPxy11_NWx__"
.assert PPxy11 + PPxy0_SWx__ - PPxy0 = PPxy11_SWx__, error, "ptr: PPxy11_SWx__"
.assert PPxy11 + PPxy0___xNE - PPxy0 = PPxy11___xNE, error, "ptr: PPxy11___xNE"
.assert PPxy11 + PPxy0___xSE - PPxy0 = PPxy11___xSE, error, "ptr: PPxy11___xSE"
.assert PPxy12 + PPxy0_NWx__ - PPxy0 = PPxy12_NWx__, error, "ptr: PPxy12_NWx__"
.assert PPxy12 + PPxy0_SWx__ - PPxy0 = PPxy12_SWx__, error, "ptr: PPxy12_SWx__"
.assert PPxy12 + PPxy0___xNE - PPxy0 = PPxy12___xNE, error, "ptr: PPxy12___xNE"
.assert PPxy12 + PPxy0___xSE - PPxy0 = PPxy12___xSE, error, "ptr: PPxy12___xSE"
.assert PPxy13 + PPxy0_NWx__ - PPxy0 = PPxy13_NWx__, error, "ptr: PPxy13_NWx__"
.assert PPxy13 + PPxy0_SWx__ - PPxy0 = PPxy13_SWx__, error, "ptr: PPxy13_SWx__"
.assert PPxy13 + PPxy0___xNE - PPxy0 = PPxy13___xNE, error, "ptr: PPxy13___xNE"
.assert PPxy13 + PPxy0___xSE - PPxy0 = PPxy13___xSE, error, "ptr: PPxy13___xSE"
.assert PPxy14 + PPxy0_NWx__ - PPxy0 = PPxy14_NWx__, error, "ptr: PPxy14_NWx__"
.assert PPxy14 + PPxy0_SWx__ - PPxy0 = PPxy14_SWx__, error, "ptr: PPxy14_SWx__"
.assert PPxy14 + PPxy0___xNE - PPxy0 = PPxy14___xNE, error, "ptr: PPxy14___xNE"
.assert PPxy14 + PPxy0___xSE - PPxy0 = PPxy14___xSE, error, "ptr: PPxy14___xSE"
.assert PPxy15 + PPxy0_NWx__ - PPxy0 = PPxy15_NWx__, error, "ptr: PPxy15_NWx__"
.assert PPxy15 + PPxy0_SWx__ - PPxy0 = PPxy15_SWx__, error, "ptr: PPxy15_SWx__"
.assert PPxy15 + PPxy0___xNE - PPxy0 = PPxy15___xNE, error, "ptr: PPxy15___xNE"
.assert PPxy15 + PPxy0___xSE - PPxy0 = PPxy15___xSE, error, "ptr: PPxy15___xSE"
.assert PPxy16 + PPxy0_NWx__ - PPxy0 = PPxy16_NWx__, error, "ptr: PPxy16_NWx__"
.assert PPxy16 + PPxy0_SWx__ - PPxy0 = PPxy16_SWx__, error, "ptr: PPxy16_SWx__"
.assert PPxy16 + PPxy0___xNE - PPxy0 = PPxy16___xNE, error, "ptr: PPxy16___xNE"
.assert PPxy16 + PPxy0___xSE - PPxy0 = PPxy16___xSE, error, "ptr: PPxy16___xSE"
.assert PPxy17 + PPxy0_NWx__ - PPxy0 = PPxy17_NWx__, error, "ptr: PPxy17_NWx__"
.assert PPxy17 + PPxy0_SWx__ - PPxy0 = PPxy17_SWx__, error, "ptr: PPxy17_SWx__"
.assert PPxy17 + PPxy0___xNE - PPxy0 = PPxy17___xNE, error, "ptr: PPxy17___xNE"
.assert PPxy17 + PPxy0___xSE - PPxy0 = PPxy17___xSE, error, "ptr: PPxy17___xSE"
.assert PPxy18 + PPxy0_NWx__ - PPxy0 = PPxy18_NWx__, error, "ptr: PPxy18_NWx__"
.assert PPxy18 + PPxy0_SWx__ - PPxy0 = PPxy18_SWx__, error, "ptr: PPxy18_SWx__"
.assert PPxy18 + PPxy0___xNE - PPxy0 = PPxy18___xNE, error, "ptr: PPxy18___xNE"
.assert PPxy18 + PPxy0___xSE - PPxy0 = PPxy18___xSE, error, "ptr: PPxy18___xSE"
.assert PPxy19 + PPxy0_NWx__ - PPxy0 = PPxy19_NWx__, error, "ptr: PPxy19_NWx__"
.assert PPxy19 + PPxy0_SWx__ - PPxy0 = PPxy19_SWx__, error, "ptr: PPxy19_SWx__"
.assert PPxy19 + PPxy0___xNE - PPxy0 = PPxy19___xNE, error, "ptr: PPxy19___xNE"
.assert PPxy19 + PPxy0___xSE - PPxy0 = PPxy19___xSE, error, "ptr: PPxy19___xSE"
.assert PPxy20 + PPxy0_NWx__ - PPxy0 = PPxy20_NWx__, error, "ptr: PPxy20_NWx__"
.assert PPxy20 + PPxy0_SWx__ - PPxy0 = PPxy20_SWx__, error, "ptr: PPxy20_SWx__"
.assert PPxy20 + PPxy0___xNE - PPxy0 = PPxy20___xNE, error, "ptr: PPxy20___xNE"
.assert PPxy20 + PPxy0___xSE - PPxy0 = PPxy20___xSE, error, "ptr: PPxy20___xSE"
.assert PPxy21 + PPxy0_NWx__ - PPxy0 = PPxy21_NWx__, error, "ptr: PPxy21_NWx__"
.assert PPxy21 + PPxy0_SWx__ - PPxy0 = PPxy21_SWx__, error, "ptr: PPxy21_SWx__"
.assert PPxy21 + PPxy0___xNE - PPxy0 = PPxy21___xNE, error, "ptr: PPxy21___xNE"
.assert PPxy21 + PPxy0___xSE - PPxy0 = PPxy21___xSE, error, "ptr: PPxy21___xSE"
.segment "LINE_UNROLLED"
    nop
    nop
NPxy0:
NPxy0_store___xNE:
    lda #8
    or_buffer 0
    cpx to_x
    beq NPxy0_return
    tya
    dex
    sbc Dy
    bcc NPxy0_adc_SWx__
NPxy0_NWx__:
    sbc Dy
    bcs NPxy0_NWxNE
    adc rounded_Dx
NPxy0_NWxSE:
    tay
    lda #6
    or_buffer 0
    cpx to_x
    beq NPxy0_return
    tya
    dex
    sbc Dy
    bcs NPxy0_SWx__
    adc rounded_Dx
    jmp NPxy1_NWx__
NPxy0_NWxNE:
    tay
    lda #12
    or_buffer 0
    cpx to_x
    beq NPxy0_return
    tya
    dex
    sbc Dy
    bcs NPxy0_NWx__
NPxy0_adc_SWx__:
    adc rounded_Dx
NPxy0_SWx__:
    sbc Dy
    bcc NPxy0_fill_SWx__
NPxy0_SWxSE:
    tay
    lda #3
NPxy0_store___xSE:
    or_buffer 0
    cpx to_x
    beq NPxy0_return
    tya
    dex
    sbc Dy
    bcs NPxy0_SWx__
    adc rounded_Dx
    jmp NPxy1_NWx__
NPxy0_return:
    rts
NPxy0___xSE:
    tay
    lda #2
    jmp NPxy0_store___xSE
NPxy0___xNE:
    tay
    jmp NPxy0_store___xNE
NPxy0_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 0
NPxy1:
NPxy1_store___xNE:
    lda #8
    or_buffer 1
    cpx to_x
    beq NPxy1_return
    tya
    dex
    sbc Dy
    bcc NPxy1_adc_SWx__
NPxy1_NWx__:
    sbc Dy
    bcs NPxy1_NWxNE
    adc rounded_Dx
NPxy1_NWxSE:
    tay
    lda #6
    or_buffer 1
    cpx to_x
    beq NPxy1_return
    tya
    dex
    sbc Dy
    bcs NPxy1_SWx__
    adc rounded_Dx
    jmp NPxy2_NWx__
NPxy1_NWxNE:
    tay
    lda #12
    or_buffer 1
    cpx to_x
    beq NPxy1_return
    tya
    dex
    sbc Dy
    bcs NPxy1_NWx__
NPxy1_adc_SWx__:
    adc rounded_Dx
NPxy1_SWx__:
    sbc Dy
    bcc NPxy1_fill_SWx__
NPxy1_SWxSE:
    tay
    lda #3
NPxy1_store___xSE:
    or_buffer 1
    cpx to_x
    beq NPxy1_return
    tya
    dex
    sbc Dy
    bcs NPxy1_SWx__
    adc rounded_Dx
    jmp NPxy2_NWx__
NPxy1_return:
    rts
NPxy1___xSE:
    tay
    lda #2
    jmp NPxy1_store___xSE
NPxy1___xNE:
    tay
    jmp NPxy1_store___xNE
NPxy1_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 1
NPxy2:
NPxy2_store___xNE:
    lda #8
    or_buffer 2
    cpx to_x
    beq NPxy2_return
    tya
    dex
    sbc Dy
    bcc NPxy2_adc_SWx__
NPxy2_NWx__:
    sbc Dy
    bcs NPxy2_NWxNE
    adc rounded_Dx
NPxy2_NWxSE:
    tay
    lda #6
    or_buffer 2
    cpx to_x
    beq NPxy2_return
    tya
    dex
    sbc Dy
    bcs NPxy2_SWx__
    adc rounded_Dx
    jmp NPxy3_NWx__
NPxy2_NWxNE:
    tay
    lda #12
    or_buffer 2
    cpx to_x
    beq NPxy2_return
    tya
    dex
    sbc Dy
    bcs NPxy2_NWx__
NPxy2_adc_SWx__:
    adc rounded_Dx
NPxy2_SWx__:
    sbc Dy
    bcc NPxy2_fill_SWx__
NPxy2_SWxSE:
    tay
    lda #3
NPxy2_store___xSE:
    or_buffer 2
    cpx to_x
    beq NPxy2_return
    tya
    dex
    sbc Dy
    bcs NPxy2_SWx__
    adc rounded_Dx
    jmp NPxy3_NWx__
NPxy2_return:
    rts
NPxy2___xSE:
    tay
    lda #2
    jmp NPxy2_store___xSE
NPxy2___xNE:
    tay
    jmp NPxy2_store___xNE
NPxy2_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 2
NPxy3:
NPxy3_store___xNE:
    lda #8
    or_buffer 3
    cpx to_x
    beq NPxy3_return
    tya
    dex
    sbc Dy
    bcc NPxy3_adc_SWx__
NPxy3_NWx__:
    sbc Dy
    bcs NPxy3_NWxNE
    adc rounded_Dx
NPxy3_NWxSE:
    tay
    lda #6
    or_buffer 3
    cpx to_x
    beq NPxy3_return
    tya
    dex
    sbc Dy
    bcs NPxy3_SWx__
    adc rounded_Dx
    jmp NPxy4_NWx__
NPxy3_NWxNE:
    tay
    lda #12
    or_buffer 3
    cpx to_x
    beq NPxy3_return
    tya
    dex
    sbc Dy
    bcs NPxy3_NWx__
NPxy3_adc_SWx__:
    adc rounded_Dx
NPxy3_SWx__:
    sbc Dy
    bcc NPxy3_fill_SWx__
NPxy3_SWxSE:
    tay
    lda #3
NPxy3_store___xSE:
    or_buffer 3
    cpx to_x
    beq NPxy3_return
    tya
    dex
    sbc Dy
    bcs NPxy3_SWx__
    adc rounded_Dx
    jmp NPxy4_NWx__
NPxy3_return:
    rts
NPxy3___xSE:
    tay
    lda #2
    jmp NPxy3_store___xSE
NPxy3___xNE:
    tay
    jmp NPxy3_store___xNE
NPxy3_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 3
NPxy4:
NPxy4_store___xNE:
    lda #8
    or_buffer 4
    cpx to_x
    beq NPxy4_return
    tya
    dex
    sbc Dy
    bcc NPxy4_adc_SWx__
NPxy4_NWx__:
    sbc Dy
    bcs NPxy4_NWxNE
    adc rounded_Dx
NPxy4_NWxSE:
    tay
    lda #6
    or_buffer 4
    cpx to_x
    beq NPxy4_return
    tya
    dex
    sbc Dy
    bcs NPxy4_SWx__
    adc rounded_Dx
    jmp NPxy5_NWx__
NPxy4_NWxNE:
    tay
    lda #12
    or_buffer 4
    cpx to_x
    beq NPxy4_return
    tya
    dex
    sbc Dy
    bcs NPxy4_NWx__
NPxy4_adc_SWx__:
    adc rounded_Dx
NPxy4_SWx__:
    sbc Dy
    bcc NPxy4_fill_SWx__
NPxy4_SWxSE:
    tay
    lda #3
NPxy4_store___xSE:
    or_buffer 4
    cpx to_x
    beq NPxy4_return
    tya
    dex
    sbc Dy
    bcs NPxy4_SWx__
    adc rounded_Dx
    jmp NPxy5_NWx__
NPxy4_return:
    rts
NPxy4___xSE:
    tay
    lda #2
    jmp NPxy4_store___xSE
NPxy4___xNE:
    tay
    jmp NPxy4_store___xNE
NPxy4_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 4
NPxy5:
NPxy5_store___xNE:
    lda #8
    or_buffer 5
    cpx to_x
    beq NPxy5_return
    tya
    dex
    sbc Dy
    bcc NPxy5_adc_SWx__
NPxy5_NWx__:
    sbc Dy
    bcs NPxy5_NWxNE
    adc rounded_Dx
NPxy5_NWxSE:
    tay
    lda #6
    or_buffer 5
    cpx to_x
    beq NPxy5_return
    tya
    dex
    sbc Dy
    bcs NPxy5_SWx__
    adc rounded_Dx
    jmp NPxy6_NWx__
NPxy5_NWxNE:
    tay
    lda #12
    or_buffer 5
    cpx to_x
    beq NPxy5_return
    tya
    dex
    sbc Dy
    bcs NPxy5_NWx__
NPxy5_adc_SWx__:
    adc rounded_Dx
NPxy5_SWx__:
    sbc Dy
    bcc NPxy5_fill_SWx__
NPxy5_SWxSE:
    tay
    lda #3
NPxy5_store___xSE:
    or_buffer 5
    cpx to_x
    beq NPxy5_return
    tya
    dex
    sbc Dy
    bcs NPxy5_SWx__
    adc rounded_Dx
    jmp NPxy6_NWx__
NPxy5_return:
    rts
NPxy5___xSE:
    tay
    lda #2
    jmp NPxy5_store___xSE
NPxy5___xNE:
    tay
    jmp NPxy5_store___xNE
NPxy5_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 5
NPxy6:
NPxy6_store___xNE:
    lda #8
    or_buffer 6
    cpx to_x
    beq NPxy6_return
    tya
    dex
    sbc Dy
    bcc NPxy6_adc_SWx__
NPxy6_NWx__:
    sbc Dy
    bcs NPxy6_NWxNE
    adc rounded_Dx
NPxy6_NWxSE:
    tay
    lda #6
    or_buffer 6
    cpx to_x
    beq NPxy6_return
    tya
    dex
    sbc Dy
    bcs NPxy6_SWx__
    adc rounded_Dx
    jmp NPxy7_NWx__
NPxy6_NWxNE:
    tay
    lda #12
    or_buffer 6
    cpx to_x
    beq NPxy6_return
    tya
    dex
    sbc Dy
    bcs NPxy6_NWx__
NPxy6_adc_SWx__:
    adc rounded_Dx
NPxy6_SWx__:
    sbc Dy
    bcc NPxy6_fill_SWx__
NPxy6_SWxSE:
    tay
    lda #3
NPxy6_store___xSE:
    or_buffer 6
    cpx to_x
    beq NPxy6_return
    tya
    dex
    sbc Dy
    bcs NPxy6_SWx__
    adc rounded_Dx
    jmp NPxy7_NWx__
NPxy6_return:
    rts
NPxy6___xSE:
    tay
    lda #2
    jmp NPxy6_store___xSE
NPxy6___xNE:
    tay
    jmp NPxy6_store___xNE
NPxy6_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 6
NPxy7:
NPxy7_store___xNE:
    lda #8
    or_buffer 7
    cpx to_x
    beq NPxy7_return
    tya
    dex
    sbc Dy
    bcc NPxy7_adc_SWx__
NPxy7_NWx__:
    sbc Dy
    bcs NPxy7_NWxNE
    adc rounded_Dx
NPxy7_NWxSE:
    tay
    lda #6
    or_buffer 7
    cpx to_x
    beq NPxy7_return
    tya
    dex
    sbc Dy
    bcs NPxy7_SWx__
    adc rounded_Dx
    jmp NPxy8_NWx__
NPxy7_NWxNE:
    tay
    lda #12
    or_buffer 7
    cpx to_x
    beq NPxy7_return
    tya
    dex
    sbc Dy
    bcs NPxy7_NWx__
NPxy7_adc_SWx__:
    adc rounded_Dx
NPxy7_SWx__:
    sbc Dy
    bcc NPxy7_fill_SWx__
NPxy7_SWxSE:
    tay
    lda #3
NPxy7_store___xSE:
    or_buffer 7
    cpx to_x
    beq NPxy7_return
    tya
    dex
    sbc Dy
    bcs NPxy7_SWx__
    adc rounded_Dx
    jmp NPxy8_NWx__
NPxy7_return:
    rts
NPxy7___xSE:
    tay
    lda #2
    jmp NPxy7_store___xSE
NPxy7___xNE:
    tay
    jmp NPxy7_store___xNE
NPxy7_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 7
NPxy8:
NPxy8_store___xNE:
    lda #8
    or_buffer 8
    cpx to_x
    beq NPxy8_return
    tya
    dex
    sbc Dy
    bcc NPxy8_adc_SWx__
NPxy8_NWx__:
    sbc Dy
    bcs NPxy8_NWxNE
    adc rounded_Dx
NPxy8_NWxSE:
    tay
    lda #6
    or_buffer 8
    cpx to_x
    beq NPxy8_return
    tya
    dex
    sbc Dy
    bcs NPxy8_SWx__
    adc rounded_Dx
    jmp NPxy9_NWx__
NPxy8_NWxNE:
    tay
    lda #12
    or_buffer 8
    cpx to_x
    beq NPxy8_return
    tya
    dex
    sbc Dy
    bcs NPxy8_NWx__
NPxy8_adc_SWx__:
    adc rounded_Dx
NPxy8_SWx__:
    sbc Dy
    bcc NPxy8_fill_SWx__
NPxy8_SWxSE:
    tay
    lda #3
NPxy8_store___xSE:
    or_buffer 8
    cpx to_x
    beq NPxy8_return
    tya
    dex
    sbc Dy
    bcs NPxy8_SWx__
    adc rounded_Dx
    jmp NPxy9_NWx__
NPxy8_return:
    rts
NPxy8___xSE:
    tay
    lda #2
    jmp NPxy8_store___xSE
NPxy8___xNE:
    tay
    jmp NPxy8_store___xNE
NPxy8_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 8
NPxy9:
NPxy9_store___xNE:
    lda #8
    or_buffer 9
    cpx to_x
    beq NPxy9_return
    tya
    dex
    sbc Dy
    bcc NPxy9_adc_SWx__
NPxy9_NWx__:
    sbc Dy
    bcs NPxy9_NWxNE
    adc rounded_Dx
NPxy9_NWxSE:
    tay
    lda #6
    or_buffer 9
    cpx to_x
    beq NPxy9_return
    tya
    dex
    sbc Dy
    bcs NPxy9_SWx__
    adc rounded_Dx
    jmp NPxy10_NWx__
NPxy9_NWxNE:
    tay
    lda #12
    or_buffer 9
    cpx to_x
    beq NPxy9_return
    tya
    dex
    sbc Dy
    bcs NPxy9_NWx__
NPxy9_adc_SWx__:
    adc rounded_Dx
NPxy9_SWx__:
    sbc Dy
    bcc NPxy9_fill_SWx__
NPxy9_SWxSE:
    tay
    lda #3
NPxy9_store___xSE:
    or_buffer 9
    cpx to_x
    beq NPxy9_return
    tya
    dex
    sbc Dy
    bcs NPxy9_SWx__
    adc rounded_Dx
    jmp NPxy10_NWx__
NPxy9_return:
    rts
NPxy9___xSE:
    tay
    lda #2
    jmp NPxy9_store___xSE
NPxy9___xNE:
    tay
    jmp NPxy9_store___xNE
NPxy9_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 9
NPxy10:
NPxy10_store___xNE:
    lda #8
    or_buffer 10
    cpx to_x
    beq NPxy10_return
    tya
    dex
    sbc Dy
    bcc NPxy10_adc_SWx__
NPxy10_NWx__:
    sbc Dy
    bcs NPxy10_NWxNE
    adc rounded_Dx
NPxy10_NWxSE:
    tay
    lda #6
    or_buffer 10
    cpx to_x
    beq NPxy10_return
    tya
    dex
    sbc Dy
    bcs NPxy10_SWx__
    adc rounded_Dx
    jmp NPxy11_NWx__
NPxy10_NWxNE:
    tay
    lda #12
    or_buffer 10
    cpx to_x
    beq NPxy10_return
    tya
    dex
    sbc Dy
    bcs NPxy10_NWx__
NPxy10_adc_SWx__:
    adc rounded_Dx
NPxy10_SWx__:
    sbc Dy
    bcc NPxy10_fill_SWx__
NPxy10_SWxSE:
    tay
    lda #3
NPxy10_store___xSE:
    or_buffer 10
    cpx to_x
    beq NPxy10_return
    tya
    dex
    sbc Dy
    bcs NPxy10_SWx__
    adc rounded_Dx
    jmp NPxy11_NWx__
NPxy10_return:
    rts
NPxy10___xSE:
    tay
    lda #2
    jmp NPxy10_store___xSE
NPxy10___xNE:
    tay
    jmp NPxy10_store___xNE
NPxy10_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 10
NPxy11:
NPxy11_store___xNE:
    lda #8
    or_buffer 11
    cpx to_x
    beq NPxy11_return
    tya
    dex
    sbc Dy
    bcc NPxy11_adc_SWx__
NPxy11_NWx__:
    sbc Dy
    bcs NPxy11_NWxNE
    adc rounded_Dx
NPxy11_NWxSE:
    tay
    lda #6
    or_buffer 11
    cpx to_x
    beq NPxy11_return
    tya
    dex
    sbc Dy
    bcs NPxy11_SWx__
    adc rounded_Dx
    jmp NPxy12_NWx__
NPxy11_NWxNE:
    tay
    lda #12
    or_buffer 11
    cpx to_x
    beq NPxy11_return
    tya
    dex
    sbc Dy
    bcs NPxy11_NWx__
NPxy11_adc_SWx__:
    adc rounded_Dx
NPxy11_SWx__:
    sbc Dy
    bcc NPxy11_fill_SWx__
NPxy11_SWxSE:
    tay
    lda #3
NPxy11_store___xSE:
    or_buffer 11
    cpx to_x
    beq NPxy11_return
    tya
    dex
    sbc Dy
    bcs NPxy11_SWx__
    adc rounded_Dx
    jmp NPxy12_NWx__
NPxy11_return:
    rts
NPxy11___xSE:
    tay
    lda #2
    jmp NPxy11_store___xSE
NPxy11___xNE:
    tay
    jmp NPxy11_store___xNE
NPxy11_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 11
NPxy12:
NPxy12_store___xNE:
    lda #8
    or_buffer 12
    cpx to_x
    beq NPxy12_return
    tya
    dex
    sbc Dy
    bcc NPxy12_adc_SWx__
NPxy12_NWx__:
    sbc Dy
    bcs NPxy12_NWxNE
    adc rounded_Dx
NPxy12_NWxSE:
    tay
    lda #6
    or_buffer 12
    cpx to_x
    beq NPxy12_return
    tya
    dex
    sbc Dy
    bcs NPxy12_SWx__
    adc rounded_Dx
    jmp NPxy13_NWx__
NPxy12_NWxNE:
    tay
    lda #12
    or_buffer 12
    cpx to_x
    beq NPxy12_return
    tya
    dex
    sbc Dy
    bcs NPxy12_NWx__
NPxy12_adc_SWx__:
    adc rounded_Dx
NPxy12_SWx__:
    sbc Dy
    bcc NPxy12_fill_SWx__
NPxy12_SWxSE:
    tay
    lda #3
NPxy12_store___xSE:
    or_buffer 12
    cpx to_x
    beq NPxy12_return
    tya
    dex
    sbc Dy
    bcs NPxy12_SWx__
    adc rounded_Dx
    jmp NPxy13_NWx__
NPxy12_return:
    rts
NPxy12___xSE:
    tay
    lda #2
    jmp NPxy12_store___xSE
NPxy12___xNE:
    tay
    jmp NPxy12_store___xNE
NPxy12_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 12
NPxy13:
NPxy13_store___xNE:
    lda #8
    or_buffer 13
    cpx to_x
    beq NPxy13_return
    tya
    dex
    sbc Dy
    bcc NPxy13_adc_SWx__
NPxy13_NWx__:
    sbc Dy
    bcs NPxy13_NWxNE
    adc rounded_Dx
NPxy13_NWxSE:
    tay
    lda #6
    or_buffer 13
    cpx to_x
    beq NPxy13_return
    tya
    dex
    sbc Dy
    bcs NPxy13_SWx__
    adc rounded_Dx
    jmp NPxy14_NWx__
NPxy13_NWxNE:
    tay
    lda #12
    or_buffer 13
    cpx to_x
    beq NPxy13_return
    tya
    dex
    sbc Dy
    bcs NPxy13_NWx__
NPxy13_adc_SWx__:
    adc rounded_Dx
NPxy13_SWx__:
    sbc Dy
    bcc NPxy13_fill_SWx__
NPxy13_SWxSE:
    tay
    lda #3
NPxy13_store___xSE:
    or_buffer 13
    cpx to_x
    beq NPxy13_return
    tya
    dex
    sbc Dy
    bcs NPxy13_SWx__
    adc rounded_Dx
    jmp NPxy14_NWx__
NPxy13_return:
    rts
NPxy13___xSE:
    tay
    lda #2
    jmp NPxy13_store___xSE
NPxy13___xNE:
    tay
    jmp NPxy13_store___xNE
NPxy13_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 13
NPxy14:
NPxy14_store___xNE:
    lda #8
    or_buffer 14
    cpx to_x
    beq NPxy14_return
    tya
    dex
    sbc Dy
    bcc NPxy14_adc_SWx__
NPxy14_NWx__:
    sbc Dy
    bcs NPxy14_NWxNE
    adc rounded_Dx
NPxy14_NWxSE:
    tay
    lda #6
    or_buffer 14
    cpx to_x
    beq NPxy14_return
    tya
    dex
    sbc Dy
    bcs NPxy14_SWx__
    adc rounded_Dx
    jmp NPxy15_NWx__
NPxy14_NWxNE:
    tay
    lda #12
    or_buffer 14
    cpx to_x
    beq NPxy14_return
    tya
    dex
    sbc Dy
    bcs NPxy14_NWx__
NPxy14_adc_SWx__:
    adc rounded_Dx
NPxy14_SWx__:
    sbc Dy
    bcc NPxy14_fill_SWx__
NPxy14_SWxSE:
    tay
    lda #3
NPxy14_store___xSE:
    or_buffer 14
    cpx to_x
    beq NPxy14_return
    tya
    dex
    sbc Dy
    bcs NPxy14_SWx__
    adc rounded_Dx
    jmp NPxy15_NWx__
NPxy14_return:
    rts
NPxy14___xSE:
    tay
    lda #2
    jmp NPxy14_store___xSE
NPxy14___xNE:
    tay
    jmp NPxy14_store___xNE
NPxy14_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 14
NPxy15:
NPxy15_store___xNE:
    lda #8
    or_buffer 15
    cpx to_x
    beq NPxy15_return
    tya
    dex
    sbc Dy
    bcc NPxy15_adc_SWx__
NPxy15_NWx__:
    sbc Dy
    bcs NPxy15_NWxNE
    adc rounded_Dx
NPxy15_NWxSE:
    tay
    lda #6
    or_buffer 15
    cpx to_x
    beq NPxy15_return
    tya
    dex
    sbc Dy
    bcs NPxy15_SWx__
    adc rounded_Dx
    jmp NPxy16_NWx__
NPxy15_NWxNE:
    tay
    lda #12
    or_buffer 15
    cpx to_x
    beq NPxy15_return
    tya
    dex
    sbc Dy
    bcs NPxy15_NWx__
NPxy15_adc_SWx__:
    adc rounded_Dx
NPxy15_SWx__:
    sbc Dy
    bcc NPxy15_fill_SWx__
NPxy15_SWxSE:
    tay
    lda #3
NPxy15_store___xSE:
    or_buffer 15
    cpx to_x
    beq NPxy15_return
    tya
    dex
    sbc Dy
    bcs NPxy15_SWx__
    adc rounded_Dx
    jmp NPxy16_NWx__
NPxy15_return:
    rts
NPxy15___xSE:
    tay
    lda #2
    jmp NPxy15_store___xSE
NPxy15___xNE:
    tay
    jmp NPxy15_store___xNE
NPxy15_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 15
NPxy16:
NPxy16_store___xNE:
    lda #8
    or_buffer 16
    cpx to_x
    beq NPxy16_return
    tya
    dex
    sbc Dy
    bcc NPxy16_adc_SWx__
NPxy16_NWx__:
    sbc Dy
    bcs NPxy16_NWxNE
    adc rounded_Dx
NPxy16_NWxSE:
    tay
    lda #6
    or_buffer 16
    cpx to_x
    beq NPxy16_return
    tya
    dex
    sbc Dy
    bcs NPxy16_SWx__
    adc rounded_Dx
    jmp NPxy17_NWx__
NPxy16_NWxNE:
    tay
    lda #12
    or_buffer 16
    cpx to_x
    beq NPxy16_return
    tya
    dex
    sbc Dy
    bcs NPxy16_NWx__
NPxy16_adc_SWx__:
    adc rounded_Dx
NPxy16_SWx__:
    sbc Dy
    bcc NPxy16_fill_SWx__
NPxy16_SWxSE:
    tay
    lda #3
NPxy16_store___xSE:
    or_buffer 16
    cpx to_x
    beq NPxy16_return
    tya
    dex
    sbc Dy
    bcs NPxy16_SWx__
    adc rounded_Dx
    jmp NPxy17_NWx__
NPxy16_return:
    rts
NPxy16___xSE:
    tay
    lda #2
    jmp NPxy16_store___xSE
NPxy16___xNE:
    tay
    jmp NPxy16_store___xNE
NPxy16_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 16
NPxy17:
NPxy17_store___xNE:
    lda #8
    or_buffer 17
    cpx to_x
    beq NPxy17_return
    tya
    dex
    sbc Dy
    bcc NPxy17_adc_SWx__
NPxy17_NWx__:
    sbc Dy
    bcs NPxy17_NWxNE
    adc rounded_Dx
NPxy17_NWxSE:
    tay
    lda #6
    or_buffer 17
    cpx to_x
    beq NPxy17_return
    tya
    dex
    sbc Dy
    bcs NPxy17_SWx__
    adc rounded_Dx
    jmp NPxy18_NWx__
NPxy17_NWxNE:
    tay
    lda #12
    or_buffer 17
    cpx to_x
    beq NPxy17_return
    tya
    dex
    sbc Dy
    bcs NPxy17_NWx__
NPxy17_adc_SWx__:
    adc rounded_Dx
NPxy17_SWx__:
    sbc Dy
    bcc NPxy17_fill_SWx__
NPxy17_SWxSE:
    tay
    lda #3
NPxy17_store___xSE:
    or_buffer 17
    cpx to_x
    beq NPxy17_return
    tya
    dex
    sbc Dy
    bcs NPxy17_SWx__
    adc rounded_Dx
    jmp NPxy18_NWx__
NPxy17_return:
    rts
NPxy17___xSE:
    tay
    lda #2
    jmp NPxy17_store___xSE
NPxy17___xNE:
    tay
    jmp NPxy17_store___xNE
NPxy17_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 17
NPxy18:
NPxy18_store___xNE:
    lda #8
    or_buffer 18
    cpx to_x
    beq NPxy18_return
    tya
    dex
    sbc Dy
    bcc NPxy18_adc_SWx__
NPxy18_NWx__:
    sbc Dy
    bcs NPxy18_NWxNE
    adc rounded_Dx
NPxy18_NWxSE:
    tay
    lda #6
    or_buffer 18
    cpx to_x
    beq NPxy18_return
    tya
    dex
    sbc Dy
    bcs NPxy18_SWx__
    adc rounded_Dx
    jmp NPxy19_NWx__
NPxy18_NWxNE:
    tay
    lda #12
    or_buffer 18
    cpx to_x
    beq NPxy18_return
    tya
    dex
    sbc Dy
    bcs NPxy18_NWx__
NPxy18_adc_SWx__:
    adc rounded_Dx
NPxy18_SWx__:
    sbc Dy
    bcc NPxy18_fill_SWx__
NPxy18_SWxSE:
    tay
    lda #3
NPxy18_store___xSE:
    or_buffer 18
    cpx to_x
    beq NPxy18_return
    tya
    dex
    sbc Dy
    bcs NPxy18_SWx__
    adc rounded_Dx
    jmp NPxy19_NWx__
NPxy18_return:
    rts
NPxy18___xSE:
    tay
    lda #2
    jmp NPxy18_store___xSE
NPxy18___xNE:
    tay
    jmp NPxy18_store___xNE
NPxy18_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 18
NPxy19:
NPxy19_store___xNE:
    lda #8
    or_buffer 19
    cpx to_x
    beq NPxy19_return
    tya
    dex
    sbc Dy
    bcc NPxy19_adc_SWx__
NPxy19_NWx__:
    sbc Dy
    bcs NPxy19_NWxNE
    adc rounded_Dx
NPxy19_NWxSE:
    tay
    lda #6
    or_buffer 19
    cpx to_x
    beq NPxy19_return
    tya
    dex
    sbc Dy
    bcs NPxy19_SWx__
    adc rounded_Dx
    jmp NPxy20_NWx__
NPxy19_NWxNE:
    tay
    lda #12
    or_buffer 19
    cpx to_x
    beq NPxy19_return
    tya
    dex
    sbc Dy
    bcs NPxy19_NWx__
NPxy19_adc_SWx__:
    adc rounded_Dx
NPxy19_SWx__:
    sbc Dy
    bcc NPxy19_fill_SWx__
NPxy19_SWxSE:
    tay
    lda #3
NPxy19_store___xSE:
    or_buffer 19
    cpx to_x
    beq NPxy19_return
    tya
    dex
    sbc Dy
    bcs NPxy19_SWx__
    adc rounded_Dx
    jmp NPxy20_NWx__
NPxy19_return:
    rts
NPxy19___xSE:
    tay
    lda #2
    jmp NPxy19_store___xSE
NPxy19___xNE:
    tay
    jmp NPxy19_store___xNE
NPxy19_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 19
NPxy20:
NPxy20_store___xNE:
    lda #8
    or_buffer 20
    cpx to_x
    beq NPxy20_return
    tya
    dex
    sbc Dy
    bcc NPxy20_adc_SWx__
NPxy20_NWx__:
    sbc Dy
    bcs NPxy20_NWxNE
    adc rounded_Dx
NPxy20_NWxSE:
    tay
    lda #6
    or_buffer 20
    cpx to_x
    beq NPxy20_return
    tya
    dex
    sbc Dy
    bcs NPxy20_SWx__
    adc rounded_Dx
    jmp NPxy21_NWx__
NPxy20_NWxNE:
    tay
    lda #12
    or_buffer 20
    cpx to_x
    beq NPxy20_return
    tya
    dex
    sbc Dy
    bcs NPxy20_NWx__
NPxy20_adc_SWx__:
    adc rounded_Dx
NPxy20_SWx__:
    sbc Dy
    bcc NPxy20_fill_SWx__
NPxy20_SWxSE:
    tay
    lda #3
NPxy20_store___xSE:
    or_buffer 20
    cpx to_x
    beq NPxy20_return
    tya
    dex
    sbc Dy
    bcs NPxy20_SWx__
    adc rounded_Dx
    jmp NPxy21_NWx__
NPxy20_return:
    rts
NPxy20___xSE:
    tay
    lda #2
    jmp NPxy20_store___xSE
NPxy20___xNE:
    tay
    jmp NPxy20_store___xNE
NPxy20_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 20
NPxy21:
NPxy21_store___xNE:
    lda #8
    or_buffer 21
    cpx to_x
    beq NPxy21_return
    tya
    dex
    sbc Dy
    bcc NPxy21_adc_SWx__
NPxy21_NWx__:
    sbc Dy
    bcs NPxy21_NWxNE
    adc rounded_Dx
NPxy21_NWxSE:
    tay
    lda #6
    or_buffer 21
    cpx to_x
    beq NPxy21_return
    tya
    dex
    sbc Dy
    bcs NPxy21_SWx__
    rts
    nop
    nop
    nop
    nop
NPxy21_NWxNE:
    tay
    lda #12
    or_buffer 21
    cpx to_x
    beq NPxy21_return
    tya
    dex
    sbc Dy
    bcs NPxy21_NWx__
NPxy21_adc_SWx__:
    adc rounded_Dx
NPxy21_SWx__:
    sbc Dy
    bcc NPxy21_fill_SWx__
NPxy21_SWxSE:
    tay
    lda #3
NPxy21_store___xSE:
    or_buffer 21
    cpx to_x
    beq NPxy21_return
    tya
    dex
    sbc Dy
    bcs NPxy21_SWx__
    rts
    nop
    nop
    nop
    nop
NPxy21_return:
    rts
NPxy21___xSE:
    tay
    lda #2
    jmp NPxy21_store___xSE
NPxy21___xNE:
    tay
    jmp NPxy21_store___xNE
NPxy21_fill_SWx__:
    adc rounded_Dx
    tay
    lda #1
    or_buffer 21
    rts
    nop
    nop
    nop
NPyx0:
NPyx0_adc_NWx__:
    adc rounded_Dy
    dex
NPyx0_NWx__:
    sbc Dx
    bcs NPyx0_NWxSW
    adc rounded_Dy
NPyx0_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 0
    dey
    beq NPyx0_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx1_adc_NWx__
    jmp NPyx1_NEx__
NPyx0_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 0
    dey
    beq NPyx0_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx1_NWx__
    adc rounded_Dy
    jmp NPyx1_NEx__
NPyx0_adc_NEx__:
    adc rounded_Dy
NPyx0_NEx__:
    sbc Dx
    bcc NPyx0_fill_NEx__
NPyx0_NExSE:
    sta subroutine_temp
    lda #10
NPyx0_store___xSE:
    or_buffer 0
    dey
    beq NPyx0_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx1_NEx__
    adc rounded_Dy
    dex
    jmp NPyx1_NWx__
NPyx0_return:
    rts
NPyx0___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx0_store___xSE
NPyx0_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 0
    dex
NPyx0___xSW:
    lda #1
    or_buffer 0
    dey
    beq NPyx0_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx1_NWx__
    adc rounded_Dy
    jmp NPyx1_NEx__
NPyx1:
NPyx1_adc_NWx__:
    adc rounded_Dy
    dex
NPyx1_NWx__:
    sbc Dx
    bcs NPyx1_NWxSW
    adc rounded_Dy
NPyx1_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 1
    dey
    beq NPyx1_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx2_adc_NWx__
    jmp NPyx2_NEx__
NPyx1_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 1
    dey
    beq NPyx1_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx2_NWx__
    adc rounded_Dy
    jmp NPyx2_NEx__
NPyx1_adc_NEx__:
    adc rounded_Dy
NPyx1_NEx__:
    sbc Dx
    bcc NPyx1_fill_NEx__
NPyx1_NExSE:
    sta subroutine_temp
    lda #10
NPyx1_store___xSE:
    or_buffer 1
    dey
    beq NPyx1_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx2_NEx__
    adc rounded_Dy
    dex
    jmp NPyx2_NWx__
NPyx1_return:
    rts
NPyx1___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx1_store___xSE
NPyx1_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 1
    dex
NPyx1___xSW:
    lda #1
    or_buffer 1
    dey
    beq NPyx1_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx2_NWx__
    adc rounded_Dy
    jmp NPyx2_NEx__
NPyx2:
NPyx2_adc_NWx__:
    adc rounded_Dy
    dex
NPyx2_NWx__:
    sbc Dx
    bcs NPyx2_NWxSW
    adc rounded_Dy
NPyx2_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 2
    dey
    beq NPyx2_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx3_adc_NWx__
    jmp NPyx3_NEx__
NPyx2_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 2
    dey
    beq NPyx2_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx3_NWx__
    adc rounded_Dy
    jmp NPyx3_NEx__
NPyx2_adc_NEx__:
    adc rounded_Dy
NPyx2_NEx__:
    sbc Dx
    bcc NPyx2_fill_NEx__
NPyx2_NExSE:
    sta subroutine_temp
    lda #10
NPyx2_store___xSE:
    or_buffer 2
    dey
    beq NPyx2_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx3_NEx__
    adc rounded_Dy
    dex
    jmp NPyx3_NWx__
NPyx2_return:
    rts
NPyx2___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx2_store___xSE
NPyx2_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 2
    dex
NPyx2___xSW:
    lda #1
    or_buffer 2
    dey
    beq NPyx2_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx3_NWx__
    adc rounded_Dy
    jmp NPyx3_NEx__
NPyx3:
NPyx3_adc_NWx__:
    adc rounded_Dy
    dex
NPyx3_NWx__:
    sbc Dx
    bcs NPyx3_NWxSW
    adc rounded_Dy
NPyx3_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 3
    dey
    beq NPyx3_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx4_adc_NWx__
    jmp NPyx4_NEx__
NPyx3_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 3
    dey
    beq NPyx3_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx4_NWx__
    adc rounded_Dy
    jmp NPyx4_NEx__
NPyx3_adc_NEx__:
    adc rounded_Dy
NPyx3_NEx__:
    sbc Dx
    bcc NPyx3_fill_NEx__
NPyx3_NExSE:
    sta subroutine_temp
    lda #10
NPyx3_store___xSE:
    or_buffer 3
    dey
    beq NPyx3_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx4_NEx__
    adc rounded_Dy
    dex
    jmp NPyx4_NWx__
NPyx3_return:
    rts
NPyx3___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx3_store___xSE
NPyx3_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 3
    dex
NPyx3___xSW:
    lda #1
    or_buffer 3
    dey
    beq NPyx3_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx4_NWx__
    adc rounded_Dy
    jmp NPyx4_NEx__
NPyx4:
NPyx4_adc_NWx__:
    adc rounded_Dy
    dex
NPyx4_NWx__:
    sbc Dx
    bcs NPyx4_NWxSW
    adc rounded_Dy
NPyx4_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 4
    dey
    beq NPyx4_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx5_adc_NWx__
    jmp NPyx5_NEx__
NPyx4_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 4
    dey
    beq NPyx4_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx5_NWx__
    adc rounded_Dy
    jmp NPyx5_NEx__
NPyx4_adc_NEx__:
    adc rounded_Dy
NPyx4_NEx__:
    sbc Dx
    bcc NPyx4_fill_NEx__
NPyx4_NExSE:
    sta subroutine_temp
    lda #10
NPyx4_store___xSE:
    or_buffer 4
    dey
    beq NPyx4_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx5_NEx__
    adc rounded_Dy
    dex
    jmp NPyx5_NWx__
NPyx4_return:
    rts
NPyx4___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx4_store___xSE
NPyx4_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 4
    dex
NPyx4___xSW:
    lda #1
    or_buffer 4
    dey
    beq NPyx4_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx5_NWx__
    adc rounded_Dy
    jmp NPyx5_NEx__
NPyx5:
NPyx5_adc_NWx__:
    adc rounded_Dy
    dex
NPyx5_NWx__:
    sbc Dx
    bcs NPyx5_NWxSW
    adc rounded_Dy
NPyx5_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 5
    dey
    beq NPyx5_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx6_adc_NWx__
    jmp NPyx6_NEx__
NPyx5_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 5
    dey
    beq NPyx5_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx6_NWx__
    adc rounded_Dy
    jmp NPyx6_NEx__
NPyx5_adc_NEx__:
    adc rounded_Dy
NPyx5_NEx__:
    sbc Dx
    bcc NPyx5_fill_NEx__
NPyx5_NExSE:
    sta subroutine_temp
    lda #10
NPyx5_store___xSE:
    or_buffer 5
    dey
    beq NPyx5_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx6_NEx__
    adc rounded_Dy
    dex
    jmp NPyx6_NWx__
NPyx5_return:
    rts
NPyx5___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx5_store___xSE
NPyx5_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 5
    dex
NPyx5___xSW:
    lda #1
    or_buffer 5
    dey
    beq NPyx5_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx6_NWx__
    adc rounded_Dy
    jmp NPyx6_NEx__
NPyx6:
NPyx6_adc_NWx__:
    adc rounded_Dy
    dex
NPyx6_NWx__:
    sbc Dx
    bcs NPyx6_NWxSW
    adc rounded_Dy
NPyx6_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 6
    dey
    beq NPyx6_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx7_adc_NWx__
    jmp NPyx7_NEx__
NPyx6_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 6
    dey
    beq NPyx6_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx7_NWx__
    adc rounded_Dy
    jmp NPyx7_NEx__
NPyx6_adc_NEx__:
    adc rounded_Dy
NPyx6_NEx__:
    sbc Dx
    bcc NPyx6_fill_NEx__
NPyx6_NExSE:
    sta subroutine_temp
    lda #10
NPyx6_store___xSE:
    or_buffer 6
    dey
    beq NPyx6_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx7_NEx__
    adc rounded_Dy
    dex
    jmp NPyx7_NWx__
NPyx6_return:
    rts
NPyx6___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx6_store___xSE
NPyx6_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 6
    dex
NPyx6___xSW:
    lda #1
    or_buffer 6
    dey
    beq NPyx6_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx7_NWx__
    adc rounded_Dy
    jmp NPyx7_NEx__
NPyx7:
NPyx7_adc_NWx__:
    adc rounded_Dy
    dex
NPyx7_NWx__:
    sbc Dx
    bcs NPyx7_NWxSW
    adc rounded_Dy
NPyx7_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 7
    dey
    beq NPyx7_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx8_adc_NWx__
    jmp NPyx8_NEx__
NPyx7_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 7
    dey
    beq NPyx7_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx8_NWx__
    adc rounded_Dy
    jmp NPyx8_NEx__
NPyx7_adc_NEx__:
    adc rounded_Dy
NPyx7_NEx__:
    sbc Dx
    bcc NPyx7_fill_NEx__
NPyx7_NExSE:
    sta subroutine_temp
    lda #10
NPyx7_store___xSE:
    or_buffer 7
    dey
    beq NPyx7_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx8_NEx__
    adc rounded_Dy
    dex
    jmp NPyx8_NWx__
NPyx7_return:
    rts
NPyx7___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx7_store___xSE
NPyx7_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 7
    dex
NPyx7___xSW:
    lda #1
    or_buffer 7
    dey
    beq NPyx7_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx8_NWx__
    adc rounded_Dy
    jmp NPyx8_NEx__
NPyx8:
NPyx8_adc_NWx__:
    adc rounded_Dy
    dex
NPyx8_NWx__:
    sbc Dx
    bcs NPyx8_NWxSW
    adc rounded_Dy
NPyx8_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 8
    dey
    beq NPyx8_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx9_adc_NWx__
    jmp NPyx9_NEx__
NPyx8_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 8
    dey
    beq NPyx8_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx9_NWx__
    adc rounded_Dy
    jmp NPyx9_NEx__
NPyx8_adc_NEx__:
    adc rounded_Dy
NPyx8_NEx__:
    sbc Dx
    bcc NPyx8_fill_NEx__
NPyx8_NExSE:
    sta subroutine_temp
    lda #10
NPyx8_store___xSE:
    or_buffer 8
    dey
    beq NPyx8_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx9_NEx__
    adc rounded_Dy
    dex
    jmp NPyx9_NWx__
NPyx8_return:
    rts
NPyx8___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx8_store___xSE
NPyx8_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 8
    dex
NPyx8___xSW:
    lda #1
    or_buffer 8
    dey
    beq NPyx8_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx9_NWx__
    adc rounded_Dy
    jmp NPyx9_NEx__
NPyx9:
NPyx9_adc_NWx__:
    adc rounded_Dy
    dex
NPyx9_NWx__:
    sbc Dx
    bcs NPyx9_NWxSW
    adc rounded_Dy
NPyx9_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 9
    dey
    beq NPyx9_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx10_adc_NWx__
    jmp NPyx10_NEx__
NPyx9_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 9
    dey
    beq NPyx9_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx10_NWx__
    adc rounded_Dy
    jmp NPyx10_NEx__
NPyx9_adc_NEx__:
    adc rounded_Dy
NPyx9_NEx__:
    sbc Dx
    bcc NPyx9_fill_NEx__
NPyx9_NExSE:
    sta subroutine_temp
    lda #10
NPyx9_store___xSE:
    or_buffer 9
    dey
    beq NPyx9_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx10_NEx__
    adc rounded_Dy
    dex
    jmp NPyx10_NWx__
NPyx9_return:
    rts
NPyx9___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx9_store___xSE
NPyx9_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 9
    dex
NPyx9___xSW:
    lda #1
    or_buffer 9
    dey
    beq NPyx9_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx10_NWx__
    adc rounded_Dy
    jmp NPyx10_NEx__
NPyx10:
NPyx10_adc_NWx__:
    adc rounded_Dy
    dex
NPyx10_NWx__:
    sbc Dx
    bcs NPyx10_NWxSW
    adc rounded_Dy
NPyx10_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 10
    dey
    beq NPyx10_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx11_adc_NWx__
    jmp NPyx11_NEx__
NPyx10_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 10
    dey
    beq NPyx10_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx11_NWx__
    adc rounded_Dy
    jmp NPyx11_NEx__
NPyx10_adc_NEx__:
    adc rounded_Dy
NPyx10_NEx__:
    sbc Dx
    bcc NPyx10_fill_NEx__
NPyx10_NExSE:
    sta subroutine_temp
    lda #10
NPyx10_store___xSE:
    or_buffer 10
    dey
    beq NPyx10_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx11_NEx__
    adc rounded_Dy
    dex
    jmp NPyx11_NWx__
NPyx10_return:
    rts
NPyx10___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx10_store___xSE
NPyx10_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 10
    dex
NPyx10___xSW:
    lda #1
    or_buffer 10
    dey
    beq NPyx10_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx11_NWx__
    adc rounded_Dy
    jmp NPyx11_NEx__
NPyx11:
NPyx11_adc_NWx__:
    adc rounded_Dy
    dex
NPyx11_NWx__:
    sbc Dx
    bcs NPyx11_NWxSW
    adc rounded_Dy
NPyx11_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 11
    dey
    beq NPyx11_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx12_adc_NWx__
    jmp NPyx12_NEx__
NPyx11_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 11
    dey
    beq NPyx11_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx12_NWx__
    adc rounded_Dy
    jmp NPyx12_NEx__
NPyx11_adc_NEx__:
    adc rounded_Dy
NPyx11_NEx__:
    sbc Dx
    bcc NPyx11_fill_NEx__
NPyx11_NExSE:
    sta subroutine_temp
    lda #10
NPyx11_store___xSE:
    or_buffer 11
    dey
    beq NPyx11_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx12_NEx__
    adc rounded_Dy
    dex
    jmp NPyx12_NWx__
NPyx11_return:
    rts
NPyx11___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx11_store___xSE
NPyx11_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 11
    dex
NPyx11___xSW:
    lda #1
    or_buffer 11
    dey
    beq NPyx11_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx12_NWx__
    adc rounded_Dy
    jmp NPyx12_NEx__
NPyx12:
NPyx12_adc_NWx__:
    adc rounded_Dy
    dex
NPyx12_NWx__:
    sbc Dx
    bcs NPyx12_NWxSW
    adc rounded_Dy
NPyx12_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 12
    dey
    beq NPyx12_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx13_adc_NWx__
    jmp NPyx13_NEx__
NPyx12_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 12
    dey
    beq NPyx12_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx13_NWx__
    adc rounded_Dy
    jmp NPyx13_NEx__
NPyx12_adc_NEx__:
    adc rounded_Dy
NPyx12_NEx__:
    sbc Dx
    bcc NPyx12_fill_NEx__
NPyx12_NExSE:
    sta subroutine_temp
    lda #10
NPyx12_store___xSE:
    or_buffer 12
    dey
    beq NPyx12_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx13_NEx__
    adc rounded_Dy
    dex
    jmp NPyx13_NWx__
NPyx12_return:
    rts
NPyx12___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx12_store___xSE
NPyx12_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 12
    dex
NPyx12___xSW:
    lda #1
    or_buffer 12
    dey
    beq NPyx12_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx13_NWx__
    adc rounded_Dy
    jmp NPyx13_NEx__
NPyx13:
NPyx13_adc_NWx__:
    adc rounded_Dy
    dex
NPyx13_NWx__:
    sbc Dx
    bcs NPyx13_NWxSW
    adc rounded_Dy
NPyx13_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 13
    dey
    beq NPyx13_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx14_adc_NWx__
    jmp NPyx14_NEx__
NPyx13_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 13
    dey
    beq NPyx13_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx14_NWx__
    adc rounded_Dy
    jmp NPyx14_NEx__
NPyx13_adc_NEx__:
    adc rounded_Dy
NPyx13_NEx__:
    sbc Dx
    bcc NPyx13_fill_NEx__
NPyx13_NExSE:
    sta subroutine_temp
    lda #10
NPyx13_store___xSE:
    or_buffer 13
    dey
    beq NPyx13_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx14_NEx__
    adc rounded_Dy
    dex
    jmp NPyx14_NWx__
NPyx13_return:
    rts
NPyx13___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx13_store___xSE
NPyx13_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 13
    dex
NPyx13___xSW:
    lda #1
    or_buffer 13
    dey
    beq NPyx13_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx14_NWx__
    adc rounded_Dy
    jmp NPyx14_NEx__
NPyx14:
NPyx14_adc_NWx__:
    adc rounded_Dy
    dex
NPyx14_NWx__:
    sbc Dx
    bcs NPyx14_NWxSW
    adc rounded_Dy
NPyx14_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 14
    dey
    beq NPyx14_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx15_adc_NWx__
    jmp NPyx15_NEx__
NPyx14_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 14
    dey
    beq NPyx14_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx15_NWx__
    adc rounded_Dy
    jmp NPyx15_NEx__
NPyx14_adc_NEx__:
    adc rounded_Dy
NPyx14_NEx__:
    sbc Dx
    bcc NPyx14_fill_NEx__
NPyx14_NExSE:
    sta subroutine_temp
    lda #10
NPyx14_store___xSE:
    or_buffer 14
    dey
    beq NPyx14_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx15_NEx__
    adc rounded_Dy
    dex
    jmp NPyx15_NWx__
NPyx14_return:
    rts
NPyx14___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx14_store___xSE
NPyx14_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 14
    dex
NPyx14___xSW:
    lda #1
    or_buffer 14
    dey
    beq NPyx14_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx15_NWx__
    adc rounded_Dy
    jmp NPyx15_NEx__
NPyx15:
NPyx15_adc_NWx__:
    adc rounded_Dy
    dex
NPyx15_NWx__:
    sbc Dx
    bcs NPyx15_NWxSW
    adc rounded_Dy
NPyx15_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 15
    dey
    beq NPyx15_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx16_adc_NWx__
    jmp NPyx16_NEx__
NPyx15_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 15
    dey
    beq NPyx15_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx16_NWx__
    adc rounded_Dy
    jmp NPyx16_NEx__
NPyx15_adc_NEx__:
    adc rounded_Dy
NPyx15_NEx__:
    sbc Dx
    bcc NPyx15_fill_NEx__
NPyx15_NExSE:
    sta subroutine_temp
    lda #10
NPyx15_store___xSE:
    or_buffer 15
    dey
    beq NPyx15_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx16_NEx__
    adc rounded_Dy
    dex
    jmp NPyx16_NWx__
NPyx15_return:
    rts
NPyx15___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx15_store___xSE
NPyx15_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 15
    dex
NPyx15___xSW:
    lda #1
    or_buffer 15
    dey
    beq NPyx15_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx16_NWx__
    adc rounded_Dy
    jmp NPyx16_NEx__
NPyx16:
NPyx16_adc_NWx__:
    adc rounded_Dy
    dex
NPyx16_NWx__:
    sbc Dx
    bcs NPyx16_NWxSW
    adc rounded_Dy
NPyx16_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 16
    dey
    beq NPyx16_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx17_adc_NWx__
    jmp NPyx17_NEx__
NPyx16_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 16
    dey
    beq NPyx16_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx17_NWx__
    adc rounded_Dy
    jmp NPyx17_NEx__
NPyx16_adc_NEx__:
    adc rounded_Dy
NPyx16_NEx__:
    sbc Dx
    bcc NPyx16_fill_NEx__
NPyx16_NExSE:
    sta subroutine_temp
    lda #10
NPyx16_store___xSE:
    or_buffer 16
    dey
    beq NPyx16_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx17_NEx__
    adc rounded_Dy
    dex
    jmp NPyx17_NWx__
NPyx16_return:
    rts
NPyx16___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx16_store___xSE
NPyx16_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 16
    dex
NPyx16___xSW:
    lda #1
    or_buffer 16
    dey
    beq NPyx16_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx17_NWx__
    adc rounded_Dy
    jmp NPyx17_NEx__
NPyx17:
NPyx17_adc_NWx__:
    adc rounded_Dy
    dex
NPyx17_NWx__:
    sbc Dx
    bcs NPyx17_NWxSW
    adc rounded_Dy
NPyx17_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 17
    dey
    beq NPyx17_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx18_adc_NWx__
    jmp NPyx18_NEx__
NPyx17_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 17
    dey
    beq NPyx17_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx18_NWx__
    adc rounded_Dy
    jmp NPyx18_NEx__
NPyx17_adc_NEx__:
    adc rounded_Dy
NPyx17_NEx__:
    sbc Dx
    bcc NPyx17_fill_NEx__
NPyx17_NExSE:
    sta subroutine_temp
    lda #10
NPyx17_store___xSE:
    or_buffer 17
    dey
    beq NPyx17_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx18_NEx__
    adc rounded_Dy
    dex
    jmp NPyx18_NWx__
NPyx17_return:
    rts
NPyx17___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx17_store___xSE
NPyx17_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 17
    dex
NPyx17___xSW:
    lda #1
    or_buffer 17
    dey
    beq NPyx17_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx18_NWx__
    adc rounded_Dy
    jmp NPyx18_NEx__
NPyx18:
NPyx18_adc_NWx__:
    adc rounded_Dy
    dex
NPyx18_NWx__:
    sbc Dx
    bcs NPyx18_NWxSW
    adc rounded_Dy
NPyx18_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 18
    dey
    beq NPyx18_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx19_adc_NWx__
    jmp NPyx19_NEx__
NPyx18_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 18
    dey
    beq NPyx18_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx19_NWx__
    adc rounded_Dy
    jmp NPyx19_NEx__
NPyx18_adc_NEx__:
    adc rounded_Dy
NPyx18_NEx__:
    sbc Dx
    bcc NPyx18_fill_NEx__
NPyx18_NExSE:
    sta subroutine_temp
    lda #10
NPyx18_store___xSE:
    or_buffer 18
    dey
    beq NPyx18_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx19_NEx__
    adc rounded_Dy
    dex
    jmp NPyx19_NWx__
NPyx18_return:
    rts
NPyx18___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx18_store___xSE
NPyx18_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 18
    dex
NPyx18___xSW:
    lda #1
    or_buffer 18
    dey
    beq NPyx18_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx19_NWx__
    adc rounded_Dy
    jmp NPyx19_NEx__
NPyx19:
NPyx19_adc_NWx__:
    adc rounded_Dy
    dex
NPyx19_NWx__:
    sbc Dx
    bcs NPyx19_NWxSW
    adc rounded_Dy
NPyx19_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 19
    dey
    beq NPyx19_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx20_adc_NWx__
    jmp NPyx20_NEx__
NPyx19_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 19
    dey
    beq NPyx19_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx20_NWx__
    adc rounded_Dy
    jmp NPyx20_NEx__
NPyx19_adc_NEx__:
    adc rounded_Dy
NPyx19_NEx__:
    sbc Dx
    bcc NPyx19_fill_NEx__
NPyx19_NExSE:
    sta subroutine_temp
    lda #10
NPyx19_store___xSE:
    or_buffer 19
    dey
    beq NPyx19_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx20_NEx__
    adc rounded_Dy
    dex
    jmp NPyx20_NWx__
NPyx19_return:
    rts
NPyx19___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx19_store___xSE
NPyx19_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 19
    dex
NPyx19___xSW:
    lda #1
    or_buffer 19
    dey
    beq NPyx19_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx20_NWx__
    adc rounded_Dy
    jmp NPyx20_NEx__
NPyx20:
NPyx20_adc_NWx__:
    adc rounded_Dy
    dex
NPyx20_NWx__:
    sbc Dx
    bcs NPyx20_NWxSW
    adc rounded_Dy
NPyx20_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 20
    dey
    beq NPyx20_return
    lda subroutine_temp
    sbc Dx
    bcc NPyx21_adc_NWx__
    jmp NPyx21_NEx__
NPyx20_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 20
    dey
    beq NPyx20_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx21_NWx__
    adc rounded_Dy
    jmp NPyx21_NEx__
NPyx20_adc_NEx__:
    adc rounded_Dy
NPyx20_NEx__:
    sbc Dx
    bcc NPyx20_fill_NEx__
NPyx20_NExSE:
    sta subroutine_temp
    lda #10
NPyx20_store___xSE:
    or_buffer 20
    dey
    beq NPyx20_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx21_NEx__
    adc rounded_Dy
    dex
    jmp NPyx21_NWx__
NPyx20_return:
    rts
NPyx20___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx20_store___xSE
NPyx20_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 20
    dex
NPyx20___xSW:
    lda #1
    or_buffer 20
    dey
    beq NPyx20_return
    lda subroutine_temp
    sbc Dx
    bcs NPyx21_NWx__
    adc rounded_Dy
    jmp NPyx21_NEx__
NPyx21:
NPyx21_adc_NWx__:
    adc rounded_Dy
    dex
NPyx21_NWx__:
    sbc Dx
    bcs NPyx21_NWxSW
    adc rounded_Dy
NPyx21_NWxSE:
    sta subroutine_temp
    lda #6
    or_buffer 21
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
NPyx21_NWxSW:
    sta subroutine_temp
    lda #5
    or_buffer 21
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
NPyx21_adc_NEx__:
    adc rounded_Dy
NPyx21_NEx__:
    sbc Dx
    bcc NPyx21_fill_NEx__
NPyx21_NExSE:
    sta subroutine_temp
    lda #10
NPyx21_store___xSE:
    or_buffer 21
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
    rts
NPyx21_return:
    rts
NPyx21___xSE:
    sta subroutine_temp
    lda #2
    jmp NPyx21_store___xSE
NPyx21_fill_NEx__:
    adc rounded_Dy
    sta subroutine_temp
    lda #8
    or_buffer 21
    dex
NPyx21___xSW:
    lda #1
    or_buffer 21
    rts
.segment "RODATA"
NPxy_lo:
.byt .lobyte(NPxy0)
.byt .lobyte(NPxy1)
.byt .lobyte(NPxy2)
.byt .lobyte(NPxy3)
.byt .lobyte(NPxy4)
.byt .lobyte(NPxy5)
.byt .lobyte(NPxy6)
.byt .lobyte(NPxy7)
.byt .lobyte(NPxy8)
.byt .lobyte(NPxy9)
.byt .lobyte(NPxy10)
.byt .lobyte(NPxy11)
.byt .lobyte(NPxy12)
.byt .lobyte(NPxy13)
.byt .lobyte(NPxy14)
.byt .lobyte(NPxy15)
.byt .lobyte(NPxy16)
.byt .lobyte(NPxy17)
.byt .lobyte(NPxy18)
.byt .lobyte(NPxy19)
.byt .lobyte(NPxy20)
.byt .lobyte(NPxy21)
NPxy_hi:
.byt .hibyte(NPxy0)
.byt .hibyte(NPxy1)
.byt .hibyte(NPxy2)
.byt .hibyte(NPxy3)
.byt .hibyte(NPxy4)
.byt .hibyte(NPxy5)
.byt .hibyte(NPxy6)
.byt .hibyte(NPxy7)
.byt .hibyte(NPxy8)
.byt .hibyte(NPxy9)
.byt .hibyte(NPxy10)
.byt .hibyte(NPxy11)
.byt .hibyte(NPxy12)
.byt .hibyte(NPxy13)
.byt .hibyte(NPxy14)
.byt .hibyte(NPxy15)
.byt .hibyte(NPxy16)
.byt .hibyte(NPxy17)
.byt .hibyte(NPxy18)
.byt .hibyte(NPxy19)
.byt .hibyte(NPxy20)
.byt .hibyte(NPxy21)
NPxy_offset:
.byt NPxy0___xNE - NPxy0
.byt NPxy0___xSE - NPxy0
.byt NPxy0_NWx__ - NPxy0
.byt NPxy0_SWx__ - NPxy0
NPyx_lo:
.byt .lobyte(NPyx0)
.byt .lobyte(NPyx1)
.byt .lobyte(NPyx2)
.byt .lobyte(NPyx3)
.byt .lobyte(NPyx4)
.byt .lobyte(NPyx5)
.byt .lobyte(NPyx6)
.byt .lobyte(NPyx7)
.byt .lobyte(NPyx8)
.byt .lobyte(NPyx9)
.byt .lobyte(NPyx10)
.byt .lobyte(NPyx11)
.byt .lobyte(NPyx12)
.byt .lobyte(NPyx13)
.byt .lobyte(NPyx14)
.byt .lobyte(NPyx15)
.byt .lobyte(NPyx16)
.byt .lobyte(NPyx17)
.byt .lobyte(NPyx18)
.byt .lobyte(NPyx19)
.byt .lobyte(NPyx20)
.byt .lobyte(NPyx21)
NPyx_hi:
.byt .hibyte(NPyx0)
.byt .hibyte(NPyx1)
.byt .hibyte(NPyx2)
.byt .hibyte(NPyx3)
.byt .hibyte(NPyx4)
.byt .hibyte(NPyx5)
.byt .hibyte(NPyx6)
.byt .hibyte(NPyx7)
.byt .hibyte(NPyx8)
.byt .hibyte(NPyx9)
.byt .hibyte(NPyx10)
.byt .hibyte(NPyx11)
.byt .hibyte(NPyx12)
.byt .hibyte(NPyx13)
.byt .hibyte(NPyx14)
.byt .hibyte(NPyx15)
.byt .hibyte(NPyx16)
.byt .hibyte(NPyx17)
.byt .hibyte(NPyx18)
.byt .hibyte(NPyx19)
.byt .hibyte(NPyx20)
.byt .hibyte(NPyx21)
NPyx_offset:
.byt NPyx0_NEx__ - NPyx0
.byt NPyx0___xSE - NPyx0
.byt NPyx0_NWx__ - NPyx0
.byt NPyx0___xSW - NPyx0
.assert .lobyte(NPxy0_NWx__) <> $FF, error, "page overlap: NPxy0_NWx__"
.assert .lobyte(NPxy0_NWxNE) <> $FF, error, "page overlap: NPxy0_NWxNE"
.assert .lobyte(NPxy0_NWxSE) <> $FF, error, "page overlap: NPxy0_NWxSE"
.assert .lobyte(NPxy0___xNE) <> $FF, error, "page overlap: NPxy0___xNE"
.assert .lobyte(NPxy0_SWx__) <> $FF, error, "page overlap: NPxy0_SWx__"
.assert .lobyte(NPxy0_SWxSE) <> $FF, error, "page overlap: NPxy0_SWxSE"
.assert .lobyte(NPxy0___xSE) <> $FF, error, "page overlap: NPxy0___xSE"
.assert .lobyte(NPxy1_NWx__) <> $FF, error, "page overlap: NPxy1_NWx__"
.assert .lobyte(NPxy1_NWxNE) <> $FF, error, "page overlap: NPxy1_NWxNE"
.assert .lobyte(NPxy1_NWxSE) <> $FF, error, "page overlap: NPxy1_NWxSE"
.assert .lobyte(NPxy1___xNE) <> $FF, error, "page overlap: NPxy1___xNE"
.assert .lobyte(NPxy1_SWx__) <> $FF, error, "page overlap: NPxy1_SWx__"
.assert .lobyte(NPxy1_SWxSE) <> $FF, error, "page overlap: NPxy1_SWxSE"
.assert .lobyte(NPxy1___xSE) <> $FF, error, "page overlap: NPxy1___xSE"
.assert .lobyte(NPxy2_NWx__) <> $FF, error, "page overlap: NPxy2_NWx__"
.assert .lobyte(NPxy2_NWxNE) <> $FF, error, "page overlap: NPxy2_NWxNE"
.assert .lobyte(NPxy2_NWxSE) <> $FF, error, "page overlap: NPxy2_NWxSE"
.assert .lobyte(NPxy2___xNE) <> $FF, error, "page overlap: NPxy2___xNE"
.assert .lobyte(NPxy2_SWx__) <> $FF, error, "page overlap: NPxy2_SWx__"
.assert .lobyte(NPxy2_SWxSE) <> $FF, error, "page overlap: NPxy2_SWxSE"
.assert .lobyte(NPxy2___xSE) <> $FF, error, "page overlap: NPxy2___xSE"
.assert .lobyte(NPxy3_NWx__) <> $FF, error, "page overlap: NPxy3_NWx__"
.assert .lobyte(NPxy3_NWxNE) <> $FF, error, "page overlap: NPxy3_NWxNE"
.assert .lobyte(NPxy3_NWxSE) <> $FF, error, "page overlap: NPxy3_NWxSE"
.assert .lobyte(NPxy3___xNE) <> $FF, error, "page overlap: NPxy3___xNE"
.assert .lobyte(NPxy3_SWx__) <> $FF, error, "page overlap: NPxy3_SWx__"
.assert .lobyte(NPxy3_SWxSE) <> $FF, error, "page overlap: NPxy3_SWxSE"
.assert .lobyte(NPxy3___xSE) <> $FF, error, "page overlap: NPxy3___xSE"
.assert .lobyte(NPxy4_NWx__) <> $FF, error, "page overlap: NPxy4_NWx__"
.assert .lobyte(NPxy4_NWxNE) <> $FF, error, "page overlap: NPxy4_NWxNE"
.assert .lobyte(NPxy4_NWxSE) <> $FF, error, "page overlap: NPxy4_NWxSE"
.assert .lobyte(NPxy4___xNE) <> $FF, error, "page overlap: NPxy4___xNE"
.assert .lobyte(NPxy4_SWx__) <> $FF, error, "page overlap: NPxy4_SWx__"
.assert .lobyte(NPxy4_SWxSE) <> $FF, error, "page overlap: NPxy4_SWxSE"
.assert .lobyte(NPxy4___xSE) <> $FF, error, "page overlap: NPxy4___xSE"
.assert .lobyte(NPxy5_NWx__) <> $FF, error, "page overlap: NPxy5_NWx__"
.assert .lobyte(NPxy5_NWxNE) <> $FF, error, "page overlap: NPxy5_NWxNE"
.assert .lobyte(NPxy5_NWxSE) <> $FF, error, "page overlap: NPxy5_NWxSE"
.assert .lobyte(NPxy5___xNE) <> $FF, error, "page overlap: NPxy5___xNE"
.assert .lobyte(NPxy5_SWx__) <> $FF, error, "page overlap: NPxy5_SWx__"
.assert .lobyte(NPxy5_SWxSE) <> $FF, error, "page overlap: NPxy5_SWxSE"
.assert .lobyte(NPxy5___xSE) <> $FF, error, "page overlap: NPxy5___xSE"
.assert .lobyte(NPxy6_NWx__) <> $FF, error, "page overlap: NPxy6_NWx__"
.assert .lobyte(NPxy6_NWxNE) <> $FF, error, "page overlap: NPxy6_NWxNE"
.assert .lobyte(NPxy6_NWxSE) <> $FF, error, "page overlap: NPxy6_NWxSE"
.assert .lobyte(NPxy6___xNE) <> $FF, error, "page overlap: NPxy6___xNE"
.assert .lobyte(NPxy6_SWx__) <> $FF, error, "page overlap: NPxy6_SWx__"
.assert .lobyte(NPxy6_SWxSE) <> $FF, error, "page overlap: NPxy6_SWxSE"
.assert .lobyte(NPxy6___xSE) <> $FF, error, "page overlap: NPxy6___xSE"
.assert .lobyte(NPxy7_NWx__) <> $FF, error, "page overlap: NPxy7_NWx__"
.assert .lobyte(NPxy7_NWxNE) <> $FF, error, "page overlap: NPxy7_NWxNE"
.assert .lobyte(NPxy7_NWxSE) <> $FF, error, "page overlap: NPxy7_NWxSE"
.assert .lobyte(NPxy7___xNE) <> $FF, error, "page overlap: NPxy7___xNE"
.assert .lobyte(NPxy7_SWx__) <> $FF, error, "page overlap: NPxy7_SWx__"
.assert .lobyte(NPxy7_SWxSE) <> $FF, error, "page overlap: NPxy7_SWxSE"
.assert .lobyte(NPxy7___xSE) <> $FF, error, "page overlap: NPxy7___xSE"
.assert .lobyte(NPxy8_NWx__) <> $FF, error, "page overlap: NPxy8_NWx__"
.assert .lobyte(NPxy8_NWxNE) <> $FF, error, "page overlap: NPxy8_NWxNE"
.assert .lobyte(NPxy8_NWxSE) <> $FF, error, "page overlap: NPxy8_NWxSE"
.assert .lobyte(NPxy8___xNE) <> $FF, error, "page overlap: NPxy8___xNE"
.assert .lobyte(NPxy8_SWx__) <> $FF, error, "page overlap: NPxy8_SWx__"
.assert .lobyte(NPxy8_SWxSE) <> $FF, error, "page overlap: NPxy8_SWxSE"
.assert .lobyte(NPxy8___xSE) <> $FF, error, "page overlap: NPxy8___xSE"
.assert .lobyte(NPxy9_NWx__) <> $FF, error, "page overlap: NPxy9_NWx__"
.assert .lobyte(NPxy9_NWxNE) <> $FF, error, "page overlap: NPxy9_NWxNE"
.assert .lobyte(NPxy9_NWxSE) <> $FF, error, "page overlap: NPxy9_NWxSE"
.assert .lobyte(NPxy9___xNE) <> $FF, error, "page overlap: NPxy9___xNE"
.assert .lobyte(NPxy9_SWx__) <> $FF, error, "page overlap: NPxy9_SWx__"
.assert .lobyte(NPxy9_SWxSE) <> $FF, error, "page overlap: NPxy9_SWxSE"
.assert .lobyte(NPxy9___xSE) <> $FF, error, "page overlap: NPxy9___xSE"
.assert .lobyte(NPxy10_NWx__) <> $FF, error, "page overlap: NPxy10_NWx__"
.assert .lobyte(NPxy10_NWxNE) <> $FF, error, "page overlap: NPxy10_NWxNE"
.assert .lobyte(NPxy10_NWxSE) <> $FF, error, "page overlap: NPxy10_NWxSE"
.assert .lobyte(NPxy10___xNE) <> $FF, error, "page overlap: NPxy10___xNE"
.assert .lobyte(NPxy10_SWx__) <> $FF, error, "page overlap: NPxy10_SWx__"
.assert .lobyte(NPxy10_SWxSE) <> $FF, error, "page overlap: NPxy10_SWxSE"
.assert .lobyte(NPxy10___xSE) <> $FF, error, "page overlap: NPxy10___xSE"
.assert .lobyte(NPxy11_NWx__) <> $FF, error, "page overlap: NPxy11_NWx__"
.assert .lobyte(NPxy11_NWxNE) <> $FF, error, "page overlap: NPxy11_NWxNE"
.assert .lobyte(NPxy11_NWxSE) <> $FF, error, "page overlap: NPxy11_NWxSE"
.assert .lobyte(NPxy11___xNE) <> $FF, error, "page overlap: NPxy11___xNE"
.assert .lobyte(NPxy11_SWx__) <> $FF, error, "page overlap: NPxy11_SWx__"
.assert .lobyte(NPxy11_SWxSE) <> $FF, error, "page overlap: NPxy11_SWxSE"
.assert .lobyte(NPxy11___xSE) <> $FF, error, "page overlap: NPxy11___xSE"
.assert .lobyte(NPxy12_NWx__) <> $FF, error, "page overlap: NPxy12_NWx__"
.assert .lobyte(NPxy12_NWxNE) <> $FF, error, "page overlap: NPxy12_NWxNE"
.assert .lobyte(NPxy12_NWxSE) <> $FF, error, "page overlap: NPxy12_NWxSE"
.assert .lobyte(NPxy12___xNE) <> $FF, error, "page overlap: NPxy12___xNE"
.assert .lobyte(NPxy12_SWx__) <> $FF, error, "page overlap: NPxy12_SWx__"
.assert .lobyte(NPxy12_SWxSE) <> $FF, error, "page overlap: NPxy12_SWxSE"
.assert .lobyte(NPxy12___xSE) <> $FF, error, "page overlap: NPxy12___xSE"
.assert .lobyte(NPxy13_NWx__) <> $FF, error, "page overlap: NPxy13_NWx__"
.assert .lobyte(NPxy13_NWxNE) <> $FF, error, "page overlap: NPxy13_NWxNE"
.assert .lobyte(NPxy13_NWxSE) <> $FF, error, "page overlap: NPxy13_NWxSE"
.assert .lobyte(NPxy13___xNE) <> $FF, error, "page overlap: NPxy13___xNE"
.assert .lobyte(NPxy13_SWx__) <> $FF, error, "page overlap: NPxy13_SWx__"
.assert .lobyte(NPxy13_SWxSE) <> $FF, error, "page overlap: NPxy13_SWxSE"
.assert .lobyte(NPxy13___xSE) <> $FF, error, "page overlap: NPxy13___xSE"
.assert .lobyte(NPxy14_NWx__) <> $FF, error, "page overlap: NPxy14_NWx__"
.assert .lobyte(NPxy14_NWxNE) <> $FF, error, "page overlap: NPxy14_NWxNE"
.assert .lobyte(NPxy14_NWxSE) <> $FF, error, "page overlap: NPxy14_NWxSE"
.assert .lobyte(NPxy14___xNE) <> $FF, error, "page overlap: NPxy14___xNE"
.assert .lobyte(NPxy14_SWx__) <> $FF, error, "page overlap: NPxy14_SWx__"
.assert .lobyte(NPxy14_SWxSE) <> $FF, error, "page overlap: NPxy14_SWxSE"
.assert .lobyte(NPxy14___xSE) <> $FF, error, "page overlap: NPxy14___xSE"
.assert .lobyte(NPxy15_NWx__) <> $FF, error, "page overlap: NPxy15_NWx__"
.assert .lobyte(NPxy15_NWxNE) <> $FF, error, "page overlap: NPxy15_NWxNE"
.assert .lobyte(NPxy15_NWxSE) <> $FF, error, "page overlap: NPxy15_NWxSE"
.assert .lobyte(NPxy15___xNE) <> $FF, error, "page overlap: NPxy15___xNE"
.assert .lobyte(NPxy15_SWx__) <> $FF, error, "page overlap: NPxy15_SWx__"
.assert .lobyte(NPxy15_SWxSE) <> $FF, error, "page overlap: NPxy15_SWxSE"
.assert .lobyte(NPxy15___xSE) <> $FF, error, "page overlap: NPxy15___xSE"
.assert .lobyte(NPxy16_NWx__) <> $FF, error, "page overlap: NPxy16_NWx__"
.assert .lobyte(NPxy16_NWxNE) <> $FF, error, "page overlap: NPxy16_NWxNE"
.assert .lobyte(NPxy16_NWxSE) <> $FF, error, "page overlap: NPxy16_NWxSE"
.assert .lobyte(NPxy16___xNE) <> $FF, error, "page overlap: NPxy16___xNE"
.assert .lobyte(NPxy16_SWx__) <> $FF, error, "page overlap: NPxy16_SWx__"
.assert .lobyte(NPxy16_SWxSE) <> $FF, error, "page overlap: NPxy16_SWxSE"
.assert .lobyte(NPxy16___xSE) <> $FF, error, "page overlap: NPxy16___xSE"
.assert .lobyte(NPxy17_NWx__) <> $FF, error, "page overlap: NPxy17_NWx__"
.assert .lobyte(NPxy17_NWxNE) <> $FF, error, "page overlap: NPxy17_NWxNE"
.assert .lobyte(NPxy17_NWxSE) <> $FF, error, "page overlap: NPxy17_NWxSE"
.assert .lobyte(NPxy17___xNE) <> $FF, error, "page overlap: NPxy17___xNE"
.assert .lobyte(NPxy17_SWx__) <> $FF, error, "page overlap: NPxy17_SWx__"
.assert .lobyte(NPxy17_SWxSE) <> $FF, error, "page overlap: NPxy17_SWxSE"
.assert .lobyte(NPxy17___xSE) <> $FF, error, "page overlap: NPxy17___xSE"
.assert .lobyte(NPxy18_NWx__) <> $FF, error, "page overlap: NPxy18_NWx__"
.assert .lobyte(NPxy18_NWxNE) <> $FF, error, "page overlap: NPxy18_NWxNE"
.assert .lobyte(NPxy18_NWxSE) <> $FF, error, "page overlap: NPxy18_NWxSE"
.assert .lobyte(NPxy18___xNE) <> $FF, error, "page overlap: NPxy18___xNE"
.assert .lobyte(NPxy18_SWx__) <> $FF, error, "page overlap: NPxy18_SWx__"
.assert .lobyte(NPxy18_SWxSE) <> $FF, error, "page overlap: NPxy18_SWxSE"
.assert .lobyte(NPxy18___xSE) <> $FF, error, "page overlap: NPxy18___xSE"
.assert .lobyte(NPxy19_NWx__) <> $FF, error, "page overlap: NPxy19_NWx__"
.assert .lobyte(NPxy19_NWxNE) <> $FF, error, "page overlap: NPxy19_NWxNE"
.assert .lobyte(NPxy19_NWxSE) <> $FF, error, "page overlap: NPxy19_NWxSE"
.assert .lobyte(NPxy19___xNE) <> $FF, error, "page overlap: NPxy19___xNE"
.assert .lobyte(NPxy19_SWx__) <> $FF, error, "page overlap: NPxy19_SWx__"
.assert .lobyte(NPxy19_SWxSE) <> $FF, error, "page overlap: NPxy19_SWxSE"
.assert .lobyte(NPxy19___xSE) <> $FF, error, "page overlap: NPxy19___xSE"
.assert .lobyte(NPxy20_NWx__) <> $FF, error, "page overlap: NPxy20_NWx__"
.assert .lobyte(NPxy20_NWxNE) <> $FF, error, "page overlap: NPxy20_NWxNE"
.assert .lobyte(NPxy20_NWxSE) <> $FF, error, "page overlap: NPxy20_NWxSE"
.assert .lobyte(NPxy20___xNE) <> $FF, error, "page overlap: NPxy20___xNE"
.assert .lobyte(NPxy20_SWx__) <> $FF, error, "page overlap: NPxy20_SWx__"
.assert .lobyte(NPxy20_SWxSE) <> $FF, error, "page overlap: NPxy20_SWxSE"
.assert .lobyte(NPxy20___xSE) <> $FF, error, "page overlap: NPxy20___xSE"
.assert .lobyte(NPxy21_NWx__) <> $FF, error, "page overlap: NPxy21_NWx__"
.assert .lobyte(NPxy21_NWxNE) <> $FF, error, "page overlap: NPxy21_NWxNE"
.assert .lobyte(NPxy21_NWxSE) <> $FF, error, "page overlap: NPxy21_NWxSE"
.assert .lobyte(NPxy21___xNE) <> $FF, error, "page overlap: NPxy21___xNE"
.assert .lobyte(NPxy21_SWx__) <> $FF, error, "page overlap: NPxy21_SWx__"
.assert .lobyte(NPxy21_SWxSE) <> $FF, error, "page overlap: NPxy21_SWxSE"
.assert .lobyte(NPxy21___xSE) <> $FF, error, "page overlap: NPxy21___xSE"
.assert .lobyte(NPyx0_NWx__) <> $FF, error, "page overlap: NPyx0_NWx__"
.assert .lobyte(NPyx0_NWxSW) <> $FF, error, "page overlap: NPyx0_NWxSW"
.assert .lobyte(NPyx0_NWxSE) <> $FF, error, "page overlap: NPyx0_NWxSE"
.assert .lobyte(NPyx0___xSE) <> $FF, error, "page overlap: NPyx0___xSE"
.assert .lobyte(NPyx0___xSW) <> $FF, error, "page overlap: NPyx0___xSW"
.assert .lobyte(NPyx0_NEx__) <> $FF, error, "page overlap: NPyx0_NEx__"
.assert .lobyte(NPyx0_NExSE) <> $FF, error, "page overlap: NPyx0_NExSE"
.assert .lobyte(NPyx1_NWx__) <> $FF, error, "page overlap: NPyx1_NWx__"
.assert .lobyte(NPyx1_NWxSW) <> $FF, error, "page overlap: NPyx1_NWxSW"
.assert .lobyte(NPyx1_NWxSE) <> $FF, error, "page overlap: NPyx1_NWxSE"
.assert .lobyte(NPyx1___xSE) <> $FF, error, "page overlap: NPyx1___xSE"
.assert .lobyte(NPyx1___xSW) <> $FF, error, "page overlap: NPyx1___xSW"
.assert .lobyte(NPyx1_NEx__) <> $FF, error, "page overlap: NPyx1_NEx__"
.assert .lobyte(NPyx1_NExSE) <> $FF, error, "page overlap: NPyx1_NExSE"
.assert .lobyte(NPyx2_NWx__) <> $FF, error, "page overlap: NPyx2_NWx__"
.assert .lobyte(NPyx2_NWxSW) <> $FF, error, "page overlap: NPyx2_NWxSW"
.assert .lobyte(NPyx2_NWxSE) <> $FF, error, "page overlap: NPyx2_NWxSE"
.assert .lobyte(NPyx2___xSE) <> $FF, error, "page overlap: NPyx2___xSE"
.assert .lobyte(NPyx2___xSW) <> $FF, error, "page overlap: NPyx2___xSW"
.assert .lobyte(NPyx2_NEx__) <> $FF, error, "page overlap: NPyx2_NEx__"
.assert .lobyte(NPyx2_NExSE) <> $FF, error, "page overlap: NPyx2_NExSE"
.assert .lobyte(NPyx3_NWx__) <> $FF, error, "page overlap: NPyx3_NWx__"
.assert .lobyte(NPyx3_NWxSW) <> $FF, error, "page overlap: NPyx3_NWxSW"
.assert .lobyte(NPyx3_NWxSE) <> $FF, error, "page overlap: NPyx3_NWxSE"
.assert .lobyte(NPyx3___xSE) <> $FF, error, "page overlap: NPyx3___xSE"
.assert .lobyte(NPyx3___xSW) <> $FF, error, "page overlap: NPyx3___xSW"
.assert .lobyte(NPyx3_NEx__) <> $FF, error, "page overlap: NPyx3_NEx__"
.assert .lobyte(NPyx3_NExSE) <> $FF, error, "page overlap: NPyx3_NExSE"
.assert .lobyte(NPyx4_NWx__) <> $FF, error, "page overlap: NPyx4_NWx__"
.assert .lobyte(NPyx4_NWxSW) <> $FF, error, "page overlap: NPyx4_NWxSW"
.assert .lobyte(NPyx4_NWxSE) <> $FF, error, "page overlap: NPyx4_NWxSE"
.assert .lobyte(NPyx4___xSE) <> $FF, error, "page overlap: NPyx4___xSE"
.assert .lobyte(NPyx4___xSW) <> $FF, error, "page overlap: NPyx4___xSW"
.assert .lobyte(NPyx4_NEx__) <> $FF, error, "page overlap: NPyx4_NEx__"
.assert .lobyte(NPyx4_NExSE) <> $FF, error, "page overlap: NPyx4_NExSE"
.assert .lobyte(NPyx5_NWx__) <> $FF, error, "page overlap: NPyx5_NWx__"
.assert .lobyte(NPyx5_NWxSW) <> $FF, error, "page overlap: NPyx5_NWxSW"
.assert .lobyte(NPyx5_NWxSE) <> $FF, error, "page overlap: NPyx5_NWxSE"
.assert .lobyte(NPyx5___xSE) <> $FF, error, "page overlap: NPyx5___xSE"
.assert .lobyte(NPyx5___xSW) <> $FF, error, "page overlap: NPyx5___xSW"
.assert .lobyte(NPyx5_NEx__) <> $FF, error, "page overlap: NPyx5_NEx__"
.assert .lobyte(NPyx5_NExSE) <> $FF, error, "page overlap: NPyx5_NExSE"
.assert .lobyte(NPyx6_NWx__) <> $FF, error, "page overlap: NPyx6_NWx__"
.assert .lobyte(NPyx6_NWxSW) <> $FF, error, "page overlap: NPyx6_NWxSW"
.assert .lobyte(NPyx6_NWxSE) <> $FF, error, "page overlap: NPyx6_NWxSE"
.assert .lobyte(NPyx6___xSE) <> $FF, error, "page overlap: NPyx6___xSE"
.assert .lobyte(NPyx6___xSW) <> $FF, error, "page overlap: NPyx6___xSW"
.assert .lobyte(NPyx6_NEx__) <> $FF, error, "page overlap: NPyx6_NEx__"
.assert .lobyte(NPyx6_NExSE) <> $FF, error, "page overlap: NPyx6_NExSE"
.assert .lobyte(NPyx7_NWx__) <> $FF, error, "page overlap: NPyx7_NWx__"
.assert .lobyte(NPyx7_NWxSW) <> $FF, error, "page overlap: NPyx7_NWxSW"
.assert .lobyte(NPyx7_NWxSE) <> $FF, error, "page overlap: NPyx7_NWxSE"
.assert .lobyte(NPyx7___xSE) <> $FF, error, "page overlap: NPyx7___xSE"
.assert .lobyte(NPyx7___xSW) <> $FF, error, "page overlap: NPyx7___xSW"
.assert .lobyte(NPyx7_NEx__) <> $FF, error, "page overlap: NPyx7_NEx__"
.assert .lobyte(NPyx7_NExSE) <> $FF, error, "page overlap: NPyx7_NExSE"
.assert .lobyte(NPyx8_NWx__) <> $FF, error, "page overlap: NPyx8_NWx__"
.assert .lobyte(NPyx8_NWxSW) <> $FF, error, "page overlap: NPyx8_NWxSW"
.assert .lobyte(NPyx8_NWxSE) <> $FF, error, "page overlap: NPyx8_NWxSE"
.assert .lobyte(NPyx8___xSE) <> $FF, error, "page overlap: NPyx8___xSE"
.assert .lobyte(NPyx8___xSW) <> $FF, error, "page overlap: NPyx8___xSW"
.assert .lobyte(NPyx8_NEx__) <> $FF, error, "page overlap: NPyx8_NEx__"
.assert .lobyte(NPyx8_NExSE) <> $FF, error, "page overlap: NPyx8_NExSE"
.assert .lobyte(NPyx9_NWx__) <> $FF, error, "page overlap: NPyx9_NWx__"
.assert .lobyte(NPyx9_NWxSW) <> $FF, error, "page overlap: NPyx9_NWxSW"
.assert .lobyte(NPyx9_NWxSE) <> $FF, error, "page overlap: NPyx9_NWxSE"
.assert .lobyte(NPyx9___xSE) <> $FF, error, "page overlap: NPyx9___xSE"
.assert .lobyte(NPyx9___xSW) <> $FF, error, "page overlap: NPyx9___xSW"
.assert .lobyte(NPyx9_NEx__) <> $FF, error, "page overlap: NPyx9_NEx__"
.assert .lobyte(NPyx9_NExSE) <> $FF, error, "page overlap: NPyx9_NExSE"
.assert .lobyte(NPyx10_NWx__) <> $FF, error, "page overlap: NPyx10_NWx__"
.assert .lobyte(NPyx10_NWxSW) <> $FF, error, "page overlap: NPyx10_NWxSW"
.assert .lobyte(NPyx10_NWxSE) <> $FF, error, "page overlap: NPyx10_NWxSE"
.assert .lobyte(NPyx10___xSE) <> $FF, error, "page overlap: NPyx10___xSE"
.assert .lobyte(NPyx10___xSW) <> $FF, error, "page overlap: NPyx10___xSW"
.assert .lobyte(NPyx10_NEx__) <> $FF, error, "page overlap: NPyx10_NEx__"
.assert .lobyte(NPyx10_NExSE) <> $FF, error, "page overlap: NPyx10_NExSE"
.assert .lobyte(NPyx11_NWx__) <> $FF, error, "page overlap: NPyx11_NWx__"
.assert .lobyte(NPyx11_NWxSW) <> $FF, error, "page overlap: NPyx11_NWxSW"
.assert .lobyte(NPyx11_NWxSE) <> $FF, error, "page overlap: NPyx11_NWxSE"
.assert .lobyte(NPyx11___xSE) <> $FF, error, "page overlap: NPyx11___xSE"
.assert .lobyte(NPyx11___xSW) <> $FF, error, "page overlap: NPyx11___xSW"
.assert .lobyte(NPyx11_NEx__) <> $FF, error, "page overlap: NPyx11_NEx__"
.assert .lobyte(NPyx11_NExSE) <> $FF, error, "page overlap: NPyx11_NExSE"
.assert .lobyte(NPyx12_NWx__) <> $FF, error, "page overlap: NPyx12_NWx__"
.assert .lobyte(NPyx12_NWxSW) <> $FF, error, "page overlap: NPyx12_NWxSW"
.assert .lobyte(NPyx12_NWxSE) <> $FF, error, "page overlap: NPyx12_NWxSE"
.assert .lobyte(NPyx12___xSE) <> $FF, error, "page overlap: NPyx12___xSE"
.assert .lobyte(NPyx12___xSW) <> $FF, error, "page overlap: NPyx12___xSW"
.assert .lobyte(NPyx12_NEx__) <> $FF, error, "page overlap: NPyx12_NEx__"
.assert .lobyte(NPyx12_NExSE) <> $FF, error, "page overlap: NPyx12_NExSE"
.assert .lobyte(NPyx13_NWx__) <> $FF, error, "page overlap: NPyx13_NWx__"
.assert .lobyte(NPyx13_NWxSW) <> $FF, error, "page overlap: NPyx13_NWxSW"
.assert .lobyte(NPyx13_NWxSE) <> $FF, error, "page overlap: NPyx13_NWxSE"
.assert .lobyte(NPyx13___xSE) <> $FF, error, "page overlap: NPyx13___xSE"
.assert .lobyte(NPyx13___xSW) <> $FF, error, "page overlap: NPyx13___xSW"
.assert .lobyte(NPyx13_NEx__) <> $FF, error, "page overlap: NPyx13_NEx__"
.assert .lobyte(NPyx13_NExSE) <> $FF, error, "page overlap: NPyx13_NExSE"
.assert .lobyte(NPyx14_NWx__) <> $FF, error, "page overlap: NPyx14_NWx__"
.assert .lobyte(NPyx14_NWxSW) <> $FF, error, "page overlap: NPyx14_NWxSW"
.assert .lobyte(NPyx14_NWxSE) <> $FF, error, "page overlap: NPyx14_NWxSE"
.assert .lobyte(NPyx14___xSE) <> $FF, error, "page overlap: NPyx14___xSE"
.assert .lobyte(NPyx14___xSW) <> $FF, error, "page overlap: NPyx14___xSW"
.assert .lobyte(NPyx14_NEx__) <> $FF, error, "page overlap: NPyx14_NEx__"
.assert .lobyte(NPyx14_NExSE) <> $FF, error, "page overlap: NPyx14_NExSE"
.assert .lobyte(NPyx15_NWx__) <> $FF, error, "page overlap: NPyx15_NWx__"
.assert .lobyte(NPyx15_NWxSW) <> $FF, error, "page overlap: NPyx15_NWxSW"
.assert .lobyte(NPyx15_NWxSE) <> $FF, error, "page overlap: NPyx15_NWxSE"
.assert .lobyte(NPyx15___xSE) <> $FF, error, "page overlap: NPyx15___xSE"
.assert .lobyte(NPyx15___xSW) <> $FF, error, "page overlap: NPyx15___xSW"
.assert .lobyte(NPyx15_NEx__) <> $FF, error, "page overlap: NPyx15_NEx__"
.assert .lobyte(NPyx15_NExSE) <> $FF, error, "page overlap: NPyx15_NExSE"
.assert .lobyte(NPyx16_NWx__) <> $FF, error, "page overlap: NPyx16_NWx__"
.assert .lobyte(NPyx16_NWxSW) <> $FF, error, "page overlap: NPyx16_NWxSW"
.assert .lobyte(NPyx16_NWxSE) <> $FF, error, "page overlap: NPyx16_NWxSE"
.assert .lobyte(NPyx16___xSE) <> $FF, error, "page overlap: NPyx16___xSE"
.assert .lobyte(NPyx16___xSW) <> $FF, error, "page overlap: NPyx16___xSW"
.assert .lobyte(NPyx16_NEx__) <> $FF, error, "page overlap: NPyx16_NEx__"
.assert .lobyte(NPyx16_NExSE) <> $FF, error, "page overlap: NPyx16_NExSE"
.assert .lobyte(NPyx17_NWx__) <> $FF, error, "page overlap: NPyx17_NWx__"
.assert .lobyte(NPyx17_NWxSW) <> $FF, error, "page overlap: NPyx17_NWxSW"
.assert .lobyte(NPyx17_NWxSE) <> $FF, error, "page overlap: NPyx17_NWxSE"
.assert .lobyte(NPyx17___xSE) <> $FF, error, "page overlap: NPyx17___xSE"
.assert .lobyte(NPyx17___xSW) <> $FF, error, "page overlap: NPyx17___xSW"
.assert .lobyte(NPyx17_NEx__) <> $FF, error, "page overlap: NPyx17_NEx__"
.assert .lobyte(NPyx17_NExSE) <> $FF, error, "page overlap: NPyx17_NExSE"
.assert .lobyte(NPyx18_NWx__) <> $FF, error, "page overlap: NPyx18_NWx__"
.assert .lobyte(NPyx18_NWxSW) <> $FF, error, "page overlap: NPyx18_NWxSW"
.assert .lobyte(NPyx18_NWxSE) <> $FF, error, "page overlap: NPyx18_NWxSE"
.assert .lobyte(NPyx18___xSE) <> $FF, error, "page overlap: NPyx18___xSE"
.assert .lobyte(NPyx18___xSW) <> $FF, error, "page overlap: NPyx18___xSW"
.assert .lobyte(NPyx18_NEx__) <> $FF, error, "page overlap: NPyx18_NEx__"
.assert .lobyte(NPyx18_NExSE) <> $FF, error, "page overlap: NPyx18_NExSE"
.assert .lobyte(NPyx19_NWx__) <> $FF, error, "page overlap: NPyx19_NWx__"
.assert .lobyte(NPyx19_NWxSW) <> $FF, error, "page overlap: NPyx19_NWxSW"
.assert .lobyte(NPyx19_NWxSE) <> $FF, error, "page overlap: NPyx19_NWxSE"
.assert .lobyte(NPyx19___xSE) <> $FF, error, "page overlap: NPyx19___xSE"
.assert .lobyte(NPyx19___xSW) <> $FF, error, "page overlap: NPyx19___xSW"
.assert .lobyte(NPyx19_NEx__) <> $FF, error, "page overlap: NPyx19_NEx__"
.assert .lobyte(NPyx19_NExSE) <> $FF, error, "page overlap: NPyx19_NExSE"
.assert .lobyte(NPyx20_NWx__) <> $FF, error, "page overlap: NPyx20_NWx__"
.assert .lobyte(NPyx20_NWxSW) <> $FF, error, "page overlap: NPyx20_NWxSW"
.assert .lobyte(NPyx20_NWxSE) <> $FF, error, "page overlap: NPyx20_NWxSE"
.assert .lobyte(NPyx20___xSE) <> $FF, error, "page overlap: NPyx20___xSE"
.assert .lobyte(NPyx20___xSW) <> $FF, error, "page overlap: NPyx20___xSW"
.assert .lobyte(NPyx20_NEx__) <> $FF, error, "page overlap: NPyx20_NEx__"
.assert .lobyte(NPyx20_NExSE) <> $FF, error, "page overlap: NPyx20_NExSE"
.assert .lobyte(NPyx21_NWx__) <> $FF, error, "page overlap: NPyx21_NWx__"
.assert .lobyte(NPyx21_NWxSW) <> $FF, error, "page overlap: NPyx21_NWxSW"
.assert .lobyte(NPyx21_NWxSE) <> $FF, error, "page overlap: NPyx21_NWxSE"
.assert .lobyte(NPyx21___xSE) <> $FF, error, "page overlap: NPyx21___xSE"
.assert .lobyte(NPyx21___xSW) <> $FF, error, "page overlap: NPyx21___xSW"
.assert .lobyte(NPyx21_NEx__) <> $FF, error, "page overlap: NPyx21_NEx__"
.assert .lobyte(NPyx21_NExSE) <> $FF, error, "page overlap: NPyx21_NExSE"
.assert NPyx0 + NPyx0_NWx__ - NPyx0 = NPyx0_NWx__, error, "ptr: NPyx0_NWx__"
.assert NPyx0 + NPyx0_NEx__ - NPyx0 = NPyx0_NEx__, error, "ptr: NPyx0_NEx__"
.assert NPyx0 + NPyx0___xSE - NPyx0 = NPyx0___xSE, error, "ptr: NPyx0___xSE"
.assert NPyx0 + NPyx0___xSW - NPyx0 = NPyx0___xSW, error, "ptr: NPyx0___xSW"
.assert NPyx1 + NPyx0_NWx__ - NPyx0 = NPyx1_NWx__, error, "ptr: NPyx1_NWx__"
.assert NPyx1 + NPyx0_NEx__ - NPyx0 = NPyx1_NEx__, error, "ptr: NPyx1_NEx__"
.assert NPyx1 + NPyx0___xSE - NPyx0 = NPyx1___xSE, error, "ptr: NPyx1___xSE"
.assert NPyx1 + NPyx0___xSW - NPyx0 = NPyx1___xSW, error, "ptr: NPyx1___xSW"
.assert NPyx2 + NPyx0_NWx__ - NPyx0 = NPyx2_NWx__, error, "ptr: NPyx2_NWx__"
.assert NPyx2 + NPyx0_NEx__ - NPyx0 = NPyx2_NEx__, error, "ptr: NPyx2_NEx__"
.assert NPyx2 + NPyx0___xSE - NPyx0 = NPyx2___xSE, error, "ptr: NPyx2___xSE"
.assert NPyx2 + NPyx0___xSW - NPyx0 = NPyx2___xSW, error, "ptr: NPyx2___xSW"
.assert NPyx3 + NPyx0_NWx__ - NPyx0 = NPyx3_NWx__, error, "ptr: NPyx3_NWx__"
.assert NPyx3 + NPyx0_NEx__ - NPyx0 = NPyx3_NEx__, error, "ptr: NPyx3_NEx__"
.assert NPyx3 + NPyx0___xSE - NPyx0 = NPyx3___xSE, error, "ptr: NPyx3___xSE"
.assert NPyx3 + NPyx0___xSW - NPyx0 = NPyx3___xSW, error, "ptr: NPyx3___xSW"
.assert NPyx4 + NPyx0_NWx__ - NPyx0 = NPyx4_NWx__, error, "ptr: NPyx4_NWx__"
.assert NPyx4 + NPyx0_NEx__ - NPyx0 = NPyx4_NEx__, error, "ptr: NPyx4_NEx__"
.assert NPyx4 + NPyx0___xSE - NPyx0 = NPyx4___xSE, error, "ptr: NPyx4___xSE"
.assert NPyx4 + NPyx0___xSW - NPyx0 = NPyx4___xSW, error, "ptr: NPyx4___xSW"
.assert NPyx5 + NPyx0_NWx__ - NPyx0 = NPyx5_NWx__, error, "ptr: NPyx5_NWx__"
.assert NPyx5 + NPyx0_NEx__ - NPyx0 = NPyx5_NEx__, error, "ptr: NPyx5_NEx__"
.assert NPyx5 + NPyx0___xSE - NPyx0 = NPyx5___xSE, error, "ptr: NPyx5___xSE"
.assert NPyx5 + NPyx0___xSW - NPyx0 = NPyx5___xSW, error, "ptr: NPyx5___xSW"
.assert NPyx6 + NPyx0_NWx__ - NPyx0 = NPyx6_NWx__, error, "ptr: NPyx6_NWx__"
.assert NPyx6 + NPyx0_NEx__ - NPyx0 = NPyx6_NEx__, error, "ptr: NPyx6_NEx__"
.assert NPyx6 + NPyx0___xSE - NPyx0 = NPyx6___xSE, error, "ptr: NPyx6___xSE"
.assert NPyx6 + NPyx0___xSW - NPyx0 = NPyx6___xSW, error, "ptr: NPyx6___xSW"
.assert NPyx7 + NPyx0_NWx__ - NPyx0 = NPyx7_NWx__, error, "ptr: NPyx7_NWx__"
.assert NPyx7 + NPyx0_NEx__ - NPyx0 = NPyx7_NEx__, error, "ptr: NPyx7_NEx__"
.assert NPyx7 + NPyx0___xSE - NPyx0 = NPyx7___xSE, error, "ptr: NPyx7___xSE"
.assert NPyx7 + NPyx0___xSW - NPyx0 = NPyx7___xSW, error, "ptr: NPyx7___xSW"
.assert NPyx8 + NPyx0_NWx__ - NPyx0 = NPyx8_NWx__, error, "ptr: NPyx8_NWx__"
.assert NPyx8 + NPyx0_NEx__ - NPyx0 = NPyx8_NEx__, error, "ptr: NPyx8_NEx__"
.assert NPyx8 + NPyx0___xSE - NPyx0 = NPyx8___xSE, error, "ptr: NPyx8___xSE"
.assert NPyx8 + NPyx0___xSW - NPyx0 = NPyx8___xSW, error, "ptr: NPyx8___xSW"
.assert NPyx9 + NPyx0_NWx__ - NPyx0 = NPyx9_NWx__, error, "ptr: NPyx9_NWx__"
.assert NPyx9 + NPyx0_NEx__ - NPyx0 = NPyx9_NEx__, error, "ptr: NPyx9_NEx__"
.assert NPyx9 + NPyx0___xSE - NPyx0 = NPyx9___xSE, error, "ptr: NPyx9___xSE"
.assert NPyx9 + NPyx0___xSW - NPyx0 = NPyx9___xSW, error, "ptr: NPyx9___xSW"
.assert NPyx10 + NPyx0_NWx__ - NPyx0 = NPyx10_NWx__, error, "ptr: NPyx10_NWx__"
.assert NPyx10 + NPyx0_NEx__ - NPyx0 = NPyx10_NEx__, error, "ptr: NPyx10_NEx__"
.assert NPyx10 + NPyx0___xSE - NPyx0 = NPyx10___xSE, error, "ptr: NPyx10___xSE"
.assert NPyx10 + NPyx0___xSW - NPyx0 = NPyx10___xSW, error, "ptr: NPyx10___xSW"
.assert NPyx11 + NPyx0_NWx__ - NPyx0 = NPyx11_NWx__, error, "ptr: NPyx11_NWx__"
.assert NPyx11 + NPyx0_NEx__ - NPyx0 = NPyx11_NEx__, error, "ptr: NPyx11_NEx__"
.assert NPyx11 + NPyx0___xSE - NPyx0 = NPyx11___xSE, error, "ptr: NPyx11___xSE"
.assert NPyx11 + NPyx0___xSW - NPyx0 = NPyx11___xSW, error, "ptr: NPyx11___xSW"
.assert NPyx12 + NPyx0_NWx__ - NPyx0 = NPyx12_NWx__, error, "ptr: NPyx12_NWx__"
.assert NPyx12 + NPyx0_NEx__ - NPyx0 = NPyx12_NEx__, error, "ptr: NPyx12_NEx__"
.assert NPyx12 + NPyx0___xSE - NPyx0 = NPyx12___xSE, error, "ptr: NPyx12___xSE"
.assert NPyx12 + NPyx0___xSW - NPyx0 = NPyx12___xSW, error, "ptr: NPyx12___xSW"
.assert NPyx13 + NPyx0_NWx__ - NPyx0 = NPyx13_NWx__, error, "ptr: NPyx13_NWx__"
.assert NPyx13 + NPyx0_NEx__ - NPyx0 = NPyx13_NEx__, error, "ptr: NPyx13_NEx__"
.assert NPyx13 + NPyx0___xSE - NPyx0 = NPyx13___xSE, error, "ptr: NPyx13___xSE"
.assert NPyx13 + NPyx0___xSW - NPyx0 = NPyx13___xSW, error, "ptr: NPyx13___xSW"
.assert NPyx14 + NPyx0_NWx__ - NPyx0 = NPyx14_NWx__, error, "ptr: NPyx14_NWx__"
.assert NPyx14 + NPyx0_NEx__ - NPyx0 = NPyx14_NEx__, error, "ptr: NPyx14_NEx__"
.assert NPyx14 + NPyx0___xSE - NPyx0 = NPyx14___xSE, error, "ptr: NPyx14___xSE"
.assert NPyx14 + NPyx0___xSW - NPyx0 = NPyx14___xSW, error, "ptr: NPyx14___xSW"
.assert NPyx15 + NPyx0_NWx__ - NPyx0 = NPyx15_NWx__, error, "ptr: NPyx15_NWx__"
.assert NPyx15 + NPyx0_NEx__ - NPyx0 = NPyx15_NEx__, error, "ptr: NPyx15_NEx__"
.assert NPyx15 + NPyx0___xSE - NPyx0 = NPyx15___xSE, error, "ptr: NPyx15___xSE"
.assert NPyx15 + NPyx0___xSW - NPyx0 = NPyx15___xSW, error, "ptr: NPyx15___xSW"
.assert NPyx16 + NPyx0_NWx__ - NPyx0 = NPyx16_NWx__, error, "ptr: NPyx16_NWx__"
.assert NPyx16 + NPyx0_NEx__ - NPyx0 = NPyx16_NEx__, error, "ptr: NPyx16_NEx__"
.assert NPyx16 + NPyx0___xSE - NPyx0 = NPyx16___xSE, error, "ptr: NPyx16___xSE"
.assert NPyx16 + NPyx0___xSW - NPyx0 = NPyx16___xSW, error, "ptr: NPyx16___xSW"
.assert NPyx17 + NPyx0_NWx__ - NPyx0 = NPyx17_NWx__, error, "ptr: NPyx17_NWx__"
.assert NPyx17 + NPyx0_NEx__ - NPyx0 = NPyx17_NEx__, error, "ptr: NPyx17_NEx__"
.assert NPyx17 + NPyx0___xSE - NPyx0 = NPyx17___xSE, error, "ptr: NPyx17___xSE"
.assert NPyx17 + NPyx0___xSW - NPyx0 = NPyx17___xSW, error, "ptr: NPyx17___xSW"
.assert NPyx18 + NPyx0_NWx__ - NPyx0 = NPyx18_NWx__, error, "ptr: NPyx18_NWx__"
.assert NPyx18 + NPyx0_NEx__ - NPyx0 = NPyx18_NEx__, error, "ptr: NPyx18_NEx__"
.assert NPyx18 + NPyx0___xSE - NPyx0 = NPyx18___xSE, error, "ptr: NPyx18___xSE"
.assert NPyx18 + NPyx0___xSW - NPyx0 = NPyx18___xSW, error, "ptr: NPyx18___xSW"
.assert NPyx19 + NPyx0_NWx__ - NPyx0 = NPyx19_NWx__, error, "ptr: NPyx19_NWx__"
.assert NPyx19 + NPyx0_NEx__ - NPyx0 = NPyx19_NEx__, error, "ptr: NPyx19_NEx__"
.assert NPyx19 + NPyx0___xSE - NPyx0 = NPyx19___xSE, error, "ptr: NPyx19___xSE"
.assert NPyx19 + NPyx0___xSW - NPyx0 = NPyx19___xSW, error, "ptr: NPyx19___xSW"
.assert NPyx20 + NPyx0_NWx__ - NPyx0 = NPyx20_NWx__, error, "ptr: NPyx20_NWx__"
.assert NPyx20 + NPyx0_NEx__ - NPyx0 = NPyx20_NEx__, error, "ptr: NPyx20_NEx__"
.assert NPyx20 + NPyx0___xSE - NPyx0 = NPyx20___xSE, error, "ptr: NPyx20___xSE"
.assert NPyx20 + NPyx0___xSW - NPyx0 = NPyx20___xSW, error, "ptr: NPyx20___xSW"
.assert NPyx21 + NPyx0_NWx__ - NPyx0 = NPyx21_NWx__, error, "ptr: NPyx21_NWx__"
.assert NPyx21 + NPyx0_NEx__ - NPyx0 = NPyx21_NEx__, error, "ptr: NPyx21_NEx__"
.assert NPyx21 + NPyx0___xSE - NPyx0 = NPyx21___xSE, error, "ptr: NPyx21___xSE"
.assert NPyx21 + NPyx0___xSW - NPyx0 = NPyx21___xSW, error, "ptr: NPyx21___xSW"
.assert NPxy0 + NPxy0_NWx__ - NPxy0 = NPxy0_NWx__, error, "ptr: NPxy0_NWx__"
.assert NPxy0 + NPxy0_SWx__ - NPxy0 = NPxy0_SWx__, error, "ptr: NPxy0_SWx__"
.assert NPxy0 + NPxy0___xNE - NPxy0 = NPxy0___xNE, error, "ptr: NPxy0___xNE"
.assert NPxy0 + NPxy0___xSE - NPxy0 = NPxy0___xSE, error, "ptr: NPxy0___xSE"
.assert NPxy1 + NPxy0_NWx__ - NPxy0 = NPxy1_NWx__, error, "ptr: NPxy1_NWx__"
.assert NPxy1 + NPxy0_SWx__ - NPxy0 = NPxy1_SWx__, error, "ptr: NPxy1_SWx__"
.assert NPxy1 + NPxy0___xNE - NPxy0 = NPxy1___xNE, error, "ptr: NPxy1___xNE"
.assert NPxy1 + NPxy0___xSE - NPxy0 = NPxy1___xSE, error, "ptr: NPxy1___xSE"
.assert NPxy2 + NPxy0_NWx__ - NPxy0 = NPxy2_NWx__, error, "ptr: NPxy2_NWx__"
.assert NPxy2 + NPxy0_SWx__ - NPxy0 = NPxy2_SWx__, error, "ptr: NPxy2_SWx__"
.assert NPxy2 + NPxy0___xNE - NPxy0 = NPxy2___xNE, error, "ptr: NPxy2___xNE"
.assert NPxy2 + NPxy0___xSE - NPxy0 = NPxy2___xSE, error, "ptr: NPxy2___xSE"
.assert NPxy3 + NPxy0_NWx__ - NPxy0 = NPxy3_NWx__, error, "ptr: NPxy3_NWx__"
.assert NPxy3 + NPxy0_SWx__ - NPxy0 = NPxy3_SWx__, error, "ptr: NPxy3_SWx__"
.assert NPxy3 + NPxy0___xNE - NPxy0 = NPxy3___xNE, error, "ptr: NPxy3___xNE"
.assert NPxy3 + NPxy0___xSE - NPxy0 = NPxy3___xSE, error, "ptr: NPxy3___xSE"
.assert NPxy4 + NPxy0_NWx__ - NPxy0 = NPxy4_NWx__, error, "ptr: NPxy4_NWx__"
.assert NPxy4 + NPxy0_SWx__ - NPxy0 = NPxy4_SWx__, error, "ptr: NPxy4_SWx__"
.assert NPxy4 + NPxy0___xNE - NPxy0 = NPxy4___xNE, error, "ptr: NPxy4___xNE"
.assert NPxy4 + NPxy0___xSE - NPxy0 = NPxy4___xSE, error, "ptr: NPxy4___xSE"
.assert NPxy5 + NPxy0_NWx__ - NPxy0 = NPxy5_NWx__, error, "ptr: NPxy5_NWx__"
.assert NPxy5 + NPxy0_SWx__ - NPxy0 = NPxy5_SWx__, error, "ptr: NPxy5_SWx__"
.assert NPxy5 + NPxy0___xNE - NPxy0 = NPxy5___xNE, error, "ptr: NPxy5___xNE"
.assert NPxy5 + NPxy0___xSE - NPxy0 = NPxy5___xSE, error, "ptr: NPxy5___xSE"
.assert NPxy6 + NPxy0_NWx__ - NPxy0 = NPxy6_NWx__, error, "ptr: NPxy6_NWx__"
.assert NPxy6 + NPxy0_SWx__ - NPxy0 = NPxy6_SWx__, error, "ptr: NPxy6_SWx__"
.assert NPxy6 + NPxy0___xNE - NPxy0 = NPxy6___xNE, error, "ptr: NPxy6___xNE"
.assert NPxy6 + NPxy0___xSE - NPxy0 = NPxy6___xSE, error, "ptr: NPxy6___xSE"
.assert NPxy7 + NPxy0_NWx__ - NPxy0 = NPxy7_NWx__, error, "ptr: NPxy7_NWx__"
.assert NPxy7 + NPxy0_SWx__ - NPxy0 = NPxy7_SWx__, error, "ptr: NPxy7_SWx__"
.assert NPxy7 + NPxy0___xNE - NPxy0 = NPxy7___xNE, error, "ptr: NPxy7___xNE"
.assert NPxy7 + NPxy0___xSE - NPxy0 = NPxy7___xSE, error, "ptr: NPxy7___xSE"
.assert NPxy8 + NPxy0_NWx__ - NPxy0 = NPxy8_NWx__, error, "ptr: NPxy8_NWx__"
.assert NPxy8 + NPxy0_SWx__ - NPxy0 = NPxy8_SWx__, error, "ptr: NPxy8_SWx__"
.assert NPxy8 + NPxy0___xNE - NPxy0 = NPxy8___xNE, error, "ptr: NPxy8___xNE"
.assert NPxy8 + NPxy0___xSE - NPxy0 = NPxy8___xSE, error, "ptr: NPxy8___xSE"
.assert NPxy9 + NPxy0_NWx__ - NPxy0 = NPxy9_NWx__, error, "ptr: NPxy9_NWx__"
.assert NPxy9 + NPxy0_SWx__ - NPxy0 = NPxy9_SWx__, error, "ptr: NPxy9_SWx__"
.assert NPxy9 + NPxy0___xNE - NPxy0 = NPxy9___xNE, error, "ptr: NPxy9___xNE"
.assert NPxy9 + NPxy0___xSE - NPxy0 = NPxy9___xSE, error, "ptr: NPxy9___xSE"
.assert NPxy10 + NPxy0_NWx__ - NPxy0 = NPxy10_NWx__, error, "ptr: NPxy10_NWx__"
.assert NPxy10 + NPxy0_SWx__ - NPxy0 = NPxy10_SWx__, error, "ptr: NPxy10_SWx__"
.assert NPxy10 + NPxy0___xNE - NPxy0 = NPxy10___xNE, error, "ptr: NPxy10___xNE"
.assert NPxy10 + NPxy0___xSE - NPxy0 = NPxy10___xSE, error, "ptr: NPxy10___xSE"
.assert NPxy11 + NPxy0_NWx__ - NPxy0 = NPxy11_NWx__, error, "ptr: NPxy11_NWx__"
.assert NPxy11 + NPxy0_SWx__ - NPxy0 = NPxy11_SWx__, error, "ptr: NPxy11_SWx__"
.assert NPxy11 + NPxy0___xNE - NPxy0 = NPxy11___xNE, error, "ptr: NPxy11___xNE"
.assert NPxy11 + NPxy0___xSE - NPxy0 = NPxy11___xSE, error, "ptr: NPxy11___xSE"
.assert NPxy12 + NPxy0_NWx__ - NPxy0 = NPxy12_NWx__, error, "ptr: NPxy12_NWx__"
.assert NPxy12 + NPxy0_SWx__ - NPxy0 = NPxy12_SWx__, error, "ptr: NPxy12_SWx__"
.assert NPxy12 + NPxy0___xNE - NPxy0 = NPxy12___xNE, error, "ptr: NPxy12___xNE"
.assert NPxy12 + NPxy0___xSE - NPxy0 = NPxy12___xSE, error, "ptr: NPxy12___xSE"
.assert NPxy13 + NPxy0_NWx__ - NPxy0 = NPxy13_NWx__, error, "ptr: NPxy13_NWx__"
.assert NPxy13 + NPxy0_SWx__ - NPxy0 = NPxy13_SWx__, error, "ptr: NPxy13_SWx__"
.assert NPxy13 + NPxy0___xNE - NPxy0 = NPxy13___xNE, error, "ptr: NPxy13___xNE"
.assert NPxy13 + NPxy0___xSE - NPxy0 = NPxy13___xSE, error, "ptr: NPxy13___xSE"
.assert NPxy14 + NPxy0_NWx__ - NPxy0 = NPxy14_NWx__, error, "ptr: NPxy14_NWx__"
.assert NPxy14 + NPxy0_SWx__ - NPxy0 = NPxy14_SWx__, error, "ptr: NPxy14_SWx__"
.assert NPxy14 + NPxy0___xNE - NPxy0 = NPxy14___xNE, error, "ptr: NPxy14___xNE"
.assert NPxy14 + NPxy0___xSE - NPxy0 = NPxy14___xSE, error, "ptr: NPxy14___xSE"
.assert NPxy15 + NPxy0_NWx__ - NPxy0 = NPxy15_NWx__, error, "ptr: NPxy15_NWx__"
.assert NPxy15 + NPxy0_SWx__ - NPxy0 = NPxy15_SWx__, error, "ptr: NPxy15_SWx__"
.assert NPxy15 + NPxy0___xNE - NPxy0 = NPxy15___xNE, error, "ptr: NPxy15___xNE"
.assert NPxy15 + NPxy0___xSE - NPxy0 = NPxy15___xSE, error, "ptr: NPxy15___xSE"
.assert NPxy16 + NPxy0_NWx__ - NPxy0 = NPxy16_NWx__, error, "ptr: NPxy16_NWx__"
.assert NPxy16 + NPxy0_SWx__ - NPxy0 = NPxy16_SWx__, error, "ptr: NPxy16_SWx__"
.assert NPxy16 + NPxy0___xNE - NPxy0 = NPxy16___xNE, error, "ptr: NPxy16___xNE"
.assert NPxy16 + NPxy0___xSE - NPxy0 = NPxy16___xSE, error, "ptr: NPxy16___xSE"
.assert NPxy17 + NPxy0_NWx__ - NPxy0 = NPxy17_NWx__, error, "ptr: NPxy17_NWx__"
.assert NPxy17 + NPxy0_SWx__ - NPxy0 = NPxy17_SWx__, error, "ptr: NPxy17_SWx__"
.assert NPxy17 + NPxy0___xNE - NPxy0 = NPxy17___xNE, error, "ptr: NPxy17___xNE"
.assert NPxy17 + NPxy0___xSE - NPxy0 = NPxy17___xSE, error, "ptr: NPxy17___xSE"
.assert NPxy18 + NPxy0_NWx__ - NPxy0 = NPxy18_NWx__, error, "ptr: NPxy18_NWx__"
.assert NPxy18 + NPxy0_SWx__ - NPxy0 = NPxy18_SWx__, error, "ptr: NPxy18_SWx__"
.assert NPxy18 + NPxy0___xNE - NPxy0 = NPxy18___xNE, error, "ptr: NPxy18___xNE"
.assert NPxy18 + NPxy0___xSE - NPxy0 = NPxy18___xSE, error, "ptr: NPxy18___xSE"
.assert NPxy19 + NPxy0_NWx__ - NPxy0 = NPxy19_NWx__, error, "ptr: NPxy19_NWx__"
.assert NPxy19 + NPxy0_SWx__ - NPxy0 = NPxy19_SWx__, error, "ptr: NPxy19_SWx__"
.assert NPxy19 + NPxy0___xNE - NPxy0 = NPxy19___xNE, error, "ptr: NPxy19___xNE"
.assert NPxy19 + NPxy0___xSE - NPxy0 = NPxy19___xSE, error, "ptr: NPxy19___xSE"
.assert NPxy20 + NPxy0_NWx__ - NPxy0 = NPxy20_NWx__, error, "ptr: NPxy20_NWx__"
.assert NPxy20 + NPxy0_SWx__ - NPxy0 = NPxy20_SWx__, error, "ptr: NPxy20_SWx__"
.assert NPxy20 + NPxy0___xNE - NPxy0 = NPxy20___xNE, error, "ptr: NPxy20___xNE"
.assert NPxy20 + NPxy0___xSE - NPxy0 = NPxy20___xSE, error, "ptr: NPxy20___xSE"
.assert NPxy21 + NPxy0_NWx__ - NPxy0 = NPxy21_NWx__, error, "ptr: NPxy21_NWx__"
.assert NPxy21 + NPxy0_SWx__ - NPxy0 = NPxy21_SWx__, error, "ptr: NPxy21_SWx__"
.assert NPxy21 + NPxy0___xNE - NPxy0 = NPxy21___xNE, error, "ptr: NPxy21___xNE"
.assert NPxy21 + NPxy0___xSE - NPxy0 = NPxy21___xSE, error, "ptr: NPxy21___xSE"

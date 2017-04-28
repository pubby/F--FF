.include "globals.inc"
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
.segment "CODE"
:
    rts
    nop
PPxy0:
    dec nt_buffer+0*32, x
    cpx to_x
    bcs :-
    inx
    adc Dy
    bmi PPxy0
    sbc Dx
PPxy1:
    dec nt_buffer+1*32, x
    cpx to_x
    bcs :-
    inx
    adc Dy
    bmi PPxy1
    sbc Dx
PPxy2:
    dec nt_buffer+2*32, x
    cpx to_x
    bcs :-
    inx
    adc Dy
    bmi PPxy2
    sbc Dx
PPxy3:
    dec nt_buffer+3*32, x
    cpx to_x
    bcs :-
    inx
    adc Dy
    bmi PPxy3
    sbc Dx
PPxy4:
    dec nt_buffer+4*32, x
    cpx to_x
    bcs :-
    inx
    adc Dy
    bmi PPxy4
    sbc Dx
PPxy5:
    dec nt_buffer+5*32, x
    cpx to_x
    bcs :-
    inx
    adc Dy
    bmi PPxy5
    sbc Dx
PPxy6:
    dec nt_buffer+6*32, x
    cpx to_x
    bcs :-
    inx
    adc Dy
    bmi PPxy6
    sbc Dx
PPxy7:
    dec nt_buffer+7*32, x
    cpx to_x
midReturn1:
    bcs :-
    inx
    adc Dy
    bmi PPxy7
    sbc Dx
PPxy8:
    dec nt_buffer+8*32, x
    cpx to_x
    bcs midReturn1
    inx
    adc Dy
    bmi PPxy8
    sbc Dx
PPxy9:
    dec nt_buffer+9*32, x
    cpx to_x
    bcs midReturn1
    inx
    adc Dy
    bmi PPxy9
    sbc Dx
PPxy10:
    dec nt_buffer+10*32, x
    cpx to_x
    bcs midReturn1
    inx
    adc Dy
    bmi PPxy10
    sbc Dx
PPxy11:
    dec nt_buffer+11*32, x
    cpx to_x
    bcs midReturn1
    inx
    adc Dy
    bmi PPxy11
    sbc Dx
PPxy12:
    dec nt_buffer+12*32, x
    cpx to_x
    bcs midReturn1
    inx
    adc Dy
    bmi PPxy12
    sbc Dx
PPxy13:
    dec nt_buffer+13*32, x
    cpx to_x
    bcs midReturn1
    inx
    adc Dy
    bmi PPxy13
    sbc Dx
PPxy14:
    dec nt_buffer+14*32, x
    cpx to_x
    bcs :+
    inx
    adc Dy
    bmi PPxy14
    sbc Dx
PPxy15:
    dec nt_buffer+15*32, x
    cpx to_x
    bcs :+
    inx
    adc Dy
    bmi PPxy15
    sbc Dx
PPxy16:
    dec nt_buffer+16*32, x
    cpx to_x
    bcs :+
    inx
    adc Dy
    bmi PPxy16
    sbc Dx
PPxy17:
    dec nt_buffer+17*32, x
    cpx to_x
    bcs :+
    inx
    adc Dy
    bmi PPxy17
    sbc Dx
PPxy18:
    dec nt_buffer+18*32, x
    cpx to_x
    bcs :+
    inx
    adc Dy
    bmi PPxy18
    sbc Dx
PPxy19:
    dec nt_buffer+19*32, x
    cpx to_x
    bcs :+
    inx
    adc Dy
    bmi PPxy19
    sbc Dx
PPxy20:
    dec nt_buffer+20*32, x
    cpx to_x
    bcs :+
    inx
    adc Dy
    bmi PPxy20
    sbc Dx
PPxy21:
    dec nt_buffer+21*32, x
    cpx to_x
    bcs :+
    inx
    adc Dy
    bmi PPxy21
    sbc Dx
:
    rts
    nop
PPyx0:
    dec nt_buffer+0*32, x
    dey
    beq :-
    adc Dx
    bmi PPyx1
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx1:
    dec nt_buffer+1*32, x
    dey
    beq :-
    adc Dx
    bmi PPyx2
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx2:
    dec nt_buffer+2*32, x
    dey
    beq :-
    adc Dx
    bmi PPyx3
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx3:
    dec nt_buffer+3*32, x
    dey
    beq :-
    adc Dx
    bmi PPyx4
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx4:
    dec nt_buffer+4*32, x
    dey
    beq :-
    adc Dx
    bmi PPyx5
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx5:
    dec nt_buffer+5*32, x
    dey
    beq :-
    adc Dx
    bmi PPyx6
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx6:
    dec nt_buffer+6*32, x
    dey
    beq :-
    adc Dx
    bmi PPyx7
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx7:
    dec nt_buffer+7*32, x
    dey
midReturn2:
    beq :-
    adc Dx
    bmi PPyx8
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx8:
    dec nt_buffer+8*32, x
    dey
    beq midReturn2
    adc Dx
    bmi PPyx9
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx9:
    dec nt_buffer+9*32, x
    dey
    beq midReturn2
    adc Dx
    bmi PPyx10
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx10:
    dec nt_buffer+10*32, x
    dey
    beq midReturn2
    adc Dx
    bmi PPyx11
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx11:
    dec nt_buffer+11*32, x
    dey
    beq midReturn2
    adc Dx
    bmi PPyx12
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx12:
    dec nt_buffer+12*32, x
    dey
    beq midReturn2
    adc Dx
    bmi PPyx13
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx13:
    dec nt_buffer+13*32, x
    dey
    beq midReturn2
    adc Dx
    bmi PPyx14
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx14:
    dec nt_buffer+14*32, x
    dey
    beq :+
    adc Dx
    bmi PPyx15
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx15:
    dec nt_buffer+15*32, x
    dey
    beq :+
    adc Dx
    bmi PPyx16
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx16:
    dec nt_buffer+16*32, x
    dey
    beq :+
    adc Dx
    bmi PPyx17
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx17:
    dec nt_buffer+17*32, x
    dey
    beq :+
    adc Dx
    bmi PPyx18
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx18:
    dec nt_buffer+18*32, x
    dey
    beq :+
    adc Dx
    bmi PPyx19
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx19:
    dec nt_buffer+19*32, x
    dey
    beq :+
    adc Dx
    bmi PPyx20
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx20:
    dec nt_buffer+20*32, x
    dey
    beq :+
    adc Dx
    bmi PPyx21
    .byt $ED ; sbc absolute
    .word Dy
    inx
PPyx21:
    dec nt_buffer+21*32, x
:
    rts

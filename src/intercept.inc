.macro calc_intercept_low op, intercept, intercept_scale, numer, denom
:
    lsr intercept_scale+2
    beq :+
    ror intercept_scale+1
    ror intercept_scale+0
    lsr denom+2
    ror denom+1
    lda numer+0
    rra denom+0
    tax
    lda numer+1
    adc denom+1
    tay
    lda numer+2
    adc denom+2
    bcs :- ; if denom >= numer
    sta numer+2
    sty numer+1
    stx numer+0
.if .xmatch(op,add)
    .repeat 3, i
        lda intercept+i
        adc intercept_scale+i
        sta intercept+i
    .endrepeat
.else
    sec
    .repeat 3, i
        lda intercept+i
        sbc intercept_scale+i
        sta intercept+i
    .endrepeat
.endif
    jmp :-
:
    ror intercept_scale+1
    .byt $0C ; IGN to skip next LSR
:
    lsr intercept_scale+1
    beq :+
    ror intercept_scale+0
    lsr denom+2
    ror denom+1
    lda numer+0
    rra denom+0
    tax
    lda numer+1
    adc denom+1
    tay
    lda numer+2
    adc denom+2
    bcs :- ; if denom >= numer
    sta numer+2
    sty numer+1
    stx numer+0
.if .xmatch(op, add)
    .repeat 2, i
        lda intercept+i
        adc intercept_scale+i
        sta intercept+i
    .endrepeat
    bcc :-
    inc intercept+2
.else
    sec
    .repeat 2, i
        lda intercept+i
        sbc intercept_scale+i
        sta intercept+i
    .endrepeat
    bcs :-
    dec intercept+2
.endif
    jmp :-
:
.endmacro

.macro calc_intercept_high op, intercept, intercept_scale, numer, denom
:
    lsr intercept_scale+2
    beq :+
    ror intercept_scale+1
    ror intercept_scale+0
    lsr denom+2
    ror denom+1
    ror denom+0
    sec
    lda numer+0
    sbc denom+0
    tax
    lda numer+1
    sbc denom+1
    tay
    lda numer+2
    sbc denom+2
    bcc :- ; if denom >= numer
    sta numer+2
    sty numer+1
    stx numer+0
.if .xmatch(op,add)
    clc
    .repeat 3, i
        lda intercept+i
        adc intercept_scale+i
        sta intercept+i
    .endrepeat
.else
    .repeat 3, i
        lda intercept+i
        sbc intercept_scale+i
        sta intercept+i
    .endrepeat
.endif
    jmp :-
:
    ror intercept_scale+1
    .byt $0C ; IGN to skip next LSR
:
    lsr intercept_scale+1
    beq :+
    ror intercept_scale+0
    lsr denom+2
    ror denom+1
    ror denom+0
    sec
    lda numer+0
    sbc denom+0
    tax
    lda numer+1
    sbc denom+1
    tay
    lda numer+2
    sbc denom+2
    bcc :- ; if denom >= numer
    sta numer+2
    sty numer+1
    stx numer+0
.if .xmatch(op,add)
    clc
    .repeat 2, i
        lda intercept+i
        adc intercept_scale+i
        sta intercept+i
    .endrepeat
    bcc :-
    inc intercept+2
    bcs :-
.else
    .repeat 2, i
        lda intercept+i
        sbc intercept_scale+i
        sta intercept+i
    .endrepeat
    bcs :-
    dec intercept+2
    bcc :-
.endif
:
.endmacro

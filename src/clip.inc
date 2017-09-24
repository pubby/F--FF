.macro scale_by_ratio intercept, intercept_scale, numer, denom
; i=2 d=2
loop_2_2:
    lsr intercept_scale+2
    beq zeroInterceptScale_2_2
    ror intercept_scale+1
    ror intercept_scale+0
    lsr denom+2
    beq zeroDenom_2_2
denomEntrance_2_2:
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
    bcc loop_2_2
    stx numer+0
    sty numer+1
    sta numer+2
    lda intercept+0
    sbc intercept_scale+0
    sta intercept+0
    lda intercept+1
    sbc intercept_scale+1
    sta intercept+1
    lda intercept+2
    sbc intercept_scale+2
    sta intercept+2
    jmp loop_2_2
zeroDenom_2_2:
    ror denom+1
    jmp denomEntrance_2_1
zeroInterceptScale_2_2:
    ror intercept_scale+1
    .byt $0C ; IGN to skip next LSR
; i=1 d=2
loop_1_2:
    lsr intercept_scale+1
    beq zeroInterceptScale_1_2
    ror intercept_scale+0
    lsr denom+2
    beq zeroDenom_1_2
denomEntrance_1_2:
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
    bcc loop_1_2
    stx numer+0
    sty numer+1
    sta numer+2
    lda intercept+0
    sbc intercept_scale+0
    sta intercept+0
    lda intercept+1
    sbc intercept_scale+1
    sta intercept+1
    bcs loop_1_2
    dec intercept+2
    jmp loop_1_2
zeroDenom_1_2:
    ror denom+1
    jmp denomEntrance_1_1
zeroInterceptScale_1_2:
    lda #0
    sta numer+0
    sta numer+1
    rts
; i=2 d=1
loop_2_1:
    lsr intercept_scale+2
    beq zeroInterceptScale_2_1
    ror intercept_scale+1
    ror intercept_scale+0
    lsr denom+1
    beq zeroDenom_2_1
denomEntrance_2_1:
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
    bcc loop_2_1
    stx numer+0
    sty numer+1
    sta numer+2
    lda intercept+0
    sbc intercept_scale+0
    sta intercept+0
    lda intercept+1
    sbc intercept_scale+1
    sta intercept+1
    lda intercept+2
    sbc intercept_scale+2
    sta intercept+2
    jmp loop_2_1
zeroDenom_2_1:
    ror denom+0
    jmp denomEntrance_2_0
zeroInterceptScale_2_1:
    ror intercept_scale+1
    .byt $0C ; IGN to skip next LSR
; i=1 d=1
loop_1_1:
    lsr intercept_scale+1
    beq zeroInterceptScale_1_1
    ror intercept_scale+0
    lsr denom+1
    beq zeroDenom_1_1
denomEntrance_1_1:
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
    bcc loop_1_1
    stx numer+0
    sty numer+1
    sta numer+2
    lda intercept+0
    sbc intercept_scale+0
    sta intercept+0
    lda intercept+1
    sbc intercept_scale+1
    sta intercept+1
    bcs loop_1_1
    dec intercept+2
    jmp loop_1_1
zeroDenom_1_1:
    ror denom+0
    jmp denomEntrance_1_0
zeroInterceptScale_1_1:
    lda #0
    sta numer+0
    sta numer+1
    rts
; i=2 d=0
loop_2_0:
    lsr intercept_scale+2
    beq zeroInterceptScale_2_0
    ror intercept_scale+1
    ror intercept_scale+0
    lsr denom+0
denomEntrance_2_0:
    sec
    lda numer+0
    sbc denom+0
    tax
    lda numer+1
    sbc denom+1
    tay
    lda numer+2
    sbc denom+2
    bcc loop_2_0
    stx numer+0
    sty numer+1
    sta numer+2
    lda intercept+0
    sbc intercept_scale+0
    sta intercept+0
    lda intercept+1
    sbc intercept_scale+1
    sta intercept+1
    lda intercept+2
    sbc intercept_scale+2
    sta intercept+2
    jmp loop_2_0
zeroInterceptScale_2_0:
    ror intercept_scale+1
    .byt $0C ; IGN to skip next LSR
; i=1 d=0
loop_1_0:
    lsr intercept_scale+1
    beq zeroInterceptScale_1_0
    ror intercept_scale+0
    lsr denom+0
denomEntrance_1_0:
    sec
    lda numer+0
    sbc denom+0
    tax
    lda numer+1
    sbc denom+1
    tay
    lda numer+2
    sbc denom+2
    bcc loop_1_0
    stx numer+0
    sty numer+1
    sta numer+2
    lda intercept+0
    sbc intercept_scale+0
    sta intercept+0
    lda intercept+1
    sbc intercept_scale+1
    sta intercept+1
    bcs loop_1_0
    dec intercept+2
    jmp loop_1_0
zeroInterceptScale_1_0:
    lda #0
    sta numer+0
    sta numer+1
    rts
.endmacro

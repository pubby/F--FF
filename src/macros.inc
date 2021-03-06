.ifndef MACROS_INC
.define MACROS_INC

; into = a + b + carry bit
; Sets A to new value of address+1.
; Sets carry bit on overflow.
; Both values should be 16-bit. Address should be little-endian.
.macro add16into value1, value2, into
    .if (.match (.mid (0, 1, {value2}), #))
        ; += immediate
        lda value1+0
        adc #.lobyte(.right (.tcount ({value2})-1, {value2}))
        sta into+0
        lda value1+1
        adc #.hibyte(.right (.tcount ({value2})-1, {value2}))
        sta into+1
    .else
        ; += absolute or zeropage
        lda value1+0
        adc value2+0
        sta into+0
        lda value1+1
        adc value2+1
        sta into+1
    .endif
.endmacro

; a += (b + carry_bit)
.macro add16 value1, value2
    add16into value1, value2, value1
.endmacro

.macro sub16into value1, value2, into
    .if (.match (.mid (0, 1, {value2}), #))
        ; -= immediate
        lda value1+0
        sbc #.lobyte(.right (.tcount ({value2})-1, {value2}))
        sta into+0
        lda value1+1
        sbc #.hibyte(.right (.tcount ({value2})-1, {value2}))
        sta into+1
    .else
        ; -= absolute or zeropage
        lda value1+0
        sbc value2+0
        sta into+0
        lda value1+1
        sbc value2+1
        sta into+1
    .endif
.endmacro

.macro sub16 value1, value2
    sub16into value1, value2, value1
.endmacro

.macro store16into value, into
    .if (.match (.mid (0, 1, {value}), #))
        ; -= immediate
        lda #.lobyte(.right (.tcount ({value})-1, {value}))
        sta into+0
        lda #.hibyte(.right (.tcount ({value})-1, {value}))
        sta into+1
    .else
        ; -= absolute or zeropage
        lda value+0
        sta into+0
        lda value+1
        sta into+1
    .endif
.endmacro

.macro store8into value, into
    .if (.match (.mid (0, 1, {value}), #))
        ; -= immediate
       lda #.right (.tcount ({value})-1, {value})
        sta into
    .else
        ; -= absolute or zeropage
        lda #value
        sta into
    .endif
.endmacro

.macro storePPUADDR value
    .if (.match (.mid (0, 1, {value}), #))
        ; -= immediate
        lda #.hibyte(.right (.tcount ({value})-1, {value}))
        sta PPUADDR
        lda #.lobyte(.right (.tcount ({value})-1, {value}))
        sta PPUADDR
    .else
        ; -= absolute or zeropage
        lda value+1
        sta PPUADDR
        lda value+0
        sta PPUADDR
    .endif
.endmacro

;.define XYADDR(nt, xpos, ypos) ((nt) + (ypos)*$20 + (xpos))
.define XYADDR(nt, xpos, ypos) (nt + (xpos) + ((ypos)*$20))

.define P(i, str) .ident(.sprintf("p%i%s", (i)+1, .string(str)))
;.define P(i, str) .ident(.string(str))

.define LAPTIME(i) .ident(.sprintf("lap_time_%i", (i)))

.macro beq_aligned label
    beq label
    .assert .hibyte(*) = .hibyte(label), error, "beq misaligned"
.endmacro

.macro bne_aligned label
    bne label
    .assert .hibyte(*) = .hibyte(label), error, "bne misaligned"
.endmacro

.macro bcs_aligned label
    bcs label
    .assert .hibyte(*) = .hibyte(label), error, "bcs misaligned"
.endmacro

.macro bcc_aligned label
    bcc label
    .assert .hibyte(*) = .hibyte(label), error, "bcc misaligned"
.endmacro

.macro bvs_aligned label
    bvs label
    .assert .hibyte(*) = .hibyte(label), error, "bvs misaligned"
.endmacro

.macro bvc_aligned label
    bvc label
    .assert .hibyte(*) = .hibyte(label), error, "bvc misaligned"
.endmacro

.macro bpl_aligned label
    bpl label
    .assert .hibyte(*) = .hibyte(label), error, "bpl misaligned"
.endmacro

.macro bmi_aligned label
    bmi label
    .assert .hibyte(*) = .hibyte(label), error, "bmi misaligned"
.endmacro


.endif

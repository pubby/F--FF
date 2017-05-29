.include "globals.inc"
.include "intercept.inc"

.export draw_line

.segment "LINE_TABLES"
subpixel_table:
.repeat 256, i
    .byt (((i & %11111100) * (3 - (i & %11))) + 0) / 4
.endrepeat

.segment "LINE"
; NOTE: This returns in A, but it won't set the zero flag correctly.
; Use TAX or something to set the zero flag.
.macro compute_out_code xvar, yvar
    lda #0
    ldx yvar+1
    beq :++
    bpl :+
    ora #%1010
:
    eor #%1000
:
    ldx xvar+1
    beq :++
    bpl :+
    ora #%0101
:
    eor #%0100
:
.endmacro

.macro clip xop
    compute_out_code to_x, to_y
    sta to_out_code
    compute_out_code from_x, from_y
    tax                 ; Store from_out_code in X temporarily.
    bne :+              ; Flag set by TAX.
    jmp clipTo
:
    and to_out_code
    beq :+
    jmp trivialReject
:
clipFromLoop:
    ; A = 0
    sta from_x_sub
    sta from_y_sub
    sta Dx_sub
    sta Dy_sub
    sec
    .if .xmatch(xop,add)
        sub16into to_x, from_x, Dx
    .else
        sub16into from_x, to_x, Dx
    .endif
    sec
    sub16into to_y, from_y, Dy

    txa                 ; load from_out_code
    lsr
    bcc @notXLeft
        calc_intercept_low add, from_y_sub, Dy_sub, from_x_sub, Dx_sub
        lda #0
        sta from_x+0
        sta from_x+1
        jmp doneClipFrom
@notXLeft:
    lsr
    bcc @notYTop
        calc_intercept_low xop, from_x_sub, Dx_sub, from_y_sub, Dy_sub
        lda #0
        sta from_y+0
        sta from_y+1
        jmp doneClipFrom
@notYTop:
    lsr
    bcc @notXRight
        dec from_x+1
        calc_intercept_high add, from_y_sub, Dy_sub, from_x_sub, Dx_sub
        lda #$FF
        sta from_x+0
@notXRight:
doneClipFrom:
    compute_out_code from_x, from_y
    tax                 ; Store from_out_code in X temporarily.
    beq clipTo          ; Flag set by TAX.
    and to_out_code
    beq jumpClipFromLoop
trivialReject:
    rts
jumpClipFromLoop:
    jmp clipFromLoop

clipTo:
    ldx to_out_code
    bne clipToLoop
    jmp accept
clipToLoop:
    lda #0
    sta to_x_sub
    sta to_y_sub
    sta Dx_sub
    sta Dy_sub
    sec
    .if .xmatch(xop,add)
        sub16into to_x, from_x, Dx
    .else
        sub16into from_x, to_x, Dx
    .endif
    sec
    sub16into to_y, from_y, Dy

    txa                 ; load to_out_code
    lsr
    bcc @notXLeft
        calc_intercept_low sub, to_y_sub, Dy_sub, to_x_sub, Dx_sub
        lda #0
        sta to_x+0
        sta to_x+1
        jmp doneClipTo
@notXLeft:
    lsr
    lsr
    bcc @notXRight
        dec to_x+1
        calc_intercept_high sub, to_y_sub, Dy_sub, to_x_sub, Dx_sub
        lda #$FF
        sta to_x+0
        jmp doneClipTo
@notXRight:
    lsr
    bcc @notYBottom
        dec to_y+1
        .if .xmatch(xop,add)
            calc_intercept_high sub, to_x_sub, Dx_sub, to_y_sub, Dy_sub
        .else
            calc_intercept_high add, to_x_sub, Dx_sub, to_y_sub, Dy_sub
        .endif
        lda #$FF
        sta to_y+0
@notYBottom:
doneClipTo:
    compute_out_code to_x, to_y
    tax                 ; Store to_out_code in X temporarily.
    beq accept          ; Flag set by TAX.
    jmp clipToLoop
accept:
    ; fall-through into invoking code.
.endmacro

.macro bressenham_set_ptr name
    lda from_x
    alr #%00000100
    tax
    lda from_y
    lsr
    lsr
    lsr
    tay
    bcc :+
    clc
    inx
:
    lda .ident(.sprintf("%s_lo", .string(name))), y
    adc .ident(.sprintf("%s_offset", .string(name))), x
    sta ptr_temp+0
    lda .ident(.sprintf("%s_hi", .string(name))), y
    adc #0
    sta ptr_temp+1 ; This won't set carry.
.endmacro

.macro bressenham op
    lda from_y
    cmp #22*8
    bcc :+
earlyReturn:
    rts
:
    ldx #%11111100
    sax subroutine_temp
    lda to_y
    sec
    sbc subroutine_temp ; Carry will remain set.
    sax rounded_Dy
    lda to_y
    sbc from_y          ; Carry will remain set.
    sta Dy

    .if .xmatch(op,add)
        lda from_x
        sax subroutine_temp
        lda to_x
        sbc subroutine_temp
        and #%11111100
        sta rounded_Dx
        ora rounded_Dy
        beq earlyReturn
        lda to_x
        sbc from_x
        sta Dx
        cmp rounded_Dy
        bcc secondOctant
    .else
        lda to_x
        sax subroutine_temp
        lda from_x
        sbc subroutine_temp
        and #%11111100
        sta rounded_Dx
        ora rounded_Dy
        beq earlyReturn
        lda from_x
        sbc to_x
        sta Dx
        cmp rounded_Dy
        bcc fourthOctant
    .endif

    .if .xmatch(op,add)
        bressenham_set_ptr PPxy

        lda to_x
        lsr
        lsr
        lsr
        adc #$FF
        sta to_x

        lda from_x
        lsr
        lsr
        alr #%11111110      ; Clears carry for iteration code.
        tax

        lda from_y
        and #%00000011
        ora rounded_Dx
        tay
        lda subpixel_table, y
        eor #$FF
        jmp (ptr_temp)
    secondOctant:
        lda from_x
        and #%00000011
        ora rounded_Dy
        tay
        lda subpixel_table, y
        sta subroutine_temp

        bressenham_set_ptr PPyx

        lda from_y
        and #%11111000
        eor #$FF
        sec
        adc to_y
        lsr
        lsr
        lsr
        adc #0
        tay

        lda from_x
        lsr
        lsr
        lsr
        tax

        sec
        lda subroutine_temp
        jmp (ptr_temp)
    .else
    thirdOctant:
        bressenham_set_ptr NPxy

        lda to_x
        lsr
        lsr
        lsr
        adc #0
        sta to_x

        lda from_x
        lsr
        lsr
        lsr
        tax

        lda from_y
        and #%00000011
        ora rounded_Dx
        tay
        lda subpixel_table, y
        sta subroutine_temp
        sec
        jmp (ptr_temp)
    fourthOctant:
        lda from_x
        and #%00000011
        eor #%00000011
        ora rounded_Dy
        tay
        lda subpixel_table, y
        sta subroutine_temp

        bressenham_set_ptr NPyx

        lda from_y
        and #%11111000
        eor #$FF
        sec
        adc to_y
        lsr
        lsr
        lsr
        adc #0
        tay

        lda from_x
        lsr
        lsr
        lsr
        tax

        sec
        lda subroutine_temp
        jmp (ptr_temp)
    .endif
.endmacro

.proc draw_line
    sec
    lax to_y+0
    sbc from_y+0
    sta Dy+0
    lda to_y+1
    tay
    sbc from_y+1
    sta Dy+1
    bvc :+
    eor #$80
:
    bpl posDy
    sec
    lda #0
    sbc Dx+0
    sta Dx+0
    lda #0
    sbc Dx+1
    sta Dx+1

    ; Swap to and from.
    lda from_y+0
    sta to_y+0
    stx from_y+0

    lda from_y+1
    sta to_y+1
    sty from_y+1

    lda from_x+0
    ldx to_x+0
    stx from_x+0
    sta to_x+0

    lda from_x+1
    ldx to_x+1
    stx from_x+1
    sta to_x+1
posDy:

    ; Now find Dx
    sec
    sub16into to_x, from_x, Dx
    bvc :+
    eor #$80
:
    bmi :+
    jmp posDx
:
    sec
    lax #0
    sbc Dx+0
    sta Dx+0
    txa
    sbc Dx+1
    sta Dx+1
    ; Neg Dx
    .scope clipNegX
        clip sub
        bressenham sub
    .endscope
posDx:
    .scope clipPosX
        clip add
        bressenham add
    .endscope
.endproc


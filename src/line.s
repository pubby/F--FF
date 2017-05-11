.include "globals.inc"
.include "intercept.inc"

.export draw_line3, draw_line5

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
    sta from_out_code
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
    sec
    .if .xmatch(xop,add)
        sub16into to_x, from_x, Dx
    .else
        sub16into from_x, to_x, Dx
    .endif
    sec
    sub16into to_y, from_y, Dy

    ;lda #0
    ;sta from_x+1
    ;sta to_x+1
    ;sta from_y+1
    ;sta to_y+1
    ; fall-through into invoking code.
.endmacro

.proc draw_line5
    bankswitch 0
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
    .endscope
    jmp doneClip
posDx:
    .scope clipPosX
        clip add
    .endscope
doneClip:

rounded_from_x = 0
rounded_from_y = 1
rounded_to_x = 2

    lda from_y
    cmp #22*8
    bcc :+
    rts
:


    ldx #%11111100
    lda from_y
dontSwapY:
    sax rounded_from_y
    lda to_y
    sec
    sbc rounded_from_y  ; Carry will remain set.
    sax rounded_Dy
    lda to_y
    sbc from_y          ; Carry will remain set.
    sta Dy
doneSettingY:


    lda from_x
    sax rounded_from_x 
    lax to_x
    sbc from_x
    sta Dx
    txa                 ; Reload to_x.
    and #%11111100
    sta rounded_to_x
    sbc rounded_from_x
    bcc reverseX
    sta rounded_Dx
    cmp Dy
    bcc secondOctant

    jsr calcStartingPointXY
    lda PPxy_lo, y
    adc PPxy_offset, x
    sta ptr_temp+0
    lda PPxy_hi, y
    adc #0
    sta ptr_temp+1 ; This won't set carry.

    lda to_x
    lsr
    lsr
    lsr
    adc #255
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

    jsr calcStartingPointXY
    lda PPyx_lo, y
    adc PPyx_offset, x
    sta ptr_temp+0
    lda PPyx_hi, y
    adc #0
    sta ptr_temp+1

    jmp lsrFromYCallTemp
reverseX:
    sec
    lda rounded_from_x
    sbc rounded_to_x    ; Carry remains set.
    sta rounded_Dx

    sec ; TODO
    lda #0
    sbc Dx
    sta Dx

    ;lda from_x
    ;sbc to_x
    ;sta Dx
    lda rounded_Dx
    cmp Dy
    bcc fourthOctant

    ;lda rounded_Dx
    ;sta Dx

    jsr calcStartingPointXY
    lda NPxy_lo, y
    adc NPxy_offset, x
    sta ptr_temp+0
    lda NPxy_hi, y
    adc #0              ; Carry set from calcStartingPoint. Remains clear.
    sta ptr_temp+1 

    lda to_x
    lsr
    lsr
    lsr
    sbc #255
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

    jsr calcStartingPointXY
    lda NPyx_lo, y
    adc NPyx_offset, x
    sta ptr_temp+0
    lda NPyx_hi, y
    adc #0
    sta ptr_temp+1

lsrFromYCallTemp:
    lda from_y
    lsr
    lsr
    lsr
    ;sbc #0
    sta from_y
    lda to_y
    lsr
    lsr
    lsr
    adc #0
    sec
    sbc from_y
    tay

    ;adc #0
    ;beq return
    ;tay
    ;bcc :+
    ;iny
;:

lsrFromXCallTemp:
    lda from_x
    lsr
    lsr
    lsr
    tax

    ;clc ; TODO
    sec
    lda subroutine_temp
    jmp (ptr_temp)

; Returns with carry clear.
calcStartingPointXY:
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
return:
    rts
.endproc

;jmp .ident(.concat("row_", row+1, "_i_", i)):
;.ident(.concat("row_", row, "_i_", i)):

.if 0
.proc clip_line
    lda from_x+1
    beq from_x_clipped
    bmi clipL
    bpl clipR

    lda from_y+1
    beq from_y_clipped

from_x_clipped:
    lda from_y+1
    beq from_clipped
    
    if(!clipped(from))
    {
        clip(from)
    }

clipL:

.endproc
.endif

.proc draw_line3
.if 0
    lda #0
    sta inter
    lda to_x+1
    beq :+
    jsr clip_to_x_left
    lda to_y
    sta inter
:

    ldx #%11111000
    sec 
    lda to_y
    sbc from_y
    sta Dy
    lda to_x
    sbc from_x
    bcc reverseX
    cmp Dy
    bcc secondOctant
    sax Dx
    lda from_y
    and #%00000111
    ora Dx
    tax
    lda subpixel_table, x
    sta subroutine_temp

    lax from_y
    ldy lsr3_table, x
    lda PPxy_lo, y
    sta ptr_temp+0
    lda PPxy_hi, y
    sta ptr_temp+1

    lax Dx
    ldy lsr3_table, x

    lax from_x
    lda lsr3_table, x
    tax

    lda subroutine_temp
    ; carry set from bcc
    jmp (ptr_temp)
secondOctant:
    sta Dx
    lda Dy
    sax Dy
    lda from_x
    and #%00000111
    ora Dy
    tax
    lda subpixel_table, x
    sta subroutine_temp

    lax from_y
    ldy lsr3_table, x
    lda PPyx_lo, y
    sta ptr_temp+0
    lda PPyx_hi, y
    sta ptr_temp+1

    lax Dy
    ldy lsr3_table, x

    lax from_x
    lda lsr3_table, x
    tax

    lda subroutine_temp
    sec
    jmp (ptr_temp)
reverseX:
    eor #$FF
    adc #1 ; carry cleared from bcc
    cmp Dy
    bcc fourthOctant

    sax Dx
    lda from_y
    and #%00000111
    ora Dx
    tax
    lda subpixel_table, x
    sta subroutine_temp

    lax from_y
    ldy lsr3_table, x
    lda NPxy_lo, y
    sta ptr_temp+0
    lda NPxy_hi, y
    sta ptr_temp+1

    lax Dx
    ldy lsr3_table, x

    lax from_x
    lda lsr3_table, x
    tax

    lda subroutine_temp
    ; carry set from bcc
    jmp (ptr_temp)
fourthOctant:
    sta Dx
    lda Dy
    sax Dy
    lda from_x
    and #%00000111
    ora Dy
    tax
    lda subpixel_table, x
    sta subroutine_temp

    lax from_y
    ldy lsr3_table, x
    lda NPyx_lo, y
    sta ptr_temp+0
    lda NPyx_hi, y
    sta ptr_temp+1

    lax Dy
    ldy lsr3_table, x

    lax from_x
    lda lsr3_table, x
    tax

    lda subroutine_temp
    sec
    jmp (ptr_temp)
.endif
.endproc

.if 0
.proc draw_line3
half_Dx = 0
half_Dy = 1
    lsr from_x
    lsr from_y
    lsr to_x
    lsr to_y

    ; Setup variables
    sec
    lda to_x
    sbc from_x
    bcc negativeDx
    sta Dx
    lda to_y
    sbc from_y ; carry set (bcc)
    sta Dy

    cmp Dx
    bcs @bigDx

    lda Dx
    clc
    adc #4
    lsr
    ;lsr
    ;lsr
    eor #$FF
    ;sec
    ;adc #3
    ;lda #$FF
    tax
    inx

    lda from_y
    lsr
    lsr
    tay
    lda PPxy_lo, y
    sta ptr_temp+0
    lda PPxy_hi, y
    sta ptr_temp+1
    txa
    lsr from_x
    lsr from_x
    lsr to_x
    lsr to_x
    ldx from_x
    jmp (ptr_temp)
@bigDx:
    lsr
    eor #$FF
    tax
    inx

    lsr from_x
    lsr from_x
    lsr from_x
    lsr from_y
    lsr from_y
    lsr from_y

    ldy from_y
    lda PPyx_lo, y
    sta ptr_temp+0
    lda PPyx_hi, y
    sta ptr_temp+1
    lda Dy
    lsr
    lsr
    lsr
    tay
    txa
    ldx from_x
    clc
    jmp (ptr_temp)
negativeDx:
    eor #$FF
    sta Dx
    lda to_y
    sbc from_y ; carry set
    sta Dy

    cmp Dx
    bcs @bigDx

    lda Dx
    lsr
    eor #$FF
    tax
    inx

    lsr from_x
    lsr from_x
    lsr from_x
    lsr from_y
    lsr from_y
    lsr from_y

    ldy from_y
    lda NPxy_lo, y
    sta ptr_temp+0
    lda NPxy_hi, y
    sta ptr_temp+1
    txa
    ldx from_x
    jmp (ptr_temp)
@bigDx:
    lsr
    eor #$FF
    tax
    inx

    lsr from_x
    lsr from_x
    lsr from_x
    lsr from_y
    lsr from_y
    lsr from_y

    ldy from_y
    lda NPyx_lo, y
    sta ptr_temp+0
    lda NPyx_hi, y
    sta ptr_temp+1
    lda Dy
    lsr
    lsr
    lsr
    tay
    txa
    ldx from_x
    clc
    jmp (ptr_temp)
.endproc

.proc draw_line2
dx = 0
dy = 1
D = 2
D_sub = 3
D_add = 4
pattern = 5
pattern_mask = 6
to = 7
    lda to_x
    lsr
    lsr
    sta to

    ; Setup variables
    sec
    lda to_x
    sbc from_x
    sta D_sub
    sec
    lda to_y
    sbc from_y
    sta D_add
    sec
    sbc D_sub
    sta D

    ldy from_x
    ldx from_y
    lda nt_buffer_ptr_lo, x
    sta ptr_temp+0
    lda nt_buffer_ptr_hi, x
    sta ptr_temp+1
    lda #11
    sta pattern
    lda #%00001111
    sta pattern_mask
loop:
.repeat 4, i
    lda #%00010001 << i
    and pattern_mask
    ora (ptr_temp), y
    sta (ptr_temp), y

    lda D
    bmi :++
    lda #$FF
    eor pattern_mask
    sta pattern_mask
    bmi :+
    inx
    lda nt_buffer_ptr_lo, x
    sta ptr_temp+0
    lda nt_buffer_ptr_hi, x
    sta ptr_temp+1
:
    lda D
    sec
    sbc D_sub
:
    clc
    adc D_add
    sta D
.endrepeat

    iny
    cpy to
    bcs return
    jmp loop
return:
    rts
.endproc

.proc draw_line
dx = 0
dy = 1
D = 2
D_sub = 3
D_add = 4
    ; Setup variables
    sec
    lda to_x
    sbc from_x
    sta dx
    asl
    sta D_sub
    sec
    lda to_y
    sbc from_y
    sta dy
    asl
    sta D_add
    sec
    sbc dx
    sta D

    ldy from_x
    ldx from_y
    lda nt_buffer_ptr_lo, x
    sta ptr_temp+0
    lda nt_buffer_ptr_hi, x
    sta ptr_temp+1
loop:
    lda #$20
    sta (ptr_temp), y

    lda D
    bmi doneYChange
    inx
    lda nt_buffer_ptr_lo, x
    sta ptr_temp+0
    lda nt_buffer_ptr_hi, x
    sta ptr_temp+1
    lda D
    sec
    sbc D_sub
doneYChange:
    clc
    adc D_add
    sta D

    iny
    cpy to_x
    bcc loop
    rts
.endproc

.endif

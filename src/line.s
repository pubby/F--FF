.include "globals.inc"

.export draw_line3, draw_line5

.segment "TABLES_256"
subpixel_table:
.repeat 256, i
    .byt (((i & %11111100) * (3 - (i & %11))) + 3) / 4
.endrepeat

.segment "CODE"

.macro scale_by_ratio intercept, intercept_scale, numer, denom
@loop:
    lsr intercept_scale+1
    beq zeroScaleHighByte
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
    bcs @loop ; if denom >= numer
    sta denom+2
    sty denom+1
    stx denom+0
    sec
    .repeat 2, i
        lda intercept+i
        sbc intercept_scale+i
        sta intercept+i
    .endrepeat
    jmp @loop
zeroScaleHighByte:
@loop:
    lsr intercept_scale+0
    beq return
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
    bcs @loop ; if denom >= numer
    sta numer+2
    sty numer+1
    stx numer+0
    sec
    lda intercept+0
    sbc intercept_scale+0
    sta intercept+0
    bcs @loop
    dec intercept+1
    jmp @loop
return:
    lda #0
    sta numer+2
    sta numer+1
    rts
.endmacro

.proc clip_to_x_left
    sec
    lda from_x+0
    sbc to_x+0
    sta Dx+0
    lda #0
    sbc to_x+1
    sta Dx+1

    sec
    lda to_y+0
    sbc from_y+0
    sta Dy+0
    lda to_y+1
    sbc #0
    sta Dy+1

    lda #0
    sta to_x_sub
    sta Dx_sub
    sta to_y_sub
    sta Dy_sub

    ;scale_by_ratio to_y_sub, Dy_sub, to_x_sub, Dx_sub
    scale_by_ratio to_y, Dy, to_x_sub, Dx_sub
.endproc

.proc draw_line5
rounded_from_x = 0
rounded_from_y = 1
rounded_to_x = 2
rounded_to_y = 3
    bankswitch 0

    lda #0
    sta inter
    lda to_x+1
    beq :+
    jsr clip_to_x_left
    lda to_y
    sta inter
:

    ldx #%11111100
    lda from_y
    cmp to_y
    bcc dontSwapY
    ; Swap Y variables and calculate.
    tay
    sbc to_y            ; Carry will remain set.
    sta Dy

    lda to_y
    sta from_y
    sax rounded_from_y

    tya
    sta to_y            ; is this needed?
    sax rounded_to_y

    sbc rounded_from_y  ; Carry set from last sbc. (and will remain set)
    sax rounded_Dy
    jmp doneSettingY
dontSwapY:
    sax rounded_from_y
    lda to_y
    sax rounded_to_y
    sec
    sbc rounded_from_y  ; Carry will remain set.
    sax rounded_Dy
    lda to_y
    sbc from_y          ; Carry will remain set.
    sta Dy
doneSettingY:

    lda from_x
    sax rounded_from_x 
    lda to_x
    sax rounded_to_x
    sbc rounded_from_x
    bcc reverseX
    sax rounded_Dx
    lda to_x
    sbc from_x
    sta Dx
    lda rounded_Dx
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
    adc #0
    sta to_x

    dec Dy              ; Needed for this octant only.
                        ; (cmp clears carry every iteration)
    lda from_y
    and #%00000011
    ora rounded_Dx
    tay
    lda subpixel_table, y
    sta subroutine_temp
    ;dec subroutine_temp

    jmp lsrFromXCallTemp
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
    lda from_x
    sbc rounded_to_x    ; Carry remains set.
    sax rounded_Dx
    lda from_x
    sbc to_x
    sta Dx
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
    sbc #0
    sta to_x

    lda from_y
    and #%00000011
    ora rounded_Dx
    tay
    lda subpixel_table, y
    sta subroutine_temp

    jmp lsrFromXCallTemp
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
    lda Dy
    lsr
    lsr
    lsr
    adc #0
    beq return
    tay

lsrFromXCallTemp:
    lda from_x
    lsr
    lsr
    lsr
    tax

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

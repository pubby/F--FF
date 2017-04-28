.include "globals.inc"

.export draw_line, draw_line2, draw_line3

.segment "RODATA"
nt_buffer_ptr_lo:
.repeat 32, i
    .byt .lobyte(nt_buffer + i * 32)
.endrepeat
nt_buffer_ptr_hi:
.repeat 32, i
    .byt .hibyte(nt_buffer + i * 32)
.endrepeat

upper_pattern:
.repeat 256, i
    .byt $FF
    ;.byt %1 << (i & %11)
.endrepeat

lower_pattern:
.repeat 256, i
    .byt $FF
    ;.byt %10000 << (i & %11)
.endrepeat

.segment "CODE"

.if 0
.proc draw_line
dx = 0 ; 2 bytes
dy = 2 ; 2 bytes
D = 4 ; 2 bytes
    sec
    lda to_x+0
    sbc from_x+0
    sta dx+0
    lda to_x+1
    sbc from_x+1
    sta dx+1

    sec
    lda to_y+0
    sbc from_y+0
    sta dy+0
    sta D+0
    lda to_y+1
    sbc from_y+1
    sta dy+1
    asl D+0
    rol
    sta D+1

    sec
    lda D+0
    sbc dx+0
    sta D+0
    lda D+1
    sbc dx+1
    sta D+1

    ; Loop
    ldx 
loop:
.endif

.if 0
.proc prepare_draw_line
    ; clip

    ; calculate midpoint
    lda from_x+1
    beq isGood
    clc
    lda from_x+0
    adc to_x+0
    sta midpoint_x+0
    lda from_x+1
    adc to_x+1
    ror
    sta midpoint_x+1
    ror midpoint_x+0
isGood:
.endproc
.endif


;jmp .ident(.concat("row_", row+1, "_i_", i)):
;.ident(.concat("row_", row, "_i_", i)):

.proc draw_line3
    ; Setup variables
    sec
    lda to_x
    sbc from_x
    sta Dx
    sec
    lda to_y
    sbc from_y
    sta Dy

    cmp Dx
    bcs bigDx

    sec
    sbc Dx 
    tax
    ldy from_y
    lda PPxy_lo, y
    sta ptr_temp+0
    lda PPxy_hi, y
    sta ptr_temp+1
    txa
    ldx from_x
    jmp (ptr_temp)
bigDx:
    lda Dx
    sbc Dy  ; Carry set from bcs
    sta subroutine_temp
    ldy from_y
    lda PPyx_lo, y
    sta ptr_temp+0
    lda PPyx_hi, y
    sta ptr_temp+1
    lda subroutine_temp
    ldx from_x
    ldy Dy
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


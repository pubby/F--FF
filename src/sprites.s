.include "globals.inc"

.export clear_remaining_cpu_oam
.export init_game_sprites
.export init_timer_sprites
.export prepare_blank_sprites
.export prepare_game_sprites
.export prepare_metasprite
.export prepare_menu_sprites
.export time_digit_table
.export OAM_OPP

OAM_SHIP = CPU_OAM + 0
OAM_SHIP_END = OAM_SHIP + 16*4

p1_OAM_SHIP = OAM_SHIP
p2_OAM_SHIP = OAM_SHIP + 8*4
p1_OAM_SHIP_END = p2_OAM_SHIP
p2_OAM_SHIP_END = OAM_SHIP_END

OAM_OPP = OAM_SHIP_END
OAM_OPP_END = OAM_OPP+2*4

OAM_BOOST_BLACK = OAM_OPP_END
OAM_BOOST_BLACK_END = OAM_BOOST_BLACK + 8*4

p1_OAM_BOOST_BLACK = OAM_BOOST_BLACK
p2_OAM_BOOST_BLACK = OAM_BOOST_BLACK + 4*4

OAM_BOOST_BAR = OAM_BOOST_BLACK_END
OAM_BOOST_BAR_END = OAM_BOOST_BAR + 8*4

p1_OAM_BOOST_BAR = OAM_BOOST_BAR
p2_OAM_BOOST_BAR = OAM_BOOST_BAR + 4*4

OAM_TIME = OAM_BOOST_BAR_END
OAM_TIME_END = OAM_TIME + 8*4

OAM_START = OAM_TIME_END

.segment "RODATA"
.include "metasprites.inc"

.segment "SMALL_TABLES"
.include "time_digit.inc"

.segment "CODE"

SPR_NT = 1
.define PATTERN(i) ((i) * 2 + SPR_NT)

draw_x = 0
draw_y = 1

; This writes sprite data to CPU_OAM. Does not write to PPU.
; Clobbers A, X, Y.
.proc prepare_1p_sprites
    ; player y-positions
    lda p1_dir_speed
    anc #%11110000
    ror
    adc #4*8
    tay
    ldx p1_jump
    lda #176
    clc
    adc ship_entrance
    bcc :+
    lda #255
    jmp @store
:
    sec
    sbc ship_jump_table, x
@store:
    sta subroutine_temp
    .repeat 6, i
        .if i > 0
            lda subroutine_temp
        .endif
        adc ship_y_offsets+i, y
        sbc p1_lift
        sta OAM_SHIP+(4*(i+0))+0
    .endrepeat
    .repeat 6, i
        lda subroutine_temp
        adc #16
        adc ship_y_offsets+i, y
        sbc p1_lift
        sta OAM_SHIP+(4*(i+6))+0
    .endrepeat

    lda p1_buttons_held
    and #BUTTON_LEFT | BUTTON_RIGHT
    beq noFlaps
    cmp #BUTTON_LEFT | BUTTON_RIGHT
    beq noFlaps
    and #BUTTON_LEFT
    beq @doneLeft
    lda #PATTERN($34)
    sta OAM_SHIP+(4*0)+1
    lda #0
    ldy OAM_SHIP+(4*6)+0
    cpy #182
    bcc :+
    lda frame_number
    anc #%110
:
    adc #PATTERN($44)
    sta OAM_SHIP+(4*6)+1
    lda #PATTERN($33)
    sta OAM_SHIP+(4*5)+1
    lda #PATTERN($43)
    sta OAM_SHIP+(4*11)+1
@doneLeft:

    lda p1_buttons_held
    and #BUTTON_RIGHT
    beq @doneRight
    lda #PATTERN($33)
    sta OAM_SHIP+(4*0)+1
    lda #PATTERN($43)
    sta OAM_SHIP+(4*6)+1
    lda #PATTERN($34)
    sta OAM_SHIP+(4*5)+1
    lda #0
    ldy OAM_SHIP+(4*11)+0
    cpy #182
    bcc :+
    lda frame_number
    anc #%110
:
    adc #PATTERN($44)
    sta OAM_SHIP+(4*11)+1
@doneRight:
    jmp donePlayer

noFlaps:
    lda #PATTERN($30)
    sta OAM_SHIP+(4*0)+1
    sta OAM_SHIP+(4*5)+1
    lda #PATTERN($40)
    sta OAM_SHIP+(4*6)+1
    sta OAM_SHIP+(4*11)+1
donePlayer:

    clc
    lda p1_boost_tank
    adc #68
.repeat 4, j
    .if j <> 0
        adc #16
    .endif
    sta p1_OAM_BOOST_BLACK+(j*4)+0
    sta p2_OAM_BOOST_BLACK+(j*4)+0
.endrepeat

    jsr update_time_digits

    lda p1_explosion
    beq noExplosion
    ldx #.lobyte(OAM_SHIP)
    cmp #4
    bcs blankExplosion
    asl
    tay
    dey
    lda #128-8*3
    sta draw_x
    lda #172
    sta draw_y
    lda metasprite::explosion, y
    sta ptr_temp+1
    dey
    lda metasprite::explosion, y
    sta ptr_temp+0
    ldy #0
    jsr prepare_metasprite

blankExplosion:
    cpx #.lobyte(OAM_SHIP_END)
    beq doneExplosion
    lda #$FF
:
    sta CPU_OAM, x
    axs #.lobyte(-4)
    cpx #.lobyte(OAM_SHIP_END)
    bne :-
doneExplosion:
noExplosion:

    ; Use X as an index into CPU_OAM. The 'prepare_sprite' functions will
    ; use and increment X as they write to 'CPU_OAM'.
    ldx #.lobyte(OAM_START)

    lda p1_explosion
    bne doneSmoke
    lda p1_boost_tank
    cmp #16
    bcs doneSmoke

    lda subroutine_temp
    sec
    sbc #14
    sta CPU_OAM+0, x ; Set sprite's y-position.
    lda #128-14-4
    sta CPU_OAM+3, x ; Set sprite's x-position.
    lda frame_number
    anc #%110
    adc #PATTERN($35)
    sta CPU_OAM+1, x ; Set sprite's pattern.
    lda #2
    sta CPU_OAM+2, x ; Set sprite's attributes.
    txa
    axs #.lobyte(-4)

    lda subroutine_temp
    sec
    sbc #14
    sta CPU_OAM+0, x ; Set sprite's y-position.
    lda #128+14-4
    sta CPU_OAM+3, x ; Set sprite's x-position.
    lda frame_number
    anc #%110
    adc #PATTERN($35)
    sta CPU_OAM+1, x ; Set sprite's pattern.
    lda #2 | %01000000
    sta CPU_OAM+2, x ; Set sprite's attributes.
    txa
    axs #.lobyte(-4)
doneSmoke:

    lda p1_pre_explosion
    beq doneExclamationMark
    lda frame_number
    lsr
    bcc doneExclamationMark
    lda #146
    sta CPU_OAM+0, x ; Set sprite's y-position.
    lda #128+-4
    sta CPU_OAM+3, x ; Set sprite's x-position.
    lda #PATTERN($48)
    sta CPU_OAM+1, x ; Set sprite's pattern.
    lda #%00000000
    sta CPU_OAM+2, x ; Set sprite's attributes.
    txa
    axs #.lobyte(-4)
doneExclamationMark:

    lda p1_text_timer
    beq doneText
    dec p1_text_timer

    lda #128-5*5
    sta draw_x
    lda #50
    sta draw_y
    lda p1_lap
    asl
    sbc #1
    tay
    lda metasprite::lap, y
    sta ptr_temp+0
    iny
    lda metasprite::lap, y
    sta ptr_temp+1
    ldy #0
    jsr prepare_metasprite
doneText:

finish:
    lda countdown
    beq doneCountdown
    asl
    sbc #1
    tax
    lda metasprite::countdown, x
    sta ptr_temp+0
    inx
    lda metasprite::countdown, x
    sta ptr_temp+1
    lda #(256-34)/2
    sta draw_x
    lda #80
    sta draw_y
    ldx #OAM_START - CPU_OAM
    ldy #0
    jsr prepare_metasprite
doneCountdown:

    ; Clear the remaining portion of CPU_OAM so that unused/glitchy
    ; sprites aren't drawn.
    jmp clear_remaining_cpu_oam ; X is 0 after clear_remaining_cpu_oam.
.endproc

.proc prepare_game_sprites
    lda two_player
    bne prepare_2p_sprites
    jmp prepare_1p_sprites
.endproc

.proc prepare_2p_sprites
    .repeat 2, i
    .scope P i, _poopy_diaper
        ; player y-positions
        lda P i, _dir_speed
        anc #%11110000
        arr #$FF
        ror
        adc #6*4
        tay
        ldx P i, _jump
        lda #182
        clc
        adc ship_entrance
        bcc :+
        lda #255
        jmp :++
    :
        sec
        sbc #0
        sbc ship_jump_table, x
    :
        sta subroutine_temp
        .repeat 3, k
            .if k > 0
                lda subroutine_temp
            .endif
            adc ship_y_offsets_2p+k, y
            sbc P i, _lift
            sta 0+(4*(k+0))+P i, _OAM_SHIP
        .endrepeat
        .repeat 3, k
            lda subroutine_temp
            adc #16
            adc ship_y_offsets_2p+k, y
            sbc P i, _lift
            sta 0+(4*(k+3))+P i, _OAM_SHIP
        .endrepeat

        clc
        lda P i, _boost_tank
        adc #68
        .repeat 4, j
            .if j <> 0
                adc #16
            .endif
            sta 0+(j*4)+P i, _OAM_BOOST_BLACK
        .endrepeat

        lda P i, _explosion
        beq noExplosion
        ldx #.lobyte(P i, _OAM_SHIP)
        cmp #4
        bcs blankExplosion
        asl
        tay
        dey
        lda #(128-32)/2+128*i
        sta draw_x
        lda #168+8
        sta draw_y
        lda metasprite::explosion_small, y
        sta ptr_temp+1
        dey
        lda metasprite::explosion_small, y
        sta ptr_temp+0
        ldy #0
        jsr prepare_metasprite

    blankExplosion:
        cpx #.lobyte(P i, _OAM_SHIP_END)
        bcs doneExplosion
        lda #$FF
    :
        sta CPU_OAM, x
        axs #.lobyte(-4)
        cpx #.lobyte(OAM_SHIP_END)
        bne :-
    doneExplosion:
    noExplosion:
    .endscope
    .endrepeat

    jsr update_time_digits

    ; Use X as an index into CPU_OAM. The 'prepare_sprite' functions will
    ; use and increment X as they write to 'CPU_OAM'.
    ldx #.lobyte(OAM_START)

    .repeat 2, i
    .scope P i, _stinky_butt
        lda P i, _pre_explosion
        beq doneExclamationMark
        lda frame_number
        lsr
        bcc doneExclamationMark
        lda #152
        sta CPU_OAM+0, x ; Set sprite's y-position.
        lda #64-4+128*i
        sta CPU_OAM+3, x ; Set sprite's x-position.
        lda #PATTERN($48)
        sta CPU_OAM+1, x ; Set sprite's pattern.
        lda #%00000000
        sta CPU_OAM+2, x ; Set sprite's attributes.
        txa
        axs #.lobyte(-4)
    doneExclamationMark:

    lda P i, _text_timer
    beq doneText
    dec P i, _text_timer

    lda #64-5*5+128*i
    sta draw_x
    lda #50
    sta draw_y
    lda P i, _lap
    asl
    sbc #1
    tay
    lda metasprite::lap, y
    sta ptr_temp+0
    iny
    lda metasprite::lap, y
    sta ptr_temp+1
    ldy #0
    jsr prepare_metasprite
doneText:

    .endscope
    .endrepeat

    jmp prepare_1p_sprites::finish
.endproc

.proc update_time_digits
    ldy time_sub
    lda time_digit_table, y
    and #%00001111
    asl
    adc #PATTERN($56)
    sta OAM_TIME+7*4+1

    lda time_digit_table, y
    alr #%11110000
    lsr
    lsr
    adc #PATTERN($56)
    sta OAM_TIME+6*4+1

    lda time_digits+0
    asl
    adc #PATTERN($56)
    sta OAM_TIME+4*4+1

    lda time_digits+1
    asl
    adc #PATTERN($56)
    sta OAM_TIME+3*4+1

    lda time_digits+2
    asl
    adc #PATTERN($56)
    sta OAM_TIME+1*4+1

    lda time_digits+3
    asl
    adc #PATTERN($56)
    sta OAM_TIME+0*4+1
    rts
.endproc


ship_y_offsets:
    .byt  <(+3-7), <+2, <+1, <-0, <-1, <(-2-7), $FF, $FF
    .byt  <(+2-7), <+1, <+0, <-0, <-1, <(-2-7), $FF, $FF
    .byt  <(+1-7), <+0, <+0, <-0, <-0, <(-1-7), $FF, $FF
    .byt  <(+0-7), <+0, <+0, <-0, <-0, <(-0-7), $FF, $FF
    .byt  <(-0-7), <-0, <-0, <+0, <+0, <(+0-7), $FF, $FF
    .byt  <(-1-7), <-0, <-0, <+0, <+0, <(+1-7), $FF, $FF
    .byt  <(-2-7), <-1, <-0, <+0, <+1, <(+2-7), $FF, $FF
    .byt  <(-2-7), <-1, <-0, <+1, <+2, <(+3-7), $FF, $FF

ship_y_offsets_2p:
    .byt  <+1, <+0, <-2, $FF
    .byt  <+1, <+0, <-2, $FF
    .byt  <+1, <+0, <-2, $FF
    .byt  <+1, <+0, <-1, $FF
    .byt  <+1, <+0, <-0, $FF
    .byt  <+0, <+0, <-0, $FF
    .byt  <+0, <+0, <-0, $FF
    .byt  <-0, <-0, <+1, $FF
    .byt  <-1, <-0, <+1, $FF
    .byt  <-2, <-0, <+1, $FF
    .byt  <-2, <-0, <+1, $FF
    .byt  <-2, <-0, <+1, $FF

prepare_blank_sprites:
    ldx #0
    ; Fall-through to clear_remaining_cpu_oam
; Clears CPU_OAM (hides sprites) from X to $FF.
; Clobbers A, X. Preserves Y.
.proc clear_remaining_cpu_oam
    lda #$FF
clearOAMLoop:
    sta CPU_OAM, x
    axs #.lobyte(-4)
    bne clearOAMLoop    ; OAM is 256 bytes. Overflow signifies completion.
    rts
.endproc

.proc init_1p_sprites
    ldx #0
    jsr clear_remaining_cpu_oam

    ; x-positions
    .repeat 6, i
        lda #104+8*i
        sta OAM_SHIP+(4*(i+0))+3
        sta OAM_SHIP+(4*(i+6))+3
    .endrepeat

    ; ship patterns
    .repeat 3, i
        lda #PATTERN($30+i)
        sta OAM_SHIP+(4*(i+0))+1
        lda #PATTERN($40+i)
        sta OAM_SHIP+(4*(i+6))+1
        lda #PATTERN($30+2-i)
        sta OAM_SHIP+(4*(i+3))+1
        lda #PATTERN($40+2-i)
        sta OAM_SHIP+(4*(i+9))+1
    .endrepeat

    ; attributes
    lda #2
    sta OAM_SHIP+(4*0)+2
    sta OAM_SHIP+(4*1)+2
    sta OAM_SHIP+(4*2)+2
    lda #0
    sta OAM_SHIP+(4*6)+2
    sta OAM_SHIP+(4*7)+2
    sta OAM_SHIP+(4*8)+2

    lda #2 | %01000000
    sta OAM_SHIP+(4*3)+2
    sta OAM_SHIP+(4*4)+2
    sta OAM_SHIP+(4*5)+2
    lda #0 | %01000000
    sta OAM_SHIP+(4*9)+2
    sta OAM_SHIP+(4*10)+2
    sta OAM_SHIP+(4*11)+2

    ;;;;;;;;;;;;;;;;;;
    ; Boost bar shit ;
    ;;;;;;;;;;;;;;;;;;
    
boost_bar_shit:

    ; x-positions
    lda #4
    .repeat 4, i
        sta p1_OAM_BOOST_BLACK+(4*i)+3
        sta p1_OAM_BOOST_BAR+(4*i)+3
    .endrepeat

    lda #256-8-4
    .repeat 4, i
        sta p2_OAM_BOOST_BLACK+(4*i)+3
        sta p2_OAM_BOOST_BAR+(4*i)+3
    .endrepeat
    
    ; y-positions
    .repeat 4, i
        lda #68+16*i
        sta p1_OAM_BOOST_BLACK+(4*i)+0
        sta p1_OAM_BOOST_BAR+(4*i)+0
        sta p2_OAM_BOOST_BLACK+(4*i)+0
        sta p2_OAM_BOOST_BAR+(4*i)+0
    .endrepeat

    ; pattern
    lda #PATTERN($50)
    ldy #PATTERN($51)
    .repeat 8, i
        sta OAM_BOOST_BLACK+(4*i)+1
        sty OAM_BOOST_BAR+(4*i)+1
    .endrepeat

    ; attributes
    lda #3 | %00100000
    ldy #3
    .repeat 8, i
        sta OAM_BOOST_BLACK+(4*i)+2
        sty OAM_BOOST_BAR+(4*i)+2
    .endrepeat
    rts
.endproc

.proc init_game_sprites
    lda two_player
    bne init_2p_sprites
    jmp init_1p_sprites
.endproc

.proc init_2p_sprites
    ldx #0
    jsr clear_remaining_cpu_oam

    ; x-positions
    .repeat 3, i
        lda #(128-24)/2+8*i
        sta p1_OAM_SHIP+(4*(i+0))+3
        sta p1_OAM_SHIP+(4*(i+3))+3
        lda #128+(128-24)/2+8*i
        sta p2_OAM_SHIP+(4*(i+0))+3
        sta p2_OAM_SHIP+(4*(i+3))+3
    .endrepeat

    ; ship patterns
    .repeat 2, i
        lda #PATTERN($39)
        sta 1+(4*0)+P i, _OAM_SHIP
        sta 1+(4*2)+P i, _OAM_SHIP
        lda #PATTERN($3A+i)
        sta 1+(4*1)+P i, _OAM_SHIP
        lda #PATTERN($49)
        sta 1+(4*3)+P i, _OAM_SHIP
        sta 1+(4*5)+P i, _OAM_SHIP
        lda #PATTERN($4A)
        sta 1+(4*4)+P i, _OAM_SHIP
    .endrepeat

    ; attributes
    .repeat 2, i
        lda #i
        sta 2+(4*0)+P i, _OAM_SHIP
        sta 2+(4*3)+P i, _OAM_SHIP
        sta 2+(4*4)+P i, _OAM_SHIP
        ora #%01000000
        sta 2+(4*5)+P i, _OAM_SHIP
        sta 2+(4*2)+P i, _OAM_SHIP
        lda #2
        sta 2+(4*1)+P i, _OAM_SHIP
    .endrepeat

    jmp init_1p_sprites::boost_bar_shit
.endproc

.proc init_timer_sprites
    ; x-positions
    .repeat 8, i
        lda #(256-80)/2+10*i+1
        sta OAM_TIME+(4*i)+3
    .endrepeat
    
    ; y-positions
    lda #210
    .repeat 8, i
        sta OAM_TIME+(4*i)+0
    .endrepeat

    ; pattern
    lda #PATTERN($56)
    ldy #PATTERN($52)
    sta OAM_TIME+(4*0)+1
    sta OAM_TIME+(4*1)+1
    sty OAM_TIME+(4*2)+1
    sta OAM_TIME+(4*3)+1
    sta OAM_TIME+(4*4)+1
    sty OAM_TIME+(4*5)+1
    sta OAM_TIME+(4*6)+1
    sta OAM_TIME+(4*7)+1

    ; attributes
    lda #3
    .repeat 8, i
        sta OAM_TIME+(4*i)+2
    .endrepeat
    rts
.endproc

.proc prepare_metasprite
    sty subroutine_temp
    ldy #0
    lda (ptr_temp), y
    tay              ; First byte holds length of data.
loop:
    cpx #256-16
    bcs return

    lda (ptr_temp), y
    dey
    clc
    adc draw_y
    bcs badPos
    cmp #240
    bcs badPos
    sta CPU_OAM+0, x ; Set sprite's y-position.

    lda (ptr_temp), y
    bpl :+
    adc draw_x
    sta CPU_OAM+3, x ; Set sprite's x-position.
    bcc badPos
:
    adc draw_x
    sta CPU_OAM+3, x ; Set sprite's x-position.
    bcs badPos
    dey

    lda (ptr_temp), y
    dey
    sta CPU_OAM+1, x ; Set sprite's pattern.
    lda (ptr_temp), y
    eor subroutine_temp
    sta CPU_OAM+2, x ; Set sprite's attributes.

    ; Increment X by 4.
    txa
    axs #.lobyte(-4)
deyCheck:
    dey
    bne loop
return:
    rts
badPos:
    dey
    dey
    jmp deyCheck
.endproc

.proc prepare_menu_sprites
    ldx #0

    lda two_player
    beq doneRadSprite

    lda #160
    sta draw_x
    sec
    lda #120-1+32
    sbc menu_scroll
    bcs doneRadSprite
    sta draw_y

    ldy #0
    store16into #metasprite::menu_p2_const0, ptr_temp
    jsr prepare_metasprite
doneRadSprite:

    lda #24
    sec
    sbc menu_icy_x
    bcs doneIcy
    sta draw_x
    store8into #60, draw_y
    store16into #metasprite::icy_text_const0, ptr_temp
    ldy #1
    jsr prepare_metasprite
doneIcy:

    lda #24
    sec
    sbc menu_spicy_x
    bcs doneSpicy
    sta draw_x
    store8into #60+28, draw_y
    store16into #metasprite::spicy_text_const0, ptr_temp
    ldy #1
    jsr prepare_metasprite
doneSpicy:

    lda #24
    sec
    sbc menu_dicey_x
    bcs doneDicey
    sta draw_x
    store8into #60+28*2, draw_y
    store16into #metasprite::dicey_text_const0, ptr_temp
    ldy #1
    jsr prepare_metasprite
doneDicey:

    lda menu_state
    and #MENU_SHOW_CURSOR
    beq doneShowCursor
    ldy track_number
    lda menu_table_y, y
    sta CPU_OAM+0, x ; Set sprite's y-position.
    lda #PATTERN($20)
    sta CPU_OAM+1, x ; Set sprite's pattern.
    lda #1
    sta CPU_OAM+2, x ; Set sprite's attributes.
    lda frame_number
    lsr
    lsr
    lsr
    lsr
    alr #%00000010
    adc #28
    sta CPU_OAM+3, x ; Set sprite's x-position.
    txa
    axs #.lobyte(-4)
doneShowCursor:

    jmp clear_remaining_cpu_oam
.endproc

.segment "SMALL_TABLES"
menu_table_y:
    .byt 60, 60+28, 60+28*2, $FF

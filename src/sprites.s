.include "globals.inc"

.export clear_remaining_cpu_oam
.export init_game_sprites
.export prepare_blank_sprites
.export prepare_game_sprites
.export prepare_metasprite
.export prepare_menu_sprites

OAM_SHIP = CPU_OAM + 0
OAM_SHADOW = OAM_SHIP + 12*4
OAM_BOOST_BLACK = OAM_SHADOW + 6*4
OAM_BOOST_BAR = OAM_BOOST_BLACK + 4*4
OAM_START = OAM_BOOST_BAR + 4*4

.segment "RODATA"
.include "metasprites.inc"

.segment "CODE"

SPR_NT = 1
.define PATTERN(i) ((i) * 2 + SPR_NT)

draw_x = 0
draw_y = 1

; This writes sprite data to CPU_OAM. Does not write to PPU.
; Clobbers A, X, Y.
.proc prepare_game_sprites
    ; Write to CPU_OAM.
    jsr prepare_player_sprites

    ; Use X as an index into CPU_OAM. The 'prepare_sprite' functions will
    ; use and increment X as they write to 'CPU_OAM'.
    ldx #.lobyte(OAM_START)


    clc
    lda p1_boost_tank
    adc #64
.repeat 4, j
    .if j <> 0
        adc #16
    .endif
    sta OAM_BOOST_BLACK+(j*4)+0
.endrepeat

    ; Clear the remaining portion of CPU_OAM so that unused/glitchy
    ; sprites aren't drawn.
    jmp clear_remaining_cpu_oam ; X is 0 after clear_remaining_cpu_oam.
.endproc

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

ship_y_offsets:
    .byt  <(+3-4), <+2, <+1, <-0, <-1, <(-2-4), $FF, $FF
    .byt  <(+2-4), <+1, <+0, <-0, <-1, <(-2-4), $FF, $FF
    .byt  <(+1-4), <+0, <+0, <-0, <-0, <(-1-4), $FF, $FF
    .byt  <(+0-4), <+0, <+0, <+0, <+0, <(+0-4), $FF, $FF
    .byt  <(+0-4), <+0, <+0, <+0, <+0, <(+0-4), $FF, $FF
    .byt  <(-1-4), <+0, <+0, <+0, <+0, <(+1-4), $FF, $FF
    .byt  <(-2-4), <-1, <+0, <+0, <+1, <(+2-4), $FF, $FF
    .byt  <(-2-4), <-1, <+0, <+1, <+2, <(+3-4), $FF, $FF
    .byt  <(-2-4), <-1, <+0, <+1, <+2, <(+3-4), $FF, $FF

.proc init_game_sprites
    ldx #0
    jsr clear_remaining_cpu_oam

    ; x-positions
    .repeat 6, i
        lda #104+8*i
        ; Ship
        sta OAM_SHIP+(4*(i+0))+3
        sta OAM_SHIP+(4*(i+6))+3
        ; Shadow
        sta OAM_SHADOW+(4*(i))+3
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
    lda #%01000000
    ldx #%00100001
    sax OAM_SHIP+(4*0)+2
    sax OAM_SHIP+(4*1)+2
    sax OAM_SHIP+(4*2)+2
    sax OAM_SHIP+(4*6)+2
    sax OAM_SHIP+(4*7)+2
    sax OAM_SHIP+(4*8)+2
    stx OAM_SHADOW+(4*0)+2
    stx OAM_SHADOW+(4*1)+2
    stx OAM_SHADOW+(4*2)+2

    ldx #%01000001
    sax OAM_SHIP+(4*3)+2
    sax OAM_SHIP+(4*4)+2
    sax OAM_SHIP+(4*5)+2
    sax OAM_SHIP+(4*9)+2
    sax OAM_SHIP+(4*10)+2
    sax OAM_SHIP+(4*11)+2
    stx OAM_SHADOW+(4*3)+2
    stx OAM_SHADOW+(4*4)+2
    stx OAM_SHADOW+(4*5)+2

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

    ; shadow patterns
    .repeat 3, i
        lda #PATTERN($35+i)
        sta OAM_SHADOW+(4*(i))+1
        sta OAM_SHADOW+(4*(5-i))+1
    .endrepeat

    ; y-positions
    lda #154+32
    .repeat 6, i
        sta OAM_SHADOW+(4*(i))+0
    .endrepeat


    ;;;;;;;;;;;;;;;;;;
    ; Boost bar shit ;
    ;;;;;;;;;;;;;;;;;;
    

    ; x-positions
    lda #4
    .repeat 4, i
        sta OAM_BOOST_BLACK+(4*i)+3
        sta OAM_BOOST_BAR+(4*i)+3
    .endrepeat
    
    ; y-positions
    .repeat 4, i
        lda #64+16*i
        sta OAM_BOOST_BLACK+(4*i)+0
        sta OAM_BOOST_BAR+(4*i)+0
    .endrepeat

    ; pattern
    lda #PATTERN($50)
    ldy #PATTERN($51)
    .repeat 4, i
        sta OAM_BOOST_BLACK+(4*i)+1
        sty OAM_BOOST_BAR+(4*i)+1
    .endrepeat

    ; attributes
    lda #3 | %00100000
    ldy #3
    .repeat 4, i
        sta OAM_BOOST_BLACK+(4*i)+2
        sty OAM_BOOST_BAR+(4*i)+2
    .endrepeat

    rts
.endproc

.proc prepare_player_sprites
    ; y-positions
    lda p1_dir_speed
    cmp #$80
    arr #%11100000
    ror
    adc #4*8
    tay
    sec
    .repeat 6, i
        lda #154
        adc ship_y_offsets+i, y
        sbc p1_lift
        sta OAM_SHIP+(4*(i+0))+0
    .endrepeat
    .repeat 6, i
        lda #154+16
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
    beq :+
    lda #PATTERN($34)
    sta OAM_SHIP+(4*0)+1
    lda frame_number
    anc #%110
    adc #PATTERN($44)
    sta OAM_SHIP+(4*6)+1
    lda #PATTERN($33)
    sta OAM_SHIP+(4*5)+1
    lda #PATTERN($43)
    sta OAM_SHIP+(4*11)+1
:

    lda p1_buttons_held
    and #BUTTON_RIGHT
    beq :+
    lda #PATTERN($33)
    sta OAM_SHIP+(4*0)+1
    lda #PATTERN($43)
    sta OAM_SHIP+(4*6)+1
    lda #PATTERN($34)
    sta OAM_SHIP+(4*5)+1
    lda frame_number
    anc #%110
    adc #PATTERN($44)
    sta OAM_SHIP+(4*11)+1
:
    rts

noFlaps:
    lda #PATTERN($30)
    sta OAM_SHIP+(4*0)+1
    sta OAM_SHIP+(4*5)+1
    lda #PATTERN($40)
    sta OAM_SHIP+(4*6)+1
    sta OAM_SHIP+(4*11)+1
    rts


    lda #104
    sta draw_x

    lda #64
    sec
    sbc p1_lift
    sta draw_y

    ldy #1
    store16into #metasprite::ship_const0, ptr_temp
    ;jsr prepare_metasprite

    ldy #$26
    lda p1_buttons_held
    and #BUTTON_B
    bne :+
    ldy #$06
:
    sty palette_buffer+16+7


    ; SHADOW
    ; y-positions
    lda #154+18
    .repeat 6, i
        sta CPU_OAM+(4*(i+0))+0, x
    .endrepeat

    ; x-positions
    .repeat 6, i
        lda #104+8*i
        sta CPU_OAM+(4*(i+0))+3, x
    .endrepeat

    ; patterns
    .repeat 3, i
        lda #PATTERN($35+i)
        sta CPU_OAM+(4*(i+0))+1, x
        sta CPU_OAM+(4*(5-i))+1, x
    .endrepeat

    ; attributes
    lda #%00000010
    .repeat 3, i
        sta CPU_OAM+(4*(i+0))+2, x
    .endrepeat
    lda #%01000010
    .repeat 3, i
        sta CPU_OAM+(4*(i+3))+2, x
    .endrepeat

    txa
    axs #.lobyte(-4*6)
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

    lda menu_data
    and #MENU_2P
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
    ldy menu_cursor
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

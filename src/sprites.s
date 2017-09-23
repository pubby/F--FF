.include "globals.inc"

.export clear_remaining_cpu_oam
.export prepare_blank_sprites
.export prepare_game_sprites
.export prepare_metasprite
.export prepare_menu_sprites

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
    ; Use X as an index into CPU_OAM. The 'prepare_sprite' functions will
    ; use and increment X as they write to 'CPU_OAM'.
    ldx #0

    ; Write to CPU_OAM.
    jsr prepare_player_sprites

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
    .byt  <+3, <+2, <+1, <-0, <-1, <-2, $FF, $FF
    .byt  <+2, <+1, <+0, <-0, <-1, <-2, $FF, $FF
    .byt  <+1, <+0, <+0, <-0, <-0, <-1, $FF, $FF
    .byt  <+0, <+0, <+0, <+0, <+0, <+0, $FF, $FF
    .byt  <-1, <+0, <+0, <+0, <+0, <+1, $FF, $FF
    .byt  <-2, <-1, <+0, <+0, <+1, <+2, $FF, $FF
    .byt  <-2, <-1, <+0, <+1, <+2, <+3, $FF, $FF
    .byt  <-2, <-1, <+0, <+1, <+2, <+3, $FF, $FF

.proc prepare_player_sprites
    lda p1_dir_speed
    cmp #$80
    arr #%11100000
    ror
    adc #4*8
    tay

    ; y-positions
    .repeat 6, i
        lda #154
        clc
        adc ship_y_offsets+i, y
        sta CPU_OAM+(4*(i+0))+0, x
    .endrepeat
    .repeat 6, i
        lda #154+16
        clc
        adc ship_y_offsets+i, y
        sta CPU_OAM+(4*(i+6))+0, x
    .endrepeat

    ; x-positions
    .repeat 6, i
        lda #104+8*i
        sta CPU_OAM+(4*(i+0))+3, x
        sta CPU_OAM+(4*(i+6))+3, x
    .endrepeat

    ; patterns
    .repeat 3, i
        lda #PATTERN(i)
        sta CPU_OAM+(4*(i+0))+1, x
        ora #32
        sta CPU_OAM+(4*(i+6))+1, x
        lda #PATTERN(2-i)
        sta CPU_OAM+(4*(i+3))+1, x
        ora #32
        sta CPU_OAM+(4*(i+9))+1, x
    .endrepeat

    ; attributes
    lda #%00000000
    sta CPU_OAM+(4*0)+2, x
    sta CPU_OAM+(4*1)+2, x
    sta CPU_OAM+(4*2)+2, x
    lda #%01000000
    sta CPU_OAM+(4*3)+2, x
    sta CPU_OAM+(4*4)+2, x
    sta CPU_OAM+(4*5)+2, x
    lda #%00000001
    sta CPU_OAM+(4*6)+2, x
    sta CPU_OAM+(4*7)+2, x
    sta CPU_OAM+(4*8)+2, x
    lda #%01000001
    sta CPU_OAM+(4*9)+2, x
    sta CPU_OAM+(4*10)+2, x
    sta CPU_OAM+(4*11)+2, x

    txa
    axs #.lobyte(-4*12)
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
    lda metasprite::menu_p2, y
    sta ptr_temp+0
    lda metasprite::menu_p2+1, y
    sta ptr_temp+1
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

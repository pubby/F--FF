.include "globals.inc"

.import decompress_tokumaru
.import prepare_game_sprites
.import setup_cos, setup_sin
.importzp multiply_store
.import copy_multiply_code
.import p1_move, p2_move
.import p1_solo_move
.import p1_render, p2_render
.import init_menu
.import read_gamepads
.import init_flag
.import ppu_copy_palette_buffer
.import icy_palette, spicy_palette, dicey_palette
.import sprite_1p_palette
.import sprite_2p_palette
.import init_game_sprites
.import init_timer_sprites
.import penguin_init_ntsc
.import penguin_process
.import penguin_set_song
.import init_game_sound
.import process_game_sound
.import init_results

.export main, nmi_handler, irq_handler, nmi_return
.export update_return
.export sprites_chr, rad_chr
.export init_game

.segment "RESERVED"
.repeat 41
    .byt 0
.endrepeat
.segment "BANK0_END"
.byt 0
.segment "BANK1_END"
.byt 1
.segment "BANK2_END"
.byt 2
.segment "BANK3_END"
.byt 3

.segment "LEVELS"
.scope l1
    .include "icy.inc"
.endscope
.scope l2
    .include "spicy.inc"
.endscope
.scope l3
    .include "dicey.inc"
.endscope

.segment "NMI_CODE"

.proc game_nmi
    lsr subframes_left
    bne :+ 
    lda frame_ready
    bne renderFrame
:

    ; Do OAM DMA
    lda #.hibyte(CPU_OAM)
    sta OAMDMA

    jsr ppu_copy_palette_buffer

    ldx #$00
    stx PPUMASK

    ldx #$20
.repeat 3, i
:
    lda $00
    dex
    bne :-
.endrepeat
    ldx #$83
:
    lda $00
    dex
    bne :-

    jmp return

renderFrame:
    ; Do OAM DMA (without reading controllers)
    lda #.hibyte(CPU_OAM) ; A = $03
    sta OAMDMA
    adc two_player      ; carry bit is irrelevant
    sta subframes_left

    bit PPUSTATUS
    lda #$20
    sta PPUADDR
    ldx #$00
    stx PPUADDR
    stx PPUMASK
    lda #$FF
    .repeat 2, i
    :
        .repeat 64, j
            ldy nt_buffer+(i*256)+j, x
            sty PPUDATA
        .endrepeat
        axs #.lobyte(-64)
        beq :+
        jmp :-
    :
    .endrepeat
    .repeat 32*22-512, i
        lda nt_buffer+i+512
        sta PPUDATA
    .endrepeat

    ldx #0

    inc nmi_counter
return:
    stx PPUSCROLL
    stx PPUSCROLL
    stx PPUADDR
    stx PPUADDR

    lda #PPUMASK_BG_ON | PPUMASK_NO_BG_CLIP| PPUMASK_SPR_ON | PPUMASK_NO_SPR_CLIP
    sta PPUMASK
    lda #PPUCTRL_NMI_ON | PPUCTRL_8X16_SPR
    sta PPUCTRL

    ;jsr penguin_process
    jsr process_game_sound
    jmp nmi_return
.endproc

.segment "CODE"

; 4+3+3+4+3+2+4+5 = 28 cycles
.proc nmi_handler
    pha
    stx nmi_x
    sty nmi_y
    lda $BFFF ; current bank
    sta nmi_bank
    bankswitch_to game_nmi
    jmp (nmi_ptr)
.endproc

.proc nmi_return
    ; Restore registers and return.
    ldy nmi_bank
    bankswitch_y
    ldx nmi_x
    ldy nmi_y
    pla
    rti
.endproc

.proc irq_handler
    rti
.endproc

update_return:
    lda nmi_counter
:
    cmp nmi_counter
    beq :-
    jmp (update_ptr)


.proc p_move_update
    lda two_player
    beq oneP
twoP:
    jsr p1_move
    lda #SPLITSCREEN_LEFT
    sta line_splitscreen
    jsr p1_render

    jsr p2_move
    lda #SPLITSCREEN_RIGHT
    sta line_splitscreen
    jmp p2_render
oneP:
    jsr p1_solo_move
    jmp p1_render
.endproc

.proc update_game
    lda #0
    sta frame_ready
    sta debug
    inc frame_number

    jsr prepare_game_sprites

    bankswitch_to clear_nt_buffer
    jsr clear_nt_buffer
    jsr read_gamepads

    jsr p_move_update

    lda needs_completion
    bne :+
    inc completion_timer
    lda completion_timer
    cmp #32
    bcc :+
    jmp init_results
:

    clc
    lda #2
    adc two_player
    adc time_sub
    sta time_sub
    sbc #60-1
    bne doneDigitUpdate
    sta time_sub
    lda #10
    isc time_digits+0
    bne doneDigitUpdate
    sta time_digits+0
    lda #6
    isc time_digits+1
    bne doneDigitUpdate
    sta time_digits+1
    lda #10
    isc time_digits+2
    bne doneDigitUpdate
    sta time_digits+2
    lda #6
    isc time_digits+3
    bne doneDigitUpdate
    sta time_digits+3
doneDigitUpdate:

    lda track_number
    cmp #2
    bne doneRainbowPalette
    lda frame_number
    lsr
    bcc doneRainbowPalette
    ldx #%11110000
    ldy #1
rainbowPaletteLoop:
    lda palette_buffer, y
    sax subroutine_temp
    anc #%00001111
    adc #1
    cmp #$D
    bne :+
    lda #$1
:
    ora subroutine_temp
    sta palette_buffer, y
    lda next_palette_index, y
    tay
    bne rainbowPaletteLoop
doneRainbowPalette:

    lda timer
    beq doneTimer
    dec timer
    bne doneTimer
    lda #0
    sta countdown
doneTimer:

    lda #1 
    sta debug
    sta frame_ready
    jmp update_return
.endproc

next_palette_index:
.byt 0,  2,  3,  5
.byt 0,  6,  7,  9
.byt 0, 10, 11, 13
.byt 0, 14, 15,  0

ltx_table_hi:
.byt .hibyte(l1::ltx_lo)
.byt .hibyte(l2::ltx_lo)
.byt .hibyte(l3::ltx_lo)

tf_table_lo:
.byt .lobyte(l1::tf)
.byt .lobyte(l2::tf)
.byt .lobyte(l3::tf)

tf_table_hi:
.byt .hibyte(l1::tf)
.byt .hibyte(l2::tf)
.byt .hibyte(l3::tf)

track_size_table:
.byt l1::track_size
.byt l2::track_size
.byt l3::track_size

main:
    jmp init_flag
    ;jmp init_menu

.proc init_game
    ; Zero-out bss
    lda #0
    tax
zeroBSSLoop:
    sta game_bss_start, x
    inx
    cpx #.lobyte(game_bss_end-game_bss_start)
    bne zeroBSSLoop

    ; Zero-out zeropage
    sta PPUMASK
    sta PPUCTRL
    ldx #game_zp_start
zeroZPLoop:
    sta $00, x
    inx
    bne zeroZPLoop
    inx                 ; X = 1
    stx frame_ready
    store16into #game_nmi, nmi_ptr
    store16into #game_fade_in, update_ptr

    ; Chr
    bankswitch_to ppu_load_4x4_pixels_chr
    jsr ppu_load_4x4_pixels_chr

    ; Setup black palette
    lda #$0F
    ldx #32-1
paletteLoop:
    sta palette_buffer, x
    dex
    bne paletteLoop

    ; Setup attributes.
    bit PPUSTATUS
    storePPUADDR #$23C0
    lda #%00000000
    ldx #8
:
    sta PPUDATA
    dex
    bne :-
    lda #%01010101
    ldx #8
:
    sta PPUDATA
    dex
    bne :-
    lda #%10101010
    ldx #16
:
    sta PPUDATA
    dex
    bne :-
    lda #%11111111
    ldx #32
:
    sta PPUDATA
    dex
    bne :-

    ; Setup multiplication
    jsr copy_multiply_code

    ; Level pointers
    ldx track_number
    lda track_size_table, x
    sta level_length
    ldy tf_table_lo, x
    sty tf_ptr+0
    ldy tf_table_hi, x
    sty tf_ptr+1
    ldy ltx_table_hi, x
    ldx #$80
    lda #$00
    .repeat 4, i
        sta lx_lo_ptr+(4*i)+0
        sty lx_lo_ptr+(4*i)+1
        stx lx_hi_ptr+(4*i)+0
        sty lx_hi_ptr+(4*i)+1
        iny
    .endrepeat

    ; Variables
    lda #64
    sta p1_boost_tank
    sta p2_boost_tank
    lda #$FF
    sta camera_height

    lda #128
    sta ship_entrance

    lda #8
    sta timer

    lda #7
    sta p1_lift
    sta p2_lift

    lda #1
    ldx two_player
    beq :+
    ora #2
:
    sta needs_completion

    ; Render the first frame without player input.
    lda #0
    sta p1_buttons_held
    sta p1_buttons_pressed
    sta p2_buttons_held
    sta p2_buttons_pressed
    jsr prepare_game_sprites
    bankswitch_to clear_nt_buffer
    jsr clear_nt_buffer
    jsr p_move_update

    ; Sprites
    jsr init_game_sprites

    ; Music
    jsr penguin_init_ntsc
    ldx #2
    jsr penguin_set_song

    jsr init_game_sound

    lda #PPUCTRL_NMI_ON | PPUCTRL_8X16_SPR
    bit PPUSTATUS
    sta PPUCTRL
    jmp update_return
.endproc

track_palette_lo:
.byt .lobyte(icy_palette)
.byt .lobyte(spicy_palette)
.byt .lobyte(dicey_palette)

track_palette_hi:
.byt .hibyte(icy_palette)
.byt .hibyte(spicy_palette)
.byt .hibyte(dicey_palette)

.proc game_fade_in
    bankswitch_to clear_nt_buffer
    jsr clear_nt_buffer
    jsr p_move_update

    lda timer
    asl
    asl
    asl
    and #%11110000
    sta subroutine_temp

    store16into #sprite_1p_palette, ptr_temp
    lda two_player
    beq :+
    store16into #sprite_2p_palette, ptr_temp
:

    ldy #15
spritePaletteLoop:
    lda (ptr_temp), y
    sec
    sbc subroutine_temp
    bcs :+
    lda #$0F
:
    sta palette_buffer+16, y
    dey
    bne spritePaletteLoop

    ldx track_number
    lda track_palette_lo, x
    sta ptr_temp+0
    lda track_palette_hi, x
    sta ptr_temp+1

    ldy #15
bgPaletteLoop:
    lda (ptr_temp), y
    sec
    sbc subroutine_temp
    bcs :+
    lda #$0F
:
    sta palette_buffer, y
    dey
    bne bgPaletteLoop

    dec timer
    beq game_init_ship_entrance
    jmp update_return
.endproc

.proc game_init_ship_entrance
    store16into #game_ship_entrance, update_ptr
    jmp update_return
.endproc

.proc game_ship_entrance
    jsr prepare_game_sprites
    jsr dec_camera_height

    lsr ship_entrance
    beq game_init_countdown
    jmp update_return
.endproc

.proc dec_camera_height
    lda camera_height
    sec
    sbc #24
    cmp #146
    bcs :+
    lda #146
:
    sta camera_height
    bankswitch_to clear_nt_buffer
    jsr clear_nt_buffer
    jmp p_move_update
.endproc


.macro lda2p i
    lda two_player
    beq *+5
    lda #i
    .byt $0C ; IGN to skip LDA
    lda #i*3/2
.endmacro

.proc game_init_countdown
    lda #4
    sta countdown
    lda2p 20
    sta timer
    store16into #game_countdown, update_ptr
    jmp update_return
.endproc

.proc game_countdown
    dec timer
    bne :+
    lda2p 20
    sta timer
    lda #1
    dcp countdown
    beq game_init_start
:
    jsr prepare_game_sprites
    jsr dec_camera_height
    jmp update_return
.endproc

.proc game_init_start
    jsr init_timer_sprites
    store16into #update_game, update_ptr
    jmp update_return
.endproc

.segment "SMALL_TABLES"
top_pixel_pattern_table:
.repeat 16, i
    .if i & %0100 && i & %1000
        .byt %11111111
    .elseif i & %0100
        .byt %00001111
    .elseif i & %1000
        .byt %11110000
    .else
        .byt %00000000
    .endif
.endrepeat
bottom_pixel_pattern_table:
.repeat 16, i
    .if i & %0001 && i & %0010
        .byt %11111111
    .elseif i & %0001
        .byt %00001111
    .elseif i & %0010
        .byt %11110000
    .else
        .byt %00000000
    .endif
.endrepeat

.segment "B2_CODE"
.proc clear_nt_buffer
    lda #0
    .repeat 32*22, i
        sta nt_buffer+i
    .endrepeat
    rts
.endproc

.segment "CHR"
sprites_chr:
    .incbin "sprpack.cchr"
rad_chr:
    .incbin "rad.cchr"

.proc ppu_load_4x4_pixels_chr
    ldx #0
    stx PPUADDR
    stx PPUADDR
loop:
    txa
    and #%00001111
    tay
    jsr writeHalfTile
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    jsr writeHalfTile
    inx
    bne loop
    rts
writeHalfTile:
    lda top_pixel_pattern_table, y
    jsr store
    lda bottom_pixel_pattern_table, y
store:
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    sta PPUDATA
    rts
.endproc


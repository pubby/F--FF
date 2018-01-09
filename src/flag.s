.include "globals.inc"

.import delay_A_plus_25_cycles
.import read_gamepads
.import ppu_copy_palette_buffer
.import init_menu
.import penguin_process
.import penguin_set_song

.export init_flag
.export ppu_setup_text_chr

chr_buffer = multiply
shifted_sin_scroll_table = nt_buffer

y_scroll = l1100+0
sin_scroll = l1100+1
nmi_sync_count = l1100+2
pal_ptr = l1100+3 ; 2 bytes
fade_state = l1100+5

.segment "FLAG_DATA"
flag_curve:
    .include "flag_chr.inc"
flag_chr:
    .incbin "flag_chr.bin"
    .include "flag_nt.inc"

.segment "SIN_SCROLL"
.include "sin_scroll.inc"
.assert .lobyte(sin_scroll_table) = 0, error, "misaligned sin scroll table"

.segment "FLAG_NMI_CODE"
.proc flag_nmi
    ; 28 cycles (caller)

    ; 9 cycles
    ldx #$FF
    tsx
    inc frame_number

    ; 10 cycles:
    jsr begin_nmi_sync

    ; 2 cycles:
    lda #$02
    sta OAMDMA  ; Must happen on even cycle.

    ; 12+2+256-1 = 269 cycles
    storePPUADDR #$3F00
    ldy #0
:
    lda (pal_ptr), y
    sta PPUDATA
    iny
    cpy #16
    bne_aligned :-

    ; 1337 cycles:
    bit PPUSTATUS
    anc #0
    tax
    tay
copyChrBufferLoop:
    stx PPUADDR
    sta PPUADDR
    .repeat 8, i
        lda chr_buffer+i, y
        sta PPUDATA
    .endrepeat
    tya
    adc #8
    tay
    asl
    bcc copyChrBufferLoop
doneCopyChrBuffer:
    .assert .hibyte(copyChrBufferLoop) = .hibyte(doneCopyChrBuffer), error, "misaligned bcc"

    ; 6 cycles:
    lda #PPUMASK_BG_ON | PPUMASK_NO_BG_CLIP
    sta PPUMASK

    ; 18 cycles:
    ldx #0
    stx PPUSCROLL
    stx PPUSCROLL
    inc sin_scroll
    ldy sin_scroll

    lda #1715 - 1679 - 27
    jsr delay_A_plus_25_cycles

    jsr end_nmi_sync

    ; We're now synchronized exactly to 2286 cycles
    ; after beginning of frame.

    ldx #0
    stx y_scroll

    bit PPUSTATUS

    lda #106-27-62
    jsr delay_A_plus_25_cycles

    jsr set_scroll

rorLoop:
    ; 42 cycles:
    lsr chr_buffer+8*0, x
    ror chr_buffer+8*1, x
    ror chr_buffer+8*2, x
    ror chr_buffer+8*3, x
    ror chr_buffer+8*4, x
    ror chr_buffer+8*5, x
    ror chr_buffer+8*6, x

    ; 72 cycles:
    lda subroutine_temp
    php
    jsr set_scroll
    plp

    ; 42 cycles:
    ror chr_buffer+8*7, x
    ror chr_buffer+8* 8, x
    ror chr_buffer+8* 9, x
    ror chr_buffer+8*10, x
    ror chr_buffer+8*11, x
    ror chr_buffer+8*12, x
    ror chr_buffer+8*13, x

    ; 72 cycles:
    lda subroutine_temp
    php
    jsr set_scroll
    plp

    ; 22 cycles:
    ror chr_buffer+8*14, x
    ror chr_buffer+8*15, x
    arr #0
    ora chr_buffer+8*0, x
    sta chr_buffer+8*0, x

    ; 21 cycles:
    lsr subroutine_temp
    lsr subroutine_temp
    lsr subroutine_temp
    nop
    nop
    nop
    inx

    ; 62 cycles:
    jsr set_scroll

    ; 5 cycles:
    cpx #8
    bcc rorLoop
:
    .assert .hibyte(rorLoop) = .hibyte(:-), error, "fuck"

    ; 43 cycles:
    lda #39-27
    .byt $0C
scrollLoop:
    ; 44 cycles:
    lda #44-27
    jsr delay_A_plus_25_cycles
startScrollLoop:
    ; 62 cycles:
    jsr set_scroll

    nop
    nop
    nop
    nop

    ; 44 cycles:
    lda #44-27
    jsr delay_A_plus_25_cycles

    ; 62 cycles:
    jsr set_scroll

    nop
    nop
    nop
    nop

    ; 43 cycles:
    lda #43-27
    jsr delay_A_plus_25_cycles

    ; 62 cycles:
    jsr set_scroll

    ; 8 cycles:
    lda y_scroll
    ;cmp #213
    cmp #231
    bcc scrollLoop
:
    .assert .hibyte(scrollLoop) = .hibyte(:-), error, "fuck"

    ldx #$FF
    txs
    jsr penguin_process

    ldx fade_state
    lda pal_table_lo, x
    sta pal_ptr+0
    lda pal_table_hi, x
    sta pal_ptr+1
    cpx #4
    beq checkButton
    lda frame_number
    and #%11
    beq decFade
    jmp infiniteLoop
checkButton:
    ; Read P1's controller for Start/A quickly.
    lda #1
    sta $4016
    lsr
    sta $4016
    lda $4016
    bit $4016
    bit $4016
    ora $4016
    lsr
    bcc infiniteLoop
decFade:
    dec fade_state
    bpl infiniteLoop
    ldx #$FF
    txs
    jmp init_menu
infiniteLoop:
    jmp infiniteLoop
.endproc

.segment "SMALL_TABLES"
flag_pal0:
    .byt $0F,$20,$0F,$20
    .byt $0F,$0F,$20,$0F
    .byt $0F,$2A,$0F,$2A
    .byt $0F,$0F,$01,$0F
flag_pal1:
    .byt $0F,$10,$0F,$10
    .byt $0F,$0F,$10,$0F
    .byt $0F,$19,$0F,$19
    .byt $0F,$0F,$0F,$0F
flag_pal2:
    .byt $0F,$01,$0F,$01
    .byt $0F,$0F,$01,$0F
    .byt $0F,$08,$0F,$08
    .byt $0F,$0F,$0F,$0F
flag_pal3:
    .byt $0F,$0F,$0F,$0F
    .byt $0F,$0F,$0F,$0F
    .byt $0F,$0F,$0F,$0F
    .byt $0F,$0F,$0F,$0F
pal_table_lo:
    .byt .lobyte(flag_pal3)
    .byt .lobyte(flag_pal2)
    .byt .lobyte(flag_pal1)
    .byt .lobyte(flag_pal0)
    .byt .lobyte(flag_pal0)
    .byt .lobyte(flag_pal1)
    .byt .lobyte(flag_pal2)
    .byt .lobyte(flag_pal3)
pal_table_hi:
    .byt .hibyte(flag_pal3)
    .byt .hibyte(flag_pal2)
    .byt .hibyte(flag_pal1)
    .byt .hibyte(flag_pal0)
    .byt .hibyte(flag_pal0)
    .byt .hibyte(flag_pal1)
    .byt .hibyte(flag_pal2)
    .byt .hibyte(flag_pal3)

.segment "CODE"

.proc ppu_setup_text_chr
    bankswitch_to flag_chr
    bit PPUSTATUS
    ldx #0
    stx PPUADDR
    stx PPUADDR
    tya
:
    sta PPUDATA
    inx
    bne :-
.repeat 4, i
:
    lda flag_chr+(i*256), x
    sta PPUDATA
    inx
    bne :-
.endrepeat
    rts
.endproc

.proc init_flag
    lda #0
    sta $4015
    sta PPUMASK
    sta PPUCTRL

    ldx #1
    jsr penguin_set_song

    storePPUADDR #$3F00
    lda #$0F
    sta PPUDATA

    store16into #flag_nmi, nmi_ptr
    store16into #flag_pal3, pal_ptr

    bankswitch_to flag_curve
    ldx #0
:
    lda flag_curve, x
    sta chr_buffer, x
    inx
    cpx #16*8
    bne :-

    ldy #$FF
    jsr ppu_setup_text_chr

    bankswitch_to flag_nt_data
    bit PPUSTATUS
    lda #$20
    sta PPUADDR
    ldy #$00
    sty PPUADDR
    store16into #flag_nt_data, ptr_temp
readBytesLoop:
    lda (ptr_temp), y
    cmp #$FF
    beq exitLoop
    ldx #%00011111
    axs #0
    .repeat 5
        lsr
    .endrepeat
    bne shortLength
longLength:
    inc ptr_temp+0
    bne :+
    inc ptr_temp+1
:
    lda (ptr_temp), y
shortLength:
    sta subroutine_temp
    lda flag_nt_map, x
    ldx subroutine_temp
runLengthLoop:
    sta PPUDATA
    dex
    bne runLengthLoop
    inc ptr_temp+0
    bne :+
    inc ptr_temp+1
:
    jmp readBytesLoop
exitLoop:

    store8into #7, fade_state
    ldx #0
    stx sin_scroll
    stx y_scroll
    stx nmi_sync_count
:
    lda sin_scroll_table, x
    lsr
    lsr
    lsr
    sta shifted_sin_scroll_table, x
    inx
    bne :-

    jsr init_nmi_sync
loop:
    jsr wait_nmi
    jmp loop

.endproc

; 56 cycles
.proc set_scroll
    nop
    stx subroutine_temp
    lda #0
    sta PPUADDR
    lda y_scroll
    sta PPUSCROLL
    and #$F8
    asl
    asl
    ora shifted_sin_scroll_table, y
    ldx sin_scroll_table, y
    stx PPUSCROLL
    sta PPUADDR
    dey
    inc y_scroll
    ldx subroutine_temp
    rts
.endproc


.segment "NMI_SYNC"

; Initializes synchronization and enables NMI
; Preserved: X, Y
; Time: 15 frames average, 28 frames max
init_nmi_sync:
	; Disable interrupts and rendering
	sei
	lda #0
	sta $2000
	sta $2001
	
	; Coarse synchronize
	bit $2002
init_nmi_sync_1:
	bit $2002
	bpl init_nmi_sync_1
	
	; Synchronize to odd CPU cycle
	sta $4014

	; Fine synchronize
	lda #3
init_nmi_sync_2:
	sta nmi_sync_count
	bit $2002
	bit $2002
	php
	eor #$02
	nop
	nop
	plp
	bpl init_nmi_sync_2

	; Delay one frame
init_nmi_sync_3:
	bit $2002
	bpl init_nmi_sync_3
	
	; Enable rendering long enough for frame to
	; be shortened if it's a short one, but not long
	; enough that background will get displayed.
	lda #$08
	sta $2001
	
	; Can reduce delay by up to 5 and this still works,
	; so there's a good margin.
	; delay 2377
	lda #216
init_nmi_sync_4:
	nop
	nop
	sec
	sbc #1
	bne init_nmi_sync_4
	
	sta $2001
	
	lda nmi_sync_count
	
	; Wait for this and next frame to finish.
	; If this frame was short, loop ends. If it was
	; long, loop runs for a third frame.
init_nmi_sync_5:
	bit $2002
	bit $2002
	php
	eor #$02
	sta nmi_sync_count
	nop
	nop
	plp
	bpl init_nmi_sync_5
	
	; Enable NMI
	lda #$80
	sta $2000
	
	rts

; Initializes synchronization and enables NMI on PAL NES
; Preserved: X, Y
; Time: about 20 frames
init_nmi_sync_pal:
	; NMI will first occur within frame 2 after
	; synchronization
	lda #2
	sta nmi_sync_count
	
	; Disable interrupts and rendering
	sei
	lda #0
	sta $2000
	sta $2001
	
	; Coarse synchronize
	bit $2002
init_nmi_sync_pal_1:
	bit $2002
	bpl init_nmi_sync_pal_1
	
	; Synchronize to odd CPU cycle
	sta $4014
	bit <0
	
	; Fine synchronize
init_nmi_sync_pal_2:
	bit <0
	nop
	bit $2002
	bit $2002
	bpl init_nmi_sync_pal_2
	
	; Enable NMI
	lda #$80
	sta $2000
	
	rts


; Waits until NMI occurs.
; Preserved: A, X, Y
wait_nmi:
	pha
	
	; Reset high/low flag so NMI can depend on it
	bit PPUSTATUS
	; NMI must not occur during taken branch, so we
	; only use branch to get out of loop.
	lda nmi_sync_count
wait_nmi_1:
	cmp nmi_sync_count
	bne wait_nmi_2
	jmp wait_nmi_1
wait_nmi_2:
	pla
	rts


; Must be called in NMI handler, before sprite DMA.
; Preserved: X, Y
begin_nmi_sync:
	lda nmi_sync_count
	and #$02
	beq begin_nmi_sync_1
begin_nmi_sync_1:
	rts


; Must be called after sprite DMA. Instructions before this
; must total 1715 (NTSC)/6900 (PAL) cycles, treating
; JSR begin_nmi_sync and STA $4014 as taking 10 cycles total) 
; Next instruction will begin 2286 (NTSC)/7471 (PAL) cycles
; after the cycle that the frame began in.
; Preserved: X, Y
end_nmi_sync:
	lda nmi_sync_count
	inc nmi_sync_count
	and #$02
	bne end_nmi_sync_1
end_nmi_sync_1:
	lda $2002
	bmi end_nmi_sync_2
end_nmi_sync_2:
	bmi end_nmi_sync_3
end_nmi_sync_3:
	rts


; Keeps track of synchronization on frames where no
; synchronization is needed (where begin_nmi_sync/end_nmi_sync
; aren't called).
; Preserved: A, X, Y
track_nmi_sync:
	inc nmi_sync_count
	rts


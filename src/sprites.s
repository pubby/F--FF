.include "globals.inc"

.export prepare_blank_sprites
.export prepare_game_sprites

.segment "CODE"

SPR_NT = 1
.define PATTERN(i) ((i) * 2 + SPR_NT)

; This writes sprite data to CPU_OAM. Does not write to PPU.
; Clobbers A, X, Y.
.proc prepare_game_sprites
    ; Use X as an index into CPU_OAM. The 'prepare_sprite' functions will
    ; use and increment X as they write to 'CPU_OAM'.
    ldx #0              ; Start off at 4, skipping sprite0.

    ; Write to CPU_OAM.
    jsr prepare_player_sprites

    ; Clear the remaining portion of CPU_OAM so that unused/glitchy
    ; sprites aren't drawn.
    jsr clear_remaining_cpu_oam ; X is 0 after clear_remaining_cpu_oam.
    rts
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

.proc prepare_player_sprites
    ; y-positions
    lda #154
    .repeat 6, i
        sta CPU_OAM+(4*(i+0))+0, x
    .endrepeat
    lda #154+16
    .repeat 6, i
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



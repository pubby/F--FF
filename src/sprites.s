.include "globals.inc"

.export prepare_blank_sprites
.export prepare_game_sprites

.segment "CODE"

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
    lda py
    clc
    adc #35
    sta CPU_OAM+0, x ; Set sprite's y-position.
    lda #$08
    sta CPU_OAM+1, x ; Set sprite's pattern.
    lda #0
    sta CPU_OAM+2, x ; Set sprite's attributes.
    lda px
    sta CPU_OAM+3, x ; Set sprite's x-position.
    ; Increment X by 4.
    txa
    axs #.lobyte(-4)

    lda fy
    clc
    adc #35
    sta CPU_OAM+0, x ; Set sprite's y-position.
    lda #$08
    sta CPU_OAM+1, x ; Set sprite's pattern.
    lda #0
    sta CPU_OAM+2, x ; Set sprite's attributes.
    lda fx
    sta CPU_OAM+3, x ; Set sprite's x-position.
    ; Increment X by 4.
    txa
    axs #.lobyte(-4)

    rts
.endproc



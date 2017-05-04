.include "globals.inc"

.export ppu_set_palette

.segment "RODATA"
palette:
    .byt $05,$11,$21,$31, $05,$21,$24,$28, $05,$21,$24,$28, $05,$21,$24,$28
    .byt $05,$2C,$2C,$2C, $05,$21,$24,$28, $05,$21,$24,$28, $05,$21,$24,$28

.segment "CODE"
; Clobbers A, X. Preserves Y.
.proc ppu_set_palette
    ppu_palette_address = $3F00
    lda #.hibyte(ppu_palette_address)
    sta PPUADDR
    lda #.lobyte(ppu_palette_address)
    sta PPUADDR
    ldx #0
copyPaletteLoop:
    lda palette, x
    sta PPUDATA
    inx
    cpx #32
    bne copyPaletteLoop
    rts
.endproc


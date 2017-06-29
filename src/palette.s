.include "globals.inc"

.export ppu_set_palette

.segment "RODATA"
palette:
    .byt $0F,$13,$03,$13, $0F,$22,$12,$22, $0F,$31,$21,$31, $0F,$20,$31,$20
    .byt $0F,$2C,$2C,$2C, $0F,$21,$24,$28, $0F,$21,$24,$28, $0F,$21,$24,$28

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


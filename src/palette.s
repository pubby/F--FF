.include "globals.inc"

.export ppu_set_palette
.export ppu_copy_palette_buffer
.export palette

.segment "RODATA"
palette:
    ; BLUE PALETTE:
    ;.byt $0F,$13,$03,$13, $0F,$22,$12,$22, $0F,$31,$21,$31, $0F,$20,$31,$20
    ;.byt $0F,$11,$2C,$3A, $0F,$11,$2C,$26, $0F,$21,$24,$28, $0F,$21,$24,$28

    ; RED PALETTE:
    ;.byt $0F,$14,$04,$14, $0F,$25,$15,$25, $0F,$36,$26,$36, $0F,$27,$37,$27
    ;.byt $0F,$11,$2C,$3A, $0F,$11,$2C,$26, $0F,$21,$24,$28, $0F,$21,$24,$28
    ;.byt $0F,$15,$27,$39, $0F,$15,$27,$2B, $0F,$21,$24,$28, $0F,$21,$24,$28

    ; GREEN PALETTE:
    ;.byt $0F,$29,$09,$29, $0F,$3A,$1A,$3A, $0F,$3B,$2B,$3B, $0F,$30,$3C,$30
    ;.byt $0F,$11,$2C,$3A, $0F,$11,$2C,$26, $0F,$21,$24,$28, $0F,$21,$24,$28

    ; MENU PALETTE:
    .byt $25,$2A,$02,$0F
    .byt $25,$2A,$02,$0F
    .byt $25,$06,$02,$0F
    .byt $25,$06,$02,$0F

    ;.byt $20,$2A,$15,$0F
    ;.byt $20,$2A,$15,$0F
    ;.byt $20,$0F,$15,$0F
    ;.byt $20,$0F,$15,$0F

    .byt $20,$06,$24,$20
    .byt $25,$20,$0F,$20
    .byt $25,$11,$0F,$20
    .byt $25,$20,$11,$24

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

.segment "NMI_CODE"

.proc ppu_copy_palette_buffer
    storePPUADDR #$3F00
    lda palette_buffer
    .repeat 32, i
        .if ((i .mod 4) <> 0) | (i = 16)
            lda palette_buffer+i
        .endif
        sta PPUDATA
    .endrepeat
    rts
.endproc

.include "globals.inc"

.export ppu_copy_palette_buffer
.export sprite_palette
.export icy_palette, spicy_palette, dicey_palette
.export menu_palette

.segment "RODATA"
sprite_palette:
    .byt $0F,$11,$2A,$3A
    .byt $0F,$11,$26,$3A
    .byt $0F,$01,$11,$21
    .byt $0F,$0F,$14,$28

icy_palette:
    .byt $0F,$13,$03,$13
    .byt $0F,$22,$12,$22
    .byt $0F,$31,$21,$31
    .byt $0F,$20,$31,$20

spicy_palette:
    .byt $0F,$14,$04,$14
    .byt $0F,$25,$15,$25
    .byt $0F,$36,$26,$36
    .byt $0F,$27,$37,$27

dicey_palette:
    .byt $0F,$17,$07,$17
    .byt $0F,$28,$18,$28
    .byt $0F,$39,$29,$39
    .byt $0F,$2A,$3A,$2A

    ; MENU PALETTE:
menu_palette:
    .byt $25,$2A,$02,$0F
    .byt $25,$2A,$02,$0F
    .byt $25,$06,$02,$0F
    .byt $25,$06,$02,$0F

    .byt $20,$06,$24,$20
    .byt $25,$20,$0F,$20
    .byt $25,$11,$0F,$20
    .byt $25,$20,$11,$24

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

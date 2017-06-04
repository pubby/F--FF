.include "globals.inc"

.segment "CODE"

.proc divide
    lda #2

    txa

    lda #0
    slo P+0
    rol P+1
    sec
    sbc D+0
    tax 
    lda P+1
    sbc D+1
    bcc :+
    stx P+0
    sta P+1
:
    ror result+1
    ror result+0

    2+5+5+2+3+2+3+3+2+3+3+5

    asl P+0
    rol

    sbc D+0
    tax 
    lda P+1
    sbc D+1
    bcc :+
    stx P+0
:
    ror result+1
    ror result+0

.endproc

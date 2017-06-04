#include <cstdio>
#include <cstdlib>

unsigned char reverse(unsigned char b)
{
   b = (b & 0xF0) >> 4 | (b & 0x0F) << 4;
   b = (b & 0xCC) >> 2 | (b & 0x33) << 2;
   b = (b & 0xAA) >> 1 | (b & 0x55) << 1;
   return b;
}

unsigned flip(int p, unsigned char b)
{
    if(p)
    {
        unsigned char ret = 0;
        ret |= (b & 0b1010) >> 1;
        ret |= (b << 1) & 0b1010;
        return ret;
    }
    return b;
}

char const* sbc(int p)
{
    if(p)
        return "sbc";
    return "adc";
}

char const* adc(int p)
{
    if(p)
        return "adc";
    return "sbc";
}

char const* bcs(int p)
{
    if(p)
        return "bcs";
    return "bcc";
}

char const* bcc(int p)
{
    if(p)
        return "bcc";
    return "bcs";
}

int main(int argc, char** argv)
{
    if(argc != 2)
    {
        std::fprintf(stderr, "usage: %s [outfile]\n", argv[0]);
        return EXIT_FAILURE;
    }
    
    FILE* fp = std::fopen(argv[1], "wb");
    if(!fp)
    {
        std::fprintf(stderr, "can't open file %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    std::fprintf(fp, ".include \"globals.inc\"\n");

    std::fprintf(fp, ".macro or_buffer i\n");
    std::fprintf(fp, "        ora nt_buffer+i*32, x\n");
    std::fprintf(fp, "        sta nt_buffer+i*32, x\n");
    //std::fprintf(fp, "    .if i < 6\n");
    //std::fprintf(fp, "        ora zp_nt_buffer+i*32, x\n");
    ////std::fprintf(fp, "        sta zp_nt_buffer+i*32, x\n");
    //std::fprintf(fp, "    .else\n");
    //std::fprintf(fp, "        ora nt_buffer+(i-6)*32, x\n");
    //std::fprintf(fp, "        sta nt_buffer+(i-6)*32, x\n");
    //std::fprintf(fp, "    .endif\n");
    std::fprintf(fp, ".endmacro\n");

    for(int p = 0; p != 2; ++p)
    {
        char const* pp = p ? "NP" : "PP";
        std::fprintf(fp, ".segment \"LINE_UNROLLED\"\n");
        std::fprintf(fp, "    nop\n");
        if(p == 0)
            for(int i = 0; i != 0; ++i) std::fprintf(fp, "    nop\n");
        else
            for(int i = 0; i != 1; ++i) std::fprintf(fp, "    nop\n");
        for(unsigned i = 0; i != 22; ++i)
        {
            bool const last_i = i == 21;
            std::fprintf(fp, "%sxy%i:\n", pp, i);
            std::fprintf(fp, "%sxy%i_store___xNE:\n", pp, i);
            std::fprintf(fp, "    lda #%u\n", flip(p, 0b0100));
            std::fprintf(fp, "    or_buffer %i\n", i);
            std::fprintf(fp, "    cpx to_x\n");
            std::fprintf(fp, "    beq %sxy%i_return\n", pp, i);
            std::fprintf(fp, "    tya\n");
            std::fprintf(fp, "    %s\n", p ? "dex" : "inx");
            std::fprintf(fp, "    %s Dy\n", sbc(p));
            std::fprintf(fp, "    %s %sxy%i_adc_SWx__\n", bcc(p), pp, i);
            // fall-through

            std::fprintf(fp, "%sxy%i_NWx__:\n", pp, i);
            std::fprintf(fp, "    %s Dy\n", sbc(p));
            std::fprintf(fp, "    %s %sxy%i_NWxNE\n", bcs(p), pp, i);
            std::fprintf(fp, "    %s rounded_Dx\n", adc(p));
            // fall-through

            std::fprintf(fp, "%sxy%i_NWxSE:\n", pp, i);
            std::fprintf(fp, "    tay\n");
            std::fprintf(fp, "    lda #%u\n", flip(p, 0b1001));
            std::fprintf(fp, "    or_buffer %i\n", i);
            std::fprintf(fp, "    cpx to_x\n");
            std::fprintf(fp, "    beq %sxy%i_return\n", pp, i);
            std::fprintf(fp, "    tya\n");
            std::fprintf(fp, "    %s\n", p ? "dex" : "inx");
            std::fprintf(fp, "    %s Dy\n", sbc(p));
            std::fprintf(fp, "    %s %sxy%i_SWx__\n", bcs(p), pp, i);
            if(last_i)
                std::fprintf(fp, "    rts\n    nop\n    nop\n    nop\n    nop\n");
            else
            {
                std::fprintf(fp, "    %s rounded_Dx\n", adc(p));
                std::fprintf(fp, "    jmp %sxy%i_NWx__\n", pp, i+1);
            }

            std::fprintf(fp, "%sxy%i_NWxNE:\n", pp, i);
            std::fprintf(fp, "    tay\n");
            std::fprintf(fp, "    lda #%u\n", flip(p, 0b1100));
            std::fprintf(fp, "    or_buffer %i\n", i);
            std::fprintf(fp, "    cpx to_x\n");
            std::fprintf(fp, "    beq %sxy%i_return\n", pp, i);
            std::fprintf(fp, "    tya\n");
            std::fprintf(fp, "    %s\n", p ? "dex" : "inx");
            std::fprintf(fp, "    %s Dy\n", sbc(p));
            std::fprintf(fp, "    %s %sxy%i_NWx__\n", bcs(p), pp, i);
            std::fprintf(fp, "%sxy%i_adc_SWx__:\n", pp, i);
            std::fprintf(fp, "    %s rounded_Dx\n", adc(p));
            // fall-through

            std::fprintf(fp, "%sxy%i_SWx__:\n", pp, i);
            std::fprintf(fp, "    %s Dy\n", sbc(p));
            std::fprintf(fp, "    %s %sxy%i_fill_SWx__\n", bcc(p), pp, i);
            //fall-through

            std::fprintf(fp, "%sxy%i_SWxSE:\n", pp, i);
            std::fprintf(fp, "    tay\n");
            std::fprintf(fp, "    lda #%u\n", flip(p, 0b0011));
            std::fprintf(fp, "%sxy%i_store___xSE:\n", pp, i);
            std::fprintf(fp, "    or_buffer %i\n", i);
            std::fprintf(fp, "    cpx to_x\n");
            std::fprintf(fp, "    beq %sxy%i_return\n", pp, i);
            std::fprintf(fp, "    tya\n");
            std::fprintf(fp, "    %s\n", p ? "dex" : "inx");
            std::fprintf(fp, "    %s Dy\n", sbc(p));
            std::fprintf(fp, "    %s %sxy%i_SWx__\n", bcs(p), pp, i);
            if(last_i)
                std::fprintf(fp, "    rts\n    nop\n    nop\n    nop\n    nop\n");
            else
            {
                std::fprintf(fp, "    %s rounded_Dx\n", adc(p));
                std::fprintf(fp, "    jmp %sxy%i_NWx__\n", pp, i+1);
            }

            std::fprintf(fp, "%sxy%i_return:\n", pp, i);
            std::fprintf(fp, "    rts\n");

            std::fprintf(fp, "%sxy%i___xSE:\n", pp, i);
            std::fprintf(fp, "    tay\n");
            std::fprintf(fp, "    lda #%u\n", flip(p, 0b0001));
            std::fprintf(fp, "    jmp %sxy%i_store___xSE\n", pp, i);

            std::fprintf(fp, "%sxy%i___xNE:\n", pp, i);
            std::fprintf(fp, "    tay\n");
            std::fprintf(fp, "    jmp %sxy%i_store___xNE\n", pp, i);

            std::fprintf(fp, "%sxy%i_fill_SWx__:\n", pp, i);
            std::fprintf(fp, "    %s rounded_Dx\n", adc(p));
            std::fprintf(fp, "    tay\n");
            std::fprintf(fp, "    lda #%u\n", flip(p, 0b0010));
            std::fprintf(fp, "    or_buffer %i\n", i);
            if(last_i)
                std::fprintf(fp, "    rts\n");
            // fall-through to next i
        }

        std::fprintf(fp, "    nop\n");
        std::fprintf(fp, "    nop\n");
        if(p == 1)
            std::fprintf(fp, "    nop\n");

        for(unsigned i = 0; i != 22; ++i)
        {
            bool const last_i = i == 21;

            std::fprintf(fp, "%syx%i:\n", pp, i);
            std::fprintf(fp, "%syx%i_adc_NWx__:\n", pp, i);
            std::fprintf(fp, "    adc rounded_Dy\n");
            std::fprintf(fp, "    %s\n", p ? "dex" : "inx");
            std::fprintf(fp, "%syx%i_NWx__:\n", pp, i);
            std::fprintf(fp, "    sbc Dx\n");
            std::fprintf(fp, "    bcs %syx%i_NWxSW\n", pp, i);
            std::fprintf(fp, "    adc rounded_Dy\n");
            // fall-through

            std::fprintf(fp, "%syx%i_NWxSE:\n", pp, i);
            std::fprintf(fp, "    sta subroutine_temp\n");
            std::fprintf(fp, "    lda #%u\n", flip(p, 0b1001));
            std::fprintf(fp, "    or_buffer %i\n", i);
            if(last_i)
                for(int i = 0; i != 12; ++i)
                    std::fprintf(fp, "    rts\n");
            else
            {
                std::fprintf(fp, "    dey\n");
                std::fprintf(fp, "    beq %syx%i_return\n", pp, i);
                std::fprintf(fp, "    lda subroutine_temp\n");
                std::fprintf(fp, "    sbc Dx\n");
                std::fprintf(fp, "    bcc %syx%i_adc_NWx__\n", pp, i+1);
                std::fprintf(fp, "    jmp %syx%i_NEx__\n", pp, i+1);
            }

            std::fprintf(fp, "%syx%i_NWxSW:\n", pp, i);
            std::fprintf(fp, "    sta subroutine_temp\n");
            std::fprintf(fp, "    lda #%u\n", flip(p, 0b1010));
            std::fprintf(fp, "    or_buffer %i\n", i);
            if(last_i)
                for(int i = 0; i != 14; ++i)
                    std::fprintf(fp, "    rts\n");
            else
            {
                std::fprintf(fp, "    dey\n");
                std::fprintf(fp, "    beq %syx%i_return\n", pp, i);
                std::fprintf(fp, "    lda subroutine_temp\n");
                std::fprintf(fp, "    sbc Dx\n");
                std::fprintf(fp, "    bcs %syx%i_NWx__\n", pp, i+1);
                std::fprintf(fp, "    adc rounded_Dy\n");
                std::fprintf(fp, "    jmp %syx%i_NEx__\n", pp, i+1);
            }

            std::fprintf(fp, "%syx%i_adc_NEx__:\n", pp, i);
            std::fprintf(fp, "    adc rounded_Dy\n");
            std::fprintf(fp, "%syx%i_NEx__:\n", pp, i);
            std::fprintf(fp, "    sbc Dx\n");
            std::fprintf(fp, "    bcc %syx%i_fill_NEx__\n", pp, i);
            //fall-through

            std::fprintf(fp, "%syx%i_NExSE:\n", pp, i);
            std::fprintf(fp, "    sta subroutine_temp\n");
            std::fprintf(fp, "    lda #%u\n", flip(p, 0b0101));
            std::fprintf(fp, "%syx%i_store___xSE:\n", pp, i);
            std::fprintf(fp, "    or_buffer %i\n", i);
            if(last_i)
                for(int i = 0; i != 15; ++i)
                    std::fprintf(fp, "    rts\n");
            else
            {
                std::fprintf(fp, "    dey\n");
                std::fprintf(fp, "    beq %syx%i_return\n", pp, i);
                std::fprintf(fp, "    lda subroutine_temp\n");
                std::fprintf(fp, "    sbc Dx\n");
                std::fprintf(fp, "    bcs %syx%i_NEx__\n", pp, i+1);
                std::fprintf(fp, "    adc rounded_Dy\n");
                std::fprintf(fp, "    %s\n", p ? "dex" : "inx");
                std::fprintf(fp, "    jmp %syx%i_NWx__\n", pp, i+1);
            }

            std::fprintf(fp, "%syx%i_return:\n", pp, i);
            std::fprintf(fp, "    rts\n");

            std::fprintf(fp, "%syx%i___xSE:\n", pp, i);
            std::fprintf(fp, "    sta subroutine_temp\n");
            std::fprintf(fp, "    lda #%u\n", flip(p, 0b0001));
            std::fprintf(fp, "    jmp %syx%i_store___xSE\n", pp, i);

            std::fprintf(fp, "%syx%i_fill_NEx__:\n", pp, i);
            std::fprintf(fp, "    adc rounded_Dy\n");
            std::fprintf(fp, "    sta subroutine_temp\n");
            std::fprintf(fp, "    lda #%u\n", flip(p, 0b0100));
            std::fprintf(fp, "    or_buffer %i\n", i);
            std::fprintf(fp, "    %s\n", p ? "dex" : "inx");

            std::fprintf(fp, "%syx%i___xSW:\n", pp, i);
            std::fprintf(fp, "    lda #%u\n", flip(p, 0b0010));
            std::fprintf(fp, "    or_buffer %i\n", i);
            if(last_i)
                    std::fprintf(fp, "    rts\n");
            else
            {
                std::fprintf(fp, "    dey\n");
                std::fprintf(fp, "    beq %syx%i_return\n", pp, i);
                std::fprintf(fp, "    lda subroutine_temp\n");
                std::fprintf(fp, "    sbc Dx\n");
                std::fprintf(fp, "    bcs %syx%i_NWx__\n", pp, i+1);
                std::fprintf(fp, "    adc rounded_Dy\n");
                std::fprintf(fp, "    jmp %syx%i_NEx__\n", pp, i+1);
            }
        }

        std::fprintf(fp, ".segment \"RODATA\"\n");
        std::fprintf(fp, "%sxy_lo:\n", pp);
        for(unsigned i = 0; i != 22; ++i)
            std::fprintf(fp, ".byt .lobyte(%sxy%i)\n", pp, i);
        std::fprintf(fp, "%sxy_hi:\n", pp);
        for(unsigned i = 0; i != 22; ++i)
            std::fprintf(fp, ".byt .hibyte(%sxy%i)\n", pp, i);

        if(p == 0)
        {
            std::fprintf(fp, "%sxy_offset:\n", pp);
            std::fprintf(fp, ".byt %sxy0_NWx__ - %sxy0\n", pp, pp);
            std::fprintf(fp, ".byt %sxy0_SWx__ - %sxy0\n", pp, pp);
            std::fprintf(fp, ".byt %sxy0___xNE - %sxy0\n", pp, pp);
            std::fprintf(fp, ".byt %sxy0___xSE - %sxy0\n", pp, pp);
        }
        else
        {
            std::fprintf(fp, "%sxy_offset:\n", pp);
            std::fprintf(fp, ".byt %sxy0___xNE - %sxy0\n", pp, pp);
            std::fprintf(fp, ".byt %sxy0___xSE - %sxy0\n", pp, pp);
            std::fprintf(fp, ".byt %sxy0_NWx__ - %sxy0\n", pp, pp);
            std::fprintf(fp, ".byt %sxy0_SWx__ - %sxy0\n", pp, pp);
        }

        std::fprintf(fp, "%syx_lo:\n", pp);
        for(unsigned i = 0; i != 22; ++i)
            std::fprintf(fp, ".byt .lobyte(%syx%i)\n", pp, i);
        std::fprintf(fp, "%syx_hi:\n", pp);
        for(unsigned i = 0; i != 22; ++i)
            std::fprintf(fp, ".byt .hibyte(%syx%i)\n", pp, i);

        if(p == 0)
        {
            std::fprintf(fp, "%syx_offset:\n", pp);
            std::fprintf(fp, ".byt %syx0_NWx__ - %syx0\n", pp, pp);
            std::fprintf(fp, ".byt %syx0___xSW - %syx0\n", pp, pp);
            std::fprintf(fp, ".byt %syx0_NEx__ - %syx0\n", pp, pp);
            std::fprintf(fp, ".byt %syx0___xSE - %syx0\n", pp, pp);
        }
        else
        {
            std::fprintf(fp, "%syx_offset:\n", pp);
            std::fprintf(fp, ".byt %syx0_NEx__ - %syx0\n", pp, pp);
            std::fprintf(fp, ".byt %syx0___xSE - %syx0\n", pp, pp);
            std::fprintf(fp, ".byt %syx0_NWx__ - %syx0\n", pp, pp);
            std::fprintf(fp, ".byt %syx0___xSW - %syx0\n", pp, pp);
        }

        for(unsigned i = 0; i != 22; ++i)
        {
            std::fprintf(fp, ".assert .lobyte(%sxy%i_NWx__) <> $FF, error, "
                         "\"page overlap: %sxy%i_NWx__\"\n", pp, i, pp, i);
            std::fprintf(fp, ".assert .lobyte(%sxy%i_NWxNE) <> $FF, error, "
                         "\"page overlap: %sxy%i_NWxNE\"\n", pp, i, pp, i);
            std::fprintf(fp, ".assert .lobyte(%sxy%i_NWxSE) <> $FF, error, "
                         "\"page overlap: %sxy%i_NWxSE\"\n", pp, i, pp, i);
            std::fprintf(fp, ".assert .lobyte(%sxy%i___xNE) <> $FF, error, "
                         "\"page overlap: %sxy%i___xNE\"\n", pp, i, pp, i);
            std::fprintf(fp, ".assert .lobyte(%sxy%i_SWx__) <> $FF, error, "
                         "\"page overlap: %sxy%i_SWx__\"\n", pp, i, pp, i);
            std::fprintf(fp, ".assert .lobyte(%sxy%i_SWxSE) <> $FF, error, "
                         "\"page overlap: %sxy%i_SWxSE\"\n", pp, i, pp, i);
            std::fprintf(fp, ".assert .lobyte(%sxy%i___xSE) <> $FF, error, "
                         "\"page overlap: %sxy%i___xSE\"\n", pp, i, pp, i);
        }

        for(unsigned i = 0; i != 22; ++i)
        {
            std::fprintf(fp, ".assert .lobyte(%syx%i_NWx__) <> $FF, error, "
                         "\"page overlap: %syx%i_NWx__\"\n", pp, i, pp, i);
            std::fprintf(fp, ".assert .lobyte(%syx%i_NWxSW) <> $FF, error, "
                         "\"page overlap: %syx%i_NWxSW\"\n", pp, i, pp, i);
            std::fprintf(fp, ".assert .lobyte(%syx%i_NWxSE) <> $FF, error, "
                         "\"page overlap: %syx%i_NWxSE\"\n", pp, i, pp, i);
            std::fprintf(fp, ".assert .lobyte(%syx%i___xSE) <> $FF, error, "
                         "\"page overlap: %syx%i___xSE\"\n", pp, i, pp, i);
            std::fprintf(fp, ".assert .lobyte(%syx%i___xSW) <> $FF, error, "
                         "\"page overlap: %syx%i___xSW\"\n", pp, i, pp, i);
            std::fprintf(fp, ".assert .lobyte(%syx%i_NEx__) <> $FF, error, "
                         "\"page overlap: %syx%i_NEx__\"\n", pp, i, pp, i);
            std::fprintf(fp, ".assert .lobyte(%syx%i_NExSE) <> $FF, error, "
                         "\"page overlap: %syx%i_NExSE\"\n", pp, i, pp, i);
        }

        for(unsigned i = 0; i != 22; ++i)
        {
            std::fprintf(fp, ".assert %syx%i + %syx0_NWx__ - %syx0 = %syx%i_NWx__, "
                             "error, \"ptr: %syx%i_NWx__\"\n", 
                             pp, i, pp, pp, pp, i, pp, i);
            std::fprintf(fp, ".assert %syx%i + %syx0_NEx__ - %syx0 = %syx%i_NEx__, "
                             "error, \"ptr: %syx%i_NEx__\"\n", 
                             pp, i, pp, pp, pp, i, pp, i);
            std::fprintf(fp, ".assert %syx%i + %syx0___xSE - %syx0 = %syx%i___xSE, "
                             "error, \"ptr: %syx%i___xSE\"\n", 
                             pp, i, pp, pp, pp, i, pp, i);
            std::fprintf(fp, ".assert %syx%i + %syx0___xSW - %syx0 = %syx%i___xSW, "
                             "error, \"ptr: %syx%i___xSW\"\n", 
                             pp, i, pp, pp, pp, i, pp, i);
        }

        for(unsigned i = 0; i != 22; ++i)
        {
            std::fprintf(fp, ".assert %sxy%i + %sxy0_NWx__ - %sxy0 = %sxy%i_NWx__, "
                             "error, \"ptr: %sxy%i_NWx__\"\n", 
                             pp, i, pp, pp, pp, i, pp, i);
            std::fprintf(fp, ".assert %sxy%i + %sxy0_SWx__ - %sxy0 = %sxy%i_SWx__, "
                             "error, \"ptr: %sxy%i_SWx__\"\n", 
                             pp, i, pp, pp, pp, i, pp, i);
            std::fprintf(fp, ".assert %sxy%i + %sxy0___xNE - %sxy0 = %sxy%i___xNE, "
                             "error, \"ptr: %sxy%i___xNE\"\n", 
                             pp, i, pp, pp, pp, i, pp, i);
            std::fprintf(fp, ".assert %sxy%i + %sxy0___xSE - %sxy0 = %sxy%i___xSE, "
                             "error, \"ptr: %sxy%i___xSE\"\n", 
                             pp, i, pp, pp, pp, i, pp, i);
        }

    }

    std::fclose(fp);
}

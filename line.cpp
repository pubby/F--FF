#include <cstdio>
#include <cstdlib>

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
    std::fprintf(fp, ".segment \"RODATA\"\n");
    std::fprintf(fp, "PPxy_lo:\n");
    for(unsigned i = 0; i != 22; ++i)
        std::fprintf(fp, ".byt .lobyte(PPxy%i)\n", i);
    std::fprintf(fp, "PPxy_hi:\n");
    for(unsigned i = 0; i != 22; ++i)
        std::fprintf(fp, ".byt .hibyte(PPxy%i)\n", i);
    std::fprintf(fp, "PPyx_lo:\n");
    for(unsigned i = 0; i != 22; ++i)
        std::fprintf(fp, ".byt .lobyte(PPyx%i)\n", i);
    std::fprintf(fp, "PPyx_hi:\n");
    for(unsigned i = 0; i != 22; ++i)
        std::fprintf(fp, ".byt .hibyte(PPyx%i)\n", i);

    std::fprintf(fp, ".segment \"CODE\"\n");
    std::fprintf(fp, ":\n");
    std::fprintf(fp, "    rts\n");
    std::fprintf(fp, "    nop\n");
    for(unsigned i = 0; i != 22; ++i)
    {
        std::fprintf(fp, "PPxy%i:\n", i);
        std::fprintf(fp, "    dec nt_buffer+%i*32, x\n", i);
        std::fprintf(fp, "    cpx to_x\n");
        if(i == 7)
            std::fprintf(fp, "midReturn1:\n");
        if(i < 8)
            std::fprintf(fp, "    bcs :-\n");
        else if(i < 22 - 8)
            std::fprintf(fp, "    bcs midReturn1\n");
        else
            std::fprintf(fp, "    bcs :+\n");
        std::fprintf(fp, "    inx\n");
        std::fprintf(fp, "    adc Dy\n");
        std::fprintf(fp, "    bmi PPxy%i\n", i);
        std::fprintf(fp, "    sbc Dx\n");
    }

    std::fprintf(fp, ":\n");
    std::fprintf(fp, "    rts\n");
    std::fprintf(fp, "    nop\n");

    for(unsigned i = 0; i != 22; ++i)
    {
        std::fprintf(fp, "PPyx%i:\n", i);
        std::fprintf(fp, "    dec nt_buffer+%i*32, x\n", i);
        if(i < 22 - 1)
        {
            std::fprintf(fp, "    dey\n");
            if(i == 7)
                std::fprintf(fp, "midReturn2:\n");
            if(i < 8)
                std::fprintf(fp, "    beq :-\n");
            else if(i < 22 - 8)
                std::fprintf(fp, "    beq midReturn2\n");
            else
                std::fprintf(fp, "    beq :+\n");
            std::fprintf(fp, "    adc Dx\n");
            std::fprintf(fp, "    bmi PPyx%i\n", i+1);
            std::fprintf(fp, "    .byt $ED ; sbc absolute\n");
            std::fprintf(fp, "    .word Dy\n");
            std::fprintf(fp, "    inx\n");
        }
    }

    std::fprintf(fp, ":\n");
    std::fprintf(fp, "    rts\n");

    /*
    std::fprintf(fp, ".include \"globals.inc\"\n");
    std::fprintf(fp, ".segment \"RODATA\"\n");
    std::fprintf(fp, "loop_lo:\n");
    for(unsigned i = 0; i != 44; ++i)
        std::fprintf(fp, ".byt .lobyte(LY%i)\n", i);
    std::fprintf(fp, "loop_hi:\n");
    for(unsigned i = 0; i != 44; ++i)
        std::fprintf(fp, ".byt .hibyte(LY%i)\n", i);

    std::fprintf(fp, ".segment \"CODE\"\n");
    for(unsigned i = 0; i != 44; ++i)
    {
        std::fprintf(fp, "LY%i:\n", i);
        std::fprintf(fp, "    iny\n");
        std::fprintf(fp, "    cpy to_x\n");
        std::fprintf(fp, "jumpPoint%i:\n", i);
        if(i % 9 == 4)
        {
            std::fprintf(fp, "    bcc :+\n");
            std::fprintf(fp, "return%i:\n", i / 9);
            std::fprintf(fp, "    rts\n");
            std::fprintf(fp, ":\n");
        }
        std::fprintf(fp, "    bcs return%i\n", i / 9);
        std::fprintf(fp, "    sta subroutine_temp\n");
        std::fprintf(fp, "    lax xdiv, y\n");
        if(i % 2 == 0)
            std::fprintf(fp, "    lda upper_pattern, y\n");
        else
            std::fprintf(fp, "    lda lower_pattern, y\n");
        //std::fprintf(fp, "    and subroutine_temp, x\n", i / 2);
        std::fprintf(fp, "    ora nt_buffer+%i*32, x\n", i / 2);
        std::fprintf(fp, "    sta nt_buffer+%i*32, x\n", i / 2);
        std::fprintf(fp, "    lda subroutine_temp\n");
        std::fprintf(fp, "    adc D_add\n");
        std::fprintf(fp, "    bmi LY%i\n", i);
        if(i < 44 - 1)
            std::fprintf(fp, "    sbc D_sub\n");
    }
    std::fprintf(fp, "bottomReturn:\n");
    std::fprintf(fp, "    rts\n");
    */

    std::fclose(fp);
}

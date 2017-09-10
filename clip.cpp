#include <cstdio>
#include <cstdlib>

void foo(FILE* fp, int i, int d)
{
    std::fprintf(fp, "; i=%i d=%i\n", i, d);
    std::fprintf(fp, "loop_%i_%i:\n", i, d);
    std::fprintf(fp, "    lsr intercept_scale+%i\n", i);
    std::fprintf(fp, "    beq zeroInterceptScale_%i_%i\n", i, d);
    for(int k = i-1; k >= 0; --k)
        std::fprintf(fp, "    ror intercept_scale+%i\n", k);

    std::fprintf(fp, "    lsr denom+%i\n", d);
    if(d > 0)
        std::fprintf(fp, "    beq zeroDenom_%i_%i\n", i, d);
    std::fprintf(fp, "denomEntrance_%i_%i:\n", i, d);
    for(int k = d-1; k >= 0; --k)
        std::fprintf(fp, "    ror denom+%i\n", k);
    std::fprintf(fp, "    sec\n");
    std::fprintf(fp, "    lda numer+0\n");
    std::fprintf(fp, "    sbc denom+0\n");
    std::fprintf(fp, "    tax\n");
    std::fprintf(fp, "    lda numer+1\n");
    std::fprintf(fp, "    sbc denom+1\n");
    //if(d == 2)
    {
        std::fprintf(fp, "    tay\n");
        std::fprintf(fp, "    lda numer+2\n");
        std::fprintf(fp, "    sbc denom+2\n");
        std::fprintf(fp, "    bcc loop_%i_%i\n", i, d);
        std::fprintf(fp, "    stx numer+0\n");
        std::fprintf(fp, "    sty numer+1\n");
        std::fprintf(fp, "    sta numer+2\n");
    }
    for(int k = 0; k < 3; ++k)
    {
        if(k <= i)
        {
            std::fprintf(fp, "    lda intercept+%i\n", k);
            std::fprintf(fp, "    sbc intercept_scale+%i\n", k);
            std::fprintf(fp, "    sta intercept+%i\n", k);
        }
        else
        {
            std::fprintf(fp, "    bcs loop_%i_%i\n", i, d);
            std::fprintf(fp, "    dec intercept+%i\n", k);
        }
    }
    std::fprintf(fp, "    jmp loop_%i_%i\n", i, d);

    if(d > 0)
    {
        std::fprintf(fp, "zeroDenom_%i_%i:\n", i, d);
        std::fprintf(fp, "    ror denom+%i\n", d-1);
        //std::fprintf(fp, "    jmp loop_%i_%i\n", i, d-1);
        std::fprintf(fp, "    jmp denomEntrance_%i_%i\n", i, d-1);
    }
    std::fprintf(fp, "zeroInterceptScale_%i_%d:\n", i, d);
    if(i <= 1)
    {
        std::fprintf(fp, "    lda #0\n");
        std::fprintf(fp, "    sta numer+0\n");
        std::fprintf(fp, "    sta numer+1\n");
        std::fprintf(fp, "    rts\n");
    }
    else
    {
        std::fprintf(fp, "    ror intercept_scale+%i\n", i-1);
        std::fprintf(fp, "    .byt $0C ; IGN to skip next LSR\n");
        foo(fp, i - 1, d);
    }
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

    std::fprintf(fp, ".macro scale_by_ratio intercept, intercept_scale, numer, denom\n");
    foo(fp, 2, 2);
    foo(fp, 2, 1);
    foo(fp, 2, 0);
    std::fprintf(fp, ".endmacro\n");
    std::fclose(fp);
}

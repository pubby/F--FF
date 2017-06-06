#include <cstdio>
#include <iostream>

using u8 = unsigned char;
using s8 = signed char;
using u16 = unsigned short;
using s16 = short;

u8 bs(u8 v) { return v == 0 ? 0 : 31 - __builtin_clz(v); }
u8 bsi(unsigned v) { return v == 0 ? 0 : 31 - __builtin_clz(v); }

u8 and_mask(u8 i)
{
    return ~((1u << bs(i)) - 1u);
}

u8 or_mask(u8 i)
{
    return ((1 << bs(i)) - 1) & i;
}

unsigned fi(unsigned i)
{
    return i+12;
}

unsigned recip(u8 t, u8 i)
{
    unsigned j = 0x100 | (i >> t) | ((i << (8 - t)) & 0xFF);
    return (256*256*256) / fi(j << t);
}

int main(int argc, char** argv)
{
    if(argc != 2)
    {
        std::fprintf(stderr, "usage: %s [outfile]", argv[0]);
        return 1;
    }
    FILE* fp = std::fopen(argv[1], "w");

    std::fprintf(fp, "recip_table_0_lo:\n");
    for(int i = 0; i != 256; ++i)
    {
        if(i % 8 == 0)
            std::fprintf(fp, "    .byt");
        unsigned j = ((256*256*256) / fi(i));
        std::fprintf(fp, " $%02X", (j >> (bsi(j) - 15)) & 0xFF);
        std::fprintf(fp, "%s", i % 8 == 7 ? "\n" : ",");
    }

    std::fprintf(fp, "recip_table_0_hi:\n");
    for(int i = 0; i != 256; ++i)
    {
        if(i % 8 == 0)
            std::fprintf(fp, "    .byt");
        unsigned j = ((256*256*256) / fi(i));
        std::fprintf(fp, " $%02X", (j >> (bsi(j) - 15)) >> 8);
        std::fprintf(fp, "%s", i % 8 == 7 ? "\n" : ",");
    }

    for(int t = 0; t < 8; ++t)
    {
        std::fprintf(fp, "recip_table_%i_lo:\n", t+1);
        for(int i = 0; i != 256; ++i)
        {
            if(i % 8 == 0)
                std::fprintf(fp, "    .byt");
            std::fprintf(fp, " $%02X", recip(t, i) & 0xFF);
            std::fprintf(fp, "%s", i % 8 == 7 ? "\n" : ",");
        }
        std::fprintf(fp, "recip_table_%i_hi:\n", t+1);
        for(int i = 0; i != 256; ++i)
        {
            if(i % 8 == 0)
                std::fprintf(fp, "    .byt");
            std::fprintf(fp, " $%02X", recip(t, i) >> 8);
            std::fprintf(fp, "%s", i % 8 == 7 ? "\n" : ",");
        }
    }

    std::fprintf(fp, "recip_and_table:\n");
    for(int i = 0; i != 256; ++i)
    {
        if(i % 8 == 0)
            std::fprintf(fp, "    .byt");
        std::fprintf(fp, " $%02X", and_mask(i));
        std::fprintf(fp, "%s", i % 8 == 7 ? "\n" : ",");
    }

    std::fprintf(fp, "recip_or_table:\n");
    for(int i = 0; i != 256; ++i)
    {
        if(i % 8 == 0)
            std::fprintf(fp, "    .byt");
        std::fprintf(fp, " $%02X", or_mask(i));
        std::fprintf(fp, "%s", i % 8 == 7 ? "\n" : ",");
    }

    std::fprintf(fp, "recip_asl_table:\n");
    for(int i = 0; i != 256; ++i)
    {
        if(i % 8 == 0)
            std::fprintf(fp, "    .byt");
        unsigned j = ((256*256*256) / fi(i));
        std::fprintf(fp, " $%02X", (6 - (bsi(j) - 15)) * 7);
        std::fprintf(fp, "%s", i % 8 == 7 ? "\n" : ",");
    }

    std::fprintf(fp, "recip_index_table:\n");
    for(int i = 0; i != 256; ++i)
    {
        if(i % 2 == 0)
            std::fprintf(fp, "    .byt");
        if(i == 0)
            std::fprintf(fp, " .hibyte(recip_table_0_lo)");
        else
            std::fprintf(fp, " .hibyte(recip_table_%i_lo)", bs(i) + 1);
        std::fprintf(fp, "%s", i % 2 == 1 ? "\n" : ",");
    }

    /*
    for(unsigned hi = 1; hi < 256; ++hi)
    for(unsigned lo = 0; lo < 256; ++lo)
    {
        unsigned k = hi*256 + lo;
        u8 i = lo & and_mask(hi);
        i |= or_mask(hi);
        unsigned j = recip(bs(hi), i);
        std::cout << int(j) << ' ' << ((256*256*255) / k) << std::endl;
    }
    */

    std::fclose(fp);
}

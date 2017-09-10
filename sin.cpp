#include <cmath>
#include <cstdio>

constexpr double pi = 3.14159265359;

unsigned sin_(unsigned d)
{
    if(d >= 63)
        return 0xFFFF;
    return std::round(std::sin(d * (pi / 128.0)) * 65536.0);
}

int main(int argc, char** argv)
{
    if(argc != 2)
    {
        std::fprintf(stderr, "usage: %s [outfile]", argv[0]);
        return 1;
    }
    FILE* fp = std::fopen(argv[1], "w");
    if(!fp)
    {
        std::fprintf(stderr, "can't open %s", argv[0]);
        return 1;
    }

    std::fprintf(fp, "sin_table_lo:");
    for(unsigned i = 0; i != 64; ++i)
    {
        if(i % 8 == 0) std::fprintf(fp,"\n.byt ");
        else std::fprintf(fp, ",");
        std::fprintf(fp, "$%02X", sin_(i) & 0xFF);
    }

    std::fprintf(fp, "\nsin_table_hi:");
    for(unsigned i = 0; i != 64; ++i)
    {
        if(i % 8 == 0) std::fprintf(fp,"\n.byt ");
        else std::fprintf(fp, ",");
        std::fprintf(fp, "$%02X", sin_(i) >> 8);
    }
}

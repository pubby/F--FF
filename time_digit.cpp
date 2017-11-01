#include <cmath>
#include <cstdio>

constexpr double pi = 3.14159265359;

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

    std::fprintf(fp, "\ntime_digit_table:");
    for(unsigned i = 0; i != 64; ++i)
    {
        if(i % 8 == 0) std::fprintf(fp,"\n.byt ");
        else std::fprintf(fp, ",");
        unsigned j = i * 100 / 60;
        unsigned lo = j % 10;
        unsigned hi = j / 10;
        std::printf("%i %i\n", lo, hi);
        std::fprintf(fp, "$%02X", lo | (hi << 4));
    }
}

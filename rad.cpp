#include <cstdio>
#include <cstdlib>
#include <array>
#include <vector>
#include <map>

using tile_t = std::array<unsigned char, 16>;

int main(int argc, char** argv)
{
    if(argc != 6)
    {
        std::fprintf(stderr, "usage: %s [in chr] [in chr2] [in chr3] [out chr] [out nt]\n", argv[0]);
        return EXIT_FAILURE;
    }

    FILE* fp = nullptr;
    std::size_t size = 0;
    std::vector<tile_t> tvec;
    std::map<tile_t, unsigned> tmap;
    
    fp = std::fopen(argv[1], "rb");
    if(!fp)
    {
        std::fprintf(stderr, "can't open file %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    std::fseek(fp, 0L, SEEK_END);
    size = std::ftell(fp);
    std::rewind(fp);

    std::vector<tile_t> tiles(size / sizeof(tile_t));
    std::fread(tiles.data(), size, 1, fp);
    std::fclose(fp);

    for(tile_t t : tiles)
    {
        auto p = tmap.try_emplace(t, tvec.size());
        if(p.second)
            tvec.push_back(t);
    }

    fp = std::fopen(argv[2], "rb");
    if(!fp)
    {
        std::fprintf(stderr, "can't open file %s\n", argv[2]);
        return EXIT_FAILURE;
    }

    std::fseek(fp, 0L, SEEK_END);
    size = std::ftell(fp);
    std::rewind(fp);

    std::vector<tile_t> tiles2(size / sizeof(tile_t));
    std::fread(tiles2.data(), size, 1, fp);
    std::fclose(fp);

    for(tile_t t : tiles2)
    {
        auto p = tmap.try_emplace(t, tvec.size());
        if(p.second)
            tvec.push_back(t);
    }

    fp = std::fopen(argv[4], "wb");
    if(!fp)
    {
        std::fprintf(stderr, "can't open file %s\n", argv[4]);
        return EXIT_FAILURE;
    }
    while(tvec.size() < 256)
        tvec.push_back(tile_t{});
    for(tile_t t : tvec)
        for(unsigned char c : t)
            std::fputc(~c, fp);
    std::fclose(fp);

    std::vector<unsigned char> nt(1024, 0);
    std::vector<unsigned char> nt2(1024, 0);
    for(unsigned i = 0; i != 960/64; ++i)
    for(unsigned j = 0; j != 32; ++j)
    {
        nt[i*64+j]    = tmap[tiles[i*64+j*2]];
        nt[i*64+j+32] = tmap[tiles[i*64+j*2+1]];
        nt2[i*64+j]    = tmap[tiles2[i*64+j*2]];
        nt2[i*64+j+32] = tmap[tiles2[i*64+j*2+1]];
    }

    for(unsigned i = 960; i < 1024; ++i)
        nt[i] = nt2[i] = 0b01000001;

    for(unsigned i = 960+8*1; i < 960+8*2; ++i)
        nt[i] = nt2[i] = 0b01010001;

    for(unsigned i = 960+8*2; i < 960+8*4; ++i)
        nt[i] = nt2[i] = 0b01010101;

    for(unsigned i = 960+8*4; i < 960+8*5; ++i)
        nt[i] = nt2[i] = 0b01000101;

    for(unsigned i = 960+32; i < 1024; ++i)
        nt[i] = nt2[i] = nt[i] | 0b10101010;

    fp = std::fopen(argv[5], "w");
    if(!fp)
    {
        std::fprintf(stderr, "can't open file %s\n", argv[5]);
        return EXIT_FAILURE;
    }
    std::fprintf(fp, "rad_nt:");
    for(unsigned i = 0; i < nt.size(); ++i)
    {
        if(i % 8 == 0)
            std::fprintf(fp, "\n.byt ");
        else
            std::fprintf(fp, ", ");
        std::fprintf(fp, "$%02X", nt[i]);
    }

    std::fprintf(fp, "\n\nrad_nt_swaps:\n");
    unsigned A = -1;
    unsigned X = -1;
    unsigned Y = -1;
    unsigned addr = -1;
    for(unsigned i = 0; i < nt.size(); ++i)
    {
        if(nt[i] == nt2[i])
            continue;
        if(i != addr+1)
        {
            addr = i;
            if((0x2800+i)>>8 != X)
            {
                X = (0x2800+i)>>8;
                std::fprintf(fp, "ldx #$%02X\n", X);
            }
            if(((0x2800+i)&0xFF) != Y)
            {
                Y = (0x2800+i)&0xFF;
                std::fprintf(fp, "ldy #$%02X\n", Y);
            }
            std::fprintf(fp, "stx PPUADDR\n");
            std::fprintf(fp, "sty PPUADDR\n");
        }
        if((A&X) == nt[i])
            std::fprintf(fp, "sax PPUDATA\n\n");
        else
        {
            if(A != nt[i])
            {
                A = nt[i];
                std::fprintf(fp, "lda #$%02X\n", A);
            }
            std::fprintf(fp, "sta PPUDATA\n\n");
        }
    }
    std::fprintf(fp, "rts\n");

    std::fprintf(fp, "\n\nrad2_nt_swaps:\n");
    A = -1;
    X = -1;
    Y = -1;
    for(unsigned i = 0; i < nt2.size(); ++i)
    {
        if(nt[i] == nt2[i])
            continue;
        if(i != addr+1)
        {
            addr = i;
            if((0x2800+i)>>8 != X)
            {
                X = (0x2800+i)>>8;
                std::fprintf(fp, "ldx #$%02X\n", X);
            }
            if(((0x2800+i)&0xFF) != Y)
            {
                Y = (0x2800+i)&0xFF;
                std::fprintf(fp, "ldy #$%02X\n", Y);
            }
            std::fprintf(fp, "stx PPUADDR\n");
            std::fprintf(fp, "sty PPUADDR\n");
        }
        if((A&X) == nt2[i])
            std::fprintf(fp, "sax PPUDATA\n\n");
        else
        {
            if(A != nt2[i])
            {
                A = nt2[i];
                std::fprintf(fp, "lda #$%02X\n", A);
            }
            std::fprintf(fp, "sta PPUDATA\n\n");
        }
    }
    std::fprintf(fp, "rts\n");
    std::fclose(fp);

    std::printf("size %i\n", tvec.size());

}


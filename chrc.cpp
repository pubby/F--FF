#include <cstdio>
#include <cstdlib>
#include <array>
#include <vector>

using tile_t = std::array<unsigned char, 16>;

struct coord
{
    int x;
    int y;
    bool operator!=(coord o) const { return x != o.x || y != o.y; }
};

constexpr int signum(int x) { return int(0 < x) - int(x < 0); }

tile_t trace_line(coord from, coord to)
{
    // Using a slightly different version of the algorithm than line_state.
    // This version doesn't need to swap x or y.
    coord direction = to;
    direction.x -= from.x;
    direction.y -= from.y;
    coord const d = { std::abs(direction.x), std::abs(direction.y) };
    coord const s = { signum(direction.x), signum(direction.y) };
    std::array<std::array<bool, 8>, 8> pixels = {};
    for(int err = d.x - d.y; from != to;)
    {
        pixels[from.y][from.x] = true;
        int const err2 = 2 * err;
        if(err2 > -d.y)
        {
            err -= d.y;
            from.x += s.x;
        }
        if(err2 < d.x)
        {
            err += d.x;
            from.y += s.y;
        }
    }
    pixels[from.y][from.x] = true;

    tile_t t;
    for(unsigned y = 0; y < 8; ++y)
    {
        t[y] = 0;
        t[y+8] = 0;
        for(unsigned x = 0; x < 8; ++x)
        {
            t[y] |= unsigned(pixels[y][x]) << (7 - x);
            t[y+8] |= unsigned(pixels[y][x]) << (7 - x);
        }
    }
    return t;
}

coord fix(coord c)
{
    if(c.x >= 4)
        ++c.x;
    if(c.y >= 4)
        ++c.y;
    return c;
}

tile_t solid(unsigned char b)
{
    tile_t t = {};
    unsigned char top = b & 0b1111;
    unsigned char bottom = b >> 4;

    for(unsigned i = 6; top; top >>= 1, i -= 2)
        if(top & 1)
            for(unsigned j = 0; j != 4; ++j)
                t[j] |= 0b11 << i;

    for(unsigned i = 6; bottom; bottom >>= 1, i -= 2)
        if(bottom & 1)
            for(unsigned j = 0; j != 4; ++j)
                t[j+4] |= 0b11 << i;

    return t;
}

std::pair<unsigned char, unsigned char> solid3(unsigned char b)
{
    unsigned char top = 0;
    unsigned char bot = 0;
    if(b & 0b0001)
        bot |= 0b00001111;
    if(b & 0b0010)
        bot |= 0b11110000;
    if(b & 0b0100)
        top |= 0b00001111;
    if(b & 0b1000)
        top |= 0b11110000;
    return { top, bot };
}

tile_t solid2(unsigned char b)
{
    tile_t t = {};
    auto p1 = solid3(b & 0b1111);
    auto p2 = solid3(b >> 4);

    for(int i = 0; i != 4; ++i)
        t[i+ 0] = p1.first;
    for(int i = 0; i != 4; ++i)
        t[i+ 4] = p1.second;
    for(int i = 0; i != 4; ++i)
        t[i+ 8] = p2.first;
    for(int i = 0; i != 4; ++i)
        t[i+12] = p2.second;

    return t;
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

    //for(unsigned i = 0; i != 256; ++i)
        //for(unsigned j = 0; j != 16; ++j)
            //std::fputc(i ? 0xFF : 0x00, fp);

    for(unsigned i = 0; i != 256; ++i)
        for(unsigned char byte : solid2(i))
            std::fputc(byte, fp);
    /*
    for(unsigned y1 = 0; y1 < 8; y1 += 2)
    for(unsigned x1 = 0; x1 < 8; x1 += 2)
    for(unsigned y2 = 0; y2 < 8; y2 += 2)
    for(unsigned x2 = 0; x2 < 8; x2 += 2)
        for(unsigned char byte : trace_line(fix({x1,y1}),fix({x2,y2})))
            std::fputc(byte, fp);
            */

    std::fclose(fp);
}


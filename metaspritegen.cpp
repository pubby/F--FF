#include <cstdlib>
#include <cstdio>
#include <fstream>
#include <iostream>
#include <vector>
#include <map>
#include <algorithm>

struct sprite_t
{
    int x_off;
    int y_off;
    int pattern;
    int attributes;
};

std::uint32_t sprite_byte(sprite_t sprite)
{
    unsigned char const x = sprite.x_off;
    unsigned char const y = sprite.y_off;
    unsigned char const p = sprite.pattern;
    unsigned char const a = sprite.attributes;
    return x | (y << 8) | (p << 16) | (a << 24);
}

bool operator==(sprite_t lhs, sprite_t rhs)
{
    return sprite_byte(lhs) == sprite_byte(rhs);
}

bool operator<(sprite_t lhs, sprite_t rhs)
{
    return sprite_byte(lhs) < sprite_byte(rhs);
}

using metasprite_t = std::vector<sprite_t>;

struct animation_t
{
    char const* name;
    int width;
    int height;
    int flags;
    std::vector<metasprite_t> frames;
};

unsigned char HFLIP = 1 << 6;
unsigned char VFLIP = 1 << 7;

constexpr unsigned char PATTERN(unsigned char x)
{
    return x*2 + 1;
}

static std::vector<animation_t> const animations =
{
    { "menu_p2", 0, 0, 0, {
        { 
            { 8* 0, 16* 0, PATTERN(0x00), 0 },
            { 8* 1, 16* 0, PATTERN(0x01), 0 },
            { 8* 2, 16* 0, PATTERN(0x02), 0 },
            { 8* 3, 16* 0, PATTERN(0x03), 0 },
            { 8* 4, 16* 0, PATTERN(0x04), 0 },
            { 8* 5, 16* 0, PATTERN(0x05), 0 },
            { 8* 6, 16* 0, PATTERN(0x06), 0 },
            { 8* 7, 16* 0, PATTERN(0x07), 0 },

            { 8* 0, 16* 1, PATTERN(0x10), 0 },
            { 8* 1, 16* 1, PATTERN(0x11), 0 },
            { 8* 2, 16* 1, PATTERN(0x12), 0 },
            { 8* 3, 16* 1, PATTERN(0x13), 0 },
            { 8* 4, 16* 1, PATTERN(0x14), 0 },
            { 8* 5, 16* 1, PATTERN(0x15), 0 },
            { 8* 6, 16* 1, PATTERN(0x16), 0 },
            { 8* 7, 16* 1, PATTERN(0x17), 0 },

            { 8* 1, 16* 2, PATTERN(0x08), 0 },
            { 8* 2, 16* 2, PATTERN(0x09), 0 },
            { 8* 3, 16* 2, PATTERN(0x0A), 0 },
            { 8* 4, 16* 2, PATTERN(0x0B), 0 },
            { 8* 5, 16* 2, PATTERN(0x0C), 0 },
            { 8* 6, 16* 2, PATTERN(0x0D), 0 },
            { 8* 7, 16* 2, PATTERN(0x0E), 0 },

            { 8* 1, 16* 3, PATTERN(0x18), 0 },
            { 8* 2, 16* 3, PATTERN(0x19), 0 },
            { 8* 3, 16* 3, PATTERN(0x1A), 0 },
            { 8* 4, 16* 3, PATTERN(0x1B), 0 },
            { 8* 5, 16* 3, PATTERN(0x1C), 0 },
            { 8* 6, 16* 3, PATTERN(0x1D), 0 },
            { 8* 7, 16* 3, PATTERN(0x1E), 0 },
            { 8* 8, 16* 3, PATTERN(0x1F), 0 },
        },
    }},

    { "icy_text", 0, 0, 0, {
        { 
            { 12* 0, 0, PATTERN(0x23), 0 },
            { 12* 1, 0, PATTERN(0x24), 0 },
            { 12* 2, 0, PATTERN(0x25), 0 },
        },
    }},

    { "spicy_text", 0, 0, 0, {
        { 
            { 12* 0, 0, PATTERN(0x21), 0 },
            { 12* 1, 0, PATTERN(0x22), 0 },
            { 12* 2, 0, PATTERN(0x23), 0 },
            { 12* 3, 0, PATTERN(0x24), 0 },
            { 12* 4, 0, PATTERN(0x25), 0 },
        },
    }},

    { "dicey_text", 0, 0, 0, {
        { 
            { 12* 0, 0, PATTERN(0x26), 0 },
            { 12* 1, 0, PATTERN(0x23), 0 },
            { 12* 2, 0, PATTERN(0x24), 0 },
            { 12* 3, 0, PATTERN(0x27), 0 },
            { 12* 4, 0, PATTERN(0x25), 0 },
        },
    }},

    { "ship", 0, 0, 0, {
        { 
            { 8* 0, 0, PATTERN(0x30), 0 },
            { 8* 1, 3, PATTERN(0x31), 0 },
            { 8* 2, 3, PATTERN(0x32), 0 },
            { 8* 3, 3, PATTERN(0x32), HFLIP },
            { 8* 4, 3, PATTERN(0x31), HFLIP },
            { 8* 5, 0, PATTERN(0x30), HFLIP },

            { 8* 0, 16+0, PATTERN(0x40), 0 },
            { 8* 1, 16+3, PATTERN(0x41), 0 },
            { 8* 2, 16+3, PATTERN(0x42), 0 },
            { 8* 3, 16+3, PATTERN(0x42), HFLIP },
            { 8* 4, 16+3, PATTERN(0x41), HFLIP },
            { 8* 5, 16+0, PATTERN(0x40), HFLIP },
        },
    }},

    { "shadow", 0, 0, 0, {
        { 
            { 8* 2, 0, PATTERN(0x35), 0 },
            { 8* 3, 0, PATTERN(0x35), HFLIP },

            { 8* 1, 1, PATTERN(0x34), 0 },
            { 8* 4, 1, PATTERN(0x34), HFLIP },

            { 8* 5, 3, PATTERN(0x33), HFLIP },
            { 8* 0, 3, PATTERN(0x33), 0 },
        },
    }},

    { "shadow_tight", 0, 0, 0, {
        { 
            { 8* 2, 0, PATTERN(0x35), 0 },
            { 8* 3, 0, PATTERN(0x35), HFLIP },

            { 8* 1, 1, PATTERN(0x34), 0 },
            { 8* 4, 1, PATTERN(0x34), HFLIP },

            { 8* 5-2, 2, PATTERN(0x33), HFLIP },
            { 8* 0+2, 2, PATTERN(0x33), 0 },
        },
    }},

    { "explosion", 0, 0, 0, {
        { 
            { 8* 1,  0, PATTERN(0x70), 0 },
            { 8* 2,  0, PATTERN(0x71), 0 },
            { 8* 3,  0, PATTERN(0x71), HFLIP },
            { 8* 4,  0, PATTERN(0x70), HFLIP },
            { 8* 1, 16, PATTERN(0x70), VFLIP },
            { 8* 2, 16, PATTERN(0x71), VFLIP },
            { 8* 3, 16, PATTERN(0x71), HFLIP | VFLIP },
            { 8* 4, 16, PATTERN(0x70), HFLIP | VFLIP },
        },
        { 
            { 8* 0,  0, PATTERN(0x72), 0 },
            { 8* 1,  0, PATTERN(0x73), 0 },
            { 8* 2,  0, PATTERN(0x74), 0 },
            { 8* 3,  0, PATTERN(0x74), HFLIP },
            { 8* 4,  0, PATTERN(0x73), HFLIP },
            { 8* 5,  0, PATTERN(0x72), HFLIP },
            { 8* 0, 16, PATTERN(0x72), VFLIP },
            { 8* 1, 16, PATTERN(0x73), VFLIP },
            { 8* 2, 16, PATTERN(0x74), VFLIP },
            { 8* 3, 16, PATTERN(0x74), HFLIP | VFLIP },
            { 8* 4, 16, PATTERN(0x73), HFLIP | VFLIP },
            { 8* 5, 16, PATTERN(0x72), HFLIP | VFLIP },
        },
        { 
            { 8* 0,  0, PATTERN(0x75), 0 },
            { 8* 1,  0, PATTERN(0x76), 0 },
            { 8* 2,  0, PATTERN(0x77), 0 },
            { 8* 3,  0, PATTERN(0x77), HFLIP },
            { 8* 4,  0, PATTERN(0x76), HFLIP },
            { 8* 5,  0, PATTERN(0x75), HFLIP },
            { 8* 0, 16, PATTERN(0x75), VFLIP },
            { 8* 1, 16, PATTERN(0x76), VFLIP },
            { 8* 2, 16, PATTERN(0x77), VFLIP },
            { 8* 3, 16, PATTERN(0x77), HFLIP | VFLIP },
            { 8* 4, 16, PATTERN(0x76), HFLIP | VFLIP },
            { 8* 5, 16, PATTERN(0x75), HFLIP | VFLIP },
        },
    }},

    { "lap", 0, 0, 0, {
        { 
            { 10* 0,  0, PATTERN(0x53), 0 },
            { 10* 1,  0, PATTERN(0x54), 0 },
            { 10* 2,  0, PATTERN(0x55), 0 },
            { 10* 4,  0, PATTERN(0x58), 0 },
        },
        { 
            { 10* 0,  0, PATTERN(0x53), 0 },
            { 10* 1,  0, PATTERN(0x54), 0 },
            { 10* 2,  0, PATTERN(0x55), 0 },
            { 10* 4,  0, PATTERN(0x59), 0 },
        },
    }},

    { "win", 0, 0, 0, {
        { 
            { 0,     0, PATTERN(0x62), 0 },
            { 8,     0, PATTERN(0x62), HFLIP },
            { 8+8,  0, PATTERN(0x63), 0 },
            { 8+18,  0, PATTERN(0x64), 0 },
        },
    }},

    { "lose", 0, 0, 0, {
        { 
            { 10*0,  0, PATTERN(0x53), 0 },
            { 10*1,  0, PATTERN(0x56), 0 },
            { 10*2,  0, PATTERN(0x60), 0 },
            { 10*3,  0, PATTERN(0x61), 0 },
        },
    }},

    { "countdown", 0, 0, 0, {
        { 
            {  0,  0, PATTERN(0x6E), 0 },
            {  8,  0, PATTERN(0x66), HFLIP },
            {  0, 16, PATTERN(0x6E), VFLIP },
            {  8, 16, PATTERN(0x6F), 0 },

            { 16+2,  0, PATTERN(0x6E), 0 },
            { 24+2,  0, PATTERN(0x6E), HFLIP },
            { 16+2, 16, PATTERN(0x6E), VFLIP },
            { 24+2, 16, PATTERN(0x6E), HFLIP | VFLIP },
        },
        { 
            { 3+9,  0, PATTERN(0x6C), 0 },
            { 1+9, 16, PATTERN(0x6D), 0 },
            { 8+9, 16, PATTERN(0x6D), HFLIP },
            { 8+9, 16, PATTERN(0x6D), HFLIP },
        },
        { 
            { 0+9,  0, PATTERN(0x69), 0 },
            { 8+9,  0, PATTERN(0x68), 0 },
            { 0+9, 16, PATTERN(0x6A), 0 },
            { 8+9, 16, PATTERN(0x6B), 0 },
        },
        { 
            { 0+9,  0, PATTERN(0x67), 0 },
            { 8+9,  0, PATTERN(0x68), 0 },
            { 0+9, 16, PATTERN(0x67), VFLIP },
            { 8+9, 16, PATTERN(0x68), VFLIP },
        },
    }},
} ;

int get_width(std::vector<sprite_t> const& sprites)
{
    int x_max = 0;
    for(sprite_t sprite : sprites)
        if(sprite.x_off > x_max)
            x_max = sprite.x_off;
    return x_max + 8;
}

int get_height(std::vector<sprite_t> const& sprites)
{
    int y_max = 0;
    for(sprite_t sprite : sprites)
        if(sprite.y_off > y_max)
            y_max = sprite.y_off;
    return y_max + 16;
}

std::vector<sprite_t> hmirror(std::vector<sprite_t> sprites, int width)
{
    for(sprite_t& sprite : sprites)
    {
        sprite.x_off = width - sprite.x_off - 8;
        sprite.attributes ^= HFLIP;
    }
    return sprites;
}

std::vector<sprite_t> hmirror(std::vector<sprite_t> sprites)
{
    return hmirror(sprites, get_width(sprites));
}

int main(int argc, char** argv)
{
    if(argc != 2)
    {
        std::fprintf(stderr, "usage: %s [outfile]\n", argv[0]);
        return EXIT_FAILURE;
    }

    FILE* fp = std::fopen(argv[1], "w");
    if(!fp)
    {
        std::fprintf(stderr, "can't open file %s\n", argv[1]);
        return EXIT_FAILURE;
    }

    std::fprintf(fp, ".scope metasprite\n");

    /*
    out << "metasprite_lo_table:\n";
    for(std::size_t i = 0; i != explosion_metasprites.frames.size(); ++i)
        out << ".byt .lobyte(metasprite_" << i << ")\n";
    out << "metasprite_hi_table:\n";
    for(std::size_t i = 0; i != explosion_metasprites.frames.size(); ++i)
        out << ".byt .hibyte(metasprite_" << i << ")\n";
    out << '\n';
    */

    std::map<metasprite_t, unsigned> frame_map;

    unsigned next_frame_id = 0;
    for(animation_t const& animation : animations)
    {
        std::fprintf(fp, "%s:\n", animation.name);
        int i = 0;
        for(metasprite_t frame : animation.frames)
        {
            auto it = frame_map.find(frame);
            if(it == frame_map.end())
                it = frame_map.emplace(frame, next_frame_id++).first;
            std::fprintf(fp, ".addr m%i\n", it->second);
            std::fprintf(fp, "%s_const%i = m%i\n", animation.name, i, it->second);
            if(animation.flags & HFLIP)
            {
                frame = hmirror(frame, animation.width);
                auto it = frame_map.find(frame);
                if(it == frame_map.end())
                    it = frame_map.emplace(frame, next_frame_id++).first;
                std::fprintf(fp, ".addr m%i\n", it->second);
                std::fprintf(fp, "%s_const%i = m%i\n", animation.name, i, it->second);
                ++i;
            }
            ++i;
        }
    }

    std::fprintf(fp, "\n");

    std::vector<std::pair<unsigned, metasprite_t> > sorted_frames;
    for(auto&& pair : frame_map)
        sorted_frames.push_back(std::make_pair(pair.second, pair.first));
    std::sort(sorted_frames.begin(), sorted_frames.end());
    for(auto&& pair : sorted_frames)
    {
        std::fprintf(fp, "m%i:\n", pair.first);
        std::fprintf(fp, ".byt %lu\n", pair.second.size() * 4);
        for(sprite_t sprite : pair.second)
        {
            std::fprintf(fp, ".byt $%02x, $%02x, $%02x, $%02x\n", 
                         sprite.attributes,
                         sprite.pattern,
                         (unsigned char)sprite.x_off,
                         (unsigned char)sprite.y_off);
        }
    }

    std::fprintf(fp, ".endscope\n");
    std::fclose(fp);

    /*
    for(std::size_t i = 0; i != explosion_metasprites.frames.size(); ++i)
    {
        auto const& metasprite = explosion_metasprites.frames[i];
        out << "metasprite_" << i << ":\n";
        if(metasprite.empty())
            continue;
        out << ".byt " << metasprite.size() * 4 << '\n';
        for(sprite_t sprite : metasprite)
        {
            out << ".byt ";
            out << (int)sprite.attributes << ", ";
            out << (int)sprite.pattern << ", ";
            out << (int)sprite.x_off << ", ";
            out << (int)sprite.y_off << '\n';
        }
    }
    */
}

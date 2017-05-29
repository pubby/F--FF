#include <cstdint>
#include <cmath>
#include <iostream>
#include <vector>

#include <SFML/Graphics.hpp>

using u8 = std::uint8_t;
using u16 = std::uint32_t;
using s8 = std::int8_t;
using s16 = std::int32_t;

constexpr double pi = 3.14159265358979323846;

s8 to_signed(u8 x)
{
    if(x <= INT8_MAX)
        return static_cast<s8>(x);
    return static_cast<s8>(x - INT8_MIN) + INT8_MIN;
}
s16 to_signed(u16 x)
{
    if(x <= INT16_MAX)
        return static_cast<s16>(x);
    return static_cast<s16>(x - INT16_MIN) + INT16_MIN;
}

u16 sin_table[64][128];

u16 sin_multiply(u8 dir, u16 n)
{
    /*
    if(bpl(dir))
    {
        u16 a = sin_table[dir / 2][n];
        u16 b = sin_table[((dir + 1) % 128) / 2][n];
        return (a + b) / 2;
    }
    else
        return -sin_multiply(-dir, n);
        */
    return std::sin(dir / 128.0 * pi) * to_signed(n);
}

u16 cos_multiply(u8 dir, u16 n)
{
    return std::cos(dir / 128.0 * pi) * to_signed(n);
    //return sin_multiply(dir + 64, n);
}

struct coord
{
    u16 x;
    u16 y;
};

using line = std::array<coord, 2>;

struct segment
{
    coord l;
    coord r;
};

#include "foo.level.hpp"

coord transform(coord player, u8 dir, coord c)
{
    u16 const xx = c.x - player.x;
    u16 const yy = c.y - player.y;

    c.x =  cos_multiply(dir, xx);
    c.x -= sin_multiply(dir, yy);
    c.y =  sin_multiply(dir, xx);
    c.y += cos_multiply(dir, yy);

    return c;
}

line transform(coord player, u8 dir, line l)
{
    return {{ transform(player, dir, l[0]), transform(player, dir, l[1]) }};
}

coord perspective(coord c)
{
    double d = std::abs(256.0 / (to_signed(c.y)));
    return { to_signed(c.x) * d, (to_signed(c.y) + 256) * d };
}

line perspective(line l)
{
    return {{ perspective(l[0]), perspective(l[1]) }};
}

bool in_front(coord c, line l)
{
    int a = to_signed(c.x - l[0].x) * to_signed(l[1].y - l[0].y);
    int b = to_signed(c.y - l[0].y) * to_signed(l[1].x - l[0].x);
    return a < b;
}

void draw_line(sf::RenderTarget& rt, line l, sf::Color color)
{
    int d = 128;
    int s = 1;
    sf::VertexArray line(sf::LinesStrip, 2);
    line[0].position = sf::Vector2f(to_signed(l[0].x)/s+d, to_signed(l[0].y)/1-256);
    line[1].position = sf::Vector2f(to_signed(l[1].x)/s+d, to_signed(l[1].y)/1-256);
    line[0].color = color;
    line[1].color = color;
    rt.draw(line);
}

void do_draw(sf::RenderTarget& rt, coord player, u8 dir, line l, sf::Color color)
{
    l = transform(player, dir, l);
    /*
    //l[0].x += 128;
    l[0].y += 256;
    //l[1].x += 128;
    l[1].y += 256;
    draw_line(rt, l, color);
    return;
    */
    double const scale = 256.0;
    int const near = 0;

    double d1 = (scale / std::max(1, to_signed(l[0].y)));
    if(to_signed(l[0].y) < near)
    {
        return;
        if(to_signed(l[1].y) < near)
            return;
        // find the intersection
        double t = to_signed(l[0].y) - near;
        t /= (double)(to_signed(l[0].y - l[1].y));
        l[0].x = to_signed(l[1].x) * t + to_signed(l[0].x) * (1.0 - t);
        l[0].y = near;
        d1 = scale / std::max(4, near);
    }

    double d2 = (scale / std::max(1, to_signed(l[1].y)));
    if(to_signed(l[1].y) < near)
    {
        return;
        // find the intersection
        double t = to_signed(l[1].y) - near;
        t /= (double)(to_signed(l[1].y - l[0].y));
        l[1].x = to_signed(l[0].x) * t + to_signed(l[1].x) * (1.0 - t);
        l[1].y = near;
        d2 = scale / std::max(4, near);
    }

    line dl1 = l;
    line dl2 = l;
    line dl3 = l;
    line dl4 = l;

    dl1[0] = { to_signed(l[0].x) * -d1, (to_signed(l[0].y) + 64) * d1 };
    dl1[1] = { to_signed(l[1].x) * -d2, (to_signed(l[1].y) + 64) * d2 };

    dl2[0] = { to_signed(l[0].x) * -d1, (to_signed(l[0].y) + 32) * d1 };
    dl2[1] = { to_signed(l[1].x) * -d2, (to_signed(l[1].y) + 32) * d2 };

    dl3[0] = dl1[0];
    dl3[1] = dl2[0];

    dl4[0] = dl1[1];
    dl4[1] = dl2[1];

    draw_line(rt, dl1, color);
    if(color == sf::Color::Red)
    {
        draw_line(rt, dl2, color);
        draw_line(rt, dl3, color);
        draw_line(rt, dl4, color);
    }
}

int main()
{
    std::vector<line> wall_lines;
    std::vector<line> floor_lines;
    for(unsigned i = 0; i != track_size; ++i)
    {
        unsigned j = (i + 1) % track_size;
        wall_lines.push_back({{{ ltx[i]/3, lty[i]/3 }, { ltx[j]/3, lty[j]/3 }}});
        wall_lines.push_back({{{ rtx[i]/3, rty[i]/3 }, { rtx[j]/3, rty[j]/3 }}});
    }

    for(unsigned i = 0; i != track_size; ++i)
    {
        unsigned j = (i + 1) % track_size;
        floor_lines.push_back({{{ ltx[i]/3, lty[i]/3 }, { rtx[i]/3, rty[i]/3 }}});
    }

    unsigned track_i = 0;

    sf::RenderWindow window(sf::VideoMode(256, 22*8), "SFML window");
    window.setFramerateLimit(30);
    unsigned char d = 0;
    coord pl = {0,0};
    while(true)
    {
        // Process events
        sf::Event event;
        while(window.pollEvent(event)) 
        {
            // Close window : exit
            switch(event.type)
            {
            case sf::Event::Closed:
                window.close();
                return 0;
            default:
                break;
            }
        }

        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Up))
        {
            pl.x += cos_multiply(d, 48);
            pl.y += sin_multiply(d, 48);
        }
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Down))
        {
            pl.x -= cos_multiply(d, 48);
            pl.y -= sin_multiply(d, 48);
        }
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Left))
            d -= 4;
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Right))
            d += 4;

        if(!in_front(pl, floor_lines[track_i]))
            track_i = (track_i + 1) % track_size;

        std::cout << track_i << std::endl;

        for(unsigned i = 0; i != track_size; ++i)
        {
            if(i == track_i)
                do_draw(window, pl, 64-d, floor_lines[i], sf::Color::Blue);
            else
                do_draw(window, pl, 64-d, floor_lines[i], sf::Color::Yellow);
        }
        for(line l : wall_lines)
            do_draw(window, pl, 64-d, l, sf::Color::Red);
        window.display();
        window.clear();
    }

}

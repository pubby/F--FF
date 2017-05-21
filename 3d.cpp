#include <cstdint>
#include <cmath>
#include <iostream>
#include <vector>

#include <SFML/Graphics.hpp>

#include "foo.level.hpp"

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

struct line
{
    coord c1;
    coord c2;
    sf::Color color;

    coord& operator[](unsigned i) { return i == 0 ? c1 : c2; }
    coord const& operator[](unsigned i) const { return i == 0 ? c1 : c2; }
};

coord transform(coord player, u8 dir, coord c)
{
    u16 const xx = c.x - player.x;
    u16 const yy = c.y - player.y;

    c.x =  cos_multiply(dir, xx);
    c.x -= sin_multiply(dir, yy);
    c.y =  sin_multiply(dir, xx);
    c.y += cos_multiply(dir, yy);

    //c.x += player.x;
    //c.y += player.y;

    return c;
}

line transform(coord player, u8 dir, line l)
{
    return { transform(player, dir, l[0]), transform(player, dir, l[1]), l.color };
}

coord perspective(coord c)
{
    double d = std::abs(64.0 / (to_signed(c.y)));
    return { to_signed(c.x) * d, (to_signed(c.y) + 64) * d };
}

line perspective(line l)
{
    return { perspective(l[0]), perspective(l[1]), l.color };
}

void draw_line(sf::RenderTarget& rt, line l)
{
    int d = 16;
    int s = 8;
    sf::VertexArray line(sf::LinesStrip, 2);
    line[0].position = sf::Vector2f(to_signed(l[0].x)/s+d, to_signed(l[0].y)/s-32);
    line[1].position = sf::Vector2f(to_signed(l[1].x)/s+d, to_signed(l[1].y)/s-32);
    line[0].color = l.color;
    line[1].color = l.color;
    rt.draw(line);
}

void do_draw(sf::RenderTarget& rt, coord player, u8 dir, line l)
{
    l = transform(player, dir, l);
    double const scale = 256.0;
    int const near = 4;

    double d1 = (scale / (to_signed(l[0].y)));
    if(to_signed(l[0].y) < near)
    {
        if(to_signed(l[1].y) < near)
            return;
        // find the intersection
        double t = to_signed(l[0].y) - near;
        t /= (double)(to_signed(l[0].y - l[1].y));
        l[0].x = to_signed(l[1].x) * t + to_signed(l[0].x) * (1.0 - t);
        l[0].y = near;
        d1 = scale / near;
    }

    double d2 = (scale / (to_signed(l[1].y)));
    if(to_signed(l[1].y) < near)
    {
        // find the intersection
        double t = to_signed(l[1].y) - near;
        t /= (double)(to_signed(l[1].y - l[0].y));
        l[1].x = to_signed(l[0].x) * t + to_signed(l[1].x) * (1.0 - t);
        l[1].y = near;
        d2 = scale / near;
    }

    line dl1 = l;
    line dl2 = l;
    line dl3 = l;
    line dl4 = l;

    dl1[0] = { to_signed(l[0].x) * d1, (to_signed(l[0].y) + 32) * d1 };
    dl1[1] = { to_signed(l[1].x) * d2, (to_signed(l[1].y) + 32) * d2 };
    dl1.color = l.color;

    dl2[0] = { to_signed(l[0].x) * d1, (to_signed(l[0].y) + 16) * d1 };
    dl2[1] = { to_signed(l[1].x) * d2, (to_signed(l[1].y) + 16) * d2 };
    dl2.color = l.color;

    dl3[0] = dl1[0];
    dl3[1] = dl2[0];
    dl3.color = l.color;

    dl4[0] = dl1[1];
    dl4[1] = dl2[1];
    dl4.color = l.color;

    draw_line(rt, dl1);
    if(l.color != sf::Color::Yellow)
    {
        draw_line(rt, dl2);
        //draw_line(rt, dl3);
        //draw_line(rt, dl4);
    }
}

int main()
{
    std::vector<line> lines;
    for(unsigned i = 0; i != track_size; ++i)
    {
        unsigned j = (i + 1) % track_size;
        lines.push_back({{ ltx[i]/3, lty[i]/3 }, { ltx[j]/3, lty[j]/3 }, sf::Color::Red});
        lines.push_back({{ rtx[i]/3, rty[i]/3 }, { rtx[j]/3, rty[j]/3 }, sf::Color::Red});
        lines.push_back({{ ltx[i]/3, lty[i]/3 }, { rtx[i]/3, rty[i]/3 }, sf::Color::Yellow});
    }
    std::cout << lines.size() << std::endl;

    sf::RenderWindow window(sf::VideoMode(64, 44), "SFML window");
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
                break;
            default:
                break;
            }
        }

        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Up))
        {
            pl.x += cos_multiply(d, 16);
            pl.y += sin_multiply(d, 16);
        }
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Down))
        {
            pl.x -= cos_multiply(d, 16);
            pl.y -= sin_multiply(d, 16);
        }
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Left))
            d += 4;
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Right))
            d -= 4;

        for(line l : lines)
            do_draw(window, pl, 64-d, l);
            //draw_line(window, (transform(pl, 192-d, l)));
            //draw_line(window, perspective(transform(pl, 192-d, l)));
        window.display();
        window.clear();
    }

}

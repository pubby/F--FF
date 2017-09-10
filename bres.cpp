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

struct coord
{
    int x;
    int y;
};

using line = std::array<coord, 2>;

void draw_line(sf::RenderTarget& rt, coord a, coord b)
{
    sf::VertexArray line(sf::LinesStrip, 2);
    line[0].position = sf::Vector2f(a.x, a.y);
    line[1].position = sf::Vector2f(b.x, b.y);
    line[0].color = sf::Color::Red;
    line[1].color = sf::Color::Red;
    rt.draw(line);
}


std::array<std::array<bool, 32>, 32> pixels;

void bres(coord a, coord b)
{
    pixels = {};
    if(a.x > b.x)
        return;
    if(a.y > b.y)
        return;
    int dx = (b.x / 8 - a.x / 8) * 8;
    int dy = b.y - a.y;
    int mod = 7 - a.y % 8;
    int D = -((dx * mod) / 8);

    a.x /= 8;
    a.y /= 8;
    b.x /= 8;
    b.y /= 8;

    while(a.x != b.x)
    {
        pixels[a.y][a.x] = true;
        D += dy;
        if(D > 0)
        {
            D -= dx;
            a.y += 1;
        }
        a.x += 1;
    }
    pixels[a.y][a.x] = true;
}

int bres2(coord a, coord b)
{
    pixels = {};
    if(a.x >= b.x)
        return 0;
    if(a.y >= b.y)
        return 0;
    //int dx = (b.x / 8 - a.x / 8) * 8;
    int dx = b.x - a.x;
    int dy = b.y - a.y;
    int mod = (a.x % 8);
    //int D = -((dx * mod) / 8);

    int in = ((4 - mod) * dy / dx) + (a.y % 8);
    std::printf("%i\n", in);
    //dy = b.y - ((a.y / 8) * 8 + in);
    dx = (b.x / 8 - a.x / 8) * 8;
    int D = ((7 - in) * dx) / 8;

    //int D = mod * dy / 8;

    a.x /= 8;
    a.y /= 8;
    b.x /= 8;
    b.y /= 8;

    while(a.x != b.x)
    {
        pixels[a.y][a.x] = true;
        D -= dy;
        if(D < 0)
        {
            D += dx;
            a.y += 1;
        }
        a.x += 1;
    }
    pixels[a.y][a.x] = true;
    return in;
}

int main()
{
    sf::RenderWindow window(sf::VideoMode(256, 256), "SFML window");
    window.setFramerateLimit(30);

    coord a = {};
    coord b = {};

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
            b.y -= 1;
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Down))
            b.y += 1;
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Left))
            b.x -= 1;
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Right))
            b.x += 1;

        if(sf::Keyboard::isKeyPressed(sf::Keyboard::W))
            a.y -= 1;
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::R))
            a.y += 1;
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::A))
            a.x -= 1;
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::S))
            a.x += 1;

        int in = bres2(a, b);
        for(unsigned y = 0; y != 32; ++y)
        for(unsigned x = 0; x != 32; ++x)
        {
            sf::RectangleShape r;
            r.setSize(sf::Vector2f(8.0, 8.0));
            r.setPosition(sf::Vector2f(x*8.0, y*8.0));
            if(!pixels[y][x])
                r.setFillColor(sf::Color::Black);
            r.setOutlineColor(sf::Color::Cyan);
            r.setOutlineThickness(1.0f);
            window.draw(r);
        }

        draw_line(window, a, b);

        sf::RectangleShape r;
        r.setSize(sf::Vector2f(1.0, 1.0));
        r.setPosition(sf::Vector2f(a.x / 8 + 4, a.y / 8 + in));
        r.setFillColor(sf::Color::Blue);
        window.draw(r);

        window.display();
        window.clear();
    }

}

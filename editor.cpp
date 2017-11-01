#include <cstdint>
#include <cmath>
#include <iostream>
#include <vector>

#include <SFML/Graphics.hpp>

float segment_length = 24.0f;
constexpr float quarter_angle = 1.57079632679f;
constexpr float turn_increment = quarter_angle * 0.1;

constexpr unsigned char TF_BLANK = 1 << 0;
constexpr unsigned char TF_JUMP = 1 << 1;

struct segment_t
{
    float angle;
    float wl = 5.0f;
    float wr = 5.0f;
    unsigned char flags = 0;
};

struct node_t
{
    float x;
    float y;
};

struct editor
{
    unsigned active_index = 0;
    std::vector<segment_t> segments;

    editor() : active_index(0) {}

    segment_t const& active_segment() const { return segments[active_index]; }
    segment_t& active_segment() { return segments[active_index]; }

    void add()
    {
        if(segments.size() >= 256)
            return;
        segment_t s = active_segment();
        s.angle = 0.0f;
        segments.insert(segments.begin() + active_index + 1, s);
        ++active_index;
    }

    void remove()
    {
        if(segments.size() <= 1)
            return;
        segments.erase(segments.begin() + active_index);
        active_index = (active_index + segments.size() - 1) % segments.size();
    }

    void select_next() { active_index = (active_index + 1) % segments.size(); }
    void select_prev() { active_index = (active_index + segments.size() - 1) % segments.size(); }

    std::pair<std::vector<node_t>, std::vector<node_t>> get_nodes() const
    {
        std::pair<std::vector<node_t>, std::vector<node_t>> ret;
        float angle = 0.0f;
        node_t n = { 256.0f, 256.0f };
        node_t l;
        node_t r;
        for(segment_t const& s : segments)
        {
            n.x += std::cos(angle) * segment_length;
            n.y += std::sin(angle) * segment_length;
            l.x = n.x + std::cos(angle + s.angle * 0.5f + quarter_angle) * s.wl;
            l.y = n.y + std::sin(angle + s.angle * 0.5f + quarter_angle) * s.wl;
            r.x = n.x - std::cos(angle + s.angle * 0.5f + quarter_angle) * s.wr;
            r.y = n.y - std::sin(angle + s.angle * 0.5f + quarter_angle) * s.wr;
            angle += s.angle;
            ret.first.push_back(l);
            ret.second.push_back(r);
        }
        return ret;
    }
};

void save(char const* filename, editor const& e)
{
    FILE* fp = std::fopen(filename, "w");
    if(!fp)
        throw std::runtime_error("can't open file");
    for(unsigned i = 0; i != e.segments.size(); ++i)
        std::fprintf(fp, "%f %f %f %i\n", 
                     e.segments[i].angle, 
                     e.segments[i].wl, 
                     e.segments[i].wr,
                     e.segments[i].flags);
    std::fclose(fp);
}

editor load(char const* filename)
{
    editor e;
    FILE* fp = std::fopen(filename, "r");
    if(fp)
    {
        while(true)
        {
            segment_t s = {};
            int const read = std::fscanf(fp, "%f %f %f %i\n", 
               &s.angle, &s.wl, &s.wr, &s.flags);
            if(read <= 0)
                break;
            e.segments.push_back(s);
        }
        std::fclose(fp);
    }
    if(e.segments.empty())
        e.segments.push_back(segment_t{});
    return e;
}


short to_short(float f)
{
    return f * 64;
}

void save_asm(char const* filename, editor const& e)
{
    auto nodes = e.get_nodes();
    std::vector<node_t> const& l_nodes = nodes.second;
    std::vector<node_t> const& r_nodes = nodes.first;

    FILE* fp = std::fopen(filename, "w");
    if(!fp)
        throw std::runtime_error("can't open file");

    std::fprintf(fp, "track_size = %i\n", l_nodes.size());

    std::fprintf(fp, ".segment \"LEVELS\"\n");
    std::fprintf(fp, ".align 256\n");
    std::fprintf(fp, "ltx_lo:\n");
    for(unsigned i = 0; i != 128; ++i)
    {
        std::fprintf(fp, "    .byt .lobyte(%i)\n", 
                     to_short(l_nodes[i % l_nodes.size()].x - 256.0f));
    }
    std::fprintf(fp, "ltx_hi:\n");
    for(unsigned i = 0; i != 128; ++i)
    {
        std::fprintf(fp, "    .byt .hibyte(%i)\n", 
                     to_short(l_nodes[i % l_nodes.size()].x - 256.0f));
    }

    std::fprintf(fp, ".align 256\n");
    std::fprintf(fp, "lty_lo:\n");
    for(unsigned i = 0; i != 128; ++i)
    {
        std::fprintf(fp, "    .byt .lobyte(%i)\n", 
                     to_short(l_nodes[i % l_nodes.size()].y - 256.0f));
    }
    std::fprintf(fp, "lty_hi:\n");
    for(unsigned i = 0; i != 128; ++i)
    {
        std::fprintf(fp, "    .byt .hibyte(%i)\n", 
                     to_short(l_nodes[i % l_nodes.size()].y - 256.0f));
    }

    std::fprintf(fp, ".align 256\n");
    std::fprintf(fp, "rtx_lo:\n");
    for(unsigned i = 0; i != 128; ++i)
    {
        std::fprintf(fp, "    .byt .lobyte(%i)\n", 
                     to_short(r_nodes[i % r_nodes.size()].x - 256.0f));
    }
    std::fprintf(fp, "rtx_hi:\n");
    for(unsigned i = 0; i != 128; ++i)
    {
        std::fprintf(fp, "    .byt .hibyte(%i)\n", 
                     to_short(r_nodes[i % r_nodes.size()].x - 256.0f));
    }

    std::fprintf(fp, ".align 256\n");
    std::fprintf(fp, "rty_lo:\n");
    for(unsigned i = 0; i != 128; ++i)
    {
        std::fprintf(fp, "    .byt .lobyte(%i)\n", 
                     to_short(r_nodes[i % r_nodes.size()].y - 256.0f));
    }
    std::fprintf(fp, "rty_hi:\n");
    for(unsigned i = 0; i != 128; ++i)
    {
        std::fprintf(fp, "    .byt .hibyte(%i)\n", 
                     to_short(r_nodes[i % r_nodes.size()].y - 256.0f));
    }

    std::fprintf(fp, ".segment \"LEVEL_FLAGS\"\n");
    std::fprintf(fp, "tf:\n");
    for(unsigned i = 0; i != 128; ++i)
        std::fprintf(fp, "    .byt %i\n", e.segments[i % e.segments.size()].flags);

    std::fclose(fp);
}

void draw(sf::RenderTarget& rt, editor const& e)
{
    auto nodes = e.get_nodes();
    std::vector<node_t> const& l_nodes = nodes.first;
    std::vector<node_t> const& r_nodes = nodes.second;

    for(unsigned i = 0; i != l_nodes.size(); ++i)
    {
        sf::VertexArray line(sf::LinesStrip, 2);
        line[0].position = sf::Vector2f(l_nodes[i].x, l_nodes[i].y);
        line[1].position = sf::Vector2f(r_nodes[i].x, r_nodes[i].y);
        if(e.segments[i].flags & TF_BLANK)
        {
            line[0].color = sf::Color(40, 40, 40);
            line[1].color = sf::Color(40, 40, 40);
        }
        else if(e.segments[i].flags & TF_JUMP)
        {
            line[0].color = sf::Color(80, 80, 80);
            line[1].color = sf::Color(80, 80, 80);
        }
        else
        {
            line[0].color = sf::Color::Yellow;
            line[1].color = sf::Color::Yellow;
        }
        rt.draw(line);
    }

    for(unsigned i = 0; i != l_nodes.size(); ++i)
    {
        unsigned j = (i + 1) % l_nodes.size();

        sf::VertexArray line(sf::LinesStrip, 2);
        line[0].position = sf::Vector2f(l_nodes[i].x, l_nodes[i].y);
        line[1].position = sf::Vector2f(l_nodes[j].x, l_nodes[j].y);
        line[0].color = sf::Color::Blue;
        line[1].color = sf::Color::Blue;
        rt.draw(line);
        line[0].position = sf::Vector2f(r_nodes[i].x, r_nodes[i].y);
        line[1].position = sf::Vector2f(r_nodes[j].x, r_nodes[j].y);
        rt.draw(line);
    }

    for(unsigned i = 0; i != l_nodes.size(); ++i)
    {
        sf::RectangleShape c;
        c.setSize({2.0f, 2.0f});
        c.setPosition(l_nodes[i].x - 1.0f, l_nodes[i].y - 1.0f);
        if(i == e.active_index)
            c.setFillColor(sf::Color::Red);
        rt.draw(c);

        c.setPosition(r_nodes[i].x - 1.0f, r_nodes[i].y - 1.0f);
        c.setFillColor(sf::Color::White);
        if(i == e.active_index)
            c.setFillColor(sf::Color::Red);
        rt.draw(c);
    }
}

int main(int argc, char** argv)
{
    if(argc != 2)
    {
        std::fprintf(stderr, "usage: %s [file]\n", argv[0]);
        return EXIT_FAILURE;
    }
    
    editor e = load(argv[1]);

    sf::RenderWindow window(sf::VideoMode(800, 800), "Track Editor");
    window.setFramerateLimit(60);

    while(true)
    {
        sf::Event event;
        while(window.pollEvent(event)) 
        {
            switch(event.type)
            {
            case sf::Event::Closed:
                window.close();
                return 0;
            case sf::Event::KeyPressed:
                switch(event.key.code)
                {
                case sf::Keyboard::Insert:
                    e.add();
                    break;
                case sf::Keyboard::Delete:
                    e.remove();
                    break;
                case sf::Keyboard::Home:
                    e.active_index = 0;
                    break;
                case sf::Keyboard::PageUp:
                    e.select_next();
                    break;
                case sf::Keyboard::PageDown:
                    e.select_prev();
                    break;
                case sf::Keyboard::F5:
                    save(argv[1], e);
                    break;
                case sf::Keyboard::F6:
                    save_asm((std::string(argv[1]) + ".inc").c_str(), e);
                    break;
                case sf::Keyboard::F7:
                    e = load(argv[1]);
                    break;
                case sf::Keyboard::Left:
                    e.active_segment().angle -= turn_increment;
                    break;
                case sf::Keyboard::Right:
                    e.active_segment().angle += turn_increment;
                    break;
                case sf::Keyboard::Num1:
                    e.active_segment().wl -= 1;
                    break;
                case sf::Keyboard::Num2:
                    e.active_segment().wl += 1;
                    break;
                case sf::Keyboard::Num3:
                    e.active_segment().wr -= 1;
                    break;
                case sf::Keyboard::Num4:
                    e.active_segment().wr += 1;
                    break;
                case sf::Keyboard::Num0:
                    e.active_segment().wl = 5.0f;
                    e.active_segment().wr = 5.0f;
                    break;
                case sf::Keyboard::Num5:
                    e.active_segment().flags &= ~TF_BLANK;
                    e.active_segment().flags ^= TF_JUMP;
                    break;
                case sf::Keyboard::Num6:
                    e.active_segment().flags &= ~TF_JUMP;
                    e.active_segment().flags ^= TF_BLANK;
                    break;
                case sf::Keyboard::Num7:
                    segment_length -= 1.0f;
                    break;
                case sf::Keyboard::Num8:
                    segment_length += 1.0f;
                    break;
                case sf::Keyboard::Num9:
                    segment_length = 24.0f;
                    break;
                }
                break;
            default:
                break;
            }
        }

        draw(window, e);
        window.display();
        window.clear();
    }

}

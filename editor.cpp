#include <cstdint>
#include <cmath>
#include <iostream>
#include <vector>

#include <SFML/Graphics.hpp>

struct node_t
{
    float x;
    float y;
};

struct editor
{
    unsigned active_index = 0;
    std::vector<node_t> l_nodes;
    std::vector<node_t> r_nodes;

    editor() : active_index(0) {}

    node_t const& active_l() const { return l_nodes[active_index]; }
    node_t& active_l() { return l_nodes[active_index]; }
    node_t const& active_r() const { return r_nodes[active_index]; }
    node_t& active_r() { return r_nodes[active_index]; }

    node_t const& active_node() const
    {
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::LControl))
            return active_r();
        return active_l();
    }

    node_t& active_node() 
    {
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::LControl))
            return active_r();
        return active_l();
    }

    void add()
    {
        if(l_nodes.size() >= 256)
            return;
        l_nodes.insert(l_nodes.begin() + active_index + 1, active_l());
        r_nodes.insert(r_nodes.begin() + active_index + 1, active_r());
        ++active_index;
    }

    void remove()
    {
        if(l_nodes.size() <= 1)
            return;
        l_nodes.erase(l_nodes.begin() + active_index);
        r_nodes.erase(r_nodes.begin() + active_index);
        active_index = (active_index + l_nodes.size() - 1) % l_nodes.size();
    }

    void select_next() { active_index = (active_index + 1) % l_nodes.size(); }
    void select_prev() { active_index = (active_index + l_nodes.size() - 1) % l_nodes.size(); }
};

void save(char const* filename, editor const& e)
{
    FILE* fp = std::fopen(filename, "w");
    if(!fp)
        throw std::runtime_error("can't open file");
    for(unsigned i = 0; i != e.l_nodes.size(); ++i)
        std::fprintf(fp, "%f %f %f %f\n", e.l_nodes[i].x, e.l_nodes[i].y, e.r_nodes[i].x, e.r_nodes[i].y);
    std::fclose(fp);
}

short to_short(float f)
{
    return (f - 256.0f) * 64;
}

void save_cpp(char const* filename, editor const& e)
{
    FILE* fp = std::fopen(filename, "w");
    if(!fp)
        throw std::runtime_error("can't open file");

    std::fprintf(fp, "constexpr unsigned track_size = %i;\n", e.l_nodes.size());
    std::fprintf(fp, "constexpr short ltx[] =\n{\n");
    for(unsigned i = 0; i != e.l_nodes.size(); ++i)
        std::fprintf(fp, "    %i%s\n", to_short(e.l_nodes[i].x), i == e.l_nodes.size() - 1 ? "" : ",");
    std::fprintf(fp, "};\n");

    std::fprintf(fp, "constexpr short lty[] =\n{\n");
    for(unsigned i = 0; i != e.l_nodes.size(); ++i)
        std::fprintf(fp, "    %i%s\n", to_short(e.l_nodes[i].y), i == e.l_nodes.size() - 1 ? "" : ",");
    std::fprintf(fp, "};\n");

    std::fprintf(fp, "constexpr short rtx[] =\n{\n");
    for(unsigned i = 0; i != e.r_nodes.size(); ++i)
        std::fprintf(fp, "    %i%s\n", to_short(e.r_nodes[i].x), i == e.r_nodes.size() - 1 ? "" : ",");
    std::fprintf(fp, "};\n");

    std::fprintf(fp, "constexpr short rty[] =\n{\n");
    for(unsigned i = 0; i != e.r_nodes.size(); ++i)
        std::fprintf(fp, "    %i%s\n", to_short(e.r_nodes[i].y), i == e.r_nodes.size() - 1 ? "" : ",");
    std::fprintf(fp, "};\n");

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
            node_t l, r;
            if(std::fscanf(fp, "%f %f %f %f\n", &l.x, &l.y, &r.x, &r.y) < 4)
                break;
            e.l_nodes.push_back(l);
            e.r_nodes.push_back(r);
        }
        std::fclose(fp);
    }
    if(e.l_nodes.empty())
    {
        e.l_nodes.push_back(node_t{ 246.0f, 256.0f });
        e.r_nodes.push_back(node_t{ 266.0f, 256.0f });
    }
    return e;
}

void draw(sf::RenderTarget& rt, editor const& e)
{
    for(unsigned i = 0; i != e.l_nodes.size(); ++i)
    {
        sf::VertexArray line(sf::LinesStrip, 2);
        line[0].position = sf::Vector2f(e.l_nodes[i].x, e.l_nodes[i].y);
        line[1].position = sf::Vector2f(e.r_nodes[i].x, e.r_nodes[i].y);
        line[0].color = sf::Color::Yellow;
        line[1].color = sf::Color::Yellow;
        rt.draw(line);
    }

    for(unsigned i = 0; i != e.l_nodes.size(); ++i)
    {
        unsigned j = (i + 1) % e.l_nodes.size();

        sf::VertexArray line(sf::LinesStrip, 2);
        line[0].position = sf::Vector2f(e.l_nodes[i].x, e.l_nodes[i].y);
        line[1].position = sf::Vector2f(e.l_nodes[j].x, e.l_nodes[j].y);
        line[0].color = sf::Color::Blue;
        line[1].color = sf::Color::Blue;
        rt.draw(line);
        line[0].position = sf::Vector2f(e.r_nodes[i].x, e.r_nodes[i].y);
        line[1].position = sf::Vector2f(e.r_nodes[j].x, e.r_nodes[j].y);
        rt.draw(line);
    }

    for(unsigned i = 0; i != e.l_nodes.size(); ++i)
    {
        sf::RectangleShape c;
        c.setSize({2.0f, 2.0f});
        c.setPosition(e.l_nodes[i].x - 1.0f, e.l_nodes[i].y - 1.0f);
        if(&e.l_nodes[i] == &e.active_node())
            c.setFillColor(sf::Color::Red);
        rt.draw(c);

        c.setPosition(e.r_nodes[i].x - 1.0f, e.r_nodes[i].y - 1.0f);
        c.setFillColor(sf::Color::White);
        if(&e.r_nodes[i] == &e.active_node())
            c.setFillColor(sf::Color::Red);
        rt.draw(c);
    }
}

float move_speed()
{
    if(sf::Keyboard::isKeyPressed(sf::Keyboard::LShift))
        return 4.0f;
    if(sf::Keyboard::isKeyPressed(sf::Keyboard::RShift))
        return 4.0f;
    return 0.5f;
}

int main(int argc, char** argv)
{
    if(argc != 2)
    {
        std::fprintf(stderr, "usage: %s [file]\n", argv[0]);
        return EXIT_FAILURE;
    }
    
    editor e = load(argv[1]);

    sf::RenderWindow window(sf::VideoMode(512, 512), "Track Editor");
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
                case sf::Keyboard::End:
                    e.active_index = e.l_nodes.size() - 1;
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
                    save_cpp((std::string(argv[1]) + ".hpp").c_str(), e);
                    break;
                case sf::Keyboard::F7:
                    e = load(argv[1]);
                    break;
                }
                break;
            default:
                break;
            }
        }

        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Up))
            e.active_node().y -= move_speed();
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Down))
            e.active_node().y += move_speed();
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Left))
            e.active_node().x -= move_speed();
        if(sf::Keyboard::isKeyPressed(sf::Keyboard::Right))
            e.active_node().x += move_speed();

        draw(window, e);
        window.display();
        window.clear();
    }

}

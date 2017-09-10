#include <algorithm>
#include <iostream>
#include <string>
#include <climits>
#include <vector>

enum point
{
    __,
    NW,
    NE,
    SW,
    SE,
};

struct thing
{
    point a;
    point b;

    bool operator==(thing o) const { return a == o.a && b == o.b; }
    bool operator<(thing o) const 
    { 
        if(a == o.a)
            return b < o.b;
        return a < o.a;
    }

    int cost(thing o) const
    {
        if(*this == thing{NW, __} && o == thing{NW,SW})
            return 15;
        if(*this == thing{NW, __} && o == thing{NW,SE})
            return 15;
        if(*this == thing{__, SW} && o == thing{NW,__})
            return 15;
        if(*this == thing{__, SW} && o == thing{NE,__})
            return 15;

        if(*this == thing{NE, __} && o == thing{NE,SE})
            return 15;
        if(*this == thing{NE, __} && o == thing{__,SW})
            return 15;

        if(*this == thing{NW, SW} && o == thing{NW,__})
            return 15;
        if(*this == thing{NW, SW} && o == thing{NE,__})
            return 15;

        if(*this == thing{NW, SE} && o == thing{NE,__})
            return 15;
        if(*this == thing{NW, SE} && o == thing{NW,__})
            return 15;

        return 0;
    }

    std::string print() const
    {
        std::string ret;
        switch(a)
        {
        case __: ret += "__"; break;
        case NW: ret += "NW"; break;
        case NE: ret += "NE"; break;
        case SW: ret += "SW"; break;
        case SE: ret += "SE"; break;
        }
        ret += "x";
        switch(b)
        {
        case __: ret += "__"; break;
        case NW: ret += "NW"; break;
        case NE: ret += "NE"; break;
        case SW: ret += "SW"; break;
        case SE: ret += "SE"; break;
        }
        return ret;
    }
};

int main()
{
    std::vector<thing> things;
    things.push_back({NW, __});
    things.push_back({NW, SW});
    things.push_back({NW, SE});
    things.push_back({NE, __});
    things.push_back({NE, SE});
    things.push_back({__, SW});
    std::sort(things.begin(), things.end());

    int best_cost = 0;
    std::vector<thing> best;

    do 
    {
        int cost = 0;
        for(int i = 0; i < 6; ++i)
            cost += things[i].cost(things[(i+1) % 6]);
        if(cost > best_cost)
        {
            best_cost = cost;
            best = things;
        }
    } 
    while(std::next_permutation(things.begin(), things.end()));

    std::cout << "best: " << best_cost << std::endl;
    for(thing t : best)
        std::cout << t.print() << std::endl;
}


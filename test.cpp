#include <cstdio>
#include <cmath>

int scale(int x1, int y1, int x2, int y2)
{
    long long num = -y1 << 8;
    long long den = (y2 - y1) << 8;

    long long xv = x1;
    long long xd = (x2 - x1);
    std::printf("xd: %i %i %i\n",  xd, num, den);

    //while(num > (1 << 8))
    //while(xd > 0)
    for(int i = 0; i < 32; ++i)
    {
        //int carry = xd & 1;
        int carry = 0;
        den >>= 1;
        xd >>= 1;
        if(den <= num)
        {
            num -= den;
            xv += xd + carry;
        }
    }
    return xv;
}

int main()
{
    int i = 0;
    int j = -300;
    int k = 10;
    int l = 20;
    int a = scale(i, j, k, l);
    double d = ((-j) / double(l - j));
    short b = i + d * (k - i);
    std::printf(" %i %i\n", a, b);
    /*
    for(int i = 0; i < 3000; i += 500)
    for(int j = 0; j < 30000; j += 5000)
    for(int k = 0; k < 3000; k += 500)
    for(int l = 0; l < 30000; l += 5000)
    {
        //std::printf("%i %i %i %i\n", i, j, k, l);
        //if(a != b)
            //std::printf("%i %i %i %i:\n", i, j, k, l);
        int a = scale(-i, -j, k, l);
        double d = ((j) / double(j + l));
        short b = d * k - (1.0 - d) * i;
            std::printf(" %i %i\n", a, b);
    }
    */
}

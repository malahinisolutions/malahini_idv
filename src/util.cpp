#include "util.h"

std::vector<unsigned char> ParseHex(const char* psz)
{
    // convert hex dump to vector
    std::vector<unsigned char> vch;
    while (true)
    {
        while (isspace(*psz))
            psz++;
        signed char c = phexdigit[(unsigned char)*psz++];
        if (c == (signed char)-1)
            break;
        unsigned char n = (c << 4);
        c = phexdigit[(unsigned char)*psz++];
        if (c == (signed char)-1)
            break;
        n |= c;
        vch.push_back(n);
    }
    return vch;
}

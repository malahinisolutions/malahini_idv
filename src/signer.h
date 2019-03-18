#ifndef SIGNER_H
#define SIGNER_H
#include <openssl/ecdsa.h>
#include <openssl/obj_mac.h>
#include <openssl/ec.h>
#include <openssl/err.h>

#include <string>
#include <vector>
#include "uint256.h"

class Signer
{
private:
    EC_KEY* pkey;
public:
    bool fSet;
    Signer(std::vector<unsigned char>& vchPrivKey);
    bool Sign(uint256 hash, std::vector<unsigned char>& vchSig);
};

#endif // SIGNER_H

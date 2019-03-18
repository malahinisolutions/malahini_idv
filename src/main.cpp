#include <iostream>
#include <string>
#include <vector>
#include "signer.h"
#include "util.h"
#include "uint256.h"
#include "json/json_spirit_reader_template.h"
#include "json/json_spirit_writer_template.h"
#include "json/json_spirit_utils.h"

json_spirit::Value GetJsonError(std::string strError){
    json_spirit::Object result;
    result.push_back(json_spirit::Pair("result", false));
    result.push_back(json_spirit::Pair("error", strError));
    return result;
}

json_spirit::Value GetJsonSuccess(std::string strSign){
    json_spirit::Object result;
    result.push_back(json_spirit::Pair("result", true));
    result.push_back(json_spirit::Pair("signature", strSign));
    return result;
}

int main(int argc, char *argv[])
{
    if (argc < 3){
        std::cout << json_spirit::write_string(GetJsonError("Not enough args"), false) << std::endl;
        return 1;
    }
    std::vector<unsigned char> vchKey = ParseHex(argv[2]);
    Signer signer(vchKey);
    if (!signer.fSet){
        std::cout << json_spirit::write_string(GetJsonError("Invalid private key"), false) << std::endl;
        return 2;
    }
    std::vector <unsigned char> vchSign;
    uint256 hash;
    hash.SetHex(argv[1]);
    if(signer.Sign(hash, vchSign)){
        std::cout << json_spirit::write_string(GetJsonSuccess(HexStr(vchSign)), false) << std::endl;
        return 0;
    } else {
        std::cout << json_spirit::write_string(GetJsonError("Failed to sign"), false) << std::endl;
        return 3;
    }



    return 0;
}


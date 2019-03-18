#include "signer.h"
#include <iostream>
#include "util.h"

bool fSet = false;

typedef struct {
    int        field_type,     /* either NID_X9_62_prime_field or
                         * NID_X9_62_characteristic_two_field */
        seed_len,
        param_len;
    unsigned int cofactor;     /* promoted to BN_ULONG */
} EC_CURVE_DATA;

static const struct { EC_CURVE_DATA h; unsigned char data[0+32*6]; }
    _EC_SECG_PRIME_256K1 = {
        { NID_X9_62_prime_field,0,32,1 },
        {                                                      /* no seed */
            0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF, /* p */
            0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
            0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFE,0xFF,0xFF,
            0xFC,0x2F,
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00, /* a */
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x00,
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00, /* b */
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
            0x00,0x07,
            0x79,0xBE,0x66,0x7E,0xF9,0xDC,0xBB,0xAC,0x55,0xA0, /* x */
            0x62,0x95,0xCE,0x87,0x0B,0x07,0x02,0x9B,0xFC,0xDB,
            0x2D,0xCE,0x28,0xD9,0x59,0xF2,0x81,0x5B,0x16,0xF8,
            0x17,0x98,
            0x48,0x3a,0xda,0x77,0x26,0xa3,0xc4,0x65,0x5d,0xa4, /* y */
            0xfb,0xfc,0x0e,0x11,0x08,0xa8,0xfd,0x17,0xb4,0x48,
            0xa6,0x85,0x54,0x19,0x9c,0x47,0xd0,0x8f,0xfb,0x10,
            0xd4,0xb8,
            0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,0xFF, /* order */
            0xFF,0xFF,0xFF,0xFF,0xFF,0xFE,0xBA,0xAE,0xDC,0xE6,
            0xAF,0x48,0xA0,0x3B,0xBF,0xD2,0x5E,0x8C,0xD0,0x36,
            0x41,0x41 }
    };

static EC_GROUP *ec_group_new_from_data(const EC_CURVE_DATA *data)
{
    EC_GROUP *group=NULL;
    EC_POINT *P=NULL;
    BN_CTX      *ctx=NULL;
    BIGNUM      *p=NULL, *a=NULL, *b=NULL, *x=NULL, *y=NULL, *order=NULL;
    int         ok=0;
    int         seed_len,param_len;
    const unsigned char *params;

    if ((ctx = BN_CTX_new()) == NULL) {
        ECerr(EC_F_EC_GROUP_NEW_FROM_DATA, ERR_R_MALLOC_FAILURE);
        goto err;
    }

    seed_len  = data->seed_len;
    param_len = data->param_len;
    params       = (const unsigned char *)(data+1);    /* skip header */
    params      += seed_len;                           /* skip seed   */

    if (!(p = BN_bin2bn(params+0*param_len, param_len, NULL))
        || !(a = BN_bin2bn(params+1*param_len, param_len, NULL))
        || !(b = BN_bin2bn(params+2*param_len, param_len, NULL))) {
        ECerr(EC_F_EC_GROUP_NEW_FROM_DATA, ERR_R_BN_LIB);
        goto err;
    }

    if ((group = EC_GROUP_new_curve_GFp(p, a, b, ctx)) == NULL) {
        ECerr(EC_F_EC_GROUP_NEW_FROM_DATA, ERR_R_EC_LIB);
        goto err;
    }

    if ((P = EC_POINT_new(group)) == NULL) {
        ECerr(EC_F_EC_GROUP_NEW_FROM_DATA, ERR_R_EC_LIB);
        goto err;
    }

    if (!(x = BN_bin2bn(params+3*param_len, param_len, NULL))
        || !(y = BN_bin2bn(params+4*param_len, param_len, NULL))) {
        ECerr(EC_F_EC_GROUP_NEW_FROM_DATA, ERR_R_BN_LIB);
        goto err;
    }
    if (!EC_POINT_set_affine_coordinates_GFp(group, P, x, y, ctx)) {
        ECerr(EC_F_EC_GROUP_NEW_FROM_DATA, ERR_R_EC_LIB);
        goto err;
    }
    if (!(order = BN_bin2bn(params+5*param_len, param_len, NULL))
        || !BN_set_word(x, (BN_ULONG)data->cofactor))
    {
        ECerr(EC_F_EC_GROUP_NEW_FROM_DATA, ERR_R_BN_LIB);
        goto err;
    }
    if (!EC_GROUP_set_generator(group, P, order, x)) {
        ECerr(EC_F_EC_GROUP_NEW_FROM_DATA, ERR_R_EC_LIB);
        goto err;
    }
    if (seed_len) {
        if (!EC_GROUP_set_seed(group, params-seed_len, seed_len)) {
            ECerr(EC_F_EC_GROUP_NEW_FROM_DATA, ERR_R_EC_LIB);
            goto err;
        }
    }
    ok=1;
err:
    if (!ok) {
        EC_GROUP_free(group);
        group = NULL;
    }
    if (P)
        EC_POINT_free(P);
    if (ctx)
        BN_CTX_free(ctx);
    if (p)
        BN_free(p);
    if (a)
        BN_free(a);
    if (b)
        BN_free(b);
    if (order)
        BN_free(order);
    if (x)
        BN_free(x);
    if (y)
        BN_free(y);
    return group;
}

EC_GROUP *EC_GROUP_new_by_curve_name_NID_secp256k1(void)
{
    static EC_GROUP *group = NULL;

    if (group == NULL) {
#ifdef HAVE_NID_SECP256K1
        group = EC_GROUP_new_by_curve_name(NID_secp256k1);
#else
        group = ec_group_new_from_data(&_EC_SECG_PRIME_256K1.h);
#endif
    }

    return group;
}

EC_KEY *EC_KEY_new_by_curve_name_NID_secp256k1(void)
{
    EC_KEY *ret = NULL;
    EC_GROUP *group = EC_GROUP_new_by_curve_name_NID_secp256k1();

    if (group == NULL)
        return NULL;

    ret = EC_KEY_new();

    if (ret == NULL)
        return NULL;

    EC_KEY_set_group(ret, group);

    return ret;
}

int EC_KEY_regenerate_key(EC_KEY *eckey, BIGNUM *priv_key)
{
    int ok = 0;
    BN_CTX *ctx = NULL;
    EC_POINT *pub_key = NULL;

    if (!eckey) return 0;

    const EC_GROUP *group = EC_KEY_get0_group(eckey);

    if ((ctx = BN_CTX_new()) == NULL)
        goto err;

    pub_key = EC_POINT_new(group);

    if (pub_key == NULL)
        goto err;

    if (!EC_POINT_mul(group, pub_key, priv_key, NULL, NULL, ctx))
        goto err;

    EC_KEY_set_private_key(eckey,priv_key);
    EC_KEY_set_public_key(eckey,pub_key);

    ok = 1;

err:

    if (pub_key)
        EC_POINT_free(pub_key);
    if (ctx != NULL)
        BN_CTX_free(ctx);

    return(ok);
}

Signer::Signer(std::vector<unsigned char> &vchPrivKey)
{
    pkey = pkey = EC_KEY_new_by_curve_name_NID_secp256k1();;
    if (pkey != NULL){
        if (vchPrivKey.size() == 32){
            BIGNUM *bn = BN_bin2bn(&vchPrivKey[0],32,BN_new());
            if (bn != NULL){
                if (EC_KEY_regenerate_key(pkey,bn))
                {
                    fSet = true;
                }
            }
            BN_clear_free(bn);
        }
    }
}

bool Signer::Sign(uint256 hash, std::vector<unsigned char> &vchSig)
{
    vchSig.clear();
    ECDSA_SIG *sig = ECDSA_do_sign((unsigned char*)&hash, sizeof(hash), pkey);
    if (sig == NULL)
        return false;
    BN_CTX *ctx = BN_CTX_new();
    BN_CTX_start(ctx);
    const EC_GROUP *group = EC_KEY_get0_group(pkey);
    BIGNUM *order = BN_CTX_get(ctx);
    BIGNUM *halforder = BN_CTX_get(ctx);
    EC_GROUP_get_order(group, order, ctx);
    BN_rshift1(halforder, order);
    if (BN_cmp(sig->s, halforder) > 0) {
        // enforce low S values, by negating the value (modulo the order) if above order/2.
        BN_sub(sig->s, order, sig->s);
    }
    BN_CTX_end(ctx);
    BN_CTX_free(ctx);
    unsigned int nSize = ECDSA_size(pkey);
    vchSig.resize(nSize); // Make sure it is big enough
    unsigned char *pos = &vchSig[0];
    nSize = i2d_ECDSA_SIG(sig, &pos);
    ECDSA_SIG_free(sig);
    vchSig.resize(nSize); // Shrink to fit actual size
    return true;
}

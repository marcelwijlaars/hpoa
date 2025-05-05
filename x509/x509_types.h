
typedef struct asn1_string_st ASN1_BIT_STRING;
typedef struct asn1_string_st ASN1_OCTET_STRING;
typedef struct asn1_string_st ASN1_INTEGER;
typedef struct asn1_string_st ASN1_TIME;
typedef struct asn1_string_st ASN1_UTF8STRING;
typedef struct asn1_object_st ASN1_OBJECT;
typedef struct asn1_type_st asn1_type_st;
typedef struct asn1_type_st ASN1_TYPE;

typedef struct ASN1_ENCODING_st ASN1_ENCODING_st;
typedef struct ASN1_ENCODING_st ASN1_ENCODING;

typedef struct x509_cinf_st X509_CINF;
typedef struct x509_st x509_st;
typedef struct x509_st X509;

typedef struct X509_algor_st X509_ALGOR;
typedef struct X509_name_st X509_name_st;
typedef struct X509_name_st X509_NAME;
typedef struct X509_pubkey_st X509_pubkey_st;
typedef struct X509_pubkey_st X509_PUBKEY;
typedef struct X509_val_st X509_val_st;
typedef struct X509_val_st X509_VAL;
typedef struct X509_POLICY_CACHE_st X509_POLICY_CACHE;

typedef struct crypto_ex_data_st CRYPTO_EX_DATA;


typedef struct stack_st_X509_EXTENSION stack_st_X509_EXTENSION;
typedef struct stack_st_GENERAL_NAME GENERAL_NAMES;
typedef struct stack_st_ASN1_OBJECT stack_st_ASN1_OBJECT;
typedef struct stack_st _STACK;


typedef struct evp_pkey_st evp_pkey_st;
typedef struct evp_pkey_st EVP_PKEY;

typedef struct env_md_st env_md_st;
typedef struct env_md_st EVP_MD;

typedef struct env_md_ctx_st env_md_ctx_st;
typedef struct env_md_ctx_st EVP_MD_CTX;

typedef struct evp_pkey_asn1_method_st evp_pkey_asn1_method_st;
typedef struct evp_pkey_asn1_method_st EVP_PKEY_ASN1_METHOD;

typedef struct bio_st bio_st;
typedef struct bio_st BIO;
typedef struct bio_method_st bio_method_st;
typedef struct bio_method_st BIO_METHOD;



typedef struct engine_st engine_st;
typedef struct engine_st ENGINE;

typedef struct AUTHORITY_KEYID_st AUTHORITY_KEYID_st;
typedef struct AUTHORITY_KEYID_st AUTHORITY_KEYID;

typedef struct NAME_CONSTRAINTS_st NAME_CONSTRAINTS_st;
typedef struct NAME_CONSTRAINTS_st NAME_CONSTRAINTS;

typedef struct ASIdentifierChoice_st ASIdentifierChoice_st;
typedef struct ASIdentifierChoice_st ASIdentifierChoice;

typedef struct buf_mem_st buf_mem_st;
typedef struct buf_mem_st BUF_MEM;

typedef int (pem_password_cb)(char *, int, int, void *);




typedef struct stack_st {
    int num;
    char **data;
    int sorted;
    int num_alloc;
    int (*comp) (const void *, const void *);
} _STACK;                       /* Use STACK_OF(...) instead */


union _union_277 {
    char *ptr;
    struct rsa_st *rsa;
    struct dsa_st *dsa;
    struct dh_st *dh;
    struct ec_key_st *ec;
};


struct evp_pkey_st {
    int type;
    int save_type;
    int references;
    EVP_PKEY_ASN1_METHOD *ameth;
    ENGINE *engine;
    union _union_277 pkey;
    int save_parameters;
    struct stack_st_X509_ATTRIBUTE *attributes;
};


struct stack_st_X509_ALGOR {
    _STACK stack;
};

struct stack_st_ASN1_OBJECT {
    _STACK stack;
};


struct stack_st_X509_EXTENSION {
    _STACK stack;
};


struct ASN1_ENCODING_st {
    unsigned char *enc;
    long len;
    int modified;
};

struct x509_cinf_st {
    ASN1_INTEGER *version;
    ASN1_INTEGER *serialNumber;
    X509_ALGOR *signature;
    X509_NAME *issuer;
    X509_VAL *validity;
    X509_NAME *subject;
    X509_PUBKEY *key;
    ASN1_BIT_STRING *issuerUID;
    ASN1_BIT_STRING *subjectUID;
    struct stack_st_X509_EXTENSION *extensions;
    ASN1_ENCODING enc;
};



struct X509_algor_st {
    ASN1_OBJECT *algorithm;
    ASN1_TYPE *parameter;
};



struct asn1_string_st {
    int length;
    int type;
    unsigned char *data;
    long flags;
};

struct crypto_ex_data_st {
    struct stack_st_void *sk;
    int dummy;
};


struct X509_POLICY_CACHE_st {
};


struct stack_st_DIST_POINT {
    _STACK stack;
};

struct stack_st_GENERAL_NAME {
    _STACK stack;
};

struct stack_st_IPAddressFamily {
    _STACK stack;
};


struct ASIdentifiers_st {
    ASIdentifierChoice *asnum;
    ASIdentifierChoice **rdi;
};


struct x509_cert_aux_st {
    struct stack_st_ASN1_OBJECT *trust;
    struct stack_st_ASN1_OBJECT *reject;
    ASN1_UTF8STRING *alias;
    ASN1_OCTET_STRING *keyid;
    struct stack_st_X509_ALGOR *other;
};
typedef struct x509_cert_aux_st X509_CERT_AUX;


struct X509_name_st {
    struct stack_st_X509_NAME_ENTRY *entries;
    int modified;
    BUF_MEM *bytes;
    unsigned char *canon_enc;
    int canon_enclen;
};

struct X509_val_st {
    ASN1_TIME *notBefore;
    ASN1_TIME *notAfter;
};



struct X509_pubkey_st {
    X509_ALGOR *algor;
    ASN1_BIT_STRING *public_key;
    EVP_PKEY *pkey;
};




struct x509_st {
    X509_CINF *cert_info;
    X509_ALGOR *sig_alg;
    ASN1_BIT_STRING *signature;
    int valid;
    int references;
    char *name;
    CRYPTO_EX_DATA ex_data;
    long ex_pathlen;
    long ex_pcpathlen;
    ulong ex_flags;
    ulong ex_kusage;
    ulong ex_xkusage;
    ulong ex_nscert;
    ASN1_OCTET_STRING *skid;
    AUTHORITY_KEYID *akid;
    X509_POLICY_CACHE *policy_cache;
    struct stack_st_DIST_POINT *crldp;
    struct stack_st_GENERAL_NAME *altname;
    NAME_CONSTRAINTS *nc;
    struct stack_st_IPAddressFamily *rfc3779_addr;
    struct ASIdentifiers_st *rfc3779_asid;
    unsigned char sha1_hash[20];
    X509_CERT_AUX *aux;
};


struct bio_st {
    BIO_METHOD *method;
    long (*callback)(struct bio_st *, int, char *, int, long, long);
    char *cb_arg;
    int init;
    int shutdown;
    int flags;
    int retry_reason;
    int num;
    void *ptr;
    struct bio_st *next_bio;
    struct bio_st *prev_bio;
    int references;
    ulong num_read;
    ulong num_write;
    CRYPTO_EX_DATA ex_data;
};

struct NAME_CONSTRAINTS_st {
    struct stack_st_GENERAL_SUBTREE *permittedSubtrees;
    struct stack_st_GENERAL_SUBTREE *excludedSubtrees;
};


struct AUTHORITY_KEYID_st {
    ASN1_OCTET_STRING *keyid;
    GENERAL_NAMES *issuer;
    ASN1_INTEGER *serial;
};

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdint.h>
#include <stdbool.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <ctype.h>
#include <errno.h>
#include <string.h>


//#include "../../openssl-OpenSSL_1_0_1-stable/crypto/fips_err.h"
//#include "openssl/evp.h"
//#include "openssl/x509.h"
///#include "openssl/pem.h"


#include "x509_types.h"

typedef void *d2i_of_void(void **, const unsigned char **, long);

extern const unsigned short int **__ctype_b_loc(void);
#define __ctype_b (*__ctype_b_loc())

extern EVP_MD *FIPS_evp_sha1(void);
extern EVP_MD *FIPS_evp_sha256(void);
extern EVP_MD *FIPS_evp_sha512(void);
extern EVP_MD_CTX *FIPS_md_ctx_create(void);
extern int FIPS_digestinit(EVP_MD_CTX *, const EVP_MD *);
extern int FIPS_digestupdate(EVP_MD_CTX *, const void *, size_t);

extern BIO * BIO_new(BIO_METHOD *);
extern BIO_METHOD * BIO_s_mem(void);
extern int BIO_puts(BIO *,char *);
extern int BIO_free(BIO *);


extern X509 *PEM_read_bio_X509(BIO *, X509 **, pem_password_cb *, void *);
extern void *PEM_ASN1_read_bio(unsigned char *,char *,BIO *,void **,unsigned char*,void *);

extern _STACK *sk_new(int *);
extern int sk_push(_STACK *,void *);

extern int X509_cmp(X509 *,X509 *); // hebben we al geloof ik in de main code
extern EVP_PKEY *X509_get_pubkey(X509 *);
extern void OPENSSL_add_all_algorithms_noconf(void);

extern int EVP_VerifyFinal(EVP_MD_CTX *,unsigned char *,uint ,EVP_PKEY *);


//unsigned int DAT_10022c98;
unsigned int *DAT_10011a40;

int           DAT_10022ab4;
char         *DAT_10022c2c;
char         *DAT_10022c40;
X509         *DAT_10022c44;
X509         *DAT_10022c48;
void         *DAT_10022c60;
int           DAT_10022c78;
int           DAT_10022c74;
int           DAT_10022c78;
int           DAT_10022c7c;
int           DAT_10022c84;
unsigned int  DAT_10022c90;
int          *DAT_10022c98;
int           DAT_10022c9c;
const EVP_MD *DAT_10022cb0;
EVP_MD_CTX   *DAT_10022cb4;
char         *DAT_10022cbc;
char         *DAT_10022cc0;
char         *DAT_10022cc4;
int           DAT_10022cc8;
int           DAT_10022ccc;

































unsigned int FUN_1000ca0c(void);
//unsigned int FUN_1000d6e0(void);
unsigned int FUN_1000dae4(unsigned int);
//unsigned int FUN_1000c6f4(size_t,char *,char*);
//unsigned int FUN_1000c7dc(char *,char *);
unsigned int FUN_1000da30(void);
//char *FUN_1000be80(char*);
void trimSpaces(char*);
//int FUN_1000c384(char*);
//int FUN_1000c488(int*,int*);
//X509* FUN_1000bac8(void);
//int FUN_1000ddd4(X509*,X509*);
//unsigned int FUN_1000dc8c(void);
//void FUN_1000d22c(size_t*,char*);

void trimSpaces(char *);


unsigned int OPENSSL_malloc_wrapper(size_t, char *, char*); // FUN_1000c6f4 
unsigned int OPENSSL_free_wrapper(char *,char *); // FUN_1000c7dc

char *OPENSSL_strlwr(char *);
unsigned int X509_parse_signed_file(void);
X509* X509_get_embedded_cert(void);
unsigned int X509_verify_signature(void);
X509 *PEM_read_bio_X509(BIO *, X509 **, pem_password_cb *, void *);
unsigned int PEM_read_bio_X509_CERT(char *);
int BIO_base64_decode_block(int *,int *);
void PEM_buffer_append(size_t *,char *);
int BIO_base64_char_value(char *); //int FUN_1000c384(char*);
int X509_certificate_compare(X509 *,X509 *); //int FUN_1000ddd4(X509*,X509*);
unsigned char OPENSSL_str2bool(char *);  //FUN_1000bc00
unsigned int X509_parse_signed_file(void);  //FUN_1000d6e0

unsigned int X509_verify_signature(void); // FUN_1000dc8c 














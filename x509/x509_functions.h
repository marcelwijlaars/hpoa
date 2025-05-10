
 // FUN_1000c6f4 
 // FUN_1000c6f4 
 // FUN_1000c6f4
unsigned int FUN_1000ca0c(char*);
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














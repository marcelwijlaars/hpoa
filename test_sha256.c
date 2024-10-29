#include <stdio.h>
#include <stdlib.h>
//#include <stdint.h>
//#include <stdbool.h>
//#include <endian.h>
//#include <unistd.h>
//#include <fcntl.h>
#include <string.h>
//#include "sha2/sha2.h"
#include <openssl/sha.h>
#include <openssl/md5.h>

void main (void) {

  int n;
  MD5_CTX c;
  char buf[512];
  ssize_t bytes;
  unsigned char out[MD5_DIGEST_LENGTH];


  strcpy(buf,"Marcel is gek! Wie is er nog meer gek?");
  printf("MD5 of '%s'\n",buf);

  bytes = strlen(buf);
  

  MD5_Init(&c);

  MD5_Update(&c, buf, bytes);
  
  MD5_Final(out, &c);

  for(n=0; n<MD5_DIGEST_LENGTH; n++)
    printf("%02x", out[n]);
  printf("\n");












  
#if 0
  SHA256_CTX ctx;
  u_int8_t results[SHA256_DIGEST_LENGTH];
  char *buf;
  int n;

  buf=calloc(0x200,1);
  strcpy(buf,"Marcel is gek! Wie is er nog meer gek?");


  n = strlen(buf);
  
  SHA256_Init(&ctx);
  SHA256_Update(&ctx, (u_int8_t *)buf, n);
  SHA256_Final(results, &ctx);

  /* Print the digest as one long hex value */
  for (n = 0; n < SHA256_DIGEST_LENGTH; n++)
    printf("%02x", results[n]);
  putchar('\n');

#endif
  
#if 0
  sha256_ctx ctx;
  u_int8_t results[SHA256_DIGEST_SIZE];
  char *buf;
  int n;

  buf=malloc(0x200);
  strcpy(buf,"Marcel is gek! Wie is er nog meer gek?");

  n = strlen(buf);
  
  sha256_init(&ctx);
  sha256_update(&ctx, (u_int8_t *)buf, n);
  sha256_final(results, &ctx);

  /* Print the digest as one long hex value */
  printf("0x");
  for (n = 0; n < SHA256_DIGEST_SIZE; n++)
    printf("%02x", results[n]);
  putchar('\n');

#endif
}

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <ctype.h>


//#include <openssl/pem.h> //have to fix this, should be local
//#include <openssl/fips.h> // have to fix this

//#include <linux/loop.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include "DAT_variables.h" // needed for sha stuff
#include "sha2/sha2.h"
//#include <openssl/sha.h>
#include "md5/md5.h"
#include "crc32/crc32.h"
#include "x509/x509_types.h"
#include "x509/x509_functions.h"
//#include "data_0x10010100.h"

#define HEADER_SIZE 0xD5
#define NEW_SECONDARY_HEADER_SIZE 0x38
#define OLD_SECONDARY_HEADER_SIZE 0x23
#define MAX_FILE_SIZE 0xFFFFFF
#define C7000 2
#define C3000 1 //actually 1 or 3
#define OA_BOARD_TYPE C7000

#define IS_INT true
#define NOT_INT false

#define RSA_ERR_PADDING     0x401   /* PKCS#1 padding validation failed */
#define RSA_ERR_SIZE        0x406   /* Key/message size mismatch */



#define ___bswap_constant_32(x)						\
     ((((x) & 0xff000000) >> 24) | (((x) & 0x00ff0000) >>  8) |                      \
      (((x) & 0x0000ff00) <<  8) | (((x) & 0x000000ff) << 24))

# define ___bswap_32(x) \
     (__extension__                                                              \
      ({ register unsigned int __x = (x); ___bswap_constant_32 (__x); }))

#define __htobe32(x) ___bswap_32 (x)

// #define SEEK_SET 0
// #define SEEK_CUR 1
// #define SEEK_END 2

const int __i__ = 1;
#define is_bigendian() ( (*(char*)&__i__) == 0 )

/* start from chatGPT */
#define CARRY4(a, b) (((a) + (b)) < (a))
#define CONCAT11(byte1, byte2)  ((uint16_t)(((uint16_t)(byte1) << 8) | (byte2)))
#define CONCAT12(byte1, byte2, byte3)  ((uint32_t)(((uint32_t)(byte1) << 16) | ((uint32_t)(byte2) << 8) | (byte3)))
#define CONCAT13(byte1, byte2, byte3, byte4)  ((uint32_t)(((uint32_t)(byte1) << 24) | ((uint32_t)(byte2) << 16) | ((uint32_t)(byte3) << 8) | (byte4)))

/* end from chatGPT */

#define RED     "\x1b[1;31m"
#define GREEN   "\x1b[1;32m"
#define YELLOW  "\x1b[1;33m"
#define BLUE    "\x1b[1;34m"
#define MAGENTA "\x1b[1;35m"
#define CYAN    "\x1b[1;36m"
#define DEFAULT "\x1b[1;0m"


#define UBOOT_MAGIC	0x27051956
#define SQUASHFS_MAGIC  0x73717368
#define PEM_MAGIC       0x2d2d2d2d //not official magic numver, but I think this works

#define INDEX_KERNEL        0x01
#define INDEX_INITRD        0x02
#define INDEX_SQUASHFS      0x03
#define INDEX_KERNEL_UDOG   0x04
#define INDEX_STORAGE       0x05
#define INDEX_CERTS         0x06



extern const unsigned short int **__ctype_b_loc(void);
#define __ctype_b (*__ctype_b_loc())



typedef struct partition{
  uint8_t  nr;
  char name[0x40];
  uint32_t jump_size;
  uint32_t offset;
  uint8_t  md5[MD5_DIGEST_LENGTH];
  uint32_t header_crc32; 
  uint32_t data_crc32;
}*partition;


uint open_mtd_for_output_internal(int,char*,int); /* FUN_10001edc */
int open_mtd_for_input_internal(char*, int, void*); /* FUN_10002160 */
int FUN_1000f7dc(unsigned int, unsigned int);
char *partition_selector(unsigned char); /* FUN_100033a8 */
void do_housekeeping(void);
void do_sha256_test(void);
int modify_partition(partition, char*,int);
int em_type(void);
int do_rw_test(void);
uint64_t fw_with_fingerprint(char*);                       /* FUN_1000cb68 ish */ 
uint rsa_verify_signature(int, __off_t *, unsigned char *, int, int);
int write_initrd(void);
int verify_initrd(void);
int get_free_loop(void);
int do_analysis(partition, char *);
void print_partition_info(partition, int);
int verify_mtd_md5sum(char*, void *);
unsigned int copy_partition_to_mtd_device(int, partition);
void write_hpoa_header(int, partition, int, unsigned char*);
int partition_nr_selector(char*);
void line_print_16_bytes(unsigned char*,int);
void print_keys(void);

void kind_of_memset(unsigned int*,unsigned char,unsigned int); /* FUN_10008264 */
void kind_of_memcpy(unsigned int*,unsigned int*,unsigned int); /* FUN_100081f0 */

void FUN_100092f8(int*, int*, uint);
void FUN_10009374(int*, uint);
void FUN_10008fe4(void *,void *,size_t);
void simple_md5sum(char*, int, bool);
int only_modify_hash(char*, char*, unsigned char*);

#if 0
unsigned int FUN_1000ca0c(char*);
unsigned int FUN_1000d6e0(void);
unsigned int FUN_1000dae4(unsigned int);
unsigned int FUN_1000c6f4(size_t,char *,char*);
unsigned int FUN_1000c7dc(char *,char *);
unsigned int FUN_1000da30(void);
char *FUN_1000be80(char*);
void trimSpaces(char*);
int FUN_1000c384(char*);
int FUN_1000c488(int*,int*);
X509* FUN_1000bac8(void);
int FUN_1000ddd4(X509*,X509*);
unsigned int FUN_1000dc8c(void);
void FUN_1000d22c(size_t*,char*);

#endif





#if 0
unsigned char check_something(int,int);
unsigned char FUN_10005f64(unsigned char *, uint, unsigned char*, size_t, int, int);
size_t FUN_10005d64(int, void *, size_t, SHA256_CTX *);
uint32_t FUN_10005de8(int, unsigned char *, unsigned char *);
uint32_t FUN_100089b8(int, uint *, int, int, int *);
uint32_t FUN_1000a4c0(int,int,int);
uint FUN0_10009824(int, int, uint, uint);
uint FUN_10009924(int, int, uint, int);
uint FUN_1000610c(int, __off_t *, unsigned char *, int, int);
uint FUN_10005cdc(int, uint, SHA256_CTX *);
void FUN_CONCAT(unsigned int*,unsigned int*,unsigned int); /* FUN_1000810 */
void kind_of_memset(unsigned int*,unsigned char,unsigned int); /* FUN_10008264 */
void kind_of_memcpy(unsigned int*,unsigned int*,unsigned int); /* FUN_100081f0 */
void FUN_10006944(unsigned int*,unsigned int*);
void FUN_1000b460(char *);
void FUN_10008fe4(void *,void *,size_t);
void FUN_10008f90(void *,int,size_t);
void FUN_100090a4(int,uint,int,int);
void FUN_100091dc(int,int,int,uint);
void FUN_10009ebc(int, int, int, int, int, uint);
void FUN_100092f8(int, int, uint);
void FUN_10009e2c(int, int, int, int, uint);
void FUN_10009374(int, uint);
void FUN_100096ac(int, int, int, int);
void FUN_10009db8(int, int, uint, int, uint);
void FUN_10009a24(int, int, int, uint, int, uint);
void FUN_1000af94(uint *, uint, uint);
void FUN0_1000b104(int*, int*, uint);
uint FUN_1000aa18(uint);
uint FUN_1000a738(int, int, uint, int, uint);
void MD5_printf(unsigned int*,char*);
int FUN_1000a8a4(int, int, uint, int, uint);
int FUN_10009580(int, int, int, uint); // big_int_subtract
int FUN_10008474(void *, size_t *, int, uint, int *);
int FUN0_1000a6bc(int,int);

#endif

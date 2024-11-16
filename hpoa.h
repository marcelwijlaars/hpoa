#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
//#include "data_0x10010100.h" // needed fro sha stuff??
#include "sha2/sha2.h"
//#include <openssl/sha.h>
#include "md5/md5.h"

#define HEADER_SIZE 0xD5
#define MAX_FILE_SIZE 0xFFFFFF
#define C7000 2
#define C3000 1 //actually 1 or 3
#define OA_BOARD_TYPE C7000


#define __bswap_constant_32(x)						\
     ((((x) & 0xff000000) >> 24) | (((x) & 0x00ff0000) >>  8) |                      \
      (((x) & 0x0000ff00) <<  8) | (((x) & 0x000000ff) << 24))

# define __bswap_32(x) \
     (__extension__                                                              \
      ({ register unsigned int __x = (x); __bswap_constant_32 (__x); }))


#define htobe32(x) __bswap_32 (x)

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


uint open_mtd_for_output_internal(int,char*,int); /* FUN_10001edc */
int open_mtd_for_input_internal(char*, int, void*); /* FUN_10002160 */
int FUN_1000f7dc(unsigned int, unsigned int);
char *partition_selector(unsigned char); /* FUN_100033a8 */
void do_housekeeping(void);
void do_sha256_tests(void);




#if 0
unsigned char check_something(int,int);
unsigned char FUN_10005f64(unsigned char *, uint, unsigned char*, size_t, int, int);
size_t FUN_10005d64(int, void *, size_t, SHA256_CTX *);
uint64_t  fw_with_fingerprint(void);                       /* FUN_1000cb68 */ 
uint32_t FUN_10005de8(int, unsigned char *, unsigned char *);
uint32_t FUN_100089b8(int, uint *, int, int, int *);
uint32_t FUN_1000a4c0(int,int,int);
uint FUN_10009824(int, int, uint, uint);
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
void FUN_1000b104(int*, int*, uint);
uint FUN_1000aa18(uint);
uint FUN_1000a738(int, int, uint, int, uint);
void MD5_printf(unsigned int*,char*);
int FUN_1000a8a4(int, int, uint, int, uint);
int FUN_10009580(int, int, int, uint);
int FUN_10008474(void *, size_t *, int, uint, int *);
int FUN_1000a6bc(int,int);
int get_em_type(void);
#endif

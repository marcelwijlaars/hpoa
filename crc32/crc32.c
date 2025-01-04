#include <stdint.h>
#include "crc32.h"

uint32_t crc32(uint32_t seed, const unsigned char *buf, uint32_t len)
{
  uint32_t crc = seed;
  const unsigned char *p = buf;

  crc = crc ^ 0xffffffffL;
  while (len) {
    crc = crc32_table[(crc ^ *p++) & 0xff] ^ (crc >> 8);
    //ghidra says: crc = (crc32_tabel[(crc ^ *p++) & 0xff] * 4) ^ crc >> 8;
    len--;
  }
  return crc ^ 0xffffffffL;
}



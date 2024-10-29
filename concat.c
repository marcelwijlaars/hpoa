#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

#define RED "\x1b[1;31m"
#define GREEN "\x1b[1;32m"
#define BLUE "\x1b[1;34m"
#define DEFAULT "\x1b[1;0m"


void CONCAT_FUN(unsigned int*,unsigned int*, unsigned int);

int main(void){
  int k;
  int   *tmp_int_10,   *tmp_int_11;
  tmp_int_10=calloc(0x10,sizeof(unsigned int));
  tmp_int_11=calloc(0x10,sizeof(unsigned int));
  
  tmp_int_11[0]=0x01020304;
  tmp_int_11[1]=0x05060708;
  tmp_int_11[2]=0x09101112;
  tmp_int_11[3]=0x13141516;
    
  CONCAT_FUN(tmp_int_10,tmp_int_11,4);

  
  for(k=0;k<0x10;k++) printf("%.2X ",(unsigned char)*(tmp_int_10+k));
  printf("\n");

  return 0;
}



/* concat werk niet moet getest worden. */
void CONCAT_FUN(unsigned int *p1,unsigned int *p2,uint len){
  int i=0;
  uint j;
  printf(RED);
  printf("CONCAT_FUN.\n");
  printf(DEFAULT);
  printf("\n");
  
  printf("p2[0]: %.8X\n",p2[0]);
  printf("p2[1]: %.8X\n",p2[1]);
  printf("p2[2]: %.8X\n",p2[2]);
  printf("p2[3]: %.8X\n",p2[3]);
  
  for (j=0; j < len; j=j+1) {
    for (i=0; i < 4; i=i+1) {
      *(unsigned char*)(p1 + (3-i) +(j*4)) = (p2[j] >>(8*i));   
      //printf("p1 %.2i: %X\n",i+(j*4),*(unsigned char*)(p1+i+(j*4)));
    }
  }
  return;
}

int hard_read(void){
  int k=0;
  unsigned char* pointer = (char*)0x10020000;  
  //for(k=0;k<0x10;k++)
  printf("%.2X ",(unsigned char)*(pointer+k));
  printf("\n");

  return 0;
}


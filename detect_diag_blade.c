#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/i2c-dev.h>

int i2c_read(int,unsigned int, size_t,void *);
int i2c_write(int, unsigned int, size_t,void *);
int i2c_detect_diag_blade(void);


int main(void){

  i2c_detect_diag_blade();
  
  
  return 0;
}
  

unsigned int hpoa_main(void){
  unsigned int uVar1;
  int iVar2;  
  iVar2 = i2c_detect_diag_blade();
  uVar1 = 2;
  if (iVar2 == 0) {
    puts("Manufacturing diagnostics blade detected.  All owing shell access.");
    system("/etc/grantroot");
    system("/usr/sbin/allfan 180 > /dev/null 2>&1");
    uVar1 = 0;
  }
  return uVar1;
}



int i2c_detect_diag_blade(void) {
  int iVar1;
  int iVar2;
  char local_28;
  unsigned char local_27;
  
  int fd = open("/dev/i2c1",2);
  iVar2 = 0;
  if (fd == -1) {
    fputs("Error:  Could not open /dev/i2c1\n",stderr);
    iVar1 = 1;
  }
  else {
    do {
      local_28 = '\x01';
      if (iVar2 != 0) {
        local_28 = '\b';
      }
      iVar1 = i2c_write(fd, 0x75,1,&local_28);
      fputs("1.",stderr);
      if (iVar1 == 0) {
        local_28 = '\x06';
        local_27 = 0;
        iVar1 = i2c_write(fd, 0x20,2,&local_28);
        fputs("2.",stderr);
        if (iVar1 == 0) {
          local_28 = '\a';
          local_27 = 0xff;
          iVar1 = i2c_write(fd, 0x20,2,&local_28);
          fputs("3.",stderr);
          if (iVar1 == 0) {
            local_27 = 0x55;
            local_28 = '\x02';
            iVar1 = i2c_write(fd, 0x20,2,&local_28);
            fputs("4.",stderr);
            if (iVar1 == 0) {
              local_28 = '\0';
              iVar1 = i2c_write(fd, 0x20,1,&local_28);
              fputs("5.",stderr);
              if (iVar1 == 0) {
                iVar1 = i2c_read(fd, 0x20,1,&local_28);
                fputs("6.",stderr);
                if ((iVar1 == 0) && (iVar1 = 1, local_28 == 'U')) {
                  local_28 = '\x01';
                  iVar1 = i2c_write(fd, 0x20,1,&local_28);
                  fputs("7.",stderr);
                  if (iVar1 == 0) {
                    iVar1 = i2c_read(fd, 0x20,1,&local_28);
                    fputs("8.",stderr);
                    if ((iVar1 == 0) && (iVar1 = 1, local_28 == 'U') ) {
                      local_27 = 0xaa;
                      local_28 = '\x02';
                      iVar1 = i2c_write(fd, 0x20,2,&local_28);
                      fputs("9.",stderr);
                      if (iVar1 == 0) {
                        local_28 = '\0';
                        iVar1 = i2c_write(fd, 0x20,1,&local_28);
                        fputs("10.",stderr);
                        if (iVar1 == 0) {
                          iVar1 = i2c_read(fd, 0x20,1,&local_28);
                          fputs("11.",stderr);
                          if ((iVar1 == 0) && (iVar1 = 1, local_28 == -0x56)) {
                            local_28 = '\x01';
                            iVar1 = i2c_write(fd, 0x20,1,&local_28);
                            fputs("12.",stderr);
                            if (iVar1 == 0) {
                              iVar1 = i2c_read(fd, 0x20,1,&local_28);
                              fputs("13.",stderr);
                              if (iVar1 == 0) {
                                if (local_28 == -0x56) {
                                  fputs("done.\n",stderr);
                                  break;
                                }
                                iVar1 = 1;
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      iVar2 = iVar2 + 1;
    } while (iVar2 < 2);
    close(fd);
  }
  return iVar1;
}




int i2c_write(int fd, unsigned int address,size_t param_2,void * param_3){
  int iVar1;
  size_t sVar2;
  
  iVar1 = 0;
  if ((0 < (int)param_2) && (iVar1 = ioctl(fd, I2C_SLAVE,address), iVar1 != -1)) {
    sVar2 = write(fd,param_3,param_2);
    iVar1 = (sVar2 == param_2) - 1;
  }
  return iVar1;
}


int i2c_read(int fd, unsigned int address,size_t param_2,void * param_3){
  int iVar1;
  size_t sVar2;
  
  iVar1 = 0;
  if ((0 < (int)param_2) && (iVar1 = ioctl(fd, I2C_SLAVE,address), iVar1 != -1)) {
    sVar2 = read(fd,param_3,param_2);
    iVar1 = (sVar2 == param_2) - 1;
  }
  return iVar1;
}



#include <unistd.h>
#include <stdio.h>
#include <fcntl.h>

int  main(void){
  int d;
  unsigned char data=0;
  int fd;
  ssize_t ret=1;
  
  //d = daemon(0,0);
  //if (d != -1) {
    fd = open("/dev/watchdog",1);
    if (fd != -1) {
      do {
        ret=write(fd,&data,1);
	printf("Watchdog goes to sleep for 30 seconds.\n");
        sleep(0x1e);
      } while( ret==1 );
    }
    printf("Can\'t open watchdog device errno.\n");
    //}
  return -1;
}

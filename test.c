#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/i2c-dev.h>
//#include <i2c/smbus.h>


int test_address(unsigned int **address){
  printf("address: 0x%LX\n", address);
  return 0;
}

void main(void){

  unsigned int *a;
  unsigned int *b;

  printf("size of unsigned int: %i\n",sizeof(unsigned int));

  b=(a+0x10);
  a=calloc(0x20,sizeof(unsigned int));
  printf("the address of a: 0x%LX\n", &a);
  test_address(&a);
  printf("the address of b: 0x%LX\n", &b);
  test_address(&b);

}

#if 0
int old_main(void)
{
  printf("Wellcome to device programming.\n");
  printf("Enter i2c port no : ");
  u_int8_t prt = 0;
  scanf("%c",&prt);
  char pth[18] = {0};
  sprintf(pth,"/dev/i2c-%c",prt);
  int fd = open(pth,O_RDWR);
  if(fd > 0)
    {
      printf("%s has been opened\n",pth);
      int rt_ctl = 0;
      for(int i=0;i<=60;i+=10)
	{
	  if(!i)
	    {
	      printf("     ");
	      for(int i=0;i<=0xf;i++)
		{
		  printf("%x  ",i);
		}
	      printf("\n");
	    }
	  printf("%.2d: ",i);
	  for(int j=0x0;j<=0xf;j++)
	    {

	      rt_ctl = ioctl(fd,I2C_SLAVE,i+j);
	      if(rt_ctl < 0)
		{
		  printf("-- ");
		  //perror("ioctl() failed due to : ");
		}
	      else
		{
		  rt_ctl = i2c_smbus_read_byte(fd);
		  if(rt_ctl < 0)
		    {
		      printf("-- ");
		    }
		  else
		    {
		      printf("%02x ",j);
		    }
		}
	    }
	  printf("\n");
	}
      close(fd);
    }

}
#endif

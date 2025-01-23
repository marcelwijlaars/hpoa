#include "hpoa.h"


/* glocal variables */
unsigned char *DAT_10012738=0;  //doesn't change anywhere should be calloced
unsigned char *DAT_10022c28;




int main(int argc,char **argv){
  
  int fd, fw, fh;
  FILE *fp;
  off_t offset;                                                 /* __offset */

  char file_name[128];
  char *new_name;
  new_name = malloc(0x80*sizeof(char));

  ssize_t ret;                                                  /* uVar10 */

  unsigned char *read_buffer;                                   /* local_d28 */
  read_buffer=calloc(MAX_FILE_SIZE,sizeof(unsigned char));

  int md5_check=0;
  
  int i,j;                                                      /* iVar16 and iVar27 */
  int index=0;

  uint32_t partition_size=0;
  char *mtd_name;
  mtd_name=calloc(0x80,sizeof(unsigned char));

  char *partition_name;
  partition_name=calloc(0x80,sizeof(unsigned char));

  
  unsigned int jump_size_array[0x10];     // mag weg, ook hier boven gedefineerd
  unsigned int image_data_size_array[0x10];   //dubbel up denk ik
  unsigned int fw_location=0;
  unsigned int fw_location_array[0x10];
  unsigned int current_location_array[0x10];

  int opt=0;
  int modify=0;
  int burn=0;
  int firmware=0;
  int verify=0;
  int have_fingerprint=0;

  partition p;
  
  int nr_partitions=0;
  DAT_10022c28=calloc(0x80,sizeof(unsigned char));


#if 0 //SHA stuff works
  do_sha256_test();
#endif
  
  p= malloc(0x10*sizeof(*p)); // must be sizeof *p otherwise size of the address of p

  if (geteuid() != 0) {
    fprintf(stderr, "%s needs root privileges!\n",argv[0]);
    exit(1);
  }


  /*  handle commandline options */
  if(argc <= 1){
    printf("No firmware file. Usage: %s [option] <filename>\n",argv[0]);
    return -1;
  }else{
    while(opt = getopt(argc,argv,"fbmtv"),opt != -1) {
      if (true) {
	switch(opt) {
	case 'm':
	  modify=1;
	  printf("Choosen option: %c, will modify rc.sysinit\n",opt);
	  break;
	case 'b':
	  burn=1;
	  if((modify==0)&&(firmware==0)){
	    printf("Going to burn_only.\n");
	    goto burn_only;
	    printf("Burn firmare ok.\n");
	    return(1);
	  }
	  //printf("Choosen option: %c, will burn new initrd to /dev/mtd-initrd\n",opt);
	  break;
	case 'f':
	  firmware=1;
	  printf("Choosen option: %c, will compose new firmware image\n",opt);
	  break;
	case 'v':
	  verify=1;
	  if((modify==0)&&(burn==0)&&(firmware==0)){
	    printf("Going to verify_only.\n");
	    goto verify_only;
	    printf("Firmare verification ok.\n");
	    return(1);
	  }
	  //printf("Choosen option: %c, will verify new firmware image\n",opt);
	  break;
	}
      }
    }
  }

  /****************************************************************************************/
  /*                                 main code                                            */
  /****************************************************************************************/
  

  
  fd=open(argv[optind],O_RDONLY);                 /* file_name = local_c48 */
  ret=read(fd,read_buffer,HEADER_SIZE);           /* read_buffer = local_d28 */

  char pcVar22 = 0x00000001 & 0xFFFFFFFF;
  // should be have_signature */
  have_fingerprint = verify_signature(fd,(__off_t *)&DAT_10022c28,read_buffer,0,pcVar22);
  //if(have_fingerprint)
  printf("have_fingerprint: %i\n", have_fingerprint);
  //fw_with_fingerprint(argv[optind]);
		       


  
  /* analyse partitions */
  nr_partitions = do_analysis(p,argv[optind]);

  /*
   * Verifying signature...
   * on success (NEW_HEADER==0)  successful! Key1
   * on failure (NEW_HEADER==1)  Firmware image is an unofficial and unsupported release.
   */
  
#define NEW_HEADER 0
#if NEW_HEADER  

  fh= open("hpoa444.bin",O_WRONLY |O_CREAT, 0666);
  write_hpoa_header(fh, p, nr_partitions,read_buffer);
  close(fh);

#endif
  
  for(i=0;i<nr_partitions;i++){
    partition_name = partition_selector((p+i)->nr);
    copy_partition_to_mtd_device(fd, (p+i));
    
    if((p+i)->nr==0x05){
      memset(new_name,0,0x80);
      strcpy(new_name,partition_name);
      strcat(new_name,"-udog");
      md5_check=verify_mtd_md5sum(new_name,(p+i)->md5);
    }else{
      md5_check=verify_mtd_md5sum(partition_name,(p+i)->md5);
    }
    if(md5_check!=0) printf("md5 error\n");
  }



  
  if(modify) {
    nr_partitions=modify_partition(p, "initrd",nr_partitions);
  }

  /* print partitions */
  print_partition_info(p, nr_partitions);


  

  if(burn && modify) {
    for(i=0;i<nr_partitions;i++);
  }
  
  close(fd);
  

  if(burn && ((em_type()==C3000) || (em_type()==C7000)) ){
    printf("start writing initrd\n");
    write_initrd();
  }


  unsigned char *data;

  strcpy(file_name,argv[optind]);

  
  if(firmware){
    printf(RED);
    printf("doing the firmware stuff\n");
    printf(DEFAULT);


    unsigned int crc=0;
    uint32_t image_data_size=0;
    char cmd[0x100];
    int s,data_len=0x1000;
    unsigned int crc_array[0x10];
    unsigned int header_crc_array[0x10];

    data=calloc(data_len,sizeof(char));

#if !NEW_HEADER
    strcpy(cmd, "cp ");
    strcat(cmd, file_name);
    strcat(cmd, " hpoa444.bin");
    //printf("%s\n",cmd);
    system(cmd);
#endif
    fw=open("hpoa444.bin",O_RDWR);
    s=lseek(fw,HEADER_SIZE,SEEK_SET);
    fw_location+=s;
    printf("file_location s: 0x%X\n", s);

    fw_location_array[0]=s;
    
    fd=open("dev/mtd-kernel",O_RDONLY);
    while(data_len=read(fd,data,data_len),data_len>0){
      fw_location+=write(fw,data,data_len);
    }
    fw_location_array[1]=fw_location;

    lseek(fd,0x00,SEEK_SET);
    data_len=0x40;
    crc=0;
    data_len = read(fd,data,data_len);
    image_data_size=*((unsigned int*)data+3);
    if(!is_bigendian()) image_data_size = __htobe32(image_data_size);
    image_data_size_array[1]=image_data_size;
      
    for(i=0;i<4;i++) *(data+i+4)=0;
    crc = crc32(crc,data,data_len);
    header_crc_array[1]=crc;

    data_len=0x1000;
    crc=0;
    while(data_len = read(fd,data,data_len),data_len>0){
      crc = crc32(crc,data,data_len);
    }
    crc_array[1]=crc;
    close(fd);
    
    fd=open("dev/mtd-initrd",O_RDONLY);
    while(s=read(fd,data,0x1000),s>0){
      fw_location+=write(fw,data,s);
    }
    fw_location_array[2]=fw_location;

    lseek(fd,0x0,SEEK_SET);
    data_len=0x40;
    crc=0;
    data_len = read(fd,data,data_len);
    image_data_size=*((unsigned int*)data+3);
    if(!is_bigendian()) image_data_size = __htobe32(image_data_size);
    image_data_size_array[2]=image_data_size;
    for(i=0;i<4;i++) *(data+i+4)=0;
    crc = crc32(crc,data,data_len);
    header_crc_array[2]=crc;

    data_len=0x1000;
    crc=0;
    while(data_len = read(fd,data,data_len),data_len>0){
      crc = crc32(crc,data,data_len);
    }
    crc_array[2]=crc;
    close(fd);

    
    fd=open("dev/mtd-squashfs",O_RDONLY);
    while(s=read(fd,data,0x1000),s>0){
      fw_location+=write(fw,data,s);
    }
    fw_location_array[3]=fw_location;

    lseek(fd,0x0,SEEK_SET);
    data_len=0x40;
    crc=0;
    data_len = read(fd,data,data_len);
    image_data_size=*((unsigned int*)data+3);
    if(!is_bigendian()) image_data_size = __htobe32(image_data_size);
    image_data_size_array[3]=image_data_size;
    for(i=0;i<4;i++) *(data+i+4)=0;
    crc = crc32(crc,data,data_len);
    header_crc_array[3]=crc;

    data_len=0x1000;
    crc=0;
    while(data_len = read(fd,data,data_len),data_len>0){
      crc = crc32(crc,data,data_len);
    }
    crc_array[3]=crc;
    close(fw);


    for(i=0;i<4;i++){
      printf("current: 0x%06X, fw: 0x%06X, header_crc: 0x%08X, crc: 0x%08X\n",current_location_array[i],fw_location_array[i], header_crc_array[i], crc_array[i]);
    }

        for(i=0;i<4;i++){
      printf("jump_size: 0x%08X, image_data_size: 0x%08X\n", jump_size_array[i], image_data_size_array[i+1]);
    }
  } // end of doing the firmware stuff

 verify_only:
  if(verify){
    printf("start verifying initrd\n");
    verify_initrd();
    return(1);
  }

 burn_only:
  //printf("em_type: %i\n",em_type());
  if(burn){
    printf("start writing initrd\n");
    write_initrd();
    return(1);
  }

  //print_keys();


  free(p);
  return 0;
}

/******************************************************************************************/
/*                                  End of main                                           */
/******************************************************************************************/


void write_hpoa_header(int fd, partition p, int nr_partitions, unsigned char* data){

  
  int i,j;
    int remaining_partitions=0;
  uint32_t jump_size;
  char *new_version;
  new_version=calloc(0x10,sizeof(unsigned char));
  strcpy(new_version,"444");
  j=0;
  data[j]=0x01;
  remaining_partitions=nr_partitions-3;
  nr_partitions=3;
  j+=1;      
  for(i=0;i<nr_partitions;i++){
    *(data+j)=(p+i)->nr;
    j+=sizeof(unsigned char);;      
    jump_size=(p+i)->jump_size;
    if(!is_bigendian())
      jump_size = __htobe32(jump_size);
    memcpy((data+j), &jump_size, sizeof(uint32_t));
    j+=sizeof(uint32_t);
    memcpy((data+j), (p+i)->md5, MD5_DIGEST_LENGTH);
    j+=MD5_DIGEST_LENGTH;
  }

  j+=7;
  *(data+j+1)=atoi((new_version+1));
  *(new_version+1)=0;
  *(data+j)=atoi((new_version+0));
  j+=2*sizeof(unsigned char);
  write(fd,data,HEADER_SIZE);
}


uint32_t  *read_crc32(int fd,uint32_t offset){
  uint32_t *crc=0;
  uint32_t magic;
  uint8_t *data;
  data=calloc(HEADER_SIZE,sizeof(uint8_t));
  crc=calloc(0x02,sizeof(uint32_t));
  
  lseek(fd,offset,SEEK_SET);
  read(fd,data,0x40);
#if 0
  int i;
  for(i=0;i<0x40;i++){
    printf("%02X ",*(data+i));
    if(((i+1)%0x10)==0) printf("\n");
  }
  printf("\n");
#endif
  magic = *(uint32_t*)((uint32_t*)data);
  if(!is_bigendian()) magic = __htobe32(magic);
  switch(magic){
  case UBOOT_MAGIC:
    *(crc+0)=*((uint32_t*)data+1);
    if(!is_bigendian()) *(crc+0) = __htobe32(*(crc+0));
    *(crc+1)=*((uint32_t*)data+6);
    if(!is_bigendian()) *(crc+1) = __htobe32(*(crc+1));

    break;
  case SQUASHFS_MAGIC:
    *(crc+0)=0;
    *(crc+1)=0;

    break;
  case PEM_MAGIC:
    printf("Found PEM magic.\n");
    *(crc+0)=0;
    *(crc+1)=0;

    break;
  default:
    printf("No magic.\n");
    *(crc+0)=0;
    *(crc+1)=0;
    break;
  }
  /*   go to offset check partition type and read crc from partition and return data */
  
  lseek(fd,offset,SEEK_SET);

  free(data);
  return crc;
}

int do_analysis(partition p, char *file_name) {

  int fd;
  int i, j, k, m, n, o;
  uint32_t jump_size;
  uint32_t old_partition_offset=0;
  uint32_t partition_offset=0;
  //  uint32_t secondary_partition_offset=0;
  int s,data_len=0x1000;
  unsigned char *data;
  data=calloc(data_len,sizeof(char));
  /* dit moet een struct worden */

  uint32_t file_size=0;

  char *udog;

  //printf(RED);
  //printf("do_analysis.\n");
  //printf(DEFAULT);


  
  /*
   * We only need to verify the header and data crc32 are ok
   * to prevent the "Invalid OS checksum." message.
   * how does the crc check know its ist finished reading the partition data,
   * where/what is the EOF marker?
   */
  
  /*
   * The hpoa440.bin first 0xD5 bytes contain the pointer to the first three partitions,
   * the one byte partition type at:
   * 1 + (n*0x15),
   * and the 4 byte offsets of the partitions at:
   * 2 + (n*0x15),
   * and the 16 byte long md5 checksum at:
   * 6 + (n*0x15),
   * where n the the mtd partition number, starting at 0 (kind of)
   */

  
  fd=open(file_name,O_RDONLY);
  read(fd,data,HEADER_SIZE);
  if( ( (*(data+0)==0x01) || (*(data +0)==0x02) )  && (*(data+1)==0x01) ) {
    partition_offset=HEADER_SIZE;
  }else{
    printf("Wrong header!\n");
    exit(-1);
  }

  /* offset is eigenlijk jumpsize vermoed ik */
  n=0, m=0, o=0;
  do{
    (p+n)->nr = *(data + n*0x15 + 1);
    strcpy( (p+n)->name, partition_selector((p+n)->nr));
    jump_size = *(uint32_t*)(data + n*0x15 + 2); 
    if(!is_bigendian()) jump_size = __htobe32(jump_size);
    (p+n)->jump_size       = jump_size; 
    for(i=0;i<MD5_DIGEST_LENGTH;i++){
      (p+n)->md5[i] = *(data + n*0x15 + 6 + i);  // gaat niet goed
    }
    (p+n)->offset = partition_offset;
    partition_offset+=(p+n)->jump_size;
    (p+n)->header_crc32      = *( read_crc32(fd,(p+n)->offset) + 0);
    (p+n)->data_crc32        = *( read_crc32(fd,(p+n)->offset) + 1);
    n++;
  }while(strlen(partition_selector(*(data + n*0x15 + 1))) >0);

  unsigned int local_b48 = *(uint32_t*)(data+(n+1)*15+6 +0 +4 -1 );
  unsigned int local_b44 = *(uint32_t*)(data+(n+1)*15+6 +4 +4 -1 );
  unsigned int local_b40 = *(uint32_t*)(data+(n+1)*15+6 +8 +4 -1);

  if(!is_bigendian()) {
    local_b48 = __htobe32(local_b48);
    local_b44 = __htobe32(local_b44);
    local_b40 = __htobe32(local_b40);
  }

  
  //printf("local_b48: 0x%08X\n",local_b48);
  //printf("local_b44: 0x%08X\n",local_b44);
  //printf("local_b40: 0x%08X\n",local_b40);

  
  uint32_t ret;
  ret=lseek(fd,partition_offset,SEEK_SET);
  //printf("file_location: 0x%08X\n",ret);
  read(fd,data,HEADER_SIZE);
  //printf("file_location: 0x%08X\n",lseek(fd,));

  if( (*(data+0)==0x01) && (*(data+1)==0x02) ) {
    partition_offset+=NEW_SECONDARY_HEADER_SIZE;
  }else if( (*(data+0)==0x01) && (*(data+1)==0x01) ) {
    partition_offset+=OLD_SECONDARY_HEADER_SIZE;
  }else{
    printf("Wrong secondary header!\n");
    exit(-1);
  }

#if 0
  for(i=0;i<0x40;i++){
    printf("%02X ",*(data+i));
    if(((i+1)%0x10)==0) printf("\n");
  }
  printf("\n");
#endif

  m=0;  
  do{
    (p+n+m)->nr              = *(data + m*0x15 + 1 + 13);
    if((p+n+m)->nr==0x05){
      udog=calloc(0x20, sizeof(char));
      strcpy(udog,partition_selector((p+n+m)->nr));
      strcat(udog,"-udog");
      strcpy( (p+n+m)->name, udog);
    }else {
      strcpy( (p+n+m)->name, partition_selector((p+n+m)->nr));
    }

    jump_size = *(uint32_t*)(data + m*0x15 + 2 + 13);
    if(!is_bigendian()) jump_size = __htobe32(jump_size);
    (p+n+m)->jump_size       = jump_size; 
    //printf("jump_size: 0x%08X\n",(p+n+m)->jump_size);
    
    for(i=0;i<MD5_DIGEST_LENGTH;i++)
      (p+n+m)->md5[i] = *(data + m*0x15 + 6 + i + 13);

    (p+n+m)->offset = partition_offset;
    partition_offset+=(p+n+m)->jump_size;
    (p+n+m)->header_crc32      = *( read_crc32(fd,(p+n+m)->offset) + 0);
    (p+n+m)->data_crc32        = *( read_crc32(fd,(p+n+m)->offset) + 1);
    m++;

  }while(strlen(partition_selector(*(data + m*0x15 + 1 + 13))) >0);


  ret=lseek(fd,partition_offset,SEEK_SET);
  //printf("file_location: 0x%08X\n",ret);
  read(fd,data,HEADER_SIZE);
  //printf("file_location: 0x%08X\n",lseek(fd,));

  o=0;
  if( (*(data+0)==0x2d) && (*(data+1)==0x2d) && (*(data+2)==0x3d) && (*(data+3)==0x3c) ) {
    //printf("Have Fingerprint file!\n");

    (p+n+m+o)->nr              = 0x0A;
    strcpy( (p+n+m+o)->name, partition_selector((p+n+m+o)->nr));
    jump_size = 0xFFFFFFFF; //until EOF
    
    (p+n+m+o)->offset = partition_offset;
    partition_offset+=(p+n+m+o)->jump_size;
    (p+n+m+o)->header_crc32      = 0;
    (p+n+m+o)->data_crc32        = 0;
    o++;
  }

#if 0
  for(i=0;i<0x40;i++){
    printf("%02X ",*(data+i));
    if(((i+1)%0x10)==0) printf("\n");
  }
  printf("\n");
#endif

  
  
  close(fd);
  //printf("nr of partitions: %i\n",n+m+o);
  return (n+m+o);
}

void print_partition_info(partition p, int nr_partitions){
  int i,j;
  printf("Nr   partition   offset     md5                              header crc32  data crc32\n");
  for(i=0;i<nr_partitions;i++){
    /* Partition nr*/
    printf("0x%02X ", (p+i)->nr);
    /* Partition name*/
    printf("%-11s ", (p+i)->name);
    /* offset */
    printf("0x%08X ",(p+i)->offset);
    /* md5*/
    for(j=0;j<MD5_DIGEST_LENGTH;j++)
      printf("%02X", (p+i)->md5[j]);
    printf(" ");
    /* header crc32 */
    printf("0x%08X    ",(p+i)->header_crc32);
    /* data crc32 */
    printf("0x%08X",(p+i)->data_crc32);
    printf("\n");
  }
  printf("\n");
}



/* FUN_10008100 */
void FUN_CONCAT(unsigned int *param_1,unsigned int *param_2,uint param_3){
  int local_1c;
  uint local_18;

  //printf(RED);
  //printf("FUN_CONCAT.\n");
  //printf(DEFAULT);
  
  local_1c = 0;
  for (local_18 = 0; local_18 < param_3; local_18 = local_18 + 4) {
    *(uint *)(local_1c * 4 + param_1) =
      CONCAT13(*(unsigned char*)(param_2 + local_18 + 3),
	       *(unsigned char*)(param_2 + local_18 + 2),
	       *(unsigned char*)(param_2 + local_18 + 1),
	       *(unsigned char*)(param_2 + local_18 + 0));
    local_1c = local_1c + 1;
  }
  return;
}


/* this function returns 1 if the firmware file has a fingerprint section, otherwise 0 */
/* FUN_1000cb68 */
uint64_t fw_with_fingerprint (char *filename){
  uint64_t uVar1=0;
  char *pcVar2;
  //int ret;
  FILE *file;
  int iVar3;
  int iVar4;
  char acStack_420 [0x410];
  //code *local_20;

  printf(RED);
  printf("fw_with_fingerprint, FUN_1000cb68.\n");
  printf(DEFAULT);

  pcVar2=calloc(0x400,sizeof(char));
  memset(acStack_420,0,0x400);

  //local_20 = FUN_1000b510;
  //pcVar2 = (char *)FUN_1000b510(); //returns filename
  
  file= fopen(filename,"rb");
  if (file == (FILE *)0x0) {
    printf("could not open the signed file for parsing\n");
    uVar1 = 0;
  }
  else {
    printf("Opened the signed file for parsing\n");
    memset(acStack_420,0,0x400);
    fgets(acStack_420,0x400,file);
    iVar3 = errno;
    iVar3 = 0;
    iVar4 = fseek(file,-0x2800,SEEK_END);  // set file file location to 0x2800 from end
    if ((iVar4 == -1) && (iVar3 = errno, iVar3 == 0x16)) {
      rewind(file);
    }

    /* hpoa440.bin has no clear fingerprint section, hpoa450.bin does */
    memset(acStack_420,0,0x400);
    while (pcVar2 = fgets(acStack_420,0x400,file), pcVar2 != 0x0) {
      pcVar2 = strstr(acStack_420 ,"Fingerprint Length:");
      if (pcVar2 != 0x0) {  //"Fingerprint Length:" string found!!!
        uVar1 = 1;
        break;
      }
      memset(acStack_420,0,0x400);
    }
    if(uVar1==1)
      printf("fingerprint Lenghth found\n");
    else
      printf("No Fingerprint Length found\n");

    fclose(file);
  }
  return uVar1;
}



int partition_nr_selector(char *name){

  if(strcmp(name,"kernel")==0)      return 0x01;
  if(strcmp(name,"initrd")==0)      return 0x02;
  if(strcmp(name,"initrd.mod")==0)  return 0x02;
  if(strcmp(name,"squashfs")==0)    return 0x03;
  if(strcmp(name,"uboot")==0)       return 0x04;
  if(strcmp(name,"kernel-udog")==0) return 0x05;
  if(strcmp(name,"storage")==0)     return 0x08;
  if(strcmp(name,"fwmgmt")==0)      return 0x09;
  if(strcmp(name,"certs")==0)       return 0x0A;
  if(strcmp(name,"config")==0)      return 0x0B;
  return -1;
}

/* FUN_100033a8 */
char * partition_selector(unsigned char p){ //should be partition_name_selector
  char *s;
  /*
  printf(RED);
  printf("partition_selector, FUN_100033a8.\n");
  printf(DEFAULT);
  */
  
  s= "";
  switch(p) {
  case 0:
    s = "";
    break;
  case 1:
  case 5:
    s = "kernel";
    break;
  case 2:
    s = "initrd";
    break;
  case 3:
    s = "squashfs";
    break;
  case 4:
  case 6:
  case 7:
    s = "uboot";
    break;
  case 8:
    s = "storage";
    break;
  case 9:
    s = "fwmgmt";
    break;
  case 0x0A:
    s = "certs";
    break;
  case 0x0B:
    s = "config";
  }
  return s;
}



void FUN_1000e730(uint *param_1,uint *param_2){
  uint uVar1;
  unsigned int uVar2;
  uint uVar3;
  uint uVar4;
  uint uVar5;
  /*
  printf(RED);
  printf("FUN_1000e730.\n");
  printf(DEFAULT);
  */
  uVar3 = *param_1;
  uVar4 = param_1[1];
  uVar1 =      uVar3 >> 0x14 & 0x7ff;
  param_2[1] = uVar3 >> 0x1f;
  uVar5 =      uVar3 & 0xfffff;

  if (uVar1 == 0) {
    if ((uVar5 | uVar4) != 0) {
      uVar5 = (uVar4 >> 0x18) | (uVar5 << 8);
      uVar4 = uVar4 << 8;
      param_2[2] = 0xfffffc02;
      *param_2 = 3;
      if ((uVar5 < 0x10000000) && ((uVar5 != 0xfffffff || (true)))) {
        do {
          uVar5 = (uVar4 >> 0x1f) | (uVar5 << 1);
          uVar4 = uVar4 << 1;
          param_2[2] = param_2[2] + -1;
          if (0xfffffff < uVar5) break;
        } while ((uVar5 != 0xfffffff) || (true));
      }
LAB_1000e80c:
      param_2[4] = uVar5;
      param_2[5] = uVar4;
      return;
    }
    uVar2 = 2;

  }
  else if (uVar1 == 0x7ff) {
    if ((uVar5 | uVar4) != 0) {
      if ((uVar3 & 0x80000) == 0) {
        *param_2 = 0;
      }
      else {
        *param_2 = 1;
      }
      goto LAB_1000e80c;
    }
    uVar2 = 4;
  }
  else {
    param_2[4] = (uVar4 >> 0x18) | (uVar5 << 8) | 0x10000000;
    param_2[5] = (uVar4 << 8);
    uVar2 = 3;
    param_2[2] = uVar1 - 0x3ff;
  }
  *param_2 = uVar2;
  return;
}



/*
 * chat gpt suggest the following function  to concat44:
 * Shift the high part by 0x20 (32) bits to the left
 * and OR it with the low part
 */

uint64_t CONCAT44(uint32_t high, uint32_t low) {

    return ((uint64_t)high << 0x20 ) | low;
}


uint64_t FUN_1000fc58(uint param_1,uint param_2,uint param_3){
  uint uVar1;
  uint uVar2;
  
  printf(RED);
  printf("FUN_1000fc58.\n");
  printf(DEFAULT);

  uVar1 = 0x20 - param_3;
  uVar2 = param_2;
  if (param_3 != 0) {
    if ((int)uVar1 < 1) {
      uVar2 = 0;
      param_1 = param_2 << (-uVar1 & 0x3f);
    }
    else {
      uVar2 = param_2 << (param_3 & 0x3f);
      param_1 = param_1 << (param_3 & 0x3f) | param_2 >> (uVar1 & 0x3f);
    }
  }
  return CONCAT44(param_1,uVar2);
}


/*
 * chat GPT suggets its a circular bitwise shift
 * on the param_1 and param_2 values based on the value of param_3.
 */
uint64_t FUN_1000f988(uint param_1,uint param_2,uint param_3){
  uint uVar1;
  uint uVar2;
  
  printf(RED);
  printf("FUN_1000f988.\n");
  printf(DEFAULT);

  uVar1 = 0x20 - param_3;
  uVar2 = param_1;
  if (param_3 != 0) {
    if ((int)uVar1 < 1) {
      uVar2 = 0;
      param_2 = param_1 >> (-uVar1 & 0x3f);
    }
    else {
      uVar2 = param_1 >> (param_3 & 0x3f);
      param_2 = param_2 >> (param_3 & 0x3f) | param_1 << (uVar1 & 0x3f);
    }
  }
  return CONCAT44(uVar2,param_2);
}


/* needed by _130 functions */
uint64_t FUN_1000fa10(uint *param_1){
  uint uVar1;
  uint uVar2;
  uint uVar3;
  uint uVar4;
  uint uVar5;
  uint uVar6;
  bool bVar7;
  long long int lVar8;
  uint64_t uVar9;
  /*
  printf(RED);
  printf("FUN_1000fa10.\n");
  printf(DEFAULT);
  */
  
  uVar1 = *param_1;
  uVar4 = 0;
  uVar3 = param_1[1];
  uVar5 = param_1[4];
  uVar6 = param_1[5];
  if (uVar1 < 2) {
    uVar4 = 0x7ff;
    uVar5 = uVar5 | 0x80000;
    goto LAB_1000fa64;
  }
  if (uVar1 == 4) {
LAB_1000fbc8:
    uVar4 = 0x7ff;
  }
  else if (uVar1 != 2) {
    if ((uVar5 | uVar6) == 0) goto LAB_1000fa64;
    uVar1 = param_1[2];
    if ((int)uVar1 < -0x3fe) {
      uVar1 = -uVar1 - 0x3fe;
      if ((int)uVar1 < 0x39) {
        lVar8 = FUN_1000fc58(0,1,uVar1);
        uVar2 = uVar5 & (uint)((unsigned long long int)(lVar8 + -1) >> 0x20);
        uVar9 = FUN_1000f988(uVar5,uVar6,uVar1);
        uVar5 = (uint)((unsigned long long int)uVar9 >> 0x20);
        uVar6 = (uint)uVar9 | (uint)((uVar2 | (uVar6 & (uint)(lVar8 + -1))) != 0);
      }
      else {
        uVar5 = 0;
        uVar6 = 0;
      }
      if ((false) || ((uVar6 & 0xff) != 0x80)) {
        bVar7 = 0xffffff80 < uVar6;
        uVar6 = uVar6 + 0x7f;
        uVar5 = uVar5 + bVar7;
      }
      else if ((uVar6 & 0x100) != 0) {
        bVar7 = 0xffffff7f < uVar6;
        uVar6 = uVar6 + 0x80;
        uVar5 = uVar5 + bVar7;
      }
      if ((0xfffffff < uVar5) || ((uVar5 == 0xfffffff && (false)))) {
        uVar4 = 1;
      }
    }
    else {
      if (0x3ff < (int)uVar1) goto LAB_1000fbc8;
      uVar4 = uVar1 + 0x3ff;
      if ((false) || ((uVar6 & 0xff) != 0x80)) {
        bVar7 = 0xffffff80 < uVar6;
        uVar6 = uVar6 + 0x7f;
        uVar5 = uVar5 + bVar7;
      }
      else if ((uVar6 & 0x100) != 0) {
        bVar7 = 0xffffff7f < uVar6;
        uVar6 = uVar6 + 0x80;
        uVar5 = uVar5 + bVar7;
      }
      if ((0x1fffffff < uVar5) || ((uVar5 == 0x1fffffff && (false)))) {
        uVar6 = uVar5 << 0x1f | uVar6 >> 1;
        uVar5 = uVar5 >> 1;
        uVar4 = uVar1 + 0x400;
      }
    }
    uVar6 = uVar5 << 0x18 | uVar6 >> 8;
    uVar5 = uVar5 >> 8;
    goto LAB_1000fa64;
  }
  uVar5 = 0;
  uVar6 = 0;
LAB_1000fa64:
  return CONCAT44( (uVar5 & 0xfffff) | ((uVar4 & 0x7ff) << 0x14) | (uVar3 << 0x1f),uVar6);
}




uint64_t FUN_1000ecf4(uint param_1,int param_2,uint param_3,int param_4){
  int iVar1;
  uint *puVar2;
  uint uVar3;
  uint uVar4;
  uint uVar5;
  uint uVar6;
  uint uVar7;
  unsigned char in_xer_so=0 ;
  bool bVar8;
  unsigned char in_cr1=0;
  unsigned char unaff_cr2=0;
  unsigned char unaff_cr3=0;
  unsigned char unaff_cr4=0;
  unsigned char in_cr5=0;
  unsigned char in_cr6=0;
  unsigned char in_cr7=0;
  uint64_t uVar9;
  
  uint local_b8[6]; 
  uint local_98[6];
  uint local_78[6];

  uint local_58[2];
  uint local_50[2];


  uint local_48;
  uint local_44;
  uint local_40;
  /*
  printf(RED);
  printf("FUN_1000ecf4.\n");
  printf(DEFAULT);
  */
  puVar2 = &local_b8[0];
  local_58[0] = param_1;
  local_58[1] = param_2; // not used, combined array[2] ????
  local_50[0] = param_3;
  local_50[1] = param_4; // not used, combined array[2] ????
  
  FUN_1000e730(&local_58[0],&local_b8[0]);
  FUN_1000e730(&local_50[0],&local_98[0]);
  local_48 = (uint)(unsigned char)
    ((
     (local_b8[0] == 0) << 3 |
     (1 < local_b8[0]) << 2 |
     (local_b8[0] == 1) << 1 |
     (in_xer_so & 1)
      ) << 0x1c) |
    ((uint)(in_cr1 & 0xf) << 0x18) |
    ((uint)(unaff_cr2 & 0xf) << 0x14) |
    ((uint)(unaff_cr3 & 0xf) << 0x10) |
    ((uint)(unaff_cr4 & 0xf) << 0xc) |
    ((uint)(in_cr5 & 0xf)  << 8) |
    ((uint)(in_cr6 & 0xf) << 4) |
    (uint)(in_cr7 & 0xf);
  if (1 < local_b8[0]) {
    local_44 = (uint)(unsigned char)
      (
       (local_98[0] == 0) << 3 |
       (1 < local_98[0])  << 2 |
       (local_98[0] == 1) << 1 |
       (in_xer_so & 1)
       )                      << 0x1c |
      (uint)(in_cr1    & 0xf) << 0x18 |
      (uint)(unaff_cr2 & 0xf) << 0x14 |
      (uint)(unaff_cr3 & 0xf) << 0x10 |
      (uint)(unaff_cr4 & 0xf) << 0x0c |
      (uint)(in_cr5    & 0xf) << 0x08 |
      (uint)(in_cr6    & 0xf) << 0x04 |
      (uint)(in_cr7    & 0xf) << 0x00;

    
    if (1 < local_98[0]) {
      if (local_b8[0] == 4) {
        if (local_98[0] == 2) {
LAB_1000f0d8:
          puVar2 = (uint *)&DAT_10012738;
          goto LAB_1000efd0;
        }
        goto LAB_1000f0b0;
      }
      if (local_98[0] == 4) {
        if (local_b8[0] == 2) goto LAB_1000f0d8;
      }
      else {
        if (local_b8[0] == 2) goto LAB_1000f0b0;
        if (local_98[0] != 2) {
          iVar1 = 0;
          uVar4 = (uint)((unsigned long long int)local_98[3] * (unsigned long long int)local_b8[4] >> 0x20);
          uVar5 = local_98[3] * local_b8[4];
          uVar7 = uVar5 + local_98[4] * local_b8[3];
          uVar6 = uVar4 + (int)((unsigned long long int)local_98[4] * (unsigned long long int)local_b8[3] >> 0x20) + (uint)CARRY4(uVar5,local_98[4] * local_b8[4]);
          uVar3 = (uint)((unsigned long long int)local_98[4] * (unsigned long long int)local_b8[4] >> 0x20);
          local_98[4] = local_98[4] * local_b8[4];
          if ((uVar6 < uVar4) || ((uVar4 == uVar6 && (uVar7 < uVar5)))) {
            iVar1 = 1;
          }
          uVar4 = 0;
          uVar7 = uVar3 + uVar7;
          if ((uVar7 < uVar3) || ((uVar3 == uVar7 && (false)))) {
            uVar4 = 1;
          }
          uVar3 = uVar6 + local_98[3] * local_b8[3];
          local_78[4] = uVar4 + uVar3;

	  local_78[3] = iVar1 + (int)((unsigned long long int)local_98[3] * (unsigned long long int)local_b8[3] >> 0x20) +
	    (uint)CARRY4(uVar6,local_98[3] * local_b8[3]) +
	    (uint)CARRY4(uVar4,uVar3);

	  
          local_78[1] = (uint)(local_b8[1] != local_98[1]);
          local_78[2] = local_b8[2] + local_98[1] + 4;
          if ((0x1fffffff < local_78[3]) || ((local_78[3] == 0x1fffffff && (false)))) {
            do {
              uVar4 = local_78[4] & 1;
              local_78[4] = local_78[3] << 0x1f | local_78[4] >> 1;
              local_78[3] = local_78[3] >> 1;
              in_cr6 =
		(uVar4 != 0)    << 2 |
		(uVar4 == 0)    << 1 |
		(in_xer_so & 1) << 0;
              uVar3 = uVar7 << 0x1f;
              local_78[2] = local_78[2] + 1;
              in_cr1 =
		(local_78[3] < 0x1fffffff)  << 3 |
		(0x1fffffff < local_78[3])  << 2 |
		(local_78[3] == 0x1fffffff) << 1 |
		(in_xer_so & 1)          << 0;
              if (uVar4 != 0) {
                uVar7 = uVar7 >> 1 | 0x80000000;
                local_98[4] = uVar3 | local_98[4] >> 1;
              }
            } while ((0x1fffffff < local_78[3]) || ((local_78[3] == 0x1fffffff && (false))));
          }
          if ((local_78[3] < 0x10000000) && ((local_78[3] != 0xfffffff || (true)))) {
            do {
              bVar8 = (int)uVar7 < 0;
              local_78[3] = local_78[4] >> 0x1f | local_78[3] << 1;
              local_78[4] = local_78[4] << 1;
              local_78[2] = local_78[2] + -1;
              uVar7 = local_98[4] >> 0x1f | uVar7 << 1;
              local_98[4] = local_98[4] << 1;
              if (bVar8) {
                local_78[4] = local_78[4] | 1;
              }
              local_40 = (uint)(unsigned char)
		(
		 (local_78[3] < 0xfffffff)  << 3 |
		 (0xfffffff < local_78[3])  << 2 |
		 (local_78[3] == 0xfffffff) << 1 |
		 (in_xer_so & 1)         << 0
		 ) << 0x1c |
		(uint)(in_cr1 & 0xf)    << 0x18 |
		(uint)(unaff_cr2 & 0xf) << 0x14 |
		(uint)(unaff_cr3 & 0xf) << 0x10 |
		(uint)(unaff_cr4 & 0xf) << 0x0c |
		(uint)(in_cr5 & 0xf)    << 0x08 |
		(uint)(in_cr6 & 0xf)    << 0x04 |
		(uint)(unsigned char)
		(
		 (local_78[4] != 0xffffffff) << 3 |
		 (local_78[4] == 0xffffffff) << 1 |
		 (in_xer_so & 1)          << 0 
		 );
              in_cr6 =
		((int)local_78[3] < 0xfffffff) << 3 |
		(0xfffffff < (int)local_78[3]) << 2 |
		(local_78[3] == 0xfffffff)     << 1 |
		(in_xer_so & 1)             << 0;
            } while ((0xfffffff >= local_78[3]) && ((local_78[3] != 0xfffffff || (true))));
          }
          if ((true) && (((local_78[4] & 0xff) == 0x80 && (((local_78[4] & 0x100) != 0 || ((uVar7 | local_98[4]) != 0)))))) {
            bVar8 = 0xffffff7f < local_78[4];
            local_78[4] = local_78[4] + 0x80;
            local_78[3] = local_78[3] + bVar8;
          }
          local_78[0] = 3;
          puVar2 = &local_78[0];
          goto LAB_1000efd0;
        }
      }
    }
    local_98[1] = (uint)(local_b8[1] != local_98[1]);
    puVar2 = &local_98[0];
  }
  else {
LAB_1000f0b0:
    local_b8[1] = (uint)(local_b8[1] != local_98[1]);
  }
LAB_1000efd0:
  uVar9 = FUN_1000fa10(puVar2);
  return uVar9;
}



/*
 * chatGPT says:
 * The function is likely designed for manipulating or comparing multi-word values,
 * possibly in the context of multi-precision arithmetic or complex data processing.
 * It involves comparing and manipulating the data pointed to by these parameters and
 * updating param_3
*/

uint * FUN_1000e89c(uint *param_1,uint *param_2,uint *param_3){
  bool bVar1;
  uint uVar2;
  uint uVar3;
  int iVar4;
  uint *puVar5;
  uint uVar6;
  uint uVar7;
  uint uVar8;
  uint uVar9;
  uint uVar10;
  uint uVar11;

  printf(RED);
  printf("FUN_1000e89c.\n");
  printf(DEFAULT);

  uVar10 = *param_1;
  puVar5 = param_1;
  if ((1 < uVar10) && (uVar2 = *param_2, puVar5 = param_2, 1 < uVar2)) {
    if (uVar10 == 4) {
      puVar5 = param_1;
      if ((uVar2 == 4) && (param_1[1] != param_2[1])) {
        puVar5 = (uint *)&DAT_10012738;
      }
    }
    else {
      puVar5 = param_2;
      if (uVar2 != 4) {
        if (uVar2 == 2) {
          puVar5 = param_1;
          if (uVar10 == 2) {
            uVar10 = param_1[2];
            uVar2 = param_1[3];
            param_3[1] = param_1[1];
            *param_3 = 2;
            param_3[2] = uVar10;
            param_3[3] = uVar2;
            uVar10 = param_1[5];
            param_3[4] = param_1[4];
            param_3[5] = uVar10;
            param_3[1] = param_1[1] & param_2[1];
            puVar5 = param_3;
          }
        }
        else {
          puVar5 = param_2;
          if (uVar10 != 2) {
            uVar3 = param_2[2];
            uVar11 = param_1[2];
            uVar2 = param_1[4];
            uVar6 = param_1[5];
            uVar10 = param_2[4];
            uVar7 = param_2[5];
            uVar8 = (int)(uVar11 - uVar3) >> 0x1f;
            if ((int)((uVar8 ^ (uVar11 - uVar3)) - uVar8) < 0x40) {
              uVar8 = uVar3;
              if ((int)uVar3 < (int)uVar11) {
                iVar4 = uVar11 - uVar3;
                do {
                  uVar3 = uVar10 << 0x1f;
                  uVar10 = uVar10 >> 1;
                  uVar7 = (uVar7 & 1) | uVar3 | uVar7 >> 1;
                  iVar4 = iVar4 + -1;
                  uVar8 = uVar11;
                } while (iVar4 != 0);
              }
              uVar3 = uVar11;
              if ((int)uVar11 < (int)uVar8) {
                iVar4 = uVar8 - uVar11;
                do {
                  uVar3 = uVar2 << 0x1f;
                  uVar2 = uVar2 >> 1;
                  uVar6 = (uVar6 & 1) | uVar3 | uVar6 >> 1;
                  iVar4 = iVar4 + -1;
                  uVar3 = uVar8;
                } while (iVar4 != 0);
              }
            }
            else if ((int)uVar3 < (int)uVar11) {
              uVar10 = 0;
              uVar7 = 0;
              uVar3 = uVar11;
            }
            else {
              uVar2 = 0;
              uVar6 = 0;
            }
            uVar8 = param_1[1];
            if (uVar8 == param_2[1]) {
              param_3[1] = uVar8;
              param_3[2] = uVar3;
              param_3[4] = uVar2 + uVar10 + (uint)CARRY4(uVar6,uVar7);
              param_3[5] = uVar6 + uVar7;
            }
            else {
              uVar11 = uVar7 - uVar6;
              uVar9 = uVar10 - (uVar2 + (uVar7 < uVar6));
              if (uVar8 == 0) {
                uVar11 = uVar6 - uVar7;
                uVar9 = uVar2 - (uVar10 + (uVar6 < uVar7));
              }
              if ((int)uVar9 < 0) {
                param_3[2] = uVar3;
                param_3[1] = 1;
                bVar1 = uVar11 != 0;
                uVar11 = -uVar11;
                uVar9 = -(bVar1 + uVar9);
              }
              else {
                param_3[2] = uVar3;
                param_3[1] = 0;
              }
              param_3[4] = uVar9;
              param_3[5] = uVar11;
              uVar2 = param_3[4];
              uVar10 = param_3[5];
              uVar3 = (uVar2 - 1) + (uint)(uVar10 != 0);
              while ((uVar3 < 0x10000000 && ((uVar3 != 0xfffffff || (uVar10 != 0))))) {
                uVar2 = uVar10 >> 0x1f | uVar2 << 1;
                uVar10 = uVar10 << 1;
                uVar3 = (uVar2 - 1) + (uint)(uVar10 != 0);
                param_3[4] = uVar2;
                param_3[5] = uVar10;
                param_3[2] = param_3[2] - 1;
              }
            }
            *param_3 = 3;
            puVar5 = param_3;
            if ((0x1fffffff < param_3[4]) || ((param_3[4] == 0x1fffffff && (false)))) {
              uVar10 = param_3[4];
              param_3[4] = uVar10 >> 1;
              param_3[5] = (param_3[5] & 1) | uVar10 << 0x1f | param_3[5] >> 1;
              param_3[2] = param_3[2] + 1;
            }
          }
        }
      }
    }
  }
  return puVar5;
}


uint64_t FUN_1000ebfc(uint param_1,unsigned int  param_2,uint param_3,unsigned int param_4){
  uint *puVar1;
  uint64_t uVar2;
  uint auStack_88 [8];
  uint auStack_68 [8];
  uint auStack_48 [8];
  uint local_28[2];
  uint local_20[2];
  
  printf(RED);
  printf("FUN_1000ebfc.\n");
  printf(DEFAULT);
  
  local_28[0] = param_1;
  local_28[1] = param_2;
  local_20[0] = param_3;
  local_20[1] = param_4;

  /* FUN_1000e730(uint param_1[2],uint param_2[6-8]) */
  FUN_1000e730(&local_28[0],auStack_88);
  FUN_1000e730(&local_20[0],auStack_68);
  puVar1 = FUN_1000e89c(auStack_88,auStack_68,auStack_48);
  uVar2 = FUN_1000fa10(puVar1);
  return uVar2;
}


uint64_t FUN_1000f0f0(uint param_1,uint32_t param_2,uint param_3,uint32_t param_4){
  uint uVar1;
  uint *puVar2;
  uint uVar3;
  uint uVar4;
  uint uVar5;
  uint uVar6;
  uint uVar7;
  bool bVar8;
  uint64_t uVar9;


  uint *local_78;
  local_78=calloc(8,sizeof(unsigned int));

  uint *local_58;
  local_58=calloc(8,sizeof(unsigned int));

  uint local_38[2];
  //uint32_t local_34;
  uint local_30[2];
  //uint32_t  local_2c;
  
  local_38[0] = param_1;
  local_38[1] = param_2;
  local_30[0] = param_3;
  local_30[1] = param_4;

  /* FUN_1000e730(uint param_1[2],uint param_2[6-8]) */
  FUN_1000e730(&local_38[0],local_78);
  FUN_1000e730(&local_30[0],local_58);
  puVar2 = local_78;
  uVar6 = local_78[3];
  uVar7 = local_78[4];
  if ((1 < local_78[0]) && (puVar2 = local_58, 1 < local_58[0])) {
    local_78[1] = local_78[1] ^ local_58[1];
    if ((local_78[0] == 4) || (local_78[0] == 2)) {
      puVar2 = local_78;
      if (local_78[0] == local_58[0]) {
        puVar2 = (uint *)&DAT_10012738;
      }
    }
    else if (local_58[0] == 4) {
      local_78[3] = 0;
      local_78[4] = 0;
      local_78[2] = 0;
      puVar2 = local_78;
      uVar6 = local_78[3];
      uVar7 = local_78[4];
    }
    else if (local_58[0] == 2) {
      local_78[0] = 4;
      puVar2 = local_78;
    }
    else {
      local_78[2] = local_78[2] - local_58[2];
      if ((local_78[3] < local_58[3]) || ((local_58[3] == local_78[3] && (local_78[4] < local_58[4])))) {
        local_78[2] = local_78[2] + -1;
        uVar6 = local_78[4] >> 0x1f;
        local_78[4] = local_78[4] << 1;
        local_78[3] = uVar6 | local_78[3] << 1;
      }
      uVar6 = 0;
      uVar7 = 0;
      uVar3 = 0x10000000;
      uVar4 = 0;
      do {
        uVar5 = uVar3 << 0x1f | uVar4 >> 1;
        uVar1 = uVar3 >> 1;
        if ((local_58[3] <= local_78[3]) && ((local_58[3] != local_78[3] || (local_58[4] <= local_78[4])))) {
          uVar6 = uVar6 | uVar3;
          uVar7 = uVar7 | uVar4;
          bVar8 = local_78[4] < local_58[4];
          local_78[4] = local_78[4] - local_58[4];
          local_78[3] = local_78[3] - (local_58[3] + bVar8);
        }
        uVar3 = local_78[4] >> 0x1f;
        local_78[4] = local_78[4] << 1;
        local_78[3] = uVar3 | local_78[3] << 1;
        uVar3 = uVar1;
        uVar4 = uVar5;
      } while ((uVar1 | uVar5) != 0);
      puVar2 = local_78;
      if (((true) && ((uVar7 & 0xff) == 0x80)) && (((uVar7 & 0x100) != 0 || ((local_78[3] | local_78[4]) != 0)))) {
        uVar6 = uVar6 + (0xffffff7f < uVar7);
        uVar7 = uVar7 + 0x80;
      }
    }
  }
  local_78[4] = uVar7;
  local_78[3] = uVar6;
  uVar9 = FUN_1000fa10(puVar2);
  return uVar9;
}



/* this funcrion does something with ppc condition register bits */
/* not clear how to translate to x86 code */
/* needed by _130 functio */
uint64_t FUN_1000f6bc(uint param_1){
  bool bVar1;
  uint uVar2;
  //uint32_t tmp = *(volatile uint32_t *)XER;
/* read low bits of cr0 */
/* on some CPUs, only the low 16 bits are correct, */
/* on others all 32 bit are correct */
// uint32_t cr0;

//    register int var __asm__("regname");
  //register int reg asm("smsw %0" : "=r"(cr0));
  //register int reg asm("ebx"); 
  unsigned char in_xer_so=0; //powerpc overflow check?
  unsigned char    in_cr1=0;
  unsigned char unaff_cr2=0;
  unsigned char unaff_cr3=0;
  unsigned char unaff_cr4=0;
  unsigned char    in_cr5=0;
  
  unsigned char bVar3;
  uint64_t uVar4;
  uint local_38;
  int local_34;
  int local_30;
  uint local_28;
  uint local_24;
  uint local_18;
  /*
  printf(RED);
  printf("FUN_1000f6bc.\n");
  printf(DEFAULT);
  */
  uVar2 = (int)param_1 >> 0x1f;
  local_34 = -uVar2;
  local_38 = 3;
  if (param_1 == 0) {
    local_38 = 2;
  } else {
    local_30 = 0x3c;
    if (local_34 != 0) {
      bVar1 = (param_1 == 0x80000000);
      uVar2 = (int)-param_1 >> 0x1f;
      param_1 = -param_1;
      if (bVar1) {
        return 0xc1e0000000000000;
      }
    }
    local_28 = uVar2;
    local_24 = param_1;
    if (
	(uVar2 < 0x10000000) && ((bVar3 = 
				  ((int)uVar2 < 0xfffffff) << 3 |
				  (0xfffffff < (int)uVar2)         << 2 |
				  (uVar2 == 0xfffffff)             << 1 |
				  (in_xer_so & 1)                  << 0,
				  (uVar2 != 0xfffffff) ||
				  (bVar3 =
				   (param_1 != 0xffffffff) << 3 |
				   (param_1 == 0xffffffff) << 1 |
				   (in_xer_so & 1)         << 0,
				   true))))
      {
      local_30 = 0x3c;
      do {
        local_30 = local_30 + -1;
        local_28 = local_24 >> 0x1f | local_28 << 1;
        local_24 = local_24 << 1;
        local_18 = (uint)(unsigned char)(
					 (local_28 < 0xfffffff)   << 3 |
					 (0xfffffff < local_28)   << 2 |
					 (local_28 == 0xfffffff)  << 1 |
					 (in_xer_so & 1)          << 0
					 ) << 0x1c |
	  (uint)(in_cr1 & 0xf)    << 0x18 |
	  (uint)(unaff_cr2 & 0xf) << 0x14 |
	  (uint)(unaff_cr3 & 0xf) << 0x10 |
	  (uint)(unaff_cr4 & 0xf) << 0x0C |
	  (uint)(in_cr5 & 0xf)    << 0x08 |
	  (uint)(unsigned char)(
				((int)local_28 < 0xfffffff) << 3 |
				(0xfffffff < (int)local_28) << 2 |
				(local_28 == 0xfffffff)     << 1 |
				(in_xer_so & 1)             <<0
				) << 4 | (uint)bVar3;
        if (0xfffffff < local_28) break;
      } while (
	       (local_28 != 0xfffffff) ||
	       (bVar3 = (local_24 != 0xffffffff) << 3 |
		(local_24 == 0xffffffff)         << 1 |
		(in_xer_so & 1)                  << 0,
		true)
	       );
    }
  }
  uVar4 = FUN_1000fa10(&local_38);
  return uVar4;
}



/* FUN_10002160 */
/*
 * name should bew something like:
 * int verify_mtd_md5sum(char *partition_name,int param_2,void *param_3){
 */
//int open_mtd_for_input_internal(char *partition_name,int param_2,void *param_3){
int verify_mtd_md5sum(char *partition_name,void *param_3){
  
  int i;
  size_t len;
  int iVar2;

  char *input_buffer = calloc(1024,sizeof(char));
  size_t input_size = 0;
  MD5Context ctx;

  char *dev; /* undefined4 uStack_10058; */
  char *mtd; /* undefined4 uStack_10054; */
  char *dash;
  char *cmd;
  cmd=calloc(0x100,sizeof(unsigned char));

  unsigned char *md5sum;
  md5sum=calloc(0x20,sizeof(char));


  //printf(RED);
  //printf("verify_mtd_md5sum, FUN_10002160.\n");
  //printf(DEFAULT);

  char *full_path;
  full_path=calloc(0x80,sizeof(char));

  dev = "dev";  
  mtd = "/mtd";
  dash = "-\0\0\0";
  len = strlen(dev);
  strncat(full_path,dev,len);
  len = strlen(mtd);
  strncat(full_path,mtd,len);
  len = strlen(dash);
  strncat(full_path,dash,len);
  len = strlen(partition_name);
  strncat(full_path,partition_name,len);

  FILE *file;
  file=fopen(full_path,"r");

  if (file == NULL) {
    printf("file == NULL\n");
    fclose(file);
    free(full_path);
  }
  else {
    //printf("Verify partition: %s, md5sum: ",full_path);

    md5Init(&ctx);
    while((input_size = fread(input_buffer, 1, 1024, file)) > 0){
        md5Update(&ctx, (uint8_t *)input_buffer, input_size);
    }
    md5Finalize(&ctx);

    free(input_buffer);
    memcpy(md5sum, ctx.digest, MD5_DIGEST_LENGTH);

    fclose(file);

    for(i=0; i<MD5_DIGEST_LENGTH; i++){
      printf("%2.2X",md5sum[i]);
    }
    printf("\n");


    /*
     * Comparing result of FUN_10006944 with param_3
     * both shoudl have identical md5sum and
     * iVar2 should return 0
     * do_analysis should also have found the md5sum in the partition header
     */
    iVar2 = memcmp((unsigned char*)param_3,md5sum,0x10);


    free(cmd);
    free(md5sum);
    free(full_path);
    return iVar2;

  }
  return -1;
}


/* FUN_10001edc */
/*
 * name should be something like: 
 * unsigned int copy_partition_to_mtd_device(int fd,char *partition_name,int param_3) {
 */
//unsigned int open_mtd_for_output_internal(int fd,char *partition_name,int param_3) {
unsigned int copy_partition_to_mtd_device(int fd,partition p) {

  int iVar1;
  size_t len;
  int __fd;
  char *__s;
  ssize_t sVar3;
  uint uVar4;
  uint uVar5;
  int iVar6;
  int iVar7;
  uint64_t uVar8;
  uint64_t uVar9;

  char *dev; /* undefined4 uStack_10058; */
  char *mtd; /* undefined4 uStack_10054; */
  char *dash;
  unsigned char  data[65536];
  unsigned int local_38[5];

  //printf(RED);
  //printf("copy_partition_to_mtd_device, FUN_10001edc.\n");
  //printf(DEFAULT);

  char *full_path;
  full_path=calloc(0x80,sizeof(char));

  char* partition_name = p->name;
  
  dev = "dev";  
  mtd = "/mtd";
  dash = "-\0\0\0";
  len = strlen(dev);
  strncat(full_path,dev,len);
  len = strlen(mtd);
  strncat(full_path,mtd,len);
  len = strlen(dash);
  strncat(full_path,dash,len);
  len = strlen(partition_name);
  strncat(full_path,partition_name,len);

  uVar5 = 0xfffffff6;


  lseek(fd,p->offset,SEEK_SET);

  if(access((char*)full_path,F_OK) == -1)
    __fd = open((char *)full_path,O_WRONLY | O_APPEND | O_CREAT, 0666);
  else
    __fd = open((char *)full_path,O_SYNC|O_RDWR);

  
  if (__fd == -1) {
    printf("error opening %s\n",full_path);
  }
  else {
    //printf("Copy partition data to: %s.\n",full_path);
    iVar7 = 0;
    iVar6 = 0;
    if (0 < p->jump_size) {
      do {
        len = p->jump_size - iVar6;
        if (0x10000 < (int)len) {
          len = 0x10000;
        }
        len = read(fd,data,len);  // read data form hpoa bin file
        if (len == 0) {
	  break;
	}
	
        if (len == 0xffffffff) {
          __s = "em_flash: read";
LAB_10001f7c:
          printf("%s\n",__s);
          break;
        }
        iVar6 = iVar6 + len;
        sVar3 = write(__fd,data,len); // write data to mtd device
        if (sVar3 == -1) {
          __s = "em_flash: write";
          goto LAB_10001f7c;
        }
        iVar7 = iVar7 + sVar3;

	unsigned int DAT_10022c24=0;
        uVar4 = DAT_10022c24 + sVar3;
        DAT_10022c24 = uVar4;
        if (uVar4 != 0) {
	  uVar8 = FUN_1000f6bc(uVar4); /* was: uVar8 = FUN_1000a8c4(); */
          if ((int)uVar4 < 0) {
            uVar8 = FUN_1000ebfc((int)((unsigned long long int)uVar8 >> 0x20),(int)uVar8,0x41f00000,0);
          }
	  unsigned int DAT_10022c20=0;
	  iVar1 = DAT_10022c20;
          uVar9 = FUN_1000f6bc(DAT_10022c20);  /* was 1000fbbc */
          if (iVar1 < 0) {
            uVar9 = FUN_1000ebfc((int)((unsigned long long int)uVar9 >> 0x20),(int)uVar9,0x41f00000,0);
          }
          uVar8 = FUN_1000f0f0((int)((unsigned long long int)uVar8 >> 0x20),(int)uVar8,(int)((unsigned long long int)uVar9 >> 0x20),(int)uVar9);
          uVar8 = FUN_1000ecf4((int)((unsigned long long int)uVar8 >> 0x20),(int)uVar8,0x40590000,0);
	  uVar4 = FUN_1000f7dc((uint)((unsigned long long)uVar8 >> 0x20),(int)uVar8);

	  /*problem with function below */
          //uVar4 = FUN_1000a9e4();
        }
        local_38[0] = uVar4;

	
        if (((int)uVar5 < (int)uVar4) && ((uVar4 & 1) == 0)) {
          //generate_event(0x1203,0,local_38,4);
          uVar5 = local_38[0];
        }

        if ((local_38[0] & 1) == 0) {
          //printf("\b\b\b\b%3d%%"); //should give some percentage I guess
          //fflush(stdout);
        }
        fsync(__fd);
      } while (iVar7 < p->jump_size);
      //printf("\n");
    }
    close(__fd);

    if (p->jump_size <= iVar7 && p->jump_size <= iVar6) {
      return 0;
    }
    printf("error tr %d tw %d nbytes %d\n",iVar6,iVar7,p->jump_size);
  }
  return 0xffffffff;
}


int FUN_1000f7dc(unsigned int param_1,unsigned int param_2){
  uint64_t uVar1;
  uint local_18[2]; 

  uint *local_38;
  local_38=calloc(8,sizeof(unsigned int));
  
  //printf(RED);
  //printf("FUN_1000f7dc.\n");
  //printf(DEFAULT);
   
  local_18[0] = param_1;
  local_18[1] = param_2;

  FUN_1000e730(&local_18[0],local_38);

  if (*(local_38+0) == 2) {
    return 0;
  }
  if (*(local_38+0) < 2) {
    return 0;
  }
  if (*(local_38+0) != 4) {
    if (*(local_38+2) < 0) {
      return 0;
    }
    if (*(local_38+2) < 0x1f) {
      uVar1 = FUN_1000f988(*(local_38+3),*(local_38+4),0x3c - *(local_38+2));
      if (*(local_38+1) == 0) {
	return (int)uVar1;
      }
      return -(int)uVar1;
    }
  }
  return -0x80000000 - (uint)(*(local_38+1) == 0);
}



int cpqem_find_tag_ex(char *param_1,char *param_2,char *param_3,size_t param_4,uint param_5)
{
  int sVar1;
  char *pcVar2;
  char *pbVar3;
  char *pbVar4;


  sVar1 = strlen(param_2);
  pbVar3 = param_1;
  do {
    pcVar2 = strstr((char *)pbVar3,param_2);
    pbVar3 = (char *)(pcVar2 + sVar1);
    if (pcVar2 == (char *)0x0) {
      return 0;
    }
  } while (
	   ( (pbVar3 != param_1 + sVar1) && (pbVar3[-1 - sVar1] != 10) ) ||
	   (*pbVar3 != param_5)
	   );
  
  if (pbVar3[1] == '\"') {
    pbVar3 = pbVar3 + 2;
  } else {
    pbVar3 = pbVar3 + (pbVar3[1] == '\'') + 1;
  }
  
  pbVar4 = (char *)strpbrk((char *)pbVar3,"\'\"\n");
  if (pbVar4 == (char *)0x0) {
    pbVar4 = pbVar3;
  }
  
  sVar1 = (int)*pbVar4 - (int)*pbVar3;

  if ((int)param_4 <( (int)*pbVar4 - (int)*pbVar3 ) ){
    sVar1 = param_4;
  }
  strncpy((char*)param_3,(char *)pbVar3,sVar1);
  //  printf("%s, %s, %i\n",param_3,pbVar3,(int)sVar1);

  param_3[sVar1] = '\0';
  //  printf("%s, %s\n",param_3,pbVar3);
  //printf("ret:: %i\n",*pbVar3-0x30);
  return *pbVar3-0x30;
}



int find_tag_in_file(char *file_name, char *tag, char *param_3, size_t param_4, unsigned int param_5){
  FILE *__stream;
  int iVar1;
  __ssize_t _Var2;
  int iVar3;
  char *local_28;
  size_t asStack_24 [2];

  iVar3 = 0;
  local_28 = (char *)0x0;
  __stream = fopen(file_name,"r");
  iVar1 = 0;
  if (__stream != (FILE *)0x0) {
    do {
      _Var2 = getline(&local_28,asStack_24,__stream);

      iVar1 = iVar3;
      if (_Var2 < 1) break;
      iVar3 = cpqem_find_tag_ex(local_28,tag,param_3,param_4,param_5);
      iVar1 = iVar3;
    } while (iVar3 == 0);
    if (local_28 != (char *)0x0) {
      free(local_28);
    }
    fclose(__stream);
  }
  return iVar1;
}


int em_type(void){  // not used right now
  char local_28 [32];
  int emtype=0;
  local_28[0] = '\0';
  //find_tag_in_file("/etc/gpio_states","OABOARDTYPE",local_28,0x10,0);
  emtype=find_tag_in_file("gpio_states","OABOARDTYPE",local_28,0x10,'=');
  return emtype;
}


#if 0
//void do_housekeeping(void){
  /* Start with houskeeping */

  //system("rm -rf dev/*");
  //system("mkdir dev");
  //system("touch dev/mtd-kernel");
  //system("touch dev/mtd-initrd");
  //system("touch dev/mtd-squashfs");
  //system("touch dev/mtd-uboot");
  //system("touch dev/mtd-storage");
  //system("touch dev/mtd-fwmgmt");
  //system("touch dev/mtd-certs");
  //system("touch dev/mtd-config");

}
#endif

void my_md5sum(char *file_name, char *md5_sum){
  int i;
  int input_size;
  MD5Context ctx;
  char *input_buffer = malloc(1024);

  FILE *file;
  file=fopen(file_name,"r");

  if (file == NULL) {
    printf("file == NULL\n");
    fclose(file);
  } else {
    md5Init(&ctx);
    while((input_size = fread(input_buffer, 1, 1024, file)) > 0){
        md5Update(&ctx, (uint8_t *)input_buffer, input_size);
    }
    md5Finalize(&ctx);

    free(input_buffer);
    memcpy(md5_sum, ctx.digest, MD5_DIGEST_LENGTH);
    fclose(file);
  }
}


int modify_partition(partition p,char *partition_name,int nr_partitions){
  int i;
  char *cmd;
  cmd=calloc(0x100,sizeof(char));

  int loopctlfd, loopfd, backingfile;
  long devnr;
  char loopname[0x100];

  printf(RED);
  printf("modify_partition.\n");
  printf(DEFAULT);

  sprintf(loopname, "/dev/loop%i", get_free_loop());
  //printf("loopname = %s\n", loopname);

  memset(cmd,'\0',0x100);
  strcpy(cmd,"mkdir dev/mnt-");
  strcat(cmd,partition_name);
  // printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd,"sync");  
  //printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd,"tail -c+65 dev/mtd-");
  strcat(cmd,partition_name);
  strcat(cmd," | gunzip >& dev/");
  strcat(cmd,partition_name);
  strcat(cmd, " ; ");
  strcat(cmd,"sync");  
  //printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd ,"losetup ");
  strcat(cmd, loopname);
  strcat(cmd," dev/");
  strcat(cmd,partition_name);
  //printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd, "mount -o loop ");
  strcat(cmd, loopname);
  strcat(cmd, " dev/mnt-");
  strcat(cmd,partition_name);
  strcat(cmd, " ; ");
  strcat(cmd,"sync");  
  //printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd, "echo \"udog:pD.WvCQWQJ4Kc:0:0:0,,:/:/bin/sh\" > passwd.new ");
  strcat(cmd, " ; ");  
  strcat(cmd,"sync");  
  //printf("%s\n",cmd);
  system(cmd);
  
  memset(cmd,'\0',0x100);
  strcpy(cmd, "grep -v -e '^udog:' ");
  strcat(cmd, "dev/mnt-");
  strcat(cmd, partition_name);
  strcat(cmd, "/etc/passwd >> passwd.new");
  strcat(cmd, " ; ");  
  strcat(cmd,"sync");  
  //printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd, "mv passwd.new ");
  strcat(cmd, "dev/mnt-");
  strcat(cmd, partition_name);
  strcat(cmd, "/etc/passwd");
  strcat(cmd, " ; ");  
  strcat(cmd,"sync");  
  //printf("%s\n",cmd);
  system(cmd);
  
  memset(cmd,'\0',0x100);
  strcpy(cmd,"chmod 666 ");
  strcat(cmd, "dev/mnt-");
  strcat(cmd, partition_name);
  strcat(cmd, "/etc/passwd");
  strcat(cmd, " ; ");
  strcat(cmd,"sync");  
  //printf("%s\n",cmd);
  system(cmd);
  
  memset(cmd,'\0',0x100);
  strcpy(cmd,"chown 1:1 ");
  strcat(cmd, "dev/mnt-");
  strcat(cmd, partition_name);
  strcat(cmd, "/etc/passwd");
  strcat(cmd, " ; ");
  strcat(cmd,"sync");
  //printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd,"cp rc.sysinit ");
  strcat(cmd, "dev/mnt-");
  strcat(cmd, partition_name);
  strcat(cmd, "/etc/rc.sysinit");
  strcat(cmd, " ; ");
  strcat(cmd,"sync");
  //printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd,"dd if=");
  strcat(cmd, loopname);
  strcat(cmd, " status=none | gzip -9 > ");
  strcat(cmd,partition_name);
  strcat(cmd,".gz");
  //printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd,"losetup -d ");
  strcat(cmd, loopname);
  strcat(cmd, " ; ");
  strcat(cmd,"sync");
  //printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd,"umount dev/mnt-");
  strcat(cmd,partition_name);
  strcat(cmd, " ; ");
  strcat(cmd,"sync");
  //printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd,"rm -rf dev/mnt-");
  strcat(cmd,partition_name);
  //printf("%s\n",cmd);
  system(cmd);
  
  memset(cmd,'\0',0x100);
  strcpy(cmd, "mkimage -d ");
  strcat(cmd, partition_name);
  strcat(cmd, ".gz -n \'\"");
  strcat(cmd, partition_name);
  strcat(cmd, " 141208-0921 build\"\' -T ramdisk dev/mtd-");
  strcat(cmd, partition_name);
  strcat(cmd, ".mod");
  strcat(cmd," >& /dev/null");
  strcat(cmd, " ; ");
  strcat(cmd,"sync");  
  //printf("%s\n",cmd);
  system(cmd);
  
  /* must do md5 of gzipped partition before mkimage adds header */
  memset(cmd,'\0',0x100);
  strcpy(cmd,"md5sum  ");
  strcat(cmd,partition_name);
  strcat(cmd,".gz >/dev/null");
  strcat(cmd, " ; ");
  strcat(cmd,"sync");
  //printf("%s\n",cmd);
  system(cmd);

  char* md5_sum;
  md5_sum=calloc(MD5_DIGEST_LENGTH, sizeof(unsigned char));
  char *filename = calloc(0x100,sizeof(char));
  strcpy(filename,"dev/mtd-");
  strcat(filename,partition_name);
  strcat(filename, ".mod");
  my_md5sum(filename,md5_sum);

  
  memset(cmd,'\0',0x100);
  strcpy(cmd,"rm ");
  strcat(cmd,partition_name);
  strcat(cmd,".gz >& /dev/null");
  strcat(cmd, " ; ");
  strcat(cmd,"sync");  
  //printf("%s\n",cmd);
  system(cmd);


  md5_sum=calloc(MD5_DIGEST_LENGTH, sizeof(unsigned char));
  strcpy(filename,"dev/mtd-");
  strcat(filename,partition_name);
  strcat(filename, ".mod");

  // need partition_size to calculate offset and recalculate the header and data crc32
  // all needs to be put in the patrition struct

  printf("filename: %s\n",filename);
  int fd;
  if(fd=open(filename,O_RDONLY), fd<0){
    printf("error fd: %i\n",fd);
    exit(-1);
  }  
  int file_location;   //moet hier nog 0x40 van af?
  if(file_location = lseek(fd,0,SEEK_END), file_location <0){
    printf("file location error: %i\n",file_location);
    exit(-1);
  }

  (p+nr_partitions)->offset= (p+1)->offset;
  (p+nr_partitions)->jump_size=file_location;

  uint32_t crc;

  lseek(fd,1*sizeof(unsigned int),SEEK_SET);
  read(fd, &crc, sizeof(unsigned int));
  if(!is_bigendian()) crc = __htobe32(crc);
  (p+nr_partitions)->header_crc32=crc;

  lseek(fd,6*sizeof(unsigned int),SEEK_SET);
  read(fd, &crc, sizeof(unsigned int));
  if(!is_bigendian()) crc = __htobe32(crc);
  (p+nr_partitions)->data_crc32=crc;
  
  close(fd);
  printf("dev/mtd-initrd.mod jumpsize: 0x%X\n", (p+nr_partitions)->jump_size);
  my_md5sum(filename,md5_sum);

  memcpy((p+nr_partitions)->md5, md5_sum, MD5_DIGEST_LENGTH);

  memset(filename,'\0',0x100);
  strcpy(filename,partition_name);
  strcat(filename, ".mod");
  strcpy((p+nr_partitions)->name, filename);
  (p+nr_partitions)->nr = partition_nr_selector((p+nr_partitions)->name);

  free(filename);

  nr_partitions++;
  return nr_partitions;
}


int  verify_initrd(void){

  int fd;
  char *data;
  char *burned;
  data=calloc(0x100,sizeof(char));
  burned=calloc(0x100,sizeof(char));
    
  int fd_burned;
  int len;
    
  fd=open("mtd-initrd", O_RDONLY);
  if(fd<0){
    printf("could not open mtd-initrd\n");
    return(-1);
  }

    
  fd_burned=open("/dev/mtd-initrd", O_SYNC|O_RDWR);
  if(fd_burned<0){
    printf("could not open /dev/mtd-initrd\n");
    return(-1);
  }
    
  while(len=read(fd, data,0x100),len>0){
    read(fd_burned, burned,len);
    if(memcmp(data,burned,len)!=0){
      printf("Burned data does not match initrd\n");
      close(fd);
      close(fd_burned);
    }
  }
  close(fd);
  close(fd_burned);
        
  return(0);
}

 
int  write_initrd(void){

  int fd;
  char *data;
  data=calloc(0x1000,sizeof(char));
  
  int fd_initrd;
  int len;
  
  fd_initrd=open("mtd-initrd", O_RDONLY);
  if(fd_initrd<0){
    printf("could not open initrd\n");
    return(-1);
  }

  
  fd=open("/dev/mtd-initrd", O_SYNC|O_RDWR);
  if(fd<0){
    printf("could not open /dev/mtd-initrd\n");
    return(-1);
  }
  
  while(len=read(fd_initrd,data,0x1000),len>0){
    write(fd,data,len);
  }
  close(fd);
  close(fd_initrd);
  
  return(0);
}




void do_sha256_test(void){
    
  printf(BLUE);
  printf("/*********************************/\n");
  printf("/*       Start SHA256 test       */\n");
  printf("/*********************************/\n");
  printf(DEFAULT);

  sha256_ctx ctx;
  
  u_int8_t *results;


  char *buf;
  buf=calloc(0x200,1);
  int n;

  results = calloc(SHA256_DIGEST_SIZE,sizeof(u_int8_t));  
  strcpy(buf,"Marcel is gek! Wie is er nog meer gek?");
  printf("sha256 of '%s'\n",buf);
  n = strlen(buf);
  
  sha256_init(&ctx);
  sha256_update(&ctx, (u_int8_t *)buf, n);
  sha256_final(&ctx, results);

  /* Print the digest as one long hex value */
  for (n = 0; n < SHA256_DIGEST_SIZE; n++)
    printf("%02x", results[n]);
  putchar('\n');


  printf("https://emn178.github.io/online-tools/sha256.html says: \n");
  printf("8879886cd88241725cfb3af4b25fd2110c553c9e58d193b8b622a9479c761ff8\n");

  printf(BLUE);
  printf("/*********************************/\n");
  printf("/*       End SHA256 test         */\n");
  printf("/*********************************/\n");
  printf(DEFAULT);

}

size_t FUN_10005d64(int fd,void *buffer,size_t len,sha256_ctx *ctx){
  size_t sVar1;

  //printf(RED);
  //printf("FUN_10005d64, len: 0x%lX\n", len);
  //printf(DEFAULT);
  
  sVar1 = 0xffffffff;
  if ((int)len > 0) {
    do {
      sVar1 = read(fd,buffer,len);
      if ((int)sVar1 < 1) {
        return len;
      }
      sha256_update(ctx,buffer,sVar1);
      len = len - sVar1;
      buffer = (void *)((int*)buffer + sVar1);
    } while ((int)len > 0);
    //printf("len is not > 0, sha256_update should be finished!\n");
    sVar1 = 0;
  }else{
    printf("len is not > 0");
  }
  return sVar1;
}



uint FUN_10005cdc(int fd,uint param_2,sha256_ctx *ctx){
  uint uVar1;
  size_t sVar2;
  unsigned char auStack_2018 [0x2008];

  //printf(RED);
  //printf("FUN_10005cdc\n");
  //printf(DEFAULT);
  
  uVar1 = 0xffffffff;
  if ((int)param_2 >0) {
    do {
      sVar2 = 0x2000;
      if (param_2 < 0x2000) {
        sVar2 = param_2;
      }
      sVar2 = read(fd,auStack_2018,sVar2);
      if ((int)sVar2 < 1) {
	//printf("return param_2 is 0x%X, is sha256_update finished?\n",param_2);
        return param_2;
      }
      sha256_update(ctx,auStack_2018,sVar2);
      param_2 = param_2 - sVar2;
    } while ((int)param_2 > 0);
    uVar1 = 0;
    //printf("param_2 is not > 0, sha256_update should be finished.\n");
  }else{
    printf("param_2 is not > 0\n");
  }
  return uVar1;
}



/* this dunction does the actual sha256 hash */
uint32_t FUN_10005de8(int fd,unsigned char *sha256_buffer,unsigned char *digest){
  int n;
  int len=0;
  bool bVar1;
  uint32_t uVar2=0xFFFFFFFF;
  int iVar3;
  size_t sVar4;
  int *piVar5=0;
  unsigned char *pbVar6;
  uint jump_size_sum;
  int iVar8;
  sha256_ctx ctx;
  uint8_t results[SHA256_DIGEST_SIZE];
  unsigned char buffer[0x20];      // ustack_58[0], only need 0x0e bytes
  //  unsigned char  local_57;     // uStack_58[1]
  unsigned int uStack_48[0x30];    // uStack_48[0], only need 0x15 bytes
  //int local_47;                  // uStack_48[1] 

  //printf(RED);
  //printf("FUN_10005de8\n");
  //printf(DEFAULT);

  //line_print_16_bytes(sha256_buffer,HEADER_SIZE);
  
#if 0
  printf("file_location: 0x%lX\n",lseek(fd,0,SEEK_CUR));
  sha256_init(&ctx);
  while(len=read(fd,buffer,0x0E),len>0){
    sha256_update(&ctx,buffer, len);
  }

  printf("file_location: 0x%lX\n",lseek(fd,0,SEEK_CUR));
  sha256_final(&ctx,digest); //was sha256_Final(param_3,&SStack_c8);
  //line_print_16_bytes(digest,4*SHA256_DIGEST_SIZE);
  //line_print_16_bytes(sha256_buffer+0x55,4*SHA256_DIGEST_SIZE);

#endif

#if 1 
  pbVar6 = (unsigned  char *)0x0;
  uVar2 = 0xffffffff;
  /* the if case below should alwase be true */
  if (((fd > -1) && (sha256_buffer != (unsigned char *)0x0)) && (*sha256_buffer - 1 < 2)) {
    iVar8 = 0;
    sha256_init(&ctx);
    bVar1 = false;

    do {
      iVar8 = iVar8 + 1;
      if ((bVar1) && (sha256_buffer[0x40] == 0)) {
        pbVar6 = sha256_buffer + 0x45;
        break;
      }
      bVar1 = iVar8 == 3;
    } while (iVar8 < 4);

    piVar5 = (int *)(sha256_buffer + 2); // jump_size location
    iVar8 = 4;
    jump_size_sum = 0;

    do {
      iVar3 = *piVar5;
      if(!is_bigendian()) iVar3 = __htobe32(iVar3);
      piVar5 = (int *)((char*)piVar5 + 0x15); // goto next jump_size location
      jump_size_sum = jump_size_sum + iVar3;  // sum of jump size
      iVar8 = iVar8 + -1;
      //printf("piVar5: 0x%08X, iVar3: 0x%08X, uVar7: 0x%X\n",piVar5, iVar3, jump_size_sum);
    } while (iVar8 != 0);  //loops 4 times, same as in analysis

    /* i can get jumpsize sum from partition struct */

    //printf("\njump_size_sum: 0x%X\n",jump_size_sum);
    jump_size_sum = FUN_10005cdc(fd,jump_size_sum,&ctx);  //do the sha256_update over size uVar7
    //printf("after FUN_10005cdc jump_size_sum: 0x%X\n",jump_size_sum); // should be 0

    uVar2 = 0xffffffff;

    int pbVar6_plus_8 = *(int *)(pbVar6 + 8);
    if(!is_bigendian()) pbVar6_plus_8 = __htobe32(pbVar6_plus_8);
    //printf("jump_size_sum: 0x%X, pbVar6_plus_8: 0x%X\n",jump_size_sum,pbVar6_plus_8 );
    //printf("pbVar6: 0x%08X\n",pbVar6);
    
    if (jump_size_sum == 0) {
      if ((pbVar6 != (unsigned char *)0x0) && (pbVar6_plus_8 != 0)) {
	/* read 0xe bytes and store them at uStack_58 */
	/* do the sha256_update */
        sVar4 = FUN_10005d64(fd,&buffer[0],0xe,&ctx);
        if (sVar4 != 0) {
	  printf("sVar4 is not 0\n");
          return 0xffffffff;
        }
        jump_size_sum = 0;
        iVar8 = 0;
        if (buffer[1] != 0) {

          do {
            iVar8 = iVar8 + 1;
	    /* do the sha256_update */
            sVar4=FUN_10005d64(fd,&uStack_48[0],0x15,&ctx); 
	    if (sVar4 != 0) {
	      printf("sVar4 is not 0\n");
	      return 0xffffffff;
	    }

	    unsigned int new_jump_size = *(uint*)((uint8_t*)uStack_48+1);
	    if(!is_bigendian()) new_jump_size = __htobe32(new_jump_size);
	    //printf("new jump_size: 0x%08X\n", new_jump_size);
            jump_size_sum = jump_size_sum + new_jump_size; 
	    //printf("iVar8: %i, (int)(uint)buffer[i]: 0x%X\n",iVar8,(int)(uint)buffer[1]);
          } while ((int)(uint)buffer[1] > iVar8);
	  
        }

	/* jump_size_sum should be >0 otherwise 5cdc returns 0xFFFFFFFF */
        jump_size_sum = FUN_10005cdc(fd,jump_size_sum,&ctx);
	//printf("jump_size_sum: 0x%X, need to be zero!!!, otherwise return -1\n",jump_size_sum);

        if (jump_size_sum != 0) {
	  printf("jump_size_sum is not 0\n");
          return 0xffffffff;
        }
      }

      sha256_final(&ctx,digest); //was sha256_Final(param_3,&SStack_c8);
      uVar2 = 0;
    }else{
      printf("jump_size_sum is not 0!!!\n");
    }// end of if (jump_size_sum == 0)
  }
#endif

  return uVar2;
}



void line_print_16_bytes(unsigned char * data,int len){
  int i;

  printf(RED);
  printf("line_print_16_bytes\n");
  printf(DEFAULT);

  for(i=0;i<len;i++){
    printf("%02X ",*(data+i));
    if(((i+1)%0x10)==0) printf("\n");
  }
  printf("\n");
}


void FUN_10008f90(void *param_1,int param_2,size_t param_3){

  printf(RED);
  printf("FUN_10008f90\n");
  printf(DEFAULT);

  if (param_3 != 0) {
    memset(param_1,param_2,param_3);
  }
  return;
}


uint32_t FUN_1000a4c0(int *param_1,int *param_2,int param_3){
  int i;
  printf(RED);
  printf("FUN_1000a4c0\n");
  printf(DEFAULT);
  
  i=  param_3 -1;
  while( true ) {
    if (i < 0) {
      return 0;
    }
    if (*(uint *)(param_2 + i*4) < *(uint *)(param_1 + i*4)) break;
    if (*(uint *)(param_1 + i*4) < *(uint *)(param_2 + i*4)) return 0xffffffff;
    i= i -1;
  }
  return 1;
}


int FUN_1000a6bc(int *param_1,int param_2){  //very starnge function
  int i;

  printf(RED);
  printf("FUN_1000a6bc\n");
  printf(DEFAULT);
  
  for(i = param_2 + -1; ( (-1 < i) && ((i * 4 + param_1) == 0)); i = i -1) {
  }
  return i + 1;
}



uint FUN_10009824(int *param_1,int *param_2,uint param_3,uint param_4){
  uint local_24;
  uint i;
  
  uint local_18;
  uint local_14;
  
  printf(RED);
  printf("FUN_10009824\n");
  printf(DEFAULT);

  if (param_3 < 0x20) {
    local_24 = 0;
    for (i = 0; i < param_4; i = i + 1) {
      
      local_14 = *(uint *)(i*4 + param_2);
      *(uint *)(i*4 + param_1) = local_14 << (param_3 & 0x3f) | local_24;
      
      if (param_3 == 0) {
        local_14 = 0;
      }
      else {
        local_14 = local_14 >> (0x20 - param_3 & 0x3f);
      }
      local_24 = local_14;
    }
    local_18 = local_24;
  }
  else {
    local_18 = 0;
  }
  return local_18;
}


uint FUN_10009924(int param_1,int param_2,uint param_3,int param_4){
  uint local_24;
  int  local_20;
  uint local_18;
  uint local_14;
  
  printf(RED);
  printf("FUN_10009924\n");
  printf(DEFAULT);

  if (param_3 < 0x20) {
    local_24 = 0;
    for (local_20 = param_4 + -1; -1 < local_20; local_20 = local_20 + -1) {
      local_14 = *(uint *)(local_20 * 4 + param_2);
      *(uint *)(local_20 * 4 + param_1) = local_14 >> (param_3 & 0x3f) | local_24;
      if (param_3 == 0) {
        local_14 = 0;
      }
      else {
        local_14 = local_14 << ((0x20 - param_3) & 0x3f);
      }
      local_24 = local_14;
    }
    local_18 = local_24;
  }
  else {
    local_18 = 0;
  }
  return local_18;
}

void FUN_1000b104(int *param_1,int *param_2,uint param_3) {
  ushort uVar1;
  uint uVar2;
  int iVar3;
  uint     local_28;
  uint32_t local_24;
  ushort   local_18;
  ushort   local_16;
  
  printf(RED);
  printf("FUN_1000b104\n");
  printf(DEFAULT);

  uVar1 = (ushort)(param_3 >> 0x10);
  local_24 = param_2[1];
  if (uVar1 == 0xffff) {
    local_18 = (ushort)(local_24 >> 0x10);
  }
  else {
    local_18 = (ushort)(local_24 / (uVar1 + 1));
  }
  uVar2 = (uint)local_18 * (param_3 & 0xffff);
  local_28 = *param_2 + uVar2 * -0x10000;
  if (uVar2 * -0x10000 - 1 < local_28) {
    local_24 = local_24 - 1;
  }
  local_24 = (local_24 - (uVar2 >> 0x10)) - (uint)local_18 * (uint)uVar1;
  while ((uVar1 < local_24 || ((local_24 == uVar1 && (param_3 << 0x10 <= local_28))))) {
    local_28 = local_28 + (param_3 & 0xffff) * -0x10000;
    if ((param_3 & 0xffff) * -0x10000 - 1 < local_28) {
      local_24 = local_24 - 1;
    }
    local_24 = local_24 - uVar1;
    local_18 = local_18 + 1;
  }
  if (uVar1 == 0xffff) {
    local_16 = (local_24>>16)&0xFFFF;
  }
  else {
    local_16 = (ushort)((local_24 * 0x10000 + (local_28 >> 0x10)) / (uVar1 + 1));
  }
  iVar3 = (uint)local_16 * (param_3 & 0xffff);
  uVar2 = (uint)local_16 * (uint)uVar1;
  local_28 = local_28 - iVar3;
  if (-iVar3 - 1U < local_28) {
    local_24 = local_24 - 1;
  }
  local_28 = local_28 + uVar2 * -0x10000;
  if (uVar2 * -0x10000 - 1 < local_28) {
    local_24 = local_24 - 1;
  }
  local_24 = local_24 - (uVar2 >> 0x10);
  while ((local_24 != 0 || ((true && (param_3 <= local_28))))) {
    local_28 = local_28 - param_3;
    if (-param_3 - 1 < local_28) {
      local_24 = local_24 + -1;
    }
    local_16 = local_16 + 1;
  }
  *param_1 = (uint)local_18 * 0x10000 + (uint)local_16;
  return;
}



int FUN_10009580(int *param_1,int *param_2,int *param_3,uint param_4){
  uint local_28;
  int  local_24;
  uint i;
  static int once=0;

  if(once==0){
    printf(RED);
    printf("FUN_10009580\n");
    printf(DEFAULT);
    once=1;
  }
  local_24 = 0;
  for (i= 0; i < param_4; i = i + 1) {
    local_28 = *(int *)(i*4 + param_2) - local_24;
    if (-local_24 - 1U < local_28) {
      local_28 = -*(int *)(i*4 + param_3) - 1;
    }
    else {
      local_28 = local_28 - *(int *)(i*4 + param_3);
      if (-*(int *)(i*4 + param_3) - 1U < local_28) {
        local_24 = 1;
      }
      else {
        local_24 = 0;
      }
    }
    *(uint *)(i*4 + param_1) = local_28;
  }
  return local_24;
}


void FUN_1000af94(uint *param_1,uint param_2,uint param_3){
  ushort uVar1;
  ushort uVar2;
  uint uVar3;
  uint uVar4;
  
  //printf(RED);
  //printf("FUN_1000af94\n");
  //printf(DEFAULT);

  uVar1 = (ushort)(param_2 >> 0x10);
  uVar2 = (ushort)(param_3 >> 0x10);
  *param_1 = (param_2 & 0xffff) * (param_3 & 0xffff);
  uVar3 = (uint)uVar1 * (param_3 & 0xffff);
  param_1[1] = (uint)uVar1 * (uint)uVar2;
  uVar4 = (param_2 & 0xffff) * (uint)uVar2 + uVar3;
  if (uVar4 < uVar3) {
    param_1[1] = param_1[1] + 0x10000;
  }
  uVar3 = *param_1 + uVar4 * 0x10000;
  *param_1 = uVar3;
  if (uVar3 < uVar4 * 0x10000) {
    param_1[1] = param_1[1] + 1;
  }
  param_1[1] = param_1[1] + (uVar4 >> 0x10);
  return;
}

int FUN_1000a8a4(int *param_1,int *param_2,uint param_3,int *param_4,uint len){
  uint uVar1;
  uint local_24;
  uint local_20[0x100];  // local_20[0]
  int local_1c;      // local_20[1]
  uint i;
  int local_14;
  
  printf(RED);
  printf("FUN_1000a8a4\n");
  printf(DEFAULT);

  if (param_3 == 0) {
    local_14 = 0;
  }else {
    local_24 = 0;
    for (i= 0; i < len; i = i + 1) {
      //printf("before af94\n");
      FUN_1000af94(&local_20[0],param_3,*(uint *)(param_4 + i*4));
      //printf("after af94\n");

      uVar1 = *(int *)(param_2 + i*4) - local_24;
      //printf("test\n");
      *(uint *)(param_1 + i*4) = uVar1;
      local_24 = (uint)(-local_24 - 1 < uVar1);
      uVar1 = *(int *)(param_1 + i*4) - local_20[0];
      *(uint *)(param_1 + i*4) = uVar1;
      if (-local_20[0] - 1 < uVar1) {
        local_24 = local_24 + 1;
      }
      //printf("after for loop\n");
      local_24 = local_24 + local_20[1];
    }
    local_14 = local_24;
  }
  return local_14;
}


uint FUN_1000aa18(uint param_1){
  uint i;
  uint local_14;
  
  printf(RED);
  printf("FUN_1000aa18\n");
  printf(DEFAULT);

  local_14 = 0;
  printf("param_1: %i\n",param_1);

  for (i = param_1; ((local_14 < 0x20) && (i != 0)); i = i >> 1) {
    //printf("i: %i\n",i);
    local_14 = local_14 + 1;
  }
  return local_14;
}



void FUN_10009a24(int *param_1,int *param_2,int *param_3,uint param_4,int *param_5,uint param_6){
  int iVar1;
  int iVar2;
  uint uVar3;
  int iVar4;
  uint local_1d0;
  uint auStack_1cc [0x100];
  int iStack_bc;
  unsigned char auStack_b8 [144];
  int local_28;
  int i;
  uint local_20;
  uint local_1c;
  
  printf(RED);
  printf("FUN_10009a24\n");
  printf(DEFAULT);

  local_20 = FUN_1000a6bc(param_5,param_6);
  printf("9a24 after FUN_1000a6bc\n");  
  
  if (local_20 != 0) {
    
    //printf("9a24 before FUN_1000aa18\n");
    //printf("local_20: %i\n",local_20);

    local_1c = FUN_1000aa18(*(uint *)(local_20 * 4 + param_5 + -4));

    
    //printf("9a24 after FUN_1000aa18\n");  
        local_1c = 0x20 - local_1c;
    FUN_10009374((auStack_1cc + 1),local_20);
    //printf("9a24 after FUN_10009374\n");  
    uVar3 = FUN_10009824((auStack_1cc + 1),param_3,local_1c,param_4);
    //printf("9a24 after FUN_10009824\n");  
    auStack_1cc[param_4 + 1] = uVar3;
    FUN_10009824(auStack_b8,param_5,local_1c,local_20);
    local_28 = (&iStack_bc)[local_20];
    FUN_10009374(param_1,param_4);
    printf("9a24 param_4: %i\n",param_4);
    for (i = param_4 - local_20; i > -1; i = i -1) {
      if (local_28 == -1) {
        local_1d0 = auStack_1cc[i + local_20 + 1];
      }
      else {
        FUN_1000b104((int *)&local_1d0,(int *)(auStack_1cc + i + local_20),local_28 + 1);
	printf("9a24 after FUN_1000b104\n");  

      }
      iVar1 = i + local_20;
      iVar2 = i + local_20;
      iVar4 = FUN_1000a8a4((auStack_1cc + i + 1),(auStack_1cc + i + 1),local_1d0,auStack_b8,local_20);
      auStack_1cc[iVar1 + 1] = auStack_1cc[iVar2 + 1] - iVar4;
      //printf("i: %i\n",i);

      
      /* while loops takes infinite to finish */
      while ((auStack_1cc[i + local_20 + 1] != 0 || (iVar1 = FUN_1000a4c0((auStack_1cc + i + 1),auStack_b8,local_20), -1 < iVar1))) {
        local_1d0 = local_1d0 + 1;
        iVar1 = i + local_20;
        iVar2 = i + local_20;
        iVar4 = FUN_10009580((auStack_1cc + i + 1),(auStack_1cc + i + 1),auStack_b8,local_20);
        auStack_1cc[iVar1 + 1] = auStack_1cc[iVar2 + 1] - iVar4;
      }


      
      *(uint *)(param_1 + i*4) = local_1d0;
    }
    FUN_10009374(param_2,param_6);
    FUN_10009924(param_2,(int)(auStack_1cc + 1),local_1c,local_20);
    FUN_10008f90(auStack_1cc + 1,0,0x10c);
    FUN_10008f90(auStack_b8,0,0x84);
  }
  return;
}



void FUN_10009db8(int *param_1,int *param_2,uint param_3,int *param_4,uint param_5){
  unsigned char auStack_120 [284];

  printf(RED);
  printf("FUN_10009db8\n");
  printf(DEFAULT);
  
  //printf("9db8 param_4: %i\n",param_4);

  FUN_10009a24(auStack_120,param_1,param_2,param_3,param_4,param_5);
  printf("9db8 after FUN_10009a24\n");
  FUN_10008f90(auStack_120,0,0x108);
  printf("9db8 after FUN_10008f90\n");

  return;
}


// both two functions below are almost the same ??????????????????
uint FUN_1000a738(int *param_1,int *param_2,uint param_3,int *param_4,uint param_5){
  uint uVar1;
  uint local_24;
  uint local_20[2]; // local_20[0]
  //int local_1c;   // local_20[1]
  uint i;
  uint local_14;
  
  //printf(RED);
  //printf("FUN_1000a738\n");
  //printf(DEFAULT);

  if (param_3 == 0) {
    local_14 = 0;
  }
  else {
    local_24 = 0;
    //printf("param_5: %i\n",param_5);
    for (i = 0; i < param_5; i = i + 1) {
      //printf("i: 0x%04X, ",i);
      FUN_1000af94(&local_20[0],param_3,*(uint *)(i * 4 + param_4));
      uVar1 = *(int *)(param_2 + i*4) + local_24;
      *(uint *)(param_1 + i*4) = uVar1;
      local_24 = (uint)(uVar1 < local_24);
      uVar1 = *(int *)(param_1 + i*4) + local_20[0];
      *(uint *)(param_1 + i*4) = uVar1;
      if (uVar1 < local_20[0]) {
        local_24 = local_24 + 1;
      }
      local_24 = local_24 + local_20[1];
    }
    local_14 = local_24;
  }
  return local_14;
}


void FUN_100096ac(int *param_1,int *param_2,int *param_3,int param_4){
  int iVar1;
  int iVar2;
  uint uVar3;
  int aiStack_138 [0x100]; // was 68
  uint local_28;
  uint local_24;
  uint i;
  
  printf(RED);
  printf("FUN_100096ac\n");
  printf(DEFAULT);

  FUN_10009374(aiStack_138,param_4 << 1);
  local_28 = FUN_1000a6bc(param_2,param_4);
  local_24 = FUN_1000a6bc(param_3,param_4);
  //printf("local_28: %i\n",local_28);
  for (i = 0; i < local_28; i = i + 1) {
    //printf("96ac, i: %i, ",i);
    iVar1 = local_24 + i;
    iVar2 = local_24 + i;
    uVar3 = FUN_1000a738((aiStack_138 + i),(aiStack_138 + i),(i * 4 + param_2),param_3,local_24);
    aiStack_138[iVar1] = aiStack_138[iVar2] + uVar3;
  }
  FUN_100092f8(param_1,aiStack_138,param_4 << 1);
  FUN_10008f90(aiStack_138,0,0x108);
  return;
}


void FUN_10009e2c(int *param_1,int *param_2,int *param_3,int *param_4,uint param_5){
  unsigned char auStack_120 [284];
  
  printf(RED);
  printf("FUN_10009e2c\n");
  printf(DEFAULT);

  FUN_100096ac(auStack_120,param_2,param_3,param_5);
  //printf("9e2c after FUN_100096ac\n");
  //printf("9e2c param_4: %i\n",param_4);

  FUN_10009db8(param_1,auStack_120,param_5 << 1,param_4,param_5);
  printf("9e2c after FUN_10009db8\n");
  FUN_10008f90(auStack_120,0,0x108);
  printf("9e2c after FUN_10008f90\n");

  return;
}




/* FUN_10008264 */
void kind_of_memset(unsigned int *p1,unsigned char value,uint len){
  unsigned int i;
  //printf(RED);
  //printf("kind_of_memset, FUN_10008264.\n");
  //printf(DEFAULT);
  
  for (i=0; i < len; i=i+1) {
    *(unsigned char*)((unsigned char*)p1 + i) = value;
  }
  return;
}


/* FUN_100081f0 */
void kind_of_memcpy(unsigned int *p1,unsigned int *p2,uint len){
  unsigned int i;

  //printf(RED);
  //printf("kind_of_memcpy, FUN_100081f0.\n");
  //printf(DEFAULT);

  for (i=0; i<(int)len; i++) {
    *(p1 + i) = *(p2 + i);
  }
  return;
}


void FUN_100092f8(int *param_1,int *param_2,uint param_3){
  uint i;

  printf(RED);
  printf("FUN_100092f8\n");
  printf(DEFAULT);

  for (i = 0; i < param_3; i = i + 1) {
    *(uint32_t *)(param_1 + i*4) = *(uint32_t *)(param_2 + i*4 );
  }
  return;
}


void FUN_10009374(int *param_1,uint len){
  uint i;
  
  printf(RED);
  printf("FUN_10009374\n");
  printf(DEFAULT);

  for (i= 0; i< len; i = i + 1) {
    *(uint32_t *)(param_1 + i*4) = 0;
  }
  return;
}


void FUN_10009ebc(int *param_1,int *param_2,int *param_3,int param_4,int *param_5,uint param_6){
  int iVar1;
  unsigned char auStack_2d4[100];
  unsigned char auStack_250[132];
  unsigned char auStack_1cc[132];
  unsigned char auStack_148[136];
  uint local_c0;
  uint32_t local_b8 [36];
  int local_28;
  uint local_24;
  uint local_20;
  uint local_1c;

  printf(RED);
  printf("FUN_10009edc\n");
  printf(DEFAULT);
  
  //printf("9ebc param_5: %i\n",param_5);
  FUN_100092f8(auStack_250,param_2,param_6);

  FUN_10009e2c(auStack_1cc,auStack_250,param_2,param_5,param_6);
  //printf("after FUN_10009e2c\n");
  FUN_10009e2c(auStack_148,auStack_1cc,param_2,param_5,param_6);
  //printf("after FUN_10009e2c\m");

  FUN_10009374(local_b8,param_6);
  local_b8[0] = 1;
  iVar1 = FUN_1000a6bc(param_3,param_4);
  local_28 = iVar1;
  while (local_28 = local_28 + -1, -1 < local_28) {
    local_c0 = *(uint *)(local_28 * 4 + param_3);
    local_24 = 0x20;
    if (local_28 == iVar1 + -1) {
      for (; local_c0 >> 0x1e == 0; local_c0 = local_c0 << 2) {
        local_24 = local_24 - 2;
      }
    }

    for (local_20 = 0; local_20 < local_24; local_20 = local_20 + 2) {

      FUN_10009e2c((int)local_b8,(int)local_b8,(int)local_b8,param_5,param_6);
      FUN_10009e2c((int)local_b8,(int)local_b8,(int)local_b8,param_5,param_6);
      local_1c = local_c0 >> 0x1e;
      if (local_1c != 0) {
        FUN_10009e2c((int)local_b8,(int)local_b8,(int)(auStack_2d4 + local_1c * 0x84),param_5,param_6);
      }
      local_c0 = local_c0 << 2;
    }
  }
  FUN_100092f8(param_1,local_b8,param_6);
  FUN_10008f90(auStack_250,0,0x18c);
  FUN_10008f90(local_b8,0,0x84);
  return;
}


void FUN_100091dc(int param_1,int param_2,int param_3,uint param_4){
  uint uVar1;
  int local_24;
  uint local_20;
  uint local_1c;

  printf(RED);
  printf("FUN_100091dc\n");
  printf(DEFAULT);

  local_20 = 0;
  local_24 = param_2 + -1;
  while ((local_20 < param_4 && (-1 < local_24))) {
    uVar1 = *(uint *)(local_20 * 4 + param_3);
    for (local_1c = 0; (-1 < local_24 && (local_1c < 0x20)); local_1c = local_1c + 8) {
      *(char *)(param_1 + local_24) = (char)(uVar1 >> (local_1c & 0x3f));
      local_24 = local_24 + -1;
    }
    local_20 = local_20 + 1;
  }
  for (; -1 < local_24; local_24 = local_24 + -1) {
    *(unsigned char *)(param_1 + local_24) = 0;
  }
  return;
}


void FUN_100090a4(int *param_1,uint param_2,int *key,int len){
  uint local_28;
  int local_24;
  uint local_20;
  uint local_1c;

  printf(RED);
  printf("FUN_100090a4\n");
  printf(DEFAULT);

  local_20 = 0;
  local_24 = len - 1;
  while ((local_20 < param_2 && (-1 < local_24))) {
    local_28 = 0;
    for (local_1c = 0; (-1 < local_24 && (local_1c < 0x20)); local_1c = local_1c + 8) {
      local_28 = local_28 | (uint)*(unsigned char *)(key + local_24) << (local_1c & 0x3f);
      local_24 = local_24 + -1;
    }
    *(uint *)(param_1 + local_20 * 4) = local_28;
    local_20 = local_20 + 1;
  }
  for (; local_20 < param_2; local_20 = local_20 + 1) {
    *(uint32_t*)(param_1 + local_20 * 4 ) = 0;
  }
  return;
}


uint32_t FUN_100089b8(unsigned char *param_1,uint *param_2,unsigned char *sha256_buffer,int len,int *key_address){
  int iVar1;
  unsigned char auStack_260[144];
  unsigned char auStack_1d0[144];
  unsigned char auStack_140[144];
  unsigned char auStack_0b0[144];
  int local_20;
  uint local_1c;
  uint32_t local_18;
  
  printf(RED);
  printf("FUN_100089b8\n");
  printf(DEFAULT);

  FUN_100090a4(auStack_140, 0x21,sha256_buffer            ,len);
  FUN_100090a4(auStack_0b0, 0x21,(int)(key_address + 1)   ,0x80);
  FUN_100090a4(auStack_1d0, 0x21,(int)(key_address + 0x21),0x80);
  
  local_1c = FUN_1000a6bc(auStack_0b0,0x21);
  local_20 = FUN_1000a6bc(auStack_1d0,0x21);

  iVar1 = FUN_1000a4c0(auStack_140,auStack_0b0,local_1c);

  if (iVar1 < 0) {
    FUN_10009ebc(auStack_260,auStack_140,auStack_1d0,local_20,auStack_0b0,local_1c);
    unsigned int ui = 7;
    *param_2 = (*key_address + ui) >> 3;  
    FUN_100091dc(param_1,*param_2,(int)auStack_260,local_1c);
    FUN_10008f90(auStack_260,0,0x84);
    FUN_10008f90(auStack_140,0,0x84);
    local_18 = 0;
  }
  else {
    local_18 = 0x401;
  }
  return local_18;
}





#if 1

int FUN_10008474(void *param_1,size_t *len_1,unsigned char *sha256_buffer,uint len_2,int *key_address){
  uint uVar1;
  unsigned char *pcVar2;
  
  unsigned char local_a0[128]; //probably key because of length
  uint local_20;
  uint local_1c;
  uint local_18;
  int  local_14;

  unsigned int ui=7;
  printf(RED);
  printf("FUN_10008474\n");
  printf(DEFAULT);
  
  local_1c = (*key_address + ui) >> 3;
  if (local_1c < len_2) {
    local_14 = 0x406;
  }else{
    local_14 = FUN_100089b8(local_a0,&local_18,sha256_buffer,len_2,key_address);
    if (local_14 == 0) {
      printf("local_14==0\n");
      exit(-1);
      if (local_18 == local_1c) {
        if ((local_a0[0] == '\0') && (local_a0[1] == '\x01')) {
          for (local_20 = 2; (uVar1 = local_20, local_20 < local_1c - 1 && (local_a0[local_20] == -1)); local_20 = local_20 + 1) {
          }
          pcVar2 = &local_a0[0] + local_20;
          local_20 = local_20 + 1;
          if (*pcVar2 == '\0') {
            *len_1 = local_1c - local_20;
            if (local_1c < *len_1 + 0xb) {
              local_14 = 0x401;
            }
            else {
              FUN_10008fe4(param_1,local_a0 + uVar1 + 1,*len_1);
              FUN_10008f90(local_a0,0,0x80);
              local_14 = 0;
            }
          }
          else {
            local_14 = 0x401;
          }
        }
        else {
          local_14 = 0x401;
        }
      }
      else {
        local_14 = 0x406;
      }
    }
  }
  return local_14;
}

#endif


unsigned char FUN_10005f64(unsigned char *sha256_buffer,uint len,unsigned char *digest,size_t digest_len,int add_dev_key,int param_6) {
  bool bVar1=false;
  int param2=0;
  int iVar2;
  int nr_keys;
  int iVar4;
  int *key_address[8];
  unsigned char abStack_58 [32];
  size_t len_0[3];

  printf(RED);
  printf("FUN_10005f64\n");
  printf(DEFAULT);
  

  memset(key_address,0,0x20);
  nr_keys = 2; 
  key_address[0] = (int *)data_10022860;
  key_address[1] = (int *)data_10022964;
  if (add_dev_key != 0) {
    nr_keys = 3;
    printf("Adding the developer key to the keyring. ");
    printf("Do not do this on production releases!\n");
    key_address[2] = (int *)data_1002275c;  //must be key!!
  }
  
  bVar1 = false;
  len_0[0] = 0x20;
  iVar2 = 0;
  do {
    memset(abStack_58,0,len_0[0]);  // abStack_58 all zeors
    
    param2 = FUN_10008474(abStack_58,len_0,sha256_buffer,len,key_address[iVar2]);
    
    iVar4 = iVar2 + 1;
    if (param_6 > 2) {
      printf("[%d] - %d, digest_size=%ld \n",iVar2,param2,len_0[0]);
      /* should print below to the keyring i guess */
      line_print_16_bytes(sha256_buffer,len);
      line_print_16_bytes(abStack_58,len_0[0]);  
      line_print_16_bytes(digest,digest_len);
    }

    if (param2 == 0) {
      iVar2 = memcmp(abStack_58,digest,digest_len); // compare digest with abStack_58
      bVar1 = iVar2 == 0;                           // digest is equal to abStack_58
    }
    iVar2 = iVar4;
  } while (!bVar1 && iVar4 < nr_keys);
  
  if (param_6 != 0) {
    if (!bVar1) {
      printf("digest does not match abStack_58!\n");
    }else {
      printf("successful! Key%d\n",iVar4);
    }
  }

  return bVar1 ^ 1;
}



uint verify_signature(int fd, __off_t *param_2       ,unsigned char *sha256_buffer,int param_4,int param_5){
  int i;
  uint uVar1;
  __off_t file_location;
  int iVar3;
  __off_t _Var4;
  
  unsigned char *digest; //abStack_48[48]
  digest = calloc(4*SHA256_DIGEST_SIZE, sizeof(unsigned char));

  //unsigned char output[2 * SHA256_DIGEST_SIZE + 1];
  //output[2 * SHA256_DIGEST_SIZE] = '\0';
  
  printf(RED);
  printf("verify_signature, FUN_1000610c\n");
  printf(DEFAULT);

  file_location = lseek(fd,0,SEEK_CUR);
  //printf("file_location: 0x%lX\n", file_location);
  
  uVar1 = 0xffffffff;
  if (file_location > -1) {  // no error

    iVar3 = FUN_10005de8(fd,sha256_buffer,digest);

    printf("digest:\n");
    line_print_16_bytes(digest,SHA256_DIGEST_SIZE);
    printf("sha256_buffer+55\n");
    line_print_16_bytes(sha256_buffer+0x55,4*SHA256_DIGEST_SIZE);

    uVar1 = 0xffffffff;
    if (iVar3 > -1) {
      if (param_2 != (__off_t *)0x0) {
        _Var4 = lseek(fd,0,1);
        *param_2 = _Var4;
      }
      
      file_location = lseek(fd,file_location,SEEK_SET);
      
      uVar1 = 0xffffffff;


      if (file_location > -1) { //no error
	printf("file_location: 0x%lX\n",file_location);
#if 1
	unsigned char bVar5;
        bVar5 = FUN_10005f64(sha256_buffer + 0x55,0x80,digest,0x20,param_4,param_5);
	printf("bVar5: %i\n",bVar5);
        uVar1 = (uint)bVar5;
#endif 
      }
      printf("Should add developer key to key ring.\n");

      uVar1 = 1^1; // ==0
    }
  }else{
    printf("lseek error!\n");
  }
  return uVar1;
}


int get_free_loop(void){
  int i;
  int loopdev[2]={0};
  FILE *fp;
  size_t size=0x100;
  char *line=calloc(0x100,sizeof(char));
  fp=fopen("/proc/partitions","r");
  while(getline(&line,&size,fp)>0){
    if(strlen(line)>=4){
      for(i=strlen(line)-8;i<strlen(line)-4;i++){
	if(strncmp((line+i),"loop",4)==0){
	  loopdev[1]=atoi((line+i+4));
	  if(loopdev[1]>=loopdev[0]) loopdev[0]=loopdev[1];
	}
      }
    }
  }
  fclose(fp);
  return loopdev[0]+1;
  
}

void print_keys(void){
  /* print keys in data_10010100 */
  int i,j;
  for(j=0;j<7;j++){
    printf("key[%i]: ",j);
    for(i=0;i<(4*8);i++){
      printf("%c",data_10010100[j*36 +i]);
    }
    printf("\n");
  }
  printf("\n");
}




  
#if 0  

//DAT_10022c28=calloc(0x80,sizeof(unsigned char));
//unsigned char *DAT_10022c28;
//unsigned char *DAT_10022a68;
//char *DAT_10022c2c; // waarschijnlijk naam van flash image 


  
  unsigned int *local_5c;
  local_5c=calloc(6,sizeof(uint));

  unsigned int      partition_nr;  //was unsigned char, was uVar9




unsigned int jump_size=0;             //mag uiteindelijk ook weg  /* _Var12*/
  unsigned int current_location=0;


  int iVar5 = 0;
  int iVar8 = 0;
  int iVar9 = 0;
  bool bVar1;



  //printf("Endianness: ");
  //if(is_bigendian()) printf("big.\n"); else printf("little.\n");




int jsa_index=0;
  while( false ) {
    current_location = lseek(fd,0,SEEK_CUR);
    current_location_array[index]=current_location;
    index++;

    //printf("current location: 0x%X\n",current_location);
    
    iVar5 = iVar8;
    bVar1 = (3 < iVar9);
    iVar9 = iVar9 + 1;

    if ( ( bVar1 || (local_5c[0] != 0) ) || ( *(read_buffer+1+iVar5) == '\0') ) break;

    partition_nr = (unsigned int) *(read_buffer+1+iVar5);  
    partition_name = partition_selector(partition_nr);      

    jump_size= *(__off_t*)(read_buffer+1+iVar5+1);
    if(!is_bigendian()) jump_size = __htobe32(jump_size);
    jump_size_array[jsa_index]=jump_size;
    jsa_index++;
    
    /* write mtd partition */
    local_5c[0] = open_mtd_for_output_internal(fd, partition_name,jump_size);

    iVar8 = iVar5 + 0x15;

    if(modify && strcmp(partition_name,"initrd")==0) {

      md5_sum  = calloc( 0x10,sizeof(char));
      nr_partitions= modify_partition(partition_name,&partition_size);
      /* update md5sum int read_buffer, should also be updated in firmware file */

      for(i=0;i<MD5_DIGEST_LENGTH;i++){
	*(uint8_t*)(read_buffer + 1 + iVar5 + 5 + i)= *(uint8_t*)(md5_sum+i);
	}

      sprintf(mtd_name,"dev/mtd-%s",partition_name);

      fp=fopen(mtd_name,"r");
      partition_size=fseek(fp,0, SEEK_END);
      partition_size = ftell(fp);
      fclose(fp);
    }

    if (local_5c[0] == 0) {
      local_5c[0] = open_mtd_for_input_internal(partition_name,jump_size,(read_buffer + 1 + iVar5 + 5));
    }
    printf("\n");
  }




  
  if(!burn){
    //system("rm -rf dev/*");
  }




  /* what is DAT_10022c28? */
  uint uVar9 = memcmp(argv[optind], "file://",7);  //is file:// somewhere in filename?
  //printf("uVar9: 0x%08X, %i\n",uVar9,uVar9);
  uint uVar10 = (int)uVar9 >> 0x1f;
  //printf("uVar10: 0x%08X, %i\n",uVar10, uVar10);
  uint uVar21=1;  // is initialised as 1
  char *pcVar27 = (char *)0xc; // devfined  right here
  uint tmp1 = (int) (uVar10 - (uVar10 ^ uVar9 )) >> 0x1f;
  //printf("tmp1: %i\n",tmp1);
  
  char pcVar22 = (uVar21 & tmp1);  //1 & -1: 0x00000001 & 0xFFFFFFFF = 1
  
  char pcVar22 = 0x00000001 & 0xFFFFFFFF
  //printf("pcVar22: 0x%08X\n",pcVar22);





#endif


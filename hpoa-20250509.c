#include "hpoa.h"


unsigned char *DAT_10012738=0;  //doesn't change anywhere should be calloced


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
  
  int i,j;                                                     /* iVar16 and iVar27 */
  int index=0;

  uint32_t partition_size=0;
  char *mtd_name;
  mtd_name=calloc(0x80,sizeof(unsigned char));

  char *partition_name;
  partition_name=calloc(0x80,sizeof(unsigned char));

  
  unsigned int jump_size_array[0x10];     // mag weg, ook hier boven gedefineerd
  unsigned int image_data_size_array[0x10];   //dubbel op denk ik
  unsigned int fw_location=0;
  unsigned int fw_location_array[0x10];
  unsigned int current_location_array[0x10];

  int opt=0;
  int modify=0;
  int burn=0;
  int firmw=0;
  int verify=0;
  int signature=0;
  int have_signature=0;
  uint64_t have_fingerprint=0;

  partition p;
  
  int nr_partitions=0;

  __off_t *fd_location;
  fd_location=calloc(1,sizeof(__off_t));


#if 0 //modify hash with hash from different file
  only_modify_hash("hpoa440.bin", "hpoa440_hash450.bin", hash_450);
#endif
  
#if 0 //SHA stuff works
  do_sha256_test();
#endif

#if 0  
  printf("sizeof(uint64_t): %li\n",sizeof(uint64_t));
  printf("sizeof(long long int): %li\n",sizeof(long long int));
  printf("sizeof(long int): %li\n",sizeof(long int));
  printf("sizeof(int): %li\n",sizeof(int));
  printf("sizeof(short): %li\n",sizeof(short));
#endif

  
  p= malloc(0x10*sizeof(*p)); // must be sizeof *p otherwise size of the address of p

  if (geteuid() != 0) {
    fprintf(stderr, "%s needs root privileges!\n",argv[0]);
    exit(-1);
  }


  /*  handle commandline options */
  if(argc <= 1){
    printf("No file. Usage: %s [option] <filename>\n",argv[0]);
    return -1;
  }else{
    while(opt = getopt(argc,argv,"btfsmv"),opt != -1) {
      if (true) {
	switch(opt) {
	case 'm':
	  modify=1;
	  printf("Choosen option: %c, will modify rc.sysinit\n",opt);
	  break;
	case 'b':
	  burn=1;
	  if((modify==0)&&(firmw==0)){
	    printf("Going to burn_only.\n");
	    goto burn_only;
	    printf("Burn firmare ok.\n");
	    return(1);
	  }
	  //printf("Choosen option: %c, will burn new initrd to /dev/mtd-initrd\n",opt);
	  break;
	case 'f':
	  firmw=1;
	  printf("Choosen option: %c, will compose new image\n",opt);
	  break;

	case 's':
	 signature=1;
	 printf("Going to check signature.\n");
	 break;
	case 'v':
	  verify=1;
	  if((modify==0)&&(burn==0)&&(firmw==0)){
	    printf("Going to verify_only.\n");
	    goto verify_only;
	    printf("Firmare verification ok.\n");
	    return(1);
	  }
	  //printf("Choosen option: %c, will verify new firmw image\n",opt);
	  break;
	}
      }
    }
  }

  /****************************************************************************************/
  /*                                 main code                                            */
  /****************************************************************************************/

  #if 0
  fd=open("key_1.rsa",O_CREAT|O_WRONLY|0666);
  for(i=0;i<128;i++){
    write(fd,data_10022860[i+4],1);
    printf("%02X:",data_10022860[i+4]);
  }
  fsync(fd);
  
  close(fd);
  exit(-2);
  
#endif
  
  printf("Endianness: ");
  if(!is_bigendian()) printf("little.\n"); else printf("big.\n");



  int test_int=305419896;
  unsigned char test_array[4]={0x12,0x34,0x56,0x78};
  printf("test_int=305419896 is reperesended as: 0x%08X\n",test_int);
  printf("*(uint32_t*) cast from unsigned char test_array[4]={0x12,0x34,0x56,0x78}: 0x%08X\n", *(uint*)test_array);  
  
  
  fd=open(argv[optind],O_RDONLY);                 /* file_name = local_c48 */
  ret=read(fd,read_buffer,HEADER_SIZE);           /* read_buffer = local_d28 */

  char pcVar22 = 0x00000001 & 0xFFFFFFFF;

  /*
   * search for "Fingerprint Length" at SEEK_END -0x2800
   * if found, hane x509 certificates at the end of the file
   * if not found should user signature at 0x55-0xd5 of the file
   * version >= 450 should have x509 certificates
   */


  
  have_fingerprint=fw_with_fingerprint (argv[optind]);

  if(have_fingerprint ){
    printf(GREEN);
    printf("Have firmware file with RSA key\n");
    printf(DEFAULT);
  }else{
    printf(GREEN);
    printf("Hpoa uses hardcoded RSA key\n");
    printf(DEFAULT);
  }

  printf("have_fingerprint: 0x%lX\n",have_fingerprint);
  if(signature){
    if (have_fingerprint == 1) {
      /* X.509 *functions */
      //ret = FUN_1000ca0c: x509 signature check -1 is fail, 0 is ok
      have_signature = FUN_1000ca0c(argv[optind]);
      printf("have_signature: %i\n",have_signature);
    } else {

      /* SHA256 functions */
      /* 
       * in main parm_4=0 in FUN_100061f4 param_4 =  vVar7
       * DAT_1001152c = "dev"
       * iVar3 = memcmp(param_1,&DAT_1001152c,4);
       * bVar7 = bVar7 = iVar3 == 0;
       * ie. param_1 needs to start with dev
       * however FUN_100061f4 is not used strangely enough
       */ 
      have_signature = rsa_verify_signature(fd,fd_location,read_buffer,0,pcVar22);
      printf("have_signature: %i\n", have_signature);
    }

  }

  exit(-2);
  
  /* analyse partitions */
  nr_partitions = do_analysis(p,argv[optind]);

  /*
   * Verifying signature...
   * on success (NEW_HEADER==0)  successful! Key1
   * on failure (NEW_HEADER==1)  image is unsupported.
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

  
  if(firmw){
    printf(RED);
    printf("doing the fw stuff\n");
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
  } // end of doing the fw stuff

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


/* this function returns 1 if the file has a fingerprint section, otherwise 0 */
/* FUN_1000cb68 */
uint64_t fw_with_fingerprint (char *filename){
  uint64_t uVar1=0;
  char *pcVar2;
  //int ret;
  FILE *file;
  int iVar3;
  int iVar4;
  char *acStack_420;

  acStack_420=calloc(0x410,sizeof(char));
  memset(acStack_420,0,0x400);

  //code *local_20;

  printf(RED);
  printf("fw_with_fingerprint, FUN_1000cb68.\n");
  printf(DEFAULT);


  //local_20 = FUN_1000b510;
  //pcVar2 = (char *)DAT_10022c2c /* pointer to file name */

  printf("1.0: cb68: filename: %s\n",filename);
  file= fopen(filename,"rb");
  if (file == (FILE *)0x0) {
    free(acStack_420);
    exit(-1);
    uVar1 = 0;
  } else {
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
      pcVar2= strstr(acStack_420 ,"Fingerprint Length:");
      if (pcVar2 != 0x0) {  //"Fingerprint Length:" string found!!!
        uVar1 = 1;
        break;
      }
      memset(acStack_420,0,0x400);
    }
    fclose(file);
  }
  free(acStack_420);
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


// ai suggests montgomery_form_convert or bn_to_mont_form as name
void  bn_to_mont_form(uint *param_1,uint *param_2){
  uint uVar1;
  unsigned int uVar2;
  uint uVar3;
  uint uVar4;
  uint uVar5;
  /*
  printf(RED);
  printf(" bn_to_mont_form, FUN_1000e730.\n");
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
//ai suggests  bn_from_mont_form
uint64_t bn_from_mont_form(uint *param_1){
  uint uVar1;
  uint uVar2;
  uint uVar3;
  uint uVar4;
  uint uVar5;
  uint uVar6;
  bool bVar7;
  int64_t lVar8;
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
        uVar2 = uVar5 & (uint)((uint64_t)(lVar8 + -1) >> 0x20);
        uVar9 = FUN_1000f988(uVar5,uVar6,uVar1);
        uVar5 = (uint)((uint64_t)uVar9 >> 0x20);
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
  
  bn_to_mont_form(&local_58[0],&local_b8[0]);
  bn_to_mont_form(&local_50[0],&local_98[0]);
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
          uVar4 = (uint)((uint64_t)local_98[3] * (uint64_t)local_b8[4] >> 0x20);
          uVar5 = local_98[3] * local_b8[4];
          uVar7 = uVar5 + local_98[4] * local_b8[3];
          uVar6 = uVar4 + (int)((uint64_t)local_98[4] * (uint64_t)local_b8[3] >> 0x20) + (uint)CARRY4(uVar5,local_98[4] * local_b8[4]);
          uVar3 = (uint)((uint64_t)local_98[4] * (uint64_t)local_b8[4] >> 0x20);
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

	  local_78[3] = iVar1 + (int)((uint64_t)local_98[3] * (uint64_t)local_b8[3] >> 0x20) +
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
  uVar9 = bn_from_mont_form(puVar2);
  return uVar9;
}



/*
 * chatGPT says:
 * The function is likely designed for manipulating or comparing multi-word values,
 * possibly in the context of multi-precision arithmetic or complex data processing.
 * It involves comparing and manipulating the data pointed to by these parameters and
 * updating param_3
*/

// ai suggests montgomery_modular_add or bn_mod_add_mont as name
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

// ai suggests montgomery_add or bn_add_mont as name
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
  bn_to_mont_form(&local_28[0],auStack_88);
  bn_to_mont_form(&local_20[0],auStack_68);
  puVar1 = FUN_1000e89c(auStack_88,auStack_68,auStack_48);
  uVar2 = bn_from_mont_form(puVar1);
  return uVar2;
}

//ai suggests  montgomery_modular_divide or bn_mod_div_mont as name
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
  bn_to_mont_form(&local_38[0],local_78);
  bn_to_mont_form(&local_30[0],local_58);
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
  uVar9 = bn_from_mont_form(puVar2);
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
	uVar4 = 0xc1e0000000000000;
        return uVar4;
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
  uVar4 = bn_from_mont_form(&local_38);
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
            uVar8 = FUN_1000ebfc((int)((uint64_t)uVar8 >> 0x20),(int)uVar8,0x41f00000,0);
          }
	  unsigned int DAT_10022c20=0;
	  iVar1 = DAT_10022c20;
          uVar9 = FUN_1000f6bc(DAT_10022c20);  /* was 1000fbbc */
          if (iVar1 < 0) {
            uVar9 = FUN_1000ebfc((int)((uint64_t)uVar9 >> 0x20),(int)uVar9,0x41f00000,0);
          }
          uVar8 = FUN_1000f0f0((int)((uint64_t)uVar8 >> 0x20),(int)uVar8,(int)((uint64_t)uVar9 >> 0x20),(int)uVar9);
          uVar8 = FUN_1000ecf4((int)((uint64_t)uVar8 >> 0x20),(int)uVar8,0x40590000,0);
	  uVar4 = FUN_1000f7dc((uint)((uint64_t)uVar8 >> 0x20),(int)uVar8);

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

  bn_to_mont_form(&local_18[0],local_38);

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

void simple_md5sum(char *data, int len, bool int_type){
  int i=0;
  MD5Context ctx;
  char md5_sum[MD5_DIGEST_LENGTH];
  char *d;
  d = calloc(len,sizeof(char));
  
  //printf("\nlen: 0x%X\n",len);
  for(i=0; i<(len/sizeof(int)); i++){
    //printf("simple_md5sum: i: 0x%X\n",i);
    if(int_type){
      *((int*)d+i) = __htobe32( *((int*)data+i) );
    }else{
	*((int*)d+i) = *((int*)data+i);
    }
  }
  
  md5Init(&ctx);

  i=0;
  int c=0;
  while(i+=MD5_INPUT_LENGTH, i<=len){
    //printf("\nc*MD5_INPUT_LENGTH: 0x%X\n",c*MD5_INPUT_LENGTH);
    md5Update(&ctx, (uint8_t *)((char*)d+c*MD5_INPUT_LENGTH),MD5_INPUT_LENGTH);
    c++;
  }
  if(c*MD5_INPUT_LENGTH <len){
    //printf("\nrest: c: 0x%X, len: 0x%X, c*MD5_INPUT_LENGTH: 0x%X, len - c*MD5_INPUT_LENGTH: 0x%X\n",c, len, c*MD5_INPUT_LENGTH,len -c*MD5_INPUT_LENGTH);
    md5Update(&ctx, (uint8_t *)((char*)d+c*MD5_INPUT_LENGTH),len-(c*MD5_INPUT_LENGTH));
  }
  md5Finalize(&ctx);
  
  memcpy(md5_sum, ctx.digest, MD5_DIGEST_LENGTH);
  for(i=0;i<MD5_DIGEST_LENGTH;i++)
    printf("%02X",(unsigned char)md5_sum[i]);
  printf("\n");
  
  free(d);
}

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
  int32_t devnr;
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



 
int only_modify_hash(char* file_name, char *new_file_name, unsigned char *hash){

  int fd;
  char *data;
  data=calloc(0x1000,sizeof(char));
  
  int fd_mod;
  int len;
  fd_mod= open(new_file_name,O_WRONLY |O_CREAT, 0666);
  if(fd_mod<0){
    printf("could not open %s\n",new_file_name);
    return(-1);
  }
  
  fd=open(file_name, O_RDONLY);
  if(fd<0){
    printf("could not open %s\n",file_name);
    return(-1);
  }

  len=read(fd,data,0x55);
  write(fd_mod,data,len);
  len=read(fd,data,0x80);
  write(fd_mod,hash,0x80);
  
  while(len=read(fd,data,0x1000),len>0){
    write(fd_mod,data,len);
  }
  close(fd);
  close(fd_mod);
  
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

size_t loop_sha256_update(int fd,void *buffer,size_t len,sha256_ctx *ctx){
  size_t sVar1;

  //printf(RED);
  //printf("Loop_sha256_update, FUN_10005d64, len: 0x%lX\n", len);
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

  int q;
  for(q=0; q<0x2008;q++){
    auStack_2018[q]=0;
  }

  
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



/* this function does the actual sha256 hash */
uint32_t rsa_hash_to_verify (int fd,unsigned char *sha256_buffer,unsigned char *digest){
  int i,n;
  int len=0;
  bool bVar1;
  uint32_t uVar2=0xFFFFFFFF;
  int iVar3;
  size_t sVar4;
  int *piVar5=0;
  unsigned char *pbVar6;

  unsigned int new_jump_size=0;
  uint jump_size_sum;
  int iVar8;
  sha256_ctx ctx;
  uint8_t results[SHA256_DIGEST_SIZE];
  unsigned char buffer[0x20];      // ustack_58[0], only need 0x0e bytes
  //  unsigned char  local_57;     // uStack_58[1]
  unsigned int uStack_48[0x30];    // uStack_48[0], only need 0x15 bytes
  //int local_47;                  // uStack_48[1] 

  printf(RED);
  printf("rsa_hash_to_verify, FUN_10005de8\n");
  printf(DEFAULT);

  //line_print_16_bytes(sha256_buffer,HEADER_SIZE);

  int q;
  for(q=0; q<SHA256_DIGEST_SIZE;q++){
    results[q]=0;
  }
  for(q=0; q<0x20;q++){
    buffer[q]=0;
  }
  for(q=0; q<0x30;q++){
    uStack_48[q]=0;
  }


  
#if 0
  printf("0.0: 5de8: file_location: 0x%lX\n",lseek(fd,0,SEEK_CUR));
  sha256_init(&ctx);
  while(len=read(fd,buffer,0x0E),len>0){
    sha256_update(&ctx,buffer, len);
  }

  printf("1: 5de8: file_location: 0x%lX\n",lseek(fd,0,SEEK_CUR));
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
    //printf("1: 5de8: jump_size_sum: 0x%X, pbVar6_plus_8: 0x%X\n",jump_size_sum,pbVar6_plus_8 );
    //printf("2: 5de8: pbVar6: 0x%08X\n",*(uint*)pbVar6);

    //printf("3: 5de8: File location: 0x%lX\n",lseek(fd,0,SEEK_CUR));
    if (jump_size_sum == 0) {
      if ((pbVar6 != (unsigned char *)0x0) && (pbVar6_plus_8 != 0)) {
	/* read 0xe bytes and store them at uStack_58 */


	// size 0xe doesnt make sense
	// 0xe bytes are read into buffer
	sVar4 = loop_sha256_update(fd,&buffer[0],0xe,&ctx);
        if (sVar4 != 0) {
	  printf("sVar4 is not 0\n");
          return 0xffffffff;
        }
        jump_size_sum = 0;
        iVar8 = 0;
        if (buffer[1] != 0) {

	  /*
	   * read chunks of 0x15 bytes and do a sha256_update on it
	   * do this while  buffer[1] > iVar8
	   */
	  
          do {
            iVar8 = iVar8 + 1;
	    //size 0x15 doesn't make any sense
	    sVar4=loop_sha256_update(fd,&uStack_48[0],0x15,&ctx); 
	    if (sVar4 != 0) {
	      printf("sVar4 is not 0\n");
	      return 0xffffffff;
	    }

	    new_jump_size = *(uint*)((uint8_t*)uStack_48+1);
	    if(!is_bigendian()) new_jump_size = __htobe32(new_jump_size);
	    //printf("4: 5de8: new jump_size: 0x%08X\n", new_jump_size);
            jump_size_sum = jump_size_sum + new_jump_size; 
	    //printf("iVar8: %i, (int)(uint)buffer[i]: 0x%X\n",iVar8,(int)(uint)buffer[1]);
          } while ((int)(uint)buffer[1] > iVar8);


	  
        }

	/* jump_size_sum should be >0 otherwise 5cdc returns 0xFFFFFFFF */
        jump_size_sum = FUN_10005cdc(fd,jump_size_sum,&ctx);
	//printf("jump_size_sum: 0x%X, need to be zero!!!, otherwise return -1\n",jump_size_sum);

        if (jump_size_sum != 0) {
	  printf("5: 5de8: jump_size_sum is not 0\n");
          return 0xffffffff;
        }
      }

      sha256_final(&ctx,digest); //was sha256_Final(param_3,&SStack_c8);
      //printf("5.9: 5de8: File location: 0x%lX\n",lseek(fd,0,SEEK_CUR));

      uVar2 = 0;
    }else{
      printf("6.0: 5de8: jump_size_sum is not 0!!!\n");
    }// end of if (jump_size_sum == 0)
  }
#endif

  return uVar2;
}




void line_print_4_ints(unsigned char * data,int len){
  int i;

  unsigned char d[len];
  printf(RED);
  if(is_bigendian()) printf("Big endian "); else printf("Little endian ");
  printf("line_print_4_ints\n");
  printf(DEFAULT);
  //printf("len: 0x%X\n",len);
  //printf("len/sizeof(int): 0x%lX\n",len/sizeof(int));
  /* make copy so not to change data */
  for(i=0;i<len/sizeof(int);i++){ 
  //if(is_bigendian())
      //*((int*)d+i) = __htobe32(*((int*)data+i));
    //else
      *((int*)d+i) = *((int*)data+i);
      }
  
  for(i=0;i<(len/sizeof(int));i++){
    printf("%08X ",*(uint32_t*)((uint32_t*)d+i));
    if(((i+1)%0x04)==0) printf("\n");
  }
  if(((i)%0x04)!=0) printf("\n");
}




void line_print_8_ints(unsigned char * data,int len){
  int i;

  unsigned char d[len];
  //printf(RED);
  //if(is_bigendian()) printf("Big endian "); else printf("Little endian ");
  //printf("line_print_8_ints\n");
  //printf(DEFAULT);

  /* make copy so not to change data */
  for(i=0;i<len/sizeof(int);i++){ 
  //if(is_bigendian())
      //*((int*)d+i) = __htobe32(*((int*)data+i));
    //else
      *((int*)d+i) = *((int*)data+i);
      }
  
  for(i=0;i<(len/sizeof(int));i++){
    printf("%08X ",*(uint32_t*)((uint32_t*)d+i));
    //if(((i+1)%0x08)==0) printf("\n");
  }
  //if(((i)%0x08)!=0) printf("\n");
}


void line_print_8_shorts(unsigned char * data,int len){
  int i;
  unsigned char d[len];

  printf(RED);
  if(is_bigendian()) printf("Big endian "); else printf("Little endian ");
  printf("line_print_8_shorts\n");
  printf(DEFAULT);


  for(i=0;i<len/sizeof(uint16_t);i++){
  //if(is_bigendian())      
      //*((uint16_t*)d+i) = __htobe32(*((uint16_t*)data+i));
  //else
      *((int*)d+i) = *((int*)data+i);
      }

  
  for(i=0;i<(len>>1);i++){
    printf("%04X ",*(uint16_t*)((uint16_t*)d+i));
    if(((i+1)%0x08)==0) printf("\n");
  }
  if(((i)%0x08)!=0) printf("\n");
}


void line_print_16_bytes(unsigned char * data,int len){
  int i;

  printf(RED);
  if(is_bigendian()) printf("Big endian "); else printf("Little endian ");
  printf("line_print_16_bytes\n");
  printf(DEFAULT);

  for(i=0;i<len;i++){
    printf("%02X ",*(data+i));
    if(((i+1)%0x10)==0) printf("\n");
  }
  if(((i)%0x10)!=0) printf("\n");
}


void line_print_all_bytes(unsigned char * data,int len){
  int i;
#if 0
  printf(RED);
  if(is_bigendian()) printf("Big endian "); else printf("Little endian ");
  printf("line_print_all_bytes:\n");
  printf(DEFAULT);
  #endif

  for(i=0;i<len;i++){
    printf("%02X",*(data+i));
  }
  printf("\n");
}



/* this function return -1 or 1 */
int kind_of_memcmp(int *param_1,int *param_2,int param_3){
  int i;
  printf(RED);
  printf("kind_of_memcmp, FUN_1000a4c0\n");
  printf(DEFAULT);

  i=  param_3 -1;
  while( true ) {
    if (i < 0) {
      printf(GREEN);
      printf("1: a4c0: We have an identical int\n");
      printf("2: a4c0: Content of param_1:\n");
      line_print_4_ints((unsigned char*)param_1,param_3*sizeof(int));
      printf("3: a4c0: Content of param_1:\n");
      line_print_4_ints((unsigned char*)param_2,param_3*sizeof(int));
      printf(DEFAULT);

      return 0;
    }

    if (*(uint *)(param_2 + i) < *(uint *)(param_1 + i)) break;
    if (*(uint *)(param_1 + i) < *(uint *)(param_2 + i)) {
      return -1;
    }
    i= i -1;
  }
  return 1;
}

// ai suggests bn_num_words 
int bn_num_words(int *param_1,int len){  //very starnge function
  int i;

  //printf(RED);
  //printf("bn_num_words, FUN0_1000a6bc\n");
  //printf(DEFAULT);

  for(i = len -1; ( (i > -1) && (*(param_1 +i) == 0)); i = i -1) {
  }
  return i + 1;
}


uint bn_shift_left(int *param_1,int *param_2,uint param_3,uint  len){
  uint local_24;
  uint i;
  uint local_18;
  uint local_14;
  
  printf(RED);
  printf("bn_shift_left, FUN_10009824\n");
  printf(DEFAULT);

  if (param_3 < 0x20) {
    local_24 = 0;
    for (i = 0; i < len; i = i + 1) {
      local_14 = *(uint *)(param_2 + i);
      *(uint *)(param_1 + i) = local_14 << (param_3 & 0x3f) | local_24;
      if (param_3 == 0) {
        local_14 = 0;
      } else {
        local_14 = local_14 >> ((0x20 - param_3) & 0x3f);
      }
      local_24 = local_14;
    }
    local_18 = local_24;
  }else{
    local_18 = 0;
  }
  return local_18;
}

uint bn_shift_right(int *param_1,int *param_2,uint param_3,int len){
  uint local_24;
  int  i;
  uint local_18;
  uint local_14;
  
  printf(RED);
  printf("bn_shift_right, FUN_10009924\n");
  printf(DEFAULT);

  if (param_3 < 0x20) {
    local_24 = 0;
    for (i = len + -1; i>=0; i = i + -1) {
      local_14 = *(uint *)(param_2 + i);
      *(uint *)(param_1 + i) = local_14 >> (param_3 & 0x3f) | local_24;
      if (param_3 == 0) {
        local_14 = 0;
      } else {
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



//this function only reads param_{2,3} and only writes return_buffer
// waar komt param_2 vandaan
//ai suggests bn_div_rem_words
void bn_div_rem_words(int *return_value,int *param_2,uint param_3) {

  ushort p3_h;  //was uVar1  
  ushort p3_l;  
  ushort p21_l;  
  ushort p21_h;  //was local_18;
  uint uVar2;
  int iVar3;
  uint     local_28;
  uint32_t local_24;

  ushort   local_16;
  
  printf(RED);
  printf("bn_div_rem_words,FUN_1000b104\n");
  printf(DEFAULT);

  // we can not print param_2 becaus we dont know its size
  printf("2.0: b104: param_2[0]: 0x%08X\n",param_2[0]);
  printf("2.1: b104: param_2[1]: 0x%08X\n",param_2[1]);
  printf("2.2: b104: param_2[2]: 0x%08X\n",param_2[2]);
  printf("3.0: b104: param_3   : 0x%08X\n",param_3);

 
  p3_h = (ushort)(param_3 >> 0x10);
  p3_l = (ushort)(param_3 & 0xFFFF);
  
  local_24 = param_2[1];


  if (p3_h == 0xffff) {
    p21_h = (ushort)(local_24 / (p3_h + 0) ); 
  }else{
    p21_h = (ushort)(local_24 / (p3_h + 1) );
  }

  uVar2 = (uint) p21_h * p3_l;

  //printf("3.3: b104: uVar2          : 0x%08X\n",uVar2);
  //printf("3.4: b104: uVar2*-0x10000 : 0x%08X\n",uVar2*-0x10000);

  local_28 = param_2[0] + uVar2 * -0x10000;
  if (uVar2 * -0x10000 - 1 < local_28) {
    local_24 = local_24 - 1;
  }
  //printf("3.5: b104: local_28  : 0x%08X\n",local_28);
  //printf("3.6: b104: local_24  : 0x%08X\n",local_24);
  //printf("3.7: b104: p21_h     : 0x%04X\n",p21_h);



  // local_24 lijkt veel te groot te zijn
  local_24 = (local_24 - (uVar2 >> 0x10)) - (uint)p21_h * (uint)p3_h;

  //printf("4:   b104: local_24  : 0x%08X\n",local_24);
  //printf("5:   b104: p3_h      : 0x%04X\n",p3_h);

  unsigned char loop_condition;
  while ( loop_condition = ((local_24 > p3_h) || ( (local_24 == p3_h) && ( (param_3 << 0x10) <= local_28) ) ), loop_condition == true ) {

    //printf("5.3: b104: 0x%X <= 0x%X, ",param_3<<0x10, local_28);
    //printf("loop_condition: %i\n",loop_condition);
    
    local_28 = local_28 + (param_3 & 0xffff) * -0x10000;
    //local_28 = local_28 + ((param_3 & 0xffff) << 0x10);

    if ((param_3 & 0xffff) * -0x10000 - 1 < local_28) {
      local_24 = local_24 - 1;
    }
    local_24 = local_24 - p3_h;
    p21_h = p21_h + 1;
    //if(p21_h>0xFFF0){
    //  printf("5.5:   b104: break from b104 loop 1\n");
    //  exit(-1);
    //}
    //printf("6:   b104: local_24: 0x%08X, ",local_24);
    //printf("p3_h: 0x%04X, ",p3_h);
    //printf("local_28: 0x%08X, ",local_28);
    //printf("param_3: 0x%08X\n",param_3);
  }

  if (p3_h == 0xffff) {
    local_16 = (local_24>>16)&0xFFFF;
  }else {
    local_16 = (ushort)( (local_24 * 0x10000 + (local_28 >> 0x10)) / (p3_h + 1));
  }
  //printf("7:   b104: local_16  : 0x%04X\n",local_16);
  
  iVar3 = (uint)local_16 * (param_3 & 0xffff);
  uVar2 = (uint)local_16 * (uint)p3_h;
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

    //if(local_16>0xFFF0){
    //  printf("break from b104 loop 2\n");
    //  exit(-1);
    //}

  }
  *return_value = (uint)p21_h * 0x10000 + (uint)local_16;
  //printf("8:   b104: return_value: 0x%08X\n",*return_value);
  return;
}


/* name could be multiword_subtract */

/*
 * Given its usage in code that deals with signatures and keys
 * The modular arithmetic is probably part of a larger cryptographic operation
 * Most likely part of RSA or similar public-key cryptography implementation 
 */
int big_int_subtract(int *param_1,int *param_2,int *param_3,uint len){
  uint local_28;
  int  local_24;
  uint i;

  int *return_buffer;
  return_buffer = calloc(len,sizeof(int));
  
  //printf(RED);
  //printf("big_int_subtract, FUN_10009580\n");
  //printf(DEFAULT);

  //printf("0.0: 9580: param_1: \n");
  //line_print_4_ints((unsigned char*)param_1,len*sizeof(int));
  //printf("0.5: 9580: param_2: \n");
  //line_print_4_ints((unsigned char*)param_2,len*sizeof(int));
  

  local_24 = 0;
  for (i= 0; i < len; i = i + 1) {
    local_28 = *(int *)(param_2 + i) - local_24;
    if (-local_24 - 1U < local_28) {
      local_28 = -*(int *)(param_3 + i) - 1;
    }
    else {
      local_28 = local_28 - *(int *)(param_3 + i);
      if (-*(int *)(param_3 + i) - 1U < local_28) {
        local_24 = 1;
      }
      else {
        local_24 = 0;
      }
    }
    *(uint *)(return_buffer + i) = local_28;
  }
  //printf("1.0: 9580: return_buffer: \n");
  //line_print_4_ints((unsigned char*)return_buffer,len*sizeof(int));
  memcpy(param_1,return_buffer,len*sizeof(int));
  free(return_buffer);
    

  return local_24;
}

void simplefied_multiply_and_store(uint *param_1, uint param_2, uint param_3) {
    // Multiply the two parameters
    uint64_t result = (uint64_t)param_2 * (uint64_t)param_3;

    // Store the lower 32 bits in param_1[0] and the higher 32 bits in param_1[1]
    param_1[0] = (uint)(result & 0xFFFFFFFF);        // Lower 32 bits
    param_1[1] = (uint)(result >> 32);               // Upper 32 bits

    return;
}

/* on x86 this function and the function above give identical results */
/* still not sure this function works correctly on all old powerpc cpu's */
void multiply_and_store(uint *param_1,uint param_2,uint param_3){
  ushort uVar1;
  ushort uVar2;
  uint uVar3;
  uint uVar4;
  static int lc=0;
  
  //printf(RED);
  //printf("multiply_and_store, FUN_1000af94");
  //printf(DEFAULT);

  //printf("1.0: af94: param_{2,3}: 0x%.8X, 0x%.8X\n", param_2, param_3);

  uVar1 = (ushort)(param_2 >> 0x10);
  uVar2 = (ushort)(param_3 >> 0x10);
  *param_1 = (param_2 & 0xffff) * (param_3 & 0xffff);
  uVar3 = (uint)uVar1 * (param_3 & 0xffff);
  param_1[1] = (uint)uVar1 * (uint)uVar2;
  uVar4 = (param_2 & 0xffff) * (uint)uVar2 + uVar3;
  if (uVar4 < uVar3) {
    param_1[1] = param_1[1] + 0x10000;
  }
  uVar3 = param_1[0] + uVar4 * 0x10000;
  param_1[0] = uVar3;
  if (uVar3 < uVar4 * 0x10000) {
    param_1[1] = param_1[1] + 1;
  }
  param_1[1] = param_1[1] + (uVar4 >> 0x10);
  
  //printf("2.0: af84: lc: 0x%04X, param_1[0]: 0x%08X, param_1[1]: 0x%08X\n", lc,param_1[0],param_1[1]);
  //if(lc==0x410) exit(-2);
  lc++;
  return;
}




/*  implementing a multi-precision addition operation with carry*/
uint FUN_1000a738(int *param_1,int *param_2,uint param_3,int *param_4,uint param_5){
  uint uVar1;
  uint local_24;
  uint local_20[2]; // local_20[0]
  //int local_1c;   // local_20[1]
  uint i;
  uint local_14;

  static int itter=0;
  //printf(RED);
  //printf("FUN_1000a738\n");
  //printf(DEFAULT);

  //why are param_1 and param 2 identical
  //printf("0: a738: param_1:\n");
  //line_print_4_ints((unsigned char*)param_1,param_5);


  //printf("1.1: a738: param_3: 0x%X\n", param_3);
  //printf("1.2: a738: param_4\n ");
  //line_print_4_ints((unsigned char*)param_4,param_5);
  
  memset(local_20,0,2*sizeof(int));
  
  if (param_3 == 0) {
    local_14 = 0;
  }
  else {
    local_24 = 0;
    //printf("2: a738: param_5: %i\n",param_5);
    //printf("3: a738: param_1:\n");

    for (i = 0; i < param_5; i = i + 1) {
      //printf("i: 0x%04X, ",i);
      multiply_and_store(&local_20[0],param_3,*(uint *)(param_4 +i)); //was i*4

      //printf("0x%X ",*(int *)(param_2 + i) );
      uVar1 = *(int *)(param_2 + i) + local_24;
      *(uint *)(param_1 + i) = uVar1;
      local_24 = (uint)(uVar1 < local_24);
      
      uVar1 = *(int *)(param_1 + i) + local_20[0];
      *(uint *)(param_1 + i) = uVar1;
      if (uVar1 < local_20[0]) {
        local_24 = local_24 + 1;
      }
      local_24 = local_24 + local_20[1];
    }
    //printf("\n");
    local_14 = local_24;
  }
  //printf("4: a738: function itter: %i\n", itter);

  //printf("5: a738: param_1:\n");
  //line_print_4_ints((unsigned char*)param_1,param_5*sizeof(int));
  itter++;
  return local_14;
}



/*
 * param_1: rw
 * param_2: ro
 * param_3: to function
 * param_4: to function
 * len    : ro
 */

/* implementing a multi-precision subtraction operation with borrow */
// ai suggests bn_word_mul_sub
int bn_word_mul_sub(int *param_1,uint param_3,int *param_4,uint len){
  uint uVar1;
  uint local_24;
  unsigned int *return_value;  // local_20[0]
  uint i;
  int local_14;
  int *param4;
  printf(RED);
  printf("bn_word_mul_sub, FUN_1000a8a4\n");
  printf(DEFAULT);

  return_value=calloc(2,sizeof(unsigned int));
  param4=calloc(1,sizeof(int));
  
  if (param_3 == 0) {
    local_14 = 0;
  }else {
    local_24 = 0;
    for (i= 0; i < len; i = i + 1) {
      if(!is_bigendian()) *(uint*)(param4) = __htobe32(*(uint*)(param_4+i));
      else *(uint*)(param4) = *(uint*)(param_4+i);
	
      multiply_and_store(return_value,param_3,*(uint *)(param4));
      uVar1 = *(int *)(param_1 + i) - local_24;
      *(uint *)(param_1 + i) = uVar1;
      local_24 = (uint)(-local_24 - 1 < uVar1);
      uVar1 = *(int *)(param_1 + i) - *return_value;
      *(uint *)(param_1 + i) = uVar1;
      //printf("0.0: a8a4: *(uint*)(param_1 + %i): 0x%X\n",i,*(uint*)(param_1+i) );
      if (-*return_value - 1 < uVar1) {
        local_24 = local_24 + 1;
      }
      local_24 = local_24 + *(return_value+1);
    }
    local_14 = local_24;
  }
  //printf("1.0: a8a4: return value local_14: 0x%X\n",local_14);

  //printf("2.0: a8a4: param_1:\n");
  //line_print_4_ints((unsigned char*)param_1,len*sizeof(int));
  free(return_value);
  free(param4);
  return local_14;
}


int old_FUN_1000a8a4(int *param_1,int *param_2,uint param_3,int *param_4,uint len){
  uint uVar1;
  uint local_24;
  unsigned int *return_value;  // local_20[0]
  uint i;
  int local_14;
  printf(RED);
  printf("FUN_1000a8a4\n");
  printf(DEFAULT);

  return_value=calloc(2,sizeof(unsigned int));
  
  if (param_3 == 0) {
    local_14 = 0;
  }else {
    local_24 = 0;
    //printf("0.5: a8a4: len: %i\n",len);
    for (i= 0; i < len; i = i + 1) {
      multiply_and_store(return_value,param_3,*(uint *)(param_4 + i));
      uVar1 = *(int *)(param_2 + i) - local_24;
      *(uint *)(param_1 + i) = uVar1;
      local_24 = (uint)(-local_24 - 1 < uVar1);
      uVar1 = *(int *)(param_1 + i) - *return_value;
      *(uint *)(param_1 + i) = uVar1;
      if (-*return_value - 1 < uVar1) {
        local_24 = local_24 + 1;
      }
      local_24 = local_24 + *(return_value+1);
    }
    local_14 = local_24;
  }
  //printf("1.0: a8a4: return value local_14: 0x%X\n",local_14);

  //printf("2.0: a8a4: param_1:\n");
  //line_print_4_ints((unsigned char*)param_1,len*sizeof(int));
  //printf("3.0: a8a4: param_2:\n");
  //line_print_4_ints((unsigned char*)param_2,len*sizeof(int));
  return local_14;
}




uint bn_clz_word(uint param_1){
  printf(RED);
  printf("bn_clz_word, FUN_1000aa18\n");
  printf(DEFAULT);
  
  uint local_18;
  uint local_14;
  
  local_14 = 0;
  for (local_18 = param_1; (local_14 < 0x20 && (local_18 != 0)); local_18 = local_18 >> 1) {
    local_14 = local_14 + 1;
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
  printf("1: aa18: param_1: %i\n",param_1);

  for (i = param_1; ((local_14 < 0x20) && (i != 0)); i = i >> 1) {
    //printf("i: %i\n",i);
    local_14 = local_14 + 1;
  }
  return local_14;
}

// param_5 is first part of key in reverse order
// param_3 seems to be related to hash_buffer
/*
 * RSA key in DAT_variables.h file. key bit size and key exponent match RSA key. should check with: openssl rsa -pubin -inform PEM -text -noout < pub.key
 */

// ai suggests bn_mod_reduce_montgomery as name 
 void bn_mod_reduce_mont(int *param_1,int *param_2,int *param_3,uint param_4,int *reverse_key,uint param_6){
  int iVar1=0;
  int iVar2=0;
  uint uVar3;
  int iVar4=0;
  uint local_1d0=0;
  int auStack_1cc [68];     // was (unsigned char) auStack_1cc [4] + (int)aiStack_1c8[67];
  uint auStack_b8 [37];     // was (unsigned char) auStack_b8 [144] + (int) iStack_bc; 
  //int iStack_bc=0;

  int* _reverse_key;
  _reverse_key=calloc(37,sizeof(int));
  
  int local_28=0;
  int i=0;
  uint local_20=0;
  uint msb_position=0;  // was local_1c
  int lc=0;
  printf(RED);

  printf("bn_mod_reduce_mont, FUN_10009a24\n");
  printf(DEFAULT);

  memset(auStack_1cc,0, 68*sizeof(int));
  memset(auStack_b8, 0, 37*sizeof(int));

  if(!is_bigendian())
    for(int q=0;q<param_4/sizeof(int);q++)
      *(param_3+q)=__htobe32(*(param_3+q));
  
  local_20 = bn_num_words(reverse_key,param_6);
  printf("-2.9: 9a24: param_3: ");	
  simple_md5sum((char*)param_3,param_4, NOT_INT); 
  //line_print_4_ints((unsigned char*)param_3, 0x80);
  

  printf("-2.5: 9a24: *reverse_key: ");
  simple_md5sum((char*)reverse_key,36*sizeof(int), NOT_INT); 
  //  line_print_4_ints((unsigned char*)reverse_key, 0x84);
  
  if (local_20 != 0) {
    msb_position=0x20-bn_clz_word(*(uint *)(reverse_key + local_20*1 -1));
    
    memset((int*)(auStack_1cc + 1),0,local_20*sizeof(uint32_t));  //local_20 == len == 8

    //if msb_position == 0 function below copies param_2 to patam_1
    uVar3 = bn_shift_left((int*)(auStack_1cc + 1),param_3,msb_position,param_4);
    // FUN_10008474 alreadey reversed the key_address data thus also the reverse_key
    bn_shift_left((int*)(auStack_b8 + 1),reverse_key,msb_position,local_20);


    printf("-1.6: 9a24: auStack_1cc: ");
    simple_md5sum((char*)(auStack_1cc+1),param_4, NOT_INT); 

    printf("-1.7: 9a24: auStack_b8: ");
    simple_md5sum((char*)(auStack_b8+1),36*sizeof(int), NOT_INT); 
    //line_print_4_ints((unsigned char*)(auStack_b8),37*sizeof(int));

    //printf("-0.6: 9a24: auStack_b8:\n");	
    //line_print_4_ints((unsigned char*)(auStack_b8+1), 0x90/sizeof(int));

    //printf("-1.0: 9a24 local_20: 0x%X\n",local_20);


    local_28 = auStack_b8[local_20+1];  // was (&iStack_bc)[local_20];
    //local_28 = auStack_b8[local_20];  // was (&iStack_bc)[local_20];

    printf("-0.9: 9a24: param_4: 0x%X\n",param_4);   //0x40 is logical
    printf("-0.8: 9a24: local_20: 0x%X\n",local_20); //0x20 is logical
    printf("-0.5: 9a24: local_28: 0x%X\n",local_28);
    printf("-0.7: 9a24: auStack_b8[%i]: 0x%X\n",local_20+1,auStack_b8[local_20+1]);
    printf("-0.6: 9a24: auStack_b8[%i]: 0x%X\n",local_20,auStack_b8[local_20]);


    memset(param_1,0,param_4*sizeof(uint32_t));  //param_4 == len
	  
    //printf("-0.1: 9a24 param_4: %i\n",param_4);
    printf(" 0.0: 9a24: auStack_1cc[%i]: 0x%08X\n",i+local_20+1,(int)auStack_1cc[i+local_20+1]);

    //printf("0.97: 9a24: local_1d0: 0x%X\n", local_1d0);

    getchar();
    for (i = param_4 - local_20; i > -1; i = i -1) { //param_4=0x40, local_20=0x20
      if (local_28 == -1) {
        local_1d0 = auStack_1cc[i + local_20 + 1];
      } else {
	
	//printf("0.98: 9a24: i: 0x%X, local_20: 0x%X, auStack_1cc:\n", i, local_20);	
	//line_print_4_ints((unsigned char*)(auStack_1cc + i + local_20), 0x80);

	//this function only reads param_{2,3} and only writes param_1
	// auStack_1cc == param_2

	//local_1d0 is the return buffer, only the first value is changed
	//local_1d0 is just one int
	printf(CYAN);
	printf("Strange that b104 param_2 takes auSTack_1cc, which is big an only uses index 0 and d 1\nLooks like someting goes wrong with index or gets over written)\n");
	printf("Remember index of auStack_1cc is (i+local_20) = 0x%X\n",i+local_20);
	printf(DEFAULT);
	printf("auStack_1cc is 68xint long, i+local_20: 0x%X, cant do line_print\n", i+local_20);
	printf("1.0: 9a24: local_28: 0x%X\n",local_28);
	printf("1.1: 9a24: local_1d0: 0x%X\n",local_1d0);
	bn_div_rem_words((int *)&local_1d0,(int *)(auStack_1cc + i + local_20),local_28 + 1);
	printf("1.2: 9a24: local_1d0: 0x%X\n",local_1d0);
	getchar();	
      }
      printf(CYAN);
      printf("1.3: 9a24: fun0_1000b104 fucks up content of auStack_1cc in x86 code\n");
      printf(DEFAULT);


      
      iVar1 = i + local_20;
      iVar2 = i + local_20;

      /* a8a4 levert product som van array _1cc *_1cc of zo iets */

      // should we correct for big/little endianess ????

      printf("1.4: 9a24: auStack_1cc:\n");
      line_print_4_ints((unsigned char*)(auStack_1cc),(2*local_20+1)*sizeof(int));
      printf("1.5: 9a24: auStack_b8:\n");
      line_print_4_ints((unsigned char*)(auStack_b8),37*sizeof(int));
      printf("1.6: 9a24: i: 0x%X, local_1d0: 0x%X\n",i, local_1d0);

      iVar4 = bn_word_mul_sub((int*)(auStack_1cc + i + 1),local_1d0,(int*)(auStack_b8+1),local_20);

      
      printf("1.7: 9a24: auStack_1cc:\n");
      line_print_4_ints((unsigned char*)(auStack_1cc),(2*local_20+1)*sizeof(int));


      //printf("2.0: 9a24: auStack_1cc[%i]: 0x%08X\n",i+local_20+1,(uint)auStack_1cc[i+local_20+1]);
      auStack_1cc[iVar1 + 1] = auStack_1cc[iVar2 + 1] - iVar4;
      printf("2.4: 9a24: auStack_1cc[%i] = iVar4: 0x%08X\n",iVar1+i, iVar4);

      //printf("2.5: 9a24: auStack_1cc[%i]: 0x%08X\n",i+local_20+1,(int)auStack_1cc[i+local_20+1]);

      //printf("3.1: 9a24: auStack_1cc\n");
      //line_print_8_ints((unsigned char*)auStack_1cc,68*sizeof(int));
      //printf("3.2: 9a24: auStackb8\n");
      //line_print_4_ints((unsigned char*)(auStack_b8+1),2*local_20*sizeof(int)+8);
      printf(MAGENTA);
      printf("We should continuasly check the loop conditions, when stops????\n");
      printf("diffrence between x86 and ppc\n");
      printf(DEFAULT);

      while (
	     (
	      ( auStack_1cc[i + local_20 + 1] != 0)||
	      (
	       iVar1 = kind_of_memcmp((int*)(auStack_1cc + i + 1),(int*)(auStack_b8+1),local_20)
	       ,(iVar1 > -1)
	       )
	      )
	     ) {
	//printf("4.4: 9a24: (auStack_b8+1): ");
	//simple_md5sum((char*)(auStack_b8+1),local_20*sizeof(int), NOT_INT); 
	//line_print_4_ints((unsigned char*)(auStack_b8+1),local_20*sizeof(int));

	//printf("4.5: 9a24: auStack_1cc: ");
	//simple_md5sum((char*)(auStack_1cc +i +1),local_20*sizeof(int), NOT_INT); 
	//line_print_4_ints((unsigned char*)(auStack_1cc + i +1),local_20*sizeof(int));

	//printf("4.6: 9a24: (auStack_1cc + 1)[i + local_20] != 0: %i\n",(auStack_1cc + 1)[i + local_20] != 0 );
	//printf("4.7: 9a24: (iVar1 > -1): %i\n",(iVar1 > -1) );
	

	//printf("4.8: 9a24: lc: 0x%08X, auStack_1cc[%i]: 0x%08X\n",lc,i+local_20+1,(int)auStack_1cc[i+local_20+1]);

        local_1d0 = local_1d0 + 1;
        iVar1 = i + local_20; // local_20=0x20, i at first itter is also 0x20
        iVar2 = i + local_20; // iVar1 and iVar2 are 0x40

	/*
	 * this function has to update auStack_1cc within the range,
	 * that is checked in the while loop conditions
	 * the rrurn value is always 0 or 1
	 */

	//printf("5.3: 9a24: iVar4: 0x%X\n",iVar4);
        iVar4 = big_int_subtract((int*)(auStack_1cc + i + 1),(int*)(auStack_1cc + i + 1),(int*)(auStack_b8+1),local_20);

	//printf("5.4: 9a24: lc: 0x%X, iVar4: 0x%X\n",lc,iVar4);

	//printf("5.5: 9a24: auStack_1cc+i+1: \n");
	//line_print_4_ints((unsigned char*)(auStack_1cc + i + 1),local_20*sizeof(int));
	
	if((auStack_1cc[i+local_20+1]%0x500000)==0)
	printf("5.9: 9a24: i: %i, iVar4: 0x%X, iVar1: %i, iVar2: %i, local_20: %i, auStack_1cc[%i]: 0x%08X\n",i,iVar4, iVar1, iVar2, local_20,i+local_20+1,(int)auStack_1cc[i+local_20+1]);

       
        auStack_1cc[iVar1 + 1] = auStack_1cc[iVar2 + 1] - iVar4;
	//if(lc==0x5) exit(-2);
	//getchar();
	lc++;

      } // end of while

      printf(BLUE);
      printf("6: 9a24: lc: 0x%i, i: %i, iVar4: 0x%X, iVar1: %i, local_20: %i, auStack_1cc[%i]: 0x%08X\n",lc, i,iVar4, iVar1, local_20,i+local_20+1,(int)auStack_1cc[i+local_20+1]);
      printf(DEFAULT);
      //if(i==31) exit(-2);
      //getchar();

      
      *(uint *)(param_1 + i) = local_1d0;
    } //end of for


    memset(param_2,0,param_6*sizeof(uint32_t));

    bn_shift_right(param_2,(auStack_1cc + 1),msb_position,local_20);
    memset(auStack_1cc + 1,0,0x10c); // size is 0x110, why not clear all?
    memset(auStack_b8,0,0x84);       // size is 0x90,  why not clear all?
  } //end of if
  return;
}




//OpenSSL nameing for this function  bn_mul
void bn_mul(int *param_1,int *param_2,int *param_3,int param_4){
  int iVar1;
  uint uVar3;
  int aiStack_138 [66+2]; // was 68
  uint local_28;
  uint local_24;
  uint i;

  
  //printf(RED);
  //printf("bn_mul, FUN_100096ac\n");
  //printf(DEFAULT);

  memset(aiStack_138,0,(param_4 << 1)*sizeof(uint32_t));

  local_28 = bn_num_words(param_2,param_4); //should return 32
  local_24 = bn_num_words(param_3,param_4); //should return 32

  //printf("3: 96ac: local_28: %i\n",local_28);  // should return 32
  //printf("4: 96ac: local_24: %i\n",local_24);  // should return 32

  //intf("4.1: 96ac: aiStack_138:\n");
  //ne_print_4_ints((unsigned char*)aiStack_138,(param_4<<1)*sizeof(uint32_t));
  
  for (i = 0; i < local_28; i = i + 1) {  //i=0:32
    //printf("4.2: 96ac: i: %i, ",i);
    iVar1 = local_24 + i;  //32+i

    // in the case below the iderntical first two parameters is ok
    uVar3 = FUN_1000a738(  (aiStack_138 + i),(aiStack_138 + i),*(param_2+i),param_3,local_24);
    aiStack_138[iVar1] = aiStack_138[iVar1] + uVar3;
  }
  //printf("5: 96ac: aiStack_138:\n");
  //line_print_4_ints((unsigned char*)aiStack_138,(param_4<<1)*sizeof(uint32_t));
  
  memcpy(param_1, aiStack_138, (param_4<<1) * sizeof(uint32_t));  //param_4 is line of len
  memset(aiStack_138,0,0x108);
  return;
}




// parameter 4 is paramter 5 van 9a24
// ai suggests  rsa_montgomery_multiply or rsa_modular_multiply  as a name for this function
// more acurate ai suggests rsa_montgomery_modular_multiply
//  OpenSSL library uses bn_mod_mul_montgomery
void bn_mod_mul_mont(int *param_1,int *param_2,int *param_3,int *param_4,uint param_5){
  int auStack_120[0x11c];
  int auStack_220[0x11c];  

  //printf(RED);
  //printf("bn_mod_mul_mont, FUN_10009e2c\n");
  //printf(DEFAULT);

  memset(auStack_120,0,0x11c*sizeof(int));
  memset(auStack_220,0,0x11c*sizeof(int));

  bn_mul(auStack_120,param_2,param_3,param_5);
  bn_mod_reduce_mont(auStack_220,param_1,auStack_120 ,param_5<<1,param_4,param_5);
  
  memset(auStack_220,0,66*sizeof(int));
  memset(auStack_120,0,66*sizeof(int));
  return;
}



// paramet 5 is parameter 5 van 9a24
// ai suggect (RSA_)montgomery_modular_exponentiation as a name for this function
// OpenSSL library uses bn_mod_exp_mont 
void bn_mod_exp_mont (int *return_buffer,int *param_2,int *param_3,int param_4,int *param_5,uint len){
  int iVar1;
  int auStack_2d4[144];
  int auStack_250[144];
  int auStack_1cc[144];
  int auStack_148[144]; 
  uint local_c0;
  int local_b8 [36];  //36*4=144????????, toeval????????????
  int local_28;
  uint local_24;
  uint local_20;
  uint local_1c;


  memset(auStack_2d4,0,144*sizeof(int));
  memset(auStack_250,0,144*sizeof(int));
  memset(auStack_1cc,0,144*sizeof(int));
  memset(auStack_148,0,144*sizeof(int));
  memset(local_b8,   0, 36*sizeof(int));
  
  printf(RED);
  printf("bn_mod_exp_mont, FUN_10009ebc\n");
  printf(DEFAULT);

  memcpy(auStack_250, param_2, len * sizeof(uint32_t));
  
  bn_mod_mul_mont(auStack_1cc,auStack_250,param_2,param_5,len);
  bn_mod_mul_mont(auStack_148,auStack_1cc,param_2,param_5,len);


  memset(local_b8, 0, len * sizeof(uint32_t));
  
  local_b8[0] = 1;
  iVar1 = bn_num_words(param_3,param_4);
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

      bn_mod_mul_mont(local_b8,local_b8,local_b8,param_5,len); // squaring  result=(input*input)mod n, n=param_5
      bn_mod_mul_mont(local_b8,local_b8,local_b8,param_5,len); // squaring
      local_1c = local_c0 >> 0x1e;
      if (local_1c != 0) {
        bn_mod_mul_mont(local_b8,local_b8,(auStack_2d4 + local_1c * 0x84),param_5,len);
      }
      local_c0 = local_c0 << 2;
    }
  }

  memcpy(return_buffer, local_b8, len * sizeof(uint32_t));
  memset(auStack_250,0,0x18c);  // size is 0x240, why not clear all?
  memset(local_b8,0,0x84);      // size is 0x90,  why not clear all?
  return;
}



// ai suggests bn_bn2bin as name 
void bn_bn2bin(int *hash,int key_len,int *key,uint hash_len){
  uint uVar1;
  int j;
  uint k;
  uint i;

  printf("bn_bn2bin, FUN_100091dc\n");

  k = 0;
  j = hash_len - 1;
  while (k < key_len && j >= 0) {
    uVar1 = *(uint *)(hash + k);
    for (i= 0; ((-1 < j) && (i < 0x20)); i = i + 8) {
      *(unsigned char *)((unsigned char*)key + j) = (char)(uVar1 >> (i & 0x3f));
      j = j + -1;
    }
    k = k + 1;
  }
  for (; -1 < j; j = j  -1) {
    *(unsigned char *)(key + j) = 0;
  }
  return;
}



/* I think key is endianess sensitive */
/* should correct for endianness of key only once */
/* param_1 == auStack_140 */
// ai suggests bn_bin2bn as name
void bn_bin2bn(int *packed_key,uint key_len,int *key,int hash_len){
  uint local_28;
  int j;
  uint k;
  uint i;

  printf(RED);
  printf("bn_bin2bn, FUN0_100090a4\n");
  printf(DEFAULT);


  k = 0;
  j= hash_len - 1;  // for 0 to 0x79, reads key in bytes (cast)

  while ((k < key_len && (-1 < j))) { //runs 0x21 times
    local_28 = 0;
    for (i = 0; ((j>-1) && (i<0x20)); i = i + 8) { // runs 4 times
      local_28 = local_28 | (unsigned int)*(unsigned char*)((unsigned char*)key+j) << (i & 0x3f); //shift left over i bits
      j = j - 1;
    }
    *(uint *)(packed_key + k) = local_28; //copy something to auStack_140, was k*4
    k = k + 1;
  }
  
  for (; k < key_len; k = k + 1) {
    *(uint32_t*)(packed_key + k ) = 0;  // was k*4
  }

  return;
}


/* is param_2 some kind of length? */
/* at teh end: *param_2 = (*key_address + ui) >> 3;  */
/* we need to check endianness at the end  for param_2 to be correct*/
/* some key/hash bufers seem to be big endian and some little endian */
/* ai suggest rsa_verify_raw_montgomery as name */
uint32_t rsa_verify_raw_montgomery(int *pass_through,uint *param_2,unsigned char *hash_buffer,int hash_len,int *key_address){
  int iVar1;
  int return_buffer[36];
  int auStack_1d0[36];
  int auStack_140[36];
  int auStack_0b0[36];  // goes into FUN_10009ebc and eventuall into 9a24 param_5
  int local_20;
  uint local_1c;
  uint32_t local_18;
  
  printf(RED);
  printf("rsa_verify_raw_montgomery, FUN_100089b8\n");
  printf(DEFAULT);

  memset(return_buffer,0,36*sizeof(int));
  memset(auStack_1d0,  0,36*sizeof(int));
  memset(auStack_140,  0,36*sizeof(int));
  memset(auStack_0b0,  0,36*sizeof(int));

  printf("0: 89b8: key_address md5_sum: ");
  simple_md5sum((char*)key_address,(KEY_SIZE+1)*sizeof(int), !is_bigendian()); 
  //line_print_4_ints((unsigned char*)(key_address),(KEY_SIZE+1)*sizeof(int));

  printf("0.6: 89b8: hash_len: 0x%X\n",hash_len);

  bn_bin2bn(auStack_140, 0x21,(int*)hash_buffer ,hash_len);
  printf("0.7: 89b8: auStack_140 md5sum: ");
  simple_md5sum((char*)auStack_140,(KEY_SIZE+1)*sizeof(int),!is_bigendian());
  line_print_4_ints((unsigned char*)auStack_140,(KEY_SIZE+1)*sizeof(int));
  
  printf("0.9: 89b8: hash_buffer md5sum: ");
  simple_md5sum((char*)hash_buffer,hash_len, NOT_INT);
  line_print_4_ints((unsigned char*)hash_buffer,hash_len);

  //printf("1.0: 89b8: (key_address+0x01)\n");
  //line_print_4_ints((unsigned char*)(key_address+0x01),(KEY_SIZE+1)*sizeof(int));
  //printf("1.1: 89b8: (key_address+0x21)\n");
  //line_print_4_ints((unsigned char*)(key_address+0x21),KEY_SIZE*sizeof(int));


  /* is the function below (2x pack_key) correct */
  /* waarom param_4 in bytes */
  bn_bin2bn(auStack_0b0, 0x21,(key_address + 0x01), 0x80); // packs RSA key Modulus 
  bn_bin2bn(auStack_1d0, 0x21,(key_address + 0x21), 0x80); // packs RSA key Exponent  
  
  printf("1.2: 89b8: auStack_0b0 md5_sum: ");
  simple_md5sum((char*)auStack_0b0,(KEY_SIZE+1)*sizeof(int),NOT_INT);
  line_print_4_ints((unsigned char*)auStack_0b0,0x21*sizeof(int));
  printf("1.3: 89b8: auStack_1d0 md5_sum: ");
  simple_md5sum((char*)auStack_1d0,(KEY_SIZE+1)*sizeof(int),NOT_INT);
  line_print_4_ints((unsigned char*)auStack_1d0,0x21*sizeof(int));

  /* below confirms keys are endian sensitive */
  printf("exponent: %i\n", __htobe32(*(int*)auStack_1d0));
  printf("exponent: %X\n", __htobe32(*(int*)auStack_1d0));
  exit(-2);
  
  /* find the actual key size */
  local_1c = bn_num_words(auStack_0b0,0x21); // 0x20 size is 20 ints
  local_20 = bn_num_words(auStack_1d0,0x21); // 0x01 size is 1 int

  printf("2.0: 89b8: local_1c: 0x%X, local_20: 0x%X\n",local_1c,local_20);

  iVar1 = kind_of_memcmp(auStack_140,auStack_0b0,local_1c); 
  printf("2.1: 89b8: iVar1: %i\n",iVar1);
  
  printf("2.4: 89b8: auStack_140 md5_sum: ");
  //  simple_md5sum((char*)auStack_140,(KEY_SIZE+1)*sizeof(int),NOT_INT);
  simple_md5sum((char*)auStack_140,(KEY_SIZE+1)*sizeof(int),!is_bigendian());

  line_print_4_ints((unsigned char*)auStack_140,(KEY_SIZE+1)*sizeof(int));
  printf("2.5: 89b8: auStack_0b0 md5_sum: ");
  simple_md5sum((char*)auStack_0b0,(KEY_SIZE+1)*sizeof(int),NOT_INT);
  line_print_4_ints((unsigned char*)auStack_0b0,(KEY_SIZE+1)*sizeof(int));

  printf(MAGENTA);
  printf("we should check function 90a4\n");
  printf("Should it copy of change the hash to auStack_140?\n");
  printf(DEFAULT);

  
  if (iVar1 < 0) { // auStack_0b0 is not equal to auStack_140
    printf("3.0: 89b8: auStack_140 md5_sum: ");
    simple_md5sum((char*)auStack_140,(KEY_SIZE)*sizeof(int),!is_bigendian());
    //line_print_4_ints((unsigned char*)auStack_140,(KEY_SIZE+1)*sizeof(int)); //full, len=32
    
    printf("3.2: 89b8: auStack_1d0 md5_sum: ");
    simple_md5sum((char*)auStack_1d0,(KEY_SIZE)*sizeof(int),NOT_INT);
    //line_print_4_ints((unsigned char*)auStack_1d0,(KEY_SIZE+1)*sizeof(int)); //almost empty, len=1
    printf("3.3: 89b8: auStack_0b0 md5_sum: ");
    simple_md5sum((char*)auStack_0b0,(KEY_SIZE)*sizeof(int),NOT_INT);
    //line_print_4_ints((unsigned char*)auStack_0b0,(KEY_SIZE+1)*sizeof(int)); //full, len=32


    bn_mod_exp_mont(return_buffer,auStack_140,auStack_1d0,local_20,auStack_0b0,local_1c);

    printf("4.0: 89b8: tmp: 0x%08X\n",*key_address);
    *param_2 = (*key_address + 7U) >> 3;

    /* unpack return_buffer to pass_through */
    bn_bn2bin(pass_through,*param_2,return_buffer,local_1c); //realy (int*)?
    memset(return_buffer,0,0x84);
    memset(auStack_140,0,0x84);
    local_18 = 0;
  }
  else {
    local_18 = RSA_ERR_PADDING;
  }
  
  return local_18;
}


// len_1[0] should be KEY_SIZE == 0x20 len_2 == 0x80 == sizeof(hash_buffer))
// FUN_10008474 only acts on one key !!!!!!!!!
/* 
 * Verify PKCS#1 type 1 padding (0x00 0x01 0xFF... 0x00 DATA)
 * Returns 0 on success, 0x401 on padding error
 */

/* new function */
int verify_pkcs1_type1_padding(unsigned char *buffer, uint buffer_len, void *out_data, size_t *out_len) {
  uint i;
  uint data_start;
  unsigned char *separator_ptr;

  // Check for PKCS#1 padding header (0x00 0x01)
  if ((buffer[0] != '\0') || (buffer[1] != '\x01')) {
    return RSA_ERR_PADDING;
  }

  // Find padding end (0xFF bytes followed by 0x00 separator)
  for (i = 2; (i < buffer_len - 1) && (buffer[i] == 0xFF); i++) {
    // Iterate through padding bytes
  }
  
  separator_ptr = &buffer[i];
  data_start = i + 1;
  
  // Check for 0x00 separator
  if (*separator_ptr != '\0') {
    return RSA_ERR_PADDING;
  }

  // Calculate data length
  *out_len = buffer_len - data_start;
  
  // Verify minimum padding length (8 bytes) - 0x00 0x01 + at least 6 0xFF bytes + 0x00
  if (buffer_len < *out_len + 0xb) {
    return RSA_ERR_PADDING;
  }
  
  // Copy data to output buffer if length > 0
  if (*out_len != 0) {
    memcpy(out_data, buffer + data_start, *out_len);
  }
  
  return 0;
}

/* 
 * RSA verify with PKCS#1 padding
 * Returns 0 on success, error code on failure
 */
int rsa_verify_pkcs1_padding(void *return_buffer,size_t *key_len,unsigned char *hash_buffer,uint hash_len,int *key_address){

  int i;
  uint uVar1;
  unsigned char *pcVar2;

  /*
   * pass threough get overloaded, should only be 128 long, now 128*sizeof(int)
   * probably what is returned to pass_throughh is more than 128
   */
  unsigned char pass_through[0x80*sizeof(int)]; //probably return buffer for key because of length
  uint local_20;
  uint local_1c;
  uint local_18;
  int  ret;

  printf(RED);
  printf("rsa_verify_pkcs1_padding, FUN_10008474\n");
  printf(DEFAULT);

  if(!is_bigendian()){  //if not powerPC
    //hash should nog be converted to big endian, otherwise multiply and store goes wrong
    for(i=0;i<KEY_BUFFER_SIZE_INTS;i++)
      *(int*)((int*)key_address+i)= __htobe32(*(int*)((int*)key_address+i));
    //for(i=0;i<hash_len;i++)
      //*(int*)((int*)hash_buffer+i)= __htobe32(*(int*)((int*)hash_buffer+i));
  }

  printf("-4.0: 8474: *key_len: 0x%lX\n", (long int)*key_len); // *key_len = 0x20


  printf("-3.0: 8474: key_address, endianness corrected, md5_sum: ");
  simple_md5sum((char*) key_address,(key_len[0]+1)*sizeof(int), !is_bigendian());
  //line_print_4_ints((unsigned char*)key_address,(key_len[0]+1)*sizeof(int));
  
  printf("-2.0: 8474: hash_buffer: ");
  simple_md5sum((char*) hash_buffer,HASH_BUFFER_SIZE_CHARS, IS_INT);
  //line_print_4_ints(hash_buffer,HASH_BUFFER_SIZE_CHARS);

  local_1c = (*key_address + 7U) >> 3;  // local_1c == 0x80, hash_len == 0x80

  printf(BLUE);
  printf("-1.5: 8474: local_1c: 0x%X\n", local_1c);
  printf("-1.0: 8474: hash_len: 0x%X\n", hash_len);
  printf(DEFAULT);

  if (local_1c < hash_len) {
    ret = RSA_ERR_SIZE;
  }else{
    printf("0.0: 8474: key_address md5_sum: ");
    simple_md5sum((char*)(key_address),(KEY_SIZE+1)*sizeof(int),!is_bigendian()); 
    printf("0.1: 8474: local_1c: 0x%X\n", local_1c);

    ret = rsa_verify_raw_montgomery((int*)pass_through,&local_18,hash_buffer,hash_len,key_address);
    printf(CYAN);
    printf("0.3: 8474: local_1c: 0x%X\n", local_1c);
    printf(DEFAULT);

    printf(CYAN);
    printf("0.4: 8474: out (key_address+1) md5_sum: ");
    printf(DEFAULT);
    simple_md5sum((char*)(key_address+1),KEY_SIZE*sizeof(int),NOT_INT);

    if (ret == 0) {
      printf("ret==0, local_1c: 0x%X\n", local_1c);
      if (local_18 == local_1c) {
        // Verify PKCS#1 padding and extract data
        ret = verify_pkcs1_type1_padding(pass_through, local_1c, return_buffer, key_len);
        
        // Clear sensitive data
        if (ret == 0) {
          memset(pass_through, 0, 0x80*sizeof(int)); // set first 128 ints to 0
        }
      }
      else {
        ret = RSA_ERR_SIZE;
      }
    }
  }
  return ret;
}

/*************************************************************************************/
/*                            check key -> data, not correct                         */
/*************************************************************************************/  

/* do something with keys I guess */
//ai suggests rsa_verify_signature_keyring 
unsigned char rsa_verify_signature_keyring(unsigned char *hash_buffer,uint hash_len,unsigned char *digest,size_t digest_len,int add_dev_key,int verify_signature_flag) {
  bool bVar1=false;
  int param2=0;
  int iVar2;
  int nr_keys;
  int iVar4;
  int *tmp_address[8];
  int *key_address[8]; // was undefined
  unsigned char return_buffer[0x20];
  size_t key_len[3];

  printf(RED);
  printf("rsa_verify_signature_keyring, FUN_10005f64\n");
  printf(DEFAULT);

  memset(key_len,0,3*sizeof(size_t));
  memset(key_address,0,3*sizeof(int));
  
  nr_keys = 2; 
  key_address[0] = (int *)data_10022860;
  key_address[1] = (int *)data_10022964;
  key_address[2] = (int *)data_1002275c;

  
  if (add_dev_key != 0) {
    nr_keys = 3;
    printf("0.6: 5f64: Adding the developer key to the keyring. ");
    printf("Do not do this on production releases!\n");
  }
  
  bVar1 = false;
  key_len[0] = KEY_SIZE;
  iVar2 = 0;
  do {
    memset(return_buffer,0,key_len[0]);  // abStack_58 all zeors
    
    printf("0.7: 5f64: key_len[0]: 0x%lX\n", (long int)key_len[0]);
    printf("0.8: 5f64: key_address[%i] no endianness correction, md5_sum: ", iVar2);
    simple_md5sum((char*) key_address[iVar2],(key_len[0]+1)*sizeof(int), NOT_INT);
    //line_print_4_ints((unsigned char*)key_address[iVar2],(key_len[0]+1)*sizeof(int));
    
    param2 = rsa_verify_pkcs1_padding(return_buffer,key_len,hash_buffer,hash_len,key_address[iVar2]);

    //printf("0.9: 5f64: key_address[iVar2]:\n");
    //line_print_4_ints((unsigned char*)key_address[iVar2],KEY_BUFFER_SIZE_CHARS);
    
    //fflush(stdout);
    //printf("1: 5f64: param2: 0x%X\n",param2);
    
    iVar4 = iVar2 + 1;
    if (verify_signature_flag > 2) {
      //printf("[%d] - %d, digest_size=%ld \n",iVar2,param2,key_len[0]);
      /* should print below to the keyring i guess */
      line_print_16_bytes(hash_buffer,hash_len);
      line_print_16_bytes(return_buffer,key_len[0]);  
      line_print_16_bytes(digest,digest_len);
    }

    if (param2 == 0) {
      //compare digest oc header 0xe and 0x15 with abStack
      //printf(MAGENTA);
      //line_print_16_bytes(return_buffer,digest_len);  
      //line_print_16_bytes(digest,digest_len);
      //printf(DEFAULT);
      
      iVar2 = memcmp(return_buffer,digest,digest_len); // compare digest with abStack_58
      bVar1 = iVar2 == 0;                           // digest is equal to abStack_58
    }
    iVar2 = iVar4;
  } while (!bVar1 && iVar4 < nr_keys);
  
  if (verify_signature_flag != 0) {
    if (!bVar1) {
      printf("digest does not match abStack_58!\n");
    }else {
      printf("successful! Key%d\n",iVar4);
    }
  }

  return bVar1 ^ 1;
}


uint rsa_verify_signature(int fd, __off_t *fd_location ,unsigned char *read_buffer,int param_4,int verify_signature_flag){
  int i;
  uint uVar1;
  __off_t file_location, store_file_location;
  int iVar3;

  unsigned char *hash_buffer;
  hash_buffer = calloc(0x80, sizeof(unsigned char));
  unsigned char *digest; //abStack_48[48]
  digest = calloc(48, sizeof(unsigned char)); //as in original code

  printf(RED);
  printf("rsa_verify_signature, FUN_1000610c\n");
  printf(DEFAULT);

  file_location = lseek(fd,0,SEEK_CUR);  
  printf("0.8: 610c: file_location: 0x%lX\n", file_location); // file_location =0xD5

  uVar1 = 0xffffffff;
  if (file_location > -1) {  // no error

    iVar3 = rsa_hash_to_verify(fd,read_buffer,digest); // returns sha25_digest from file_location

    file_location = lseek(fd,0,SEEK_CUR);  
    printf("0.9: 610c: file_location: 0x%lX\n", file_location); // file_location =0xD5

    printf("1.0: 610c: finished sha256 digest of fw file minus header\n");
    printf("1.1: 610c: sha256 digest: ");
    line_print_all_bytes((unsigned char*)digest,SHA256_DIGEST_SIZE);
    printf("1.2: 610c: tail -c+214 hpoa440.bin | sha256sum\n");
    printf("                  digest: 471e10e450f519b7f4d0e6d995ca66b0ceb50da12f00c3df0d57e02708c77eb3\n");


    
    uVar1 = 0xffffffff;
    if (iVar3 > -1) {
      if (fd_location != (__off_t *)0x0) {  // check for null pointer ????

        store_file_location = lseek(fd,0,1);
        *fd_location = store_file_location; // write current location in fd_location
      }

      file_location = lseek(fd,file_location,SEEK_SET);
      
      uVar1 = 0xffffffff;


      if (file_location > -1) { //no error

	
	printf("1.5: 610c: file_location: 0x%lX\n",file_location);

	/* enter sha256 key rabit hole */
	// digets has been used to do sha256 over header 0xe and 0x15, should contain result
	// should we  __htobe32 digest? 

	memcpy(hash_buffer, read_buffer+0x55, HASH_BUFFER_SIZE_CHARS);

	printf("1.9: 610c: hash_buffer (no endianness corr.) md5_sum: ");
	simple_md5sum((char*)hash_buffer,0x80,NOT_INT);

        uVar1= rsa_verify_signature_keyring(hash_buffer,HASH_BUFFER_SIZE_CHARS,digest,0x20,param_4,verify_signature_flag);
	printf("2: 610c: rsa_verify_signature: uVar1: %i\n",uVar1);
      }
      printf("3: 610c: Should add developer key to keyring.\n");

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


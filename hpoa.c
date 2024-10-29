#include "hpoa.h"
#include "data_0x10010100.h"

#define DEVEL 1
#define INTERNAL 1
#define VERSION_130 130
#define VERSION_440 440
#define VERSION_999 999
#define VERSION VERSION_999

/* glocal variables */
unsigned char *DAT_1002275c=0;
unsigned char *DAT_10022860=0;
unsigned char *DAT_10022964=0;
unsigned char *DAT_10022c18=0;
unsigned char *DAT_10022c1c=0;
unsigned char *DAT_10022c28=0;

unsigned char *DAT_10022a68;

unsigned char *DAT_1000ff30=0;

unsigned char *DAT_10012738=0;

unsigned int DAT_000cbb58=-1;

char *DAT_1000ff88 = "/dev";
char *DAT_10022c2c; // waarschijnlijk naam van flash image 

unsigned int DAT_10022c20=0;
unsigned int DAT_10022c24=0;


int main(int argc,char **argv){
  
  int fd;
  off_t offset;                                                 /* __offset */
  off_t ret_offset;                                             /* _Var12 */
  char file_name[128];
  unsigned int file_size=0;
  ssize_t ret;                                                  /* uVar10 */
  char check;                                                   /* iVar11 */
  int step;                                                     /* iVar25 */
  unsigned char *read_buffer;                                   /* local_d28 */
  read_buffer=calloc(MAX_FILE_SIZE,sizeof(unsigned char));

  unsigned char *read_buffer_address_0;                         /* puVar6  */  
  unsigned char *read_buffer_address_1;                         /* pbVar23 */
  unsigned char *read_buffer_address_2;                         /* pbVar15 */
  unsigned char *read_buffer_address_3;                         /* pbVar22 */
  read_buffer_address_3=calloc(MAX_FILE_SIZE,sizeof(unsigned char));


  unsigned char *auStack_ce9;
  //auStack_ce9=calloc(161,sizeof(unsigned char));
  
  int i;                                                        /* iVar16 */
  
  int j;                                                        /* iVar27 */
  int c=0;
  unsigned char k;
  int   tmp_int_0,   tmp_int_1,   tmp_int_2,   tmp_int_3,   tmp_int_4;

  char *tmp_char_0, *tmp_char_1, *tmp_char_2, *tmp_char_3, *tmp_char_4;
  tmp_char_0=calloc(0xFF,sizeof(unsigned char));
  tmp_char_1=calloc(0xFF,sizeof(unsigned char));
  tmp_char_2=calloc(0xFF,sizeof(unsigned char));
  tmp_char_3=calloc(0xFF,sizeof(unsigned char));
  tmp_char_4=calloc(0xFF,sizeof(unsigned char));

    char *partition_name;
  partition_name=calloc(0x80,sizeof(unsigned char));
  
  unsigned char *buffer;
  buffer=calloc(MAX_FILE_SIZE,sizeof(unsigned char));

  char local_c48 [128];
  char acStack_ab8[48];

  char **param2;

  unsigned int *local_5c;
  local_5c=calloc(6,sizeof(uint));
  unsigned char uVar17=1;
  char *pcVar21;
  char *pcVar26;
  
  pcVar21=malloc(0x10*sizeof(char));
  pcVar26=malloc(0x100*sizeof(char));
  unsigned int uVar20=1;
  unsigned int uVar24;
  int iVar19=0;
  int iVar18=0;
  unsigned int  partition_nr;  //was unsigned char, was uVar9

  unsigned int jump_size=0;
  unsigned int current_location=0;

  

  bool b_0=false;
  bool b_1=false;
  bool b_2=false;

  int   *tmp_int_10,   *tmp_int_11;
  tmp_int_10=calloc(0x10,sizeof(unsigned int));
  tmp_int_11=calloc(0x10,sizeof(unsigned int));

  /* taken from address 10022a68 in ghidra */
  DAT_10022a68 = calloc(0x80,sizeof(unsigned char));
  *(DAT_10022a68+0) = 0x80;
   


  
  
  printf(GREEN);
  printf("/**************************/\n");
  printf("/*      Start of Main     */\n");
  printf("/**************************/\n");
  printf(DEFAULT);


  /* Start with houskeeping */

  system("rm -rf dev");
  system("mkdir dev");
  system("touch dev/mtd-kernel");
  system("touch dev/mtd-initrd");
  system("touch dev/mtd-squashfs");
  system("touch dev/mtd-uboot");
  system("touch dev/mtd-storage");
  system("touch dev/mtd-fwmgmt");
  system("touch dev/mtd-certs");
  system("touch dev/mtd-config");

  
  //printf("argv[optind]: %s\n", argv[optind]);

#if 0  // should ash chatGPT to rewrite CONCAT functions
  tmp_int_11[0]=0x01020304;
  tmp_int_11[1]=0x05060708;
  tmp_int_11[2]=0x09101112;
  tmp_int_11[3]=0x13141516;

  FUN_CONCAT((unsigned int*)tmp_int_10,(unsigned int*)tmp_int_11,0x4);
  printf("Concatenated test data: ");
  for(k=0;k<0x10;k++) printf("%.2X ",(unsigned char)*((unsigned char*)tmp_int_10+k));
  printf("\n");
#endif


#if 1
    printf(BLUE);
    printf("/*********************************/\n");
    printf("/*   start MD5 and SHA256 test   */\n");
    printf("/*********************************/\n");
    printf(DEFAULT);

  SHA256_CTX ctx;
  MD5_CTX md5ctx;
  
  u_int8_t *results;
  results = calloc(SHA256_DIGEST_LENGTH,sizeof(u_int8_t));

  char *buf;
  int n;

  buf=calloc(0x200,1);
  strcpy(buf,"Marcel is gek! Wie is er nog meer gek?");
  printf("sha256 of '%s'\n",buf);

  n = strlen(buf);
  
  SHA256_Init(&ctx);
  SHA256_Update(&ctx, (u_int8_t *)buf, n);
  SHA256_Final(results, &ctx);

  /* Print the digest as one long hex value */
  for (n = 0; n < SHA256_DIGEST_LENGTH; n++)
    printf("%02x", results[n]);
  putchar('\n');


  printf("https:\/\/emn178.github.io\/online-tools\/sha256.html says: \n");
  printf("8879886cd88241725cfb3af4b25fd2110c553c9e58d193b8b622a9479c761ff8\n");

  results = calloc(SHA256_DIGEST_LENGTH,sizeof(u_int8_t));
  strcpy(buf,"Marcel is gek! Wie is er nog meer gek?");
  printf("MD5 of '%s'\n",buf);
  n = strlen(buf);

  MD5_Init(&md5ctx);

  MD5_Update(&md5ctx, buf, n);
  MD5_Final(results, &md5ctx);

  for(n=0; n<MD5_DIGEST_LENGTH; n++)
    printf("%02x", results[n]);
  putchar('\n');

  printf("https://emn178.github.io/online-tools/md5.html says: \n");
  printf("e231be8c834629454d571a27dee17253\n");


  results = calloc(SHA256_DIGEST_LENGTH,sizeof(u_int8_t));
  strcpy(buf,"Marcel is gek! Wie is er nog meer gek?");
  printf("MD5 of '%s'\n",buf);
  n = strlen(buf);


  
  unsigned int MD5_variables[0x24];
  MD5_initialize_variables(MD5_variables);
  //MD5_printf(MD5_variables);
  
  MD5_encryption(MD5_variables,(unsigned int*)buf,n>>2);
  MD5_printf(MD5_variables);
  
  FUN_10006944((unsigned int*)results,MD5_variables);
  //MD5_printf(MD5_variables);

  
  printf("local MD5 of '%s'\n",buf);
  for(n=0; n<MD5_DIGEST_LENGTH; n++)
    printf("%02x", results[n]);
  putchar('\n');
  for(n=0; n<MD5_DIGEST_LENGTH; n++)
    printf("%02x", *(unsigned char*)((unsigned char*)MD5_variables+n) );
  putchar('\n');



  results = calloc(SHA256_DIGEST_LENGTH,sizeof(u_int8_t));
  strcpy(buf,"Marcel is gek! Wie is er nog meer gek?");
  printf("MD5 of '%s'\n",buf);
  n = strlen(buf);


  md5_context my_ctx;
  md5_init(&my_ctx);
  md5_digest(&my_ctx, buf, n);
  
  uint8_t md5_actual[16] = {0};
  md5_output(&my_ctx, results);

  printf("new local MD5 of '%s'\n",buf);
  for(n=0; n<MD5_DIGEST_LENGTH; n++)
    printf("%02x", results[n]);
  putchar('\n');
  

  printf(BLUE);
  printf("/*********************************/\n");
  printf("/*   end  MD5 and SHA256 test    */\n");
  printf("/*********************************/\n");
  printf(DEFAULT);


  exit(-1);
#endif


  

  
  printf("Endianness: ");
  if(is_bigendian()) printf("big.\n"); else printf("little.\n");
  

  tmp_int_2=1;

  if(argc <= 1){
    printf("No firmware file. Usage: %s <filename>\n",argv[0]);
    return -1;
  }
  strcpy(file_name,argv[optind]);

  fd=open(file_name,O_RDONLY); /*file_name = local_c48 */

  file_size=lseek(fd,0,SEEK_END);
  printf("file size: 0x%X\n",file_size);
  offset=lseek(fd,0,SEEK_SET);
  //printf("current file offset: 0x%lX\n",offset);

 
  printf(YELLOW);
  printf("/*******************/\n");
  printf("/*  fd opened!!!   */\n");
  printf("/*******************/\n");
  printf(DEFAULT);

  
  ret=read(fd,read_buffer,HEADER_SIZE); /* read_buffer = local_d28 */

#if INTERNAL
  /* check value at address (read_buffer+0) */
  if ((ret < HEADER_SIZE) || (0x01 < (*(read_buffer+0) -1)) ) { 
    printf("Not valid OA firmware image");
    close(fd);
    return -1;
  }

  i = 0;
  j = 0;
  do {
    if ( *(read_buffer -1 + i) == 0 ) break;
    j = j + 1;
    i = i + 0x15;
  } while (j < 4);

  
  
#endif //INTERNAL 
  
  

#if !INTERNAL

  partition_nr=*(read_buffer -1);       /* moet 0 zijn */
  
  if ((ret < HEADER_SIZE) || (0x1f < *read_buffer) ) { 
    printf("Not valid OA firmware image");
    close(fd);
    return -1;
  }

  
  partition_nr=*(read_buffer -1); /* moet 0 zijn */

  if (1 < partition_nr) {
    close(ret);
    printf("Firmware image requires a newer version of the OA firmware to be running on the OA to successfully update.\n");
  }

  printf("read_buffer data: ");
  for(k=0;k<0x10;k++) printf("%.2X ",*(read_buffer+k));
  printf("\n");

  /*
    cVar26 = (char *)0xc
    uVar20 = 1;  //see above
  */

  //pcVar21 should be a char*
  ret = (int)partition_nr >> 0x1f;
  *pcVar26 = (char) 0xc;
  *pcVar21 = (char)(uVar20 & (int)(ret - (ret ^ partition_nr)) >> 0x1f);
  //printf("pcVar21: %i\n",*pcVar21);


  memset(tmp_char_4,0,0x0C);  /* local_b48  ofwel (local_b40 +8) */
  i = 0;
  j = 0;
  int o=1;
  int p=6;
  do {
    read_buffer_address_2 = read_buffer;
    if ( *(read_buffer + i + o) == 0 ) {
      *(int*)tmp_char_0 = *(int*)(read_buffer + p + i + 0);
      //printf("offset: %i, readbuffser value %.4X, ", i + p + 0, *(int*)(read_buffer + p + i + 0) );
      //printf("little endian readbuffser value %X\n", htobe32(*(int*)(read_buffer + p + i + 0)) );
      *(int*)tmp_char_1 = *(int*)(read_buffer + p + i + 4);
      //printf("offset: %i, readbuffser value %.4X, ", i + p + 4, *(int*)(read_buffer + p + i + 4) );
      //printf("little endian readbuffser value %X\n", htobe32(*(int*)(read_buffer + p + i + 4)) );

      *(int*)tmp_char_2 = *(int*)(read_buffer + p + i + 8);
      //printf("offset: %i, readbuffser value %.4X, ", i + p + 8, *(int*)(read_buffer + p + i + 8) );
      //printf("little endian readbuffser value %X\n", htobe32(*(int*)(read_buffer + p + i + 8)) );

      if (is_bigendian()) {
	*(int*)(tmp_char_4 + 8) = *(int*)tmp_char_0; // local_b48
	*(int*)(tmp_char_4 + 4) = *(int*)tmp_char_1; // local_b44
	*(int*)(tmp_char_4 + 0) = *(int*)tmp_char_2; // local_b40
      } else {
	*(int*)(tmp_char_4 + 8) = htobe32(*(int*)tmp_char_0); // local_b48
	*(int*)(tmp_char_4 + 4) = htobe32(*(int*)tmp_char_1); // local_b44
	*(int*)(tmp_char_4 + 0) = htobe32(*(int*)tmp_char_2); // local_b40
      }
      break;
    }
    j = j + 1;
    i = i + 0x15;
  } while (j < 4);

#endif // !INTERNAL



#if !INTERNAL
  
  offset=0;        //__offset
  i = 0x10020000;  //uVar16
  DAT_10022c20 = 0;
  DAT_10022c24 = 0;
  j=0;
  read_buffer_address_1 = read_buffer_address_2;  

  unsigned int xd28 = 0xd28;
  unsigned int xce9 = 0xce9;
    
  auStack_ce9 = read_buffer + (xd28-xce9);
  
  unsigned int fw_version = *(unsigned int*)((unsigned char*)tmp_char_4+8);
  printf("fw_version: 0x%X\n",fw_version);
  

  printf("j: %i, *tmp_char_4 data: ",j);
  for(k=0;k<0xC;k++) printf("%.2X ",(unsigned char)*(tmp_char_4+k));
  printf("\n");

  printf("read_buffer_address_1 data: ");
  for(k=0;k<0x10;k++) printf("%.2X ",*(read_buffer_address_1+k));
  printf("\n");

#if 0
  printf("address of read_buffer: %LX\n",(long long int)&read_buffer);
  printf("address of auStack_ce9: %LX\n",(long long int)&auStack_ce9);
  printf("value of auStack_ce9: %LX\n",*(long long int *)auStack_ce9);

  printf("au_stack_ce9 data: ");
  for(k=0;k<0x10;k++) printf("%.2X ",*(unsigned char*)(auStack_ce9+k));
  printf("\n");
#endif
  
  // *read_buffer_address_1;                         /* pbVar23 */
  // *read_buffer_address_2;                         /* pbVar15 */

  do {
    step = *(int*)(read_buffer_address_1 + 2);
    if (!is_bigendian()) 
      step= htobe32(step);
    
    /* check returns 0 or 1 */
    check = check_something((uint)read_buffer_address_1[1],get_em_type());

    offset = offset + step;
    printf("Step: 0x%X, check: 0x%X, offset: 0x%lX\n", step, check,offset);    
    if (check != 0) {
      j= j + step;
    }
    read_buffer_address_1 = read_buffer_address_1 + 0x15;
  } while ((int*)read_buffer_address_1 <= (int*)auStack_ce9);


  DAT_10022c20 = j;

  
  printf("First step should be 0x173038 - 0xD5 = 0x172F63\n");
  printf("Second step should be 0x4E5CD9 - 0x173038 - 0x40 = 0x372C61\n");
  printf("Both values can be foud in hpoa440.bin at the approx addresses.\n");
  
  //*b40 ofwell tmp_char_4 zou de lengte van het te lezen buffer moeten bevatten
  printf("j (step+1?): %X, ",j);
  printf("*tmp_char_4: %X\n", *(int*)tmp_char_4);

  buffer = (unsigned char *)calloc(*(int*)tmp_char_4,sizeof(char));
  if (buffer == (unsigned char *)0x0) {
    printf("Out of memory while decoding flash image.\n");
  }

  ret_offset= lseek(fd,offset,SEEK_CUR);
  if (ret_offset < 0) {
    printf("Invalid flash image.\n");
  }

  //*(int*)tmp_char_4=offset;


  

  ret = read(fd,buffer,*(int*)tmp_char_4);
  *pcVar26=ret;
  printf("read %lX chars at offset: 0x%X\n",ret,(int)offset);
  ret_offset=lseek(fd, 0, SEEK_CUR);


  printf(BLUE);
  printf("buffer data contains address of start of kernel image, so where didt initrd get written\n");
  printf("buffer data at offset %lX: ", offset);
  for(k=0;k<0x23;k++) printf("%.2X ",*(unsigned char*)(buffer+k));
  printf("\n");
  printf(DEFAULT);
  
  if( file_size > ret_offset){ 
    printf("file size: 0x%X > file position: 0x%lX!!!\n",file_size,ret_offset);
  }else{
    printf("file size: 0x%X < file position: 0x%lX!!!\n",file_size,ret_offset);
    close(fd);
    printf(YELLOW);
    printf("/*******************/\n");
    printf("/*  fd closed!!!   */\n");
    printf("/*******************/\n");
    printf(DEFAULT);
    exit(-1);
  }
  
  if (ret < *(int*)tmp_char_4) {
    printf("Invalid flash image.\n");
  }
  *pcVar26=0;
  ret_offset = lseek(fd,HEADER_SIZE,SEEK_SET);
  if(ret_offset != HEADER_SIZE ){
    pcVar26=file_name;
    printf("Invalid flash image.\n");
  }


  printf(BLUE);
  printf("Reset current location to 0x%lX\n", ret_offset);
  printf(DEFAULT);



  /* MOET ER ACHTER KOMEN WAAROM NIET 0 */

  char *local_af8  [0x10];                 // 0xFFFFF508  //  0x10 address * (int*) ?
  // char acStack_ab8 [0x30];              // 0xFFFFF548  //  0x30 chars
  // char local_a88   [0x730];             // 0xFFfff578  // 0x730 chars

  if (*(unsigned char *)buffer == 0) {
    printf("*buffer == 0\n");
    memcpy(local_af8, data_0x10010100, 0x38); //should fail

    printf("local_af8 data at offset %lX: ", offset);
    for(k=0;k<0x38;k++) printf("%.2X ",*(unsigned char*)(local_af8+k));
    printf("\n");
    
    
    memset(acStack_ab8, 0, 0x21); //clear acStack_ab8
    pcVar26 = (char *)0x21;
    //pcVar14 = acStack_ab8;
    *(int*)(tmp_char_4 + 8) = (uint) *(unsigned char *)buffer;
    j = MD5_processing(file_name,acStack_ab8,0x21);
    printf("MD5_processing returned: %i\n",j);
    if (j == 0) {
      printf("*buffer == 0\n");
      uVar20 = 0;
      do {
	//pcVar14=acStack_ab8;
	j = strcmp(((char*)read_buffer_address_2 + 0x230),acStack_ab8);

	if (j == 0) {
	  *(int*)(tmp_char_4 + 8) = *(uint *)(read_buffer_address_2 + 0x234);
	  break;
	}
	uVar20 = uVar20 + 1;
	read_buffer_address_2 = read_buffer_address_2 + 8;
      } while (uVar20 < 7);
    }
  }
  else {
    
    if (!is_bigendian()) {
      *((int*)buffer+2)=htobe32(*((int*)buffer+2));
      *((int*)buffer+6)=htobe32(*((int*)buffer+6));
    }

#if 0
    printf("*buffer != 0\n");
    pintf("*(int*)(buffer+2):            0x%X\n",*((int*)buffer+2));
#endif
    *((int*)buffer+2) = *((int*)buffer+2) *0x100 ;
#if 0
    printf("*(int*)(buffer+6):            0x%X\n",*((int*)buffer+6));
    printf("*(int*)(buffer+2)*0x100:      0x%X\n",*((int*)buffer+2));
    printf("buffer+2 +buffer+6:           0x%X\n",*((int*)buffer+2) + *((int*)buffer+6) );
#endif


    //if (!is_bigendian()) {
    //  *((unsigned int*)buffer+2) = be32toh( *((unsigned int*)buffer+2) );
    //  *((unsigned int*)buffer+6) = be32toh( *((unsigned int*)buffer+6) );
    //}

    *((unsigned int*) tmp_char_4+8)=(*((unsigned int*)buffer + 2) + *((unsigned int*)buffer + 6));
    
      /*
    if (is_bigendian()) {
      printf("buffer+2: 0x%X\n",*(int*)((int)buffer+6));
      printf("buffer+6: 0x%X\n",*(int*)((int)buffer+2));

      
      *(int*)(tmp_char_4 + 8) =*( (unsigned char*)buffer + 2) * 0x100 + *( (unsigned char*)buffer + 6);
    } else {
      *(int*)(tmp_char_4 + 8) = htobe32(*( (unsigned char*)buffer + 2) * 0x100 +
					*( (unsigned char*)buffer + 6) ) ;
    }
      */
  }

      
  printf("*(int*)((char*)tmp_char_4+8): 0x%X\n", *(int*)((char*)tmp_char_4+8));
  
  printf("tmp_char_4 data: ");
  for(k=0;k<0x0C;k++) printf("%.2X ",*(unsigned char*)(tmp_char_4+k));
  printf("\n");

  FUN_1000b460(file_name);  

  uint64_t uVar28;
  uVar28 = fw_with_fingerprint(); // if with fingerprint 1 else 0

  /* if hot have fingerprint, should skip sha signature check below */

  //printf("uVar28: 0x%8.8lX\n",uVar28);
  
  //printf("uVar28>>20: 0x%LX\n", uVar28 >> 0x20);
  //printf("uVar28<<20: 0x%LX\n", uVar28 << 0x20);

  i= (int)(uVar28 >> 0x20);
  //printf("i: 0x%8.8X\n",i);
  
  partition_nr = -i;

  //printf("partition_nr: %i\n",partition_nr);

  
  uVar20 = (uint)((char *)0x44f < (char*)(tmp_char_4 + 8));
  *read_buffer_address_2= (0x44f < *(tmp_char_4 + 8)) && (i == 0);
  
  if ( *read_buffer_address_2 != 0x0 ) {
    close(fd);

    printf(YELLOW);
    printf("/*******************/\n");
    printf("/*  fd closed!!!   */\n");
    printf("/*******************/\n");
    printf(DEFAULT);

    ret = *(tmp_char_4 + 8);
    printf("Firmware image is an unofficial and unsupported release.\nPlease verify the URL and try to flash again with a new image.\n");
  }



  printf("i: 0x%X\n",i);
  char *local_b48;
  local_b48=calloc(0x80,sizeof(char));
  int iVar16=0;
  iVar16=i;
  

  
  iVar16 = *(int *)((int)buffer + 6);
  printf("iVar16: 0x%X\n",iVar16);
  
  *local_b48 = (char *)(
		       *(int *)((int)buffer + 2) * 0x100 + iVar16
		       );
  printf("local_48: 0x%X\n",*local_b48);
  


  printf("Can we find the signature file??????????\n");
  
  
  // for VERSION_130 FUN_100040d8 does something with a sha gisganture
  // for VERSION_130 FUN_10002a68 does the sha or md5 initialization,
  // this time with 9 values in the variables list
  
  
  /* skip sha signature check */
  if (i == 1) {
    printf("File has wrong signature\n");
    //ret = FUN_1000ca0c: x509 signature check -1 is fail, 0 is ok
    exit(-1);
  }
  else {
    // verifying signature
    printf("Line 514: sha256_ctx stuff\n");
    //param_5 = pcVar21;
    ret = FUN_1000610c(fd,(__off_t *)&DAT_10022c28,&read_buffer,0,(int)pcVar21);
  }

  if (ret != 0) {
    close(fd);

    printf(YELLOW);
    printf("/*******************/\n");
    printf("/*  fd closed!!!   */\n");
    printf("/*******************/\n");
    printf(DEFAULT);

    printf("Firmware image is an unofficial and unsupported release.\nPlease verify the URL and try to flash again with a new image.\n");
    exit(-1);
  }
  /*  finished skipping sha signature check */


  printf("read_buffer_address_2: 0x%X\n", *read_buffer_address_2);
  


  i = 0;

  // *read_buffer_address_1;                         /* pbVar23 */
  // *read_buffer_address_2;                         /* pbVar15 */
  // *read_buffer_address_3;                         /* pbVar22 */

  read_buffer_address_3= (char*)((int)buffer + 0xe);
  read_buffer_address_1= read_buffer_address_3;

  

  if (*(char *)((int*)buffer + 1) != '\0') {
    do {
	if (get_em_type() < 2) {
      LAB_10003cf4:
	uVar20 = *(read_buffer_address_1 + 1);
	DAT_10022c20 = DAT_10022c20 + uVar20;
      }
      else {
	ret = *(read_buffer_address_1 + 1);
	uVar20 = (uint)(ret < 8);
	b_0 = (uint)((1 < (ret - 5)) && (ret < 8));
	if ((b_0 == 0) || (ret < 0xc)) goto LAB_10003cf4;
      }
      i= i + 1;
      //printf("i: 0x%X, (int)(uint)*(unsigned char*)((int)buffer+1): 0x%X\n",i, (int)(uint)*(unsigned char *)((int)buffer + 1) );
      read_buffer_address_1 = read_buffer_address_1 +0x15;
    } while (i< (int)(uint)*(unsigned char *)((int*)buffer + 1));
  }

  
  if (DAT_10022c18 != 0) {
    printf("\nFlashing from version: %x.%2.2x ",4,0x50);
    printf("to version: %d.%2.2x\n",
	   (uint)(*tmp_char_4 >> 0x08) & 0xff,
	   (uint)*tmp_char_4 & 0xff);
  }


  if (
      (
       (
	((get_em_type() == 1) && (*(uint*)(tmp_char_4+8) < 0x200))
	||
	((get_em_type() == 3) && (*(uint*)(tmp_char_4+8) < 0x230))
	)

       ||

       ((get_em_type() == 5) && (*(uint*)(tmp_char_4+8) < 0x230))
       )
      ||
      ((get_em_type() == 2) && (*(uint*)(tmp_char_4+8) < 0x22f))
      ) {

    close(fd);
    printf("*(unsigned int*)tmp_char_4: %X\n",*(unsigned int*)(tmp_char_4+8));
    tmp_int_0 = *(uint*)(tmp_char_4+8) >> 0 & 0xff;
    if(!is_bigendian()) htobe32(tmp_int_0); 
    tmp_int_1 = *(uint*)(tmp_char_4+8) >> 8 & 0xff;
    printf("Firmware version %d.%2.2x is not supported on this hardware.\n",tmp_int_1,tmp_int_0);
  }else{
    //printf("Next???\n");
    tmp_int_0 = *(uint*)(tmp_char_4+8) >> 0 & 0xff;
    //if(!is_bigendian()) htobe32(*(int*)tmp_int_0); 
    tmp_int_1 = *(uint*)(tmp_char_4+8) >> 8 & 0xff;
    printf("Supported Firmware version %d.%2.2x found.\n",tmp_int_1,tmp_int_0);
    
  }


/******************************************************************************************/
/*                                                                                        */
/*                            start the actual flashing                                   */
/*                                                                                        */
/******************************************************************************************/

// iets dergelijk als onderstyaande moet waarschijnlijk gebeuren
// retrun value of flashput should be 0 and thus the return value of syste should be 0
  /*
   * if(local_b4 < (char *)0x351) {
   *   local_5c[0] = system("/usr/sbin/flashput -factory-ers >/dev/null 2>&1")
   * }
   */

  local_5c[0]=0;



  // *read_buffer; // I quess this starts at local_{d28,d27,d26 d22[14]} 

  // *read_buffer_address_1;                         /* pbVar23 */
  // *read_buffer_address_2;                         /* pbVar15 */

  printf("read_buffer data: ");
  for(k=0;k<0x10;k++) printf("%.2X ",*(read_buffer+k));
  printf("\n");

  if(pcVar21!=(char*) 0x00){
    printf("Flashing... \n");
  }
  
  printf("local_5c[0]: 0x%X\n",local_5c[0]);
  //FUN_100029e8
  ret = *(uint*)(tmp_char_4 + 8) >> 8 & 0xFF;
  //generate event stuff

#endif // !INTERNAL


#if INTERNAL
  
  int iVar5 = 0;
  int iVar8 = 0;
  int iVar9 = 0;
  bool bVar1;
  
  while( true ) {
    current_location = lseek(fd,0,SEEK_CUR);

    iVar5 = iVar8;
    bVar1 = (3 < iVar9);
    iVar9 = iVar9 + 1;

    //printf("((&read_buffer+1))[0]: 0x%X\n",((&read_buffer+1))[0] );
    //printf("*(unsigned int*)(read_buffer+1): 0x%X\n",*(unsigned int*)(read_buffer + 1) );
    ///printf("(unsigned int)(read_buffer+1)[1]: 0x%X\n",(unsigned int)(read_buffer+1)[1] );

    printf("\n\niVar5: 0x%X\n",iVar5);
    printf("address of (read_buffer+i+iVar5+1): 0x%lX, ",(unsigned long long int*)&read_buffer+iVar5+1+i);
    for(i=0;i<0x10;i++){
      printf("0x%.2X ",*(unsigned char*)(read_buffer+iVar5+1+i));
    }
    printf("\n");

    if ((bVar1 || (local_5c[0] != 0) ) || (((&read_buffer+1))[iVar5] == '\0')) break;

    // local_247 + 0 +iVar5 == local_248 + 1 + 0 +iVar5 //should give partition_nr
    partition_nr = (unsigned int)(read_buffer+1)[iVar5];  
    partition_name = partition_selector(partition_nr);

    //was local_30[0] = FUN_10001edc(iVar2,uVar3,*(undefined4 *)(&local_247 + 1+ iVar5));

    ret_offset = *(__off_t*)(read_buffer+1 + iVar5 +1);
    if(!is_bigendian()) ret_offset = htobe32(ret_offset);
    jump_size=ret_offset; //need to find the right name for this variable

    local_5c[0] = open_mtd_for_output_internal(fd,   partition_name,jump_size);

    iVar8 = iVar5 + 0x15;

    printf("output_internal returned: %i\n",local_5c[0]);
    if (local_5c[0] == 0) {
      partition_nr = (unsigned int)(read_buffer+1)[iVar5]; // wasuVar3 = FUN_10002498((&local_247)[iVar5]);

      printf("partition_nr: %i\n",partition_nr);
      //param_2 is teh size of the patition that needs to be read
      //param_3 is the address of the memory that need to be compared
      
      //local_5c[0] = open_mtd_for_input_internal(partition_name,*(uint32_t*)(read_buffer + 1 + iVar5 + 1),(uint32_t*)(&read_buffer + 1 + iVar5 + 5));
      local_5c[0] = open_mtd_for_input_internal(partition_name,jump_size,(uint32_t*)(&read_buffer + 1 + iVar5 + 5));
      printf("input_internal returned: %i\n",local_5c[0]);

    }
  }

#endif // INTERNAL

#if !INTERNAL
  
  iVar18=0;
  
  while( true ) {
    current_location = lseek(fd,0,SEEK_CUR);

    iVar19 = -local_5c[0];

    //First iterartion uVar20 should return true
    uVar20= (uint)((iVar18 < 4) && (local_5c [0] == 0));  //true or false
    //printf("First time, iVar18: 0x%X, local_5c[0]: 0x%X\n",iVar18,local_5c[0]);
    if (uVar20 == 0) {
      printf("uVar20 == 0, break from first while loop\n");
      break;
    }
    i = iVar18 * 0x15;
    read_buffer_address_2 = read_buffer;
    partition_nr = (unsigned int)(read_buffer+1)[i];

    /* gaat iets fout met endianess */
    //if(!is_bigendian()) partition_nr = htobe32(partition_nr);

    if (partition_nr == 0) {
      printf("Firts while, Partition_nr == 0, break from first while loop\n");
      break;
    }

    j = check_something(partition_nr,get_em_type());
    
    iVar18 = iVar18 + 1;

    // below could be the size of the blok/partition that should be read
    ret_offset = *(__off_t *)(read_buffer+1 + i + 1); //could be first partition localtion

    
    if(!is_bigendian()) ret_offset = htobe32(ret_offset);

    jump_size=ret_offset;

    printf("Firts_while, current location: 0x%6.6X, ", current_location);
    printf("jump_size: 0x%X, ",jump_size);
    
    if (j== 0) {
      ret_offset = lseek(fd,ret_offset,SEEK_CUR);
      if (ret_offset < 0) {
	local_5c[0] = 1;
      }
    } else {
      partition_name = partition_selector(partition_nr);
      ret = uVar17;
      printf("partition_name: %s\n",partition_name);
	
      //printf("pcVar21: %i\n",pcVar21);
      //printf("uVar17: %i\n",uVar17);
      //printf("iVar19: %i\n",iVar19);
      //printf("*read_buffer_address_2: %i\n",*read_buffer_address_2);
      //printf("uVar20: %i\n",uVar20);

#if VERSION == VERSION_130
      local_5c[0] = open_mtd_for_output_130(fd,   partition_name,ret_offset, *(int*)pcVar21,uVar17,iVar19,*(unsigned int*)read_buffer_address_2,uVar20);
#endif
#if VERSION == VERSION_440
      local_5c[0] = open_mtd_for_output_440(fd,   partition_name,ret_offset, *(int*)pcVar21,uVar17,iVar19,*(unsigned int*)read_buffer_address_2,uVar20);
#endif

      //printf("second time, iVar18: 0x%X, local_5c[0]: 0x%X\n",iVar18,local_5c[0]);
      
      if (local_5c[0] == 0) {
	partition_name = partition_selector((read_buffer+1)[i]);

	printf("address of read_buffer_address: %llX\n",(unsigned long long int)(&read_buffer +1 + i + 5));

#if VERSION == VERSION_130
	local_5c[0] = open_mtd_for_input_130(partition_name,*(size_t *)(read_buffer+1 + i + 1),(void *)((int*)read_buffer +1 + i + 5));
#endif
#if VERSION == VERSION_440
	local_5c[0] = open_mtd_for_input_440(partition_name,*(size_t *)(read_buffer+1 + i + 1),(void *)((int*)read_buffer +1 + i + 5));
#endif


      }
    }
    printf("partition[%i]: %s\n", partition_nr, partition_name);
  } /* end while */

#if 0
  printf("\n\n");
  printf("lseek retrun value: 0x%X\n",lseek(fd,(__off_t)*tmp_char_4,SEEK_CUR));
#endif
  
  if (
      (
       (*tmp_char_4 != 0x0) &&
       (*(char *)((int*)buffer + (int)1) != '\0')
       ) &&
      (ret_offset = lseek(fd,(__off_t)*tmp_char_4,SEEK_CUR), (ret_offset < 0))
      ) {
    local_5c[0] = 1;
  }
  iVar18 = 0;



#if 0

  
  printf("lseek retrun value evaluation: 0x%X\n",(ret_offset<0) );

  
  printf("*tmp_char_4: 0x%X\n",*tmp_char_4);
  
  printf("buffer data: ");
  for(k=0;k<0x10;k++) printf("%.2X ",*((unsigned char*)buffer+k));
  printf("\n");

  int tmp2;
  tmp2 = *((int*)buffer + (int)1);
  printf("tmp2: 0x%X\n", tmp2);
  if(!is_bigendian())
    tmp2=htobe32(tmp2);
  printf("tmp2: 0x%X\n", tmp2);
  printf("(int)(uint)* (unsigned char *) ((int*)buffer + (int)1): 0x%X\n", (int)(uint)* (unsigned char *) ((int*)buffer + (int)1));
  printf("(int)(uint)* (unsigned char *) tmp2: 0x%X\n", (int)(uint) (unsigned char ) tmp2);


  printf("ret_offset: 0x%X\n",ret_offset);
  printf("local_5c[0]: 0x%X\n\n",local_5c[0]);
  
  printf("i: 0x%X\n",i);
  printf("(int)(uint)*(unsigned char*)((int*)buffer+1): 0x%X\n",(int)(uint)*(unsigned char*)((int*)buffer+(int)1) );
  printf("*((int*)buffer+1): 0x%X\n",*((int*)buffer+(int)1) );
  printf("*(buffer+1): 0x%X\n",*((int*)buffer+(int)1) );

#endif


  /* second while seems to find its start location from what it read at the end of the file */


  printf("\nCurrent location: 0x%lX\n",lseek(fd,0,SEEK_CUR));
  
  while( true ) {

    //b_1 = iVar18 < (int)(uint)* (unsigned char *) ((int*)buffer + (int)1);
    b_1 = iVar18 < *((int*)buffer + (int)1);
    //printf("b_1: 0x%X\n",b_1);
    
    uVar20 = (uint)b_1;
    iVar19 = -local_5c[0];
    
    partition_nr = (uint)(b_1 && (local_5c[0] == 0));
    if (partition_nr == 0) {
      printf("Second while, Partition_nr == 0, break from second while loop\n");
      break;
    }
    i = iVar18 * 0x15;
    uVar24 = (unsigned int)(read_buffer_address_3)[i]; 
    //printf("(unsigned int*)(read_buffer_address_3)[%i]: 0x%X\n",i,(unsigned int*)(read_buffer_address_3)[i] );

    //if(!is_bigendian()) uVar24 = htobe32(uVar24);
    
    if (uVar24 == 0){
      printf("Second  while, uVar24 == 0, break from second while loop\n");
      break;
    }
    j = check_something(uVar24,get_em_type());
    iVar18 = iVar18 + 1;


    /* should check ret_offset on file_size */
    ret_offset = *(__off_t *)(read_buffer_address_3 + i + 1);
    if(!is_bigendian()) ret_offset = htobe32(ret_offset);

    if (j == 0) {
      ret_offset = lseek(fd,ret_offset,SEEK_CUR);
      if (ret_offset < 0) {
	local_5c[0] = 1;
      }
    } else {
      partition_name = partition_selector(uVar24);

      ret = uVar17;
#if VERSION == VERSION_130
      local_5c[0]  = open_mtd_for_output_130(fd,partition_name,ret_offset,*(int*)pcVar21,uVar17,iVar19,uVar20,partition_nr);
#endif
#if VERSION == VERSION_440
      local_5c[0]  = open_mtd_for_output_440(fd,partition_name,ret_offset,*(int*)pcVar21,uVar17,iVar19,uVar20,partition_nr);
#endif


      if (local_5c[0] == 0) {
	partition_name = partition_selector((read_buffer_address_3)[i]);

	printf(BLUE);
	printf("before open_mtd_for_input, FUN_10002dd0\n");
	printf(DEFAULT);


	printf("address of read_buffer_address_3: %llX\n",(unsigned long long int)(&read_buffer_address_3+i+5));
	printf("value of read_buffer_address_3: 0x%X\n",*(int*)((long long int)read_buffer_address_3+i+5));
#if VERSION == VERSION_130
	local_5c[0] = open_mtd_for_input_130(partition_name, *(size_t *)(read_buffer_address_3 + i + 1), (&read_buffer_address_3 + i + 5));
#endif
#if VERSION == VERSION_440
	local_5c[0] = open_mtd_for_input_440(partition_name, *(size_t *)(read_buffer_address_3 + i + 1), (&read_buffer_address_3 + i + 5));
#endif

	printf(BLUE);
	printf("After open_mtd_for_output, FUN_10002a9c0...\n");
	printf(DEFAULT);

	
	printf("read_buffer_address_3: ");
	for(k=0;k<0x10;k++) printf("%.2X ",*((unsigned char*)read_buffer_address_3+k));
	printf("\n");
	
      }
    }
    printf("Second while, jump size: 0x%lX to partition[%i]: %s\n", ret_offset,partition_nr, partition_name);

    //printf("Second while, uVar24: 0x%X\n", uVar24);
  }
#endif // !INTERNAL
  
  close(fd);

  printf(YELLOW);
  printf("/*******************/\n");
  printf("/*  fd closed!!!   */\n");
  printf("/*******************/\n");
  printf(DEFAULT);

  printf(GREEN);
  printf("/**************************/\n");
  printf("/*       End of Main      */\n");
  printf("/**************************/\n");
  printf(DEFAULT);
  


  
  return 0;
}

/******************************************************************************************/
/*                                                                                        */
/*                                  End of main                                           */
/*                                                                                        */
/******************************************************************************************/


/* FUN_10003210 */
/* p2 is retreived from gpio_states en shoud be 2 for the C7000, which fails in this code */
/* if p2 is 1 which indicates a c3000 the code seems top work */
/* The OABOARDTyPE in gpio_states was changed from 2 to 1 */
unsigned char check_something(int p1,int p2){

  printf(RED);
  printf("check something, FUN_10003210.\n");
  printf(DEFAULT);

  //p2 is OA_BOARDTYPE
  if (
      (p2 <= 1) ||
      (((
	 ((p1 > 1) - 2U &&
	  (p1 != 8) &&
	  (
	   (p1 != 9) &&
	   (p1 != 10)
	   )
	  )
	 &&
	 (
	  (p1 != 0xb) &&
	  (p1 != 5) )
	 )
	&&
	(p1 != 6)
	)
       )
      ) {
    if (p2 > 1) {
      return 0;
    }
    if (
	(
	 (
	  (p1 > 1) - 2U &&
	  (p1 != 8)) &&
	 (
	  (p1 != 9) &&
	  (p1 != 10)
	  )
	 )
	&&
	(
	 (
	  (p1 != 0xb) &&
	  (p1 != 1) &&
	  (p1 != 7)
	  )
	 )
	) {
      return 0;
    }
  }
  return 1;
}


void MD5_printf(unsigned int* ABCD){
  int i;
  for(i=0;i<6;i++){
    printf("ABCD[%i]: 0x%4.4X\n",i,ABCD[i]);
  }
}

/* FUN_1000673c */
void MD5_initialize_variables(unsigned int *ABCD){
 
  printf(RED);
  printf("MD5 initialize variables.\n");
  printf(DEFAULT);
  
  ABCD[0] = 0x67452301;
  ABCD[1] = 0xefcdab89;
  ABCD[2] = 0x98badcfe;
  ABCD[3] = 0x10325476;
  ABCD[4] = 0;
  ABCD[5] = 0;

  return;
}

/* FUN_10002f44 */
unsigned int MD5_processing(char *fw_file_name,void *param_2,size_t param_3){
  unsigned char* image_data;
  int fw_fd;
  uint len;
  int i;
  char *s_pointer;
  unsigned int MD5_variables[0x24];
  unsigned char unsigned_char_array_of_zeros [16];
  char char_array_of_zeros [60];
  unsigned char *unsigned_char_pointer;
  int c=0;
  
  printf(RED);
  printf("MD5 Processing.\n");
  printf(DEFAULT);
  
  image_data = malloc(0x2000);
  if (image_data == (void *)0x0) {
    printf("Failed to allocate memory for MD5 processing\n");
  }
  else {
    printf("opening firmware image: %s\n",fw_file_name);
    fw_fd = open(fw_file_name,0);
    if (fw_fd != -1) {
      memset(unsigned_char_array_of_zeros,0,0x10);
      memset(char_array_of_zeros,0,0x21);
      memset(image_data,0,0x2000);
      MD5_initialize_variables(MD5_variables);
      while( true ) {
        len = read(fw_fd,image_data,0x2000);
	printf("loop should run 1830.7 times, loop counter: %i\n",c++);
        if ((int)len < 1) break;
	printf("Read 0x%X bytes from file\n",len);
        MD5_encryption(MD5_variables,(unsigned int*)image_data,len>>2);
      }
      printf("encryption done?\n");
      FUN_10006944((unsigned int*)unsigned_char_array_of_zeros,MD5_variables);

      
      i = 0;
      s_pointer = char_array_of_zeros;
      do {
        unsigned_char_pointer = unsigned_char_array_of_zeros + i;
        i = i + 1;
        sprintf(s_pointer,"%02x",(uint)*unsigned_char_pointer);
        s_pointer = s_pointer + 2;
      } while (i < 0x10);
      free(image_data);
      close(fw_fd);
      if (param_2 != (void *)0x0) {
        if (0x21 < param_3) {
          param_3 = 0x21;
        }
        memcpy(param_2,char_array_of_zeros,param_3);
      }
      return 0;
    }
    free(image_data);
  }
  return 0xffffffff;
}


  
void FUN_10006944(unsigned int *param_1,unsigned int *ABCD){

  unsigned int *unsigned_int_array;
  unsigned_int_array=calloc(0x100,sizeof(unsigned int));
  uint local_28;
  uint local_24;
  uint local_20;

  printf(RED);
  printf("FUN_10006944.\n");
  printf(DEFAULT);
  int i;

  //  printf("address of param_1: 0x%llX\n",(unsigned long long int*)param_1);
  //for(i=0;i<0x10;i++){
  //  printf("ABCD[%i]: 0x%X, ",i,*(ABCD+i));
  //  printf("param_1[%i]: 0x%X\n",i,*(unsigned int*)((unsigned long long int*)&param_1+i));
  //}
  part_of_MD5_calculations((int*)unsigned_int_array,(int*)(ABCD + 4),8);
  
  local_28 = ((uint)ABCD[4] >> 3) & 0x3f;
  if (local_28 < 0x38) {
    local_20 = 0x38 - local_28;
  }
  else {
    local_20 = 0x78 - local_28;
  }

  local_24 = local_20;

  MD5_encryption(ABCD,(unsigned int*)DAT_10022a68,local_20);
  MD5_encryption(ABCD,(unsigned int*)unsigned_int_array,8);
  part_of_MD5_calculations((int*)param_1,(int*)ABCD,0x10);
  kind_of_memset(ABCD,0,0x58);
  return;
}



void part_of_MD5_calculations(int *param_1,int *param_2,uint param_3){
  int local_1c;
  uint local_18;

  printf(RED);
  printf("Part of MD5 calculations, FUN_10007FF0.\n");
  printf(DEFAULT);

  
  local_1c = 0;
  for (local_18 = 0; local_18 < param_3; local_18 = local_18 + 4) {
    //printf("i:%i, *param_2: %X\n",local_18,*param_2);

    *(unsigned char *)(param_1 + local_18) = *(unsigned char *)(local_1c * 4 + param_2 + 3);
    *(char *)(param_1 + local_18 + 1) = (char)((uint)*(unsigned int *)(local_1c * 4 + param_2) >> 8);
    *(char *)(param_1 + local_18 + 2) = (char)((uint)*(unsigned int *)(local_1c * 4 + param_2) >> 0x10);
    *(char *)(param_1 + local_18 + 3) = (char)((uint)*(unsigned int *)(local_1c * 4 + param_2) >> 0x18);
    local_1c = local_1c + 1;
    //printf("i:%i, *param_1: %X\n",local_18,*(unsigned int*)(param_1 + local_18));

  }
  return;
}


/* FUN_10007ff0 */
/* some kind of strange memcopy */
void old_part_of_MD5_calculations(unsigned int *param_1,unsigned int *param_2,uint len){
  unsigned int i;

  printf(RED);
  printf("Part of MD5 calculations, FUN_10007FF0.\n");
  printf(DEFAULT);

  printf("param_2 should be B: %X\n",*param_2);

  i=0;
  for (i = 0; i < len; i=i+4) {
    printf("i:%i, *param_2: %X\n",i,*param_2);
    *((char*)param_1 + i + 0) = (char)*(param_2 + i +3) >> 0x00;
    *((char*)param_1 + i + 1) = (char)*(param_2 + i +0) >> 0x08;
    *((char*)param_1 + i + 2) = (char)*(param_2 + i +0) >> 0x10;
    *((char*)param_1 + i + 3) = (char)*(param_2 + i +0) >> 0x18;

  }
  return;
}





/* FUN_100067b4 */
void MD5_encryption(unsigned int *variables,unsigned int *image_data,unsigned int len){
  uint uVar1;
  uint local_1c;
  uint local_18;

  // len is derived from the number of bytres read from file
  // image data in processed in ints, so 
  // after getting len from read, len shoud be devided by 4 and parsed to MD5_encryption
  
  //printf(RED);
  //printf("MD5 encryption, FUN_100067b4.\n");
  //printf(DEFAULT);

  local_18 = ((uint)variables[4] >> 3) & 0x3f;
  uVar1 = variables[4] + len * 8;
  variables[4] = uVar1;

  if (uVar1 < (len << 3)) {
    variables[5] = variables[5] + 1;
  }
  variables[5] = variables[5] + (len >> 0x1d);
  local_1c = 0x40 - local_18;

  
  if (len < local_1c) {
    local_1c = 0;
  }
  else {
    kind_of_memcpy((variables + local_18 + 0x18),(unsigned int*)image_data,local_1c);

    MD5_follow_precomputed_table((unsigned int*)variables,(unsigned int*)(variables + 6));
    for (; (local_1c + 0x3f) < len; local_1c = local_1c + 0x40) {
      MD5_follow_precomputed_table((unsigned int*)variables,(unsigned int*)image_data + local_1c);
    }
    local_18 = 0;
  }
  kind_of_memcpy((variables + local_18 + 0x18),(unsigned int*)(image_data + local_1c),len - local_1c);

  return;
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


/* FUN_10008100 */
/* chatGPT vragen deze dunctie te controleren */
void wrong_FUN_CONCAT(unsigned int *p1,unsigned int *p2,uint len){
  unsigned char i=0;
  unsigned char j;
  
  //printf(RED);
  //printf("FUN_CONCAT.\n");
  //printf(DEFAULT);
  
  //for (i=0; i < 4; i=i+1) 
  //  printf("p2[%i]: %.8X\n",i , p2[i] );

  int tmp=0;
  
  for (j=0; j < len; j=j+1) {
    for (i=0; i < 4; i=i+1) {
      printf("i: %i\n",i);
      //if(is_bigendian()){

      *(unsigned char*)((unsigned char*)p1 + i + (j*4) ) = (p2[j] >>(8*i));
	//printf("test[%i]: %X\n", i + (j*4), *(unsigned char*)((unsigned char*)p1 + i + (j*4) ) );
	//} else {
	//*(unsigned char*)((unsigned char*)p1 + (3-i) +(j*4)) = (p2[j] >>(8*i));
	//}
    }
  }
  /*
  for (i=0; i < 16; i=i+1) 
    printf("p1[%i]: %.2X\n",(unsigned char*)((unsigned char*)p1+i) , *(unsigned char*)((unsigned char*)p1+i) );

  for (i=0; i < 4; i=i+1) 
    printf("p1[%i]: %.8X\n",(unsigned int*)((unsigned int*)p1+i), *(unsigned int*)((unsigned int*)p1+i) );
  */
  return;
}

/* FUN_10008264 */
void kind_of_memset(unsigned int *p1,unsigned char value,uint len){
  unsigned int i;
  //printf(RED);
  //printf("kind_of_memset, FUN_10008264.\n");
  //printf(DEFAULT);
  
  for (i=0; i < len; i=i+1) {
    *(unsigned char*)(p1 + i) = value;
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



/* FUN_1000c6f4 */
int kind_of_calloc(size_t len,void **param_2){
  int local_1c;
  
  printf(RED);
  printf("kind_of_calloc, FUN_1000c6f4.\n");
  printf(DEFAULT);
  
  *param_2 = malloc(len);
  if (*param_2 == (void *)0x0) {
    printf("failed to acquire memory.\n");
    local_1c = -1;
  }
  else {
    memset(*param_2,0,len);
    local_1c = 0;
  }
  return local_1c;
}



/* FUN_1000c7dc */
int  check_binary_fname(void **param_1,char *param_2){ // doesn't do realy much
  int local_20;

  printf(RED);
  printf("check_binary_fname, FUN_1000c7dc.\n");
  printf(DEFAULT);
  
  if (param_2 == 0) 
    local_20 = -1;
  else if (*param_1 == (void *)0x0)
    local_20 = 0;
  else {
    free(*param_1);
    *param_1 = (void *)0x0;
    local_20 = 0;
  }
  return local_20;
}


/* FUN_1000b460 */
void FUN_1000b460(char *param_1){ //only param_1 is copied to DAT_10022c2c
  int iVar1;

  printf(RED);
  printf("FUN_1000b460.\n");
  printf(DEFAULT);
  
  if (param_1 == (char *)0x0) {
    printf("Can\'t set input file to NULL\n");
  }
  else {
    if (DAT_10022c2c != (char *)0x0) {
      check_binary_fname((void*)&DAT_10022c2c,"set_checker_binary_fname");
    }
    iVar1 = kind_of_calloc(0xfff,(void*)&DAT_10022c2c);
    if (iVar1 != -1) {
      strcpy(DAT_10022c2c,param_1);
    }
  }
  return;
}

/* this function returns 1 if the firmware file has a fingerprint section, otherwise 0 */
/* FUN_1000cb68 */
uint64_t fw_with_fingerprint (void){
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
  
  printf("DAT_10022c2c: %s\n",DAT_10022c2c);
  file= fopen((char*)DAT_10022c2c,"rb");
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
    if(uVar1==1)printf("fingerprint Lenghth found\n"); else printf("No Fingerprint Length found\n");

    fclose(file);
  }
  return uVar1;
}



/* FUN_10006a20 */
void MD5_follow_precomputed_table(unsigned int *ABCD,unsigned int *param_2){
  //printf(RED);
  //printf("MD5_follow_precomputed_table, FUN_10006a20.\n");
  //printf(DEFAULT);

  uint A;
  uint B;
  uint C;
  uint D;

  uint AA;
  uint BB;
  uint CC;
  uint DD;

  uint uVar5=0;
  unsigned int *local_50;
  local_50=calloc(0x10,sizeof(unsigned int));
  int local_4c=0;
  int local_48=0;
  int local_44=0;
  int local_40=0;
  int local_3c=0;
  int local_38=0;
  int local_34=0;
  int local_30=0;
  int local_2c=0;
  int local_28=0;
  int local_24=0;
  int local_20=0;
  int local_1c=0;
  int local_18=0;
  int local_14=0;


  
  A = ABCD[0];
  B = ABCD[1];
  C = ABCD[2];
  D = ABCD[3];

  FUN_CONCAT(local_50,param_2,0x40);

  uVar5 = ((B & C) | (~B & D)) + *local_50 + A + 0xd76aa478;
  uVar5 = (uVar5 * 0x80 | uVar5 >> 0x19) + B;
  D = ((uVar5 & B) | (~uVar5 & C)) + local_4c + D + 0xe8c7b756;
  D = (D * 0x1000 | D >> 0x14) + uVar5;
  C = ((D & uVar5) | (~D & B)) + local_48 + C + 0x242070db;
  C = (C * 0x20000 | C >> 0xf) + D;
  B = ((C & D) | (~C & uVar5)) + local_44 + B + 0xc1bdceee;
  B = (B * 0x400000 | B >> 10) + C;
  uVar5 = ((B & C) | (~B & D)) + local_40 + uVar5 + 0xf57c0faf;
  uVar5 = (uVar5 * 0x80 | uVar5 >> 0x19) + B;
  D = ((uVar5 & B) | (~uVar5 & C)) + local_3c + D + 0x4787c62a;
  D = (D * 0x1000 | D >> 0x14) + uVar5;
  C = ((D & uVar5) | (~D & B)) + local_38 + C + 0xa8304613;
  C = (C * 0x20000 | C >> 0xf) + D;
  B = ((C & D) | (~C & uVar5)) + local_34 + B + 0xfd469501;
  B = (B * 0x400000 | B >> 10) + C;
  uVar5 = ((B & C) | (~B & D)) + local_30 + uVar5 + 0x698098d8;
  uVar5 = (uVar5 * 0x80 | uVar5 >> 0x19) + B;
  D = ((uVar5 & B) | (~uVar5 & C)) + local_2c + D + 0x8b44f7af;
  D = (D * 0x1000 | D >> 0x14) + uVar5;
  C = (((D & uVar5) | (~D & B)) + local_28 + C) - 0xa44f;
  C = (C * 0x20000 | C >> 0xf) + D;
  B = ((C & D) | (~C & uVar5)) + local_24 + B + 0x895cd7be;
  B = (B * 0x400000 | B >> 10) + C;
  uVar5 = ((B & C) | (~B & D)) + local_20 + uVar5 + 0x6b901122;
  uVar5 = (uVar5 * 0x80 | uVar5 >> 0x19) + B;
  D = ((uVar5 & B) | (~uVar5 & C)) + local_1c + D + 0xfd987193;
  D = (D * 0x1000 | D >> 0x14) + uVar5;
  C = ((D & uVar5) | (~D & B)) + local_18 + C + 0xa679438e;
  C = (C * 0x20000 | C >> 0xf) + D;
  B = ((C & D) | (~C & uVar5)) + local_14 + B + 0x49b40821;
  B = (B * 0x400000 | B >> 10) + C;
  uVar5 = ((B & D) | (~D & C)) + local_4c + uVar5 + 0xf61e2562;
  uVar5 = (uVar5 * 0x20 | uVar5 >> 0x1b) + B;
  D = ((uVar5 & C) | (~C & B)) + local_38 + D + 0xc040b340;
  D = (D * 0x200 | D >> 0x17) + uVar5;
  C = ((D & B) | (~B & uVar5)) + local_24 + C + 0x265e5a51;
  C = (C * 0x4000 | C >> 0x12) + D;
  B = ((C & uVar5) | (~uVar5 & D)) + *local_50 + B + 0xe9b6c7aa;
  B = (B * 0x100000 | B >> 0xc) + C;
  uVar5 = ((B & D) | (~D & C)) + local_3c + uVar5 + 0xd62f105d;
  uVar5 = (uVar5 * 0x20 | uVar5 >> 0x1b) + B;
  D = ((uVar5 & C) | (~C & B)) + local_28 + D + 0x2441453;
  D = (D * 0x200 | D >> 0x17) + uVar5;
  C = ((D & B) | (~B & uVar5)) + local_14 + C + 0xd8a1e681;
  C = (C * 0x4000 | C >> 0x12) + D;
  B = ((C & uVar5) | (~uVar5 & D)) + local_40 + B + 0xe7d3fbc8;
  B = (B * 0x100000 | B >> 0xc) + C;
  uVar5 = ((B & D) | (~D & C)) + local_2c + uVar5 + 0x21e1cde6;
  uVar5 = (uVar5 * 0x20 | uVar5 >> 0x1b) + B;
  D = ((uVar5 & C) | (~C & B)) + local_18 + D + 0xc33707d6;
  D = (D * 0x200 | D >> 0x17) + uVar5;
  C = ((D & B) | (~B & uVar5)) + local_44 + C + 0xf4d50d87;
  C = (C * 0x4000 | C >> 0x12) + D;
  B = ((C & uVar5) | (~uVar5 & D)) + local_30 + B + 0x455a14ed;
  B = (B * 0x100000 | B >> 0xc) + C;
  uVar5 = ((B & D) | (~D & C)) + local_1c + uVar5 + 0xa9e3e905;
  uVar5 = (uVar5 * 0x20 | uVar5 >> 0x1b) + B;
  D = ((uVar5 & C) | (~C & B)) + local_48 + D + 0xfcefa3f8;
  D = (D * 0x200 | D >> 0x17) + uVar5;
  C = ((D & B) | (~B & uVar5)) + local_34 + C + 0x676f02d9;
  C = (C * 0x4000 | C >> 0x12) + D;
  B = ((C & uVar5) | (~uVar5 & D)) + local_20 + B + 0x8d2a4c8a;
  B = (B * 0x100000 | B >> 0xc) + C;
  uVar5 = ((B ^ C ^ D) + local_3c + uVar5) - 0x5c6be;
  uVar5 = (uVar5 * 0x10 | uVar5 >> 0x1c) + B;
  D = (uVar5 ^ B ^ C) + local_30 + D + 0x8771f681;
  D = (D * 0x800 | D >> 0x15) + uVar5;
  C = (D ^ uVar5 ^ B) + local_24 + C + 0x6d9d6122;
  C = (C * 0x10000 | C >> 0x10) + D;
  B = (C ^ D ^ uVar5) + local_18 + B + 0xfde5380c;
  B = (B * 0x800000 | B >> 9) + C;
  uVar5 = (B ^ C ^ D) + local_4c + uVar5 + 0xa4beea44;
  uVar5 = (uVar5 * 0x10 | uVar5 >> 0x1c) + B;
  D = (uVar5 ^ B ^ C) + local_40 + D + 0x4bdecfa9;
  D = (D * 0x800 | D >> 0x15) + uVar5;
  C = (D ^ uVar5 ^ B) + local_34 + C + 0xf6bb4b60;
  C = (C * 0x10000 | C >> 0x10) + D;
  B = (C ^ D ^ uVar5) + local_28 + B + 0xbebfbc70;
  B = (B * 0x800000 | B >> 9) + C;
  uVar5 = (B ^ C ^ D) + local_1c + uVar5 + 0x289b7ec6;
  uVar5 = (uVar5 * 0x10 | uVar5 >> 0x1c) + B;
  D = (uVar5 ^ B ^ C) + *local_50 + D + 0xeaa127fa;
  D = (D * 0x800 | D >> 0x15) + uVar5;
  C = (D ^ uVar5 ^ B) + local_44 + C + 0xd4ef3085;
  C = (C * 0x10000 | C >> 0x10) + D;
  B = (C ^ D ^ uVar5) + local_38 + B + 0x4881d05;
  B = (B * 0x800000 | B >> 9) + C;
  uVar5 = (B ^ C ^ D) + local_2c + uVar5 + 0xd9d4d039;
  uVar5 = (uVar5 * 0x10 | uVar5 >> 0x1c) + B;
  D = (uVar5 ^ B ^ C) + local_20 + D + 0xe6db99e5;
  D = (D * 0x800 | D >> 0x15) + uVar5;
  C = (D ^ uVar5 ^ B) + local_14 + C + 0x1fa27cf8;
  C = (C * 0x10000 | C >> 0x10) + D;
  B = (C ^ D ^ uVar5) + local_48 + B + 0xc4ac5665;
  B = (B * 0x800000 | B >> 9) + C;
  uVar5 = ((~D | B) ^ C) + *local_50 + uVar5 + 0xf4292244;
  uVar5 = (uVar5 * 0x40 | uVar5 >> 0x1a) + B;
  D = ((~C | uVar5) ^ B) + local_34 + D + 0x432aff97;
  D = (D * 0x400 | D >> 0x16) + uVar5;
  C = ((~B | D) ^ uVar5) + local_18 + C + 0xab9423a7;
  C = (C * 0x8000 | C >> 0x11) + D;
  B = ((~uVar5 | C) ^ D) + local_3c + B + 0xfc93a039;
  B = (B * 0x200000 | B >> 0xb) + C;
  uVar5 = ((~D | B) ^ C) + local_20 + uVar5 + 0x655b59c3;
  uVar5 = (uVar5 * 0x40 | uVar5 >> 0x1a) + B;
  D = ((~C | uVar5) ^ B) + local_44 + D + 0x8f0ccc92;
  D = (D * 0x400 | D >> 0x16) + uVar5;
  C = (((~B | D) ^ uVar5) + local_28 + C) - 0x100b83;
  C = (C * 0x8000 | C >> 0x11) + D;
  B = ((~uVar5 | C) ^ D) + local_4c + B + 0x85845dd1;
  B = (B * 0x200000 | B >> 0xb) + C;
  uVar5 = ((~D | B) ^ C) + local_30 + uVar5 + 0x6fa87e4f;
  uVar5 = (uVar5 * 0x40 | uVar5 >> 0x1a) + B;
  D = ((~C | uVar5) ^ B) + local_14 + D + 0xfe2ce6e0;
  D = (D * 0x400 | D >> 0x16) + uVar5;
  C = ((~B | D) ^ uVar5) + local_38 + C + 0xa3014314;
  C = (C * 0x8000 | C >> 0x11) + D;
  B = ((~uVar5 | C) ^ D) + local_1c + B + 0x4e0811a1;
  B = (B * 0x200000 | B >> 0xb) + C;
  uVar5 = ((~D | B) ^ C) + local_40 + uVar5 + 0xf7537e82;
  uVar5 = (uVar5 * 0x40 | uVar5 >> 0x1a) + B;
  D = ((~C | uVar5) ^ B) + local_24 + D + 0xbd3af235;
  D = (D * 0x400 | D >> 0x16) + uVar5;
  C = ((~B | D) ^ uVar5) + local_48 + C + 0x2ad7d2bb;
  C = (C * 0x8000 | C >> 0x11) + D;
  B = ((~uVar5 | C) ^ D) + local_2c + B + 0xeb86d391;

  ABCD[0] = ABCD[0] + uVar5;
  ABCD[1] = ABCD[1] + (B * 0x200000 | B >> 0xb) + C;
  ABCD[2] = ABCD[2] + C;
  ABCD[3] = ABCD[3] + D;

  //printf("just before kind of memset\n");
  kind_of_memset((unsigned int*)local_50,0,0x40); // moet dit niet 0x10 ipv 0x40, zie ook bij calloc
  //printf("just after kind of memset\n");

  free(local_50); 
  return;
}



/* FUN_100033a8 */
char * partition_selector(unsigned char p){
  char *s;

  printf(RED);
  printf("partition_selector, FUN_100033a8.\n");
  printf(DEFAULT);
    
  
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
  unsigned char in_xer_so;
  bool bVar8;
  unsigned char in_cr1;
  unsigned char unaff_cr2;
  unsigned char unaff_cr3;
  unsigned char unaff_cr4;
  unsigned char in_cr5;
  unsigned char in_cr6;
  unsigned char in_cr7;
  uint64_t uVar9;
  uint local_b8;
  uint local_b4;
  int local_b0;
  uint local_a8;
  uint local_a4;
  uint local_98;
  uint local_94;
  int local_90;
  uint local_88;
  uint local_84;
  uint local_78;
  uint local_74;
  int local_70;
  uint local_68;
  uint local_64;
  uint local_58;
  int  local_54;
  uint local_50;
  int  local_4c;
  uint local_48;
  uint local_44;
  uint local_40;
  /*
  printf(RED);
  printf("FUN_1000ecf4.\n");
  printf(DEFAULT);
  */
  puVar2 = &local_b8;
  local_58 = param_1;
  local_54 = param_2; // not used, combined array[2] ????
  local_50 = param_3;
  local_4c = param_4; // not used, combined array[2] ????
  
  FUN_1000e730(&local_58,&local_b8);
  FUN_1000e730(&local_50,&local_98);
  local_48 = (uint)(unsigned char)
    ((
     (local_b8 == 0) << 3 |
     (1 < local_b8) << 2 |
     (local_b8 == 1) << 1 |
     (in_xer_so & 1)
      ) << 0x1c) |
    ((uint)(in_cr1 & 0xf) << 0x18) |
    ((uint)(unaff_cr2 & 0xf) << 0x14) |
    ((uint)(unaff_cr3 & 0xf) << 0x10) |
    ((uint)(unaff_cr4 & 0xf) << 0xc) |
    ((uint)(in_cr5 & 0xf)  << 8) |
    ((uint)(in_cr6 & 0xf) << 4) |
    (uint)(in_cr7 & 0xf);
  if (1 < local_b8) {
    local_44 = (uint)(unsigned char)
      (
       (local_98 == 0) << 3 |
       (1 < local_98)  << 2 |
       (local_98 == 1) << 1 |
       (in_xer_so & 1)
       )                      << 0x1c |
      (uint)(in_cr1    & 0xf) << 0x18 |
      (uint)(unaff_cr2 & 0xf) << 0x14 |
      (uint)(unaff_cr3 & 0xf) << 0x10 |
      (uint)(unaff_cr4 & 0xf) << 0x0c |
      (uint)(in_cr5    & 0xf) << 0x08 |
      (uint)(in_cr6    & 0xf) << 0x04 |
      (uint)(in_cr7    & 0xf) << 0x00;

    
    if (1 < local_98) {
      if (local_b8 == 4) {
        if (local_98 == 2) {
LAB_1000f0d8:
          puVar2 = (uint *)&DAT_10012738;
          goto LAB_1000efd0;
        }
        goto LAB_1000f0b0;
      }
      if (local_98 == 4) {
        if (local_b8 == 2) goto LAB_1000f0d8;
      }
      else {
        if (local_b8 == 2) goto LAB_1000f0b0;
        if (local_98 != 2) {
          iVar1 = 0;
          uVar4 = (uint)((unsigned long long int)local_88 * (unsigned long long int)local_a4 >> 0x20);
          uVar5 = local_88 * local_a4;
          uVar7 = uVar5 + local_84 * local_a8;
          uVar6 = uVar4 + (int)((unsigned long long int)local_84 * (unsigned long long int)local_a8 >> 0x20) + (uint)CARRY4(uVar5,local_84 * local_a8);
          uVar3 = (uint)((unsigned long long int)local_84 * (unsigned long long int)local_a4 >> 0x20);
          local_84 = local_84 * local_a4;
          if ((uVar6 < uVar4) || ((uVar4 == uVar6 && (uVar7 < uVar5)))) {
            iVar1 = 1;
          }
          uVar4 = 0;
          uVar7 = uVar3 + uVar7;
          if ((uVar7 < uVar3) || ((uVar3 == uVar7 && (false)))) {
            uVar4 = 1;
          }
          uVar3 = uVar6 + local_88 * local_a8;
          local_64 = uVar4 + uVar3;

	  local_68 = iVar1 + (int)((unsigned long long int)local_88 * (unsigned long long int)local_a8 >> 0x20) +
	    (uint)CARRY4(uVar6,local_88 * local_a8) +
	    (uint)CARRY4(uVar4,uVar3);

	  
          local_74 = (uint)(local_b4 != local_94);
          local_70 = local_b0 + local_90 + 4;
          if ((0x1fffffff < local_68) || ((local_68 == 0x1fffffff && (false)))) {
            do {
              uVar4 = local_64 & 1;
              local_64 = local_68 << 0x1f | local_64 >> 1;
              local_68 = local_68 >> 1;
              in_cr6 =
		(uVar4 != 0)    << 2 |
		(uVar4 == 0)    << 1 |
		(in_xer_so & 1) << 0;
              uVar3 = uVar7 << 0x1f;
              local_70 = local_70 + 1;
              in_cr1 =
		(local_68 < 0x1fffffff)  << 3 |
		(0x1fffffff < local_68)  << 2 |
		(local_68 == 0x1fffffff) << 1 |
		(in_xer_so & 1)          << 0;
              if (uVar4 != 0) {
                uVar7 = uVar7 >> 1 | 0x80000000;
                local_84 = uVar3 | local_84 >> 1;
              }
            } while ((0x1fffffff < local_68) || ((local_68 == 0x1fffffff && (false))));
          }
          if ((local_68 < 0x10000000) && ((local_68 != 0xfffffff || (true)))) {
            do {
              bVar8 = (int)uVar7 < 0;
              local_68 = local_64 >> 0x1f | local_68 << 1;
              local_64 = local_64 << 1;
              local_70 = local_70 + -1;
              uVar7 = local_84 >> 0x1f | uVar7 << 1;
              local_84 = local_84 << 1;
              if (bVar8) {
                local_64 = local_64 | 1;
              }
              local_40 = (uint)(unsigned char)
		(
		 (local_68 < 0xfffffff)  << 3 |
		 (0xfffffff < local_68)  << 2 |
		 (local_68 == 0xfffffff) << 1 |
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
		 (local_64 != 0xffffffff) << 3 |
		 (local_64 == 0xffffffff) << 1 |
		 (in_xer_so & 1)          << 0 
		 );
              in_cr6 =
		((int)local_68 < 0xfffffff) << 3 |
		(0xfffffff < (int)local_68) << 2 |
		(local_68 == 0xfffffff)     << 1 |
		(in_xer_so & 1)             << 0;
            } while ((0xfffffff >= local_68) && ((local_68 != 0xfffffff || (true))));
          }
          if ((true) && (((local_64 & 0xff) == 0x80 && (((local_64 & 0x100) != 0 || ((uVar7 | local_84) != 0)))))) {
            bVar8 = 0xffffff7f < local_64;
            local_64 = local_64 + 0x80;
            local_68 = local_68 + bVar8;
          }
          local_78 = 3;
          puVar2 = &local_78;
          goto LAB_1000efd0;
        }
      }
    }
    local_94 = (uint)(local_b4 != local_94);
    puVar2 = &local_98;
  }
  else {
LAB_1000f0b0:
    local_b4 = (uint)(local_b4 != local_94);
  }
LAB_1000efd0:
  uVar9 = FUN_1000fa10(puVar2);
  return uVar9;
}



/*
 * chagt says:
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
  unsigned int local_24;
  uint local_20[2];
  unsigned int local_1c;
  
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
  unsigned char in_xer_so; //powerpc overflow check?
  unsigned char    in_cr1;
  unsigned char unaff_cr2;
  unsigned char unaff_cr3;
  unsigned char unaff_cr4;
  unsigned char    in_cr5;
  
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



#if VERSION == VERSION_999

/* FUN_10002160 */
int open_mtd_for_input_internal(char *partition_name,int param_2,void *param_3){
  int i;
  size_t len;
  int iVar2;
  ssize_t sVar3;
  int *piVar4;
  char *__format;

  char *dev; /* undefined4 uStack_10058; */
  char *mtd; /* undefined4 uStack_10054; */
  char *dash;

  char *data;
  data=calloc(0x10000,sizeof(unsigned char));
  unsigned int *auStack_98;
  auStack_98=calloc(0x10,sizeof(char));
  unsigned int *auStack_88;
  auStack_88=calloc(0x200,sizeof(unsigned int)); //was unsigned char auStack_88 [116];
  
  printf(RED);
  printf("open_mtd_for_input_internal, FUN_10002160.\n");
  printf(DEFAULT);

  char *full_path;
  full_path=calloc(0x80,sizeof(char));

#if DEVEL
  dev = "dev";  
#else
  dev = "/dev";
#endif
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

  
  iVar2 = open((char *)full_path,0);
  if (iVar2 == -1) {
    __format = "error opening %s for intput\n";
    printf("%s",__format);
    close(iVar2);
    free(full_path);
  }
  else {
    printf("opening mtd partition: %s for input\n",full_path);
    MD5_initialize_variables(auStack_88);
    do {
      len = param_2;
      if (0x10000 < (int)param_2) {
        len = 0x10000;
      }
      sVar3 = read(iVar2,data,len);
      if (0 < sVar3) {
	MD5_encryption(auStack_88,(unsigned int*)data,sVar3>>2);
        param_2 = param_2 - sVar3;
      }
    } while ((int)(
	      ((-1 - sVar3) + ((uint)(sVar3 == 0))) &
	      ((-1 - param_2) + ((uint)(param_2 == 0)))
	      ) < 0);
    FUN_10006944(auStack_98,(unsigned int*)auStack_88);
    close(iVar2);
    free(full_path);
    if (sVar3 != -1) {
      printf(BLUE);
      printf("Comparing result of FUN_10006944 with param_3\n");
      printf(DEFAULT);
      
      printf("address of auStack_98: 0x%16.16X, values: ",*(long long unsigned int*)&auStack_98);
      for(i=0;i<0x10;i++){
	printf("%2.2X ",*(unsigned char*)((unsigned char*)auStack_98+i));
      }
      printf("\n");
      
      printf("address of Param_3:    0x%16.16X, values: ",*(long long unsigned int*)&param_3);
      for(i=0;i<0x10;i++){
	printf("%2.2X ",*(unsigned char*)((unsigned char*)param_3+i));
      }
      printf("\n");

    iVar2 = memcmp(&param_3,auStack_98,0x10);
      
      
      return iVar2;
    }
    piVar4 = __errno_location();
    __format = "read failed errno = %d\n";
    printf("%i, %s",*piVar4,__format);
  }
  return -1;
}




/* FUN_10001edc */
unsigned int open_mtd_for_output_internal(int fd,char *partition_name,int param_3) {
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

  printf(RED);
  printf("open_mtd_for_output_internal, FUN_10001edc.\n");
  printf(DEFAULT);

  char *full_path;
  full_path=calloc(0x80,sizeof(char));

#if DEVEL
  dev = "dev";  
#else
  dev = "/dev";
#endif
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

    __fd = open((char *)full_path,1);
  if (__fd == -1) {
    printf("error opening %s for output\n",full_path);
  }
  else {
    iVar7 = 0;
    iVar6 = 0;
    if (0 < param_3) {
      do {
        len = param_3 - iVar6;
        if (0x10000 < (int)len) {
          len = 0x10000;
        }
        len = read(fd,data,len);
        if (len == 0) break;
        if (len == 0xffffffff) {
          __s = "em_flash: read";
LAB_10001f7c:
          printf("%s\n",__s);
          break;
        }
        iVar6 = iVar6 + len;
        sVar3 = write(__fd,data,len);
        if (sVar3 == -1) {
          __s = "em_flash: write";
          goto LAB_10001f7c;
        }
        iVar7 = iVar7 + sVar3;

	  
        uVar4 = DAT_10022c24 + sVar3;
        DAT_10022c24 = uVar4;
        if (uVar4 != 0) {
	  uVar8 = FUN_1000f6bc(uVar4); /* was: uVar8 = FUN_1000a8c4(); */
          if ((int)uVar4 < 0) {
            uVar8 = FUN_1000ebfc((int)((unsigned long long int)uVar8 >> 0x20),(int)uVar8,0x41f00000,0);
          }
	  iVar1 = DAT_10022c20;
          uVar9 = FUN_1000f6bc(DAT_10022c20);  /* was 1000fbbc */
          if (iVar1 < 0) {
            uVar9 = FUN_1000ebfc((int)((unsigned long long int)uVar9 >> 0x20),(int)uVar9,0x41f00000,0);
          }
          uVar8 = FUN_1000f0f0((int)((unsigned long long int)uVar8 >> 0x20),(int)uVar8,(int)((unsigned long long int)uVar9 >> 0x20),(int)uVar9);
          FUN_1000ecf4((int)((unsigned long long int)uVar8 >> 0x20),(int)uVar8,0x40590000,0);

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
      } while (iVar7 < param_3);
      //printf("\n");
    }
    close(__fd);

    if (param_3 <= iVar7 && param_3 <= iVar6) {
      return 0;
    }
    printf("error tr %d tw %d nbytes %d\n",iVar6,iVar7,param_3);
  }
  return 0xffffffff;
}

#endif // VERSION_999


#if VERSION == VERSION_440
/* param_7 is somehow not used */
/* FUN_1002a9c */
unsigned int open_mtd_for_output_440(int fd,char *partition_name,int param_3,int param_4,int param_5,unsigned int param_6,unsigned int param_7,unsigned int param_8) {
  FILE *pFVar1;
  size_t len;
  int __fd;
  ssize_t sVar3;
  unsigned int uVar4;
  unsigned char *puVar7;
  float tmp3,tmp4,tmp5;

  char *pcVar8;

  int param2;
  int param3;
  unsigned int uVar9;
  uint64_t uVar10;
  uint64_t uVar11;
  char *dev; /* undefined4 uStack_10058; */
  char *mtd; /* undefined4 uStack_10054; */
  char *dash;
  unsigned char  data[65536];
  unsigned int local_38[3];

  printf(RED);
  printf("open_mtd_for_output_440, FUN_10002a9c.\n");
  printf(DEFAULT);

  puVar7 = (unsigned char*)DAT_1000ff88;
  uVar9 = 0xfffffff6;

  char *full_path;
  full_path=calloc(0x80,sizeof(char));

#if DEVEL
  dev = "dev";  
#else
  dev = "/dev";
#endif
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

    
  __fd = open(full_path,1);
  if (__fd == -1) {
    printf("error opening %s for output\n",full_path);
  }
  else {
    printf("opening mtd partision: %s for output\n",full_path);
    param3 = 0;
    param2 = 0;
    if (0 < param_3) {
      do {
        len = param_3 - param2;
        if (0x10000 < (int)len) {
          len = 0x10000;
        }

        len = read(fd,data,len);
	//printf("read: 0x%lX bytes of data.\n", len);
	
        if (len == 0) break;
        if (len == 0xffffffff) {
          pcVar8 = "em_flash: read";
LAB_10002b54:
          perror(pcVar8);
          break;
        }
        param2 = param2 + len;
        sVar3 = write(__fd,data,len);
        if (sVar3 == -1) {
          pcVar8 = "em_flash: write";
          goto LAB_10002b54;
        }

	//printf("param_3: 0x%X\n",param_3);
	tmp4=param_3;
        param3 = param3 + sVar3;
        fsync(__fd);
        uVar4 = DAT_10022c24 + sVar3;
	
	tmp3=uVar4;

	DAT_10022c24 = uVar4;
        if (uVar4 != 0) {
          uVar10 = FUN_1000f6bc(uVar4);
          if ((int)uVar4 < 0) {
            uVar10 = FUN_1000ebfc((uint)((unsigned long long int)uVar10 >> 0x20),(int)uVar10,0x41f00000,0);
          }
          uVar4 = DAT_10022c20;
	  //tmp4=uVar4;
          uVar11 = FUN_1000f6bc(DAT_10022c20);
          if ((int)uVar4 < 0) {
            uVar11 = FUN_1000ebfc((uint)((unsigned long long int)uVar11 >> 0x20),(int)uVar11,0x41f00000,0);
          }
          uVar10 = FUN_1000f0f0((unsigned int)((unsigned long long int)uVar10 >> 0x20),(int)uVar10,(uint)((unsigned long long int)uVar11 >> 0x20),(int)uVar11);
          uVar10 = FUN_1000ecf4((unsigned int)((unsigned long long int)uVar10 >> 0x20),(int)uVar10,0x40590000,0);
          uVar4 = FUN_1000f7dc((unsigned int)((unsigned long long int)uVar10 >> 0x20),(int)uVar10);
        }
        param_8 = (unsigned int)((int)uVar9 < (int)uVar4);
        local_38[0] = uVar4;

	//printf("param_3: 0x%X\n",param_3);
	
        if (((int)uVar9 < (int)uVar4 && DAT_10022c18 == 0) && ((uVar4 & 1) == 0)) {
          //generate_event(0x1203,0,local_38,4);
          uVar9 = local_38[0];
        }
        pFVar1 = stdout;  // stdin has file descriptor 0, stdout has file descripter 1
        if (param_5 == 0) {
          if (param_4 != 0) {
            if (stdout->_lock == (_IO_lock_t *)0x0) {
              fputc(0x2e, stdout);
            }
            else {
              pcVar8 = stdout->_IO_write_base;
              if (pcVar8 < stdout->_IO_buf_base) {
                *pcVar8 = '.';
                pFVar1->_IO_write_base = pcVar8 + 1;
              }
              else {
                fputc_unlocked(0x2e,stdout);
              }
            }
            goto LAB_10002d34;
          }
        }
        else if ((local_38[0] & 1) == 0) {
	  //printf("tmp3: %f\n ",tmp3);
	  //printf("tmp4: %f\n ",tmp4);
	  tmp5=tmp3/tmp4;
	  //printf("\b\b\b\b%3d%%",local_38[0]);
	  printf("\b\b\b\b%3.0f%%",tmp5*100);
	  //usleep(100000);
LAB_10002d34:
          fflush(stdout);
        }
      } while (param3 < param_3);
      printf("\n");
      fflush(stdout);

    }
    close(__fd);
    if (param3 >= param_3 && param_3 <= param2) {
      return 0;
    }
    printf("error tr %d tw %d nbytes %d\n",param2,param3,param_3);
  }
  return 0xffffffff;
}


/* FUN_10002dd0 */
int open_mtd_for_input_440(char *partition_name,int  param_2,void *param_3) {

  int len;
  int fd;
  uint uVar3;
  int *piVar4;
  char *__format;
  char  *full_path;
  char *dev;
  char *mtd;
  char *dash;

  //unsigned char data[0x10000];
  unsigned char *data;
  data=calloc(0x10000,sizeof(unsigned char));
  
  //char  auStack_98[0x10];
  char *auStack_98;
  auStack_98=calloc(0x10,sizeof(char));
  
  //int aiStack_88 [0x80]; //was 29 (0x1D)
  int *aiStack_88;
  aiStack_88=calloc(0x200,sizeof(int));


  unsigned int tmp_local=0x7FFF;
  
  printf(RED);
  printf("open_mtd_for_input_440, FUN_10002dd0.\n");
  printf(DEFAULT);

  printf("line 2542: address of param_3: %LX\n",param_3);
  
  full_path=calloc(0x80,sizeof(char));

#if DEVEL
  dev = "dev";
#else
  dev = "/dev";
#endif
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


  
  fd = open((char *)full_path,0);
  
  //if(!is_bigendian())
  //  param_2=htobe32(param_2);

  //printf("File size: 0x%X\n",lseek(fd,0,SEEK_END));
  //printf("File position: 0x%X\n",lseek(fd,0,SEEK_SET));

  if (fd == -1) {
    printf("error opening %s for intput\n");
    close(fd);
    free(full_path);
  } else {
    printf("opening mtd partision: %s for input\n",full_path);
    MD5_initialize_variables(aiStack_88);

    do {
      len = param_2;
      if (0x10000 < (int)param_2) {	
        len = 0x10000;
      }
      uVar3 = read(fd,data,len);


      if (0 < (int)uVar3) {
	//printf("uVar3: 0x%X\n",uVar3);
	MD5_encryption((unsigned int*)aiStack_88,(unsigned int*)data,uVar3>>2);
	param_2 =(int) param_2 - (int)uVar3;
      
      }
    } while ((int)(
		   ((-1 - uVar3)   + ((uint)(uVar3   == 0))) &
		   ((-1 - param_2) + ((uint)(param_2 == 0)))
		   ) < 0);

    int i;
    printf("\n\nline 2611\n");
    for(i=0;i<0x10;i++) *((unsigned long long int*)auStack_98+i)=i;

    
    printf("address of auStack_98: 0x%lX\n",(unsigned long long int*)&auStack_98);
    for(i=0;i<0x10;i++){
      printf("auStack_98[%i]: 0x%X\n",i,*(unsigned int*)((unsigned long long int*)auStack_98+i));
    }
    FUN_10006944((unsigned long long int*)&auStack_98,(unsigned int*)aiStack_88); 

    
    close(fd);

    free(full_path);
    if (uVar3 != 0xffffffff) {
      fd = memcmp(&param_3,&auStack_98,0x10);
      return fd;
    }
  }
  printf("return with error\n");
  return -1;
}

#endif //VERSION_440

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




size_t cpqem_find_tag_ex(char *param_1,char *param_2,char *param_3,size_t param_4,uint param_5)

{
  size_t sVar1;
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
  } while (((pbVar3 != param_1 + sVar1) && (pbVar3[-1 - sVar1] != 10)) || (*pbVar3 != param_5));
  if (pbVar3[1] == 0x22) {
    pbVar3 = pbVar3 + 2;
  }
  else {
    pbVar3 = pbVar3 + (pbVar3[1] == 0x27) + 1;
  }
  pbVar4 = (char *)strpbrk((char *)pbVar3,"\'\"\n");
  if (pbVar4 == (char *)0x0) {
    pbVar4 = pbVar3;
  }
  sVar1 = (int)*pbVar4 - (int)*pbVar3;
  if ((int)param_4 <( (int)*pbVar4 - (int)*pbVar3 ) ){
    sVar1 = param_4;
  }
  strncpy(param_3,(char *)pbVar3,sVar1);
  param_3[sVar1] = '\0';
  return sVar1;
}



int find_tag_in_file(char *param_1, char *param_2, char *param_3, size_t param_4, unsigned int param_5){
  FILE *__stream;
  int iVar1;
  __ssize_t _Var2;
  int iVar3;
  char *local_28;
  size_t asStack_24 [2];

  iVar3 = 0;
  local_28 = (char *)0x0;
  __stream = fopen(param_1,"r");
  iVar1 = 0;
  if (__stream != (FILE *)0x0) {
    do {
      _Var2 = getline(&local_28,asStack_24,__stream);
      iVar1 = iVar3;
      if (_Var2 < 1) break;
      iVar3 = cpqem_find_tag_ex(local_28,param_2,param_3,param_4,param_5);
      iVar1 = iVar3;
    } while (iVar3 == 0);
    if (local_28 != (char *)0x0) {
      free(local_28);
    }
    fclose(__stream);
  }
  return iVar1;
}



int get_em_type(void){
  char local_28 [32];
  if (DAT_000cbb58 == -1) {
    local_28[0] = '\0';
    //find_tag_in_file("/etc/gpio_states","OABOARDTYPE",local_28,0x10,0);
    find_tag_in_file("gpio_states","OABOARDTYPE",&local_28[0],0x10,'=');
    DAT_000cbb58 = atoi(local_28);
  }
  return DAT_000cbb58;
}



#if VERSION == VERSION_130


/***************************************************/
/*         From em_flash version 1.30              */
/***************************************************/

/* FUN_10001d2c */
unsigned int open_mtd_for_output_130(int fd, char *partition_name,int param_3,int param_4,int param_5,unsigned int param_6,unsigned int param_7,unsigned int param_8) {
  FILE *pFVar1;
  int iVar2;
  int __fd;
  ssize_t sVar3;
  uint uVar4;
  size_t len;
  char *pcVar6;
  uint uVar7;
  int iVar8;
  int iVar9;
  uint64_t uVar10;
  uint64_t uVar11;
  unsigned char data[0x10000];
  uint local_38 [3];
  
  uVar7 = 0xfffffff6;


  printf(RED);
  printf("open_mtd_for_output_130, FUN_10001d2c.\n");
  printf(DEFAULT);

  //puVar7 = (unsigned char*)DAT_1000ff88;


  char *dev;
  char *mtd;
  char *dash;
  char *full_path;
  full_path=calloc(0x80,sizeof(char));

#if DEVEL
  dev = "dev";  
#else
  dev = "/dev";
#endif
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
  
  __fd = open((char *)&full_path,1);
  if (__fd == -1) {
    printf("error opening %s for output\n",&full_path);
  }
  else {
    iVar9 = 0;
    iVar8 = 0;
    if (0 < param_3) {
      do {
        len = param_3 - iVar8;
        if (0x10000 < (int)len) {
          len = 0x10000;
        }
        len = read(fd,data,len);
        if (len == 0) break;
        if (len == 0xffffffff) {
          pcVar6 = "em_flash: read";
	LAB_10001dc0:
          perror(pcVar6);
          break;
        }
        iVar8 = iVar8 + len;
        sVar3 = write(__fd,data,len);
        if (sVar3 == -1) {
          pcVar6 = "em_flash: write";
          goto LAB_10001dc0;
        }
        iVar9 = iVar9 + sVar3;

        uVar4 = DAT_10022c24 + sVar3;
        DAT_10022c24 = uVar4;
        if (uVar4 != 0) {
	  /***********************************************/
	  /*       problem/different in 130 code         */
	  /*       uVar10 = FUN_1000a1d4();              */
	  /***********************************************/
          uVar10 = FUN_1000f6bc(uVar4);

	  if ((int)uVar4 < 0) {
            uVar10 = FUN_1000ebfc((int)((unsigned long long)uVar10 >> 0x20),(int)uVar10,0x41f00000,0);
          }
	  
          iVar2 = DAT_10022c20;
          uVar11 = FUN_1000f6bc(DAT_10022c20);
          if (iVar2 < 0) {
            uVar11 = FUN_1000ebfc((int)((unsigned long long)uVar11 >> 0x20),(int)uVar11,0x41f00000,0);
          }
          uVar10 = FUN_1000f0f0((int)((unsigned long long)uVar10 >> 0x20),(int)uVar10,(int)((unsigned long long)uVar11 >> 0x20),(int)uVar11);
          uVar10 = FUN_1000ecf4((int)((unsigned long long)uVar10 >> 0x20),(int)uVar10,0x40590000,0);

	  /***********************************************/
	  /*       problem/different in 130 code         */
	  /*       uVar4 = FUN_1000a2f4();               */
	  /***********************************************/
	  uVar4 = FUN_1000f7dc((uint)((unsigned long long)uVar10 >> 0x20),(int)uVar10);
	  
        }
        local_38[0] = uVar4;
        if (((int)uVar7 < (int)uVar4 && DAT_10022c18 == 0) && ((uVar4 & 1) == 0)) {
          //generate_event(0x1203,0,local_38,4);
          uVar7 = local_38[0];
        }
        //pFVar1 = __stdout;
        if (param_5 == 0) {
          if (param_4 != 0) {
	    printf(".");
#if 0
	    if (__stdout->_lock == (_IO_lock_t *)0x0) {
              fputc(0x2e,__stdout);

            } else {
              pcVar6 = __stdout->_IO_write_base;
              if (pcVar6 < __stdout->_IO_buf_base) {
                *pcVar6 = '.';
                pFVar1->_IO_write_base = pcVar6 + 1;
              }
              else {
                __fputc_unlocked(0x2e);
              }
            }
#endif
            goto LAB_10001f94;
          }
        }
        else if ((local_38[0] & 1) == 0) {
          printf("\b\b\b\b%3d%%");
	LAB_10001f94:
          fflush(stdout);
        }
        fsync(__fd);
      } while (iVar9 < param_3);
      printf("\n\n");
    }
    close(__fd);
    if (param_3 <= iVar9 && param_3 <= iVar8) {
      return 0;
    }
    fprintf(stderr,"error tr %d tw %d nbytes %d\n",iVar8,iVar9,param_3);
  }
  return 0xffffffff;
}



/* FUN_10002020 */
int open_mtd_for_input_130(char *partition_name,int Param_2,void *param_3){

  int param_2=Param_2;
  int len;
  int fd;
  ssize_t sVar2;
  int *piVar3;
  char *__format;
  char  *full_path;
  full_path=calloc(0x80,sizeof(char));
  unsigned char data [0x10000];
  unsigned char auStack_98 [0x10];
  unsigned char auStack_88 [116];
  char *dev;
  char *mtd;
  char *dash;

  printf(RED);
  printf("open_mtd_for_input_130, FUN_10002020.\n");
  printf(DEFAULT);

#if DEVEL
  dev = "dev";
#else
  dev = "/dev";
#endif
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
  
  fd = open((char *)full_path,0);
  if (fd  == -1) {
    __format = "error opening %s for intput\n";
  }
  else {
    MD5_initialize_variables(auStack_88);
    do {
      len = param_2;
      if (0x10000 < (int)param_2) {
        len = 0x10000;
      }
      sVar2 = read(fd ,data,len);
      if (0 < sVar2) {
	MD5_encryption((unsigned int*)auStack_88,(unsigned int*)data,sVar2>>2);
        //FUN_100067b4(auStack_88,data,sVar2); should  sVar2 >>3 or not
        param_2 = param_2 - sVar2;
      }
    } while ((int)((-1 - sVar2) + (uint)(sVar2 == 0) & (-1 - param_2) + (uint)(param_2 == 0)) < 0);
    FUN_10006944(auStack_98,auStack_88);
    close(fd);
    if (sVar2 != -1) {
      fd = memcmp(param_3,auStack_98,0x10);
      return fd;
    }
    piVar3 = __errno_location();
    full_path = (char*)piVar3;
    __format = "read failed errno = %d\n";
  }
  fprintf(stderr,__format,full_path);
  return -1;
}

#endif // VERSION_130

uint FUN_1000610c(int param_1,__off_t *param_2,unsigned char *param_3,int param_4,int param_5){
  uint uVar1;
  __off_t _Var2;
  int iVar3;
  __off_t _Var4;
  unsigned char bVar5;
  unsigned char abStack_48 [48];

  printf(RED);
  printf("FUN_1000610c\n");
  printf(DEFAULT);

  
  if (param_5 != 0) {
    printf("Verifying signature...\n");
  }
  _Var2 = lseek(param_1,0,1);
  uVar1 = 0xffffffff;
  if (-1 < _Var2) {
    iVar3 = FUN_10005de8(param_1,param_3,abStack_48);
    uVar1 = 0xffffffff;
    if (-1 < iVar3) {
      if (param_2 != (__off_t *)0x0) {
        _Var4 = lseek(param_1,0,1);
        *param_2 = _Var4;
      }
      _Var2 = lseek(param_1,_Var2,0);
      uVar1 = 0xffffffff;
      if (-1 < _Var2) {
        bVar5 = FUN_10005f64(param_3 + 0x55,0x80,abStack_48,0x20,param_4,param_5);
        uVar1 = (uint)bVar5;
      }
    }
  }
  return uVar1;
}


uint32_t FUN_10005de8(int param_1,unsigned char *param_2,unsigned char *param_3){
  int n;
  bool bVar1;
  uint32_t uVar2;
  int iVar3;
  size_t sVar4;
  int *piVar5;
  unsigned char *pbVar6;
  uint uVar7;
  int iVar8;
  SHA256_CTX SStack_c8;
  uint8_t results[SHA256_DIGEST_LENGTH];
  unsigned char uStack_58[0x10]; // ustack_58[0], only need 0x0e bytes
  //  unsigned char  local_57;   // uStack_58[1]
  unsigned char uStack_48[20];   // uStack_48[0], only need 0x15 bytes
  //int local_47;                // uStack_48[1] 

  printf(RED);
  printf("FUN_10005de8\n");
  printf(DEFAULT);

  
  pbVar6 = (unsigned  char *)0x0;
  uVar2 = 0xffffffff;
  if (((-1 < param_1) && (param_2 != (unsigned char *)0x0)) && (*param_2 - 1 < 2)) {
    iVar8 = 0;
    SHA256_Init(&SStack_c8);
    bVar1 = false;
    do {
      iVar8 = iVar8 + 1;
      if ((bVar1) && (param_2[0x40] == 0)) {
        pbVar6 = param_2 + 0x45;
        break;
      }
      bVar1 = iVar8 == 3;
    } while (iVar8 < 4);
    piVar5 = (int *)(param_2 + 2);
    iVar8 = 4;
    uVar7 = 0;
    do {
      iVar3 = *piVar5;
      piVar5 = (int *)((int*)piVar5 + 0x15);
      uVar7 = uVar7 + iVar3;
      iVar8 = iVar8 + -1;
    } while (iVar8 != 0);
    uVar7 = FUN_10005cdc(param_1,uVar7,&SStack_c8);
    uVar2 = 0xffffffff;
    if (uVar7 == 0) {
      if ((pbVar6 != (unsigned char *)0x0) && (*(int *)(pbVar6 + 8) != 0)) {
	/* read 0xe bytes and store them at uStack_58 */
        sVar4 = FUN_10005d64(param_1,&uStack_58[0],0xe,&SStack_c8);
        if (sVar4 != 0) {
          return 0xffffffff;
        }
        uVar7 = 0;
        iVar8 = 0;
        if (uStack_58[1] != 0) {
          do {
            iVar8 = iVar8 + 1;
            sVar4 = FUN_10005d64(param_1,&uStack_48[0],0x15,&SStack_c8);
            if (sVar4 != 0) {
              return 0xffffffff;
            }
            uVar7 = uVar7 + uStack_48[1];
          } while (iVar8 < (int)(uint)uStack_58[1]);
        }
        uVar7 = FUN_10005cdc(param_1,uVar7,&SStack_c8);
        if (uVar7 != 0) {
          return 0xffffffff;
        }
      }
      SHA256_Final(param_3,&SStack_c8); //was sha256_Final(param_3,&SStack_c8);

      /* Print the digest as one long hex value */
      for (n = 0; n < SHA256_DIGEST_LENGTH; n++)
	printf("%02x", param_3[n]);
      putchar('\n');

      
      uVar2 = 0;
    }
  }
  return uVar2;
}



unsigned char FUN_10005f64(unsigned char *param_1,uint param_2,unsigned char  *param_3,size_t param_4,int param_5,int param_6) {
  bool bVar1;
  int param2;
  int iVar2;
  int iVar3;
  int iVar4;
  int *local_78 [8];
  unsigned char abStack_58 [32];
  size_t local_38 [3];

  printf(RED);
  printf("FUN_10005f\n");
  printf(DEFAULT);

  
  memset(local_78,0,0x18);
  iVar3 = 2;
  local_78[0] = (int *)&DAT_10022860;
  local_78[1] = (int *)&DAT_10022964;
  if (param_5 != 0) {
    iVar3 = 3;
    syslog(7,"Adding the developer key to the keyring. Do not do this on production releases!\n");
    local_78[2] = (int *)&DAT_1002275c;
  }
  bVar1 = false;
  local_38[0] = 0x20;
  iVar2 = 0;
  do {
    memset(abStack_58,0,0x20);
    param2 = FUN_10008474(abStack_58,local_38,(int)param_1,param_2,local_78[iVar2]);
    iVar4 = iVar2 + 1;
    if (2 < param_6) {
      printf("[%d] - %d, digest_size=%d \n",iVar2,param2,local_38[0]);
      fflush(stdout);
      FUN_10005c58(param_1,param_2);
      FUN_10005c58(abStack_58,local_38[0]);
      FUN_10005c58(param_3,param_4);
    }
    if (param2 == 0) {
      iVar2 = memcmp(abStack_58,param_3,param_4);
      bVar1 = iVar2 == 0;
    }
    iVar2 = iVar4;
  } while (!bVar1 && iVar4 < iVar3);
  if (param_6 != 0) {
    if (!bVar1) {
      syslog(7,"failed!\n");
    }
    else {
      syslog(7,"successful! Key%d\n",iVar4);
    }
  }
  return bVar1 ^ 1;
}




size_t FUN_10005d64(int param_1,void *param_2,size_t param_3,SHA256_CTX *param_4){
  size_t sVar1;

  printf(RED);
  printf("FUN_10005d64\n");
  printf(DEFAULT);

  
  sVar1 = 0xffffffff;
  if (0 < (int)param_3) {
    do {
      sVar1 = read(param_1,param_2,param_3);
      if ((int)sVar1 < 1) {
        return param_3;
      }
      SHA256_Update(param_4,param_2,sVar1);
      param_3 = param_3 - sVar1;
      param_2 = (void *)((int)param_2 + sVar1);
    } while (0 < (int)param_3);
    sVar1 = 0;
  }
  return sVar1;
}



uint FUN_10005cdc(int param_1,uint param_2,SHA256_CTX *param_3){
  uint uVar1;
  size_t sVar2;
  unsigned char auStack_2018 [0x2008];

  printf(RED);
  printf("FUN_10005cdc\n");
  printf(DEFAULT);
  
  uVar1 = 0xffffffff;
  if (0 < (int)param_2) {
    do {
      sVar2 = 0x2000;
      if (param_2 < 0x2000) {
        sVar2 = param_2;
      }
      sVar2 = read(param_1,auStack_2018,sVar2);
      if ((int)sVar2 < 1) {
        return param_2;
      }
      SHA256_Update(param_3,auStack_2018,sVar2);
      param_2 = param_2 - sVar2;
    } while (0 < (int)param_2);
    uVar1 = 0;
  }
  return uVar1;
}



void FUN_10005c58(unsigned char  *param_1,int param_2){
  unsigned char  bVar1;

  printf(RED);
  printf("FUN_10005c58\n");
  printf(DEFAULT);
  
  printf("%4d: ",param_2);
  fflush(stdout);
  if (0 < param_2) {
    do {
      bVar1 = *param_1;
      param_1 = param_1 + 1;
      printf("%02x ",(uint)bVar1);
      fflush(stdout);
      param_2 = param_2 + -1;
    } while (param_2 != 0);
  }
  putchar(10);
  fflush(stdout);
  return;
}


int FUN_10008474(void *param_1,size_t *param_2,int param_3,uint param_4,int *param_5){
  uint uVar1;
  char *pcVar2;
  char local_a0 [128];
  uint local_20;
  uint local_1c;
  uint local_18;
  int local_14;

  printf(RED);
  printf("FUN_10008474\n");
  printf(DEFAULT);
  
  local_1c = *param_5 + 7U >> 3;
  if (local_1c < param_4) {
    local_14 = 0x406;
  }
  else {
    local_14 = FUN_100089b8((int)local_a0,&local_18,param_3,param_4,param_5);
    if (local_14 == 0) {
      if (local_18 == local_1c) {
        if ((local_a0[0] == '\0') && (local_a0[1] == '\x01')) {
          for (local_20 = 2; (uVar1 = local_20, local_20 < local_1c - 1 && (local_a0[local_20] == -1)); local_20 = local_20 + 1) {
          }
          pcVar2 = local_a0 + local_20;
          local_20 = local_20 + 1;
          if (*pcVar2 == '\0') {
            *param_2 = local_1c - local_20;
            if (local_1c < *param_2 + 0xb) {
              local_14 = 0x401;
            }
            else {
              FUN_10008fe4(param_1,local_a0 + uVar1 + 1,*param_2);
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


void FUN_10008fe4(void *param_1,void *param_2,size_t param_3){

  printf(RED);
  printf("FUN_10008fe4\n");
  printf(DEFAULT);

  if (param_3 != 0) {
    memcpy(param_1,param_2,param_3);
  }
  return;
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



uint32_t FUN_100089b8(int param_1,uint *param_2,int param_3,int param_4,int *param_5){
  int iVar1;
  unsigned char auStack_260 [144];
  unsigned char auStack_1d0 [144];
  unsigned char auStack_140 [144];
  unsigned char  auStack_b0 [144];
  int local_20;
  uint local_1c;
  uint32_t local_18;
  
  printf(RED);
  printf("FUN_100089b8\n");
  printf(DEFAULT);

  FUN_100090a4((int)auStack_140,0x21,param_3,param_4);
  FUN_100090a4((int)auStack_b0,0x21,(int)(param_5 + 1),0x80);
  FUN_100090a4((int)auStack_1d0,0x21,(int)(param_5 + 0x21),0x80);
  local_1c = FUN_1000a6bc((int)auStack_b0,0x21);
  local_20 = FUN_1000a6bc((int)auStack_1d0,0x21);
  iVar1 = FUN_1000a4c0((int)auStack_140,(int)auStack_b0,local_1c);
  if (iVar1 < 0) {
    FUN_10009ebc((int)auStack_260,(int)auStack_140,(int)auStack_1d0,local_20,(int)auStack_b0,local_1c);
    *param_2 = *param_5 + 7U >> 3;
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


void FUN_100090a4(int param_1,uint param_2,int param_3,int param_4)

{
  uint local_28;
  int local_24;
  uint local_20;
  uint local_1c;

  printf(RED);
  printf("FUN_100090a4\n");
  printf(DEFAULT);

  local_20 = 0;
  local_24 = param_4 + -1;
  while ((local_20 < param_2 && (-1 < local_24))) {
    local_28 = 0;
    for (local_1c = 0; (-1 < local_24 && (local_1c < 0x20)); local_1c = local_1c + 8) {
      local_28 = local_28 | (uint)*(unsigned char *)(param_3 + local_24) << (local_1c & 0x3f);
      local_24 = local_24 + -1;
    }
    *(uint *)(local_20 * 4 + param_1) = local_28;
    local_20 = local_20 + 1;
  }
  for (; local_20 < param_2; local_20 = local_20 + 1) {
    *(uint32_t*)(local_20 * 4 + param_1) = 0;
  }
  return;
}


int FUN_1000a6bc(int param_1,int param_2){
  int local_20;

  printf(RED);
  printf("FUN_1000a6bc\n");
  printf(DEFAULT);
  
  for (local_20 = param_2 + -1; (-1 < local_20 && (*(int *)(local_20 * 4 + param_1) == 0)); local_20 = local_20 + -1) {
  }
  return local_20 + 1;
}



uint32_t FUN_1000a4c0(int param_1,int param_2,int param_3){
  int local_1c;
  
  local_1c = param_3 + -1;
  while( true ) {
    if (local_1c < 0) {
      return 0;
    }
    if (*(uint *)(local_1c * 4 + param_2) < *(uint *)(local_1c * 4 + param_1)) break;
    if (*(uint *)(local_1c * 4 + param_1) < *(uint *)(local_1c * 4 + param_2)) {
      return 0xffffffff;
    }
    local_1c = local_1c + -1;
  }
  return 1;
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


void FUN_10009ebc(int param_1,int param_2,int param_3,int param_4,int param_5,uint param_6){
  int iVar1;
  unsigned char auStack_2d4 [100];
  unsigned char auStack_250 [132];
  unsigned char auStack_1cc [132];
  unsigned char auStack_148 [136];
  uint local_c0;
  uint32_t local_b8 [36];
  int local_28;
  uint local_24;
  uint local_20;
  uint local_1c;

  printf(RED);
  printf("FUN_10009edc\n");
  printf(DEFAULT);

  
  FUN_100092f8((int)auStack_250,param_2,param_6);
  FUN_10009e2c((int)auStack_1cc,(int)auStack_250,param_2,param_5,param_6);
  FUN_10009e2c((int)auStack_148,(int)auStack_1cc,param_2,param_5,param_6);
  FUN_10009374((int)local_b8,param_6);
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
  FUN_100092f8(param_1,(int)local_b8,param_6);
  FUN_10008f90(auStack_250,0,0x18c);
  FUN_10008f90(local_b8,0,0x84);
  return;
}




void FUN_100092f8(int param_1,int param_2,uint param_3){
  uint local_1c;

  printf(RED);
  printf("FUN_100092f8\n");
  printf(DEFAULT);

  for (local_1c = 0; local_1c < param_3; local_1c = local_1c + 1) {
    *(uint32_t *)(local_1c * 4 + param_1) = *(uint32_t *)(local_1c * 4 + param_2);
  }
  return;
}



void FUN_10009e2c(int param_1,int param_2,int param_3,int param_4,uint param_5){
  unsigned char auStack_120 [284];
  
  printf(RED);
  printf("FUN_10009e2c\n");
  printf(DEFAULT);

  FUN_100096ac((int)auStack_120,param_2,param_3,param_5);
  FUN_10009db8(param_1,(int)auStack_120,param_5 << 1,param_4,param_5);
  FUN_10008f90(auStack_120,0,0x108);
  return;
}


void FUN_10009374(int param_1,uint param_2){
  uint local_20;
  
  printf(RED);
  printf("FUN_10009374\n");
  printf(DEFAULT);

  for (local_20 = 0; local_20 < param_2; local_20 = local_20 + 1) {
    *(uint32_t *)(local_20 * 4 + param_1) = 0;
  }
  return;
}



void FUN_100096ac(int param_1,int param_2,int param_3,int param_4){
  int iVar1;
  int iVar2;
  uint uVar3;
  int aiStack_138 [68];
  uint local_28;
  uint local_24;
  uint local_20;
  
  printf(RED);
  printf("FUN_100096ac\n");
  printf(DEFAULT);

  FUN_10009374((int)aiStack_138,param_4 << 1);
  local_28 = FUN_1000a6bc(param_2,param_4);
  local_24 = FUN_1000a6bc(param_3,param_4);
  for (local_20 = 0; local_20 < local_28; local_20 = local_20 + 1) {
    iVar1 = local_20 + local_24;
    iVar2 = local_20 + local_24;
    uVar3 = FUN_1000a738((int)(aiStack_138 + local_20),(int)(aiStack_138 + local_20),*(uint *)(local_20 * 4 + param_2),param_3,local_24);
    aiStack_138[iVar1] = aiStack_138[iVar2] + uVar3;
  }
  FUN_100092f8(param_1,(int)aiStack_138,param_4 << 1);
  FUN_10008f90(aiStack_138,0,0x108);
  return;
}


void FUN_10009db8(int param_1,int param_2,uint param_3,int param_4,uint param_5){
  unsigned char auStack_120 [284];

  printf(RED);
  printf("FUN_10009db8\n");
  printf(DEFAULT);

  FUN_10009a24((int)auStack_120,param_1,param_2,param_3,param_4,param_5);
  FUN_10008f90(auStack_120,0,0x108);
  return;
}



void FUN_10009a24(int param_1,int param_2,int param_3,uint param_4,int param_5,uint param_6){
  int iVar1;
  int iVar2;
  uint uVar3;
  int iVar4;
  uint local_1d0;
  uint auStack_1cc [68];
  int iStack_bc;
  unsigned char auStack_b8 [144];
  int local_28;
  int local_24;
  uint local_20;
  uint local_1c;
  
  printf(RED);
  printf("FUN_10009a24\n");
  printf(DEFAULT);

  local_20 = FUN_1000a6bc(param_5,param_6);
  if (local_20 != 0) {
    local_1c = FUN_1000aa18(*(uint *)(local_20 * 4 + param_5 + -4));
    local_1c = 0x20 - local_1c;
    FUN_10009374((int)(auStack_1cc + 1),local_20);
    uVar3 = FUN_10009824((int)(auStack_1cc + 1),param_3,local_1c,param_4);
    auStack_1cc[param_4 + 1] = uVar3;
    FUN_10009824((int)auStack_b8,param_5,local_1c,local_20);
    local_28 = (&iStack_bc)[local_20];
    FUN_10009374(param_1,param_4);
    for (local_24 = param_4 - local_20; -1 < local_24; local_24 = local_24 + -1) {
      if (local_28 == -1) {
        local_1d0 = auStack_1cc[local_24 + local_20 + 1];
      }
      else {
        FUN_1000b104((int *)&local_1d0,(int *)(auStack_1cc + local_24 + local_20),local_28 + 1);
      }
      iVar1 = local_24 + local_20;
      iVar2 = local_24 + local_20;
      iVar4 = FUN_1000a8a4((int)(auStack_1cc + local_24 + 1),(int)(auStack_1cc + local_24 + 1),local_1d0,(int)auStack_b8,local_20);
      auStack_1cc[iVar1 + 1] = auStack_1cc[iVar2 + 1] - iVar4;
      while ((auStack_1cc[local_24 + local_20 + 1] != 0 || (iVar1 = FUN_1000a4c0((int)(auStack_1cc + local_24 + 1),(int)auStack_b8,local_20), -1 < iVar1))) {
        local_1d0 = local_1d0 + 1;
        iVar1 = local_24 + local_20;
        iVar2 = local_24 + local_20;
        iVar4 = FUN_10009580((int)(auStack_1cc + local_24 + 1),(int)(auStack_1cc + local_24 + 1),(int)auStack_b8,local_20);
        auStack_1cc[iVar1 + 1] = auStack_1cc[iVar2 + 1] - iVar4;
      }
      *(uint *)(local_24 * 4 + param_1) = local_1d0;
    }
    FUN_10009374(param_2,param_6);
    FUN_10009924(param_2,(int)(auStack_1cc + 1),local_1c,local_20);
    FUN_10008f90(auStack_1cc + 1,0,0x10c);
    FUN_10008f90(auStack_b8,0,0x84);
  }
  return;
}


uint FUN_10009824(int param_1,int param_2,uint param_3,uint param_4){
  uint local_24;
  uint local_20;
  uint local_18;
  uint local_14;
  
  printf(RED);
  printf("FUN_10009824\n");
  printf(DEFAULT);

  if (param_3 < 0x20) {
    local_24 = 0;
    for (local_20 = 0; local_20 < param_4; local_20 = local_20 + 1) {
      local_14 = *(uint *)(local_20 * 4 + param_2);
      *(uint *)(local_20 * 4 + param_1) = local_14 << (param_3 & 0x3f) | local_24;
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
  int local_20;
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
        local_14 = local_14 << (0x20 - param_3 & 0x3f);
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




int FUN_10009580(int param_1,int param_2,int param_3,uint param_4){
  uint local_28;
  int local_24;
  uint local_20;
  
  printf(RED);
  printf("FUN_10009580\n");
  printf(DEFAULT);

  local_24 = 0;
  for (local_20 = 0; local_20 < param_4; local_20 = local_20 + 1) {
    local_28 = *(int *)(local_20 * 4 + param_2) - local_24;
    if (-local_24 - 1U < local_28) {
      local_28 = -*(int *)(local_20 * 4 + param_3) - 1;
    }
    else {
      local_28 = local_28 - *(int *)(local_20 * 4 + param_3);
      if (-*(int *)(local_20 * 4 + param_3) - 1U < local_28) {
        local_24 = 1;
      }
      else {
        local_24 = 0;
      }
    }
    *(uint *)(local_20 * 4 + param_1) = local_28;
  }
  return local_24;
}


void FUN_1000af94(uint *param_1,uint param_2,uint param_3){
  ushort uVar1;
  ushort uVar2;
  uint uVar3;
  uint uVar4;
  
  printf(RED);
  printf("FUN_1000af94\n");
  printf(DEFAULT);

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


void FUN_1000b104(int *param_1,int *param_2,uint param_3) {
  ushort uVar1;
  uint uVar2;
  int iVar3;
  uint local_28;
  uint32_t local_24;
  ushort local_18;
  ushort local_16;
  
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


uint FUN_1000aa18(uint param_1){
  uint local_18;
  uint local_14;
  
  printf(RED);
  printf("FUN_1000aa18\n");
  printf(DEFAULT);

  local_14 = 0;
  for (local_18 = param_1; (local_14 < 0x20 && (local_18 != 0)); local_18 = local_18 >> 1) {
    local_14 = local_14 + 1;
  }
  return local_14;
}


// both two functions below are the same ??????????????????
uint FUN_1000a738(int param_1,int param_2,uint param_3,int param_4,uint param_5){
  uint uVar1;
  uint local_24;
  uint local_20[2]; // local_20[0]
  //int local_1c;   // local_20[1]
  uint local_18;
  uint local_14;
  
  printf(RED);
  printf("FUN_1000a738\n");
  printf(DEFAULT);

  if (param_3 == 0) {
    local_14 = 0;
  }
  else {
    local_24 = 0;
    for (local_18 = 0; local_18 < param_5; local_18 = local_18 + 1) {
      FUN_1000af94(&local_20[0],param_3,*(uint *)(local_18 * 4 + param_4));
      uVar1 = *(int *)(local_18 * 4 + param_2) + local_24;
      *(uint *)(local_18 * 4 + param_1) = uVar1;
      local_24 = (uint)(uVar1 < local_24);
      uVar1 = *(int *)(local_18 * 4 + param_1) + local_20[0];
      *(uint *)(local_18 * 4 + param_1) = uVar1;
      if (uVar1 < local_20[0]) {
        local_24 = local_24 + 1;
      }
      local_24 = local_24 + local_20[1];
    }
    local_14 = local_24;
  }
  return local_14;
}

int FUN_1000a8a4(int param_1,int param_2,uint param_3,int param_4,uint param_5){
  uint uVar1;
  uint local_24;
  uint local_20[2];  // local_20[0]
  int local_1c;      // local_20[1]
  uint local_18;
  int local_14;
  
  printf(RED);
  printf("FUN_1000a8a4\n");
  printf(DEFAULT);

  if (param_3 == 0) {
    local_14 = 0;
  }
  else {
    local_24 = 0;
    for (local_18 = 0; local_18 < param_5; local_18 = local_18 + 1) {
      FUN_1000af94(&local_20[0],param_3,*(uint *)(local_18 * 4 + param_4));
      uVar1 = *(int *)(local_18 * 4 + param_2) - local_24;
      *(uint *)(local_18 * 4 + param_1) = uVar1;
      local_24 = (uint)(-local_24 - 1 < uVar1);
      uVar1 = *(int *)(local_18 * 4 + param_1) - local_20[0];
      *(uint *)(local_18 * 4 + param_1) = uVar1;
      if (-local_20[0] - 1 < uVar1) {
        local_24 = local_24 + 1;
      }
      local_24 = local_24 + local_20[1];
    }
    local_14 = local_24;
  }
  return local_14;
}



#include "hpoa.h"

/* glocal variables */
//unsigned char *DAT_10022a68;
unsigned char *DAT_10012738=0;  //doesn't change anywhere
unsigned int   DAT_000cbb58=-1;
//char *DAT_10022c2c; // waarschijnlijk naam van flash image 
unsigned int DAT_10022c20=0;
unsigned int DAT_10022c24=0;
//unsigned char *DAT_10022c28;


int main(int argc,char **argv){
  
  int fd,fw;
  FILE *fp;
  off_t offset;                                                 /* __offset */

  char file_name[128];
  ssize_t ret;                                                  /* uVar10 */
  unsigned char *read_buffer;                                   /* local_d28 */
  read_buffer=calloc(MAX_FILE_SIZE,sizeof(unsigned char));

  int i,j;                                                      /* iVar16 and iVar27 */
  int index=0;

  uint32_t partition_size=0;
  char *mtd_name;
  mtd_name=calloc(0x80,sizeof(unsigned char));

  char *partition_name;
  partition_name=calloc(0x80,sizeof(unsigned char));

  //unsigned char *DAT_10022c28;
  //DAT_10022c28=calloc(0x80,sizeof(unsigned char));

  
  unsigned int *local_5c;
  local_5c=calloc(6,sizeof(uint));

  unsigned int  partition_nr;  //was unsigned char, was uVar9

  unsigned int jump_size=0;                                     /* _Var12*/
  unsigned int current_location=0;
  unsigned int fw_location=0;
  unsigned int fw_location_array[0x10];
  unsigned int current_location_array[0x10];

  int iVar5 = 0;
  int iVar8 = 0;
  int iVar9 = 0;
  bool bVar1;

  int opt=0;
  int modify=0;
  int rw_test=0;
  int burn=0;
  int firmware=0;
  int verify=0;
  int have_fingerprint=0;

  char *md5_sum;


  if (geteuid() != 0) {
    fprintf(stderr, "%s needs root privileges!\n",argv[0]);
    exit(1);
  }
  
  if(argc <= 1){
    printf("No firmware file. Usage: %s [option] <filename>\n",argv[0]);
    return -1;
  }else{
  
    while ( opt = getopt(argc,argv,"fbmtv"), opt != -1) {
      if (true) {
	switch(opt) {
	case 'm':
	  modify=1;
	  //printf("Choosen option: %c, will modify rc.sysinit\n",opt);
	  break;
	case 't':
	  rw_test=1;
	  //printf("Choosen option: %c, will test write data to /dev/mtd7:0x4000\n",opt);
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
	  //printf("Choosen option: %c, will compose new firmware image\n",opt);
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


#if 0 //SHA stuff works
  do_sha256_tests();
#endif


  printf("Endianness: ");
  if(is_bigendian()) printf("big.\n"); else printf("little.\n");

    
  if(!burn || !rw_test) {
    do_housekeeping();
  }

  
  if ( rw_test && !modify ) {
    if( do_rw_test() < 0) return -1;
  }

  
  strcpy(file_name,argv[optind]);
  
  fd=open(file_name,O_RDONLY);                 /*file_name = local_c48 */
  ret=read(fd,read_buffer,HEADER_SIZE);     /* read_buffer = local_d28 */

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


  //have_fingerprint = verify_signature(fd,(__off_t *)&DAT_10022c28,read_buffer,0);

  
  /****************************************************************************************/
  /*                              main while loop                                         */
  /****************************************************************************************/


  while( true ) {
    current_location = lseek(fd,0,SEEK_CUR);
    current_location_array[index]=current_location;
    index++;

    printf("current location: 0x%X\n",current_location);
    
    iVar5 = iVar8;
    bVar1 = (3 < iVar9);
    iVar9 = iVar9 + 1;

    if ( ( bVar1 || (local_5c[0] != 0) ) || ( *(read_buffer+1+iVar5) == '\0') ) break;

    partition_nr = (unsigned int) *(read_buffer+1+iVar5);  
    partition_name = partition_selector(partition_nr);      

    jump_size= *(__off_t*)(read_buffer+1+iVar5+1);
        if(!is_bigendian()) jump_size = __htobe32(jump_size);

    /* write mtd partition */
    local_5c[0] = open_mtd_for_output_internal(fd, partition_name,jump_size);

    iVar8 = iVar5 + 0x15;

    if(modify && strcmp(partition_name,"initrd")==0) {

      md5_sum  = calloc( 0x10,sizeof(char));
      modify_initrd(partition_name,&partition_size,md5_sum);
      /* update md5sum int read_buffer, should also be updated in firmware file */

      for(i=0;i<MD5_DIGEST_LENGTH;i++){
	*(uint8_t*)(read_buffer + 1 + iVar5 + 5 + i)= *(uint8_t*)(md5_sum+i);
	}

      sprintf(mtd_name,"dev/mtd-%s",partition_name);


      fp=fopen(mtd_name,"r");
      partition_size=fseek(fp,0, SEEK_END);
      partition_size = ftell(fp);
      //printf("%s size: %i\n",mtd_name,partition_size);
      fclose(fp);

      
      //modify=0;
      //goto write_modified_initrd;
    }

    if (local_5c[0] == 0) {
      //jump_size = *(__off_t*)(read_buffer+1+iVar5+1);
      //if(!is_bigendian()) jump_size = __htobe32(jump_size);

      /* verify the writen mtd partition */
      /* (read_nuffer + 1 + iVar5 +5) is where the MD5sum of the partition is stored */
      printf("read_buffer localtion: 0x%X\n", 1+iVar5+5);
      local_5c[0] = open_mtd_for_input_internal(partition_name,jump_size,(read_buffer + 1 + iVar5 + 5));
    }
    printf("\n");
  }
  close(fd);


  if(burn && ((em_type()==C3000) || (em_type()==C7000)) ){
    printf("start writing initrd\n");
    write_initrd();
  }

  

  if(firmware){
    ssize_t s=0;
    char *data;
    char cmd[0x100];
    data=calloc(0x1000,sizeof(char));

    strcpy(cmd, "cp ");
    strcat(cmd, file_name);
    strcat(cmd, " hpoa999.bin");
    printf("%s\n",cmd);
    system(cmd);
    fw=open("hpoa999.bin",O_RDWR);
    s=write(fw,read_buffer,HEADER_SIZE);
    fw_location+=s;
    fw_location_array[0]=fw_location;
    
    fd=open("dev/mtd-kernel",O_RDONLY);
    while(s=read(fd,data,0x1000),s>0){
      fw_location+=write(fw,data,s);
    }
    close(fd);
    fw_location_array[1]=fw_location;

    fd=open("dev/mtd-initrd",O_RDONLY);
    while(s=read(fd,data,0x1000),s>0){
      fw_location+=write(fw,data,s);
    }
    close(fd);
    fw_location_array[2]=fw_location;

    fd=open("dev/mtd-squashfs",O_RDONLY);
    while(s=read(fd,data,0x1000),s>0){
      fw_location+=write(fw,data,s);
    }
    close(fd);
    fw_location_array[3]=fw_location;
    close(fw);


    for(i=0;i<4;i++){
      printf("current: 0x%X, fw: 0x%X\n",current_location_array[i],fw_location_array[i]);
    }
  }

  verify_only:
  if(verify){
    printf("start verifying initrd\n");
    verify_initrd();
    return(1);
  }

  burn_only:
  printf("em_type: %i\n",em_type());
  if(burn){
    printf("start writing initrd\n");
    write_initrd();
    return(1);
  }

  return 0;
}

/******************************************************************************************/
/*                                  End of main                                           */
/******************************************************************************************/


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
    if(uVar1==1)printf("fingerprint Lenghth found\n"); else printf("No Fingerprint Length found\n");

    fclose(file);
  }
  return uVar1;
}



/* FUN_100033a8 */
char * partition_selector(unsigned char p){
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
int open_mtd_for_input_internal(char *partition_name,int param_2,void *param_3){


  
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


  printf(RED);
  printf("open_mtd_for_input_internal, FUN_10002160.\n");
  printf(DEFAULT);

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
    printf("Open partition: %s for MD5 input\n",full_path);

    md5Init(&ctx);
    while((input_size = fread(input_buffer, 1, 1024, file)) > 0){
        md5Update(&ctx, (uint8_t *)input_buffer, input_size);
    }
    md5Finalize(&ctx);

    free(input_buffer);
    memcpy(md5sum, ctx.digest, MD5_DIGEST_LENGTH);

    fclose(file);

#if 1
    printf(BLUE);
    printf("Comparing result of FUN_10006944 with param_3\n");
    printf(DEFAULT);

    printf("param_3: ");
    for(i=0; i<MD5_DIGEST_LENGTH; i++){
      printf("%2.2X",*(unsigned char*)((unsigned char*)param_3+i));
    }
    printf("\n");

    printf("md5sum:  ");
    for(i=0; i<MD5_DIGEST_LENGTH; i++){
      printf("%2.2X",md5sum[i]);
    }
    printf("\n");

#endif

    iVar2 = memcmp((unsigned char*)param_3,md5sum,0x10);


    free(cmd);
    free(md5sum);
    free(full_path);
    return iVar2;

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

    __fd = open((char *)full_path,O_SYNC|O_RDWR);
  if (__fd == -1) {
    printf("error opening %s for output\n",full_path);
  }
  else {
    printf("Open partition: %s for output\n",full_path);
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


int em_type(void){  // not used right now
  char local_28 [32];
  if (DAT_000cbb58 == -1) {
    local_28[0] = '\0';
    //find_tag_in_file("/etc/gpio_states","OABOARDTYPE",local_28,0x10,0);
    printf("before find_tag_in_file\n");
    find_tag_in_file("gpio_states","OABOARDTYPE",&local_28[0],0x10,'=');
    printf("after find_tag_in_file\n");
    printf("em_type: %i\n",atoi(local_28));
    DAT_000cbb58 = atoi(local_28);
  }
  return DAT_000cbb58;
}

void do_housekeeping(void){
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

}


void do_sha256_tests(void){
    
  printf(BLUE);
  printf("/*********************************/\n");
  printf("/*   start MD5 and SHA256 test   */\n");
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
  printf("/*   end  MD5 and SHA256 test    */\n");
  printf("/*********************************/\n");
  printf(DEFAULT);

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


int modify_initrd(char *partition_name, uint32_t *mtd_size,char *md5_sum){
  int i;
  char *cmd;
  cmd=calloc(0x100,sizeof(char));

  int loopctlfd, loopfd, backingfile;
  long devnr;
  char loopname[0x100];

  printf(RED);
  printf("modify_initrd.\n");
  printf(DEFAULT);

  sprintf(loopname, "/dev/loop%i", get_free_loop());
  printf("loopname = %s\n", loopname);

  memset(cmd,'\0',0x100);
  strcpy(cmd,"mkdir dev/mnt-");
  strcat(cmd,partition_name);
  printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd,"sync");  
  printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd,"tail -c+65 dev/mtd-");
  strcat(cmd,partition_name);
  strcat(cmd," | gunzip >& dev/");
  strcat(cmd,partition_name);
  strcat(cmd, " ; ");
  strcat(cmd,"sync");  
  printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd ,"losetup ");
  strcat(cmd, loopname);
  strcat(cmd," dev/");
  strcat(cmd,partition_name);
  printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd, "mount -o loop ");
  strcat(cmd, loopname);
  strcat(cmd, " dev/mnt-");
  strcat(cmd,partition_name);
  strcat(cmd, " ; ");
  strcat(cmd,"sync");  
  printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd, "echo \"udog:pD.WvCQWQJ4Kc:0:0:0,,:/:/bin/sh\" > passwd.new ");
  strcat(cmd, " ; ");  
  strcat(cmd,"sync");  
  printf("%s\n",cmd);
  system(cmd);
  
  memset(cmd,'\0',0x100);
  strcpy(cmd, "grep -v -e '^udog:' ");
  strcat(cmd, "dev/mnt-");
  strcat(cmd, partition_name);
  strcat(cmd, "/etc/passwd >> passwd.new");
  strcat(cmd, " ; ");  
  strcat(cmd,"sync");  
  printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd, "mv passwd.new ");
  strcat(cmd, "dev/mnt-");
  strcat(cmd, partition_name);
  strcat(cmd, "/etc/passwd");
  strcat(cmd, " ; ");  
  strcat(cmd,"sync");  
  printf("%s\n",cmd);
  system(cmd);
  
  memset(cmd,'\0',0x100);
  strcpy(cmd,"chmod 666 ");
  strcat(cmd, "dev/mnt-");
  strcat(cmd, partition_name);
  strcat(cmd, "/etc/passwd");
  strcat(cmd, " ; ");
  strcat(cmd,"sync");  
  printf("%s\n",cmd);
  system(cmd);
  
  memset(cmd,'\0',0x100);
  strcpy(cmd,"chown 1:1 ");
  strcat(cmd, "dev/mnt-");
  strcat(cmd, partition_name);
  strcat(cmd, "/etc/passwd");
  strcat(cmd, " ; ");
  strcat(cmd,"sync");
  printf("%s\n",cmd);
  system(cmd);


  memset(cmd,'\0',0x100);
  strcpy(cmd,"cp rc.sysinit ");
  strcat(cmd, "dev/mnt-");
  strcat(cmd, partition_name);
  strcat(cmd, "/etc/rc.sysinit");
  strcat(cmd, " ; ");
  strcat(cmd,"sync");
  printf("%s\n",cmd);
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
  printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd,"umount dev/mnt-");
  strcat(cmd,partition_name);
  strcat(cmd, " ; ");
  strcat(cmd,"sync");
  printf("%s\n",cmd);
  system(cmd);

  memset(cmd,'\0',0x100);
  strcpy(cmd,"rm -rf dev/mnt-");
  strcat(cmd,partition_name);
  printf("%s\n",cmd);
  system(cmd);
  
  memset(cmd,'\0',0x100);
  strcpy(cmd, "mkimage -d ");
  strcat(cmd, partition_name);
  strcat(cmd, ".gz -n \'\"");
  strcat(cmd, partition_name);
  strcat(cmd, " 141208-0921 build\"\' -T ramdisk dev/mtd-");
  strcat(cmd, partition_name);
  strcat(cmd," >& /dev/null");
  strcat(cmd, " ; ");
  strcat(cmd,"sync");  
  printf("%s\n",cmd);
  system(cmd);
  
  /* must do md5 of gzipped partition before mkimage adds header */
  memset(cmd,'\0',0x100);
  strcpy(cmd,"md5sum  ");
  strcat(cmd,partition_name);
  strcat(cmd,".gz >/dev/null");
  strcat(cmd, " ; ");
  strcat(cmd,"sync");
  printf("%s\n",cmd);
  system(cmd);

  /* must do md5 of gzipped partition before mkimage adds header */
  memset(cmd,'\0',0x100);
  strcpy(cmd, "md5sum dev/mtd-");
  strcat(cmd, partition_name);
  strcat(cmd, " >/dev/null");
  strcat(cmd, " ; ");
  strcat(cmd, "sync");
  printf("%s\n",cmd);
  system(cmd);

  
  char *filename = calloc(0x100,sizeof(char));
  strcpy(filename,"dev/mtd-");
  strcat(filename,partition_name);
  my_md5sum(filename,md5_sum);

  free(filename);
  
  memset(cmd,'\0',0x100);
  strcpy(cmd,"rm ");
  strcat(cmd,partition_name);
  strcat(cmd,".gz >& /dev/null");
  strcat(cmd, " ; ");
  strcat(cmd,"sync");  
  printf("%s\n",cmd);
  system(cmd);

  
  return 0;
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


int  do_rw_test(void){

  if( (em_type()==C3000) || (em_type()==C7000) ){
    
    int fd;
    char data[0x100];
    char ret[0x100];
    memset(data,0,0x100);


    fd=open("/dev/mtd7", O_SYNC|O_RDWR);
    if(fd<0){
      printf("could not open /dev/mtd7\n");
      return(-1);
    }
    
    lseek(fd,0x00008000,SEEK_SET);
    read(fd,ret,0x10);
    if(memcmp(data,ret,0x10)==0){
      lseek(fd,0x00008000,SEEK_SET);
      strcat(data,"Hello world!");
      write(fd,data,12);
    }else{
      printf("Data range is not all zeros!\n");
    }
    close(fd);

    printf("only tested writing to /dev/mtd7\n");
    return(0);

  }else{
    printf("No physical enclosure, can't do rw_test\n");
    return -1;
  }
}



size_t FUN_10005d64(int fd,void *param_2,size_t param_3,sha256_ctx *ctx){
  size_t sVar1;

  printf(RED);
  printf("FUN_10005d64\n");
  printf(DEFAULT);

  
  sVar1 = 0xffffffff;
  if (0 < (int)param_3) {
    do {
      sVar1 = read(fd,param_2,param_3);
      if ((int)sVar1 < 1) {
        return param_3;
      }
      sha256_update(ctx,param_2,sVar1);
      param_3 = param_3 - sVar1;
      param_2 = (void *)((int*)param_2 + sVar1);
    } while (0 < (int)param_3);
    sVar1 = 0;
  }
  return sVar1;
}



uint FUN_10005cdc(int fd,uint param_2,sha256_ctx *ctx){
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
      sVar2 = read(fd,auStack_2018,sVar2);
      if ((int)sVar2 < 1) {
        return param_2;
      }
      sha256_update(ctx,auStack_2018,sVar2);
      param_2 = param_2 - sVar2;
    } while (0 < (int)param_2);
    uVar1 = 0;
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
  sha256_ctx ctx;
  uint8_t results[SHA256_DIGEST_SIZE];
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
    sha256_init(&ctx);
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
    uVar7 = FUN_10005cdc(param_1,uVar7,&ctx);
    uVar2 = 0xffffffff;
    if (uVar7 == 0) {
      if ((pbVar6 != (unsigned char *)0x0) && (*(int *)(pbVar6 + 8) != 0)) {
	/* read 0xe bytes and store them at uStack_58 */
        sVar4 = FUN_10005d64(param_1,&uStack_58[0],0xe,&ctx);
        if (sVar4 != 0) {
          return 0xffffffff;
        }
        uVar7 = 0;
        iVar8 = 0;
        if (uStack_58[1] != 0) {
          do {
            iVar8 = iVar8 + 1;
            sVar4 = FUN_10005d64(param_1,&uStack_48[0],0x15,&ctx);
            if (sVar4 != 0) {
              return 0xffffffff;
            }
            uVar7 = uVar7 + uStack_48[1];
          } while (iVar8 < (int)(uint)uStack_58[1]);
        }
        uVar7 = FUN_10005cdc(param_1,uVar7,&ctx);
        if (uVar7 != 0) {
          return 0xffffffff;
        }
      }
      sha256_final(&ctx,param_3); //was sha256_Final(param_3,&SStack_c8);

      /* Print the digest as one long hex value */
      for (n = 0; n < SHA256_DIGEST_SIZE; n++)
	printf("%02x", param_3[n]);
      putchar('\n');

      
      uVar2 = 0;
    }
  }
  return uVar2;
}



uint verify_signature(int fd ,__off_t *param_2,unsigned char *param_3,int param_4){
  uint uVar1;
  __off_t _Var2;
  int iVar3;
  __off_t _Var4;
  unsigned char bVar5;
  unsigned char abStack_48 [48];

  printf(RED);
  printf("verify_signature, FUN_1000610c\n");
  printf(DEFAULT);

  _Var2 = lseek(fd,0,1);
  uVar1 = 0xffffffff;
  if (-1 < _Var2) {
    iVar3 = FUN_10005de8(fd,param_3,abStack_48);
    uVar1 = 0xffffffff;
    if (-1 < iVar3) {
      if (param_2 != (__off_t *)0x0) {
        _Var4 = lseek(fd,0,1);
        *param_2 = _Var4;
      }
      _Var2 = lseek(fd,_Var2,0);
      uVar1 = 0xffffffff;
      if (-1 < _Var2) {
	printf("Should add developer key to key ring.\n");
        //bVar5 = FUN_10005f64(param_3 + 0x55,0x80,abStack_48,0x20,param_4,param_5);
        //uVar1 = (uint)bVar5;
      }
    }
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
  return loopdev[0];
  
}



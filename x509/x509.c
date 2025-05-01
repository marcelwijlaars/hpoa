#include "x509.h"


X509 *PEM_read_bio_X509(BIO *bp, X509 **x, pem_password_cb *cb, void *u)
{
    return PEM_ASN1_read_bio((d2i_of_void *)d2i_X509, "CERTIFICATE",bp,(void **)x,cb,u);
}

unsigned char FUN_1000bc00(char *param_1) {
  size_t sVar1;
  char *uVar2;
  int iVar3;
  char *local_24;
  unsigned int local_20;

  local_24=calloc(0x100,sizeof(char));
  
  if (param_1 == (char *)0x0) {
    local_20 = 0;
  }
  else {
    sVar1 = strlen(param_1);

    FUN_1000c6f4((size_t)(sVar1 + 1),local_24,"stobool");
    strcpy(local_24,param_1);
    uVar2 = FUN_1000be80(local_24);
    trimSpaces(uVar2);
    iVar3 = strcmp(local_24,"true");
    if ((((iVar3 == 0) || (iVar3 = strcmp(local_24,"yes"), iVar3 == 0)) ||
        (iVar3 = strcmp(local_24,"y"), iVar3 == 0)) || (iVar3 = strcmp(local_24,"1"), iVar3 == 0)) {
      FUN_1000c7dc(local_24,"stobool");
      local_20 = 1;
    }
    else {
      iVar3 = strcmp(local_24,"false");
      if (((iVar3 == 0) || (iVar3 = strcmp(local_24,"no"), iVar3 == 0)) ||
         ((iVar3 = strcmp(local_24,"n"), iVar3 == 0 || (iVar3 = strcmp(local_24,"0"), iVar3 == 0))))
      {
        FUN_1000c7dc(local_24,"stobool");
        local_20 = 0;
      }
      else {
        FUN_1000c7dc(local_24,"stobool");
        local_20 = 0;
      }
    }
  }
  return local_20;
}



char * FUN_1000bdd4(int param_1){
  char *local_14;
  
  if (param_1 == 0) {
    local_14 = "False";
  }
  else {
    local_14 = "True";
  }
  return local_14;
}



void FUN_1000be20(unsigned int param_1,char *param_2){
  if (param_2 != (char *)0x0) {
    sprintf(param_2,"%d",param_1);
  }
  return;
}



char *FUN_1000be80(char *param_1){
  int i;
  char *local_20;
  
  if (param_1 == 0) {
    local_20 = 0;
  }
  else {
    for (i= 0; local_20 = param_1, *(char *)(param_1 + i) != '\0';i++) {
      if ((0x40 < *(unsigned char *)(param_1 + i)) && (*(unsigned char *)(param_1 + i) < 0x5b)) {
        *(char *)(param_1 + i) = *(char *)(param_1 + i) + ' ';
      }
    }
  }
  return local_20;
}


char* DAT_10022bf8 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

void FUN_1000c09c(unsigned char *param_1,unsigned char *param_2){  
  int local_20;
  int i;
  
  local_20 = ((uint)param_1[0] * 0x100 + (uint)param_1[1]) * 0x100 + (uint)param_1[2];
  for (i = 0; i < 4; i++) {
    *(char *)(param_2 +3 - i) =
         DAT_10022bf8[local_20 + (local_20 >> 6) * -0x40];
    local_20 = local_20 >> 6;
  }
  return;
}

void FUN_1000bf58(void *param_1,uint param_2,unsigned char *param_3,int param_4){
  void *local_38;
  uint local_34;
  unsigned char *local_30;
  unsigned char auStack_28 [36];
  
  local_38 = param_1;
  local_34 = param_2;
  local_30 = param_3;
  if (param_4 - 1U < (param_2 + 2) / 3 << 2) {
    printf("Can\'t encode data to BASE-64.  Buffer too small\n");
  }
  for (; 2 < local_34; local_34 = local_34 - 3) {
    FUN_1000c09c(local_38,local_30);
    local_38 = (void *)((int*)local_38 + 3);  // big endian to small endian, or char*?
    local_30 = local_30 + 4;
  }
  if (local_34 != 0) {
    memset(auStack_28,0,3);
    memcpy(auStack_28,local_38,local_34);
    FUN_1000c09c(auStack_28,local_30);
    local_30[3] = 0x3d;
    if (local_34 == 1) {
      local_30[2] = 0x3d;
    }
    local_30 = local_30 + 4;
  }
  *local_30 = 0;
  return;
}




int FUN_1000c18c(char *param_1,void *param_2,uint param_3){
  size_t sVar1;
  int iVar2;
  void *local_44;
  uint local_40;
  
  char *local_38;
  char *local_3c;

  char acStack_34 [4];
  char auStack_30 [16];
  int local_20;
  uint local_1c;
  int local_18;
  int local_14;

  local_3c=calloc(0x100,sizeof(char));
  
  local_20 = 0;
  local_1c = 3;
  local_18 = 0;
  sVar1 = strlen(param_1);
  FUN_1000c6f4(sVar1 + 5,local_3c,"base64_decode");
  if (local_3c == (char *)0x0) {
    local_14 = -1;
  }
  else {
    strcpy(local_3c,param_1);
    strcat(local_3c,"====");
    local_38 = local_3c;
    local_44 = param_2;
    local_40 = param_3;
    while (local_1c == 3) {
      for (local_20 = 0; local_20 < 4; local_20 = local_20 + 1) {
        while ((*local_38 != '=' && (iVar2 = FUN_1000c384(local_38), iVar2 < 0))) {
          local_38 = local_38 + 1;
        }
        acStack_34[local_20] = *local_38;
        local_38 = local_38 + 1;
      }
      local_1c = FUN_1000c488((int*)acStack_34,(int*)auStack_30);
      if (local_40 < local_1c) {
        free(local_3c);
        return -1;
      }
      memcpy(local_44,auStack_30,local_1c);
      local_44 = (void *)((int*)local_44 + local_1c);
      local_40 = local_40 - local_1c;
      local_18 = local_18 + local_1c;
    }
    free(local_3c);
    local_14 = local_18;
  }
  return local_14;
}



int FUN_1000c384(char *param_1){

  unsigned int local_14;
  
  if ((*param_1 < 0x41) || (0x5a < *param_1)) {
    if ((*param_1 < 0x61) || (0x7a < *param_1)) {
      if ((*param_1 < 0x30) || (0x39 < *param_1)) {
        if (*param_1 == 0x2b) {
          local_14 = 0x3e;
        }
        else if (*param_1 == 0x2f) {
          local_14 = 0x3f;
        }
        else {
          local_14 = -1;
        }
      }
      else {
        local_14 = *param_1 + 4;
      }
    }
    else {
      local_14 = *param_1 - 0x47;
    }
  }
  else {
    local_14 = *param_1 - 0x41;
  }
  return local_14;
}



int FUN_1000c488(int *param_1,int *param_2){
  bool bVar1;
  int iVar2;
  int local_40;
  uint local_3c;
  int local_38;
  int local_30 [9];
  
  local_38 = 3;
  bVar1 = true;
  for (local_40 = 0; local_40 < 4; local_40 = local_40 + 1) {
    iVar2 = FUN_1000c384((char *)(param_1 + local_40));
    local_30[local_40] = iVar2;
  }
  local_40 = 3;
  do {
    if (local_40 < 0) {
      if (local_38 < 0) {
        local_38 = 0;
      }
      local_3c = ((local_30[0] * 0x40 + local_30[1]) * 0x40 + local_30[2]) * 0x40 + local_30[3];
      for (local_40 = local_38; iVar2 = local_38, local_40 < 3; local_40 = local_40 + 1) {
        local_3c = ((int)local_3c >> 8) + (uint)((int)local_3c < 0 && (local_3c & 0xff) != 0);
      }
      while (local_40 = iVar2 + -1, -1 < local_40) {
        *(char *)(param_2 + local_40) = (char)local_3c;
        local_3c = ((int)local_3c >> 8) + (uint)((int)local_3c < 0 && (local_3c & 0xff) != 0);
        iVar2 = local_40;
      }
      return local_38;
    }
    if (local_30[local_40] < 0) {
      if ((!bVar1) || (*(char *)(param_1 + local_40) != '=')) {
        return 0;
      }
      local_30[local_40] = 0;
      local_38 = local_38 + -1;
    }
    else {
      bVar1 = false;
    }
    local_40 = local_40 -1;
  } while( true );
}



unsigned int FUN_1000c6f4(size_t param_1,char *param_2,char* param_3) {
  void *pvVar1;
  unsigned int local_1c;

  if (param_3 == 0) {
    local_1c = 0xffffffff;
  }
  else if (param_1 == 0) {
    local_1c = 0xffffffff;
  }
  else if (param_2 == NULL) {
    local_1c = 0xffffffff;
  }
  else {
    pvVar1 = calloc(param_1,sizeof(char));
    *param_2 = *(int*)pvVar1;
    if (*param_2 == 0) {
      printf("failed to acquire memory for [%s]",param_3);
      local_1c = 0xffffffff;
    }
    else {
      memset((void *)param_2,0,param_1);
      local_1c = 0;
    }
  }
  return local_1c;
}



unsigned int FUN_1000c7dc(char *param_1,char *param_2){
  unsigned int local_20;
  
  if (param_2 == 0) {  // empty string or 0 pointer?
    local_20 = 0xffffffff;
  }
  else if (*param_1 == 0) {
    local_20 = 0;
  }
  else {
    *param_1 = 0;
    free((void *)param_1);
    local_20 = 0;
  }
  return local_20;
}



void FUN_1000c868(int param_1,int param_2,int param_3) {
  if (param_1 == 0) {
    printf("File path supplied to split_path is NULL. Will abort!");
  }
  if (param_2 == 0) {
    printf("Buffer passed to split_path() to store directory name is NULL!");
  }
  if (param_3 == 0) {
    printf("Buffer passed to split_path() to store file name is NULL!");
  }
  return;
}

  

unsigned int FUN_1000c8e8(char *param_1,char *param_2,char *param_3,char *param_4,char *param_5)

{
  int iVar1;
  unsigned int local_14;
  
  if (param_1 == (char *)0x0) {
    local_14 = 0;
  }
  else if ((param_2 == (char *)0x0) || (iVar1 = strcmp(param_1,param_2), iVar1 != 0)) {
    if ((param_3 == (char *)0x0) || (iVar1 = strcmp(param_1,param_3), iVar1 != 0)) {
      if ((param_4 == (char *)0x0) || (iVar1 = strcmp(param_1,param_4), iVar1 != 0)) {
        if ((param_5 == (char *)0x0) || (iVar1 = strcmp(param_1,param_5), iVar1 != 0)) {
          local_14 = 0;
        }
        else {
          local_14 = 1;
        }
      }
      else {
        local_14 = 1;
      }
    }
    else {
      local_14 = 1;
    }
  }
  else {
    local_14 = 1;
  }
  return local_14;
}


void FUN_1000e38c(void){
  if (DAT_10022cc4 != (void *)0x0) {
    memset(DAT_10022cc4,0,DAT_10022cc8);
    FUN_1000c7dc(DAT_10022cc4,"close_signed_hash");
    DAT_10022cc4 = (void *)0x0;
    DAT_10022cc8 = 0;
  }
  return;
}


void FUN_1000de80(void){
  if (DAT_10022cbc != 0) {
    FUN_1000c7dc(DAT_10022cbc,"close_config");
  }
  if (DAT_10022cc0 != 0) {
    FUN_1000c7dc(DAT_10022cc0,"close_config");
  }
  FUN_1000e38c();
  return;
}



unsigned int FUN_1000ca0c(void) {
  unsigned int iVar1;
  char *uVar2;
  X509 *uVar3;
  char *__file;
  unsigned int iVar4;
  unsigned int local_14;
  
  iVar1 = FUN_1000d6e0();
  if (iVar1 == 0) {
    uVar2 = (char*)DAT_10022c44;
    uVar3 = FUN_1000bac8();
    iVar1 = FUN_1000ddd4((X509*)uVar2,uVar3);
    if (iVar1 == 0) {
      iVar1 = FUN_1000da30();
      if (iVar1 == 0) {
        __file = (char *)DAT_10022c2c; // file name
        iVar1 = open(__file,0);
        if (iVar1 == -1) {
          uVar2 = DAT_10022c2c; // file name
          printf("Can\'t open [%s] to check\n",uVar2);
          local_14 = 0xffffffff;
        }
        else {
          iVar4 = FUN_1000dae4(iVar1);
          if (iVar4 == 0) {
            iVar1 = FUN_1000dc8c();
            if (iVar1 == 0) {
              FUN_1000de80();
              local_14 = 0;
            }
            else {
              local_14 = 0xffffffff;
            }
          }
          else {
            close(iVar1);
            local_14 = 0xffffffff;
          }
        }
      }
      else {
        local_14 = 0xffffffff;
      }
    }
    else {
      printf("Certificates validation failed. Cannot trust the signed file!\n");
      local_14 = 0xffffffff;
    }
  }
  else {
    local_14 = 0xffffffff;
  }
  return local_14;
}



unsigned char FUN_1000cb68(void){ // same as fw_with_fingerprint (char *filename)
  unsigned char uVar1;
  char *pcVar2;
  FILE *__stream;
  int *piVar3;
  int iVar4;
  char acStack_420 [1024];
  //void *local_20;
  
  uVar1 = 0;
  memset(acStack_420,0,0x400);
  //local_20 = DAT_10022c2c; // file name 
  pcVar2 = (char *)DAT_10022c2c; // file name 
  __stream = fopen(pcVar2,"rb");
  if (__stream == (FILE *)0x0) {
    printf("could not open the signed file for parsing\n");
    uVar1 = 0;
  }
  else {
    memset(acStack_420,0,0x400);
    fgets(acStack_420,0x400,__stream);
    piVar3 = __errno_location();
    *piVar3 = 0;
    iVar4 = fseek(__stream,-0x2800,2);
    if ((iVar4 == -1) && (piVar3 = __errno_location(), *piVar3 == 0x16)) {
      rewind(__stream);
    }
    memset(acStack_420,0,0x400);
    while (pcVar2 = fgets(acStack_420,0x400,__stream), pcVar2 != (char *)0x0) {
      pcVar2 = strstr(acStack_420,"Fingerprint Length:");
      if (pcVar2 != (char *)0x0) {
        uVar1 = 1;
        break;
      }
      memset(acStack_420,0,0x400);
    }
    fclose(__stream);
  }
  return uVar1;
}



int *FUN_1000cd38(void){ //returns pointer or value???
  unsigned int local_18;
  unsigned char local_14;

  local_14 = 0xb5;
  if (DAT_10022c98 == 0) {
    DAT_10022ab4 = 0x794;
    FUN_1000c6f4(0x794,(char*)DAT_10022c98,"get_embeded_signing_cert");
  }
  for (local_18 = 0; local_18 < 0x78c; local_18 = local_18 + 1) {
    *(unsigned char *)(DAT_10022c98 + local_18) = DAT_10011a40[local_18]^local_14;
    local_14 = local_14 + 1;
  }
  return DAT_10022c98; //strange to return a pointer to a static variable
}




void FUN_1000ce10(void){
  if (DAT_10022c98 != (void *)0x0) {
    memset(DAT_10022c98,0,DAT_10022ab4);
    FUN_1000c7dc((char*)DAT_10022c98,"release_embeded_signing_cert");
    DAT_10022c98 = NULL;
    DAT_10022ab4 = 0xffffffff;
  }
  return;
}



long FUN_1000ce94(FILE *param_1,char *param_2)

{
  char *pcVar1;
  size_t sVar2;
  long local_420;
  char acStack_418 [1024];
  long local_18;
  
  local_420 = 0;
  memset(acStack_418,0,0x400);
  if ((param_1 == (FILE *)0x0) || (param_2 == (char *)0x0)) {
    printf("find_block_length():  invalid file stream pointer or the pattern");
    local_18 = 0;
  }
  else {
    while (pcVar1 = fgets(acStack_418,0x400,param_1), pcVar1 != (char *)0x0) {
      pcVar1 = strstr(acStack_418,param_2);
      if (pcVar1 != (char *)0x0) {
        sVar2 = strlen(param_2);
        local_420 = strtol(pcVar1 + sVar2,(char **)0x0,10);
        if (local_420 == 0) {
          printf("[%s]: could not retrieve [%s]","parse_signed_file",param_2);
        }
        break;
      }
      memset(acStack_418,0,0x400);
    }
    local_18 = local_420;
  }
  return local_18;
}



unsigned int  FUN_1000b9f4(char *param_1){
  BIO *bp;
  int iVar1;
  unsigned int local_20;
  
  bp = BIO_new(BIO_s_mem());
  BIO_puts(bp,param_1);
  local_20 = 0;
  DAT_10022c44 = PEM_read_bio_X509(bp,(X509 **)0x0,NULL,(void *)0x0);
  if (DAT_10022c44 == (X509 *)0x0) {
    printf("Can\'t convert signing certificate into a data structure\n");
    local_20 = 0xffffffff;
  }
  iVar1 = BIO_free(bp);
  if (iVar1 != 1) {
    printf("Can\'t free BIO memory\n");
    local_20 = 0xffffffff;
  }
  return local_20;
}



unsigned int FUN_1000b770(char *param_1){
  BIO *bp;
  X509 *data;
  int iVar1;
  unsigned int local_20;
  unsigned int local_14;
  
  local_20 = 0;
  if (DAT_10022c74 < 4) {
    if (param_1 == NULL) {
      printf("Pointer to certificates chain is NULL\n");
      local_14 = 0xffffffff;
    }
    else {
      bp = BIO_new(BIO_s_mem());
      BIO_puts(bp,param_1);
      
      data = PEM_read_bio_X509(bp,(X509 **)0x0,NULL,(void *)0x0);
      
      if (data == (X509 *)0x0) {
        printf("Can\'t convert intermediate certificate into a data structure\n");
        local_20 = 0xffffffff;
      }
      iVar1 = BIO_free(bp);
      if (iVar1 != 1) {
        printf("Can\'t free BIO memory\n");
        local_20 = 0xffffffff;
      }
      if (DAT_10022c78 == 0) {
        DAT_10022c60 = sk_new((void *)DAT_10022c60);
        if (DAT_10022c60 == (_STACK *)0x0) {
          printf("Can\'t create intermediate certificate stack\n");
          local_20 = 0xffffffff;
        }
        DAT_10022c78 = 1;
      }
      iVar1 = sk_push(DAT_10022c60,data);
      if (iVar1 < 1) {
        printf("Intermediate certificate could not be added to the stack\n");
        local_20 = 0xffffffff;
      }
      DAT_10022c74 = DAT_10022c74 + 1;
      local_14 = local_20;
    }
  }
  else {
    printf("exceeded MAX no of allowed certificates [5].\n");
    local_14 = 0xffffffff;
  }
  return local_14;
}


int FUN_1000cff0(FILE *param_1){
  int iVar1;
  int iVar2;
  char *pcVar3;
  int local_434;
  size_t local_428;
  char *local_424;
  char acStack_420 [1024];
  int local_20;
  
  local_434 = 0;
  local_428 = 0;
  local_424 = (char *)0x0;
  memset(acStack_420,0,0x400);
  if (param_1 == (FILE *)0x0) {
    printf("split_cert_chain():  invalid file stream pointer.\n");
    local_20 = 0;
  }
  else {
    iVar1 = DAT_10022c7c;
    iVar2 = DAT_10022c84;
    fseek(param_1,iVar1 + iVar2,0);
    local_428 = 0x800;
    iVar1 = FUN_1000c6f4(0x800,local_424,"split_cert_chain");
    if (iVar1 == -1) {
      local_20 = -1;
    }
    else {
      do {
        while( true ) {
          while( true ) {
            pcVar3 = fgets(acStack_420,0x400,param_1);
            if (pcVar3 == (char *)0x0) goto LAB_1000d1ec;
            iVar1 = strcmp(acStack_420,"-----BEGIN CERTIFICATE----- ");
            if (iVar1 != 0) break;
            strcat(local_424,"-----BEGIN CERTIFICATE----- ");
          }
          iVar1 = strcmp(acStack_420,"-----END CERTIFICATE-----\n");
          if (iVar1 == 0) break;
          FUN_1000d22c(&local_428,acStack_420);
          memset(acStack_420,0,0x400);
        }
        strcat(local_424,"-----END CERTIFICATE-----\n");
        if (DAT_10022c9c == 0) {
          DAT_10022c9c = 1;
          local_434 = FUN_1000b9f4(local_424);
        }
        else {
          local_434 = FUN_1000b770(local_424);
        }
        memset(local_424,0,local_428);
      } while (local_434 != -1);
LAB_1000d1ec:
      FUN_1000c7dc(local_424,"split_cert_chain()");
      local_20 = local_434;
    }
  }
  return local_20;
}



void FUN_1000d22c(size_t *param_1,char *param_2){
  size_t sVar1;
  size_t sVar2;
  size_t sVar3;
  void *pvVar4;
  
  if (*param_1 == 0) {
    printf("append_PEM_buff was told an invalid size of malloc\'d cert buffer.\n");
  }
  else if (param_2 == (char *)0x0) {
    printf("append_PEM_buff received a NULL pointer to append to cert buffer.\n");
  }
  else {
    sVar2 = strlen((char *)param_1[1]);
    sVar1 = *param_1;
    sVar3 = strlen(param_2);
    if (sVar3 < sVar1 - sVar2) {
      strcat((char *)param_1[1],param_2);
    }
    else {
      *param_1 = *param_1 + 0x200;
      pvVar4 = realloc((void *)param_1[1],*param_1);
      if (pvVar4 == (void *)0x0) {
        printf("memory allocated to cert was insufficient, and attempt to reallocate failed.");
      }
      else {
        param_1[1] = (size_t)pvVar4;
        strcat((char *)param_1[1],param_2);
      }
    }
  }
  return;
}




void FUN_1000e064(char *param_1){
  size_t sVar1;
  int iVar2;
  
  if (param_1 == (char *)0x0) {
    printf("Can\'t set private keyID to NULL\n");
  }
  else {
    if (DAT_10022cbc != NULL) {
      FUN_1000c7dc(DAT_10022cbc,"set_private_keyID");
    }
    sVar1 = strlen(param_1);
    iVar2 = FUN_1000c6f4(sVar1 + 1,DAT_10022cbc,"set_private_keyID");
    if (iVar2 != -1) {
      strcpy(DAT_10022cbc,param_1);
      trimSpaces(DAT_10022cbc);
      if (*DAT_10022cbc == '\0') {
        FUN_1000c7dc(DAT_10022cbc,"set_private_keyID");
      }
    }
  }
  return;
}



void FUN_1000e2b4(int param_1) {
  if (0 < param_1) {
    if (DAT_10022cc4 != 0) {
      FUN_1000c7dc(DAT_10022cc4,"init_signed_hash");
    }
    DAT_10022cc8 = param_1;
    FUN_1000c6f4(param_1,DAT_10022cc4,"init_signed_hash");
  }
  return;
}

 
void FUN_1000e410(int param_1){
  DAT_10022ccc = param_1;
  return;
}

void FUN_1000d4dc(void){
  unsigned int *iVar1;
  char *pcVar2;
  char *uVar3;
  int uVar4;
  char *local_28;
  char *local_24;
  int local_20;

  iVar1=calloc(0x10,sizeof(unsigned int));
  
  local_28 = (char *)0x0;
  local_24 = (char *)0x0;
  local_20 = DAT_10022c84;
  local_20 = local_20 + 1;
  if ((1 < local_20) &&
     (*iVar1 = FUN_1000c6f4(local_20,local_28,"parse_fingerprint()"), *iVar1 != -1)) {
    pcVar2 = (char *)DAT_10022c40;
    strcpy(local_28,pcVar2);
    local_24 = strtok(local_28,"\n");
    while ((
	    local_24 != (char *)0x0 &&
           (pcVar2 = strstr(local_24,"End HP Signed File Fingerprint"),
	    pcVar2 == (char *)0x0)
	    )) {
      local_24 = strtok((char *)0x0,":\n");
      if ((local_24 != (char *)0x0) && (*iVar1 = strcmp(local_24,"Key"), *iVar1 == 0)) {
        local_24 = strtok((char *)0x0,"\n");
        FUN_1000e064(local_24);
      }
      if ((local_24 != (char *)0x0) && (*iVar1 = strcmp(local_24,"Hash"), *iVar1 == 0)) {
        local_24 = strtok((char *)0x0,"\n");
        FUN_1000e410(2);
      }
      if (((local_24 != (char *)0x0) && (*iVar1 = strcmp(local_24,"Signature"), iVar1 == 0)) &&
         (local_24 = strtok((char *)0x0,"\n"), local_24 != (char *)0x0)) {
        iVar1 = (unsigned int*) DAT_10022c44;
        FUN_1000e2b4(**(unsigned int **)(iVar1 + 8));
        uVar3 = DAT_10022cc4;
        uVar4 = DAT_10022cc8;
        FUN_1000c18c(local_24,uVar3,uVar4);
      }
    }
    FUN_1000c7dc(local_28,"parse_fingerprint()");
  }
  return;
}


void FUN_1000d988(void)

{
  int iVar1;
  
  iVar1 = DAT_10022ccc;
  if (iVar1 == 1) {
    DAT_10022cb0 = FIPS_evp_sha256();
  }
  else if (iVar1 == 0) {
    DAT_10022cb0 = FIPS_evp_sha1();
  }
  else if (iVar1 == 2) {
    DAT_10022cb0 = FIPS_evp_sha512();
  }
  else {
    printf("Unknown message digest\n");
  }
  return;
}



unsigned int FUN_1000da30(void){
  int iVar1;
  unsigned int local_18;
  
  OPENSSL_add_all_algorithms_noconf();
  DAT_10022cb4 = FIPS_md_ctx_create();
  if (DAT_10022cb4 == 0) {
    printf("Can\'t initialize the message digest\n");
    local_18 = 0xffffffff;
  }
  else {
    FUN_1000d988();
    iVar1 = FIPS_digestinit(DAT_10022cb4,DAT_10022cb0);
    if (iVar1 == 0) {
      printf("Can\'t initialize the verifier\n");
      local_18 = 0xffffffff;
    }
    else {
      local_18 = 0;
    }
  }
  return local_18;
}



unsigned int FUN_1000dae4(unsigned int param_1){
  int iVar1;
  char *local_24;
  int local_20;
  int local_1c;
  unsigned int local_18;
  
  local_24 = (void *)0x0;
  local_20 = 1;
  local_1c = 0;
  iVar1 = FUN_1000c6f4(0x1000,local_24,"validate_stream");
  if (iVar1 == -1) {
    local_18 = 0xffffffff;
  }
  else {
    while (iVar1 = DAT_10022c7c, local_1c < iVar1) {
      iVar1 = DAT_10022c7c;
      if (local_1c + 0x1000 < iVar1) {
        local_20 = read(param_1,local_24,0x1000);
      }
      else {
        iVar1 = DAT_10022c7c;
        local_20 = read(param_1,local_24,iVar1 - local_1c);
      }
      if (local_20 < 0) break;
      local_1c = local_1c + local_20;
      iVar1 = FIPS_digestupdate(DAT_10022cb4,local_24,local_20);
      if (iVar1 == 0) {
        printf("Verify failed during string processing\n");
        FUN_1000c7dc(local_24,"validate_stream");
        return 0xffffffff;
      }
      memset(local_24,0,0x1000);
    }
    memset(local_24,0,0x1000);
    FUN_1000c7dc(local_24,"validate_stream");
    local_18 = 0;
  }
  return local_18;
}




void FUN_1000b538(char *param_1){
  size_t sVar1;
  int iVar2;
  
  if (param_1 != (char *)0x0) {
    sVar1 = strlen(param_1);
    iVar2 = FUN_1000c6f4(sVar1 + 1,DAT_10022c40,"set_checker_fingerprint()");
    if (iVar2 != -1) {
      strcpy(DAT_10022c40,param_1);
    }
  }
  return;
}


unsigned int FUN_1000d368(FILE *param_1,void *param_2){
  unsigned char *puVar1;
  long __off;
  int iVar2;
  void *local_1c;
  size_t local_18;
  unsigned int local_14;
  
  local_1c = NULL;
  local_18 = 0;
  if (param_1 == NULL) {
    puVar1 = (unsigned char *)param_2;  // call to function how??????????
    printf("findblock:  invalid file stream pointer to [%s].\n",puVar1);
    local_14 = 0xffffffff;
  }
  else {
    __off = DAT_10022c7c;
    fseek(param_1,__off,0);
    iVar2 =  DAT_10022c84;
    local_18 = iVar2 + 1;
    if (local_18 != 0) {
      iVar2 = FUN_1000c6f4(local_18,local_1c,"split_signed_file():fingerprint");
      if (iVar2 == -1) {
        return 0xffffffff;
      }
      fread(local_1c,local_18,1,param_1);
      *(unsigned char *)((int*)local_1c + local_18 - 1) = 0;
      FUN_1000b538(local_1c);
      FUN_1000c7dc(local_1c,"split_signed_file():fingerprint");
    }
    iVar2 = FUN_1000cff0(param_1);
    if (iVar2 == -1) {
      local_14 = 0xffffffff;
    }
    else {
      FUN_1000d4dc();
      local_14 = 0;
    }
  }
  return local_14;
}



void FUN_1000b6b0(int param_1){
  if (-1 < param_1) {
    DAT_10022c84 = param_1;
  }
  return;
}


void FUN_1000b5f0(int param_1){
  if (-1 < param_1) {
    DAT_10022c7c = param_1;
  }
  return;
}


unsigned int FUN_1000dc8c(void){
  unsigned char *sigbuf;
  int iVar1;
  unsigned char auStack_a0 [128];
  uint local_20;
  X509 *local_1c;
  EVP_PKEY *local_18;
  unsigned int local_14;
  
  memset(auStack_a0,0,0x78);
  local_20 = 0;
  local_1c = (X509 *)0x0;
  local_18 = (EVP_PKEY *)0x0;
  local_1c = (X509 *)DAT_10022c44;

  if (local_1c == (X509 *)0x0) {
    printf("Can\'t make public key\n");
    local_14 = 0xffffffff;
  }
  else {
    local_20 = local_1c->signature->length;
    local_18 = X509_get_pubkey(local_1c);
    if (local_18 == (EVP_PKEY *)0x0) {
      printf("Can\'t make public key\n");
      local_14 = 0xffffffff;
    }
    else {
      sigbuf = (unsigned char *)DAT_10022cc4;
      iVar1 = EVP_VerifyFinal(DAT_10022cb4,sigbuf,local_20,local_18);
      if (iVar1 == 1) {
        printf("validate_finalize: Verification succeeded\n");
        local_14 = 0;
      }
      else {
        printf("validate_finalize: Verification of signed file failed\n");
        local_14 = 0xffffffff;
      }
    }
  }
  return local_14;
}



int FUN_1000ddd4(X509 *param_1,X509 *param_2){
  unsigned int local_20;
  
  if ((param_1 == NULL) || (param_2 == NULL)) {
    local_20 = -1;
  }
  else {
    local_20 = X509_cmp(param_1,param_2);
  }
  return local_20;
}


X509* FUN_1000bac8(void){
  BIO *bp;
  char *buf;
  int iVar1;
  X509 *local_14;
  
  bp = BIO_new(BIO_s_mem());
  buf = (char *)FUN_1000cd38();
  BIO_puts(bp,buf);
  DAT_10022c48 = PEM_read_bio_X509(bp,(X509 **)0x0,NULL,(void *)0x0);
  if (DAT_10022c48 == NULL) {
    local_14 = NULL;
  }
  else {
    iVar1 = BIO_free(bp);
    if (iVar1 == 1) {
      local_14 = DAT_10022c48;
    }else{
      local_14 = NULL;
    }
  }
  return local_14;
}



unsigned int *FUN_1000b510(void) {
  return (unsigned int *)DAT_10022c2c;
}

unsigned int FUN_1000d6e0(void){
  bool bVar1;
  char *pcVar2;
  FILE *__stream;
  int *piVar3;
  int iVar4;
  size_t sVar5;
  unsigned int uVar6;
  char acStack_428 [1024];
  void *local_28;
  int local_24;
  unsigned int local_20;
  
  bVar1 = false;
  memset(acStack_428,0,0x400);
  local_24 = 0;
  //local_28 = DAT_10022c2c; //probably pointer to some function, strange.
  //pcVar2 = (char *)DAT_10022c2c;

  local_28 = (void*)FUN_1000b510;
  pcVar2 = (char *)FUN_1000b510();

  
  __stream = fopen(pcVar2,"rb");
  if (__stream == (FILE *)0x0) {
    printf("could not open the signed file for parsing");
    local_20 = 0xffffffff;
  }
  else {
    memset(acStack_428,0,0x400);
    fgets(acStack_428,0x400,__stream);
    piVar3 = __errno_location();
    *piVar3 = 0;
    iVar4 = fseek(__stream,-0x2800,2);
    if ((iVar4 == -1) && (piVar3 = __errno_location(), *piVar3 == 0x16)) {
      rewind(__stream);
    }
    memset(acStack_428,0,0x400);
    while (pcVar2 = fgets(acStack_428,0x400,__stream), pcVar2 != (char *)0x0) {
      pcVar2 = strstr(acStack_428,"Fingerprint Length:");
      if (pcVar2 != (char *)0x0) {
        bVar1 = true;
        local_24 = ftell(__stream);
        sVar5 = strlen(acStack_428);
        local_24 = (local_24 - sVar5) + -0x2b;
        break;
      }
      memset(acStack_428,0,0x400);
    }
    if (bVar1) {
      FUN_1000b5f0(local_24);
      local_24 = 0;
      uVar6 = FUN_1000ce94(__stream,"Fingerprint Length:");
      FUN_1000b6b0(uVar6);
      iVar4 = FUN_1000d368(__stream,local_28);
      if (iVar4 == -1) {
        fclose(__stream);
        local_20 = 0xffffffff;
      }
      else {
        fclose(__stream);
        local_20 = 0;
      }
    }
    else {
      printf("could not find signed blocks in the file. File is not a valid signed file!.\n"
                  );
      fclose(__stream);
      local_20 = 0xffffffff;
    }
  }
  return local_20;
}


void truncateSpaces(char *param_1){
  size_t sVar1;
  
  if ((param_1 != (char *)0x0) && (*param_1 != '\0')) {
    sVar1 = strlen(param_1);
    while ((sVar1 = sVar1 - 1, -1 < (int)sVar1 &&
           ((*(ushort *)((uint)(unsigned char)param_1[sVar1] * 2 + __ctype_b) & 0x20) != 0))) {
      param_1[sVar1] = '\0';
    }
  }
  return;
}


void trimSpaces(char *param_1) {
  int iVar1;
  size_t sVar2;
  int iVar3;
  int iVar4;
  
  if ((param_1 != (char *)0x0) && (*param_1 != '\0')) {
    sVar2 = strlen(param_1);
    iVar4 = 0;
    if (0 < (int)sVar2) {
      do {
        iVar3 = iVar4;
        if ((*(ushort *)((uint)(unsigned char)param_1[iVar3] * 2 + __ctype_b) & 0x20) == 0) break;
        iVar4 = iVar3 + 1;
        iVar3 = 0;
      } while (iVar4 < (int)sVar2);
      if (0 < iVar3) {
        iVar4 = 0;
        iVar1 = iVar3;
        while (iVar1 < (int)sVar2) {
          param_1[iVar4] = param_1[iVar3 + iVar4];
          iVar4 = iVar4 + 1;
          iVar1 = iVar3 + iVar4;
        }
        param_1[iVar4] = '\0';
      }
    }
    if (*param_1 != '\0') {
      truncateSpaces(param_1);
    }
  }
  return;
}

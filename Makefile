
all:
#	gcc -Wl,-emain -Wall -Wno-unused-variable -Wno-unused-but-set-variable -o hpoa md5/md5.c sha2/sha2.c hpoa.c
	gcc -Wall -Wno-unused-variable -Wno-unused-but-set-variable -o hpoa md5/md5.c sha2/sha2.c hpoa.c
local:
	gcc -nostdlib -I/usr/local/x86_64-linux-uclibc/usr/include -L/usr/local/x86_64-linux-uclibc/usr/lib -Wl,-emain,-dynamic-linker,libuClibc-1.0.50.so -Wall -Wno-unused-variable -Wno-unused-but-set-variable -o hpoa md5/md5.c sha2/sha2.c hpoa.c



old2:
	gcc -pedantic -Wunused-function -Wno-unused-variable -Wno-unused-but-set-variable -Wall -o hpoa md5/md5.c hpoa.c -lcrypto

old:
	gcc -pedantic -Wno-unused-variable -Wno-unused-but-set-variable -Wall -o hpoa hpoa.c sha2/sha2.c

clean:
	rm hpoa

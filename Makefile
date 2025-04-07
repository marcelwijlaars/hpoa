
all:
#	gcc -Wl,-emain -Wall -Wno-unused-variable -Wno-unused-but-set-variable -o hpoa md5/md5.c sha2/sha2.c hpoa.c
	gcc -std=c99 -D _GNU_SOURCE -Wall -Wno-unused-variable -Wno-unused-but-set-variable -o hpoa md5/md5.c sha2/sha2.c crc32/crc32.c hpoa.c

asan:
	gcc -std=c99 -fsanitize=address -g3 -D _GNU_SOURCE -Wall -Wno-unused-variable -Wno-unused-but-set-variable -o hpoa md5/md5.c sha2/sha2.c crc32/crc32.c hpoa.c

undef:
	gcc -std=c99 -fsanitize=undefined -g3 -D _GNU_SOURCE -Wall -Wno-unused-variable -Wno-unused-but-set-variable -o hpoa md5/md5.c sha2/sha2.c crc32/crc32.c hpoa.c

thread:
	gcc -std=c99 -fsanitize=thread -g3 -D _GNU_SOURCE -Wall -Wno-unused-variable -Wno-unused-but-set-variable -o hpoa md5/md5.c sha2/sha2.c crc32/crc32.c hpoa.c

local:
	gcc -nostdlib -I/usr/local/x86_64-linux-uclibc/usr/include -L/usr/local/x86_64-linux-uclibc/lib -Wl,-emain,-dynamic-linker,libuClibc-1.0.50.so -Wall -Wno-unused-variable -Wno-unused-but-set-variable -o hpoa md5/md5.c sha2/sha2.c hpoa.c



old2:
	gcc -pedantic -Wunused-function -Wno-unused-variable -Wno-unused-but-set-variable -Wall -o hpoa md5/md5.c hpoa.c -lcrypto

old:
	gcc -pedantic -Wno-unused-variable -Wno-unused-but-set-variable -Wall -o hpoa hpoa.c sha2/sha2.c

clean:
	rm hpoa

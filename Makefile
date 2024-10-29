#lscpu | grep 'Byte Order:'


all:
	gcc -pedantic -Wno-unused-variable -Wno-unused-but-set-variable -Wall -o hpoa md5/md5.c hpoa.c -L/opt/ssl/lib/ -lcrypto

old:
	gcc -pedantic -Wno-unused-variable -Wno-unused-but-set-variable -Wall -o hpoa hpoa.c sha2/sha2.c

clean:
	rm hpoa

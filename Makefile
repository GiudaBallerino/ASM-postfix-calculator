
all: bin/postfix

bin/postfix: obj/itoa.o obj/postfix.o obj/main.o
	gcc -m32 obj/main.o obj/postfix.o obj/itoa.o -o bin/postfix

obj/itoa.o: src/itoa.s
	gcc -gstabs -m32 -c src/itoa.s -o obj/itoa.o

obj/postfix.o: src/postfix.s
	gcc -gstabs -m32 -c src/postfix.s -o obj/postfix.o

obj/main.o: src/main.c
	gcc -gstabs -m32 -c src/main.c -o obj/main.o

clean:
	rm -rf bin/*
	rm -rf obj/*

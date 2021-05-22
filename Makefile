
all: bin/main

bin/main: obj/postfix.o obj/main.o
	gcc -m32 obj/main.o obj/postfix.o -o bin/main

obj/postfix.o: src/postfix.s
	gcc -gstabs -m32 -c src/postfix.s -o obj/postfix.o

obj/main.o: src/main.c
	gcc -gstabs -m32 -c src/main.c -o obj/main.o

clean:
	rm -rf bin/*
	rm -rf obj/*

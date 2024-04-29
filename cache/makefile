#Alon Luboshitz 312115090
CC = gcc
FLAG = -c
MAIN = cache

.phony: all clean

all: $(MAIN)

$(MAIN): main.o cache.o
	$(CC) $^ -o $@



main.o: main.c cache.h
	$(CC) -c main.c

cache.o: cache.c cache.h
	$(CC) -c cache.c

clean:
	rm *.o $(MAIN)

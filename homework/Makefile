CC = gcc
ASM = fasm
CFLAGS = -Wall -Wextra -O2

TARGET = main_prog
OBJS = main.o array.o

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJS)

main.o: main.c array.h
	$(CC) $(CFLAGS) -c main.c -o main.o

array.o: array.asm
	$(ASM) array.asm array.o

clean:
	rm -f $(OBJS) $(TARGET)

run: all
	./$(TARGET)

.PHONY: all clean run

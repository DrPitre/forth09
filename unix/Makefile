CC     = gcc
CFLAGS = -w -std=gnu89 -D_strass=__builtin_memcpy

TARGET = forth09
OBJS   = main.o dictiona.o basic_fu.o

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) -o $@ $^

main.o: ../main.c ../stack.c ../token.c
	$(CC) $(CFLAGS) -c ../main.c

dictiona.o: ../dictiona.c
	$(CC) $(CFLAGS) -c ../dictiona.c

basic_fu.o: ../basic_fu.c
	$(CC) $(CFLAGS) -c ../basic_fu.c

clean:
	rm -f $(OBJS) $(TARGET)

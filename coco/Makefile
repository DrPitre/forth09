CMOC   = cmoc
CFLAGS = --os9 --add-os9-stack-space=16384 -D_strass=memcpy -I $(HOME)/Projects/coco-shelf/cmoc_os9/include

TARGET = forth09
OBJS   = main.o dictiona.o basic_fu.o
DSK    = l2_coco3.dsk

.PHONY: all install clean

all: $(TARGET)

install: $(TARGET)
	os9 copy -r $(TARGET) $(DSK),CMDS/$(TARGET)
	os9 attr -epe $(DSK),CMDS/$(TARGET)

$(TARGET): $(OBJS)
	$(CMOC) --os9 --add-os9-stack-space=16384 -o $@ $^ -L $(HOME)/Projects/coco-shelf/cmoc_os9/lib -lc

main.o: ../main.c ../stack.c ../token.c
	$(CMOC) $(CFLAGS) -c ../main.c -o=$@

dictiona.o: ../dictiona.c
	$(CMOC) $(CFLAGS) -c ../dictiona.c -o=$@

basic_fu.o: ../basic_fu.c
	$(CMOC) $(CFLAGS) -c ../basic_fu.c -o=$@

clean:
	rm -f $(OBJS) $(TARGET)

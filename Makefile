.PHONY: all unix coco clean

all: unix coco

unix:
	$(MAKE) -C unix

coco:
	$(MAKE) -C coco

clean:
	$(MAKE) -C unix clean
	$(MAKE) -C coco clean

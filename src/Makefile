PROJECT = iPodMemos

CC = gcc
LD = $(CC)
CFLAGS = -isysroot /User/sysroot \
	 -I/usr/include/gpod-1.0 \
	 -I/usr/include/glib-2.0 \
	 -std=gnu99 \
	 -Wall \
	 -c
LDFLAGS = -isysroot /User/sysroot \
	  -w \
	  -dynamiclib \
	  -lobjc \
	  -lsubstrate \
	  -framework Foundation \
	  -framework UIKit \
	  -framework MFMusicLibrary

OBJECTS = iPodMemos.o DonateDelegate.o TagViewController.o

all: $(OBJECTS)
	$(LD) $(LDFLAGS) -o $(PROJECT).dylib $(OBJECTS)

%.o: %.m
	$(CC) $(CFLAGS) -o $@ $^

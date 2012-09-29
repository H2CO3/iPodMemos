PROJECT = iPodMemos

CC = gcc
LD = $(CC)
CFLAGS = -isysroot /User/sysroot \
	 -Wall \
	 -c
LDFLAGS = -isysroot /User/sysroot \
	  -w \
	  -dynamiclib \
	  -lobjc \
	  -lsubstrate \
	  -lipodimportclient \
	  -framework Foundation \
	  -framework UIKit

OBJECTS = iPodMemos.o DonateDelegate.o TagViewController.o

all: $(OBJECTS)
	$(LD) $(LDFLAGS) -o $(PROJECT).dylib $(OBJECTS)

%.o: %.m
	$(CC) $(CFLAGS) -o $@ $^

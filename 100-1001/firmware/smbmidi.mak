CC = iccavr
CFLAGS =  -IC:\ICC\include\ -e  -l -g -Wa-W 
ASFLAGS = $(CFLAGS)  -Wa-g
LFLAGS =  -LC:\ICC\lib\ -g -Wl-W -bfunc_lit:0x1a.0x2000 -dram_end:0x25f -bdata:0x60.0x25f -dhwstk_size:16 -beeprom:1.512 -fihx_coff -S2
FILES = midi.o spi.o 

smbmidi:	$(FILES)
	$(CC) -o smbmidi $(LFLAGS) @smbmidi.lk 
midi.o: C:/ICC/include/io8515v.h C:/ICC/include/macros.h C:\projects\SynthMod\100-1001\firmware/smb.h C:\projects\SynthMod\100-1001\firmware/midi.h
midi.o:	C:\projects\SynthMod\100-1001\firmware\midi.c
	$(CC) -c $(CFLAGS) C:\projects\SynthMod\100-1001\firmware\midi.c
spi.o: C:/ICC/include/io8515v.h C:/ICC/include/macros.h C:\projects\SynthMod\100-1001\firmware/smb.h
spi.o:	C:\projects\SynthMod\100-1001\firmware\spi.c
	$(CC) -c $(CFLAGS) C:\projects\SynthMod\100-1001\firmware\spi.c

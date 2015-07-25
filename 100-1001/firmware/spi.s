	.module spi.c
	.area text(rom, con, rel)
	.dbfile C:\projects\SynthMod\100-1001\firmware\spi.c
	.dbfunc e InitSPI _InitSPI fV
	.even
_InitSPI::
	.dbline -1
	.dbline 19
; /******************************************************************************
; **
; ** These are the routines for talking to the SPI port
; **
; ** The SPI port will output a 16 bit integer to the DAC
; **  It will then latch the data into the appropriate DAC register
; **
; *******************************************************************************/
; #include <io8515v.h>
; #include <macros.h>
; #include "smb.h"
; 
; /*******************************************************************************
; **
; ** This routine initializes the SPI port and gets it ready for use
; **
; *******************************************************************************/
; void InitSPI(void)
; {
	.dbline 20
; 	DDRB |= 0xb0;	/*	set SS pin to output	*/
	in R24,0x17
	ori R24,176
	out 0x17,R24
	.dbline 21
; 	SPCR = SPI_SPCR_SPE | SPI_SPCR_CPHA | SPI_SPCR_MSTR;	/*	enable SPI port	*/	
	ldi R24,84
	out 0xd,R24
	.dbline 22
; 	MCUCR |= 0x80;	/*	enable external memory	*/
	in R24,0x35
	ori R24,128
	out 0x35,R24
	.dbline -2
	.dbline 23
; }
L1:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e PortFull _PortFull fI
;              a -> R18
;         retval -> R16,R17
	.even
_PortFull::
	.dbline -1
	.dbline 31
; 
; /*******************************************************************************
; ** Wait for data to exit from SPI port
; ** Returns true while data is still transmiting
; *******************************************************************************/
; 
; int PortFull(void)
; {
	.dbline 33
; 	char a;
; 	int retval=0;
	clr R16
	clr R17
	.dbline 34
; 	a = SPSR;
	in R18,0xe
	.dbline 35
; 	if(a & 0x80) retval = 1;
	sbrc R18,7
	.dbline 35
	ldi R16,1
L3:
	.dbline 36
; 	return retval;
	.dbline -2
L2:
	.dbline 0 ; func end
	ret
	.dbsym r a 18 c
	.dbsym r retval 16 I
	.dbend
	.area lit(rom, con, rel)
_DacLUT:
	.word -24576
	.word -23552
	.word -22528
	.word -21504
	.word -20480
	.word -19456
	.word -18432
	.word -17408
	.dbsym s DacLUT _DacLUT A[16:8]kI
	.area text(rom, con, rel)
	.dbfile C:\projects\SynthMod\100-1001\firmware\spi.c
	.dbfunc e SendData _SendData fV
;        convert -> y+0
;           port -> R20,R21
;              d -> R22,R23
	.even
_SendData::
	rcall push_gset2
	mov R20,R18
	mov R21,R19
	mov R22,R16
	mov R23,R17
	sbiw R28,2
	.dbline -1
	.dbline 55
; }
; 
; /*******************************************************************************
; This routine sends data d to DAC port port
; *******************************************************************************/
; static const int DacLUT[8] = {
; 	0xa000,
; 	0xa400,
; 	0xa800,
; 	0xac00,
; 	0xb000,
; 	0xb400,
; 	0xb800,
; 	0xbc00
; };
; 
; 
; void SendData(int d,int port)
; {
	.dbline 60
; 	union {
; 		int v;
; 		char b[2];
; 	}convert;
; 	convert.v = d;
	std y+1,R23
	std y+0,R22
	.dbline 61
; 	SPDR = convert.b[1];	/*	get MSB of data	*/
	ldd R2,y+1
	out 0xf,R2
L8:
	.dbline 62
L9:
	.dbline 62
; 	while(!PortFull());			/*	wait for data to be transmitted	*/
	rcall _PortFull
	cpi R16,0
	cpc R16,R17
	breq L8
X0:
	.dbline 63
; 	SPDR = convert.b[0];			/*	get LSB of data	*/
	ldd R2,y+0
	out 0xf,R2
L11:
	.dbline 64
L12:
	.dbline 64
; 	while(!PortFull());		/*	wait for data to be transmitted	*/
	rcall _PortFull
	cpi R16,0
	cpc R16,R17
	breq L11
X1:
	.dbline 65
; 	*((volatile char *)DacLUT[port]) = 0;	//dummy write to load DAC	*/	
	ldi R24,<_DacLUT
	ldi R25,>_DacLUT
	mov R16,R20
	mov R17,R21
	lsl R16
	rol R17
	add R16,R24
	adc R17,R25
	rcall lpm16
	mov R30,R16
	mov R31,R17
	clr R2
	std z+0,R2
	.dbline -2
	.dbline 66
; }
L5:
	adiw R28,2
	rcall pop_gset2
	.dbline 0 ; func end
	ret
	.dbsym l convert 0 X
	.dbsym r port 20 I
	.dbsym r d 22 I
	.dbend

	.module midi.c
	.area vector(rom, abs)
	.org 20
	rjmp _iTxd
	.org 18
	rjmp _iRxd
	.org 14
	rjmp _iTimer
	.area text(rom, con, rel)
	.dbfile C:\projects\SynthMod\100-1001\firmware\midi.c
	.dbfunc e InitUart _InitUart fV
;              i -> R20,R21
;           baud -> R16,R17
	.even
_InitUart::
	rcall push_gset1
	.dbline -1
	.dbline 32
; /*******************************************************************************
; 	Midi.c
; 
; 	These are the functions that provide the interface to the midi port
; 
; *******************************************************************************/
; 
; #include <io8515v.h>
; #include <macros.h>
; #include "smb.h"
; #include "midi.h"
; 
; #pragma interrupt_handler iTxd:11 
; #pragma interrupt_handler iRxd:iv_UART_RX
; #pragma interrupt_handler iTimer:iv_TIMER0_OVF
; 
; char GateShadow;
; 
; typedef struct {
; 	volatile int head;
; 	volatile int tail;
; 	volatile int nchar;
; 	volatile int size;
; }IODESC;
; 
; volatile IODESC txdesc;
; char txbuff[32];
; volatile IODESC rxdesc;
; char rxbuff[32];
; 
; void InitUart(int baud)
; {
	.dbline 35
; 	int i;
; 
; 	UCR |= 0x18;	/*	enable uart rec and xmit	*/
	in R24,0xa
	ori R24,24
	out 0xa,R24
	.dbline 36
; 	UBRR = baud;
	out 0x9,R16
	.dbline 37
; 	txdesc.head = 0;	/*	initialize transmit descriptor	*/
	clr R2
	clr R3
	sts _txdesc+1,R3
	sts _txdesc,R2
	.dbline 38
; 	txdesc.tail = 0;
	sts _txdesc+2+1,R3
	sts _txdesc+2,R2
	.dbline 39
; 	txdesc.nchar = 0;
	sts _txdesc+4+1,R3
	sts _txdesc+4,R2
	.dbline 40
; 	txdesc.size = 32;
	ldi R24,32
	ldi R25,0
	sts _txdesc+6+1,R25
	sts _txdesc+6,R24
	.dbline 41
; 	rxdesc.head = 0;	/*	initialize receiever descriptor	*/
	sts _rxdesc+1,R3
	sts _rxdesc,R2
	.dbline 42
; 	rxdesc.tail = 0;
	sts _rxdesc+2+1,R3
	sts _rxdesc+2,R2
	.dbline 43
; 	rxdesc.size = 32;
	sts _rxdesc+6+1,R25
	sts _rxdesc+6,R24
	.dbline 44
; 	rxdesc.nchar = 0;
	sts _rxdesc+4+1,R3
	sts _rxdesc+4,R2
	.dbline 45
; 	for(i=0;i<32;++i)
	clr R20
	clr R21
L9:
	.dbline 46
	.dbline 47
	ldi R24,<_txbuff
	ldi R25,>_txbuff
	mov R30,R20
	mov R31,R21
	add R30,R24
	adc R31,R25
	ldi R24,111
	std z+0,R24
	.dbline 48
	ldi R24,<_rxbuff
	ldi R25,>_rxbuff
	mov R30,R20
	mov R31,R21
	add R30,R24
	adc R31,R25
	ldi R24,105
	std z+0,R24
	.dbline 49
L10:
	.dbline 45
	subi R20,255  ; offset = 1
	sbci R21,255
	.dbline 45
	cpi R20,32
	ldi R30,0
	cpc R21,R30
	brlt L9
	.dbline -2
	.dbline 50
; 	{
; 		txbuff[i] = 'o';
; 		rxbuff[i] = 'i';
; 	}
; }
L2:
	rcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r i 20 I
	.dbsym r baud 16 I
	.dbend
	.dbfunc e Disable _Disable fV
	.even
_Disable::
	.dbline -1
	.dbline 53
; 
; void Disable(void)		/*	disable interrupts	*/
; {
	.dbline 54
; 	SREG &= ~0x80;
	bclr 7
	.dbline -2
	.dbline 55
; }
L13:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e Enable _Enable fV
	.even
_Enable::
	.dbline -1
	.dbline 58
; 
; void Enable(void)		/* enable interrupts	*/
; {
	.dbline 59
; 	SREG |= 0x80;		
	bset 7
	.dbline -2
	.dbline 60
; }
L14:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e EnableRxIRQ _EnableRxIRQ fV
	.even
_EnableRxIRQ::
	.dbline -1
	.dbline 63
; 
; void EnableRxIRQ(void)	
; {
	.dbline 67
; 	/**************************
; 	** Enable Receiver interrupts
; 	**************************/
; 	UCR |= 0x80;
	sbi 0xa,7
	.dbline -2
	.dbline 68
; }
L15:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e DisableRxIRQ _DisableRxIRQ fV
	.even
_DisableRxIRQ::
	.dbline -1
	.dbline 71
; 
; void DisableRxIRQ(void)
; {
	.dbline 75
; 	/**************************
; 	** Disable Receirver interrupts
; 	**************************/
; 	UCR &= ~0x80;
	cbi 0xa,7
	.dbline -2
	.dbline 76
; }
L16:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e EnableTxIRQ _EnableTxIRQ fV
	.even
_EnableTxIRQ::
	.dbline -1
	.dbline 79
; 
; void EnableTxIRQ(void)
; {
	.dbline 80
; 	UCR |= 0x20;	/*	enable transmit data register empty interrupt	*/
	sbi 0xa,5
	.dbline -2
	.dbline 81
; }
L17:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e DisableTxIRQ _DisableTxIRQ fV
	.even
_DisableTxIRQ::
	.dbline -1
	.dbline 84
; 
; void DisableTxIRQ(void)
; {
	.dbline 85
; 	UCR &= ~0x20;	/*	disable transmit data register empty interrupt	*/
	cbi 0xa,5
	.dbline -2
	.dbline 86
; }
L18:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e iRxd _iRxd fV
;              c -> R16
	.even
_iRxd::
	st -y,R2
	st -y,R3
	st -y,R4
	st -y,R5
	st -y,R16
	st -y,R24
	st -y,R25
	st -y,R30
	st -y,R31
	in R2,0x3f
	st -y,R2
	.dbline -1
	.dbline 89
; 
; void iRxd(void)
; {
	.dbline 94
; 	/**************************
; 	** Interrupt handler for 
; 	** Receive Interrupts
; 	**************************/
; 	char c = UDR;	/*	read data from receive data reg	*/
	in R16,0xc
	.dbline 95
; 	if(rxdesc.nchar < rxdesc.size)	/*	is there space to put char?	*/
	lds R2,_rxdesc+6
	lds R3,_rxdesc+6+1
	lds R4,_rxdesc+4
	lds R5,_rxdesc+4+1
	cp R4,R2
	cpc R5,R3
	brge L20
	.dbline 96
; 	{
	.dbline 97
; 		rxbuff[rxdesc.head++] = c;	/*	put character into buffer	*/
	lds R2,_rxdesc
	lds R3,_rxdesc+1
	mov R24,R2
	mov R25,R3
	adiw R24,1
	sts _rxdesc+1,R25
	sts _rxdesc,R24
	ldi R24,<_rxbuff
	ldi R25,>_rxbuff
	mov R30,R2
	mov R31,R3
	add R30,R24
	adc R31,R25
	std z+0,R16
	.dbline 98
; 		if(rxdesc.head == rxdesc.size) rxdesc.head = 0;	/*	wrap head pointer	*/
	lds R2,_rxdesc+6
	lds R3,_rxdesc+6+1
	lds R4,_rxdesc
	lds R5,_rxdesc+1
	cp R4,R2
	cpc R5,R3
	brne L24
	.dbline 98
	clr R2
	clr R3
	sts _rxdesc+1,R3
	sts _rxdesc,R2
L24:
	.dbline 99
	lds R24,_rxdesc+4
	lds R25,_rxdesc+4+1
	adiw R24,1
	sts _rxdesc+4+1,R25
	sts _rxdesc+4,R24
	.dbline 100
L20:
	.dbline -2
	.dbline 101
; 		rxdesc.nchar++;	/*	increment character count	*/
; 	}	/*	otherwise, just drop character	*/
; }
L19:
	ld R2,y+
	out 0x3f,R2
	ld R31,y+
	ld R30,y+
	ld R25,y+
	ld R24,y+
	ld R16,y+
	ld R5,y+
	ld R4,y+
	ld R3,y+
	ld R2,y+
	.dbline 0 ; func end
	reti
	.dbsym r c 16 c
	.dbend
	.dbfunc e iTxd _iTxd fV
;              c -> R20
	.even
_iTxd::
	rcall push_lset
	rcall push_gset1
	.dbline -1
	.dbline 104
; 
; void iTxd(void)		/* interrupt handler for uart	*/
; {
	.dbline 107
; 	char c;
; 
; 	c = (char)txbuff[txdesc.tail++];		/*	get character from buffer	*/
	lds R2,_txdesc+2
	lds R3,_txdesc+2+1
	mov R24,R2
	mov R25,R3
	adiw R24,1
	sts _txdesc+2+1,R25
	sts _txdesc+2,R24
	ldi R24,<_txbuff
	ldi R25,>_txbuff
	mov R30,R2
	mov R31,R3
	add R30,R24
	adc R31,R25
	ldd R20,z+0
	.dbline 108
; 	--txdesc.nchar;						/*	one less character to send	*/
	lds R24,_txdesc+4
	lds R25,_txdesc+4+1
	sbiw R24,1
	sts _txdesc+4+1,R25
	sts _txdesc+4,R24
	.dbline 109
; 	if(txdesc.nchar == 0)				/*	is xmit buffer empty?	*/				
	lds R2,_txdesc+4
	lds R3,_txdesc+4+1
	tst R2
	brne L31
	tst R3
	brne L31
X0:
	.dbline 110
; 		DisableTxIRQ();					/*	stop transmitting data	*/
	rcall _DisableTxIRQ
L31:
	.dbline 111
; 	if(txdesc.tail == txdesc.size) txdesc.tail = 0;	/* wrap tail pointer	*/
	lds R2,_txdesc+6
	lds R3,_txdesc+6+1
	lds R4,_txdesc+2
	lds R5,_txdesc+2+1
	cp R4,R2
	cpc R5,R3
	brne L34
	.dbline 111
	clr R2
	clr R3
	sts _txdesc+2+1,R3
	sts _txdesc+2,R2
L34:
	.dbline 112
; 	UDR = c;
	out 0xc,R20
	.dbline -2
	.dbline 113
; }
L28:
	rcall pop_gset1
	rcall pop_lset
	.dbline 0 ; func end
	reti
	.dbsym r c 20 c
	.dbend
	.dbfunc e GetC _GetC fI
;              c -> R20,R21
	.even
_GetC::
	rcall push_gset1
	.dbline -1
	.dbline 116
; 
; int GetC(void)
; {
L40:
	.dbline 123
L41:
	.dbline 123
; 	/*********************************
; 	** Get a character from the UART
; 	** If there is no character, wait
; 	*********************************/
; 	int c;
; 
; 	while(rxdesc.nchar == 0);	/*	wait for character to apear in buffer	*/
	lds R2,_rxdesc+4
	lds R3,_rxdesc+4+1
	tst R2
	brne X1
	tst R3
	breq L40
X1:
	.dbline 124
; 	Disable();			/*	disable interrupts	*/
	rcall _Disable
	.dbline 125
; 	c = (int)rxbuff[rxdesc.tail++];		/*	get character from buffer	*/
	lds R2,_rxdesc+2
	lds R3,_rxdesc+2+1
	mov R24,R2
	mov R25,R3
	adiw R24,1
	sts _rxdesc+2+1,R25
	sts _rxdesc+2,R24
	ldi R24,<_rxbuff
	ldi R25,>_rxbuff
	mov R30,R2
	mov R31,R3
	add R30,R24
	adc R31,R25
	ldd R20,z+0
	clr R21
	.dbline 126
; 	if(rxdesc.tail == rxdesc.size) rxdesc.tail = 0;	/*	wrap tail pointer	*/
	lds R2,_rxdesc+6
	lds R3,_rxdesc+6+1
	lds R4,_rxdesc+2
	lds R5,_rxdesc+2+1
	cp R4,R2
	cpc R5,R3
	brne L45
	.dbline 126
	clr R2
	clr R3
	sts _rxdesc+2+1,R3
	sts _rxdesc+2,R2
L45:
	.dbline 127
; 	rxdesc.nchar--;	/*	decrement number of chars in buffer	*/
	lds R24,_rxdesc+4
	lds R25,_rxdesc+4+1
	sbiw R24,1
	sts _rxdesc+4+1,R25
	sts _rxdesc+4,R24
	.dbline 128
; 	Enable();
	rcall _Enable
	.dbline 129
; 	return c;	/*	return fetched character	*/	
	mov R16,R20
	mov R17,R21
	.dbline -2
L39:
	rcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r c 20 I
	.dbend
	.dbfunc e PutC _PutC fV
;              i -> R20,R21
	.even
_PutC::
	rcall push_gset1
	mov R20,R16
	mov R21,R17
	.dbline -1
	.dbline 133
; }
; 
; void PutC(int i)
; {
L52:
	.dbline 134
L53:
	.dbline 134
; 	while(txdesc.nchar == txdesc.size);	/*	pend on buffer full	*/
	lds R2,_txdesc+6
	lds R3,_txdesc+6+1
	lds R4,_txdesc+4
	lds R5,_txdesc+4+1
	cp R4,R2
	cpc R5,R3
	breq L52
	.dbline 135
; 	Disable();	/*	Disable interrupts	*/
	rcall _Disable
	.dbline 136
; 	txbuff[txdesc.head++] = (char)i;	/*	put data into buffer	*/
	lds R2,_txdesc
	lds R3,_txdesc+1
	mov R24,R2
	mov R25,R3
	adiw R24,1
	sts _txdesc+1,R25
	sts _txdesc,R24
	ldi R24,<_txbuff
	ldi R25,>_txbuff
	mov R30,R2
	mov R31,R3
	add R30,R24
	adc R31,R25
	std z+0,R20
	.dbline 137
; 	if(txdesc.head == txdesc.size) txdesc.head = 0;	/*	wrap head pointer	*/
	lds R2,_txdesc+6
	lds R3,_txdesc+6+1
	lds R4,_txdesc
	lds R5,_txdesc+1
	cp R4,R2
	cpc R5,R3
	brne L57
	.dbline 137
	clr R2
	clr R3
	sts _txdesc+1,R3
	sts _txdesc,R2
L57:
	.dbline 138
; 	if(txdesc.nchar == 0)	/*	first char in buff?	*/
	lds R2,_txdesc+4
	lds R3,_txdesc+4+1
	tst R2
	brne L60
	tst R3
	brne L60
X2:
	.dbline 139
; 		EnableTxIRQ();		/*	start transmit interrupt	*/
	rcall _EnableTxIRQ
L60:
	.dbline 140
; 	txdesc.nchar++;
	lds R24,_txdesc+4
	lds R25,_txdesc+4+1
	adiw R24,1
	sts _txdesc+4+1,R25
	sts _txdesc+4,R24
	.dbline 141
; 	Enable();	/*	enable interrupts	*/	
	rcall _Enable
	.dbline -2
	.dbline 142
; }
L51:
	rcall pop_gset1
	.dbline 0 ; func end
	ret
	.dbsym r i 20 I
	.dbend
	.dbfunc e iTimer _iTimer fV
	.even
_iTimer::
	st -y,R2
	st -y,R24
	in R2,0x3f
	st -y,R2
	.dbline -1
	.dbline 152
	.dbline 156
	ldi R24,224
	out 0x32,R24
	.dbline 157
	lds R24,_Counter
	subi R24,1
	mov R2,R24
	sts _Counter,R2
	tst R24
	brne L65
	.dbline 158
	.dbline 159
	ldi R24,2
	lds R2,_GateShadow
	eor R2,R24
	sts _GateShadow,R2
	.dbline 160
	com R2
	sts 50176,R2
	.dbline 161
	lds R2,_GateShadow
	sts 49152,R2
	.dbline 162
	lds R2,_CRV
	sts _Counter,R2
	.dbline 163
L65:
	.dbline -2
	.dbline 164
; 
; //--------------------------------------------------------------------------
; // Timer STuff...
; //--------------------------------------------------------------------------
; 
; unsigned char Counter;
; unsigned char CRV;
; 
; void iTimer(void)
; {
; 	//-----------------------------------
; 	//timer interrupt handler
; 	//-----------------------------------
; 	TCNT0 = ~31;
; 	if(--Counter == 0)
; 	{
; 		GateShadow ^= 0x02;
; 		LED_PORT = ~GateShadow;
; 		GATE_PORT = GateShadow;
; 		Counter = CRV;
; 	}
; }
L64:
	ld R2,y+
	out 0x3f,R2
	ld R24,y+
	ld R2,y+
	.dbline 0 ; func end
	reti
	.dbend
	.dbfunc e EnableTimerIrq _EnableTimerIrq fV
	.even
_EnableTimerIrq::
	.dbline -1
	.dbline 167
; 
; void EnableTimerIrq(void)
; {
	.dbline 168
; 	TIMSK |= 0x02;	//enable timer interrupt
	in R24,0x39
	ori R24,2
	out 0x39,R24
	.dbline -2
	.dbline 169
; }
L67:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e DisableTimerIrq _DisableTimerIrq fV
	.even
_DisableTimerIrq::
	.dbline -1
	.dbline 172
; 
; void DisableTimerIrq(void)
; {
	.dbline 173
; 	TIMSK &= ~0x02;	//disable timer interrupt
	in R24,0x39
	andi R24,253
	out 0x39,R24
	.dbline -2
	.dbline 174
; }
L68:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e InitTimer _InitTimer fV
	.even
_InitTimer::
	.dbline -1
	.dbline 177
; 
; void InitTimer(void)
; {
	.dbline 178
; 	TCCR0 = 5;	//system clock divided by 1024
	ldi R24,5
	out 0x33,R24
	.dbline 179
; 	TCNT0 = ~31;
	ldi R24,224
	out 0x32,R24
	.dbline 180
; 	Counter = 31;
	ldi R24,31
	sts _Counter,R24
	.dbline 181
; 	CRV = 31;
	sts _CRV,R24
	.dbline -2
	.dbline 182
; }
L69:
	.dbline 0 ; func end
	ret
	.dbend
	.dbfunc e Delay _Delay fV
;              a -> R16
;              b -> R18
	.even
_Delay::
	.dbline -1
	.dbline 186
; 
; 
; void Delay()
; {
	.dbline 189
; 	unsigned char a, b;
; 
; 	for (a = 1; a; a++)
	ldi R16,1
	rjmp L74
L71:
	.dbline 190
	ldi R18,1
	rjmp L78
L75:
	.dbline 190
L76:
	.dbline 190
	inc R18
L78:
	.dbline 190
	tst R18
	brne L75
L72:
	.dbline 189
	inc R16
L74:
	.dbline 189
	tst R16
	brne L71
	.dbline -2
	.dbline 191
; 		for (b = 1; b; b++);
; }
L70:
	.dbline 0 ; func end
	ret
	.dbsym r a 16 c
	.dbsym r b 18 c
	.dbend
	.dbfunc e main _main fI
	.area func_lit(rom, con, rel)
L109:
	.word `L85
	.word `L85
	.word `L85
	.word `L85
	.word `L85
	.word `L85
	.word `L85
	.word `L85
	.word `L101
	.word `L85
	.word `L103
	.word `L85
	.word `L105
	.word `L85
	.word `L85
	.word `L108
	.area text(rom, con, rel)
	.dbfile C:\projects\SynthMod\100-1001\firmware\midi.c
;    currentnote -> R12,R13
;              v -> R14,R15
;       nextnote -> y+12
;           chan -> y+11
;          state -> y+10
;            cmd -> y+9
;              c -> y+8
	.even
_main::
	sbiw R28,14
	.dbline -1
	.dbline 227
; 
; enum {IDLE,NOTE0,NOTE1};
; 
; #define SYSEX			0xf0
; #define SYSCOMUNDEF		0xf1
; #define SYSCOMSONGPOS	0xf2
; #define SYSCOMSONGSEL	0xf3
; #define SYSCOMUNDEF1	0xf4
; #define SYSCOMUNDEF2	0xf5
; #define SYSCOMTUNEREQ	0xf6
; #define SYSEXEND		0xf7
; #define SYSRTCLOCK		0xf8
; #define SYSRTUNDEF		0xf9
; #define SYSRTSTART		0xfa
; #define SYSRTCONTINUE	0xfb
; #define SYSRTSTOP		0xfc
; #define SYSRTUNDEF1		0xfd
; #define SYSRTACTIVESEN	0xfe
; #define SYSRTRESET		0xff
; 
; #define NOTEON	0x90
; #define NOTEOFF	0x80
; #define NOTEPRES	0xa0		//note pressure
; #define CHANPRES	0xb0		//channel pressure
; #define CONTROL	0xd0			//control change
; #define WHEEL	0xe0			//pitch wheel change
; #define PATCH	0xc0			//patch change
; 
; 
; #define MIDI_CLOCK	0x80
; #define MIDI_START	0x40
; #define MIDI_RESET	0x20
; #define MIDI_GATE	0x01
; 
; main()
; {
	.dbline 235
; 	int currentnote,nextnote;
; 	char c;
; 	char cmd;
; 	char chan;
; 	char state;
; 	int v;
; 
; 	InitSPI();		/*	initialize the SPI port	*/
	rcall _InitSPI
	.dbline 236
; 	InitTimer();	//initialize real clock timer
	rcall _InitTimer
	.dbline 237
; 	InitUart(BAUD_MIDI);
	ldi R16,15
	ldi R17,0
	rcall _InitUart
	.dbline 238
; 	EnableRxIRQ();	/*	enable receive interrupt	*/
	rcall _EnableRxIRQ
	.dbline 239
; 	EnableTimerIrq();
	rcall _EnableTimerIrq
	.dbline 240
; 	GateShadow = 0;
	clr R2
	sts _GateShadow,R2
	.dbline 241
; 	GATE_PORT = GateShadow;	/*	set all outputs to zero	*/
	sts 49152,R2
	.dbline 242
; 	LED_PORT = ~GateShadow;
	com R2
	sts 50176,R2
	.dbline 243
; 	Enable();		/*	enable global interrupts	*/
	rcall _Enable
	rjmp L82
L81:
	.dbline 246
; 	
; 	while(1)
; 	{
	.dbline 247
; 		c = GetC();
	rcall _GetC
	std y+8,R16
	.dbline 248
; 		if(c & 0x080)	//is it a command?
	mov R0,R16
	sbrs R16,7
	rjmp L84
	.dbline 249
; 		{
	.dbline 250
; 			if(c < 0x0f0)
	mov R24,R0
	cpi R16,240
	brsh L86
	.dbline 251
; 			{
	.dbline 253
; 				//process this stuff, dispose of everything else
; 				cmd = (char)(c & 0xf0);
	clr R25
	andi R24,240
	andi R25,0
	std y+9,R24
	.dbline 254
; 				chan = (char)(c & 0x0f);
	ldd R24,y+8
	clr R25
	andi R24,15
	andi R25,0
	std y+11,R24
	.dbline 255
; 				if(cmd == NOTEON)
	ldd R24,y+9
	cpi R24,144
	breq X15
	rjmp L85
X15:
	.dbline 256
; 					state = NOTE0;
	clr R0
	inc R0
	std y+10,R0
	.dbline 257
; 			}
	rjmp L85
L86:
	.dbline 259
; 			else
; 			{
	.dbline 260
; 				switch(c)
	ldd R10,y+8
	clr R11
	mov R24,R10
	mov R25,R11
	cpi R24,240
	ldi R30,0
	cpc R25,R30
	brge X16
	rjmp L85
X16:
	ldi R24,255
	cp R24,R10
	cpc R25,R11
	brge X17
	rjmp L85
X17:
	ldi R24,<L109
	ldi R25,>L109
	mov R16,R10
	mov R17,R11
	subi R16,240
	sbci R17,0
	lsl R16
	rol R17
	add R16,R24
	adc R17,R25
	rcall lpm16
	mov R30,R16
	mov R31,R17
	ijmp
X3:
	.dbline 261
; 				{
	.dbline 263
; 					case SYSEX:
; 						break;
	.dbline 265
; 					case SYSCOMUNDEF:
; 						break;
	.dbline 267
; 					case SYSCOMSONGPOS:
; 						break;
	.dbline 269
; 					case SYSCOMSONGSEL:
; 						break;
	.dbline 271
; 					case SYSCOMUNDEF1:
; 						break;
	.dbline 273
; 					case SYSCOMUNDEF2:
; 						break;
	.dbline 275
; 					case SYSCOMTUNEREQ:
; 						break;
	.dbline 277
; 					case SYSEXEND:
; 						break;
L101:
	.dbline 279
; 					case SYSRTCLOCK:
; 						Disable();
	rcall _Disable
	.dbline 280
; 						GateShadow ^= MIDI_CLOCK;	/*	toggle these bits	*/
	ldi R24,128
	ldi R25,0
	lds R2,_GateShadow
	clr R3
	eor R2,R24
	eor R3,R25
	sts _GateShadow,R2
	.dbline 281
; 						GATE_PORT = GateShadow;
	sts 49152,R2
	.dbline 282
; 						LED_PORT = ~GateShadow;
	com R2
	sts 50176,R2
	.dbline 283
; 						Enable();
	rcall _Enable
	.dbline 284
; 						break;
	rjmp L85
X4:
	.dbline 286
; 					case SYSRTUNDEF:
; 						break;
L103:
	.dbline 288
; 					case SYSRTSTART:
; 						Disable();
	rcall _Disable
	.dbline 289
; 						GateShadow |= MIDI_START;
	lds R24,_GateShadow
	ori R24,64
	sts _GateShadow,R24
	.dbline 290
; 						GateShadow &= ~MIDI_RESET;
	andi R24,223
	sts _GateShadow,R24
	.dbline 291
; 						GATE_PORT = GateShadow;
	mov R2,R24
	sts 49152,R2
	.dbline 292
; 						LED_PORT = ~GateShadow;
	com R2
	sts 50176,R2
	.dbline 293
; 						Enable();				
	rcall _Enable
	.dbline 294
; 						break;
	rjmp L85
X5:
	.dbline 296
; 					case SYSRTCONTINUE:
; 						break;
L105:
	.dbline 298
; 					case SYSRTSTOP:
; 						Disable();
	rcall _Disable
	.dbline 299
; 						GateShadow &= ~MIDI_START;
	lds R24,_GateShadow
	andi R24,191
	sts _GateShadow,R24
	.dbline 300
; 						GATE_PORT = GateShadow;
	mov R2,R24
	sts 49152,R2
	.dbline 301
; 						LED_PORT = ~GateShadow;
	com R2
	sts 50176,R2
	.dbline 302
; 						Enable();		
	rcall _Enable
	.dbline 303
; 						break;
	rjmp L85
X6:
	.dbline 305
; 					case SYSRTUNDEF1:
; 						break;
	.dbline 307
; 					case SYSRTACTIVESEN:
; 						break;
L108:
	.dbline 309
; 					case SYSRTRESET:
; 						Disable();
	rcall _Disable
	.dbline 310
; 						GateShadow &= ~MIDI_START;
	lds R24,_GateShadow
	andi R24,191
	sts _GateShadow,R24
	.dbline 311
; 						GateShadow |= MIDI_RESET;
	ori R24,32
	sts _GateShadow,R24
	.dbline 312
; 						GATE_PORT = GateShadow;
	mov R2,R24
	sts 49152,R2
	.dbline 313
; 						LED_PORT = ~GateShadow;
	com R2
	sts 50176,R2
	.dbline 314
; 						Enable();		
	rcall _Enable
	.dbline 315
; 						break;
	.dbline 317
; 				}	//end of swtich(c)
; 			}	//end of if(c < 0xf0)
	.dbline 319
; 
; 		}
	rjmp L85
L84:
	.dbline 321
; 		else	// if(c & 0x080)
; 		{
	.dbline 322
; 			switch(cmd)
	ldd R22,y+9
	clr R23
	cpi R22,176
	ldi R30,0
	cpc R23,R30
	brne X18
	rjmp L111
X18:
	ldi R24,176
	ldi R25,0
	cp R24,R22
	cpc R25,R23
	brlt L154
L153:
	cpi R22,144
	ldi R30,0
	cpc R23,R30
	brne X19
	rjmp L121
X19:
	ldi R24,144
	ldi R25,0
	cp R24,R22
	cpc R25,R23
	brlt L156
L155:
	cpi R22,128
	ldi R30,0
	cpc R23,R30
	breq L113
	rjmp L110
L156:
	cpi R22,160
	ldi R30,0
	cpc R23,R30
	brne X20
	rjmp L133
X20:
	rjmp L110
L154:
	cpi R22,208
	ldi R30,0
	cpc R23,R30
	brne X21
	rjmp L140
X21:
	ldi R24,208
	ldi R25,0
	cp R24,R22
	cpc R25,R23
	brlt L158
L157:
	cpi R22,192
	ldi R30,0
	cpc R23,R30
	brne X22
	rjmp L152
X22:
	rjmp L110
L158:
	cpi R22,224
	ldi R30,0
	cpc R23,R30
	brne X23
	rjmp L146
X23:
	rjmp L110
X7:
	.dbline 323
; 			{
L113:
	.dbline 325
; 				case NOTEOFF:
; 					switch(state)
	ldd R20,y+10
	clr R21
	cpi R20,1
	ldi R30,0
	cpc R21,R30
	breq L117
	cpi R20,2
	ldi R30,0
	cpc R21,R30
	breq L118
	rjmp L111
X8:
	.dbline 326
; 					{
L117:
	.dbline 328
; 						case NOTE0:
; 							nextnote = (int)c << 5;
	ldi R18,5
	ldi R19,0
	ldd R16,y+8
	clr R17
	rcall lsl16
	std y+13,R17
	std y+12,R16
	.dbline 329
; 							state = NOTE1;
	ldi R24,2
	std y+10,R24
	.dbline 330
; 							break;
	rjmp L111
L118:
	.dbline 332
; 						case NOTE1:
; 							if(nextnote == currentnote)
	ldd R0,y+12
	ldd R1,y+13
	cp R0,R12
	cpc R1,R13
	brne L119
	.dbline 333
; 							{
	.dbline 334
; 								Disable();
	rcall _Disable
	.dbline 335
; 								GateShadow &= ~MIDI_GATE;
	lds R24,_GateShadow
	andi R24,254
	sts _GateShadow,R24
	.dbline 336
; 								GATE_PORT = GateShadow;
	mov R2,R24
	sts 49152,R2
	.dbline 337
; 								LED_PORT = ~GateShadow;
	com R2
	sts 50176,R2
	.dbline 338
; 								Enable();
	rcall _Enable
	.dbline 339
; 							}
L119:
	.dbline 340
; 							state = NOTE0;
	clr R0
	inc R0
	std y+10,R0
	.dbline 341
; 							break;
	.dbline 343
; 					}
; 					break;
	rjmp L111
L121:
	.dbline 345
; 				case NOTEON:
; 					switch(state)
	ldd R2,y+10
	clr R3
	std y+1,R3
	std y+0,R2
	mov R24,R2
	mov R25,R3
	cpi R24,1
	ldi R30,0
	cpc R25,R30
	breq L125
	cpi R24,2
	ldi R30,0
	cpc R25,R30
	breq L126
	rjmp L111
X9:
	.dbline 346
; 					{
L125:
	.dbline 348
; 						case NOTE0:
; 							nextnote = (int)c << 5;
	ldi R18,5
	ldi R19,0
	ldd R16,y+8
	clr R17
	rcall lsl16
	std y+13,R17
	std y+12,R16
	.dbline 349
; 							state = NOTE1;
	ldi R24,2
	std y+10,R24
	.dbline 350
; 							break;
	rjmp L111
L126:
	.dbline 352
; 						case NOTE1:
; 							Disable();
	rcall _Disable
	.dbline 353
; 							if(c > 0)
	clr R2
	ldd R0,y+8
	cp R2,R0
	brsh L127
	.dbline 354
; 							{
	.dbline 355
; 								currentnote = nextnote;
	ldd R12,y+12
	ldd R13,y+13
	.dbline 356
; 								SendData(currentnote,0);
	clr R18
	clr R19
	mov R16,R12
	mov R17,R13
	rcall _SendData
	.dbline 357
; 								if(GateShadow & MIDI_GATE)	//is gate already set?
	lds R2,_GateShadow
	sbrs R2,0
	rjmp L129
	.dbline 358
; 								{
	.dbline 359
; 									GateShadow &= ~MIDI_GATE;	//retrigger gate
	mov R24,R2
	andi R24,254
	sts _GateShadow,R24
	.dbline 360
; 									GATE_PORT = GateShadow;
	mov R2,R24
	sts 49152,R2
	.dbline 361
; 									LED_PORT = ~GateShadow;
	com R2
	sts 50176,R2
	.dbline 362
; 								}
L129:
	.dbline 363
; 								GateShadow |= MIDI_GATE;
	lds R24,_GateShadow
	ori R24,1
	sts _GateShadow,R24
	.dbline 364
; 							}
	rjmp L128
L127:
	.dbline 366
; 							else
; 							{
	.dbline 367
; 								if(currentnote == nextnote)
	ldd R0,y+12
	ldd R1,y+13
	cp R12,R0
	cpc R13,R1
	brne L131
	.dbline 368
; 								{
	.dbline 369
; 									GateShadow &= ~MIDI_GATE;
	lds R24,_GateShadow
	andi R24,254
	sts _GateShadow,R24
	.dbline 370
; 								}
L131:
	.dbline 371
; 							}
L128:
	.dbline 372
; 							GATE_PORT = GateShadow;
	lds R2,_GateShadow
	sts 49152,R2
	.dbline 373
; 							LED_PORT = ~GateShadow;
	com R2
	sts 50176,R2
	.dbline 374
; 							Enable();
	rcall _Enable
	.dbline 375
; 							state = NOTE0;
	clr R0
	inc R0
	std y+10,R0
	.dbline 376
; 							break;
	.dbline 378
; 						default:
; 							break;
	.dbline 380
; 					}
; 					break;
	rjmp L111
L133:
	.dbline 382
; 				case NOTEPRES:	//note pressure
; 					switch(state)
	ldd R2,y+10
	clr R3
	std y+3,R3
	std y+2,R2
	mov R24,R2
	mov R25,R3
	cpi R24,1
	ldi R30,0
	cpc R25,R30
	breq L137
	cpi R24,2
	ldi R30,0
	cpc R25,R30
	breq L138
	rjmp L111
X10:
	.dbline 383
; 					{
L137:
	.dbline 385
; 						case NOTE0:
; 							state = NOTE1;
	ldi R24,2
	std y+10,R24
	.dbline 386
; 							break;
	rjmp L111
L138:
	.dbline 388
; 						case NOTE1:
; 							state = NOTE0;
	clr R0
	inc R0
	std y+10,R0
	.dbline 389
; 							break;
	.dbline 391
; 					}
; 					break;
	rjmp L111
X11:
	.dbline 393
; 				case CHANPRES:		//channel pressure
; 					break;
L140:
	.dbline 395
; 				case CONTROL:			//control change
; 					switch(state)
	ldd R2,y+10
	clr R3
	std y+5,R3
	std y+4,R2
	mov R24,R2
	mov R25,R3
	cpi R24,1
	ldi R30,0
	cpc R25,R30
	breq L144
	cpi R24,2
	ldi R30,0
	cpc R25,R30
	breq L145
	rjmp L111
X12:
	.dbline 396
; 					{
L144:
	.dbline 398
; 						case NOTE0:
; 							state = NOTE1;
	ldi R24,2
	std y+10,R24
	.dbline 399
; 							break;
	rjmp L111
L145:
	.dbline 401
; 						case NOTE1:
; 							state = NOTE0;
	clr R0
	inc R0
	std y+10,R0
	.dbline 402
; 							break;
	.dbline 404
; 					}
; 					break;
	rjmp L111
L146:
	.dbline 406
; 				case WHEEL:			//pitch wheel change
; 					switch(state)
	ldd R2,y+10
	clr R3
	std y+7,R3
	std y+6,R2
	mov R24,R2
	mov R25,R3
	cpi R24,1
	ldi R30,0
	cpc R25,R30
	breq L150
	cpi R24,2
	ldi R30,0
	cpc R25,R30
	breq L151
	rjmp L111
X13:
	.dbline 407
; 					{
L150:
	.dbline 409
; 						case NOTE0:
; 							v = ((int)c);
	ldd R14,y+8
	clr R15
	.dbline 410
; 							state = NOTE1;
	ldi R24,2
	std y+10,R24
	.dbline 411
; 							break;
	rjmp L111
L151:
	.dbline 413
; 						case NOTE1:
; 							v |= ((int)c)<<7;
	ldi R18,7
	ldi R19,0
	ldd R16,y+8
	clr R17
	rcall lsl16
	or R14,R16
	or R15,R17
	.dbline 414
; 							v >>= 2;	//12 bits;
	asr R15
	ror R14
	asr R15
	ror R14
	.dbline 416
; 			//				v ^= 0x0800;
; 							SendData(v,1);
	ldi R18,1
	ldi R19,0
	mov R16,R14
	mov R17,R15
	rcall _SendData
	.dbline 417
; 							state = NOTE0;
	clr R0
	inc R0
	std y+10,R0
	.dbline 418
; 							break;
	.dbline 420
; 					}
; 					break;
	rjmp L111
L152:
	.dbline 422
; 				case PATCH:			//patch change
; 					state = NOTE0;
	clr R0
	inc R0
	std y+10,R0
	.dbline 423
; 					break;
L110:
L111:
	.dbline 425
; 			}	//end of switch(cmd)
; 		}	//end of if(c & 0x080)
L85:
	.dbline 427
L82:
	.dbline 245
	rjmp L81
X14:
	.dbline 428
; 
; 	}	//end of while(1) loop
; 	return 0;
	clr R16
	clr R17
	.dbline -2
L80:
	adiw R28,14
	.dbline 0 ; func end
	ret
	.dbsym r currentnote 12 I
	.dbsym r v 14 I
	.dbsym l nextnote 12 I
	.dbsym l chan 11 c
	.dbsym l state 10 c
	.dbsym l cmd 9 c
	.dbsym l c 8 c
	.dbend
	.area bss(ram, con, rel)
	.dbfile C:\projects\SynthMod\100-1001\firmware\midi.c
_CRV::
	.blkb 1
	.dbsym e CRV _CRV c
_Counter::
	.blkb 1
	.dbsym e Counter _Counter c
_rxbuff::
	.blkb 32
	.dbsym e rxbuff _rxbuff A[32:32]c
_rxdesc::
	.blkb 8
	.dbsym e rxdesc _rxdesc X
_txbuff::
	.blkb 32
	.dbsym e txbuff _txbuff A[32:32]c
_txdesc::
	.blkb 8
	.dbsym e txdesc _txdesc X
_GateShadow::
	.blkb 1
	.dbsym e GateShadow _GateShadow c

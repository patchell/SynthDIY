/***************************************************************
	Midi.H	

	This is the header file for the MIDI driver interface

	Open(void)		initializes midi port
	GetC(void)		gets character from midi buffer
	PutC(int c)	puts a character to midi buffer
	StatusIn(void)	gets number of chars in buffer
	StatusOut(void)	gets number of chars left to transmit

	This code is copyright(c) 2002 by Jim Patchell
	However, anyone is free to use this as they see fit, as long
	as this text remains in the source code
*******************************************************************************/

#ifndef MIDI__H
#define MIDI__H

extern void InitUart(int baud);	/*	initialize UART		*/
extern void Disable(void);		/*	disable interrupts	*/
extern void Enable(void);		/* enable interrupts	*/
extern void EnableRxIRQ(void);	/* enable reciever interrupt	*/	
extern void DisableRxIRQ(void);	/*	disable reciever interrupt	*/
extern void EnableTxIRQ(void);	/*	enable transmitter interrupt	*/
extern void DisableTxIRQ(void);	/*	disable transmitter interrupt	*/
extern int GetC(void);			/*	get character from midi port in	*/
extern void PutC(int i);		/*	send character to midi port out	*/


#endif
																															
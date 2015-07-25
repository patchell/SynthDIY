NOTE: AVR Code addresses are word addresses
All other addresses (including ones in FLASH) are byte addresses

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                        func_lit   001A   0020 =     32. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       001A  __func_lit_start
       003A  __func_lit_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             lit   003A   0010 =     16. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       003A  __lit_start
       004A  __lit_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                            text   004A   07C8 =   1992. bytes (rel,con,rom)

       Addr  Global Symbol
      -----  --------------------------------
       0025  __text_start
       0025  __start
       0044  _exit
       0045  _InitUart
       0088  _Disable
       008A  _Enable
       008C  _EnableRxIRQ
       008E  _DisableRxIRQ
       0090  _EnableTxIRQ
       0092  _DisableTxIRQ
       0094  _iRxd
       00E3  _iTxd
       011E  _GetC
       015A  _PutC
       01A1  _iTimer
       01C5  _EnableTimerIrq
       01C9  _DisableTimerIrq
       01CD  _InitTimer
       01D7  _Delay
       01E2  _main
       0377  _InitSPI
       0380  _PortFull
       0386  _SendData
       03AA  pop_gset2
       03AC  push_gset1
       03AF  pop_gset1
       03B0  pop
       03C3  push_gset2
       03C6  lpm16
       03D4  push_lset
       03EB  pop_lset
       0402  lsl16
       0409  __text_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                             bss   0060   0053 =     83. bytes (rel,con,ram)

       Addr  Global Symbol
      -----  --------------------------------
       0060  __bss_start
       0060  _CRV
       0061  _Counter
       0062  _rxbuff
       0082  _rxdesc
       008A  _txbuff
       00AA  _txdesc
       00B2  _GateShadow
       00B3  __bss_end

Area                               Addr   Size   Decimal Bytes (Attributes)
--------------------------------   ----   ----   ------- ----- ------------
                          vector   0000   0010 =     16. bytes (abs,ovr,rom)

Files Linked      [ module(s) ]

C:\ICC\lib\crtAVR.o	[ crtavr.s ]
midi.o	[ midi.c ]
spi.o	[ spi.c ]
<library>	[ gpop2.s, gpush.s, gpush2.s, lpm16.s, lpush.s, lsl16.s ]

User Global Definitions

ram_end = 0x25f
hwstk_size = 0x10

User Base Address Definitions

func_lit = 0x1a
data = 0x60
eeprom:1.512


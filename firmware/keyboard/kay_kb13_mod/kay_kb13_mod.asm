; kay_kb13_mod v1.0
; Modified firmware (KB13 by CARO) for KAY1024 PS/2 keyboard controller
; z00m 03/2023
; syntax for sjasmplus

; FUSES for ATMega48PA 20MHz / MiniPRO / TL866 programmer
; ----------------------
; Name      | checkbox |
; ----------------------
; CKSEL0    |    off   |
; CKSEL1    |    off   |
; CKSEL2    |    off   |
; CKSEL3    |    off   |
; SUT0      |    on    |
; SUT1      |    off   |
; CKOUT     |    off   |
; CKDIV8    |    off   |
; BODLEVEL0 |    on    |
; BODLEVEL1 |    on    |
; BODLEVEL2 |    off   |
; EESAVE    |    off   |
; WDTON     |    off   |
; SPIEN     |    on    |
; DWEN      |    off   |
; RSTDISBL  |    off   |
; SELFPRGEN |    off   |
; ----------------------

	device	zxspectrum48
	
	org	0
	
start:
	incbin	"kay_kb13.dmp"	; original firmware with really dumb keyb layout
				; (or dumb for me at least)

; both SHIFTs are hardcoded to SYMBOL SHIFT by default 
; make left CTRL to act as SYMBOL SHIFT at least, so left SHIFT can be mapped
; to CAPS SHIFT as supposed to be
	org	#270
	db	#94		; change hardcoded LSHIFT to LCTRL 
	
	org	#2EA
	db	#94		; change hardcoded LSHIFT to LCTRL


; virtual keyboard matrix	
	org	#800
	
D0	equ	#01
D1	equ	#02
D2	equ	#03
D3	equ	#04
D4	equ	#05

A08	equ	#00
A09	equ	#08
A10	equ	#10
A11	equ	#18
A12	equ	#20
A13	equ	#28
A14	equ	#30
A15	equ	#38

CS	equ	#80	;Caps Shift switch
SS	equ	#40	;Symbol Shift switch
EX	equ	#C0	;dedicated extra keys

Kl_1	equ	A11+D0
Kl_2	equ	A11+D1
Kl_3	equ	A11+D2
Kl_4	equ	A11+D3
Kl_5	equ	A11+D4

Kl_6	equ	A12+D4
Kl_7	equ	A12+D3
Kl_8	equ	A12+D2
Kl_9	equ	A12+D1
Kl_0	equ	A12+D0

Kl_Q	equ	A10+D0
Kl_W	equ	A10+D1
Kl_E	equ	A10+D2
Kl_R	equ	A10+D3
Kl_T	equ	A10+D4

Kl_Y	equ	A13+D4
Kl_U	equ	A13+D3
Kl_I	equ	A13+D2
Kl_O	equ	A13+D1
Kl_P	equ	A13+D0

Kl_A	equ	A09+D0
Kl_S	equ	A09+D1
Kl_D	equ	A09+D2
Kl_F	equ	A09+D3
Kl_G	equ	A09+D4

Kl_H	equ	A14+D4
Kl_J	equ	A14+D3
Kl_K	equ	A14+D2
Kl_L	equ	A14+D1
Kl_CR	equ	A14+D0  ;Enter

Kl_CS	equ	A08+D0  ;Caps Shift
Kl_Z	equ	A08+D1
Kl_X	equ	A08+D2
Kl_C	equ	A08+D3
Kl_V	equ	A08+D4

Kl_B	equ	A15+D4
Kl_N	equ	A15+D3
Kl_M	equ	A15+D2
Kl_SS	equ	A15+D1  ;Symbol Shift
Kl_Sp	equ	A15+D0	;Space

; scan code 2 table
; #00 = disabled
; #FF = enabled, not defined

; *Function keys mapped for iSDOS EDIT program
; **HOME / END / WIN mapped for iSDOS Commander
	db	#00		;00h
	db	CS+Kl_9		;01h+	F9	*end of line (CS+9)
	db	#00		;02h
	db	CS+Kl_5		;03h+	F5	*character to the left (CS+5)
	db	CS+Kl_3		;04h+	F3	*INS / OVR (CS+3)
	db	CS+Kl_1		;05h+	F1	*RUS / LAT (CS+1)
	db	CS+Kl_2		;06h+	F2	*upper case / lower case (CS+2)
	db	#00		;07h+	F12		reserved for NMI
	db	CS+Kl_7		;08h+	F7	*line up (CS+7)		
	db	SS+Kl_CR	;09h+	F10	*block operations (SS+ENTER)
	db	CS+Kl_8		;0Ah+	F8	*character to the right (CS+8)
	db	CS+Kl_6		;0Bh+	F6	*line down (CS+6)
	db	CS+Kl_4		;0Ch+	F4	*to the beginning of line (CS+4)
	db	CS+Kl_1		;0Dh+	Tab		EDIT (CS+1)
	db	EX+0		;0Eh+	`~ 
	db	#00		;0Fh

	db	#00		;10h
	db	CS+Kl_SS	;11h+	Left Alt	EXTEND MODE (CS+SS)
	db	Kl_CS		;12h+	Left Shift	CAPS SHIFT
	db	#00		;13h
	db	#00		;14h+	Left Ctrl	SYMBOL SHIFT (hardcoded)
	db	Kl_Q		;15h+	Q		Q
	db	Kl_1		;16h+	1		1
	db	#00		;17h
	db	#00		;18h
	db	#00		;19h
	db	Kl_Z		;1Ah+	Z		Z
	db	Kl_S		;1Bh+	S		S
	db	Kl_A		;1Ch+	A		A
	db	Kl_W		;1Dh+	W		W
	db	Kl_2		;1Eh+	2		2
	db	#00		;1Fh

	db	#00		;20h
	db	Kl_C		;21h+	C		C
	db	Kl_X		;22h+	X		X
	db	Kl_D		;23h+	D		D
	db	Kl_E		;24h+	E		E
	db	Kl_4		;25h+	4		4
	db	Kl_3		;26h+	3		3
	db	#00		;27h
	db	#00		;28h
	db	Kl_Sp		;29h+	Space		SPACE
	db	Kl_V		;2Ah+	V		V
	db	Kl_F		;2Bh+	F		F
	db	Kl_T		;2Ch+	T		T
	db	Kl_R		;2Dh+	R		R
	db	Kl_5		;2Eh+	5		5
	db	#00		;2Fh

	db	#00		;30h
	db	Kl_N		;31h+	N		N
	db	Kl_B		;32h+	B		B
	db	Kl_H		;33h+	H		H
	db	Kl_G		;34h+	G		G
	db	Kl_Y		;35h+	Y		Y
	db	Kl_6		;36h+	6		6
	db	#00		;37h
	db	#00		;38h
	db	#00		;39h
	db	Kl_M		;3Ah+	M		M
	db	Kl_J		;3Bh+	J		J
	db	Kl_U		;3Ch+	U		U
	db	Kl_7		;3Dh+	7		7
	db	Kl_8		;3Eh+	8		8
	db	#00		;3Fh

	db	#00		;40h
	db	EX+1		;41h+	,<		, < (SS+N / SS+R)
	db	Kl_K		;42h+	K		K
	db	Kl_I		;43h+	I		I
	db	Kl_O		;44h+	O		O
	db	Kl_0		;45h+	0		0
	db	Kl_9		;46h+	9		9
	db	#00		;47h
	db	#00		;48h
	db	EX+2		;49h+	.>		. > (SS+M / SS+T)
	db	EX+3		;4Ah+	/?		/ ? (SS+V / SS+C)
	db	Kl_L		;4Bh+	L		L
	db	EX+4		;4Ch+	;:		; : (SS+O / SS+Z)
	db	Kl_P		;4Dh+	P		P
	db	EX+5		;4Eh+	-_		- _ (SS+J / SS+0)
	db	#00		;4Fh

	db	#00		;50h
	db	#00		;51h
	db	EX+6		;52h+	'"		' " (SS+7 / SS+P)
	db	#00		;53h
	db	EX+7		;54h+	[{		[ { (SS+Y / SS+F)***
	db	EX+8		;55h+	=+		= + (SS+L / SS+K)
	db	#00		;56h
	db	#00		;57h
	db	CS+Kl_2		;58h+	Caps Lock	CAPS LOCK (CS+2)
	db	#00		;59h+ 	Right Shift	SYMBOL SHIFT (hardcoded)
	db	Kl_CR		;5Ah+	ENTER		ENTER
	db	EX+9		;5Bh+	]}		] } (SS+Kl_U,SS+Kl_G)***
	db	#00		;5Ch
	db	EX+10		;5Dh+	\|		\ | (SS+Kl_D,SS+Kl_S)***
	db	#00		;5Eh
	db	#00		;5Fh

	db	#00		;60h
	db	#00		;61h
	db	#00		;62h
	db	#00		;63h
	db	#00		;64h
	db	#00		;65h
	db	CS+Kl_0		;66h+	BackSpace	DELETE (CS+0)
	db	#00		;67h
	db	#00		;68h
	db	Kl_1		;69h+	[1]		1
	db	#00		;6Ah
	db	Kl_4		;6Bh+	[4]		4
	db	Kl_7		;6Ch+	[7]		7
	db	#00		;6Dh
	db	#00		;6Eh
	db	#00		;6Fh

	db	Kl_0		;70h+	[0]		0
	db	SS+Kl_M		;71h+	[.]		. (SS+M)
	db	Kl_2		;72h+	[2]		2
	db	Kl_5		;73h+	[5]		5
	db	Kl_6		;74h+	[6]		6
	db	Kl_8		;75h+	[8]		8
	db	CS+Kl_Sp	;76h+	ESC		BREAK (CS+SPACE)
	db	#00		;77h+	Num Lock	reserved
	db	SS+Kl_Sp	;78h+	F11	*command menu (SS+SPACE)
	db	SS+Kl_K		;79h+	[+]		+ (SS+K)
	db	Kl_3		;7Ah+	[3]		3
	db	SS+Kl_J		;7Bh+	[-]		- (SS+J)
	db	SS+Kl_B		;7Ch+	[*]		* (SS+B)
	db	Kl_9		;7Dh+	[9]		9
	db	#00		;7Eh+	Scroll Lock 	reserved for TURBO
	db	#00		;7Fh

; prefix E0:
	db	#00		;00h
	db	#00		;01h
	db	#00		;02h
	db	#00		;03h
	db	#00		;04h
	db	#00		;05h
	db	#00		;06h
	db	#00		;07h
	db	#00		;08h
	db	#00		;09h
	db	#00		;0Ah
	db	#00		;0Bh
	db	#00		;0Ch
	db	#00		;0Dh
	db	#00		;0Eh
	db	#00		;0Fh

	db	#00		;10h
	db	CS+Kl_SS	;11h+	R Alt		EXTEND MODE (CS+SS)
	db	#00		;12h+	Print Screen 	reserved for RESET
	db	#00		;13h
	db	Kl_CS		;14h+	R Ctrl		CAPS SHIFT
	db	#00		;15h
	db	#00		;16h
	db	#00		;17h
	db	#00		;18h
	db	#00		;19h
	db	#00		;1Ah
	db	#00		;1Bh
	db	#00		;1Ch
	db	#00		;1Dh
	db	#00		;1Eh
	db	CS+Kl_CR	;1Fh+	Left Win	**root dir (CS+ENTER)

	db	#00		;20h
	db	#00		;21h
	db	#00		;22h
	db	#00		;23h
	db	#00		;24h
	db	#00		;25h
	db	#00		;26h
	db	CS+Kl_CR	;27h+	Right Win 	**root dir (CS+ENTER)
	db	#00		;28h
	db	#00		;29h
	db	#00		;2Ah
	db	#00		;2Bh
	db	#00		;2Ch
	db	#00		;2Dh
	db	#00		;2Eh
	db	#00		;2Fh+	Win Menu

	db	#00		;30h
	db	#00		;31h
	db	#00		;32h
	db	#00		;33h
	db	#00		;34h
	db	#00		;35h
	db	#00		;36h
	db	#00		;37h+	[Power]
	db	#00		;38h
	db	#00		;39h
	db	#00		;3Ah
	db	#00		;3Bh
	db	#00		;3Ch
	db	#00		;3Dh
	db	#00		;3Eh
	db	#00		;3Fh+	[Sleep]

	db	#00		;40h
	db	#00		;41h
	db	#00		;42h
	db	#00		;43h
	db	#00		;44h
	db	#00		;45h
	db	#00		;46h
	db	#00		;47h
	db	#00		;48h
	db	#00		;49h
	db	SS+Kl_V		;4Ah+	[/]		/ (SS+V)
	db	#00		;4Bh
	db	#00		;4Ch
	db	#00		;4Dh
	db	#00		;4Eh
	db	#00		;4Fh

	db	#00		;50h
	db	#00		;51h
	db	#00		;52h
	db	#00		;53h
	db	#00		;54h
	db	#00		;55h
	db	#00		;56h
	db	#00		;57h
	db	#00		;58h
	db	#00		;59h
	db	Kl_CR		;5Ah+	[Enter]		ENTER
	db	#00		;5Bh
	db	#00		;5Ch
	db	#00		;5Dh
	db	#00		;5Eh+	[Wake Up]
	db	#00		;5Fh

	db	#00		;60h
	db	#00		;61h
	db	#00		;62h
	db	#00		;63h
	db	#00		;64h
	db	#00		;65h
	db	#00		;66h
	db	#00		;67h
	db	#00		;68h
	db	CS+Kl_A		;69h+	[End]	**end of dir (CS+A)
	db	#00		;6Ah
	db	CS+Kl_5		;6Bh+	[Left]		CURSOR LEFT (CS+5)
	db	CS+Kl_Q		;6Ch+	[Home]	**beginning of dir (CS+Q)
	db	#00		;6Dh
	db	#00		;6Eh
	db	#00		;6Fh

	db	CS+Kl_9		;70h+	[Insert]	GRAPH MODE (CS+9)
	db	CS+Kl_0		;71h+	[Del]		DELETE (CS+0)
	db	CS+Kl_6		;72h+	[Down]		CURSOR DOWN (CS+6)
	db	#00		;73h
	db	CS+Kl_8		;74h+	[Right]		CURSOR RIGHT (CS+8)
	db	CS+Kl_7		;75h+	[Up]		CURSOR UP (CS+7)
	db	#00		;76h
	db	#00		;77h
	db	#00		;78h
	db	#00		;79h
	db	CS+Kl_4		;7Ah+	[Pg Down]	INV VIDEO (CS+4)
	db	#00		;7Bh
	db	#00		;7Ch
	db	CS+Kl_3		;7Dh+	[Pg Up]		TRUE VIDEO (CS+3)
	db	#00		;7Eh
	db	#00		;7Fh

; extra keys
; ***EXTEND MODE required for some of them
; 	db	without SHIFT, with SHIFT

	db	SS+Kl_H,SS+Kl_X		;EX+0		^ L
	db	SS+Kl_N,SS+Kl_R		;EX+1		, <
	db	SS+Kl_M,SS+Kl_T		;EX+2		. >
	db	SS+Kl_V,SS+Kl_C		;EX+3		/ ?
	db	SS+Kl_O,SS+Kl_Z		;EX+4		; :
	db	SS+Kl_J,SS+Kl_0		;EX+5		- _
	db	SS+Kl_7,SS+Kl_P		;EX+6		' "
	db	SS+Kl_Y,SS+Kl_F		;EX+7		[ {	***
	db	SS+Kl_L,SS+Kl_K		;EX+8		= +
	db	SS+Kl_U,SS+Kl_G		;EX+9		] }	***
	db	SS+Kl_D,SS+Kl_S		;EX+10		\ |	***
	db	#00,#00			;EX+11		not used
	db	#00,#00			;EX+12		not used
	db	#00,#00			;EX+13		not used
	db	#00,#00			;EX+14		not used
	db	#00,#00			;EX+15		not used
	db	#00,#00			;EX+16		not used

; can be used to remap keys
; this remaps ")" to "(" and "_" to ")" on keys 9 & 0 with SHIFT
;	db	Kl_9,SS+Kl_8
;	db	Kl_0,SS+Kl_9


	savebin "kay_kb13_mod.bin",start,#1000-start

	
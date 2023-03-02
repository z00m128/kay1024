
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;pm683.c,36 :: 		void interrupt()
;pm683.c,38 :: 		ptmr = ptmr + 1;        // Счетчик ~0,1 сек.
	INCF       _ptmr+0, 1
	BTFSC      STATUS+0, 2
	INCF       _ptmr+1, 1
;pm683.c,39 :: 		asm clrwdt;
	CLRWDT
;pm683.c,40 :: 		TMR1H = 0x3C;
	MOVLW      60
	MOVWF      TMR1H+0
;pm683.c,41 :: 		TMR1L = 0xB0;
	MOVLW      176
	MOVWF      TMR1L+0
;pm683.c,42 :: 		PIR1.TMR1IF = 0;
	BCF        PIR1+0, 0
;pm683.c,43 :: 		}
L__interrupt47:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;pm683.c,45 :: 		void main()
;pm683.c,52 :: 		ANSEL = 0;
	CLRF       ANSEL+0
;pm683.c,53 :: 		OPTION_REG = 143;                   // Резисторы выключены WDT 1:128
	MOVLW      143
	MOVWF      OPTION_REG+0
;pm683.c,54 :: 		GPIO = 0;
	CLRF       GPIO+0
;pm683.c,55 :: 		VRCON = 0;
	CLRF       VRCON+0
;pm683.c,56 :: 		CMCON0 = 7;                         // компаратор выключен
	MOVLW      7
	MOVWF      CMCON0+0
;pm683.c,57 :: 		CMCON1 = 7;
	MOVLW      7
	MOVWF      CMCON1+0
;pm683.c,58 :: 		TRISIO = 248;                       // GP0, GP1 и GP2 - выходы, остальные вход
	MOVLW      248
	MOVWF      TRISIO+0
;pm683.c,59 :: 		asm clrwdt;
	CLRWDT
;pm683.c,60 :: 		T1CON = 17;                         // TMR1 включен, предделитель 1:2
	MOVLW      17
	MOVWF      T1CON+0
;pm683.c,61 :: 		INTCON = 192;                       // Прерывания разрешены
	MOVLW      192
	MOVWF      INTCON+0
;pm683.c,62 :: 		TMR1H = 0x3C;
	MOVLW      60
	MOVWF      TMR1H+0
;pm683.c,63 :: 		TMR1L = 0xB0;
	MOVLW      176
	MOVWF      TMR1L+0
;pm683.c,64 :: 		PIR1.TMR1IF = 0;
	BCF        PIR1+0, 0
;pm683.c,65 :: 		PIE1 = 1;
	MOVLW      1
	MOVWF      PIE1+0
;pm683.c,66 :: 		ptmr = 0;
	CLRF       _ptmr+0
	CLRF       _ptmr+1
;pm683.c,67 :: 		kn = 0;
	CLRF       _kn+0
;pm683.c,68 :: 		pstop = 1;
	MOVLW      1
	MOVWF      _pstop+0
;pm683.c,69 :: 		errstop = 1;
	MOVLW      1
	MOVWF      _errstop+0
;pm683.c,70 :: 		PS_ON = 0;
	BCF        GPIO+0, 0
;pm683.c,76 :: 		do
L_main0:
;pm683.c,78 :: 		do
L_main3:
;pm683.c,80 :: 		asm clrwdt;
	CLRWDT
;pm683.c,81 :: 		Error = 0;
	BCF        GPIO+0, 1
;pm683.c,82 :: 		if (button == 0 && Ext_ON == 0)               // Цикл "моргания" светодиодом
	BTFSC      GPIO+0, 4
	GOTO       L_main8
	BTFSC      GPIO+0, 5
	GOTO       L_main8
L__main46:
;pm683.c,85 :: 		if (ptmr < 1) Pwr_LED = 1;                // включили светодиод
	MOVLW      0
	SUBWF      _ptmr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main48
	MOVLW      1
	SUBWF      _ptmr+0, 0
L__main48:
	BTFSC      STATUS+0, 0
	GOTO       L_main9
	BSF        GPIO+0, 2
L_main9:
;pm683.c,86 :: 		if (ptmr > 1 && ptmr <= 15) Pwr_LED = 0;  // выключили светодиод
	MOVF       _ptmr+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main49
	MOVF       _ptmr+0, 0
	SUBLW      1
L__main49:
	BTFSC      STATUS+0, 0
	GOTO       L_main12
	MOVF       _ptmr+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main50
	MOVF       _ptmr+0, 0
	SUBLW      15
L__main50:
	BTFSS      STATUS+0, 0
	GOTO       L_main12
L__main45:
	BCF        GPIO+0, 2
L_main12:
;pm683.c,87 :: 		if (ptmr > 15) ptmr = 0;
	MOVF       _ptmr+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main51
	MOVF       _ptmr+0, 0
	SUBLW      15
L__main51:
	BTFSC      STATUS+0, 0
	GOTO       L_main13
	CLRF       _ptmr+0
	CLRF       _ptmr+1
L_main13:
;pm683.c,88 :: 		}
	GOTO       L_main14
L_main8:
;pm683.c,91 :: 		delay_ms(35);                             // антидребезговая задержка
	MOVLW      46
	MOVWF      R12+0
	MOVLW      115
	MOVWF      R13+0
L_main15:
	DECFSZ     R13+0, 1
	GOTO       L_main15
	DECFSZ     R12+0, 1
	GOTO       L_main15
;pm683.c,92 :: 		if (button != 0 || Ext_ON != 0)           // врубаем питание
	BTFSC      GPIO+0, 4
	GOTO       L__main44
	BTFSC      GPIO+0, 5
	GOTO       L__main44
	GOTO       L_main18
L__main44:
;pm683.c,94 :: 		pstop = 0;
	CLRF       _pstop+0
;pm683.c,95 :: 		PS_ON = 1;                            // влкючаем БП
	BSF        GPIO+0, 0
;pm683.c,96 :: 		Pwr_LED = 1;                          // включаем светодиод (PowerON)
	BSF        GPIO+0, 2
;pm683.c,97 :: 		}
L_main18:
;pm683.c,98 :: 		}
L_main14:
;pm683.c,100 :: 		while (pstop);
	MOVF       _pstop+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main3
;pm683.c,102 :: 		delay_ms(Pwr_OK_time);                            // Задержка на включение БП
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main19:
	DECFSZ     R13+0, 1
	GOTO       L_main19
	DECFSZ     R12+0, 1
	GOTO       L_main19
	DECFSZ     R11+0, 1
	GOTO       L_main19
	NOP
	NOP
;pm683.c,103 :: 		pstop = 1;                                        // ожидаем сигнал "PowerGood" от БП
	MOVLW      1
	MOVWF      _pstop+0
;pm683.c,105 :: 		do                                                // Цикл генерации сигнала ошибки
L_main20:
;pm683.c,107 :: 		asm clrwdt;
	CLRWDT
;pm683.c,108 :: 		if (Pwr_OK == 0)                              // ошибка питания
	BTFSC      GPIO+0, 3
	GOTO       L_main23
;pm683.c,110 :: 		PS_ON = 0;                                // вырубаем питание БП
	BCF        GPIO+0, 0
;pm683.c,111 :: 		Pwr_LED = 0;                              // вырубаем светодиод Включения
	BCF        GPIO+0, 2
;pm683.c,112 :: 		Error = 1;                                // Зажигаем светодиод "ошибка"
	BSF        GPIO+0, 1
;pm683.c,113 :: 		pstop = 0;
	CLRF       _pstop+0
;pm683.c,114 :: 		errstop = 0;
	CLRF       _errstop+0
;pm683.c,115 :: 		}
L_main23:
;pm683.c,116 :: 		if (button != 0 && kn == 0)                   // цикл выключения
	BTFSS      GPIO+0, 4
	GOTO       L_main26
	MOVF       _kn+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main26
L__main43:
;pm683.c,119 :: 		kn = 1;
	MOVLW      1
	MOVWF      _kn+0
;pm683.c,120 :: 		ptmr = 0;
	CLRF       _ptmr+0
	CLRF       _ptmr+1
;pm683.c,121 :: 		}
L_main26:
;pm683.c,122 :: 		if (button != 0 && ptmr > off_time)           // кнопка нажата более 2 сек.
	BTFSS      GPIO+0, 4
	GOTO       L_main29
	MOVF       _ptmr+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main52
	MOVF       _ptmr+0, 0
	SUBLW      20
L__main52:
	BTFSC      STATUS+0, 0
	GOTO       L_main29
L__main42:
;pm683.c,124 :: 		pstop = 0;
	CLRF       _pstop+0
;pm683.c,125 :: 		PS_ON = 0;                                // вырубаем питание БП
	BCF        GPIO+0, 0
;pm683.c,126 :: 		Pwr_LED = 0;                              // выключаем светодиод (PowerON)
	BCF        GPIO+0, 2
;pm683.c,127 :: 		Error = 0;                                // ну, это не обязательно, он и так в "0"
	BCF        GPIO+0, 1
;pm683.c,128 :: 		do
L_main30:
;pm683.c,130 :: 		asm clrwdt;
	CLRWDT
;pm683.c,132 :: 		while (button);
	BTFSC      GPIO+0, 4
	GOTO       L_main30
;pm683.c,133 :: 		}
L_main29:
;pm683.c,134 :: 		if (button == 0 && ptmr <= off_time) kn = 0;  // кнопка нажата менее 4 сек.
	BTFSC      GPIO+0, 4
	GOTO       L_main35
	MOVF       _ptmr+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main53
	MOVF       _ptmr+0, 0
	SUBLW      20
L__main53:
	BTFSS      STATUS+0, 0
	GOTO       L_main35
L__main41:
	CLRF       _kn+0
L_main35:
;pm683.c,136 :: 		while (pstop);
	MOVF       _pstop+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main20
;pm683.c,137 :: 		pstop = 1;
	MOVLW      1
	MOVWF      _pstop+0
;pm683.c,140 :: 		while (errstop);                                     // Цикл "моргания" при ошибке
	MOVF       _errstop+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main0
;pm683.c,141 :: 		do                                                 // пока не вырубим питание
L_main36:
;pm683.c,144 :: 		asm clrwdt;
	CLRWDT
;pm683.c,145 :: 		Pwr_LED = 0;
	BCF        GPIO+0, 2
;pm683.c,146 :: 		Error = 1;
	BSF        GPIO+0, 1
;pm683.c,147 :: 		delay_ms(200);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main39:
	DECFSZ     R13+0, 1
	GOTO       L_main39
	DECFSZ     R12+0, 1
	GOTO       L_main39
	DECFSZ     R11+0, 1
	GOTO       L_main39
	NOP
;pm683.c,148 :: 		Pwr_LED = 0;
	BCF        GPIO+0, 2
;pm683.c,149 :: 		Error = 0;
	BCF        GPIO+0, 1
;pm683.c,150 :: 		delay_ms(200);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main40:
	DECFSZ     R13+0, 1
	GOTO       L_main40
	DECFSZ     R12+0, 1
	GOTO       L_main40
	DECFSZ     R11+0, 1
	GOTO       L_main40
	NOP
;pm683.c,152 :: 		while (1);
	GOTO       L_main36
;pm683.c,153 :: 		}
	GOTO       $+0
; end of _main

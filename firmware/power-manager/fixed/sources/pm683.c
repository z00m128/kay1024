////////////////////////////////////////////////////////////
//                                                        //
// КОНТРОЛЛЕР PIC12F675  (внутренний генератор 4Mhz)      //
//                                                        //
// Конфигурация:                                          //
// OSC = IRC                                              //
// WDT = Off                                              //
// PWRT = ON                                              //
// CP = OFF                                               //
// MCLR = OFF                                             //
// BOD = ON                                               //
// CPD = OFF                                              //
//                                                        //
////////////////////////////////////////////////////////////
#define PS_ON      GPIO.GP0   // Pwr_ON (act. - '0') to PS
#define Error      GPIO.GP1   // Error LED/Buzzer
#define Pwr_LED    GPIO.GP2   // Power_LED
#define Pwr_OK     GPIO.GP3   // Pwr_GOOD from PS
#define button     GPIO.GP4   // Button In
#define Ext_ON     GPIO.GP5   // External On

unsigned short pstop;       // Переменная цикла on off
unsigned short errstop;     // Переменная цикла power fail
unsigned short kn;
unsigned int ptmr;          // Переменная для счетчика таймера
////////////////////////////////////////////////////////////
//                                                        //
// ОБРАБОТКА ПРЕРЫВАНИЙ                                   //
//                                                        //
////////////////////////////////////////////////////////////
void interrupt()
{  ptmr = ptmr + 1;      // Счетчик ~0,1 сек.
   asm clrwdt;
   TMR1H = 0x3C;
   TMR1L = 0xB0;
   PIR1.TMR1IF = 0;
}

void main()
{
////////////////////////////////////////////////////////////
//                                                        //
// ИНИЦИАЛИЗАЦИЯ                                          //
//                                                        //
////////////////////////////////////////////////////////////
   ANSEL = 0;
   OPTION_REG = 143;                   // Резисторы выключены WDT 1:128
   GPIO = 0;
   VRCON = 0;
   CMCON0 = 7;                         // компаратор выключен
   CMCON1 = 7;
   TRISIO = 248;                       // GP0, GP1 и GP2 - выходы, остальные вход
   asm clrwdt;
   T1CON = 17;                         // TMR1 включен, предделитель 1:2
   INTCON = 192;                       // Прерывания разрешены
   TMR1H = 0x3C;
   TMR1L = 0xB0;
   PIR1.TMR1IF = 0;
   PIE1 = 1;
   ptmr = 0;
   kn = 0;
   pstop = 1;
   errstop = 1;
   PS_ON = 0;
////////////////////////////////////////////////////////////
//                                                        //
// ОСНОВНОЙ ЦИКЛ ПРОГРАММЫ                                //
//                                                        //
////////////////////////////////////////////////////////////
   do
   {  do
      {  asm clrwdt;
         Error = 0;
         if (button == 0 && Ext_ON == 0)                // Цикл "моргания" светодиодом
            // в режиме ожидания
         {  if (ptmr < 1) Pwr_LED = 1;                   // включили светодиод
            if (ptmr > 1 && ptmr <= 15) Pwr_LED = 0;     // выключили светодиод
            if (ptmr > 15) ptmr = 0;
         }
         else
         {  delay_ms(35);                                // антидребезговая задержка
            if (button != 0 || Ext_ON != 0)              // врубаем питание
            {  pstop = 0;
               PS_ON = 1;                                // влкючаем БП
               Pwr_LED = 1;                              // включаем светодиод (PowerON)
            }
         }
      }
      while (pstop);

      delay_ms(500);                                     // Задержка на включение БП
      pstop = 1;                                         // ожидаем сигнал "PowerGood" от БП

      do                                                 // Цикл генерации сигнала ошибки
      {  asm clrwdt;
         if (Pwr_OK == 0)                                // ошибка питания
         {  PS_ON = 0;                                   // вырубаем питание БП
            Pwr_LED = 0;                                 // вырубаем светодиод Включения
            Error = 1;                                   // Зажигаем светодиод "ошибка"
            pstop = 0;
            errstop = 0;
         }
         if (button != 0 && kn == 0)                     // цикл выключения
         {  // произошло нажатие кнопки
            kn = 1;
            ptmr = 0;
         }
         if (button != 0 && ptmr > 35)                   // кнопка нажата более 4 сек.
         {  pstop = 0;
            PS_ON = 0;                                   // вырубаем питание БП
            Pwr_LED = 0;                                 // выключаем светодиод (PowerON)
            Error = 0;                                // ну, это не обязательно, он и так в "0"
            delay_ms(100);
            do
            {  asm clrwdt;
            }
            while (button);
         }
         if (button == 0 && ptmr <= 35)
         {  kn = 0;        // кнопка нажата менее 4 сек.
            ptmr = 0;
         }
      }
      while (pstop);
      pstop = 1;

   }
   while (errstop);                                     // Цикл "моргания" при ошибке
   do                                                 // пока не вырубим питание
   {  // (не устраним неиспр. БП)
      asm clrwdt;
      Pwr_LED = 0;
      Error = 1;
      delay_ms(200);
      Pwr_LED = 0;
      Error = 0;
      delay_ms(200);
   }
   while (1);
}

#line 1 "C:/KAY_PM/sources/pm683.c"
#line 27 "C:/KAY_PM/sources/pm683.c"
unsigned short pstop;
unsigned short errstop;
unsigned short kn;
unsigned int ptmr;





void interrupt()
{
 ptmr = ptmr + 1;
 asm clrwdt;
 TMR1H = 0x3C;
 TMR1L = 0xB0;
 PIR1.TMR1IF = 0;
}

void main()
{





 ANSEL = 0;
 OPTION_REG = 143;
 GPIO = 0;
 VRCON = 0;
 CMCON0 = 7;
 CMCON1 = 7;
 TRISIO = 248;
 asm clrwdt;
 T1CON = 17;
 INTCON = 192;
 TMR1H = 0x3C;
 TMR1L = 0xB0;
 PIR1.TMR1IF = 0;
 PIE1 = 1;
 ptmr = 0;
 kn = 0;
 pstop = 1;
 errstop = 1;
  GPIO.GP0  = 0;





 do
 {
 do
 {
 asm clrwdt;
  GPIO.GP1  = 0;
 if ( GPIO.GP4  == 0 &&  GPIO.GP5  == 0)

 {
 if (ptmr < 1)  GPIO.GP2  = 1;
 if (ptmr > 1 && ptmr <= 15)  GPIO.GP2  = 0;
 if (ptmr > 15) ptmr = 0;
 }
 else
 {
 delay_ms(35);
 if ( GPIO.GP4  != 0 ||  GPIO.GP5  != 0)
 {
 pstop = 0;
  GPIO.GP0  = 1;
  GPIO.GP2  = 1;
 }
 }
 }
 while (pstop);

 delay_ms( 500 );
 pstop = 1;

 do
 {
 asm clrwdt;
 if ( GPIO.GP3  == 0)
 {
  GPIO.GP0  = 0;
  GPIO.GP2  = 0;
  GPIO.GP1  = 1;
 pstop = 0;
 errstop = 0;
 }
 if ( GPIO.GP4  != 0 && kn == 0)
 {

 kn = 1;
 ptmr = 0;
 }
 if ( GPIO.GP4  != 0 && ptmr >  20 )
 {
 pstop = 0;
  GPIO.GP0  = 0;
  GPIO.GP2  = 0;
  GPIO.GP1  = 0;
 do
 {
 asm clrwdt;
 }
 while ( GPIO.GP4 );
 }
 if ( GPIO.GP4  == 0 && ptmr <=  20 ) kn = 0;
 }
 while (pstop);
 pstop = 1;

 }
 while (errstop);
 do
 {

 asm clrwdt;
  GPIO.GP2  = 0;
  GPIO.GP1  = 1;
 delay_ms(200);
  GPIO.GP2  = 0;
  GPIO.GP1  = 0;
 delay_ms(200);
 }
 while (1);
}

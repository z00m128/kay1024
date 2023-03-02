////////////////////////////////////////////////////////////
//                                                        //
// ���������� PIC12F675  (���������� ��������� 4Mhz)      //
//                                                        //
// ������������:                                          //
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
#define off_time   20 // ����� ������� ����������
// �������������� �� ������� t * 0,1 ���.
// �.�. 20 - ~2 �������
#define Pwr_OK_time 500 // �����, � ��, �������� �������
// Pwr_OK ��� ��������� ��.

unsigned short pstop;       // ���������� ����� on off
unsigned short errstop;     // ���������� ����� power fail
unsigned short kn;
unsigned int ptmr;          // ���������� ��� �������� �������
////////////////////////////////////////////////////////////
//                                                        //
// ��������� ����������                                   //
//                                                        //
////////////////////////////////////////////////////////////
void interrupt()
{
    ptmr = ptmr + 1;        // ������� ~0,1 ���.
    asm clrwdt;
    TMR1H = 0x3C;
    TMR1L = 0xB0;
    PIR1.TMR1IF = 0;
}

void main()
{
////////////////////////////////////////////////////////////
//                                                        //
// �������������                                          //
//                                                        //
////////////////////////////////////////////////////////////
    ANSEL = 0;
    OPTION_REG = 143;                   // ��������� ��������� WDT 1:128
    GPIO = 0;
    VRCON = 0;
    CMCON0 = 7;                         // ���������� ��������
    CMCON1 = 7;
    TRISIO = 248;                       // GP0, GP1 � GP2 - ������, ��������� ����
    asm clrwdt;
    T1CON = 17;                         // TMR1 �������, ������������ 1:2
    INTCON = 192;                       // ���������� ���������
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
// �������� ���� ���������                                //
//                                                        //
////////////////////////////////////////////////////////////
    do
    {
        do
        {
            asm clrwdt;
            Error = 0;
            if (button == 0 && Ext_ON == 0)               // ���� "��������" �����������
                // � ������ ��������
            {
                if (ptmr < 1) Pwr_LED = 1;                // �������� ���������
                if (ptmr > 1 && ptmr <= 15) Pwr_LED = 0;  // ��������� ���������
                if (ptmr > 15) ptmr = 0;
            }
            else
            {
                delay_ms(35);                             // ��������������� ��������
                if (button != 0 || Ext_ON != 0)           // ������� �������
                {
                    pstop = 0;
                    PS_ON = 1;                            // �������� ��
                    Pwr_LED = 1;                          // �������� ��������� (PowerON)
                }
            }
        }
        while (pstop);

        delay_ms(Pwr_OK_time);                            // �������� �� ��������� ��
        pstop = 1;                                        // ������� ������ "PowerGood" �� ��

        do                                                // ���� ��������� ������� ������
        {
            asm clrwdt;
            if (Pwr_OK == 0)                              // ������ �������
            {
                PS_ON = 0;                                // �������� ������� ��
                Pwr_LED = 0;                              // �������� ��������� ���������
                Error = 1;                                // �������� ��������� "������"
                pstop = 0;
                errstop = 0;
            }
            if (button != 0 && kn == 0)                   // ���� ����������
            {
                // ��������� ������� ������
                kn = 1;
                ptmr = 0;
            }
            if (button != 0 && ptmr > off_time)           // ������ ������ ����� 2 ���.
            {
                pstop = 0;
                PS_ON = 0;                                // �������� ������� ��
                Pwr_LED = 0;                              // ��������� ��������� (PowerON)
                Error = 0;                                // ��, ��� �� �����������, �� � ��� � "0"
                do
                {
                    asm clrwdt;
                }
                while (button);
            }
            if (button == 0 && ptmr <= off_time) kn = 0;  // ������ ������ ����� 4 ���.
        }
        while (pstop);
        pstop = 1;

    }
    while (errstop);                                     // ���� "��������" ��� ������
    do                                                 // ���� �� ������� �������
    {
        // (�� �������� ������. ��)
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
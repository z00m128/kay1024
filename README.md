# Nemo KAY1024 (v2010/v2018)
Nemo KAY1024 is russian ZX Spectrum clone. This would like to be a repository of the materials I collected while I was building this computer.

## Key features
- CPU: Z80A 7MHz / 3.5MHz
- RAM: 1024kB paged on ports #7ffd / #1ffd
- sound: YM2149 / beeper
- screen: like ZX Spectrum, no enhanced modes, B/W CVBS and RGBS out 
- operating systems: BASIC, TRDOS, iS-DOS
- FDD: Betadisk Turbo for NemoBUS/ZX-BUS
- HDD: NemoIDE for NemoBUS/ZX-BUS
- keyboard: matrix or AT controller for NemoBUS/ZX-BUS (v2010 and v2018 have a built-in PS/2 controller)
- ports: joystick, centronics, tape in/out, 3 NemoBUS/ZX-BUS slots (4 on v2010 and v2018)
- peripherals: various were available - like modem, sound card, etc.
- enhancements: various available - like RTC, cache, expanded ROM, etc.

Computers were manufactured by Nemo company, St. Petersburg, and were produced as boards only, or as the complete computers in various cases. Some of them were in cases from the domestic Corvette producer (hence the name KAY1024SL3 Korvet, 3SL means three NemoBUS slots).

As time went by, there were few versions, each slightly better than the last.

### KAY128
There is a rumour that that it was created on a basis of Composite 128K AY computer (which is based on Leningrad scheme), with some changes. The new computer name was taken from the last three letters of old name. 

### KAY256 / KAY256 Turbo
As the name suggests, it has enhanced memory. It was compatible with the Scorpion 256 computer. The first version lacks the turbo mode and came only with two ZX-BUS slots. The latter has three slots and 7MHz turbo.

### KAY1024
In addition to memory expansion, the computer received several other enhancements. In 3.5MHz mode the processor has no wait states. The INT signal does not have a fixed length. The unused quarter of the ROM contains a computer test. The NemoBUS/ZX-BUS connectors have a pitch of 2.54 mm instead of 2.5 mm as before, and a few other ehnancements. The last known officialy produced computer was sold in 2001.

### KAY1024 v2010/v2018
The board has been revised, enhanced and re-released under the name KAY1024 v2010 by hobbyist for hobbyists. It has 4 NemoBUS/ZX-BUS slots, 30 pin SIMM slot, PS/2 keyboard interface, it can be powered with standard ATX power supply, and many more enhancements. The 2018 version is only slightly different, basically it just fixes a few bugs.

## Other informations

### Memory paging
    port 7FFDh, 01xxxxxx xxxxxx01
    D0 = bank 0 ;128 kB memory
    D1 = bank 1 ;128 kB memory
    D2 = bank 2 ;128 kB memory
    D3 = videoram
    D4 = ROM128 / ROM48
    D5 = disable paging
    D6 = INIT (XS1, Printer)
    D7 = bank 5 ;1024 kB memory, if JP6 is open; else #1FFD blocked

    port 1FFDh, 00xxxxxx xxxxxx01
    D0 = 0 - ROM, 1 - RAM page 0 at 0-3FFF
    D1 = /Q8 (XS1, Printer)
    D2 = 0-TURBO, 1-NORMAL if JP3 is closed, else SLCTIN (XS1, Printer)
    D3 = ROM DOS / ROM KRAMIS
    D4 = bank 3 ;256 kB memory
    D5 = STROBE (XS1, Printer)
    D6 = /Q6 (XS1, Printer)
    D7 = bank 4 ;512 kB memory
    
 ## Recommendations
 
If you are going to build it, do not try to assemble it from integrated circuits of the LS type. ALS family is the minimum. I'm recommending HCT family as I had a lot of issues with the picture and overall stability with the ALS ICs. Once I swithed to HCT ICs, most of the problems were gone.

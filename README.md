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
    D7 = bank 5 ;1024 kB memory, if JP6 is closed; else #1FFD blocked

    port 1FFDh, 00xxxxxx xxxxxx01
    D0 = 0 - ROM, 1 - RAM page 0 at 0-3FFF
    D1 = /Q8 (XS1, Printer)
    D2 = 0-TURBO, 1-NORMAL if JP3 is closed, else SLCTIN (XS1, Printer)
    D3 = ROM DOS / ROM KRAMIS
    D4 = bank 3 ;256 kB memory
    D5 = STROBE (XS1, Printer)
    D6 = /Q6 (XS1, Printer)
    D7 = bank 4 ;512 kB memory
    
### Port 1FFDh configuration
    JP4 = port 1FFDh blocking circuit presence.
    9-7 - blocking circuit is installed / 9-8 - blocking circuit is not installed.

    JP6 = port 1FFDh blocking configuration.
    Open - port 1FFDh is blocked / Closed - port 1FFDh is enabled.
    If port 1FFDh blocking circuit is installed, the JP6 must be open. Port blocking is controlled by push button then.
    
    JP7 = port 1FFDh blocking on/off. Push button.
    
So, if you have not installed the 1FFDh port blocking circuit, the JP4 must be in 9-8 position and JP6 must be closed. If you have the DD58 and related parts fitted, JP4 must be in the 9-7 position and JP6 must be open. The push button connected to JP7 then serves to momentarily block/unblock the 1FFDh port. Actual state is indicated with HL2 LED - if the LED is on, the port is blocked.
    
### Jumper configuration
    JP1  = Turbo on-off, on/off switch. Overrides 1FFDh/bit2 state if enabled with JP3.
    JP1' = Turbo on-off, push button. Overrides 1FFDh/bit2 state if enabled with JP3
    Use preferred one. Actual state is indicated with HL1 LED - if the LED is on, the turbo mode is on and CPU runs on 7MHz.
    
    JP2  = Reset, push button.
    
    JP3  = Turbo control.
    Open - controlled by button/switch only / Closed - controlled by button/switch and port 1FFDh/bit2.
    
    JP5  = ROM layout configuration.
    10-11 standard ROM page layout / 11-12 reversed ROM page layout.
    
    JP10 = INT control.
    1-2 standard operation of the INT / 2-3 external INT.
    
    JP11 = port #FF control.
    Needs to be open if port #FF circuit is installed.
    
    JP12 = Power supply configuration.
    1-2 built-in 12V converter / 2-3 ATX power supply.
    
    JP13 = Power supply external on-off. Activated by pulse.
    
    JP14 = Power supply on-off. Push button.
    
    JP15 = Video configuration.
    Open - disable video on XS5 & XS10 / Closed - enable video on XS5(1) & XS10(8).
    
    JP16 = Sync configuration.
    Open - disable sync on XS5 & XS10 / Closed - enable sync on XS5(5) & XS10(11).
    
    JP17 = bicolor LED. Power ON (green) / Power fail (red).
        
## Recommendations
 
If you are going to build it, do not try to assemble it from integrated circuits of the LS family. ALS family is the minimum. I'm recommending HCT family as I had a lot of issues with the picture quality and overall stability with the ALS ICs. The HC family also did not work for me. Once I swithed to HCT ICs, most of the problems were gone. You can combine HC with HCT ICs and ALS with HCT ICs where it is needed or possible. You can't combine HC and ALS directly. It will not work properly.

Use high quality logic components where possible. Chinese things from ebay most likely would not work properly.

I had a lot of problems with timings in many places of the circuit if DD1 and DD2 did not give proper waveforms on the oscilloscope. Try to use a pullup on the output of the master clock (DD1.2) if its waveform is too wavy. I have new Texas Instruments 74HC04 as DD1 and new oldstock ELCAP 74HCT175 as DD2 and this combo finally give me good results.

I couldn't find several integrated circuits in the ALS or HCT version anymore, so I had to use the LS version. Fortunately, it doesn't cause problems (except DD7). These are DD33 and DD34 (74LS298), DD41 and DD53 (74LS295), DD8 and DD29 (74LS07), DD7 and DD44 (74LS06). 74LS06 in position DD7 will not work, it is necessary to use 74ALS05 or 75HC05 instead.

The SCR/ signal is probably not well timed, because thin interfering lines were displayed on the edges of the attributes. The pulses seem to come too soon. It needs to be shifted with an 82p - 120p ceramic capacitor connected to ground, depending on your conditions. As a second option, it may help to use 74ALS86 instead of 74HCT86 in position DD11.

Also the HC5 falls down too soon in my case, so it produces a glitch at the output of DD48.2. I fixed this with 120p ceramic capacitor connected to ground.

The PS/2 keyboard controller firmware has a key layout that drove me crazy. SHIFT keys are used as SYMBOL SHIFT and CTRL keys as CAPS SHIFT, completely illogically (for me at least). Unfortunately, I couldn't find the source code for the firmware anywhere, so I got around it in a rather curious way using the ATMEGA firmware binary and [SjASMPlus](https://github.com/z00m128/sjasmplus). Now it is possible to create your own layout, except for the SHIFT and CTRL keys. They are hard-coded in the firmware, but I managed to change the function of the SHIFT and CTRL keys on the left side, so at least they behave logically - SHIFT as CAPS SHIFT and CTRL as SYMBOL SHIFT. The modified firmware you can find in [./firmware/keyboard/kay_kb13_mod](https://github.com/z00m128/kay1024/tree/main/firmware/keyboard/kay_kb13_mod) folder.

I can read and understand russian texts, but sadly, all documentation is in russian language. So if you can't read russian, you have to struggle your own fight with it. I will not translate the documentation to english. Maybe except for notes in text files.

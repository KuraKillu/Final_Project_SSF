#define __SFR_OFFSET 0
#include "avr/io.h"

.global main

main:
    LDI R17, 0xFF
    OUT DDRC, R17       ; set port C for o/p
    SBI DDRB, 4         ; Set PB4 as output
;========================================================================
loop:
    SBI PORTB, 4        ; Give PB4 high signal
    JMP loop            ; Loop back to the start of the main routine
;========================================================================
delay_20ms:             ;delay 20ms
    LDI   R21, 255
l3: LDI   R22, 210
l4: LDI   R23, 2
l5: DEC   R23
    BRNE  l5
    DEC   R22
    BRNE  l4
    DEC   R21
    BRNE  l3
    RET
;========================================================================
delay_2s:               ;delay 2s
    LDI   R21, 255
l6: LDI   R22, 255
l7: LDI   R23, 164
l8: DEC   R23
    BRNE  l8
    DEC   R22
    BRNE  l7
    DEC   R21
    BRNE  l6
    RET
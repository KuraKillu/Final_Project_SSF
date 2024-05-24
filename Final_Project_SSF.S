#define __SFR_OFFSET 0
#include "avr/io.h"

.global main

main:
    SBI DDRB, 4 ; Set PB4 as output
    
loop:
    SBI PORTB, 4 ; Give PB4 high signal
    JMP loop ; Loop back to the start of the main routine
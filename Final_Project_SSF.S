#define __SFR_OFFSET 0
#include "avr/io.h"
;========================================================================
.global main
.global DHT11
;========================================================================
main:
    LDI R17, 0xFF           ; Load 0xFF into register R17
    OUT DDRB, R17           ; Set all pins on PORTB as outputs
    ; USART Initialization
    LDI R16, 0x00           ; High byte of UBRR0 for 9600 baud with F_CPU = 16MHz
    STS UBRR0H, R16
    LDI R16, 0x67           ; Low byte of UBRR0 for 9600 baud with F_CPU = 16MHz
    STS UBRR0L, R16
    LDI R16, (1<<TXEN0)     ; Enable USART transmitter
    STS UCSR0B, R16
    LDI R16, (1<<UCSZ01)|(1<<UCSZ00) ; Set frame format: 8 data bits, no parity, 1 stop bit
    STS UCSR0C, R16
agn:RCALL delay_2s          ; Wait 2s for DHT11 to get ready
;========================================================================
DHT11:
    SBI   DDRB, 5           ; Set PB5 as output
    CBI   PORTB, 5          ; Send low pulse on PB5
    RCALL delay_20ms        ; Wait for 20ms
    SBI   PORTB, 5          ; Send high pulse on PB5
    CBI   DDRB, 5           ; Set PB5 as input
w1: SBIC  PINB, 5
    RJMP  w1                ; Wait for DHT11 low pulse
w2: SBIS  PINB, 5
    RJMP  w2                ; Wait for DHT11 high pulse
w3: SBIC  PINB, 5
    RJMP  w3                ; Wait for DHT11 low pulse
;-----------------------------------------------------------------
    RCALL DHT11_reading     ; Call subroutine to read DHT11 data
    RCALL printval
;-----------------------------------------------------------------
    CPI R18, 25             ; Compare DHT11 temp to 25
    BRLO FanOff             ; Branch if temperature < 25
    CPI R18, 25
    BRGE FanLow             ; Branch if temperature >= 25
    CPI R18, 30
    BRGE FanHigh            ; Branch if temperature >= 30
    RJMP  agn               ; Repeat loop
;========================================================================
FanHigh: 
    LDI   R20, 0xFF         ; 100% into R20 for high fan speed
    RJMP lplh               ; 
;-----------------------------------------------------------------
FanLow: 
    LDI   R20, 0x80         ; 50% into R20 for low fan speed
lplh:SBI   PORTB, 4          ; Set PB4 high to turn on fan
     RCALL delay_20ms        ; Call 20ms delay
     CBI   PORTB, 4          ; Set PB4 low to turn off fan
     RCALL delay_20ms        ; Call 20ms delay
     DEC   R20               ; Decrement R20
     BRNE  lplh              ; Repeat loop
     RJMP agn                ; Repeat loop
;-----------------------------------------------------------------
FanOff: 
    CBI PORTB, 4            ; Turn off fan by setting PB4 low
    RJMP agn                ; Repeat loop
;========================================================================
printval:
    MOV R16, R18            ; Move temperature value to R16
    RCALL ASCII_MSD         ; Convert most significant digit to ASCII
    RCALL LCD_buffer        ; Send to buffer
    STS UDR0, R16           ; Send over USART
    RCALL ASCII_LSD         ; Convert least significant digit to ASCII
    RCALL LCD_buffer        ; Send to buffer
    STS UDR0, R16           ; Send over USART
    RCALL newline           ; Send newline characters
    RET                     ; Return from subroutine
;========================================================================
newline:
    RCALL LCD_buffer        ; Send to buffer
    LDI R16, 0x0A           ; Load newline character (LF)
    STS UDR0, R16           ; Send over USART
;========================================================================
    RCALL LCD_buffer        ; Send to buffer
    LDI R16, 0x0D           ; Load carriage return character (CR)
    STS UDR0, R16           ; Send over USART
    RET                     ; Return from subroutine
;========================================================================
LCD_buffer:
    LDS R27, UCSR0A         ; Load UCSR0A into R27
    SBRS R27, UDRE0         ; Skip if UDRE0 bit is set (buffer ready)
    RJMP LCD_buffer         ; Wait until buffer is ready
    RET                     ; Return from subroutine
;========================================================================
ASCII_MSD:
    MOV R23, R16            ; Copy R16 to R23
    ANDI R16, 0xF0          ; Mask lower nibble
    SWAP R16                ; Swap nibbles
    SUBI R16, -48           ; Convert to ASCII
    MOV R28, R16            ; Move result to R28
    SUBI R28, 58            ; Check if above '9'
    BRPL A_F_D1             ; Branch if so (adjust for letters)
MSD_RET:
    RET                     ; Return from subroutine
A_F_D1:
    SUBI R16, -7            ; Adjust for letters (A-F)
    RJMP MSD_RET            ; Jump to return
;========================================================================
ASCII_LSD:
    MOV R16, R23            ; Copy R23 back to R16
    ANDI R16, 0x0F          ; Mask upper nibble
    SUBI R16, -48           ; Convert to ASCII
    MOV R28, R16            ; Move result to R28
    SUBI R28, 58            ; Check if above '9'
    BRPL A_F_D0             ; Branch if so (adjust for letters)
LSD_RET:
    RET                     ; Return from subroutine
A_F_D0:
    SUBI R16, -7            ; Adjust for letters (A-F)
    RJMP LSD_RET            ; Jump to return
;========================================================================
DHT11_reading:
    LDI   R17, 24           ; Set counter for receiving 8 bits
    CLR   R18               ; Clear data register
;-----------------------------------------------------------------
w4: SBIS  PINB, 5
    RJMP  w4                ; Detect data bit (high pulse)
    RCALL delay_50          ; Wait 50us
;-----------------------------------------------------------------
    SBIS  PINB, 5           ; Check if received bit is 1
    RJMP  skp               ; Jump if received bit is 0
    SEC                     ; Set carry flag (C=1)
    ROL   R18               ; Shift in 1 into LSB of data register
    RJMP  w5                ; Jump to wait for low pulse
skp:LSL   R18               ; Shift in 0 into LSB of data register
;-----------------------------------------------------------------
w5: SBIC  PINB, 5
    RJMP  w5                ; Wait for DHT11 low pulse
;-----------------------------------------------------------------
    DEC   R17               ; Decrement counter
    BRNE  w4                ; Repeat until all bits received
    RET                     ; Return from subroutine
;===============================================================
;delay subroutines
;===============================================================
delay_20ms:                 ; Delay 20ms
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
delay_2s:                   ; Delay 2s
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
;========================================================================
delay_50:                   ; 50us delay using Timer0
    ;---------------------------------------------------------
    CLR   R20
    OUT   TCNT0, R20        ; Initialize Timer0 with count=0
    LDI   R20, 100
    OUT   OCR0A, R20        ; Set OCR0A to 100
    LDI   R20, 0b00001010
    OUT   TCCR0B, R20       ; Timer0: CTC mode, prescaler 8
    ;---------------------------------------------------------
l2: IN    R20, TIFR0        ; Get TIFR0 byte & check
    SBRS  R20, OCF0A        ; Skip if OCF0A is set
    RJMP  l2                ; Loop back if OCF0A is not set
    ;---------------------------------------------------------
    CLR   R20
    OUT   TCCR0B, R20       ; Stop Timer0
    ;---------------------------------------------------------
    LDI   R20, (1<<OCF0A)
    OUT   TIFR0, R20        ; Clear OCF0A flag
    RET
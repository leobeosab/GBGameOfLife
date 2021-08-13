INCLUDE "gb/constants.inc"

SECTION "Header", ROM0[$100]

EntryPoint:
    di 
    jp Start

    REPT $150 - $104
        db 0
    ENDR

SECTION "Booking system code", ROM0

Start:
    call wait_v_blank

    call lcd_off 

    call copyFont

.drawStrings
    ld hl, $9800
    ld de, HotelBookingTitle
    call showString

.displayRegisters
    ld a, %11100100
    ld [LCD_BG_PAL], a

    call reset_scan_lines

    call sound_off

    call lcd_on

.lockup
    jr .lockup

sound_off::
    xor a
    ld [SOUND_CONTROL], a
ret

Section "String Storage", ROM0
HotelBookingTitle:
    db "Booking Sys: V1.0", 0
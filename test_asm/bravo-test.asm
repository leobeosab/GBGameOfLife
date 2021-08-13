INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]

EntryPoint: 
    di
    jp Start 

    REPT $150 - $104
        db 0
    ENDR

SECTION "Booking System code", ROM0

Start:
.waitVBlank
    ld a, [rLY]
    cp 144
    jr c, .waitVBlank

    xor a
    ld[rLCDC], a

    ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles
.copyFont
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or c
    jr nz, .copyFont

    ld hl, $9800
    ld de, HotelBookingSystem
    call showString
    ld hl, $9860
    ld de, HotelBookingSystem
    call showString

.displayStuff
    ;Init display registers
    ld a, %11100100
    ld [rBGP], a

    xor a
    ld [rSCY], a
    ld [rSCX], a

    ; Shut the sound down
    ld [rNR52], a

    ; Turn the screen on
    ld a, %10000001
    ld [rLCDC], a

    ; Lockup
.lockup
    jr .lockup

SECTION "Helper Functions", ROM0
;@param hl : position of string on screen
;@param de : pointer to string
showString:
.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a ; check if byte is zero
    jr nz, .copyString ; Continue if it's not
ret

SECTION "Font", ROM0

FontTiles:
INCBIN "font.chr"
FontTilesEnd:
FontEnd


SECTION "String Storage", ROM0
HotelBookingSystem:
    db "Guests: ", 0
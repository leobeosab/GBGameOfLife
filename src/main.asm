INCLUDE "gb/constants.inc"

SECTION "Header", ROM0[$100]

EntryPoint:
    di 
    jp Start

    REPT $150 - $104
        db 0
    ENDR

SECTION "Game of Life Code", ROM0

Start:
  call wait_v_blank
  call lcd_off 
  call copyFont
  call loadCells

.drawStrings
  ld hl, $9a20
  ld de, GameTitle
  call showString

call loadStartingGrid

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
GameTitle:
  db "Game of life", 0

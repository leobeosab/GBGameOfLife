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

.drawStrings
  ld hl, $9a20
  ld de, GameTitle
  call showString

; Load smiley into VRAM
.loadSmiley
  ld hl, $9000 + 16
  ld de, SmileyDemo
  ld b, 16

  call memCopy

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
SmileyDemo:
  db $00, $00, $00, $00, $24, $24, $00, $00, $81, $81, $7e, $7e, $00, $00, $00, $00
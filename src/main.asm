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
.loadCells
  ld hl, $9000 + 16
  ld de, DeadCell
  ld b, 16
  call memCopy

  ld hl, $9000 + 32
  ld de, LiveCell
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
  DB $ff, $ff, $81, $ff, $bd, $ff, $bd, $e7
  DB $bd, $e7, $bd, $ff, $81, $ff, $ff, $ff
LiveCell:
  DB $00, $ff, $3c, $c3, $42, $bd, $5a, $a5
  DB $5a, $a5, $42, $bd, $3c, $c3, $00, $ff
DeadCell:
  DB $00, $ff, $3c, $ff, $42, $ff, $5a, $ff
  DB $5a, $ff, $42, $ff, $3c, $ff, $00, $ff
Wall:
  DB $00, $ff, $7e, $ff, $42, $ff, $4a, $ff
  DB $7a, $ff, $02, $ff, $fe, $ff, $00, $ff

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
  ld hl, $9000 + $F
  ld de, SmileyDemo
  ld b, 16

.copyloop
  ld a, [de]
  inc de
  ld [hli], a
  dec b
  jp nz, .copyloop

.setupCellGrid
  ; Load in Cell grid to cell grid constant
  ld hl, CELL_GRID_START
  ld de, CellGrid

  ld hl, CELL_ACCUMULATOR
  ld [hl], 0 ; Cell Accumulator

  ; tile offset
  ld de, 0

  ld hl, ROW_ACCUMULATOR
  ld [hl], 0

  .setRow
    ld hl, COL_ACCUMULATOR
    ld [hl], 0

    ld a, 0
    ld [BITSHIFT_TRACKER], a
    .setColumn
      ld hl, BITSHIFT_TRACKER
      rl [hl]

      ; Get current cell and save to register b
      ld bc, CELL_ACCUMULATOR
      ld hl, CELL_GRID_START
      add hl, bc
      ld b, [hl]

      ; Increment Cell Accumulator
      ld hl, CELL_ACCUMULATOR
      inc [hl]

      ; Increment Tile Offset
      inc de

      ; Comparison time
      ld a, [BITSHIFT_TRACKER]
      and b
      ;jp z, .setColumn
      call drawSmiley

      ; Update the cell Accumulator
      ld a, [BITSHIFT_TRACKER]
      sub a, 128
      ;jp nz, .setColumn

    ; Increment row accumulator
    ld hl, ROW_ACCUMULATOR
    inc [hl]

    ; Increment Tile Offset at the end of the row
    inc de
    inc de
    inc de
    inc de

    ; Check if row accumulator is at 16
    ld hl, ROW_ACCUMULATOR
    ld a, [hl]
    sub a, 1
    ;jp nz, .setRow

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
CellGrid:
  db %00001001, %00000000
  db %00001000, %00000000
  db %00001000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000

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

.setupCellGrid
  ; Load in Cell grid to cell grid constant
  ld hl, CELL_GRID_START
  ld de, CellGrid
  ld b, 36
  call memCopy

  ld hl, CELL_ACCUMULATOR
  ld [hl], 0 ; Cell Accumulator

  ; tile offset
  ld de, 0

  ld hl, ROW_ACCUMULATOR
  ld [hl], 0

  .setRow
    ld hl, COL_ACCUMULATOR
    ld [hl], 0

    ld hl, ROW_HALF
    ld [hl], 1

    .setRowHalf
      ld a, 128
      ld [BITSHIFT_TRACKER], a

      .setColumn
        ; Get current cell and save to register b
        ld hl, CELL_GRID_START
        ld a, [CELL_ACCUMULATOR]
        ld b, 0
        ld c, a
        add hl, bc

        ld b, [hl]

        ; Comparison time
        ld a, [BITSHIFT_TRACKER]
        and a, b
        call nz, drawCell

        ; Increment Tile Offset
        inc de

        ; Update the cell Accumulator
        ld a, [BITSHIFT_TRACKER]
        rr a
        ld [BITSHIFT_TRACKER], a
        add a, 0 ; If we rotate through all of the bits the result will be all 0s so if we add 0 and check if the 0 flag is set then we know we are done
        jp nz, .setColumn
      ; End Set Column -----------------------------------

      ; Increment Cell Accumulator
      ld hl, CELL_ACCUMULATOR
      inc [hl]
      
      ld a, [ROW_HALF]
      rl a
      ld [ROW_HALF], a
      and a, %00000100
      jp z, .setRowHalf
    ; End Set Row Half -----------------------------------


    ; Increment row accumulator
    ld hl, ROW_ACCUMULATOR
    inc [hl]

    ; Increment Tile Offset at the end of the row
    ld a, 0
    .tileOffset
      inc a
      inc de
      cp a, 16
      jp nz, .tileOffset

    ; Check if row accumulator is at 16
    ld hl, ROW_ACCUMULATOR
    ld a, [hl]
    sub a, 16
    jp nz, .setRow
  ; End Set Row -----------------------------------

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
  db %11111111, %11111111
  db %11111111, %00000001
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00100000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00010000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000
  db %00000000, %00000000

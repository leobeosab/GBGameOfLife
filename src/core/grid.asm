INCLUDE "gb/constants.inc"

SECTION "grid_setup", ROM0

loadStartingGrid::
    .setupCellGrid
    ; Load in Cell grid to cell grid constant
    ld hl, CELL_GRID_START
    ld de, CellGrid
    ld b, 36
    call memCopy

    ld hl, CELL_ACCUMULATOR
    ld [hl], 0 ; Cell Accumulator

    ; tile offset
    ; This decideds the spacing from the left side of the screen
    ld de, 2

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
ret 

SECTION "starting grid storage", ROM0
CellGrid:
  db %00000000, %11111111
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


INCLUDE "gb/constants.inc"

SECTION "grid_setup", ROM0

drawWalls::
    ; hl - Background Tile Start position
    ; c - Increment amount
    ; b - Tile count
    .wallLoop
    ; Create wall
    ld [hl], 3
    ; Temporary Storage for b
    ld a, b
    ld b, 0

    ; Increase HL to next wall position
    add hl, bc

    ; Swap b back in for a
    ld b, a

    ; Decrease wall counter
    dec b
    ld a, b

    ; Jump if the wall counter is not at 0
    jp nz, .wallLoop
ret

loadStartingGrid::
    ; Setup the walls
    ; left wall
    ld hl, $9801
    ld c, $20
    ld b, 16  
    call drawWalls
    ; middle bottom wall
    ld hl, $9a01
    ld c, $1
    ld b, 18
    call drawWalls
    ; right wall
    ld hl, $9812
    ld c, $20
    ld b, 16  
    call drawWalls

    .setupCellGrid
    ; Load in Cell grid to cell grid constant
    ld hl, CELL_GRID_START
    ld de, CellGrid
    ld bc, 36
    call memCopy

    ; draw initial grid
    call drawGrid
ret 

getNumberOfNeighbors::
    ; b = row
    ; c = column

    ; get top left neigbor

ret

getCellState:: 
    ; b = row
    ; c = column
    ; RET = d register contains 1 or 0 based on state

    ; Check if column is out of bounds (ie greater than 15)
    ld a, b
    sbc a, ROW_LENGTH
    jp nc, .deadCell

    ld a, c
    sbc a, COLUMN_LENGTH
    jp nc, .deadCell

    ; load hl to cell @ 0,0
    ld hl, CELL_GRID_START

    ; Add hl up the rows
    .rowAddition
    ; Check if we hit zero on rows
    ld a, 0
    or a, b
    ld a, b
    jp z, .endRow

    ; Add row to hl
    ld d, 0
    ld e, 2 ; TODO:// replace this with column length
    add hl, de

    ; decrease row
    dec b
    jp .rowAddition
    .endRow

    ; Check to see if column is over 15 if it is, add one to hl and subtract 8
    ld a, c
    sbc a, 8
    jp c, .startColumnMath
    inc hl
    ld c, a

    .startColumnMath
    ld b, 128

    .colAddition
    ; Check if we are at 0 on columns
    ld a, 0
    or a, c
    jp z, .endColumn

    ; add column to h1
    rr b

    ; decrease column
    dec c
    jp .colAddition
    .endColumn

    ld a, [hl]
    and a, b
    jp z, .deadCell
    
    .liveCell
    ld d, 1
    jp .endGetCellState
    .deadCell
    ld d, 0
    jp .endGetCellState

    .endGetCellState
ret

drawGrid::
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
            call drawCell

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

; a = bitshift tracker
; b = value in cell grid
drawCell::
  ld a, [BITSHIFT_TRACKER]
  and a, b
  ld hl, VRAM_MAP_CHR
  add hl, de
  jp nz, .drawLive
  .drawDead
  ld [hl], 1
  jp .drawCellEnd
  .drawLive
  ld [hl], 2
  .drawCellEnd
ret

SECTION "starting grid storage", ROM0
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

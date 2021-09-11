INCLUDE "gb/constants.inc"

SECTION "graphics_storage", rom0

copyFont::
    ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles
    call memCopy
ret

; Load smiley into VRAM
loadCells::
    ld hl, $9000 + 16
    ld de, DeadCell
    ld bc, 16
    call memCopy

    ld hl, $9000 + 32
    ld de, LiveCell
    ld bc, 16
    call memCopy
ret

showString::
.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a
    jr nz, .copyString
ret

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

FontTiles:
INCBIN "assets/font.chr"
FontTilesEnd:
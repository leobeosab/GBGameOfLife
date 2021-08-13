INCLUDE "gb/constants.inc"

Section "Asset Loading", ROM0
copyFont::
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
ret

drawCell::
  ld hl, VRAM_MAP_CHR
  add hl, de
  ld [hl], 1
ret

showString::
.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a
    jr nz, .copyString
ret

SECTION "Font", ROM0
FontTiles:
INCBIN "assets/font.chr"
FontTilesEnd:

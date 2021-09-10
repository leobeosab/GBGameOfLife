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

; a - 0 or 1 1 being alive, 0 being dead
; inc a because the tile index is setup with 1 being dead, 2 being alive
drawCell::
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

showString::
.copyString
    ld a, [de]
    ld [hli], a
    inc de
    and a
    jr nz, .copyString
ret

memCopy::
  ; hl start address
  ; ld start data address
  ; b datasize
  .copyloop
    ld a, [de]
    inc de
    ld [hli], a
    dec b
    jp nz, .copyloop
ret

haltProgram::
  halt
ret


SECTION "Font", ROM0
FontTiles:
INCBIN "assets/font.chr"
FontTilesEnd:

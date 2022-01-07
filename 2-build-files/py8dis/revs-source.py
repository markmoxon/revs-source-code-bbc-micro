from commands import *
from trace6502 import *
import acorn


# Revs? loads from &1200 to &6FFF inclusive (length &5E00)


load(0x1200, "4-reference-binaries/Revs.bin", "0a0da117451375a1df0eab317892725b")
set_output_filename("3-assembled-output/Revs.bin")

acorn.bbc()
config._lower_case = False

################################################################################
# ZERO PAGE
################################################################################

label(0x0070, "P")
label(0x0071, "Q")
label(0x0072, "R")
label(0x0073, "S")

label(0x7800, "trackChecksum")
label(0x5300, "trackData")

################################################################################
# MOVES
# move(dest, source, length)
################################################################################

#Code that ends up at &7000-70DA
move(0x7000, 0x1500, 0x15da - 0x1500 + 1)
label(0x7000, "movedFrom1500")
byte(0x7000, 0xda)

# Code that ends up at &0B00-&0CFF
move(0x0b00, 0x1300, 0x14ff - 0x1300 + 1)
label(0x0b00, "movedFrom1300")
entry(0x0b47)
entry(0x0b77)
entry(0x0ba2)
entry(0x0bcc)
entry(0x0c47)
entry(0x0ca5)
byte(0x0cf2, 0xd00 - 0x0cf2)

# Code that ends up at &0D00-&16DB
#move(0x0d00, 0x5a80, 0x700)
#label(0x0d00, "movedFrom5a80")
#entry(0x0d00)
#entry(0x0d01) # why do we need this?
#entry(0x0dd7)
#entry(0x0e5a)
#entry(0x0e74)
#entry(0x0ee5)
#entry(0x0f64)
#entry(0x0ffe)
#entry(0x109b)
#entry(0x111e)
#entry(0x1163)
#entry(0x11ab)
#entry(0x11ce)
#move(0x0d00, 0x5a80, 0x645b - 0x5a80 + 1)
#label(0x0d00, "movedFrom5a80")
#annotate(0x16dc, "CLEAR &0D00, &16DC")

#move(0x5fd0, 0x64d0, 0x6bff - 0x64d0 + 1)
#label(0x5fd0, "movedFrom64d0")

# Code that ends up at &790E-&79FF
move(0x790e, 0x120e, 0xff - 0xe)

# Code that ends up at &70DB-&7724
# This swaps with the track code that is already there, which comes from
# the track file
move(0x70db, 0x5300, 0x7724 - 0x70db + 1)

################################################################################
# ENTRY CODE
################################################################################

entry(0x1200, "Entry")
comment(0x1200, "Move block from &1200-&12FF to &7900-&79FF and jump to &790E")
label(0x1202, "entr1")

# Copy block assembled at &1200 to &7900
annotate(0x120d, "COPYBLOCK &1200, &120E, &7900")
annotate(0x120d, "CLEAR &1200, &120E")

# Copy block back from &7900 to &1200 after we have done all the assembling
annotate(0x6fff, "COPYBLOCK &7900, &790E, &1200")

################################################################################
# SWAP CODE
################################################################################

entry(0x790e, "SwapCode")
comment(0x790e, "Disable the ESCAPE key and clear memory if the BREAK key is pressed")
comment(0x7917, "*TAPE")
comment(0x791e, "Set (Q P) = &5300 = trackData, destintion address for track data")
comment(0x7926, "Set (S R) = &70DB, source address of track data")
label(0x7930, "swap1")

comment(0x792e, "Swap memory between &70DB-&7724 to &5300-&5949 and decrement checksum bytes in &7800-&7803")


comment(0x7930, "Swap Y-th byte of (Q P) and (S R)")
comment(0x793a, "Decrement the relevant checksum byte at &7800-&7803")
comment(0x7940, "Increment loop counter")
comment(0x7941, "Increment high bytes to move on to next page")
label(0x7947, "swap2")
comment(0x7947, "If we have not yet reached &7725, jump back to swap1 to keep going")
comment(0x7951, "Now check that all three checksum bytes in &7800-&7803 are zero")
label(0x7953, "swap3")
comment(0x7956, "If a checksum byte is non-zero, jump to swap4 to reset the machine")
comment(0x7959, "Loop back to check the next checksum byte")
comment(0x795b, "All checksum bytes are zero, so jump to swap4 to keep going")
label(0x795d, "swap4")
comment(0x795d, "Reset the machine")

################################################################################
# MOVE CODE
################################################################################

entry(0x7960, "MoveCode")
label(0x7964, "move1")

comment(0x7960, "Move block (blockStartHi blockStartLo) - (blockEndHi blockEndLo)-1 to (blockToHi blockToLo)")
comment(0x7960, "  * Move &1500-&15DA to &7000-&70DA")
comment(0x7960, "  * Move &1300-&14FF to &0B00-&0CFF")
comment(0x7960, "  * Move &5A80-&645B to &0D00-&16DB")
comment(0x7960, "  * Move &64D0-&6BFF to &5FD0-&63FF")
comment(0x7960, "  * Zero &5A80-&5E3F")

label(0x7978, "move2")
label(0x7982, "move3")
label(0x7988, "move4")
label(0x79aa, "move5")
entry(0x79ad, "ldaZero")

comment(0x799b, "We get here when X = 0")
comment(0x799b, "Modify the instruction at move2 to LDA #0, so the last block move actually zeroes the block")
comment(0x79a7, "Loop back to move1 to zero the rest of the block ")

label(0x79BE, "blockEndHi")
byte(0x79BE, 5)
label(0x79B9, "blockEndLo")
byte(0x79B9, 5)
label(0x79B4, "blockStartHi")
byte(0x79B4, 5)
label(0x79AF, "blockStartLo")
byte(0x79AF, 5)
label(0x79C8, "blockToHi")
byte(0x79C8, 5)
label(0x79C3, "blockToLo")
byte(0x79C3, 5)
blank(0x12cd)



#comment(0x5A80, "Block moved to &5E80")
#byte(0x5A80, 0x5E3F - 0x5A80)


go()

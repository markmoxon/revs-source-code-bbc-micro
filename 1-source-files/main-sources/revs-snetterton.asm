\ ******************************************************************************
\
\ REVS SNETTERTON TRACK SOURCE
\
\ Revs was written by Geoffrey J Crammond and is copyright Acornsoft 1985
\
\ The code on this site has been reconstructed from a disassembly of the
\ original game binaries
\
\ The commentary is copyright Mark Moxon, and any misunderstandings or mistakes
\ in the documentation are entirely my fault
\
\ The terminology and notations used in this commentary are explained at
\ https://revs.bbcelite.com/about_site/terminology_used_in_this_commentary.html
\
\ The deep dive articles referred to in this commentary can be found at
\ https://revs.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * Snetterton.bin
\
\ ******************************************************************************

GUARD &7C00             \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

LOAD% = &70DB           \ The load address of the track binary

CODE% = &5300           \ The assembly address of the track data

\ ******************************************************************************
\
\ Addresses in the main game code
\
\ ******************************************************************************

thisSectionFlags    = &0001
thisVectorNumber    = &0002
yStore              = &001B
horizonLine         = &001F
frontSegmentIndex   = &0024
directionFacing     = &0025
segmentCounter      = &0042
playerPastSegment   = &0043
xStore              = &0045
vergeBufferEnd      = &004B
horizonListIndex    = &0051
playerSpeedHi       = &0063
currentPlayer       = &006F
T                   = &0074
U                   = &0075
V                   = &0076
W                   = &0077
topTrackLine        = &007F
blockOffset         = &0082
objTrackSection     = &06E8
objSectionSegmt     = &0880
Multiply8x8         = &0C00
Absolute16Bit       = &0E40
MovePlayerForward   = &12F3
UpdateVectorNumber  = &13E0
MovePlayerBack      = &140B
CheckVergeOnScreen  = &1933
gseg13              = &2490
gtrm2               = &2535
Absolute8Bit        = &3450
MultiplyHeight      = &4610
xTrackSegmentI      = &5400
yTrackSegmentI      = &5500
zTrackSegmentI      = &5600
xTrackSegmentO      = &5700
zTrackSegmentO      = &5800
trackSectionFrom    = &5905
xVergeRightHi       = &5E90
xVergeLeftHi        = &5EB8
yVergeRight         = &5F20
yVergeLeft          = &5F48
backgroundColour    = &5F60
playerDrift         = &62FB

\ ******************************************************************************
\
\ REVS SNETTERTON TRACK
\
\ Produces the binary file Snetterton.bin that contains the Snetterton track.
\
\ ******************************************************************************

ORG CODE%

.trackData

 EQUB &63, &D1, &14, &D1, &D0, &FF, &D1, &FF
 EQUB &73, &D0, &14, &DE, &CF, &FF, &DE, &FF
 EQUB &83, &D0, &14, &FE, &CF, &1C, &FE, &7E
 EQUB &93, &D0, &11, &0F, &CF, &1A, &0F, &08
 EQUB &93, &CC, &11, &16, &CC, &09, &15, &52
 EQUB &A3, &C9, &11, &18, &C8, &10, &17, &0B
 EQUB &A3, &C8, &11, &1B, &C7, &1F, &1B, &76
 EQUB &B3, &CF, &11, &2B, &CE, &1E, &2B, &10
 EQUB &B3, &D5, &11, &2F, &D5, &FF, &2F, &FF
 EQUB &B3, &DD, &12, &2E, &DD, &0E, &2E, &91
 EQUB &C5, &E5, &13, &2C, &E5, &3C, &2D, &20
 EQUB &D5, &EF, &11, &19, &F0, &FF, &19, &FF
 EQUB &E4, &EA, &0E, &0C, &EB, &0F, &0C, &91
 EQUB &F3, &E8, &0D, &FF, &E9, &1A, &FF, &06
 EQUB &F3, &EA, &0C, &F7, &EB, &15, &F8, &0C
 EQUB &03, &EC, &0C, &F4, &ED, &FF, &F4, &FF
 EQUB &03, &EE, &10, &E0, &EF, &FF, &E0, &FF
 EQUB &13, &F1, &13, &C7, &F2, &1C, &C7, &8C
 EQUB &23, &F3, &13, &B7, &F4, &2A, &B7, &0E
 EQUB &33, &EA, &13, &AD, &EA, &FF, &AC, &FF
 EQUB &33, &DF, &13, &AC, &DF, &14, &AB, &57
 EQUB &43, &D3, &13, &AB, &D3, &13, &AA, &0B
 EQUB &43, &D1, &13, &AD, &D0, &FF, &AD, &81
 EQUB &53, &D1, &13, &BE, &D0, &FF, &BE, &FF
 EQUB &C1, &05, &15, &0A, &06, &FF, &09, &FF

.Hook80Percent

 EQUB &85, &75, &A9, &CD, &4C, &00, &0C, &98
 EQUB &20, &00, &0C, &85, &75, &20, &00, &0C
 EQUB &06, &74, &2A, &60, &A5, &44, &20, &50
 EQUB &34, &C9, &19, &B0, &07, &A5, &0D, &10
 EQUB &03, &46, &76, &60, &4C, &33, &19, &7F
 EQUB &85, &75, &A9, &CD, &4C, &00, &0C, &00
 EQUB &00, &2C, &00, &00, &00, &00, &00, &00

\ &5400

\ ******************************************************************************
\
\       Name: modifyAddressLo
\       Type: Variable
\   Category: Extra track data
\    Summary: Low byte of the location in the main game code where we modify a
\             two-byte address
\
\ ------------------------------------------------------------------------------
\
\ This is also where the xTrackSegmentI table is built, once the modifications
\ have been done. The block is exactly 20 bytes long, so along with the
\ modifyAddressHi block, there's one byte for each inner segment x-coordinate.
\
\ ******************************************************************************

.modifyAddressLo

 EQUB &49               \ !&1249 = HookSectionFrom
 EQUB &8A               \ !&128A = HookFirstSegment
 EQUB &CA               \ !&13CA = HookSegmentVector
 EQUB &27               \ !&1427 = HookSegmentVector
 EQUB &FC               \ !&12FC = HookDataPointers
 EQUB &1B               \ !&261B = HookUpdateHorizon
 EQUB &8C               \ !&248C = HookFieldOfView
 EQUB &39               \ !&2539 = HookFixHorizon
 EQUB &94               \ !&1594 = HookJoystick
 EQUB &D1               \ !&4CD1 = xTrackSignVector
 EQUB &C9               \ !&4CC9 = yTrackSignVector
 EQUB &C1               \ !&4CC1 = zTrackSignVector
 EQUB &D6               \ !&44D6 = trackRacingLine
 EQUB &D7               \ !&4CD7 = trackSignData
 EQUB &E1               \ !&4CE1 = trackSignData
 EQUB &47               \ !&1947 = HookFlattenHills
 EQUB &F3               \ !&24F3 = HookMoveBack
 EQUB &2C               \ !&462C = HookFlipAbsolute
 EQUB &43               \ !&2543 = Hook80Percent
 EQUB &24               \ !&2F24 = HookBackground

\ ******************************************************************************
\
\       Name: modifyAddressHi
\       Type: Variable
\   Category: Extra track data
\    Summary: High byte of the location in the main game code where we modify a
\             two-byte address
\
\ ------------------------------------------------------------------------------
\
\ This is also where the xTrackSegmentI table is built, once the modifications
\ have been done. The block is exactly 20 bytes long, so along with the
\ modifyAddressLo block, there's one byte for each inner segment x-coordinate.
\
\ ******************************************************************************

.modifyAddressHi

 EQUB &12               \ !&1249 = HookSectionFrom
 EQUB &12               \ !&128A = HookFirstSegment
 EQUB &13               \ !&13CA = HookSegmentVector
 EQUB &14               \ !&1427 = HookSegmentVector
 EQUB &12               \ !&12FC = HookDataPointers
 EQUB &26               \ !&261B = HookUpdateHorizon
 EQUB &24               \ !&248C = HookFieldOfView
 EQUB &25               \ !&2539 = HookFixHorizon
 EQUB &15               \ !&1594 = HookJoystick
 EQUB &4C               \ !&4CD1 = xTrackSignVector
 EQUB &4C               \ !&4CC9 = yTrackSignVector
 EQUB &4C               \ !&4CC1 = zTrackSignVector
 EQUB &44               \ !&44D6 = trackRacingLine
 EQUB &4C               \ !&4CD7 = trackSignData
 EQUB &4C               \ !&4CE1 = trackSignData
 EQUB &19               \ !&1947 = HookFlattenHills
 EQUB &24               \ !&24F3 = HookMoveBack
 EQUB &46               \ !&462C = HookFlipAbsolute
 EQUB &25               \ !&2543 = Hook80Percent
 EQUB &2F               \ !&2F24 = HookBackground


 EQUB &FF, &00, &00, &00, &00, &00, &FD, &FE
 EQUB &FD, &00, &13, &05, &01, &00, &02, &02
 EQUB &02, &04, &00, &01, &01, &01, &01, &00
 EQUB &FF, &FF, &00, &00, &FD, &02, &03, &00
 EQUB &00, &00, &00, &00, &00, &04, &02, &01
 EQUB &02, &00, &07, &00, &05, &FC, &FB, &00
 EQUB &00, &00, &00, &05, &02, &02, &00, &01
 EQUB &00, &00

.trackSignData

 EQUB &81, &94, &90, &AC, &B0, &B8
 EQUB &00, &08, &1D, &24, &3C, &54, &50, &58
 EQUB &6D, &70, &AD, &FA, &53, &0A, &AD, &FB
 EQUB &53, &2A, &48, &2A, &2A, &2A, &29, &07
 EQUB &85, &75, &4A, &68, &29, &3F, &90, &04
 EQUB &49, &3F, &69, &00, &AA, &BC, &BF, &57
 EQUB &BD, &BF, &58, &AA, &A5, &75, &18, &69
 EQUB &01, &29, &02, &D0, &06, &84, &76, &86
 EQUB &77, &F0, &04, &86, &76, &84, &77, &A5
 EQUB &75, &C9, &04, &90, &06, &A9, &00, &E5
 EQUB &76, &85, &76, &A5, &75, &C9, &06, &B0
 EQUB &0A, &C9, &02, &90, &06, &A9, &00, &E5
 EQUB &77, &85, &77, &A4, &02, &A9, &84, &85
 EQUB &75, &A5, &76, &99, &00, &54, &20, &EB
 EQUB &54, &99, &00, &58, &A5, &77, &99, &00
 EQUB &56, &20, &EB, &54, &49, &FF, &18, &69
 EQUB &01, &99, &00, &57, &AD, &FC, &53, &99
 EQUB &00, &55, &60, &08, &4C, &1B, &46

.HookDataPointers

 EQUB &A5
 EQUB &01, &29, &40, &F0, &03, &20, &82, &55
 EQUB &A5, &24, &18, &69, &03, &60, &03, &60

\ &5500

\ ******************************************************************************
\
\       Name: newContentLo
\       Type: Variable
\   Category: Extra track data
\    Summary: Low byte of the two-byte address that we want to poke into the
\             main game code at the modify location
\
\ ------------------------------------------------------------------------------
\
\ This is also where the zTrackSegmentI table is built, once the modifications
\ have been done. The block is exactly 20 bytes long, so along with the
\ newContentHi block, there's one byte for each inner segment z-coordinate.
\
\ ******************************************************************************

.newContentLo

 EQUB LO(HookSectionFrom)
 EQUB LO(HookFirstSegment)
 EQUB LO(HookSegmentVector)
 EQUB LO(HookSegmentVector)
 EQUB LO(HookDataPointers)
 EQUB LO(HookUpdateHorizon)
 EQUB LO(HookFieldOfView)
 EQUB LO(HookFixHorizon)
 EQUB LO(HookJoystick)
 EQUB LO(xTrackSignVector)
 EQUB LO(yTrackSignVector)
 EQUB LO(zTrackSignVector)
 EQUB LO(trackRacingLine)
 EQUB LO(trackSignData)
 EQUB LO(trackSignData)
 EQUB LO(HookFlattenHills)
 EQUB LO(HookMoveBack)
 EQUB LO(HookFlipAbsolute)
 EQUB LO(Hook80Percent)
 EQUB LO(HookBackground)

\ ******************************************************************************
\
\       Name: newContentHi
\       Type: Variable
\   Category: Extra track data
\    Summary: High byte of the two-byte address that we want to poke into the
\             main game code at the modify location
\
\ ------------------------------------------------------------------------------
\
\ This is also where the zTrackSegmentI table is built, once the modifications
\ have been done. The block is exactly 20 bytes long, so along with the
\ newContentLo block, there's one byte for each inner segment z-coordinate.
\
\ ******************************************************************************

.newContentHi

 EQUB HI(HookSectionFrom)
 EQUB HI(HookFirstSegment)
 EQUB HI(HookSegmentVector)
 EQUB HI(HookSegmentVector)
 EQUB HI(HookDataPointers)
 EQUB HI(HookUpdateHorizon)
 EQUB HI(HookFieldOfView)
 EQUB HI(HookFixHorizon)
 EQUB HI(HookJoystick)
 EQUB HI(xTrackSignVector)
 EQUB HI(yTrackSignVector)
 EQUB HI(zTrackSignVector)
 EQUB HI(trackRacingLine)
 EQUB HI(trackSignData)
 EQUB HI(trackSignData)
 EQUB HI(HookFlattenHills)
 EQUB HI(HookMoveBack)
 EQUB HI(HookFlipAbsolute)
 EQUB HI(Hook80Percent)
 EQUB HI(HookBackground)

 EQUB &77, &00, &72, &00, &00, &00, &02, &8C
 EQUB &28, &00, &33, &F6, &E5, &00, &DE, &DE
 EQUB &DE, &44, &00, &F5, &5F, &4A, &4A, &00
 EQUB &4F, &4F, &62, &00, &A8, &6B, &92, &63
 EQUB &00, &00, &00, &00, &00, &FA, &04, &23
 EQUB &C1, &00, &9B, &00, &7A, &BB, &F8, &00
 EQUB &00, &00, &00, &55, &11, &11, &60, &B0
 EQUB &78, &20

.xTrackSignVector

 EQUB &04, &FD, &FC, &3D, &01, &FB
 EQUB &00, &F9, &01, &F1, &EB, &E3, &20, &0A
 EQUB &07, &03

.HookSegmentVector

 EQUB &A5, &01, &29, &40, &F0, &06
 EQUB &20, &E0, &13, &20, &C4, &55, &60, &20
 EQUB &E0, &13, &AC, &F8, &53, &AD, &FD, &53
 EQUB &38, &24, &25, &30, &13, &69, &00, &D9
 EQUB &28, &57, &90, &22, &A9, &00, &C8, &CC
 EQUB &F9, &53, &90, &1A, &A0, &00, &F0, &16
 EQUB &E9, &01, &B0, &12, &98, &29, &7F, &A8
 EQUB &C0, &01, &B0, &03, &AC, &F9, &53, &88
 EQUB &B9, &28, &57, &38, &E9, &01, &8D, &FD
 EQUB &53, &8C, &F8, &53, &60

.HookMoveBack

 EQUB &24, &43, &30
 EQUB &FB, &4C, &0B, &14, &86, &45, &AC, &F8
 EQUB &53, &30, &2F, &B9, &28, &55, &85, &74
 EQUB &B9, &28, &54, &24, &25, &20, &40, &0E
 EQUB &85, &75, &A5, &74, &18, &6D, &FA, &53
 EQUB &8D, &FA, &53, &A5, &75, &6D, &FB, &53
 EQUB &8D, &FB, &53, &B9, &28, &56, &24, &25
 EQUB &20, &50, &34, &18, &6D, &FC, &53, &8D
 EQUB &FC, &53, &20, &72, &54, &A6, &45, &60

\ &5600

\ ******************************************************************************
\
\       Name: ModifyGameCode (Part 3 of 3)
\       Type: Subroutine
\   Category: Extra track data
\    Summary: Modify the game code to support the extra track data
\
\ ------------------------------------------------------------------------------
\
\ The code modifications are done in three parts.
\
\ This is also where the zTrackSegmentI table is built, once the modifications
\ have been done. The routine is padded out to be exactly 40 bytes long, so
\ there's one byte for each inner segment z-coordinate.
\
\ ******************************************************************************

.mods3

 LDA #&20               \ ?&2F23 = &20 (opcode for a JSR &xxxx instruction)
 STA &2F23

 LDA #0                 \ ?&231B = 0 (branch offset in a BEQ instruction)
 STA &231B

 LDA #LO(HookSlopeJump) \ !&45CC = HookSlopeJump (address in a JSR &xxxx
 STA &45CC              \                         instruction)
 LDA #HI(HookSlopeJump)
 STA &45CD

 LDA #75                \ ?&2772 = 75 (argument in a CMP #75 instruction)
 STA &2772

 LDA #&A9               \ !&1310 = &A9 &10 (LDA #2*8 instruction)
 STA &1310
 LDA #&10
 STA &1311

 RTS                    \ Return from the subroutine

 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &FD, &00, &03, &00
 EQUB &00, &00, &00, &00, &00, &00, &F4, &04
 EQUB &0A, &FB, &00, &FF, &FF, &FF, &FF, &01
 EQUB &00, &00, &00, &01, &00, &01, &01, &02
 EQUB &00, &00, &FF, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &FD, &01, &03, &00
 EQUB &FE, &00, &01, &FC, &FC, &03, &03, &FC
 EQUB &FE, &01

.yTrackSignVector

 EQUB &08, &08, &08, &08, &08, &08
 EQUB &08, &08, &30, &08, &08, &F8, &12, &1C
 EQUB &20, &08

.HookSectionFrom

 EQUB &84, &1B, &B9, &05, &59, &85
 EQUB &02, &98, &4A, &4A, &4A, &A8, &B9, &46
 EQUB &58, &8D, &FA, &53, &B9, &64, &58, &8D
 EQUB &FB, &53, &B9, &28, &58, &8D, &FC, &53
 EQUB &B9, &82, &58, &4A, &6A, &8D, &F8, &53
 EQUB &A9, &0E, &6A, &8D, &B3, &23, &A9, &00
 EQUB &8D, &FD, &53, &24, &25, &30, &03, &20
 EQUB &C4, &55, &A4, &1B, &A5, &02, &60

.HookUpdateHorizon

 EQUB &48
 EQUB &A5, &42, &C9, &0C, &68, &B0, &04, &85
 EQUB &1F, &84, &51, &60

.HookFieldOfView

 EQUB &90, &07, &A5, &42
 EQUB &C9, &0A, &90, &01, &60, &4C, &90, &24

.HookFlattenHills

 EQUB &98, &29, &20, &85, &82, &A9, &00, &85
 EQUB &7F, &88, &B9, &20, &5F, &C5, &1F, &B0
 EQUB &1E, &C5, &7F, &B0, &F2, &A5, &7F, &69
 EQUB &00, &99, &20, &5F, &A5, &82, &D0, &E9
 EQUB &A5, &7F, &8D, &EA, &1F, &C8, &20, &3B
 EQUB &25, &88, &38, &66, &82, &30, &DA, &A4
 EQUB &4B, &88, &84, &75, &4C, &DC, &53, &00

\ &5700

\ ******************************************************************************
\
\       Name: ModifyGameCode (Part 1 of 3)
\       Type: Subroutine
\   Category: Extra track data
\    Summary: Modify the game code to support the extra track data
\
\ ------------------------------------------------------------------------------
\
\ The code modifications are done in three parts.
\
\ The (modifyAddressHi modifyAddressLo) table contains the locations in the main
\ game code that we want to modify.
\
\ The (newContentHi newContentLo) table contains the new two-byte addresses that
\ we want to poke into the main game code at the modify locations.
\
\ This part also does a couple of single-byte modifications.
\
\ This is also where the xTrackSegmentO table is built, once the modifications
\ have been done. The routine is padded out to be exactly 40 bytes long, so
\ there's one byte for each inner segment x-coordinate.
\
\ ******************************************************************************

.ModifyGameCode

 LDX #19                \ We are about to modify 20 two-byte addresses in the
                        \ main game code, so set a counter in X

.mods1

 LDA modifyAddressHi,X  \ Set (U T) = the X-th entry in the (modifyAddressHi
 STA U                  \ modifyAddressLo) table, which contains the location
 LDA modifyAddressLo,X  \ of the code to modify in the main game code
 STA T

 LDY #0                 \ We now modify two bytes, so set an index in Y

 LDA newContentLo,X     \ We want to modify the two-byte address at location
                        \ (U T), setting it to the new address in the
                        \ (newContentHi newContentLo) table, so set A to the
                        \ low byte of the X-th entry from the table, i.e. to
                        \ the low byte of the new address

 STA (T),Y              \ Modify the byte at (U T) to the low byte of the new
                        \ address in A

 INY                    \ Increment Y to point to the next byte

 LDA newContentHi,X     \ Set A to the high byte of the X-th entry from the
                        \ table, i.e. to the high byte of the new address

 STA (T),Y              \ Modify the byte at (U T) + 1 to the high byte of the
                        \ new address in A

 DEX                    \ Decrement the loop counter to move on to the next
                        \ address to modify

 BPL mods1              \ Loop back until we have modified all 19 addresses

 LDA #&4C               \ ?&261A = &4C (opcode for a JMP &xxxx instruction)
 STA &261A

 STA &248B              \ ?&248B = &4C (opcode for a JMP &xxxx instruction)

 JMP mods2              \ Jump to part 2

 EQUB &00               \ This byte pads the routine out to exactly 40 bytes

\ EQUB &A2, &13, &BD, &14, &54, &85, &75, &BD
\ EQUB &00, &54, &85, &74, &A0, &00, &BD, &00
\ EQUB &55, &91, &74, &C8, &BD, &14, &55, &91
\ EQUB &74, &CA, &10, &E6, &A9, &4C, &8D, &1A
\ EQUB &26, &8D, &8B, &24, &4C, &00, &58

 EQUB &02, &1B, &02, &41, &06, &20, &06, &06
 EQUB &04, &03, &02, &02, &03, &23, &03, &03
 EQUB &06, &04, &12, &08, &18, &0A, &0A, &15
 EQUB &09, &09, &0D, &07, &11, &05, &03, &0C
 EQUB &1F, &1E, &18, &0E, &15, &03, &06, &0D
 EQUB &08, &19, &09, &28, &05, &05, &0C, &0F
 EQUB &15, &23, &16, &03, &0E, &08, &13, &08
 EQUB &11, &22

.zTrackSignVector

 EQUB &00, &44, &E9, &02, &1B, &12
 EQUB &1A, &1B, &B3, &05, &DE, &09, &F3, &10
 EQUB &32, &FB

.HookFixHorizon

 EQUB &8D, &EA, &1F, &99, &48, &5F
 EQUB &B9, &40, &5E, &38, &F9, &68, &5E, &B9
 EQUB &90, &5E, &F9, &B8, &5E, &10, &0C, &B9
 EQUB &40, &5E, &99, &68, &5E, &B9, &90, &5E
 EQUB &99, &B8, &5E, &B9, &20, &5F, &99, &48
 EQUB &5F, &C8, &C0, &09, &90, &DA, &A4, &51
 EQUB &60

.HookJoystick

 EQUB &A4, &6F, &B9, &E8, &06, &C9, &28
 EQUB &D0, &0F, &B9, &80, &08, &C9, &02, &90
 EQUB &03, &4E, &FB, &62, &A0, &DC, &4C, &CF
 EQUB &53, &4C, &D6, &59, &4C, &1B, &46, &00
 EQUB &01, &03, &04, &06, &07, &09, &0A, &0C
 EQUB &0D, &0F, &10, &12, &13, &15, &16, &17
 EQUB &19, &1A, &1C, &1D, &1F, &20, &21, &23
 EQUB &24, &26, &27, &28, &2A, &2B, &2D, &2E
 EQUB &2F, &31, &32, &33, &35, &36, &37, &39
 EQUB &3A, &3B, &3C, &3E, &3F, &40, &41, &43
 EQUB &44, &45, &46, &47, &49, &4A, &4B, &4C
 EQUB &4D, &4E, &4F, &51, &52, &53, &54, &55

\ &5800

\ ******************************************************************************
\
\       Name: ModifyGameCode (Part 2 of 3)
\       Type: Subroutine
\   Category: Extra track data
\    Summary: Modify the game code to support the extra track data
\
\ ------------------------------------------------------------------------------
\
\ The code modifications are done in three parts.
\
\ This is also where the zTrackSegmentO table is built, once the modifications
\ have been done. The routine is exactly 40 bytes long, so there's one byte for
\ each outer segment z-coordinate.
\
\ ******************************************************************************

.mods2

 LDA #&20               \ ?&1248 = &20 (opcode for a JSR &xxxx instruction)
 STA &1248

 STA &12FB              \ ?&12FB = &20 (opcode for a JSR &xxxx instruction)

 STA &2538              \ ?&2538 = &20 (opcode for a JSR &xxxx instruction)

 STA &45CB              \ ?&45CB = &20 (opcode for a JSR &xxxx instruction)

 LDA #&EA               \ ?&2545 = &EA (opcode for a NOP instruction)
 STA &2545

 LDA #22                \ ?&4F55 = 22 (argument in a CMP #22 instruction)
 STA &4F55

 STA &4F59              \ ?&4F59 = 22 (argument in a CMP #22 instruction)

 LDA #13                \ ?&24EA = 13 (argument in a CMP #13 instruction)
 STA &24EA

 LDA #&A2               \ ?&1FE9 = &A2 (opcode for a LDX # instruction)
 STA &1FE9

 JMP mods3              \ Jump to part 3

\ EQUB &A9, &20, &8D, &48, &12, &8D, &FB, &12
\ EQUB &8D, &38, &25, &8D, &CB, &45, &A9, &EA
\ EQUB &8D, &45, &25, &A9, &16, &8D, &55, &4F
\ EQUB &8D, &59, &4F, &A9, &0D, &8D, &EA, &24
\ EQUB &A9, &A2, &8D, &E9, &1F, &4C, &00, &56

 EQUB &00, &00, &00, &EE, &00, &00, &00, &00
 EQUB &10, &10, &10, &DC, &F1, &F8, &F8, &00
 EQUB &18, &00, &00, &00, &00, &00, &00, &00
 EQUB &26, &FC, &12, &E6, &FF, &00, &00, &EE
 EQUB &D2, &D2, &C6, &C6, &18, &C7, &3F, &3F
 EQUB &3F, &97, &5E, &1F, &47, &14, &B8, &B8
 EQUB &B8, &8D, &8D, &8D, &00, &00, &B3, &B3
 EQUB &B3, &28, &C8, &00, &00, &FE, &FF, &FF
 EQUB &D9, &D9, &0C, &11, &45, &45, &45, &8F
 EQUB &89, &88, &60, &77, &7B, &7B, &7B, &BB
 EQUB &BB, &BB, &00, &00, &A1, &A1, &A1, &DF
 EQUB &F3, &00, &00, &08, &10, &18, &27, &26
 EQUB &32, &3A, &4B, &4A, &4E, &5E, &66, &72
 EQUB &76, &7E, &86, &8E, &96, &A7, &A6, &AA
 EQUB &AF, &AE, &BC, &C4, &CE, &DA, &E2, &00

.trackRacingLine

 EQUB &00, &19, &19, &2E, &00, &57, &18, &3F
 EQUB &18, &18, &3D, &19, &19, &64, &BD, &24
 EQUB &18, &18, &6B, &18, &18, &57, &19, &00
 EQUB &00, &18, &4B, &18, &18, &18, &00, &78
 EQUB &78, &78, &78, &78, &78, &78, &78, &77
 EQUB &77, &77, &77, &77, &76, &76, &76, &76
 EQUB &75, &75, &75, &74, &74, &74, &73, &73
 EQUB &72, &72, &71, &71, &70, &70, &6F, &6F
 EQUB &6E, &6E, &6D, &6C, &6C, &6B, &6B, &6A
 EQUB &69, &68, &68, &67, &66, &65, &65, &64
 EQUB &63, &62, &61, &60, &60, &5F, &5E, &5D
 EQUB &5C, &5B, &5A, &59, &58, &57, &56, &55

\ &5900

 EQUB &40, &20, &00, &20, &28, &01, &20, &1D
 EQUB &40, &AD, &00, &B8, &B5, &1F, &AF, &43
 EQUB &68, &68, &00, &20, &70, &13, &1D, &26
 EQUB &F3, &42, &81, &F0, &4A, &12, &ED, &10
 EQUB &00, &97, &54, &3B, &06, &23, &72, &09
 EQUB &ED, &2E, &54, &B1, &9D, &25, &E8, &07
 EQUB &72, &09, &54, &50, &1B, &05, &98, &26
 EQUB &ED, &65, &54, &84, &84, &04, &EB, &10
 EQUB &02, &7E, &58, &07, &9C, &15, &FC, &11
 EQUB &70, &65, &68, &08, &83, &17, &FD, &12
 EQUB &ED, &C3, &88, &FA, &E1, &02, &EF, &34
 EQUB &40, &26, &66, &C9, &0A, &0F, &6C, &1E
 EQUB &68, &3F, &D2, &A6, &30, &06, &70, &1D
 EQUB &F3, &33, &3B, &38, &26, &25, &08, &11
 EQUB &ED, &A5, &B3, &F7, &54, &10, &A6, &08
 EQUB &C0, &67, &97, &B6, &58, &1A, &EB, &2B
 EQUB &40, &E5, &1B, &C2, &DA, &1F, &DC, &36
 EQUB &70, &A3, &FF, &A8, &98, &07, &C2, &23
 EQUB &ED, &6A, &FF, &63, &5F, &04, &7D, &1E
 EQUB &02, &76, &FF, &BC, &90, &24, &C6, &18
 EQUB &70, &4E, &FF, &84, &68, &27, &8E, &19
 EQUB &ED, &AF, &FF, &3F, &C9, &1A, &49, &09
 EQUB &02, &20, &FF, &FA, &28, &25, &FA, &23
 EQUB &C0, &20, &FF, &62, &28, &00, &62, &28
 EQUB &40

.HookFlipAbsolute

 EQUB &45, &25, &20, &50, &34, &60

\ ******************************************************************************
\
\       Name: HookSlopeJump
\       Type: Subroutine
\   Category: Extra track data
\    Summary: Jump the car when driving fast over sloping segments
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from part 5 of ApplyElevation to jump the car off the
\ ground when driving fast over sloping segments.
\
\ If the car is on the ground, replace the heightAboveTrack * 4 part of the
\ car's y-coordinate calculation with playerSpeedHi * yTrackSegmentI * 4, to
\ give:
\
\   (yPlayerCoordTop yPlayerCoordHi) =   (ySegmentCoordIHi ySegmentCoordILo)
\                                      + carProgress * yTrackSegmentI
\                                      + playerSpeedHi * yTrackSegmentI * 4
\                                      + 172
\
\ So driving fast over sloping segments can make the car jump.
\
\ Arguments:
\
\   A                   Current value of heightAboveTrack
\
\ ******************************************************************************

.HookSlopeJump

 BNE slop1              \ If A is non-zero, skip the following (so the hook has
                        \ no effect when the car is off the ground)

                        \ If we get here then heightAboveTrack = 0, so the car
                        \ is on the ground 

 LDA playerSpeedHi      \ Set A = the high byte of the current speed

 JSR MultiplyHeight     \ Set:
                        \
                        \   A = A * yTrackSegmentI
                        \     = playerSpeedHi * yTrackSegmentI
                        \
                        \ The value given in yTrackSegmentI is the y-coordinate
                        \ of the segment vector, i.e. the vector from this
                        \ segment to the next, which is the same as the change
                        \ in height as we move through the segment
                        \
                        \ So this value is higher with greater speed and on
                        \ segments that have higher slopes

 BPL slop1              \ If A is positive, skip the following instruction

 DEC W                  \ Decrement W to &FF, so (W A) has the correct sign

.slop1

 ASL A                  \ Implement the shifts that we overwrote with the call
 ROL W                  \ to the hook routine, so we have effectively inserted
                        \ the above code into the main game

 RTS                    \ Return from the subroutine

 EQUB &A0, &B5
 EQUB &C9, &A0, &F0, &07, &C9, &A8, &D0, &05
 EQUB &4E, &FB, &62, &A0, &C3, &4C, &CF, &53

.HookBackground

 EQUB &B9, &61, &5F, &C9, &8B, &F0, &04, &B9
 EQUB &60, &5F, &60, &4A, &60, &26, &77, &60
 EQUB &00, &00, &C0, &28, &AE, &02, &FC, &00

\ &5A00

 EQUB &09, &05, &00, &01, &01, &00, &68, &00
 EQUB &68, &45, &35, &2F, &2A, &A1, &00, &A1
 EQUB &6A, &52, &48, &41, &86, &92, &98, &08
 EQUB &21, &2D, &00

.HookFirstSegment

 EQUB &20, &7F, &55, &4C, &72
 EQUB &54, &00

\ ******************************************************************************
\
\       Name: CallTrackHook
\       Type: Subroutine
\   Category: Extra track data
\    Summary: The track file's hook code
\  Deep dive: The track data file format
\
\ ******************************************************************************

.CallTrackHook

 JMP ModifyGameCode     \ Modify the main game code

\ ******************************************************************************
\
\       Name: trackChecksum
\       Type: Variable
\   Category: Extra track data
\    Summary: The track file's checksum
\  Deep dive: The track data file format
\
\ ******************************************************************************

.trackChecksum

 EQUB &A2               \ Counts the number of data bytes ending in %00

 EQUB &C2               \ Counts the number of data bytes ending in %01

 EQUB &3E               \ Counts the number of data bytes ending in %10
 
 EQUB &7F               \ Counts the number of data bytes ending in %11

\ ******************************************************************************
\
\       Name: trackGameName
\       Type: Variable
\   Category: Extra track data
\    Summary: The game name
\  Deep dive: The track data file format
\
\ ------------------------------------------------------------------------------
\
\ This string is checked by the loader to see whether a track file has been
\ loaded (and if not, it loads one).
\
\ ******************************************************************************

.trackGameName

 EQUS "REVS"            \ Game name

\ ******************************************************************************
\
\       Name: trackName
\       Type: Variable
\   Category: Extra track data
\    Summary: The track name
\  Deep dive: The track data file format
\
\ ------------------------------------------------------------------------------
\
\ This string is shown on the loading screen.
\
\ ******************************************************************************

.trackName

 EQUS "Snetterton"      \ Track name
 EQUB 13

 EQUB &0D, &72          \ These bytes appear to be unused
 EQUB &6B, &0D
 EQUB &22, &20
 EQUB &42, &52
 EQUB &41, &4E
 EQUB &44, &53
 EQUB &20, &48
 EQUB &41, &54
 EQUB &43, &48
 EQUB &22, &2C
 EQUB &22, &20
 EQUB &44, &4F
 EQUB &4E, &49
 EQUB &4E, &47
 EQUB &54, &4F
 EQUB &4E, &20
 EQUB &50, &41
 EQUB &52, &4B
 EQUB &22, &2C
 EQUB &22, &20
 EQUB &4F, &55
 EQUB &4C, &54
 EQUB &4F, &4E
 EQUB &20, &50
 EQUB &41, &52
 EQUB &4B, &20
 EQUB &20, &20
 EQUB &22, &2C
 EQUB &22, &20
 EQUB &53, &4E
 EQUB &45, &54
 EQUB &54, &45
 EQUB &52, &54
 EQUB &4F, &4E
 EQUB &20, &20
 EQUB &20, &20
 EQUB &22, &0D
 EQUB &04, &06
 EQUB &0A, &20
 EQUB &DC, &22
 EQUB &22, &20
 EQUB &20, &0D
 EQUB &04, &10
 EQUB &24, &20
 EQUB &F4, &20
 EQUB &50, &72
 EQUB &6F, &67
 EQUB &72, &61
 EQUB &6D, &73
 EQUB &20, &6F
 EQUB &6E, &20
 EQUB &74, &68
 EQUB &65, &20
 EQUB &64, &69
 EQUB &73, &63
 EQUB &20, &6F
 EQUB &72, &20
 EQUB &74, &61
 EQUB &70, &65
 EQUB &20, &0D
 EQUB &04, &1A
 EQUB &11, &20
 EQUB &DC, &42
 EQUB &20, &2C
 EQUB &44, &20
 EQUB &2C, &4F
 EQUB &20, &2C
 EQUB &53, &20
 EQUB &0D, &04
 EQUB &24, &0E
 EQUB &20, &DC
 EQUB &22, &22
 EQUB &20, &20
 EQUB &20, &20
 EQUB &20, &20
 EQUB &0D, &FF

\ ******************************************************************************
\
\ Save Snetterton.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/Snetterton.bin", CODE%, P%

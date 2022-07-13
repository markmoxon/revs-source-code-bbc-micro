\ ******************************************************************************
\
\ REVS NURBURGRING TRACK SOURCE
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
\   * Nurburgring.bin
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
ScanKeyboard        = &0E50
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
\ REVS NURBURGRING TRACK
\
\ Produces the binary file Nurburgring.bin that contains the Nurburgring track.
\
\ ******************************************************************************

ORG CODE%

\ ******************************************************************************
\
\       Name: trackData
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.trackData

 EQUB &01, &2E, &1F, &00, &2D, &FF, &00, &FF
 EQUB &13, &2E, &1D, &26, &2D, &4D, &26, &92
 EQUB &22, &2E, &18, &4E, &2D, &0E, &4E, &07
 EQUB &32, &31, &17, &50, &31, &2D, &51, &22
 EQUB &41, &35, &13, &5F, &34, &FF, &5E, &FF
 EQUB &53, &2B, &11, &72, &2A, &10, &71, &B5
 EQUB &55, &27, &0F, &7B, &26, &1F, &7A, &0F
 EQUB &55, &1D, &0D, &7E, &1E, &0C, &7D, &79
 EQUB &55, &16, &0B, &7C, &16, &18, &7B, &0D
 EQUB &64, &12, &09, &80, &11, &FF, &81, &FF
 EQUB &63, &15, &07, &89, &14, &58, &89, &70
 EQUB &73, &14, &00, &B2, &13, &1D, &B2, &0E
 EQUB &83, &1B, &03, &B3, &1C, &34, &B3, &FF
 EQUB &93, &1A, &0D, &96, &1C, &25, &96, &0F
 EQUB &93, &20, &14, &8D, &21, &00, &8E, &FF
 EQUB &93, &23, &15, &8B, &23, &21, &8C, &17
 EQUB &A3, &28, &18, &86, &29, &4B, &87, &9C
 EQUB &B3, &39, &21, &65, &3A, &1B, &65, &0F
 EQUB &C5, &3F, &20, &63, &3E, &17, &64, &A2
 EQUB &C4, &4B, &1E, &67, &4B, &20, &68, &12
 EQUB &D3, &52, &1B, &62, &54, &36, &62, &FF
 EQUB &E3, &55, &11, &42, &56, &32, &42, &1C
 EQUB &E2, &53, &10, &39, &54, &47, &38, &C1
 EQUB &F3, &40, &18, &18, &41, &13, &18, &07
 EQUB &F3, &40, &1A, &13, &41, &27, &13, &24
 EQUB &F3, &3E, &1E, &08, &3F, &1A, &08, &7F
 EQUB &F3, &37, &1F, &FD, &38, &1F, &FC, &10
 EQUB &30, &30, &0D, &21, &E8, &FF, &20, &FF

\ ******************************************************************************
\
\       Name: L53E0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ Not in BH
\
\ ******************************************************************************

.L53E0

\ EQUB &A5, &44, &20, &50, &34, &C9, &19, &B0
\ EQUB &07, &A5, &0D, &10, &03, &4C, &55, &56
\ EQUB &4C, &51, &B4

 LDA &44
 JSR Absolute8Bit       \ Same address in C64 and BBC
 CMP #&19

.L53E7

 BCS L53F0
 LDA &0D
 BPL L53F0
 JMP L5655

\ ******************************************************************************
\
\       Name: L53F0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53F0

\ &B451 -> &1933 = CheckVergeOnScreen
\ JMP &B451 -> JMP CheckVergeOnScreen

 JMP CheckVergeOnScreen

 EQUB &08, &00, &12, &11, &08

\ ******************************************************************************
\
\       Name: L53F8
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53F8

 EQUB &08

\ ******************************************************************************
\
\       Name: L53F9
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53F9

 EQUB &F0

\ ******************************************************************************
\
\       Name: L53FA
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53FA

 EQUB &EC

\ ******************************************************************************
\
\       Name: L53FB
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53FB

 EQUB &2D

\ ******************************************************************************
\
\       Name: L53FC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53FC

 EQUB &16

\ ******************************************************************************
\
\       Name: L53FD
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53FD

 EQUB &04

\ ******************************************************************************
\
\       Name: L53FE
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53FE

 EQUB &F0

\ ******************************************************************************
\
\       Name: L53FF
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53FF

 EQUB &08

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

\ EQUB &FD, &3E, &8B, &E8, &B0, &7C, &78, &28
\ EQUB &20, &18, &26, &2E, &38, &68, &86

.modifyAddressLo

 EQUB &49               \ !&1249 = HookSectionFrom
 EQUB &8A               \ !&128A = HookFirstSegment
 EQUB &CA               \ !&13CA = HookSegmentVector
 EQUB &27               \ !&1427 = HookSegmentVector
 EQUB &FC               \ !&12FC = HookDataPointers
\EQUB &1B               \ !&261B = HookUpdateHorizon
\EQUB &8C               \ !&248C = HookFieldOfView
 EQUB &39               \ !&2539 = HookFixHorizon
 EQUB &94               \ !&1594 = HookJoystick
 EQUB &D1               \ !&4CD1 = xTrackSignVector
 EQUB &C9               \ !&4CC9 = yTrackSignVector
 EQUB &C1               \ !&4CC1 = zTrackSignVector
 EQUB &D6               \ !&44D6 = trackRacingLine
 EQUB &D7               \ !&4CD7 = trackSignData
 EQUB &E1               \ !&4CE1 = trackSignData
 EQUB &47               \ !&1947 = HookFlattenHills
\EQUB &F3               \ !&24F3 = HookMoveBack
\EQUB &2C               \ !&462C = HookFlipAbsolute
 EQUB &43               \ !&2543 = Hook80Percent
\EQUB &24               \ !&2F24 = HookBackground

 EQUB &33, &3C          \ These bytes appear to be unused
 EQUB &4A, &57
 EQUB &61

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

\ EQUB &11, &12, &13, &13, &12, &22, &15, &4D
\ EQUB &4D, &4D, &45, &4D, &4D, &B4, &22

.modifyAddressHi

 EQUB &12               \ !&1249 = HookSectionFrom
 EQUB &12               \ !&128A = HookFirstSegment
 EQUB &13               \ !&13CA = HookSegmentVector
 EQUB &14               \ !&1427 = HookSegmentVector
 EQUB &12               \ !&12FC = HookDataPointers
\EQUB &26               \ !&261B = HookUpdateHorizon
\EQUB &24               \ !&248C = HookFieldOfView
 EQUB &25               \ !&2539 = HookFixHorizon
 EQUB &15               \ !&1594 = HookJoystick
 EQUB &4C               \ !&4CD1 = xTrackSignVector
 EQUB &4C               \ !&4CC9 = yTrackSignVector
 EQUB &4C               \ !&4CC1 = zTrackSignVector
 EQUB &44               \ !&44D6 = trackRacingLine
 EQUB &4C               \ !&4CD7 = trackSignData
 EQUB &4C               \ !&4CE1 = trackSignData
 EQUB &19               \ !&1947 = HookFlattenHills
\EQUB &24               \ !&24F3 = HookMoveBack
\EQUB &46               \ !&462C = HookFlipAbsolute
 EQUB &25               \ !&2543 = Hook80Percent
\EQUB &2F               \ !&2F24 = HookBackground

 EQUB &2E, &3F          \ These bytes appear to be unused
 EQUB &4F, &57
 EQUB &5B

\ ******************************************************************************
\
\       Name: L5428
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5428

 EQUB &00, &00, &00, &00, &07, &00, &FD, &FE
 EQUB &FE, &00, &00, &00, &00, &FD, &05, &FF
 EQUB &FF, &00, &05, &00, &00, &FE, &00, &01
 EQUB &00, &00, &00, &00, &FC, &FC, &00, &03
 EQUB &00, &00, &00, &01, &00, &00, &00, &FC
 EQUB &03, &00, &00, &04, &04, &05, &05, &05
 EQUB &05, &05, &05, &07, &0B, &10, &14, &18
 EQUB &1C, &20

\ ******************************************************************************
\
\       Name: trackSignData
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.trackSignData

 EQUB &01, &08, &14, &20, &35, &44
 EQUB &5B, &60, &6D, &7C, &8D, &90, &9C, &AC
 EQUB &B5, &D4

\ ******************************************************************************
\
\       Name: L5472
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

\ EQUB &AD, &FC, &53, &0A, &AD, &FD
\ EQUB &53, &2A, &48, &2A, &2A, &2A, &29, &07
\ EQUB &85, &75, &4A, &68, &29, &3F, &90, &04
\ EQUB &49, &3F, &69, &00, &AA, &BC, &BF, &57
\ EQUB &BD, &BF, &58, &AA, &A5, &75, &18, &69
\ EQUB &01, &29, &02, &D0, &06, &84, &76, &86
\ EQUB &77, &F0, &04, &86, &76, &84, &77, &A5
\ EQUB &75, &C9, &04, &90, &06, &A9, &00, &E5
\ EQUB &76, &85, &76, &A5, &75, &C9, &06, &B0
\ EQUB &0A, &C9, &02, &90, &06, &A9, &00, &E5
\ EQUB &77, &85, &77, &A4, &02, &A9, &9A, &85
\ EQUB &75, &A5, &76, &99, &00, &54, &20, &5C
\ EQUB &55, &99, &00, &58, &A5, &77, &99, &00
\ EQUB &56, &20, &5C, &55, &49, &FF, &18, &69
\ EQUB &01, &99, &00, &57, &AD, &FE, &53, &99
\ EQUB &00, &55, &60, &A5, &91, &29, &40, &F0
\ EQUB &03, &20, &82, &55, &A5, &24, &18, &69
\ EQUB &03, &60

.L5472

 LDA L53FC              \ L53FA in BH
 ASL A
 LDA L53FD              \ L53FB in BH
 ROL A
 PHA
 ROL A
 ROL A
 ROL A
 AND #&07
 STA &75
 LSR A
 PLA
 AND #&3F
 BCC L548C

.L5488

 EOR #&3F
 ADC #&00

.L548C

 TAX
 LDY L57BF,X
 LDA L58BF,X
 TAX
 LDA &75
 CLC
 ADC #&01
 AND #&02
 BNE L54A3
 STY &76
 STX &77
 BEQ L54A7

.L54A3

 STX &76
 STY &77

.L54A7

 LDA &75
 CMP #&04
 BCC L54B3
 LDA #&00
 SBC &76
 STA &76

.L54B3

 LDA &75
 CMP #&06
 BCS L54C3
 CMP #&02
 BCC L54C3
 LDA #&00
 SBC &77
 STA &77

.L54C3

 LDY &02
 LDA #&9A               \ #88 in BH
 STA &75
 LDA &76
 STA &5400,Y
 JSR L555C              \ 57BB in BH
 STA &5800,Y
 LDA &77
 STA &5600,Y
 JSR L555C              \ 57BB in BH
 EOR #&FF
 CLC
 ADC #&01
 STA &5700,Y
 LDA L53FE              \ 53FC in BH
 STA &5500,Y
 RTS

\ ******************************************************************************
\
\       Name: HookDataPointers
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ Called L54F1 in BH
\
\ ******************************************************************************

.HookDataPointers

 LDA &01                \ #01 in BH
 AND #&40
 BEQ L54F4
 JSR L5582

.L54F4

 LDA &24
 CLC
 ADC #&03
 RTS

 EQUB &0C, &08, &03, &FE, &FB, &00

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
\ have been done. The block is padded out to be exactly 20 bytes long, so along
\ with the newContentHi block, there's one byte for each inner segment
\ z-coordinate.
\
\ ******************************************************************************

.newContentLo

\ EQUB &72, &1B, &72, &72, &EB, &72, &D9, &62
\ EQUB &62, &62, &A0, &62, &62, &C4, &55

 EQUB LO(HookSectionFrom)
 EQUB LO(HookFirstSegment)
 EQUB LO(HookSegmentVector)
 EQUB LO(HookSegmentVector)
 EQUB LO(HookDataPointers)
\EQUB LO(HookUpdateHorizon)
\EQUB LO(HookFieldOfView)
 EQUB LO(HookFixHorizon)
 EQUB LO(HookJoystick)
 EQUB LO(xTrackSignVector)
 EQUB LO(yTrackSignVector)
 EQUB LO(zTrackSignVector)
 EQUB LO(trackRacingLine)
 EQUB LO(trackSignData)
 EQUB LO(trackSignData)
 EQUB LO(HookFlattenHills)
\EQUB LO(HookMoveBack)
\EQUB LO(HookFlipAbsolute)
 EQUB LO(Hook80Percent)

 EQUB &00, &00          \ These bytes pad the block out to exactly 20 bytes
 EQUB &00, &00
 EQUB &00

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
\ have been done. The block is padded out to be exactly 20 bytes long, so along
\ with the newContentLo block, there's one byte for each inner segment
\ z-coordinate.
\
\ ******************************************************************************

.newContentHi

\ EQUB &56, &5A, &55, &55, &54, &57, &59, &55
\ EQUB &56, &57, &58, &54, &54, &56, &55

 EQUB HI(HookSectionFrom)
 EQUB HI(HookFirstSegment)
 EQUB HI(HookSegmentVector)
 EQUB HI(HookSegmentVector)
 EQUB HI(HookDataPointers)
\EQUB HI(HookUpdateHorizon)
\EQUB HI(HookFieldOfView)
 EQUB HI(HookFixHorizon)
 EQUB HI(HookJoystick)
 EQUB HI(xTrackSignVector)
 EQUB HI(yTrackSignVector)
 EQUB HI(zTrackSignVector)
 EQUB HI(trackRacingLine)
 EQUB HI(trackSignData)
 EQUB HI(trackSignData)
 EQUB HI(HookFlattenHills)
\EQUB HI(HookMoveBack)
\EQUB HI(HookFlipAbsolute)
 EQUB HI(Hook80Percent)

 EQUB &00, &00          \ These bytes pad the block out to exactly 20 bytes
 EQUB &00, &00
 EQUB &00

\ ******************************************************************************
\
\       Name: L5528
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5528

 EQUB &00, &00, &00, &00, &E8, &00, &54, &C6
 EQUB &C6, &00, &00, &00, &00, &8F, &9E, &B7
 EQUB &B7, &00, &93, &00, &00, &37, &00, &AD
 EQUB &00, &00, &00, &00, &09, &09, &00, &68
 EQUB &00, &00, &00, &45, &00, &00, &00, &9B
 EQUB &9C, &F6, &00, &35, &35

\ ******************************************************************************
\
\       Name: Hook80Percent
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ Called L53F0 in BH
\
\ ******************************************************************************

\ EQUB &85, &75, &A9
\ EQUB &CD, &4C, &00, &0C, &08, &4C, &6B, &46

.Hook80Percent

 STA &75
 LDA #&CD
 JMP Multiply8x8        \ Same address in C64 and BBC

\ ******************************************************************************
\
\       Name: L555C
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ Called L57BB in BH
\
\ ******************************************************************************

.L555C

 PHP

\ &466B -> &461B = CheckVergeOnScreen
\ JMP &466B -> JMP &461B

 JMP &461B

 EQUB &FC, &FC

\ ******************************************************************************
\
\       Name: xTrackSignVector
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.xTrackSignVector

 EQUB &01, &FA, &FB, &09, &1C, &06
 EQUB &09, &FE, &00, &03, &DF, &FB, &FA, &FF
 EQUB &D9, &1F

\ ******************************************************************************
\
\       Name: HookSegmentVector
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

\ EQUB &A5, &91, &29, &40, &F0, &06, &20, &A1
\ EQUB &13, &20, &BD, &55, &60, &20, &A1, &13
\ EQUB &AC, &FA, &53, &AD, &FF, &53, &38, &24
\ EQUB &25, &30, &13, &69, &00, &D9, &28, &57
\ EQUB &90, &22, &A9, &00, &C8, &CC, &FB, &53
\ EQUB &90, &1A, &A0, &00, &F0, &16, &E9, &01
\ EQUB &B0, &12, &98, &29, &7F, &A8, &C0, &01
\ EQUB &B0, &03, &AC, &FB, &53, &88, &B9, &28
\ EQUB &57, &38, &E9, &01, &8D, &FF, &53, &8C
\ EQUB &FA, &53, &60, &86, &45, &AC, &FA, &53
\ EQUB &30, &2F, &B9, &28, &55, &85, &74, &B9
\ EQUB &28, &54, &24, &25, &20, &40, &0E, &85
\ EQUB &75, &A5, &74, &18, &6D, &FC, &53, &8D
\ EQUB &FC, &53, &A5, &75, &6D, &FD, &53, &8D
\ EQUB &FD, &53, &B9, &28, &56, &24, &25, &20
\ EQUB &50, &34, &18, &6D, &FE, &53, &8D, &FE
\ EQUB &53, &20, &72, &54, &A6, &45, &60

.HookSegmentVector

 LDA &01                \ 01 in BH
 AND #&40
 BEQ L557E

\ &13A1 -> &13E0 = UpdateVectorNumber
\ JSR &13A1 -> JSR UpdateVectorNumber

 JSR UpdateVectorNumber

 JSR HookMoveBack              \ 55C4 in BH

.L557E

 RTS

\ ******************************************************************************
\
\       Name: L557F
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L557F

\ &13A1 -> &13E0 = UpdateVectorNumber
\ JSR &13A1 -> JSR UpdateVectorNumber

 JSR UpdateVectorNumber

\ ******************************************************************************
\
\       Name: L5582
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5582

 LDY L53FA              \ 53F8 in BH
 LDA L53FF              \ 53FD in BH
 SEC
 BIT &25
 BMI L55A0
 ADC #&00
 CMP L5728,Y
 BCC L55B6
 LDA #&00
 INY
 CPY L53FB              \ 53F9 in BH
 BCC L55B6
 LDY #&00
 BEQ L55B6

.L55A0

 SBC #&01
 BCS L55B6
 TYA
 AND #&7F
 TAY
 CPY #&01
 BCS L55AF
 LDY L53FB              \ 53F9 in BH

.L55AF

 DEY
 LDA L5728,Y
 SEC
 SBC #&01

.L55B6

 STA L53FF              \ 53FD in BH
 STY L53FA              \ 53F8 in BH
 RTS

\ ******************************************************************************
\
\       Name: HookMoveBack
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ L55C4 in BH
\
\ ******************************************************************************

.HookMoveBack

 STX &45
 LDY L53FA              \ 53F8 in BH
 BMI L55F3
 LDA L5528,Y
 STA &74
 LDA L5428,Y
 BIT &25
 JSR Absolute16Bit      \ Same address in C64 and BBC
 STA &75
 LDA &74
 CLC
 ADC L53FC              \ 53FA in BH
 STA L53FC              \ 53FA in BH
 LDA &75
 ADC L53FD              \ 53FB in BH
 STA L53FD              \ 53FB in BH
 LDA L5628,Y
 BIT &25
 JSR Absolute8Bit       \ Same address in C64 and BBC
 CLC
 ADC L53FE              \ 53FC in BH
 STA L53FE              \ 53FC in BH

.L55F3

 JSR L5472
 LDX &45
 RTS

 EQUB &0D, &0A, &07, &03, &00, &00, &00

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

\ EQUB &A9, &04, &8D, &74, &35, &A9, &0B, &8D
\ EQUB &F4, &35, &A9, &AD, &8D, &1C, &46, &A9
\ EQUB &57, &8D, &1D, &46, &A9, &4B, &8D, &46
\ EQUB &25, &A9, &FF, &8D, &2B, &28, &60

\ LDA #&04
\ STA &3574      \ Same, changes 0 to 4
\ LDA #&0B
\ STA &35F4      \ Same, changes 3 to &B

\ &461C/D -> &45CC, !&45CC/D = L57AD (also needs &461B -> &45CB, !&45CB = &20)

\ LDA #&AD
\ STA &461C
\ LDA #&57
\ STA &461D

\ &2546 -> &2772, ?&2772 = &4B

\ LDA #&4B
\ STA &2546

\ &282B -> &298E, ?&298E = &FF

\ LDA #&FF
\ STA &282B

 LDA #4                 \ ?&3574 = 4 (object dimension in objectTop)
 STA &3574

 LDA #11                \ ?&35F4 = 11 (object dimension in objectBottom)
 STA &35F4

 LDA #LO(HookSlopeJump) \ !&45CC = HookSlopeJump (address in a JSR &xxxx
 STA &45CC              \                         instruction)
 LDA #HI(HookSlopeJump)
 STA &45CD

 LDA #75                \ ?&2772 = 75 (argument in a CMP #75 instruction)
 STA &2772

 LDA #&FF               \ THIS ONE IS NEW
 STA &298E

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: L561F
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L561F

 EQUB &6F
 EQUB &73, &75, &74, &6F, &66, &5B, &52, &4E

\ ******************************************************************************
\
\       Name: L5628
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5628

 EQUB &00, &00, &FF, &00, &00, &00, &00, &00
 EQUB &01, &01, &00, &00, &FF, &00, &00, &00
 EQUB &01, &01, &01, &00, &01, &00, &00, &FF
 EQUB &00, &FF, &FE, &00, &00, &00, &00, &FF
 EQUB &FF, &00, &01, &01, &00, &01, &00, &00
 EQUB &FF, &FF, &FF, &00, &FF

\ ******************************************************************************
\
\       Name: L5655
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ Not in BH
\
\ ******************************************************************************

.L5655

\ EQUB &AD, &FF, &88
\ EQUB &C9, &30, &B0, &03, &46, &76, &60, &4C
\ EQUB &51, &B4

\ LDA &88FF
 LDA &06FF

 CMP #&30
 BCS L565F
 LSR &76
 RTS

.L565F

\ &B451 -> &1933 = CheckVergeOnScreen
\ JMP &B451 -> JMP CheckVergeOnScreen

 JMP CheckVergeOnScreen

\ ******************************************************************************
\
\       Name: yTrackSignVector
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.yTrackSignVector

 EQUB &F8, &06, &43, &23, &27, &0C
 EQUB &16, &FA, &A6, &09, &FA, &08, &09, &5D
 EQUB &1B, &F5

\ ******************************************************************************
\
\       Name: HookSectionFrom
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

\ EQUB &84, &1B, &B9, &05, &59, &85
\ EQUB &02, &98, &4A, &4A, &4A, &A8, &B9, &46
\ EQUB &58, &8D, &FC, &53, &B9, &64, &58, &8D
\ EQUB &FD, &53, &B9, &28, &58, &8D, &FE, &53
\ EQUB &B9, &82, &58, &4A, &6A, &8D, &FA, &53
\ EQUB &A9, &0E, &6A, &8D, &C0, &20, &A9, &00
\ EQUB &8D, &FF, &53, &24, &25, &30, &03, &20
\ EQUB &BD, &55, &A4, &1B, &A5, &02, &60, &85
\ EQUB &75, &68, &20, &00, &0C, &28, &F0, &09
\ EQUB &85, &75, &20, &00, &0C, &06, &74, &2A
\ EQUB &60, &4C, &00, &0C, &98, &29, &20, &85
\ EQUB &82, &A9, &00, &85, &7F, &88, &B9, &E0
\ EQUB &84, &C5, &1F, &B0, &1E, &C5, &7F, &B0
\ EQUB &F2, &A5, &7F, &69, &00, &99, &E0, &84
\ EQUB &A5, &82, &D0, &E9, &A5, &7F, &8D, &0C
\ EQUB &1B, &C8, &20, &7E, &22, &88, &38, &66
\ EQUB &82, &30, &DA, &A4, &4B, &88, &84, &75
\ EQUB &4C, &E0, &53

.HookSectionFrom

 STY &1B
 LDA L5905,Y
 STA &02
 TYA
 LSR A
 LSR A
 LSR A
 TAY
 LDA L5846,Y
 STA L53FC              \ 53FA in BH
 LDA L5864,Y
 STA L53FD              \ 53FB in BH
 LDA L5828,Y
 STA L53FE              \ 53FC in BH
 LDA L5882,Y
 LSR A
 ROR A
 STA L53FA              \ 53F8 in BH
 LDA #&0E
 ROR A

\ STA &20C0
 STA &23B3

 LDA #&00
 STA L53FF              \ 53FD in BH
 BIT &25
 BMI L56AA
 JSR HookMoveBack       \ 55C4 in BH

.L56AA

 LDY &1B
 LDA &02
 RTS

\ ******************************************************************************
\
\       Name: L56AF
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ Different to BH
\
\ ******************************************************************************

.L56AF

 STA &75
 PLA
 JSR Multiply8x8        \ Same address in C64 and BBC
 PLP
 BEQ L56C1
 STA &75
 JSR Multiply8x8        \ Same address in C64 and BBC
 ASL &74
 ROL A
 RTS

\ ******************************************************************************
\
\       Name: L56C1
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L56C1

 JMP Multiply8x8        \ Same address in C64 and BBC

\ ******************************************************************************
\
\       Name: HookFlattenHills
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ L56C8 in BH
\
\ ******************************************************************************

.HookFlattenHills

 TYA
 AND #&20
 STA &82
 LDA #&00

.L56CB

 STA &7F

.L56CD

 DEY

\ LDA &84E0,Y
 LDA &5F20,Y

 CMP &1F
 BCS L56F3
 CMP &7F
 BCS L56CB
 LDA &7F
 ADC #&00

\ STA &84E0,Y
 STA &5F20,Y

 LDA &82
 BNE L56CD
 LDA &7F

\ STA &1B0C
 STA &1FEA

 INY

\ &227E -> &253B = sub_C24F6
\ JSR &227E
 JSR &253B

 DEY
 SEC
 ROR &82
 BMI L56CD

.L56F3

 LDY &4B
 DEY
 STY &75
 JMP L53E0              \ JMP CheckVergeOnScreen in BH

 EQUB &78, &78, &78, &78, &00

\ ******************************************************************************
\
\       Name: L5700
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5700

\ ******************************************************************************
\
\       Name: ModifyGameCode (Part 1 of 4)
\       Type: Subroutine
\   Category: Extra track data
\    Summary: Modify the game code to support the extra track data
\
\ ------------------------------------------------------------------------------
\
\ The code modifications are done in four parts.
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

\ EQUB &A2, &0E, &BD, &14, &54, &85, &75, &BD
\ EQUB &00, &54, &85, &74, &A0, &00, &BD, &00
\ EQUB &55, &91, &74, &C8, &BD, &14, &55, &91
\ EQUB &74, &CA, &10, &E6, &4C, &00, &58

.ModifyGameCode

 LDX #14                \ We are about to modify 15 two-byte addresses in the
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

 JMP mods2              \ Jump to part 2

\ ******************************************************************************
\
\       Name: L571F
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L571F

 EQUB &AE
 EQUB &AB, &AA, &AD, &B2, &BA, &C3, &C6, &C8

\ ******************************************************************************
\
\       Name: L5728
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5728

 EQUB &53, &28, &16, &16, &07, &02, &14, &0A
 EQUB &07, &0B, &22, &03, &13, &18, &10, &2F
 EQUB &22, &09, &19, &26, &17, &19, &06, &0F
 EQUB &23, &0C, &1A, &08, &07, &08, &1C, &16
 EQUB &06, &24, &1B, &14, &15, &31, &0A, &0C
 EQUB &07, &11, &1D, &15, &04, &57, &57, &57
 EQUB &57, &57, &57, &57, &57, &57, &56, &55
 EQUB &55, &54

\ ******************************************************************************
\
\       Name: zTrackSignVector
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.zTrackSignVector

 EQUB &48, &0D, &B5, &DF, &CA, &FD
 EQUB &B7, &14, &3D, &04, &40, &FD, &03, &49
 EQUB &BE, &29

\ ******************************************************************************
\
\       Name: L5772
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

\ EQUB &8D, &0C, &1B, &99, &08, &85
\ EQUB &B9, &00, &84, &38, &F9, &28, &84, &B9
\ EQUB &50, &84, &F9, &78, &84, &10, &0C, &B9
\ EQUB &00, &84, &99, &28, &84, &B9, &50, &84
\ EQUB &99, &78, &84, &B9, &E0, &84, &99, &08
\ EQUB &85, &C0, &06, &B0, &08, &A9, &00, &99
\ EQUB &A0, &84, &99, &C8, &84, &C8, &C0, &09
\ EQUB &90, &CE, &A4, &51, &60

.HookFixHorizon

\ STA &1B0C
 STA &1FEA

\ STA &8508,Y
 STA &5F48,Y

.L5778

\ LDA &8400,Y
 LDA &5E40,Y

 SEC

\ SBC &8428,Y
 SBC &5E68,Y

\ LDA &8450,Y
 LDA &5E90,Y

\ SBC &8478,Y
 SBC &5EB8,Y

 BPL L5793

\ LDA &8400,Y
 LDA &5E40,Y

\ STA &8428,Y
 STA &5E68,Y

\ LDA &8450,Y
 LDA &5E90,Y

\ STA &8478,Y
 STA &5EB8,Y

.L5793

\ LDA &84E0,Y
 LDA &5F20,Y

\ STA &8508,Y
 STA &5F48,Y

 CPY #&06               \ Here to label not in BH
 BCS L57A5
 LDA #&00

\ STA &84A0,Y
 STA &5EE0,Y

\ STA &84C8,Y
 STA &5F08,Y

.L57A5

 INY
 CPY #&09
 BCC L5778
 LDY &51
 RTS

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

\ EQUB &D0, &09, &A5
\ EQUB &63, &20, &60, &46, &10, &02, &C6, &77
\ EQUB &0A, &26, &77, &60

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

\ ******************************************************************************
\
\       Name: L57BC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L57BC

 EQUB &F6, &F3, &F0

\ ******************************************************************************
\
\       Name: L57BF
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L57BF

 EQUB &00
 EQUB &01, &03, &04, &06, &07, &09, &0A, &0C
 EQUB &0D, &0F, &10, &12, &13, &15, &16, &17
 EQUB &19, &1A, &1C, &1D, &1F, &20, &21, &23
 EQUB &24, &26, &27, &28, &2A, &2B, &2D, &2E
 EQUB &2F, &31, &32, &33, &35, &36, &37, &39
 EQUB &3A, &3B, &3C, &3E, &3F, &40, &41, &43
 EQUB &44, &45, &46, &47, &49, &4A, &4B, &4C
 EQUB &4D, &4E, &4F, &51, &52, &53, &54, &55



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

\ EQUB &A9, &20, &8D, &FC, &11, &8D, &AF, &12
\ EQUB &8D, &7B, &22, &8D, &1B, &46, &A9, &EA
\ EQUB &8D, &88, &22, &A9, &A2, &8D, &0B, &1B
\ EQUB &4C, &00, &56

\ &11FC -> &1248, ?&1248 = &20
\ &12AF -> &12FB, ?&12FB = &20
\ &227B -> &2538, ?&2538 = &20
\ &461B -> &45CB, ?&45CB = &20

\ LDA #&20
\ STA &11FC
\ STA &12AF
\ STA &227B
\ STA &461B

\ &2288 -> &2545, ?&2545 = &EA

\ LDA #&EA
\ STA &2288

\ &1B0B -> &1FE9, ?&1FE9 = &A2

\ LDA #&A2
\ STA &1B0B

.mods2

 LDA #&20               \ ?&1248 = &20 (opcode for a JSR &xxxx instruction)
 STA &1248

 STA &12FB              \ ?&12FB = &20 (opcode for a JSR &xxxx instruction)

 STA &2538              \ ?&2538 = &20 (opcode for a JSR &xxxx instruction)

 STA &45CB              \ ?&45CB = &20 (opcode for a JSR &xxxx instruction)

 LDA #&EA               \ ?&2545 = &EA (opcode for a NOP instruction)
 STA &2545

 LDA #&A2               \ ?&1FE9 = &A2 (opcode for a LDX # instruction)
 STA &1FE9

 JMP mods3              \ Jump to part 3

\ ******************************************************************************
\
\       Name: L581B
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L581B

 EQUB &3A, &34, &2D, &25, &1E
 EQUB &16, &0E, &1B, &28, &34, &3E, &41, &43

\ ******************************************************************************
\
\       Name: L5828
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5828

 EQUB &FA, &FA, &E4, &E4, &EB, &F6, &E3, &E3
 EQUB &E3, &E3, &E3, &0E, &27, &3E, &3E, &3E
 EQUB &2F, &EF, &EF, &EF, &D9, &EE, &02, &33
 EQUB &33, &1B, &FE, &47, &44, &41

\ ******************************************************************************
\
\       Name: L5846
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5846

 EQUB &00, &00
 EQUB &00, &58, &0E, &0E, &0E, &76, &76, &56
 EQUB &56, &3D, &98, &98, &F7, &F7, &1A, &1A
 EQUB &A1, &A1, &91, &91, &F5, &F5, &39, &D3
 EQUB &D3, &19, &1C, &1E

\ ******************************************************************************
\
\       Name: L5864
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5864

 EQUB &00, &00, &00, &37
 EQUB &ED, &ED, &ED, &B2, &B2, &0C, &0C, &F5
 EQUB &80, &80, &53, &53, &6D, &6D, &31, &31
 EQUB &7C, &7C, &95, &95, &6D, &96, &96, &C3
 EQUB &BF, &BC

\ ******************************************************************************
\
\       Name: L5882
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5882

 EQUB &00, &04, &12, &1A, &26, &2E
 EQUB &36, &3B, &3A, &3F, &3E, &4A, &4E, &56
 EQUB &5A, &5E, &60, &72, &7A, &7E, &82, &8E
 EQUB &92, &9E, &A2, &AA, &AE, &D3, &D3, &D3

\ ******************************************************************************
\
\       Name: trackRacingLine
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.trackRacingLine

 EQUB &18, &18, &67, &48, &19, &19, &52, &30
 EQUB &47, &18, &18, &3B, &19, &3C, &00, &3D
 EQUB &19, &52, &50, &53, &18, &3D, &21, &6A
 EQUB &71, &18, &43, &18, &A9, &AA, &AA

\ ******************************************************************************
\
\       Name: L58BF
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L58BF

 EQUB &78
 EQUB &78, &78, &78, &78, &78, &78, &78, &77
 EQUB &77, &77, &77, &77, &76, &76, &76, &76
 EQUB &75, &75, &75, &74, &74, &74, &73, &73
 EQUB &72, &72, &71, &71, &70, &70, &6F, &6F
 EQUB &6E, &6E, &6D, &6C, &6C, &6B, &6B, &6A
 EQUB &69, &68, &68, &67, &66, &65, &65, &64
 EQUB &63, &62, &61, &60, &60, &5F, &5E, &5D
 EQUB &5C, &5B, &5A, &59, &58, &57, &56, &55

\ ******************************************************************************
\
\       Name: L5900
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5900

 EQUB &42, &E0, &40, &00, &BF

\ ******************************************************************************
\
\       Name: L5905
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5905

 EQUB &01, &00, &53
 EQUB &70, &E0, &4E, &E8, &BF, &05, &E8, &54
 EQUB &ED, &E0, &75, &48, &BF, &0A, &48, &09
 EQUB &73, &E8, &79, &AB, &A9, &14, &C4, &25
 EQUB &44, &79, &89, &34, &77, &12, &B2, &2D
 EQUB &68, &FB, &90, &03, &F9, &18, &81, &16
 EQUB &F3, &57, &F6, &35, &55, &07, &B3, &18
 EQUB &34, &AB, &3E, &C1, &0B, &20, &B1, &10
 EQUB &ED, &9B, &6E, &41, &FB, &22, &31, &10
 EQUB &02, &85, &9E, &C3, &70, &0B, &17, &13
 EQUB &70, &1E, &77, &4C, &09, &0C, &A0, &5A
 EQUB &ED, &5D, &F7, &D6, &45, &16, &89, &19
 EQUB &6A, &24, &9A, &41, &44, &07, &3E, &3D
 EQUB &73, &E7, &F9, &A9, &07, &1C, &A6, &19
 EQUB &40, &D8, &07, &3B, &5C, &0D, &3C, &06
 EQUB &6D, &5A, &7B, &F1, &DE, &13, &F2, &0F
 EQUB &6A, &1C, &A5, &EA, &1D, &22, &6B, &51
 EQUB &F3, &32, &40, &0F, &33, &23, &90, &0F
 EQUB &74, &4A, &41, &06, &E4, &0A, &13, &1C
 EQUB &ED, &8A, &65, &9E, &24, &26, &AB, &16
 EQUB &72, &E5, &F2, &8F, &05, &14, &A7, &45
 EQUB &6D, &97, &5A, &37, &B7, &09, &4F, &14
 EQUB &6A, &6F, &C4, &41, &69, &1D, &B0, &50
 EQUB &F3, &AF, &17, &C1, &A9, &1D, &30, &0C
 EQUB &6D, &BC, &7B, &5C, &BD, &01, &DD, &18
 EQUB &70, &48, &17, &C0, &3D, &19, &28, &1D

\ ******************************************************************************
\
\       Name: L59D0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L59D0

 EQUB &ED, &25, &73, &32, &1A, &0E, &9A, &19
 EQUB &42

\ ******************************************************************************
\
\       Name: HookJoystick
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ Not in BH
\
\ ******************************************************************************

\ EQUB &08, &48, &A4, &6F, &B9, &E8, &88
\ EQUB &A0, &B5, &C9, &58, &D0, &02, &A0, &D4
\ EQUB &C9, &40, &D0, &02, &A0, &CD, &C9, &D0
\ EQUB &D0, &02, &A0, &CA, &98, &4C, &AF, &56

.HookJoystick

 PHP
 PHA
 LDY &6F

\ LDA &88E8,Y
 LDA &06E8,Y

 LDY #&B5
 CMP #&58
 BNE L59E8
 LDY #&D4

.L59E8

 CMP #&40
 BNE L59EE
 LDY #&CD

.L59EE

 CMP #&D0
 BNE L59F4
 LDY #&CA

.L59F4

 TYA
 JMP L56AF

 EQUB &B5, &B8, &D8, &28, &D6, &03, &B0, &03

\ ******************************************************************************
\
\       Name: L5A00
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5A00

 EQUB &45, &41, &00, &01, &01, &00, &48, &00
 EQUB &48, &2F, &28, &23, &1E, &A8, &00, &A8
 EQUB &6F, &5D, &52, &46, &C2, &D3, &DC, &04
 EQUB &21, &19, &00

\ EQUB &20, &7F, &55, &4C, &72, &54

\ ******************************************************************************
\
\       Name: HookFirstSegment
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.HookFirstSegment 

 JSR L557F
 JMP L5472

 EQUB 0

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

 EQUB &60               \ Counts the number of data bytes ending in %00

 EQUB &00               \ Counts the number of data bytes ending in %01

 EQUB &00               \ Counts the number of data bytes ending in %10
 
 EQUB &78               \ Counts the number of data bytes ending in %11

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

 EQUS "Nurburgring"     \ Track name
 EQUB 13

 EQUB &00, &00, &00, &00, &00, &00, &00
 EQUB &4C, &00, &57, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &92, &5D, &28, &00, &03, &33, &00, &8B
 EQUB &3B, &80, &00, &00, &8B, &3B, &80, &00
 EQUB &00, &8B, &3B, &80, &00, &00, &8B, &47
 EQUB &A0, &00, &00, &8B, &55, &E4, &00, &00
 EQUB &8B, &2F, &EC, &00, &00, &8B, &1D, &5C
 EQUB &00, &00, &8A, &6D, &58, &00, &00, &8A
 EQUB &34, &D8, &00, &00, &8A, &14, &28, &00
 EQUB &00, &8A, &28, &F0, &00, &00, &8A, &22

\ EQUB &E8, &00, &00, &8A, &59, &20, &00, &00
\ EQUB &8A, &57, &38, &00, &00, &8B, &03, &60
\ EQUS "NURBURGRING"
\ EQUB &FF

\ ******************************************************************************
\
\ Save Nurburgring.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/Nurburgring.bin", CODE%, P%

\ ******************************************************************************
\
\ REVS NURBURGRING LOADER
\
\ Produces the binary file NurburgringSQR.bin that contains the extra loader
\ code for the Nurburgring track.
\
\ ******************************************************************************

ORG &9C00

\ ******************************************************************************
\
\       Name: L9C00
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L9C00

 LDA L9C42
 BEQ L9C3F

 ASL L9C42

 LDA #$44
 STA $0E85              \ Changes JSR ScanKeyboard to JSR L9C44, looks like the
 LDA #$9C               \ second one in ProcessShiftedKeys at 0EF5, but it's
 STA $0E86              \ quite different as the C64 doesn't use SHIFT keys

 LDA #$4C
 STA $154D              \ Changes JSR ScanKeyboard at 1583 in ProcessDrivingKeys
 LDA #$9D               \ to JMP L9C9D
 STA $154E
 LDA #$9C
 STA $154F

 LDA #$4C
 STA $15EE              \ Changes JSR ScanKeyboard at 15FE in ProcessDrivingKeys
 LDA #$8D               \ to JMP L9D8D
 STA $15EF
 LDA #$9D
 STA $15F0

\ &46AA -> &4658, !&4658
\ 4658   20 A8 1F   JSR sub_C1FA8               -> JSR L9DA7

\ LDA #$20
\ STA $46AA
\ LDA #$A7
\ STA $46AB
\ LDA #$9D
\ STA $46AC

 LDA #$20
 STA $4658              \ In Superior, changes JSR sub_C1FA8 at 4658 in
 LDA #$A7               \ sub_C4626 to JMP L9DA7
 STA $4659              \
 LDA #$9D               \ In Acornsoft, changes ROR L62FB at same address
 STA $465A              \ to JMP L9DA7

.L9C3F

\ JMP $5A30             \ $5A30 jumps straight to &5700
 JMP ModifyGameCode

\ ******************************************************************************
\
\       Name: L9C42
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L9C42

 EQUB &80

\ ******************************************************************************
\
\       Name: L9C43
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L9C43

 EQUB &00

\ ******************************************************************************
\
\       Name: L9C44
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L9C44

 JSR ScanKeyboard
 BNE L9C6E

 LDX #$22

 JSR ScanKeyboard
 BNE L9C68

 LDA L9C76
 BNE L9C60

 LDA L9C43
 EOR #%10000000
 STA L9C43
 JSR L9C77

.L9C60

 LDA #%10000000
 STA L9C76
 LDA #0
 RTS

.L9C68

 LDA #0
 STA L9C76
 RTS

.L9C6E

 LDA #0
 STA L9C76
 LDA #1
 RTS

\ ******************************************************************************
\
\       Name: L9C76
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L9C76

 EQUB 0

\ ******************************************************************************
\
\       Name: L9C77
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L9C77

 ASL A
 ROL A
 ROL A
 ROL A
 TAX
 LDA L9C95,X
 STA $7C23              \ CONVERT
 LDA L9C95+1,X
 STA $7C24              \ CONVERT
 LDA L9C95+2,X
 STA $7C1C              \ CONVERT
 LDA L9C95+3,X
 STA $7C1B              \ CONVERT
 RTS

\ ******************************************************************************
\
\       Name: L9C95
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L9C95

 EQUB &55, &55
 EQUB &55, &55
 EQUB &95, &65
 EQUB &59, &56

\ ******************************************************************************
\
\       Name: L9C9D
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L9C9D

 LDA L9C43
 BEQ L9CB6
 BIT $87F5              \ CONVERT
 BPL L9CDD
 BVS L9CBC
 LDA L9C43
 BEQ L9CB6
 LDA #0
 STA L9C43
 JSR L9C77

.L9CB6

 BIT $87F5              \ CONVERT
 JMP $1550              \ CONVERT

.L9CBC

 LDA #0
 STA $DC02              \ CONVERT
 LDA $DC00              \ CONVERT
 EOR #$FF
 STA $0803              \ CONVERT
 AND #4
 BEQ L9CD1
 LDA #2
 STA $76

.L9CD1

 LDA $0803              \ CONVERT
 AND #8
 BEQ L9CDA
 INC $76

.L9CDA

 JMP L9CF1

.L9CDD

 LDX #$2D
 JSR ScanKeyboard
 BNE L9CE8
 LDA #2
 STA $76

.L9CE8

 LDX #$16
 JSR ScanKeyboard
 BNE L9CF1
 INC $76

.L9CF1

 BIT $25
 BPL L9CF8
 JMP $15A7              \ CONVERT

.L9CF8

 LDA $76
 BNE L9CFF
 JMP $15E4              \ CONVERT

.L9CFF

 CMP #$03
 BNE L9D06
 JMP $162B              \ CONVERT

.L9D06

 LDX #$31
 CMP #$02
 BEQ L9D0E
 LDX #$09

.L9D0E

 LDA $66E2              \ CONVERT
 STA $76
 LSR A
 LDA $66E5              \ CONVERT
 BCC L9D25
 LDA #0
 SEC
 SBC $76
 STA $76
 LDA #0
 SBC $66E5              \ CONVERT

.L9D25

 CLC
 ADC #$01
 CPX #$31
 BNE L9D2E
 SBC #$02

.L9D2E

 STA $77
 LDA $8400,X              \ CONVERT
 SEC
 SBC $76
 STA $74
 LDA $8450,X              \ CONVERT
 SBC $77
 PHP
 JSR Absolute16Bit
 STA $76
 LDY $22
 LDA #$50
 SEC
 SBC $63
 BPL L9D4E
 LDA #0

.L9D4E

 ASL A
 ADC #$20
 STA $75
 LDA $8901,Y              \ CONVERT
 AND #$7F
 CMP #$40
 BCC L9D5E
 LDA #$03

.L9D5E

 CMP #$08
 BCC L9D64
 LDA #$07

.L9D64

 ASL A
 ASL A
 ASL A
 ASL A
 CMP $75
 BCC L9D6E
 STA $75

.L9D6E

 JSR $0DBF              \ CONVERT
 LDA $75
 PLP
 JSR $0E40              \ CONVERT
 STA $75
 LDA $74
 AND #$FE
 STA $74
 LDA $66E2              \ CONVERT
 LSR A
 BCS L9D8A
 JSR $0E44              \ CONVERT
 STA $75

.L9D8A

 JMP $15FF              \ CONVERT

\ ******************************************************************************
\
\       Name: L9D8D
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L9D8D

 JSR $0E40              \ CONVERT
 LSR A
 ROR $74
 CMP $66E5              \ CONVERT
 BCC L9DA2
 LDA $66E2              \ CONVERT
 AND #$FE
 STA $74
 LDA $66E5              \ CONVERT

.L9DA2

 STA $75
 JMP $15FF              \ CONVERT

\ ******************************************************************************
\
\       Name: L9DA7
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L9DA7

 BCC L9DAE
 LDA $0880,X              \ CONVERT
 CMP #$03

.L9DAE

 ROR $673B              \ CONVERT
 RTS

\ ******************************************************************************
\
\ Save NurburgringSWR.bin
\
\ ******************************************************************************

\ SAVE "3-assembled-output/NurburgringSWR.bin", &9C00, P%

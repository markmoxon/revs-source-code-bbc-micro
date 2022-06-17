\ ******************************************************************************
\
\ REVS BRANDS HATCH TRACK SOURCE
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
\   * BrandsHatch.bin
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

thisSectionFlags = &0001
thisVectorNumber = &0002
yStore = &001B
horizonLine = &001F
frontSegmentIndex = &0024
directionFacing = &0025
segmentCounter = &0042
playerPastSegment = &0043
xStore = &0045
vergeBufferEnd = &004B
horizonListIndex = &0051
playerSpeedHi = &0063
currentPlayer = &006F
T = &0074
U = &0075
V = &0076
W = &0077
topTrackLine = &007F
blockOffset = &0082
objTrackSection = &06E8
Multiply8x8 = &0C00
Absolute16Bit = &0E40
UpdateVectorNumber = &13E0
MovePlayerBack = &140B
CheckVergeOnScreen = &1933
gseg13 = &2490
gtrm2 = &2535
Absolute8Bit = &3450
MultiplyElevation = &4610
xTrackSegmentI = &5400
yTrackSegmentI = &5500
zTrackSegmentI = &5600
xTrackSegmentO = &5700
zTrackSegmentO = &5800
xVergeRightLo = &5E40
xVergeLeftLo = &5E68
xVergeRightHi = &5E90
xVergeLeftHi = &5EB8
yVergeRight = &5F20
yVergeLeft = &5F48

\ ******************************************************************************
\
\ REVS BRANDS HATCH TRACK
\
\ Produces the binary file BrandsHatch.bin that contains the Brands Hatch track.
\
\ ******************************************************************************

ORG CODE%

\ ******************************************************************************
\
\       Name: trackData
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.trackData

 EQUB &01, &D1, &14, &0F, &D0, &34, &0F, &7F
 EQUB &13, &D4, &14, &2A, &D3, &29, &2A, &1C
 EQUB &22, &E0, &0F, &2D, &E0, &FF, &2E, &FF
 EQUB &31, &EA, &0E, &29, &EA, &16, &2A, &49
 EQUB &31, &F3, &11, &23, &F4, &18, &24, &06
 EQUB &43, &F1, &0D, &1E, &F1, &15, &1D, &FF
 EQUB &44, &E6, &08, &23, &E5, &1F, &23, &12
 EQUB &53, &DE, &05, &21, &DE, &01, &20, &FF
 EQUB &54, &DA, &05, &1C, &DA, &27, &1B, &13
 EQUB &53, &D8, &05, &16, &D9, &2B, &16, &75
 EQUB &62, &D9, &05, &01, &DA, &28, &01, &14
 EQUB &61, &E5, &0A, &FC, &E4, &01, &FD, &7B
 EQUB &73, &EF, &11, &07, &EE, &FF, &08, &FF
 EQUB &82, &06, &11, &1B, &05, &FF, &1C, &FF
 EQUB &81, &12, &0E, &24, &11, &13, &25, &8E
 EQUB &90, &1B, &11, &2B, &1A, &2E, &2C, &17
 EQUB &92, &2A, &15, &2A, &2B, &32, &2B, &7F
 EQUB &A1, &3C, &14, &17, &3C, &25, &18, &12
 EQUB &A3, &3A, &14, &0C, &3B, &15, &0B, &FF
 EQUB &A2, &2D, &11, &00, &2D, &28, &FF, &14
 EQUB &A1, &29, &11, &FE, &2A, &15, &FD, &7B
 EQUB &B1, &1D, &14, &FB, &1D, &18, &FA, &0C
 EQUB &B3, &18, &15, &FC, &18, &21, &FB, &6C
 EQUB &C2, &0C, &14, &09, &0C, &1B, &09, &0D
 EQUB &C1, &05, &15, &0A, &06, &FF, &09, &FF
 EQUB &D3, &F9, &19, &FE, &FA, &2F, &FD, &7D
 EQUB &E2, &E5, &19, &EC, &E6, &2A, &EB, &18
 EQUB &E1, &DB, &16, &ED, &DA, &FF, &ED, &7D
 EQUB &F2, &D3, &17, &F7, &D2, &FF, &F7, &FF
 EQUB &00, &00, &00, &00, &00, &34, &00, &7F

\ ******************************************************************************
\
\       Name: sub_C53F0
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C53F0

 STA U

 LDA #205

 JMP Multiply8x8

 EQUB &00

\ ******************************************************************************
\
\       Name: L53F8
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53F8

 EQUB &00

\ ******************************************************************************
\
\       Name: L53F9
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53F9

 EQUB &3A

\ ******************************************************************************
\
\       Name: L53FA
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53FA

 EQUB &00

\ ******************************************************************************
\
\       Name: L53FB
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53FB

 EQUB &00

\ ******************************************************************************
\
\       Name: L53FC
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53FC

 EQUB &00

\ ******************************************************************************
\
\       Name: L53FD
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53FD

 EQUB &00

\ ******************************************************************************
\
\       Name: L53FE
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53FE

 EQUB &00

\ ******************************************************************************
\
\       Name: L53FF
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L53FF

 EQUB &00

\ ******************************************************************************
\
\       Name: modifyAddressLo
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ******************************************************************************

.modifyAddressLo

 EQUB &49               \ !&1249
 EQUB &8A               \ !&128A
 EQUB &CA               \ !&13CA
 EQUB &27               \ !&1427
 EQUB &FC               \ !&12FC
 EQUB &1B               \ !&261B
 EQUB &8C               \ !&248C
 EQUB &39               \ !&2539
 EQUB &94               \ !&1594
 EQUB &D1               \ !&4CD1
 EQUB &C9               \ !&4CC9
 EQUB &C1               \ !&4CC1
 EQUB &D6               \ !&44D6
 EQUB &D7               \ !&4CD7
 EQUB &E1               \ !&4CE1
 EQUB &47               \ !&1947
 EQUB &F3               \ !&24F3
 EQUB &2C               \ !&462C
 EQUB &43               \ !&2543

 EQUB &00

\ ******************************************************************************
\
\       Name: modifyAddressHi
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.modifyAddressHi

 EQUB &12               \ !&1249
 EQUB &12               \ !&128A
 EQUB &13               \ !&13CA
 EQUB &14               \ !&1427
 EQUB &12               \ !&12FC
 EQUB &26               \ !&261B
 EQUB &24               \ !&248C
 EQUB &25               \ !&2539
 EQUB &15               \ !&1594
 EQUB &4C               \ !&4CD1
 EQUB &4C               \ !&4CC9
 EQUB &4C               \ !&4CC1
 EQUB &44               \ !&44D6
 EQUB &4C               \ !&4CD7
 EQUB &4C               \ !&4CE1
 EQUB &19               \ !&1947
 EQUB &24               \ !&24F3
 EQUB &46               \ !&462C
 EQUB &25               \ !&2543

 EQUB &00

\ ******************************************************************************
\
\       Name: L5428
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5428

 EQUB &00, &00, &00, &01, &05, &01, &00, &02
 EQUB &00, &00, &00, &06, &00, &FC, &FD, &FC
 EQUB &FE, &FF, &FF, &FF, &FD, &FE, &FD, &FB
 EQUB &00, &00, &00, &01, &00, &00, &00, &00
 EQUB &00, &01, &01, &01, &04, &01, &03, &01
 EQUB &00, &00, &02, &03, &05, &FC, &FB, &00
 EQUB &00, &00, &00, &05, &02, &02, &00, &01
 EQUB &00, &00

\ ******************************************************************************
\
\       Name: extraSignData
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.extraSignData

 EQUB &0C, &10, &23, &20, &38, &4D
 EQUB &58, &60, &6C, &8C, &A4, &B5, &C0, &D4
 EQUB &E0, &01

\ ******************************************************************************
\
\       Name: sub_C5472
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C5472

 LDA L53FA
 ASL A

 LDA L53FB
 ROL A

 PHA

 ROL A
 ROL A
 ROL A
 AND #%00000111
 STA U

 LSR A

 PLA

 AND #%00111111

 BCC L548C

.L5488

 EOR #%00111111
 ADC #0

.L548C

 TAX

 LDY L57BF,X

 LDA L58BF,X
 TAX

 LDA U
 CLC
 ADC #1

 AND #%00000010
 BNE L54A3

 STY V

 STX W

 BEQ L54A7

.L54A3

 STX V

 STY W

.L54A7

 LDA U
 CMP #4
 BCC L54B3

 LDA #0
 SBC V
 STA V

.L54B3

 LDA U
 CMP #6
 BCS L54C3

 CMP #2
 BCC L54C3

 LDA #0
 SBC W
 STA W

.L54C3

 LDY thisVectorNumber

 LDA #%10001000
 STA U

 LDA V
 STA xTrackSegmentI,Y

 JSR sub_C57BB

 STA zTrackSegmentO,Y

 LDA W
 STA zTrackSegmentI,Y

 JSR sub_C57BB

 EOR #&FF
 CLC
 ADC #1
 STA xTrackSegmentO,Y

 LDA L53FC
 STA yTrackSegmentI,Y

 RTS

\ ******************************************************************************
\
\       Name: sub_C54EB
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C54EB

 EOR directionFacing

 JSR Absolute8Bit

 RTS

\ ******************************************************************************
\
\       Name: sub_C54F1
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C54F1

 LDA thisSectionFlags
 AND #%01000000
 BEQ L54FA

 JSR sub_C5582

.L54FA

 LDA frontSegmentIndex
 CLC
 ADC #3

 RTS

\ ******************************************************************************
\
\       Name: newContentLo
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.newContentLo

 EQUB LO(sub_C5672)
 EQUB LO(sub_C5A1B)
 EQUB LO(sub_C5572)
 EQUB LO(sub_C5572)
 EQUB LO(sub_C54F1)
 EQUB LO(sub_C56AF)
 EQUB LO(sub_C56BC)
 EQUB LO(sub_C5772)
 EQUB LO(sub_C57A1)
 EQUB LO(xExtraSignVector)
 EQUB LO(yExtraSignVector)
 EQUB LO(zExtraSignVector)
 EQUB LO(extraRacingLine)
 EQUB LO(extraSignData)
 EQUB LO(extraSignData)
 EQUB LO(sub_C56C8)
 EQUB LO(sub_C55BD)
 EQUB LO(sub_C54EB)
 EQUB LO(sub_C53F0)

 EQUB &00

\ ******************************************************************************
\
\       Name: newContentHi
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.newContentHi

 EQUB HI(sub_C5672)
 EQUB HI(sub_C5A1B)
 EQUB HI(sub_C5572)
 EQUB HI(sub_C5572)
 EQUB HI(sub_C54F1)
 EQUB HI(sub_C56AF)
 EQUB HI(sub_C56BC)
 EQUB HI(sub_C5772)
 EQUB HI(sub_C57A1)
 EQUB HI(xExtraSignVector)
 EQUB HI(yExtraSignVector)
 EQUB HI(zExtraSignVector)
 EQUB HI(extraRacingLine)
 EQUB HI(extraSignData)
 EQUB HI(extraSignData)
 EQUB HI(sub_C56C8)
 EQUB HI(sub_C55BD)
 EQUB HI(sub_C54EB)
 EQUB HI(sub_C53F0)

 EQUB &00

\ ******************************************************************************
\
\       Name: L5528
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5528

 EQUB &23, &48, &CB, &AC, &5C, &9D, &00, &AB
 EQUB &00, &00, &00, &3D, &00, &0A, &DE, &17
 EQUB &F8, &4A, &E1, &16, &46, &52, &5C, &BC
 EQUB &00, &00, &00, &6C, &00, &00, &00, &00
 EQUB &00, &32, &9A, &FB, &17, &A3, &11, &5A
 EQUB &00, &00, &72, &7C, &7A, &BB, &F8, &00
 EQUB &00, &00, &00, &55, &11, &11, &60, &B0
 EQUB &78, &20

\ ******************************************************************************
\
\       Name: xExtraSignVector
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.xExtraSignVector

 EQUB &F0, &D6, &D8, &0C, &09, &FE
 EQUB &F6, &32, &1C, &DF, &F4, &F2, &F8, &33
 EQUB &0D, &FC

\ ******************************************************************************
\
\       Name: sub_C5572
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C5572

 LDA thisSectionFlags
 AND #%01000000
 BEQ L557E

 JSR UpdateVectorNumber

 JSR sub_C55C4

.L557E

 RTS

\ ******************************************************************************
\
\       Name: sub_C557F
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C557F

 JSR UpdateVectorNumber

\ ******************************************************************************
\
\       Name: sub_C5582
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C5582

 LDY L53F8

 LDA L53FD

 SEC

 BIT directionFacing
 BMI L55A0

 ADC #0

 CMP L5728,Y
 BCC L55B6

 LDA #0

 INY

 CPY L53F9
 BCC L55B6

 LDY #0

 BEQ L55B6

.L55A0

 SBC #1

 BCS L55B6

 TYA
 AND #%01111111
 TAY

 CPY #1
 BCS L55AF

 LDY L53F9

.L55AF

 DEY

 LDA L5728,Y
 SEC
 SBC #1

.L55B6

 STA L53FD

 STY L53F8

 RTS

\ ******************************************************************************
\
\       Name: sub_C55BD
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C55BD

 BIT playerPastSegment
 BMI sub_C55BD-1

 JMP MovePlayerBack

\ ******************************************************************************
\
\       Name: sub_C55C4
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C55C4

 STX xStore

 LDY L53F8

 BMI L55FA

 LDA L5528,Y
 STA T

 LDA L5428,Y

 BIT directionFacing

 JSR Absolute16Bit

 STA U

 LDA T
 CLC
 ADC L53FA
 STA L53FA

 LDA U
 ADC L53FB
 STA L53FB

 LDA L5628,Y

 BIT directionFacing

 JSR Absolute8Bit

 CLC
 ADC L53FC
 STA L53FC

.L55FA

 JSR sub_C5472

 LDX xStore

 RTS

\ ******************************************************************************
\
\       Name: ModifyGameCode (Part 3 of 3)
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.mods3

 LDA #4
 STA &3574

 LDA #11
 STA &35F4

 LDA #&E9
 STA &45CC

 LDA #&59
 STA &45CD

 LDA #&4B
 STA &2772

 RTS

\ ******************************************************************************
\
\       Name: L561A
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L561A

 EQUB &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00

\ ******************************************************************************
\
\       Name: L5628
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5628

 EQUB &01, &FE, &FF, &FE, &FF, &00, &04, &09
 EQUB &00, &F9, &F9, &00, &00, &00, &04, &00
 EQUB &00, &00, &00, &00, &03, &02, &02, &01
 EQUB &00, &FA, &00, &00, &00, &FD, &03, &04
 EQUB &01, &FF, &FE, &FE, &01, &00, &00, &00
 EQUB &FC, &02, &03, &FD, &FD, &01, &03, &00
 EQUB &FE, &00, &01, &FC, &FC, &03, &03, &FC
 EQUB &FE, &01

\ ******************************************************************************
\
\       Name: yExtraSignVector
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.yExtraSignVector

 EQUB &1A, &4C, &D9, &E6, &0D, &08
 EQUB &EC, &06, &E0, &10, &12, &05, &1E, &01
 EQUB &FA, &08

\ ******************************************************************************
\
\       Name: sub_C5672
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C5672

 STY yStore

 LDA L5905,Y
 STA thisVectorNumber

 TYA
 LSR A
 LSR A
 LSR A
 TAY

 LDA L5846,Y
 STA L53FA

 LDA L5864,Y
 STA L53FB

 LDA L5828,Y
 STA L53FC

 LDA L5882,Y
 LSR A
 ROR A
 STA L53F8

 LDA #14
 ROR A
 STA &23B3

 LDA #0
 STA L53FD

 BIT directionFacing
 BMI L56AA

 JSR sub_C55C4

.L56AA

 LDY yStore

 LDA thisVectorNumber

 RTS

\ ******************************************************************************
\
\       Name: sub_C56AF
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C56AF

 PHA

 LDA segmentCounter
 CMP #12

 PLA

 BCS L56BB

 STA horizonLine

 STY horizonListIndex

.L56BB

 RTS

\ ******************************************************************************
\
\       Name: sub_C56BC
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C56BC

 BCC L56C5

 LDA segmentCounter
 CMP #10

 BCC L56C5

 RTS

.L56C5

 JMP gseg13

\******************************************************************************
\
\       Name: sub_C56C8
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C56C8

 TYA
 AND #%00100000
 STA blockOffset

 LDA #0

.L56CF

 STA topTrackLine

.L56D1

 DEY

 LDA yVergeRight,Y

 CMP horizonLine
 BCS L56F7

 CMP topTrackLine
 BCS L56CF

 LDA topTrackLine
 ADC #0
 STA yVergeRight,Y

 LDA blockOffset

 BNE L56D1

 LDA topTrackLine

 STA &1FEA

 INY

 JSR gtrm2+6

 DEY

 SEC
 ROR blockOffset

 BMI L56D1

.L56F7

 LDY vergeBufferEnd
 DEY
 STY U

 JMP CheckVergeOnScreen

 EQUB &00

\ ******************************************************************************
\
\       Name: ModifyGameCode (Part 1 of 3)
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ This routine modifies the main game code. The routine is in three parts, which
\ are run via the CallTrackHook routine once the track has been loaded.
\
\ There are two types of modification:
\
\   * 16-bit pokes take values from (newContentHi newContentLo) and poke them
\     into the addresses given in (modifyAddressHi modifyAddressLo)
\
\   * 8-bit pokes are done with straightforward LDA and STA instructions
\
\ Using BBC BASIC terminology, 16-bit pokes are shown as:
\
\   !&xxxx = y
\
\ while 8-bit pokes are shown as:
\
\   ?&xxxx = y
\
\ Each of these pokes the value y into address &xxxx.
\
\ Modifications are shown in the following format:
\
\ !<address> = <new value> in <subroutine>
\ Also needs <related pokes>
\ <instructions before modification>                -> <after modification>
\
\ There are other routines in this file that modify the main game code, but
\ these modifications are performed while the game is running. These are also
\ listed below.
\
\ Modifications applied by ModifyGameCode (Part 1 of 3)
\ -----------------------------------------------------
\
\ !&1249 = sub_C5672 in GetSectionCoords
\ Also needs ?&1248 = &20 from ModifyGameCode (Part 2 of 3)
\ 1248   B9 05 59   LDA trackSectionFrom,Y          -> JSR sub_C5672
\
\ !&128A = sub_C5A1B in GetFirstSegment
\ 1289   20 E0 13   JSR UpdateVectorNumber          -> JSR sub_C5A1B
\
\ !&13CA = sub_C5572 in GetTrackSegment
\ 13C9   20 DA 13   JSR UpdateCurveVector           -> JSR sub_C5572
\
\ !&1427 = sub_C5572 in TurnPlayerAround
\ 1426   20 DA 13   JSR UpdateCurveVector           -> JSR sub_C5572
\
\ !&12FC = sub_C54F1 in GetTrackSegment
\ Also needs ?&12FB = &20 from ModifyGameCode (Part 2 of 3)
\ 12FB   18         CLC                             -> JSR sub_C54F1
\ 12FC   69 03      ADC #3
\
\ !&261B = sub_C56AF and ?&261A = &4C in GetVergeAndMarkers
\ 261A   85 1F      STA horizonLine                 -> JMP sub_C56AF
\ 261C   84 51      STY horizonListIndex
\
\ !&248C = sub_C56BC and ?&248B = &4C in GetSegmentAngles
\ 248B   B0 2B      BCS gseg16                      -> JMP sub_C56BC
\ 248D   4C 03 24   JMP gseg4
\
\ !&2539 = sub_C5772 in GetTrackAndMarkers
\ Also needs ?&2538 = &20 from ModifyGameCode (Part 2 of 3)
\ 2538   99 48 5F   STA yVergeLeft,Y                -> JSR sub_C5772
\
\ !&1594 = sub_C57A1 in ProcessDrivingKeys
\ 1593   20 00 0C   JSR Multiply8x8                 -> JSR sub_C57A1
\
\ !&4CD1 = xExtraSignVector in BuildRoadSign
\ 4CD0   BD D0 53   LDA xTrackSignVector,X          -> LDA xExtraSignVector,X
\
\ !&4CC9 = yExtraSignVector in BuildRoadSign
\ 4CC8   BD F0 53   LDA yTrackSignVector,X          -> LDA yExtraSignVector,X
\
\ !&4CC1 = zExtraSignVector in BuildRoadSign
\ 4CC0   BD E0 53   LDA zTrackSignVector,X          -> LDA zExtraSignVector,X
\
\ !&44D6 = extraRacingLine in bestRacingLine
\ 44D5   B9 D0 59   LDA trackRacingLine,Y           -> LDA extraRacingLine,Y
\
\ !&4CD7 = extraSignData in BuildRoadSign
\ 4CD6   BD EA 59   LDA trackSignData,X             -> LDA extraSignData,X
\
\ !&4CE1 = extraSignData in BuildRoadSign
\ 4CE0   BD EA 59   LDA trackSignData,X             -> LDA extraSignData,X
\
\ !&1947 = sub_C56C8 in MapSegmentsToLines
\ 1946   20 33 19   JSR CheckVergeOnScreen          -> JSR sub_C56C8
\
\ !&24F3 = sub_C55BD in MovePlayerSegment
\ 24F2   20 0B 14   JSR MovePlayerBack              -> JSR sub_C55BD
\
\ !&462C = sub_C54EB in MovePlayerOnTrack
\ 462B   20 50 34   JSR Absolute8Bit                -> JSR sub_C54EB
\
\ !&2543 = sub_C53F0 in GetTrackAndMarkers
\ 2542   20 50 34   JSR Absolute8Bit                -> JSR sub_C53F0
\
\ Modifications applied by ModifyGameCode (Part 2 of 3)
\ -----------------------------------------------------
\
\ ?&1248 = &20 (see JSR sub_C5672 above)
\ ?&12FB = &20 (see JSR sub_C54EB above)
\ ?&2538 = &20 (see JSR sub_C5772 above)
\ ?&45CB = &20 (see JSR L57AD above)
\
\ ?&2545 = &EA in GetTrackAndMarkers
\ 2545   4A         LSR A                           -> NOP
\
\ ?&4F55 = 22 in MoveHorizon
\ 4F54   C9 12      CMP #18                         -> CMP #22
\
\ ?&4F59 = 22 in MoveHorizon
\ 4F58   A9 12      LDA #18                         -> LDA #22
\
\ ?&24EA = 13 in MovePlayerSegment
\ 24E9   C9 0E      CMP #14                         -> CMP #13
\
\ ?&1FE9 = &A2 (see LDX #A above)
\
\ Modifications applied by ModifyGameCode (Part 3 of 3)
\ -----------------------------------------------------
\
\ ?&3574 = 4 in objectTop
\ ?&35F4 = 11 = 3 + 8  in objectBottom
\ Object 10, Part 2: Scaffolds: (0, 3, 1, 0)        -> (4, -3, 1, 0)
\                    Coordinates: (10, 4, 9, 10)    -> (1, -4, 9, 10)
\ Changes chicane sign into a u-turn
\
\ !&45CC = sub_C59E9 in ApplyElevation
\ Also needs ?&45CB = &20 from ModifyGameCode (Part 2 of 3)
\ 45CB   0A         ASL A                           -> JSR sub_C59E9
\ 45CC   26 77      ROL W
\
\ ?&2772 = &4B in ApplyDriverTactics
\ 2771   C9 3C      CMP #60                         -> CMP #75
\
\ Modifications applied by sub_C5672
\ ----------------------------------
\
\ ?&23B3 = A in GetSectionAngles
\ 23B2   A9 07      LDA #7                          -> LDA #A
\
\ Modifications applied by sub_C56C8
\ ----------------------------------
\
\ ?&1FEA = A in DrawObject
\ Also needs ?&1FE9 = &A2 from ModifyGameCode (Part 2 of 3)
\ 1FE9   A6 1F      LDX horizonLine                 -> LDX #A
\
\ Modifications applied by sub_C5772
\ ----------------------------------
\
\ ?&1FEA = A in DrawObject
\ Also needs ?&1FE9 = &A2 from ModifyGameCode (Part 2 of 3)
\ 1FE9   A6 1F      LDX horizonLine                 -> LDX #A
\
\ ******************************************************************************

.ModifyGameCode

 LDX #18

.mods1

 LDA modifyAddressHi,X
 STA U

 LDA modifyAddressLo,X
 STA T

 LDY #0

 LDA newContentLo,X
 STA (T),Y

 INY

 LDA newContentHi,X
 STA (T),Y

 DEX

 BPL mods1

 LDA #&4C
 STA &261A
 STA &248B

 JMP mods2

 EQUB &00

\ ******************************************************************************
\
\       Name: L5728
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5728

 EQUB &1A, &15, &0B, &0A, &04, &0F, &15, &02
 EQUB &0C, &0C, &02, &14, &1B, &07, &0C, &03
 EQUB &0A, &0A, &1D, &07, &03, &0B, &0E, &06
 EQUB &15, &0B, &0D, &06, &2E, &10, &10, &0C
 EQUB &0C, &08, &0C, &10, &04, &0A, &08, &05
 EQUB &0C, &1A, &08, &05, &05, &05, &0C, &0F
 EQUB &15, &23, &16, &03, &0E, &08, &13, &08
 EQUB &11, &22

\ ******************************************************************************
\
\       Name: zExtraSignVector
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.zExtraSignVector

 EQUB &D2, &04, &1C, &EC, &0A, &EB
 EQUB &F7, &2D, &1B, &2B, &F8, &10, &F2, &29
 EQUB &EC, &00

\ ******************************************************************************
\
\       Name: sub_C5772
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C5772

 STA &1FEA

 STA yVergeLeft,Y

.L5778

 LDA xVergeRightLo,Y
 SEC
 SBC xVergeLeftLo,Y

 LDA xVergeRightHi,Y
 SBC xVergeLeftHi,Y

 BPL L5793

 LDA xVergeRightLo,Y
 STA xVergeLeftLo,Y

 LDA xVergeRightHi,Y
 STA xVergeLeftHi,Y

.L5793

 LDA yVergeRight,Y
 STA yVergeLeft,Y

 INY

 CPY #9
 BCC L5778

 LDY horizonListIndex

 RTS

\ ******************************************************************************
\
\       Name: sub_C57A1
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C57A1

 LDY currentPlayer

 LDA objTrackSection,Y

 LDY #181

 CMP #32
 BNE L57AE

 LDY #240

.L57AE

 TYA

 JSR Multiply8x8

 STA U

 JSR Multiply8x8

 ASL T
 ROL A

 RTS

\ ******************************************************************************
\
\       Name: sub_C57BB
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C57BB

 PHP

 JMP MultiplyElevation+11

\ ******************************************************************************
\
\       Name: L57BF
\       Type: Subroutine
\   Category: Extra track data
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
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.mods2

 LDA #&20
 STA &1248
 STA &12FB
 STA &2538
 STA &45CB

 LDA #&EA
 STA &2545

 LDA #22
 STA &4F55
 STA &4F59

 LDA #13
 STA &24EA

 LDA #&A2
 STA &1FE9

 JMP mods3

\ ******************************************************************************
\
\       Name: L5828
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5828

 EQUB &FF, &E4, &CC, &32, &DE, &D0, &D0, &00
 EQUB &00, &00, &00, &41, &FF, &FF, &FF, &3B
 EQUB &FB, &FB, &FF, &03, &1B, &1B, &FD, &FD
 EQUB &26, &FC, &12, &E6, &FF, &00

\ ******************************************************************************
\
\       Name: L5846
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5846

 EQUB &00, &2F
 EQUB &8A, &E0, &E0, &A4, &A4, &52, &52, &47
 EQUB &42, &0A, &0A, &92, &92, &92, &0A, &0A
 EQUB &0E, &0E, &9E, &9E, &6C, &6C, &B3, &B3
 EQUB &B3, &28, &C8, &00

\ ******************************************************************************
\
\       Name: L5864
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5864

 EQUB &00, &12, &50, &55
 EQUB &55, &D2, &D2, &9D, &9D, &87, &76, &1D
 EQUB &1D, &25, &25, &25, &62, &62, &A2, &A2
 EQUB &B5, &B5, &E2, &E2, &A1, &A1, &A1, &DF
 EQUB &F3, &00

\ ******************************************************************************
\
\       Name: L5882
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5882

 EQUB &02, &0E, &1A, &22, &2A, &32
 EQUB &36, &3F, &3E, &46, &52, &62, &6A, &76
 EQUB &7E, &84, &91, &92, &A2, &AA, &AF, &AE
 EQUB &B5, &B4, &BC, &C4, &CE, &DA, &E2, &00

\ ******************************************************************************
\
\       Name: extraRacingLine
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.extraRacingLine

 EQUB &18, &33, &18, &00, &4F, &31, &68, &19
 EQUB &30, &19, &2E, &18, &18, &18, &18, &33
 EQUB &18, &3F, &18, &55, &18, &5B, &35, &42
 EQUB &18, &18, &4B, &18, &18, &18, &00

\ ******************************************************************************
\
\       Name: L58BF
\       Type: Variable
\   Category: Extra track data
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
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5900

 EQUB &70, &20, &00, &A0, &21

\ ******************************************************************************
\
\       Name: L5905
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5905

 EQUB &00, &A0, &3A
 EQUB &ED, &DC, &87, &5C, &F6, &12, &C8, &1D
 EQUB &42, &52, &2B, &E3, &B5, &07, &CC, &17
 EQUB &70, &2B, &DE, &96, &AA, &1E, &73, &18
 EQUB &ED, &EB, &6C, &F6, &6A, &0E, &D3, &16
 EQUB &6A, &71, &53, &53, &00, &24, &6D, &1B
 EQUB &73, &0D, &43, &EA, &9C, &17, &04, &13
 EQUB &04, &2F, &EB, &20, &F0, &02, &7A, &0D
 EQUB &41, &39, &EB, &81, &FA, &03, &DB, &0D
 EQUB &68, &36, &EB, &CE, &30, &10, &A1, &2E
 EQUB &F3, &0A, &EB, &52, &00, &16, &8F, &22
 EQUB &C4, &58, &DF, &7C, &96, &10, &21, &20
 EQUB &40, &18, &73, &DC, &56, &08, &81, &41
 EQUB &40, &61, &32, &7F, &C5, &22, &4B, &20
 EQUB &70, &61, &12, &9F, &C5, &1B, &6B, &18
 EQUB &ED, &61, &C0, &77, &C5, &0C, &43, &24
 EQUB &32, &A6, &DC, &F6, &63, &09, &A2, &37
 EQUB &ED, &0D, &C9, &D7, &CA, &0B, &83, &1B
 EQUB &72, &6B, &A8, &7C, &17, &27, &BE, &26
 EQUB &6D, &35, &28, &76, &E1, &26, &B8, &08
 EQUB &30, &E7, &AC, &C6, &28, &07, &CF, &1C
 EQUB &ED, &37, &A0, &62, &78, &09, &6B, &0A
 EQUB &2A, &F2, &09, &9E, &34, &14, &F1, &26
 EQUB &F3, &EC, &97, &D4, &2E, &16, &27, &11
 EQUB &44, &D0, &99, &0B, &7E, &00, &50, &24
 EQUB &70, &70, &23, &83, &1E, &25, &C8, &39

\ ******************************************************************************
\
\       Name: L59D0
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L59D0

 EQUB &ED, &D8, &3C, &41, &86, &0F, &86, &19
 EQUB &C2, &15, &E6, &CA, &64, &01, &11, &1B
 EQUB &40, &98, &9A, &D9, &A5, &1D, &8C, &33
 EQUB &70

\ ******************************************************************************
\
\       Name: sub_C59E9
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C59E9

 BNE L59F4

 LDA playerSpeedHi

 JSR MultiplyElevation

 BPL L59F4

 DEC W

.L59F4

 ASL A
 ROL W

 RTS

\ ******************************************************************************
\
\       Name: L5928
\       Type: Variable
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5928

 EQUB &00, &00, &E8, &28, &92, &03, &00, &00

\ ******************************************************************************
\
\       Name: trackLapTimeSec
\       Type: Variable
\   Category: Extra track data
\    Summary: Lap times for adjusting the race class (seconds)
\  Deep dive: The track data file format
\
\ ------------------------------------------------------------------------------
\
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we change the race class to the relevant difficulty.
\
\ ******************************************************************************

 EQUB 50                \ Set class to Novice if slowest lap time > 1:50

 EQUB 40                \ Set class to Amateur if slowest lap time > 1:40

 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackLapTimeMin
\       Type: Variable
\   Category: Extra track data
\    Summary: Lap times for adjusting the race class (minutes)
\  Deep dive: The track data file format
\
\ ------------------------------------------------------------------------------
\
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we change the race class to the relevant difficulty.
\
\ ******************************************************************************

 EQUB 1                 \ Set class to Novice if slowest lap time > 1:50

 EQUB 1                 \ Set class to Amateur if slowest lap time > 1:40

 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackGearRatio
\       Type: Variable
\   Category: Extra track data
\    Summary: The gear ratio for each gear
\  Deep dive: The track data file format
\
\ ------------------------------------------------------------------------------
\
\ The rev count is calculated by multiplying the track gear ratio by the current
\ speed, so lower gears correspond to more revs at the same wheel speed when
\ compared to higher gears.
\
\ ******************************************************************************

 EQUB 103               \ Reverse

 EQUB 0                 \ Neutral

 EQUB 103               \ First gear

 EQUB 74                \ Second gear

 EQUB 60                \ Third gear

 EQUB 50                \ Fourth gear

 EQUB 44                \ Fifth gear

\ ******************************************************************************
\
\       Name: trackGearPower
\       Type: Variable
\   Category: Extra track data
\    Summary: The power for each gear
\  Deep dive: The track data file format
\
\ ------------------------------------------------------------------------------
\
\ The engine torque is calculated by multiplying the rev count by the power for
\ the relevant gear, so lower gears create more torque at the same rev count
\ when compared to higher gears.
\
\ ******************************************************************************

 EQUB 161               \ Reverse

 EQUB 0                 \ Neutral

 EQUB 161               \ First gear

 EQUB 116               \ Second gear

 EQUB 93                \ Third gear

 EQUB 79                \ Fourth gear

 EQUB 68                \ Fifth gear

\ ******************************************************************************
\
\       Name: trackBaseSpeed
\       Type: Variable
\   Category: Extra track data
\    Summary: The base speed for each race class, used when generating the best
\             racing lines and non-player driver speeds
\  Deep dive: The track data file format
\
\ ******************************************************************************

 EQUB 134               \ Base speed for Novice

 EQUB 146               \ Base speed for Amateur

 EQUB 152               \ Base speed for Professional

\ ******************************************************************************
\
\       Name: trackStartPosition
\       Type: Variable
\   Category: Extra track data
\    Summary: The starting race position of the player during a practice or
\             qualifying lap
\  Deep dive: The track data file format
\
\ ******************************************************************************

 EQUB 5

\ ******************************************************************************
\
\       Name: trackCarSpacing
\       Type: Variable
\   Category: Extra track data
\    Summary: The spacing between the cars at the start of a qualifying lap, in
\             segments
\  Deep dive: The track data file format
\
\ ******************************************************************************

 EQUB 37

\ ******************************************************************************
\
\       Name: trackTimerAdjust
\       Type: Variable
\   Category: Extra track data
\    Summary: Adjustment factor for the speed of the timers to allow for
\             fine-tuning of time on a per-track basis
\  Deep dive: The track data file format
\
\ ------------------------------------------------------------------------------
\
\ The value of the timerAdjust variable in the main game code is incremented on
\ every iteration of the main driving loop. When it reaches the value in
\ trackTimerAdjust, the timers adds 18/100 of a second rather than 9/100 of
\ a second. Decreasing this value therefore speeds up the timers, allowing their
\ speed to be adjusted on a per-track basis.
\
\ Setting this value to 255 disables the timer adjustment.
\
\ ******************************************************************************

 EQUB 70

\ ******************************************************************************
\
\       Name: trackRaceSlowdown
\       Type: Variable
\   Category: Extra track data
\    Summary: Slowdown factor for non-player drivers in the race
\  Deep dive: The track data file format
\
\ ------------------------------------------------------------------------------
\
\ Reduce the speed of all cars in a race by this amount (this does not affect
\ the speed during qualifying). I suspect this is used for testing purposes.
\
\ ******************************************************************************

 EQUB 0

\ ******************************************************************************
\
\       Name: sub_C5A1B
\       Type: Subroutine
\   Category: Extra track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C5A1B

 JSR sub_C557F

 JMP sub_C5472

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

 EQUB &87               \ Counts the number of data bytes ending in %00

 EQUB &D4               \ Counts the number of data bytes ending in %01

 EQUB &78               \ Counts the number of data bytes ending in %10
 
 EQUB &52               \ Counts the number of data bytes ending in %11

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

 EQUS "Brands Hatch"     \ Track name
 EQUB 13

 EQUB &DC, &20, &22, &20, &42, &52
 EQUB &41, &4E, &44, &53, &20, &48, &41, &54
 EQUB &43, &48, &22, &2C, &22, &20, &44, &4F
 EQUB &4E, &49, &4E, &47, &54, &4F, &4E, &20
 EQUB &50, &41, &52, &4B, &22, &2C, &22, &20
 EQUB &4F, &55, &4C, &54, &4F, &4E, &20, &50
 EQUB &41, &52, &4B, &20, &20, &20, &22, &2C
 EQUB &22, &20, &53, &4E, &45, &54, &54, &45
 EQUB &52, &54, &4F, &4E, &20, &20, &20, &20
 EQUB &22, &0D, &04, &06, &0A, &20, &DC, &22
 EQUB &22, &20, &20, &0D, &04, &10, &24, &20
 EQUB &F4, &20, &50, &72, &6F, &67, &72, &61
 EQUB &6D, &73, &20, &6F, &6E, &20, &74, &68
 EQUB &65, &20, &64, &69, &73, &63, &20, &6F
 EQUB &72, &20, &74, &61, &70, &65, &20, &0D
 EQUB &04, &1A, &11, &20, &DC, &42, &20, &2C
 EQUB &44, &20, &2C, &4F, &20, &2C, &53, &20
 EQUB &0D, &04, &24, &0E, &20, &DC, &22, &22
 EQUB &20, &20, &20, &20, &20, &20, &0D, &FF

\ ******************************************************************************
\
\ Save BrandsHatch.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/BrandsHatch.bin", CODE%, P%

\ ******************************************************************************
\
\ REVS SILVERSTONE TRACK SOURCE
\
\ Revs was written by Geoffrey J Crammond and is copyright Acornsoft 1985
\
\ The code on this site has been disassembled from the original game discs
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
\   * Silvers.bin
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
\ REVS SILVERSTONE TRACK
\
\ Produces the binary file Silverstone.bin that contains the Silverstone track.
\
\ ******************************************************************************

ORG CODE%

.trackData

\ ******************************************************************************
\
\       Name: Track section data (Part 1 of 2)
\       Type: Variable
\   Category: Track data
\    Summary: Data for the track sections
\
\ ------------------------------------------------------------------------------
\
\ Silverstone consists of the following track sections:
\
\    0   ||   Abbey Curve to Woodcote Corner
\    1   ->   Woodcote Corner (chicane right)
\    2   <-   Woodcote Corner (chicane left)
\    3   ->   Woodcote Corner (chicane right)
\    4   ||   Home Straight
\    5   ->   Copse Corner
\    6   ||   Copse Corner to Maggotts Curve
\    7   {}   Copse Corner to Maggotts Curve
\    8   ||   Copse Corner to Maggotts Curve
\    9   <-   Maggotts Curve
\   10   ||   Maggotts Curve to Becketts Corner
\   11   ||   Maggotts Curve to Becketts Corner
\   12   ->   Becketts Corner
\   13   ||   Becketts Corner to Chapel Curve
\   14   <-   Chapel Curve
\   15   ||   Hangar Straight
\   16   {}   Hangar Straight
\   17   ||   Hangar Straight
\   18   ->   Stowe Corner
\   19   ||   Stowe Corner to Club Corner
\   20   ->   Club Corner
\   21   ||   Club Corner to Abbey Curve
\   22   <-   Abbey Curve
\   23   {}   Abbey Curve to Woodcote Corner
\
\ where:
\
\   || is a straight, with just two vectors defined (start and end)
\   {} is a very gentle curve
\   -> is a right corner
\   <- is a left corner
\
\ This part defines the following aspects of these track sections:
\
\ trackSectionData      Various data for the track section:
\
\                         * Bits 4-7: road sign number (0 to 15) to show when we
\                                     enter this section
\
\                         * Bits 0-2: gets put into L0007 in sub_C1267
\
\ xTrackSectionIHi      High byte of the start x-coordinate of the inside verge
\                       of each track section
\
\ yTrackSectionIHi      High byte of the start y-coordinate of the inside verge
\                       of each track section
\
\ zTrackSectionIHi      High byte of the start z-coordinate of the inside verge
\                       of each track section
\
\ xTrackSectionOHi      High byte of the start x-coordinate of the outside verge
\                       of each track section
\
\ trackSectionTurn      Progress range within the section where cars should turn
\                       into the corner
\
\ zTrackSectionOHi      High byte of the start z-coordinate of the outside verge
\                       of each track section
\
\ trackMaxSpeed         The maximum speed for non-player drivers on this section
\                       of the track
\
\ ******************************************************************************

                        \ Track section 0

 EQUB &03               \ trackSectionData (sign = 0, L0007 = 3)
 EQUB &D1               \ xTrackSectionIHi (xTrackSectionI = &D120 = -12000)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80 =   3200)
 EQUB &0F               \ zTrackSectionIHi (zTrackSectionI = &0FA0 =   4000)
 EQUB &CF               \ xTrackSectionOHi (xTrackSectionO = &CFC0 = -12352)
 EQUB 96                \ trackSectionTurn
 EQUB &0F               \ zTrackSectionOHi (zTrackSectionO = &0F94 =   3988)
 EQUB 136               \ trackMaxSpeed

                        \ Track section 1

 EQUB &13               \ trackSectionData (sign = 1, L0007 = 3)
 EQUB &CF               \ xTrackSectionIHi (xTrackSectionI = &CF94 = -12396)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80 =   3200)
 EQUB &3E               \ zTrackSectionIHi (zTrackSectionI = &3E08 =  15880)
 EQUB &CE               \ xTrackSectionOHi (xTrackSectionO = &CE34 = -12748)
 EQUB 18                \ trackSectionTurn
 EQUB &3D               \ zTrackSectionOHi (zTrackSectionO = &3DFC =  15868)
 EQUB 00                \ trackMaxSpeed

                        \ Track section 2

 EQUB &12               \ trackSectionData (sign = 1, L0007 = 2)
 EQUB &D3               \ xTrackSectionIHi (xTrackSectionI = &D325 = -11483)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80 =   3200)
 EQUB &46               \ zTrackSectionIHi (zTrackSectionI = &4696 =  18070)
 EQUB &D2               \ xTrackSectionOHi (xTrackSectionO = &D2C5 = -11579)
 EQUB 20                \ trackSectionTurn
 EQUB &47               \ zTrackSectionOHi (zTrackSectionO = &47E8 =  18408)
 EQUB 138               \ trackMaxSpeed

                        \ Track section 3

 EQUB &22               \ trackSectionData (sign = 2, L0007 = 2)
 EQUB &D6               \ xTrackSectionIHi (xTrackSectionI = &D6B2 = -10574)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80 =   3200)
 EQUB &4A               \ zTrackSectionIHi (zTrackSectionI = &4A91 =  19089)
 EQUB &D5               \ xTrackSectionOHi (xTrackSectionO = &D556 = -10922)
 EQUB 30                \ trackSectionTurn
 EQUB &4A               \ zTrackSectionOHi (zTrackSectionO = &4AC9 =  19145)
 EQUB 33                \ trackMaxSpeed

                        \ Track section 4

 EQUB &22               \ trackSectionData (sign = 2, L0007 = 2)
 EQUB &DE               \ xTrackSectionIHi (xTrackSectionI = &DEAF =  -8529)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80 =   3200)
 EQUB &4F               \ zTrackSectionIHi (zTrackSectionI = &4F4F =  20303)
 EQUB &DE               \ xTrackSectionOHi (xTrackSectionO = &DE9F =  -8545)
 EQUB 98                \ trackSectionTurn
 EQUB &50               \ zTrackSectionOHi (zTrackSectionO = &50AE =  20654)
 EQUB 125               \ trackMaxSpeed

                        \ Track section 5

 EQUB &33               \ trackSectionData (sign = 3, L0007 = 3)
 EQUB &0F               \ xTrackSectionIHi (xTrackSectionI = &0FE7 =   4071)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80 =   3200)
 EQUB &51               \ zTrackSectionIHi (zTrackSectionI = &515C =  20828)
 EQUB &0F               \ xTrackSectionOHi (xTrackSectionO = &0FD7 =   4055)
 EQUB 40                \ trackSectionTurn
 EQUB &52               \ zTrackSectionOHi (zTrackSectionO = &52BB =  21179)
 EQUB 26                \ trackMaxSpeed

                        \ Track section 6

 EQUB &42               \ trackSectionData (sign = 4, L0007 = 2)
 EQUB &17               \ xTrackSectionIHi (xTrackSectionI = &17D8 =   6104)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0CCB =   3275)
 EQUB &4B               \ zTrackSectionIHi (zTrackSectionI = &4B09 =  19209)
 EQUB &19               \ xTrackSectionOHi (xTrackSectionO = &1937 =   6455)
 EQUB 255               \ trackSectionTurn
 EQUB &4B               \ zTrackSectionOHi (zTrackSectionO = &4B17 =  19223)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 7

 EQUB &53               \ trackSectionData (sign = 5, L0007 = 3)
 EQUB &18               \ xTrackSectionIHi (xTrackSectionI = &1864 =   6244)
 EQUB &0E               \ yTrackSectionIHi (yTrackSectionI = &0E53 =   3667)
 EQUB &3D               \ zTrackSectionIHi (zTrackSectionI = &3DE9 =  15849)
 EQUB &19               \ xTrackSectionOHi (xTrackSectionO = &19C3 =   6595)
 EQUB 00                \ trackSectionTurn
 EQUB &3D               \ zTrackSectionOHi (zTrackSectionO = &3DF7 =  15863)
 EQUB 00                \ trackMaxSpeed

                        \ Track section 8

 EQUB &53               \ trackSectionData (sign = 5, L0007 = 3)
 EQUB &18               \ xTrackSectionIHi (xTrackSectionI = &1891 =   6289)
 EQUB &0E               \ yTrackSectionIHi (yTrackSectionI = &0E77 =   3703)
 EQUB &39               \ zTrackSectionIHi (zTrackSectionI = &39B1 =  14769)
 EQUB &19               \ xTrackSectionOHi (xTrackSectionO = &19F0 =   6640)
 EQUB 33                \ trackSectionTurn
 EQUB &39               \ zTrackSectionOHi (zTrackSectionO = &39BF =  14783)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 9

 EQUB &64               \ trackSectionData (sign = 6, L0007 = 4)
 EQUB &19               \ xTrackSectionIHi (xTrackSectionI = &199F =   6559)
 EQUB &0D               \ yTrackSectionIHi (yTrackSectionI = &0D9F =   3487)
 EQUB &20               \ zTrackSectionIHi (zTrackSectionI = &2061 =   8289)
 EQUB &1A               \ xTrackSectionOHi (xTrackSectionO = &1AFE =   6910)
 EQUB 40                \ trackSectionTurn
 EQUB &20               \ zTrackSectionOHi (zTrackSectionO = &206F =   8303)
 EQUB 12                \ trackMaxSpeed

                        \ Track section 10

 EQUB &64               \ trackSectionData (sign = 6, L0007 = 4)
 EQUB &1B               \ xTrackSectionIHi (xTrackSectionI = &1BFA =   7162)
 EQUB &0D               \ yTrackSectionIHi (yTrackSectionI = &0D5F =   3423)
 EQUB &19               \ zTrackSectionIHi (zTrackSectionI = &195D =   6493)
 EQUB &1D               \ xTrackSectionOHi (xTrackSectionO = &1D1B =   7451)
 EQUB 255               \ trackSectionTurn
 EQUB &1A               \ zTrackSectionOHi (zTrackSectionO = &1A25 =   6693)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 11

 EQUB &73               \ trackSectionData (sign = 7, L0007 = 3)
 EQUB &26               \ xTrackSectionIHi (xTrackSectionI = &2612 =   9746)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0CC7 =   3271)
 EQUB &0A               \ zTrackSectionIHi (zTrackSectionI = &0AAB =   2731)
 EQUB &27               \ xTrackSectionOHi (xTrackSectionO = &2733 =  10035)
 EQUB 21                \ trackSectionTurn
 EQUB &0B               \ zTrackSectionOHi (zTrackSectionO = &0B73 =   2931)
 EQUB 116               \ trackMaxSpeed

                        \ Track section 12

 EQUB &72               \ trackSectionData (sign = 7, L0007 = 2)
 EQUB &2D               \ xTrackSectionIHi (xTrackSectionI = &2DC5 =  11717)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C5B =   3163)
 EQUB &00               \ zTrackSectionIHi (zTrackSectionI = &008B = 139)
 EQUB &2E               \ xTrackSectionOHi (xTrackSectionO = &2EDD =  11997)
 EQUB 39                \ trackSectionTurn
 EQUB &01               \ zTrackSectionOHi (zTrackSectionO = &015F = 351)
 EQUB 25                \ trackMaxSpeed

                        \ Track section 13

 EQUB &72               \ trackSectionData (sign = 7, L0007 = 2)
 EQUB &29               \ xTrackSectionIHi (xTrackSectionI = &2965 =  10597)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C4D =   3149)
 EQUB &F6               \ zTrackSectionIHi (zTrackSectionI = &F67E =  -2434)
 EQUB &29               \ xTrackSectionOHi (xTrackSectionO = &29D3 =  10707)
 EQUB 24                \ trackSectionTurn
 EQUB &F5               \ zTrackSectionOHi (zTrackSectionO = &F52F =  -2769)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 14

 EQUB &84               \ trackSectionData (sign = 8, L0007 = 4)
 EQUB &17               \ xTrackSectionIHi (xTrackSectionI = &1795 =   6037)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C4D =   3149)
 EQUB &F0               \ zTrackSectionIHi (zTrackSectionI = &F08E =  -3954)
 EQUB &18               \ xTrackSectionOHi (xTrackSectionO = &1803 =   6147)
 EQUB 40                \ trackSectionTurn
 EQUB &EF               \ zTrackSectionOHi (zTrackSectionO = &EF3F =  -4289)
 EQUB 20                \ trackMaxSpeed

                        \ Track section 15

 EQUB &93               \ trackSectionData (sign = 9, L0007 = 3)
 EQUB &11               \ xTrackSectionIHi (xTrackSectionI = &11D8 =   4568)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C0D =   3085)
 EQUB &EB               \ zTrackSectionIHi (zTrackSectionI = &EBFA =  -5126)
 EQUB &13               \ xTrackSectionOHi (xTrackSectionO = &1305 =   4869)
 EQUB 255               \ trackSectionTurn
 EQUB &EB               \ zTrackSectionOHi (zTrackSectionO = &EB44 =  -5308)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 16

 EQUB &A2               \ trackSectionData (sign = 10, L0007 = 2)
 EQUB &F1               \ xTrackSectionIHi (xTrackSectionI = &F126 =  -3802)
 EQUB &07               \ yTrackSectionIHi (yTrackSectionI = &07D5 =   2005)
 EQUB &B5               \ zTrackSectionIHi (zTrackSectionI = &B5A9 = -19031)
 EQUB &F2               \ xTrackSectionOHi (xTrackSectionO = &F253 =  -3501)
 EQUB 00                \ trackSectionTurn
 EQUB &B4               \ zTrackSectionOHi (zTrackSectionO = &B4F3 = -19213)
 EQUB 00                \ trackMaxSpeed

                        \ Track section 17

 EQUB &B1               \ trackSectionData (sign = 11, L0007 = 1)
 EQUB &EF               \ xTrackSectionIHi (xTrackSectionI = &EFB2 =  -4174)
 EQUB &07               \ yTrackSectionIHi (yTrackSectionI = &07F7 =   2039)
 EQUB &B3               \ zTrackSectionIHi (zTrackSectionI = &B33F = -19649)
 EQUB &F0               \ xTrackSectionOHi (xTrackSectionO = &F0DF =  -3873)
 EQUB 22                \ trackSectionTurn
 EQUB &B2               \ zTrackSectionOHi (zTrackSectionO = &B289 = -19831)
 EQUB 139               \ trackMaxSpeed

                        \ Track section 18

 EQUB &B4               \ trackSectionData (sign = 11, L0007 = 4)
 EQUB &E8               \ xTrackSectionIHi (xTrackSectionI = &E8EA =  -5910)
 EQUB &09               \ yTrackSectionIHi (yTrackSectionI = &099B =   2459)
 EQUB &A7               \ zTrackSectionIHi (zTrackSectionI = &A7FB = -22533)
 EQUB &EA               \ xTrackSectionOHi (xTrackSectionO = &EA17 =  -5609)
 EQUB 52                \ trackSectionTurn
 EQUB &A7               \ zTrackSectionOHi (zTrackSectionO = &A745 = -22715)
 EQUB 24                \ trackMaxSpeed

                        \ Track section 19

 EQUB &C3               \ trackSectionData (sign = 12, L0007 = 3)
 EQUB &D8               \ xTrackSectionIHi (xTrackSectionI = &D849 = -10167)
 EQUB &0A               \ yTrackSectionIHi (yTrackSectionI = &0A64 =   2660)
 EQUB &A5               \ zTrackSectionIHi (zTrackSectionI = &A5A2 = -23134)
 EQUB &D7               \ xTrackSectionOHi (xTrackSectionO = &D74A = -10422)
 EQUB 96                \ trackSectionTurn
 EQUB &A4               \ zTrackSectionOHi (zTrackSectionO = &A4AE = -23378)
 EQUB 151               \ trackMaxSpeed

                        \ Track section 20

 EQUB &D2               \ trackSectionData (sign = 13, L0007 = 2)
 EQUB &B6               \ xTrackSectionIHi (xTrackSectionI = &B691 = -18799)
 EQUB &07               \ yTrackSectionIHi (yTrackSectionI = &07F4 =   2036)
 EQUB &C8               \ zTrackSectionIHi (zTrackSectionI = &C8FA = -14086)
 EQUB &B5               \ xTrackSectionOHi (xTrackSectionO = &B592 = -19054)
 EQUB 49                \ trackSectionTurn
 EQUB &C8               \ zTrackSectionOHi (zTrackSectionO = &C806 = -14330)
 EQUB 28                \ trackMaxSpeed

                        \ Track section 21

 EQUB &E2               \ trackSectionData (sign = 14, L0007 = 2)
 EQUB &B6               \ xTrackSectionIHi (xTrackSectionI = &B603 = -18941)
 EQUB &08               \ yTrackSectionIHi (yTrackSectionI = &083E =   2110)
 EQUB &D7               \ zTrackSectionIHi (zTrackSectionI = &D71E = -10466)
 EQUB &B4               \ xTrackSectionOHi (xTrackSectionO = &B4F2 = -19214)
 EQUB 69                \ trackSectionTurn
 EQUB &D7               \ zTrackSectionOHi (zTrackSectionO = &D7FC = -10244)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 22

 EQUB &F2               \ trackSectionData (sign = 15, L0007 = 2)
 EQUB &CF               \ xTrackSectionIHi (xTrackSectionI = &CF3F = -12481)
 EQUB &0B               \ yTrackSectionIHi (yTrackSectionI = &0B90 =   2960)
 EQUB &F5               \ zTrackSectionIHi (zTrackSectionI = &F5FF =  -2561)
 EQUB &CE               \ xTrackSectionOHi (xTrackSectionO = &CE2E = -12754)
 EQUB 36                \ trackSectionTurn
 EQUB &F6               \ zTrackSectionOHi (zTrackSectionO = &F6DD =  -2339)
 EQUB 11                \ trackMaxSpeed

                        \ Track section 23

 EQUB &F2               \ trackSectionData (sign = 15, L0007 = 2)
 EQUB &D1               \ xTrackSectionIHi (xTrackSectionI = &D1DE = -11810)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C7D =   3197)
 EQUB &FD               \ zTrackSectionIHi (zTrackSectionI = &FDD2 =   -558)
 EQUB &D0               \ xTrackSectionOHi (xTrackSectionO = &D07E = -12162)
 EQUB 255               \ trackSectionTurn
 EQUB &FD               \ zTrackSectionOHi (zTrackSectionO = &FDC5 =   -571)
 EQUB 255               \ trackMaxSpeed

                        \ Same as track section 0

 EQUB &03               \ trackSectionData (sign = 0, L0007 = 3)
 EQUB &D1               \ xTrackSectionIHi (xTrackSectionI = &D120 = -12000)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80 =   3200)
 EQUB &0F               \ zTrackSectionIHi (zTrackSectionI = &0FA0 =   4000)
 EQUB &CF               \ xTrackSectionOHi (xTrackSectionO = &CFC0 = -12352)
 EQUB 96                \ trackSectionTurn
 EQUB &0F               \ zTrackSectionOHi (zTrackSectionO = &0F94 =   3988)
 EQUB 136               \ trackMaxSpeed

 EQUB &00, &8E          \ These bytes appear to be unused
 EQUB &41, &40
 EQUB &00, &00
 EQUB &C9, &54

\ ******************************************************************************
\
\       Name: xTrackSignVector
\       Type: Variable
\   Category: Track data
\    Summary: The x-coordinate of the track sign vector for each sign, to be
\             scaled and added to the inner track section vector for the sign
\
\ ******************************************************************************

 EQUB -10               \ Sign  0 = (-10 << 6,   8 << 4, 108 << 6) + section  0
 EQUB  -8               \ Sign  1 = ( -8 << 6,   8 << 4,   4 << 6) + section  2
 EQUB  82               \ Sign  2 = ( 82 << 6,   8 << 4,  27 << 6) + section  3
 EQUB -78               \ Sign  3 = (-78 << 6,   8 << 4,   3 << 6) + section  5
 EQUB   7               \ Sign  4 = (  7 << 6,   0 << 4,   8 << 6) + section  7
 EQUB  -4               \ Sign  5 = ( -4 << 6,  18 << 4,  75 << 6) + section  9
 EQUB -39               \ Sign  6 = (-39 << 6,  17 << 4,  63 << 6) + section 12
 EQUB  40               \ Sign  7 = ( 40 << 6,   8 << 4,  14 << 6) + section 14
 EQUB  -5               \ Sign  8 = ( -5 << 6,   8 << 4,  -1 << 6) + section 14
 EQUB -51               \ Sign  9 = (-51 << 6, -16 << 4, -79 << 6) + section 14
 EQUB  39               \ Sign 10 = ( 39 << 6, -20 << 4,  53 << 6) + section 18
 EQUB  23               \ Sign 11 = ( 23 << 6,  12 << 4, -16 << 6) + section 19
 EQUB  48               \ Sign 12 = ( 48 << 6,  22 << 4, -59 << 6) + section 20
 EQUB  -6               \ Sign 13 = ( -6 << 6,   4 << 4, -16 << 6) + section 21
 EQUB -46               \ Sign 14 = (-46 << 6, -16 << 4, -57 << 6) + section 22
 EQUB   0               \ Sign 15 = (  0 << 6,   8 << 4,  36 << 6) + section 23

\ ******************************************************************************
\
\       Name: zTrackSignVector
\       Type: Variable
\   Category: Track data
\    Summary: The z-coordinate of the track sign vector for each sign, to be
\             scaled and added to the inner track section vector for the sign
\
\ ******************************************************************************

 EQUB 108               \ Sign  0 = (-10 << 6,   8 << 4, 108 << 6) + section  0
 EQUB   4               \ Sign  1 = ( -8 << 6,   8 << 4,   4 << 6) + section  2
 EQUB  27               \ Sign  2 = ( 82 << 6,   8 << 4,  27 << 6) + section  3
 EQUB   3               \ Sign  3 = (-78 << 6,   8 << 4,   3 << 6) + section  5
 EQUB   8               \ Sign  4 = (  7 << 6,   0 << 4,   8 << 6) + section  7
 EQUB  75               \ Sign  5 = ( -4 << 6,  18 << 4,  75 << 6) + section  9
 EQUB  63               \ Sign  6 = (-39 << 6,  17 << 4,  63 << 6) + section 12
 EQUB  14               \ Sign  7 = ( 40 << 6,   8 << 4,  14 << 6) + section 14
 EQUB  -1               \ Sign  8 = ( -5 << 6,   8 << 4,  -1 << 6) + section 14
 EQUB -79               \ Sign  9 = (-51 << 6, -16 << 4, -79 << 6) + section 14
 EQUB  53               \ Sign 10 = ( 39 << 6, -20 << 4,  53 << 6) + section 18
 EQUB -16               \ Sign 11 = ( 23 << 6,  12 << 4, -16 << 6) + section 19
 EQUB -59               \ Sign 12 = ( 48 << 6,  22 << 4, -59 << 6) + section 20
 EQUB -16               \ Sign 13 = ( -6 << 6,   4 << 4, -16 << 6) + section 21
 EQUB -57               \ Sign 14 = (-46 << 6, -16 << 4, -57 << 6) + section 22
 EQUB  36               \ Sign 15 = (  0 << 6,   8 << 4,  36 << 6) + section 23

\ ******************************************************************************
\
\       Name: yTrackSignVector
\       Type: Variable
\   Category: Track data
\    Summary: The y-coordinate of the track sign vector for each sign, to be
\             scaled and added to the inner track section vector for the sign
\
\ ******************************************************************************

 EQUB   8               \ Sign  0 = (-10 << 6,   8 << 4, 108 << 6) + section  0
 EQUB   8               \ Sign  1 = ( -8 << 6,   8 << 4,   4 << 6) + section  2
 EQUB   8               \ Sign  2 = ( 82 << 6,   8 << 4,  27 << 6) + section  3
 EQUB   8               \ Sign  3 = (-78 << 6,   8 << 4,   3 << 6) + section  5
 EQUB   0               \ Sign  4 = (  7 << 6,   0 << 4,   8 << 6) + section  7
 EQUB  18               \ Sign  5 = ( -4 << 6,  18 << 4,  75 << 6) + section  9
 EQUB  17               \ Sign  6 = (-39 << 6,  17 << 4,  63 << 6) + section 12
 EQUB   8               \ Sign  7 = ( 40 << 6,   8 << 4,  14 << 6) + section 14
 EQUB   8               \ Sign  8 = ( -5 << 6,   8 << 4,  -1 << 6) + section 14
 EQUB -16               \ Sign  9 = (-51 << 6, -16 << 4, -79 << 6) + section 14
 EQUB -20               \ Sign 10 = ( 39 << 6, -20 << 4,  53 << 6) + section 18
 EQUB  12               \ Sign 11 = ( 23 << 6,  12 << 4, -16 << 6) + section 19
 EQUB  22               \ Sign 12 = ( 48 << 6,  22 << 4, -59 << 6) + section 20
 EQUB   4               \ Sign 13 = ( -6 << 6,   4 << 4, -16 << 6) + section 21
 EQUB -16               \ Sign 14 = (-46 << 6, -16 << 4, -57 << 6) + section 22
 EQUB   8               \ Sign 15 = (  0 << 6,   8 << 4,  36 << 6) + section 23

\ ******************************************************************************
\
\       Name: xTrackVectorI
\       Type: Variable
\   Category: Track data
\    Summary: Vector x-coordinates between two consecutive points on the inside
\             of the track
\
\ ******************************************************************************

 EQUB   -4              \ Vector   0 = (  -4,   0,  120)
 EQUB   -2              \ Vector   1 = (  -2,   0,  120)
 EQUB    2              \ Vector   2 = (   2,   0,  120)
 EQUB    6              \ Vector   3 = (   6,   0,  120)
 EQUB   10              \ Vector   4 = (  10,   0,  120)
 EQUB   14              \ Vector   5 = (  14,   0,  119)
 EQUB   18              \ Vector   6 = (  18,   0,  119)
 EQUB   21              \ Vector   7 = (  21,   0,  118)
 EQUB   25              \ Vector   8 = (  25,   0,  117)
 EQUB   29              \ Vector   9 = (  29,   0,  116)
 EQUB   33              \ Vector  10 = (  33,   0,  115)
 EQUB   37              \ Vector  11 = (  37,   0,  114)
 EQUB   40              \ Vector  12 = (  40,   0,  113)
 EQUB   44              \ Vector  13 = (  44,   0,  112)
 EQUB   48              \ Vector  14 = (  48,   0,  110)
 EQUB   51              \ Vector  15 = (  51,   0,  109)
 EQUB   60              \ Vector  16 = (  60,   0,  104)
 EQUB   74              \ Vector  17 = (  74,   0,   94)
 EQUB   87              \ Vector  18 = (  87,   0,   83)
 EQUB   97              \ Vector  19 = (  97,   0,   70)
 EQUB  106              \ Vector  20 = ( 106,   0,   56)
 EQUB  113              \ Vector  21 = ( 113,   0,   41)
 EQUB  114              \ Vector  22 = ( 114,   0,   38)
 EQUB  110              \ Vector  23 = ( 110,   0,   49)
 EQUB  105              \ Vector  24 = ( 105,   0,   59)
 EQUB   99              \ Vector  25 = (  99,   0,   68)
 EQUB   92              \ Vector  26 = (  92,   0,   77)
 EQUB   84              \ Vector  27 = (  84,   0,   86)
 EQUB   75              \ Vector  28 = (  75,   0,   93)
 EQUB   66              \ Vector  29 = (  66,   0,  100)
 EQUB   57              \ Vector  30 = (  57,   0,  106)
 EQUB   46              \ Vector  31 = (  46,   0,  111)
 EQUB   36              \ Vector  32 = (  36,   0,  115)
 EQUB   25              \ Vector  33 = (  25,   0,  117)
 EQUB   28              \ Vector  34 = (  28,   0,  116)
 EQUB   46              \ Vector  35 = (  46,   0,  111)
 EQUB   63              \ Vector  36 = (  63,   0,  102)
 EQUB   79              \ Vector  37 = (  79,   0,   91)
 EQUB   87              \ Vector  38 = (  87,   0,   82)
 EQUB   91              \ Vector  39 = (  91,   0,   78)
 EQUB   94              \ Vector  40 = (  94,   0,   74)
 EQUB   97              \ Vector  41 = (  97,   0,   70)
 EQUB  100              \ Vector  42 = ( 100,   0,   66)
 EQUB  103              \ Vector  43 = ( 103,   0,   62)
 EQUB  105              \ Vector  44 = ( 105,   0,   57)
 EQUB  108              \ Vector  45 = ( 108,   0,   53)
 EQUB  110              \ Vector  46 = ( 110,   0,   48)
 EQUB  112              \ Vector  47 = ( 112,   0,   43)
 EQUB  114              \ Vector  48 = ( 114,   0,   38)
 EQUB  115              \ Vector  49 = ( 115,   0,   33)
 EQUB  117              \ Vector  50 = ( 117,   0,   28)
 EQUB  118              \ Vector  51 = ( 118,   0,   23)
 EQUB  119              \ Vector  52 = ( 119,   0,   18)
 EQUB  119              \ Vector  53 = ( 119,   0,   13)
 EQUB  120              \ Vector  54 = ( 120,   0,    8)
 EQUB  120              \ Vector  55 = ( 120,   0,    5)
 EQUB  120              \ Vector  56 = ( 120,   0,    2)
 EQUB  120              \ Vector  57 = ( 120,   0,   -5)
 EQUB  119              \ Vector  58 = ( 119,   0,  -12)
 EQUB  119              \ Vector  59 = ( 119,   0,  -18)
 EQUB  117              \ Vector  60 = ( 117,   0,  -25)
 EQUB  116              \ Vector  61 = ( 116,   0,  -31)
 EQUB  114              \ Vector  62 = ( 114,   0,  -38)
 EQUB  112              \ Vector  63 = ( 112,   0,  -44)
 EQUB  109              \ Vector  64 = ( 109,   0,  -50)
 EQUB  106              \ Vector  65 = ( 106,   0,  -56)
 EQUB  103              \ Vector  66 = ( 103,   0,  -62)
 EQUB   99              \ Vector  67 = (  99,   0,  -68)
 EQUB   95              \ Vector  68 = (  95,   0,  -73)
 EQUB   91              \ Vector  69 = (  91,   0,  -78)
 EQUB   85              \ Vector  70 = (  85,   1,  -84)
 EQUB   78              \ Vector  71 = (  78,   3,  -91)
 EQUB   71              \ Vector  72 = (  71,   4,  -97)
 EQUB   63              \ Vector  73 = (  63,   5, -102)
 EQUB   55              \ Vector  74 = (  55,   7, -107)
 EQUB   46              \ Vector  75 = (  46,   8, -111)
 EQUB   38              \ Vector  76 = (  38,  10, -114)
 EQUB   28              \ Vector  77 = (  28,  11, -117)
 EQUB   19              \ Vector  78 = (  19,  12, -118)
 EQUB   10              \ Vector  79 = (  10,  14, -120)
 EQUB    5              \ Vector  80 = (   5,  14, -120)
 EQUB    5              \ Vector  81 = (   5,  12, -120)
 EQUB    5              \ Vector  82 = (   5,  10, -120)
 EQUB    5              \ Vector  83 = (   5,   8, -120)
 EQUB    5              \ Vector  84 = (   5,   6, -120)
 EQUB    5              \ Vector  85 = (   5,   4, -120)
 EQUB    5              \ Vector  86 = (   5,   2, -120)
 EQUB    5              \ Vector  87 = (   5,   0, -120)
 EQUB    5              \ Vector  88 = (   5,  -2, -120)
 EQUB    5              \ Vector  89 = (   5,  -4, -120)
 EQUB    5              \ Vector  90 = (   5,  -4, -120)
 EQUB    7              \ Vector  91 = (   7,  -4, -120)
 EQUB   11              \ Vector  92 = (  11,  -4, -119)
 EQUB   16              \ Vector  93 = (  16,  -4, -119)
 EQUB   20              \ Vector  94 = (  20,  -4, -118)
 EQUB   24              \ Vector  95 = (  24,  -4, -118)
 EQUB   28              \ Vector  96 = (  28,  -4, -117)
 EQUB   32              \ Vector  97 = (  32,  -4, -116)
 EQUB   36              \ Vector  98 = (  36,  -4, -114)
 EQUB   40              \ Vector  99 = (  40,  -4, -113)
 EQUB   44              \ Vector 100 = (  44,  -4, -112)
 EQUB   48              \ Vector 101 = (  48,  -4, -110)
 EQUB   52              \ Vector 102 = (  52,  -4, -108)
 EQUB   56              \ Vector 103 = (  56,  -4, -106)
 EQUB   59              \ Vector 104 = (  59,  -4, -104)
 EQUB   63              \ Vector 105 = (  63,  -4, -102)
 EQUB   67              \ Vector 106 = (  67,  -4, -100)
 EQUB   68              \ Vector 107 = (  68,  -4,  -99)
 EQUB   73              \ Vector 108 = (  73,  -4,  -96)
 EQUB   68              \ Vector 109 = (  68,  -3,  -99)
 EQUB   59              \ Vector 110 = (  59,  -3, -105)
 EQUB   49              \ Vector 111 = (  49,  -2, -110)
 EQUB   38              \ Vector 112 = (  38,  -2, -114)
 EQUB   27              \ Vector 113 = (  27,  -2, -117)
 EQUB   16              \ Vector 114 = (  16,  -1, -119)
 EQUB    5              \ Vector 115 = (   5,  -1, -120)
 EQUB   -6              \ Vector 116 = (  -6,   0, -120)
 EQUB  -17              \ Vector 117 = ( -17,   0, -119)
 EQUB  -26              \ Vector 118 = ( -26,   0, -117)
 EQUB  -33              \ Vector 119 = ( -33,   0, -115)
 EQUB  -40              \ Vector 120 = ( -40,   0, -113)
 EQUB  -46              \ Vector 121 = ( -46,   0, -111)
 EQUB  -53              \ Vector 122 = ( -53,   0, -108)
 EQUB  -59              \ Vector 123 = ( -59,   0, -105)
 EQUB  -65              \ Vector 124 = ( -65,   0, -101)
 EQUB  -71              \ Vector 125 = ( -71,   0,  -97)
 EQUB  -76              \ Vector 126 = ( -76,   0,  -93)
 EQUB  -82              \ Vector 127 = ( -82,   0,  -88)
 EQUB  -87              \ Vector 128 = ( -87,   0,  -83)
 EQUB  -91              \ Vector 129 = ( -91,   0,  -78)
 EQUB  -96              \ Vector 130 = ( -96,   0,  -72)
 EQUB -100              \ Vector 131 = (-100,   0,  -66)
 EQUB -104              \ Vector 132 = (-104,   0,  -60)
 EQUB -107              \ Vector 133 = (-107,   0,  -54)
 EQUB -110              \ Vector 134 = (-110,   0,  -48)
 EQUB -113              \ Vector 135 = (-113,   0,  -41)
 EQUB -114              \ Vector 136 = (-114,   0,  -38)
 EQUB -113              \ Vector 137 = (-113,   0,  -40)
 EQUB -111              \ Vector 138 = (-111,  -1,  -45)
 EQUB -109              \ Vector 139 = (-109,  -1,  -50)
 EQUB -107              \ Vector 140 = (-107,  -2,  -55)
 EQUB -104              \ Vector 141 = (-104,  -2,  -60)
 EQUB -101              \ Vector 142 = (-101,  -3,  -64)
 EQUB  -99              \ Vector 143 = ( -99,  -3,  -68)
 EQUB  -95              \ Vector 144 = ( -95,  -4,  -73)
 EQUB  -92              \ Vector 145 = ( -92,  -4,  -77)
 EQUB  -89              \ Vector 146 = ( -89,  -5,  -81)
 EQUB  -85              \ Vector 147 = ( -85,  -5,  -85)
 EQUB  -81              \ Vector 148 = ( -81,  -6,  -88)
 EQUB  -77              \ Vector 149 = ( -77,  -6,  -92)
 EQUB  -73              \ Vector 150 = ( -73,  -7,  -95)
 EQUB  -69              \ Vector 151 = ( -69,  -7,  -98)
 EQUB  -64              \ Vector 152 = ( -64,  -8, -101)
 EQUB  -62              \ Vector 153 = ( -62,  -8, -103)
 EQUB  -62              \ Vector 154 = ( -62,  -4, -103)
 EQUB  -62              \ Vector 155 = ( -62,   0, -103)
 EQUB  -62              \ Vector 156 = ( -62,   4, -103)
 EQUB  -62              \ Vector 157 = ( -62,   8, -103)
 EQUB  -62              \ Vector 158 = ( -62,  11, -103)
 EQUB  -62              \ Vector 159 = ( -62,  15, -103)
 EQUB  -62              \ Vector 160 = ( -62,  15, -103)
 EQUB  -65              \ Vector 161 = ( -65,  15, -101)
 EQUB  -70              \ Vector 162 = ( -70,  14,  -97)
 EQUB  -76              \ Vector 163 = ( -76,  14,  -93)
 EQUB  -81              \ Vector 164 = ( -81,  13,  -89)
 EQUB  -86              \ Vector 165 = ( -86,  13,  -84)
 EQUB  -90              \ Vector 166 = ( -90,  12,  -79)
 EQUB  -94              \ Vector 167 = ( -94,  12,  -74)
 EQUB  -99              \ Vector 168 = ( -99,  11,  -68)
 EQUB -102              \ Vector 169 = (-102,  11,  -63)
 EQUB -106              \ Vector 170 = (-106,  10,  -57)
 EQUB -108              \ Vector 171 = (-108,  10,  -52)
 EQUB -110              \ Vector 172 = (-110,   9,  -49)
 EQUB -111              \ Vector 173 = (-111,   9,  -45)
 EQUB -113              \ Vector 174 = (-113,   8,  -41)
 EQUB -114              \ Vector 175 = (-114,   8,  -38)
 EQUB -115              \ Vector 176 = (-115,   7,  -34)
 EQUB -116              \ Vector 177 = (-116,   7,  -30)
 EQUB -117              \ Vector 178 = (-117,   6,  -26)
 EQUB -118              \ Vector 179 = (-118,   6,  -23)
 EQUB -119              \ Vector 180 = (-119,   5,  -19)
 EQUB -119              \ Vector 181 = (-119,   5,  -15)
 EQUB -120              \ Vector 182 = (-120,   5,  -11)
 EQUB -120              \ Vector 183 = (-120,   4,   -7)
 EQUB -120              \ Vector 184 = (-120,   4,   -3)
 EQUB -120              \ Vector 185 = (-120,   3,    1)
 EQUB -120              \ Vector 186 = (-120,   3,    5)
 EQUB -120              \ Vector 187 = (-120,   2,    9)
 EQUB -119              \ Vector 188 = (-119,   2,   13)
 EQUB -119              \ Vector 189 = (-119,   1,   17)
 EQUB -118              \ Vector 190 = (-118,   1,   20)
 EQUB -118              \ Vector 191 = (-118,   0,   24)
 EQUB -117              \ Vector 192 = (-117,   0,   28)
 EQUB -115              \ Vector 193 = (-115,  -1,   34)
 EQUB -112              \ Vector 194 = (-112,  -2,   42)
 EQUB -109              \ Vector 195 = (-109,  -2,   50)
 EQUB -106              \ Vector 196 = (-106,  -3,   57)
 EQUB -101              \ Vector 197 = (-101,  -4,   64)
 EQUB  -97              \ Vector 198 = ( -97,  -5,   71)
 EQUB  -91              \ Vector 199 = ( -91,  -6,   78)
 EQUB  -86              \ Vector 200 = ( -86,  -6,   84)
 EQUB  -83              \ Vector 201 = ( -83,  -6,   87)
 EQUB  -81              \ Vector 202 = ( -81,  -6,   88)
 EQUB  -77              \ Vector 203 = ( -77,  -5,   92)
 EQUB  -73              \ Vector 204 = ( -73,  -5,   95)
 EQUB  -69              \ Vector 205 = ( -69,  -4,   98)
 EQUB  -64              \ Vector 206 = ( -64,  -4,  101)
 EQUB  -60              \ Vector 207 = ( -60,  -3,  104)
 EQUB  -55              \ Vector 208 = ( -55,  -3,  107)
 EQUB  -50              \ Vector 209 = ( -50,  -2,  109)
 EQUB  -46              \ Vector 210 = ( -46,  -2,  111)
 EQUB  -41              \ Vector 211 = ( -41,  -1,  113)
 EQUB  -36              \ Vector 212 = ( -36,  -1,  115)
 EQUB  -31              \ Vector 213 = ( -31,   0,  116)
 EQUB  -26              \ Vector 214 = ( -26,   0,  117)
 EQUB  -20              \ Vector 215 = ( -20,   1,  118)
 EQUB  -15              \ Vector 216 = ( -15,   1,  119)
 EQUB  -10              \ Vector 217 = ( -10,   2,  120)
 EQUB   -5              \ Vector 218 = (  -5,   2,  120)
 EQUB    1              \ Vector 219 = (   1,   3,  120)
 EQUB    6              \ Vector 220 = (   6,   3,  120)
 EQUB   11              \ Vector 221 = (  11,   4,  119)
 EQUB   16              \ Vector 222 = (  16,   4,  119)
 EQUB   21              \ Vector 223 = (  21,   5,  118)
 EQUB   27              \ Vector 224 = (  27,   5,  117)
 EQUB   32              \ Vector 225 = (  32,   6,  116)
 EQUB   37              \ Vector 226 = (  37,   6,  114)
 EQUB   42              \ Vector 227 = (  42,   7,  112)
 EQUB   47              \ Vector 228 = (  47,   7,  111)
 EQUB   51              \ Vector 229 = (  51,   8,  108)
 EQUB   56              \ Vector 230 = (  56,   8,  106)
 EQUB   61              \ Vector 231 = (  61,   9,  103)
 EQUB   65              \ Vector 232 = (  65,   9,  101)
 EQUB   70              \ Vector 233 = (  70,  10,   98)
 EQUB   74              \ Vector 234 = (  74,  10,   95)
 EQUB   76              \ Vector 235 = (  76,  10,   93)
 EQUB   74              \ Vector 236 = (  74,  11,   94)
 EQUB   70              \ Vector 237 = (  70,  12,   97)
 EQUB   66              \ Vector 238 = (  66,  13,  100)
 EQUB   62              \ Vector 239 = (  62,  14,  103)
 EQUB   58              \ Vector 240 = (  58,  14,  105)
 EQUB   54              \ Vector 241 = (  54,  15,  107)
 EQUB   49              \ Vector 242 = (  49,  16,  109)
 EQUB   45              \ Vector 243 = (  45,  17,  111)
 EQUB   40              \ Vector 244 = (  40,  18,  113)
 EQUB   36              \ Vector 245 = (  36,  18,  115)
 EQUB   31              \ Vector 246 = (  31,  19,  116)
 EQUB   26              \ Vector 247 = (  26,  20,  117)
 EQUB   22              \ Vector 248 = (  22,  17,  118)
 EQUB   17              \ Vector 249 = (  17,  13,  119)
 EQUB   12              \ Vector 250 = (  12,  10,  119)
 EQUB    8              \ Vector 251 = (   8,   7,  120)
 EQUB    3              \ Vector 252 = (   3,   3,  120)
 EQUB   -2              \ Vector 253 = (  -2,   0,  120)
 EQUB   -5              \ Vector 254 = (  -5,   0,  120)
 EQUB    0              \ Vector 255 = (   0,   0,   83)

\ ******************************************************************************
\
\       Name: yTrackVectorI
\       Type: Variable
\   Category: Track data
\    Summary: Vector y-coordinates between two consecutive points on the inside
\             of the track
\
\ ******************************************************************************

 EQUB    0              \ Vector   0 = (  -4,   0,  120)
 EQUB    0              \ Vector   1 = (  -2,   0,  120)
 EQUB    0              \ Vector   2 = (   2,   0,  120)
 EQUB    0              \ Vector   3 = (   6,   0,  120)
 EQUB    0              \ Vector   4 = (  10,   0,  120)
 EQUB    0              \ Vector   5 = (  14,   0,  119)
 EQUB    0              \ Vector   6 = (  18,   0,  119)
 EQUB    0              \ Vector   7 = (  21,   0,  118)
 EQUB    0              \ Vector   8 = (  25,   0,  117)
 EQUB    0              \ Vector   9 = (  29,   0,  116)
 EQUB    0              \ Vector  10 = (  33,   0,  115)
 EQUB    0              \ Vector  11 = (  37,   0,  114)
 EQUB    0              \ Vector  12 = (  40,   0,  113)
 EQUB    0              \ Vector  13 = (  44,   0,  112)
 EQUB    0              \ Vector  14 = (  48,   0,  110)
 EQUB    0              \ Vector  15 = (  51,   0,  109)
 EQUB    0              \ Vector  16 = (  60,   0,  104)
 EQUB    0              \ Vector  17 = (  74,   0,   94)
 EQUB    0              \ Vector  18 = (  87,   0,   83)
 EQUB    0              \ Vector  19 = (  97,   0,   70)
 EQUB    0              \ Vector  20 = ( 106,   0,   56)
 EQUB    0              \ Vector  21 = ( 113,   0,   41)
 EQUB    0              \ Vector  22 = ( 114,   0,   38)
 EQUB    0              \ Vector  23 = ( 110,   0,   49)
 EQUB    0              \ Vector  24 = ( 105,   0,   59)
 EQUB    0              \ Vector  25 = (  99,   0,   68)
 EQUB    0              \ Vector  26 = (  92,   0,   77)
 EQUB    0              \ Vector  27 = (  84,   0,   86)
 EQUB    0              \ Vector  28 = (  75,   0,   93)
 EQUB    0              \ Vector  29 = (  66,   0,  100)
 EQUB    0              \ Vector  30 = (  57,   0,  106)
 EQUB    0              \ Vector  31 = (  46,   0,  111)
 EQUB    0              \ Vector  32 = (  36,   0,  115)
 EQUB    0              \ Vector  33 = (  25,   0,  117)
 EQUB    0              \ Vector  34 = (  28,   0,  116)
 EQUB    0              \ Vector  35 = (  46,   0,  111)
 EQUB    0              \ Vector  36 = (  63,   0,  102)
 EQUB    0              \ Vector  37 = (  79,   0,   91)
 EQUB    0              \ Vector  38 = (  87,   0,   82)
 EQUB    0              \ Vector  39 = (  91,   0,   78)
 EQUB    0              \ Vector  40 = (  94,   0,   74)
 EQUB    0              \ Vector  41 = (  97,   0,   70)
 EQUB    0              \ Vector  42 = ( 100,   0,   66)
 EQUB    0              \ Vector  43 = ( 103,   0,   62)
 EQUB    0              \ Vector  44 = ( 105,   0,   57)
 EQUB    0              \ Vector  45 = ( 108,   0,   53)
 EQUB    0              \ Vector  46 = ( 110,   0,   48)
 EQUB    0              \ Vector  47 = ( 112,   0,   43)
 EQUB    0              \ Vector  48 = ( 114,   0,   38)
 EQUB    0              \ Vector  49 = ( 115,   0,   33)
 EQUB    0              \ Vector  50 = ( 117,   0,   28)
 EQUB    0              \ Vector  51 = ( 118,   0,   23)
 EQUB    0              \ Vector  52 = ( 119,   0,   18)
 EQUB    0              \ Vector  53 = ( 119,   0,   13)
 EQUB    0              \ Vector  54 = ( 120,   0,    8)
 EQUB    0              \ Vector  55 = ( 120,   0,    5)
 EQUB    0              \ Vector  56 = ( 120,   0,    2)
 EQUB    0              \ Vector  57 = ( 120,   0,   -5)
 EQUB    0              \ Vector  58 = ( 119,   0,  -12)
 EQUB    0              \ Vector  59 = ( 119,   0,  -18)
 EQUB    0              \ Vector  60 = ( 117,   0,  -25)
 EQUB    0              \ Vector  61 = ( 116,   0,  -31)
 EQUB    0              \ Vector  62 = ( 114,   0,  -38)
 EQUB    0              \ Vector  63 = ( 112,   0,  -44)
 EQUB    0              \ Vector  64 = ( 109,   0,  -50)
 EQUB    0              \ Vector  65 = ( 106,   0,  -56)
 EQUB    0              \ Vector  66 = ( 103,   0,  -62)
 EQUB    0              \ Vector  67 = (  99,   0,  -68)
 EQUB    0              \ Vector  68 = (  95,   0,  -73)
 EQUB    0              \ Vector  69 = (  91,   0,  -78)
 EQUB    1              \ Vector  70 = (  85,   1,  -84)
 EQUB    3              \ Vector  71 = (  78,   3,  -91)
 EQUB    4              \ Vector  72 = (  71,   4,  -97)
 EQUB    5              \ Vector  73 = (  63,   5, -102)
 EQUB    7              \ Vector  74 = (  55,   7, -107)
 EQUB    8              \ Vector  75 = (  46,   8, -111)
 EQUB   10              \ Vector  76 = (  38,  10, -114)
 EQUB   11              \ Vector  77 = (  28,  11, -117)
 EQUB   12              \ Vector  78 = (  19,  12, -118)
 EQUB   14              \ Vector  79 = (  10,  14, -120)
 EQUB   14              \ Vector  80 = (   5,  14, -120)
 EQUB   12              \ Vector  81 = (   5,  12, -120)
 EQUB   10              \ Vector  82 = (   5,  10, -120)
 EQUB    8              \ Vector  83 = (   5,   8, -120)
 EQUB    6              \ Vector  84 = (   5,   6, -120)
 EQUB    4              \ Vector  85 = (   5,   4, -120)
 EQUB    2              \ Vector  86 = (   5,   2, -120)
 EQUB    0              \ Vector  87 = (   5,   0, -120)
 EQUB   -2              \ Vector  88 = (   5,  -2, -120)
 EQUB   -4              \ Vector  89 = (   5,  -4, -120)
 EQUB   -4              \ Vector  90 = (   5,  -4, -120)
 EQUB   -4              \ Vector  91 = (   7,  -4, -120)
 EQUB   -4              \ Vector  92 = (  11,  -4, -119)
 EQUB   -4              \ Vector  93 = (  16,  -4, -119)
 EQUB   -4              \ Vector  94 = (  20,  -4, -118)
 EQUB   -4              \ Vector  95 = (  24,  -4, -118)
 EQUB   -4              \ Vector  96 = (  28,  -4, -117)
 EQUB   -4              \ Vector  97 = (  32,  -4, -116)
 EQUB   -4              \ Vector  98 = (  36,  -4, -114)
 EQUB   -4              \ Vector  99 = (  40,  -4, -113)
 EQUB   -4              \ Vector 100 = (  44,  -4, -112)
 EQUB   -4              \ Vector 101 = (  48,  -4, -110)
 EQUB   -4              \ Vector 102 = (  52,  -4, -108)
 EQUB   -4              \ Vector 103 = (  56,  -4, -106)
 EQUB   -4              \ Vector 104 = (  59,  -4, -104)
 EQUB   -4              \ Vector 105 = (  63,  -4, -102)
 EQUB   -4              \ Vector 106 = (  67,  -4, -100)
 EQUB   -4              \ Vector 107 = (  68,  -4,  -99)
 EQUB   -4              \ Vector 108 = (  73,  -4,  -96)
 EQUB   -3              \ Vector 109 = (  68,  -3,  -99)
 EQUB   -3              \ Vector 110 = (  59,  -3, -105)
 EQUB   -2              \ Vector 111 = (  49,  -2, -110)
 EQUB   -2              \ Vector 112 = (  38,  -2, -114)
 EQUB   -2              \ Vector 113 = (  27,  -2, -117)
 EQUB   -1              \ Vector 114 = (  16,  -1, -119)
 EQUB   -1              \ Vector 115 = (   5,  -1, -120)
 EQUB    0              \ Vector 116 = (  -6,   0, -120)
 EQUB    0              \ Vector 117 = ( -17,   0, -119)
 EQUB    0              \ Vector 118 = ( -26,   0, -117)
 EQUB    0              \ Vector 119 = ( -33,   0, -115)
 EQUB    0              \ Vector 120 = ( -40,   0, -113)
 EQUB    0              \ Vector 121 = ( -46,   0, -111)
 EQUB    0              \ Vector 122 = ( -53,   0, -108)
 EQUB    0              \ Vector 123 = ( -59,   0, -105)
 EQUB    0              \ Vector 124 = ( -65,   0, -101)
 EQUB    0              \ Vector 125 = ( -71,   0,  -97)
 EQUB    0              \ Vector 126 = ( -76,   0,  -93)
 EQUB    0              \ Vector 127 = ( -82,   0,  -88)
 EQUB    0              \ Vector 128 = ( -87,   0,  -83)
 EQUB    0              \ Vector 129 = ( -91,   0,  -78)
 EQUB    0              \ Vector 130 = ( -96,   0,  -72)
 EQUB    0              \ Vector 131 = (-100,   0,  -66)
 EQUB    0              \ Vector 132 = (-104,   0,  -60)
 EQUB    0              \ Vector 133 = (-107,   0,  -54)
 EQUB    0              \ Vector 134 = (-110,   0,  -48)
 EQUB    0              \ Vector 135 = (-113,   0,  -41)
 EQUB    0              \ Vector 136 = (-114,   0,  -38)
 EQUB    0              \ Vector 137 = (-113,   0,  -40)
 EQUB   -1              \ Vector 138 = (-111,  -1,  -45)
 EQUB   -1              \ Vector 139 = (-109,  -1,  -50)
 EQUB   -2              \ Vector 140 = (-107,  -2,  -55)
 EQUB   -2              \ Vector 141 = (-104,  -2,  -60)
 EQUB   -3              \ Vector 142 = (-101,  -3,  -64)
 EQUB   -3              \ Vector 143 = ( -99,  -3,  -68)
 EQUB   -4              \ Vector 144 = ( -95,  -4,  -73)
 EQUB   -4              \ Vector 145 = ( -92,  -4,  -77)
 EQUB   -5              \ Vector 146 = ( -89,  -5,  -81)
 EQUB   -5              \ Vector 147 = ( -85,  -5,  -85)
 EQUB   -6              \ Vector 148 = ( -81,  -6,  -88)
 EQUB   -6              \ Vector 149 = ( -77,  -6,  -92)
 EQUB   -7              \ Vector 150 = ( -73,  -7,  -95)
 EQUB   -7              \ Vector 151 = ( -69,  -7,  -98)
 EQUB   -8              \ Vector 152 = ( -64,  -8, -101)
 EQUB   -8              \ Vector 153 = ( -62,  -8, -103)
 EQUB   -4              \ Vector 154 = ( -62,  -4, -103)
 EQUB    0              \ Vector 155 = ( -62,   0, -103)
 EQUB    4              \ Vector 156 = ( -62,   4, -103)
 EQUB    8              \ Vector 157 = ( -62,   8, -103)
 EQUB   11              \ Vector 158 = ( -62,  11, -103)
 EQUB   15              \ Vector 159 = ( -62,  15, -103)
 EQUB   15              \ Vector 160 = ( -62,  15, -103)
 EQUB   15              \ Vector 161 = ( -65,  15, -101)
 EQUB   14              \ Vector 162 = ( -70,  14,  -97)
 EQUB   14              \ Vector 163 = ( -76,  14,  -93)
 EQUB   13              \ Vector 164 = ( -81,  13,  -89)
 EQUB   13              \ Vector 165 = ( -86,  13,  -84)
 EQUB   12              \ Vector 166 = ( -90,  12,  -79)
 EQUB   12              \ Vector 167 = ( -94,  12,  -74)
 EQUB   11              \ Vector 168 = ( -99,  11,  -68)
 EQUB   11              \ Vector 169 = (-102,  11,  -63)
 EQUB   10              \ Vector 170 = (-106,  10,  -57)
 EQUB   10              \ Vector 171 = (-108,  10,  -52)
 EQUB    9              \ Vector 172 = (-110,   9,  -49)
 EQUB    9              \ Vector 173 = (-111,   9,  -45)
 EQUB    8              \ Vector 174 = (-113,   8,  -41)
 EQUB    8              \ Vector 175 = (-114,   8,  -38)
 EQUB    7              \ Vector 176 = (-115,   7,  -34)
 EQUB    7              \ Vector 177 = (-116,   7,  -30)
 EQUB    6              \ Vector 178 = (-117,   6,  -26)
 EQUB    6              \ Vector 179 = (-118,   6,  -23)
 EQUB    5              \ Vector 180 = (-119,   5,  -19)
 EQUB    5              \ Vector 181 = (-119,   5,  -15)
 EQUB    5              \ Vector 182 = (-120,   5,  -11)
 EQUB    4              \ Vector 183 = (-120,   4,   -7)
 EQUB    4              \ Vector 184 = (-120,   4,   -3)
 EQUB    3              \ Vector 185 = (-120,   3,    1)
 EQUB    3              \ Vector 186 = (-120,   3,    5)
 EQUB    2              \ Vector 187 = (-120,   2,    9)
 EQUB    2              \ Vector 188 = (-119,   2,   13)
 EQUB    1              \ Vector 189 = (-119,   1,   17)
 EQUB    1              \ Vector 190 = (-118,   1,   20)
 EQUB    0              \ Vector 191 = (-118,   0,   24)
 EQUB    0              \ Vector 192 = (-117,   0,   28)
 EQUB   -1              \ Vector 193 = (-115,  -1,   34)
 EQUB   -2              \ Vector 194 = (-112,  -2,   42)
 EQUB   -2              \ Vector 195 = (-109,  -2,   50)
 EQUB   -3              \ Vector 196 = (-106,  -3,   57)
 EQUB   -4              \ Vector 197 = (-101,  -4,   64)
 EQUB   -5              \ Vector 198 = ( -97,  -5,   71)
 EQUB   -6              \ Vector 199 = ( -91,  -6,   78)
 EQUB   -6              \ Vector 200 = ( -86,  -6,   84)
 EQUB   -6              \ Vector 201 = ( -83,  -6,   87)
 EQUB   -6              \ Vector 202 = ( -81,  -6,   88)
 EQUB   -5              \ Vector 203 = ( -77,  -5,   92)
 EQUB   -5              \ Vector 204 = ( -73,  -5,   95)
 EQUB   -4              \ Vector 205 = ( -69,  -4,   98)
 EQUB   -4              \ Vector 206 = ( -64,  -4,  101)
 EQUB   -3              \ Vector 207 = ( -60,  -3,  104)
 EQUB   -3              \ Vector 208 = ( -55,  -3,  107)
 EQUB   -2              \ Vector 209 = ( -50,  -2,  109)
 EQUB   -2              \ Vector 210 = ( -46,  -2,  111)
 EQUB   -1              \ Vector 211 = ( -41,  -1,  113)
 EQUB   -1              \ Vector 212 = ( -36,  -1,  115)
 EQUB    0              \ Vector 213 = ( -31,   0,  116)
 EQUB    0              \ Vector 214 = ( -26,   0,  117)
 EQUB    1              \ Vector 215 = ( -20,   1,  118)
 EQUB    1              \ Vector 216 = ( -15,   1,  119)
 EQUB    2              \ Vector 217 = ( -10,   2,  120)
 EQUB    2              \ Vector 218 = (  -5,   2,  120)
 EQUB    3              \ Vector 219 = (   1,   3,  120)
 EQUB    3              \ Vector 220 = (   6,   3,  120)
 EQUB    4              \ Vector 221 = (  11,   4,  119)
 EQUB    4              \ Vector 222 = (  16,   4,  119)
 EQUB    5              \ Vector 223 = (  21,   5,  118)
 EQUB    5              \ Vector 224 = (  27,   5,  117)
 EQUB    6              \ Vector 225 = (  32,   6,  116)
 EQUB    6              \ Vector 226 = (  37,   6,  114)
 EQUB    7              \ Vector 227 = (  42,   7,  112)
 EQUB    7              \ Vector 228 = (  47,   7,  111)
 EQUB    8              \ Vector 229 = (  51,   8,  108)
 EQUB    8              \ Vector 230 = (  56,   8,  106)
 EQUB    9              \ Vector 231 = (  61,   9,  103)
 EQUB    9              \ Vector 232 = (  65,   9,  101)
 EQUB   10              \ Vector 233 = (  70,  10,   98)
 EQUB   10              \ Vector 234 = (  74,  10,   95)
 EQUB   10              \ Vector 235 = (  76,  10,   93)
 EQUB   11              \ Vector 236 = (  74,  11,   94)
 EQUB   12              \ Vector 237 = (  70,  12,   97)
 EQUB   13              \ Vector 238 = (  66,  13,  100)
 EQUB   14              \ Vector 239 = (  62,  14,  103)
 EQUB   14              \ Vector 240 = (  58,  14,  105)
 EQUB   15              \ Vector 241 = (  54,  15,  107)
 EQUB   16              \ Vector 242 = (  49,  16,  109)
 EQUB   17              \ Vector 243 = (  45,  17,  111)
 EQUB   18              \ Vector 244 = (  40,  18,  113)
 EQUB   18              \ Vector 245 = (  36,  18,  115)
 EQUB   19              \ Vector 246 = (  31,  19,  116)
 EQUB   20              \ Vector 247 = (  26,  20,  117)
 EQUB   17              \ Vector 248 = (  22,  17,  118)
 EQUB   13              \ Vector 249 = (  17,  13,  119)
 EQUB   10              \ Vector 250 = (  12,  10,  119)
 EQUB    7              \ Vector 251 = (   8,   7,  120)
 EQUB    3              \ Vector 252 = (   3,   3,  120)
 EQUB    0              \ Vector 253 = (  -2,   0,  120)
 EQUB    0              \ Vector 254 = (  -5,   0,  120)
 EQUB    0              \ Vector 255 = (   0,   0,   83)

\ ******************************************************************************
\
\       Name: zTrackVectorI
\       Type: Variable
\   Category: Track data
\    Summary: Vector z-coordinates between two consecutive points on the inside
\             of the track
\
\ ******************************************************************************

 EQUB  120              \ Vector   0 = (  -4,   0,  120)
 EQUB  120              \ Vector   1 = (  -2,   0,  120)
 EQUB  120              \ Vector   2 = (   2,   0,  120)
 EQUB  120              \ Vector   3 = (   6,   0,  120)
 EQUB  120              \ Vector   4 = (  10,   0,  120)
 EQUB  119              \ Vector   5 = (  14,   0,  119)
 EQUB  119              \ Vector   6 = (  18,   0,  119)
 EQUB  118              \ Vector   7 = (  21,   0,  118)
 EQUB  117              \ Vector   8 = (  25,   0,  117)
 EQUB  116              \ Vector   9 = (  29,   0,  116)
 EQUB  115              \ Vector  10 = (  33,   0,  115)
 EQUB  114              \ Vector  11 = (  37,   0,  114)
 EQUB  113              \ Vector  12 = (  40,   0,  113)
 EQUB  112              \ Vector  13 = (  44,   0,  112)
 EQUB  110              \ Vector  14 = (  48,   0,  110)
 EQUB  109              \ Vector  15 = (  51,   0,  109)
 EQUB  104              \ Vector  16 = (  60,   0,  104)
 EQUB   94              \ Vector  17 = (  74,   0,   94)
 EQUB   83              \ Vector  18 = (  87,   0,   83)
 EQUB   70              \ Vector  19 = (  97,   0,   70)
 EQUB   56              \ Vector  20 = ( 106,   0,   56)
 EQUB   41              \ Vector  21 = ( 113,   0,   41)
 EQUB   38              \ Vector  22 = ( 114,   0,   38)
 EQUB   49              \ Vector  23 = ( 110,   0,   49)
 EQUB   59              \ Vector  24 = ( 105,   0,   59)
 EQUB   68              \ Vector  25 = (  99,   0,   68)
 EQUB   77              \ Vector  26 = (  92,   0,   77)
 EQUB   86              \ Vector  27 = (  84,   0,   86)
 EQUB   93              \ Vector  28 = (  75,   0,   93)
 EQUB  100              \ Vector  29 = (  66,   0,  100)
 EQUB  106              \ Vector  30 = (  57,   0,  106)
 EQUB  111              \ Vector  31 = (  46,   0,  111)
 EQUB  115              \ Vector  32 = (  36,   0,  115)
 EQUB  117              \ Vector  33 = (  25,   0,  117)
 EQUB  116              \ Vector  34 = (  28,   0,  116)
 EQUB  111              \ Vector  35 = (  46,   0,  111)
 EQUB  102              \ Vector  36 = (  63,   0,  102)
 EQUB   91              \ Vector  37 = (  79,   0,   91)
 EQUB   82              \ Vector  38 = (  87,   0,   82)
 EQUB   78              \ Vector  39 = (  91,   0,   78)
 EQUB   74              \ Vector  40 = (  94,   0,   74)
 EQUB   70              \ Vector  41 = (  97,   0,   70)
 EQUB   66              \ Vector  42 = ( 100,   0,   66)
 EQUB   62              \ Vector  43 = ( 103,   0,   62)
 EQUB   57              \ Vector  44 = ( 105,   0,   57)
 EQUB   53              \ Vector  45 = ( 108,   0,   53)
 EQUB   48              \ Vector  46 = ( 110,   0,   48)
 EQUB   43              \ Vector  47 = ( 112,   0,   43)
 EQUB   38              \ Vector  48 = ( 114,   0,   38)
 EQUB   33              \ Vector  49 = ( 115,   0,   33)
 EQUB   28              \ Vector  50 = ( 117,   0,   28)
 EQUB   23              \ Vector  51 = ( 118,   0,   23)
 EQUB   18              \ Vector  52 = ( 119,   0,   18)
 EQUB   13              \ Vector  53 = ( 119,   0,   13)
 EQUB    8              \ Vector  54 = ( 120,   0,    8)
 EQUB    5              \ Vector  55 = ( 120,   0,    5)
 EQUB    2              \ Vector  56 = ( 120,   0,    2)
 EQUB   -5              \ Vector  57 = ( 120,   0,   -5)
 EQUB  -12              \ Vector  58 = ( 119,   0,  -12)
 EQUB  -18              \ Vector  59 = ( 119,   0,  -18)
 EQUB  -25              \ Vector  60 = ( 117,   0,  -25)
 EQUB  -31              \ Vector  61 = ( 116,   0,  -31)
 EQUB  -38              \ Vector  62 = ( 114,   0,  -38)
 EQUB  -44              \ Vector  63 = ( 112,   0,  -44)
 EQUB  -50              \ Vector  64 = ( 109,   0,  -50)
 EQUB  -56              \ Vector  65 = ( 106,   0,  -56)
 EQUB  -62              \ Vector  66 = ( 103,   0,  -62)
 EQUB  -68              \ Vector  67 = (  99,   0,  -68)
 EQUB  -73              \ Vector  68 = (  95,   0,  -73)
 EQUB  -78              \ Vector  69 = (  91,   0,  -78)
 EQUB  -84              \ Vector  70 = (  85,   1,  -84)
 EQUB  -91              \ Vector  71 = (  78,   3,  -91)
 EQUB  -97              \ Vector  72 = (  71,   4,  -97)
 EQUB -102              \ Vector  73 = (  63,   5, -102)
 EQUB -107              \ Vector  74 = (  55,   7, -107)
 EQUB -111              \ Vector  75 = (  46,   8, -111)
 EQUB -114              \ Vector  76 = (  38,  10, -114)
 EQUB -117              \ Vector  77 = (  28,  11, -117)
 EQUB -118              \ Vector  78 = (  19,  12, -118)
 EQUB -120              \ Vector  79 = (  10,  14, -120)
 EQUB -120              \ Vector  80 = (   5,  14, -120)
 EQUB -120              \ Vector  81 = (   5,  12, -120)
 EQUB -120              \ Vector  82 = (   5,  10, -120)
 EQUB -120              \ Vector  83 = (   5,   8, -120)
 EQUB -120              \ Vector  84 = (   5,   6, -120)
 EQUB -120              \ Vector  85 = (   5,   4, -120)
 EQUB -120              \ Vector  86 = (   5,   2, -120)
 EQUB -120              \ Vector  87 = (   5,   0, -120)
 EQUB -120              \ Vector  88 = (   5,  -2, -120)
 EQUB -120              \ Vector  89 = (   5,  -4, -120)
 EQUB -120              \ Vector  90 = (   5,  -4, -120)
 EQUB -120              \ Vector  91 = (   7,  -4, -120)
 EQUB -119              \ Vector  92 = (  11,  -4, -119)
 EQUB -119              \ Vector  93 = (  16,  -4, -119)
 EQUB -118              \ Vector  94 = (  20,  -4, -118)
 EQUB -118              \ Vector  95 = (  24,  -4, -118)
 EQUB -117              \ Vector  96 = (  28,  -4, -117)
 EQUB -116              \ Vector  97 = (  32,  -4, -116)
 EQUB -114              \ Vector  98 = (  36,  -4, -114)
 EQUB -113              \ Vector  99 = (  40,  -4, -113)
 EQUB -112              \ Vector 100 = (  44,  -4, -112)
 EQUB -110              \ Vector 101 = (  48,  -4, -110)
 EQUB -108              \ Vector 102 = (  52,  -4, -108)
 EQUB -106              \ Vector 103 = (  56,  -4, -106)
 EQUB -104              \ Vector 104 = (  59,  -4, -104)
 EQUB -102              \ Vector 105 = (  63,  -4, -102)
 EQUB -100              \ Vector 106 = (  67,  -4, -100)
 EQUB  -99              \ Vector 107 = (  68,  -4,  -99)
 EQUB  -96              \ Vector 108 = (  73,  -4,  -96)
 EQUB  -99              \ Vector 109 = (  68,  -3,  -99)
 EQUB -105              \ Vector 110 = (  59,  -3, -105)
 EQUB -110              \ Vector 111 = (  49,  -2, -110)
 EQUB -114              \ Vector 112 = (  38,  -2, -114)
 EQUB -117              \ Vector 113 = (  27,  -2, -117)
 EQUB -119              \ Vector 114 = (  16,  -1, -119)
 EQUB -120              \ Vector 115 = (   5,  -1, -120)
 EQUB -120              \ Vector 116 = (  -6,   0, -120)
 EQUB -119              \ Vector 117 = ( -17,   0, -119)
 EQUB -117              \ Vector 118 = ( -26,   0, -117)
 EQUB -115              \ Vector 119 = ( -33,   0, -115)
 EQUB -113              \ Vector 120 = ( -40,   0, -113)
 EQUB -111              \ Vector 121 = ( -46,   0, -111)
 EQUB -108              \ Vector 122 = ( -53,   0, -108)
 EQUB -105              \ Vector 123 = ( -59,   0, -105)
 EQUB -101              \ Vector 124 = ( -65,   0, -101)
 EQUB  -97              \ Vector 125 = ( -71,   0,  -97)
 EQUB  -93              \ Vector 126 = ( -76,   0,  -93)
 EQUB  -88              \ Vector 127 = ( -82,   0,  -88)
 EQUB  -83              \ Vector 128 = ( -87,   0,  -83)
 EQUB  -78              \ Vector 129 = ( -91,   0,  -78)
 EQUB  -72              \ Vector 130 = ( -96,   0,  -72)
 EQUB  -66              \ Vector 131 = (-100,   0,  -66)
 EQUB  -60              \ Vector 132 = (-104,   0,  -60)
 EQUB  -54              \ Vector 133 = (-107,   0,  -54)
 EQUB  -48              \ Vector 134 = (-110,   0,  -48)
 EQUB  -41              \ Vector 135 = (-113,   0,  -41)
 EQUB  -38              \ Vector 136 = (-114,   0,  -38)
 EQUB  -40              \ Vector 137 = (-113,   0,  -40)
 EQUB  -45              \ Vector 138 = (-111,  -1,  -45)
 EQUB  -50              \ Vector 139 = (-109,  -1,  -50)
 EQUB  -55              \ Vector 140 = (-107,  -2,  -55)
 EQUB  -60              \ Vector 141 = (-104,  -2,  -60)
 EQUB  -64              \ Vector 142 = (-101,  -3,  -64)
 EQUB  -68              \ Vector 143 = ( -99,  -3,  -68)
 EQUB  -73              \ Vector 144 = ( -95,  -4,  -73)
 EQUB  -77              \ Vector 145 = ( -92,  -4,  -77)
 EQUB  -81              \ Vector 146 = ( -89,  -5,  -81)
 EQUB  -85              \ Vector 147 = ( -85,  -5,  -85)
 EQUB  -88              \ Vector 148 = ( -81,  -6,  -88)
 EQUB  -92              \ Vector 149 = ( -77,  -6,  -92)
 EQUB  -95              \ Vector 150 = ( -73,  -7,  -95)
 EQUB  -98              \ Vector 151 = ( -69,  -7,  -98)
 EQUB -101              \ Vector 152 = ( -64,  -8, -101)
 EQUB -103              \ Vector 153 = ( -62,  -8, -103)
 EQUB -103              \ Vector 154 = ( -62,  -4, -103)
 EQUB -103              \ Vector 155 = ( -62,   0, -103)
 EQUB -103              \ Vector 156 = ( -62,   4, -103)
 EQUB -103              \ Vector 157 = ( -62,   8, -103)
 EQUB -103              \ Vector 158 = ( -62,  11, -103)
 EQUB -103              \ Vector 159 = ( -62,  15, -103)
 EQUB -103              \ Vector 160 = ( -62,  15, -103)
 EQUB -101              \ Vector 161 = ( -65,  15, -101)
 EQUB  -97              \ Vector 162 = ( -70,  14,  -97)
 EQUB  -93              \ Vector 163 = ( -76,  14,  -93)
 EQUB  -89              \ Vector 164 = ( -81,  13,  -89)
 EQUB  -84              \ Vector 165 = ( -86,  13,  -84)
 EQUB  -79              \ Vector 166 = ( -90,  12,  -79)
 EQUB  -74              \ Vector 167 = ( -94,  12,  -74)
 EQUB  -68              \ Vector 168 = ( -99,  11,  -68)
 EQUB  -63              \ Vector 169 = (-102,  11,  -63)
 EQUB  -57              \ Vector 170 = (-106,  10,  -57)
 EQUB  -52              \ Vector 171 = (-108,  10,  -52)
 EQUB  -49              \ Vector 172 = (-110,   9,  -49)
 EQUB  -45              \ Vector 173 = (-111,   9,  -45)
 EQUB  -41              \ Vector 174 = (-113,   8,  -41)
 EQUB  -38              \ Vector 175 = (-114,   8,  -38)
 EQUB  -34              \ Vector 176 = (-115,   7,  -34)
 EQUB  -30              \ Vector 177 = (-116,   7,  -30)
 EQUB  -26              \ Vector 178 = (-117,   6,  -26)
 EQUB  -23              \ Vector 179 = (-118,   6,  -23)
 EQUB  -19              \ Vector 180 = (-119,   5,  -19)
 EQUB  -15              \ Vector 181 = (-119,   5,  -15)
 EQUB  -11              \ Vector 182 = (-120,   5,  -11)
 EQUB   -7              \ Vector 183 = (-120,   4,   -7)
 EQUB   -3              \ Vector 184 = (-120,   4,   -3)
 EQUB    1              \ Vector 185 = (-120,   3,    1)
 EQUB    5              \ Vector 186 = (-120,   3,    5)
 EQUB    9              \ Vector 187 = (-120,   2,    9)
 EQUB   13              \ Vector 188 = (-119,   2,   13)
 EQUB   17              \ Vector 189 = (-119,   1,   17)
 EQUB   20              \ Vector 190 = (-118,   1,   20)
 EQUB   24              \ Vector 191 = (-118,   0,   24)
 EQUB   28              \ Vector 192 = (-117,   0,   28)
 EQUB   34              \ Vector 193 = (-115,  -1,   34)
 EQUB   42              \ Vector 194 = (-112,  -2,   42)
 EQUB   50              \ Vector 195 = (-109,  -2,   50)
 EQUB   57              \ Vector 196 = (-106,  -3,   57)
 EQUB   64              \ Vector 197 = (-101,  -4,   64)
 EQUB   71              \ Vector 198 = ( -97,  -5,   71)
 EQUB   78              \ Vector 199 = ( -91,  -6,   78)
 EQUB   84              \ Vector 200 = ( -86,  -6,   84)
 EQUB   87              \ Vector 201 = ( -83,  -6,   87)
 EQUB   88              \ Vector 202 = ( -81,  -6,   88)
 EQUB   92              \ Vector 203 = ( -77,  -5,   92)
 EQUB   95              \ Vector 204 = ( -73,  -5,   95)
 EQUB   98              \ Vector 205 = ( -69,  -4,   98)
 EQUB  101              \ Vector 206 = ( -64,  -4,  101)
 EQUB  104              \ Vector 207 = ( -60,  -3,  104)
 EQUB  107              \ Vector 208 = ( -55,  -3,  107)
 EQUB  109              \ Vector 209 = ( -50,  -2,  109)
 EQUB  111              \ Vector 210 = ( -46,  -2,  111)
 EQUB  113              \ Vector 211 = ( -41,  -1,  113)
 EQUB  115              \ Vector 212 = ( -36,  -1,  115)
 EQUB  116              \ Vector 213 = ( -31,   0,  116)
 EQUB  117              \ Vector 214 = ( -26,   0,  117)
 EQUB  118              \ Vector 215 = ( -20,   1,  118)
 EQUB  119              \ Vector 216 = ( -15,   1,  119)
 EQUB  120              \ Vector 217 = ( -10,   2,  120)
 EQUB  120              \ Vector 218 = (  -5,   2,  120)
 EQUB  120              \ Vector 219 = (   1,   3,  120)
 EQUB  120              \ Vector 220 = (   6,   3,  120)
 EQUB  119              \ Vector 221 = (  11,   4,  119)
 EQUB  119              \ Vector 222 = (  16,   4,  119)
 EQUB  118              \ Vector 223 = (  21,   5,  118)
 EQUB  117              \ Vector 224 = (  27,   5,  117)
 EQUB  116              \ Vector 225 = (  32,   6,  116)
 EQUB  114              \ Vector 226 = (  37,   6,  114)
 EQUB  112              \ Vector 227 = (  42,   7,  112)
 EQUB  111              \ Vector 228 = (  47,   7,  111)
 EQUB  108              \ Vector 229 = (  51,   8,  108)
 EQUB  106              \ Vector 230 = (  56,   8,  106)
 EQUB  103              \ Vector 231 = (  61,   9,  103)
 EQUB  101              \ Vector 232 = (  65,   9,  101)
 EQUB   98              \ Vector 233 = (  70,  10,   98)
 EQUB   95              \ Vector 234 = (  74,  10,   95)
 EQUB   93              \ Vector 235 = (  76,  10,   93)
 EQUB   94              \ Vector 236 = (  74,  11,   94)
 EQUB   97              \ Vector 237 = (  70,  12,   97)
 EQUB  100              \ Vector 238 = (  66,  13,  100)
 EQUB  103              \ Vector 239 = (  62,  14,  103)
 EQUB  105              \ Vector 240 = (  58,  14,  105)
 EQUB  107              \ Vector 241 = (  54,  15,  107)
 EQUB  109              \ Vector 242 = (  49,  16,  109)
 EQUB  111              \ Vector 243 = (  45,  17,  111)
 EQUB  113              \ Vector 244 = (  40,  18,  113)
 EQUB  115              \ Vector 245 = (  36,  18,  115)
 EQUB  116              \ Vector 246 = (  31,  19,  116)
 EQUB  117              \ Vector 247 = (  26,  20,  117)
 EQUB  118              \ Vector 248 = (  22,  17,  118)
 EQUB  119              \ Vector 249 = (  17,  13,  119)
 EQUB  119              \ Vector 250 = (  12,  10,  119)
 EQUB  120              \ Vector 251 = (   8,   7,  120)
 EQUB  120              \ Vector 252 = (   3,   3,  120)
 EQUB  120              \ Vector 253 = (  -2,   0,  120)
 EQUB  120              \ Vector 254 = (  -5,   0,  120)
 EQUB   83              \ Vector 255 = (   0,   0,   83)

\ ******************************************************************************
\
\       Name: xTrackVectorO
\       Type: Variable
\   Category: Track data
\    Summary: Vector x-coordinates from the inside to the outside of the track
\
\ ******************************************************************************

 EQUB  -87              \ Vector   0 = ( -87,   0,   -2)
 EQUB  -87              \ Vector   1 = ( -87,   0,    0)
 EQUB  -87              \ Vector   2 = ( -87,   0,    2)
 EQUB  -87              \ Vector   3 = ( -87,   0,    5)
 EQUB  -87              \ Vector   4 = ( -87,   0,    8)
 EQUB  -87              \ Vector   5 = ( -87,   0,   11)
 EQUB  -86              \ Vector   6 = ( -86,   0,   14)
 EQUB  -86              \ Vector   7 = ( -86,   0,   17)
 EQUB  -85              \ Vector   8 = ( -85,   0,   19)
 EQUB  -85              \ Vector   9 = ( -85,   0,   22)
 EQUB  -84              \ Vector  10 = ( -84,   0,   25)
 EQUB  -83              \ Vector  11 = ( -83,   0,   28)
 EQUB  -82              \ Vector  12 = ( -82,   0,   30)
 EQUB  -81              \ Vector  13 = ( -81,   0,   33)
 EQUB  -80              \ Vector  14 = ( -80,   0,   36)
 EQUB  -78              \ Vector  15 = ( -78,   0,   38)
 EQUB  -72              \ Vector  16 = ( -72,   0,   49)
 EQUB  -65              \ Vector  17 = ( -65,   0,   59)
 EQUB  -56              \ Vector  18 = ( -56,   0,   67)
 EQUB  -46              \ Vector  19 = ( -46,   0,   74)
 EQUB  -35              \ Vector  20 = ( -35,   0,   80)
 EQUB  -23              \ Vector  21 = ( -23,   0,   84)
 EQUB  -31              \ Vector  22 = ( -31,   0,   82)
 EQUB  -39              \ Vector  23 = ( -39,   0,   78)
 EQUB  -46              \ Vector  24 = ( -46,   0,   74)
 EQUB  -53              \ Vector  25 = ( -53,   0,   69)
 EQUB  -59              \ Vector  26 = ( -59,   0,   64)
 EQUB  -65              \ Vector  27 = ( -65,   0,   58)
 EQUB  -70              \ Vector  28 = ( -70,   0,   52)
 EQUB  -75              \ Vector  29 = ( -75,   0,   45)
 EQUB  -79              \ Vector  30 = ( -79,   0,   37)
 EQUB  -82              \ Vector  31 = ( -82,   0,   30)
 EQUB  -85              \ Vector  32 = ( -85,   0,   22)
 EQUB  -86              \ Vector  33 = ( -86,   0,   14)
 EQUB  -83              \ Vector  34 = ( -83,   0,   27)
 EQUB  -78              \ Vector  35 = ( -78,   0,   40)
 EQUB  -70              \ Vector  36 = ( -70,   0,   52)
 EQUB  -61              \ Vector  37 = ( -61,   0,   62)
 EQUB  -58              \ Vector  38 = ( -58,   0,   65)
 EQUB  -56              \ Vector  39 = ( -56,   0,   67)
 EQUB  -53              \ Vector  40 = ( -53,   0,   70)
 EQUB  -50              \ Vector  41 = ( -50,   0,   72)
 EQUB  -46              \ Vector  42 = ( -46,   0,   74)
 EQUB  -43              \ Vector  43 = ( -43,   0,   76)
 EQUB  -40              \ Vector  44 = ( -40,   0,   78)
 EQUB  -36              \ Vector  45 = ( -36,   0,   79)
 EQUB  -33              \ Vector  46 = ( -33,   0,   81)
 EQUB  -29              \ Vector  47 = ( -29,   0,   82)
 EQUB  -26              \ Vector  48 = ( -26,   0,   84)
 EQUB  -22              \ Vector  49 = ( -22,   0,   85)
 EQUB  -18              \ Vector  50 = ( -18,   0,   85)
 EQUB  -15              \ Vector  51 = ( -15,   0,   86)
 EQUB  -11              \ Vector  52 = ( -11,   0,   87)
 EQUB   -7              \ Vector  53 = (  -7,   0,   87)
 EQUB   -3              \ Vector  54 = (  -3,   0,   87)
 EQUB   -3              \ Vector  55 = (  -3,   0,   87)
 EQUB    1              \ Vector  56 = (   1,   0,   87)
 EQUB    6              \ Vector  57 = (   6,   0,   87)
 EQUB   10              \ Vector  58 = (  10,   0,   87)
 EQUB   15              \ Vector  59 = (  15,   0,   86)
 EQUB   20              \ Vector  60 = (  20,   0,   85)
 EQUB   25              \ Vector  61 = (  25,   0,   84)
 EQUB   30              \ Vector  62 = (  30,   0,   82)
 EQUB   34              \ Vector  63 = (  34,   0,   80)
 EQUB   39              \ Vector  64 = (  39,   0,   78)
 EQUB   43              \ Vector  65 = (  43,   0,   76)
 EQUB   47              \ Vector  66 = (  47,   0,   74)
 EQUB   51              \ Vector  67 = (  51,   0,   71)
 EQUB   55              \ Vector  68 = (  55,   0,   68)
 EQUB   59              \ Vector  69 = (  59,   0,   65)
 EQUB   64              \ Vector  70 = (  64,   1,   60)
 EQUB   68              \ Vector  71 = (  68,   3,   54)
 EQUB   72              \ Vector  72 = (  72,   4,   49)
 EQUB   76              \ Vector  73 = (  76,   5,   43)
 EQUB   79              \ Vector  74 = (  79,   7,   37)
 EQUB   82              \ Vector  75 = (  82,   8,   30)
 EQUB   84              \ Vector  76 = (  84,  10,   24)
 EQUB   86              \ Vector  77 = (  86,  11,   17)
 EQUB   87              \ Vector  78 = (  87,  12,   10)
 EQUB   87              \ Vector  79 = (  87,  14,    3)
 EQUB   87              \ Vector  80 = (  87,  14,    3)
 EQUB   87              \ Vector  81 = (  87,  12,    3)
 EQUB   87              \ Vector  82 = (  87,  10,    3)
 EQUB   87              \ Vector  83 = (  87,   8,    3)
 EQUB   87              \ Vector  84 = (  87,   6,    3)
 EQUB   87              \ Vector  85 = (  87,   4,    3)
 EQUB   87              \ Vector  86 = (  87,   2,    3)
 EQUB   87              \ Vector  87 = (  87,   0,    3)
 EQUB   87              \ Vector  88 = (  87,  -2,    3)
 EQUB   87              \ Vector  89 = (  87,  -4,    3)
 EQUB   87              \ Vector  90 = (  87,  -4,    3)
 EQUB   87              \ Vector  91 = (  87,  -4,    6)
 EQUB   87              \ Vector  92 = (  87,  -4,    9)
 EQUB   87              \ Vector  93 = (  87,  -4,   12)
 EQUB   86              \ Vector  94 = (  86,  -4,   15)
 EQUB   85              \ Vector  95 = (  85,  -4,   19)
 EQUB   85              \ Vector  96 = (  85,  -4,   22)
 EQUB   84              \ Vector  97 = (  84,  -4,   25)
 EQUB   83              \ Vector  98 = (  83,  -4,   28)
 EQUB   82              \ Vector  99 = (  82,  -4,   30)
 EQUB   81              \ Vector 100 = (  81,  -4,   33)
 EQUB   79              \ Vector 101 = (  79,  -4,   36)
 EQUB   78              \ Vector 102 = (  78,  -4,   39)
 EQUB   77              \ Vector 103 = (  77,  -4,   42)
 EQUB   75              \ Vector 104 = (  75,  -4,   44)
 EQUB   74              \ Vector 105 = (  74,  -4,   47)
 EQUB   72              \ Vector 106 = (  72,  -4,   50)
 EQUB   72              \ Vector 107 = (  72,  -4,   50)
 EQUB   70              \ Vector 108 = (  70,  -4,   53)
 EQUB   74              \ Vector 109 = (  74,  -3,   46)
 EQUB   78              \ Vector 110 = (  78,  -3,   39)
 EQUB   82              \ Vector 111 = (  82,  -2,   31)
 EQUB   84              \ Vector 112 = (  84,  -2,   24)
 EQUB   86              \ Vector 113 = (  86,  -2,   16)
 EQUB   87              \ Vector 114 = (  87,  -1,    8)
 EQUB   87              \ Vector 115 = (  87,  -1,    0)
 EQUB   87              \ Vector 116 = (  87,   0,   -8)
 EQUB   86              \ Vector 117 = (  86,   0,  -16)
 EQUB   85              \ Vector 118 = (  85,   0,  -21)
 EQUB   83              \ Vector 119 = (  83,   0,  -26)
 EQUB   82              \ Vector 120 = (  82,   0,  -31)
 EQUB   80              \ Vector 121 = (  80,   0,  -36)
 EQUB   77              \ Vector 122 = (  77,   0,  -40)
 EQUB   75              \ Vector 123 = (  75,   0,  -45)
 EQUB   72              \ Vector 124 = (  72,   0,  -49)
 EQUB   69              \ Vector 125 = (  69,   0,  -53)
 EQUB   66              \ Vector 126 = (  66,   0,  -57)
 EQUB   62              \ Vector 127 = (  62,   0,  -61)
 EQUB   58              \ Vector 128 = (  58,   0,  -65)
 EQUB   54              \ Vector 129 = (  54,   0,  -68)
 EQUB   50              \ Vector 130 = (  50,   0,  -71)
 EQUB   46              \ Vector 131 = (  46,   0,  -74)
 EQUB   41              \ Vector 132 = (  41,   0,  -77)
 EQUB   37              \ Vector 133 = (  37,   0,  -79)
 EQUB   32              \ Vector 134 = (  32,   0,  -81)
 EQUB   27              \ Vector 135 = (  27,   0,  -83)
 EQUB   27              \ Vector 136 = (  27,   0,  -83)
 EQUB   31              \ Vector 137 = (  31,   0,  -82)
 EQUB   34              \ Vector 138 = (  34,  -1,  -80)
 EQUB   38              \ Vector 139 = (  38,  -1,  -79)
 EQUB   41              \ Vector 140 = (  41,  -2,  -77)
 EQUB   45              \ Vector 141 = (  45,  -2,  -75)
 EQUB   48              \ Vector 142 = (  48,  -3,  -73)
 EQUB   51              \ Vector 143 = (  51,  -3,  -71)
 EQUB   54              \ Vector 144 = (  54,  -4,  -68)
 EQUB   57              \ Vector 145 = (  57,  -4,  -66)
 EQUB   60              \ Vector 146 = (  60,  -5,  -63)
 EQUB   63              \ Vector 147 = (  63,  -5,  -60)
 EQUB   66              \ Vector 148 = (  66,  -6,  -58)
 EQUB   68              \ Vector 149 = (  68,  -6,  -55)
 EQUB   71              \ Vector 150 = (  71,  -7,  -51)
 EQUB   73              \ Vector 151 = (  73,  -7,  -48)
 EQUB   75              \ Vector 152 = (  75,  -8,  -45)
 EQUB   75              \ Vector 153 = (  75,  -8,  -45)
 EQUB   75              \ Vector 154 = (  75,  -4,  -45)
 EQUB   75              \ Vector 155 = (  75,   0,  -45)
 EQUB   75              \ Vector 156 = (  75,   4,  -45)
 EQUB   75              \ Vector 157 = (  75,   8,  -45)
 EQUB   75              \ Vector 158 = (  75,  11,  -45)
 EQUB   75              \ Vector 159 = (  75,  15,  -45)
 EQUB   75              \ Vector 160 = (  75,  15,  -45)
 EQUB   72              \ Vector 161 = (  72,  15,  -49)
 EQUB   69              \ Vector 162 = (  69,  14,  -53)
 EQUB   66              \ Vector 163 = (  66,  14,  -57)
 EQUB   63              \ Vector 164 = (  63,  13,  -61)
 EQUB   59              \ Vector 165 = (  59,  13,  -64)
 EQUB   56              \ Vector 166 = (  56,  12,  -67)
 EQUB   52              \ Vector 167 = (  52,  12,  -70)
 EQUB   48              \ Vector 168 = (  48,  11,  -73)
 EQUB   43              \ Vector 169 = (  43,  11,  -76)
 EQUB   39              \ Vector 170 = (  39,  10,  -78)
 EQUB   36              \ Vector 171 = (  36,  10,  -79)
 EQUB   34              \ Vector 172 = (  34,   9,  -81)
 EQUB   31              \ Vector 173 = (  31,   9,  -82)
 EQUB   29              \ Vector 174 = (  29,   8,  -83)
 EQUB   26              \ Vector 175 = (  26,   8,  -83)
 EQUB   23              \ Vector 176 = (  23,   7,  -84)
 EQUB   20              \ Vector 177 = (  20,   7,  -85)
 EQUB   17              \ Vector 178 = (  17,   6,  -86)
 EQUB   15              \ Vector 179 = (  15,   6,  -86)
 EQUB   12              \ Vector 180 = (  12,   5,  -87)
 EQUB    9              \ Vector 181 = (   9,   5,  -87)
 EQUB    6              \ Vector 182 = (   6,   5,  -87)
 EQUB    3              \ Vector 183 = (   3,   4,  -87)
 EQUB    0              \ Vector 184 = (   0,   4,  -87)
 EQUB   -2              \ Vector 185 = (  -2,   3,  -87)
 EQUB   -4              \ Vector 186 = (  -4,   3,  -87)
 EQUB   -7              \ Vector 187 = (  -7,   2,  -87)
 EQUB  -10              \ Vector 188 = ( -10,   2,  -87)
 EQUB  -13              \ Vector 189 = ( -13,   1,  -86)
 EQUB  -16              \ Vector 190 = ( -16,   1,  -86)
 EQUB  -19              \ Vector 191 = ( -19,   0,  -85)
 EQUB  -21              \ Vector 192 = ( -21,   0,  -85)
 EQUB  -27              \ Vector 193 = ( -27,  -1,  -83)
 EQUB  -33              \ Vector 194 = ( -33,  -2,  -81)
 EQUB  -39              \ Vector 195 = ( -39,  -2,  -78)
 EQUB  -44              \ Vector 196 = ( -44,  -3,  -75)
 EQUB  -49              \ Vector 197 = ( -49,  -4,  -72)
 EQUB  -54              \ Vector 198 = ( -54,  -5,  -69)
 EQUB  -59              \ Vector 199 = ( -59,  -6,  -65)
 EQUB  -63              \ Vector 200 = ( -63,  -6,  -60)
 EQUB  -63              \ Vector 201 = ( -63,  -6,  -60)
 EQUB  -66              \ Vector 202 = ( -66,  -6,  -57)
 EQUB  -68              \ Vector 203 = ( -68,  -5,  -55)
 EQUB  -71              \ Vector 204 = ( -71,  -5,  -51)
 EQUB  -73              \ Vector 205 = ( -73,  -4,  -48)
 EQUB  -75              \ Vector 206 = ( -75,  -4,  -45)
 EQUB  -77              \ Vector 207 = ( -77,  -3,  -42)
 EQUB  -79              \ Vector 208 = ( -79,  -3,  -38)
 EQUB  -80              \ Vector 209 = ( -80,  -2,  -35)
 EQUB  -82              \ Vector 210 = ( -82,  -2,  -31)
 EQUB  -83              \ Vector 211 = ( -83,  -1,  -28)
 EQUB  -84              \ Vector 212 = ( -84,  -1,  -24)
 EQUB  -85              \ Vector 213 = ( -85,   0,  -20)
 EQUB  -86              \ Vector 214 = ( -86,   0,  -16)
 EQUB  -87              \ Vector 215 = ( -87,   1,  -13)
 EQUB  -87              \ Vector 216 = ( -87,   1,   -9)
 EQUB  -87              \ Vector 217 = ( -87,   2,   -5)
 EQUB  -87              \ Vector 218 = ( -87,   2,   -1)
 EQUB  -87              \ Vector 219 = ( -87,   3,    2)
 EQUB  -87              \ Vector 220 = ( -87,   3,    6)
 EQUB  -87              \ Vector 221 = ( -87,   4,   10)
 EQUB  -86              \ Vector 222 = ( -86,   4,   13)
 EQUB  -86              \ Vector 223 = ( -86,   5,   17)
 EQUB  -85              \ Vector 224 = ( -85,   5,   21)
 EQUB  -84              \ Vector 225 = ( -84,   6,   25)
 EQUB  -83              \ Vector 226 = ( -83,   6,   28)
 EQUB  -81              \ Vector 227 = ( -81,   7,   32)
 EQUB  -80              \ Vector 228 = ( -80,   7,   35)
 EQUB  -78              \ Vector 229 = ( -78,   8,   39)
 EQUB  -76              \ Vector 230 = ( -76,   8,   42)
 EQUB  -74              \ Vector 231 = ( -74,   9,   46)
 EQUB  -72              \ Vector 232 = ( -72,   9,   49)
 EQUB  -70              \ Vector 233 = ( -70,  10,   52)
 EQUB  -68              \ Vector 234 = ( -68,  10,   55)
 EQUB  -68              \ Vector 235 = ( -68,  10,   55)
 EQUB  -70              \ Vector 236 = ( -70,  11,   52)
 EQUB  -72              \ Vector 237 = ( -72,  12,   49)
 EQUB  -74              \ Vector 238 = ( -74,  13,   47)
 EQUB  -76              \ Vector 239 = ( -76,  14,   44)
 EQUB  -77              \ Vector 240 = ( -77,  14,   40)
 EQUB  -79              \ Vector 241 = ( -79,  15,   37)
 EQUB  -80              \ Vector 242 = ( -80,  16,   34)
 EQUB  -82              \ Vector 243 = ( -82,  17,   31)
 EQUB  -83              \ Vector 244 = ( -83,  18,   27)
 EQUB  -84              \ Vector 245 = ( -84,  18,   24)
 EQUB  -85              \ Vector 246 = ( -85,  19,   21)
 EQUB  -86              \ Vector 247 = ( -86,  20,   17)
 EQUB  -86              \ Vector 248 = ( -86,  17,   14)
 EQUB  -87              \ Vector 249 = ( -87,  13,   10)
 EQUB  -87              \ Vector 250 = ( -87,  10,    7)
 EQUB  -87              \ Vector 251 = ( -87,   7,    3)
 EQUB  -87              \ Vector 252 = ( -87,   3,    0)
 EQUB  -87              \ Vector 253 = ( -87,   0,   -3)
 EQUB  -87              \ Vector 254 = ( -87,   0,   -3)
 EQUB  118              \ Vector 255 = ( 118,   0,   50)

\ ******************************************************************************
\
\       Name: zTrackVectorO
\       Type: Variable
\   Category: Track data
\    Summary: Vector z-coordinates from the inside to the outside of the track
\
\ ******************************************************************************

 EQUB   -2              \ Vector   0 = ( -87,   0,   -2)
 EQUB    0              \ Vector   1 = ( -87,   0,    0)
 EQUB    2              \ Vector   2 = ( -87,   0,    2)
 EQUB    5              \ Vector   3 = ( -87,   0,    5)
 EQUB    8              \ Vector   4 = ( -87,   0,    8)
 EQUB   11              \ Vector   5 = ( -87,   0,   11)
 EQUB   14              \ Vector   6 = ( -86,   0,   14)
 EQUB   17              \ Vector   7 = ( -86,   0,   17)
 EQUB   19              \ Vector   8 = ( -85,   0,   19)
 EQUB   22              \ Vector   9 = ( -85,   0,   22)
 EQUB   25              \ Vector  10 = ( -84,   0,   25)
 EQUB   28              \ Vector  11 = ( -83,   0,   28)
 EQUB   30              \ Vector  12 = ( -82,   0,   30)
 EQUB   33              \ Vector  13 = ( -81,   0,   33)
 EQUB   36              \ Vector  14 = ( -80,   0,   36)
 EQUB   38              \ Vector  15 = ( -78,   0,   38)
 EQUB   49              \ Vector  16 = ( -72,   0,   49)
 EQUB   59              \ Vector  17 = ( -65,   0,   59)
 EQUB   67              \ Vector  18 = ( -56,   0,   67)
 EQUB   74              \ Vector  19 = ( -46,   0,   74)
 EQUB   80              \ Vector  20 = ( -35,   0,   80)
 EQUB   84              \ Vector  21 = ( -23,   0,   84)
 EQUB   82              \ Vector  22 = ( -31,   0,   82)
 EQUB   78              \ Vector  23 = ( -39,   0,   78)
 EQUB   74              \ Vector  24 = ( -46,   0,   74)
 EQUB   69              \ Vector  25 = ( -53,   0,   69)
 EQUB   64              \ Vector  26 = ( -59,   0,   64)
 EQUB   58              \ Vector  27 = ( -65,   0,   58)
 EQUB   52              \ Vector  28 = ( -70,   0,   52)
 EQUB   45              \ Vector  29 = ( -75,   0,   45)
 EQUB   37              \ Vector  30 = ( -79,   0,   37)
 EQUB   30              \ Vector  31 = ( -82,   0,   30)
 EQUB   22              \ Vector  32 = ( -85,   0,   22)
 EQUB   14              \ Vector  33 = ( -86,   0,   14)
 EQUB   27              \ Vector  34 = ( -83,   0,   27)
 EQUB   40              \ Vector  35 = ( -78,   0,   40)
 EQUB   52              \ Vector  36 = ( -70,   0,   52)
 EQUB   62              \ Vector  37 = ( -61,   0,   62)
 EQUB   65              \ Vector  38 = ( -58,   0,   65)
 EQUB   67              \ Vector  39 = ( -56,   0,   67)
 EQUB   70              \ Vector  40 = ( -53,   0,   70)
 EQUB   72              \ Vector  41 = ( -50,   0,   72)
 EQUB   74              \ Vector  42 = ( -46,   0,   74)
 EQUB   76              \ Vector  43 = ( -43,   0,   76)
 EQUB   78              \ Vector  44 = ( -40,   0,   78)
 EQUB   79              \ Vector  45 = ( -36,   0,   79)
 EQUB   81              \ Vector  46 = ( -33,   0,   81)
 EQUB   82              \ Vector  47 = ( -29,   0,   82)
 EQUB   84              \ Vector  48 = ( -26,   0,   84)
 EQUB   85              \ Vector  49 = ( -22,   0,   85)
 EQUB   85              \ Vector  50 = ( -18,   0,   85)
 EQUB   86              \ Vector  51 = ( -15,   0,   86)
 EQUB   87              \ Vector  52 = ( -11,   0,   87)
 EQUB   87              \ Vector  53 = (  -7,   0,   87)
 EQUB   87              \ Vector  54 = (  -3,   0,   87)
 EQUB   87              \ Vector  55 = (  -3,   0,   87)
 EQUB   87              \ Vector  56 = (   1,   0,   87)
 EQUB   87              \ Vector  57 = (   6,   0,   87)
 EQUB   87              \ Vector  58 = (  10,   0,   87)
 EQUB   86              \ Vector  59 = (  15,   0,   86)
 EQUB   85              \ Vector  60 = (  20,   0,   85)
 EQUB   84              \ Vector  61 = (  25,   0,   84)
 EQUB   82              \ Vector  62 = (  30,   0,   82)
 EQUB   80              \ Vector  63 = (  34,   0,   80)
 EQUB   78              \ Vector  64 = (  39,   0,   78)
 EQUB   76              \ Vector  65 = (  43,   0,   76)
 EQUB   74              \ Vector  66 = (  47,   0,   74)
 EQUB   71              \ Vector  67 = (  51,   0,   71)
 EQUB   68              \ Vector  68 = (  55,   0,   68)
 EQUB   65              \ Vector  69 = (  59,   0,   65)
 EQUB   60              \ Vector  70 = (  64,   1,   60)
 EQUB   54              \ Vector  71 = (  68,   3,   54)
 EQUB   49              \ Vector  72 = (  72,   4,   49)
 EQUB   43              \ Vector  73 = (  76,   5,   43)
 EQUB   37              \ Vector  74 = (  79,   7,   37)
 EQUB   30              \ Vector  75 = (  82,   8,   30)
 EQUB   24              \ Vector  76 = (  84,  10,   24)
 EQUB   17              \ Vector  77 = (  86,  11,   17)
 EQUB   10              \ Vector  78 = (  87,  12,   10)
 EQUB    3              \ Vector  79 = (  87,  14,    3)
 EQUB    3              \ Vector  80 = (  87,  14,    3)
 EQUB    3              \ Vector  81 = (  87,  12,    3)
 EQUB    3              \ Vector  82 = (  87,  10,    3)
 EQUB    3              \ Vector  83 = (  87,   8,    3)
 EQUB    3              \ Vector  84 = (  87,   6,    3)
 EQUB    3              \ Vector  85 = (  87,   4,    3)
 EQUB    3              \ Vector  86 = (  87,   2,    3)
 EQUB    3              \ Vector  87 = (  87,   0,    3)
 EQUB    3              \ Vector  88 = (  87,  -2,    3)
 EQUB    3              \ Vector  89 = (  87,  -4,    3)
 EQUB    3              \ Vector  90 = (  87,  -4,    3)
 EQUB    6              \ Vector  91 = (  87,  -4,    6)
 EQUB    9              \ Vector  92 = (  87,  -4,    9)
 EQUB   12              \ Vector  93 = (  87,  -4,   12)
 EQUB   15              \ Vector  94 = (  86,  -4,   15)
 EQUB   19              \ Vector  95 = (  85,  -4,   19)
 EQUB   22              \ Vector  96 = (  85,  -4,   22)
 EQUB   25              \ Vector  97 = (  84,  -4,   25)
 EQUB   28              \ Vector  98 = (  83,  -4,   28)
 EQUB   30              \ Vector  99 = (  82,  -4,   30)
 EQUB   33              \ Vector 100 = (  81,  -4,   33)
 EQUB   36              \ Vector 101 = (  79,  -4,   36)
 EQUB   39              \ Vector 102 = (  78,  -4,   39)
 EQUB   42              \ Vector 103 = (  77,  -4,   42)
 EQUB   44              \ Vector 104 = (  75,  -4,   44)
 EQUB   47              \ Vector 105 = (  74,  -4,   47)
 EQUB   50              \ Vector 106 = (  72,  -4,   50)
 EQUB   50              \ Vector 107 = (  72,  -4,   50)
 EQUB   53              \ Vector 108 = (  70,  -4,   53)
 EQUB   46              \ Vector 109 = (  74,  -3,   46)
 EQUB   39              \ Vector 110 = (  78,  -3,   39)
 EQUB   31              \ Vector 111 = (  82,  -2,   31)
 EQUB   24              \ Vector 112 = (  84,  -2,   24)
 EQUB   16              \ Vector 113 = (  86,  -2,   16)
 EQUB    8              \ Vector 114 = (  87,  -1,    8)
 EQUB    0              \ Vector 115 = (  87,  -1,    0)
 EQUB   -8              \ Vector 116 = (  87,   0,   -8)
 EQUB  -16              \ Vector 117 = (  86,   0,  -16)
 EQUB  -21              \ Vector 118 = (  85,   0,  -21)
 EQUB  -26              \ Vector 119 = (  83,   0,  -26)
 EQUB  -31              \ Vector 120 = (  82,   0,  -31)
 EQUB  -36              \ Vector 121 = (  80,   0,  -36)
 EQUB  -40              \ Vector 122 = (  77,   0,  -40)
 EQUB  -45              \ Vector 123 = (  75,   0,  -45)
 EQUB  -49              \ Vector 124 = (  72,   0,  -49)
 EQUB  -53              \ Vector 125 = (  69,   0,  -53)
 EQUB  -57              \ Vector 126 = (  66,   0,  -57)
 EQUB  -61              \ Vector 127 = (  62,   0,  -61)
 EQUB  -65              \ Vector 128 = (  58,   0,  -65)
 EQUB  -68              \ Vector 129 = (  54,   0,  -68)
 EQUB  -71              \ Vector 130 = (  50,   0,  -71)
 EQUB  -74              \ Vector 131 = (  46,   0,  -74)
 EQUB  -77              \ Vector 132 = (  41,   0,  -77)
 EQUB  -79              \ Vector 133 = (  37,   0,  -79)
 EQUB  -81              \ Vector 134 = (  32,   0,  -81)
 EQUB  -83              \ Vector 135 = (  27,   0,  -83)
 EQUB  -83              \ Vector 136 = (  27,   0,  -83)
 EQUB  -82              \ Vector 137 = (  31,   0,  -82)
 EQUB  -80              \ Vector 138 = (  34,  -1,  -80)
 EQUB  -79              \ Vector 139 = (  38,  -1,  -79)
 EQUB  -77              \ Vector 140 = (  41,  -2,  -77)
 EQUB  -75              \ Vector 141 = (  45,  -2,  -75)
 EQUB  -73              \ Vector 142 = (  48,  -3,  -73)
 EQUB  -71              \ Vector 143 = (  51,  -3,  -71)
 EQUB  -68              \ Vector 144 = (  54,  -4,  -68)
 EQUB  -66              \ Vector 145 = (  57,  -4,  -66)
 EQUB  -63              \ Vector 146 = (  60,  -5,  -63)
 EQUB  -60              \ Vector 147 = (  63,  -5,  -60)
 EQUB  -58              \ Vector 148 = (  66,  -6,  -58)
 EQUB  -55              \ Vector 149 = (  68,  -6,  -55)
 EQUB  -51              \ Vector 150 = (  71,  -7,  -51)
 EQUB  -48              \ Vector 151 = (  73,  -7,  -48)
 EQUB  -45              \ Vector 152 = (  75,  -8,  -45)
 EQUB  -45              \ Vector 153 = (  75,  -8,  -45)
 EQUB  -45              \ Vector 154 = (  75,  -4,  -45)
 EQUB  -45              \ Vector 155 = (  75,   0,  -45)
 EQUB  -45              \ Vector 156 = (  75,   4,  -45)
 EQUB  -45              \ Vector 157 = (  75,   8,  -45)
 EQUB  -45              \ Vector 158 = (  75,  11,  -45)
 EQUB  -45              \ Vector 159 = (  75,  15,  -45)
 EQUB  -45              \ Vector 160 = (  75,  15,  -45)
 EQUB  -49              \ Vector 161 = (  72,  15,  -49)
 EQUB  -53              \ Vector 162 = (  69,  14,  -53)
 EQUB  -57              \ Vector 163 = (  66,  14,  -57)
 EQUB  -61              \ Vector 164 = (  63,  13,  -61)
 EQUB  -64              \ Vector 165 = (  59,  13,  -64)
 EQUB  -67              \ Vector 166 = (  56,  12,  -67)
 EQUB  -70              \ Vector 167 = (  52,  12,  -70)
 EQUB  -73              \ Vector 168 = (  48,  11,  -73)
 EQUB  -76              \ Vector 169 = (  43,  11,  -76)
 EQUB  -78              \ Vector 170 = (  39,  10,  -78)
 EQUB  -79              \ Vector 171 = (  36,  10,  -79)
 EQUB  -81              \ Vector 172 = (  34,   9,  -81)
 EQUB  -82              \ Vector 173 = (  31,   9,  -82)
 EQUB  -83              \ Vector 174 = (  29,   8,  -83)
 EQUB  -83              \ Vector 175 = (  26,   8,  -83)
 EQUB  -84              \ Vector 176 = (  23,   7,  -84)
 EQUB  -85              \ Vector 177 = (  20,   7,  -85)
 EQUB  -86              \ Vector 178 = (  17,   6,  -86)
 EQUB  -86              \ Vector 179 = (  15,   6,  -86)
 EQUB  -87              \ Vector 180 = (  12,   5,  -87)
 EQUB  -87              \ Vector 181 = (   9,   5,  -87)
 EQUB  -87              \ Vector 182 = (   6,   5,  -87)
 EQUB  -87              \ Vector 183 = (   3,   4,  -87)
 EQUB  -87              \ Vector 184 = (   0,   4,  -87)
 EQUB  -87              \ Vector 185 = (  -2,   3,  -87)
 EQUB  -87              \ Vector 186 = (  -4,   3,  -87)
 EQUB  -87              \ Vector 187 = (  -7,   2,  -87)
 EQUB  -87              \ Vector 188 = ( -10,   2,  -87)
 EQUB  -86              \ Vector 189 = ( -13,   1,  -86)
 EQUB  -86              \ Vector 190 = ( -16,   1,  -86)
 EQUB  -85              \ Vector 191 = ( -19,   0,  -85)
 EQUB  -85              \ Vector 192 = ( -21,   0,  -85)
 EQUB  -83              \ Vector 193 = ( -27,  -1,  -83)
 EQUB  -81              \ Vector 194 = ( -33,  -2,  -81)
 EQUB  -78              \ Vector 195 = ( -39,  -2,  -78)
 EQUB  -75              \ Vector 196 = ( -44,  -3,  -75)
 EQUB  -72              \ Vector 197 = ( -49,  -4,  -72)
 EQUB  -69              \ Vector 198 = ( -54,  -5,  -69)
 EQUB  -65              \ Vector 199 = ( -59,  -6,  -65)
 EQUB  -60              \ Vector 200 = ( -63,  -6,  -60)
 EQUB  -60              \ Vector 201 = ( -63,  -6,  -60)
 EQUB  -57              \ Vector 202 = ( -66,  -6,  -57)
 EQUB  -55              \ Vector 203 = ( -68,  -5,  -55)
 EQUB  -51              \ Vector 204 = ( -71,  -5,  -51)
 EQUB  -48              \ Vector 205 = ( -73,  -4,  -48)
 EQUB  -45              \ Vector 206 = ( -75,  -4,  -45)
 EQUB  -42              \ Vector 207 = ( -77,  -3,  -42)
 EQUB  -38              \ Vector 208 = ( -79,  -3,  -38)
 EQUB  -35              \ Vector 209 = ( -80,  -2,  -35)
 EQUB  -31              \ Vector 210 = ( -82,  -2,  -31)
 EQUB  -28              \ Vector 211 = ( -83,  -1,  -28)
 EQUB  -24              \ Vector 212 = ( -84,  -1,  -24)
 EQUB  -20              \ Vector 213 = ( -85,   0,  -20)
 EQUB  -16              \ Vector 214 = ( -86,   0,  -16)
 EQUB  -13              \ Vector 215 = ( -87,   1,  -13)
 EQUB   -9              \ Vector 216 = ( -87,   1,   -9)
 EQUB   -5              \ Vector 217 = ( -87,   2,   -5)
 EQUB   -1              \ Vector 218 = ( -87,   2,   -1)
 EQUB    2              \ Vector 219 = ( -87,   3,    2)
 EQUB    6              \ Vector 220 = ( -87,   3,    6)
 EQUB   10              \ Vector 221 = ( -87,   4,   10)
 EQUB   13              \ Vector 222 = ( -86,   4,   13)
 EQUB   17              \ Vector 223 = ( -86,   5,   17)
 EQUB   21              \ Vector 224 = ( -85,   5,   21)
 EQUB   25              \ Vector 225 = ( -84,   6,   25)
 EQUB   28              \ Vector 226 = ( -83,   6,   28)
 EQUB   32              \ Vector 227 = ( -81,   7,   32)
 EQUB   35              \ Vector 228 = ( -80,   7,   35)
 EQUB   39              \ Vector 229 = ( -78,   8,   39)
 EQUB   42              \ Vector 230 = ( -76,   8,   42)
 EQUB   46              \ Vector 231 = ( -74,   9,   46)
 EQUB   49              \ Vector 232 = ( -72,   9,   49)
 EQUB   52              \ Vector 233 = ( -70,  10,   52)
 EQUB   55              \ Vector 234 = ( -68,  10,   55)
 EQUB   55              \ Vector 235 = ( -68,  10,   55)
 EQUB   52              \ Vector 236 = ( -70,  11,   52)
 EQUB   49              \ Vector 237 = ( -72,  12,   49)
 EQUB   47              \ Vector 238 = ( -74,  13,   47)
 EQUB   44              \ Vector 239 = ( -76,  14,   44)
 EQUB   40              \ Vector 240 = ( -77,  14,   40)
 EQUB   37              \ Vector 241 = ( -79,  15,   37)
 EQUB   34              \ Vector 242 = ( -80,  16,   34)
 EQUB   31              \ Vector 243 = ( -82,  17,   31)
 EQUB   27              \ Vector 244 = ( -83,  18,   27)
 EQUB   24              \ Vector 245 = ( -84,  18,   24)
 EQUB   21              \ Vector 246 = ( -85,  19,   21)
 EQUB   17              \ Vector 247 = ( -86,  20,   17)
 EQUB   14              \ Vector 248 = ( -86,  17,   14)
 EQUB   10              \ Vector 249 = ( -87,  13,   10)
 EQUB    7              \ Vector 250 = ( -87,  10,    7)
 EQUB    3              \ Vector 251 = ( -87,   7,    3)
 EQUB    0              \ Vector 252 = ( -87,   3,    0)
 EQUB   -3              \ Vector 253 = ( -87,   0,   -3)
 EQUB   -3              \ Vector 254 = ( -87,   0,   -3)
 EQUB   50              \ Vector 255 = ( 118,   0,   50)

\ ******************************************************************************
\
\       Name: Track section data (Part 2 of 2)
\       Type: Variable
\   Category: Track data
\    Summary: Data for the track sections
\
\ ------------------------------------------------------------------------------
\
\ Silverstone consists of the following track sections:
\
\    0   ||   Abbey Curve to Woodcote Corner
\    1   ->   Woodcote Corner (chicane right)
\    2   <-   Woodcote Corner (chicane left)
\    3   ->   Woodcote Corner (chicane right)
\    4   ||   Home Straight
\    5   ->   Copse Corner
\    6   ||   Copse Corner to Maggotts Curve
\    7   {}   Copse Corner to Maggotts Curve
\    8   ||   Copse Corner to Maggotts Curve
\    9   <-   Maggotts Curve
\   10   ||   Maggotts Curve to Becketts Corner
\   11   ||   Maggotts Curve to Becketts Corner
\   12   ->   Becketts Corner
\   13   ||   Becketts Corner to Chapel Curve
\   14   <-   Chapel Curve
\   15   ||   Hangar Straight
\   16   {}   Hangar Straight
\   17   ||   Hangar Straight
\   18   ->   Stowe Corner
\   19   ||   Stowe Corner to Club Corner
\   20   ->   Club Corner
\   21   ||   Club Corner to Abbey Curve
\   22   <-   Abbey Curve
\   23   {}   Abbey Curve to Woodcote Corner
\
\ where:
\
\   || is a straight, with just two vectors defined (start and end)
\   {} is a very gentle curve
\   -> is a right corner
\   <- is a left corner
\
\ This part defines the following aspects of these track sections:
\
\ trackSectionFlag      Various flags for the track section
\
\                       Bit 0: 0 = straight section (only one track vector)
\                              1 = curved section (multiple track vectors)
\
\                       Bit 1: 0 = 
\                              1 = 
\
\                       Bit 2: 0 = 
\                              1 = 
\
\                       Bit 3: 0 = 
\                              1 = 
\
\                       Bit 4: 0 = 
\                              1 = 
\
\                       Bit 5: 0 = 
\                              1 = 
\
\                       Bit 6: 0 = 
\                              1 = 
\
\                       Bit 7: 0 = 
\                              1 = 
\
\ xTrackSectionILo      Low byte of the start x-coordinate of the inside verge
\                       of each track section
\
\ yTrackSectionILo      Low byte of the start y-coordinate of the inside verge
\                       of each track section
\
\ zTrackSectionILo      Low byte of the start z-coordinate of the inside verge
\                       of each track section
\
\ xTrackSectionOLo      Low byte of the start x-coordinate of the outside verge
\                       of each track section
\
\ trackSectionFrom      The number of the first track vector in each section
\
\ zTrackSectionOLo      Low byte of the start z-coordinate of the outside verge
\                       of each track section
\
\ trackSectionSize      The length of each track section in terms of progress in
\                       objProgressLo
\
\ ******************************************************************************

                        \ Track section 0

 EQUB %00110000         \ trackSectionFlag
 EQUB &20               \ xTrackSectionILo (xTrackSectionI = &D120 = -12000)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80 =   3200)
 EQUB &A0               \ zTrackSectionILo (zTrackSectionI = &0FA0 =   4000)
 EQUB &C0               \ xTrackSectionOLo (xTrackSectionO = &CFC0 = -12352)
 EQUB 00                \ trackSectionFrom
 EQUB &94               \ zTrackSectionOLo (zTrackSectionO = &0F94 =   3988)
 EQUB 99                \ trackSectionSize

                        \ Track section 1

 EQUB %10101101         \ trackSectionFlag
 EQUB &94               \ xTrackSectionILo (xTrackSectionI = &CF94 = -12396)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80 =   3200)
 EQUB &08               \ zTrackSectionILo (zTrackSectionI = &3E08 =  15880)
 EQUB &34               \ xTrackSectionOLo (xTrackSectionO = &CE34 = -12748)
 EQUB 01                \ trackSectionFrom
 EQUB &FC               \ zTrackSectionOLo (zTrackSectionO = &3DFC =  15868)
 EQUB 21                \ trackSectionSize

                        \ Track section 2

 EQUB %00110011         \ trackSectionFlag
 EQUB &25               \ xTrackSectionILo (xTrackSectionI = &D325 = -11483)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80 =   3200)
 EQUB &96               \ zTrackSectionILo (zTrackSectionI = &4696 =  18070)
 EQUB &C5               \ xTrackSectionOLo (xTrackSectionO = &D2C5 = -11579)
 EQUB 22                \ trackSectionFrom
 EQUB &E8               \ zTrackSectionOLo (zTrackSectionO = &47E8 =  18408)
 EQUB 12                \ trackSectionSize

                        \ Track section 3

 EQUB %00101101         \ trackSectionFlag
 EQUB &B2               \ xTrackSectionILo (xTrackSectionI = &D6B2 = -10574)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80 =   3200)
 EQUB &91               \ zTrackSectionILo (zTrackSectionI = &4A91 =  19089)
 EQUB &56               \ xTrackSectionOLo (xTrackSectionO = &D556 = -10922)
 EQUB 34                \ trackSectionFrom
 EQUB &C9               \ zTrackSectionOLo (zTrackSectionO = &4AC9 =  19145)
 EQUB 21                \ trackSectionSize

                        \ Track section 4

 EQUB %00110010         \ trackSectionFlag
 EQUB &AF               \ xTrackSectionILo (xTrackSectionI = &DEAF =  -8529)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80 =   3200)
 EQUB &4F               \ zTrackSectionILo (zTrackSectionI = &4F4F =  20303)
 EQUB &9F               \ xTrackSectionOLo (xTrackSectionO = &DE9F =  -8545)
 EQUB 55                \ trackSectionFrom
 EQUB &AE               \ zTrackSectionOLo (zTrackSectionO = &50AE =  20654)
 EQUB 105               \ trackSectionSize

                        \ Track section 5

 EQUB %10101101         \ trackSectionFlag
 EQUB &E7               \ xTrackSectionILo (xTrackSectionI = &0FE7 =   4071)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80 =   3200)
 EQUB &5C               \ zTrackSectionILo (zTrackSectionI = &515C =  20828)
 EQUB &D7               \ xTrackSectionOLo (xTrackSectionO = &0FD7 =   4055)
 EQUB 56                \ trackSectionFrom
 EQUB &BB               \ zTrackSectionOLo (zTrackSectionO = &52BB =  21179)
 EQUB 24                \ trackSectionSize

                        \ Track section 6

 EQUB %00000010         \ trackSectionFlag
 EQUB &D8               \ xTrackSectionILo (xTrackSectionI = &17D8 =   6104)
 EQUB &CB               \ yTrackSectionILo (yTrackSectionI = &0CCB =   3275)
 EQUB &09               \ zTrackSectionILo (zTrackSectionI = &4B09 =  19209)
 EQUB &37               \ xTrackSectionOLo (xTrackSectionO = &1937 =   6455)
 EQUB 80                \ trackSectionFrom
 EQUB &17               \ zTrackSectionOLo (zTrackSectionO = &4B17 =  19223)
 EQUB 28                \ trackSectionSize

                        \ Track section 7

 EQUB %00000001         \ trackSectionFlag
 EQUB &64               \ xTrackSectionILo (xTrackSectionI = &1864 =   6244)
 EQUB &53               \ yTrackSectionILo (yTrackSectionI = &0E53 =   3667)
 EQUB &E9               \ zTrackSectionILo (zTrackSectionI = &3DE9 =  15849)
 EQUB &C3               \ xTrackSectionOLo (xTrackSectionO = &19C3 =   6595)
 EQUB 81                \ trackSectionFrom
 EQUB &F7               \ zTrackSectionOLo (zTrackSectionO = &3DF7 =  15863)
 EQUB 09                \ trackSectionSize

                        \ Track section 8

 EQUB %00101000         \ trackSectionFlag
 EQUB &91               \ xTrackSectionILo (xTrackSectionI = &1891 =   6289)
 EQUB &77               \ yTrackSectionILo (yTrackSectionI = &0E77 =   3703)
 EQUB &B1               \ zTrackSectionILo (zTrackSectionI = &39B1 =  14769)
 EQUB &F0               \ xTrackSectionOLo (xTrackSectionO = &19F0 =   6640)
 EQUB 90                \ trackSectionFrom
 EQUB &BF               \ zTrackSectionOLo (zTrackSectionO = &39BF =  14783)
 EQUB 54                \ trackSectionSize

                        \ Track section 9

 EQUB %00110011         \ trackSectionFlag
 EQUB &9F               \ xTrackSectionILo (xTrackSectionI = &199F =   6559)
 EQUB &9F               \ yTrackSectionILo (yTrackSectionI = &0D9F =   3487)
 EQUB &61               \ zTrackSectionILo (zTrackSectionI = &2061 =   8289)
 EQUB &FE               \ xTrackSectionOLo (xTrackSectionO = &1AFE =   6910)
 EQUB 91                \ trackSectionFrom
 EQUB &6F               \ zTrackSectionOLo (zTrackSectionO = &206F =   8303)
 EQUB 16                \ trackSectionSize

                        \ Track section 10

 EQUB %00000000         \ trackSectionFlag
 EQUB &FA               \ xTrackSectionILo (xTrackSectionI = &1BFA =   7162)
 EQUB &5F               \ yTrackSectionILo (yTrackSectionI = &0D5F =   3423)
 EQUB &5D               \ zTrackSectionILo (zTrackSectionI = &195D =   6493)
 EQUB &1B               \ xTrackSectionOLo (xTrackSectionO = &1D1B =   7451)
 EQUB 107               \ trackSectionFrom
 EQUB &25               \ zTrackSectionOLo (zTrackSectionO = &1A25 =   6693)
 EQUB 38                \ trackSectionSize

                        \ Track section 11

 EQUB %00110000         \ trackSectionFlag
 EQUB &12               \ xTrackSectionILo (xTrackSectionI = &2612 =   9746)
 EQUB &C7               \ yTrackSectionILo (yTrackSectionI = &0CC7 =   3271)
 EQUB &AB               \ zTrackSectionILo (zTrackSectionI = &0AAB =   2731)
 EQUB &33               \ xTrackSectionOLo (xTrackSectionO = &2733 =  10035)
 EQUB 108               \ trackSectionFrom
 EQUB &73               \ zTrackSectionOLo (zTrackSectionO = &0B73 =   2931)
 EQUB 27                \ trackSectionSize

                        \ Track section 12

 EQUB %10101101         \ trackSectionFlag
 EQUB &C5               \ xTrackSectionILo (xTrackSectionI = &2DC5 =  11717)
 EQUB &5B               \ yTrackSectionILo (yTrackSectionI = &0C5B =   3163)
 EQUB &8B               \ zTrackSectionILo (zTrackSectionI = &008B = 139)
 EQUB &DD               \ xTrackSectionOLo (xTrackSectionO = &2EDD =  11997)
 EQUB 109               \ trackSectionFrom
 EQUB &5F               \ zTrackSectionOLo (zTrackSectionO = &015F = 351)
 EQUB 27                \ trackSectionSize

                        \ Track section 13

 EQUB %00101010         \ trackSectionFlag
 EQUB &65               \ xTrackSectionILo (xTrackSectionI = &2965 =  10597)
 EQUB &4D               \ yTrackSectionILo (yTrackSectionI = &0C4D =   3149)
 EQUB &7E               \ zTrackSectionILo (zTrackSectionI = &F67E =  -2434)
 EQUB &D3               \ xTrackSectionOLo (xTrackSectionO = &29D3 =  10707)
 EQUB 136               \ trackSectionFrom
 EQUB &2F               \ zTrackSectionOLo (zTrackSectionO = &F52F =  -2769)
 EQUB 40                \ trackSectionSize

                        \ Track section 14

 EQUB %00110011         \ trackSectionFlag
 EQUB &95               \ xTrackSectionILo (xTrackSectionI = &1795 =   6037)
 EQUB &4D               \ yTrackSectionILo (yTrackSectionI = &0C4D =   3149)
 EQUB &8E               \ zTrackSectionILo (zTrackSectionI = &F08E =  -3954)
 EQUB &03               \ xTrackSectionOLo (xTrackSectionO = &1803 =   6147)
 EQUB 137               \ trackSectionFrom
 EQUB &3F               \ zTrackSectionOLo (zTrackSectionO = &EF3F =  -4289)
 EQUB 16                \ trackSectionSize

                        \ Track section 15

 EQUB %00000000         \ trackSectionFlag
 EQUB &D8               \ xTrackSectionILo (xTrackSectionI = &11D8 =   4568)
 EQUB &0D               \ yTrackSectionILo (yTrackSectionI = &0C0D =   3085)
 EQUB &FA               \ zTrackSectionILo (zTrackSectionI = &EBFA =  -5126)
 EQUB &05               \ xTrackSectionOLo (xTrackSectionO = &1305 =   4869)
 EQUB 153               \ trackSectionFrom
 EQUB &44               \ zTrackSectionOLo (zTrackSectionO = &EB44 =  -5308)
 EQUB 135               \ trackSectionSize

                        \ Track section 16

 EQUB %00000001         \ trackSectionFlag
 EQUB &26               \ xTrackSectionILo (xTrackSectionI = &F126 =  -3802)
 EQUB &D5               \ yTrackSectionILo (yTrackSectionI = &07D5 =   2005)
 EQUB &A9               \ zTrackSectionILo (zTrackSectionI = &B5A9 = -19031)
 EQUB &53               \ xTrackSectionOLo (xTrackSectionO = &F253 =  -3501)
 EQUB 154               \ trackSectionFrom
 EQUB &F3               \ zTrackSectionOLo (zTrackSectionO = &B4F3 = -19213)
 EQUB 06                \ trackSectionSize

                        \ Track section 17

 EQUB %00110000         \ trackSectionFlag
 EQUB &B2               \ xTrackSectionILo (xTrackSectionI = &EFB2 =  -4174)
 EQUB &F7               \ yTrackSectionILo (yTrackSectionI = &07F7 =   2039)
 EQUB &3F               \ zTrackSectionILo (zTrackSectionI = &B33F = -19649)
 EQUB &DF               \ xTrackSectionOLo (xTrackSectionO = &F0DF =  -3873)
 EQUB 160               \ trackSectionFrom
 EQUB &89               \ zTrackSectionOLo (zTrackSectionO = &B289 = -19831)
 EQUB 28                \ trackSectionSize

                        \ Track section 18

 EQUB %10101101         \ trackSectionFlag
 EQUB &EA               \ xTrackSectionILo (xTrackSectionI = &E8EA =  -5910)
 EQUB &9B               \ yTrackSectionILo (yTrackSectionI = &099B =   2459)
 EQUB &FB               \ zTrackSectionILo (zTrackSectionI = &A7FB = -22533)
 EQUB &17               \ xTrackSectionOLo (xTrackSectionO = &EA17 =  -5609)
 EQUB 161               \ trackSectionFrom
 EQUB &45               \ zTrackSectionOLo (zTrackSectionO = &A745 = -22715)
 EQUB 40                \ trackSectionSize

                        \ Track section 19

 EQUB %00110010         \ trackSectionFlag
 EQUB &49               \ xTrackSectionILo (xTrackSectionI = &D849 = -10167)
 EQUB &64               \ yTrackSectionILo (yTrackSectionI = &0A64 =   2660)
 EQUB &A2               \ zTrackSectionILo (zTrackSectionI = &A5A2 = -23134)
 EQUB &4A               \ xTrackSectionOLo (xTrackSectionO = &D74A = -10422)
 EQUB 201               \ trackSectionFrom
 EQUB &AE               \ zTrackSectionOLo (zTrackSectionO = &A4AE = -23378)
 EQUB 104               \ trackSectionSize

                        \ Track section 20

 EQUB %10101101         \ trackSectionFlag
 EQUB &91               \ xTrackSectionILo (xTrackSectionI = &B691 = -18799)
 EQUB &F4               \ yTrackSectionILo (yTrackSectionI = &07F4 =   2036)
 EQUB &FA               \ zTrackSectionILo (zTrackSectionI = &C8FA = -14086)
 EQUB &92               \ xTrackSectionOLo (xTrackSectionO = &B592 = -19054)
 EQUB 202               \ trackSectionFrom
 EQUB &06               \ zTrackSectionOLo (zTrackSectionO = &C806 = -14330)
 EQUB 33                \ trackSectionSize

                        \ Track section 21

 EQUB %00101010         \ trackSectionFlag
 EQUB &03               \ xTrackSectionILo (xTrackSectionI = &B603 = -18941)
 EQUB &3E               \ yTrackSectionILo (yTrackSectionI = &083E =   2110)
 EQUB &1E               \ zTrackSectionILo (zTrackSectionI = &D71E = -10466)
 EQUB &F2               \ xTrackSectionOLo (xTrackSectionO = &B4F2 = -19214)
 EQUB 235               \ trackSectionFrom
 EQUB &FC               \ zTrackSectionOLo (zTrackSectionO = &D7FC = -10244)
 EQUB 85                \ trackSectionSize

                        \ Track section 22

 EQUB %00110011         \ trackSectionFlag
 EQUB &3F               \ xTrackSectionILo (xTrackSectionI = &CF3F = -12481)
 EQUB &90               \ yTrackSectionILo (yTrackSectionI = &0B90 =   2960)
 EQUB &FF               \ zTrackSectionILo (zTrackSectionI = &F5FF =  -2561)
 EQUB &2E               \ xTrackSectionOLo (xTrackSectionO = &CE2E = -12754)
 EQUB 236               \ trackSectionFrom
 EQUB &DD               \ zTrackSectionOLo (zTrackSectionO = &F6DD =  -2339)
 EQUB 18                \ trackSectionSize

                        \ Track section 23

 EQUB %00000100         \ trackSectionFlag
 EQUB &DE               \ xTrackSectionILo (xTrackSectionI = &D1DE = -11810)
 EQUB &7D               \ yTrackSectionILo (yTrackSectionI = &0C7D =   3197)
 EQUB &D2               \ zTrackSectionILo (zTrackSectionI = &FDD2 =   -558)
 EQUB &7E               \ xTrackSectionOLo (xTrackSectionO = &D07E = -12162)
 EQUB 254               \ trackSectionFrom
 EQUB &C5               \ zTrackSectionOLo (zTrackSectionO = &FDC5 =   -571)
 EQUB 38                \ trackSectionSize

                        \ Same as track section 0

 EQUB %00110000         \ trackSectionFlag
 EQUB &20               \ xTrackSectionILo (xTrackSectionI = &D120 = -12000)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80 =   3200)
 EQUB &A0               \ zTrackSectionILo (zTrackSectionI = &0FA0 =   4000)
 EQUB &C0               \ xTrackSectionOLo (xTrackSectionO = &CFC0 = -12352)
 EQUB 00                \ trackSectionFrom
 EQUB &94               \ zTrackSectionOLo (zTrackSectionO = &0F94 =   3988)
 EQUB 99                \ trackSectionSize

 EQUB &64, &F0          \ These bytes appear to be unused
 EQUB &00, &00
 EQUB &48, &00
 EQUB &50, &52

\ ******************************************************************************
\
\       Name: trackRacingLine
\       Type: Variable
\   Category: Track data
\    Summary: The optimum racing line for each track section
\
\ ------------------------------------------------------------------------------
\
\ These 24 bytes are copied to bestRacingLine by the SetBestRacingLine routine,
\ and are processed on the way.
\
\   * Bit 0 becomes bit 7 of the result
\
\   * Bit 1 clear means the result is multiplied by baseSpeed
\
\ The processed values are shown below.
\
\ ******************************************************************************

 EQUB %00010100         \ 000101 0 0     +5 * baseSpeed    Track section  0
 EQUB %00110011         \ 001100 1 1    -12                Track section  1
 EQUB %01110010         \ 011100 1 0    +28                Track section  2
 EQUB %00111011         \ 001110 1 1    -14                Track section  3
 EQUB %00011000         \ 000110 0 0     +6 * baseSpeed    Track section  4
 EQUB %00110011         \ 001100 1 1    -12                Track section  5
 EQUB %00010101         \ 000101 0 1     -5 * baseSpeed    Track section  6
 EQUB %00010101         \ 000101 0 1     -5 * baseSpeed    Track section  7
 EQUB %00010101         \ 000101 0 1     -5 * baseSpeed    Track section  8
 EQUB %00111100         \ 001111 0 0    +15 * baseSpeed    Track section  9
 EQUB %00011000         \ 000110 0 0     +6 * baseSpeed    Track section 10
 EQUB %00110000         \ 001100 0 0    +12 * baseSpeed    Track section 11
 EQUB %00110011         \ 001100 1 1    -12                Track section 12
 EQUB %00111001         \ 001110 0 1    -14 * baseSpeed    Track section 13
 EQUB %00111000         \ 001110 0 0    +14 * baseSpeed    Track section 14
 EQUB %00010100         \ 000101 0 0     +5 * baseSpeed    Track section 15
 EQUB %00010100         \ 000101 0 0     +5 * baseSpeed    Track section 16
 EQUB %00010100         \ 000101 0 0     +5 * baseSpeed    Track section 17
 EQUB %00110111         \ 001101 1 1    -13                Track section 18
 EQUB %00100000         \ 001000 0 0     +8 * baseSpeed    Track section 19
 EQUB %01011001         \ 010110 0 1    -22 * baseSpeed    Track section 20
 EQUB %00101011         \ 001010 1 1    -10                Track section 21
 EQUB %01010100         \ 010101 0 0    +21 * baseSpeed    Track section 22
 EQUB %00010100         \ 000101 0 0     +5 * baseSpeed    Track section 23
 
 EQUB %00010100         \ Same as track section 0

 EQUB &67               \ This byte appears to be unused

\ ******************************************************************************
\
\       Name: trackSignData
\       Type: Variable
\   Category: Track data
\    Summary: Track sections and object types for 16 road signs
\
\ ------------------------------------------------------------------------------
\
\ Object types and base coordinates for the 16 road signs.
\
\   * Bits 0-2 = Object type of road sign (add 7 to get the type)
\
\   * Bits 3-7 = The track section coordinates to use as the base coordinates
\                for the sign (i.e. we add the track sign vector to this
\                section's start coordinates to get the sign coordinates)
\
\ Note that this simply defines the sign's 3D coordinates. The mapping between
\ track sections and the signs in those sections is defined in each section's
\ trackSectionData byte.
\
\ The last sign in this table is the one we see at the start of practice.
\
\ ******************************************************************************

 EQUB %00000011         \ Sign  0: 00000 011   Type 10   Chicane      Section  0
 EQUB %00010000         \ Sign  1: 00010 000   Type  7   Straight     Section  2
 EQUB %00011001         \ Sign  2: 00011 001   Type  8   Start flag   Section  3
 EQUB %00101100         \ Sign  3: 00101 100   Type 11   Right turn   Section  5
 EQUB %00111000         \ Sign  4: 00111 000   Type  7   Straight     Section  7
 EQUB %01001101         \ Sign  5: 01001 101   Type 12   Left turn    Section  9
 EQUB %01100100         \ Sign  6: 01100 100   Type 11   Right turn   Section 12
 EQUB %01110101         \ Sign  7: 01110 101   Type 12   Left turn    Section 14
 EQUB %01110000         \ Sign  8: 01110 000   Type  7   Straight     Section 14
 EQUB %01110000         \ Sign  9: 01110 000   Type  7   Straight     Section 14
 EQUB %10010100         \ Sign 10: 10010 100   Type 11   Right turn   Section 18
 EQUB %10011000         \ Sign 11: 10011 000   Type  7   Straight     Section 19
 EQUB %10100100         \ Sign 12: 10100 100   Type 11   Right turn   Section 20
 EQUB %10101000         \ Sign 13: 10101 000   Type  7   Straight     Section 21
 EQUB %10110101         \ Sign 14: 10110 101   Type 12   Left turn    Section 22
 EQUB %10111000         \ Sign 15: 10111 000   Type  7   Straight     Section 23

\ ******************************************************************************
\
\       Name: trackSectionCount
\       Type: Variable
\   Category: Track data
\    Summary: The number of track sections * 8
\
\ ******************************************************************************

 EQUB 24 * 8

\ ******************************************************************************
\
\       Name: trackVectorCount
\       Type: Variable
\   Category: Track data
\    Summary: The number of track vectors in the trackVector tables
\
\ ******************************************************************************

 EQUB 255

\ ******************************************************************************
\
\       Name: trackLengthLo
\       Type: Variable
\   Category: Track data
\    Summary: Low byte of the length of the full track (in terms of progress)
\
\ ------------------------------------------------------------------------------
\
\ (objProgressHi objProgressLo) wraps round to 0 when it reaches this figure.
\
\ ******************************************************************************

 EQUB &00               \ (trackLengthHi trackLengthLo) = &0400

\ ******************************************************************************
\
\       Name: trackLengthHi
\       Type: Variable
\   Category: Track data
\    Summary: High byte of the length of the full track (in terms of progress)
\
\ ------------------------------------------------------------------------------
\
\ (objProgressHi objProgressLo) wraps round to 0 when it reaches this figure.
\
\ ******************************************************************************

 EQUB &04               \ (trackLengthHi trackLengthLo) = &0400

\ ******************************************************************************
\
\       Name: trackPracticeLo
\       Type: Variable
\   Category: Track data
\    Summary: Low byte of the starting point for practice laps (in terms of
\             progress)
\
\ ******************************************************************************

 EQUB &4B               \ (trackPracticeHi trackPracticeLo) = &034B

\ ******************************************************************************
\
\       Name: trackPracticeHi
\       Type: Variable
\   Category: Track data
\    Summary: High byte of the starting point for practice laps (in terms of
\             progress)
\
\ ******************************************************************************

 EQUB &03              \ (trackPracticeHi trackPracticeLo) = &034B

\ ******************************************************************************
\
\       Name: trackLapTimeSec
\       Type: Variable
\   Category: Track data
\    Summary: Lap times for adjusting the race class (seconds)
\
\ ------------------------------------------------------------------------------
\
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we change the race class to the relevant difficulty.
\
\ ******************************************************************************

 EQUB 51                \ Set class to Novice if slowest lap time > 1:51
 EQUB 41                \ Set class to Amateur if slowest lap time > 1:41
 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackLapTimeMin
\       Type: Variable
\   Category: Track data
\    Summary: Lap times for adjusting the race class (minutes)
\
\ ------------------------------------------------------------------------------
\
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we change the race class to the relevant difficulty.
\
\ ******************************************************************************

 EQUB 1                 \ Set class to Novice if slowest lap time > 1:51
 EQUB 1                 \ Set class to Amateur if slowest lap time > 1:41
 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackGearRatio
\       Type: Variable
\   Category: Track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

 EQUB 103               \ Reverse
 EQUB 0                 \ Neutral
 EQUB 103               \ First gear
 EQUB 66                \ Second gear
 EQUB 53                \ Third gear
 EQUB 46                \ Fourth gear
 EQUB 42                \ Fifth gear

\ ******************************************************************************
\
\       Name: trackGearPower
\       Type: Variable
\   Category: Track data
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

 EQUB 161               \ Reverse
 EQUB 0                 \ Neutral
 EQUB 161               \ First gear
 EQUB 104               \ Second gear
 EQUB 82                \ Third gear
 EQUB 72                \ Fourth gear
 EQUB 65                \ Fifth gear

\ ******************************************************************************
\
\       Name: trackBaseSpeed
\       Type: Variable
\   Category: Track data
\    Summary: The base speed for the class, used when generating the best racing
\             lines and individual driver speeds
\
\ ******************************************************************************

 EQUB 134               \ Base speed for Novice
 EQUB 146               \ Base speed for Amateur
 EQUB 152               \ Base speed for Professional

\ ******************************************************************************
\
\       Name: trackStartPosition
\       Type: Variable
\   Category: Track data
\    Summary: The starting position of the player during a practice or
\             qualifying lap
\
\ ******************************************************************************

 EQUB 4

\ ******************************************************************************
\
\       Name: trackCarSpacing
\       Type: Variable
\   Category: Track data
\    Summary: The spacing between cars at the start of a qualifying lap
\
\ ******************************************************************************

 EQUB 40

\ ******************************************************************************
\
\       Name: trackTimerAdjust
\       Type: Variable
\   Category: Track data
\    Summary: Adjust the speed of the timers to allow for fine-tuning on a
\             per-track basis
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

 EQUB 24

\ ******************************************************************************
\
\       Name: trackRaceSlowdown
\       Type: Variable
\   Category: Track data
\    Summary: Slowdown factor for non-player cars in the race
\
\ ------------------------------------------------------------------------------
\
\ Reduce the speed of all cars in a race by this amount (this does not affect
\ the speed during qualifying). I suspect this is used for testing purposes.
\
\ ******************************************************************************

 EQUB 0

 EQUB &73, &6F          \ These bytes appear to be unused
 EQUB &31, &00
 EQUB &8C, &00
 EQUB &00

\ ******************************************************************************
\
\       Name: CallTrackHook
\       Type: Variable
\   Category: Track data
\    Summary: The track file's hook code
\
\ ******************************************************************************

.CallTrackHook

 RTS                    \ This code gets copied to the CallTrackHook routine in
 NOP                    \ the main game code, and gets called when the game is
 NOP                    \ starting up
                        \
                        \ In this track, the hook code does nothing

\ ******************************************************************************
\
\       Name: trackChecksum
\       Type: Variable
\   Category: Track data
\    Summary: The track file's checksum
\
\ ******************************************************************************

.trackChecksum

 EQUB &49               \ Counts the number of data bytes ending in %00

 EQUB &8B               \ Counts the number of data bytes ending in %01

 EQUB &8A               \ Counts the number of data bytes ending in %10
 
 EQUB &C7               \ Counts the number of data bytes ending in %11

 EQUS "REVS"            \ Game name

 EQUS "Silverstone"     \ Track name
 EQUB 13

\ ******************************************************************************
\
\ Save Silverstone.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/Silverstone.bin", CODE%, P%

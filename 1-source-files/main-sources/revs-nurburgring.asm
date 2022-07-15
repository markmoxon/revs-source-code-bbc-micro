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

trackWidth = 154        \ Track width

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

.trackData

\ ******************************************************************************
\
\       Name: Track section data (Part 1 of 2)
\       Type: Variable
\   Category: Extra track data
\    Summary: Data for the track sections
\  Deep dive: The track data file format
\
\ ------------------------------------------------------------------------------
\
\ This part defines the following aspects of these track sections:
\
\ trackSectionData      Various data for the track section:
\
\                         * Bits 0-2: Size of the track section list
\
\                           Defines the number of entries that we store in the
\                           track section list for this section, which is used
\                           to calculate the coordinates of the track verges
\                           (higher numbers mean more sections are calculated,
\                           so higher numbers are used for more complex parts
\                           of the track)
\
\                           This value is given in the bottom nibble of the
\                           track section data byte (bit 3 is ignored), i.e. the
\                           second digit in the hexadecimal value
\
\                         * Bits 4-7: Sign number
\
\                           The number of the road sign (0 to 15) to show when
\                           we enter this section, but only if the sign number
\                           is different to the number in the previous section
\
\                           This value is given in the top nibble of the track
\                           section data byte, i.e. the first digit in the
\                           hexadecimal value
\
\ xTrackSectionIHi      High byte of the x-coordinate of the starting point of
\                       the inner verge of each track section
\
\ yTrackSectionIHi      High byte of the y-coordinate of the starting point of
\                       the inner verge of each track section
\
\ zTrackSectionIHi      High byte of the z-coordinate of the starting point of
\                       the inner verge of each track section
\
\ xTrackSectionOHi      High byte of the x-coordinate of the starting point of
\                       the outside verge of each track section
\
\ trackSectionTurn      The number of the segment towards the end of the section
\                       where non-player cars should start turning in
\                       preparation for the next section
\
\ zTrackSectionOHi      High byte of the z-coordinate of the starting point of
\                       the outside verge of each track section
\
\ trackDriverSpeed      The maximum speed for non-player drivers on this section
\                       of the track
\
\ ******************************************************************************

                        \ Track section 0

 EQUB &01               \ trackSectionData       sign = 0, sectionListSize = 1
 EQUB &2E               \ xTrackSectionIHi       xTrackSectionI = &2EE0 =  12000
 EQUB &1F               \ yTrackSectionIHi       yTrackSectionI = &1F40 =   8000
 EQUB &00               \ zTrackSectionIHi       zTrackSectionI = &0000 = 0
 EQUB &2D               \ xTrackSectionOHi       xTrackSectionO = &2DBF =  11711
 EQUB 255               \ trackSectionTurn
 EQUB &00               \ zTrackSectionOHi       zTrackSectionO = &0000 = 0
 EQUB 255               \ trackDriverSpeed

                        \ Track section 1

 EQUB &13               \ trackSectionData       sign = 1, sectionListSize = 3
 EQUB &2E               \ xTrackSectionIHi       xTrackSectionI = &2EE0 =  12000
 EQUB &1D               \ yTrackSectionIHi       yTrackSectionI = &1D4E =   7502
 EQUB &26               \ zTrackSectionIHi       zTrackSectionI = &26E8 =   9960
 EQUB &2D               \ xTrackSectionOHi       xTrackSectionO = &2DBF =  11711
 EQUB 77                \ trackSectionTurn
 EQUB &26               \ zTrackSectionOHi       zTrackSectionO = &26E8 =   9960
 EQUB 146               \ trackDriverSpeed

                        \ Track section 2

 EQUB &22               \ trackSectionData       sign = 2, sectionListSize = 2
 EQUB &2E               \ xTrackSectionIHi       xTrackSectionI = &2EE0 =  12000
 EQUB &18               \ yTrackSectionIHi       yTrackSectionI = &1875 =   6261
 EQUB &4E               \ zTrackSectionIHi       zTrackSectionI = &4E48 =  20040
 EQUB &2D               \ xTrackSectionOHi       xTrackSectionO = &2DBF =  11711
 EQUB 14                \ trackSectionTurn
 EQUB &4E               \ zTrackSectionOHi       zTrackSectionO = &4E48 =  20040
 EQUB 7                 \ trackDriverSpeed

                        \ Track section 3

 EQUB &32               \ trackSectionData       sign = 3, sectionListSize = 2
 EQUB &31               \ xTrackSectionIHi       xTrackSectionI = &31E8 =  12776
 EQUB &17               \ yTrackSectionIHi       yTrackSectionI = &1779 =   6009
 EQUB &50               \ zTrackSectionIHi       zTrackSectionI = &50AB =  20651
 EQUB &31               \ xTrackSectionOHi       xTrackSectionO = &31A9 =  12713
 EQUB 45                \ trackSectionTurn
 EQUB &51               \ zTrackSectionOHi       zTrackSectionO = &51C4 =  20932
 EQUB 34                \ trackDriverSpeed

                        \ Track section 4

 EQUB &41               \ trackSectionData       sign = 4, sectionListSize = 1
 EQUB &35               \ xTrackSectionIHi       xTrackSectionI = &3579 =  13689
 EQUB &13               \ yTrackSectionIHi       yTrackSectionI = &1389 =   5001
 EQUB &5F               \ zTrackSectionIHi       zTrackSectionI = &5F34 =  24372
 EQUB &34               \ xTrackSectionOHi       xTrackSectionO = &3477 =  13431
 EQUB 255               \ trackSectionTurn
 EQUB &5E               \ zTrackSectionOHi       zTrackSectionO = &5EB2 =  24242
 EQUB 255               \ trackDriverSpeed

                        \ Track section 5

 EQUB &53               \ trackSectionData       sign = 5, sectionListSize = 3
 EQUB &2B               \ xTrackSectionIHi       xTrackSectionI = &2BFB =  11259
 EQUB &11               \ yTrackSectionIHi       yTrackSectionI = &1190 =   4496
 EQUB &72               \ zTrackSectionIHi       zTrackSectionI = &7203 =  29187
 EQUB &2A               \ xTrackSectionOHi       xTrackSectionO = &2AF9 =  11001
 EQUB 16                \ trackSectionTurn
 EQUB &71               \ zTrackSectionOHi       zTrackSectionO = &7181 =  29057
 EQUB 181               \ trackDriverSpeed

                        \ Track section 6

 EQUB &55               \ trackSectionData       sign = 5, sectionListSize = 5
 EQUB &27               \ xTrackSectionIHi       xTrackSectionI = &2757 =  10071
 EQUB &0F               \ yTrackSectionIHi       yTrackSectionI = &0FF6 =   4086
 EQUB &7B               \ zTrackSectionIHi       zTrackSectionI = &7B35 =  31541
 EQUB &26               \ xTrackSectionOHi       xTrackSectionO = &2655 =   9813
 EQUB 31                \ trackSectionTurn
 EQUB &7A               \ zTrackSectionOHi       zTrackSectionO = &7AB3 =  31411
 EQUB 15                \ trackDriverSpeed

                        \ Track section 7

 EQUB &55               \ trackSectionData       sign = 5, sectionListSize = 5
 EQUB &1D               \ xTrackSectionIHi       xTrackSectionI = &1DAB =   7595
 EQUB &0D               \ yTrackSectionIHi       yTrackSectionI = &0D3E =   3390
 EQUB &7E               \ zTrackSectionIHi       zTrackSectionI = &7EC1 =  32449
 EQUB &1E               \ xTrackSectionOHi       xTrackSectionO = &1E0B =   7691
 EQUB 12                \ trackSectionTurn
 EQUB &7D               \ zTrackSectionOHi       zTrackSectionO = &7DB1 =  32177
 EQUB 121               \ trackDriverSpeed

                        \ Track section 8

 EQUB &55               \ trackSectionData       sign = 5, sectionListSize = 5
 EQUB &16               \ xTrackSectionIHi       xTrackSectionI = &169B =   5787
 EQUB &0B               \ yTrackSectionIHi       yTrackSectionI = &0B6E =   2926
 EQUB &7C               \ zTrackSectionIHi       zTrackSectionI = &7C41 =  31809
 EQUB &16               \ xTrackSectionOHi       xTrackSectionO = &16FB =   5883
 EQUB 24                \ trackSectionTurn
 EQUB &7B               \ zTrackSectionOHi       zTrackSectionO = &7B31 =  31537
 EQUB 13                \ trackDriverSpeed

                        \ Track section 9

 EQUB &64               \ trackSectionData       sign = 6, sectionListSize = 4
 EQUB &12               \ xTrackSectionIHi       xTrackSectionI = &1285 =   4741
 EQUB &09               \ yTrackSectionIHi       yTrackSectionI = &099E =   2462
 EQUB &80               \ zTrackSectionIHi       zTrackSectionI = &80C3 = -32573
 EQUB &11               \ xTrackSectionOHi       xTrackSectionO = &1170 =   4464
 EQUB 255               \ trackSectionTurn
 EQUB &81               \ zTrackSectionOHi       zTrackSectionO = &8117 = -32489
 EQUB 255               \ trackDriverSpeed

                        \ Track section 10

 EQUB &63               \ trackSectionData       sign = 6, sectionListSize = 3
 EQUB &15               \ xTrackSectionIHi       xTrackSectionI = &151E =   5406
 EQUB &07               \ yTrackSectionIHi       yTrackSectionI = &0777 =   1911
 EQUB &89               \ zTrackSectionIHi       zTrackSectionI = &894C = -30388
 EQUB &14               \ xTrackSectionOHi       xTrackSectionO = &1409 =   5129
 EQUB 88                \ trackSectionTurn
 EQUB &89               \ zTrackSectionOHi       zTrackSectionO = &89A0 = -30304
 EQUB 112               \ trackDriverSpeed

                        \ Track section 11

 EQUB &73               \ trackSectionData       sign = 7, sectionListSize = 3
 EQUB &14               \ xTrackSectionIHi       xTrackSectionI = &145D =   5213
 EQUB &00               \ yTrackSectionIHi       yTrackSectionI = &00F7 =    247
 EQUB &B2               \ zTrackSectionIHi       zTrackSectionI = &B2D6 = -19754
 EQUB &13               \ xTrackSectionOHi       xTrackSectionO = &1345 =   4933
 EQUB 29                \ trackSectionTurn
 EQUB &B2               \ zTrackSectionOHi       zTrackSectionO = &B289 = -19831
 EQUB 14                \ trackDriverSpeed

                        \ Track section 12

 EQUB &83               \ trackSectionData       sign = 8, sectionListSize = 3
 EQUB &1B               \ xTrackSectionIHi       xTrackSectionI = &1B24 =   6948
 EQUB &03               \ yTrackSectionIHi       yTrackSectionI = &039A =    922
 EQUB &B3               \ zTrackSectionIHi       zTrackSectionI = &B341 = -19647
 EQUB &1C               \ xTrackSectionOHi       xTrackSectionO = &1C44 =   7236
 EQUB 52                \ trackSectionTurn
 EQUB &B3               \ zTrackSectionOHi       zTrackSectionO = &B33E = -19650
 EQUB 255               \ trackDriverSpeed

                        \ Track section 13

 EQUB &93               \ trackSectionData       sign = 9, sectionListSize = 3
 EQUB &1A               \ xTrackSectionIHi       xTrackSectionI = &1AE7 =   6887
 EQUB &0D               \ yTrackSectionIHi       yTrackSectionI = &0DF9 =   3577
 EQUB &96               \ zTrackSectionIHi       zTrackSectionI = &96A9 = -26967
 EQUB &1C               \ xTrackSectionOHi       xTrackSectionO = &1C07 =   7175
 EQUB 37                \ trackSectionTurn
 EQUB &96               \ zTrackSectionOHi       zTrackSectionO = &96A6 = -26970
 EQUB 15                \ trackDriverSpeed

                        \ Track section 14

 EQUB &93               \ trackSectionData       sign = 9, sectionListSize = 3
 EQUB &20               \ xTrackSectionIHi       xTrackSectionI = &20D8 =   8408
 EQUB &14               \ yTrackSectionIHi       yTrackSectionI = &1407 =   5127
 EQUB &8D               \ zTrackSectionIHi       zTrackSectionI = &8D3B = -29381
 EQUB &21               \ xTrackSectionOHi       xTrackSectionO = &215C =   8540
 EQUB 0                 \ trackSectionTurn
 EQUB &8E               \ zTrackSectionOHi       zTrackSectionO = &8E3C = -29124
 EQUB 255               \ trackDriverSpeed

                        \ Track section 15

 EQUB &93               \ trackSectionData       sign = 9, sectionListSize = 3
 EQUB &23               \ xTrackSectionIHi       xTrackSectionI = &235A =   9050
 EQUB &15               \ yTrackSectionIHi       yTrackSectionI = &157B =   5499
 EQUB &8B               \ zTrackSectionIHi       zTrackSectionI = &8BF1 = -29711
 EQUB &23               \ xTrackSectionOHi       xTrackSectionO = &23DE =   9182
 EQUB 33                \ trackSectionTurn
 EQUB &8C               \ zTrackSectionOHi       zTrackSectionO = &8CF2 = -29454
 EQUB 23                \ trackDriverSpeed

                        \ Track section 16

 EQUB &A3               \ trackSectionData       sign = 10, sectionListSize = 3
 EQUB &28               \ xTrackSectionIHi       xTrackSectionI = &281C =  10268
 EQUB &18               \ yTrackSectionIHi       yTrackSectionI = &18A5 =   6309
 EQUB &86               \ zTrackSectionIHi       zTrackSectionI = &86EA = -30998
 EQUB &29               \ xTrackSectionOHi       xTrackSectionO = &291D =  10525
 EQUB 75                \ trackSectionTurn
 EQUB &87               \ zTrackSectionOHi       zTrackSectionO = &876B = -30869
 EQUB 156               \ trackDriverSpeed

                        \ Track section 17

 EQUB &B3               \ trackSectionData       sign = 11, sectionListSize = 3
 EQUB &39               \ xTrackSectionIHi       xTrackSectionI = &3932 =  14642
 EQUB &21               \ yTrackSectionIHi       yTrackSectionI = &2140 =   8512
 EQUB &65               \ zTrackSectionIHi       zTrackSectionI = &650F =  25871
 EQUB &3A               \ xTrackSectionOHi       xTrackSectionO = &3A33 =  14899
 EQUB 27                \ trackSectionTurn
 EQUB &65               \ zTrackSectionOHi       zTrackSectionO = &6590 =  26000
 EQUB 15                \ trackDriverSpeed

                        \ Track section 18

 EQUB &C5               \ trackSectionData       sign = 12, sectionListSize = 5
 EQUB &3F               \ xTrackSectionIHi       xTrackSectionI = &3F4A =  16202
 EQUB &20               \ yTrackSectionIHi       yTrackSectionI = &2041 =   8257
 EQUB &63               \ zTrackSectionIHi       zTrackSectionI = &6306 =  25350
 EQUB &3E               \ xTrackSectionOHi       xTrackSectionO = &3EE4 =  16100
 EQUB 23                \ trackSectionTurn
 EQUB &64               \ zTrackSectionOHi       zTrackSectionO = &6413 =  25619
 EQUB 162               \ trackDriverSpeed

                        \ Track section 19

 EQUB &C4               \ trackSectionData       sign = 12, sectionListSize = 4
 EQUB &4B               \ xTrackSectionIHi       xTrackSectionI = &4B8A =  19338
 EQUB &1E               \ yTrackSectionIHi       yTrackSectionI = &1E65 =   7781
 EQUB &67               \ zTrackSectionIHi       zTrackSectionI = &679E =  26526
 EQUB &4B               \ xTrackSectionOHi       xTrackSectionO = &4B24 =  19236
 EQUB 32                \ trackSectionTurn
 EQUB &68               \ zTrackSectionOHi       zTrackSectionO = &68AB =  26795
 EQUB 18                \ trackDriverSpeed

                        \ Track section 20

 EQUB &D3               \ trackSectionData       sign = 13, sectionListSize = 3
 EQUB &52               \ xTrackSectionIHi       xTrackSectionI = &52E5 =  21221
 EQUB &1B               \ yTrackSectionIHi       yTrackSectionI = &1BF2 =   7154
 EQUB &62               \ zTrackSectionIHi       zTrackSectionI = &628F =  25231
 EQUB &54               \ xTrackSectionOHi       xTrackSectionO = &5405 =  21509
 EQUB 54                \ trackSectionTurn
 EQUB &62               \ zTrackSectionOHi       zTrackSectionO = &62A7 =  25255
 EQUB 255               \ trackDriverSpeed

                        \ Track section 21

 EQUB &E3               \ trackSectionData       sign = 14, sectionListSize = 3
 EQUB &55               \ xTrackSectionIHi       xTrackSectionI = &5597 =  21911
 EQUB &11               \ yTrackSectionIHi       yTrackSectionI = &115A =   4442
 EQUB &42               \ zTrackSectionIHi       zTrackSectionI = &4237 =  16951
 EQUB &56               \ xTrackSectionOHi       xTrackSectionO = &56B7 =  22199
 EQUB 50                \ trackSectionTurn
 EQUB &42               \ zTrackSectionOHi       zTrackSectionO = &424F =  16975
 EQUB 28                \ trackDriverSpeed

                        \ Track section 22

 EQUB &E2               \ trackSectionData       sign = 14, sectionListSize = 2
 EQUB &53               \ xTrackSectionIHi       xTrackSectionI = &536F =  21359
 EQUB &10               \ yTrackSectionIHi       yTrackSectionI = &10C4 =   4292
 EQUB &39               \ zTrackSectionIHi       zTrackSectionI = &3941 =  14657
 EQUB &54               \ xTrackSectionOHi       xTrackSectionO = &5469 =  21609
 EQUB 71                \ trackSectionTurn
 EQUB &38               \ zTrackSectionOHi       zTrackSectionO = &38B0 =  14512
 EQUB 193               \ trackDriverSpeed

                        \ Track section 23

 EQUB &F3               \ trackSectionData       sign = 15, sectionListSize = 3
 EQUB &40               \ xTrackSectionIHi       xTrackSectionI = &40AF =  16559
 EQUB &18               \ yTrackSectionIHi       yTrackSectionI = &1817 =   6167
 EQUB &18               \ zTrackSectionIHi       zTrackSectionI = &18C1 =   6337
 EQUB &41               \ xTrackSectionOHi       xTrackSectionO = &41A9 =  16809
 EQUB 19                \ trackSectionTurn
 EQUB &18               \ zTrackSectionOHi       zTrackSectionO = &1830 =   6192
 EQUB 7                 \ trackDriverSpeed

                        \ Track section 24

 EQUB &F3               \ trackSectionData       sign = 15, sectionListSize = 3
 EQUB &40               \ xTrackSectionIHi       xTrackSectionI = &40BC =  16572
 EQUB &1A               \ yTrackSectionIHi       yTrackSectionI = &1A7B =   6779
 EQUB &13               \ zTrackSectionIHi       zTrackSectionI = &135C =   4956
 EQUB &41               \ xTrackSectionOHi       xTrackSectionO = &41BD =  16829
 EQUB 39                \ trackSectionTurn
 EQUB &13               \ zTrackSectionOHi       zTrackSectionO = &13DD =   5085
 EQUB 36                \ trackDriverSpeed

                        \ Track section 25

 EQUB &F3               \ trackSectionData       sign = 15, sectionListSize = 3
 EQUB &3E               \ xTrackSectionIHi       xTrackSectionI = &3E48 =  15944
 EQUB &1E               \ yTrackSectionIHi       yTrackSectionI = &1E17 =   7703
 EQUB &08               \ zTrackSectionIHi       zTrackSectionI = &08C0 =   2240
 EQUB &3F               \ xTrackSectionOHi       xTrackSectionO = &3F3D =  16189
 EQUB 26                \ trackSectionTurn
 EQUB &08               \ zTrackSectionOHi       zTrackSectionO = &0828 =   2088
 EQUB 127               \ trackDriverSpeed

                        \ Track section 26

 EQUB &F3               \ trackSectionData       sign = 15, sectionListSize = 3
 EQUB &37               \ xTrackSectionIHi       xTrackSectionI = &3725 =  14117
 EQUB &1F               \ yTrackSectionIHi       yTrackSectionI = &1F73 =   8051
 EQUB &FD               \ zTrackSectionIHi       zTrackSectionI = &FD32 =   -718
 EQUB &38               \ xTrackSectionOHi       xTrackSectionO = &381A =  14362
 EQUB 31                \ trackSectionTurn
 EQUB &FC               \ zTrackSectionOHi       zTrackSectionO = &FC9A =   -870
 EQUB 16                \ trackDriverSpeed

 EQUB &30, &30          \ These bytes appear to be unused
 EQUB &0D, &21
 EQUB &E8, &FF
 EQUB &20, &FF

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
\       Name: subSection
\       Type: Variable
\   Category: Extra track data
\    Summary: The number of the current sub-section
\
\ ******************************************************************************

.subSection

 EQUB &EC

\ ******************************************************************************
\
\       Name: trackSubCount
\       Type: Variable
\   Category: Extra track data
\    Summary: The total number of sub-sections in the track
\
\ ******************************************************************************

.trackSubCount

 EQUB 45

\ ******************************************************************************
\
\       Name: yawAngleLo
\       Type: Variable
\   Category: Extra track data
\    Summary: Low byte of the current yaw angle of the track, i.e. the angle at
\             which the track is pointing along the ground
\
\ ******************************************************************************

.yawAngleLo

 EQUB &16

\ ******************************************************************************
\
\       Name: yawAngleHi
\       Type: Variable
\   Category: Extra track data
\    Summary: High byte of the current yaw angle of the track, i.e. the angle at
\             which the track is pointing along the ground
\
\ ******************************************************************************

.yawAngleHi

 EQUB &04

\ ******************************************************************************
\
\       Name: heightOfTrack
\       Type: Variable
\   Category: Extra track data
\    Summary: The height above ground of the current track sub-section
\
\ ******************************************************************************

.heightOfTrack

 EQUB &F0

\ ******************************************************************************
\
\       Name: subSectionSegment
\       Type: Variable
\   Category: Extra track data
\    Summary: The number of the segment within the current sub-section, counting
\             from the start of the sub-section
\
\ ******************************************************************************

.subSectionSegment

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

 EQUB &33, &3C          \ These bytes pad the block out to exactly 20 bytes
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

 EQUB &2E, &3F          \ These bytes pad the block out to exactly 20 bytes
 EQUB &4F, &57
 EQUB &5B

\ ******************************************************************************
\
\       Name: trackYawDeltaHi
\       Type: Variable
\   Category: Extra track data
\    Summary: High byte of the change in yaw angle that we apply to each segment
\             in the specified sub-section when building the track
\
\ ******************************************************************************

.trackYawDeltaHi

 EQUB &00               \ Sub-section  0 = &0000 (    0)
 EQUB &00               \ Sub-section  1 = &0000 (    0)
 EQUB &00               \ Sub-section  2 = &0000 (    0)
 EQUB &00               \ Sub-section  3 = &0000 (    0)
 EQUB &07               \ Sub-section  4 = &07E8 ( 2024)
 EQUB &00               \ Sub-section  5 = &0000 (    0)
 EQUB &FD               \ Sub-section  6 = &FD54 ( -684)
 EQUB &FE               \ Sub-section  7 = &FEC6 ( -314)
 EQUB &FE               \ Sub-section  8 = &FEC6 ( -314)
 EQUB &00               \ Sub-section  9 = &0000 (    0)
 EQUB &00               \ Sub-section 10 = &0000 (    0)
 EQUB &00               \ Sub-section 11 = &0000 (    0)
 EQUB &00               \ Sub-section 12 = &0000 (    0)
 EQUB &FD               \ Sub-section 13 = &FD8F ( -625)
 EQUB &05               \ Sub-section 14 = &059E ( 1438)
 EQUB &FF               \ Sub-section 15 = &FFB7 (  -73)
 EQUB &FF               \ Sub-section 16 = &FFB7 (  -73)
 EQUB &00               \ Sub-section 17 = &0000 (    0)
 EQUB &05               \ Sub-section 18 = &0593 ( 1427)
 EQUB &00               \ Sub-section 19 = &0000 (    0)
 EQUB &00               \ Sub-section 20 = &0000 (    0)
 EQUB &FE               \ Sub-section 21 = &FE37 ( -457)
 EQUB &00               \ Sub-section 22 = &0000 (    0)
 EQUB &01               \ Sub-section 23 = &01AD (  429)
 EQUB &00               \ Sub-section 24 = &0000 (    0)
 EQUB &00               \ Sub-section 25 = &0000 (    0)
 EQUB &00               \ Sub-section 26 = &0000 (    0)
 EQUB &00               \ Sub-section 27 = &0000 (    0)
 EQUB &FC               \ Sub-section 28 = &FC09 (-1015)
 EQUB &FC               \ Sub-section 29 = &FC09 (-1015)
 EQUB &00               \ Sub-section 30 = &0000 (    0)
 EQUB &03               \ Sub-section 31 = &0368 (  872)
 EQUB &00               \ Sub-section 32 = &0000 (    0)
 EQUB &00               \ Sub-section 33 = &0000 (    0)
 EQUB &00               \ Sub-section 34 = &0000 (    0)
 EQUB &01               \ Sub-section 35 = &0145 (  325)
 EQUB &00               \ Sub-section 36 = &0000 (    0)
 EQUB &00               \ Sub-section 37 = &0000 (    0)
 EQUB &00               \ Sub-section 38 = &0000 (    0)
 EQUB &FC               \ Sub-section 39 = &FC9B ( -869)
 EQUB &03               \ Sub-section 40 = &039C (  924)
 EQUB &00               \ Sub-section 41 = &00F6 (  246)
 EQUB &00               \ Sub-section 42 = &0000 (    0)
 EQUB &04               \ Sub-section 43 = &0435 ( 1077)
 EQUB &04               \ Sub-section 44 = &0435 ( 1077)

 EQUB &05, &05          \ These bytes appear to be unused
 EQUB &05, &05
 EQUB &05, &05
 EQUB &07, &0B
 EQUB &10, &14
 EQUB &18, &1C
 EQUB &20

\ ******************************************************************************
\
\       Name: trackSignData
\       Type: Variable
\   Category: Track data
\    Summary: Base coordinates and object types for 16 road signs
\  Deep dive: The track data file format
\
\ ******************************************************************************

.trackSignData

 EQUB %00000001         \ Sign  0: 00000 001   Type 8    Start flag   Section  0
 EQUB %00001000         \ Sign  1: 00001 000   Type 7    Straight     Section  1
 EQUB %00010100         \ Sign  2: 00010 100   Type 11   Right turn   Section  2
 EQUB %00100000         \ Sign  3: 00100 000   Type 7    Straight     Section  4
 EQUB %00110101         \ Sign  4: 00110 101   Type 12   Left turn    Section  6
 EQUB %01000100         \ Sign  5: 01000 100   Type 11   Right turn   Section  8
 EQUB %01011011         \ Sign  6: 01011 011   Type 10   Chicane      Section 11
 EQUB %01100000         \ Sign  7: 01100 000   Type 7    Straight     Section 12
 EQUB %01101101         \ Sign  8: 01101 101   Type 12   Left turn    Section 13
 EQUB %01111100         \ Sign  9: 01111 100   Type 11   Right turn   Section 15
 EQUB %10001101         \ Sign 10: 10001 101   Type 12   Left turn    Section 17
 EQUB %10010000         \ Sign 11: 10010 000   Type 7    Straight     Section 18
 EQUB %10011100         \ Sign 12: 10011 100   Type 11   Right turn   Section 19
 EQUB %10101100         \ Sign 13: 10101 100   Type 11   Right turn   Section 21
 EQUB %10110101         \ Sign 14: 10110 101   Type 12   Left turn    Section 22
 EQUB %11010100         \ Sign 15: 11010 100   Type 11   Right turn   Section 26

\ ******************************************************************************
\
\       Name: CalcSegmentVector
\       Type: Subroutine
\   Category: Extra track data
\    Summary: Calculate the segment vector for the current segment
\
\ ------------------------------------------------------------------------------
\
\ This routine calculates the segment vector for the current segment, by
\ converting the direction of the track at this point, which is stored in the
\ yaw angle in (yawAngleHi yawAngleLo), into a direction vector to store in the
\ (xTrackSegmentI yTrackSegmentI zTrackSegmentI) tables in the track data file.
\
\ We also calculate the outer track segment vector (i.e. the vector across the
\ track) and store it in the (xTrackSegmentO yTrackSegmentI zTrackSegmentO)
\ tables in the track data file.
\
\ Note that the track segment vector tables overwrite the modification routines,
\ as those are no longer used, and the main game code still thinks that's where
\ the segment vector tables are stored as part of the track data file (which
\ they are, it's just that they are dynamically generated in the extra track
\ files, rather than being full of static data).
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

.CalcSegmentVector

                        \ This routine calculates the segment vector for the
                        \ current segment within the current sub-section
                        \
                        \ The segment vector contains two vectors:
                        \
                        \   * (xTrackSegmentI yTrackSegmentI zTrackSegmentI) is
                        \     the vector along the inside of the track from the
                        \     previous segment to the current segment
                        \
                        \   * (xTrackSegmentO yTrackSegmentI zTrackSegmentO) is
                        \     the vector from the inner edge of the track to the
                        \     outer edge of the track for the current segment
                        \
                        \ We start by analysing the track's yaw angle to see in
                        \ which direction the track that we're building is
                        \ currently pointing, so we can set the correct signs
                        \ and axes for the segment vector

 LDA yawAngleLo         \ Set A = (yawAngleHi yawAngleLo) << 1
 ASL A                  \
 LDA yawAngleHi         \ Keeping the high byte only and rotating bit 7 into
 ROL A                  \ the C flag

 PHA                    \ Push the high byte in A onto the stack, so the stack
                        \ contains the high byte of yawAngle << 1

 ROL A                  \ Set bits 0-2 of U to bits 5-7 of yawAngleHi (i.e. the
 ROL A                  \ top three bits), so this is equivalent to:
 ROL A                  \
 AND #%00000111         \   U = (yawAngleHi yawAngleLo) DIV 8192
 STA U                  \
                        \ We will use U to work out the direction of the track
                        \ that we are building

                        \ We now work out the index into the xTrackCurve and
                        \ zTrackCurve tables for the curve that matches the
                        \ direction of the track, putting the result in X
                        \
                        \ The curve tables contain coordinates for a curve that
                        \ covers one-eighth of a circle, or 45 degrees, so we
                        \ first reduce the yaw angle into that range by reducing
                        \ our 32-bit angle into this range
                        \
                        \ The 32-bit angle in (yawAngleHi yawAngleLo) cover a
                        \ whole circle, so 0 to 65536 represents 0 to 360
                        \ degrees, so one-eighth of a circle, or 45 degrees, is
                        \ represented by 65536 / 8 = 8192
                        \
                        \ So we reduce the 32-bit value into the range 0 to 8192
                        \ so we can map it to the curve in the curve tables

 LSR A                  \ Set the C flag to bit 0 of A, i.e. bit 5 of yawAngleHi

 PLA                    \ Retrieve the high byte that we pushed onto the stack,
                        \ i.e. the high byte of yawAngle << 1

 AND #%00111111         \ Clear bits 6 and 7 of A, so A now contains two zeroes,
                        \ then bits 4, 3, 2, 1, 0 of yawAngleHi, then bit 7 of
                        \ yawAngleLo

                        \ By this point, we have:
                        \
                        \   X = (yawAngleHi yawAngleLo) MOD 8192
                        \
                        \ This is the corresponding point in the curve tables
                        \ for the track direction, reduced to one-eighth of a
                        \ circle, or 0 to 45 degrees
                        \
                        \ The next eighth of the circle (i.e. from 45 to 90
                        \ degrees) will map to the curve tables, but in reverse,
                        \ so we can extend our calculation to quarter circle by
                        \ flipping the index in X for this range of yaw angle
                        \ (i.e. if we are in the second eighth of the circle,
                        \ from 45 to 90 degrees, which is when bit 5 of the high
                        \ byte is clear)

 BCC vect1              \ If the C flag, i.e. bit 5 of yawAngleHi, is clear,
                        \ jump to vect1 to skip the following

 EOR #%00111111         \ Negate A using two's complement (the ADC adds 1 as the
 ADC #0                 \ C flag is set)

.vect1

                        \ By this point, A contains the index of the curve
                        \ within the curve tables that corresponds to the angle
                        \ in which the track is pointing, reduced to the first
                        \ quarter of a circle (0 to 90 degrees)
                        \
                        \ We can now fetch the vector for that point on the
                        \ curve, which will give us the vector of the curve at
                        \ that point (i.e. the direction of the curve for the
                        \ track segment we are building)

 TAX                    \ Set X = A

 LDY xTrackCurve,X      \ Set Y = X-th entry in xTrackCurve

 LDA zTrackCurve,X      \ Set X = X-th entry in zTrackCurve
 TAX

                        \ The vector in X and Y now contains the correct values
                        \ for the curve vector, but because we reduced it to the
                        \ first quarter in the circle, the signs may not be
                        \ correct, and we may need to swap the x-coordinate and
                        \ z-coordinate
                        \
                        \ We now use the value of U to set the vector properly,
                        \ as the value of U determines which eighth of the
                        \ circle corresponds to the track direction

 LDA U                  \ If bit 1 of U + 1 is set, i.e. U ends in %01 or %10,
 CLC                    \ i.e. bits 5 and 6 of yawAngleHi are different, then
 ADC #1                 \ jump to vect2 to set V and W the other way round
 AND #%00000010
 BNE vect2

 STY V                  \ Set V = Y

 STX W                  \ Set W = X

 BEQ vect3              \ Jump to vect3 (this BEQ is effectively a JMP as we
                        \ passed through a BNE above)

.vect2

 STX V                  \ Set V = X

 STY W                  \ Set W = Y

.vect3

 LDA U                  \ If U < 4, i.e. bit 2 of U is clear, i.e. bit 7 of
 CMP #4                 \ yawAngleHi is clear, jump to vect4 to skip the
 BCC vect4              \ following

                        \ If we get here then bit 2 of U is set, i.e. bit 7 of
                        \ yawAngleHi is set

 LDA #0                 \ Set V = -V
 SBC V
 STA V

.vect4

 LDA U                  \ If U >= 6, i.e. bits 1 and 2 of U are set, i.e. bits
 CMP #6                 \ 6 and 7 of yawAngleHi are set, jump to vect5 to skip
 BCS vect5              \ the following

 CMP #2                 \ If U < 2, i.e. bits 1 and 2 of U are clear, i.e. bits
 BCC vect5              \ 6 and 7 of yawAngleHi are clear, jump to vect5 to skip
                        \ the following

                        \ If we get here then bits 1 and 2 of U are different,
                        \ i.e. bits 6 and 7 of yawAngleHi are different

 LDA #0                 \ Set W = -W
 SBC W
 STA W

.vect5

                        \ By this point we have the x- and z-coordinates of the
                        \ vector for the track direction in the segment that we
                        \ want to build, and we already know the height of the
                        \ track at this point (it's in heightOfTrack)
                        \
                        \ The inner track segment vector at this point is
                        \ therefore:
                        \
                        \   [       V       ]
                        \   [ heightOfTrack ]
                        \   [       W       ]
                        \
                        \ And we can now store the vector in the track data file
                        \ as follows:
                        \
                        \   * xTrackSegmentI = V
                        \   * yTrackSegmentI = heightOfTrack
                        \   * zTrackSegmentI = W
                        \
                        \ We can also calculate the vector from the inner verge
                        \ to the outer verge as follows:
                        \
                        \   * xTrackSegmentO = -W * trackWidth / 256
                        \   * zTrackSegmentO = V * trackWidth / 256
                        \
                        \ This works because given a 2D vector [V W], the vector
                        \ [-W V] is the vector's normal, i.e. the same vector,
                        \ but perpendicular to the original
                        \
                        \ If we take the original inner vector in [V W], then
                        \ its normal vector is a vector that's perpendicular to
                        \ the original, so instead of being a vector pointing
                        \ along the inner edge, it's a vector pointing at 90
                        \ degrees across the track, which is the vector that we
                        \ want to calculate
                        \
                        \ Multiplying the normal vector by the track width sets
                        \ the correct length for the outer segment vector, so
                        \ we could make the track wider by changing the value of
                        \ the trackWidth configuration variable

 LDY thisVectorNumber   \ Set Y to thisVectorNumber, which contains the value of
                        \ trackSectionFrom for this track section (i.e. the
                        \ number of the first segment vector in the section)

 LDA #trackWidth        \ Set U to the width of the track
 STA U

 LDA V                  \ Set the x-coordinate of the Y-th inner track segment
 STA xTrackSegmentI,Y   \ vector to V

 JSR Multiply8x8Signed  \ Set A = A * U / 256
                        \       = V * trackWidth / 256

 STA zTrackSegmentO,Y   \ Set the z-coordinate of the Y-th outer track segment
                        \ vector to V * trackWidth / 256

 LDA W                  \ Set the z-coordinate of the Y-th inner track segment
 STA zTrackSegmentI,Y   \ vector to W

 JSR Multiply8x8Signed  \ Set A = A * U / 256
                        \       = W * trackWidth / 256

 EOR #&FF               \ Negate A using two's complement, so:
 CLC                    \
 ADC #1                 \   A = -W * trackWidth / 256

 STA xTrackSegmentO,Y   \ Set the x-coordinate of the Y-th outer track segment
                        \ vector to -W * trackWidth / 256

 LDA heightOfTrack      \ Set the y-coordinate of the Y-th track segment vector
 STA yTrackSegmentI,Y   \ to the height of the track

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: HookDataPointers
\       Type: Subroutine
\   Category: Extra track data
\    Summary: If bit 6 of the current section's flags is set, update the data
\             pointers
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from part 1 of GetTrackSegment so we update the
\ sub-section and sub-section segment pointers when fetching a new track
\ segment.
\
\ If bit 6 of the current section's flags is set, then the track segment vectors
\ for this section need to be generated from the curve tables (as opposed to
\ being calculated as a straight section). When this is the case, this routine
\ calls UpdateDataPointers to update the pointers to the next sub-section and
\ segment along the track.
\
\ ******************************************************************************

.HookDataPointers

 LDA thisSectionFlags   \ If bit 6 of the current section's flags is clear, jump
 AND #%01000000         \ to flab1 to skip the following call, so we just
 BEQ flab1              \ implement the same code as in the original

 JSR UpdateDataPointers \ Bit 6 of the current section's flags is set, so we are
                        \ generating this section's segment vectors using the
                        \ curve tables, so call UpdateDataPointers to update
                        \ the pointers to the next sub-section and segment along
                        \ the track, before continuing with the same code as in
                        \ the original

.flab1

 LDA frontSegmentIndex  \ Set A to the index * 3 of the front track segment in
                        \ the track segment buffer

 CLC                    \ Set A = frontSegmentIndex + 3
 ADC #3                 \
                        \ to move on to the next track segment ahead of the
                        \ current front segment in the track segment buffer,
                        \ which will become the new front segment

 RTS                    \ Return from the subroutine

 EQUB &0C, &08          \ These bytes appear to be unused
 EQUB &03, &FE
 EQUB &FB, &00

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
\       Name: trackYawDeltaLo
\       Type: Variable
\   Category: Extra track data
\    Summary: Low byte of the change in yaw angle that we apply to each segment
\             in the specified sub-section when building the track
\
\ ******************************************************************************

.trackYawDeltaLo

 EQUB &00               \ Sub-section  0 = &0000 (    0)
 EQUB &00               \ Sub-section  1 = &0000 (    0)
 EQUB &00               \ Sub-section  2 = &0000 (    0)
 EQUB &00               \ Sub-section  3 = &0000 (    0)
 EQUB &E8               \ Sub-section  4 = &07E8 ( 2024)
 EQUB &00               \ Sub-section  5 = &0000 (    0)
 EQUB &54               \ Sub-section  6 = &FD54 ( -684)
 EQUB &C6               \ Sub-section  7 = &FEC6 ( -314)
 EQUB &C6               \ Sub-section  8 = &FEC6 ( -314)
 EQUB &00               \ Sub-section  9 = &0000 (    0)
 EQUB &00               \ Sub-section 10 = &0000 (    0)
 EQUB &00               \ Sub-section 11 = &0000 (    0)
 EQUB &00               \ Sub-section 12 = &0000 (    0)
 EQUB &8F               \ Sub-section 13 = &FD8F ( -625)
 EQUB &9E               \ Sub-section 14 = &059E ( 1438)
 EQUB &B7               \ Sub-section 15 = &FFB7 (  -73)
 EQUB &B7               \ Sub-section 16 = &FFB7 (  -73)
 EQUB &00               \ Sub-section 17 = &0000 (    0)
 EQUB &93               \ Sub-section 18 = &0593 ( 1427)
 EQUB &00               \ Sub-section 19 = &0000 (    0)
 EQUB &00               \ Sub-section 20 = &0000 (    0)
 EQUB &37               \ Sub-section 21 = &FE37 ( -457)
 EQUB &00               \ Sub-section 22 = &0000 (    0)
 EQUB &AD               \ Sub-section 23 = &01AD (  429)
 EQUB &00               \ Sub-section 24 = &0000 (    0)
 EQUB &00               \ Sub-section 25 = &0000 (    0)
 EQUB &00               \ Sub-section 26 = &0000 (    0)
 EQUB &00               \ Sub-section 27 = &0000 (    0)
 EQUB &09               \ Sub-section 28 = &FC09 (-1015)
 EQUB &09               \ Sub-section 29 = &FC09 (-1015)
 EQUB &00               \ Sub-section 30 = &0000 (    0)
 EQUB &68               \ Sub-section 31 = &0368 (  872)
 EQUB &00               \ Sub-section 32 = &0000 (    0)
 EQUB &00               \ Sub-section 33 = &0000 (    0)
 EQUB &00               \ Sub-section 34 = &0000 (    0)
 EQUB &45               \ Sub-section 35 = &0145 (  325)
 EQUB &00               \ Sub-section 36 = &0000 (    0)
 EQUB &00               \ Sub-section 37 = &0000 (    0)
 EQUB &00               \ Sub-section 38 = &0000 (    0)
 EQUB &9B               \ Sub-section 39 = &FC9B ( -869)
 EQUB &9C               \ Sub-section 40 = &039C (  924)
 EQUB &F6               \ Sub-section 41 = &00F6 (  246)
 EQUB &00               \ Sub-section 42 = &0000 (    0)
 EQUB &35               \ Sub-section 43 = &0435 ( 1077)
 EQUB &35               \ Sub-section 44 = &0435 ( 1077)

\ ******************************************************************************
\
\       Name: Hook80Percent
\       Type: Subroutine
\   Category: Extra track data
\    Summary: Set the horizonTrackWidth to 80% of the width of the track on the
\             horizon
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from GetTrackAndMarkers to set the horizonTrackWidth to
\ 80% of the width of the track on the horizon.
\
\ ******************************************************************************

\ EQUB &85, &75, &A9
\ EQUB &CD, &4C, &00, &0C

.Hook80Percent

 STA U                  \ Set U = A

 LDA #205               \ Set A = 205

 JMP Multiply8x8        \ Set (A T) = A * U
                        \           = 205 * A
                        \
                        \ returning from the subroutine using a tail call
                        \
                        \ This calculates the following in A:
                        \
                        \   A = (A T) / 256
                        \     = 205 * A / 256
                        \     = 0.80 * A

\ ******************************************************************************
\
\       Name: Multiply8x8Signed
\       Type: Subroutine
\   Category: Extra track data
\    Summary: Multiply two 8-bit numbers, one of which is signed
\
\ ------------------------------------------------------------------------------
\
\ This routine calculates the following, retaining the sign in A.
\
\   A = A * U / 256
\
\ Specifically, if the last instruction to affect the N flag before the call is
\ an LDA instruction, and A is signed, then set:
\
\   A = |A| * U * abs(A)
\     = A * U / 256
\
\ So this multiplies A and U, retaining the sign in A.
\
\ ******************************************************************************

\ EQUB &08, &4C, &6B, &46

.Multiply8x8Signed

 PHP                    \ Store the N flag on the stack, as set by the LDA just
                        \ before the call, so this equals abs(A)

 JMP MultiplyHeight+11  \ Jump into the MultiplyHeight routine to do this:
                        \
                        \   JSR Absolute8Bit      \ Set A = |A|
                        \
                        \   JSR Multiply8x8       \ Set (A T) = A * U
                        \                         \           = |A| * U
                        \                         \
                        \                         \ So A = |A| * U / 256
                        \
                        \   PLP                   \ Retrieve sign in N, which we
                        \                         \ set to abs(A) above
                        \
                        \   JSR Absolute8Bit      \ Set A = |A| * abs(A)
                        \                         \       = A * U / 256
                        \
                        \   RTS                   \ Return from the subroutine
                        \
                        \ So this sets A = A * U while retaining the sign in A

 EQUB &FC, &FC          \ These bytes appear to be unused

\ ******************************************************************************
\
\       Name: xTrackSignVector
\       Type: Variable
\   Category: Extra track data
\    Summary: The x-coordinate of the track sign vector for each sign, to be
\             scaled and added to the inner track section vector for the sign
\
\ ******************************************************************************

.xTrackSignVector

 EQUB   1               \ Sign  0 = (  1 << 6,  -8 << 4,  72 << 6) + section  0
 EQUB  -6               \ Sign  1 = ( -6 << 6,   6 << 4,  13 << 6) + section  2
 EQUB  -5               \ Sign  2 = ( -5 << 6,  67 << 4, -75 << 6) + section  3
 EQUB   9               \ Sign  3 = (  9 << 6,  35 << 4, -33 << 6) + section  5
 EQUB  28               \ Sign  4 = ( 28 << 6,  39 << 4, -54 << 6) + section  7
 EQUB   6               \ Sign  5 = (  6 << 6,  12 << 4,  -3 << 6) + section  9
 EQUB   9               \ Sign  6 = (  9 << 6,  22 << 4, -73 << 6) + section 12
 EQUB  -2               \ Sign  7 = ( -2 << 6,  -6 << 4,  20 << 6) + section 14
 EQUB   0               \ Sign  8 = (  0 << 6, -90 << 4,  61 << 6) + section 14
 EQUB   3               \ Sign  9 = (  3 << 6,   9 << 4,   4 << 6) + section 14
 EQUB -33               \ Sign 10 = (-33 << 6,  -6 << 4,  64 << 6) + section 18
 EQUB  -5               \ Sign 11 = ( -5 << 6,   8 << 4,  -3 << 6) + section 19
 EQUB  -6               \ Sign 12 = ( -6 << 6,   9 << 4,   3 << 6) + section 20
 EQUB  -1               \ Sign 13 = ( -1 << 6,  93 << 4,  73 << 6) + section 21
 EQUB -39               \ Sign 14 = (-39 << 6,  27 << 4, -66 << 6) + section 22
 EQUB  31               \ Sign 15 = ( 31 << 6, -11 << 4,  41 << 6) + section 23

\ ******************************************************************************
\
\       Name: HookSegmentVector
\       Type: Subroutine
\   Category: Extra track data
\    Summary: If bit 6 of the current section's flags is set, move to the next
\             segment vector, calculate it and store it
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from part 3 of GetTrackSegment and TurnPlayerAround, so
\ we calculate the next track segment vector on-the-fly for curved sections.
\
\ If bit 6 of the current section's flags is set, then the track segment vectors
\ for this section need to be generated from the curve tables (as opposed to
\ being calculated as a straight section). When this is the case, this routine
\ calls UpdateVectorNumber and SetSegmentVector to calculate and store the next
\ track segment vector, which can then be read by the main game code as if it
\ were a static piece of data from a normal track data file.
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

\ &13A1 -> &13E0 = UpdateVectorNumber
\ JSR &13A1 -> JSR UpdateVectorNumber

.HookSegmentVector

 LDA thisSectionFlags   \ If bit 6 of the current section's flags is clear, jump
 AND #%01000000         \ to flag1 to return from the subroutine
 BEQ flag1

                        \ Bit 6 of the current section's flags is set, so we are
                        \ generating this section's segment vectors using the
                        \ curve tables

 JSR UpdateVectorNumber \ Update thisVectorNumber to the next segment vector
                        \ along the track in the direction we are facing (we
                        \ replaced a call to UpdateCurveVector with the call to
                        \ the hook, so this implements that call, knowing that
                        \ this is a curve)

 JSR SetSegmentVector   \ Calculate and store the next segment vector, so it can
                        \ be read by the main game code as if it were a static
                        \ piece of data from a normal track data file

.flag1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: MoveToNextVector
\       Type: Subroutine
\   Category: Extra track data
\    Summary: Move to the next to the next segment vector along the track and
\             update the pointers
\
\ ******************************************************************************

.MoveToNextVector

 JSR UpdateVectorNumber

\ ******************************************************************************
\
\       Name: UpdateDataPointers
\       Type: Subroutine
\   Category: Extra track data
\    Summary: Update the sub-section and segment numbers to point to the next
\             segment along the track in the correct direction
\
\ ******************************************************************************

.UpdateDataPointers

 LDY subSection         \ Set Y to the number of the current sub-section within
                        \ the current track section

 LDA subSectionSegment  \ Set A to the number of the current segment within the
                        \ current sub-section

 SEC                    \ Set the C flag for use in the following addition or
                        \ subtraction

 BIT directionFacing    \ If we are facing backwards along the track, jump to
 BMI upda1              \ upda1 to move to the nect segment in that direction

                        \ If we get here then we are facing forwards along the
                        \ track, so we increment subSectionSegment to point to
                        \ the next segment
                        \
                        \ If subSectionSegment reaches trackSubSize for this
                        \ sub-section, then we have reached the end of that
                        \ sub-section and need to start the next sub-section,
                        \ so we wrap the segment number within the sub-section
                        \ round to zero and increment subSection to move on to
                        \ the next sub-section
                        \
                        \ If subSection then reaches trackSubCount, which is the
                        \ total number of sub-sections in the track, then we
                        \ have reached the end of the last sub-section, so we
                        \ wrap subSection round to zero

 ADC #0                 \ Set A = A + 1
                        \       = subSectionSegment + 1
                        \
                        \ This works as the C flag is set

 CMP trackSubSize,Y     \ If A < trackSubSize for this index, jump to upda3 to
 BCC upda3              \ update the pointers and return from the subroutine

 LDA #0                 \ Set A = 0, to set as the new segment number in
                        \ subSectionSegment within the next sub-section

 INY                    \ Increment Y to point to the next sub-section

 CPY trackSubCount      \ If Y < trackSubCount, jump to upda3 to update the
 BCC upda3              \ pointers and return from the subroutine

 LDY #0                 \ Set Y = 0, to set the new value of subSection to the
                        \ start of the data

 BEQ upda3              \ Jump to upda3 to update the pointers and return from
                        \ the subroutine (this BEQ is effectively a JMP as Y is
                        \ always zero)

.upda1

                        \ If we get here then we are facing backwards along the
                        \ track, so we decrement subSectionSegment to point to
                        \ the previous segment, i.e. backwards along the track
                        \
                        \ If subSectionSegment goes past 0, then we have gone
                        \ past the start of that sub-section and need to jump to
                        \ the end of the previous sub-section, so we wrap the
                        \ segment number within the sub-section to the last
                        \ segment number in the previous sub-section and
                        \ decrement subSection to move back to the previous
                        \ sub-section
                        \
                        \ If subSection reaches 0, which is the start of the
                        \ track, then we wrap it round to the last sub-section
                        \ to go backwards past the start to reach the end of the
                        \ track

 SBC #1                 \ Set A = A - 1
                        \       = subSectionSegment - 1
                        \
                        \ This works as the C flag is set

 BCS upda3              \ If the subtraction didn't underflow, jump to upda3 to
                        \ update the pointers and return from the subroutine

                        \ If we get here, then subSectionSegment has just gone
                        \ past 0, so we need to jump to the end of the previous
                        \ sub-section

 TYA                    \ Clear bit 7 of Y to ensure that Y is positive
 AND #%01111111
 TAY

 CPY #1                 \ If Y >= 1, jump to upda2 as we aren't about to go past
 BCS upda2              \ the start of the first sub-section

                        \ If we get here then Y = 0, so we are in the first
                        \ segment of the first sub-section, so we need to wrap
                        \ the sub-section around to the end of the track

 LDY trackSubCount      \ Set Y = trackSubCount, so we set the new value of
                        \ subSection to trackSubCount - 1, i.e. the last
                        \ sub-section in the track

.upda2

 DEY                    \ Decrement Y to point to the previous sub-section

 LDA trackSubSize,Y     \ Set A to trackSubSize - 1 for this index, which points
 SEC                    \ to the last entry in the new sub-section
 SBC #1

.upda3

 STA subSectionSegment  \ Update the segment number within the sub-section to
                        \ the updated value of A

 STY subSection         \ Update the sub-section to the updated value of Y

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SetSegmentVector
\       Type: Subroutine
\   Category: Extra track data
\    Summary: Add the yaw angle and height deltas to the yaw angle and height
\             (for curved sections) and calculate the segment vector
\
\ ------------------------------------------------------------------------------
\
\ This routine adds the yaw angle and height deltas to the track yaw angle and
\ height, to get the coordinates for the next segment along. It then calls the
\ CalcSegmentVector routine to calculate the segment vectors and store them in
\ the correct tables for the main game code to read.
\
\ If the current sub-section number has bit 7 set, then this section isn't being
\ generated using the curve tables, but is instead being generated as a straight
\ part of the track. In this case we don't update the yaw angle or track height
\ before calculating the segment vector, as the main game code draws straight
\ segments by simply adding the same track segment vector for each segment in
\ the straight.
\
\ ******************************************************************************

.SetSegmentVector

 STX xStore             \ Store X in xStore so we can retrieve it at the end of
                        \ the routine

 LDY subSection         \ Set Y to the number of the current sub-section within
                        \ the current track section

 BMI sets1              \ If bit 7 of Y is set, then this part of the track is a
                        \ straight section that doesn't use the curve vectors to
                        \ generate the track, so jump to sets1 to skip updating
                        \ the yaw angle and track height, as we simply reuse the
                        \ same track segment vector for each segment within the
                        \ straight

                        \ We start by adding the yaw delta to the yaw angle

 LDA trackYawDeltaLo,Y  \ Set (A T) = (trackYawDeltaHi trackYawDeltaLo) for this
 STA T                  \ sub-section
 LDA trackYawDeltaHi,Y

 BIT directionFacing    \ Set the N flag to the sign of directionFacing, so the
                        \ call to Absolute16Bit sets the sign of (A T) to
                        \ abs(directionFacing)

 JSR Absolute16Bit      \ Set the sign of (A T) to match the sign bit in
                        \ directionFacing, so this negates (A T) if we are
                        \ facing backwards along the track

 STA U                  \ Set (U T) = (A T)
                        \           = signed (trackYawDeltaHi trackYawDeltaLo)
                        \             for this sub-section

 LDA T                  \ Set yawAngle = yawAngle + (U T)
 CLC                    \              = yawAngle + trackYawDelta
 ADC yawAngleLo         \
 STA yawAngleLo         \ starting with the low bytes

 LDA U                  \ And then the high bytes
 ADC yawAngleHi
 STA yawAngleHi

                        \ And now we add the track gradient (i.e. the height
                        \ delta) to the track height

 LDA trackGradient,Y    \ Set A to the gradient of this sub-section (i.e. the
                        \ change of track height over the course of the
                        \ sub-section)

 BIT directionFacing    \ Set the N flag to the sign of directionFacing, so the
                        \ call to Absolute8Bit sets the sign of A to
                        \ abs(directionFacing)

 JSR Absolute8Bit       \ Set the sign of A to match the sign bit in
                        \ directionFacing, so this negates A if we are facing
                        \ backwards along the track

 CLC                    \ Set heightOfTrack = heightOfTrack + A
 ADC heightOfTrack      \                   = heightOfTrack + trackGradient
 STA heightOfTrack

.sets1

 JSR CalcSegmentVector  \ Calculate the segment vector for the current segment
                        \ and put it in the xSegmentVectorI, ySegmentVectorI,
                        \ zSegmentVectorI, xSegmentVectorO and zSegmentVectorO
                        \ tables

 LDX xStore             \ Retrieve the value of X we stores above, so we can
                        \ return it unchanged by the routine

 RTS                    \ Return from the subroutine

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
\       Name: trackGradient
\       Type: Variable
\   Category: Extra track data
\    Summary: The change in height (i.e. the gradient) for each sub-section of
\             the track
\
\ ******************************************************************************

.trackGradient

 EQUB &00               \ Sub-section  0 =  0
 EQUB &00               \ Sub-section  1 =  0
 EQUB &FF               \ Sub-section  2 = -1
 EQUB &00               \ Sub-section  3 =  0
 EQUB &00               \ Sub-section  4 =  0
 EQUB &00               \ Sub-section  5 =  0
 EQUB &00               \ Sub-section  6 =  0
 EQUB &00               \ Sub-section  7 =  0
 EQUB &01               \ Sub-section  8 =  1
 EQUB &01               \ Sub-section  9 =  1
 EQUB &00               \ Sub-section 10 =  0
 EQUB &00               \ Sub-section 11 =  0
 EQUB &FF               \ Sub-section 12 = -1
 EQUB &00               \ Sub-section 13 =  0
 EQUB &00               \ Sub-section 14 =  0
 EQUB &00               \ Sub-section 15 =  0
 EQUB &01               \ Sub-section 16 =  1
 EQUB &01               \ Sub-section 17 =  1
 EQUB &01               \ Sub-section 18 =  1
 EQUB &00               \ Sub-section 19 =  0
 EQUB &01               \ Sub-section 20 =  1
 EQUB &00               \ Sub-section 21 =  0
 EQUB &00               \ Sub-section 22 =  0
 EQUB &FF               \ Sub-section 23 = -1
 EQUB &00               \ Sub-section 24 =  0
 EQUB &FF               \ Sub-section 25 = -1
 EQUB &FE               \ Sub-section 26 = -2
 EQUB &00               \ Sub-section 27 =  0
 EQUB &00               \ Sub-section 28 =  0
 EQUB &00               \ Sub-section 29 =  0
 EQUB &00               \ Sub-section 30 =  0
 EQUB &FF               \ Sub-section 31 = -1
 EQUB &FF               \ Sub-section 32 = -1
 EQUB &00               \ Sub-section 33 =  0
 EQUB &01               \ Sub-section 34 =  1
 EQUB &01               \ Sub-section 35 =  1
 EQUB &00               \ Sub-section 36 =  0
 EQUB &01               \ Sub-section 37 =  1
 EQUB &00               \ Sub-section 38 =  0
 EQUB &00               \ Sub-section 39 =  0
 EQUB &FF               \ Sub-section 40 = -1
 EQUB &FF               \ Sub-section 41 = -1
 EQUB &FF               \ Sub-section 42 = -1
 EQUB &00               \ Sub-section 43 =  0
 EQUB &FF               \ Sub-section 44 = -1

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
\       Type: Subroutine
\   Category: Extra track data
\    Summary: The y-coordinate of the track sign vector for each sign, to be
\             scaled and added to the inner track section vector for the sign
\
\ ******************************************************************************

.yTrackSignVector

 EQUB  -8               \ Sign  0 = (  1 << 6,  -8 << 4,  72 << 6) + section  0
 EQUB   6               \ Sign  1 = ( -6 << 6,   6 << 4,  13 << 6) + section  2
 EQUB  67               \ Sign  2 = ( -5 << 6,  67 << 4, -75 << 6) + section  3
 EQUB  35               \ Sign  3 = (  9 << 6,  35 << 4, -33 << 6) + section  5
 EQUB  39               \ Sign  4 = ( 28 << 6,  39 << 4, -54 << 6) + section  7
 EQUB  12               \ Sign  5 = (  6 << 6,  12 << 4,  -3 << 6) + section  9
 EQUB  22               \ Sign  6 = (  9 << 6,  22 << 4, -73 << 6) + section 12
 EQUB  -6               \ Sign  7 = ( -2 << 6,  -6 << 4,  20 << 6) + section 14
 EQUB -90               \ Sign  8 = (  0 << 6, -90 << 4,  61 << 6) + section 14
 EQUB   9               \ Sign  9 = (  3 << 6,   9 << 4,   4 << 6) + section 14
 EQUB  -6               \ Sign 10 = (-33 << 6,  -6 << 4,  64 << 6) + section 18
 EQUB   8               \ Sign 11 = ( -5 << 6,   8 << 4,  -3 << 6) + section 19
 EQUB   9               \ Sign 12 = ( -6 << 6,   9 << 4,   3 << 6) + section 20
 EQUB  93               \ Sign 13 = ( -1 << 6,  93 << 4,  73 << 6) + section 21
 EQUB  27               \ Sign 14 = (-39 << 6,  27 << 4, -66 << 6) + section 22
 EQUB -11               \ Sign 15 = ( 31 << 6, -11 << 4,  41 << 6) + section 23

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
 LDA trackSectionFrom,Y
 STA &02
 TYA
 LSR A
 LSR A
 LSR A
 TAY
 LDA trackYawAngleLo,Y
 STA yawAngleLo              \ 53FA in BH
 LDA trackYawAngleHi,Y
 STA yawAngleHi              \ 53FB in BH
 LDA trackHeight,Y
 STA heightOfTrack              \ 53FC in BH
 LDA trackSubConfig,Y
 LSR A
 ROR A
 STA subSection              \ 53F8 in BH
 LDA #&0E
 ROR A

\ STA &20C0
 STA &23B3

 LDA #&00
 STA subSectionSegment              \ 53FD in BH
 BIT &25
 BMI L56AA
 JSR SetSegmentVector       \ 55C4 in BH

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
\       Name: trackSubSize
\       Type: Variable
\   Category: Extra track data
\    Summary: The size of each sub-section, i.e. the number of segments in each
\             sub-section
\
\ ******************************************************************************

.trackSubSize

 EQUB 83                \ Sub-section  0
 EQUB 40                \ Sub-section  1
 EQUB 22                \ Sub-section  2
 EQUB 22                \ Sub-section  3
 EQUB 7                 \ Sub-section  4
 EQUB 2                 \ Sub-section  5
 EQUB 20                \ Sub-section  6
 EQUB 10                \ Sub-section  7
 EQUB 7                 \ Sub-section  8
 EQUB 11                \ Sub-section  9
 EQUB 34                \ Sub-section 10
 EQUB 3                 \ Sub-section 11
 EQUB 19                \ Sub-section 12
 EQUB 24                \ Sub-section 13
 EQUB 16                \ Sub-section 14
 EQUB 47                \ Sub-section 15
 EQUB 34                \ Sub-section 16
 EQUB 9                 \ Sub-section 17
 EQUB 25                \ Sub-section 18
 EQUB 38                \ Sub-section 19
 EQUB 23                \ Sub-section 20
 EQUB 25                \ Sub-section 21
 EQUB 6                 \ Sub-section 22
 EQUB 15                \ Sub-section 23
 EQUB 35                \ Sub-section 24
 EQUB 12                \ Sub-section 25
 EQUB 26                \ Sub-section 26
 EQUB 8                 \ Sub-section 27
 EQUB 7                 \ Sub-section 28
 EQUB 8                 \ Sub-section 29
 EQUB 28                \ Sub-section 30
 EQUB 22                \ Sub-section 31
 EQUB 6                 \ Sub-section 32
 EQUB 36                \ Sub-section 33
 EQUB 27                \ Sub-section 34
 EQUB 20                \ Sub-section 35
 EQUB 21                \ Sub-section 36
 EQUB 49                \ Sub-section 37
 EQUB 10                \ Sub-section 38
 EQUB 12                \ Sub-section 39
 EQUB 7                 \ Sub-section 40
 EQUB 17                \ Sub-section 41
 EQUB 29                \ Sub-section 42
 EQUB 21                \ Sub-section 43
 EQUB 4                 \ Sub-section 44

 EQUB &57, &57          \ These bytes appear to be unused
 EQUB &57, &57
 EQUB &57, &57
 EQUB &57, &57
 EQUB &57, &56
 EQUB &55, &55
 EQUB &54

\ ******************************************************************************
\
\       Name: zTrackSignVector
\       Type: Variable
\   Category: Extra track data
\    Summary: The z-coordinate of the track sign vector for each sign, to be
\             scaled and added to the inner track section vector for the sign
\
\ ******************************************************************************

.zTrackSignVector

 EQUB  72               \ Sign  0 = (  1 << 6,  -8 << 4,  72 << 6) + section  0
 EQUB  13               \ Sign  1 = ( -6 << 6,   6 << 4,  13 << 6) + section  2
 EQUB -75               \ Sign  2 = ( -5 << 6,  67 << 4, -75 << 6) + section  3
 EQUB -33               \ Sign  3 = (  9 << 6,  35 << 4, -33 << 6) + section  5
 EQUB -54               \ Sign  4 = ( 28 << 6,  39 << 4, -54 << 6) + section  7
 EQUB  -3               \ Sign  5 = (  6 << 6,  12 << 4,  -3 << 6) + section  9
 EQUB -73               \ Sign  6 = (  9 << 6,  22 << 4, -73 << 6) + section 12
 EQUB  20               \ Sign  7 = ( -2 << 6,  -6 << 4,  20 << 6) + section 14
 EQUB  61               \ Sign  8 = (  0 << 6, -90 << 4,  61 << 6) + section 14
 EQUB   4               \ Sign  9 = (  3 << 6,   9 << 4,   4 << 6) + section 14
 EQUB  64               \ Sign 10 = (-33 << 6,  -6 << 4,  64 << 6) + section 18
 EQUB  -3               \ Sign 11 = ( -5 << 6,   8 << 4,  -3 << 6) + section 19
 EQUB   3               \ Sign 12 = ( -6 << 6,   9 << 4,   3 << 6) + section 20
 EQUB  73               \ Sign 13 = ( -1 << 6,  93 << 4,  73 << 6) + section 21
 EQUB -66               \ Sign 14 = (-39 << 6,  27 << 4, -66 << 6) + section 22
 EQUB  41               \ Sign 15 = ( 31 << 6, -11 << 4,  41 << 6) + section 23

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
\       Name: xTrackCurve
\       Type: Variable
\   Category: Extra track data
\    Summary: The x-coordinate of the tangent vector (i.e. the curve direction)
\             at 64 points on a one-eighth circle covering 0 to 45 degrees
\
\ ******************************************************************************

.xTrackCurve

 EQUB 0                 \ Coordinate  0 = (0, 120)
 EQUB 1                 \ Coordinate  1 = (1, 120)
 EQUB 3                 \ Coordinate  2 = (3, 120)
 EQUB 4                 \ Coordinate  3 = (4, 120)
 EQUB 6                 \ Coordinate  4 = (6, 120)
 EQUB 7                 \ Coordinate  5 = (7, 120)
 EQUB 9                 \ Coordinate  6 = (9, 120)
 EQUB 10                \ Coordinate  7 = (10, 120)
 EQUB 12                \ Coordinate  8 = (12, 119)
 EQUB 13                \ Coordinate  9 = (13, 119)
 EQUB 15                \ Coordinate 10 = (15, 119)
 EQUB 16                \ Coordinate 11 = (16, 119)
 EQUB 18                \ Coordinate 12 = (18, 119)
 EQUB 19                \ Coordinate 13 = (19, 118)
 EQUB 21                \ Coordinate 14 = (21, 118)
 EQUB 22                \ Coordinate 15 = (22, 118)
 EQUB 23                \ Coordinate 16 = (23, 118)
 EQUB 25                \ Coordinate 17 = (25, 117)
 EQUB 26                \ Coordinate 18 = (26, 117)
 EQUB 28                \ Coordinate 19 = (28, 117)
 EQUB 29                \ Coordinate 20 = (29, 116)
 EQUB 31                \ Coordinate 21 = (31, 116)
 EQUB 32                \ Coordinate 22 = (32, 116)
 EQUB 33                \ Coordinate 23 = (33, 115)
 EQUB 35                \ Coordinate 24 = (35, 115)
 EQUB 36                \ Coordinate 25 = (36, 114)
 EQUB 38                \ Coordinate 26 = (38, 114)
 EQUB 39                \ Coordinate 27 = (39, 113)
 EQUB 40                \ Coordinate 28 = (40, 113)
 EQUB 42                \ Coordinate 29 = (42, 112)
 EQUB 43                \ Coordinate 30 = (43, 112)
 EQUB 45                \ Coordinate 31 = (45, 111)
 EQUB 46                \ Coordinate 32 = (46, 111)
 EQUB 47                \ Coordinate 33 = (47, 110)
 EQUB 49                \ Coordinate 34 = (49, 110)
 EQUB 50                \ Coordinate 35 = (50, 109)
 EQUB 51                \ Coordinate 36 = (51, 108)
 EQUB 53                \ Coordinate 37 = (53, 108)
 EQUB 54                \ Coordinate 38 = (54, 107)
 EQUB 55                \ Coordinate 39 = (55, 107)
 EQUB 57                \ Coordinate 40 = (57, 106)
 EQUB 58                \ Coordinate 41 = (58, 105)
 EQUB 59                \ Coordinate 42 = (59, 104)
 EQUB 60                \ Coordinate 43 = (60, 104)
 EQUB 62                \ Coordinate 44 = (62, 103)
 EQUB 63                \ Coordinate 45 = (63, 102)
 EQUB 64                \ Coordinate 46 = (64, 101)
 EQUB 65                \ Coordinate 47 = (65, 101)
 EQUB 67                \ Coordinate 48 = (67, 100)
 EQUB 68                \ Coordinate 49 = (68, 99)
 EQUB 69                \ Coordinate 50 = (69, 98)
 EQUB 70                \ Coordinate 51 = (70, 97)
 EQUB 71                \ Coordinate 52 = (71, 96)
 EQUB 73                \ Coordinate 53 = (73, 96)
 EQUB 74                \ Coordinate 54 = (74, 95)
 EQUB 75                \ Coordinate 55 = (75, 94)
 EQUB 76                \ Coordinate 56 = (76, 93)
 EQUB 77                \ Coordinate 57 = (77, 92)
 EQUB 78                \ Coordinate 58 = (78, 91)
 EQUB 79                \ Coordinate 59 = (79, 90)
 EQUB 81                \ Coordinate 60 = (81, 89)
 EQUB 82                \ Coordinate 61 = (82, 88)
 EQUB 83                \ Coordinate 62 = (83, 87)
 EQUB 84                \ Coordinate 63 = (84, 86)
 EQUB 85                \ Coordinate 64 = (85, 85)

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

 EQUB &3A, &34, &2D, &25, &1E
 EQUB &16, &0E, &1B, &28, &34, &3E, &41, &43

\ ******************************************************************************
\
\       Name: trackHeight
\       Type: Variable
\   Category: Extra track data
\    Summary: The height of the track above ground level for each track section
\
\ ******************************************************************************

.trackHeight

 EQUB &FA               \ Section  0 =  -6
 EQUB &FA               \ Section  1 =  -6
 EQUB &E4               \ Section  2 = -28
 EQUB &E4               \ Section  3 = -28
 EQUB &EB               \ Section  4 = -21
 EQUB &F6               \ Section  5 = -10
 EQUB &E3               \ Section  6 = -29
 EQUB &E3               \ Section  7 = -29
 EQUB &E3               \ Section  8 = -29
 EQUB &E3               \ Section  9 = -29
 EQUB &E3               \ Section 10 = -29
 EQUB &0E               \ Section 11 =  14
 EQUB &27               \ Section 12 =  39
 EQUB &3E               \ Section 13 =  62
 EQUB &3E               \ Section 14 =  62
 EQUB &3E               \ Section 15 =  62
 EQUB &2F               \ Section 16 =  47
 EQUB &EF               \ Section 17 = -17
 EQUB &EF               \ Section 18 = -17
 EQUB &EF               \ Section 19 = -17
 EQUB &D9               \ Section 20 = -39
 EQUB &EE               \ Section 21 = -18
 EQUB &02               \ Section 22 =   2
 EQUB &33               \ Section 23 =  51
 EQUB &33               \ Section 24 =  51
 EQUB &1B               \ Section 24 =  27
 EQUB &FE               \ Section 24 =  -2

 EQUB &47, &44          \ These bytes appear to be unused
 EQUB &41

\ ******************************************************************************
\
\       Name: trackYawAngleLo
\       Type: Variable
\   Category: Extra track data
\    Summary: The low byte of the yaw angle of the start of each track section
\             (i.e. the direction of the track at that point)
\
\ ******************************************************************************

.trackYawAngleLo

 EQUB &00               \ Section  0 = &0000 =     0 =   0.0 degrees
 EQUB &00               \ Section  1 = &0000 =     0 =   0.0 degrees
 EQUB &00               \ Section  2 = &0000 =     0 =   0.0 degrees
 EQUB &58               \ Section  3 = &3758 = 14168 =  77.8 degrees
 EQUB &0E               \ Section  4 = &ED0E = 60686 = 333.4 degrees
 EQUB &0E               \ Section  5 = &ED0E = 60686 = 333.4 degrees
 EQUB &0E               \ Section  6 = &ED0E = 60686 = 333.4 degrees
 EQUB &76               \ Section  7 = &B276 = 45686 = 251.0 degrees
 EQUB &76               \ Section  8 = &B276 = 45686 = 251.0 degrees
 EQUB &56               \ Section  9 = &0C56 =  3158 =  17.3 degrees
 EQUB &56               \ Section 10 = &0C56 =  3158 =  17.3 degrees
 EQUB &3D               \ Section 11 = &F53D = 62781 = 344.9 degrees
 EQUB &98               \ Section 12 = &8098 = 32920 = 180.8 degrees
 EQUB &98               \ Section 13 = &8098 = 32920 = 180.8 degrees
 EQUB &F7               \ Section 14 = &53F7 = 21495 = 118.1 degrees
 EQUB &F7               \ Section 15 = &53F7 = 21495 = 118.1 degrees
 EQUB &1A               \ Section 16 = &6D1A = 27930 = 153.4 degrees
 EQUB &1A               \ Section 17 = &6D1A = 27930 = 153.4 degrees
 EQUB &A1               \ Section 18 = &31A1 = 12705 =  69.8 degrees
 EQUB &A1               \ Section 19 = &31A1 = 12705 =  69.8 degrees
 EQUB &91               \ Section 20 = &7C91 = 31889 = 175.2 degrees
 EQUB &91               \ Section 21 = &7C91 = 31889 = 175.2 degrees
 EQUB &F5               \ Section 22 = &95F5 = 38389 = 210.9 degrees
 EQUB &F5               \ Section 23 = &95F5 = 38389 = 210.9 degrees
 EQUB &39               \ Section 24 = &6D39 = 27961 = 153.6 degrees
 EQUB &D3               \ Section 24 = &96D3 = 38611 = 212.1 degrees
 EQUB &D3               \ Section 24 = &96D3 = 38611 = 212.1 degrees

 EQUB &19, &1C          \ These bytes appear to be unused
 EQUB &1E

\ ******************************************************************************
\
\       Name: trackYawAngleHi
\       Type: Variable
\   Category: Extra track data
\    Summary: The high byte of the yaw angle of the start of each track section
\             (i.e. the direction of the track at that point)
\
\ ******************************************************************************

.trackYawAngleHi

 EQUB &00               \ Section  0 = &0000 =     0 =   0.0 degrees
 EQUB &00               \ Section  1 = &0000 =     0 =   0.0 degrees
 EQUB &00               \ Section  2 = &0000 =     0 =   0.0 degrees
 EQUB &37               \ Section  3 = &3758 = 14168 =  77.8 degrees
 EQUB &ED               \ Section  4 = &ED0E = 60686 = 333.4 degrees
 EQUB &ED               \ Section  5 = &ED0E = 60686 = 333.4 degrees
 EQUB &ED               \ Section  6 = &ED0E = 60686 = 333.4 degrees
 EQUB &B2               \ Section  7 = &B276 = 45686 = 251.0 degrees
 EQUB &B2               \ Section  8 = &B276 = 45686 = 251.0 degrees
 EQUB &0C               \ Section  9 = &0C56 =  3158 =  17.3 degrees
 EQUB &0C               \ Section 10 = &0C56 =  3158 =  17.3 degrees
 EQUB &F5               \ Section 11 = &F53D = 62781 = 344.9 degrees
 EQUB &80               \ Section 12 = &8098 = 32920 = 180.8 degrees
 EQUB &80               \ Section 13 = &8098 = 32920 = 180.8 degrees
 EQUB &53               \ Section 14 = &53F7 = 21495 = 118.1 degrees
 EQUB &53               \ Section 15 = &53F7 = 21495 = 118.1 degrees
 EQUB &6D               \ Section 16 = &6D1A = 27930 = 153.4 degrees
 EQUB &6D               \ Section 17 = &6D1A = 27930 = 153.4 degrees
 EQUB &31               \ Section 18 = &31A1 = 12705 =  69.8 degrees
 EQUB &31               \ Section 19 = &31A1 = 12705 =  69.8 degrees
 EQUB &7C               \ Section 20 = &7C91 = 31889 = 175.2 degrees
 EQUB &7C               \ Section 21 = &7C91 = 31889 = 175.2 degrees
 EQUB &95               \ Section 22 = &95F5 = 38389 = 210.9 degrees
 EQUB &95               \ Section 23 = &95F5 = 38389 = 210.9 degrees
 EQUB &6D               \ Section 24 = &6D39 = 27961 = 153.6 degrees
 EQUB &96               \ Section 24 = &96D3 = 38611 = 212.1 degrees
 EQUB &96               \ Section 24 = &96D3 = 38611 = 212.1 degrees

 EQUB &C3, &BF          \ These bytes appear to be unused
 EQUB &BC

\ ******************************************************************************
\
\       Name: trackSubConfig
\       Type: Variable
\   Category: Extra track data
\    Summary: Configuration data for each section that defines the sub-section
\             numbers, and horizon calculations
\
\ ------------------------------------------------------------------------------
\
\ Each section has a trackSubConfig value that contains the following data:
\
\   * Bits 2 to 7 = the number of the first sub-section in this section
\
\   * Bit 1 = if this is set, then in the horizon calculations, we skip the
\             check that sets horizonLine to 7
\
\   * Bit 0 = if this is set, then the segment vectors for this section are
\             generated as a straight track rather than using the curve tables
\             (this bit is only set for straight sections)
\
\ In the last one, if bit 0 is set then bit 7 of subSection gets set. This makes
\ us skip the first part of the SetSegmentVector routine, which means we do not
\ update the yaw angle or track height before calculating the segment vector.
\ This means we reuse the segment vector from the end of the previous section
\ for generating this track section. This is only done for straight sections,
\ and the main game code draws straight sections by simply adding the same track
\ segment vector for each segment in the straight, so setting bit 0 of a
\ section's trackSubConfig ensures that it heads off in a straight line in the
\ exact same direction as the tail end of the preceding section.
\
\ ******************************************************************************

.trackSubConfig

 EQUB %00000000         \ Section  0 = 000000 0 0    From  0  check     curve
 EQUB %00000100         \ Section  1 = 000001 0 0    From  1  check     curve
 EQUB %00010010         \ Section  2 = 000100 1 0    From  4  no check  curve
 EQUB %00011010         \ Section  3 = 000110 1 0    From  6  no check  curve
 EQUB %00100110         \ Section  4 = 001001 1 0    From  9  no check  curve
 EQUB %00101110         \ Section  5 = 001011 1 0    From 11  no check  curve
 EQUB %00110110         \ Section  6 = 001101 1 0    From 13  no check  curve
 EQUB %00111011         \ Section  7 = 001110 1 1    From 14  no check  straight
 EQUB %00111010         \ Section  8 = 001110 1 0    From 14  no check  curve
 EQUB %00111111         \ Section  9 = 001111 1 1    From 15  no check  straight
 EQUB %00111110         \ Section 10 = 001111 1 0    From 15  no check  curve
 EQUB %01001010         \ Section 11 = 010010 1 0    From 18  no check  curve
 EQUB %01001110         \ Section 12 = 010011 1 0    From 19  no check  curve
 EQUB %01010110         \ Section 13 = 010101 1 0    From 21  no check  curve
 EQUB %01011010         \ Section 14 = 010110 1 0    From 22  no check  curve
 EQUB %01011110         \ Section 15 = 010111 1 0    From 23  no check  curve
 EQUB %01100000         \ Section 16 = 011000 0 0    From 24  check     curve
 EQUB %01110010         \ Section 17 = 011100 1 0    From 28  no check  curve
 EQUB %01111010         \ Section 18 = 011110 1 0    From 30  no check  curve
 EQUB %01111110         \ Section 19 = 011111 1 0    From 31  no check  curve
 EQUB %10000010         \ Section 20 = 100000 1 0    From 32  no check  curve
 EQUB %10001110         \ Section 21 = 100011 1 0    From 35  no check  curve
 EQUB %10010010         \ Section 22 = 100100 1 0    From 36  no check  curve
 EQUB %10011110         \ Section 23 = 100111 1 0    From 39  no check  curve
 EQUB %10100010         \ Section 24 = 101000 1 0    From 40  no check  curve
 EQUB %10101010         \ Section 25 = 101010 1 0    From 42  no check  curve
 EQUB %10101110         \ Section 26 = 101011 1 0    From 43  no check  curve

 EQUB &D3, &D3          \ These bytes appear to be unused
 EQUB &D3

\ ******************************************************************************
\
\       Name: trackRacingLine
\       Type: Variable
\   Category: Extra track data
\    Summary: The optimum racing line for non-player drivers on each track
\             section
\  Deep dive: The track data file format
\
\ ******************************************************************************

.trackRacingLine

 EQUB %00011000         \ Section  0 = 000110 0 0 =  +6 * baseSpeed
 EQUB %00011000         \ Section  1 = 000110 0 0 =  +6 * baseSpeed
 EQUB %01100111         \ Section  2 = 011001 1 1 = -25
 EQUB %01001000         \ Section  3 = 010010 0 0 = +18 * baseSpeed
 EQUB %00011001         \ Section  4 = 000110 0 1 =  -6 * baseSpeed
 EQUB %00011001         \ Section  5 = 000110 0 1 =  -6 * baseSpeed
 EQUB %01010010         \ Section  6 = 010100 1 0 = +20
 EQUB %00110000         \ Section  7 = 001100 0 0 = +12 * baseSpeed
 EQUB %01000111         \ Section  8 = 010001 1 1 = -17
 EQUB %00011000         \ Section  9 = 000110 0 0 =  +6 * baseSpeed
 EQUB %00011000         \ Section 10 = 000110 0 0 =  +6 * baseSpeed
 EQUB %00111011         \ Section 11 = 001110 1 1 = -14
 EQUB %00011001         \ Section 12 = 000110 0 1 =  -6 * baseSpeed
 EQUB %00111100         \ Section 13 = 001111 0 0 = +15 * baseSpeed
 EQUB %00000000         \ Section 14 = 000000 0 0 =  +0 * baseSpeed
 EQUB %00111101         \ Section 15 = 001111 0 1 = -15 * baseSpeed
 EQUB %00011001         \ Section 16 = 000110 0 1 =  -6 * baseSpeed
 EQUB %01010010         \ Section 17 = 010100 1 0 = +20
 EQUB %01010000         \ Section 18 = 010100 0 0 = +20 * baseSpeed
 EQUB %01010011         \ Section 19 = 010100 1 1 = -20
 EQUB %00011000         \ Section 20 = 000110 0 0 =  +6 * baseSpeed
 EQUB %00111101         \ Section 21 = 001111 0 1 = -15 * baseSpeed
 EQUB %00100001         \ Section 22 = 001000 0 1 =  -8 * baseSpeed
 EQUB %01101010         \ Section 23 = 011010 1 0 = +26
 EQUB %01110001         \ Section 24 = 011100 0 1 = -28 * baseSpeed
 EQUB %00011000         \ Section 25 = 000110 0 0 =  +6 * baseSpeed
 EQUB %01000011         \ Section 26 = 010000 1 1 = -16

 EQUB &18, &A9          \ These bytes appear to be unused
 EQUB &AA, &AA

\ ******************************************************************************
\
\       Name: zTrackCurve
\       Type: Variable
\   Category: Extra track data
\    Summary: The z-coordinate of the tangent vector (i.e. the curve direction)
\             at 64 points on a one-eighth circle covering 0 to 45 degrees
\
\ ******************************************************************************

.zTrackCurve

 EQUB 120               \ Coordinate  0 = (0, 120)
 EQUB 120               \ Coordinate  1 = (1, 120)
 EQUB 120               \ Coordinate  2 = (3, 120)
 EQUB 120               \ Coordinate  3 = (4, 120)
 EQUB 120               \ Coordinate  4 = (6, 120)
 EQUB 120               \ Coordinate  5 = (7, 120)
 EQUB 120               \ Coordinate  6 = (9, 120)
 EQUB 120               \ Coordinate  7 = (10, 120)
 EQUB 119               \ Coordinate  8 = (12, 119)
 EQUB 119               \ Coordinate  9 = (13, 119)
 EQUB 119               \ Coordinate 10 = (15, 119)
 EQUB 119               \ Coordinate 11 = (16, 119)
 EQUB 119               \ Coordinate 12 = (18, 119)
 EQUB 118               \ Coordinate 13 = (19, 118)
 EQUB 118               \ Coordinate 14 = (21, 118)
 EQUB 118               \ Coordinate 15 = (22, 118)
 EQUB 118               \ Coordinate 16 = (23, 118)
 EQUB 117               \ Coordinate 17 = (25, 117)
 EQUB 117               \ Coordinate 18 = (26, 117)
 EQUB 117               \ Coordinate 19 = (28, 117)
 EQUB 116               \ Coordinate 20 = (29, 116)
 EQUB 116               \ Coordinate 21 = (31, 116)
 EQUB 116               \ Coordinate 22 = (32, 116)
 EQUB 115               \ Coordinate 23 = (33, 115)
 EQUB 115               \ Coordinate 24 = (35, 115)
 EQUB 114               \ Coordinate 25 = (36, 114)
 EQUB 114               \ Coordinate 26 = (38, 114)
 EQUB 113               \ Coordinate 27 = (39, 113)
 EQUB 113               \ Coordinate 28 = (40, 113)
 EQUB 112               \ Coordinate 29 = (42, 112)
 EQUB 112               \ Coordinate 30 = (43, 112)
 EQUB 111               \ Coordinate 31 = (45, 111)
 EQUB 111               \ Coordinate 32 = (46, 111)
 EQUB 110               \ Coordinate 33 = (47, 110)
 EQUB 110               \ Coordinate 34 = (49, 110)
 EQUB 109               \ Coordinate 35 = (50, 109)
 EQUB 108               \ Coordinate 36 = (51, 108)
 EQUB 108               \ Coordinate 37 = (53, 108)
 EQUB 107               \ Coordinate 38 = (54, 107)
 EQUB 107               \ Coordinate 39 = (55, 107)
 EQUB 106               \ Coordinate 40 = (57, 106)
 EQUB 105               \ Coordinate 41 = (58, 105)
 EQUB 104               \ Coordinate 42 = (59, 104)
 EQUB 104               \ Coordinate 43 = (60, 104)
 EQUB 103               \ Coordinate 44 = (62, 103)
 EQUB 102               \ Coordinate 45 = (63, 102)
 EQUB 101               \ Coordinate 46 = (64, 101)
 EQUB 101               \ Coordinate 47 = (65, 101)
 EQUB 100               \ Coordinate 48 = (67, 100)
 EQUB 99                \ Coordinate 49 = (68, 99)
 EQUB 98                \ Coordinate 50 = (69, 98)
 EQUB 97                \ Coordinate 51 = (70, 97)
 EQUB 96                \ Coordinate 52 = (71, 96)
 EQUB 96                \ Coordinate 53 = (73, 96)
 EQUB 95                \ Coordinate 54 = (74, 95)
 EQUB 94                \ Coordinate 55 = (75, 94)
 EQUB 93                \ Coordinate 56 = (76, 93)
 EQUB 92                \ Coordinate 57 = (77, 92)
 EQUB 91                \ Coordinate 58 = (78, 91)
 EQUB 90                \ Coordinate 59 = (79, 90)
 EQUB 89                \ Coordinate 60 = (81, 89)
 EQUB 88                \ Coordinate 61 = (82, 88)
 EQUB 87                \ Coordinate 62 = (83, 87)
 EQUB 86                \ Coordinate 63 = (84, 86)
 EQUB 85                \ Coordinate 64 = (85, 85)

\ ******************************************************************************
\
\       Name: Track section data (Part 2 of 2)
\       Type: Variable
\   Category: Extra track data
\    Summary: Data for the track sections
\  Deep dive: The track data file format
\
\ ------------------------------------------------------------------------------
\
\ This part defines the following aspects of these track sections:
\
\ trackSectionFlag      Various flags for the track section
\
\                       The abbreviations in brackets are used to show the
\                       values of section's flags in the comments below
\
\                         * Bit 0: Section shape (Sh)
\
\                           * 0 = straight section (only one segment vector)
\
\                           * 1 = curved section (multiple segment vectors)
\
\                         * Bit 1: Colour of left verge marks (Vc)
\
\                           * 0 = black-and-white verge marks
\
\                           * 1 = red-and-white verge marks
\
\                         * Bit 2: Colour of right verge marks (Vc)
\
\                           * 0 = black-and-white verge marks
\
\                           * 1 = red-and-white verge marks
\
\                         * Bit 3: Show corner markers on right (Mlr)
\
\                           * 0 = do not show corner markers to the right of the
\                                 track
\
\                           * 1 = show corner markers to the right of the track
\
\                         * Bit 4: Show corner markers on left (Mlr)
\
\                           * 0 = do not show corner markers to the left of the
\                                 track
\
\                           * 1 = show corner markers to the left of the track
\
\                         * Bit 5: Corner marker colours (Mc)
\
\                           * 0 = show all corner markers in white
\
\                           * 1 = show corner markers in red or white, as
\                                 appropriate
\
\                         * Bit 6: Enable hooks to generate segment vectors (G)
\
\                           * 0 = disable HookDataPointers and HookSegmentVector
\
\                           * 1 = enable HookDataPointers and HookSegmentVector
\
\                         * Bit 7: Maximum approach speed for next section (Sp)
\
\                           * 0 = the next section has no maximum approach speed
\
\                           * 1 = the next section has a maximum approach speed
\
\ xTrackSectionILo      Low byte of the x-coordinate of the starting point of
\                       the inner verge of each track section
\
\ yTrackSectionILo      Low byte of the y-coordinate of the starting point of
\                       the inner verge of each track section
\
\ zTrackSectionILo      Low byte of the z-coordinate of the starting point of
\                       the inner verge of each track section
\
\ xTrackSectionOLo      Low byte of the x-coordinate of the starting point of
\                       the outside verge of each track section
\
\ trackSectionFrom      The number of the first segment vector in each section,
\                       which enables us to fetch the segment vectors for a
\                       given track section
\
\ zTrackSectionOLo      Low byte of the z-coordinate of the starting point of
\                       the outside verge of each track section
\
\ trackSectionSize      The length of each track section in terms of segments
\
\ ******************************************************************************

                        \ Track section 0

 EQUB %01000010         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=01 Sh=0
 EQUB &E0               \ xTrackSectionILo       xTrackSectionI = &2EE0 =  12000
 EQUB &40               \ yTrackSectionILo       yTrackSectionI = &1F40 =   8000
 EQUB &00               \ zTrackSectionILo       zTrackSectionI = &0000 = 0
 EQUB &BF               \ xTrackSectionOLo       xTrackSectionO = &2DBF =  11711
 EQUB 1                 \ trackSectionFrom
 EQUB &00               \ zTrackSectionOLo       zTrackSectionO = &0000 = 0
 EQUB 83                \ trackSectionSize

                        \ Track section 1

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &E0               \ xTrackSectionILo       xTrackSectionI = &2EE0 =  12000
 EQUB &4E               \ yTrackSectionILo       yTrackSectionI = &1D4E =   7502
 EQUB &E8               \ zTrackSectionILo       zTrackSectionI = &26E8 =   9960
 EQUB &BF               \ xTrackSectionOLo       xTrackSectionO = &2DBF =  11711
 EQUB 5                 \ trackSectionFrom
 EQUB &E8               \ zTrackSectionOLo       zTrackSectionO = &26E8 =   9960
 EQUB 84                \ trackSectionSize

                        \ Track section 2

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &E0               \ xTrackSectionILo       xTrackSectionI = &2EE0 =  12000
 EQUB &75               \ yTrackSectionILo       yTrackSectionI = &1875 =   6261
 EQUB &48               \ zTrackSectionILo       zTrackSectionI = &4E48 =  20040
 EQUB &BF               \ xTrackSectionOLo       xTrackSectionO = &2DBF =  11711
 EQUB 10                \ trackSectionFrom
 EQUB &48               \ zTrackSectionOLo       zTrackSectionO = &4E48 =  20040
 EQUB 9                 \ trackSectionSize

                        \ Track section 3

 EQUB %01110011         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &E8               \ xTrackSectionILo       xTrackSectionI = &31E8 =  12776
 EQUB &79               \ yTrackSectionILo       yTrackSectionI = &1779 =   6009
 EQUB &AB               \ zTrackSectionILo       zTrackSectionI = &50AB =  20651
 EQUB &A9               \ xTrackSectionOLo       xTrackSectionO = &31A9 =  12713
 EQUB 20                \ trackSectionFrom
 EQUB &C4               \ zTrackSectionOLo       zTrackSectionO = &51C4 =  20932
 EQUB 37                \ trackSectionSize

                        \ Track section 4

 EQUB %01000100         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=10 Sh=0
 EQUB &79               \ xTrackSectionILo       xTrackSectionI = &3579 =  13689
 EQUB &89               \ yTrackSectionILo       yTrackSectionI = &1389 =   5001
 EQUB &34               \ zTrackSectionILo       zTrackSectionI = &5F34 =  24372
 EQUB &77               \ xTrackSectionOLo       xTrackSectionO = &3477 =  13431
 EQUB 18                \ trackSectionFrom
 EQUB &B2               \ zTrackSectionOLo       zTrackSectionO = &5EB2 =  24242
 EQUB 45                \ trackSectionSize

                        \ Track section 5

 EQUB %01101000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=00 Sh=0
 EQUB &FB               \ xTrackSectionILo       xTrackSectionI = &2BFB =  11259
 EQUB &90               \ yTrackSectionILo       yTrackSectionI = &1190 =   4496
 EQUB &03               \ zTrackSectionILo       zTrackSectionI = &7203 =  29187
 EQUB &F9               \ xTrackSectionOLo       xTrackSectionO = &2AF9 =  11001
 EQUB 24                \ trackSectionFrom
 EQUB &81               \ zTrackSectionOLo       zTrackSectionO = &7181 =  29057
 EQUB 22                \ trackSectionSize

                        \ Track section 6

 EQUB %11110011         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &57               \ xTrackSectionILo       xTrackSectionI = &2757 =  10071
 EQUB &F6               \ yTrackSectionILo       yTrackSectionI = &0FF6 =   4086
 EQUB &35               \ zTrackSectionILo       zTrackSectionI = &7B35 =  31541
 EQUB &55               \ xTrackSectionOLo       xTrackSectionO = &2655 =   9813
 EQUB 7                 \ trackSectionFrom
 EQUB &B3               \ zTrackSectionOLo       zTrackSectionO = &7AB3 =  31411
 EQUB 24                \ trackSectionSize

                        \ Track section 7

 EQUB %00110100         \ trackSectionFlag       Sp=0 G=0 Mc=1 Mlr=10 Vc=10 Sh=0
 EQUB &AB               \ xTrackSectionILo       xTrackSectionI = &1DAB =   7595
 EQUB &3E               \ yTrackSectionILo       yTrackSectionI = &0D3E =   3390
 EQUB &C1               \ zTrackSectionILo       zTrackSectionI = &7EC1 =  32449
 EQUB &0B               \ xTrackSectionOLo       xTrackSectionO = &1E0B =   7691
 EQUB 32                \ trackSectionFrom
 EQUB &B1               \ zTrackSectionOLo       zTrackSectionO = &7DB1 =  32177
 EQUB 16                \ trackSectionSize

                        \ Track section 8

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &9B               \ xTrackSectionILo       xTrackSectionI = &169B =   5787
 EQUB &6E               \ yTrackSectionILo       yTrackSectionI = &0B6E =   2926
 EQUB &41               \ zTrackSectionILo       zTrackSectionI = &7C41 =  31809
 EQUB &FB               \ xTrackSectionOLo       xTrackSectionO = &16FB =   5883
 EQUB 34                \ trackSectionFrom
 EQUB &31               \ zTrackSectionOLo       zTrackSectionO = &7B31 =  31537
 EQUB 16                \ trackSectionSize

                        \ Track section 9

 EQUB %00000010         \ trackSectionFlag       Sp=0 G=0 Mc=0 Mlr=00 Vc=01 Sh=0
 EQUB &85               \ xTrackSectionILo       xTrackSectionI = &1285 =   4741
 EQUB &9E               \ yTrackSectionILo       yTrackSectionI = &099E =   2462
 EQUB &C3               \ zTrackSectionILo       zTrackSectionI = &80C3 = -32573
 EQUB &70               \ xTrackSectionOLo       xTrackSectionO = &1170 =   4464
 EQUB 11                \ trackSectionFrom
 EQUB &17               \ zTrackSectionOLo       zTrackSectionO = &8117 = -32489
 EQUB 19                \ trackSectionSize

                        \ Track section 10

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &1E               \ xTrackSectionILo       xTrackSectionI = &151E =   5406
 EQUB &77               \ yTrackSectionILo       yTrackSectionI = &0777 =   1911
 EQUB &4C               \ zTrackSectionILo       zTrackSectionI = &894C = -30388
 EQUB &09               \ xTrackSectionOLo       xTrackSectionO = &1409 =   5129
 EQUB 12                \ trackSectionFrom
 EQUB &A0               \ zTrackSectionOLo       zTrackSectionO = &89A0 = -30304
 EQUB 90                \ trackSectionSize

                        \ Track section 11

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &5D               \ xTrackSectionILo       xTrackSectionI = &145D =   5213
 EQUB &F7               \ yTrackSectionILo       yTrackSectionI = &00F7 =    247
 EQUB &D6               \ zTrackSectionILo       zTrackSectionI = &B2D6 = -19754
 EQUB &45               \ xTrackSectionOLo       xTrackSectionO = &1345 =   4933
 EQUB 22                \ trackSectionFrom
 EQUB &89               \ zTrackSectionOLo       zTrackSectionO = &B289 = -19831
 EQUB 25                \ trackSectionSize

                        \ Track section 12

 EQUB %01101010         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=01 Sh=0
 EQUB &24               \ xTrackSectionILo       xTrackSectionI = &1B24 =   6948
 EQUB &9A               \ yTrackSectionILo       yTrackSectionI = &039A =    922
 EQUB &41               \ zTrackSectionILo       zTrackSectionI = &B341 = -19647
 EQUB &44               \ xTrackSectionOLo       xTrackSectionO = &1C44 =   7236
 EQUB 7                 \ trackSectionFrom
 EQUB &3E               \ zTrackSectionOLo       zTrackSectionO = &B33E = -19650
 EQUB 61                \ trackSectionSize

                        \ Track section 13

 EQUB %01110011         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &E7               \ xTrackSectionILo       xTrackSectionI = &1AE7 =   6887
 EQUB &F9               \ yTrackSectionILo       yTrackSectionI = &0DF9 =   3577
 EQUB &A9               \ zTrackSectionILo       zTrackSectionI = &96A9 = -26967
 EQUB &07               \ xTrackSectionOLo       xTrackSectionO = &1C07 =   7175
 EQUB 28                \ trackSectionFrom
 EQUB &A6               \ zTrackSectionOLo       zTrackSectionO = &96A6 = -26970
 EQUB 25                \ trackSectionSize

                        \ Track section 14

 EQUB %01000000         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &D8               \ xTrackSectionILo       xTrackSectionI = &20D8 =   8408
 EQUB &07               \ yTrackSectionILo       yTrackSectionI = &1407 =   5127
 EQUB &3B               \ zTrackSectionILo       zTrackSectionI = &8D3B = -29381
 EQUB &5C               \ xTrackSectionOLo       xTrackSectionO = &215C =   8540
 EQUB 13                \ trackSectionFrom
 EQUB &3C               \ zTrackSectionOLo       zTrackSectionO = &8E3C = -29124
 EQUB 6                 \ trackSectionSize

                        \ Track section 15

 EQUB %01101101         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &5A               \ xTrackSectionILo       xTrackSectionI = &235A =   9050
 EQUB &7B               \ yTrackSectionILo       yTrackSectionI = &157B =   5499
 EQUB &F1               \ zTrackSectionILo       zTrackSectionI = &8BF1 = -29711
 EQUB &DE               \ xTrackSectionOLo       xTrackSectionO = &23DE =   9182
 EQUB 19                \ trackSectionFrom
 EQUB &F2               \ zTrackSectionOLo       zTrackSectionO = &8CF2 = -29454
 EQUB 15                \ trackSectionSize

                        \ Track section 16

 EQUB %01101010         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=01 Sh=0
 EQUB &1C               \ xTrackSectionILo       xTrackSectionI = &281C =  10268
 EQUB &A5               \ yTrackSectionILo       yTrackSectionI = &18A5 =   6309
 EQUB &EA               \ zTrackSectionILo       zTrackSectionI = &86EA = -30998
 EQUB &1D               \ xTrackSectionOLo       xTrackSectionO = &291D =  10525
 EQUB 34                \ trackSectionFrom
 EQUB &6B               \ zTrackSectionOLo       zTrackSectionO = &876B = -30869
 EQUB 81                \ trackSectionSize

                        \ Track section 17

 EQUB %11110011         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &32               \ xTrackSectionILo       xTrackSectionI = &3932 =  14642
 EQUB &40               \ yTrackSectionILo       yTrackSectionI = &2140 =   8512
 EQUB &0F               \ zTrackSectionILo       zTrackSectionI = &650F =  25871
 EQUB &33               \ xTrackSectionOLo       xTrackSectionO = &3A33 =  14899
 EQUB 35                \ trackSectionFrom
 EQUB &90               \ zTrackSectionOLo       zTrackSectionO = &6590 =  26000
 EQUB 15                \ trackSectionSize

                        \ Track section 18

 EQUB %01110100         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=10 Sh=0
 EQUB &4A               \ xTrackSectionILo       xTrackSectionI = &3F4A =  16202
 EQUB &41               \ yTrackSectionILo       yTrackSectionI = &2041 =   8257
 EQUB &06               \ zTrackSectionILo       zTrackSectionI = &6306 =  25350
 EQUB &E4               \ xTrackSectionOLo       xTrackSectionO = &3EE4 =  16100
 EQUB 10                \ trackSectionFrom
 EQUB &13               \ zTrackSectionOLo       zTrackSectionO = &6413 =  25619
 EQUB 28                \ trackSectionSize

                        \ Track section 19

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &8A               \ xTrackSectionILo       xTrackSectionI = &4B8A =  19338
 EQUB &65               \ yTrackSectionILo       yTrackSectionI = &1E65 =   7781
 EQUB &9E               \ zTrackSectionILo       zTrackSectionI = &679E =  26526
 EQUB &24               \ xTrackSectionOLo       xTrackSectionO = &4B24 =  19236
 EQUB 38                \ trackSectionFrom
 EQUB &AB               \ zTrackSectionOLo       zTrackSectionO = &68AB =  26795
 EQUB 22                \ trackSectionSize

                        \ Track section 20

 EQUB %01110010         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=01 Sh=0
 EQUB &E5               \ xTrackSectionILo       xTrackSectionI = &52E5 =  21221
 EQUB &F2               \ yTrackSectionILo       yTrackSectionI = &1BF2 =   7154
 EQUB &8F               \ zTrackSectionILo       zTrackSectionI = &628F =  25231
 EQUB &05               \ xTrackSectionOLo       xTrackSectionO = &5405 =  21509
 EQUB 20                \ trackSectionFrom
 EQUB &A7               \ zTrackSectionOLo       zTrackSectionO = &62A7 =  25255
 EQUB 69                \ trackSectionSize

                        \ Track section 21

 EQUB %01101101         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &97               \ xTrackSectionILo       xTrackSectionI = &5597 =  21911
 EQUB &5A               \ yTrackSectionILo       yTrackSectionI = &115A =   4442
 EQUB &37               \ zTrackSectionILo       zTrackSectionI = &4237 =  16951
 EQUB &B7               \ xTrackSectionOLo       xTrackSectionO = &56B7 =  22199
 EQUB 9                 \ trackSectionFrom
 EQUB &4F               \ zTrackSectionOLo       zTrackSectionO = &424F =  16975
 EQUB 20                \ trackSectionSize

                        \ Track section 22

 EQUB %01101010         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=01 Sh=0
 EQUB &6F               \ xTrackSectionILo       xTrackSectionI = &536F =  21359
 EQUB &C4               \ yTrackSectionILo       yTrackSectionI = &10C4 =   4292
 EQUB &41               \ zTrackSectionILo       zTrackSectionI = &3941 =  14657
 EQUB &69               \ xTrackSectionOLo       xTrackSectionO = &5469 =  21609
 EQUB 29                \ trackSectionFrom
 EQUB &B0               \ zTrackSectionOLo       zTrackSectionO = &38B0 =  14512
 EQUB 80                \ trackSectionSize

                        \ Track section 23

 EQUB %11110011         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &AF               \ xTrackSectionILo       xTrackSectionI = &40AF =  16559
 EQUB &17               \ yTrackSectionILo       yTrackSectionI = &1817 =   6167
 EQUB &C1               \ zTrackSectionILo       zTrackSectionI = &18C1 =   6337
 EQUB &A9               \ xTrackSectionOLo       xTrackSectionO = &41A9 =  16809
 EQUB 29                \ trackSectionFrom
 EQUB &30               \ zTrackSectionOLo       zTrackSectionO = &1830 =   6192
 EQUB 12                \ trackSectionSize

                        \ Track section 24

 EQUB %01101101         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &BC               \ xTrackSectionILo       xTrackSectionI = &40BC =  16572
 EQUB &7B               \ yTrackSectionILo       yTrackSectionI = &1A7B =   6779
 EQUB &5C               \ zTrackSectionILo       zTrackSectionI = &135C =   4956
 EQUB &BD               \ xTrackSectionOLo       xTrackSectionO = &41BD =  16829
 EQUB 1                 \ trackSectionFrom
 EQUB &DD               \ zTrackSectionOLo       zTrackSectionO = &13DD =   5085
 EQUB 24                \ trackSectionSize

                        \ Track section 25

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &48               \ xTrackSectionILo       xTrackSectionI = &3E48 =  15944
 EQUB &17               \ yTrackSectionILo       yTrackSectionI = &1E17 =   7703
 EQUB &C0               \ zTrackSectionILo       zTrackSectionI = &08C0 =   2240
 EQUB &3D               \ xTrackSectionOLo       xTrackSectionO = &3F3D =  16189
 EQUB 25                \ trackSectionFrom
 EQUB &28               \ zTrackSectionOLo       zTrackSectionO = &0828 =   2088
 EQUB 29                \ trackSectionSize

                        \ Track section 26

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &25               \ xTrackSectionILo       xTrackSectionI = &3725 =  14117
 EQUB &73               \ yTrackSectionILo       yTrackSectionI = &1F73 =   8051
 EQUB &32               \ zTrackSectionILo       zTrackSectionI = &FD32 =   -718
 EQUB &1A               \ xTrackSectionOLo       xTrackSectionO = &381A =  14362
 EQUB 14                \ trackSectionFrom
 EQUB &9A               \ zTrackSectionOLo       zTrackSectionO = &FC9A =   -870
 EQUB 25                \ trackSectionSize

 EQUB &42               \ This byte appears to be unused

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

 EQUB &B5, &B8          \ These bytes appear to be unused

\ ******************************************************************************
\
\       Name: trackSectionCount
\       Type: Variable
\   Category: Extra track data
\    Summary: The total number of track sections * 8
\  Deep dive: The track data file format
\
\ ******************************************************************************

 EQUB 27 * 8

\ ******************************************************************************
\
\       Name: trackVectorCount
\       Type: Variable
\   Category: Track data
\    Summary: The total number of segment vectors in the segment vector tables
\  Deep dive: The track data file format
\
\ ******************************************************************************

 EQUB 40

\ ******************************************************************************
\
\       Name: trackLength
\       Type: Variable
\   Category: Track data
\    Summary: The length of the full track in terms of segments
\  Deep dive: The track data file format
\
\ ------------------------------------------------------------------------------
\
\ The highest segment number is this value minus 1, as segment numbers start
\ from zero.
\
\ ******************************************************************************

 EQUW 982               \ Segments are numbered from 0 to 981

\ ******************************************************************************
\
\       Name: trackStartLine
\       Type: Variable
\   Category: Track data
\    Summary: The segment number of the starting line
\  Deep dive: The track data file format
\
\ ------------------------------------------------------------------------------
\
\ This is the segment number of the starting line, expressed as the number of
\ segments from the starting line to the start of section 0, counting forwards
\ around the track.
\
\ If the starting line is at segment n, this value is the track length minus n.
\
\ ******************************************************************************

 EQUW 982 - 38          \ The starting line is at segment 38

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

 EQUB 69                \ Set class to Novice if slowest lap time > 1:69

 EQUB 65                \ Set class to Amateur if slowest lap time > 1:65

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

 EQUB 1                 \ Set class to Novice if slowest lap time > 1:69

 EQUB 1                 \ Set class to Amateur if slowest lap time > 1:65

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

 EQUB 72                \ Reverse

 EQUB 0                 \ Neutral

 EQUB 72                \ First gear

 EQUB 47                \ Second gear

 EQUB 40                \ Third gear

 EQUB 35                \ Fourth gear

 EQUB 30                \ Fifth gear

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

 EQUB 168               \ Reverse

 EQUB 0                 \ Neutral

 EQUB 168               \ First gear

 EQUB 111               \ Second gear

 EQUB 93                \ Third gear

 EQUB 82                \ Fourth gear

 EQUB 70                \ Fifth gear

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

 EQUB 194               \ Base speed for Novice

 EQUB 211               \ Base speed for Amateur

 EQUB 220               \ Base speed for Professional

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

 EQUB 4

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

 EQUB 33

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

 EQUB 25

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
\       Name: HookFirstSegment
\       Type: Subroutine
\   Category: Extra track data
\    Summary: Move to the next to the next segment vector along the track and
\             calculate the segment vector
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from GetFirstSegment so we do the following when
\ fetching the first segment in a section:
\
\   * Move to the next to the next segment vector along the track
\
\   * Update the sub-section and sub-section segment pointers accordingly
\
\   * Calculate the track segment vector on-the-fly for curved sections
\
\ This ensures that the first segment is set up correctly.
\
\ ******************************************************************************

\ EQUB &20, &7F, &55, &4C, &72, &54

.HookFirstSegment

 JSR MoveToNextVector   \ Move to the next to the next segment vector along the
                        \ track and update the pointers

 JMP CalcSegmentVector  \ Calculate the segment vector for the current segment
                        \ and put it in the xSegmentVectorI, ySegmentVectorI,
                        \ zSegmentVectorI, xSegmentVectorO and zSegmentVectorO
                        \ tables, returning from the subroutine using a tail
                        \ call

 EQUB &00               \ This byte appears to be unused

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

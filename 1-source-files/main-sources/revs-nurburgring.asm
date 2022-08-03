\ ******************************************************************************
\
\ REVS NÜRBURGRING TRACK SOURCE
\
\ Revs was written by Geoffrey J Crammond and is copyright Acornsoft 1985
\
\ The Nürburgring track, released as part of Revs+ on the Commodore 64, was
\ written by Geoffrey J Crammond and is copyright Firebird 1987
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
playerPitchAngle    = &000D
yStore              = &001B
horizonLine         = &001F
frontSegmentIndex   = &0024
directionFacing     = &0025
segmentCounter      = &0042
playerPastSegment   = &0043
playerHeading       = &0044
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
Multiply8x8         = &0C00
Absolute16Bit       = &0E40
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
xVergeRightLo       = &5E40
xVergeLeftLo        = &5E68
xVergeRightHi       = &5E90
xVergeLeftHi        = &5EB8
vergeDataRight      = &5EE0
vergeDataLeft       = &5F08
yVergeRight         = &5F20
yVergeLeft          = &5F48

\ ******************************************************************************
\
\ REVS NÜRBURGRING TRACK
\
\ Produces the binary file Nurburgring.bin that contains the Nürburgring track.
\
\ ******************************************************************************

ORG CODE%

.trackData

\ ******************************************************************************
\
\       Name: Track section data (Part 1 of 2)
\       Type: Variable
\   Category: Extra tracks
\    Summary: Data for the track sections
\  Deep dive: The track data file format
\             The Nürburgring track
\
\ ------------------------------------------------------------------------------
\
\ The Nürburgring consists of the following track sections:
\
\   0    ||     Romer Kurve to Castrol-S (1/2)
\   1    {}     Romer Kurve to Castrol-S (2/2)
\   2    |->|   Castrol-S (1/2)
\   3    <-     Castrol-S (2/2)
\   4    {}     Castrol-S to Ford Kurve (1/4)
\   5    {}     Castrol-S to Ford Kurve (2/4)
\   6    <-     Castrol-S to Ford Kurve (3/4)
\   7    ||     Castrol-S to Ford Kurve (4/4)
\   8    ->     Ford Kurve
\   9    ||     Ford Kurve top Dunlop Kehre (1/2)
\   10   |<-|   Ford Kurve top Dunlop Kehre (2/2)
\   11   ->     Dunlop Kehre
\   12   {}     Dunlop Kehre to Bit Kurve (1/7)
\   13   <-     Dunlop Kehre to Bit Kurve (2/7)
\   14   ||     Dunlop Kehre to Bit Kurve (3/7)
\   15   ->     Dunlop Kehre to Bit Kurve (4/7)
\   16   {}     Dunlop Kehre to Bit Kurve (5/7)
\   17   <-     Dunlop Kehre to Bit Kurve (6/7)
\   18   ||     Dunlop Kehre to Bit Kurve (7/7)
\   19   ->     Bit Kurve
\   20   {}     Bit Kurve to Veedol Schikane (1/3)
\   21   ->     Bit Kurve to Veedol Schikane (2/3)
\   22   {}     Bit Kurve to Veedol Schikane (3/3)
\   23   <-     Veedol Schikane (1/2)
\   24   ->     Veedol Schikane (2/2)
\   25   {}     Veedol Schikane to Romer Kurve
\   26   ->     Romer Kurve
\
\ where each section is one of the following shapes:
\
\   || is a straight section that doesn't curve to the left or right, and has
\      the same gradient throughout the whole section
\
\   {} is a straight section in the sense that it doesn't curve to the left or
\      right, but the gradient can differ between sub-sections
\
\   -> consists of sub-sections that all curve to the right
\
\   <- consists of sub-sections that all curve to the left
\
\   |->| consists of sub-sections that are either straight or curve to the right
\
\   |<-| consists of sub-sections that are either straight or curve to the left
\
\   |<->| consists of sub-sections that are either straight or curve to the left
\         or right
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
\ Some of the trackDriverSpeed values have been scaled down by a factor of 1.44
\ from the Commodore 64 version. This applies to sections that are followed by
\ sections with bit 7 of trackSectionFlag set.
\
\ Those sections are 1, 5, 7, 10, 16, 18 and 22, and this scaling is noted in
\ the comments below.
\
\ See part 2 of the track section data for each section's trackSectionFlag,
\ where Sp=1 denotes sections with bit 7 of trackSectionFlag set (so we scale
\ trackDriverSpeed in the sections that precede these).
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
 EQUB 101               \ trackDriverSpeed       scaled by 1.44 from the C64

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
 EQUB 125               \ trackDriverSpeed       scaled by 1.44 from the C64

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
 EQUB 84                \ trackDriverSpeed       scaled by 1.44 from the C64

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
 EQUB 77                \ trackDriverSpeed       scaled by 1.44 from the C64

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
 EQUB 108               \ trackDriverSpeed       scaled by 1.44 from the C64

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
 EQUB 112               \ trackDriverSpeed       scaled by 1.44 from the C64

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
 EQUB 134               \ trackDriverSpeed       scaled by 1.44 from the C64

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
 EQUB 88                \ trackDriverSpeed       scaled by 1.44 from the C64

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
\       Name: HookFlattenHills (Part 2 of 3)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Flatten any hills in the verge buffer, calculate the hill height
\             and track width, cut objects off at the hill height
\  Deep dive: An overview of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This part of the routine sets the verge edge to being visible when the car is
\ pointing along the track and the nose is pointing downwards.
\
\ ******************************************************************************

.hill4

 LDA playerHeading      \ Set A to the player's heading along the track, which
                        \ is an angle that represents the direction in which our
                        \ car is facing with respect to the track, like this:
                        \
                        \            0
                        \      -32   |   +32         Overhead view of car
                        \         \  |  /
                        \          \ | /             0 = looking straight ahead
                        \           \|/              +64 = looking sharp right
                        \   -64 -----+----- +64      -64 = looking sharp left
                        \           /|\
                        \          / | \
                        \         /  |  \
                        \      -96   |   +96
                        \           128
                        \
                        \ An angle of 0 means our car is facing forwards along
                        \ the track, while an angle of +32 means we are facing
                        \ 45 degrees to the right of straight on, and an angle
                        \ of 128 means we are facing backwards along the track

 JSR Absolute8Bit       \ Set A = |A|, which reflects the angle into
                        \ the right half of the above diagram:
                        \
                        \            0
                        \            |   32
                        \            |  /
                        \            | /
                        \            |/
                        \            +----- 64
                        \            |\
                        \            | \
                        \            |  \
                        \            |   96
                        \           127

 CMP #25                \ If A >= 25, then the car is pointing to a greater
 BCS hill5              \ angle than 25 to either side of dead ahead (i.e. it is
                        \ is pointing outside of the -24 to +24 field of view,
                        \ or greater than 33 degrees either side of 0), so jump
                        \ to hill5 to call CheckVergeOnScreen in the usual way

 LDA playerPitchAngle   \ If the player's pitch angle is positive, which means
 BPL hill5              \ the car's nose is pointing up, above the horizontal,
                        \ then jump to hill5 to call CheckVergeOnScreen in the
                        \ usual way

                        \ If we get here then the car nose is pointing downwards
                        \ and the car is pointing straight along the track,
                        \ within a -33 to +33 degree field of view

 JMP hill6              \ Jump to part 3

.hill5

 JMP CheckVergeOnScreen \ Implement the call that we overwrote with the call to
                        \ the hook routine, so we have effectively inserted the
                        \ above code into the main game (the JMP ensures we
                        \ return from the subroutine using a tail call)

\ ******************************************************************************
\
\       Name: HookMoveBack
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Only move the player backwards if the player has not yet driven
\             past the segment
\  Deep dive: An overview of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from MovePlayerSegment to change the behaviour when
\ moving the player backwards along the track.
\
\ Only move the player backwards by one segment if bit 7 of playerPastSegment is
\ clear (in other words, if the player has not yet driven past the segment).
\
\ ******************************************************************************

.HookMoveBack

 BIT playerPastSegment  \ If bit 7 of playerPastSegment is set, return from the
 BMI fovw1-1            \ subroutine (as fovw1-1 contains an RTS)

 JMP MovePlayerBack     \ Move the player backwards by one segment, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: subSection
\       Type: Variable
\   Category: Extra tracks
\    Summary: The number of the current sub-section
\
\ ******************************************************************************

.subSection

 EQUB &EC

\ ******************************************************************************
\
\       Name: trackSubCount
\       Type: Variable
\   Category: Extra tracks
\    Summary: The total number of sub-sections in the track
\
\ ******************************************************************************

.trackSubCount

 EQUB 45

\ ******************************************************************************
\
\       Name: yawAngleLo
\       Type: Variable
\   Category: Extra tracks
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
\   Category: Extra tracks
\    Summary: High byte of the current yaw angle of the track, i.e. the angle at
\             which the track is pointing along the ground
\
\ ******************************************************************************

.yawAngleHi

 EQUB &04

\ ******************************************************************************
\
\       Name: segmentSlope
\       Type: Variable
\   Category: Extra tracks
\    Summary: The height above ground of the current track sub-section
\
\ ******************************************************************************

.segmentSlope

 EQUB &F0

\ ******************************************************************************
\
\       Name: subSectionSegment
\       Type: Variable
\   Category: Extra tracks
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
\   Category: Extra tracks
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

 EQUB &61               \ This byte pads the block out to exactly 20 bytes

\ ******************************************************************************
\
\       Name: modifyAddressHi
\       Type: Variable
\   Category: Extra tracks
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

 EQUB &5B               \ This byte pads the block out to exactly 20 bytes

\ ******************************************************************************
\
\       Name: trackYawDeltaHi
\       Type: Variable
\   Category: Extra tracks
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

 EQUB &20               \ This byte appears to be unused

\ ******************************************************************************
\
\       Name: HookFieldOfView
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: When populating the verge buffer in GetSegmentAngles, don't give
\             up so easily when we get segments outside the field of view
\  Deep dive: An overview of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from GetSegmentAngles to change the logic in at label
\ gseg12, which is applied when a segment is outside the field of view. Note
\ that in the following, the previous segment is further away than the current
\ one.
\
\ In the original code:
\
\   * If previous segment's yaw angle >= 20 then the previous segment was also
\     outside the field of view, so return from the subroutine.
\
\   * Otherwise go to gseg4 to try reducing the size of the segment before
\     returning.
\
\ In the new code:
\
\   * If previous segment's yaw angle >= 20 and segmentCounter >= 10, then the
\     previous segment was also outside the field of view AND we have already
\     marked at least 10 segments as being visible, so return from the
\     subroutine.
\
\   * Otherwise go to gseg13 to mark this segment as visible and keep checking
\     segments.
\
\ So in the modified version, we keep checking segments until we have reached at
\ least 10.
\
\ Arguments:
\
\   A                   Yaw angle for the previous segment's right verge
\
\   C flag              Set according to CMP #20
\
\ ******************************************************************************

.HookFieldOfView

 BCC fovw1              \ If A < 20, then this segment is within the 20-degree
                        \ field of view,jump to gseg13 via fovw1

 LDA segmentCounter     \ If segmentCounter < 10, jump to gseg13 via fovw1
 CMP #10
 BCC fovw1

 RTS                    \ Return from the subroutine

.fovw1

 JMP gseg13             \ Jump to gseg13

\ ******************************************************************************
\
\       Name: trackSignData
\       Type: Variable
\   Category: Track data
\    Summary: Base coordinates and object types for 16 road signs
\  Deep dive: The track data file format
\             The Nürburgring track
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
\   Category: Extra tracks
\    Summary: Calculate the segment vector for the current segment
\  Deep dive: Dynamic track generation in the extra tracks
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
                        \ want to build, and we already know the y-coordinate of
                        \ the vector at this point (it's in segmentSlope)
                        \
                        \ The inner track segment vector at this point is
                        \ therefore:
                        \
                        \   [       V      ]
                        \   [ segmentSlope ]
                        \   [       W      ]
                        \
                        \ And we can now store the vector in the track data file
                        \ as follows:
                        \
                        \   * xTrackSegmentI = V
                        \   * yTrackSegmentI = segmentSlope
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

 LDA segmentSlope       \ Set the y-coordinate of the Y-th track segment vector
 STA yTrackSegmentI,Y   \ to the slope of the segment

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: HookDataPointers
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: If the current section is dynamically generated, update the data
\             pointers
\  Deep dive: An overview of the extra tracks
\             Dynamic track generation in the extra tracks
\             Code hooks in the extra tracks
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

\ ******************************************************************************
\
\       Name: HookFlipAbsolute
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Set the sign of A according to the direction we are facing along
\             the track
\  Deep dive: An overview of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from MovePlayerOnTrack so that the yaw angle of the
\ closest segment retains the correct sign, like this:
\
\   * If we are facing forwards along the track, set A = |A|
\
\   * If we are facing backwards along the track, set A = -|A|
\
\ ******************************************************************************

.HookFlipAbsolute

 EOR directionFacing    \ Flip the sign bit of A if we are facing backwards
                        \ along the track
                        \
                        \ The Absolute8Bit routine does the following:
                        \
                        \   * If A is positive leave it alone
                        \
                        \   * If A is negative, set A = -A
                        \
                        \ So if bit 7 of directionFacing is set (i.e. we are
                        \ facing backwards along the track), this flips bit 7 of
                        \ A, which changes the Absolute8Bit routine to the
                        \ following (if we consider the original value of A):
                        \
                        \   * If A is negative leave it alone
                        \
                        \   * If A is positive, set A = -A
                        \
                        \ So this sets set A = -|A| instead  of A = |A|

 JSR Absolute8Bit       \ Set A = |A|, unless we are facing backwards along the
                        \ track, in which case set A = -|A|

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: newContentLo
\       Type: Variable
\   Category: Extra tracks
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

 EQUB &00               \ This byte pads the block out to exactly 20 bytes

\ ******************************************************************************
\
\       Name: newContentHi
\       Type: Variable
\   Category: Extra tracks
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

 EQUB &00               \ This byte pads the block out to exactly 20 bytes

\ ******************************************************************************
\
\       Name: trackYawDeltaLo
\       Type: Variable
\   Category: Extra tracks
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
\   Category: Extra tracks
\    Summary: Set the horizonTrackWidth to 80% of the width of the track on the
\             horizon
\  Deep dive: An overview of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from GetTrackAndMarkers to set the horizonTrackWidth to
\ 80% of the width of the track on the horizon.
\
\ ******************************************************************************

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
\   Category: Extra tracks
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
\   Category: Extra tracks
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
\   Category: Extra tracks
\    Summary: If the current section is dynamically generated, move to the next
\             segment vector, calculate it and store it
\  Deep dive: An overview of the extra tracks
\             Dynamic track generation in the extra tracks
\             Code hooks in the extra tracks
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
\   Category: Extra tracks
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
\   Category: Extra tracks
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
\   Category: Extra tracks
\    Summary: Add the yaw angle and height deltas to the yaw angle and height
\             (for curved sections) and calculate the segment vector
\  Deep dive: Dynamic track generation in the extra tracks
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

 LDA trackSlopeDelta,Y  \ Set A to the change in slope for this sub-section
                        \ (i.e. the change in the gradient over the course of
                        \ each segment in the sub-section)

 BIT directionFacing    \ Set the N flag to the sign of directionFacing, so the
                        \ call to Absolute8Bit sets the sign of A to
                        \ abs(directionFacing)

 JSR Absolute8Bit       \ Set the sign of A to match the sign bit in
                        \ directionFacing, so this negates A if we are facing
                        \ backwards along the track

 CLC                    \ Set segmentSlope = segmentSlope + A
 ADC segmentSlope       \                  = segmentSlope + trackSlopeDelta
 STA segmentSlope

.sets1

 JSR CalcSegmentVector  \ Calculate the segment vector for the current segment
                        \ and put it in the xSegmentVectorI, ySegmentVectorI,
                        \ zSegmentVectorI, xSegmentVectorO and zSegmentVectorO
                        \ tables

 LDX xStore             \ Retrieve the value of X we stores above, so we can
                        \ return it unchanged by the routine

 RTS                    \ Return from the subroutine

 EQUB &0D, &0A          \ These bytes appear to be unused
 EQUB &07, &03
 EQUB &00, &00
 EQUB &00

\ ******************************************************************************
\
\       Name: ModifyGameCode (Part 3 of 3)
\       Type: Subroutine
\   Category: Extra tracks
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

 LDA #4                 \ ?&3574 = 4 (object dimension in objectTop)
 STA &3574

 LDA #11                \ ?&35F4 = 11 (object dimension in objectBottom)
 STA &35F4

 LDA #LO(HookSlopeJump) \ !&45CC = HookSlopeJump (address in a JSR instruction)
 STA &45CC
 LDA #HI(HookSlopeJump)
 STA &45CD

 LDA #75                \ ?&2772 = 75 (argument in a CMP #75 instruction)
 STA &2772

 LDA #&FF               \ ?&298E = &FF (argument in an AND #&FF instruction)
 STA &298E

 RTS                    \ Return from the subroutine

 EQUB &6F, &73          \ These bytes pad the routine out to exactly 40 bytes
 EQUB &75, &74
 EQUB &6F, &66
 EQUB &5B, &52
 EQUB &4E

\ ******************************************************************************
\
\       Name: trackSlopeDelta
\       Type: Variable
\   Category: Extra tracks
\    Summary: The change in the slope (i.e. the change in the gradient) over the
\             course of each segment for each sub-section of the track
\
\ ******************************************************************************

.trackSlopeDelta

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
\       Name: HookFlattenHills (Part 3 of 3)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Flatten any hills in the verge buffer, calculate the hill height
\             and track width, cut objects off at the hill height
\  Deep dive: An overview of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This part of the routine flags the verge coordinate at index X as being
\ visible on-screen, but only when the track section at the front of the segment
\ buffer is one of sections 0 to 5.
\
\ ******************************************************************************

.hill6

 LDA objTrackSection+23 \ Set A to the number * 8 of the track section for the
                        \ front segment of the track segment buffer

 CMP #48                \ If A >= 48, i.e. the front segment of the track
 BCS hill7              \ segment buffer is track section 6 or later, jump to
                        \ hill7 to call CheckVergeOnScreen

                        \ Otherwise we replace the call to CheckVergeOnScreen
                        \ with the following, which clears bit 7 of V to flag
                        \ the verge coordinate at index X as being visible
                        \ on-screen

 LSR V                  \ Clear bit 7 of V

 RTS                    \ Return from the subroutine

.hill7

 JMP CheckVergeOnScreen \ Implement the call that we overwrote with the call to
                        \ the hook routine, so we have effectively inserted the
                        \ above code into the main game (the JMP ensures we
                        \ return from the subroutine using a tail call)

\ ******************************************************************************
\
\       Name: yTrackSignVector
\       Type: Variable
\   Category: Extra tracks
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
\   Category: Extra tracks
\    Summary: Initialise and calculate the current segment vector
\  Deep dive: An overview of the extra tracks
\             Dynamic track generation in the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from GetSectionCoords when fetching the coordinates for
\ a track section. It initialises the segment vector calculation process by
\ doing the following:
\
\   * Fetch the section's yaw angle from the trackYawAngle tables
\
\   * Fetch the section's slope from the trackSlope table
\
\   * Initialise the sub-section and sub-section segment variables
\
\   * Modify the GetSectionAngles routine so the horizon level check is skipped
\     if the section's trackSubConfig has bit 1 set
\
\   * If we are facing forwards along the track, calculate and store the current
\     segment vector
\
\ Arguments:
\
\   Y                   The number of the track section * 8 whose coordinates we
\                       want to fetch
\
\ ******************************************************************************

.HookSectionFrom

 STY yStore             \ Store the section number in yStore, so we can retrieve
                        \ it at the end of the hook routine

 LDA trackSectionFrom,Y \ Set thisVectorNumber = the Y-th trackSectionFrom, just
 STA thisVectorNumber   \ like the code that we overwrote with the call to the
                        \ hook routine

 TYA                    \ Set Y = Y / 8
 LSR A                  \
 LSR A                  \ So Y now contains the number of the track section (as
 LSR A                  \ trackSectionFrom contains the track section * 8)
 TAY

 LDA trackYawAngleLo,Y  \ Set (yawAngleHi yawAngleLo) to this section's entry
 STA yawAngleLo         \ from (trackYawAngleHi trackYawAngleLo)
 LDA trackYawAngleHi,Y
 STA yawAngleHi

 LDA trackSlope,Y       \ Set segmentSlope to this section's entry from
 STA segmentSlope       \ trackSlope

 LDA trackSubConfig,Y   \ Set A to this section's configuration byte

 LSR A                  \ Set A = A >> 2, with bit 6 cleared, bit 7 set to the
 ROR A                  \ bit 0 of the trackSubConfig entry, and the C flag set
                        \ to bit 1 of the trackSubConfig entry

 STA subSection         \ Store A in subSection, so it contains the index
                        \ from bits 2-7 of trackSubConfig, and bit 7 is set if
                        \ bit 0 of trackSubConfig is set

 LDA #14                \ Set A = 7, with bit 7 set to the C flag (so if this
 ROR A                  \ section's trackSubConfig has bit 1 set, then A is 135,
                        \ otherwise it is 7)

 STA &23B3              \ Modify the GetSectionAngles routine, at instruction
                        \ #4 after gsec11, to test prevHorizonIndex against the
                        \ value we just calculated in A rather than 7
                        \
                        \ So if this section's trackSubConfig has bit 1 set, the
                        \ test becomes prevHorizonIndex <= 135, which is always
                        \ true, so this modification makes us never set the
                        \ horizon line to 7 for sections that have bit 1 of
                        \ trackSubConfig set

 LDA #0                 \ Set subSectionSegment = 0, so we start counting from
 STA subSectionSegment  \ the first segment in the sub-section

 BIT directionFacing    \ If we are facing backwards along the track, jump to
 BMI from1              \ from1 to skip the following call to SetSegmentVector

 JSR SetSegmentVector   \ We are facing forwards along the track, so calculate
                        \ and store the current segment vector

.from1

 LDY yStore             \ Retrieve the section number from yStore

 LDA thisVectorNumber   \ Set A to the Y-th trackSectionFrom that we set above,
                        \ so the routine sets A to the segment vector number,
                        \ just like the code that we overwrote with the call to
                        \ the hook routine

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: HookJoystick (Part 2 of 2)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Apply enhanced joystick steering to specific track sections
\  Deep dive: An overview of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This part of the routine scales the steering, but if the joystick x-axis high
\ byte is zero, then the scaling is applied in a different way. Instad of this:
\
\     2 * (scale * x-axis) ^ 2
\   = 2 * scale ^2 * x-axis ^2
\
\ we return this:
\
\   scale ^2 * x-axis
\
\ in other words, we divide the scale factor by 2 * x-axis.
\
\ ******************************************************************************

.joys4

                        \ By this point, A contains the scale factor to apply to
                        \ the steering, which is one of the following values:
                        \
                        \   * 181 for a scale factor of 1.00
                        \
                        \   * 202 for a scale factor of 1.25
                        \
                        \   * 205 for a scale factor of 1.28
                        \
                        \   * 212 for a scale factor of 1.37

 STA U                  \ Set U = A
                        \
                        \ So U = 181, 202, 205 or 212

 PLA                    \ Set A = joystick x-axis high byte, which we stored on
                        \ the stack at the start of the routine

 JSR Multiply8x8        \ Set (A T) = A * U
                        \           = x-axis * A

 PLP                    \ If the joystick x-axis high byte is zero, which we
 BEQ joys5              \ stored on the stack at the start of the routine, jump
                        \ to joys5 to return x-axis * scale ^ 2 instead

 STA U                  \ Set U = A
                        \       = high byte of A * x-axis

 JSR Multiply8x8        \ Set (A T) = A * U
                        \           = A * A
                        \           = (A * x-axis) ^ 2

 ASL T                  \ Set (A T) = (A T) * 2
 ROL A                  \           = 2 * (A * x-axis) ^ 2

                        \ So for A = 212 we have:
                        \
                        \   (A T) = 2 * (212/256 * x-axis) ^ 2
                        \         = 2 * (0.828 * x-axis) ^ 2
                        \         = 1.37 * x-axis ^ 2
                        \
                        \ and for A = 205 we have:
                        \
                        \   (A T) = 2 * (205/256 * x-axis) ^ 2
                        \         = 2 * (0.801 * x-axis) ^ 2
                        \         = 1.28 * x-axis ^ 2
                        \
                        \ and for A = 202 we have:
                        \
                        \   (A T) = 2 * (202/256 * x-axis) ^ 2
                        \         = 2 * (0.789 * x-axis) ^ 2
                        \         = 1.25 * x-axis ^ 2
                        \
                        \ and for A = 181 we have:
                        \
                        \   (A T) = 2 * (181/256 * x-axis) ^ 2
                        \         = 2 * (0.707 * x-axis) ^ 2
                        \         = 1.00 * x-axis ^ 2

 RTS                    \ Return from the subroutine

.joys5

                        \ If we get here then the joystick x-axis high byte is
                        \ zero, U contains the scale factor and A contains the
                        \ top byte of scale * x-axis

 JMP Multiply8x8        \ Calculate:
                        \
                        \   (A T) = A * U
                        \         = scale * scale * x-axis
                        \
                        \ and return the high byte in A, returning from the
                        \ subroutine using a tail call

\ ******************************************************************************
\
\       Name: HookFlattenHills (Part 1 of 3)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Flatten any hills in the verge buffer, calculate the hill height
\             and track width, cut objects off at the hill height
\  Deep dive: An overview of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from MapSegmentsToLines to flatten the height of the
\ verge entries in the verge buffer that are hidden by the nearest hill to the
\ player, so that the ground behind the nearest hill is effectively levelled
\ off.
\
\ It also sets horizonTrackWidth to 80% of the track width at the hill crest,
\ and sets the verge edge to being visible when the car is pointing along the
\ track and the nose is pointing downwards (though the latter part is only done
\ if we are looking at track sections 0 to 5 down the hill).
\
\ Arguments:
\
\   Y                   Index of the last entry in the track verge buffer - 1:
\
\                         * segmentListRight - 1 for the right verge
\
\                         * segmentListPointer - 1 for the left verge
\
\ ******************************************************************************

.HookFlattenHills

 TYA                    \ Set bit 5 of blockOffset to bit 5 of Y, so blockOffset
 AND #%00100000         \ is non-zero if Y >= 32 (i.e. Y is pointing to the
 STA blockOffset        \ verge buffer for the outer verge edges)

 LDA #0                 \ Set A = 0, so the track line starts at the bottom of
                        \ the screen

                        \ We now work our way backwards through the verge buffer
                        \ from index Y - 1, starting with the closest segments,
                        \ checking the pitch angles and maintaining a maximum
                        \ value in topTrackLine

.hill1

 STA topTrackLine       \ Set topTrackLine = A

.hill2

 DEY                    \ Decrement Y to point to the next entry in the verge
                        \ buffer, so we are moving away from the player

 LDA yVergeRight,Y      \ Set A to the pitch angle of the current entry in the
                        \ verge buffer

 CMP horizonLine        \ If A >= horizonLine, then the verge is on or higher
 BCS hill3              \ than the horizon line, so jump to hill3 to exit the
                        \ hook routine and rejoin the original game code, as
                        \ everything beyond this segment in the verge buffer
                        \ will be hidden

 CMP topTrackLine       \ If A >= topTrackLine, jump back to hill1 to set
 BCS hill1              \ topTrackLine to A and move on to the next segment,
                        \ so topTrackLine maintains the maximum track line as
                        \ we work through the verge buffer

                        \ If we get here then A < horizonLine (so the verge is
                        \ below the horizon) and A < topTrackLine (so the verge
                        \ is lower than the highest segment already processed)
                        \
                        \ In other words, this segment is lower than the ones
                        \ before it, so it is hidden by a hill

 LDA topTrackLine       \ Set the pitch angle of entry Y to topTrackLine (this
 ADC #0                 \ ADC instruction has no effect, as we know the C flag
 STA yVergeRight,Y      \ is clear, so I'm not sure what it's doing here - a
                        \ bit of debug code, perhaps?)

 LDA blockOffset        \ If blockOffset is non-zero, loop back to hill2 to move
 BNE hill2              \ on to the next segment

                        \ If we get here then blockOffset = 0, which will only
                        \ be the case if we are working through the inner verge
                        \ edges (rather than the outer edges), and we haven't
                        \ done the following already
                        \
                        \ In other words, the following is only done once, for
                        \ the closest segment whose pitch angle dips below the
                        \ segment in front of it (i.e. the closest crest of a
                        \ hill)

 LDA topTrackLine       \ Modify the DrawObject routine at dobj3 instruction #6
 STA &1FEA              \ so that objects get cut off at track line number
                        \ topTrackLine instead of horizonLine when they are
                        \ hidden behind a hill

 INY                    \ Increment Y so the call to gtrm2+6 calculates the
                        \ track width for the previous (i.e. closer) segment in
                        \ the verge buffer

 JSR gtrm2+6            \ Call the following routine, which has already been
                        \ modified by this point to calculate the following for
                        \ track segment Y (i.e. the segment in front of the
                        \ current one):
                        \
                        \   horizonTrackWidth
                        \          = 0.8 * |xVergeRightHi - xVergeLeftHi|
                        \
                        \ So this sets horizonTrackWidth to 80% of the track
                        \ width of the crest of the hill

 DEY                    \ Decrement Y back to the correct value for the current
                        \ entry in the verge buffer

 SEC                    \ Rotate a 1 into bit 7 of blockOffset so it is now
 ROR blockOffset        \ non-zero, so we only set horizonTrackWidth once as we
                        \ work through the verge buffer

 BMI hill2              \ Jump back to hill2 (this BMI is effectively a JMP as
                        \ we just set bit 7 of blockOffset)

.hill3

 LDY vergeBufferEnd     \ Set the values of Y and U so they are the same as they
 DEY                    \ would be at this point in the original code, without
 STY U                  \ the above code being run

 JMP hill4              \ Jump to part 2

 EQUB &78, &78          \ These bytes appear to be unused
 EQUB &78, &78
 EQUB &00

\ ******************************************************************************
\
\       Name: ModifyGameCode (Part 1 of 4)
\       Type: Subroutine
\   Category: Extra tracks
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

.ModifyGameCode

 LDX #18                \ We are about to modify 19 two-byte addresses in the
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

 EQUB &C8               \ This byte pads the routine out to exactly 40 bytes

\ ******************************************************************************
\
\       Name: trackSubSize
\       Type: Variable
\   Category: Extra tracks
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

\ ******************************************************************************
\
\       Name: HookUpdateHorizon
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Only update the horizon if we have found fewer than 12 visible
\             segments
\  Deep dive: An overview of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from GetVergeAndMarkers so that we only store
\ horizonLine and horizonListIndex when segmentCounter < 12.
\
\ ******************************************************************************

.HookUpdateHorizon

 PHA                    \ Store A on the stack so we can retrieve it below

 LDA segmentCounter     \ Set the C flag if segmentCounter >= 12
 CMP #12

 PLA                    \ Retrieve the value of A from the stack

 BCS upho1              \ If segmentCounter >= 12, jump to upho1 to skip the
                        \ following two instructions

                        \ Otherwise we set the horizon line and index using the
                        \ same code that we overwrote with the call to the hook
                        \ routine

 STA horizonLine        \ This track segment is higher than the current horizon
                        \ pitch angle, so the track obscures the horizon and we
                        \ need to update horizonLine to this new pitch angle

 STY horizonListIndex   \ Set horizonListIndex to the track segment number in Y

.upho1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: zTrackSignVector
\       Type: Variable
\   Category: Extra tracks
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
\       Name: HookFixHorizon
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Apply the horizon line in A instead of horizonLine
\  Deep dive: An overview of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from GetTrackAndMarkers. It does the following:
\
\  * Cut objects off at the track line in A rather than horizonLine
\
\  * Collapse the left verge of the track into the right verge, but only for a
\    few entries just in front of the horizon section, i.e. for the track
\    section list and the first three entries in the track segment list
\
\  * If the track section at the horizon is one of sections 0 to 5, zero the
\    vergeDataRight and vergeDataLeft entries for the horizon section index to
\    hide the verge
\
\ Arguments:
\
\   A                   The updated value of horizonLine
\
\   Y                   The horizon section index in the verge buffer from
\                       horizonListIndex
\
\ ******************************************************************************

.HookFixHorizon

 STA &1FEA              \ Modify the DrawObject routine at dobj3 instruction #6
                        \ so that objects get cut off at the track line number
                        \ in A instead of horizonLine when they are hidden
                        \ behind a hill

 STA yVergeLeft,Y       \ Set the pitch angle for the left side of the horizon
                        \ line in the track verge buffer to the updated value of
                        \ horizonLine (this is the instruction that we overwrote
                        \ with the call to the hook routine, so this makes sure
                        \ we still do this)

                        \ We now work through the verge buffer from index Y up
                        \ to index 8, and do the following for each entry:
                        \
                        \   * If xVergeRight < xVergeLeft, set
                        \     xVergeRight = xVergeLeft
                        \
                        \   * Set yVergeRight = yVergeLeft
                        \
                        \ This appears to squeeze the left verge of the track
                        \ into the right verge, but only for a few entries just
                        \ in front of the horizon section, i.e. for the track
                        \ section list and the first three entries in the track
                        \ segment list

.coll1

 LDA xVergeRightLo,Y    \ Set A = xVergeRight - xVergeLeft for the horizon
 SEC                    \
 SBC xVergeLeftLo,Y     \ starting with the low bytes

 LDA xVergeRightHi,Y    \ And then the high bytes
 SBC xVergeLeftHi,Y

 BPL coll2              \ If the result is positive, jump to coll2 to skip the
                        \ following

                        \ If we get here then the result is negative, so
                        \ xVergeRight < xVergeLeft

 LDA xVergeRightLo,Y    \ Set xVergeRight = xVergeLeft
 STA xVergeLeftLo,Y
 LDA xVergeRightHi,Y
 STA xVergeLeftHi,Y

.coll2

 LDA yVergeRight,Y      \ Set yVergeRight = yVergeLeft
 STA yVergeLeft,Y

 CPY #6                 \ If the horizon section index >= 6, jump to coll3
 BCS coll3

                        \ If we get here then the track section at the horizon
                        \ is one of sections 0 to 5

 LDA #0                 \ Zero the vergeDataRight and vergeDataLeft entries for
 STA vergeDataRight,Y   \ the horizon section index
 STA vergeDataLeft,Y

.coll3

 INY                    \ Increment the verge buffer index

 CPY #9                 \ Loop back until we have processed up to index 8
 BCC coll1

 LDY horizonListIndex   \ Restore the value of Y that we had on entering the
                        \ hook routine

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: HookSlopeJump
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Jump the car when driving fast over sloping segments
\  Deep dive: An overview of the extra tracks
\             Code hooks in the extra tracks
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

 EQUB &F6, &F3          \ These bytes appear to be unused
 EQUB &F0

\ ******************************************************************************
\
\       Name: xTrackCurve
\       Type: Variable
\   Category: Extra tracks
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
\   Category: Extra tracks
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

 LDA #&A2               \ ?&1FE9 = &A2 (opcode for a LDX # instruction)
 STA &1FE9

 JMP mods3              \ Jump to part 3

 EQUB &28, &34          \ These bytes pad the routine out to exactly 40 bytes
 EQUB &3E, &41
 EQUB &43

\ ******************************************************************************
\
\       Name: trackSlope
\       Type: Variable
\   Category: Extra tracks
\    Summary: The slope at the start of each track section
\
\ ******************************************************************************

.trackSlope

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
\   Category: Extra tracks
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
\   Category: Extra tracks
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
\   Category: Extra tracks
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
\   Category: Extra tracks
\    Summary: The optimum racing line for non-player drivers on each track
\             section
\  Deep dive: The track data file format
\             The Nürburgring track
\
\ ------------------------------------------------------------------------------
\
\ Some of the trackRacingLine values have been scaled down by a factor of 1.44
\ from the Commodore 64 version. This applies to sections that have bit 7 of
\ trackSectionFlag set.
\
\ The scaled sections are 2, 6, 8, 11, 17, 19 and 23.
\
\ See part 2 of the track section data for each section's trackSectionFlag,
\ where Sp=1 denotes sections with bit 7 of trackSectionFlag set.
\
\ ******************************************************************************

.trackRacingLine

 EQUB %00011000         \ Section  0 = 000110 0 0 =  +6 * baseSpeed
 EQUB %00011000         \ Section  1 = 000110 0 0 =  +6 * baseSpeed
 EQUB %01000111         \ Section  2 = 010001 1 1 = -17   (-25 / 1.44)
 EQUB %01001000         \ Section  3 = 010010 0 0 = +18 * baseSpeed
 EQUB %00011001         \ Section  4 = 000110 0 1 =  -6 * baseSpeed
 EQUB %00011001         \ Section  5 = 000110 0 1 =  -6 * baseSpeed
 EQUB %00111010         \ Section  6 = 001110 1 0 = +14   (+20 / 1.44)
 EQUB %00110000         \ Section  7 = 001100 0 0 = +12 * baseSpeed
 EQUB %00110011         \ Section  8 = 001100 1 1 = -12   (-17 / 1.44)
 EQUB %00011000         \ Section  9 = 000110 0 0 =  +6 * baseSpeed
 EQUB %00011000         \ Section 10 = 000110 0 0 =  +6 * baseSpeed
 EQUB %00101011         \ Section 11 = 001010 1 1 = -10   (-10 / 1.44)
 EQUB %00011001         \ Section 12 = 000110 0 1 =  -6 * baseSpeed
 EQUB %00111100         \ Section 13 = 001111 0 0 = +15 * baseSpeed
 EQUB %00000000         \ Section 14 = 000000 0 0 =  +0 * baseSpeed
 EQUB %00111101         \ Section 15 = 001111 0 1 = -15 * baseSpeed
 EQUB %00011001         \ Section 16 = 000110 0 1 =  -6 * baseSpeed
 EQUB %00111010         \ Section 17 = 001110 1 0 = +14   (+20 / 1.44)
 EQUB %01010000         \ Section 18 = 010100 0 0 = +20 * baseSpeed
 EQUB %00111011         \ Section 19 = 001110 1 1 = -14   (-20 / 1.44)
 EQUB %00011000         \ Section 20 = 000110 0 0 =  +6 * baseSpeed
 EQUB %00111101         \ Section 21 = 001111 0 1 = -15 * baseSpeed
 EQUB %00100001         \ Section 22 = 001000 0 1 =  -8 * baseSpeed
 EQUB %01001010         \ Section 23 = 010010 1 0 = +18   (+26 / 1.44)
 EQUB %01110001         \ Section 24 = 011100 0 1 = -28 * baseSpeed
 EQUB %00011000         \ Section 25 = 000110 0 0 =  +6 * baseSpeed
 EQUB %00101111         \ Section 26 = 001011 1 1 = -11   (-16 / 1.44)
 EQUB &18, &A9          \ These bytes appear to be unused
 EQUB &AA, &AA

\ ******************************************************************************
\
\       Name: zTrackCurve
\       Type: Variable
\   Category: Extra tracks
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
\   Category: Extra tracks
\    Summary: Data for the track sections
\  Deep dive: The track data file format
\             The Nürburgring track
\
\ ------------------------------------------------------------------------------
\
\ The Nürburgring consists of the following track sections:
\
\   0    ||     Romer Kurve to Castrol-S (1/2)
\   1    {}     Romer Kurve to Castrol-S (2/2)
\   2    |->|   Castrol-S (1/2)
\   3    <-     Castrol-S (2/2)
\   4    {}     Castrol-S to Ford Kurve (1/4)
\   5    {}     Castrol-S to Ford Kurve (2/4)
\   6    <-     Castrol-S to Ford Kurve (3/4)
\   7    ||     Castrol-S to Ford Kurve (4/4)
\   8    ->     Ford Kurve
\   9    ||     Ford Kurve top Dunlop Kehre (1/2)
\   10   |<-|   Ford Kurve top Dunlop Kehre (2/2)
\   11   ->     Dunlop Kehre
\   12   {}     Dunlop Kehre to Bit Kurve (1/7)
\   13   <-     Dunlop Kehre to Bit Kurve (2/7)
\   14   ||     Dunlop Kehre to Bit Kurve (3/7)
\   15   ->     Dunlop Kehre to Bit Kurve (4/7)
\   16   {}     Dunlop Kehre to Bit Kurve (5/7)
\   17   <-     Dunlop Kehre to Bit Kurve (6/7)
\   18   ||     Dunlop Kehre to Bit Kurve (7/7)
\   19   ->     Bit Kurve
\   20   {}     Bit Kurve to Veedol Schikane (1/3)
\   21   ->     Bit Kurve to Veedol Schikane (2/3)
\   22   {}     Bit Kurve to Veedol Schikane (3/3)
\   23   <-     Veedol Schikane (1/2)
\   24   ->     Veedol Schikane (2/2)
\   25   {}     Veedol Schikane to Romer Kurve
\   26   ->     Romer Kurve
\
\ where each section is one of the following shapes:
\
\   || is a straight section that doesn't curve to the left or right, and has
\      the same gradient throughout the whole section
\
\   {} is a straight section in the sense that it doesn't curve to the left or
\      right, but the gradient can differ between sub-sections
\
\   -> consists of sub-sections that all curve to the right
\
\   <- consists of sub-sections that all curve to the left
\
\   |->| consists of sub-sections that are either straight or curve to the right
\
\   |<-| consists of sub-sections that are either straight or curve to the left
\
\   |<->| consists of sub-sections that are either straight or curve to the left
\         or right
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
\                       given track section (note that because the segment
\                       vectors in this track are dynamically generated, this
\                       value points to the position in the segment vector
\                       table where the section's first vector will be stored
\                       once it is generated)
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
\       Name: HookJoystick (Part 1 of 2)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Apply enhanced joystick steering to specific track sections
\  Deep dive: An overview of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from ProcessDrivingKeys to scale the steering in the
\ following sections to make it easier to steer when using a joystick:
\
\   * Section 8: scale the steering by 1.28
\
\   * Section 11: scale the steering by 1.37
\
\   * Section 26: scale the steering by 1.25
\
\ Specifically, the scaling is applied as follows:
\
\   (A T) = scale_factor * x-axis ^ 2
\
\ which replaces this existing code in ProcessDrivingKeys:
\
\   (A T) = x-axis^2
\
\ Arguments:
\
\   U                   The joystick x-axis high byte
\
\   A                   The joystick x-axis high byte
\
\   Z flag              Set if A = 0
\
\ ******************************************************************************

.HookJoystick

 PHP                    \ Store the status flags and A on the stack, so we can
 PHA                    \ use them in the steering calculation

 LDY currentPlayer      \ Set A to the track section number * 8 for the current
 LDA objTrackSection,Y  \ player

 LDY #181               \ Set Y = 181 so by default we scale the steering by
                        \ 1.00

 CMP #88                \ If the track section <> 88 (i.e. section 11), jump to
 BNE joys1              \ joys1 to keep checking

 LDY #212               \ Set Y = 212 so we scale the steering by 1.37

.joys1

 CMP #64                \ If the track section <> 64 (i.e. section 8), jump to
 BNE joys2              \ joys2 to keep checking

 LDY #205               \ Set Y = 205 so we scale the steering by 1.28

.joys2

 CMP #208               \ If the track section <> 208 (i.e. section 26), jump to
 BNE joys3              \ joys3 to keep checking

 LDY #202               \ Set Y = 202 so we scale the steering by 1.25

.joys3

 TYA                    \ Set A = Y
                        \
                        \ So A is 181, 202, 205 or 212

 JMP joys4              \ Jump to part 2 to scale the steering

 EQUB &B5, &B8          \ These bytes appear to be unused

\ ******************************************************************************
\
\       Name: trackSectionCount
\       Type: Variable
\   Category: Extra tracks
\    Summary: The total number of track sections * 8
\  Deep dive: The track data file format
\             The Nürburgring track
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
\             The Nürburgring track
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
\             The Nürburgring track
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
\             The Nürburgring track
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
\   Category: Extra tracks
\    Summary: Lap times for adjusting the race class (seconds)
\  Deep dive: The track data file format
\             The Nürburgring track
\
\ ------------------------------------------------------------------------------
\
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we change the race class to the relevant difficulty.
\
\ This figure is stored in Binary Coded Decimal (BCD).
\
\ ******************************************************************************

 EQUB &45               \ Set class to Novice if slowest lap time > 1:45

 EQUB &41               \ Set class to Amateur if slowest lap time > 1:41

 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackLapTimeMin
\       Type: Variable
\   Category: Extra tracks
\    Summary: Lap times for adjusting the race class (minutes)
\  Deep dive: The track data file format
\             The Nürburgring track
\
\ ------------------------------------------------------------------------------
\
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we change the race class to the relevant difficulty.
\
\ ******************************************************************************

 EQUB 1                 \ Set class to Novice if slowest lap time > 1:45

 EQUB 1                 \ Set class to Amateur if slowest lap time > 1:41

 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackGearRatio
\       Type: Variable
\   Category: Extra tracks
\    Summary: The gear ratio for each gear
\  Deep dive: The track data file format
\             The Nürburgring track
\
\ ------------------------------------------------------------------------------
\
\ The rev count is calculated by multiplying the track gear ratio by the current
\ speed, so lower gears correspond to more revs at the same wheel speed when
\ compared to higher gears.
\
\ These figures have been scaled up by a factor of 1.44 from the Commodore 64
\ track data, to bring them in line with the other BBC Micro tracks. The values
\ from the Commodore 64 version are 72, 0, 72, 47, 40, 35 and 30.
\
\ ******************************************************************************

 EQUB 104               \ Reverse

 EQUB 0                 \ Neutral

 EQUB 104               \ First gear

 EQUB 68                \ Second gear

 EQUB 58                \ Third gear

 EQUB 51                \ Fourth gear

 EQUB 43                \ Fifth gear

\ ******************************************************************************
\
\       Name: trackGearPower
\       Type: Variable
\   Category: Extra tracks
\    Summary: The power for each gear
\  Deep dive: The track data file format
\             The Nürburgring track
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
\   Category: Extra tracks
\    Summary: The base speed for each race class, used when generating the best
\             racing lines and non-player driver speeds
\  Deep dive: The track data file format
\             The Nürburgring track
\
\ ------------------------------------------------------------------------------
\
\ These figures have been scaled down by a factor of around 2/3 compard to the
\ Commodore 64 track data, so the race times match those from the Commodore 64.
\ The values from the Commodore 64 version are 194, 211 and 220.
\
\ ******************************************************************************

 EQUB 130               \ Base speed for Novice

 EQUB 140               \ Base speed for Amateur

 EQUB 145               \ Base speed for Professional

\ ******************************************************************************
\
\       Name: trackStartPosition
\       Type: Variable
\   Category: Extra tracks
\    Summary: The starting race position of the player during a practice or
\             qualifying lap
\  Deep dive: The track data file format
\             The Nürburgring track
\
\ ******************************************************************************

 EQUB 4

\ ******************************************************************************
\
\       Name: trackCarSpacing
\       Type: Variable
\   Category: Extra tracks
\    Summary: The spacing between the cars at the start of a qualifying lap, in
\             segments
\  Deep dive: The track data file format
\             The Nürburgring track
\
\ ******************************************************************************

 EQUB 33

\ ******************************************************************************
\
\       Name: trackTimerAdjust
\       Type: Variable
\   Category: Extra tracks
\    Summary: Adjustment factor for the speed of the timers to allow for
\             fine-tuning of time on a per-track basis
\  Deep dive: The track data file format
\             The Nürburgring track
\
\ ------------------------------------------------------------------------------
\
\ The value of the timerAdjust variable in the main game code is incremented on
\ every iteration of the main driving loop. When it reaches the value in
\ trackTimerAdjust, the timers add 18/100 of a second rather than 9/100 of
\ a second. Increasing this value therefore speeds up the timers, allowing their
\ speed to be adjusted on a per-track basis.
\
\ Setting this value to 255 disables the timer adjustment.
\
\ The value from the Commodore 64 version is 25.
\
\ ******************************************************************************

 EQUB 50

\ ******************************************************************************
\
\       Name: trackRaceSlowdown
\       Type: Variable
\   Category: Extra tracks
\    Summary: Slowdown factor for non-player drivers in the race
\  Deep dive: The track data file format
\             The Nürburgring track
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
\   Category: Extra tracks
\    Summary: Move to the next to the next segment vector along the track and
\             calculate the segment vector
\  Deep dive: An overview of the extra tracks
\             Dynamic track generation in the extra tracks
\             Code hooks in the extra tracks
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
\   Category: Extra tracks
\    Summary: The track file's hook code
\  Deep dive: The track data file format
\             The Nürburgring track
\
\ ******************************************************************************

.CallTrackHook

 JMP ModifyGameCode     \ Modify the main game code

\ ******************************************************************************
\
\       Name: trackChecksum
\       Type: Variable
\   Category: Extra tracks
\    Summary: The track file's checksum
\  Deep dive: The track data file format
\             The Nürburgring track
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
\   Category: Extra tracks
\    Summary: The game name
\  Deep dive: The track data file format
\             The Nürburgring track
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
\   Category: Extra tracks
\    Summary: The track name
\  Deep dive: The track data file format
\             The Nürburgring track
\
\ ------------------------------------------------------------------------------
\
\ This string is shown on the loading screen.
\
\ ******************************************************************************

.trackName

 EQUS "Nurburgring"     \ Track name
 EQUB 13

 EQUB &00, &00          \ These bytes appear to be unused
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &4C
 EQUB &00, &57
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &00
 EQUB &00, &92
 EQUB &5D, &28
 EQUB &00, &03
 EQUB &33, &00
 EQUB &8B, &3B
 EQUB &80, &00
 EQUB &00, &8B
 EQUB &3B, &80
 EQUB &00, &00
 EQUB &8B, &3B
 EQUB &80, &00
 EQUB &00, &8B
 EQUB &47, &A0
 EQUB &00, &00
 EQUB &8B, &55
 EQUB &E4, &00
 EQUB &00, &8B
 EQUB &2F, &EC
 EQUB &00, &00
 EQUB &8B, &1D
 EQUB &5C, &00
 EQUB &00, &8A
 EQUB &6D, &58
 EQUB &00, &00
 EQUB &8A, &34
 EQUB &D8, &00
 EQUB &00, &8A
 EQUB &14, &28
 EQUB &00, &00
 EQUB &8A, &28
 EQUB &F0, &00
 EQUB &00, &8A
 EQUB &22

\ ******************************************************************************
\
\ Save Nurburgring.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/Nurburgring.bin", CODE%, P%

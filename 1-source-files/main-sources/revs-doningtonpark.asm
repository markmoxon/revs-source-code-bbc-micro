\ ******************************************************************************
\
\ REVS DONINGTON PARK TRACK SOURCE
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
\   * DoningtonPark.bin
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

trackWidth = 134        \ Track width

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
\ REVS DONINGTON PARK TRACK
\
\ Produces the binary file DoningtonPark.bin that contains the Donington Park
\ track.
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
\             The extra tracks data file format
\             The Donington Park track
\
\ ------------------------------------------------------------------------------
\
\ Donington Park consists of the following track sections:
\
\   0    ||     Coppice to Park Chicane (1/2)
\   1    {}     Coppice to Park Chicane (2/2)
\   2    |->|   Park Chicane (1/2)
\   3    <-     Park Chicane (2/2)
\   4    {}     Park Chicane to Redgate (1/2)
\   5    |->|   Park Chicane to Redgate (2/2)
\   6    ->     Redgate
\   7    |->|   Redgate to Craner Curves
\   8    ->     Craner Curves
\   9    {}     Craner Curves to The Old Hairpin (1/3)
\   10   <-     Craner Curves to The Old Hairpin (2/3)
\   11   |->|   Craner Curves to The Old Hairpin (3/3)
\   12   ->     The Old Hairpin
\   13   ||     The Old Hairpin to Macleans (1/6)
\   14   <-     The Old Hairpin to Macleans (2/6)
\   15   |<-|   The Old Hairpin to Macleans (3/6)
\   16   ||     The Old Hairpin to Macleans (4/6)
\   17   <-     The Old Hairpin to Macleans (5/6)
\   18   ->     The Old Hairpin to Macleans (6/6)
\   19   ->     Macleans
\   20   {}     Macleans to Coppice (1/2)
\   21   {}     Macleans to Coppice (2/2)
\   22   ->     Coppice (1/3)
\   23   ->     Coppice (2/3)
\   24   ->     Coppice (3/3)
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
\ ******************************************************************************

                        \ Track section 0

 EQUB &D3               \ trackSectionData       sign = 13, sectionListSize = 3
 EQUB &D1               \ xTrackSectionIHi       xTrackSectionI = &D120 = -12000
 EQUB &1E               \ yTrackSectionIHi       yTrackSectionI = &1E00 =   7680
 EQUB &D1               \ zTrackSectionIHi       zTrackSectionI = &D120 = -12000
 EQUB &D0               \ xTrackSectionOHi       xTrackSectionO = &D024 = -12252
 EQUB 255               \ trackSectionTurn
 EQUB &D1               \ zTrackSectionOHi       zTrackSectionO = &D120 = -12000
 EQUB 255               \ trackDriverSpeed

                        \ Track section 1

 EQUB &E1               \ trackSectionData       sign = 14, sectionListSize = 1
 EQUB &D1               \ xTrackSectionIHi       xTrackSectionI = &D120 = -12000
 EQUB &1C               \ yTrackSectionIHi       yTrackSectionI = &1CC4 =   7364
 EQUB &F6               \ zTrackSectionIHi       zTrackSectionI = &F628 =  -2520
 EQUB &D0               \ xTrackSectionOHi       xTrackSectionO = &D024 = -12252
 EQUB 63                \ trackSectionTurn
 EQUB &F6               \ zTrackSectionOHi       zTrackSectionO = &F628 =  -2520
 EQUB 81                \ trackDriverSpeed

                        \ Track section 2

 EQUB &F3               \ trackSectionData       sign = 15, sectionListSize = 3
 EQUB &D1               \ xTrackSectionIHi       xTrackSectionI = &D120 = -12000
 EQUB &19               \ yTrackSectionIHi       yTrackSectionI = &196C =   6508
 EQUB &15               \ zTrackSectionIHi       zTrackSectionI = &1590 =   5520
 EQUB &D0               \ xTrackSectionOHi       xTrackSectionO = &D024 = -12252
 EQUB 8                 \ trackSectionTurn
 EQUB &15               \ zTrackSectionOHi       zTrackSectionO = &1590 =   5520
 EQUB 0                 \ trackDriverSpeed

                        \ Track section 3

 EQUB &F2               \ trackSectionData       sign = 15, sectionListSize = 2
 EQUB &D3               \ xTrackSectionIHi       xTrackSectionI = &D372 = -11406
 EQUB &19               \ yTrackSectionIHi       yTrackSectionI = &196C =   6508
 EQUB &18               \ zTrackSectionIHi       zTrackSectionI = &1833 =   6195
 EQUB &D3               \ xTrackSectionOHi       xTrackSectionO = &D352 = -11438
 EQUB 18                \ trackSectionTurn
 EQUB &19               \ zTrackSectionOHi       zTrackSectionO = &192C =   6444
 EQUB 10                \ trackDriverSpeed

                        \ Track section 4

 EQUB &04               \ trackSectionData       sign = 0, sectionListSize = 4
 EQUB &D7               \ xTrackSectionIHi       xTrackSectionI = &D742 = -10430
 EQUB &19               \ yTrackSectionIHi       yTrackSectionI = &196C =   6508
 EQUB &1B               \ zTrackSectionIHi       zTrackSectionI = &1B9A =   7066
 EQUB &D6               \ xTrackSectionOHi       xTrackSectionO = &D648 = -10680
 EQUB 255               \ trackSectionTurn
 EQUB &1B               \ zTrackSectionOHi       zTrackSectionO = &1BB5 =   7093
 EQUB 255               \ trackDriverSpeed

                        \ Track section 5

 EQUB &13               \ trackSectionData       sign = 1, sectionListSize = 3
 EQUB &DB               \ xTrackSectionIHi       xTrackSectionI = &DB04 =  -9468
 EQUB &15               \ yTrackSectionIHi       yTrackSectionI = &1544 =   5444
 EQUB &3E               \ zTrackSectionIHi       zTrackSectionI = &3E00 =  15872
 EQUB &DA               \ xTrackSectionOHi       xTrackSectionO = &DA0A =  -9718
 EQUB 45                \ trackSectionTurn
 EQUB &3E               \ zTrackSectionOHi       zTrackSectionO = &3E1B =  15899
 EQUB 91                \ trackDriverSpeed

                        \ Track section 6

 EQUB &23               \ trackSectionData       sign = 2, sectionListSize = 3
 EQUB &DE               \ xTrackSectionIHi       xTrackSectionI = &DE28 =  -8664
 EQUB &14               \ yTrackSectionIHi       yTrackSectionI = &14CC =   5324
 EQUB &54               \ zTrackSectionIHi       zTrackSectionI = &54A8 =  21672
 EQUB &DD               \ xTrackSectionOHi       xTrackSectionO = &DD41 =  -8895
 EQUB 25                \ trackSectionTurn
 EQUB &55               \ zTrackSectionOHi       zTrackSectionO = &550A =  21770
 EQUB 15                \ trackDriverSpeed

                        \ Track section 7

 EQUB &23               \ trackSectionData       sign = 2, sectionListSize = 3
 EQUB &E3               \ xTrackSectionIHi       xTrackSectionI = &E302 =  -7422
 EQUB &14               \ yTrackSectionIHi       yTrackSectionI = &14CC =   5324
 EQUB &57               \ zTrackSectionIHi       zTrackSectionI = &5729 =  22313
 EQUB &E3               \ xTrackSectionOHi       xTrackSectionO = &E34D =  -7347
 EQUB 255               \ trackSectionTurn
 EQUB &58               \ zTrackSectionOHi       zTrackSectionO = &5817 =  22551
 EQUB 138               \ trackDriverSpeed

                        \ Track section 8

 EQUB &35               \ trackSectionData       sign = 3, sectionListSize = 5
 EQUB &ED               \ xTrackSectionIHi       xTrackSectionI = &ED4C =  -4788
 EQUB &14               \ yTrackSectionIHi       yTrackSectionI = &14CC =   5324
 EQUB &50               \ zTrackSectionIHi       zTrackSectionI = &50AD =  20653
 EQUB &ED               \ xTrackSectionOHi       xTrackSectionO = &EDDA =  -4646
 EQUB 255               \ trackSectionTurn
 EQUB &51               \ zTrackSectionOHi       zTrackSectionO = &517C =  20860
 EQUB 255               \ trackDriverSpeed

                        \ Track section 9

 EQUB &45               \ trackSectionData       sign = 4, sectionListSize = 5
 EQUB &F5               \ xTrackSectionIHi       xTrackSectionI = &F597 =  -2665
 EQUB &0D               \ yTrackSectionIHi       yTrackSectionI = &0DF4 =   3572
 EQUB &39               \ zTrackSectionIHi       zTrackSectionI = &39E9 =  14825
 EQUB &F6               \ xTrackSectionOHi       xTrackSectionO = &F68E =  -2418
 EQUB 6                 \ trackSectionTurn
 EQUB &39               \ zTrackSectionOHi       zTrackSectionO = &39BD =  14781
 EQUB 255               \ trackDriverSpeed

                        \ Track section 10

 EQUB &55               \ trackSectionData       sign = 5, sectionListSize = 5
 EQUB &F4               \ xTrackSectionIHi       xTrackSectionI = &F41D =  -3043
 EQUB &0B               \ yTrackSectionIHi       yTrackSectionI = &0B24 =   2852
 EQUB &31               \ zTrackSectionIHi       zTrackSectionI = &319D =  12701
 EQUB &F5               \ xTrackSectionOHi       xTrackSectionO = &F514 =  -2796
 EQUB 30                \ trackSectionTurn
 EQUB &31               \ zTrackSectionOHi       zTrackSectionO = &3171 =  12657
 EQUB 10                \ trackDriverSpeed

                        \ Track section 11

 EQUB &54               \ trackSectionData       sign = 5, sectionListSize = 4
 EQUB &F5               \ xTrackSectionIHi       xTrackSectionI = &F5AB =  -2645
 EQUB &09               \ yTrackSectionIHi       yTrackSectionI = &0926 =   2342
 EQUB &2A               \ zTrackSectionIHi       zTrackSectionI = &2AE7 =  10983
 EQUB &F6               \ xTrackSectionOHi       xTrackSectionO = &F682 =  -2430
 EQUB 35                \ trackSectionTurn
 EQUB &2B               \ zTrackSectionOHi       zTrackSectionO = &2B68 =  11112
 EQUB 120               \ trackDriverSpeed

                        \ Track section 12

 EQUB &64               \ trackSectionData       sign = 6, sectionListSize = 4
 EQUB &FE               \ xTrackSectionIHi       xTrackSectionI = &FE29 =   -471
 EQUB &06               \ yTrackSectionIHi       yTrackSectionI = &0648 =   1608
 EQUB &19               \ zTrackSectionIHi       zTrackSectionI = &19BF =   6591
 EQUB &FF               \ xTrackSectionOHi       xTrackSectionO = &FF13 =   -237
 EQUB 19                \ trackSectionTurn
 EQUB &1A               \ zTrackSectionOHi       zTrackSectionO = &1A16 =   6678
 EQUB 13                \ trackDriverSpeed

                        \ Track section 13

 EQUB &64               \ trackSectionData       sign = 6, sectionListSize = 4
 EQUB &FD               \ xTrackSectionIHi       xTrackSectionI = &FD6F =   -657
 EQUB &06               \ yTrackSectionIHi       yTrackSectionI = &0664 =   1636
 EQUB &16               \ zTrackSectionIHi       zTrackSectionI = &16B0 =   5808
 EQUB &FE               \ xTrackSectionOHi       xTrackSectionO = &FE33 =   -461
 EQUB 32                \ trackSectionTurn
 EQUB &16               \ zTrackSectionOHi       zTrackSectionO = &1612 =   5650
 EQUB 255               \ trackDriverSpeed

                        \ Track section 14

 EQUB &73               \ trackSectionData       sign = 7, sectionListSize = 3
 EQUB &EF               \ xTrackSectionIHi       xTrackSectionI = &EFF5 =  -4107
 EQUB &09               \ yTrackSectionIHi       yTrackSectionI = &0944 =   2372
 EQUB &05               \ zTrackSectionIHi       zTrackSectionI = &05CC =   1484
 EQUB &F0               \ xTrackSectionOHi       xTrackSectionO = &F0B9 =  -3911
 EQUB 29                \ trackSectionTurn
 EQUB &05               \ zTrackSectionOHi       zTrackSectionO = &052E =   1326
 EQUB 14                \ trackDriverSpeed

                        \ Track section 15

 EQUB &73               \ trackSectionData       sign = 7, sectionListSize = 3
 EQUB &EE               \ xTrackSectionIHi       xTrackSectionI = &EEEA =  -4374
 EQUB &09               \ yTrackSectionIHi       yTrackSectionI = &09A4 =   2468
 EQUB &03               \ zTrackSectionIHi       zTrackSectionI = &0337 =    823
 EQUB &EF               \ xTrackSectionOHi       xTrackSectionO = &EFE1 =  -4127
 EQUB 255               \ trackSectionTurn
 EQUB &03               \ zTrackSectionOHi       zTrackSectionO = &030B =    779
 EQUB 255               \ trackDriverSpeed

                        \ Track section 16

 EQUB &73               \ trackSectionData       sign = 7, sectionListSize = 3
 EQUB &ED               \ xTrackSectionIHi       xTrackSectionI = &ED58 =  -4776
 EQUB &0D               \ yTrackSectionIHi       yTrackSectionI = &0D0E =   3342
 EQUB &F8               \ zTrackSectionIHi       zTrackSectionI = &F81B =  -2021
 EQUB &EE               \ xTrackSectionOHi       xTrackSectionO = &EE53 =  -4525
 EQUB 14                \ trackSectionTurn
 EQUB &F8               \ zTrackSectionOHi       zTrackSectionO = &F823 =  -2013
 EQUB 255               \ trackDriverSpeed

                        \ Track section 17

 EQUB &83               \ trackSectionData       sign = 8, sectionListSize = 3
 EQUB &ED               \ xTrackSectionIHi       xTrackSectionI = &EDC8 =  -4664
 EQUB &11               \ yTrackSectionIHi       yTrackSectionI = &11DE =   4574
 EQUB &EA               \ zTrackSectionIHi       zTrackSectionI = &EAFB =  -5381
 EQUB &EE               \ xTrackSectionOHi       xTrackSectionO = &EEC3 =  -4413
 EQUB 33                \ trackSectionTurn
 EQUB &EB               \ zTrackSectionOHi       zTrackSectionO = &EB03 =  -5373
 EQUB 0                 \ trackDriverSpeed

                        \ Track section 18

 EQUB &83               \ trackSectionData       sign = 8, sectionListSize = 3
 EQUB &F0               \ xTrackSectionIHi       xTrackSectionI = &F0F9 =  -3847
 EQUB &14               \ yTrackSectionIHi       yTrackSectionI = &14A8 =   5288
 EQUB &E3               \ zTrackSectionIHi       zTrackSectionI = &E34B =  -7349
 EQUB &F1               \ xTrackSectionOHi       xTrackSectionO = &F1C2 =  -3646
 EQUB 15                \ trackSectionTurn
 EQUB &E3               \ zTrackSectionOHi       zTrackSectionO = &E3E3 =  -7197
 EQUB 114               \ trackDriverSpeed

                        \ Track section 19

 EQUB &93               \ trackSectionData       sign = 9, sectionListSize = 3
 EQUB &F5               \ xTrackSectionIHi       xTrackSectionI = &F583 =  -2685
 EQUB &17               \ yTrackSectionIHi       yTrackSectionI = &1728 =   5928
 EQUB &DB               \ zTrackSectionIHi       zTrackSectionI = &DB2C =  -9428
 EQUB &F6               \ xTrackSectionOHi       xTrackSectionO = &F675 =  -2443
 EQUB 27                \ trackSectionTurn
 EQUB &DB               \ zTrackSectionOHi       zTrackSectionO = &DB6F =  -9361
 EQUB 17                \ trackDriverSpeed

                        \ Track section 20

 EQUB &A3               \ trackSectionData       sign = 10, sectionListSize = 3
 EQUB &F3               \ xTrackSectionIHi       xTrackSectionI = &F3B0 =  -3152
 EQUB &18               \ yTrackSectionIHi       yTrackSectionI = &189B =   6299
 EQUB &D5               \ zTrackSectionIHi       zTrackSectionI = &D5CF = -10801
 EQUB &F4               \ xTrackSectionOHi       xTrackSectionO = &F440 =  -3008
 EQUB 255               \ trackSectionTurn
 EQUB &D5               \ zTrackSectionOHi       zTrackSectionO = &D501 = -11007
 EQUB 255               \ trackDriverSpeed

                        \ Track section 21

 EQUB &A3               \ trackSectionData       sign = 10, sectionListSize = 3
 EQUB &EA               \ xTrackSectionIHi       xTrackSectionI = &EA1E =  -5602
 EQUB &1A               \ yTrackSectionIHi       yTrackSectionI = &1AA9 =   6825
 EQUB &CF               \ zTrackSectionIHi       zTrackSectionI = &CF12 = -12526
 EQUB &EA               \ xTrackSectionOHi       xTrackSectionO = &EAAE =  -5458
 EQUB 27                \ trackSectionTurn
 EQUB &CE               \ zTrackSectionOHi       zTrackSectionO = &CE44 = -12732
 EQUB 111               \ trackDriverSpeed

                        \ Track section 22

 EQUB &B3               \ trackSectionData       sign = 11, sectionListSize = 3
 EQUB &DC               \ xTrackSectionIHi       xTrackSectionI = &DC56 =  -9130
 EQUB &1E               \ yTrackSectionIHi       yTrackSectionI = &1E96 =   7830
 EQUB &C5               \ zTrackSectionIHi       zTrackSectionI = &C55E = -15010
 EQUB &DC               \ xTrackSectionOHi       xTrackSectionO = &DCE6 =  -8986
 EQUB 18                \ trackSectionTurn
 EQUB &C4               \ zTrackSectionOHi       zTrackSectionO = &C490 = -15216
 EQUB 8                 \ trackDriverSpeed

                        \ Track section 23

 EQUB &B3               \ trackSectionData       sign = 11, sectionListSize = 3
 EQUB &DA               \ xTrackSectionIHi       xTrackSectionI = &DA15 =  -9707
 EQUB &1E               \ yTrackSectionIHi       yTrackSectionI = &1E8C =   7820
 EQUB &C5               \ zTrackSectionIHi       zTrackSectionI = &C547 = -15033
 EQUB &D9               \ xTrackSectionOHi       xTrackSectionO = &D9C1 =  -9791
 EQUB 6                 \ trackSectionTurn
 EQUB &C4               \ zTrackSectionOHi       zTrackSectionO = &C45A = -15270
 EQUB 118               \ trackDriverSpeed

                        \ Track section 24

 EQUB &C3               \ trackSectionData       sign = 12, sectionListSize = 3
 EQUB &D7               \ xTrackSectionIHi       xTrackSectionI = &D717 = -10473
 EQUB &1E               \ yTrackSectionIHi       yTrackSectionI = &1E70 =   7792
 EQUB &C6               \ zTrackSectionIHi       zTrackSectionI = &C69E = -14690
 EQUB &D6               \ xTrackSectionOHi       xTrackSectionO = &D6A3 = -10589
 EQUB 37                \ trackSectionTurn
 EQUB &C5               \ zTrackSectionOHi       zTrackSectionO = &C5BD = -14915
 EQUB 14                \ trackDriverSpeed

 EQUB &03, &CF          \ These bytes appear to be unused
 EQUB &14, &BB
 EQUB &CE, &FF
 EQUB &BC, &FF

\ ******************************************************************************
\
\       Name: Multiply80Percent
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Calculate (A T) = 0.80 * A
\
\ ******************************************************************************

.Multiply80Percent

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
\       Name: HookFlipAbsolute
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Set the sign of A according to the direction we are facing along
\             the track
\  Deep dive: Secrets of the extra tracks
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

 JMP Absolute8Bit       \ Set A = |A|, unless we are facing backwards along the
                        \ track, in which case set A = -|A|, and return from the
                        \ subroutine using a tail call

\ ******************************************************************************
\
\       Name: HookJoystick (Part 3 of 3)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Apply enhanced joystick steering to specific track sections
\  Deep dive: Secrets of the extra tracks
\             Code hooks in the extra tracks
\
\ ******************************************************************************

.joys12

                        \ By this point, Y contains the scale factor to apply to
                        \ the steering, which is one of the following values:
                        \
                        \   * 181 for a scale factor of 1.00
                        \
                        \   * 188 for a scale factor of 1.08
                        \
                        \   * 205 for a scale factor of 1.28
                        \
                        \   * 215 for a scale factor of 1.41

 TYA                    \ Set A = Y
                        \
                        \ So A is 181, 188, 205 or 215

 JSR Multiply8x8        \ Set (A T) = A * U
                        \           = A * x-axis

 STA U                  \ Set U = A
                        \       = high byte of A * x-axis

 JSR Multiply8x8        \ Set (A T) = A * U
                        \           = A * A
                        \           = (A * x-axis) ^ 2

 ASL T                  \ Set (A T) = (A T) * 2
 ROL A                  \           = 2 * (A * x-axis) ^ 2

                        \ So for A = 215 we have:
                        \
                        \   (A T) = 2 * (215/256 * x-axis) ^ 2
                        \         = 2 * (0.840 * x-axis) ^ 2
                        \         = 1.41 * x-axis ^ 2
                        \
                        \ and for A = 205 we have:
                        \
                        \   (A T) = 2 * (205/256 * x-axis) ^ 2
                        \         = 2 * (0.8012 * x-axis) ^ 2
                        \         = 1.28 * x-axis ^ 2
                        \
                        \ and for A = 188 we have:
                        \
                        \   (A T) = 2 * (188/256 * x-axis) ^ 2
                        \         = 2 * (0.734 * x-axis) ^ 2
                        \         = 1.08 * x-axis ^ 2
                        \
                        \ and for A = 181 we have:
                        \
                        \   (A T) = 2 * (181/256 * x-axis) ^ 2
                        \         = 2 * (0.707 * x-axis) ^ 2
                        \         = 1.00 * x-axis ^ 2

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: HookForward
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Move the player forward by an extra segment when edgeSegmentNumber
\             is 10
\  Deep dive: Secrets of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from MovePlayerSegment to move the player forward by an
\ extra segment if required.
\
\ Arguments:
\
\   A                   The value of edgeSegmentNumber
\
\ ******************************************************************************

.HookForward

 CMP #11                \ If edgeSegmentNumber >= 11, then the player is either
 BCS move1              \ in the same segment, or has moved backwards, so jump
                        \ to move1

                        \ If we get here then edgeSegmentNumber < 11, so
                        \ edgeSegmentNumber must be 10, so we move the player
                        \ forwards by two segments

 JSR MovePlayerForward  \ Move the player forwards by one segment

.move1

 JMP MovePlayerForward  \ Move the player forwards by one segment, returning
                        \ from the subroutine using a tail call

\ ******************************************************************************
\
\       Name: ModifyGameCode (Part 4 of 4)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Modify the game code to support the extra track data
\
\ ------------------------------------------------------------------------------
\
\ The code modifications are done in four parts.
\
\ ******************************************************************************

.mods4

 STA &4F55              \ ?&4F55 = 22 (argument in a CMP #22 instruction)

 STA &4F59              \ ?&4F59 = 22 (argument in a CMP #22 instruction)

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: subSection
\       Type: Variable
\   Category: Extra tracks
\    Summary: The number of the current sub-section
\
\ ******************************************************************************

.subSection

 EQUB 0

\ ******************************************************************************
\
\       Name: trackSubCount
\       Type: Variable
\   Category: Extra tracks
\    Summary: The total number of sub-sections in the track
\
\ ******************************************************************************

.trackSubCount

 EQUB 58

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

 EQUB 0

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

 EQUB 0

\ ******************************************************************************
\
\       Name: segmentSlope
\       Type: Variable
\   Category: Extra tracks
\    Summary: The height above ground of the current track sub-section
\
\ ******************************************************************************

.segmentSlope

 EQUB 0

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

 EQUB 0

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
 EQUB &D6               \ !&44D6 = trackSteering
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
 EQUB &44               \ !&44D6 = trackSteering
 EQUB &4C               \ !&4CD7 = trackSignData
 EQUB &4C               \ !&4CE1 = trackSignData
 EQUB &19               \ !&1947 = HookFlattenHills
 EQUB &24               \ !&24F3 = HookMoveBack
 EQUB &46               \ !&462C = HookFlipAbsolute
 EQUB &25               \ !&2543 = Hook80Percent
 EQUB &2F               \ !&2F24 = HookBackground

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
 EQUB &00               \ Sub-section  4 = &0000 (    0)
 EQUB &00               \ Sub-section  5 = &0000 (    0)
 EQUB &10               \ Sub-section  6 = &104B ( 4171)
 EQUB &03               \ Sub-section  7 = &0371 (  881)
 EQUB &FE               \ Sub-section  8 = &FE94 ( -364)
 EQUB &FA               \ Sub-section  9 = &FA73 (-1421)
 EQUB &00               \ Sub-section 10 = &0000 (    0)
 EQUB &00               \ Sub-section 11 = &0000 (    0)
 EQUB &00               \ Sub-section 12 = &0000 (    0)
 EQUB &00               \ Sub-section 13 = &0000 (    0)
 EQUB &00               \ Sub-section 14 = &00A9 (  169)
 EQUB &01               \ Sub-section 15 = &01C7 (  455)
 EQUB &02               \ Sub-section 16 = &0294 (  660)
 EQUB &05               \ Sub-section 17 = &0588 ( 1416)
 EQUB &01               \ Sub-section 18 = &0183 (  387)
 EQUB &00               \ Sub-section 19 = &0000 (    0)
 EQUB &01               \ Sub-section 20 = &0153 (  339)
 EQUB &01               \ Sub-section 21 = &016E (  366)
 EQUB &00               \ Sub-section 22 = &00B6 (  182)
 EQUB &00               \ Sub-section 23 = &00AD (  173)
 EQUB &00               \ Sub-section 24 = &00B2 (  178)
 EQUB &00               \ Sub-section 25 = &00FD (  253)
 EQUB &00               \ Sub-section 26 = &0000 (    0)
 EQUB &00               \ Sub-section 27 = &0000 (    0)
 EQUB &FD               \ Sub-section 28 = &FDDE ( -546)
 EQUB &FE               \ Sub-section 29 = &FE46 ( -442)
 EQUB &00               \ Sub-section 30 = &0000 (    0)
 EQUB &00               \ Sub-section 31 = &0000 (    0)
 EQUB &00               \ Sub-section 32 = &0000 (    0)
 EQUB &01               \ Sub-section 33 = &013F (  319)
 EQUB &00               \ Sub-section 34 = &0000 (    0)
 EQUB &06               \ Sub-section 35 = &0605 ( 1541)
 EQUB &FC               \ Sub-section 36 = &FC9F ( -865)
 EQUB &00               \ Sub-section 37 = &0000 (    0)
 EQUB &00               \ Sub-section 38 = &0000 (    0)
 EQUB &FE               \ Sub-section 39 = &FEC1 ( -319)
 EQUB &FE               \ Sub-section 40 = &FE2A ( -470)
 EQUB &FE               \ Sub-section 41 = &FED8 ( -296)
 EQUB &00               \ Sub-section 42 = &005B (   91)
 EQUB &01               \ Sub-section 43 = &0166 (  358)
 EQUB &02               \ Sub-section 44 = &0272 (  626)
 EQUB &04               \ Sub-section 45 = &04BE ( 1214)
 EQUB &04               \ Sub-section 46 = &044B ( 1099)
 EQUB &00               \ Sub-section 47 = &0000 (    0)
 EQUB &00               \ Sub-section 48 = &0000 (    0)
 EQUB &00               \ Sub-section 49 = &0000 (    0)
 EQUB &00               \ Sub-section 50 = &0000 (    0)
 EQUB &00               \ Sub-section 51 = &0000 (    0)
 EQUB &00               \ Sub-section 52 = &0000 (    0)
 EQUB &07               \ Sub-section 53 = &07DD ( 2013)
 EQUB &00               \ Sub-section 54 = &00BC (  188)
 EQUB &02               \ Sub-section 55 = &0224 (  548)
 EQUB &01               \ Sub-section 56 = &0162 (  354)
 EQUB &01               \ Sub-section 57 = &01A4 (  420)

\ ******************************************************************************
\
\       Name: trackSignData
\       Type: Variable
\   Category: Track data
\    Summary: Base coordinates and object types for 16 road signs
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Donington Park track
\
\ ******************************************************************************

.trackSignData

 EQUB %00100001         \ Sign  0: 00100 001   Type 8    Start flag  Section   4
 EQUB %00110100         \ Sign  1: 00110 100   Type 11   Right turn  Section   6
 EQUB %01000000         \ Sign  2: 01000 000   Type 7    Straight    Section   8
 EQUB %01001000         \ Sign  3: 01001 000   Type 7    Straight    Section   9
 EQUB %01010101         \ Sign  4: 01010 101   Type 12   Left turn   Section  10
 EQUB %01100100         \ Sign  5: 01100 100   Type 11   Right turn  Section  12
 EQUB %01110101         \ Sign  6: 01110 101   Type 12   Left turn   Section  14
 EQUB %10001101         \ Sign  7: 10001 101   Type 12   Left turn   Section  17
 EQUB %10011100         \ Sign  8: 10011 100   Type 11   Right turn  Section  19
 EQUB %10100000         \ Sign  9: 10100 000   Type 7    Straight    Section  20
 EQUB %10110100         \ Sign 10: 10110 100   Type 11   Right turn  Section  22
 EQUB %11000000         \ Sign 11: 11000 000   Type 7    Straight    Section  24
 EQUB %00000000         \ Sign 12: 00000 000   Type 7    Straight    Section   0
 EQUB %00001000         \ Sign 13: 00001 000   Type 7    Straight    Section   1
 EQUB %00010011         \ Sign 14: 00010 011   Type 10   Chicane     Section   2
 EQUB %00010000         \ Sign 15: 00010 000   Type 7    Straight    Section   2

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

\ ******************************************************************************
\
\       Name: HookDataPointers
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: If the current section is dynamically generated, update the data
\             pointers
\  Deep dive: Secrets of the extra tracks
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

 EQUB &03, &60          \ These bytes appear to be unused

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
 EQUB LO(trackSteering)
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
\   Category: Extra tracks
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
 EQUB HI(trackSteering)
 EQUB HI(trackSignData)
 EQUB HI(trackSignData)
 EQUB HI(HookFlattenHills)
 EQUB HI(HookMoveBack)
 EQUB HI(HookFlipAbsolute)
 EQUB HI(Hook80Percent)
 EQUB HI(HookBackground)

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
 EQUB &00               \ Sub-section  4 = &0000 (    0)
 EQUB &00               \ Sub-section  5 = &0000 (    0)
 EQUB &4B               \ Sub-section  6 = &104B ( 4171)
 EQUB &71               \ Sub-section  7 = &0371 (  881)
 EQUB &94               \ Sub-section  8 = &FE94 ( -364)
 EQUB &73               \ Sub-section  9 = &FA73 (-1421)
 EQUB &00               \ Sub-section 10 = &0000 (    0)
 EQUB &00               \ Sub-section 11 = &0000 (    0)
 EQUB &00               \ Sub-section 12 = &0000 (    0)
 EQUB &00               \ Sub-section 13 = &0000 (    0)
 EQUB &A9               \ Sub-section 14 = &00A9 (  169)
 EQUB &C7               \ Sub-section 15 = &01C7 (  455)
 EQUB &94               \ Sub-section 16 = &0294 (  660)
 EQUB &88               \ Sub-section 17 = &0588 ( 1416)
 EQUB &83               \ Sub-section 18 = &0183 (  387)
 EQUB &00               \ Sub-section 19 = &0000 (    0)
 EQUB &53               \ Sub-section 20 = &0153 (  339)
 EQUB &6E               \ Sub-section 21 = &016E (  366)
 EQUB &B6               \ Sub-section 22 = &00B6 (  182)
 EQUB &AD               \ Sub-section 23 = &00AD (  173)
 EQUB &B2               \ Sub-section 24 = &00B2 (  178)
 EQUB &FD               \ Sub-section 25 = &00FD (  253)
 EQUB &00               \ Sub-section 26 = &0000 (    0)
 EQUB &00               \ Sub-section 27 = &0000 (    0)
 EQUB &DE               \ Sub-section 28 = &FDDE ( -546)
 EQUB &46               \ Sub-section 29 = &FE46 ( -442)
 EQUB &00               \ Sub-section 30 = &0000 (    0)
 EQUB &00               \ Sub-section 31 = &0000 (    0)
 EQUB &00               \ Sub-section 32 = &0000 (    0)
 EQUB &3F               \ Sub-section 33 = &013F (  319)
 EQUB &00               \ Sub-section 34 = &0000 (    0)
 EQUB &05               \ Sub-section 35 = &0605 ( 1541)
 EQUB &9F               \ Sub-section 36 = &FC9F ( -865)
 EQUB &00               \ Sub-section 37 = &0000 (    0)
 EQUB &00               \ Sub-section 38 = &0000 (    0)
 EQUB &C1               \ Sub-section 39 = &FEC1 ( -319)
 EQUB &2A               \ Sub-section 40 = &FE2A ( -470)
 EQUB &D8               \ Sub-section 41 = &FED8 ( -296)
 EQUB &5B               \ Sub-section 42 = &005B (   91)
 EQUB &66               \ Sub-section 43 = &0166 (  358)
 EQUB &72               \ Sub-section 44 = &0272 (  626)
 EQUB &BE               \ Sub-section 45 = &04BE ( 1214)
 EQUB &4B               \ Sub-section 46 = &044B ( 1099)
 EQUB &00               \ Sub-section 47 = &0000 (    0)
 EQUB &00               \ Sub-section 48 = &0000 (    0)
 EQUB &00               \ Sub-section 49 = &0000 (    0)
 EQUB &00               \ Sub-section 50 = &0000 (    0)
 EQUB &00               \ Sub-section 51 = &0000 (    0)
 EQUB &00               \ Sub-section 52 = &0000 (    0)
 EQUB &DD               \ Sub-section 53 = &07DD ( 2013)
 EQUB &BC               \ Sub-section 54 = &00BC (  188)
 EQUB &24               \ Sub-section 55 = &0224 (  548)
 EQUB &62               \ Sub-section 56 = &0162 (  354)
 EQUB &A4               \ Sub-section 57 = &01A4 (  420)

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

 EQUB   4               \ Sign  0 = (  4 << 6, -26 << 4,  79 << 6) + section  0
 EQUB -15               \ Sign  1 = (-15 << 6,   9 << 4, -74 << 6) + section  2
 EQUB -12               \ Sign  2 = (-12 << 6,   8 << 4,  14 << 6) + section  3
 EQUB  -2               \ Sign  3 = ( -2 << 6,  86 << 4,  57 << 6) + section  5
 EQUB   5               \ Sign  4 = (  5 << 6,  52 << 4,  33 << 6) + section  7
 EQUB -17               \ Sign  5 = (-17 << 6,  29 << 4,  49 << 6) + section  9
 EQUB  33               \ Sign  6 = ( 33 << 6, -20 << 4,  42 << 6) + section 12
 EQUB  -2               \ Sign  7 = ( -2 << 6, -52 << 4,  41 << 6) + section 14
 EQUB -10               \ Sign  8 = (-10 << 6, -24 << 4,  29 << 6) + section 14
 EQUB   5               \ Sign  9 = (  5 << 6,   8 << 4,  -4 << 6) + section 14
 EQUB  66               \ Sign 10 = ( 66 << 6, -62 << 4,  41 << 6) + section 18
 EQUB   7               \ Sign 11 = (  7 << 6,  13 << 4, -10 << 6) + section 19
 EQUB   2               \ Sign 12 = (  2 << 6,   8 << 4,  -4 << 6) + section 20
 EQUB   1               \ Sign 13 = (  1 << 6,  11 << 4, -42 << 6) + section 21
 EQUB  -5               \ Sign 14 = ( -5 << 6,  34 << 4, -75 << 6) + section 22
 EQUB   5               \ Sign 15 = (  5 << 6,   8 << 4,  -2 << 6) + section 23

\ ******************************************************************************
\
\       Name: HookSegmentVector
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: If the current section is dynamically generated, move to the next
\             segment vector, calculate it and store it
\  Deep dive: Secrets of the extra tracks
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

 JSR UpdateVectorNumber \ Update thisVectorNumber to the next segment vector
                        \ along the track in the direction we are facing

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
\       Name: HookMoveBack
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Only move the player backwards if the player has not yet driven
\             past the segment
\  Deep dive: Secrets of the extra tracks
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
 BMI HookMoveBack-1     \ subroutine (as HookMoveBack-1 contains an RTS)

 JMP MovePlayerBack     \ Move the player backwards by one segment, returning
                        \ from the subroutine using a tail call

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

\ ******************************************************************************
\
\       Name: ModifyGameCode (Part 3 of 4)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Modify the game code to support the extra track data
\
\ ------------------------------------------------------------------------------
\
\ The code modifications are done in four parts.
\
\ This is also where the zTrackSegmentI table is built, once the modifications
\ have been done. The routine is padded out to be exactly 40 bytes long, so
\ there's one byte for each inner segment z-coordinate.
\
\ ******************************************************************************

.mods3

 LDA #LO(HookForward)   \ !&24DF = HookForward (address in a JSR
 STA &24DF              \          instruction)
 LDA #HI(HookForward)
 STA &24E0

 LDA #LO(HookSlopeJump) \ !&45CC = HookSlopeJump (address in a JSR instruction)
 STA &45CC
 LDA #HI(HookSlopeJump)
 STA &45CD

 LDA #75                \ ?&2772 = 75 (argument in a CMP #75 instruction)
 STA &2772

 LDA #&A9               \ !&1310 = &A9 &88 (LDA #17*8 instruction)
 STA &1310
 LDA #&88
 STA &1311

 LDA #22                \ Set A = 22 to pass to part 4

 JMP mods4              \ Jump to part 4

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

 EQUB &FA               \ Sub-section  0 = -6
 EQUB &01               \ Sub-section  1 =  1
 EQUB &FE               \ Sub-section  2 = -2
 EQUB &02               \ Sub-section  3 =  2
 EQUB &00               \ Sub-section  4 =  0
 EQUB &00               \ Sub-section  5 =  0
 EQUB &00               \ Sub-section  6 =  0
 EQUB &00               \ Sub-section  7 =  0
 EQUB &00               \ Sub-section  8 =  0
 EQUB &00               \ Sub-section  9 =  0
 EQUB &FF               \ Sub-section 10 = -1
 EQUB &00               \ Sub-section 11 =  0
 EQUB &01               \ Sub-section 12 =  1
 EQUB &00               \ Sub-section 13 =  0
 EQUB &00               \ Sub-section 14 =  0
 EQUB &00               \ Sub-section 15 =  0
 EQUB &00               \ Sub-section 16 =  0
 EQUB &00               \ Sub-section 17 =  0
 EQUB &00               \ Sub-section 18 =  0
 EQUB &00               \ Sub-section 19 =  0
 EQUB &FF               \ Sub-section 20 = -1
 EQUB &FE               \ Sub-section 21 = -2
 EQUB &FE               \ Sub-section 22 = -2
 EQUB &FF               \ Sub-section 23 = -1
 EQUB &00               \ Sub-section 24 =  0
 EQUB &00               \ Sub-section 25 =  0
 EQUB &00               \ Sub-section 26 =  0
 EQUB &01               \ Sub-section 27 =  1
 EQUB &00               \ Sub-section 28 =  0
 EQUB &00               \ Sub-section 29 =  0
 EQUB &00               \ Sub-section 30 =  0
 EQUB &02               \ Sub-section 31 =  2
 EQUB &00               \ Sub-section 32 =  0
 EQUB &00               \ Sub-section 33 =  0
 EQUB &00               \ Sub-section 34 =  0
 EQUB &04               \ Sub-section 35 =  4
 EQUB &00               \ Sub-section 36 =  0
 EQUB &02               \ Sub-section 37 =  2
 EQUB &00               \ Sub-section 38 =  0
 EQUB &00               \ Sub-section 39 =  0
 EQUB &00               \ Sub-section 40 =  0
 EQUB &FF               \ Sub-section 41 = -1
 EQUB &00               \ Sub-section 42 =  0
 EQUB &00               \ Sub-section 43 =  0
 EQUB &00               \ Sub-section 44 =  0
 EQUB &FF               \ Sub-section 45 = -1
 EQUB &FF               \ Sub-section 46 = -1
 EQUB &FF               \ Sub-section 47 = -1
 EQUB &00               \ Sub-section 48 =  0
 EQUB &02               \ Sub-section 49 =  2
 EQUB &00               \ Sub-section 50 =  0
 EQUB &FD               \ Sub-section 51 = -3
 EQUB &FF               \ Sub-section 52 = -1
 EQUB &FF               \ Sub-section 53 = -1
 EQUB &00               \ Sub-section 54 =  0
 EQUB &00               \ Sub-section 55 =  0
 EQUB &00               \ Sub-section 56 =  0
 EQUB &00               \ Sub-section 57 =  0

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

 EQUB -26               \ Sign  0 = (  4 << 6, -26 << 4,  79 << 6) + section  0
 EQUB   9               \ Sign  1 = (-15 << 6,   9 << 4, -74 << 6) + section  2
 EQUB   8               \ Sign  2 = (-12 << 6,   8 << 4,  14 << 6) + section  3
 EQUB  86               \ Sign  3 = ( -2 << 6,  86 << 4,  57 << 6) + section  5
 EQUB  52               \ Sign  4 = (  5 << 6,  52 << 4,  33 << 6) + section  7
 EQUB  29               \ Sign  5 = (-17 << 6,  29 << 4,  49 << 6) + section  9
 EQUB -20               \ Sign  6 = ( 33 << 6, -20 << 4,  42 << 6) + section 12
 EQUB -52               \ Sign  7 = ( -2 << 6, -52 << 4,  41 << 6) + section 14
 EQUB -24               \ Sign  8 = (-10 << 6, -24 << 4,  29 << 6) + section 14
 EQUB   8               \ Sign  9 = (  5 << 6,   8 << 4,  -4 << 6) + section 14
 EQUB -62               \ Sign 10 = ( 66 << 6, -62 << 4,  41 << 6) + section 18
 EQUB  13               \ Sign 11 = (  7 << 6,  13 << 4, -10 << 6) + section 19
 EQUB   8               \ Sign 12 = (  2 << 6,   8 << 4,  -4 << 6) + section 20
 EQUB  11               \ Sign 13 = (  1 << 6,  11 << 4, -42 << 6) + section 21
 EQUB  34               \ Sign 14 = ( -5 << 6,  34 << 4, -75 << 6) + section 22
 EQUB   8               \ Sign 15 = (  5 << 6,   8 << 4,  -2 << 6) + section 23

\ ******************************************************************************
\
\       Name: HookSectionFrom
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Initialise and calculate the current segment vector
\  Deep dive: Secrets of the extra tracks
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
\       Name: HookUpdateHorizon
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Only update the horizon if we have found fewer than 12 visible
\             segments
\  Deep dive: Secrets of the extra tracks
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
\       Name: HookFieldOfView
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: When populating the verge buffer in GetSegmentAngles, don't give
\             up so easily when we get segments outside the field of view
\  Deep dive: Secrets of the extra tracks
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
\       Name: HookFlattenHills
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Flatten any hills in the verge buffer, calculate the hill height
\             and track width, cut objects off at the hill height
\  Deep dive: Secrets of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from MapSegmentsToLines to flatten the height of the
\ verge entries in the verge buffer that are hidden by the nearest hill to the
\ player, so that the ground behind the nearest hill is effectively levelled
\ off.
\
\ It also sets horizonTrackWidth to 80% of the track width at the hill crest.
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

 JMP CheckVergeOnScreen \ Implement the call that we overwrote with the call to
                        \ the hook routine, so we have effectively inserted the
                        \ above code into the main game (the JMP ensures we
                        \ return from the subroutine using a tail call)

 EQUB &00               \ This byte appears to be unused

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

 BPL mods1              \ Loop back until we have modified all 20 addresses

 LDA #&4C               \ ?&261A = &4C (opcode for a JMP &xxxx instruction)
 STA &261A

 STA &248B              \ ?&248B = &4C (opcode for a JMP &xxxx instruction)

 JMP mods2              \ Jump to part 2

 EQUB &00               \ This byte pads the routine out to exactly 40 bytes

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

 EQUB 4                 \ Sub-section  0
 EQUB 20                \ Sub-section  1
 EQUB 11                \ Sub-section  2
 EQUB 15                \ Sub-section  3
 EQUB 17                \ Sub-section  4
 EQUB 3                 \ Sub-section  5
 EQUB 3                 \ Sub-section  6
 EQUB 3                 \ Sub-section  7
 EQUB 3                 \ Sub-section  8
 EQUB 9                 \ Sub-section  9
 EQUB 16                \ Sub-section 10
 EQUB 58                \ Sub-section 11
 EQUB 16                \ Sub-section 12
 EQUB 22                \ Sub-section 13
 EQUB 7                 \ Sub-section 14
 EQUB 4                 \ Sub-section 15
 EQUB 4                 \ Sub-section 16
 EQUB 9                 \ Sub-section 17
 EQUB 8                 \ Sub-section 18
 EQUB 18                \ Sub-section 19
 EQUB 4                 \ Sub-section 20
 EQUB 5                 \ Sub-section 21
 EQUB 10                \ Sub-section 22
 EQUB 8                 \ Sub-section 23
 EQUB 18                \ Sub-section 24
 EQUB 9                 \ Sub-section 25
 EQUB 10                \ Sub-section 26
 EQUB 8                 \ Sub-section 27
 EQUB 8                 \ Sub-section 28
 EQUB 7                 \ Sub-section 29
 EQUB 6                 \ Sub-section 30
 EQUB 11                \ Sub-section 31
 EQUB 3                 \ Sub-section 32
 EQUB 6                 \ Sub-section 33
 EQUB 15                \ Sub-section 34
 EQUB 7                 \ Sub-section 35
 EQUB 6                 \ Sub-section 36
 EQUB 14                \ Sub-section 37
 EQUB 3                 \ Sub-section 38
 EQUB 7                 \ Sub-section 39
 EQUB 6                 \ Sub-section 40
 EQUB 12                \ Sub-section 41
 EQUB 12                \ Sub-section 42
 EQUB 8                 \ Sub-section 43
 EQUB 4                 \ Sub-section 44
 EQUB 3                 \ Sub-section 45
 EQUB 6                 \ Sub-section 46
 EQUB 2                 \ Sub-section 47
 EQUB 23                \ Sub-section 48
 EQUB 12                \ Sub-section 49
 EQUB 6                 \ Sub-section 50
 EQUB 13                \ Sub-section 51
 EQUB 5                 \ Sub-section 52
 EQUB 5                 \ Sub-section 53
 EQUB 7                 \ Sub-section 54
 EQUB 5                 \ Sub-section 55
 EQUB 9                 \ Sub-section 56
 EQUB 13                \ Sub-section 57

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

 EQUB  79               \ Sign  0 = (  4 << 6, -26 << 4,  79 << 6) + section  0
 EQUB -74               \ Sign  1 = (-15 << 6,   9 << 4, -74 << 6) + section  2
 EQUB  14               \ Sign  2 = (-12 << 6,   8 << 4,  14 << 6) + section  3
 EQUB  57               \ Sign  3 = ( -2 << 6,  86 << 4,  57 << 6) + section  5
 EQUB  33               \ Sign  4 = (  5 << 6,  52 << 4,  33 << 6) + section  7
 EQUB  49               \ Sign  5 = (-17 << 6,  29 << 4,  49 << 6) + section  9
 EQUB  42               \ Sign  6 = ( 33 << 6, -20 << 4,  42 << 6) + section 12
 EQUB  41               \ Sign  7 = ( -2 << 6, -52 << 4,  41 << 6) + section 14
 EQUB  29               \ Sign  8 = (-10 << 6, -24 << 4,  29 << 6) + section 14
 EQUB  -4               \ Sign  9 = (  5 << 6,   8 << 4,  -4 << 6) + section 14
 EQUB  41               \ Sign 10 = ( 66 << 6, -62 << 4,  41 << 6) + section 18
 EQUB -10               \ Sign 11 = (  7 << 6,  13 << 4, -10 << 6) + section 19
 EQUB  -4               \ Sign 12 = (  2 << 6,   8 << 4,  -4 << 6) + section 20
 EQUB -42               \ Sign 13 = (  1 << 6,  11 << 4, -42 << 6) + section 21
 EQUB -75               \ Sign 14 = ( -5 << 6,  34 << 4, -75 << 6) + section 22
 EQUB  -2               \ Sign 15 = (  5 << 6,   8 << 4,  -2 << 6) + section 23

\ ******************************************************************************
\
\       Name: HookFixHorizon
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Apply the horizon line in A instead of horizonLine
\  Deep dive: Secrets of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from GetTrackAndMarkers to cut objects off at the track
\ line in A rather than horizonLine.
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

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: HookJoystick (Part 1 of 3)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Apply enhanced joystick steering to specific track sections
\  Deep dive: Secrets of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from ProcessDrivingKeys to zero the playerDrift flag
\ when the player is in one of the specified track sections, which has the
\ effect of cancelling drift:
\
\   * Section 2: if the player is in segment 0 or 1, cancel drift
\
\   * Section 11: if the player is in segment 40 or later, cancel drift
\
\   * Section 12: cancel drift
\
\   * Section 21: if the player is in segment 34 or later, cancel drift
\
\   * Section 22: cancel drift
\
\ In addition, scale the steering in the following sections to make it easier
\ to steer when using a joystick:
\
\   * Section 2: scale the steering by 1.41
\
\   * Section 3: scale the steering by 1.28
\
\   * Section 5: scale the steering by 1.08
\
\   * Section 6: scale the steering by 1.08
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
\ ******************************************************************************

.HookJoystick

 LDY currentPlayer      \ Set A to the track section number * 8 for the current
 LDA objTrackSection,Y  \ player

 CMP #16                \ If the track section <> 16 (i.e. section 2), jump to
 BNE joys2              \ joys2 to keep checking

 LDA objSectionSegmt,Y  \ Set A = objSectionSegmt, which keeps track of the
                        \ player's segment number in the current track section

 CMP #2                 \ If A < 2, jump to joys1
 BCC joys1

 LSR playerDrift        \ A = 0 or 1, which means the player is in one of the
                        \ first two segments in the section so clear bit 7 of
                        \ playerDrift to denote that the player is not drifting
                        \ sideways (i.e. cancel any drift)

.joys1

 LDY #215               \ Set Y = 215 so we scale the steering by 1.41

 JMP joys12             \ Jump to part 3 to scale the steering

.joys2

 PHA                    \ Store the player's track section number * 8 on the
                        \ stack so we can retrieve it below

 CMP #88                \ If the track section <> 88 (i.e. section 11), jump to
 BNE joys3              \ joys3 to keep checking

 LDA #39                \ Set A = 39 so we disable drift if the player is in
                        \ segment 40 or later in track section 11

 BNE joys4              \ Jump to joys4 (this BNE is effectively a JMP as A is
                        \ never zero)

.joys3

 CMP #168               \ If the track section <> 168 (i.e. section 21), jump to
 BNE joys5              \ joys5 to keep checking

 LDA #33                \ Set A = 33 so we disable drift if the player is in
                        \ segment 34 or later in track section 21

.joys4

 CMP objSectionSegmt,Y  \ If A < the player's segment number in the current
 BCC joys6              \ track section, jump to joys6 to cancel drift

 BCS joys7              \ Jump to joys7 to keep checking (this BCS is
                        \ effectively a JMP as we just passed through a BCC)

.joys5

 CMP #96                \ If the track section = 96 (i.e. section 12), jump to
 BEQ joys6              \ joys6 to cancel drift

 CMP #176               \ If the track section <> 176 (i.e. section 22), jump to
 BNE joys7              \ joys7 to keep checking

.joys6

 LSR playerDrift        \ Clear bit 7 of playerDrift to denote that the player
                        \ is not drifting sideways (i.e. cancel any drift)

.joys7

 PLA                    \ Retrieve the player's track section number * 8 from
                        \ the stack

 JMP joys8              \ Jump to part 2

\ ******************************************************************************
\
\       Name: Hook80Percent
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Set the horizonTrackWidth to 80% of the width of the track on the
\             horizon
\  Deep dive: Secrets of the extra tracks
\             Code hooks in the extra tracks
\
\ ******************************************************************************

.Hook80Percent

 JSR Absolute8Bit       \ Set A = |A|, so A contains the arc of the track at
                        \ the horizon (i.e. the track width on the section or
                        \ segment at the horizon) in terms of the high bytes
                        \ (this is the same as the original code that we
                        \ overwrote

 JMP Multiply80Percent  \ Set the following:
                        \
                        \   (A T) = 0.80 * A
                        \
                        \ and return from the subroutine using a tail call

 EQUB &4C, &EF          \ These bytes appear to be unused
 EQUB &53

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
\       Name: ModifyGameCode (Part 2 of 4)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Modify the game code to support the extra track data
\
\ ------------------------------------------------------------------------------
\
\ The code modifications are done in four parts.
\
\ This is also where the zTrackSegmentO table is built, once the modifications
\ have been done. The routine is exactly 40 bytes long, so there's one byte for
\ each outer segment z-coordinate.
\
\ ******************************************************************************

.mods2

 LDA #&20               \ ?&1248 = &20 (opcode for a JSR instruction)
 STA &1248

 STA &12FB              \ ?&12FB = &20 (opcode for a JSR instruction)

 STA &2538              \ ?&2538 = &20 (opcode for a JSR instruction)

 STA &45CB              \ ?&45CB = &20 (opcode for a JSR instruction)

 STA &2F23              \ ?&2F23 = &20 (opcode for a JSR instruction)

 LDA #&EA               \ ?&2545 = &EA (opcode for a NOP instruction)
 STA &2545

 LDA #13                \ ?&24EA = 13 (argument in a CMP #13 instruction)
 STA &24EA

 LDA #&A2               \ ?&1FE9 = &A2 (opcode for a LDX # instruction)
 STA &1FE9

 LDA #0                 \ ?&231B = 0 (branch offset in a BEQ instruction)
 STA &231B

 JMP mods3              \ Jump to part 3

\ ******************************************************************************
\
\       Name: trackSlope
\       Type: Variable
\   Category: Extra tracks
\    Summary: The slope at the start of each track section
\
\ ******************************************************************************

.trackSlope

 EQUB &FC               \ Section  0 =  -4
 EQUB &FC               \ Section  1 =  -4
 EQUB &00               \ Section  2 =   0
 EQUB &00               \ Section  3 =   0
 EQUB &00               \ Section  4 =   0
 EQUB &F0               \ Section  5 = -16
 EQUB &00               \ Section  6 =   0
 EQUB &00               \ Section  7 =   0
 EQUB &00               \ Section  8 =   0
 EQUB &D6               \ Section  9 = -42
 EQUB &DE               \ Section 10 = -34
 EQUB &DE               \ Section 11 = -34
 EQUB &F4               \ Section 12 = -12
 EQUB &10               \ Section 13 =  16
 EQUB &10               \ Section 14 =  16
 EQUB &10               \ Section 15 =  16
 EQUB &2C               \ Section 16 =  44
 EQUB &2C               \ Section 17 =  44
 EQUB &20               \ Section 18 =  32
 EQUB &20               \ Section 19 =  32
 EQUB &17               \ Section 20 =  23
 EQUB &15               \ Section 21 =  21
 EQUB &01               \ Section 22 =   1
 EQUB &FC               \ Section 23 =  -4
 EQUB &FC               \ Section 24 =  -4

 EQUB &F9, &E9          \ These bytes appear to be unused
 EQUB &E6, &FF
 EQUB &00

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
 EQUB &34               \ Section  3 = &3B34 = 15156 =  83.3 degrees
 EQUB &FB               \ Section  4 = &04FB =  1275 =   7.0 degrees
 EQUB &FB               \ Section  5 = &04FB =  1275 =   7.0 degrees
 EQUB &B6               \ Section  6 = &10B6 =  4278 =  23.5 degrees
 EQUB &CE               \ Section  7 = &4CCE = 19662 = 108.0 degrees
 EQUB &E6               \ Section  8 = &58E6 = 22758 = 125.0 degrees
 EQUB &45               \ Section  9 = &8745 = 34629 = 190.2 degrees
 EQUB &45               \ Section 10 = &8745 = 34629 = 190.2 degrees
 EQUB &1F               \ Section 11 = &6A1F = 27167 = 149.2 degrees
 EQUB &99               \ Section 12 = &7199 = 29081 = 159.7 degrees
 EQUB &BC               \ Section 13 = &9BBC = 39868 = 219.0 degrees
 EQUB &BC               \ Section 14 = &9BBC = 39868 = 219.0 degrees
 EQUB &76               \ Section 15 = &8776 = 34678 = 190.5 degrees
 EQUB &BD               \ Section 16 = &7EBD = 32445 = 178.2 degrees
 EQUB &BD               \ Section 17 = &7EBD = 32445 = 178.2 degrees
 EQUB &D9               \ Section 18 = &65D9 = 26073 = 143.2 degrees
 EQUB &4D               \ Section 19 = &754D = 30029 = 165.0 degrees
 EQUB &11               \ Section 20 = &A711 = 42769 = 234.9 degrees
 EQUB &11               \ Section 21 = &A711 = 42769 = 234.9 degrees
 EQUB &11               \ Section 22 = &A711 = 42769 = 234.9 degrees
 EQUB &62               \ Section 23 = &CE62 = 52834 = 290.2 degrees
 EQUB &86               \ Section 24 = &D386 = 54150 = 297.5 degrees

 EQUB &96, &8E          \ These bytes appear to be unused
 EQUB &28, &C8
 EQUB &00

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
 EQUB &3B               \ Section  3 = &3B34 = 15156 =  83.3 degrees
 EQUB &04               \ Section  4 = &04FB =  1275 =   7.0 degrees
 EQUB &04               \ Section  5 = &04FB =  1275 =   7.0 degrees
 EQUB &10               \ Section  6 = &10B6 =  4278 =  23.5 degrees
 EQUB &4C               \ Section  7 = &4CCE = 19662 = 108.0 degrees
 EQUB &58               \ Section  8 = &58E6 = 22758 = 125.0 degrees
 EQUB &87               \ Section  9 = &8745 = 34629 = 190.2 degrees
 EQUB &87               \ Section 10 = &8745 = 34629 = 190.2 degrees
 EQUB &6A               \ Section 11 = &6A1F = 27167 = 149.2 degrees
 EQUB &71               \ Section 12 = &7199 = 29081 = 159.7 degrees
 EQUB &9B               \ Section 13 = &9BBC = 39868 = 219.0 degrees
 EQUB &9B               \ Section 14 = &9BBC = 39868 = 219.0 degrees
 EQUB &87               \ Section 15 = &8776 = 34678 = 190.5 degrees
 EQUB &7E               \ Section 16 = &7EBD = 32445 = 178.2 degrees
 EQUB &7E               \ Section 17 = &7EBD = 32445 = 178.2 degrees
 EQUB &65               \ Section 18 = &65D9 = 26073 = 143.2 degrees
 EQUB &75               \ Section 19 = &754D = 30029 = 165.0 degrees
 EQUB &A7               \ Section 20 = &A711 = 42769 = 234.9 degrees
 EQUB &A7               \ Section 21 = &A711 = 42769 = 234.9 degrees
 EQUB &A7               \ Section 22 = &A711 = 42769 = 234.9 degrees
 EQUB &CE               \ Section 23 = &CE62 = 52834 = 290.2 degrees
 EQUB &D3               \ Section 24 = &D386 = 54150 = 297.5 degrees

 EQUB &11, &03          \ These bytes appear to be unused
 EQUB &DF, &F3
 EQUB &00

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

 EQUB %00000001         \ Section  0 = 000000 0 1    From  0  check     straight
 EQUB %00000000         \ Section  1 = 000000 0 0    From  0  check     curve
 EQUB %00010100         \ Section  2 = 000101 0 0    From  5  check     curve
 EQUB %00100000         \ Section  3 = 001000 0 0    From  8  check     curve
 EQUB %00101000         \ Section  4 = 001010 0 0    From 10  check     curve
 EQUB %00110000         \ Section  5 = 001100 0 0    From 12  check     curve
 EQUB %01000000         \ Section  6 = 010000 0 0    From 16  check     curve
 EQUB %01001000         \ Section  7 = 010010 0 0    From 18  check     curve
 EQUB %01010000         \ Section  8 = 010100 0 0    From 20  check     curve
 EQUB %01101000         \ Section  9 = 011010 0 0    From 26  check     curve
 EQUB %01110000         \ Section 10 = 011100 0 0    From 28  check     curve
 EQUB %01111000         \ Section 11 = 011110 0 0    From 30  check     curve
 EQUB %10001100         \ Section 12 = 100011 0 0    From 35  check     curve
 EQUB %10010001         \ Section 13 = 100100 0 1    From 36  check     straight
 EQUB %10010000         \ Section 14 = 100100 0 0    From 36  check     curve
 EQUB %10010100         \ Section 15 = 100101 0 0    From 37  check     curve
 EQUB %10100001         \ Section 16 = 101000 0 1    From 40  check     straight
 EQUB %10100000         \ Section 17 = 101000 0 0    From 40  check     curve
 EQUB %10101000         \ Section 18 = 101010 0 0    From 42  check     curve
 EQUB %10110000         \ Section 19 = 101100 0 0    From 44  check     curve
 EQUB %10111100         \ Section 20 = 101111 0 0    From 47  check     curve
 EQUB %11000100         \ Section 21 = 110001 0 0    From 49  check     curve
 EQUB %11010100         \ Section 22 = 110101 0 0    From 53  check     curve
 EQUB %11011000         \ Section 23 = 110110 0 0    From 54  check     curve
 EQUB %11011100         \ Section 24 = 110111 0 0    From 55  check     curve

 EQUB &DA, &DE          \ These bytes appear to be unused
 EQUB &DA, &E2
 EQUB &00

\ ******************************************************************************
\
\       Name: trackSteering
\       Type: Variable
\   Category: Extra tracks
\    Summary: The optimum steering for non-player drivers on each track section
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Donington Park track
\
\ ------------------------------------------------------------------------------
\
\ The following bytes are copied to sectionSteering by the GetSectionSteering
\ routine, and are processed on the way.
\
\   * Bit 0 becomes bit 7 of the result, to determine the direction of steering
\     (shown with a directional arrow below)
\
\   * Bit 1 clear means the result is multiplied by baseSpeed, so steering on
\     straight sections is proportional to the track speed (this is shown with
\     an asterisk * below)
\
\   * Bits 2 to 7 contain the amount of steering to apply
\
\ The processed values are shown below.
\
\ ******************************************************************************

.trackSteering

 EQUB %00011000         \ Section  0 = 000110 0 0            <- 6*
 EQUB %00011000         \ Section  1 = 000110 0 0            <- 6*
 EQUB %01000111         \ Section  2 = 010001 1 1            -> 17
 EQUB %10000100         \ Section  3 = 100001 0 0            <- 33*
 EQUB %00011000         \ Section  4 = 000110 0 0            <- 6*
 EQUB %00011000         \ Section  5 = 000110 0 0            <- 6*
 EQUB %01000111         \ Section  6 = 010001 1 1            -> 17
 EQUB %00011001         \ Section  7 = 000110 0 1            -> 6*
 EQUB %00011001         \ Section  8 = 000110 0 1            -> 6*
 EQUB %00011001         \ Section  9 = 000110 0 1            -> 6*
 EQUB %01011000         \ Section 10 = 010110 0 0            <- 22*
 EQUB %00100000         \ Section 11 = 001000 0 0            <- 8*
 EQUB %01011111         \ Section 12 = 010111 1 1            -> 23
 EQUB %00110101         \ Section 13 = 001101 0 1            -> 13*
 EQUB %01011000         \ Section 14 = 010110 0 0            <- 22*
 EQUB %00000000         \ Section 15 = 000000 0 0            <- 0*
 EQUB %00000000         \ Section 16 = 000000 0 0            <- 0*
 EQUB %01011000         \ Section 17 = 010110 0 0            <- 22*
 EQUB %01100100         \ Section 18 = 011001 0 0            <- 25*
 EQUB %00111111         \ Section 19 = 001111 1 1            -> 15
 EQUB %00011000         \ Section 20 = 000110 0 0            <- 6*
 EQUB %00011000         \ Section 21 = 000110 0 0            <- 6*
 EQUB %01010011         \ Section 22 = 010100 1 1            -> 20
 EQUB %00011000         \ Section 23 = 000110 0 0            <- 6*
 EQUB %01011001         \ Section 24 = 010110 0 1            -> 22*

 EQUB &18, &18          \ These bytes appear to be unused
 EQUB &18, &18
 EQUB &18, &00

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
\             The extra tracks data file format
\             The Donington Park track
\
\ ------------------------------------------------------------------------------
\
\ Donington Park consists of the following track sections:
\
\   0    ||     Coppice to Park Chicane (1/2)
\   1    {}     Coppice to Park Chicane (2/2)
\   2    |->|   Park Chicane (1/2)
\   3    <-     Park Chicane (2/2)
\   4    {}     Park Chicane to Redgate (1/2)
\   5    |->|   Park Chicane to Redgate (2/2)
\   6    ->     Redgate
\   7    |->|   Redgate to Craner Curves
\   8    ->     Craner Curves
\   9    {}     Craner Curves to The Old Hairpin (1/3)
\   10   <-     Craner Curves to The Old Hairpin (2/3)
\   11   |->|   Craner Curves to The Old Hairpin (3/3)
\   12   ->     The Old Hairpin
\   13   ||     The Old Hairpin to Macleans (1/6)
\   14   <-     The Old Hairpin to Macleans (2/6)
\   15   |<-|   The Old Hairpin to Macleans (3/6)
\   16   ||     The Old Hairpin to Macleans (4/6)
\   17   <-     The Old Hairpin to Macleans (5/6)
\   18   ->     The Old Hairpin to Macleans (6/6)
\   19   ->     Macleans
\   20   {}     Macleans to Coppice (1/2)
\   21   {}     Macleans to Coppice (2/2)
\   22   ->     Coppice (1/3)
\   23   ->     Coppice (2/3)
\   24   ->     Coppice (3/3)
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

 EQUB %00000000         \ trackSectionFlag       Sp=0 G=0 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &20               \ xTrackSectionILo       xTrackSectionI = &D120 = -12000
 EQUB &00               \ yTrackSectionILo       yTrackSectionI = &1E00 =   7680
 EQUB &20               \ zTrackSectionILo       zTrackSectionI = &D120 = -12000
 EQUB &24               \ xTrackSectionOLo       xTrackSectionO = &D024 = -12252
 EQUB 1                 \ trackSectionFrom
 EQUB &20               \ zTrackSectionOLo       zTrackSectionO = &D120 = -12000
 EQUB 79                \ trackSectionSize

                        \ Track section 1

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &20               \ xTrackSectionILo       xTrackSectionI = &D120 = -12000
 EQUB &C4               \ yTrackSectionILo       yTrackSectionI = &1CC4 =   7364
 EQUB &28               \ zTrackSectionILo       zTrackSectionI = &F628 =  -2520
 EQUB &24               \ xTrackSectionOLo       xTrackSectionO = &D024 = -12252
 EQUB 3                 \ trackSectionFrom
 EQUB &28               \ zTrackSectionOLo       zTrackSectionO = &F628 =  -2520
 EQUB 67                \ trackSectionSize

                        \ Track section 2

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &20               \ xTrackSectionILo       xTrackSectionI = &D120 = -12000
 EQUB &6C               \ yTrackSectionILo       yTrackSectionI = &196C =   6508
 EQUB &90               \ zTrackSectionILo       zTrackSectionI = &1590 =   5520
 EQUB &24               \ xTrackSectionOLo       xTrackSectionO = &D024 = -12252
 EQUB 31                \ trackSectionFrom
 EQUB &90               \ zTrackSectionOLo       zTrackSectionO = &1590 =   5520
 EQUB 9                 \ trackSectionSize

                        \ Track section 3

 EQUB %01110011         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &72               \ xTrackSectionILo       xTrackSectionI = &D372 = -11406
 EQUB &6C               \ yTrackSectionILo       yTrackSectionI = &196C =   6508
 EQUB &33               \ zTrackSectionILo       zTrackSectionI = &1833 =   6195
 EQUB &52               \ xTrackSectionOLo       xTrackSectionO = &D352 = -11438
 EQUB 1                 \ trackSectionFrom
 EQUB &2C               \ zTrackSectionOLo       zTrackSectionO = &192C =   6444
 EQUB 12                \ trackSectionSize

                        \ Track section 4

 EQUB %01000100         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=10 Sh=0
 EQUB &42               \ xTrackSectionILo       xTrackSectionI = &D742 = -10430
 EQUB &6C               \ yTrackSectionILo       yTrackSectionI = &196C =   6508
 EQUB &9A               \ zTrackSectionILo       zTrackSectionI = &1B9A =   7066
 EQUB &48               \ xTrackSectionOLo       xTrackSectionO = &D648 = -10680
 EQUB 14                \ trackSectionFrom
 EQUB &B5               \ zTrackSectionOLo       zTrackSectionO = &1BB5 =   7093
 EQUB 74                \ trackSectionSize

                        \ Track section 5

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &04               \ xTrackSectionILo       xTrackSectionI = &DB04 =  -9468
 EQUB &44               \ yTrackSectionILo       yTrackSectionI = &1544 =   5444
 EQUB &00               \ zTrackSectionILo       zTrackSectionI = &3E00 =  15872
 EQUB &0A               \ xTrackSectionOLo       xTrackSectionO = &DA0A =  -9718
 EQUB 9                 \ trackSectionFrom
 EQUB &1B               \ zTrackSectionOLo       zTrackSectionO = &3E1B =  15899
 EQUB 49                \ trackSectionSize

                        \ Track section 6

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &28               \ xTrackSectionILo       xTrackSectionI = &DE28 =  -8664
 EQUB &CC               \ yTrackSectionILo       yTrackSectionI = &14CC =   5324
 EQUB &A8               \ zTrackSectionILo       zTrackSectionI = &54A8 =  21672
 EQUB &41               \ xTrackSectionOLo       xTrackSectionO = &DD41 =  -8895
 EQUB 19                \ trackSectionFrom
 EQUB &0A               \ zTrackSectionOLo       zTrackSectionO = &550A =  21770
 EQUB 13                \ trackSectionSize

                        \ Track section 7

 EQUB %01000010         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=01 Sh=0
 EQUB &02               \ xTrackSectionILo       xTrackSectionI = &E302 =  -7422
 EQUB &CC               \ yTrackSectionILo       yTrackSectionI = &14CC =   5324
 EQUB &29               \ zTrackSectionILo       zTrackSectionI = &5729 =  22313
 EQUB &4D               \ xTrackSectionOLo       xTrackSectionO = &E34D =  -7347
 EQUB 33                \ trackSectionFrom
 EQUB &17               \ zTrackSectionOLo       zTrackSectionO = &5817 =  22551
 EQUB 26                \ trackSectionSize

                        \ Track section 8

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &4C               \ xTrackSectionILo       xTrackSectionI = &ED4C =  -4788
 EQUB &CC               \ yTrackSectionILo       yTrackSectionI = &14CC =   5324
 EQUB &AD               \ zTrackSectionILo       zTrackSectionI = &50AD =  20653
 EQUB &DA               \ xTrackSectionOLo       xTrackSectionO = &EDDA =  -4646
 EQUB 20                \ trackSectionFrom
 EQUB &7C               \ zTrackSectionOLo       zTrackSectionO = &517C =  20860
 EQUB 54                \ trackSectionSize

                        \ Track section 9

 EQUB %01101000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=00 Sh=0
 EQUB &97               \ xTrackSectionILo       xTrackSectionI = &F597 =  -2665
 EQUB &F4               \ yTrackSectionILo       yTrackSectionI = &0DF4 =   3572
 EQUB &E9               \ zTrackSectionILo       zTrackSectionI = &39E9 =  14825
 EQUB &8E               \ xTrackSectionOLo       xTrackSectionO = &F68E =  -2418
 EQUB 35                \ trackSectionFrom
 EQUB &BD               \ zTrackSectionOLo       zTrackSectionO = &39BD =  14781
 EQUB 18                \ trackSectionSize

                        \ Track section 10

 EQUB %01110011         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &1D               \ xTrackSectionILo       xTrackSectionI = &F41D =  -3043
 EQUB &24               \ yTrackSectionILo       yTrackSectionI = &0B24 =   2852
 EQUB &9D               \ zTrackSectionILo       zTrackSectionI = &319D =  12701
 EQUB &14               \ xTrackSectionOLo       xTrackSectionO = &F514 =  -2796
 EQUB 14                \ trackSectionFrom
 EQUB &71               \ zTrackSectionOLo       zTrackSectionO = &3171 =  12657
 EQUB 15                \ trackSectionSize

                        \ Track section 11

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &AB               \ xTrackSectionILo       xTrackSectionI = &F5AB =  -2645
 EQUB &26               \ yTrackSectionILo       yTrackSectionI = &0926 =   2342
 EQUB &E7               \ zTrackSectionILo       zTrackSectionI = &2AE7 =  10983
 EQUB &82               \ xTrackSectionOLo       xTrackSectionO = &F682 =  -2430
 EQUB 30                \ trackSectionFrom
 EQUB &68               \ zTrackSectionOLo       zTrackSectionO = &2B68 =  11112
 EQUB 41                \ trackSectionSize

                        \ Track section 12

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &29               \ xTrackSectionILo       xTrackSectionI = &FE29 =   -471
 EQUB &48               \ yTrackSectionILo       yTrackSectionI = &0648 =   1608
 EQUB &BF               \ zTrackSectionILo       zTrackSectionI = &19BF =   6591
 EQUB &13               \ xTrackSectionOLo       xTrackSectionO = &FF13 =   -237
 EQUB 32                \ trackSectionFrom
 EQUB &16               \ zTrackSectionOLo       zTrackSectionO = &1A16 =   6678
 EQUB 7                 \ trackSectionSize

                        \ Track section 13

 EQUB %00101010         \ trackSectionFlag       Sp=0 G=0 Mc=1 Mlr=01 Vc=01 Sh=0
 EQUB &6F               \ xTrackSectionILo       xTrackSectionI = &FD6F =   -657
 EQUB &64               \ yTrackSectionILo       yTrackSectionI = &0664 =   1636
 EQUB &B0               \ zTrackSectionILo       zTrackSectionI = &16B0 =   5808
 EQUB &33               \ xTrackSectionOLo       xTrackSectionO = &FE33 =   -461
 EQUB 0                 \ trackSectionFrom
 EQUB &12               \ zTrackSectionOLo       zTrackSectionO = &1612 =   5650
 EQUB 46                \ trackSectionSize

                        \ Track section 14

 EQUB %01110011         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &F5               \ xTrackSectionILo       xTrackSectionI = &EFF5 =  -4107
 EQUB &44               \ yTrackSectionILo       yTrackSectionI = &0944 =   2372
 EQUB &CC               \ zTrackSectionILo       zTrackSectionI = &05CC =   1484
 EQUB &B9               \ xTrackSectionOLo       xTrackSectionO = &F0B9 =  -3911
 EQUB 2                 \ trackSectionFrom
 EQUB &2E               \ zTrackSectionOLo       zTrackSectionO = &052E =   1326
 EQUB 6                 \ trackSectionSize

                        \ Track section 15

 EQUB %01000000         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &EA               \ xTrackSectionILo       xTrackSectionI = &EEEA =  -4374
 EQUB &A4               \ yTrackSectionILo       yTrackSectionI = &09A4 =   2468
 EQUB &37               \ zTrackSectionILo       zTrackSectionI = &0337 =    823
 EQUB &E1               \ xTrackSectionOLo       xTrackSectionO = &EFE1 =  -4127
 EQUB 9                 \ trackSectionFrom
 EQUB &0B               \ zTrackSectionOLo       zTrackSectionO = &030B =    779
 EQUB 24                \ trackSectionSize

                        \ Track section 16

 EQUB %00101000         \ trackSectionFlag       Sp=0 G=0 Mc=1 Mlr=01 Vc=00 Sh=0
 EQUB &58               \ xTrackSectionILo       xTrackSectionI = &ED58 =  -4776
 EQUB &0E               \ yTrackSectionILo       yTrackSectionI = &0D0E =   3342
 EQUB &1B               \ zTrackSectionILo       zTrackSectionI = &F81B =  -2021
 EQUB &53               \ xTrackSectionOLo       xTrackSectionO = &EE53 =  -4525
 EQUB 34                \ trackSectionFrom
 EQUB &23               \ zTrackSectionOLo       zTrackSectionO = &F823 =  -2013
 EQUB 28                \ trackSectionSize

                        \ Track section 17

 EQUB %01110011         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &C8               \ xTrackSectionILo       xTrackSectionI = &EDC8 =  -4664
 EQUB &DE               \ yTrackSectionILo       yTrackSectionI = &11DE =   4574
 EQUB &FB               \ zTrackSectionILo       zTrackSectionI = &EAFB =  -5381
 EQUB &C3               \ xTrackSectionOLo       xTrackSectionO = &EEC3 =  -4413
 EQUB 36                \ trackSectionFrom
 EQUB &03               \ zTrackSectionOLo       zTrackSectionO = &EB03 =  -5373
 EQUB 18                \ trackSectionSize

                        \ Track section 18

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &F9               \ xTrackSectionILo       xTrackSectionI = &F0F9 =  -3847
 EQUB &A8               \ yTrackSectionILo       yTrackSectionI = &14A8 =   5288
 EQUB &4B               \ zTrackSectionILo       zTrackSectionI = &E34B =  -7349
 EQUB &C2               \ xTrackSectionOLo       xTrackSectionO = &F1C2 =  -3646
 EQUB 15                \ trackSectionFrom
 EQUB &E3               \ zTrackSectionOLo       zTrackSectionO = &E3E3 =  -7197
 EQUB 20                \ trackSectionSize

                        \ Track section 19

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &83               \ xTrackSectionILo       xTrackSectionI = &F583 =  -2685
 EQUB &28               \ yTrackSectionILo       yTrackSectionI = &1728 =   5928
 EQUB &2C               \ zTrackSectionILo       zTrackSectionI = &DB2C =  -9428
 EQUB &75               \ xTrackSectionOLo       xTrackSectionO = &F675 =  -2443
 EQUB 36                \ trackSectionFrom
 EQUB &6F               \ zTrackSectionOLo       zTrackSectionO = &DB6F =  -9361
 EQUB 13                \ trackSectionSize

                        \ Track section 20

 EQUB %01000010         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=01 Sh=0
 EQUB &B0               \ xTrackSectionILo       xTrackSectionI = &F3B0 =  -3152
 EQUB &9B               \ yTrackSectionILo       yTrackSectionI = &189B =   6299
 EQUB &CF               \ zTrackSectionILo       zTrackSectionI = &D5CF = -10801
 EQUB &40               \ xTrackSectionOLo       xTrackSectionO = &F440 =  -3008
 EQUB 11                \ trackSectionFrom
 EQUB &01               \ zTrackSectionOLo       zTrackSectionO = &D501 = -11007
 EQUB 25                \ trackSectionSize

                        \ Track section 21

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &1E               \ xTrackSectionILo       xTrackSectionI = &EA1E =  -5602
 EQUB &A9               \ yTrackSectionILo       yTrackSectionI = &1AA9 =   6825
 EQUB &12               \ zTrackSectionILo       zTrackSectionI = &CF12 = -12526
 EQUB &AE               \ xTrackSectionOLo       xTrackSectionO = &EAAE =  -5458
 EQUB 38                \ trackSectionFrom
 EQUB &44               \ zTrackSectionOLo       zTrackSectionO = &CE44 = -12732
 EQUB 36                \ trackSectionSize

                        \ Track section 22

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &56               \ xTrackSectionILo       xTrackSectionI = &DC56 =  -9130
 EQUB &96               \ yTrackSectionILo       yTrackSectionI = &1E96 =   7830
 EQUB &5E               \ zTrackSectionILo       zTrackSectionI = &C55E = -15010
 EQUB &E6               \ xTrackSectionOLo       xTrackSectionO = &DCE6 =  -8986
 EQUB 36                \ trackSectionFrom
 EQUB &90               \ zTrackSectionOLo       zTrackSectionO = &C490 = -15216
 EQUB 5                 \ trackSectionSize

                        \ Track section 23

 EQUB %01000010         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=01 Sh=0
 EQUB &15               \ xTrackSectionILo       xTrackSectionI = &DA15 =  -9707
 EQUB &8C               \ yTrackSectionILo       yTrackSectionI = &1E8C =   7820
 EQUB &47               \ zTrackSectionILo       zTrackSectionI = &C547 = -15033
 EQUB &C1               \ xTrackSectionOLo       xTrackSectionO = &D9C1 =  -9791
 EQUB 3                 \ trackSectionFrom
 EQUB &5A               \ zTrackSectionOLo       zTrackSectionO = &C45A = -15270
 EQUB 7                 \ trackSectionSize

                        \ Track section 24

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &17               \ xTrackSectionILo       xTrackSectionI = &D717 = -10473
 EQUB &70               \ yTrackSectionILo       yTrackSectionI = &1E70 =   7792
 EQUB &9E               \ zTrackSectionILo       zTrackSectionI = &C69E = -14690
 EQUB &A3               \ xTrackSectionOLo       xTrackSectionO = &D6A3 = -10589
 EQUB 12                \ trackSectionFrom
 EQUB &BD               \ zTrackSectionOLo       zTrackSectionO = &C5BD = -14915
 EQUB 27                \ trackSectionSize

 EQUB &00               \ This byte appears to be unused

\ ******************************************************************************
\
\       Name: HookSlopeJump
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Jump the car when driving fast over sloping segments
\  Deep dive: Secrets of the extra tracks
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

\ ******************************************************************************
\
\       Name: HookJoystick (Part 2 of 3)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Apply enhanced joystick steering to specific track sections
\  Deep dive: Secrets of the extra tracks
\             Code hooks in the extra tracks
\
\ ******************************************************************************

.joys8

 LDY #181               \ Set Y = 181 so by default we scale the steering by
                        \ 1.00

 CMP #24                \ If the track section <> 24 (i.e. section 3), jump to
 BNE joys9              \ joys9 to keep checking

 LDY #205               \ Set Y = 205 so we scale the steering by 1.28

.joys9

 CMP #48                \ If the track section = 48 (i.e. section 6), jump to
 BEQ joys10             \ joys10 to scale the steering by 1.08

 CMP #40                \ If the track section <> 40 (i.e. section 5), jump to
 BNE joys11             \ joys11 to keep checking

.joys10

 LDY #188               \ Set Y = 188 so we scale the steering by 1.08

.joys11

 JMP joys12             \ Jump to part 3 to scale the steering

\ ******************************************************************************
\
\       Name: HookBackground
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Do not update the background colour when the track line above is
\             showing green for the leftTrackStart verge
\  Deep dive: Secrets of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from UpdateBackground to skip updating the background
\ colour table when the track line above is showing green for the leftTrackStart
\ verge.
\
\ ******************************************************************************

.HookBackground

                        \ If we get here then the edge we are drawing is
                        \ partially off-screen and the track line in Y has been
                        \ decremented

 LDA backgroundColour+1,Y \ Set A to the contents of the background colour table
                          \ for the track line we are drawing (i.e. track line
                          \ Y + 1, as we just decremented Y)

 CMP #%10001011         \ If A = 10001011, then this represents:
 BEQ back1              \
                        \   * Set by UpdateBackground to the value in
                        \     backgroundLeft
                        \
                        \   * Verge type = leftTrackStart
                        \
                        \   * Not set by SetVergeBackground
                        \
                        \   * Colour = logical colour 3 (green)
                        \
                        \ In this case, jump to back1 to return to the main
                        \ UpdateBackground routine without updating the
                        \ background colour

                        \ If we get here then we just implement the same code as
                        \ in the original

 LDA backgroundColour,Y \ Set A to the contents of the background colour table
                        \ for track line Y

 RTS                    \ Return from the subroutine

.back1

 LSR A                  \ Shift A to the right, so A = 01000101
                        \
                        \ This is a non-zero value, so when we return back into
                        \ the main code, we will take the BNE upba4 branch to
                        \ return from the subroutine without updating the
                        \ background
                        \
                        \ This LSR is therefore just a quick way of setting the
                        \ Z flag so the BNE upba4 branch is taken on our return

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: trackSectionCount
\       Type: Variable
\   Category: Extra tracks
\    Summary: The total number of track sections * 8
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Donington Park track
\
\ ******************************************************************************

 EQUB 25 * 8

\ ******************************************************************************
\
\       Name: trackVectorCount
\       Type: Variable
\   Category: Track data
\    Summary: The total number of segment vectors in the segment vector tables
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Donington Park track
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
\             The extra tracks data file format
\             The Donington Park track
\
\ ------------------------------------------------------------------------------
\
\ The highest segment number is this value minus 1, as segment numbers start
\ from zero.
\
\ ******************************************************************************

 EQUW 719               \ Segments are numbered from 0 to 718

\ ******************************************************************************
\
\       Name: trackStartLine
\       Type: Variable
\   Category: Track data
\    Summary: The segment number of the starting line
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Donington Park track
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

 EQUW 719 - 209         \ The starting line is at segment 209

\ ******************************************************************************
\
\       Name: trackLapTimeSec
\       Type: Variable
\   Category: Extra tracks
\    Summary: Lap times for adjusting the race class (seconds)
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Donington Park track
\
\ ------------------------------------------------------------------------------
\
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we change the race class to the relevant difficulty.
\
\ This figure is stored in Binary Coded Decimal (BCD).
\
\ ******************************************************************************

 EQUB &17               \ Set class to Novice if slowest lap time > 1:17

 EQUB &13               \ Set class to Amateur if slowest lap time > 1:13

 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackLapTimeMin
\       Type: Variable
\   Category: Extra tracks
\    Summary: Lap times for adjusting the race class (minutes)
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Donington Park track
\
\ ------------------------------------------------------------------------------
\
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we change the race class to the relevant difficulty.
\
\ ******************************************************************************

 EQUB 1                 \ Set class to Novice if slowest lap time > 1:17

 EQUB 1                 \ Set class to Amateur if slowest lap time > 1:13

 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackGearRatio
\       Type: Variable
\   Category: Extra tracks
\    Summary: The gear ratio for each gear
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Donington Park track
\
\ ------------------------------------------------------------------------------
\
\ The rev count is calculated by multiplying the track gear ratio by the current
\ speed, so lower gears correspond to more revs at the same wheel speed when
\ compared to higher gears.
\
\ ******************************************************************************

 EQUB 104               \ Reverse

 EQUB 0                 \ Neutral

 EQUB 104               \ First gear

 EQUB 69                \ Second gear

 EQUB 60                \ Third gear

 EQUB 51                \ Fourth gear

 EQUB 44                \ Fifth gear

\ ******************************************************************************
\
\       Name: trackGearPower
\       Type: Variable
\   Category: Extra tracks
\    Summary: The power for each gear
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Donington Park track
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

 EQUB 106               \ Second gear

 EQUB 93                \ Third gear

 EQUB 79                \ Fourth gear

 EQUB 69                \ Fifth gear

\ ******************************************************************************
\
\       Name: trackBaseSpeed
\       Type: Variable
\   Category: Extra tracks
\    Summary: The base speed for each race class, used when generating the best
\             racing lines and non-player driver speeds
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Donington Park track
\
\ ******************************************************************************

 EQUB 134               \ Base speed for Novice

 EQUB 146               \ Base speed for Amateur

 EQUB 152               \ Base speed for Professional

\ ******************************************************************************
\
\       Name: trackStartPosition
\       Type: Variable
\   Category: Extra tracks
\    Summary: The starting race position of the player during a practice or
\             qualifying lap
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Donington Park track
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
\             The extra tracks data file format
\             The Donington Park track
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
\             The extra tracks data file format
\             The Donington Park track
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
\ ******************************************************************************

 EQUB 20

\ ******************************************************************************
\
\       Name: trackRaceSlowdown
\       Type: Variable
\   Category: Extra tracks
\    Summary: Slowdown factor for non-player drivers in the race
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Donington Park track
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
\  Deep dive: Secrets of the extra tracks
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
\             The extra tracks data file format
\             The Donington Park track
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
\             The extra tracks data file format
\             The Donington Park track
\
\ ******************************************************************************

.trackChecksum

 EQUB &A8               \ Counts the number of data bytes ending in %00

 EQUB &CD               \ Counts the number of data bytes ending in %01

 EQUB &4B               \ Counts the number of data bytes ending in %10

 EQUB &65               \ Counts the number of data bytes ending in %11

\ ******************************************************************************
\
\       Name: trackGameName
\       Type: Variable
\   Category: Extra tracks
\    Summary: The game name
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Donington Park track
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
\             The extra tracks data file format
\             The Donington Park track
\
\ ------------------------------------------------------------------------------
\
\ This string is shown on the loading screen.
\
\ ******************************************************************************

.trackName

 EQUS "Donington Park"  \ Track name
 EQUB 13

 EQUB &22, &20          \ These bytes appear to be unused
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
\ Save DoningtonPark.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/DoningtonPark.bin", CODE%, P%

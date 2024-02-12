\ ******************************************************************************
\
\ REVS OULTON PARK TRACK SOURCE
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
\ https://revs.bbcelite.com/terminology
\
\ The deep dive articles referred to in this commentary can be found at
\ https://revs.bbcelite.com/deep_dives
\
\ ------------------------------------------------------------------------------
\
\ This source file produces the following binary file:
\
\   * OultonPark.bin
\
\ ******************************************************************************

 GUARD &7C00            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 LOAD% = &70DB          \ The load address of the track binary

 CODE% = &5300          \ The assembly address of the track data

 trackWidth = 128       \ Track width

\ ******************************************************************************
\
\ Addresses in the main game code
\
\ ******************************************************************************

 thisSectionFlags   = &0001
 thisVectorNumber   = &0002
 yStore             = &001B
 horizonLine        = &001F
 frontSegmentIndex  = &0024
 directionFacing    = &0025
 segmentCounter     = &0042
 playerPastSegment  = &0043
 xStore             = &0045
 vergeBufferEnd     = &004B
 horizonListIndex   = &0051
 playerSpeedHi      = &0063
 currentPlayer      = &006F
 T                  = &0074
 U                  = &0075
 V                  = &0076
 W                  = &0077
 topTrackLine       = &007F
 blockOffset        = &0082
 objTrackSection    = &06E8
 Multiply8x8        = &0C00
 Absolute16Bit      = &0E40
 UpdateVectorNumber = &13E0
 MovePlayerBack     = &140B
 CheckVergeOnScreen = &1933
 gseg13             = &2490
 gtrm2              = &2535
 Absolute8Bit       = &3450
 MultiplyHeight     = &4610
 xTrackSegmentI     = &5400
 yTrackSegmentI     = &5500
 zTrackSegmentI     = &5600
 xTrackSegmentO     = &5700
 zTrackSegmentO     = &5800
 trackSectionFrom   = &5905
 xVergeRightLo      = &5E40
 xVergeLeftLo       = &5E68
 xVergeRightHi      = &5E90
 xVergeLeftHi       = &5EB8
 yVergeRight        = &5F20
 yVergeLeft         = &5F48

\ ******************************************************************************
\
\ REVS OULTON PARK TRACK
\
\ Produces the binary file OultonPark.bin that contains the Oulton Park track.
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
\             The Oulton Park track
\
\ ------------------------------------------------------------------------------
\
\ Oulton Park consists of the following track sections:
\
\   0    |<-|   Lodge to Old Hall (4/4)
\   1    ->     Old Hall
\   2    ||     Old Hall to Cascades (1/4)
\   3    ->     Old Hall to Cascades (2/4)
\   4    ->     Old Hall to Cascades (3/4)
\   5    {}     Old Hall to Cascades (4/4)
\   6    <-     Cascades
\   7    ||     Cascades to Island Hairpin (1/2)
\   8    |->|   Cascades to Island Hairpin (2/2)
\   9    |->|   Island Hairpin
\   10   {}     Island Hairpin to Knickerbrook (1/4)
\   11   {}     Island Hairpin to Knickerbrook (2/4)
\   12   ||     Island Hairpin to Knickerbrook (3/4)
\   13   {}     Island Hairpin to Knickerbrook (4/4)
\   14   ->     Knickerbrook
\   15   |->|   Knickerbrook to Druids (1/4)
\   16   <-     Knickerbrook to Druids (2/4)
\   17   |<-|   Knickerbrook to Druids (3/4)
\   18   |<->|  Knickerbrook to Druids (4/4)
\   19   ->     Druids
\   20   |<-|   Druids to Lodge (1/3)
\   21   ||     Druids to Lodge (2/3)
\   22   |->|   Druids to Lodge (3/3)
\   23   ->     Lodge
\   24   ->     Lodge to Old Hall (1/4)
\   25   <-     Lodge to Old Hall (2/4)
\   26   |<-|   Lodge to Old Hall (3/4)
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
\ trackDriverSpeed      The maximum speed for non-player drivers on the next
\                       section of the track
\
\ ******************************************************************************

                        \ Track section 0

 EQUB &12               \ trackSectionData       sign = 1, sectionListSize = 2
 EQUB &D1               \ xTrackSectionIHi       xTrackSectionI = &D120 = -12000
 EQUB &12               \ yTrackSectionIHi       yTrackSectionI = &1200 =   4608
 EQUB &D1               \ zTrackSectionIHi       zTrackSectionI = &D120 = -12000
 EQUB &D0               \ xTrackSectionOHi       xTrackSectionO = &D030 = -12240
 EQUB 42                \ trackSectionTurn
 EQUB &D1               \ zTrackSectionOHi       zTrackSectionO = &D120 = -12000
 EQUB 120               \ trackDriverSpeed

                        \ Track section 1

 EQUB &21               \ trackSectionData       sign = 2, sectionListSize = 1
 EQUB &CE               \ xTrackSectionIHi       xTrackSectionI = &CEC3 = -12605
 EQUB &10               \ yTrackSectionIHi       yTrackSectionI = &10BB =   4283
 EQUB &E6               \ zTrackSectionIHi       zTrackSectionI = &E60C =  -6644
 EQUB &CD               \ xTrackSectionOHi       xTrackSectionO = &CDD5 = -12843
 EQUB 27                \ trackSectionTurn
 EQUB &E5               \ zTrackSectionOHi       zTrackSectionO = &E5EE =  -6674
 EQUB 15                \ trackDriverSpeed

                        \ Track section 2

 EQUB &23               \ trackSectionData       sign = 2, sectionListSize = 3
 EQUB &D2               \ xTrackSectionIHi       xTrackSectionI = &D225 = -11739
 EQUB &10               \ yTrackSectionIHi       yTrackSectionI = &1009 =   4105
 EQUB &ED               \ zTrackSectionIHi       zTrackSectionI = &ED6B =  -4757
 EQUB &D1               \ xTrackSectionOHi       xTrackSectionO = &D1D5 = -11819
 EQUB 255               \ trackSectionTurn
 EQUB &EE               \ zTrackSectionOHi       zTrackSectionO = &EE4D =  -4531
 EQUB 255               \ trackDriverSpeed

                        \ Track section 3

 EQUB &33               \ trackSectionData       sign = 3, sectionListSize = 3
 EQUB &E2               \ xTrackSectionIHi       xTrackSectionI = &E27A =  -7558
 EQUB &0F               \ yTrackSectionIHi       yTrackSectionI = &0F9A =   3994
 EQUB &F3               \ zTrackSectionIHi       zTrackSectionI = &F333 =  -3277
 EQUB &E2               \ xTrackSectionOHi       xTrackSectionO = &E22A =  -7638
 EQUB 9                 \ trackSectionTurn
 EQUB &F4               \ zTrackSectionOHi       zTrackSectionO = &F415 =  -3051
 EQUB 255               \ trackDriverSpeed

                        \ Track section 4

 EQUB &33               \ trackSectionData       sign = 3, sectionListSize = 3
 EQUB &ED               \ xTrackSectionIHi       xTrackSectionI = &ED35 =  -4811
 EQUB &0F               \ yTrackSectionIHi       yTrackSectionI = &0F52 =   3922
 EQUB &F6               \ zTrackSectionIHi       zTrackSectionI = &F68A =  -2422
 EQUB &EC               \ xTrackSectionOHi       xTrackSectionO = &ECF5 =  -4875
 EQUB 36                \ trackSectionTurn
 EQUB &F7               \ zTrackSectionOHi       zTrackSectionO = &F772 =  -2190
 EQUB 20                \ trackDriverSpeed

                        \ Track section 5

 EQUB &42               \ trackSectionData       sign = 4, sectionListSize = 2
 EQUB &EF               \ xTrackSectionIHi       xTrackSectionI = &EFFE =  -4098
 EQUB &0F               \ yTrackSectionIHi       yTrackSectionI = &0F16 =   3862
 EQUB &F6               \ zTrackSectionIHi       zTrackSectionI = &F6DD =  -2339
 EQUB &EF               \ xTrackSectionOHi       xTrackSectionO = &EFFC =  -4100
 EQUB 18                \ trackSectionTurn
 EQUB &F7               \ zTrackSectionOHi       zTrackSectionO = &F7CD =  -2099
 EQUB 130               \ trackDriverSpeed

                        \ Track section 6

 EQUB &53               \ trackSectionData       sign = 5, sectionListSize = 3
 EQUB &FA               \ xTrackSectionIHi       xTrackSectionI = &FA4E =  -1458
 EQUB &0C               \ yTrackSectionIHi       yTrackSectionI = &0CD6 =   3286
 EQUB &F6               \ zTrackSectionIHi       zTrackSectionI = &F6F3 =  -2317
 EQUB &FA               \ xTrackSectionOHi       xTrackSectionO = &FA4C =  -1460
 EQUB 49                \ trackSectionTurn
 EQUB &F7               \ zTrackSectionOHi       zTrackSectionO = &F7E3 =  -2077
 EQUB 26                \ trackDriverSpeed

                        \ Track section 7

 EQUB &54               \ trackSectionData       sign = 5, sectionListSize = 4
 EQUB &03               \ xTrackSectionIHi       xTrackSectionI = &032D =    813
 EQUB &0B               \ yTrackSectionIHi       yTrackSectionI = &0BE0 =   3040
 EQUB &04               \ zTrackSectionIHi       zTrackSectionI = &0493 =   1171
 EQUB &02               \ xTrackSectionOHi       xTrackSectionO = &024D =    589
 EQUB 255               \ trackSectionTurn
 EQUB &04               \ zTrackSectionOHi       zTrackSectionO = &043F =   1087
 EQUB 255               \ trackDriverSpeed

                        \ Track section 8

 EQUB &63               \ trackSectionData       sign = 6, sectionListSize = 3
 EQUB &F8               \ xTrackSectionIHi       xTrackSectionI = &F8AD =  -1875
 EQUB &0F               \ yTrackSectionIHi       yTrackSectionI = &0F60 =   3936
 EQUB &20               \ zTrackSectionIHi       zTrackSectionI = &2093 =   8339
 EQUB &F7               \ xTrackSectionOHi       xTrackSectionO = &F7CD =  -2099
 EQUB 28                \ trackSectionTurn
 EQUB &20               \ zTrackSectionOHi       zTrackSectionO = &203F =   8255
 EQUB 67                \ trackDriverSpeed

                        \ Track section 9

 EQUB &73               \ trackSectionData       sign = 7, sectionListSize = 3
 EQUB &F4               \ xTrackSectionIHi       xTrackSectionI = &F41D =  -3043
 EQUB &0E               \ yTrackSectionIHi       yTrackSectionI = &0EBB =   3771
 EQUB &2D               \ zTrackSectionIHi       zTrackSectionI = &2DDE =  11742
 EQUB &F3               \ xTrackSectionOHi       xTrackSectionO = &F339 =  -3271
 EQUB 23                \ trackSectionTurn
 EQUB &2D               \ zTrackSectionOHi       zTrackSectionO = &2D92 =  11666
 EQUB 10                \ trackDriverSpeed

                        \ Track section 10

 EQUB &83               \ trackSectionData       sign = 8, sectionListSize = 3
 EQUB &F8               \ xTrackSectionIHi       xTrackSectionI = &F888 =  -1912
 EQUB &0D               \ yTrackSectionIHi       yTrackSectionI = &0DF4 =   3572
 EQUB &30               \ zTrackSectionIHi       zTrackSectionI = &30C0 =  12480
 EQUB &F9               \ xTrackSectionOHi       xTrackSectionO = &F95E =  -1698
 EQUB 255               \ trackSectionTurn
 EQUB &31               \ zTrackSectionOHi       zTrackSectionO = &312E =  12590
 EQUB 255               \ trackDriverSpeed

                        \ Track section 11

 EQUB &83               \ trackSectionData       sign = 8, sectionListSize = 3
 EQUB &01               \ xTrackSectionIHi       xTrackSectionI = &0120 =    288
 EQUB &0F               \ yTrackSectionIHi       yTrackSectionI = &0F34 =   3892
 EQUB &20               \ zTrackSectionIHi       zTrackSectionI = &2008 =   8200
 EQUB &01               \ xTrackSectionOHi       xTrackSectionO = &01F6 =    502
 EQUB 255               \ trackSectionTurn
 EQUB &20               \ zTrackSectionOHi       zTrackSectionO = &2076 =   8310
 EQUB 255               \ trackDriverSpeed

                        \ Track section 12

 EQUB &92               \ trackSectionData       sign = 9, sectionListSize = 2
 EQUB &05               \ xTrackSectionIHi       xTrackSectionI = &056C =   1388
 EQUB &0E               \ yTrackSectionIHi       yTrackSectionI = &0E44 =   3652
 EQUB &17               \ zTrackSectionIHi       zTrackSectionI = &17AC =   6060
 EQUB &06               \ xTrackSectionOHi       xTrackSectionO = &0642 =   1602
 EQUB 255               \ trackSectionTurn
 EQUB &18               \ zTrackSectionOHi       zTrackSectionO = &181A =   6170
 EQUB 255               \ trackDriverSpeed

                        \ Track section 13

 EQUB &A5               \ trackSectionData       sign = 10, sectionListSize = 5
 EQUB &12               \ xTrackSectionIHi       xTrackSectionI = &1219 =   4633
 EQUB &0D               \ yTrackSectionIHi       yTrackSectionI = &0DCE =   3534
 EQUB &FF               \ zTrackSectionIHi       zTrackSectionI = &FF03 =   -253
 EQUB &12               \ xTrackSectionOHi       xTrackSectionO = &12EF =   4847
 EQUB 13                \ trackSectionTurn
 EQUB &FF               \ zTrackSectionOHi       zTrackSectionO = &FF71 =   -143
 EQUB 140               \ trackDriverSpeed

                        \ Track section 14

 EQUB &A4               \ trackSectionData       sign = 10, sectionListSize = 4
 EQUB &16               \ xTrackSectionIHi       xTrackSectionI = &16D3 =   5843
 EQUB &0F               \ yTrackSectionIHi       yTrackSectionI = &0F5D =   3933
 EQUB &F5               \ zTrackSectionIHi       zTrackSectionI = &F5D1 =  -2607
 EQUB &17               \ xTrackSectionOHi       xTrackSectionO = &17A9 =   6057
 EQUB 34                \ trackSectionTurn
 EQUB &F6               \ zTrackSectionOHi       zTrackSectionO = &F63F =  -2497
 EQUB 18                \ trackDriverSpeed

                        \ Track section 15

 EQUB &A3               \ trackSectionData       sign = 10, sectionListSize = 3
 EQUB &16               \ xTrackSectionIHi       xTrackSectionI = &160B =   5643
 EQUB &0F               \ yTrackSectionIHi       yTrackSectionI = &0FD7 =   4055
 EQUB &EE               \ zTrackSectionIHi       zTrackSectionI = &EEAD =  -4435
 EQUB &16               \ xTrackSectionOHi       xTrackSectionO = &16DB =   5851
 EQUB 28                \ trackSectionTurn
 EQUB &EE               \ zTrackSectionOHi       zTrackSectionO = &EE35 =  -4555
 EQUB 255               \ trackDriverSpeed

                        \ Track section 16

 EQUB &B3               \ trackSectionData       sign = 11, sectionListSize = 3
 EQUB &0A               \ xTrackSectionIHi       xTrackSectionI = &0AFC =   2812
 EQUB &0E               \ yTrackSectionIHi       yTrackSectionI = &0EAA =   3754
 EQUB &DD               \ zTrackSectionIHi       zTrackSectionI = &DD55 =  -8875
 EQUB &0B               \ xTrackSectionOHi       xTrackSectionO = &0BBC =   3004
 EQUB 38                \ trackSectionTurn
 EQUB &DC               \ zTrackSectionOHi       zTrackSectionO = &DCC7 =  -9017
 EQUB 12                \ trackDriverSpeed

                        \ Track section 17

 EQUB &B3               \ trackSectionData       sign = 11, sectionListSize = 3
 EQUB &08               \ xTrackSectionIHi       xTrackSectionI = &086B =   2155
 EQUB &10               \ yTrackSectionIHi       yTrackSectionI = &10E6 =   4326
 EQUB &D7               \ zTrackSectionIHi       zTrackSectionI = &D7D9 = -10279
 EQUB &09               \ xTrackSectionOHi       xTrackSectionO = &0953 =   2387
 EQUB 255               \ trackSectionTurn
 EQUB &D7               \ zTrackSectionOHi       zTrackSectionO = &D79B = -10341
 EQUB 255               \ trackDriverSpeed

                        \ Track section 18

 EQUB &C3               \ trackSectionData       sign = 12, sectionListSize = 3
 EQUB &03               \ xTrackSectionIHi       xTrackSectionI = &03FC =   1020
 EQUB &11               \ yTrackSectionIHi       yTrackSectionI = &117A =   4474
 EQUB &C3               \ zTrackSectionIHi       zTrackSectionI = &C3BB = -15429
 EQUB &04               \ xTrackSectionOHi       xTrackSectionO = &04EA =   1258
 EQUB 31                \ trackSectionTurn
 EQUB &C3               \ zTrackSectionOHi       zTrackSectionO = &C39D = -15459
 EQUB 137               \ trackDriverSpeed

                        \ Track section 19

 EQUB &D3               \ trackSectionData       sign = 13, sectionListSize = 3
 EQUB &04               \ xTrackSectionIHi       xTrackSectionI = &0491 =   1169
 EQUB &10               \ yTrackSectionIHi       yTrackSectionI = &109B =   4251
 EQUB &B2               \ zTrackSectionIHi       zTrackSectionI = &B265 = -19867
 EQUB &05               \ xTrackSectionOHi       xTrackSectionO = &057F =   1407
 EQUB 42                \ trackSectionTurn
 EQUB &B2               \ zTrackSectionOHi       zTrackSectionO = &B24D = -19891
 EQUB 23                \ trackDriverSpeed

                        \ Track section 20

 EQUB &E3               \ trackSectionData       sign = 14, sectionListSize = 3
 EQUB &FA               \ xTrackSectionIHi       xTrackSectionI = &FA26 =  -1498
 EQUB &12               \ yTrackSectionIHi       yTrackSectionI = &121B =   4635
 EQUB &AA               \ zTrackSectionIHi       zTrackSectionI = &AA75 = -21899
 EQUB &FA               \ xTrackSectionOHi       xTrackSectionO = &FA20 =  -1504
 EQUB 255               \ trackSectionTurn
 EQUB &A9               \ zTrackSectionOHi       zTrackSectionO = &A985 = -22139
 EQUB 255               \ trackDriverSpeed

                        \ Track section 21

 EQUB &E3               \ trackSectionData       sign = 14, sectionListSize = 3
 EQUB &EF               \ xTrackSectionIHi       xTrackSectionI = &EF5E =  -4258
 EQUB &11               \ yTrackSectionIHi       yTrackSectionI = &1132 =   4402
 EQUB &AA               \ zTrackSectionIHi       zTrackSectionI = &AA78 = -21896
 EQUB &EF               \ xTrackSectionOHi       xTrackSectionO = &EF72 =  -4238
 EQUB 255               \ trackSectionTurn
 EQUB &A9               \ zTrackSectionOHi       zTrackSectionO = &A988 = -22136
 EQUB 255               \ trackDriverSpeed

                        \ Track section 22

 EQUB &E1               \ trackSectionData       sign = 14, sectionListSize = 1
 EQUB &E0               \ xTrackSectionIHi       xTrackSectionI = &E0D6 =  -7978
 EQUB &12               \ yTrackSectionIHi       yTrackSectionI = &1287 =   4743
 EQUB &A9               \ zTrackSectionIHi       zTrackSectionI = &A942 = -22206
 EQUB &E0               \ xTrackSectionOHi       xTrackSectionO = &E0EA =  -7958
 EQUB 37                \ trackSectionTurn
 EQUB &A8               \ zTrackSectionOHi       zTrackSectionO = &A852 = -22446
 EQUB 91                \ trackDriverSpeed

                        \ Track section 23

 EQUB &F1               \ trackSectionData       sign = 15, sectionListSize = 1
 EQUB &CD               \ xTrackSectionIHi       xTrackSectionI = &CD2A = -13014
 EQUB &12               \ yTrackSectionIHi       yTrackSectionI = &12DB =   4827
 EQUB &A8               \ zTrackSectionIHi       zTrackSectionI = &A8A9 = -22359
 EQUB &CC               \ xTrackSectionOHi       xTrackSectionO = &CCFE = -13058
 EQUB 22                \ trackSectionTurn
 EQUB &A7               \ zTrackSectionOHi       zTrackSectionO = &A7BD = -22595
 EQUB 13                \ trackDriverSpeed

                        \ Track section 24

 EQUB &F3               \ trackSectionData       sign = 15, sectionListSize = 3
 EQUB &CA               \ xTrackSectionIHi       xTrackSectionI = &CAA8 = -13656
 EQUB &12               \ yTrackSectionIHi       yTrackSectionI = &12E1 =   4833
 EQUB &AD               \ zTrackSectionIHi       zTrackSectionI = &AD0C = -21236
 EQUB &C9               \ xTrackSectionOHi       xTrackSectionO = &C9BE = -13890
 EQUB 6                 \ trackSectionTurn
 EQUB &AD               \ zTrackSectionOHi       zTrackSectionO = &AD40 = -21184
 EQUB 255               \ trackDriverSpeed

                        \ Track section 25

 EQUB &03               \ trackSectionData       sign = 0, sectionListSize = 3
 EQUB &CF               \ xTrackSectionIHi       xTrackSectionI = &CF94 = -12396
 EQUB &14               \ yTrackSectionIHi       yTrackSectionI = &14EA =   5354
 EQUB &BB               \ zTrackSectionIHi       zTrackSectionI = &BBAC = -17492
 EQUB &CE               \ xTrackSectionOHi       xTrackSectionO = &CEBA = -12614
 EQUB 45                \ trackSectionTurn
 EQUB &BC               \ zTrackSectionOHi       zTrackSectionO = &BC10 = -17392
 EQUB 14                \ trackDriverSpeed

                        \ Track section 26

 EQUB &03               \ trackSectionData       sign = 0, sectionListSize = 3
 EQUB &D0               \ xTrackSectionIHi       xTrackSectionI = &D072 = -12174
 EQUB &14               \ yTrackSectionIHi       yTrackSectionI = &146A =   5226
 EQUB &BF               \ zTrackSectionIHi       zTrackSectionI = &BF4D = -16563
 EQUB &CF               \ xTrackSectionOHi       xTrackSectionO = &CF82 = -12414
 EQUB 255               \ trackSectionTurn
 EQUB &BF               \ zTrackSectionOHi       zTrackSectionO = &BF61 = -16543
 EQUB 255               \ trackDriverSpeed

 EQUB &06, &74          \ These bytes appear to be unused
 EQUB &2A, &60
 EQUB &A5, &2A
 EQUB &20, &78
 EQUB &34, &C9
 EQUB &19, &B0
 EQUB &07, &A5
 EQUB &0D, &10

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
\       Name: HookJoystick (Part 2 of 2)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Apply enhanced joystick steering to specific track sections
\  Deep dive: Secrets of the extra tracks
\             Code hooks in the extra tracks
\
\ ******************************************************************************

.joys4

 STA U                  \ Set U = A
                        \       = high byte of A * x-axis

 JSR Multiply8x8        \ Set (A T) = A * U
                        \           = A * A
                        \           = (A * x-axis) ^ 2

 ASL T                  \ Set (A T) = (A T) * 2
 ROL A                  \           = 2 * (A * x-axis) ^ 2

                        \ So for A = 248 we have:
                        \
                        \   (A T) = 2 * (248/256 * x-axis) ^ 2
                        \         = 2 * (0.969 * x-axis) ^ 2
                        \         = 1.88 * x-axis ^ 2
                        \
                        \ and for A = 190 we have:
                        \
                        \   (A T) = 2 * (190/256 * x-axis) ^ 2
                        \         = 2 * (0.742 * x-axis) ^ 2
                        \         = 1.10 * x-axis ^ 2
                        \
                        \ and for A = 181 we have:
                        \
                        \   (A T) = 2 * (181/256 * x-axis) ^ 2
                        \         = 2 * (0.707 * x-axis) ^ 2
                        \         = 1.00 * x-axis ^ 2

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

 EQUB &00, &00          \ These bytes appear to be unused

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
\ have been done. The block is padded out to be exactly 20 bytes long, so along
\ with the modifyAddressHi block, there's one byte for each inner segment
\ x-coordinate.
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

 EQUB &24               \ This byte pads the block out to exactly 20 bytes

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
\ have been done. The block is padded out to be exactly 20 bytes long, so along
\ with the modifyAddressLo block, there's one byte for each inner segment
\ x-coordinate.
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

 EQUB &2F               \ This byte pads the block out to exactly 20 bytes

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

 EQUB &FE               \ Sub-section  0 = &FE39 ( -455)
 EQUB &00               \ Sub-section  1 = &0000 (    0)
 EQUB &FF               \ Sub-section  2 = &FF87 ( -121)
 EQUB &00               \ Sub-section  3 = &0000 (    0)
 EQUB &01               \ Sub-section  4 = &0161 (  353)
 EQUB &04               \ Sub-section  5 = &040A ( 1034)
 EQUB &04               \ Sub-section  6 = &040A ( 1034)
 EQUB &00               \ Sub-section  7 = &001E (   30)
 EQUB &01               \ Sub-section  8 = &01C7 (  455)
 EQUB &00               \ Sub-section  9 = &0000 (    0)
 EQUB &00               \ Sub-section 10 = &0000 (    0)
 EQUB &FE               \ Sub-section 11 = &FE4B ( -437)
 EQUB &FD               \ Sub-section 12 = &FDD5 ( -555)
 EQUB &FE               \ Sub-section 13 = &FEFA ( -262)
 EQUB &FC               \ Sub-section 14 = &FC44 ( -956)
 EQUB &00               \ Sub-section 15 = &0017 (   23)
 EQUB &00               \ Sub-section 16 = &0017 (   23)
 EQUB &00               \ Sub-section 17 = &0000 (    0)
 EQUB &00               \ Sub-section 18 = &0000 (    0)
 EQUB &05               \ Sub-section 19 = &0509 ( 1289)
 EQUB &07               \ Sub-section 20 = &079B ( 1947)
 EQUB &00               \ Sub-section 21 = &0000 (    0)
 EQUB &00               \ Sub-section 22 = &0000 (    0)
 EQUB &00               \ Sub-section 23 = &0000 (    0)
 EQUB &00               \ Sub-section 24 = &0000 (    0)
 EQUB &00               \ Sub-section 25 = &0000 (    0)
 EQUB &00               \ Sub-section 26 = &0000 (    0)
 EQUB &02               \ Sub-section 27 = &02FD (  765)
 EQUB &01               \ Sub-section 28 = &01D6 (  470)
 EQUB &00               \ Sub-section 29 = &0000 (    0)
 EQUB &00               \ Sub-section 30 = &00B0 (  176)
 EQUB &00               \ Sub-section 31 = &0000 (    0)
 EQUB &FE               \ Sub-section 32 = &FECD ( -307)
 EQUB &00               \ Sub-section 33 = &0000 (    0)
 EQUB &00               \ Sub-section 34 = &0000 (    0)
 EQUB &FF               \ Sub-section 35 = &FFA5 (  -91)
 EQUB &FF               \ Sub-section 36 = &FFD2 (  -46)
 EQUB &FF               \ Sub-section 37 = &FF1C ( -228)
 EQUB &00               \ Sub-section 38 = &0000 (    0)
 EQUB &00               \ Sub-section 39 = &00FE (  254)
 EQUB &04               \ Sub-section 40 = &04CD ( 1229)
 EQUB &01               \ Sub-section 41 = &014E (  334)
 EQUB &02               \ Sub-section 42 = &020D (  525)
 EQUB &02               \ Sub-section 43 = &020D (  525)
 EQUB &00               \ Sub-section 44 = &0000 (    0)
 EQUB &FF               \ Sub-section 45 = &FF7D ( -131)
 EQUB &00               \ Sub-section 46 = &00E4 (  228)
 EQUB &00               \ Sub-section 47 = &0000 (    0)
 EQUB &00               \ Sub-section 48 = &0000 (    0)
 EQUB &01               \ Sub-section 49 = &018A (  394)
 EQUB &05               \ Sub-section 50 = &0574 ( 1396)
 EQUB &05               \ Sub-section 51 = &0574 ( 1396)
 EQUB &00               \ Sub-section 52 = &0042 (   66)
 EQUB &00               \ Sub-section 53 = &0042 (   66)
 EQUB &FE               \ Sub-section 54 = &FE3F ( -449)
 EQUB &00               \ Sub-section 55 = &0000 (    0)
 EQUB &FE               \ Sub-section 56 = &FE39 ( -455)
 EQUB &00               \ Sub-section 57 = &0000 (    0)

\ ******************************************************************************
\
\       Name: trackSignData
\       Type: Variable
\   Category: Track data
\    Summary: Base coordinates and object types for 16 road signs
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Oulton Park track
\
\ ******************************************************************************

.trackSignData

 EQUB %11010001         \ Sign  0: 11010 001   Type 8    Start flag   Section 26
 EQUB %00000100         \ Sign  1: 00000 100   Type 11   Right turn   Section  0
 EQUB %00010000         \ Sign  2: 00010 000   Type 7    Straight     Section  2
 EQUB %00011000         \ Sign  3: 00011 000   Type 7    Straight     Section  3
 EQUB %00100101         \ Sign  4: 00100 101   Type 12   Left turn    Section  4
 EQUB %00111000         \ Sign  5: 00111 000   Type 7    Straight     Section  7
 EQUB %01001011         \ Sign  6: 01001 011   Type 10   Hairpin      Section  9
 EQUB %01001000         \ Sign  7: 01001 000   Type 7    Straight     Section  9
 EQUB %01010000         \ Sign  8: 01010 000   Type 7    Straight     Section 10
 EQUB %01110100         \ Sign  9: 01110 100   Type 11   Right turn   Section 14
 EQUB %01111000         \ Sign 10: 01111 000   Type 7    Straight     Section 15
 EQUB %10000000         \ Sign 11: 10000 000   Type 7    Straight     Section 16
 EQUB %10011100         \ Sign 12: 10011 100   Type 11   Right turn   Section 19
 EQUB %10011000         \ Sign 13: 10011 000   Type 7    Straight     Section 19
 EQUB %10111100         \ Sign 14: 10111 100   Type 11   Right turn   Section 23
 EQUB %11001000         \ Sign 15: 11001 000   Type 7    Straight     Section 25

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
 EQUB LO(trackSteering)
 EQUB LO(trackSignData)
 EQUB LO(trackSignData)
 EQUB LO(HookFlattenHills)
 EQUB LO(HookMoveBack)
 EQUB LO(HookFlipAbsolute)
 EQUB LO(Hook80Percent)

 EQUB &E8               \ This byte pads the block out to exactly 20 bytes

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
 EQUB HI(trackSteering)
 EQUB HI(trackSignData)
 EQUB HI(trackSignData)
 EQUB HI(HookFlattenHills)
 EQUB HI(HookMoveBack)
 EQUB HI(HookFlipAbsolute)
 EQUB HI(Hook80Percent)

 EQUB &59               \ This byte pads the block out to exactly 20 bytes

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

 EQUB &39               \ Sub-section  0 = &FE39 ( -455)
 EQUB &00               \ Sub-section  1 = &0000 (    0)
 EQUB &87               \ Sub-section  2 = &FF87 ( -121)
 EQUB &00               \ Sub-section  3 = &0000 (    0)
 EQUB &61               \ Sub-section  4 = &0161 (  353)
 EQUB &0A               \ Sub-section  5 = &040A ( 1034)
 EQUB &0A               \ Sub-section  6 = &040A ( 1034)
 EQUB &1E               \ Sub-section  7 = &001E (   30)
 EQUB &C7               \ Sub-section  8 = &01C7 (  455)
 EQUB &00               \ Sub-section  9 = &0000 (    0)
 EQUB &00               \ Sub-section 10 = &0000 (    0)
 EQUB &4B               \ Sub-section 11 = &FE4B ( -437)
 EQUB &D5               \ Sub-section 12 = &FDD5 ( -555)
 EQUB &FA               \ Sub-section 13 = &FEFA ( -262)
 EQUB &44               \ Sub-section 14 = &FC44 ( -956)
 EQUB &17               \ Sub-section 15 = &0017 (   23)
 EQUB &17               \ Sub-section 16 = &0017 (   23)
 EQUB &00               \ Sub-section 17 = &0000 (    0)
 EQUB &00               \ Sub-section 18 = &0000 (    0)
 EQUB &09               \ Sub-section 19 = &0509 ( 1289)
 EQUB &9B               \ Sub-section 20 = &079B ( 1947)
 EQUB &00               \ Sub-section 21 = &0000 (    0)
 EQUB &00               \ Sub-section 22 = &0000 (    0)
 EQUB &00               \ Sub-section 23 = &0000 (    0)
 EQUB &00               \ Sub-section 24 = &0000 (    0)
 EQUB &00               \ Sub-section 25 = &0000 (    0)
 EQUB &00               \ Sub-section 26 = &0000 (    0)
 EQUB &FD               \ Sub-section 27 = &02FD (  765)
 EQUB &D6               \ Sub-section 28 = &01D6 (  470)
 EQUB &00               \ Sub-section 29 = &0000 (    0)
 EQUB &B0               \ Sub-section 30 = &00B0 (  176)
 EQUB &00               \ Sub-section 31 = &0000 (    0)
 EQUB &CD               \ Sub-section 32 = &FECD ( -307)
 EQUB &00               \ Sub-section 33 = &0000 (    0)
 EQUB &00               \ Sub-section 34 = &0000 (    0)
 EQUB &A5               \ Sub-section 35 = &FFA5 (  -91)
 EQUB &D2               \ Sub-section 36 = &FFD2 (  -46)
 EQUB &1C               \ Sub-section 37 = &FF1C ( -228)
 EQUB &00               \ Sub-section 38 = &0000 (    0)
 EQUB &FE               \ Sub-section 39 = &00FE (  254)
 EQUB &CD               \ Sub-section 40 = &04CD ( 1229)
 EQUB &4E               \ Sub-section 41 = &014E (  334)
 EQUB &0D               \ Sub-section 42 = &020D (  525)
 EQUB &0D               \ Sub-section 43 = &020D (  525)
 EQUB &00               \ Sub-section 44 = &0000 (    0)
 EQUB &7D               \ Sub-section 45 = &FF7D ( -131)
 EQUB &E4               \ Sub-section 46 = &00E4 (  228)
 EQUB &00               \ Sub-section 47 = &0000 (    0)
 EQUB &00               \ Sub-section 48 = &0000 (    0)
 EQUB &8A               \ Sub-section 49 = &018A (  394)
 EQUB &74               \ Sub-section 50 = &0574 ( 1396)
 EQUB &74               \ Sub-section 51 = &0574 ( 1396)
 EQUB &42               \ Sub-section 52 = &0042 (   66)
 EQUB &42               \ Sub-section 53 = &0042 (   66)
 EQUB &3F               \ Sub-section 54 = &FE3F ( -449)
 EQUB &00               \ Sub-section 55 = &0000 (    0)
 EQUB &39               \ Sub-section 56 = &FE39 ( -455)
 EQUB &00               \ Sub-section 57 = &0000 (    0)

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

 EQUB   3               \ Sign  0 = (  3 << 6, -26 << 4,  49 << 6) + section  0
 EQUB  -7               \ Sign  1 = ( -7 << 6,   8 << 4,  26 << 6) + section  2
 EQUB  20               \ Sign  2 = ( 20 << 6,   6 << 4,   6 << 6) + section  3
 EQUB   4               \ Sign  3 = (  4 << 6,   7 << 4,   7 << 6) + section  5
 EQUB   4               \ Sign  4 = (  4 << 6,   7 << 4,   0 << 6) + section  7
 EQUB -11               \ Sign  5 = (-11 << 6,  24 << 4,  34 << 6) + section  9
 EQUB  22               \ Sign  6 = ( 22 << 6,   8 << 4, -76 << 6) + section 12
 EQUB  -6               \ Sign  7 = ( -6 << 6,   1 << 4,  13 << 6) + section 14
 EQUB  44               \ Sign  8 = ( 44 << 6,  24 << 4, -75 << 6) + section 14
 EQUB -34               \ Sign  9 = (-34 << 6, -14 << 4,  76 << 6) + section 14
 EQUB  -4               \ Sign 10 = ( -4 << 6, -12 << 4, -25 << 6) + section 18
 EQUB  -9               \ Sign 11 = ( -9 << 6,  36 << 4, -15 << 6) + section 19
 EQUB   2               \ Sign 12 = (  2 << 6,  22 << 4,  61 << 6) + section 20
 EQUB -21               \ Sign 13 = (-21 << 6,   9 << 4, -25 << 6) + section 21
 EQUB  76               \ Sign 14 = ( 76 << 6,   4 << 4,  -2 << 6) + section 22
 EQUB -16               \ Sign 15 = (-16 << 6,  -8 << 4, -23 << 6) + section 23

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
 BMI upda1              \ upda1 to move to the next segment in that direction

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

 RTS                    \ Return from the subroutine

 EQUB &A9, &8D          \ These bytes pad the routine out to exactly 40 bytes
 EQUB &10, &13
 EQUB &A9, &10
 EQUB &8D, &11
 EQUB &13, &60
 EQUB &00, &00
 EQUB &00, &00

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
 EQUB &FF               \ Sub-section  3 = -1
 EQUB &00               \ Sub-section  4 =  0
 EQUB &07               \ Sub-section  5 =  7
 EQUB &FC               \ Sub-section  6 = -4
 EQUB &00               \ Sub-section  7 =  0
 EQUB &FE               \ Sub-section  8 = -2
 EQUB &FD               \ Sub-section  9 = -3
 EQUB &00               \ Sub-section 10 =  0
 EQUB &01               \ Sub-section 11 =  1
 EQUB &01               \ Sub-section 12 =  1
 EQUB &01               \ Sub-section 13 =  1
 EQUB &01               \ Sub-section 14 =  1
 EQUB &00               \ Sub-section 15 =  0
 EQUB &FD               \ Sub-section 16 = -3
 EQUB &00               \ Sub-section 17 =  0
 EQUB &00               \ Sub-section 18 =  0
 EQUB &00               \ Sub-section 19 =  0
 EQUB &01               \ Sub-section 20 =  1
 EQUB &01               \ Sub-section 21 =  1
 EQUB &FF               \ Sub-section 22 = -1
 EQUB &FE               \ Sub-section 23 = -2
 EQUB &02               \ Sub-section 24 =  2
 EQUB &02               \ Sub-section 25 =  2
 EQUB &FF               \ Sub-section 26 = -1
 EQUB &FF               \ Sub-section 27 = -1
 EQUB &F9               \ Sub-section 28 = -7
 EQUB &00               \ Sub-section 29 =  0
 EQUB &04               \ Sub-section 30 =  4
 EQUB &05               \ Sub-section 31 =  5
 EQUB &FD               \ Sub-section 32 = -3
 EQUB &FC               \ Sub-section 33 = -4
 EQUB &00               \ Sub-section 34 =  0
 EQUB &00               \ Sub-section 35 =  0
 EQUB &00               \ Sub-section 36 =  0
 EQUB &FF               \ Sub-section 37 = -1
 EQUB &00               \ Sub-section 38 =  0
 EQUB &00               \ Sub-section 39 =  0
 EQUB &00               \ Sub-section 40 =  0
 EQUB &01               \ Sub-section 41 =  1
 EQUB &07               \ Sub-section 42 =  7
 EQUB &F5               \ Sub-section 43 = -11
 EQUB &00               \ Sub-section 44 =  0
 EQUB &03               \ Sub-section 45 =  3
 EQUB &FD               \ Sub-section 46 = -3
 EQUB &00               \ Sub-section 47 =  0
 EQUB &FF               \ Sub-section 48 = -1
 EQUB &01               \ Sub-section 49 =  1
 EQUB &09               \ Sub-section 50 =  9
 EQUB &F6               \ Sub-section 51 = -10
 EQUB &06               \ Sub-section 52 =  6
 EQUB &FC               \ Sub-section 53 = -4
 EQUB &FE               \ Sub-section 54 = -2
 EQUB &00               \ Sub-section 55 =  0
 EQUB &02               \ Sub-section 56 =  2
 EQUB &01               \ Sub-section 57 =  1

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

 EQUB -26               \ Sign  0 = (  3 << 6, -26 << 4,  49 << 6) + section  0
 EQUB   8               \ Sign  1 = ( -7 << 6,   8 << 4,  26 << 6) + section  2
 EQUB   6               \ Sign  2 = ( 20 << 6,   6 << 4,   6 << 6) + section  3
 EQUB   7               \ Sign  3 = (  4 << 6,   7 << 4,   7 << 6) + section  5
 EQUB   7               \ Sign  4 = (  4 << 6,   7 << 4,   0 << 6) + section  7
 EQUB  24               \ Sign  5 = (-11 << 6,  24 << 4,  34 << 6) + section  9
 EQUB   8               \ Sign  6 = ( 22 << 6,   8 << 4, -76 << 6) + section 12
 EQUB   1               \ Sign  7 = ( -6 << 6,   1 << 4,  13 << 6) + section 14
 EQUB  24               \ Sign  8 = ( 44 << 6,  24 << 4, -75 << 6) + section 14
 EQUB -14               \ Sign  9 = (-34 << 6, -14 << 4,  76 << 6) + section 14
 EQUB -12               \ Sign 10 = ( -4 << 6, -12 << 4, -25 << 6) + section 18
 EQUB  36               \ Sign 11 = ( -9 << 6,  36 << 4, -15 << 6) + section 19
 EQUB  22               \ Sign 12 = (  2 << 6,  22 << 4,  61 << 6) + section 20
 EQUB   9               \ Sign 13 = (-21 << 6,   9 << 4, -25 << 6) + section 21
 EQUB   4               \ Sign 14 = ( 76 << 6,   4 << 4,  -2 << 6) + section 22
 EQUB  -8               \ Sign 15 = (-16 << 6,  -8 << 4, -23 << 6) + section 23

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
\ ------------------------------------------------------------------------------
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
\ ------------------------------------------------------------------------------
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
                        \ field of view, jump to gseg13 via fovw1

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
\ ------------------------------------------------------------------------------
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
\       Name: ModifyGameCode (Part 1 of 3)
\       Type: Subroutine
\   Category: Extra tracks
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

 EQUB 2                 \ Sub-section  0
 EQUB 18                \ Sub-section  1
 EQUB 3                 \ Sub-section  2
 EQUB 22                \ Sub-section  3
 EQUB 8                 \ Sub-section  4
 EQUB 6                 \ Sub-section  5
 EQUB 5                 \ Sub-section  6
 EQUB 24                \ Sub-section  7
 EQUB 6                 \ Sub-section  8
 EQUB 4                 \ Sub-section  9
 EQUB 18                \ Sub-section 10
 EQUB 10                \ Sub-section 11
 EQUB 21                \ Sub-section 12
 EQUB 8                 \ Sub-section 13
 EQUB 2                 \ Sub-section 14
 EQUB 6                 \ Sub-section 15
 EQUB 10                \ Sub-section 16
 EQUB 14                \ Sub-section 17
 EQUB 2                 \ Sub-section 18
 EQUB 3                 \ Sub-section 19
 EQUB 14                \ Sub-section 20
 EQUB 20                \ Sub-section 21
 EQUB 20                \ Sub-section 22
 EQUB 10                \ Sub-section 23
 EQUB 10                \ Sub-section 24
 EQUB 16                \ Sub-section 25
 EQUB 6                 \ Sub-section 26
 EQUB 10                \ Sub-section 27
 EQUB 6                 \ Sub-section 28
 EQUB 24                \ Sub-section 29
 EQUB 7                 \ Sub-section 30
 EQUB 13                \ Sub-section 31
 EQUB 13                \ Sub-section 32
 EQUB 6                 \ Sub-section 33
 EQUB 13                \ Sub-section 34
 EQUB 5                 \ Sub-section 35
 EQUB 20                \ Sub-section 36
 EQUB 9                 \ Sub-section 37
 EQUB 21                \ Sub-section 38
 EQUB 7                 \ Sub-section 39
 EQUB 3                 \ Sub-section 40
 EQUB 12                \ Sub-section 41
 EQUB 8                 \ Sub-section 42
 EQUB 7                 \ Sub-section 43
 EQUB 14                \ Sub-section 44
 EQUB 9                 \ Sub-section 45
 EQUB 2                 \ Sub-section 46
 EQUB 22                \ Sub-section 47
 EQUB 12                \ Sub-section 48
 EQUB 6                 \ Sub-section 49
 EQUB 4                 \ Sub-section 50
 EQUB 8                 \ Sub-section 51
 EQUB 17                \ Sub-section 52
 EQUB 16                \ Sub-section 53
 EQUB 8                 \ Sub-section 54
 EQUB 17                \ Sub-section 55
 EQUB 2                 \ Sub-section 56
 EQUB 19                \ Sub-section 57

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

 EQUB  49               \ Sign  0 = (  3 << 6, -26 << 4,  49 << 6) + section  0
 EQUB  26               \ Sign  1 = ( -7 << 6,   8 << 4,  26 << 6) + section  2
 EQUB   6               \ Sign  2 = ( 20 << 6,   6 << 4,   6 << 6) + section  3
 EQUB   7               \ Sign  3 = (  4 << 6,   7 << 4,   7 << 6) + section  5
 EQUB   0               \ Sign  4 = (  4 << 6,   7 << 4,   0 << 6) + section  7
 EQUB  34               \ Sign  5 = (-11 << 6,  24 << 4,  34 << 6) + section  9
 EQUB -76               \ Sign  6 = ( 22 << 6,   8 << 4, -76 << 6) + section 12
 EQUB  13               \ Sign  7 = ( -6 << 6,   1 << 4,  13 << 6) + section 14
 EQUB -75               \ Sign  8 = ( 44 << 6,  24 << 4, -75 << 6) + section 14
 EQUB  76               \ Sign  9 = (-34 << 6, -14 << 4,  76 << 6) + section 14
 EQUB -25               \ Sign 10 = ( -4 << 6, -12 << 4, -25 << 6) + section 18
 EQUB -15               \ Sign 11 = ( -9 << 6,  36 << 4, -15 << 6) + section 19
 EQUB  61               \ Sign 12 = (  2 << 6,  22 << 4,  61 << 6) + section 20
 EQUB -25               \ Sign 13 = (-21 << 6,   9 << 4, -25 << 6) + section 21
 EQUB  -2               \ Sign 14 = ( 76 << 6,   4 << 4,  -2 << 6) + section 22
 EQUB -23               \ Sign 15 = (-16 << 6,  -8 << 4, -23 << 6) + section 23

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
\ This routine is called from GetTrackAndMarkers. It does the following:
\
\  * Cut objects off at the track line in A rather than horizonLine
\
\  * Collapse the left verge of the track into the right verge, but only for a
\    few entries just in front of the horizon section, i.e. for the track
\    section list and the first three entries in the track segment list
\
\ ------------------------------------------------------------------------------
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

 INY                    \ Increment the verge buffer index

 CPY #9                 \ Loop back until we have processed up to index 8
 BCC coll1

 LDY horizonListIndex   \ Restore the value of Y that we had on entering the
                        \ hook routine

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: HookJoystick (Part 1 of 2)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Apply enhanced joystick steering to specific track sections
\  Deep dive: Secrets of the extra tracks
\             Code hooks in the extra tracks
\
\ ------------------------------------------------------------------------------
\
\ This routine is called from ProcessDrivingKeys to scale the steering in the
\ following sections to make it easier to steer when using a joystick:
\
\   * Section 9: scale the steering by 1.88
\
\   * Section 22: scale the steering by 1.10
\
\   * Section 23: scale the steering by 1.10
\
\ Specifically, the scaling is applied as follows:
\
\   (A T) = scale_factor * x-axis ^ 2
\
\ which replaces this existing code in ProcessDrivingKeys:
\
\   (A T) = x-axis^2
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   U                   The joystick x-axis high byte
\
\ ******************************************************************************

.HookJoystick

 LDY currentPlayer      \ Set A to the track section number * 8 for the current
 LDA objTrackSection,Y  \ player

 LDY #181               \ Set Y = 181 so by default we scale the steering by
                        \ 1.00

 CMP #72                \ If the track section <> 72 (i.e. section 9), jump to
 BNE joys1              \ joys1 to keep checking

 LDY #248               \ Set Y = 248 so we scale the steering by 1.88

.joys1

 CMP #184               \ If the track section = 184 (i.e. section 23), jump to
 BEQ joys2              \ joys2 to scale the steering by 1.10

 CMP #176               \ If the track section <> 176 (i.e. section 22), jump to
 BNE joys3              \ joys3 to keep checking

.joys2

 LDY #190               \ Set Y = 190 so we scale the steering by 1.10

.joys3

 TYA                    \ Set A = Y
                        \
                        \ So A is 181, 190 or 248

 JSR Multiply8x8        \ Set (A T) = A * U

 JMP joys4              \ Jump to part 2

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

 LDA #&20               \ ?&1248 = &20 (opcode for a JSR instruction)
 STA &1248

 STA &12FB              \ ?&12FB = &20 (opcode for a JSR instruction)

 STA &2538              \ ?&2538 = &20 (opcode for a JSR instruction)

 STA &45CB              \ ?&45CB = &20 (opcode for a JSR instruction)

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

\ ******************************************************************************
\
\       Name: trackSlope
\       Type: Variable
\   Category: Extra tracks
\    Summary: The slope at the start of each track section
\
\ ******************************************************************************

.trackSlope

 EQUB &00               \ Section  0 =   0
 EQUB &E7               \ Section  1 = -25
 EQUB &FD               \ Section  2 =  -3
 EQUB &FD               \ Section  3 =  -3
 EQUB &FD               \ Section  4 =  -3
 EQUB &F1               \ Section  5 = -15
 EQUB &E5               \ Section  6 = -27
 EQUB &0E               \ Section  7 =  14
 EQUB &0E               \ Section  8 =  14
 EQUB &F0               \ Section  9 = -16
 EQUB &FE               \ Section 10 =  -2
 EQUB &FE               \ Section 11 =  -2
 EQUB &FE               \ Section 12 =  -2
 EQUB &FE               \ Section 13 =  -2
 EQUB &18               \ Section 14 =  24
 EQUB &E4               \ Section 15 = -28
 EQUB &41               \ Section 16 =  65
 EQUB &1A               \ Section 17 =  26
 EQUB &02               \ Section 18 =   2
 EQUB &F9               \ Section 19 =  -7
 EQUB &F0               \ Section 20 = -16
 EQUB &0B               \ Section 21 =  11
 EQUB &0B               \ Section 22 =  11
 EQUB &FF               \ Section 23 =  -1
 EQUB &D3               \ Section 24 = -45
 EQUB &F9               \ Section 24 =  -7
 EQUB &E9               \ Section 24 = -23

 EQUB &E6, &FF          \ These bytes appear to be unused
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
 EQUB &07               \ Section  1 = &FB07 = 64263 = 353.0 degrees
 EQUB &7D               \ Section  2 = &327D = 12925 =  71.0 degrees
 EQUB &7D               \ Section  3 = &327D = 12925 =  71.0 degrees
 EQUB &4D               \ Section  4 = &354D = 13645 =  75.0 degrees
 EQUB &F7               \ Section  5 = &3FF7 = 16375 =  90.0 degrees
 EQUB &F7               \ Section  6 = &3FF7 = 16375 =  90.0 degrees
 EQUB &B6               \ Section  7 = &F1B6 = 61878 = 339.9 degrees
 EQUB &B6               \ Section  8 = &F1B6 = 61878 = 339.9 degrees
 EQUB &26               \ Section  9 = &F326 = 62246 = 341.9 degrees
 EQUB &BB               \ Section 10 = &6CBB = 27835 = 152.9 degrees
 EQUB &BB               \ Section 11 = &6CBB = 27835 = 152.9 degrees
 EQUB &BB               \ Section 12 = &6CBB = 27835 = 152.9 degrees
 EQUB &BB               \ Section 13 = &6CBB = 27835 = 152.9 degrees
 EQUB &BB               \ Section 14 = &6CBB = 27835 = 152.9 degrees
 EQUB &A1               \ Section 15 = &95A1 = 38305 = 210.4 degrees
 EQUB &71               \ Section 16 = &9A71 = 39537 = 217.2 degrees
 EQUB &DA               \ Section 17 = &8ADA = 35546 = 195.3 degrees
 EQUB &7B               \ Section 18 = &857B = 34171 = 187.7 degrees
 EQUB &69               \ Section 19 = &8469 = 33897 = 186.2 degrees
 EQUB &3B               \ Section 20 = &C13B = 49467 = 271.7 degrees
 EQUB &A0               \ Section 21 = &BCA0 = 48288 = 265.3 degrees
 EQUB &A0               \ Section 22 = &BCA0 = 48288 = 265.3 degrees
 EQUB &A4               \ Section 23 = &C7A4 = 51108 = 280.7 degrees
 EQUB &14               \ Section 24 = &0914 =  2324 =  12.8 degrees
 EQUB &96               \ Section 24 = &1196 =  4502 =  24.7 degrees
 EQUB &8E               \ Section 24 = &038E =   910 =   5.0 degrees

 EQUB &28, &C8          \ These bytes appear to be unused
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
 EQUB &FB               \ Section  1 = &FB07 = 64263 = 353.0 degrees
 EQUB &32               \ Section  2 = &327D = 12925 =  71.0 degrees
 EQUB &32               \ Section  3 = &327D = 12925 =  71.0 degrees
 EQUB &35               \ Section  4 = &354D = 13645 =  75.0 degrees
 EQUB &3F               \ Section  5 = &3FF7 = 16375 =  90.0 degrees
 EQUB &3F               \ Section  6 = &3FF7 = 16375 =  90.0 degrees
 EQUB &F1               \ Section  7 = &F1B6 = 61878 = 339.9 degrees
 EQUB &F1               \ Section  8 = &F1B6 = 61878 = 339.9 degrees
 EQUB &F3               \ Section  9 = &F326 = 62246 = 341.9 degrees
 EQUB &6C               \ Section 10 = &6CBB = 27835 = 152.9 degrees
 EQUB &6C               \ Section 11 = &6CBB = 27835 = 152.9 degrees
 EQUB &6C               \ Section 12 = &6CBB = 27835 = 152.9 degrees
 EQUB &6C               \ Section 13 = &6CBB = 27835 = 152.9 degrees
 EQUB &6C               \ Section 14 = &6CBB = 27835 = 152.9 degrees
 EQUB &95               \ Section 15 = &95A1 = 38305 = 210.4 degrees
 EQUB &9A               \ Section 16 = &9A71 = 39537 = 217.2 degrees
 EQUB &8A               \ Section 17 = &8ADA = 35546 = 195.3 degrees
 EQUB &85               \ Section 18 = &857B = 34171 = 187.7 degrees
 EQUB &84               \ Section 19 = &8469 = 33897 = 186.2 degrees
 EQUB &C1               \ Section 20 = &C13B = 49467 = 271.7 degrees
 EQUB &BC               \ Section 21 = &BCA0 = 48288 = 265.3 degrees
 EQUB &BC               \ Section 22 = &BCA0 = 48288 = 265.3 degrees
 EQUB &C7               \ Section 23 = &C7A4 = 51108 = 280.7 degrees
 EQUB &09               \ Section 24 = &0914 =  2324 =  12.8 degrees
 EQUB &11               \ Section 24 = &1196 =  4502 =  24.7 degrees
 EQUB &03               \ Section 24 = &038E =   910 =   5.0 degrees

 EQUB &DF, &F3          \ These bytes appear to be unused
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

 EQUB %00000010         \ Section  0 = 000000 1 0    From  0  no check  curve
 EQUB %00010010         \ Section  1 = 000100 1 0    From  4  no check  curve
 EQUB %00011111         \ Section  2 = 000111 1 1    From  7  no check  straight
 EQUB %00011110         \ Section  3 = 000111 1 0    From  7  no check  curve
 EQUB %00100010         \ Section  4 = 001000 1 0    From  8  no check  curve
 EQUB %00100110         \ Section  5 = 001001 1 0    From  9  no check  curve
 EQUB %00101110         \ Section  6 = 001011 1 0    From 11  no check  curve
 EQUB %00111111         \ Section  7 = 001111 1 1    From 15  no check  straight
 EQUB %00111110         \ Section  8 = 001111 1 0    From 15  no check  curve
 EQUB %01001010         \ Section  9 = 010010 1 0    From 18  no check  curve
 EQUB %01010110         \ Section 10 = 010101 1 0    From 21  no check  curve
 EQUB %01011110         \ Section 11 = 010111 1 0    From 23  no check  curve
 EQUB %01100111         \ Section 12 = 011001 1 1    From 25  no check  straight
 EQUB %01100110         \ Section 13 = 011001 1 0    From 25  no check  curve
 EQUB %01101110         \ Section 14 = 011011 1 0    From 27  no check  curve
 EQUB %01110110         \ Section 15 = 011101 1 0    From 29  no check  curve
 EQUB %10000010         \ Section 16 = 100000 1 0    From 32  no check  curve
 EQUB %10000110         \ Section 17 = 100001 1 0    From 33  no check  curve
 EQUB %10010110         \ Section 18 = 100101 1 0    From 37  no check  curve
 EQUB %10100010         \ Section 19 = 101000 1 0    From 40  no check  curve
 EQUB %10110010         \ Section 20 = 101100 1 0    From 44  no check  curve
 EQUB %10111011         \ Section 21 = 101110 1 1    From 46  no check  straight
 EQUB %10111010         \ Section 22 = 101110 1 0    From 46  no check  curve
 EQUB %11001010         \ Section 23 = 110010 1 0    From 50  no check  curve
 EQUB %11010010         \ Section 24 = 110100 1 0    From 52  no check  curve
 EQUB %11011010         \ Section 25 = 110110 1 0    From 54  no check  curve
 EQUB %11011110         \ Section 26 = 110111 1 0    From 55  no check  curve

 EQUB &DA, &E2          \ These bytes appear to be unused
 EQUB &00

\ ******************************************************************************
\
\       Name: trackSteering
\       Type: Variable
\   Category: Extra tracks
\    Summary: The optimum steering for non-player drivers on each track section
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Oulton Park track
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
 EQUB %01001011         \ Section  1 = 010010 1 1            -> 18
 EQUB %00011000         \ Section  2 = 000110 0 0            <- 6*
 EQUB %00011001         \ Section  3 = 000110 0 1            -> 6*
 EQUB %00110001         \ Section  4 = 001100 0 1            -> 12*
 EQUB %00110001         \ Section  5 = 001100 0 1            -> 12*
 EQUB %00101110         \ Section  6 = 001011 1 0            <- 11
 EQUB %00011000         \ Section  7 = 000110 0 0            <- 6*
 EQUB %00000000         \ Section  8 = 000000 0 0            <- 0*
 EQUB %01001011         \ Section  9 = 010010 1 1            -> 18
 EQUB %00011000         \ Section 10 = 000110 0 0            <- 6*
 EQUB %00011000         \ Section 11 = 000110 0 0            <- 6*
 EQUB %00011000         \ Section 12 = 000110 0 0            <- 6*
 EQUB %00011000         \ Section 13 = 000110 0 0            <- 6*
 EQUB %00111111         \ Section 14 = 001111 1 1            -> 15
 EQUB %01010101         \ Section 15 = 010101 0 1            -> 21*
 EQUB %01000100         \ Section 16 = 010001 0 0            <- 17*
 EQUB %00011000         \ Section 17 = 000110 0 0            <- 6*
 EQUB %00011000         \ Section 18 = 000110 0 0            <- 6*
 EQUB %00110111         \ Section 19 = 001101 1 1            -> 13
 EQUB %00011000         \ Section 20 = 000110 0 0            <- 6*
 EQUB %00011000         \ Section 21 = 000110 0 0            <- 6*
 EQUB %00011000         \ Section 22 = 000110 0 0            <- 6*
 EQUB %01000111         \ Section 23 = 010001 1 1            -> 17
 EQUB %00011001         \ Section 24 = 000110 0 1            -> 6*
 EQUB %00110100         \ Section 25 = 001101 0 0            <- 13*
 EQUB %00011000         \ Section 26 = 000110 0 0            <- 6*

 EQUB &18, &18          \ These bytes appear to be unused
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
\             The Oulton Park track
\
\ ------------------------------------------------------------------------------
\
\ Oulton Park consists of the following track sections:
\
\   0    |<-|   Lodge to Old Hall (4/4)
\   1    ->     Old Hall
\   2    ||     Old Hall to Cascades (1/4)
\   3    ->     Old Hall to Cascades (2/4)
\   4    ->     Old Hall to Cascades (3/4)
\   5    {}     Old Hall to Cascades (4/4)
\   6    <-     Cascades
\   7    ||     Cascades to Island Hairpin (1/2)
\   8    |->|   Cascades to Island Hairpin (2/2)
\   9    |->|   Island Hairpin
\   10   {}     Island Hairpin to Knickerbrook (1/4)
\   11   {}     Island Hairpin to Knickerbrook (2/4)
\   12   ||     Island Hairpin to Knickerbrook (3/4)
\   13   {}     Island Hairpin to Knickerbrook (4/4)
\   14   ->     Knickerbrook
\   15   |->|   Knickerbrook to Druids (1/4)
\   16   <-     Knickerbrook to Druids (2/4)
\   17   |<-|   Knickerbrook to Druids (3/4)
\   18   |<->|  Knickerbrook to Druids (4/4)
\   19   ->     Druids
\   20   |<-|   Druids to Lodge (1/3)
\   21   ||     Druids to Lodge (2/3)
\   22   |->|   Druids to Lodge (3/3)
\   23   ->     Lodge
\   24   ->     Lodge to Old Hall (1/4)
\   25   <-     Lodge to Old Hall (2/4)
\   26   |<-|   Lodge to Old Hall (3/4)
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
\                         * Bit 7: Section has a maximum speed (Sp)
\
\                           * 0 = this section has no maximum speed
\
\                           * 1 = this section has a maximum speed
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

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &20               \ xTrackSectionILo       xTrackSectionI = &D120 = -12000
 EQUB &00               \ yTrackSectionILo       yTrackSectionI = &1200 =   4608
 EQUB &20               \ zTrackSectionILo       zTrackSectionI = &D120 = -12000
 EQUB &30               \ xTrackSectionOLo       xTrackSectionO = &D030 = -12240
 EQUB 0                 \ trackSectionFrom
 EQUB &20               \ zTrackSectionOLo       zTrackSectionO = &D120 = -12000
 EQUB 45                \ trackSectionSize

                        \ Track section 1

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &C3               \ xTrackSectionILo       xTrackSectionI = &CEC3 = -12605
 EQUB &BB               \ yTrackSectionILo       yTrackSectionI = &10BB =   4283
 EQUB &0C               \ zTrackSectionILo       zTrackSectionI = &E60C =  -6644
 EQUB &D5               \ xTrackSectionOLo       xTrackSectionO = &CDD5 = -12843
 EQUB 5                 \ trackSectionFrom
 EQUB &EE               \ zTrackSectionOLo       zTrackSectionO = &E5EE =  -6674
 EQUB 19                \ trackSectionSize

                        \ Track section 2

 EQUB %00000010         \ trackSectionFlag       Sp=0 G=0 Mc=0 Mlr=00 Vc=01 Sh=0
 EQUB &25               \ xTrackSectionILo       xTrackSectionI = &D225 = -11739
 EQUB &09               \ yTrackSectionILo       yTrackSectionI = &1009 =   4105
 EQUB &6B               \ zTrackSectionILo       zTrackSectionI = &ED6B =  -4757
 EQUB &D5               \ xTrackSectionOLo       xTrackSectionO = &D1D5 = -11819
 EQUB 24                \ trackSectionFrom
 EQUB &4D               \ zTrackSectionOLo       zTrackSectionO = &EE4D =  -4531
 EQUB 37                \ trackSectionSize

                        \ Track section 3

 EQUB %01000000         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &7A               \ xTrackSectionILo       xTrackSectionI = &E27A =  -7558
 EQUB &9A               \ yTrackSectionILo       yTrackSectionI = &0F9A =   3994
 EQUB &33               \ zTrackSectionILo       zTrackSectionI = &F333 =  -3277
 EQUB &2A               \ xTrackSectionOLo       xTrackSectionO = &E22A =  -7638
 EQUB 25                \ trackSectionFrom
 EQUB &15               \ zTrackSectionOLo       zTrackSectionO = &F415 =  -3051
 EQUB 24                \ trackSectionSize

                        \ Track section 4

 EQUB %01000000         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &35               \ xTrackSectionILo       xTrackSectionI = &ED35 =  -4811
 EQUB &52               \ yTrackSectionILo       yTrackSectionI = &0F52 =   3922
 EQUB &8A               \ zTrackSectionILo       zTrackSectionI = &F68A =  -2422
 EQUB &F5               \ xTrackSectionOLo       xTrackSectionO = &ECF5 =  -4875
 EQUB 9                 \ trackSectionFrom
 EQUB &72               \ zTrackSectionOLo       zTrackSectionO = &F772 =  -2190
 EQUB 6                 \ trackSectionSize

                        \ Track section 5

 EQUB %01101000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=00 Sh=0
 EQUB &FE               \ xTrackSectionILo       xTrackSectionI = &EFFE =  -4098
 EQUB &16               \ yTrackSectionILo       yTrackSectionI = &0F16 =   3862
 EQUB &DD               \ zTrackSectionILo       zTrackSectionI = &F6DD =  -2339
 EQUB &FC               \ xTrackSectionOLo       xTrackSectionO = &EFFC =  -4100
 EQUB 15                \ trackSectionFrom
 EQUB &CD               \ zTrackSectionOLo       zTrackSectionO = &F7CD =  -2099
 EQUB 22                \ trackSectionSize

                        \ Track section 6

 EQUB %11110011         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &4E               \ xTrackSectionILo       xTrackSectionI = &FA4E =  -1458
 EQUB &D6               \ yTrackSectionILo       yTrackSectionI = &0CD6 =   3286
 EQUB &F3               \ zTrackSectionILo       zTrackSectionI = &F6F3 =  -2317
 EQUB &4C               \ xTrackSectionOLo       xTrackSectionO = &FA4C =  -1460
 EQUB 37                \ trackSectionFrom
 EQUB &E3               \ zTrackSectionOLo       zTrackSectionO = &F7E3 =  -2077
 EQUB 41                \ trackSectionSize

                        \ Track section 7

 EQUB %00000100         \ trackSectionFlag       Sp=0 G=0 Mc=0 Mlr=00 Vc=10 Sh=0
 EQUB &2D               \ xTrackSectionILo       xTrackSectionI = &032D =    813
 EQUB &E0               \ yTrackSectionILo       yTrackSectionI = &0BE0 =   3040
 EQUB &93               \ zTrackSectionILo       zTrackSectionI = &0493 =   1171
 EQUB &4D               \ xTrackSectionOLo       xTrackSectionO = &024D =    589
 EQUB 38                \ trackSectionFrom
 EQUB &3F               \ zTrackSectionOLo       zTrackSectionO = &043F =   1087
 EQUB 64                \ trackSectionSize

                        \ Track section 8

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &AD               \ xTrackSectionILo       xTrackSectionI = &F8AD =  -1875
 EQUB &60               \ yTrackSectionILo       yTrackSectionI = &0F60 =   3936
 EQUB &93               \ zTrackSectionILo       zTrackSectionI = &2093 =   8339
 EQUB &CD               \ xTrackSectionOLo       xTrackSectionO = &F7CD =  -2099
 EQUB 39                \ trackSectionFrom
 EQUB &3F               \ zTrackSectionOLo       zTrackSectionO = &203F =   8255
 EQUB 30                \ trackSectionSize

                        \ Track section 9

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &1D               \ xTrackSectionILo       xTrackSectionI = &F41D =  -3043
 EQUB &BB               \ yTrackSectionILo       yTrackSectionI = &0EBB =   3771
 EQUB &DE               \ zTrackSectionILo       zTrackSectionI = &2DDE =  11742
 EQUB &39               \ xTrackSectionOLo       xTrackSectionO = &F339 =  -3271
 EQUB 29                \ trackSectionFrom
 EQUB &92               \ zTrackSectionOLo       zTrackSectionO = &2D92 =  11666
 EQUB 19                \ trackSectionSize

                        \ Track section 10

 EQUB %01000010         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=01 Sh=0
 EQUB &88               \ xTrackSectionILo       xTrackSectionI = &F888 =  -1912
 EQUB &F4               \ yTrackSectionILo       yTrackSectionI = &0DF4 =   3572
 EQUB &C0               \ zTrackSectionILo       zTrackSectionI = &30C0 =  12480
 EQUB &5E               \ xTrackSectionOLo       xTrackSectionO = &F95E =  -1698
 EQUB 8                 \ trackSectionFrom
 EQUB &2E               \ zTrackSectionOLo       zTrackSectionO = &312E =  12590
 EQUB 40                \ trackSectionSize

                        \ Track section 11

 EQUB %01000000         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &20               \ xTrackSectionILo       xTrackSectionI = &0120 =    288
 EQUB &34               \ yTrackSectionILo       yTrackSectionI = &0F34 =   3892
 EQUB &08               \ zTrackSectionILo       zTrackSectionI = &2008 =   8200
 EQUB &F6               \ xTrackSectionOLo       xTrackSectionO = &01F6 =    502
 EQUB 8                 \ trackSectionFrom
 EQUB &76               \ zTrackSectionOLo       zTrackSectionO = &2076 =   8310
 EQUB 20                \ trackSectionSize

                        \ Track section 12

 EQUB %00000000         \ trackSectionFlag       Sp=0 G=0 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &6C               \ xTrackSectionILo       xTrackSectionI = &056C =   1388
 EQUB &44               \ yTrackSectionILo       yTrackSectionI = &0E44 =   3652
 EQUB &AC               \ zTrackSectionILo       zTrackSectionI = &17AC =   6060
 EQUB &42               \ xTrackSectionOLo       xTrackSectionO = &0642 =   1602
 EQUB 28                \ trackSectionFrom
 EQUB &1A               \ zTrackSectionOLo       zTrackSectionO = &181A =   6170
 EQUB 59                \ trackSectionSize

                        \ Track section 13

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &19               \ xTrackSectionILo       xTrackSectionI = &1219 =   4633
 EQUB &CE               \ yTrackSectionILo       yTrackSectionI = &0DCE =   3534
 EQUB &03               \ zTrackSectionILo       zTrackSectionI = &FF03 =   -253
 EQUB &EF               \ xTrackSectionOLo       xTrackSectionO = &12EF =   4847
 EQUB 29                \ trackSectionFrom
 EQUB &71               \ zTrackSectionOLo       zTrackSectionO = &FF71 =   -143
 EQUB 22                \ trackSectionSize

                        \ Track section 14

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &D3               \ xTrackSectionILo       xTrackSectionI = &16D3 =   5843
 EQUB &5D               \ yTrackSectionILo       yTrackSectionI = &0F5D =   3933
 EQUB &D1               \ zTrackSectionILo       zTrackSectionI = &F5D1 =  -2607
 EQUB &A9               \ xTrackSectionOLo       xTrackSectionO = &17A9 =   6057
 EQUB 11                \ trackSectionFrom
 EQUB &3F               \ zTrackSectionOLo       zTrackSectionO = &F63F =  -2497
 EQUB 16                \ trackSectionSize

                        \ Track section 15

 EQUB %01101010         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=01 Sh=0
 EQUB &0B               \ xTrackSectionILo       xTrackSectionI = &160B =   5643
 EQUB &D7               \ yTrackSectionILo       yTrackSectionI = &0FD7 =   4055
 EQUB &AD               \ zTrackSectionILo       zTrackSectionI = &EEAD =  -4435
 EQUB &DB               \ xTrackSectionOLo       xTrackSectionO = &16DB =   5851
 EQUB 27                \ trackSectionFrom
 EQUB &35               \ zTrackSectionOLo       zTrackSectionO = &EE35 =  -4555
 EQUB 44                \ trackSectionSize

                        \ Track section 16

 EQUB %01110011         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &FC               \ xTrackSectionILo       xTrackSectionI = &0AFC =   2812
 EQUB &AA               \ yTrackSectionILo       yTrackSectionI = &0EAA =   3754
 EQUB &55               \ zTrackSectionILo       zTrackSectionI = &DD55 =  -8875
 EQUB &BC               \ xTrackSectionOLo       xTrackSectionO = &0BBC =   3004
 EQUB 31                \ trackSectionFrom
 EQUB &C7               \ zTrackSectionOLo       zTrackSectionO = &DCC7 =  -9017
 EQUB 13                \ trackSectionSize

                        \ Track section 17

 EQUB %01101000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=00 Sh=0
 EQUB &6B               \ xTrackSectionILo       xTrackSectionI = &086B =   2155
 EQUB &E6               \ yTrackSectionILo       yTrackSectionI = &10E6 =   4326
 EQUB &D9               \ zTrackSectionILo       zTrackSectionI = &D7D9 = -10279
 EQUB &53               \ xTrackSectionOLo       xTrackSectionO = &0953 =   2387
 EQUB 4                 \ trackSectionFrom
 EQUB &9B               \ zTrackSectionOLo       zTrackSectionO = &D79B = -10341
 EQUB 44                \ trackSectionSize

                        \ Track section 18

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &FC               \ xTrackSectionILo       xTrackSectionI = &03FC =   1020
 EQUB &7A               \ yTrackSectionILo       yTrackSectionI = &117A =   4474
 EQUB &BB               \ zTrackSectionILo       zTrackSectionI = &C3BB = -15429
 EQUB &EA               \ xTrackSectionOLo       xTrackSectionO = &04EA =   1258
 EQUB 8                 \ trackSectionFrom
 EQUB &9D               \ zTrackSectionOLo       zTrackSectionO = &C39D = -15459
 EQUB 37                \ trackSectionSize

                        \ Track section 19

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &91               \ xTrackSectionILo       xTrackSectionI = &0491 =   1169
 EQUB &9B               \ yTrackSectionILo       yTrackSectionI = &109B =   4251
 EQUB &65               \ zTrackSectionILo       zTrackSectionI = &B265 = -19867
 EQUB &7F               \ xTrackSectionOLo       xTrackSectionO = &057F =   1407
 EQUB 6                 \ trackSectionFrom
 EQUB &4D               \ zTrackSectionOLo       zTrackSectionO = &B24D = -19891
 EQUB 30                \ trackSectionSize

                        \ Track section 20

 EQUB %01000010         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=01 Sh=0
 EQUB &26               \ xTrackSectionILo       xTrackSectionI = &FA26 =  -1498
 EQUB &1B               \ yTrackSectionILo       yTrackSectionI = &121B =   4635
 EQUB &75               \ zTrackSectionILo       zTrackSectionI = &AA75 = -21899
 EQUB &20               \ xTrackSectionOLo       xTrackSectionO = &FA20 =  -1504
 EQUB 37                \ trackSectionFrom
 EQUB &85               \ zTrackSectionOLo       zTrackSectionO = &A985 = -22139
 EQUB 23                \ trackSectionSize

                        \ Track section 21

 EQUB %00000000         \ trackSectionFlag       Sp=0 G=0 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &5E               \ xTrackSectionILo       xTrackSectionI = &EF5E =  -4258
 EQUB &32               \ yTrackSectionILo       yTrackSectionI = &1132 =   4402
 EQUB &78               \ zTrackSectionILo       zTrackSectionI = &AA78 = -21896
 EQUB &72               \ xTrackSectionOLo       xTrackSectionO = &EF72 =  -4238
 EQUB 21                \ trackSectionFrom
 EQUB &88               \ zTrackSectionOLo       zTrackSectionO = &A988 = -22136
 EQUB 31                \ trackSectionSize

                        \ Track section 22

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &D6               \ xTrackSectionILo       xTrackSectionI = &E0D6 =  -7978
 EQUB &87               \ yTrackSectionILo       yTrackSectionI = &1287 =   4743
 EQUB &42               \ zTrackSectionILo       zTrackSectionI = &A942 = -22206
 EQUB &EA               \ xTrackSectionOLo       xTrackSectionO = &E0EA =  -7958
 EQUB 23                \ trackSectionFrom
 EQUB &52               \ zTrackSectionOLo       zTrackSectionO = &A852 = -22446
 EQUB 42                \ trackSectionSize

                        \ Track section 23

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &2A               \ xTrackSectionILo       xTrackSectionI = &CD2A = -13014
 EQUB &DB               \ yTrackSectionILo       yTrackSectionI = &12DB =   4827
 EQUB &A9               \ zTrackSectionILo       zTrackSectionI = &A8A9 = -22359
 EQUB &FE               \ xTrackSectionOLo       xTrackSectionO = &CCFE = -13058
 EQUB 26                \ trackSectionFrom
 EQUB &BD               \ zTrackSectionOLo       zTrackSectionO = &A7BD = -22595
 EQUB 12                \ trackSectionSize

                        \ Track section 24

 EQUB %01101010         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=01 Sh=0
 EQUB &A8               \ xTrackSectionILo       xTrackSectionI = &CAA8 = -13656
 EQUB &E1               \ yTrackSectionILo       yTrackSectionI = &12E1 =   4833
 EQUB &0C               \ zTrackSectionILo       zTrackSectionI = &AD0C = -21236
 EQUB &BE               \ xTrackSectionOLo       xTrackSectionO = &C9BE = -13890
 EQUB 39                \ trackSectionFrom
 EQUB &40               \ zTrackSectionOLo       zTrackSectionO = &AD40 = -21184
 EQUB 33                \ trackSectionSize

                        \ Track section 25

 EQUB %01110011         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &94               \ xTrackSectionILo       xTrackSectionI = &CF94 = -12396
 EQUB &EA               \ yTrackSectionILo       yTrackSectionI = &14EA =   5354
 EQUB &AC               \ zTrackSectionILo       zTrackSectionI = &BBAC = -17492
 EQUB &BA               \ xTrackSectionOLo       xTrackSectionO = &CEBA = -12614
 EQUB 33                \ trackSectionFrom
 EQUB &10               \ zTrackSectionOLo       zTrackSectionO = &BC10 = -17392
 EQUB 8                 \ trackSectionSize

                        \ Track section 26

 EQUB %01000000         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &72               \ xTrackSectionILo       xTrackSectionI = &D072 = -12174
 EQUB &6A               \ yTrackSectionILo       yTrackSectionI = &146A =   5226
 EQUB &4D               \ zTrackSectionILo       zTrackSectionI = &BF4D = -16563
 EQUB &82               \ xTrackSectionOLo       xTrackSectionO = &CF82 = -12414
 EQUB 2                 \ trackSectionFrom
 EQUB &61               \ zTrackSectionOLo       zTrackSectionO = &BF61 = -16543
 EQUB 38                \ trackSectionSize

 EQUB &70, &A0          \ These bytes appear to be unused
 EQUB &F0, &07
 EQUB &C9, &A8
 EQUB &D0, &05
 EQUB &4E

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

 JSR Absolute8Bit       \ Set A = |A|, unless we are facing backwards along the
                        \ track, in which case set A = -|A|

 RTS                    \ Return from the subroutine

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
\ ------------------------------------------------------------------------------
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

 EQUB &77, &60          \ These bytes appear to be unused
 EQUB &00, &00

\ ******************************************************************************
\
\       Name: trackSectionCount
\       Type: Variable
\   Category: Extra tracks
\    Summary: The total number of track sections * 8
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Oulton Park track
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
\             The extra tracks data file format
\             The Oulton Park track
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
\             The Oulton Park track
\
\ ------------------------------------------------------------------------------
\
\ The highest segment number is this value minus 1, as segment numbers start
\ from zero.
\
\ ******************************************************************************

 EQUW 819               \ Segments are numbered from 0 to 818

\ ******************************************************************************
\
\       Name: trackStartLine
\       Type: Variable
\   Category: Track data
\    Summary: The segment number of the starting line
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Oulton Park track
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

 EQUW 819 - 807         \ The starting line is at segment 807

\ ******************************************************************************
\
\       Name: trackLapTimeSec
\       Type: Variable
\   Category: Extra tracks
\    Summary: Lap times for adjusting the race class (seconds)
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Oulton Park track
\
\ ------------------------------------------------------------------------------
\
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we change the race class to the relevant difficulty.
\
\ This figure is stored in Binary Coded Decimal (BCD).
\
\ ******************************************************************************

 EQUB &22               \ Set class to Novice if slowest lap time > 1:22

 EQUB &18               \ Set class to Amateur if slowest lap time > 1:18

 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackLapTimeMin
\       Type: Variable
\   Category: Extra tracks
\    Summary: Lap times for adjusting the race class (minutes)
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Oulton Park track
\
\ ------------------------------------------------------------------------------
\
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we change the race class to the relevant difficulty.
\
\ ******************************************************************************

 EQUB 1                 \ Set class to Novice if slowest lap time > 1:22

 EQUB 1                 \ Set class to Amateur if slowest lap time > 1:18

 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackGearRatio
\       Type: Variable
\   Category: Extra tracks
\    Summary: The gear ratio for each gear
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Oulton Park track
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

 EQUB 80                \ Second gear

 EQUB 64                \ Third gear

 EQUB 53                \ Fourth gear

 EQUB 44                \ Fifth gear

\ ******************************************************************************
\
\       Name: trackGearPower
\       Type: Variable
\   Category: Extra tracks
\    Summary: The power for each gear
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Oulton Park track
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

 EQUB 125               \ Second gear

 EQUB 99                \ Third gear

 EQUB 82                \ Fourth gear

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
\             The Oulton Park track
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
\             The Oulton Park track
\
\ ******************************************************************************

 EQUB 3

\ ******************************************************************************
\
\       Name: trackCarSpacing
\       Type: Variable
\   Category: Extra tracks
\    Summary: The spacing between the cars at the start of a qualifying lap, in
\             segments
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Oulton Park track
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
\             The Oulton Park track
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

 EQUB 93

\ ******************************************************************************
\
\       Name: trackRaceSlowdown
\       Type: Variable
\   Category: Extra tracks
\    Summary: Slowdown factor for non-player drivers in the race
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Oulton Park track
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
\             The Oulton Park track
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
\             The Oulton Park track
\
\ ******************************************************************************

.trackChecksum

 EQUB &76               \ Counts the number of data bytes ending in %00

 EQUB &D7               \ Counts the number of data bytes ending in %01

 EQUB &7A               \ Counts the number of data bytes ending in %10

 EQUB &5E               \ Counts the number of data bytes ending in %11

\ ******************************************************************************
\
\       Name: trackGameName
\       Type: Variable
\   Category: Extra tracks
\    Summary: The game name
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Oulton Park track
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
\             The Oulton Park track
\
\ ------------------------------------------------------------------------------
\
\ This string is shown on the loading screen.
\
\ ******************************************************************************

.trackName

 EQUS "Oulton Park"     \ Track name
 EQUB 13

 EQUB &72, &6B          \ These bytes appear to be unused
 EQUB &0D, &22
 EQUB &20, &42
 EQUB &52, &41
 EQUB &4E, &44
 EQUB &53, &20
 EQUB &48, &41
 EQUB &54, &43
 EQUB &48, &22
 EQUB &2C, &22
 EQUB &20, &44
 EQUB &4F, &4E
 EQUB &49, &4E
 EQUB &47, &54
 EQUB &4F, &4E
 EQUB &20, &50
 EQUB &41, &52
 EQUB &4B, &22
 EQUB &2C, &22
 EQUB &20, &4F
 EQUB &55, &4C
 EQUB &54, &4F
 EQUB &4E, &20
 EQUB &50, &41
 EQUB &52, &4B
 EQUB &20, &20
 EQUB &20, &22
 EQUB &2C, &22
 EQUB &20, &53
 EQUB &4E, &45
 EQUB &54, &54
 EQUB &45, &52
 EQUB &54, &4F
 EQUB &4E, &20
 EQUB &20, &20
 EQUB &20, &22
 EQUB &0D, &04
 EQUB &06, &0A
 EQUB &20, &DC
 EQUB &22, &22
 EQUB &20, &20
 EQUB &0D, &04
 EQUB &10, &24
 EQUB &20, &F4
 EQUB &20, &50
 EQUB &72, &6F
 EQUB &67, &72
 EQUB &61, &6D
 EQUB &73, &20
 EQUB &6F, &6E
 EQUB &20, &74
 EQUB &68, &65
 EQUB &20, &64
 EQUB &69, &73
 EQUB &63, &20
 EQUB &6F, &72
 EQUB &20, &74
 EQUB &61, &70
 EQUB &65, &20
 EQUB &0D, &04
 EQUB &1A, &11
 EQUB &20, &DC
 EQUB &42, &20
 EQUB &2C, &44
 EQUB &20, &2C
 EQUB &4F, &20
 EQUB &2C, &53
 EQUB &20, &0D
 EQUB &04, &24
 EQUB &0E, &20
 EQUB &DC, &22
 EQUB &22, &20
 EQUB &20, &20
 EQUB &20, &20
 EQUB &20, &0D
 EQUB &FF

\ ******************************************************************************
\
\ Save OultonPark.bin
\
\ ******************************************************************************

 SAVE "3-assembled-output/OultonPark.bin", CODE%, P%

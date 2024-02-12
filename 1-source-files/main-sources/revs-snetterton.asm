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
\ https://revs.bbcelite.com/terminology
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

 GUARD &7C00            \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

 LOAD% = &70DB          \ The load address of the track binary

 CODE% = &5300          \ The assembly address of the track data

 trackWidth = 132       \ Track width

\ ******************************************************************************
\
\ Addresses in the main game code
\
\ ******************************************************************************

 thisSectionFlags   = &0001
 thisVectorNumber   = &0002
 playerPitchAngle   = &000D
 yStore             = &001B
 horizonLine        = &001F
 frontSegmentIndex  = &0024
 directionFacing    = &0025
 segmentCounter     = &0042
 playerPastSegment  = &0043
 playerHeading      = &0044
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
 objSectionSegmt    = &0880
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
 backgroundColour   = &5F60
 playerDrift        = &62FB

\ ******************************************************************************
\
\ REVS SNETTERTON TRACK
\
\ Produces the binary file Snetterton.bin that contains the Snetterton track.
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
\             The Snetterton track
\
\ ------------------------------------------------------------------------------
\
\ Snetterton consists of the following track sections:
\
\   0    |<-|   Sear to the Esses (3/5)
\   1    |->|   Sear to the Esses (4/5)
\   2    {}     Sear to the Esses (5/5)
\   3    <-     The Esses (1/3)
\   4    ||     The Esses (2/3)
\   5    |->|   The Esses (3/3)
\   6    |->|   The Esses to the Bomb Hole
\   7    ->     The Bomb Hole
\   8    ||     The Bomb Hole to Coram (1/2)
\   9    ||     The Bomb Hole to Coram (2/2)
\   10   ->     Coram
\   11   |<-|   Coram to Russell (1/2)
\   12   |<->|  Coram to Russell (2/2)
\   13   <-     Russell
\   14   ->     Russell to Riches (1/4)
\   15   |->|   Russell to Riches (2/4)
\   16   {}     Russell to Riches (3/4)
\   17   ||     Russell to Riches (4/4)
\   18   ->     Riches
\   19   ||     Riches to Seer (1/2)
\   20   ||     Riches to Seer (2/2)
\   21   ->     Sear
\   22   ||     Sear to the Esses (1/5)
\   23   ||     Sear to the Esses (2/5)
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

 EQUB &63               \ trackSectionData       sign = 6, sectionListSize = 3
 EQUB &D1               \ xTrackSectionIHi       xTrackSectionI = &D120 = -12000
 EQUB &14               \ yTrackSectionIHi       yTrackSectionI = &1400 =   5120
 EQUB &D1               \ zTrackSectionIHi       zTrackSectionI = &D120 = -12000
 EQUB &D0               \ xTrackSectionOHi       xTrackSectionO = &D028 = -12248
 EQUB 255               \ trackSectionTurn
 EQUB &D1               \ zTrackSectionOHi       zTrackSectionO = &D120 = -12000
 EQUB 255               \ trackDriverSpeed

                        \ Track section 1

 EQUB &73               \ trackSectionData       sign = 7, sectionListSize = 3
 EQUB &D0               \ xTrackSectionIHi       xTrackSectionI = &D0AD = -12115
 EQUB &14               \ yTrackSectionIHi       yTrackSectionI = &1400 =   5120
 EQUB &DE               \ zTrackSectionIHi       zTrackSectionI = &DEB8 =  -8520
 EQUB &CF               \ xTrackSectionOHi       xTrackSectionO = &CFB5 = -12363
 EQUB 255               \ trackSectionTurn
 EQUB &DE               \ zTrackSectionOHi       zTrackSectionO = &DEAF =  -8529
 EQUB 255               \ trackDriverSpeed

                        \ Track section 2

 EQUB &83               \ trackSectionData       sign = 8, sectionListSize = 3
 EQUB &D0               \ xTrackSectionIHi       xTrackSectionI = &D068 = -12184
 EQUB &14               \ yTrackSectionIHi       yTrackSectionI = &1400 =   5120
 EQUB &FE               \ zTrackSectionIHi       zTrackSectionI = &FE20 =   -480
 EQUB &CF               \ xTrackSectionOHi       xTrackSectionO = &CF70 = -12432
 EQUB 28                \ trackSectionTurn
 EQUB &FE               \ zTrackSectionOHi       zTrackSectionO = &FE1D =   -483
 EQUB 126               \ trackDriverSpeed

                        \ Track section 3

 EQUB &93               \ trackSectionData       sign = 9, sectionListSize = 3
 EQUB &D0               \ xTrackSectionIHi       xTrackSectionI = &D042 = -12222
 EQUB &11               \ yTrackSectionIHi       yTrackSectionI = &1181 =   4481
 EQUB &0F               \ zTrackSectionIHi       zTrackSectionI = &0FF0 =   4080
 EQUB &CF               \ xTrackSectionOHi       xTrackSectionO = &CF4A = -12470
 EQUB 26                \ trackSectionTurn
 EQUB &0F               \ zTrackSectionOHi       zTrackSectionO = &0FED =   4077
 EQUB 8                 \ trackDriverSpeed

                        \ Track section 4

 EQUB &93               \ trackSectionData       sign = 9, sectionListSize = 3
 EQUB &CC               \ xTrackSectionIHi       xTrackSectionI = &CC97 = -13161
 EQUB &11               \ yTrackSectionIHi       yTrackSectionI = &1154 =   4436
 EQUB &16               \ zTrackSectionIHi       zTrackSectionI = &163B =   5691
 EQUB &CC               \ xTrackSectionOHi       xTrackSectionO = &CC06 = -13306
 EQUB 9                 \ trackSectionTurn
 EQUB &15               \ zTrackSectionOHi       zTrackSectionO = &1572 =   5490
 EQUB 82                \ trackDriverSpeed

                        \ Track section 5

 EQUB &A3               \ trackSectionData       sign = 10, sectionListSize = 3
 EQUB &C9               \ xTrackSectionIHi       xTrackSectionI = &C92E = -14034
 EQUB &11               \ yTrackSectionIHi       yTrackSectionI = &1154 =   4436
 EQUB &18               \ zTrackSectionIHi       zTrackSectionI = &18B1 =   6321
 EQUB &C8               \ xTrackSectionOHi       xTrackSectionO = &C89D = -14179
 EQUB 16                \ trackSectionTurn
 EQUB &17               \ zTrackSectionOHi       zTrackSectionO = &17E8 =   6120
 EQUB 11                \ trackDriverSpeed

                        \ Track section 6

 EQUB &A3               \ trackSectionData       sign = 10, sectionListSize = 3
 EQUB &C8               \ xTrackSectionIHi       xTrackSectionI = &C809 = -14327
 EQUB &11               \ yTrackSectionIHi       yTrackSectionI = &1154 =   4436
 EQUB &1B               \ zTrackSectionIHi       zTrackSectionI = &1B50 =   6992
 EQUB &C7               \ xTrackSectionOHi       xTrackSectionO = &C71B = -14565
 EQUB 31                \ trackSectionTurn
 EQUB &1B               \ zTrackSectionOHi       zTrackSectionO = &1B98 =   7064
 EQUB 118               \ trackDriverSpeed

                        \ Track section 7

 EQUB &B3               \ trackSectionData       sign = 11, sectionListSize = 3
 EQUB &CF               \ xTrackSectionIHi       xTrackSectionI = &CF65 = -12443
 EQUB &11               \ yTrackSectionIHi       yTrackSectionI = &1154 =   4436
 EQUB &2B               \ zTrackSectionIHi       zTrackSectionI = &2B84 =  11140
 EQUB &CE               \ xTrackSectionOHi       xTrackSectionO = &CE84 = -12668
 EQUB 30                \ trackSectionTurn
 EQUB &2B               \ zTrackSectionOHi       zTrackSectionO = &2BEB =  11243
 EQUB 16                \ trackDriverSpeed

                        \ Track section 8

 EQUB &B3               \ trackSectionData       sign = 11, sectionListSize = 3
 EQUB &D5               \ xTrackSectionIHi       xTrackSectionI = &D57E = -10882
 EQUB &11               \ yTrackSectionIHi       yTrackSectionI = &1158 =   4440
 EQUB &2F               \ zTrackSectionIHi       zTrackSectionI = &2F07 =  12039
 EQUB &D5               \ xTrackSectionOHi       xTrackSectionO = &D59C = -10852
 EQUB 255               \ trackSectionTurn
 EQUB &2F               \ zTrackSectionOHi       zTrackSectionO = &2FFC =  12284
 EQUB 255               \ trackDriverSpeed

                        \ Track section 9

 EQUB &B3               \ trackSectionData       sign = 11, sectionListSize = 3
 EQUB &DD               \ xTrackSectionIHi       xTrackSectionI = &DD65 =  -8859
 EQUB &12               \ yTrackSectionIHi       yTrackSectionI = &1268 =   4712
 EQUB &2E               \ zTrackSectionIHi       zTrackSectionI = &2E08 =  11784
 EQUB &DD               \ xTrackSectionOHi       xTrackSectionO = &DD83 =  -8829
 EQUB 14                \ trackSectionTurn
 EQUB &2E               \ zTrackSectionOHi       zTrackSectionO = &2EFD =  12029
 EQUB 145               \ trackDriverSpeed

                        \ Track section 10

 EQUB &C5               \ trackSectionData       sign = 12, sectionListSize = 5
 EQUB &E5               \ xTrackSectionIHi       xTrackSectionI = &E5C3 =  -6717
 EQUB &13               \ yTrackSectionIHi       yTrackSectionI = &1388 =   5000
 EQUB &2C               \ zTrackSectionIHi       zTrackSectionI = &2CFA =  11514
 EQUB &E5               \ xTrackSectionOHi       xTrackSectionO = &E5E1 =  -6687
 EQUB 60                \ trackSectionTurn
 EQUB &2D               \ zTrackSectionOHi       zTrackSectionO = &2DEF =  11759
 EQUB 32                \ trackDriverSpeed

                        \ Track section 11

 EQUB &D5               \ trackSectionData       sign = 13, sectionListSize = 5
 EQUB &EF               \ xTrackSectionIHi       xTrackSectionI = &EF26 =  -4314
 EQUB &11               \ yTrackSectionIHi       yTrackSectionI = &1166 =   4454
 EQUB &19               \ zTrackSectionIHi       zTrackSectionI = &19C9 =   6601
 EQUB &F0               \ xTrackSectionOHi       xTrackSectionO = &F00A =  -4086
 EQUB 255               \ trackSectionTurn
 EQUB &19               \ zTrackSectionOHi       zTrackSectionO = &196C =   6508
 EQUB 255               \ trackDriverSpeed

                        \ Track section 12

 EQUB &E4               \ trackSectionData       sign = 14, sectionListSize = 4
 EQUB &EA               \ xTrackSectionIHi       xTrackSectionI = &EA3F =  -5569
 EQUB &0E               \ yTrackSectionIHi       yTrackSectionI = &0ED2 =   3794
 EQUB &0C               \ zTrackSectionIHi       zTrackSectionI = &0CA6 =   3238
 EQUB &EB               \ xTrackSectionOHi       xTrackSectionO = &EB30 =  -5328
 EQUB 15                \ trackSectionTurn
 EQUB &0C               \ zTrackSectionOHi       zTrackSectionO = &0C70 =   3184
 EQUB 145               \ trackDriverSpeed

                        \ Track section 13

 EQUB &F3               \ trackSectionData       sign = 15, sectionListSize = 3
 EQUB &E8               \ xTrackSectionIHi       xTrackSectionI = &E833 =  -6093
 EQUB &0D               \ yTrackSectionIHi       yTrackSectionI = &0D3B =   3387
 EQUB &FF               \ zTrackSectionIHi       zTrackSectionI = &FF38 =   -200
 EQUB &E9               \ xTrackSectionOHi       xTrackSectionO = &E926 =  -5850
 EQUB 26                \ trackSectionTurn
 EQUB &FF               \ zTrackSectionOHi       zTrackSectionO = &FF08 =   -248
 EQUB 6                 \ trackDriverSpeed

                        \ Track section 14

 EQUB &F3               \ trackSectionData       sign = 15, sectionListSize = 3
 EQUB &EA               \ xTrackSectionIHi       xTrackSectionI = &EAA5 =  -5467
 EQUB &0C               \ yTrackSectionIHi       yTrackSectionI = &0CB3 =   3251
 EQUB &F7               \ zTrackSectionIHi       zTrackSectionI = &F7F7 =  -2057
 EQUB &EB               \ xTrackSectionOHi       xTrackSectionO = &EB54 =  -5292
 EQUB 21                \ trackSectionTurn
 EQUB &F8               \ zTrackSectionOHi       zTrackSectionO = &F8A6 =  -1882
 EQUB 12                \ trackDriverSpeed

                        \ Track section 15

 EQUB &03               \ trackSectionData       sign = 0, sectionListSize = 3
 EQUB &EC               \ xTrackSectionIHi       xTrackSectionI = &EC67 =  -5017
 EQUB &0C               \ yTrackSectionIHi       yTrackSectionI = &0C97 =   3223
 EQUB &F4               \ zTrackSectionIHi       zTrackSectionI = &F4B6 =  -2890
 EQUB &ED               \ xTrackSectionOHi       xTrackSectionO = &ED58 =  -4776
 EQUB 255               \ trackSectionTurn
 EQUB &F4               \ zTrackSectionOHi       zTrackSectionO = &F4EB =  -2837
 EQUB 255               \ trackDriverSpeed

                        \ Track section 16

 EQUB &03               \ trackSectionData       sign = 0, sectionListSize = 3
 EQUB &EE               \ xTrackSectionIHi       xTrackSectionI = &EEE5 =  -4379
 EQUB &10               \ yTrackSectionIHi       yTrackSectionI = &101B =   4123
 EQUB &E0               \ zTrackSectionIHi       zTrackSectionI = &E0C2 =  -7998
 EQUB &EF               \ xTrackSectionOHi       xTrackSectionO = &EFDA =  -4134
 EQUB 255               \ trackSectionTurn
 EQUB &E0               \ zTrackSectionOHi       zTrackSectionO = &E0DC =  -7972
 EQUB 255               \ trackDriverSpeed

                        \ Track section 17

 EQUB &13               \ trackSectionData       sign = 1, sectionListSize = 3
 EQUB &F1               \ xTrackSectionIHi       xTrackSectionI = &F1A3 =  -3677
 EQUB &13               \ yTrackSectionIHi       yTrackSectionI = &13FF =   5119
 EQUB &C7               \ zTrackSectionIHi       zTrackSectionI = &C7A8 = -14424
 EQUB &F2               \ xTrackSectionOHi       xTrackSectionO = &F298 =  -3432
 EQUB 28                \ trackSectionTurn
 EQUB &C7               \ zTrackSectionOHi       zTrackSectionO = &C7C2 = -14398
 EQUB 140               \ trackDriverSpeed

                        \ Track section 18

 EQUB &23               \ trackSectionData       sign = 2, sectionListSize = 3
 EQUB &F3               \ xTrackSectionIHi       xTrackSectionI = &F36A =  -3222
 EQUB &13               \ yTrackSectionIHi       yTrackSectionI = &13FF =   5119
 EQUB &B7               \ zTrackSectionIHi       zTrackSectionI = &B763 = -18589
 EQUB &F4               \ xTrackSectionOHi       xTrackSectionO = &F45F =  -2977
 EQUB 42                \ trackSectionTurn
 EQUB &B7               \ zTrackSectionOHi       zTrackSectionO = &B77D = -18563
 EQUB 14                \ trackDriverSpeed

                        \ Track section 19

 EQUB &33               \ trackSectionData       sign = 3, sectionListSize = 3
 EQUB &EA               \ xTrackSectionIHi       xTrackSectionI = &EA76 =  -5514
 EQUB &13               \ yTrackSectionIHi       yTrackSectionI = &13FF =   5119
 EQUB &AD               \ zTrackSectionIHi       zTrackSectionI = &ADBC = -21060
 EQUB &EA               \ xTrackSectionOHi       xTrackSectionO = &EA90 =  -5488
 EQUB 255               \ trackSectionTurn
 EQUB &AC               \ zTrackSectionOHi       zTrackSectionO = &ACC6 = -21306
 EQUB 255               \ trackDriverSpeed

                        \ Track section 20

 EQUB &33               \ trackSectionData       sign = 3, sectionListSize = 3
 EQUB &DF               \ xTrackSectionIHi       xTrackSectionI = &DF4E =  -8370
 EQUB &13               \ yTrackSectionIHi       yTrackSectionI = &13FF =   5119
 EQUB &AC               \ zTrackSectionIHi       zTrackSectionI = &AC84 = -21372
 EQUB &DF               \ xTrackSectionOHi       xTrackSectionO = &DF68 =  -8344
 EQUB 20                \ trackSectionTurn
 EQUB &AB               \ zTrackSectionOHi       zTrackSectionO = &AB8E = -21618
 EQUB 87                \ trackDriverSpeed

                        \ Track section 21

 EQUB &43               \ trackSectionData       sign = 4, sectionListSize = 3
 EQUB &D3               \ xTrackSectionIHi       xTrackSectionI = &D3AF = -11345
 EQUB &13               \ yTrackSectionIHi       yTrackSectionI = &13FF =   5119
 EQUB &AB               \ zTrackSectionIHi       zTrackSectionI = &AB3F = -21697
 EQUB &D3               \ xTrackSectionOHi       xTrackSectionO = &D3C9 = -11319
 EQUB 19                \ trackSectionTurn
 EQUB &AA               \ zTrackSectionOHi       zTrackSectionO = &AA49 = -21943
 EQUB 11                \ trackDriverSpeed

                        \ Track section 22

 EQUB &43               \ trackSectionData       sign = 4, sectionListSize = 3
 EQUB &D1               \ xTrackSectionIHi       xTrackSectionI = &D120 = -12000
 EQUB &13               \ yTrackSectionIHi       yTrackSectionI = &13FF =   5119
 EQUB &AD               \ zTrackSectionIHi       zTrackSectionI = &ADFA = -20998
 EQUB &D0               \ xTrackSectionOHi       xTrackSectionO = &D028 = -12248
 EQUB 255               \ trackSectionTurn
 EQUB &AD               \ zTrackSectionOHi       zTrackSectionO = &ADFA = -20998
 EQUB 129               \ trackDriverSpeed

                        \ Track section 23

 EQUB &53               \ trackSectionData       sign = 5, sectionListSize = 3
 EQUB &D1               \ xTrackSectionIHi       xTrackSectionI = &D120 = -12000
 EQUB &13               \ yTrackSectionIHi       yTrackSectionI = &13FF =   5119
 EQUB &BE               \ zTrackSectionIHi       zTrackSectionI = &BE62 = -16798
 EQUB &D0               \ xTrackSectionOHi       xTrackSectionO = &D028 = -12248
 EQUB 255               \ trackSectionTurn
 EQUB &BE               \ zTrackSectionOHi       zTrackSectionO = &BE62 = -16798
 EQUB 255               \ trackDriverSpeed

 EQUB &C1, &05          \ These bytes appear to be unused
 EQUB &15, &0A
 EQUB &06, &FF
 EQUB &09, &FF

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
\       Name: HookJoystick (Part 3 of 3)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Apply enhanced joystick steering to specific track sections
\  Deep dive: Secrets of the extra tracks
\             Code hooks in the extra tracks
\
\ ******************************************************************************

.joys6

                        \ By this point, Y contains the scale factor to apply to
                        \ the steering, which is one of the following values:
                        \
                        \   * 181 for a scale factor of 1.00
                        \
                        \   * 195 for a scale factor of 1.16
                        \
                        \   * 220 for a scale factor of 1.48

 TYA                    \ Set A = Y
                        \
                        \ So A is 181, 195 or 220

 JSR Multiply8x8        \ Set (A T) = A * U
                        \           = A * x-axis

 STA U                  \ Set U = A
                        \       = high byte of A * x-axis

 JSR Multiply8x8        \ Set (A T) = A * U
                        \           = A * A
                        \           = (A * x-axis) ^ 2

 ASL T                  \ Set (A T) = (A T) * 2
 ROL A                  \           = 2 * (A * x-axis) ^ 2

                        \ So for A = 220 we have:
                        \
                        \   (A T) = 2 * (220/256 * x-axis) ^ 2
                        \         = 2 * (0.859 * x-axis) ^ 2
                        \         = 1.48 * x-axis ^ 2
                        \
                        \ and for A = 195 we have:
                        \
                        \   (A T) = 2 * (195/256 * x-axis) ^ 2
                        \         = 2 * (0.762 * x-axis) ^ 2
                        \         = 1.16 * x-axis ^ 2
                        \
                        \ and for A = 181 we have:
                        \
                        \   (A T) = 2 * (181/256 * x-axis) ^ 2
                        \         = 2 * (0.707 * x-axis) ^ 2
                        \         = 1.00 * x-axis ^ 2

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: HookFlattenHills (Part 2 of 2)
\       Type: Subroutine
\   Category: Extra tracks
\    Summary: Flatten any hills in the verge buffer, calculate the hill height
\             and track width, cut objects off at the hill height
\  Deep dive: Secrets of the extra tracks
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
                        \ pointing outside of the -24 to +24 field of view, or
                        \ greater than 33 degrees either side of 0), so jump to
                        \ hill5 to call CheckVergeOnScreen in the usual way

 LDA playerPitchAngle   \ If the player's pitch angle is positive, which means
 BPL hill5              \ the car's nose is pointing up, above the horizontal,
                        \ then jump to hill5 to call CheckVergeOnScreen in the
                        \ usual way

                        \ If we get here then the car nose is pointing downwards
                        \ and the car is pointing straight along the track,
                        \ within a -33 to +33 degree field of view
                        \
                        \ We therefore replace the call to CheckVergeOnScreen
                        \ with the following, which clears bit 7 of V to flag
                        \ the verge coordinate at index X as being visible
                        \ on-screen

 LSR V                  \ Clear bit 7 of V

 RTS                    \ Return from the subroutine

.hill5

 JMP CheckVergeOnScreen \ Implement the call that we overwrote with the call to
                        \ the hook routine, so we have effectively inserted the
                        \ above code into the main game (the JMP ensures we
                        \ return from the subroutine using a tail call)

 EQUB &7F, &85          \ These bytes appear to be unused
 EQUB &75, &A9
 EQUB &CD, &4C
 EQUB &00, &0C
 EQUB &00

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

 EQUB 44

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

 EQUB &FF               \ Sub-section  0 = &FF77 ( -137)
 EQUB &00               \ Sub-section  1 = &0000 (    0)
 EQUB &00               \ Sub-section  2 = &0072 (  114)
 EQUB &00               \ Sub-section  3 = &0000 (    0)
 EQUB &00               \ Sub-section  4 = &0000 (    0)
 EQUB &00               \ Sub-section  5 = &0000 (    0)
 EQUB &FD               \ Sub-section  6 = &FD02 ( -766)
 EQUB &FE               \ Sub-section  7 = &FE8C ( -372)
 EQUB &FD               \ Sub-section  8 = &FD28 ( -728)
 EQUB &00               \ Sub-section  9 = &0000 (    0)
 EQUB &13               \ Sub-section 10 = &1333 ( 4915)
 EQUB &05               \ Sub-section 11 = &05F6 ( 1526)
 EQUB &01               \ Sub-section 12 = &01E5 (  485)
 EQUB &00               \ Sub-section 13 = &0000 (    0)
 EQUB &02               \ Sub-section 14 = &02DE (  734)
 EQUB &02               \ Sub-section 15 = &02DE (  734)
 EQUB &02               \ Sub-section 16 = &02DE (  734)
 EQUB &04               \ Sub-section 17 = &0444 ( 1092)
 EQUB &00               \ Sub-section 18 = &0000 (    0)
 EQUB &01               \ Sub-section 19 = &01F5 (  501)
 EQUB &01               \ Sub-section 20 = &015F (  351)
 EQUB &01               \ Sub-section 21 = &014A (  330)
 EQUB &01               \ Sub-section 22 = &014A (  330)
 EQUB &00               \ Sub-section 23 = &0000 (    0)
 EQUB &FF               \ Sub-section 24 = &FF4F ( -177)
 EQUB &FF               \ Sub-section 25 = &FF4F ( -177)
 EQUB &00               \ Sub-section 26 = &0062 (   98)
 EQUB &00               \ Sub-section 27 = &0000 (    0)
 EQUB &FD               \ Sub-section 28 = &FDA8 ( -600)
 EQUB &02               \ Sub-section 29 = &026B (  619)
 EQUB &03               \ Sub-section 30 = &0392 (  914)
 EQUB &00               \ Sub-section 31 = &0063 (   99)
 EQUB &00               \ Sub-section 32 = &0000 (    0)
 EQUB &00               \ Sub-section 33 = &0000 (    0)
 EQUB &00               \ Sub-section 34 = &0000 (    0)
 EQUB &00               \ Sub-section 35 = &0000 (    0)
 EQUB &00               \ Sub-section 36 = &0000 (    0)
 EQUB &04               \ Sub-section 37 = &04FA ( 1274)
 EQUB &02               \ Sub-section 38 = &0204 (  516)
 EQUB &01               \ Sub-section 39 = &0123 (  291)
 EQUB &02               \ Sub-section 40 = &02C1 (  705)
 EQUB &00               \ Sub-section 41 = &0000 (    0)
 EQUB &07               \ Sub-section 42 = &079B ( 1947)
 EQUB &00               \ Sub-section 43 = &0000 (    0)

 EQUB &05, &FC          \ These bytes appear to be unused
 EQUB &FB, &00
 EQUB &00, &00
 EQUB &00, &05
 EQUB &02, &02
 EQUB &00, &01
 EQUB &00, &00

\ ******************************************************************************
\
\       Name: trackSignData
\       Type: Variable
\   Category: Track data
\    Summary: Base coordinates and object types for 16 road signs
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Snetterton track
\
\ ******************************************************************************

.trackSignData

 EQUB %10000001         \ Sign  0: 10000 001   Type 8    Start flag   Section 16
 EQUB %10010100         \ Sign  1: 10010 100   Type 11   Right turn   Section 18
 EQUB %10010000         \ Sign  2: 10010 000   Type 7    Straight     Section 18
 EQUB %10101100         \ Sign  3: 10101 100   Type 11   Right turn   Section 21
 EQUB %10110000         \ Sign  4: 10110 000   Type 7    Straight     Section 22
 EQUB %10111000         \ Sign  5: 10111 000   Type 7    Straight     Section 23
 EQUB %00000000         \ Sign  6: 00000 000   Type 7    Straight     Section  0
 EQUB %00001000         \ Sign  7: 00001 000   Type 7    Straight     Section  1
 EQUB %00011101         \ Sign  8: 00011 101   Type 12   Left turn    Section  3
 EQUB %00100100         \ Sign  9: 00100 100   Type 11   Right turn   Section  4
 EQUB %00111100         \ Sign 10: 00111 100   Type 11   Right turn   Section  7
 EQUB %01010100         \ Sign 11: 01010 100   Type 11   Right turn   Section 10
 EQUB %01010000         \ Sign 12: 01010 000   Type 7    Straight     Section 10
 EQUB %01011000         \ Sign 13: 01011 000   Type 7    Straight     Section 11
 EQUB %01101101         \ Sign 14: 01101 101   Type 12   Left turn    Section 13
 EQUB %01110000         \ Sign 15: 01110 000   Type 7    Straight     Section 14

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

 EQUB &77               \ Sub-section  0 = &FF77 ( -137)
 EQUB &00               \ Sub-section  1 = &0000 (    0)
 EQUB &72               \ Sub-section  2 = &0072 (  114)
 EQUB &00               \ Sub-section  3 = &0000 (    0)
 EQUB &00               \ Sub-section  4 = &0000 (    0)
 EQUB &00               \ Sub-section  5 = &0000 (    0)
 EQUB &02               \ Sub-section  6 = &FD02 ( -766)
 EQUB &8C               \ Sub-section  7 = &FE8C ( -372)
 EQUB &28               \ Sub-section  8 = &FD28 ( -728)
 EQUB &00               \ Sub-section  9 = &0000 (    0)
 EQUB &33               \ Sub-section 10 = &1333 ( 4915)
 EQUB &F6               \ Sub-section 11 = &05F6 ( 1526)
 EQUB &E5               \ Sub-section 12 = &01E5 (  485)
 EQUB &00               \ Sub-section 13 = &0000 (    0)
 EQUB &DE               \ Sub-section 14 = &02DE (  734)
 EQUB &DE               \ Sub-section 15 = &02DE (  734)
 EQUB &DE               \ Sub-section 16 = &02DE (  734)
 EQUB &44               \ Sub-section 17 = &0444 ( 1092)
 EQUB &00               \ Sub-section 18 = &0000 (    0)
 EQUB &F5               \ Sub-section 19 = &01F5 (  501)
 EQUB &5F               \ Sub-section 20 = &015F (  351)
 EQUB &4A               \ Sub-section 21 = &014A (  330)
 EQUB &4A               \ Sub-section 22 = &014A (  330)
 EQUB &00               \ Sub-section 23 = &0000 (    0)
 EQUB &4F               \ Sub-section 24 = &FF4F ( -177)
 EQUB &4F               \ Sub-section 25 = &FF4F ( -177)
 EQUB &62               \ Sub-section 26 = &0062 (   98)
 EQUB &00               \ Sub-section 27 = &0000 (    0)
 EQUB &A8               \ Sub-section 28 = &FDA8 ( -600)
 EQUB &6B               \ Sub-section 29 = &026B (  619)
 EQUB &92               \ Sub-section 30 = &0392 (  914)
 EQUB &63               \ Sub-section 31 = &0063 (   99)
 EQUB &00               \ Sub-section 32 = &0000 (    0)
 EQUB &00               \ Sub-section 33 = &0000 (    0)
 EQUB &00               \ Sub-section 34 = &0000 (    0)
 EQUB &00               \ Sub-section 35 = &0000 (    0)
 EQUB &00               \ Sub-section 36 = &0000 (    0)
 EQUB &FA               \ Sub-section 37 = &04FA ( 1274)
 EQUB &04               \ Sub-section 38 = &0204 (  516)
 EQUB &23               \ Sub-section 39 = &0123 (  291)
 EQUB &C1               \ Sub-section 40 = &02C1 (  705)
 EQUB &00               \ Sub-section 41 = &0000 (    0)
 EQUB &9B               \ Sub-section 42 = &079B ( 1947)
 EQUB &00               \ Sub-section 43 = &0000 (    0)

 EQUB &7A, &BB          \ These bytes appear to be unused
 EQUB &F8, &00
 EQUB &00, &00
 EQUB &00, &55
 EQUB &11, &11
 EQUB &60, &B0
 EQUB &78, &20

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

 EQUB   4               \ Sign  0 = (  4 << 6,   8 << 4,   0 << 6) + section  0
 EQUB  -3               \ Sign  1 = ( -3 << 6,   8 << 4,  68 << 6) + section  2
 EQUB  -4               \ Sign  2 = ( -4 << 6,   8 << 4, -23 << 6) + section  3
 EQUB  61               \ Sign  3 = ( 61 << 6,   8 << 4,   2 << 6) + section  5
 EQUB   1               \ Sign  4 = (  1 << 6,   8 << 4,  27 << 6) + section  7
 EQUB  -5               \ Sign  5 = ( -5 << 6,   8 << 4,  18 << 6) + section  9
 EQUB   0               \ Sign  6 = (  0 << 6,   8 << 4,  26 << 6) + section 12
 EQUB  -7               \ Sign  7 = ( -7 << 6,   8 << 4,  27 << 6) + section 14
 EQUB   1               \ Sign  8 = (  1 << 6,  48 << 4, -77 << 6) + section 14
 EQUB -15               \ Sign  9 = (-15 << 6,   8 << 4,   5 << 6) + section 14
 EQUB -21               \ Sign 10 = (-21 << 6,   8 << 4, -34 << 6) + section 18
 EQUB -29               \ Sign 11 = (-29 << 6,  -8 << 4,   9 << 6) + section 19
 EQUB  32               \ Sign 12 = ( 32 << 6,  18 << 4, -13 << 6) + section 20
 EQUB  10               \ Sign 13 = ( 10 << 6,  28 << 4,  16 << 6) + section 21
 EQUB   7               \ Sign 14 = (  7 << 6,  32 << 4,  50 << 6) + section 22
 EQUB   3               \ Sign 15 = (  3 << 6,   8 << 4,  -5 << 6) + section 23

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

 LDA #&20               \ ?&2F23 = &20 (opcode for a JSR instruction)
 STA &2F23

 LDA #0                 \ ?&231B = 0 (branch offset in a BEQ instruction)
 STA &231B

 LDA #LO(HookSlopeJump) \ !&45CC = HookSlopeJump (address in a JSR instruction)
 STA &45CC
 LDA #HI(HookSlopeJump)
 STA &45CD

 LDA #75                \ ?&2772 = 75 (argument in a CMP #75 instruction)
 STA &2772

 LDA #&A9               \ !&1310 = &A9 &10 (LDA #2*8 instruction)
 STA &1310
 LDA #&10
 STA &1311

 RTS                    \ Return from the subroutine

 EQUB &00, &00          \ These bytes pad the routine out to exactly 40 bytes
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

 EQUB &00               \ Sub-section  0 =   0
 EQUB &00               \ Sub-section  1 =   0
 EQUB &00               \ Sub-section  2 =   0
 EQUB &00               \ Sub-section  3 =   0
 EQUB &FD               \ Sub-section  4 =  -3
 EQUB &00               \ Sub-section  5 =   0
 EQUB &03               \ Sub-section  6 =   3
 EQUB &00               \ Sub-section  7 =   0
 EQUB &00               \ Sub-section  8 =   0
 EQUB &00               \ Sub-section  9 =   0
 EQUB &00               \ Sub-section 10 =   0
 EQUB &00               \ Sub-section 11 =   0
 EQUB &00               \ Sub-section 12 =   0
 EQUB &00               \ Sub-section 13 =   0
 EQUB &F4               \ Sub-section 14 = -12
 EQUB &04               \ Sub-section 15 =   4
 EQUB &0A               \ Sub-section 16 =  10
 EQUB &FB               \ Sub-section 17 =  -5
 EQUB &00               \ Sub-section 18 =   0
 EQUB &FF               \ Sub-section 19 =  -1
 EQUB &FF               \ Sub-section 20 =  -1
 EQUB &FF               \ Sub-section 21 =  -1
 EQUB &FF               \ Sub-section 22 =  -1
 EQUB &01               \ Sub-section 23 =   1
 EQUB &00               \ Sub-section 24 =   0
 EQUB &00               \ Sub-section 25 =   0
 EQUB &00               \ Sub-section 26 =   0
 EQUB &01               \ Sub-section 27 =   1
 EQUB &00               \ Sub-section 28 =   0
 EQUB &01               \ Sub-section 29 =   1
 EQUB &01               \ Sub-section 30 =   1
 EQUB &02               \ Sub-section 31 =   2
 EQUB &00               \ Sub-section 32 =   0
 EQUB &00               \ Sub-section 33 =   0
 EQUB &FF               \ Sub-section 34 =  -1
 EQUB &00               \ Sub-section 35 =   0
 EQUB &00               \ Sub-section 36 =   0
 EQUB &00               \ Sub-section 37 =   0
 EQUB &00               \ Sub-section 38 =   0
 EQUB &00               \ Sub-section 39 =   0
 EQUB &00               \ Sub-section 40 =   0
 EQUB &00               \ Sub-section 41 =   0
 EQUB &00               \ Sub-section 42 =   0
 EQUB &00               \ Sub-section 43 =   0

 EQUB &FD, &01          \ These bytes appear to be unused
 EQUB &03, &00
 EQUB &FE, &00
 EQUB &01, &FC
 EQUB &FC, &03
 EQUB &03, &FC
 EQUB &FE, &01

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

 EQUB   8               \ Sign  0 = (  4 << 6,   8 << 4,   0 << 6) + section  0
 EQUB   8               \ Sign  1 = ( -3 << 6,   8 << 4,  68 << 6) + section  2
 EQUB   8               \ Sign  2 = ( -4 << 6,   8 << 4, -23 << 6) + section  3
 EQUB   8               \ Sign  3 = ( 61 << 6,   8 << 4,   2 << 6) + section  5
 EQUB   8               \ Sign  4 = (  1 << 6,   8 << 4,  27 << 6) + section  7
 EQUB   8               \ Sign  5 = ( -5 << 6,   8 << 4,  18 << 6) + section  9
 EQUB   8               \ Sign  6 = (  0 << 6,   8 << 4,  26 << 6) + section 12
 EQUB   8               \ Sign  7 = ( -7 << 6,   8 << 4,  27 << 6) + section 14
 EQUB  48               \ Sign  8 = (  1 << 6,  48 << 4, -77 << 6) + section 14
 EQUB   8               \ Sign  9 = (-15 << 6,   8 << 4,   5 << 6) + section 14
 EQUB   8               \ Sign 10 = (-21 << 6,   8 << 4, -34 << 6) + section 18
 EQUB  -8               \ Sign 11 = (-29 << 6,  -8 << 4,   9 << 6) + section 19
 EQUB  18               \ Sign 12 = ( 32 << 6,  18 << 4, -13 << 6) + section 20
 EQUB  28               \ Sign 13 = ( 10 << 6,  28 << 4,  16 << 6) + section 21
 EQUB  32               \ Sign 14 = (  7 << 6,  32 << 4,  50 << 6) + section 22
 EQUB   8               \ Sign 15 = (  3 << 6,   8 << 4,  -5 << 6) + section 23

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
\       Name: HookFlattenHills (Part 1 of 2)
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
\ It also sets horizonTrackWidth to 80% of the track width at the hill crest,
\ and sets the verge edge to being visible when the car is pointing along the
\ track and the nose is pointing downwards.
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

 JMP hill4              \ Jump to part 2

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

 EQUB 2                 \ Sub-section  0
 EQUB 27                \ Sub-section  1
 EQUB 2                 \ Sub-section  2
 EQUB 65                \ Sub-section  3
 EQUB 6                 \ Sub-section  4
 EQUB 32                \ Sub-section  5
 EQUB 6                 \ Sub-section  6
 EQUB 6                 \ Sub-section  7
 EQUB 4                 \ Sub-section  8
 EQUB 3                 \ Sub-section  9
 EQUB 2                 \ Sub-section 10
 EQUB 2                 \ Sub-section 11
 EQUB 3                 \ Sub-section 12
 EQUB 35                \ Sub-section 13
 EQUB 3                 \ Sub-section 14
 EQUB 3                 \ Sub-section 15
 EQUB 6                 \ Sub-section 16
 EQUB 4                 \ Sub-section 17
 EQUB 18                \ Sub-section 18
 EQUB 8                 \ Sub-section 19
 EQUB 24                \ Sub-section 20
 EQUB 10                \ Sub-section 21
 EQUB 10                \ Sub-section 22
 EQUB 21                \ Sub-section 23
 EQUB 9                 \ Sub-section 24
 EQUB 9                 \ Sub-section 25
 EQUB 13                \ Sub-section 26
 EQUB 7                 \ Sub-section 27
 EQUB 17                \ Sub-section 28
 EQUB 5                 \ Sub-section 29
 EQUB 3                 \ Sub-section 30
 EQUB 12                \ Sub-section 31
 EQUB 31                \ Sub-section 32
 EQUB 30                \ Sub-section 33
 EQUB 24                \ Sub-section 34
 EQUB 14                \ Sub-section 35
 EQUB 21                \ Sub-section 36
 EQUB 3                 \ Sub-section 37
 EQUB 6                 \ Sub-section 38
 EQUB 13                \ Sub-section 39
 EQUB 8                 \ Sub-section 40
 EQUB 25                \ Sub-section 41
 EQUB 9                 \ Sub-section 42
 EQUB 40                \ Sub-section 43

 EQUB &05, &05          \ These bytes appear to be unused
 EQUB &0C, &0F
 EQUB &15, &23
 EQUB &16, &03
 EQUB &0E, &08
 EQUB &13, &08
 EQUB &11, &22

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

 EQUB   0               \ Sign  0 = (  4 << 6,   8 << 4,   0 << 6) + section  0
 EQUB  68               \ Sign  1 = ( -3 << 6,   8 << 4,  68 << 6) + section  2
 EQUB -23               \ Sign  2 = ( -4 << 6,   8 << 4, -23 << 6) + section  3
 EQUB   2               \ Sign  3 = ( 61 << 6,   8 << 4,   2 << 6) + section  5
 EQUB  27               \ Sign  4 = (  1 << 6,   8 << 4,  27 << 6) + section  7
 EQUB  18               \ Sign  5 = ( -5 << 6,   8 << 4,  18 << 6) + section  9
 EQUB  26               \ Sign  6 = (  0 << 6,   8 << 4,  26 << 6) + section 12
 EQUB  27               \ Sign  7 = ( -7 << 6,   8 << 4,  27 << 6) + section 14
 EQUB -77               \ Sign  8 = (  1 << 6,  48 << 4, -77 << 6) + section 14
 EQUB   5               \ Sign  9 = (-15 << 6,   8 << 4,   5 << 6) + section 14
 EQUB -34               \ Sign 10 = (-21 << 6,   8 << 4, -34 << 6) + section 18
 EQUB   9               \ Sign 11 = (-29 << 6,  -8 << 4,   9 << 6) + section 19
 EQUB -13               \ Sign 12 = ( 32 << 6,  18 << 4, -13 << 6) + section 20
 EQUB  16               \ Sign 13 = ( 10 << 6,  28 << 4,  16 << 6) + section 21
 EQUB  50               \ Sign 14 = (  7 << 6,  32 << 4,  50 << 6) + section 22
 EQUB  -5               \ Sign 15 = (  3 << 6,   8 << 4,  -5 << 6) + section 23

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
\   * Section 21: cancel drift
\
\ In addition, scale the steering in the following sections to make it easier
\ to steer when using a joystick:
\
\   * Section 2: scale the steering by 1.48
\
\   * Section 20: scale the steering by 1.16
\
\   * Section 21: scale the steering by 1.16
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

 CMP #40                \ If the track section <> 16 (i.e. section 2), jump to
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

 LDY #220               \ Set Y = 220 so we scale the steering by 1.48

 JMP joys6              \ Jump to part 3 to scale the steering

.joys2

 JMP joys3              \ Jump to part 2

 EQUB &4C, &1B          \ These bytes appear to be unused
 EQUB &46

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
 EQUB &00               \ Section  1 =   0
 EQUB &00               \ Section  2 =   0
 EQUB &EE               \ Section  3 = -18
 EQUB &00               \ Section  4 =   0
 EQUB &00               \ Section  5 =   0
 EQUB &00               \ Section  6 =   0
 EQUB &00               \ Section  7 =   0
 EQUB &10               \ Section  8 =  16
 EQUB &10               \ Section  9 =  16
 EQUB &10               \ Section 10 =  16
 EQUB &DC               \ Section 11 = -36
 EQUB &F1               \ Section 12 = -15
 EQUB &F8               \ Section 13 =  -8
 EQUB &F8               \ Section 14 =  -8
 EQUB &00               \ Section 15 =   0
 EQUB &18               \ Section 16 =  24
 EQUB &00               \ Section 17 =   0
 EQUB &00               \ Section 18 =   0
 EQUB &00               \ Section 19 =   0
 EQUB &00               \ Section 20 =   0
 EQUB &00               \ Section 21 =   0
 EQUB &00               \ Section 22 =   0
 EQUB &00               \ Section 23 =   0

 EQUB &26, &FC          \ These bytes appear to be unused
 EQUB &12, &E6
 EQUB &FF, &00

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
 EQUB &EE               \ Section  1 = &FEEE = 65262 = 358.5 degrees
 EQUB &D2               \ Section  2 = &FFD2 = 65490 = 359.7 degrees
 EQUB &D2               \ Section  3 = &FFD2 = 65490 = 359.7 degrees
 EQUB &C6               \ Section  4 = &D9C6 = 55750 = 306.2 degrees
 EQUB &C6               \ Section  5 = &D9C6 = 55750 = 306.2 degrees
 EQUB &18               \ Section  6 = &0C18 =  3096 =  17.0 degrees
 EQUB &C7               \ Section  7 = &11C7 =  4551 =  25.0 degrees
 EQUB &3F               \ Section  8 = &453F = 17727 =  97.4 degrees
 EQUB &3F               \ Section  9 = &453F = 17727 =  97.4 degrees
 EQUB &3F               \ Section 10 = &453F = 17727 =  97.4 degrees
 EQUB &97               \ Section 11 = &8F97 = 36759 = 201.9 degrees
 EQUB &5E               \ Section 12 = &895E = 35166 = 193.2 degrees
 EQUB &1F               \ Section 13 = &881F = 34847 = 191.4 degrees
 EQUB &47               \ Section 14 = &6047 = 24647 = 135.4 degrees
 EQUB &14               \ Section 15 = &7714 = 30484 = 167.5 degrees
 EQUB &B8               \ Section 16 = &7BB8 = 31672 = 174.0 degrees
 EQUB &B8               \ Section 17 = &7BB8 = 31672 = 174.0 degrees
 EQUB &B8               \ Section 18 = &7BB8 = 31672 = 174.0 degrees
 EQUB &8D               \ Section 19 = &BB8D = 48013 = 263.7 degrees
 EQUB &8D               \ Section 20 = &BB8D = 48013 = 263.7 degrees
 EQUB &8D               \ Section 21 = &BB8D = 48013 = 263.7 degrees
 EQUB &0                \ Section 22 = &0000 =     0 =   0.0 degrees
 EQUB &0                \ Section 23 = &0000 =     0 =   0.0 degrees

 EQUB &B3, &B3          \ These bytes appear to be unused
 EQUB &B3, &28
 EQUB &C8, &00

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
 EQUB &FE               \ Section  1 = &FEEE = 65262 = 358.5 degrees
 EQUB &FF               \ Section  2 = &FFD2 = 65490 = 359.7 degrees
 EQUB &FF               \ Section  3 = &FFD2 = 65490 = 359.7 degrees
 EQUB &D9               \ Section  4 = &D9C6 = 55750 = 306.2 degrees
 EQUB &D9               \ Section  5 = &D9C6 = 55750 = 306.2 degrees
 EQUB &0C               \ Section  6 = &0C18 =  3096 =  17.0 degrees
 EQUB &11               \ Section  7 = &11C7 =  4551 =  25.0 degrees
 EQUB &45               \ Section  8 = &453F = 17727 =  97.4 degrees
 EQUB &45               \ Section  9 = &453F = 17727 =  97.4 degrees
 EQUB &45               \ Section 10 = &453F = 17727 =  97.4 degrees
 EQUB &8F               \ Section 11 = &8F97 = 36759 = 201.9 degrees
 EQUB &89               \ Section 12 = &895E = 35166 = 193.2 degrees
 EQUB &88               \ Section 13 = &881F = 34847 = 191.4 degrees
 EQUB &60               \ Section 14 = &6047 = 24647 = 135.4 degrees
 EQUB &77               \ Section 15 = &7714 = 30484 = 167.5 degrees
 EQUB &7B               \ Section 16 = &7BB8 = 31672 = 174.0 degrees
 EQUB &7B               \ Section 17 = &7BB8 = 31672 = 174.0 degrees
 EQUB &7B               \ Section 18 = &7BB8 = 31672 = 174.0 degrees
 EQUB &BB               \ Section 19 = &BB8D = 48013 = 263.7 degrees
 EQUB &BB               \ Section 20 = &BB8D = 48013 = 263.7 degrees
 EQUB &BB               \ Section 21 = &BB8D = 48013 = 263.7 degrees
 EQUB &00               \ Section 22 = &0000 =     0 =   0.0 degrees
 EQUB &00               \ Section 23 = &0000 =     0 =   0.0 degrees

 EQUB &A1, &A1          \ These bytes appear to be unused
 EQUB &A1, &DF
 EQUB &F3, &00

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
 EQUB %00001000         \ Section  1 = 000010 0 0    From  2  check     curve
 EQUB %00010000         \ Section  2 = 000100 0 0    From  4  check     curve
 EQUB %00011000         \ Section  3 = 000110 0 0    From  6  check     curve
 EQUB %00100111         \ Section  4 = 001001 1 1    From  9  no check  straight
 EQUB %00100110         \ Section  5 = 001001 1 0    From  9  no check  curve
 EQUB %00110010         \ Section  6 = 001100 1 0    From 12  no check  curve
 EQUB %00111010         \ Section  7 = 001110 1 0    From 14  no check  curve
 EQUB %01001011         \ Section  8 = 010010 1 1    From 18  no check  straight
 EQUB %01001010         \ Section  9 = 010010 1 0    From 18  no check  curve
 EQUB %01001110         \ Section 10 = 010011 1 0    From 19  no check  curve
 EQUB %01011110         \ Section 11 = 010111 1 0    From 23  no check  curve
 EQUB %01100110         \ Section 12 = 011001 1 0    From 25  no check  curve
 EQUB %01110010         \ Section 13 = 011100 1 0    From 28  no check  curve
 EQUB %01110110         \ Section 14 = 011101 1 0    From 29  no check  curve
 EQUB %01111110         \ Section 15 = 011111 1 0    From 31  no check  curve
 EQUB %10000110         \ Section 16 = 100001 1 0    From 33  no check  curve
 EQUB %10001110         \ Section 17 = 100011 1 0    From 35  no check  curve
 EQUB %10010110         \ Section 18 = 100101 1 0    From 37  no check  curve
 EQUB %10100111         \ Section 19 = 101001 1 1    From 41  no check  straight
 EQUB %10100110         \ Section 20 = 101001 1 0    From 41  no check  curve
 EQUB %10101010         \ Section 21 = 101010 1 0    From 42  no check  curve
 EQUB %10101111         \ Section 22 = 101011 1 1    From 43  no check  straight
 EQUB %10101110         \ Section 23 = 101011 1 0    From 43  no check  curve

 EQUB &BC, &C4          \ These bytes appear to be unused
 EQUB &CE, &DA
 EQUB &E2, &00

\ ******************************************************************************
\
\       Name: trackSteering
\       Type: Variable
\   Category: Extra tracks
\    Summary: The optimum steering for non-player drivers on each track section
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Snetterton track
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

 EQUB %00000000         \ Section  0 = 000000 0 0            <- 0*
 EQUB %00011001         \ Section  1 = 000110 0 1            -> 6*
 EQUB %00011001         \ Section  2 = 000110 0 1            -> 6*
 EQUB %00101110         \ Section  3 = 001011 1 0            <- 11
 EQUB %00000000         \ Section  4 = 000000 0 0            <- 0*
 EQUB %01010111         \ Section  5 = 010101 1 1            -> 21
 EQUB %00011000         \ Section  6 = 000110 0 0            <- 6*
 EQUB %00111111         \ Section  7 = 001111 1 1            -> 15
 EQUB %00011000         \ Section  8 = 000110 0 0            <- 6*
 EQUB %00011000         \ Section  9 = 000110 0 0            <- 6*
 EQUB %00111101         \ Section 10 = 001111 0 1            -> 15*
 EQUB %00011001         \ Section 11 = 000110 0 1            -> 6*
 EQUB %00011001         \ Section 12 = 000110 0 1            -> 6*
 EQUB %01100100         \ Section 13 = 011001 0 0            <- 25*
 EQUB %10111101         \ Section 14 = 101111 0 1            -> 47*
 EQUB %00100100         \ Section 15 = 001001 0 0            <- 9*
 EQUB %00011000         \ Section 16 = 000110 0 0            <- 6*
 EQUB %00011000         \ Section 17 = 000110 0 0            <- 6*
 EQUB %01101011         \ Section 18 = 011010 1 1            -> 26
 EQUB %00011000         \ Section 19 = 000110 0 0            <- 6*
 EQUB %00011000         \ Section 20 = 000110 0 0            <- 6*
 EQUB %01010111         \ Section 21 = 010101 1 1            -> 21
 EQUB %00011001         \ Section 22 = 000110 0 1            -> 6*
 EQUB %00000000         \ Section 23 = 000000 0 0            <- 0*

 EQUB &00, &18          \ These bytes appear to be unused
 EQUB &4B, &18
 EQUB &18, &18
 EQUB &00

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
\             The Snetterton track
\
\ ------------------------------------------------------------------------------
\
\ Snetterton consists of the following track sections:
\
\   0    |<-|   Sear to the Esses (3/5)
\   1    |->|   Sear to the Esses (4/5)
\   2    {}     Sear to the Esses (5/5)
\   3    <-     The Esses (1/3)
\   4    ||     The Esses (2/3)
\   5    |->|   The Esses (3/3)
\   6    |->|   The Esses to the Bomb Hole
\   7    ->     The Bomb Hole
\   8    ||     The Bomb Hole to Coram (1/2)
\   9    ||     The Bomb Hole to Coram (2/2)
\   10   ->     Coram
\   11   |<-|   Coram to Russell (1/2)
\   12   |<->|  Coram to Russell (2/2)
\   13   <-     Russell
\   14   ->     Russell to Riches (1/4)
\   15   |->|   Russell to Riches (2/4)
\   16   {}     Russell to Riches (3/4)
\   17   ||     Russell to Riches (4/4)
\   18   ->     Riches
\   19   ||     Riches to Seer (1/2)
\   20   ||     Riches to Seer (2/2)
\   21   ->     Sear
\   22   ||     Sear to the Esses (1/5)
\   23   ||     Sear to the Esses (2/5)
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

 EQUB %01000000         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &20               \ xTrackSectionILo       xTrackSectionI = &D120 = -12000
 EQUB &00               \ yTrackSectionILo       yTrackSectionI = &1400 =   5120
 EQUB &20               \ zTrackSectionILo       zTrackSectionI = &D120 = -12000
 EQUB &28               \ xTrackSectionOLo       xTrackSectionO = &D028 = -12248
 EQUB 1                 \ trackSectionFrom
 EQUB &20               \ zTrackSectionOLo       zTrackSectionO = &D120 = -12000
 EQUB 29                \ trackSectionSize

                        \ Track section 1

 EQUB %01000000         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &AD               \ xTrackSectionILo       xTrackSectionI = &D0AD = -12115
 EQUB &00               \ yTrackSectionILo       yTrackSectionI = &1400 =   5120
 EQUB &B8               \ zTrackSectionILo       zTrackSectionI = &DEB8 =  -8520
 EQUB &B5               \ xTrackSectionOLo       xTrackSectionO = &CFB5 = -12363
 EQUB 31                \ trackSectionFrom
 EQUB &AF               \ zTrackSectionOLo       zTrackSectionO = &DEAF =  -8529
 EQUB 67                \ trackSectionSize

                        \ Track section 2

 EQUB %01101000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=00 Sh=0
 EQUB &68               \ xTrackSectionILo       xTrackSectionI = &D068 = -12184
 EQUB &00               \ yTrackSectionILo       yTrackSectionI = &1400 =   5120
 EQUB &20               \ zTrackSectionILo       zTrackSectionI = &FE20 =   -480
 EQUB &70               \ xTrackSectionOLo       xTrackSectionO = &CF70 = -12432
 EQUB 19                \ trackSectionFrom
 EQUB &1D               \ zTrackSectionOLo       zTrackSectionO = &FE1D =   -483
 EQUB 38                \ trackSectionSize

                        \ Track section 3

 EQUB %11110011         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &42               \ xTrackSectionILo       xTrackSectionI = &D042 = -12222
 EQUB &81               \ yTrackSectionILo       yTrackSectionI = &1181 =   4481
 EQUB &F0               \ zTrackSectionILo       zTrackSectionI = &0FF0 =   4080
 EQUB &4A               \ xTrackSectionOLo       xTrackSectionO = &CF4A = -12470
 EQUB 18                \ trackSectionFrom
 EQUB &ED               \ zTrackSectionOLo       zTrackSectionO = &0FED =   4077
 EQUB 16                \ trackSectionSize

                        \ Track section 4

 EQUB %00000000         \ trackSectionFlag       Sp=0 G=0 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &97               \ xTrackSectionILo       xTrackSectionI = &CC97 = -13161
 EQUB &54               \ yTrackSectionILo       yTrackSectionI = &1154 =   4436
 EQUB &3B               \ zTrackSectionILo       zTrackSectionI = &163B =   5691
 EQUB &06               \ xTrackSectionOLo       xTrackSectionO = &CC06 = -13306
 EQUB 35                \ trackSectionFrom
 EQUB &72               \ zTrackSectionOLo       zTrackSectionO = &1572 =   5490
 EQUB 9                 \ trackSectionSize

                        \ Track section 5

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &2E               \ xTrackSectionILo       xTrackSectionI = &C92E = -14034
 EQUB &54               \ yTrackSectionILo       yTrackSectionI = &1154 =   4436
 EQUB &B1               \ zTrackSectionILo       zTrackSectionI = &18B1 =   6321
 EQUB &9D               \ xTrackSectionOLo       xTrackSectionO = &C89D = -14179
 EQUB 37                \ trackSectionFrom
 EQUB &E8               \ zTrackSectionOLo       zTrackSectionO = &17E8 =   6120
 EQUB 7                 \ trackSectionSize

                        \ Track section 6

 EQUB %01110010         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=01 Sh=0
 EQUB &09               \ xTrackSectionILo       xTrackSectionI = &C809 = -14327
 EQUB &54               \ yTrackSectionILo       yTrackSectionI = &1154 =   4436
 EQUB &50               \ zTrackSectionILo       zTrackSectionI = &1B50 =   6992
 EQUB &1B               \ xTrackSectionOLo       xTrackSectionO = &C71B = -14565
 EQUB 5                 \ trackSectionFrom
 EQUB &98               \ zTrackSectionOLo       zTrackSectionO = &1B98 =   7064
 EQUB 38                \ trackSectionSize

                        \ Track section 7

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &65               \ xTrackSectionILo       xTrackSectionI = &CF65 = -12443
 EQUB &54               \ yTrackSectionILo       yTrackSectionI = &1154 =   4436
 EQUB &84               \ zTrackSectionILo       zTrackSectionI = &2B84 =  11140
 EQUB &84               \ xTrackSectionOLo       xTrackSectionO = &CE84 = -12668
 EQUB 4                 \ trackSectionFrom
 EQUB &EB               \ zTrackSectionOLo       zTrackSectionO = &2BEB =  11243
 EQUB 16                \ trackSectionSize

                        \ Track section 8

 EQUB %00000010         \ trackSectionFlag       Sp=0 G=0 Mc=0 Mlr=00 Vc=01 Sh=0
 EQUB &7E               \ xTrackSectionILo       xTrackSectionI = &D57E = -10882
 EQUB &58               \ yTrackSectionILo       yTrackSectionI = &1158 =   4440
 EQUB &07               \ zTrackSectionILo       zTrackSectionI = &2F07 =  12039
 EQUB &9C               \ xTrackSectionOLo       xTrackSectionO = &D59C = -10852
 EQUB 21                \ trackSectionFrom
 EQUB &FC               \ zTrackSectionOLo       zTrackSectionO = &2FFC =  12284
 EQUB 17                \ trackSectionSize

                        \ Track section 9

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &65               \ xTrackSectionILo       xTrackSectionI = &DD65 =  -8859
 EQUB &68               \ yTrackSectionILo       yTrackSectionI = &1268 =   4712
 EQUB &08               \ zTrackSectionILo       zTrackSectionI = &2E08 =  11784
 EQUB &83               \ xTrackSectionOLo       xTrackSectionO = &DD83 =  -8829
 EQUB 23                \ trackSectionFrom
 EQUB &FD               \ zTrackSectionOLo       zTrackSectionO = &2EFD =  12029
 EQUB 18                \ trackSectionSize

                        \ Track section 10

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &C3               \ xTrackSectionILo       xTrackSectionI = &E5C3 =  -6717
 EQUB &88               \ yTrackSectionILo       yTrackSectionI = &1388 =   5000
 EQUB &FA               \ zTrackSectionILo       zTrackSectionI = &2CFA =  11514
 EQUB &E1               \ xTrackSectionOLo       xTrackSectionO = &E5E1 =  -6687
 EQUB 2                 \ trackSectionFrom
 EQUB &EF               \ zTrackSectionOLo       zTrackSectionO = &2DEF =  11759
 EQUB 52                \ trackSectionSize

                        \ Track section 11

 EQUB %01000000         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &26               \ xTrackSectionILo       xTrackSectionI = &EF26 =  -4314
 EQUB &66               \ yTrackSectionILo       yTrackSectionI = &1166 =   4454
 EQUB &C9               \ zTrackSectionILo       zTrackSectionI = &19C9 =   6601
 EQUB &0A               \ xTrackSectionOLo       xTrackSectionO = &F00A =  -4086
 EQUB 15                \ trackSectionFrom
 EQUB &6C               \ zTrackSectionOLo       zTrackSectionO = &196C =   6508
 EQUB 30                \ trackSectionSize

                        \ Track section 12

 EQUB %01101000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=01 Vc=00 Sh=0
 EQUB &3F               \ xTrackSectionILo       xTrackSectionI = &EA3F =  -5569
 EQUB &D2               \ yTrackSectionILo       yTrackSectionI = &0ED2 =   3794
 EQUB &A6               \ zTrackSectionILo       zTrackSectionI = &0CA6 =   3238
 EQUB &30               \ xTrackSectionOLo       xTrackSectionO = &EB30 =  -5328
 EQUB 6                 \ trackSectionFrom
 EQUB &70               \ zTrackSectionOLo       zTrackSectionO = &0C70 =   3184
 EQUB 29                \ trackSectionSize

                        \ Track section 13

 EQUB %11110011         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=10 Vc=01 Sh=1
 EQUB &33               \ xTrackSectionILo       xTrackSectionI = &E833 =  -6093
 EQUB &3B               \ yTrackSectionILo       yTrackSectionI = &0D3B =   3387
 EQUB &38               \ zTrackSectionILo       zTrackSectionI = &FF38 =   -200
 EQUB &26               \ xTrackSectionOLo       xTrackSectionO = &E926 =  -5850
 EQUB 37                \ trackSectionFrom
 EQUB &08               \ zTrackSectionOLo       zTrackSectionO = &FF08 =   -248
 EQUB 17                \ trackSectionSize

                        \ Track section 14

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &A5               \ xTrackSectionILo       xTrackSectionI = &EAA5 =  -5467
 EQUB &B3               \ yTrackSectionILo       yTrackSectionI = &0CB3 =   3251
 EQUB &F7               \ zTrackSectionILo       zTrackSectionI = &F7F7 =  -2057
 EQUB &54               \ xTrackSectionOLo       xTrackSectionO = &EB54 =  -5292
 EQUB 16                \ trackSectionFrom
 EQUB &A6               \ zTrackSectionOLo       zTrackSectionO = &F8A6 =  -1882
 EQUB 8                 \ trackSectionSize

                        \ Track section 15

 EQUB %11000000         \ trackSectionFlag       Sp=1 G=1 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &67               \ xTrackSectionILo       xTrackSectionI = &EC67 =  -5017
 EQUB &97               \ yTrackSectionILo       yTrackSectionI = &0C97 =   3223
 EQUB &B6               \ zTrackSectionILo       zTrackSectionI = &F4B6 =  -2890
 EQUB &58               \ xTrackSectionOLo       xTrackSectionO = &ED58 =  -4776
 EQUB 26                \ trackSectionFrom
 EQUB &EB               \ zTrackSectionOLo       zTrackSectionO = &F4EB =  -2837
 EQUB 43                \ trackSectionSize

                        \ Track section 16

 EQUB %01000000         \ trackSectionFlag       Sp=0 G=1 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &E5               \ xTrackSectionILo       xTrackSectionI = &EEE5 =  -4379
 EQUB &1B               \ yTrackSectionILo       yTrackSectionI = &101B =   4123
 EQUB &C2               \ zTrackSectionILo       zTrackSectionI = &E0C2 =  -7998
 EQUB &DA               \ xTrackSectionOLo       xTrackSectionO = &EFDA =  -4134
 EQUB 31                \ trackSectionFrom
 EQUB &DC               \ zTrackSectionOLo       zTrackSectionO = &E0DC =  -7972
 EQUB 54                \ trackSectionSize

                        \ Track section 17

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &A3               \ xTrackSectionILo       xTrackSectionI = &F1A3 =  -3677
 EQUB &FF               \ yTrackSectionILo       yTrackSectionI = &13FF =   5119
 EQUB &A8               \ zTrackSectionILo       zTrackSectionI = &C7A8 = -14424
 EQUB &98               \ xTrackSectionOLo       xTrackSectionO = &F298 =  -3432
 EQUB 7                 \ trackSectionFrom
 EQUB &C2               \ zTrackSectionOLo       zTrackSectionO = &C7C2 = -14398
 EQUB 35                \ trackSectionSize

                        \ Track section 18

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &6A               \ xTrackSectionILo       xTrackSectionI = &F36A =  -3222
 EQUB &FF               \ yTrackSectionILo       yTrackSectionI = &13FF =   5119
 EQUB &63               \ zTrackSectionILo       zTrackSectionI = &B763 = -18589
 EQUB &5F               \ xTrackSectionOLo       xTrackSectionO = &F45F =  -2977
 EQUB 4                 \ trackSectionFrom
 EQUB &7D               \ zTrackSectionOLo       zTrackSectionO = &B77D = -18563
 EQUB 30                \ trackSectionSize

                        \ Track section 19

 EQUB %00000010         \ trackSectionFlag       Sp=0 G=0 Mc=0 Mlr=00 Vc=01 Sh=0
 EQUB &76               \ xTrackSectionILo       xTrackSectionI = &EA76 =  -5514
 EQUB &FF               \ yTrackSectionILo       yTrackSectionI = &13FF =   5119
 EQUB &BC               \ zTrackSectionILo       zTrackSectionI = &ADBC = -21060
 EQUB &90               \ xTrackSectionOLo       xTrackSectionO = &EA90 =  -5488
 EQUB 36                \ trackSectionFrom
 EQUB &C6               \ zTrackSectionOLo       zTrackSectionO = &ACC6 = -21306
 EQUB 24                \ trackSectionSize

                        \ Track section 20

 EQUB %01110000         \ trackSectionFlag       Sp=0 G=1 Mc=1 Mlr=10 Vc=00 Sh=0
 EQUB &4E               \ xTrackSectionILo       xTrackSectionI = &DF4E =  -8370
 EQUB &FF               \ yTrackSectionILo       yTrackSectionI = &13FF =   5119
 EQUB &84               \ zTrackSectionILo       zTrackSectionI = &AC84 = -21372
 EQUB &68               \ xTrackSectionOLo       xTrackSectionO = &DF68 =  -8344
 EQUB 39                \ trackSectionFrom
 EQUB &8E               \ zTrackSectionOLo       zTrackSectionO = &AB8E = -21618
 EQUB 25                \ trackSectionSize

                        \ Track section 21

 EQUB %11101101         \ trackSectionFlag       Sp=1 G=1 Mc=1 Mlr=01 Vc=10 Sh=1
 EQUB &AF               \ xTrackSectionILo       xTrackSectionI = &D3AF = -11345
 EQUB &FF               \ yTrackSectionILo       yTrackSectionI = &13FF =   5119
 EQUB &3F               \ zTrackSectionILo       zTrackSectionI = &AB3F = -21697
 EQUB &C9               \ xTrackSectionOLo       xTrackSectionO = &D3C9 = -11319
 EQUB 26                \ trackSectionFrom
 EQUB &49               \ zTrackSectionOLo       zTrackSectionO = &AA49 = -21943
 EQUB 9                 \ trackSectionSize

                        \ Track section 22

 EQUB %00000010         \ trackSectionFlag       Sp=0 G=0 Mc=0 Mlr=00 Vc=01 Sh=0
 EQUB &20               \ xTrackSectionILo       xTrackSectionI = &D120 = -12000
 EQUB &FF               \ yTrackSectionILo       yTrackSectionI = &13FF =   5119
 EQUB &FA               \ zTrackSectionILo       zTrackSectionI = &ADFA = -20998
 EQUB &28               \ xTrackSectionOLo       xTrackSectionO = &D028 = -12248
 EQUB 37                \ trackSectionFrom
 EQUB &FA               \ zTrackSectionOLo       zTrackSectionO = &ADFA = -20998
 EQUB 35                \ trackSectionSize

                        \ Track section 23

 EQUB %11000000         \ trackSectionFlag       Sp=1 G=1 Mc=0 Mlr=00 Vc=00 Sh=0
 EQUB &20               \ xTrackSectionILo       xTrackSectionI = &D120 = -12000
 EQUB &FF               \ yTrackSectionILo       yTrackSectionI = &13FF =   5119
 EQUB &62               \ zTrackSectionILo       zTrackSectionI = &BE62 = -16798
 EQUB &28               \ xTrackSectionOLo       xTrackSectionO = &D028 = -12248
 EQUB 0                 \ trackSectionFrom
 EQUB &62               \ zTrackSectionOLo       zTrackSectionO = &BE62 = -16798
 EQUB 40                \ trackSectionSize

 EQUB &40               \ This byte appears to be unused

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

.joys3

 LDY #181               \ Set Y = 181 so by default we scale the steering by
                        \ 1.00

 CMP #160               \ If the track section = 160 (i.e. section 20), jump to
 BEQ joys4              \ joys4 to scale the steering by 1.16

 CMP #168               \ If the track section <> 168 (i.e. section 21), jump to
 BNE joys5              \ joys5 to keep checking

 LSR playerDrift        \ Clear bit 7 of playerDrift to denote that the player
                        \ is not drifting sideways (i.e. cancel any drift)

.joys4

 LDY #195               \ Set Y = 195 so we scale the steering by 1.16

.joys5

 JMP joys6              \ Jump to part 3 to scale the steering

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

 EQUB &26, &77          \ These bytes appear to be unused
 EQUB &60, &00
 EQUB &00

\ ******************************************************************************
\
\       Name: trackSectionCount
\       Type: Variable
\   Category: Extra tracks
\    Summary: The total number of track sections * 8
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Snetterton track
\
\ ******************************************************************************

 EQUB 24 * 8

\ ******************************************************************************
\
\       Name: trackVectorCount
\       Type: Variable
\   Category: Track data
\    Summary: The total number of segment vectors in the segment vector tables
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Snetterton track
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
\             The Snetterton track
\
\ ------------------------------------------------------------------------------
\
\ The highest segment number is this value minus 1, as segment numbers start
\ from zero.
\
\ ******************************************************************************

 EQUW 686               \ Segments are numbered from 0 to 685

\ ******************************************************************************
\
\       Name: trackStartLine
\       Type: Variable
\   Category: Track data
\    Summary: The segment number of the starting line
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Snetterton track
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

 EQUW 686 - 434         \ The starting line is at segment 434

\ ******************************************************************************
\
\       Name: trackLapTimeSec
\       Type: Variable
\   Category: Extra tracks
\    Summary: Lap times for adjusting the race class (seconds)
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Snetterton track
\
\ ------------------------------------------------------------------------------
\
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we change the race class to the relevant difficulty.
\
\ This figure is stored in Binary Coded Decimal (BCD).
\
\ ******************************************************************************

 EQUB &09               \ Set class to Novice if slowest lap time > 1:09

 EQUB &05               \ Set class to Amateur if slowest lap time > 1:05

 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackLapTimeMin
\       Type: Variable
\   Category: Extra tracks
\    Summary: Lap times for adjusting the race class (minutes)
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Snetterton track
\
\ ------------------------------------------------------------------------------
\
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we change the race class to the relevant difficulty.
\
\ ******************************************************************************

 EQUB 1                 \ Set class to Novice if slowest lap time > 1:09

 EQUB 1                 \ Set class to Amateur if slowest lap time > 1:05

 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackGearRatio
\       Type: Variable
\   Category: Extra tracks
\    Summary: The gear ratio for each gear
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Snetterton track
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

 EQUB 53                \ Third gear

 EQUB 47                \ Fourth gear

 EQUB 42                \ Fifth gear

\ ******************************************************************************
\
\       Name: trackGearPower
\       Type: Variable
\   Category: Extra tracks
\    Summary: The power for each gear
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Snetterton track
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

 EQUB 82                \ Third gear

 EQUB 72                \ Fourth gear

 EQUB 65                \ Fifth gear

\ ******************************************************************************
\
\       Name: trackBaseSpeed
\       Type: Variable
\   Category: Extra tracks
\    Summary: The base speed for each race class, used when generating the best
\             racing lines and non-player driver speeds
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Snetterton track
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
\             The Snetterton track
\
\ ******************************************************************************

 EQUB 8

\ ******************************************************************************
\
\       Name: trackCarSpacing
\       Type: Variable
\   Category: Extra tracks
\    Summary: The spacing between the cars at the start of a qualifying lap, in
\             segments
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Snetterton track
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
\             The Snetterton track
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

 EQUB 45

\ ******************************************************************************
\
\       Name: trackRaceSlowdown
\       Type: Variable
\   Category: Extra tracks
\    Summary: Slowdown factor for non-player drivers in the race
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Snetterton track
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
\             The Snetterton track
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
\             The Snetterton track
\
\ ******************************************************************************

.trackChecksum

 EQUB &A6               \ Counts the number of data bytes ending in %00

 EQUB &C2               \ Counts the number of data bytes ending in %01

 EQUB &3E               \ Counts the number of data bytes ending in %10

 EQUB &7F               \ Counts the number of data bytes ending in %11

\ ******************************************************************************
\
\       Name: trackGameName
\       Type: Variable
\   Category: Extra tracks
\    Summary: The game name
\  Deep dive: The track data file format
\             The extra tracks data file format
\             The Snetterton track
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
\             The Snetterton track
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

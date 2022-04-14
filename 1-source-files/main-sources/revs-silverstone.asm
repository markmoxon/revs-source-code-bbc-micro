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
\       Name: Track section data (high bytes)
\       Type: Variable
\   Category: Track
\    Summary: Data for the track sections
\
\ ------------------------------------------------------------------------------
\
\ Key:
\   || is a straight, with just two vectors defined (start and end)
\   {} is a straight, but with multiple vectors
\   -> is a right turn
\   <- is a left turn
\
\ Section                [road signs]   Description                       Size
\
\ Track section  0   ||  [chicane]      Abbey Curve to Woodcote Corner      99
\ Track section  1   ->                 Woodcote Corner (chicane right)     21
\ Track section  2   <-  [straight]     Woodcote Corner (chicane left)      12
\ Track section  3   ->  [start]        Woodcote Corner (chicane right)     21
\ Track section  4   ||                 Home Straight                      105
\ Track section  5   ->  [right]        Copse Corner                        24
\ Track section  6   ||                 Copse Corner to Maggotts Curve      28
\ Track section  7   {}  [straight]     Copse Corner to Maggotts Curve       9
\ Track section  8   ||                 Copse Corner to Maggotts Curve      54
\ Track section  9   <-  [left]         Maggotts Curve                      16
\ Track section 10   ||                 Maggotts Curve to Becketts Corner   38
\ Track section 11   ||                 Maggotts Curve to Becketts Corner   27
\ Track section 12   ->  [right]        Becketts Corner                     27
\ Track section 13   ||                 Becketts Corner to Chapel Curve     40
\ Track section 14   <-  [left, st, st] Chapel Curve                        16
\ Track section 15   ||                 Hangar Straight                    135
\ Track section 16   {}                 Hangar Straight                      6
\ Track section 17   ||                 Hangar Straight                     28
\ Track section 18   ->  [right]        Stowe Corner                        40
\ Track section 19   ||  [straight]     Stowe Corner to Club Corner        104
\ Track section 20   ->  [right]        Club Corner                         33
\ Track section 21   ||  [straight]     Club Corner to Abbey Curve          85
\ Track section 22   <-  [left]         Abbey Curve                         18
\ Track section 23   {}  [straight]     Abbey Curve to Woodcote Corner      38
\
\ .trackSection0a
\ trackData      = &5300
\ Bits 4-7 of trackData+0 (i.e. first digit in hex value) is an index into
\ trackData+&0D0, trackData+&0E0, trackData+&0F0
\ Bits 0-3 gets put into L0007 in sub_C1267
\
\ .xTrackSectionIHi
\ High byte of the start x-coordinate of the inside verge of each track section
\ trackData+&001 = &5301
\
\ .yTrackSectionIHi
\ High byte of the start y-coordinate of the inside verge of each track section
\ trackData+&002 = &5302
\
\ .zTrackSectionIHi
\ High byte of the start z-coordinate of the inside verge of each track section
\ trackData+&003 = &5303
\
\ .xTrackSectionOHi
\ High byte of the start x-coordinate of the outside verge of each track section
\ trackData+&004 = &5304
\
\ .trackSectionTurn
\ Progress range within the section where cars should turn into the corner
\ trackData+&005 = &5305
\
\ .zTrackSectionOHi
\ High byte of the start z-coordinate of the outside verge of each track section
\ trackData+&006 = &5306
\
\ .trackMaxSpeed
\ The maximum speed for non-player drivers on this section of the track
\ trackData+&007 = &5307
\
\ ******************************************************************************

                        \ Track section 0

 EQUB &03               \ trackSection0a
 EQUB &D1               \ xTrackSectionIHi (xTrackSectionI = &D120)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80)
 EQUB &0F               \ zTrackSectionIHi (zTrackSectionI = &0FA0)
 EQUB &CF               \ xTrackSectionOHi (xTrackSectionO = &CFC0)
 EQUB 96                \ trackSectionTurn
 EQUB &0F               \ zTrackSectionOHi (zTrackSectionO = &0F94)
 EQUB 136               \ trackMaxSpeed

                        \ Track section 1

 EQUB &13               \ trackSection0a
 EQUB &CF               \ xTrackSectionIHi (xTrackSectionI = &CF94)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80)
 EQUB &3E               \ zTrackSectionIHi (zTrackSectionI = &3E08)
 EQUB &CE               \ xTrackSectionOHi (xTrackSectionO = &CE34)
 EQUB 18                \ trackSectionTurn
 EQUB &3D               \ zTrackSectionOHi (zTrackSectionO = &3DFC)
 EQUB 0                 \ trackMaxSpeed

                        \ Track section 2

 EQUB &12               \ trackSection0a
 EQUB &D3               \ xTrackSectionIHi (xTrackSectionI = &D325)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80)
 EQUB &46               \ zTrackSectionIHi (zTrackSectionI = &4696)
 EQUB &D2               \ xTrackSectionOHi (xTrackSectionO = &D2C5)
 EQUB 20                \ trackSectionTurn
 EQUB &47               \ zTrackSectionOHi (zTrackSectionO = &47E8)
 EQUB 138               \ trackMaxSpeed

                        \ Track section 3

 EQUB &22               \ trackSection0a
 EQUB &D6               \ xTrackSectionIHi (xTrackSectionI = &D6B2)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80)
 EQUB &4A               \ zTrackSectionIHi (zTrackSectionI = &4A91)
 EQUB &D5               \ xTrackSectionOHi (xTrackSectionO = &D556)
 EQUB 30                \ trackSectionTurn
 EQUB &4A               \ zTrackSectionOHi (zTrackSectionO = &4AC9)
 EQUB 33                \ trackMaxSpeed

                        \ Track section 4

 EQUB &22               \ trackSection0a
 EQUB &DE               \ xTrackSectionIHi (xTrackSectionI = &DEAF)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80)
 EQUB &4F               \ zTrackSectionIHi (zTrackSectionI = &4F4F)
 EQUB &DE               \ xTrackSectionOHi (xTrackSectionO = &DE9F)
 EQUB 98                \ trackSectionTurn
 EQUB &50               \ zTrackSectionOHi (zTrackSectionO = &50AE)
 EQUB 125               \ trackMaxSpeed

                        \ Track section 5

 EQUB &33               \ trackSection0a
 EQUB &0F               \ xTrackSectionIHi (xTrackSectionI = &0FE7)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80)
 EQUB &51               \ zTrackSectionIHi (zTrackSectionI = &515C)
 EQUB &0F               \ xTrackSectionOHi (xTrackSectionO = &0FD7)
 EQUB 40                \ trackSectionTurn
 EQUB &52               \ zTrackSectionOHi (zTrackSectionO = &52BB)
 EQUB 26                \ trackMaxSpeed

                        \ Track section 6

 EQUB &42               \ trackSection0a
 EQUB &17               \ xTrackSectionIHi (xTrackSectionI = &17D8)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0CCB)
 EQUB &4B               \ zTrackSectionIHi (zTrackSectionI = &4B09)
 EQUB &19               \ xTrackSectionOHi (xTrackSectionO = &1937)
 EQUB 255               \ trackSectionTurn
 EQUB &4B               \ zTrackSectionOHi (zTrackSectionO = &4B17)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 7

 EQUB &53               \ trackSection0a
 EQUB &18               \ xTrackSectionIHi (xTrackSectionI = &1864)
 EQUB &0E               \ yTrackSectionIHi (yTrackSectionI = &0E53)
 EQUB &3D               \ zTrackSectionIHi (zTrackSectionI = &3DE9)
 EQUB &19               \ xTrackSectionOHi (xTrackSectionO = &19C3)
 EQUB 0                 \ trackSectionTurn
 EQUB &3D               \ zTrackSectionOHi (zTrackSectionO = &3DF7)
 EQUB 0                 \ trackMaxSpeed

                        \ Track section 8

 EQUB &53               \ trackSection0a
 EQUB &18               \ xTrackSectionIHi (xTrackSectionI = &1891)
 EQUB &0E               \ yTrackSectionIHi (yTrackSectionI = &0E77)
 EQUB &39               \ zTrackSectionIHi (zTrackSectionI = &39B1)
 EQUB &19               \ xTrackSectionOHi (xTrackSectionO = &19F0)
 EQUB 33                \ trackSectionTurn
 EQUB &39               \ zTrackSectionOHi (zTrackSectionO = &39BF)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 9

 EQUB &64               \ trackSection0a
 EQUB &19               \ xTrackSectionIHi (xTrackSectionI = &199F)
 EQUB &0D               \ yTrackSectionIHi (yTrackSectionI = &0D9F)
 EQUB &20               \ zTrackSectionIHi (zTrackSectionI = &2061)
 EQUB &1A               \ xTrackSectionOHi (xTrackSectionO = &1AFE)
 EQUB 40                \ trackSectionTurn
 EQUB &20               \ zTrackSectionOHi (zTrackSectionO = &206F)
 EQUB 12                \ trackMaxSpeed

                        \ Track section 10

 EQUB &64               \ trackSection0a
 EQUB &1B               \ xTrackSectionIHi (xTrackSectionI = &1BFA)
 EQUB &0D               \ yTrackSectionIHi (yTrackSectionI = &0D5F)
 EQUB &19               \ zTrackSectionIHi (zTrackSectionI = &195D)
 EQUB &1D               \ xTrackSectionOHi (xTrackSectionO = &1D1B)
 EQUB 255               \ trackSectionTurn
 EQUB &1A               \ zTrackSectionOHi (zTrackSectionO = &1A25)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 11

 EQUB &73               \ trackSection0a
 EQUB &26               \ xTrackSectionIHi (xTrackSectionI = &2612)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0CC7)
 EQUB &0A               \ zTrackSectionIHi (zTrackSectionI = &0AAB)
 EQUB &27               \ xTrackSectionOHi (xTrackSectionO = &2733)
 EQUB 21                \ trackSectionTurn
 EQUB &0B               \ zTrackSectionOHi (zTrackSectionO = &0B73)
 EQUB 116               \ trackMaxSpeed

                        \ Track section 12

 EQUB &72               \ trackSection0a
 EQUB &2D               \ xTrackSectionIHi (xTrackSectionI = &2DC5)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C5B)
 EQUB &00               \ zTrackSectionIHi (zTrackSectionI = &008B)
 EQUB &2E               \ xTrackSectionOHi (xTrackSectionO = &2EDD)
 EQUB 39                \ trackSectionTurn
 EQUB &01               \ zTrackSectionOHi (zTrackSectionO = &015F)
 EQUB 25                \ trackMaxSpeed

                        \ Track section 13

 EQUB &72               \ trackSection0a
 EQUB &29               \ xTrackSectionIHi (xTrackSectionI = &2965)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C4D)
 EQUB &F6               \ zTrackSectionIHi (zTrackSectionI = &F67E)
 EQUB &29               \ xTrackSectionOHi (xTrackSectionO = &29D3)
 EQUB 24                \ trackSectionTurn
 EQUB &F5               \ zTrackSectionOHi (zTrackSectionO = &F52F)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 14

 EQUB &84               \ trackSection0a
 EQUB &17               \ xTrackSectionIHi (xTrackSectionI = &1795)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C4D)
 EQUB &F0               \ zTrackSectionIHi (zTrackSectionI = &F08E)
 EQUB &18               \ xTrackSectionOHi (xTrackSectionO = &1803)
 EQUB 40                \ trackSectionTurn
 EQUB &EF               \ zTrackSectionOHi (zTrackSectionO = &EF3F)
 EQUB 20                \ trackMaxSpeed

                        \ Track section 15

 EQUB &93               \ trackSection0a
 EQUB &11               \ xTrackSectionIHi (xTrackSectionI = &11D8)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C0D)
 EQUB &EB               \ zTrackSectionIHi (zTrackSectionI = &EBFA)
 EQUB &13               \ xTrackSectionOHi (xTrackSectionO = &1305)
 EQUB 255               \ trackSectionTurn
 EQUB &EB               \ zTrackSectionOHi (zTrackSectionO = &EB44)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 16

 EQUB &A2               \ trackSection0a
 EQUB &F1               \ xTrackSectionIHi (xTrackSectionI = &F126)
 EQUB &07               \ yTrackSectionIHi (yTrackSectionI = &07D5)
 EQUB &B5               \ zTrackSectionIHi (zTrackSectionI = &B5A9)
 EQUB &F2               \ xTrackSectionOHi (xTrackSectionO = &F253)
 EQUB 0                 \ trackSectionTurn
 EQUB &B4               \ zTrackSectionOHi (zTrackSectionO = &B4F3)
 EQUB 0                 \ trackMaxSpeed

                        \ Track section 17

 EQUB &B1               \ trackSection0a
 EQUB &EF               \ xTrackSectionIHi (xTrackSectionI = &EFB2)
 EQUB &07               \ yTrackSectionIHi (yTrackSectionI = &07F7)
 EQUB &B3               \ zTrackSectionIHi (zTrackSectionI = &B33F)
 EQUB &F0               \ xTrackSectionOHi (xTrackSectionO = &F0DF)
 EQUB 22                \ trackSectionTurn
 EQUB &B2               \ zTrackSectionOHi (zTrackSectionO = &B289)
 EQUB 139               \ trackMaxSpeed

                        \ Track section 18

 EQUB &B4               \ trackSection0a
 EQUB &E8               \ xTrackSectionIHi (xTrackSectionI = &E8EA)
 EQUB &09               \ yTrackSectionIHi (yTrackSectionI = &099B)
 EQUB &A7               \ zTrackSectionIHi (zTrackSectionI = &A7FB)
 EQUB &EA               \ xTrackSectionOHi (xTrackSectionO = &EA17)
 EQUB 52                \ trackSectionTurn
 EQUB &A7               \ zTrackSectionOHi (zTrackSectionO = &A745)
 EQUB 24                \ trackMaxSpeed

                        \ Track section 19

 EQUB &C3               \ trackSection0a
 EQUB &D8               \ xTrackSectionIHi (xTrackSectionI = &D849)
 EQUB &0A               \ yTrackSectionIHi (yTrackSectionI = &0A64)
 EQUB &A5               \ zTrackSectionIHi (zTrackSectionI = &A5A2)
 EQUB &D7               \ xTrackSectionOHi (xTrackSectionO = &D74A)
 EQUB 96                \ trackSectionTurn
 EQUB &A4               \ zTrackSectionOHi (zTrackSectionO = &A4AE)
 EQUB 151               \ trackMaxSpeed

                        \ Track section 20

 EQUB &D2               \ trackSection0a
 EQUB &B6               \ xTrackSectionIHi (xTrackSectionI = &B691)
 EQUB &07               \ yTrackSectionIHi (yTrackSectionI = &07F4)
 EQUB &C8               \ zTrackSectionIHi (zTrackSectionI = &C8FA)
 EQUB &B5               \ xTrackSectionOHi (xTrackSectionO = &B592)
 EQUB 49                \ trackSectionTurn
 EQUB &C8               \ zTrackSectionOHi (zTrackSectionO = &C806)
 EQUB 28                \ trackMaxSpeed

                        \ Track section 21

 EQUB &E2               \ trackSection0a
 EQUB &B6               \ xTrackSectionIHi (xTrackSectionI = &B603)
 EQUB &08               \ yTrackSectionIHi (yTrackSectionI = &083E)
 EQUB &D7               \ zTrackSectionIHi (zTrackSectionI = &D71E)
 EQUB &B4               \ xTrackSectionOHi (xTrackSectionO = &B4F2)
 EQUB 69                \ trackSectionTurn
 EQUB &D7               \ zTrackSectionOHi (zTrackSectionO = &D7FC)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 22

 EQUB &F2               \ trackSection0a
 EQUB &CF               \ xTrackSectionIHi (xTrackSectionI = &CF3F)
 EQUB &0B               \ yTrackSectionIHi (yTrackSectionI = &0B90)
 EQUB &F5               \ zTrackSectionIHi (zTrackSectionI = &F5FF)
 EQUB &CE               \ xTrackSectionOHi (xTrackSectionO = &CE2E)
 EQUB 36                \ trackSectionTurn
 EQUB &F6               \ zTrackSectionOHi (zTrackSectionO = &F6DD)
 EQUB 11                \ trackMaxSpeed

                        \ Track section 23

 EQUB &F2               \ trackSection0a
 EQUB &D1               \ xTrackSectionIHi (xTrackSectionI = &D1DE)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C7D)
 EQUB &FD               \ zTrackSectionIHi (zTrackSectionI = &FDD2)
 EQUB &D0               \ xTrackSectionOHi (xTrackSectionO = &D07E)
 EQUB 255               \ trackSectionTurn
 EQUB &FD               \ zTrackSectionOHi (zTrackSectionO = &FDC5)
 EQUB 255               \ trackMaxSpeed

                        \ Same as track section 0

 EQUB &03               \ trackSection0a
 EQUB &D1               \ xTrackSectionIHi (xTrackSectionI = &D120)
 EQUB &0C               \ yTrackSectionIHi (yTrackSectionI = &0C80)
 EQUB &0F               \ zTrackSectionIHi (zTrackSectionI = &0FA0)
 EQUB &CF               \ xTrackSectionOHi (xTrackSectionO = &CFC0)
 EQUB 96                \ trackSectionTurn
 EQUB &0F               \ zTrackSectionOHi (zTrackSectionO = &0F94)
 EQUB 136               \ trackMaxSpeed

 EQUB &00, &8E          \ These bytes appear to be unused
 EQUB &41, &40
 EQUB &00, &00
 EQUB &C9, &54

\ ******************************************************************************
\
\       Name: xTrackSignVector
\       Type: Variable
\   Category: Track
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ trackData+&0D0 = &53D0
\
\ ******************************************************************************

 EQUB &F6, &F8, &52, &B2, &07, &FC, &D9, &28
 EQUB &FB, &CD, &27, &17, &30, &FA, &D2, &00

\ ******************************************************************************
\
\       Name: zTrackSignVector
\       Type: Variable
\   Category: Track
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ trackData+&0E0 = &53E0
\
\ ******************************************************************************

 EQUB &6C, &04, &1B, &03, &08, &4B, &3F, &0E
 EQUB &FF, &B1, &35, &F0, &C5, &F0, &C7, &24

\ ******************************************************************************
\
\       Name: yTrackSignVector
\       Type: Variable
\   Category: Track
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ trackData+&0F0 = &53F0
\
\ ******************************************************************************

 EQUB &08, &08, &08, &08, &00, &12, &11, &08
 EQUB &08, &F0, &EC, &0C, &16, &04, &F0, &08

\ ******************************************************************************
\
\       Name: xTrackVectorI
\       Type: Variable
\   Category: Track
\    Summary: Vector x-coordinates between two consecutive points on the inside
\             of the track
\
\ ------------------------------------------------------------------------------
\
\ trackData+&100 = &5400
\ i.e. left-right on the screen
\
\ ******************************************************************************

 EQUB &FC, &FE, &02, &06, &0A, &0E, &12, &15
 EQUB &19, &1D, &21, &25, &28, &2C, &30, &33
 EQUB &3C, &4A, &57, &61, &6A, &71, &72, &6E
 EQUB &69, &63, &5C, &54, &4B, &42, &39, &2E
 EQUB &24, &19, &1C, &2E, &3F, &4F, &57, &5B
 EQUB &5E, &61, &64, &67, &69, &6C, &6E, &70
 EQUB &72, &73, &75, &76, &77, &77, &78, &78
 EQUB &78, &78, &77, &77, &75, &74, &72, &70
 EQUB &6D, &6A, &67, &63, &5F, &5B, &55, &4E
 EQUB &47, &3F, &37, &2E, &26, &1C, &13, &0A
 EQUB &05, &05, &05, &05, &05, &05, &05, &05
 EQUB &05, &05, &05, &07, &0B, &10, &14, &18
 EQUB &1C, &20, &24, &28, &2C, &30, &34, &38
 EQUB &3B, &3F, &43, &44, &49, &44, &3B, &31
 EQUB &26, &1B, &10, &05, &FA, &EF, &E6, &DF
 EQUB &D8, &D2, &CB, &C5, &BF, &B9, &B4, &AE
 EQUB &A9, &A5, &A0, &9C, &98, &95, &92, &8F
 EQUB &8E, &8F, &91, &93, &95, &98, &9B, &9D
 EQUB &A1, &A4, &A7, &AB, &AF, &B3, &B7, &BB
 EQUB &C0, &C2, &C2, &C2, &C2, &C2, &C2, &C2
 EQUB &C2, &BF, &BA, &B4, &AF, &AA, &A6, &A2
 EQUB &9D, &9A, &96, &94, &92, &91, &8F, &8E
 EQUB &8D, &8C, &8B, &8A, &89, &89, &88, &88
 EQUB &88, &88, &88, &88, &89, &89, &8A, &8A
 EQUB &8B, &8D, &90, &93, &96, &9B, &9F, &A5
 EQUB &AA, &AD, &AF, &B3, &B7, &BB, &C0, &C4
 EQUB &C9, &CE, &D2, &D7, &DC, &E1, &E6, &EC
 EQUB &F1, &F6, &FB, &01, &06, &0B, &10, &15
 EQUB &1B, &20, &25, &2A, &2F, &33, &38, &3D
 EQUB &41, &46, &4A, &4C, &4A, &46, &42, &3E
 EQUB &3A, &36, &31, &2D, &28, &24, &1F, &1A
 EQUB &16, &11, &0C, &08, &03, &FE, &FB, &00

\ ******************************************************************************
\
\       Name: yTrackVectorI
\       Type: Variable
\   Category: Track
\    Summary: Vector y-coordinates between two consecutive points on the inside
\             of the track
\
\ ------------------------------------------------------------------------------
\
\ trackData+&200 = &5500
\ i.e. up-down on the screen (track height)
\
\ ******************************************************************************

 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &01, &03
 EQUB &04, &05, &07, &08, &0A, &0B, &0C, &0E
 EQUB &0E, &0C, &0A, &08, &06, &04, &02, &00
 EQUB &FE, &FC, &FC, &FC, &FC, &FC, &FC, &FC
 EQUB &FC, &FC, &FC, &FC, &FC, &FC, &FC, &FC
 EQUB &FC, &FC, &FC, &FC, &FC, &FD, &FD, &FE
 EQUB &FE, &FE, &FF, &FF, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &FF, &FF, &FE, &FE, &FD, &FD
 EQUB &FC, &FC, &FB, &FB, &FA, &FA, &F9, &F9
 EQUB &F8, &F8, &FC, &00, &04, &08, &0B, &0F
 EQUB &0F, &0F, &0E, &0E, &0D, &0D, &0C, &0C
 EQUB &0B, &0B, &0A, &0A, &09, &09, &08, &08
 EQUB &07, &07, &06, &06, &05, &05, &05, &04
 EQUB &04, &03, &03, &02, &02, &01, &01, &00
 EQUB &00, &FF, &FE, &FE, &FD, &FC, &FB, &FA
 EQUB &FA, &FA, &FA, &FB, &FB, &FC, &FC, &FD
 EQUB &FD, &FE, &FE, &FF, &FF, &00, &00, &01
 EQUB &01, &02, &02, &03, &03, &04, &04, &05
 EQUB &05, &06, &06, &07, &07, &08, &08, &09
 EQUB &09, &0A, &0A, &0A, &0B, &0C, &0D, &0E
 EQUB &0E, &0F, &10, &11, &12, &12, &13, &14
 EQUB &11, &0D, &0A, &07, &03, &00, &00, &00

\ ******************************************************************************
\
\       Name: zTrackVectorI
\       Type: Variable
\   Category: Track
\    Summary: Vector z-coordinates between two consecutive points on the inside
\             of the track
\
\ ------------------------------------------------------------------------------
\
\ trackData+&300 = &5600
\ i.e. in-out of the screen
\
\ ******************************************************************************

 EQUB &78, &78, &78, &78, &78, &77, &77, &76
 EQUB &75, &74, &73, &72, &71, &70, &6E, &6D
 EQUB &68, &5E, &53, &46, &38, &29, &26, &31
 EQUB &3B, &44, &4D, &56, &5D, &64, &6A, &6F
 EQUB &73, &75, &74, &6F, &66, &5B, &52, &4E
 EQUB &4A, &46, &42, &3E, &39, &35, &30, &2B
 EQUB &26, &21, &1C, &17, &12, &0D, &08, &05
 EQUB &02, &FB, &F4, &EE, &E7, &E1, &DA, &D4
 EQUB &CE, &C8, &C2, &BC, &B7, &B2, &AC, &A5
 EQUB &9F, &9A, &95, &91, &8E, &8B, &8A, &88
 EQUB &88, &88, &88, &88, &88, &88, &88, &88
 EQUB &88, &88, &88, &88, &89, &89, &8A, &8A
 EQUB &8B, &8C, &8E, &8F, &90, &92, &94, &96
 EQUB &98, &9A, &9C, &9D, &A0, &9D, &97, &92
 EQUB &8E, &8B, &89, &88, &88, &89, &8B, &8D
 EQUB &8F, &91, &94, &97, &9B, &9F, &A3, &A8
 EQUB &AD, &B2, &B8, &BE, &C4, &CA, &D0, &D7
 EQUB &DA, &D8, &D3, &CE, &C9, &C4, &C0, &BC
 EQUB &B7, &B3, &AF, &AB, &A8, &A4, &A1, &9E
 EQUB &9B, &99, &99, &99, &99, &99, &99, &99
 EQUB &99, &9B, &9F, &A3, &A7, &AC, &B1, &B6
 EQUB &BC, &C1, &C7, &CC, &CF, &D3, &D7, &DA
 EQUB &DE, &E2, &E6, &E9, &ED, &F1, &F5, &F9
 EQUB &FD, &01, &05, &09, &0D, &11, &14, &18
 EQUB &1C, &22, &2A, &32, &39, &40, &47, &4E
 EQUB &54, &57, &58, &5C, &5F, &62, &65, &68
 EQUB &6B, &6D, &6F, &71, &73, &74, &75, &76
 EQUB &77, &78, &78, &78, &78, &77, &77, &76
 EQUB &75, &74, &72, &70, &6F, &6C, &6A, &67
 EQUB &65, &62, &5F, &5D, &5E, &61, &64, &67
 EQUB &69, &6B, &6D, &6F, &71, &73, &74, &75
 EQUB &76, &77, &77, &78, &78, &78, &78, &53

\ ******************************************************************************
\
\       Name: xTrackVectorO
\       Type: Variable
\   Category: Track
\    Summary: Vector x-coordinates from the inside to the outside of the track
\
\ ------------------------------------------------------------------------------
\
\ trackData+&400 = &5700
\ i.e. left-right on the screen
\
\ ******************************************************************************

 EQUB &A9, &A9, &A9, &A9, &A9, &A9, &AA, &AA
 EQUB &AB, &AB, &AC, &AD, &AE, &AF, &B0, &B2
 EQUB &B8, &BF, &C8, &D2, &DD, &E9, &E1, &D9
 EQUB &D2, &CB, &C5, &BF, &BA, &B5, &B1, &AE
 EQUB &AB, &AA, &AD, &B2, &BA, &C3, &C6, &C8
 EQUB &CB, &CE, &D2, &D5, &D8, &DC, &DF, &E3
 EQUB &E6, &EA, &EE, &F1, &F5, &F9, &FD, &FD
 EQUB &01, &06, &0A, &0F, &14, &19, &1E, &22
 EQUB &27, &2B, &2F, &33, &37, &3B, &40, &44
 EQUB &48, &4C, &4F, &52, &54, &56, &57, &57
 EQUB &57, &57, &57, &57, &57, &57, &57, &57
 EQUB &57, &57, &57, &57, &57, &57, &56, &55
 EQUB &55, &54, &53, &52, &51, &4F, &4E, &4D
 EQUB &4B, &4A, &48, &48, &46, &4A, &4E, &52
 EQUB &54, &56, &57, &57, &57, &56, &55, &53
 EQUB &52, &50, &4D, &4B, &48, &45, &42, &3E
 EQUB &3A, &36, &32, &2E, &29, &25, &20, &1B
 EQUB &1B, &1F, &22, &26, &29, &2D, &30, &33
 EQUB &36, &39, &3C, &3F, &42, &44, &47, &49
 EQUB &4B, &4B, &4B, &4B, &4B, &4B, &4B, &4B
 EQUB &4B, &48, &45, &42, &3F, &3B, &38, &34
 EQUB &30, &2B, &27, &24, &22, &1F, &1D, &1A
 EQUB &17, &14, &11, &0F, &0C, &09, &06, &03
 EQUB &00, &FE, &FC, &F9, &F6, &F3, &F0, &ED
 EQUB &EB, &E5, &DF, &D9, &D4, &CF, &CA, &C5
 EQUB &C1, &C1, &BE, &BC, &B9, &B7, &B5, &B3
 EQUB &B1, &B0, &AE, &AD, &AC, &AB, &AA, &A9
 EQUB &A9, &A9, &A9, &A9, &A9, &A9, &AA, &AA
 EQUB &AB, &AC, &AD, &AF, &B0, &B2, &B4, &B6
 EQUB &B8, &BA, &BC, &BC, &BA, &B8, &B6, &B4
 EQUB &B3, &B1, &B0, &AE, &AD, &AC, &AB, &AA
 EQUB &AA, &A9, &A9, &A9, &A9, &A9, &A9, &76

\ ******************************************************************************
\
\       Name: zTrackVectorO
\       Type: Variable
\   Category: Track
\    Summary: Vector z-coordinates from the inside to the outside of the track
\
\ ------------------------------------------------------------------------------
\
\ trackData+&500 = &5800
\ i.e. in-out of the screen
\
\ ******************************************************************************

 EQUB &FE, &00, &02, &05, &08, &0B, &0E, &11
 EQUB &13, &16, &19, &1C, &1E, &21, &24, &26
 EQUB &31, &3B, &43, &4A, &50, &54, &52, &4E
 EQUB &4A, &45, &40, &3A, &34, &2D, &25, &1E
 EQUB &16, &0E, &1B, &28, &34, &3E, &41, &43
 EQUB &46, &48, &4A, &4C, &4E, &4F, &51, &52
 EQUB &54, &55, &55, &56, &57, &57, &57, &57
 EQUB &57, &57, &57, &56, &55, &54, &52, &50
 EQUB &4E, &4C, &4A, &47, &44, &41, &3C, &36
 EQUB &31, &2B, &25, &1E, &18, &11, &0A, &03
 EQUB &03, &03, &03, &03, &03, &03, &03, &03
 EQUB &03, &03, &03, &06, &09, &0C, &0F, &13
 EQUB &16, &19, &1C, &1E, &21, &24, &27, &2A
 EQUB &2C, &2F, &32, &32, &35, &2E, &27, &1F
 EQUB &18, &10, &08, &00, &F8, &F0, &EB, &E6
 EQUB &E1, &DC, &D8, &D3, &CF, &CB, &C7, &C3
 EQUB &BF, &BC, &B9, &B6, &B3, &B1, &AF, &AD
 EQUB &AD, &AE, &B0, &B1, &B3, &B5, &B7, &B9
 EQUB &BC, &BE, &C1, &C4, &C6, &C9, &CD, &D0
 EQUB &D3, &D3, &D3, &D3, &D3, &D3, &D3, &D3
 EQUB &D3, &CF, &CB, &C7, &C3, &C0, &BD, &BA
 EQUB &B7, &B4, &B2, &B1, &AF, &AE, &AD, &AD
 EQUB &AC, &AB, &AA, &AA, &A9, &A9, &A9, &A9
 EQUB &A9, &A9, &A9, &A9, &A9, &AA, &AA, &AB
 EQUB &AB, &AD, &AF, &B2, &B5, &B8, &BB, &BF
 EQUB &C4, &C4, &C7, &C9, &CD, &D0, &D3, &D6
 EQUB &DA, &DD, &E1, &E4, &E8, &EC, &F0, &F3
 EQUB &F7, &FB, &FF, &02, &06, &0A, &0D, &11
 EQUB &15, &19, &1C, &20, &23, &27, &2A, &2E
 EQUB &31, &34, &37, &37, &34, &31, &2F, &2C
 EQUB &28, &25, &22, &1F, &1B, &18, &15, &11
 EQUB &0E, &0A, &07, &03, &00, &FD, &FD, &32

\ ******************************************************************************
\
\       Name: Track section data (low bytes)
\       Type: Variable
\   Category: Track
\    Summary: Data for the track sections
\
\ ------------------------------------------------------------------------------
\
\ .trackSectionFlag
\ trackData+&600 = &5900
\
\ .xTrackSectionILo
\ Low byte of the start x-coordinate of the inside verge of each track section
\ trackData+&601 = &5901
\
\ .yTrackSectionILo
\ Low byte of the start y-coordinate of the inside verge of each track section
\ trackData+&602 = &5902
\
\ .zTrackSectionILo
\ Low byte of the start z-coordinate of the inside verge of each track section
\ trackData+&603 = &5903
\
\ .xTrackSectionOLo
\ Low byte of the start x-coordinate of the outside verge of each track section
\ trackData+&604 = &5904
\
\ .trackSectionFrom
\ The number of the first track vector in each section
\ trackData+&605 = &5905
\
\ .zTrackSectionOLo
\ Low byte of the start z-coordinate of the outside verge of each track section
\ trackData+&606 = &5906
\
\ .trackSectionSize
\ The length of each track section in terms of progress in objProgressLo
\ trackData+&607 = &5907
\
\ ******************************************************************************

                        \ Track section 0

 EQUB %00110000         \ trackSectionFlag
 EQUB &20               \ xTrackSectionILo (xTrackSectionI = &D120)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80)
 EQUB &A0               \ zTrackSectionILo (zTrackSectionI = &0FA0)
 EQUB &C0               \ xTrackSectionOLo (xTrackSectionO = &CFC0)
 EQUB 0                 \ trackSectionFrom
 EQUB &94               \ zTrackSectionOLo (zTrackSectionO = &0F94)
 EQUB 99                \ trackSectionSize

                        \ Track section 1

 EQUB %10101101         \ trackSectionFlag
 EQUB &94               \ xTrackSectionILo (xTrackSectionI = &CF94)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80)
 EQUB &08               \ zTrackSectionILo (zTrackSectionI = &3E08)
 EQUB &34               \ xTrackSectionOLo (xTrackSectionO = &CE34)
 EQUB 1                 \ trackSectionFrom
 EQUB &FC               \ zTrackSectionOLo (zTrackSectionO = &3DFC)
 EQUB 21                \ trackSectionSize

                        \ Track section 2

 EQUB %00110011         \ trackSectionFlag
 EQUB &25               \ xTrackSectionILo (xTrackSectionI = &D325)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80)
 EQUB &96               \ zTrackSectionILo (zTrackSectionI = &4696)
 EQUB &C5               \ xTrackSectionOLo (xTrackSectionO = &D2C5)
 EQUB 22                \ trackSectionFrom
 EQUB &E8               \ zTrackSectionOLo (zTrackSectionO = &47E8)
 EQUB 12                \ trackSectionSize

                        \ Track section 3

 EQUB %00101101         \ trackSectionFlag
 EQUB &B2               \ xTrackSectionILo (xTrackSectionI = &D6B2)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80)
 EQUB &91               \ zTrackSectionILo (zTrackSectionI = &4A91)
 EQUB &56               \ xTrackSectionOLo (xTrackSectionO = &D556)
 EQUB 34                \ trackSectionFrom
 EQUB &C9               \ zTrackSectionOLo (zTrackSectionO = &4AC9)
 EQUB 21                \ trackSectionSize

                        \ Track section 4

 EQUB %00110010         \ trackSectionFlag
 EQUB &AF               \ xTrackSectionILo (xTrackSectionI = &DEAF)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80)
 EQUB &4F               \ zTrackSectionILo (zTrackSectionI = &4F4F)
 EQUB &9F               \ xTrackSectionOLo (xTrackSectionO = &DE9F)
 EQUB 55                \ trackSectionFrom
 EQUB &AE               \ zTrackSectionOLo (zTrackSectionO = &50AE)
 EQUB 105               \ trackSectionSize

                        \ Track section 5

 EQUB %10101101         \ trackSectionFlag
 EQUB &E7               \ xTrackSectionILo (xTrackSectionI = &0FE7)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80)
 EQUB &5C               \ zTrackSectionILo (zTrackSectionI = &515C)
 EQUB &D7               \ xTrackSectionOLo (xTrackSectionO = &0FD7)
 EQUB 56                \ trackSectionFrom
 EQUB &BB               \ zTrackSectionOLo (zTrackSectionO = &52BB)
 EQUB 24                \ trackSectionSize

                        \ Track section 6

 EQUB %00000010         \ trackSectionFlag
 EQUB &D8               \ xTrackSectionILo (xTrackSectionI = &17D8)
 EQUB &CB               \ yTrackSectionILo (yTrackSectionI = &0CCB)
 EQUB &09               \ zTrackSectionILo (zTrackSectionI = &4B09)
 EQUB &37               \ xTrackSectionOLo (xTrackSectionO = &1937)
 EQUB 80                \ trackSectionFrom
 EQUB &17               \ zTrackSectionOLo (zTrackSectionO = &4B17)
 EQUB 28                \ trackSectionSize

                        \ Track section 7

 EQUB %00000001         \ trackSectionFlag
 EQUB &64               \ xTrackSectionILo (xTrackSectionI = &1864)
 EQUB &53               \ yTrackSectionILo (yTrackSectionI = &0E53)
 EQUB &E9               \ zTrackSectionILo (zTrackSectionI = &3DE9)
 EQUB &C3               \ xTrackSectionOLo (xTrackSectionO = &19C3)
 EQUB 81                \ trackSectionFrom
 EQUB &F7               \ zTrackSectionOLo (zTrackSectionO = &3DF7)
 EQUB 9                 \ trackSectionSize

                        \ Track section 8

 EQUB %00101000         \ trackSectionFlag
 EQUB &91               \ xTrackSectionILo (xTrackSectionI = &1891)
 EQUB &77               \ yTrackSectionILo (yTrackSectionI = &0E77)
 EQUB &B1               \ zTrackSectionILo (zTrackSectionI = &39B1)
 EQUB &F0               \ xTrackSectionOLo (xTrackSectionO = &19F0)
 EQUB 90                \ trackSectionFrom
 EQUB &BF               \ zTrackSectionOLo (zTrackSectionO = &39BF)
 EQUB 54                \ trackSectionSize

                        \ Track section 9

 EQUB %00110011         \ trackSectionFlag
 EQUB &9F               \ xTrackSectionILo (xTrackSectionI = &199F)
 EQUB &9F               \ yTrackSectionILo (yTrackSectionI = &0D9F)
 EQUB &61               \ zTrackSectionILo (zTrackSectionI = &2061)
 EQUB &FE               \ xTrackSectionOLo (xTrackSectionO = &1AFE)
 EQUB 91                \ trackSectionFrom
 EQUB &6F               \ zTrackSectionOLo (zTrackSectionO = &206F)
 EQUB 16                \ trackSectionSize

                        \ Track section 10

 EQUB %00000000         \ trackSectionFlag
 EQUB &FA               \ xTrackSectionILo (xTrackSectionI = &1BFA)
 EQUB &5F               \ yTrackSectionILo (yTrackSectionI = &0D5F)
 EQUB &5D               \ zTrackSectionILo (zTrackSectionI = &195D)
 EQUB &1B               \ xTrackSectionOLo (xTrackSectionO = &1D1B)
 EQUB 107               \ trackSectionFrom
 EQUB &25               \ zTrackSectionOLo (zTrackSectionO = &1A25)
 EQUB 38                \ trackSectionSize

                        \ Track section 11

 EQUB %00110000         \ trackSectionFlag
 EQUB &12               \ xTrackSectionILo (xTrackSectionI = &2612)
 EQUB &C7               \ yTrackSectionILo (yTrackSectionI = &0CC7)
 EQUB &AB               \ zTrackSectionILo (zTrackSectionI = &0AAB)
 EQUB &33               \ xTrackSectionOLo (xTrackSectionO = &2733)
 EQUB 108               \ trackSectionFrom
 EQUB &73               \ zTrackSectionOLo (zTrackSectionO = &0B73)
 EQUB 27                \ trackSectionSize

                        \ Track section 12

 EQUB %10101101         \ trackSectionFlag
 EQUB &C5               \ xTrackSectionILo (xTrackSectionI = &2DC5)
 EQUB &5B               \ yTrackSectionILo (yTrackSectionI = &0C5B)
 EQUB &8B               \ zTrackSectionILo (zTrackSectionI = &008B)
 EQUB &DD               \ xTrackSectionOLo (xTrackSectionO = &2EDD)
 EQUB 109               \ trackSectionFrom
 EQUB &5F               \ zTrackSectionOLo (zTrackSectionO = &015F)
 EQUB 27                \ trackSectionSize

                        \ Track section 13

 EQUB %00101010         \ trackSectionFlag
 EQUB &65               \ xTrackSectionILo (xTrackSectionI = &2965)
 EQUB &4D               \ yTrackSectionILo (yTrackSectionI = &0C4D)
 EQUB &7E               \ zTrackSectionILo (zTrackSectionI = &F67E)
 EQUB &D3               \ xTrackSectionOLo (xTrackSectionO = &29D3)
 EQUB 136               \ trackSectionFrom
 EQUB &2F               \ zTrackSectionOLo (zTrackSectionO = &F52F)
 EQUB 40                \ trackSectionSize

                        \ Track section 14

 EQUB %00110011         \ trackSectionFlag
 EQUB &95               \ xTrackSectionILo (xTrackSectionI = &1795)
 EQUB &4D               \ yTrackSectionILo (yTrackSectionI = &0C4D)
 EQUB &8E               \ zTrackSectionILo (zTrackSectionI = &F08E)
 EQUB &03               \ xTrackSectionOLo (xTrackSectionO = &1803)
 EQUB 137               \ trackSectionFrom
 EQUB &3F               \ zTrackSectionOLo (zTrackSectionO = &EF3F)
 EQUB 16                \ trackSectionSize

                        \ Track section 15

 EQUB %00000000         \ trackSectionFlag
 EQUB &D8               \ xTrackSectionILo (xTrackSectionI = &11D8)
 EQUB &0D               \ yTrackSectionILo (yTrackSectionI = &0C0D)
 EQUB &FA               \ zTrackSectionILo (zTrackSectionI = &EBFA)
 EQUB &05               \ xTrackSectionOLo (xTrackSectionO = &1305)
 EQUB 153               \ trackSectionFrom
 EQUB &44               \ zTrackSectionOLo (zTrackSectionO = &EB44)
 EQUB 135               \ trackSectionSize

                        \ Track section 16

 EQUB %00000001         \ trackSectionFlag
 EQUB &26               \ xTrackSectionILo (xTrackSectionI = &F126)
 EQUB &D5               \ yTrackSectionILo (yTrackSectionI = &07D5)
 EQUB &A9               \ zTrackSectionILo (zTrackSectionI = &B5A9)
 EQUB &53               \ xTrackSectionOLo (xTrackSectionO = &F253)
 EQUB 154               \ trackSectionFrom
 EQUB &F3               \ zTrackSectionOLo (zTrackSectionO = &B4F3)
 EQUB 6                 \ trackSectionSize

                        \ Track section 17

 EQUB %00110000         \ trackSectionFlag
 EQUB &B2               \ xTrackSectionILo (xTrackSectionI = &EFB2)
 EQUB &F7               \ yTrackSectionILo (yTrackSectionI = &07F7)
 EQUB &3F               \ zTrackSectionILo (zTrackSectionI = &B33F)
 EQUB &DF               \ xTrackSectionOLo (xTrackSectionO = &F0DF)
 EQUB 160               \ trackSectionFrom
 EQUB &89               \ zTrackSectionOLo (zTrackSectionO = &B289)
 EQUB 28                \ trackSectionSize

                        \ Track section 18

 EQUB %10101101         \ trackSectionFlag
 EQUB &EA               \ xTrackSectionILo (xTrackSectionI = &E8EA)
 EQUB &9B               \ yTrackSectionILo (yTrackSectionI = &099B)
 EQUB &FB               \ zTrackSectionILo (zTrackSectionI = &A7FB)
 EQUB &17               \ xTrackSectionOLo (xTrackSectionO = &EA17)
 EQUB 161               \ trackSectionFrom
 EQUB &45               \ zTrackSectionOLo (zTrackSectionO = &A745)
 EQUB 40                \ trackSectionSize

                        \ Track section 19

 EQUB %00110010         \ trackSectionFlag
 EQUB &49               \ xTrackSectionILo (xTrackSectionI = &D849)
 EQUB &64               \ yTrackSectionILo (yTrackSectionI = &0A64)
 EQUB &A2               \ zTrackSectionILo (zTrackSectionI = &A5A2)
 EQUB &4A               \ xTrackSectionOLo (xTrackSectionO = &D74A)
 EQUB 201               \ trackSectionFrom
 EQUB &AE               \ zTrackSectionOLo (zTrackSectionO = &A4AE)
 EQUB 104               \ trackSectionSize

                        \ Track section 20

 EQUB %10101101         \ trackSectionFlag
 EQUB &91               \ xTrackSectionILo (xTrackSectionI = &B691)
 EQUB &F4               \ yTrackSectionILo (yTrackSectionI = &07F4)
 EQUB &FA               \ zTrackSectionILo (zTrackSectionI = &C8FA)
 EQUB &92               \ xTrackSectionOLo (xTrackSectionO = &B592)
 EQUB 202               \ trackSectionFrom
 EQUB &06               \ zTrackSectionOLo (zTrackSectionO = &C806)
 EQUB 33                \ trackSectionSize

                        \ Track section 21

 EQUB %00101010         \ trackSectionFlag
 EQUB &03               \ xTrackSectionILo (xTrackSectionI = &B603)
 EQUB &3E               \ yTrackSectionILo (yTrackSectionI = &083E)
 EQUB &1E               \ zTrackSectionILo (zTrackSectionI = &D71E)
 EQUB &F2               \ xTrackSectionOLo (xTrackSectionO = &B4F2)
 EQUB 235               \ trackSectionFrom
 EQUB &FC               \ zTrackSectionOLo (zTrackSectionO = &D7FC)
 EQUB 85                \ trackSectionSize

                        \ Track section 22

 EQUB %00110011         \ trackSectionFlag
 EQUB &3F               \ xTrackSectionILo (xTrackSectionI = &CF3F)
 EQUB &90               \ yTrackSectionILo (yTrackSectionI = &0B90)
 EQUB &FF               \ zTrackSectionILo (zTrackSectionI = &F5FF)
 EQUB &2E               \ xTrackSectionOLo (xTrackSectionO = &CE2E)
 EQUB 236               \ trackSectionFrom
 EQUB &DD               \ zTrackSectionOLo (zTrackSectionO = &F6DD)
 EQUB 18                \ trackSectionSize

                        \ Track section 23

 EQUB %00000100         \ trackSectionFlag
 EQUB &DE               \ xTrackSectionILo (xTrackSectionI = &D1DE)
 EQUB &7D               \ yTrackSectionILo (yTrackSectionI = &0C7D)
 EQUB &D2               \ zTrackSectionILo (zTrackSectionI = &FDD2)
 EQUB &7E               \ xTrackSectionOLo (xTrackSectionO = &D07E)
 EQUB 254               \ trackSectionFrom
 EQUB &C5               \ zTrackSectionOLo (zTrackSectionO = &FDC5)
 EQUB 38                \ trackSectionSize

                        \ Same as track section 0

 EQUB %00110000         \ trackSectionFlag
 EQUB &20               \ xTrackSectionILo (xTrackSectionI = &D120)
 EQUB &80               \ yTrackSectionILo (yTrackSectionI = &0C80)
 EQUB &A0               \ zTrackSectionILo (zTrackSectionI = &0FA0)
 EQUB &C0               \ xTrackSectionOLo (xTrackSectionO = &CFC0)
 EQUB 0                 \ trackSectionFrom
 EQUB &94               \ zTrackSectionOLo (zTrackSectionO = &0F94)
 EQUB 99                \ trackSectionSize

 EQUB &64, &F0          \ These bytes appear to be unused
 EQUB &00, &00
 EQUB &48, &00
 EQUB &50, &52

\ ******************************************************************************
\
\       Name: trackSteering
\       Type: Variable
\   Category: Track
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ trackData+&6D0 = &59D0
\
\ These 24 bytes are copied to L5FB0, one per track section
\ Bit 0 -> bit 7 of result
\ Bit 1 clear -> result is scaled by U
\ See sub_C44C6
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
\       Name: trackRoadSigns
\       Type: Variable
\   Category: Track
\    Summary: Track sections and object types for 16 road signs
\
\ ------------------------------------------------------------------------------
\
\ trackData+&6EA = &59EA
\ Track sections and object types for 16 road signs
\ Bits 0-2 = Object type of road sign (add 7 to get the type)
\ Bits 3-7 = Index into track data at trackData+&001, trackData+&601
\            Track section
\ Road sign at track section 23 is the sign we see at start of practice
\
\ ******************************************************************************

 EQUB %00000011         \ 00000 011    Type 10    Chicane       Track section  0
 EQUB %00010000         \ 00010 000    Type  7    Straight      Track section  2
 EQUB %00011001         \ 00011 001    Type  8    Start flag    Track section  3
 EQUB %00101100         \ 00101 100    Type 11    Right turn    Track section  5
 EQUB %00111000         \ 00111 000    Type  7    Straight      Track section  7
 EQUB %01001101         \ 01001 101    Type 12    Left turn     Track section  9
 EQUB %01100100         \ 01100 100    Type 11    Right turn    Track section 12
 EQUB %01110101         \ 01110 101    Type 12    Left turn     Track section 14
 EQUB %01110000         \ 01110 000    Type  7    Straight      Track section 14
 EQUB %01110000         \ 01110 000    Type  7    Straight      Track section 14
 EQUB %10010100         \ 10010 100    Type 11    Right turn    Track section 18
 EQUB %10011000         \ 10011 000    Type  7    Straight      Track section 19
 EQUB %10100100         \ 10100 100    Type 11    Right turn    Track section 20
 EQUB %10101000         \ 10101 000    Type  7    Straight      Track section 21
 EQUB %10110101         \ 10110 101    Type 12    Left turn     Track section 22
 EQUB %10111000         \ 10111 000    Type  7    Straight      Track section 23

\ ******************************************************************************
\
\       Name: trackSectionCount
\       Type: Variable
\   Category: Track
\    Summary: The number of track sections * 8
\
\ ------------------------------------------------------------------------------
\
\ trackData+&6FA = &59FA
\ The number of bytes at trackData+&6D0 (24) that we copy to L5FB0
\
\ ******************************************************************************

 EQUB 24 * 8

\ ******************************************************************************
\
\       Name: trackVectorCount
\       Type: Variable
\   Category: Track
\    Summary: The number of track vectors in the trackVector tables
\
\ ------------------------------------------------------------------------------
\
\ trackData+&6FB = &59FB
\
\ ******************************************************************************

 EQUB 255

\ ******************************************************************************
\
\       Name: trackLengthLo
\       Type: Variable
\   Category: Track
\    Summary: Low byte of length of full track (in terms of progress)
\
\ ------------------------------------------------------------------------------
\
\ trackData(&6FD &6FC) = (&59FD &59FC)
\ Length of full track (in terms of progress)
\ carProgress wraps round to 0 when it reaches this figure
\
\ ******************************************************************************

 EQUB &00               \ (trackLengthHi trackLengthLo) = &0400

\ ******************************************************************************
\
\       Name: trackLengthHi
\       Type: Variable
\   Category: Track
\    Summary: High byte of length of full track (in terms of progress)
\
\ ------------------------------------------------------------------------------
\
\ trackData(&6FD &6FC) = (&59FD &59FC)
\ Length of full track (in terms of progress)
\ carProgress wraps round to 0 when it reaches this figure
\
\ ******************************************************************************

 EQUB &04               \ (trackLengthHi trackLengthLo) = &0400

\ ******************************************************************************
\
\       Name: trackStartLo
\       Type: Variable
\   Category: Track
\    Summary: Low byte of starting point for practice laps (in terms of
\             progress)
\
\ ------------------------------------------------------------------------------
\
\ trackData(&6FE &6FF) = (&59FF &59FE)
\ 24 bytes in (carProgressHi carProgressLo) are initialised to &034B
\
\ ******************************************************************************

 EQUB &4B               \ (trackStartHi trackStartLo) = &034B

\ ******************************************************************************
\
\       Name: trackStartHi
\       Type: Variable
\   Category: Track
\    Summary: High byte of starting point for practice laps (in terms of
\             progress)
\
\ ------------------------------------------------------------------------------
\
\ trackData(&6FE &6FF) = (&59FF &59FE)
\ 24 bytes in (carProgressHi carProgressLo) are initialised to &034B
\
\ ******************************************************************************

 EQUB &03              \ (trackStartHi trackStartLo) = &034B

\ ******************************************************************************
\
\       Name: trackLapTimeSec
\       Type: Variable
\   Category: Track
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ .trackLapTimeSec
\ trackData+&700 = &5A00
\ Race class adjuster: seconds
\ See MainLoop (Part 4 of 6)
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we set the race class to the relevant difficulty
\
\ ******************************************************************************

 EQUB 51                \ Set class to Novice if slowest lap time > 1:51
 EQUB 41                \ Set class to Amateur if slowest lap time > 1:41
 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackLapTimeMin
\       Type: Variable
\   Category: Track
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ trackData+&703 = &5A03
\ See MainLoop (Part 4 of 6)
\ Race class adjuster: minutes
\
\ ******************************************************************************

 EQUB 1                 \ Set class to Novice if slowest lap time > 1:51
 EQUB 1                 \ Set class to Amateur if slowest lap time > 1:41
 EQUB 0                 \ Otherwise set class to Professional

\ ******************************************************************************
\
\       Name: trackGearRatio
\       Type: Variable
\   Category: Track
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ trackData+&706 = &5A06
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
\   Category: Track
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ trackData+&70D = &5A0D
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
\   Category: Track
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ trackData+&714 = &5A14
\
\ ******************************************************************************

 EQUB 134               \ Base speed for Novice
 EQUB 146               \ Base speed for Amateur
 EQUB 152               \ Base speed for Professional

\ ******************************************************************************
\
\       Name: trackLapStart
\       Type: Variable
\   Category: Track
\    Summary: The starting position of the player during a practice or
\             qualifying lap
\
\ ------------------------------------------------------------------------------
\
\ trackData+&717 = &5A17
\
\ ******************************************************************************

 EQUB 4

\ ******************************************************************************
\
\       Name: trackCarSpacing
\       Type: Variable
\   Category: Track
\    Summary: The spacing between cars at the start of a qualifying lap
\
\ ------------------------------------------------------------------------------
\
\ trackData+&718 = &5A18
\ Passed to sub_C109B in A by ResetVariables for a practice or qualifying lap
\
\ ******************************************************************************

 EQUB 40

\ ******************************************************************************
\
\       Name: trackTimerAdjust
\       Type: Variable
\   Category: Track
\    Summary: Adjust the speed of the timers to allow for fine-tuning on a
\             per-track basis
\
\ ------------------------------------------------------------------------------
\
\ trackData+&719 = &5A19
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
\   Category: Track
\    Summary: Slowdown factor for non-player cars in the race
\
\ ------------------------------------------------------------------------------
\
\ trackData+&71A = &5A1A
\
\ Reduce the speed of all cars in a race by this amount (this does not affect
\ the speed during qualifying)
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
\   Category: Track
\    Summary: The track file's hook code
\
\ ------------------------------------------------------------------------------
\
\ 
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
\   Category: Track
\    Summary: The track file's checksum
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.trackChecksum

 EQUB &49               \ Checksum bytes:
 EQUB &8B               \
 EQUB &8A               \   * trackChecksum+0 counts the number of data bytes
 EQUB &C7               \     ending in %00
                        \
                        \   * trackChecksum+1 counts the number of data bytes
                        \     ending in %01
                        \
                        \   * trackChecksum+2 counts the number of data bytes
                        \     ending in %10
                        \
                        \   * trackChecksum+3 counts the number of data bytes
                        \     ending in %11

 EQUS "REVS"            \ Game name

 EQUS "Silverstone"     \ Track name
 EQUB 13

\ ******************************************************************************
\
\ Save Silverstone.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/Silverstone.bin", CODE%, P%

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

\ Section                [road signs]   Description                       Size
\
\ Track section  0   ||  [chicane]      Abbey Curve to Woodcote Corner      99
\ Track section  1   ~~                 Woodcote Corner                     21
\ Track section  2   ~~  [straight]     Woodcote Corner                     12
\ Track section  3   ||  [start]        Home straight                       21
\ Track section  4   ||                 Home straight                      105
\ Track section  5   ||  [right]        Approach to Copse Corner            24
\ Track section  6   ->                 Copse Corner                        28
\ Track section  7   ||  [straight]     Out of Copse Corner                  9
\ Track section  8   ||                 Copse Corner to Maggotts Curve      54
\ Track section  9   ||  [left]         Approach to Maggotts Curve          16
\ Track section 10   <-                 Maggotts Curve                      38
\ Track section 11   ||                 Maggotts Curve to Becketts Corner   27
\ Track section 12   ->  [right]        Becketts Corner                     27
\ Track section 13   ||                 Becketts Corner to Chapel Curve     40
\ Track section 14   <-  [left, st, st] Chapel Curve                        16
\ Track section 15   ||                 Hangar Straight                    135
\ Track section 16   ||                 Hangar Straight                      6
\ Track section 17   ||                 Approach to Stowe Corner            28
\ Track section 18   ->  [right]        Stowe Corner                        40
\ Track section 19   ||  [straight]     Stowe Corner to Club Corner        104
\ Track section 20   ->  [right]        Club Corner                         33
\ Track section 21   ||  [straight]     Club Corner to Abbey Curve          85
\ Track section 22   <-  [left]         Abbey Curve                         18
\ Track section 23   ||  [straight]     Abbey Curve to Woodcote Corner      38

.trackData

\ .trackSection0a
\ trackData      = &5300
\ Bits 4-7 of trackData+0 (i.e. first digit in hex value) is an index into
\ trackData+&0D0, trackData+&0E0, trackData+&0F0

\ .trackSection1Hi
\ trackData+&001 = &5301

\ .trackSection2Hi
\ trackData+&002 = &5302

\ .trackSection3Hi
\ trackData+&003 = &5303

\ .trackSection4Hi
\ trackData+&004 = &5304

\ .trackSection5a
\ trackData+&005 = &5305

\ .trackSection6Hi
\ trackData+&006 = &5306

\ .trackMaxSpeed
\ trackData+&007 = &5307

                        \ Track section 0

 EQUB &03               \ trackSection0a
 EQUB &D1               \ trackSection1Hi (trackSection1 = &D120)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0C80)
 EQUB &0F               \ trackSection3Hi (trackSection3 = &0FA0)
 EQUB &CF               \ trackSection4Hi (trackSection4 = &CFC0)
 EQUB 96                \ trackSection5a
 EQUB &0F               \ trackSection6Hi (trackSection6 = &0F94)
 EQUB 136               \ trackMaxSpeed

                        \ Track section 1

 EQUB &13               \ trackSection0a
 EQUB &CF               \ trackSection1Hi (trackSection1 = &CF94)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0C80)
 EQUB &3E               \ trackSection3Hi (trackSection3 = &3E08)
 EQUB &CE               \ trackSection4Hi (trackSection4 = &CE34)
 EQUB 18                \ trackSection5a
 EQUB &3D               \ trackSection6Hi (trackSection6 = &3DFC)
 EQUB 0                 \ trackMaxSpeed

                        \ Track section 2

 EQUB &12               \ trackSection0a
 EQUB &D3               \ trackSection1Hi (trackSection1 = &D325)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0C80)
 EQUB &46               \ trackSection3Hi (trackSection3 = &4696)
 EQUB &D2               \ trackSection4Hi (trackSection4 = &D2C5)
 EQUB 20                \ trackSection5a
 EQUB &47               \ trackSection6Hi (trackSection6 = &47E8)
 EQUB 138               \ trackMaxSpeed

                        \ Track section 3

 EQUB &22               \ trackSection0a
 EQUB &D6               \ trackSection1Hi (trackSection1 = &D6B2)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0C80)
 EQUB &4A               \ trackSection3Hi (trackSection3 = &4A91)
 EQUB &D5               \ trackSection4Hi (trackSection4 = &D556)
 EQUB 30                \ trackSection5a
 EQUB &4A               \ trackSection6Hi (trackSection6 = &4AC9)
 EQUB 33                \ trackMaxSpeed

                        \ Track section 4

 EQUB &22               \ trackSection0a
 EQUB &DE               \ trackSection1Hi (trackSection1 = &DEAF)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0C80)
 EQUB &4F               \ trackSection3Hi (trackSection3 = &4F4F)
 EQUB &DE               \ trackSection4Hi (trackSection4 = &DE9F)
 EQUB 98                \ trackSection5a
 EQUB &50               \ trackSection6Hi (trackSection6 = &50AE)
 EQUB 125               \ trackMaxSpeed

                        \ Track section 5

 EQUB &33               \ trackSection0a
 EQUB &0F               \ trackSection1Hi (trackSection1 = &0FE7)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0C80)
 EQUB &51               \ trackSection3Hi (trackSection3 = &515C)
 EQUB &0F               \ trackSection4Hi (trackSection4 = &0FD7)
 EQUB 40                \ trackSection5a
 EQUB &52               \ trackSection6Hi (trackSection6 = &52BB)
 EQUB 26                \ trackMaxSpeed

                        \ Track section 6

 EQUB &42               \ trackSection0a
 EQUB &17               \ trackSection1Hi (trackSection1 = &17D8)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0CCB)
 EQUB &4B               \ trackSection3Hi (trackSection3 = &4B09)
 EQUB &19               \ trackSection4Hi (trackSection4 = &1937)
 EQUB 255               \ trackSection5a
 EQUB &4B               \ trackSection6Hi (trackSection6 = &4B17)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 7

 EQUB &53               \ trackSection0a
 EQUB &18               \ trackSection1Hi (trackSection1 = &1864)
 EQUB &0E               \ trackSection2Hi (trackSection2 = &0E53)
 EQUB &3D               \ trackSection3Hi (trackSection3 = &3DE9)
 EQUB &19               \ trackSection4Hi (trackSection4 = &19C3)
 EQUB 0                 \ trackSection5a
 EQUB &3D               \ trackSection6Hi (trackSection6 = &3DF7)
 EQUB 0                 \ trackMaxSpeed

                        \ Track section 8

 EQUB &53               \ trackSection0a
 EQUB &18               \ trackSection1Hi (trackSection1 = &1891)
 EQUB &0E               \ trackSection2Hi (trackSection2 = &0E77)
 EQUB &39               \ trackSection3Hi (trackSection3 = &39B1)
 EQUB &19               \ trackSection4Hi (trackSection4 = &19F0)
 EQUB 33                \ trackSection5a
 EQUB &39               \ trackSection6Hi (trackSection6 = &39BF)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 9

 EQUB &64               \ trackSection0a
 EQUB &19               \ trackSection1Hi (trackSection1 = &199F)
 EQUB &0D               \ trackSection2Hi (trackSection2 = &0D9F)
 EQUB &20               \ trackSection3Hi (trackSection3 = &2061)
 EQUB &1A               \ trackSection4Hi (trackSection4 = &1AFE)
 EQUB 40                \ trackSection5a
 EQUB &20               \ trackSection6Hi (trackSection6 = &206F)
 EQUB 12                \ trackMaxSpeed

                        \ Track section 10

 EQUB &64               \ trackSection0a
 EQUB &1B               \ trackSection1Hi (trackSection1 = &1BFA)
 EQUB &0D               \ trackSection2Hi (trackSection2 = &0D5F)
 EQUB &19               \ trackSection3Hi (trackSection3 = &195D)
 EQUB &1D               \ trackSection4Hi (trackSection4 = &1D1B)
 EQUB 255               \ trackSection5a
 EQUB &1A               \ trackSection6Hi (trackSection6 = &1A25)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 11

 EQUB &73               \ trackSection0a
 EQUB &26               \ trackSection1Hi (trackSection1 = &2612)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0CC7)
 EQUB &0A               \ trackSection3Hi (trackSection3 = &0AAB)
 EQUB &27               \ trackSection4Hi (trackSection4 = &2733)
 EQUB 21                \ trackSection5a
 EQUB &0B               \ trackSection6Hi (trackSection6 = &0B73)
 EQUB 116               \ trackMaxSpeed

                        \ Track section 12

 EQUB &72               \ trackSection0a
 EQUB &2D               \ trackSection1Hi (trackSection1 = &2DC5)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0C5B)
 EQUB &00               \ trackSection3Hi (trackSection3 = &008B)
 EQUB &2E               \ trackSection4Hi (trackSection4 = &2EDD)
 EQUB 39                \ trackSection5a
 EQUB &01               \ trackSection6Hi (trackSection6 = &015F)
 EQUB 25                \ trackMaxSpeed

                        \ Track section 13

 EQUB &72               \ trackSection0a
 EQUB &29               \ trackSection1Hi (trackSection1 = &2965)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0C4D)
 EQUB &F6               \ trackSection3Hi (trackSection3 = &F67E)
 EQUB &29               \ trackSection4Hi (trackSection4 = &29D3)
 EQUB 24                \ trackSection5a
 EQUB &F5               \ trackSection6Hi (trackSection6 = &F52F)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 14

 EQUB &84               \ trackSection0a
 EQUB &17               \ trackSection1Hi (trackSection1 = &1795)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0C4D)
 EQUB &F0               \ trackSection3Hi (trackSection3 = &F08E)
 EQUB &18               \ trackSection4Hi (trackSection4 = &1803)
 EQUB 40                \ trackSection5a
 EQUB &EF               \ trackSection6Hi (trackSection6 = &EF3F)
 EQUB 20                \ trackMaxSpeed

                        \ Track section 15

 EQUB &93               \ trackSection0a
 EQUB &11               \ trackSection1Hi (trackSection1 = &11D8)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0C0D)
 EQUB &EB               \ trackSection3Hi (trackSection3 = &EBFA)
 EQUB &13               \ trackSection4Hi (trackSection4 = &1305)
 EQUB 255               \ trackSection5a
 EQUB &EB               \ trackSection6Hi (trackSection6 = &EB44)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 16

 EQUB &A2               \ trackSection0a
 EQUB &F1               \ trackSection1Hi (trackSection1 = &F126)
 EQUB &07               \ trackSection2Hi (trackSection2 = &07D5)
 EQUB &B5               \ trackSection3Hi (trackSection3 = &B5A9)
 EQUB &F2               \ trackSection4Hi (trackSection4 = &F253)
 EQUB 0                 \ trackSection5a
 EQUB &B4               \ trackSection6Hi (trackSection6 = &B4F3)
 EQUB 0                 \ trackMaxSpeed

                        \ Track section 17

 EQUB &B1               \ trackSection0a
 EQUB &EF               \ trackSection1Hi (trackSection1 = &EFB2)
 EQUB &07               \ trackSection2Hi (trackSection2 = &07F7)
 EQUB &B3               \ trackSection3Hi (trackSection3 = &B33F)
 EQUB &F0               \ trackSection4Hi (trackSection4 = &F0DF)
 EQUB 22                \ trackSection5a
 EQUB &B2               \ trackSection6Hi (trackSection6 = &B289)
 EQUB 139               \ trackMaxSpeed

                        \ Track section 18

 EQUB &B4               \ trackSection0a
 EQUB &E8               \ trackSection1Hi (trackSection1 = &E8EA)
 EQUB &09               \ trackSection2Hi (trackSection2 = &099B)
 EQUB &A7               \ trackSection3Hi (trackSection3 = &A7FB)
 EQUB &EA               \ trackSection4Hi (trackSection4 = &EA17)
 EQUB 52                \ trackSection5a
 EQUB &A7               \ trackSection6Hi (trackSection6 = &A745)
 EQUB 24                \ trackMaxSpeed

                        \ Track section 19

 EQUB &C3               \ trackSection0a
 EQUB &D8               \ trackSection1Hi (trackSection1 = &D849)
 EQUB &0A               \ trackSection2Hi (trackSection2 = &0A64)
 EQUB &A5               \ trackSection3Hi (trackSection3 = &A5A2)
 EQUB &D7               \ trackSection4Hi (trackSection4 = &D74A)
 EQUB 96                \ trackSection5a
 EQUB &A4               \ trackSection6Hi (trackSection6 = &A4AE)
 EQUB 151               \ trackMaxSpeed

                        \ Track section 20

 EQUB &D2               \ trackSection0a
 EQUB &B6               \ trackSection1Hi (trackSection1 = &B691)
 EQUB &07               \ trackSection2Hi (trackSection2 = &07F4)
 EQUB &C8               \ trackSection3Hi (trackSection3 = &C8FA)
 EQUB &B5               \ trackSection4Hi (trackSection4 = &B592)
 EQUB 49                \ trackSection5a
 EQUB &C8               \ trackSection6Hi (trackSection6 = &C806)
 EQUB 28                \ trackMaxSpeed

                        \ Track section 21

 EQUB &E2               \ trackSection0a
 EQUB &B6               \ trackSection1Hi (trackSection1 = &B603)
 EQUB &08               \ trackSection2Hi (trackSection2 = &083E)
 EQUB &D7               \ trackSection3Hi (trackSection3 = &D71E)
 EQUB &B4               \ trackSection4Hi (trackSection4 = &B4F2)
 EQUB 69                \ trackSection5a
 EQUB &D7               \ trackSection6Hi (trackSection6 = &D7FC)
 EQUB 255               \ trackMaxSpeed

                        \ Track section 22

 EQUB &F2               \ trackSection0a
 EQUB &CF               \ trackSection1Hi (trackSection1 = &CF3F)
 EQUB &0B               \ trackSection2Hi (trackSection2 = &0B90)
 EQUB &F5               \ trackSection3Hi (trackSection3 = &F5FF)
 EQUB &CE               \ trackSection4Hi (trackSection4 = &CE2E)
 EQUB 36                \ trackSection5a
 EQUB &F6               \ trackSection6Hi (trackSection6 = &F6DD)
 EQUB 11                \ trackMaxSpeed

                        \ Track section 23

 EQUB &F2               \ trackSection0a
 EQUB &D1               \ trackSection1Hi (trackSection1 = &D1DE)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0C7D)
 EQUB &FD               \ trackSection3Hi (trackSection3 = &FDD2)
 EQUB &D0               \ trackSection4Hi (trackSection4 = &D07E)
 EQUB 255               \ trackSection5a
 EQUB &FD               \ trackSection6Hi (trackSection6 = &FDC5)
 EQUB 255               \ trackMaxSpeed

                        \ Same as track section 0

 EQUB &03               \ trackSection0a
 EQUB &D1               \ trackSection1Hi (trackSection1 = &D120)
 EQUB &0C               \ trackSection2Hi (trackSection2 = &0C80)
 EQUB &0F               \ trackSection3Hi (trackSection3 = &0FA0)
 EQUB &CF               \ trackSection4Hi (trackSection4 = &CFC0)
 EQUB 96                \ trackSection5a
 EQUB &0F               \ trackSection6Hi (trackSection6 = &0F94)
 EQUB 136               \ trackMaxSpeed

 EQUB &00, &8E          \ These bytes appear to be unused
 EQUB &41, &40
 EQUB &00, &00
 EQUB &C9, &54

\ .trackData0D0
\ trackData+&0D0 = &53D0

 EQUB &F6, &F8, &52, &B2, &07, &FC, &D9, &28
 EQUB &FB, &CD, &27, &17, &30, &FA, &D2, &00

\ .trackData0E0
\ trackData+&0E0 = &53E0

 EQUB &6C, &04, &1B, &03, &08, &4B, &3F, &0E
 EQUB &FF, &B1, &35, &F0, &C5, &F0, &C7, &24

\ .trackData0F0
\ trackData+&0F0 = &53F0

 EQUB &08, &08, &08, &08, &00, &12, &11, &08
 EQUB &08, &F0, &EC, &0C, &16, &04, &F0, &08

\ .xTrackVector
\ trackData+&100 = &5400
\ x-coordinate of the vector between two consecutive points on the inside of
\ the track
\ i.e. left-right on the screen

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

\ .yTrackVector
\ trackData+&200 = &5500
\ y-coordinate of the vector between two consecutive points on the inside of
\ the track
\ i.e. up-down on the screen (track height)

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

\ .zTrackVector
\ trackData+&300 = &5600
\ z-coordinate of the vector between two consecutive points on the inside of
\ the track
\ i.e. in-out of the screen

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

\ .xTrackOutVector
\ trackData+&400 = &5700
\ x-coordinate of the vector from the inside to the outside of the track
\ i.e. left-right on the screen

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

\ .zTrackOutVector
\ trackData+&500 = &5800
\ z-coordinate of the vector from the inside to the outside of the track
\ i.e. in-out of the screen

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

\ .trackSection0b
\ trackData+&600 = &5900

\ .trackSection1Lo
\ trackData+&601 = &5901

\ .trackSection2Lo
\ trackData+&602 = &5902

\ .trackSection3Lo
\ trackData+&603 = &5903

\ .trackSection4Lo
\ trackData+&604 = &5904

\ .trackSection5b
\ trackData+&605 = &5905

\ .trackSection6Lo
\ trackData+&606 = &5906

\ .trackSectionSize
\ trackData+&607 = &5907

                        \ Track section 0

 EQUB %00110000         \ trackSection0b
 EQUB &20               \ trackSection1Lo (trackSection1 = &D120)
 EQUB &80               \ trackSection2Lo (trackSection2 = &0C80)
 EQUB &A0               \ trackSection3Lo (trackSection3 = &0FA0)
 EQUB &C0               \ trackSection4Lo (trackSection4 = &CFC0)
 EQUB 0                 \ trackSection5b
 EQUB &94               \ trackSection6Lo (trackSection6 = &0F94)
 EQUB 99                \ trackSectionSize

                        \ Track section 1

 EQUB %10101101         \ trackSection0b
 EQUB &94               \ trackSection1Lo (trackSection1 = &CF94)
 EQUB &80               \ trackSection2Lo (trackSection2 = &0C80)
 EQUB &08               \ trackSection3Lo (trackSection3 = &3E08)
 EQUB &34               \ trackSection4Lo (trackSection4 = &CE34)
 EQUB 1                 \ trackSection5b
 EQUB &FC               \ trackSection6Lo (trackSection6 = &3DFC)
 EQUB 21                \ trackSectionSize

                        \ Track section 2

 EQUB %00110011         \ trackSection0b
 EQUB &25               \ trackSection1Lo (trackSection1 = &D325)
 EQUB &80               \ trackSection2Lo (trackSection2 = &0C80)
 EQUB &96               \ trackSection3Lo (trackSection3 = &4696)
 EQUB &C5               \ trackSection4Lo (trackSection4 = &D2C5)
 EQUB 22                \ trackSection5b
 EQUB &E8               \ trackSection6Lo (trackSection6 = &47E8)
 EQUB 12                \ trackSectionSize

                        \ Track section 3

 EQUB %00101101         \ trackSection0b
 EQUB &B2               \ trackSection1Lo (trackSection1 = &D6B2)
 EQUB &80               \ trackSection2Lo (trackSection2 = &0C80)
 EQUB &91               \ trackSection3Lo (trackSection3 = &4A91)
 EQUB &56               \ trackSection4Lo (trackSection4 = &D556)
 EQUB 34                \ trackSection5b
 EQUB &C9               \ trackSection6Lo (trackSection6 = &4AC9)
 EQUB 21                \ trackSectionSize

                        \ Track section 4

 EQUB %00110010         \ trackSection0b
 EQUB &AF               \ trackSection1Lo (trackSection1 = &DEAF)
 EQUB &80               \ trackSection2Lo (trackSection2 = &0C80)
 EQUB &4F               \ trackSection3Lo (trackSection3 = &4F4F)
 EQUB &9F               \ trackSection4Lo (trackSection4 = &DE9F)
 EQUB 55                \ trackSection5b
 EQUB &AE               \ trackSection6Lo (trackSection6 = &50AE)
 EQUB 105               \ trackSectionSize

                        \ Track section 5

 EQUB %10101101         \ trackSection0b
 EQUB &E7               \ trackSection1Lo (trackSection1 = &0FE7)
 EQUB &80               \ trackSection2Lo (trackSection2 = &0C80)
 EQUB &5C               \ trackSection3Lo (trackSection3 = &515C)
 EQUB &D7               \ trackSection4Lo (trackSection4 = &0FD7)
 EQUB 56                \ trackSection5b
 EQUB &BB               \ trackSection6Lo (trackSection6 = &52BB)
 EQUB 24                \ trackSectionSize

                        \ Track section 6

 EQUB %00000010         \ trackSection0b
 EQUB &D8               \ trackSection1Lo (trackSection1 = &17D8)
 EQUB &CB               \ trackSection2Lo (trackSection2 = &0CCB)
 EQUB &09               \ trackSection3Lo (trackSection3 = &4B09)
 EQUB &37               \ trackSection4Lo (trackSection4 = &1937)
 EQUB 80                \ trackSection5b
 EQUB &17               \ trackSection6Lo (trackSection6 = &4B17)
 EQUB 28                \ trackSectionSize

                        \ Track section 7

 EQUB %00000001         \ trackSection0b
 EQUB &64               \ trackSection1Lo (trackSection1 = &1864)
 EQUB &53               \ trackSection2Lo (trackSection2 = &0E53)
 EQUB &E9               \ trackSection3Lo (trackSection3 = &3DE9)
 EQUB &C3               \ trackSection4Lo (trackSection4 = &19C3)
 EQUB 81                \ trackSection5b
 EQUB &F7               \ trackSection6Lo (trackSection6 = &3DF7)
 EQUB 9                 \ trackSectionSize

                        \ Track section 8

 EQUB %00101000         \ trackSection0b
 EQUB &91               \ trackSection1Lo (trackSection1 = &1891)
 EQUB &77               \ trackSection2Lo (trackSection2 = &0E77)
 EQUB &B1               \ trackSection3Lo (trackSection3 = &39B1)
 EQUB &F0               \ trackSection4Lo (trackSection4 = &19F0)
 EQUB 90                \ trackSection5b
 EQUB &BF               \ trackSection6Lo (trackSection6 = &39BF)
 EQUB 54                \ trackSectionSize

                        \ Track section 9

 EQUB %00110011         \ trackSection0b
 EQUB &9F               \ trackSection1Lo (trackSection1 = &199F)
 EQUB &9F               \ trackSection2Lo (trackSection2 = &0D9F)
 EQUB &61               \ trackSection3Lo (trackSection3 = &2061)
 EQUB &FE               \ trackSection4Lo (trackSection4 = &1AFE)
 EQUB 91                \ trackSection5b
 EQUB &6F               \ trackSection6Lo (trackSection6 = &206F)
 EQUB 16                \ trackSectionSize

                        \ Track section 10

 EQUB %00000000         \ trackSection0b
 EQUB &FA               \ trackSection1Lo (trackSection1 = &1BFA)
 EQUB &5F               \ trackSection2Lo (trackSection2 = &0D5F)
 EQUB &5D               \ trackSection3Lo (trackSection3 = &195D)
 EQUB &1B               \ trackSection4Lo (trackSection4 = &1D1B)
 EQUB 107               \ trackSection5b
 EQUB &25               \ trackSection6Lo (trackSection6 = &1A25)
 EQUB 38                \ trackSectionSize

                        \ Track section 11

 EQUB %00110000         \ trackSection0b
 EQUB &12               \ trackSection1Lo (trackSection1 = &2612)
 EQUB &C7               \ trackSection2Lo (trackSection2 = &0CC7)
 EQUB &AB               \ trackSection3Lo (trackSection3 = &0AAB)
 EQUB &33               \ trackSection4Lo (trackSection4 = &2733)
 EQUB 108               \ trackSection5b
 EQUB &73               \ trackSection6Lo (trackSection6 = &0B73)
 EQUB 27                \ trackSectionSize

                        \ Track section 12

 EQUB %10101101         \ trackSection0b
 EQUB &C5               \ trackSection1Lo (trackSection1 = &2DC5)
 EQUB &5B               \ trackSection2Lo (trackSection2 = &0C5B)
 EQUB &8B               \ trackSection3Lo (trackSection3 = &008B)
 EQUB &DD               \ trackSection4Lo (trackSection4 = &2EDD)
 EQUB 109               \ trackSection5b
 EQUB &5F               \ trackSection6Lo (trackSection6 = &015F)
 EQUB 27                \ trackSectionSize

                        \ Track section 13

 EQUB %00101010         \ trackSection0b
 EQUB &65               \ trackSection1Lo (trackSection1 = &2965)
 EQUB &4D               \ trackSection2Lo (trackSection2 = &0C4D)
 EQUB &7E               \ trackSection3Lo (trackSection3 = &F67E)
 EQUB &D3               \ trackSection4Lo (trackSection4 = &29D3)
 EQUB 136               \ trackSection5b
 EQUB &2F               \ trackSection6Lo (trackSection6 = &F52F)
 EQUB 40                \ trackSectionSize

                        \ Track section 14

 EQUB %00110011         \ trackSection0b
 EQUB &95               \ trackSection1Lo (trackSection1 = &1795)
 EQUB &4D               \ trackSection2Lo (trackSection2 = &0C4D)
 EQUB &8E               \ trackSection3Lo (trackSection3 = &F08E)
 EQUB &03               \ trackSection4Lo (trackSection4 = &1803)
 EQUB 137               \ trackSection5b
 EQUB &3F               \ trackSection6Lo (trackSection6 = &EF3F)
 EQUB 16                \ trackSectionSize

                        \ Track section 15

 EQUB %00000000         \ trackSection0b
 EQUB &D8               \ trackSection1Lo (trackSection1 = &11D8)
 EQUB &0D               \ trackSection2Lo (trackSection2 = &0C0D)
 EQUB &FA               \ trackSection3Lo (trackSection3 = &EBFA)
 EQUB &05               \ trackSection4Lo (trackSection4 = &1305)
 EQUB 153               \ trackSection5b
 EQUB &44               \ trackSection6Lo (trackSection6 = &EB44)
 EQUB 135               \ trackSectionSize

                        \ Track section 16

 EQUB %00000001         \ trackSection0b
 EQUB &26               \ trackSection1Lo (trackSection1 = &F126)
 EQUB &D5               \ trackSection2Lo (trackSection2 = &07D5)
 EQUB &A9               \ trackSection3Lo (trackSection3 = &B5A9)
 EQUB &53               \ trackSection4Lo (trackSection4 = &F253)
 EQUB 154               \ trackSection5b
 EQUB &F3               \ trackSection6Lo (trackSection6 = &B4F3)
 EQUB 6                 \ trackSectionSize

                        \ Track section 17

 EQUB %00110000         \ trackSection0b
 EQUB &B2               \ trackSection1Lo (trackSection1 = &EFB2)
 EQUB &F7               \ trackSection2Lo (trackSection2 = &07F7)
 EQUB &3F               \ trackSection3Lo (trackSection3 = &B33F)
 EQUB &DF               \ trackSection4Lo (trackSection4 = &F0DF)
 EQUB 160               \ trackSection5b
 EQUB &89               \ trackSection6Lo (trackSection6 = &B289)
 EQUB 28                \ trackSectionSize

                        \ Track section 18

 EQUB %10101101         \ trackSection0b
 EQUB &EA               \ trackSection1Lo (trackSection1 = &E8EA)
 EQUB &9B               \ trackSection2Lo (trackSection2 = &099B)
 EQUB &FB               \ trackSection3Lo (trackSection3 = &A7FB)
 EQUB &17               \ trackSection4Lo (trackSection4 = &EA17)
 EQUB 161               \ trackSection5b
 EQUB &45               \ trackSection6Lo (trackSection6 = &A745)
 EQUB 40                \ trackSectionSize

                        \ Track section 19

 EQUB %00110010         \ trackSection0b
 EQUB &49               \ trackSection1Lo (trackSection1 = &D849)
 EQUB &64               \ trackSection2Lo (trackSection2 = &0A64)
 EQUB &A2               \ trackSection3Lo (trackSection3 = &A5A2)
 EQUB &4A               \ trackSection4Lo (trackSection4 = &D74A)
 EQUB 201               \ trackSection5b
 EQUB &AE               \ trackSection6Lo (trackSection6 = &A4AE)
 EQUB 104               \ trackSectionSize

                        \ Track section 20

 EQUB %10101101         \ trackSection0b
 EQUB &91               \ trackSection1Lo (trackSection1 = &B691)
 EQUB &F4               \ trackSection2Lo (trackSection2 = &07F4)
 EQUB &FA               \ trackSection3Lo (trackSection3 = &C8FA)
 EQUB &92               \ trackSection4Lo (trackSection4 = &B592)
 EQUB 202               \ trackSection5b
 EQUB &06               \ trackSection6Lo (trackSection6 = &C806)
 EQUB 33                \ trackSectionSize

                        \ Track section 21

 EQUB %00101010         \ trackSection0b
 EQUB &03               \ trackSection1Lo (trackSection1 = &B603)
 EQUB &3E               \ trackSection2Lo (trackSection2 = &083E)
 EQUB &1E               \ trackSection3Lo (trackSection3 = &D71E)
 EQUB &F2               \ trackSection4Lo (trackSection4 = &B4F2)
 EQUB 235               \ trackSection5b
 EQUB &FC               \ trackSection6Lo (trackSection6 = &D7FC)
 EQUB 85                \ trackSectionSize

                        \ Track section 22

 EQUB %00110011         \ trackSection0b
 EQUB &3F               \ trackSection1Lo (trackSection1 = &CF3F)
 EQUB &90               \ trackSection2Lo (trackSection2 = &0B90)
 EQUB &FF               \ trackSection3Lo (trackSection3 = &F5FF)
 EQUB &2E               \ trackSection4Lo (trackSection4 = &CE2E)
 EQUB 236               \ trackSection5b
 EQUB &DD               \ trackSection6Lo (trackSection6 = &F6DD)
 EQUB 18                \ trackSectionSize

                        \ Track section 23

 EQUB %00000100         \ trackSection0b
 EQUB &DE               \ trackSection1Lo (trackSection1 = &D1DE)
 EQUB &7D               \ trackSection2Lo (trackSection2 = &0C7D)
 EQUB &D2               \ trackSection3Lo (trackSection3 = &FDD2)
 EQUB &7E               \ trackSection4Lo (trackSection4 = &D07E)
 EQUB 254               \ trackSection5b
 EQUB &C5               \ trackSection6Lo (trackSection6 = &FDC5)
 EQUB 38                \ trackSectionSize

                        \ Same as track section 0

 EQUB %00110000         \ trackSection0b
 EQUB &20               \ trackSection1Lo (trackSection1 = &D120)
 EQUB &80               \ trackSection2Lo (trackSection2 = &0C80)
 EQUB &A0               \ trackSection3Lo (trackSection3 = &0FA0)
 EQUB &C0               \ trackSection4Lo (trackSection4 = &CFC0)
 EQUB 0                 \ trackSection5b
 EQUB &94               \ trackSection6Lo (trackSection6 = &0F94)
 EQUB 99                \ trackSectionSize

 EQUB &64, &F0          \ These bytes appear to be unused
 EQUB &00, &00
 EQUB &48, &00
 EQUB &50, &52

\ .trackData6D0
\ trackData+&6D0 = &59D0
\
\ These 24 bytes are copied to L5FB0, one per track section
\ Bit 0 -> bit 7 of result
\ Bit 1 clear -> result is scaled by U
\ See sub_C44C6

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

 EQUB &67               \ Unused?

\ .trackRoadSigns
\ trackData+&6EA = &59EA
\ Track sections and object types for 16 road signs
\ Bits 0-2 = Object type of road sign (add 7 to get the type)
\ Bits 3-7 = Index into track data at trackData+&001, trackData+&601
\            Track section
\ Road sign at track section 23 is the sign we see at start of practice

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

\ .trackSectionCount
\ trackData+&6FA = &59FA
\ The number of bytes at trackData+&6D0 (24) that we copy to L5FB0
\ Number of track sections * 8

 EQUB 24 * 8

\ trackData+&6FB = &59FB

 EQUB &FF

\ .trackLengthHi
\ .trackLengthLo
\ trackData(&6FD &6FC) = (&59FD &59FC)
\ Length of full track (in terms of progress)
\ carProgress wraps round to 0 when it reaches this figure

 EQUW &0400

\ .trackStartHi
\ .trackStartLo
\ trackData(&6FE &6FF) = (&59FF &59FE)
\ 24 bytes in (carProgressHi carProgressLo) are initialised to &034B
\ Starting point for practice laps

 EQUW &034B

\ .trackLapTimeSec
\ trackData+&700 = &5A00
\ Race class adjuster: seconds
\ See MainLoop (Part 4 of 6)
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we set the race class to the relevant difficulty

 EQUB 51                \ Set class to Novice if slowest lap time > 1:51
 EQUB 41                \ Set class to Amateur if slowest lap time > 1:41
 EQUB 0                 \ Otherwise set class to Professional

\ .trackLapTimeMin
\ trackData+&703 = &5A03
\ See MainLoop (Part 4 of 6)
\ Race class adjuster: minutes

 EQUB 1                 \ Set class to Novice if slowest lap time > 1:51
 EQUB 1                 \ Set class to Amateur if slowest lap time > 1:41
 EQUB 0                 \ Otherwise set class to Professional

\ .trackGearRatio
\ trackData+&706 = &5A06
\ Called "ratios" in car performance hack

 EQUB 103               \ Reverse
 EQUB 0                 \ Neutral
 EQUB 103               \ First gear
 EQUB 66                \ Second gear
 EQUB 53                \ Third gear
 EQUB 46                \ Fourth gear
 EQUB 42                \ Fifth gear

\ .trackGearPower
\ trackData+&70D = &5A0D
\ Called "powers" in car performance hack

 EQUB 161               \ Reverse
 EQUB 0                 \ Neutral
 EQUB 161               \ First gear
 EQUB 104               \ Second gear
 EQUB 82                \ Third gear
 EQUB 72                \ Fourth gear
 EQUB 65                \ Fifth gear

\ .trackBaseSpeed
\ trackData+&714 = &5A14

 EQUB 134               \ Base speed for Novice
 EQUB 146               \ Base speed for Amateur
 EQUB 152               \ Base speed for Professional

\ .trackLapStart
\ trackData+&717 = &5A17
\ The starting position of the player during a practice or qualifying lap

 EQUB 4

\ .trackData718
\ trackData+&718 = &5A18
\ Passed to sub_C109B in A by ResetVariables for a practice or qualifying lap

 EQUB 40

\ .trackData719
\ trackData+&719 = &5A19
\ Something to do with the lap timer - when L0046 matches this number, the lap
\ timer is bumped up by 18/100 rather than 9/100 in sub_C17C3
\ L0046 is incremented in sub_C5052
\ Used to initialise the value of L0046 in sub_C5052

 EQUB 24

\ .trackRaceSlowdown
\ trackData+&71A = &5A1A
\ Reduce the speed of all cars in a race by this amount (this does not affect
\ the speed during qualifying)

 EQUB 0

 EQUB &73, &6F          \ These bytes appear to be unused
 EQUB &31, &00
 EQUB &8C, &00
 EQUB &00

.CallTrackHook

 RTS                    \ This code gets copied to the CallTrackHook routine in
 NOP                    \ the main game code, and gets called when the game is
 NOP                    \ starting up
                        \
                        \ In this track, the hook code does nothing

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

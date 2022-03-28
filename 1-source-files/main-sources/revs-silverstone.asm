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

\ Track section  0:  ||  [chicane]      Abbey Curve to Woodcote Corner     &63
\ Track section  1:  ~~                 Woodcote Corner                    &15
\ Track section  2:  ~~  [straight]     Woodcote Corner                    &0C
\ Track section  3:  ||  [start]        Home straight                      &15
\ Track section  4:  ||                 Home straight                      &69
\ Track section  5:  ||  [right]        Approach to Copse Corner           &18
\ Track section  6:  ->                 Copse Corner                       &1C
\ Track section  7:  ||  [straight]     Out of Copse Corner                &09
\ Track section  8:  ||                 Copse Corner to Maggotts Curve     &36
\ Track section  9:  ||  [left]         Approach to Maggotts Curve         &10
\ Track section 10:  <-                 Maggotts Curve                     &26
\ Track section 11:  ||                 Maggotts Curve to Becketts Corner  &1B
\ Track section 12:  ->  [right]        Becketts Corner                    &1B
\ Track section 13:  ||                 Becketts Corner to Chapel Curve    &28
\ Track section 14:  <-  [left, st, st] Chapel Curve                       &10
\ Track section 15:  ||                 Hangar Straight                    &87
\ Track section 16:  ||                 Hangar Straight                    &06
\ Track section 17:  ||                 Approach to Stowe Corner           &1C
\ Track section 18:  ->  [right]        Stowe Corner                       &28
\ Track section 19:  ||  [straight]     Stowe Corner to Club Corner        &68
\ Track section 20:  ->  [right]        Club Corner                        &21
\ Track section 21:  ||  [straight]     Club Corner to Abbey Curve         &55
\ Track section 22:  <-  [left]         Abbey Curve                        &12
\ Track section 23:  ||  [straight]     Abbey Curve to Woodcote Corner     &26

.trackData

\ .trackSection0a
\ trackData      = L5300
\ Bits 4-7 of trackData+0 (i.e. first digit in hex value) is an index into
\ trackData+&0D0, trackData+&0E0, trackData+&0F0

\ .trackSection1Hi
\ trackData+&001 = L5301

\ .trackSection2Hi
\ trackData+&002 = L5302

\ .trackSection3Hi
\ trackData+&003 = L5303



\ .trackSection4Hi
\ trackData+&004 = L5304

\ .trackSection5a
\ trackData+&005 = L5305

\ .trackSection6Hi
\ trackData+&006 = L5306



\ .trackSection7
\ trackData+&007 = L5307

EQUB &03, &D1, &0C, &0F, &CF, &60, &0F, &88     \ Track section  0
EQUB &13, &CF, &0C, &3E, &CE, &12, &3D, &00     \ Track section  1
EQUB &12, &D3, &0C, &46, &D2, &14, &47, &8A     \ Track section  2
EQUB &22, &D6, &0C, &4A, &D5, &1E, &4A, &21     \ Track section  3
EQUB &22, &DE, &0C, &4F, &DE, &62, &50, &7D     \ Track section  4
EQUB &33, &0F, &0C, &51, &0F, &28, &52, &1A     \ Track section  5
EQUB &42, &17, &0C, &4B, &19, &FF, &4B, &FF     \ Track section  6
EQUB &53, &18, &0E, &3D, &19, &00, &3D, &00     \ Track section  7
EQUB &53, &18, &0E, &39, &19, &21, &39, &FF     \ Track section  8
EQUB &64, &19, &0D, &20, &1A, &28, &20, &0C     \ Track section  9
EQUB &64, &1B, &0D, &19, &1D, &FF, &1A, &FF     \ Track section 10
EQUB &73, &26, &0C, &0A, &27, &15, &0B, &74     \ Track section 11
EQUB &72, &2D, &0C, &00, &2E, &27, &01, &19     \ Track section 12
EQUB &72, &29, &0C, &F6, &29, &18, &F5, &FF     \ Track section 13
EQUB &84, &17, &0C, &F0, &18, &28, &EF, &14     \ Track section 14
EQUB &93, &11, &0C, &EB, &13, &FF, &EB, &FF     \ Track section 15
EQUB &A2, &F1, &07, &B5, &F2, &00, &B4, &00     \ Track section 16
EQUB &B1, &EF, &07, &B3, &F0, &16, &B2, &8B     \ Track section 17
EQUB &B4, &E8, &09, &A7, &EA, &34, &A7, &18     \ Track section 18
EQUB &C3, &D8, &0A, &A5, &D7, &60, &A4, &97     \ Track section 19
EQUB &D2, &B6, &07, &C8, &B5, &31, &C8, &1C     \ Track section 20
EQUB &E2, &B6, &08, &D7, &B4, &45, &D7, &FF     \ Track section 21
EQUB &F2, &CF, &0B, &F5, &CE, &24, &F6, &0B     \ Track section 22
EQUB &F2, &D1, &0C, &FD, &D0, &FF, &FD, &FF     \ Track section 23

EQUB &03, &D1, &0C, &0F, &CF, &60, &0F, &88     \ Unused?
EQUB &00, &8E, &41, &40, &00, &00, &C9, &54     \ Unused?

\ trackData+&0D0 = L53D0

 EQUB &F6, &F8, &52, &B2, &07, &FC, &D9, &28
 EQUB &FB, &CD, &27, &17, &30, &FA, &D2, &00

\ trackData+&0E0 = L53E0

 EQUB &6C, &04, &1B, &03, &08, &4B, &3F, &0E
 EQUB &FF, &B1, &35, &F0, &C5, &F0, &C7, &24

\ trackData+&0F0 = L53F0

 EQUB &08, &08, &08, &08, &00, &12, &11, &08
 EQUB &08, &F0, &EC, &0C, &16, &04, &F0, &08

\ .trackDataBlock1
\ trackData+&100 = L5400

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

\ .trackDataBlock2
\ trackData+&200 = L5500

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

\ .trackDataBlock3
\ trackData+&300 = L5600

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

\ .trackDataBlock4
\ trackData+&400 = L5700

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

\ .trackDataBlock5
\ trackData+&500 = &5800

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

EQUB &30, &20, &80, &A0, &C0, &00, &94, &63     \ Track section  0
EQUB &AD, &94, &80, &08, &34, &01, &FC, &15     \ Track section  1
EQUB &33, &25, &80, &96, &C5, &16, &E8, &0C     \ Track section  2
EQUB &2D, &B2, &80, &91, &56, &22, &C9, &15     \ Track section  3
EQUB &32, &AF, &80, &4F, &9F, &37, &AE, &69     \ Track section  4
EQUB &AD, &E7, &80, &5C, &D7, &38, &BB, &18     \ Track section  5
EQUB &02, &D8, &CB, &09, &37, &50, &17, &1C     \ Track section  6
EQUB &01, &64, &53, &E9, &C3, &51, &F7, &09     \ Track section  7
EQUB &28, &91, &77, &B1, &F0, &5A, &BF, &36     \ Track section  8
EQUB &33, &9F, &9F, &61, &FE, &5B, &6F, &10     \ Track section  9
EQUB &00, &FA, &5F, &5D, &1B, &6B, &25, &26     \ Track section 10
EQUB &30, &12, &C7, &AB, &33, &6C, &73, &1B     \ Track section 11
EQUB &AD, &C5, &5B, &8B, &DD, &6D, &5F, &1B     \ Track section 12
EQUB &2A, &65, &4D, &7E, &D3, &88, &2F, &28     \ Track section 13
EQUB &33, &95, &4D, &8E, &03, &89, &3F, &10     \ Track section 14
EQUB &00, &D8, &0D, &FA, &05, &99, &44, &87     \ Track section 15
EQUB &01, &26, &D5, &A9, &53, &9A, &F3, &06     \ Track section 16
EQUB &30, &B2, &F7, &3F, &DF, &A0, &89, &1C     \ Track section 17
EQUB &AD, &EA, &9B, &FB, &17, &A1, &45, &28     \ Track section 18
EQUB &32, &49, &64, &A2, &4A, &C9, &AE, &68     \ Track section 19
EQUB &AD, &91, &F4, &FA, &92, &CA, &06, &21     \ Track section 20
EQUB &2A, &03, &3E, &1E, &F2, &EB, &FC, &55     \ Track section 21
EQUB &33, &3F, &90, &FF, &2E, &EC, &DD, &12     \ Track section 22
EQUB &04, &DE, &7D, &D2, &7E, &FE, &C5, &26     \ Track section 23

EQUB &30, &20, &80, &A0, &C0, &00, &94, &63     \ Unused?
EQUB &64, &F0, &00, &00, &48, &00, &50, &52     \ Unused?

\ trackData+&6D0 = &59D0
\
\ These 24 bytes are copied to L5FB0, one per track section
\ Bit 0 -> bit 7 of result
\ Bit 1 clear -> result is scaled by U
\ See sub_C44C6

 EQUB &14               \ Track section  0
 EQUB &33               \ Track section  1
 EQUB &72               \ Track section  2
 EQUB &3B               \ Track section  3
 EQUB &18               \ Track section  4
 EQUB &33               \ Track section  5
 EQUB &15               \ Track section  6
 EQUB &15               \ Track section  7
 EQUB &15               \ Track section  8
 EQUB &3C               \ Track section  9
 EQUB &18               \ Track section 10
 EQUB &30               \ Track section 11
 EQUB &33               \ Track section 12
 EQUB &39               \ Track section 13
 EQUB &38               \ Track section 14
 EQUB &14               \ Track section 15
 EQUB &14               \ Track section 16
 EQUB &14               \ Track section 17
 EQUB &37               \ Track section 18
 EQUB &20               \ Track section 19
 EQUB &59               \ Track section 20
 EQUB &2B               \ Track section 21
 EQUB &54               \ Track section 22
 EQUB &14               \ Track section 23

 EQUB &14, &67          \ Unused?

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
\ Number of track sections

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

\ trackData+&718 = &5A18
\ Passed to sub_C109B in A by ResetVariables for a practice or qualifying lap

 EQUB 40

\ trackData+&719 = &5A19
\ Something to do with the lap timer - when L0046 matches this number, the lap
\ timer is bumped up by 18/100 rather than 9/100 in sub_C17C3
\ L0046 is incremented in sub_C5052
\ Used to initialise the value of L0046 in sub_C5052

 EQUB 24

\ trackData+&71A = &5A1A
\ Subtracted from driver speed in sub_C27ED

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

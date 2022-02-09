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
\ Produces the binary file Silvers.bin that contains the Silverstone track.
\
\ ******************************************************************************

ORG CODE%

.trackData

\ trackData = L5300

 EQUB &03

\ trackData+1 = L5301

 EQUB &D1

\ trackData+2 = L5302

 EQUB &0C

\ trackData+3 = L5303

 EQUB &0F

\ trackData+4 = L5304

 EQUB &CF

\ trackData+5 = L5305

 EQUB &60

\ trackData+6 = L5306

 EQUB &0F

\ trackData+7 = L5307

 EQUB &88, &13, &CF, &0C, &3E
 EQUB &CE, &12, &3D, &00, &12, &D3, &0C, &46, &D2, &14, &47, &8A
 EQUB &22, &D6, &0C, &4A, &D5, &1E, &4A, &21, &22, &DE, &0C, &4F
 EQUB &DE, &62, &50, &7D, &33, &0F, &0C, &51, &0F, &28, &52, &1A
 EQUB &42, &17, &0C, &4B, &19, &FF, &4B, &FF, &53, &18, &0E, &3D
 EQUB &19, &00, &3D, &00, &53, &18, &0E, &39, &19, &21, &39, &FF
 EQUB &64, &19, &0D, &20, &1A, &28, &20, &0C, &64, &1B, &0D, &19
 EQUB &1D, &FF, &1A, &FF, &73, &26, &0C, &0A, &27, &15, &0B, &74
 EQUB &72, &2D, &0C, &00, &2E, &27, &01, &19, &72, &29, &0C, &F6
 EQUB &29, &18, &F5, &FF, &84, &17, &0C, &F0, &18, &28, &EF, &14
 EQUB &93, &11, &0C, &EB, &13, &FF, &EB, &FF, &A2, &F1, &07, &B5
 EQUB &F2, &00, &B4, &00, &B1, &EF, &07, &B3, &F0, &16, &B2, &8B
 EQUB &B4, &E8, &09, &A7, &EA, &34, &A7, &18, &C3, &D8, &0A, &A5
 EQUB &D7, &60, &A4, &97, &D2, &B6, &07, &C8, &B5, &31, &C8, &1C
 EQUB &E2, &B6, &08, &D7, &B4, &45, &D7, &FF, &F2, &CF, &0B, &F5
 EQUB &CE, &24, &F6, &0B, &F2, &D1, &0C, &FD, &D0, &FF, &FD, &FF
 EQUB &03, &D1, &0C, &0F, &CF, &60, &0F, &88, &00, &8E, &41, &40
 EQUB &00, &00, &C9, &54, &F6

\ trackData+208 = L53D0

 EQUB &F8, &52, &B2, &07, &FC, &D9, &28
 EQUB &FB, &CD, &27, &17, &30, &FA, &D2, &00

\ trackData+224 = L53E0

 EQUB &6C, &04, &1B, &03
 EQUB &08, &4B, &3F, &0E, &FF, &B1, &35, &F0, &C5, &F0, &C7, &24

\ trackData+240 = L53F0

 EQUB &08, &08, &08, &08, &00, &12, &11, &08, &08, &F0, &EC, &0C
 EQUB &16, &04, &F0, &08

\ trackData+256 = L5400

 EQUB &FC, &FE, &02, &06, &0A, &0E, &12, &15
 EQUB &19, &1D, &21, &25, &28, &2C, &30, &33, &3C, &4A, &57, &61
 EQUB &6A, &71, &72, &6E, &69, &63, &5C, &54, &4B, &42, &39, &2E
 EQUB &24, &19, &1C, &2E, &3F, &4F, &57, &5B, &5E, &61, &64, &67
 EQUB &69, &6C, &6E, &70, &72, &73, &75, &76, &77, &77, &78, &78
 EQUB &78, &78, &77, &77, &75, &74, &72, &70, &6D, &6A, &67, &63
 EQUB &5F, &5B, &55, &4E, &47, &3F, &37, &2E, &26, &1C, &13, &0A
 EQUB &05, &05, &05, &05, &05, &05, &05, &05, &05, &05, &05, &07
 EQUB &0B, &10, &14, &18, &1C, &20, &24, &28, &2C, &30, &34, &38
 EQUB &3B, &3F, &43, &44, &49, &44, &3B, &31, &26, &1B, &10, &05
 EQUB &FA, &EF, &E6, &DF, &D8, &D2, &CB, &C5, &BF, &B9, &B4, &AE
 EQUB &A9, &A5, &A0, &9C, &98, &95, &92, &8F, &8E, &8F, &91, &93
 EQUB &95, &98, &9B, &9D, &A1, &A4, &A7, &AB, &AF, &B3, &B7, &BB
 EQUB &C0, &C2, &C2, &C2, &C2, &C2, &C2, &C2, &C2, &BF, &BA, &B4
 EQUB &AF, &AA, &A6, &A2, &9D, &9A, &96, &94, &92, &91, &8F, &8E
 EQUB &8D, &8C, &8B, &8A, &89, &89, &88, &88, &88, &88, &88, &88
 EQUB &89, &89, &8A, &8A, &8B, &8D, &90, &93, &96, &9B, &9F, &A5
 EQUB &AA, &AD, &AF, &B3, &B7, &BB, &C0, &C4, &C9, &CE, &D2, &D7
 EQUB &DC, &E1, &E6, &EC, &F1, &F6, &FB, &01, &06, &0B, &10, &15
 EQUB &1B, &20, &25, &2A, &2F, &33, &38, &3D, &41, &46, &4A, &4C
 EQUB &4A, &46, &42, &3E, &3A, &36, &31, &2D, &28, &24, &1F, &1A
 EQUB &16, &11, &0C, &08, &03, &FE, &FB, &00

\ trackData+512 = L5500

 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &01, &03, &04, &05, &07, &08
 EQUB &0A, &0B, &0C, &0E, &0E, &0C, &0A, &08, &06, &04, &02, &00
 EQUB &FE, &FC, &FC, &FC, &FC, &FC, &FC, &FC, &FC, &FC, &FC, &FC
 EQUB &FC, &FC, &FC, &FC, &FC, &FC, &FC, &FC, &FC, &FD, &FD, &FE
 EQUB &FE, &FE, &FF, &FF, &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &FF, &FF, &FE, &FE, &FD, &FD, &FC, &FC, &FB, &FB
 EQUB &FA, &FA, &F9, &F9, &F8, &F8, &FC, &00, &04, &08, &0B, &0F
 EQUB &0F, &0F, &0E, &0E, &0D, &0D, &0C, &0C, &0B, &0B, &0A, &0A
 EQUB &09, &09, &08, &08, &07, &07, &06, &06, &05, &05, &05, &04
 EQUB &04, &03, &03, &02, &02, &01, &01, &00, &00, &FF, &FE, &FE
 EQUB &FD, &FC, &FB, &FA, &FA, &FA, &FA, &FB, &FB, &FC, &FC, &FD
 EQUB &FD, &FE, &FE, &FF, &FF, &00, &00, &01, &01, &02, &02, &03
 EQUB &03, &04, &04, &05, &05, &06, &06, &07, &07, &08, &08, &09
 EQUB &09, &0A, &0A, &0A, &0B, &0C, &0D, &0E, &0E, &0F, &10, &11
 EQUB &12, &12, &13, &14, &11, &0D, &0A, &07, &03, &00, &00, &00

\ trackData+768 = L5600

 EQUB &78, &78, &78, &78, &78, &77, &77, &76, &75, &74, &73, &72
 EQUB &71, &70, &6E, &6D, &68, &5E, &53, &46, &38, &29, &26, &31
 EQUB &3B, &44, &4D, &56, &5D, &64, &6A, &6F, &73, &75, &74, &6F
 EQUB &66, &5B, &52, &4E, &4A, &46, &42, &3E, &39, &35, &30, &2B
 EQUB &26, &21, &1C, &17, &12, &0D, &08, &05, &02, &FB, &F4, &EE
 EQUB &E7, &E1, &DA, &D4, &CE, &C8, &C2, &BC, &B7, &B2, &AC, &A5
 EQUB &9F, &9A, &95, &91, &8E, &8B, &8A, &88, &88, &88, &88, &88
 EQUB &88, &88, &88, &88, &88, &88, &88, &88, &89, &89, &8A, &8A
 EQUB &8B, &8C, &8E, &8F, &90, &92, &94, &96, &98, &9A, &9C, &9D
 EQUB &A0, &9D, &97, &92, &8E, &8B, &89, &88, &88, &89, &8B, &8D
 EQUB &8F, &91, &94, &97, &9B, &9F, &A3, &A8, &AD, &B2, &B8, &BE
 EQUB &C4, &CA, &D0, &D7, &DA, &D8, &D3, &CE, &C9, &C4, &C0, &BC
 EQUB &B7, &B3, &AF, &AB, &A8, &A4, &A1, &9E, &9B, &99, &99, &99
 EQUB &99, &99, &99, &99, &99, &9B, &9F, &A3, &A7, &AC, &B1, &B6
 EQUB &BC, &C1, &C7, &CC, &CF, &D3, &D7, &DA, &DE, &E2, &E6, &E9
 EQUB &ED, &F1, &F5, &F9, &FD, &01, &05, &09, &0D, &11, &14, &18
 EQUB &1C, &22, &2A, &32, &39, &40, &47, &4E, &54, &57, &58, &5C
 EQUB &5F, &62, &65, &68, &6B, &6D, &6F, &71, &73, &74, &75, &76
 EQUB &77, &78, &78, &78, &78, &77, &77, &76, &75, &74, &72, &70
 EQUB &6F, &6C, &6A, &67, &65, &62, &5F, &5D, &5E, &61, &64, &67
 EQUB &69, &6B, &6D, &6F, &71, &73, &74, &75, &76, &77, &77, &78
 EQUB &78, &78, &78, &53

\ trackData+1024 = L5700

 EQUB &A9, &A9, &A9, &A9, &A9, &A9, &AA, &AA
 EQUB &AB, &AB, &AC, &AD, &AE, &AF, &B0, &B2, &B8, &BF, &C8, &D2
 EQUB &DD, &E9, &E1, &D9, &D2, &CB, &C5, &BF, &BA, &B5, &B1, &AE
 EQUB &AB, &AA, &AD, &B2, &BA, &C3, &C6, &C8, &CB, &CE, &D2, &D5
 EQUB &D8, &DC, &DF, &E3, &E6, &EA, &EE, &F1, &F5, &F9, &FD, &FD
 EQUB &01, &06, &0A, &0F, &14, &19, &1E, &22, &27, &2B, &2F, &33
 EQUB &37, &3B, &40, &44, &48, &4C, &4F, &52, &54, &56, &57, &57
 EQUB &57, &57, &57, &57, &57, &57, &57, &57, &57, &57, &57, &57
 EQUB &57, &57, &56, &55, &55, &54, &53, &52, &51, &4F, &4E, &4D
 EQUB &4B, &4A, &48, &48, &46, &4A, &4E, &52, &54, &56, &57, &57
 EQUB &57, &56, &55, &53, &52, &50, &4D, &4B, &48, &45, &42, &3E
 EQUB &3A, &36, &32, &2E, &29, &25, &20, &1B, &1B, &1F, &22, &26
 EQUB &29, &2D, &30, &33, &36, &39, &3C, &3F, &42, &44, &47, &49
 EQUB &4B, &4B, &4B, &4B, &4B, &4B, &4B, &4B, &4B, &48, &45, &42
 EQUB &3F, &3B, &38, &34, &30, &2B, &27, &24, &22, &1F, &1D, &1A
 EQUB &17, &14, &11, &0F, &0C, &09, &06, &03, &00, &FE, &FC, &F9
 EQUB &F6, &F3, &F0, &ED, &EB, &E5, &DF, &D9, &D4, &CF, &CA, &C5
 EQUB &C1, &C1, &BE, &BC, &B9, &B7, &B5, &B3, &B1, &B0, &AE, &AD
 EQUB &AC, &AB, &AA, &A9, &A9, &A9, &A9, &A9, &A9, &A9, &AA, &AA
 EQUB &AB, &AC, &AD, &AF, &B0, &B2, &B4, &B6, &B8, &BA, &BC, &BC
 EQUB &BA, &B8, &B6, &B4, &B3, &B1, &B0, &AE, &AD, &AC, &AB, &AA
 EQUB &AA, &A9, &A9, &A9, &A9, &A9, &A9, &76

\ trackData+1280 = 5800

 EQUB &FE, &00, &02, &05
 EQUB &08, &0B, &0E, &11, &13, &16, &19, &1C, &1E, &21, &24, &26
 EQUB &31, &3B, &43, &4A, &50, &54, &52, &4E, &4A, &45, &40, &3A
 EQUB &34, &2D, &25, &1E, &16, &0E, &1B, &28, &34, &3E, &41, &43
 EQUB &46, &48, &4A, &4C, &4E, &4F, &51, &52, &54, &55, &55, &56
 EQUB &57, &57, &57, &57, &57, &57, &57, &56, &55, &54, &52, &50
 EQUB &4E, &4C, &4A, &47, &44, &41, &3C, &36, &31, &2B, &25, &1E
 EQUB &18, &11, &0A, &03, &03, &03, &03, &03, &03, &03, &03, &03
 EQUB &03, &03, &03, &06, &09, &0C, &0F, &13, &16, &19, &1C, &1E
 EQUB &21, &24, &27, &2A, &2C, &2F, &32, &32, &35, &2E, &27, &1F
 EQUB &18, &10, &08, &00, &F8, &F0, &EB, &E6, &E1, &DC, &D8, &D3
 EQUB &CF, &CB, &C7, &C3, &BF, &BC, &B9, &B6, &B3, &B1, &AF, &AD
 EQUB &AD, &AE, &B0, &B1, &B3, &B5, &B7, &B9, &BC, &BE, &C1, &C4
 EQUB &C6, &C9, &CD, &D0, &D3, &D3, &D3, &D3, &D3, &D3, &D3, &D3
 EQUB &D3, &CF, &CB, &C7, &C3, &C0, &BD, &BA, &B7, &B4, &B2, &B1
 EQUB &AF, &AE, &AD, &AD, &AC, &AB, &AA, &AA, &A9, &A9, &A9, &A9
 EQUB &A9, &A9, &A9, &A9, &A9, &AA, &AA, &AB, &AB, &AD, &AF, &B2
 EQUB &B5, &B8, &BB, &BF, &C4, &C4, &C7, &C9, &CD, &D0, &D3, &D6
 EQUB &DA, &DD, &E1, &E4, &E8, &EC, &F0, &F3, &F7, &FB, &FF, &02
 EQUB &06, &0A, &0D, &11, &15, &19, &1C, &20, &23, &27, &2A, &2E
 EQUB &31, &34, &37, &37, &34, &31, &2F, &2C, &28, &25, &22, &1F
 EQUB &1B, &18, &15, &11, &0E, &0A, &07, &03, &00, &FD, &FD, &32

\ trackData+1536 = 5900

 EQUB &30

\ trackData+1537 = 5901

 EQUB &20

\ trackData+1538 = 5902

 EQUB &80

\ trackData+1539 = 5903

 EQUB &A0

\ trackData+1540 = 5904

 EQUB &C0

\ trackData+1541 = 5905

 EQUB &00

\ trackData+1542 = 5906

 EQUB &94

\ trackData+1543 = 5907

 EQUB &63

 EQUB &AD, &94, &80, &08
 EQUB &34, &01, &FC, &15, &33, &25, &80, &96, &C5, &16, &E8, &0C
 EQUB &2D, &B2, &80, &91, &56, &22, &C9, &15, &32, &AF, &80, &4F
 EQUB &9F, &37, &AE, &69, &AD, &E7, &80, &5C, &D7, &38, &BB, &18
 EQUB &02, &D8, &CB, &09, &37, &50, &17, &1C, &01, &64, &53, &E9
 EQUB &C3, &51, &F7, &09, &28, &91, &77, &B1, &F0, &5A, &BF, &36
 EQUB &33, &9F, &9F, &61, &FE, &5B, &6F, &10, &00, &FA, &5F, &5D
 EQUB &1B, &6B, &25, &26, &30, &12, &C7, &AB, &33, &6C, &73, &1B
 EQUB &AD, &C5, &5B, &8B, &DD, &6D, &5F, &1B, &2A, &65, &4D, &7E
 EQUB &D3, &88, &2F, &28, &33, &95, &4D, &8E, &03, &89, &3F, &10
 EQUB &00, &D8, &0D, &FA, &05, &99, &44, &87, &01, &26, &D5, &A9
 EQUB &53, &9A, &F3, &06, &30, &B2, &F7, &3F, &DF, &A0, &89, &1C
 EQUB &AD, &EA, &9B, &FB, &17, &A1, &45, &28, &32, &49, &64, &A2
 EQUB &4A, &C9, &AE, &68, &AD, &91, &F4, &FA, &92, &CA, &06, &21
 EQUB &2A, &03, &3E, &1E, &F2, &EB, &FC, &55, &33, &3F, &90, &FF
 EQUB &2E, &EC, &DD, &12, &04, &DE, &7D, &D2, &7E, &FE, &C5, &26
 EQUB &30, &20, &80, &A0, &C0, &00, &94, &63, &64, &F0, &00, &00
 EQUB &48, &00, &50, &52

\ trackData+1744 = 59D0
\
\ Next 24 bytes are copied to L5FB0
\ Bit 0 -> bit 7 of result
\ Bit 1 clear -> result is scaled by U
\ See sub_C44C6

 EQUB &14, &33, &72, &3B, &18, &33, &15, &15
 EQUB &15, &3C, &18, &30, &33, &39, &38, &14, &14, &14, &37, &20
 EQUB &59, &2B, &54, &14, &14, &67

\ trackData+1770 = 59EA

 EQUB &03, &10, &19, &2C, &38, &4D
 EQUB &64, &75, &70, &70, &94, &98, &A4, &A8, &B5, &B8

\ trackData+1786 = 59FA

 EQUB &C0

\ trackData+1787 = 59FB

 EQUB &FF

\ trackData+1788 = 59FC

 EQUB &00

\ trackData+1789 = 59FD

 EQUB &04

\ trackData+1790 = 59FE

 EQUB &4B

\ trackData+1791 = 59FF

 EQUB &03

\ trackData+1792 = 5A00
\ Race class adjuster: seconds
\ See MainLoop (Part 4 of 6)
\ If the slowest lap time is a human player, and it's slower than one of these
\ times, then we set the race class to the relevant difficulty

 EQUB 51                \ Set class to Novice if slowest lap time > 1:51
 EQUB 41                \ Set class to Amateur if slowest lap time > 1:41
 EQUB 0                 \ Otherwise set class to Professional

\ trackData+1795 = 5A03
\ See MainLoop (Part 4 of 6)
\ Race class adjuster: minutes

 EQUB 1                 \ Set class to Novice if slowest lap time > 1:51
 EQUB 1                 \ Set class to Amateur if slowest lap time > 1:41
 EQUB 0                 \ Otherwise set class to Professional

\ trackData+1798 = 5A06
\ Called "ratios" in car performance hack

 EQUB &67, &00, &67, &42, &35, &2E, &2A

\ trackData+1805 = 5A0D
\ Called "powers" in car performance hack

 EQUB &A1, &00, &A1, &68, &52, &48, &41

\ trackData+1812 = 5A14

 EQUB 134               \ Base speed for Novice
 EQUB 146               \ Base speed for Amateur
 EQUB 152               \ Base speed for Professional

\ trackData+1815 = 5A17

 EQUB &04

\ trackData+1816 = 5A18

 EQUB &28

\ trackData+1817 = 5A19

 EQUB &18

\ trackData+1818 = 5A1A

 EQUB &00, &73, &6F, &31, &00, &8C, &00, &00

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

 EQUS "REVS"         \ Game name

 EQUS "Silverstone"  \ Track name
 EQUB 13

\ ******************************************************************************
\
\ Save Silvers.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/Silvers.bin", CODE%, P%

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
\ https://revs.bbcelite.com/about_site/terminology_used_in_this_commentary.html
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
\ REVS SNETTERTON TRACK
\
\ Produces the binary file Snetterton.bin that contains the Snetterton track.
\
\ ******************************************************************************

ORG CODE%

.trackData

 EQUB &63, &D1, &14, &D1, &D0, &FF, &D1, &FF
 EQUB &73, &D0, &14, &DE, &CF, &FF, &DE, &FF
 EQUB &83, &D0, &14, &FE, &CF, &1C, &FE, &7E
 EQUB &93, &D0, &11, &0F, &CF, &1A, &0F, &08
 EQUB &93, &CC, &11, &16, &CC, &09, &15, &52
 EQUB &A3, &C9, &11, &18, &C8, &10, &17, &0B
 EQUB &A3, &C8, &11, &1B, &C7, &1F, &1B, &76
 EQUB &B3, &CF, &11, &2B, &CE, &1E, &2B, &10
 EQUB &B3, &D5, &11, &2F, &D5, &FF, &2F, &FF
 EQUB &B3, &DD, &12, &2E, &DD, &0E, &2E, &91
 EQUB &C5, &E5, &13, &2C, &E5, &3C, &2D, &20
 EQUB &D5, &EF, &11, &19, &F0, &FF, &19, &FF
 EQUB &E4, &EA, &0E, &0C, &EB, &0F, &0C, &91
 EQUB &F3, &E8, &0D, &FF, &E9, &1A, &FF, &06
 EQUB &F3, &EA, &0C, &F7, &EB, &15, &F8, &0C
 EQUB &03, &EC, &0C, &F4, &ED, &FF, &F4, &FF
 EQUB &03, &EE, &10, &E0, &EF, &FF, &E0, &FF
 EQUB &13, &F1, &13, &C7, &F2, &1C, &C7, &8C
 EQUB &23, &F3, &13, &B7, &F4, &2A, &B7, &0E
 EQUB &33, &EA, &13, &AD, &EA, &FF, &AC, &FF
 EQUB &33, &DF, &13, &AC, &DF, &14, &AB, &57
 EQUB &43, &D3, &13, &AB, &D3, &13, &AA, &0B
 EQUB &43, &D1, &13, &AD, &D0, &FF, &AD, &81
 EQUB &53, &D1, &13, &BE, &D0, &FF, &BE, &FF
 EQUB &C1, &05, &15, &0A, &06, &FF, &09, &FF
 EQUB &85, &75, &A9, &CD, &4C, &00, &0C, &98
 EQUB &20, &00, &0C, &85, &75, &20, &00, &0C
 EQUB &06, &74, &2A, &60, &A5, &44, &20, &50
 EQUB &34, &C9, &19, &B0, &07, &A5, &0D, &10
 EQUB &03, &46, &76, &60, &4C, &33, &19, &7F
 EQUB &85, &75, &A9, &CD, &4C, &00, &0C, &00
 EQUB &00, &2C, &00, &00, &00, &00, &00, &00

\ &5400

\ modAddrLo
 EQUB &49, &8A, &CA, &27, &FC, &1B, &8C, &39
 EQUB &94, &D1, &C9, &C1, &D6, &D7, &E1, &47
 EQUB &F3, &2C, &43, &24

\ &5414

\ modAddrHi
 EQUB &12, &12, &13, &14, &12, &26, &24, &25
 EQUB &15, &4C, &4C, &4C, &44, &4C, &4C, &19
 EQUB &24, &46, &25, &2F

 EQUB &FF, &00, &00, &00, &00, &00, &FD, &FE
 EQUB &FD, &00, &13, &05, &01, &00, &02, &02
 EQUB &02, &04, &00, &01, &01, &01, &01, &00
 EQUB &FF, &FF, &00, &00, &FD, &02, &03, &00
 EQUB &00, &00, &00, &00, &00, &04, &02, &01
 EQUB &02, &00, &07, &00, &05, &FC, &FB, &00
 EQUB &00, &00, &00, &05, &02, &02, &00, &01
 EQUB &00, &00, &81, &94, &90, &AC, &B0, &B8
 EQUB &00, &08, &1D, &24, &3C, &54, &50, &58
 EQUB &6D, &70, &AD, &FA, &53, &0A, &AD, &FB
 EQUB &53, &2A, &48, &2A, &2A, &2A, &29, &07
 EQUB &85, &75, &4A, &68, &29, &3F, &90, &04
 EQUB &49, &3F, &69, &00, &AA, &BC, &BF, &57
 EQUB &BD, &BF, &58, &AA, &A5, &75, &18, &69
 EQUB &01, &29, &02, &D0, &06, &84, &76, &86
 EQUB &77, &F0, &04, &86, &76, &84, &77, &A5
 EQUB &75, &C9, &04, &90, &06, &A9, &00, &E5
 EQUB &76, &85, &76, &A5, &75, &C9, &06, &B0
 EQUB &0A, &C9, &02, &90, &06, &A9, &00, &E5
 EQUB &77, &85, &77, &A4, &02, &A9, &84, &85
 EQUB &75, &A5, &76, &99, &00, &54, &20, &EB
 EQUB &54, &99, &00, &58, &A5, &77, &99, &00
 EQUB &56, &20, &EB, &54, &49, &FF, &18, &69
 EQUB &01, &99, &00, &57, &AD, &FC, &53, &99
 EQUB &00, &55, &60, &08, &4C, &1B, &46, &A5
 EQUB &01, &29, &40, &F0, &03, &20, &82, &55
 EQUB &A5, &24, &18, &69, &03, &60, &03, &60

\ &5500

\ Value to poke into modAddr
 EQUB &72, &1B, &72, &72, &EF, &AF, &BC, &72
 EQUB &A1, &62, &62, &62, &A0, &62, &62, &C8
 EQUB &BD, &C1, &C8, &E8

\ &5514

\ Value to poke into modAddr+1
 EQUB &56, &5A, &55, &55
 EQUB &54, &56, &56, &57, &57, &55, &56, &57
 EQUB &58, &54, &54, &56, &55, &59, &53, &59

 EQUB &77, &00, &72, &00, &00, &00, &02, &8C
 EQUB &28, &00, &33, &F6, &E5, &00, &DE, &DE
 EQUB &DE, &44, &00, &F5, &5F, &4A, &4A, &00
 EQUB &4F, &4F, &62, &00, &A8, &6B, &92, &63
 EQUB &00, &00, &00, &00, &00, &FA, &04, &23
 EQUB &C1, &00, &9B, &00, &7A, &BB, &F8, &00
 EQUB &00, &00, &00, &55, &11, &11, &60, &B0
 EQUB &78, &20, &04, &FD, &FC, &3D, &01, &FB
 EQUB &00, &F9, &01, &F1, &EB, &E3, &20, &0A
 EQUB &07, &03, &A5, &01, &29, &40, &F0, &06
 EQUB &20, &E0, &13, &20, &C4, &55, &60, &20
 EQUB &E0, &13, &AC, &F8, &53, &AD, &FD, &53
 EQUB &38, &24, &25, &30, &13, &69, &00, &D9
 EQUB &28, &57, &90, &22, &A9, &00, &C8, &CC
 EQUB &F9, &53, &90, &1A, &A0, &00, &F0, &16
 EQUB &E9, &01, &B0, &12, &98, &29, &7F, &A8
 EQUB &C0, &01, &B0, &03, &AC, &F9, &53, &88
 EQUB &B9, &28, &57, &38, &E9, &01, &8D, &FD
 EQUB &53, &8C, &F8, &53, &60, &24, &43, &30
 EQUB &FB, &4C, &0B, &14, &86, &45, &AC, &F8
 EQUB &53, &30, &2F, &B9, &28, &55, &85, &74
 EQUB &B9, &28, &54, &24, &25, &20, &40, &0E
 EQUB &85, &75, &A5, &74, &18, &6D, &FA, &53
 EQUB &8D, &FA, &53, &A5, &75, &6D, &FB, &53
 EQUB &8D, &FB, &53, &B9, &28, &56, &24, &25
 EQUB &20, &50, &34, &18, &6D, &FC, &53, &8D
 EQUB &FC, &53, &20, &72, &54, &A6, &45, &60

\ &5600

 LDA #&20
 STA &2F23
 LDA #&00
 STA &231B
 LDA #&C7
 STA &45CC
 LDA #&59
 STA &45CD
 LDA #&4B
 STA &2772
 LDA #&A9
 STA &1310
 LDA #&10
 STA &1311
 RTS

\ EQUB &A9, &20, &8D, &23, &2F, &A9, &00, &8D
\ EQUB &1B, &23, &A9, &C7, &8D, &CC, &45, &A9
\ EQUB &59, &8D, &CD, &45, &A9, &4B, &8D, &72
\ EQUB &27, &A9, &A9, &8D, &10, &13, &A9, &10
\ EQUB &8D, &11, &13, &60

 EQUB &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &FD, &00, &03, &00
 EQUB &00, &00, &00, &00, &00, &00, &F4, &04
 EQUB &0A, &FB, &00, &FF, &FF, &FF, &FF, &01
 EQUB &00, &00, &00, &01, &00, &01, &01, &02
 EQUB &00, &00, &FF, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &FD, &01, &03, &00
 EQUB &FE, &00, &01, &FC, &FC, &03, &03, &FC
 EQUB &FE, &01, &08, &08, &08, &08, &08, &08
 EQUB &08, &08, &30, &08, &08, &F8, &12, &1C
 EQUB &20, &08, &84, &1B, &B9, &05, &59, &85
 EQUB &02, &98, &4A, &4A, &4A, &A8, &B9, &46
 EQUB &58, &8D, &FA, &53, &B9, &64, &58, &8D
 EQUB &FB, &53, &B9, &28, &58, &8D, &FC, &53
 EQUB &B9, &82, &58, &4A, &6A, &8D, &F8, &53
 EQUB &A9, &0E, &6A, &8D, &B3, &23, &A9, &00
 EQUB &8D, &FD, &53, &24, &25, &30, &03, &20
 EQUB &C4, &55, &A4, &1B, &A5, &02, &60, &48
 EQUB &A5, &42, &C9, &0C, &68, &B0, &04, &85
 EQUB &1F, &84, &51, &60, &90, &07, &A5, &42
 EQUB &C9, &0A, &90, &01, &60, &4C, &90, &24
 EQUB &98, &29, &20, &85, &82, &A9, &00, &85
 EQUB &7F, &88, &B9, &20, &5F, &C5, &1F, &B0
 EQUB &1E, &C5, &7F, &B0, &F2, &A5, &7F, &69
 EQUB &00, &99, &20, &5F, &A5, &82, &D0, &E9
 EQUB &A5, &7F, &8D, &EA, &1F, &C8, &20, &3B
 EQUB &25, &88, &38, &66, &82, &30, &DA, &A4
 EQUB &4B, &88, &84, &75, &4C, &DC, &53, &00

\ &5700

 LDX #&13

.L5702

 LDA &5414,X
 STA &75
 LDA &5400,X
 STA &74
 LDY #&00
 LDA &5500,X
 STA (&74),Y
 INY
 LDA &5514,X
 STA (&74),Y
 DEX
 BPL L5702
 LDA #&4C
 STA &261A
 STA &248B
 JMP &5800

\ EQUB &A2, &13, &BD, &14, &54, &85, &75, &BD
\ EQUB &00, &54, &85, &74, &A0, &00, &BD, &00
\ EQUB &55, &91, &74, &C8, &BD, &14, &55, &91
\ EQUB &74, &CA, &10, &E6, &A9, &4C, &8D, &1A
\ EQUB &26, &8D, &8B, &24, &4C, &00, &58

 EQUB &00
 EQUB &02, &1B, &02, &41, &06, &20, &06, &06
 EQUB &04, &03, &02, &02, &03, &23, &03, &03
 EQUB &06, &04, &12, &08, &18, &0A, &0A, &15
 EQUB &09, &09, &0D, &07, &11, &05, &03, &0C
 EQUB &1F, &1E, &18, &0E, &15, &03, &06, &0D
 EQUB &08, &19, &09, &28, &05, &05, &0C, &0F
 EQUB &15, &23, &16, &03, &0E, &08, &13, &08
 EQUB &11, &22, &00, &44, &E9, &02, &1B, &12
 EQUB &1A, &1B, &B3, &05, &DE, &09, &F3, &10
 EQUB &32, &FB, &8D, &EA, &1F, &99, &48, &5F
 EQUB &B9, &40, &5E, &38, &F9, &68, &5E, &B9
 EQUB &90, &5E, &F9, &B8, &5E, &10, &0C, &B9
 EQUB &40, &5E, &99, &68, &5E, &B9, &90, &5E
 EQUB &99, &B8, &5E, &B9, &20, &5F, &99, &48
 EQUB &5F, &C8, &C0, &09, &90, &DA, &A4, &51
 EQUB &60, &A4, &6F, &B9, &E8, &06, &C9, &28
 EQUB &D0, &0F, &B9, &80, &08, &C9, &02, &90
 EQUB &03, &4E, &FB, &62, &A0, &DC, &4C, &CF
 EQUB &53, &4C, &D6, &59, &4C, &1B, &46, &00
 EQUB &01, &03, &04, &06, &07, &09, &0A, &0C
 EQUB &0D, &0F, &10, &12, &13, &15, &16, &17
 EQUB &19, &1A, &1C, &1D, &1F, &20, &21, &23
 EQUB &24, &26, &27, &28, &2A, &2B, &2D, &2E
 EQUB &2F, &31, &32, &33, &35, &36, &37, &39
 EQUB &3A, &3B, &3C, &3E, &3F, &40, &41, &43
 EQUB &44, &45, &46, &47, &49, &4A, &4B, &4C
 EQUB &4D, &4E, &4F, &51, &52, &53, &54, &55

\ &5800

 LDA #&20
 STA &1248
 STA &12FB
 STA &2538
 STA &45CB
 LDA #&EA
 STA &2545
 LDA #&16
 STA &4F55
 STA &4F59
 LDA #&0D
 STA &24EA
 LDA #&A2
 STA &1FE9
 JMP &5600

\ EQUB &A9, &20, &8D, &48, &12, &8D, &FB, &12
\ EQUB &8D, &38, &25, &8D, &CB, &45, &A9, &EA
\ EQUB &8D, &45, &25, &A9, &16, &8D, &55, &4F
\ EQUB &8D, &59, &4F, &A9, &0D, &8D, &EA, &24
\ EQUB &A9, &A2, &8D, &E9, &1F, &4C, &00, &56

 EQUB &00, &00, &00, &EE, &00, &00, &00, &00
 EQUB &10, &10, &10, &DC, &F1, &F8, &F8, &00
 EQUB &18, &00, &00, &00, &00, &00, &00, &00
 EQUB &26, &FC, &12, &E6, &FF, &00, &00, &EE
 EQUB &D2, &D2, &C6, &C6, &18, &C7, &3F, &3F
 EQUB &3F, &97, &5E, &1F, &47, &14, &B8, &B8
 EQUB &B8, &8D, &8D, &8D, &00, &00, &B3, &B3
 EQUB &B3, &28, &C8, &00, &00, &FE, &FF, &FF
 EQUB &D9, &D9, &0C, &11, &45, &45, &45, &8F
 EQUB &89, &88, &60, &77, &7B, &7B, &7B, &BB
 EQUB &BB, &BB, &00, &00, &A1, &A1, &A1, &DF
 EQUB &F3, &00, &00, &08, &10, &18, &27, &26
 EQUB &32, &3A, &4B, &4A, &4E, &5E, &66, &72
 EQUB &76, &7E, &86, &8E, &96, &A7, &A6, &AA
 EQUB &AF, &AE, &BC, &C4, &CE, &DA, &E2, &00
 EQUB &00, &19, &19, &2E, &00, &57, &18, &3F
 EQUB &18, &18, &3D, &19, &19, &64, &BD, &24
 EQUB &18, &18, &6B, &18, &18, &57, &19, &00
 EQUB &00, &18, &4B, &18, &18, &18, &00, &78
 EQUB &78, &78, &78, &78, &78, &78, &78, &77
 EQUB &77, &77, &77, &77, &76, &76, &76, &76
 EQUB &75, &75, &75, &74, &74, &74, &73, &73
 EQUB &72, &72, &71, &71, &70, &70, &6F, &6F
 EQUB &6E, &6E, &6D, &6C, &6C, &6B, &6B, &6A
 EQUB &69, &68, &68, &67, &66, &65, &65, &64
 EQUB &63, &62, &61, &60, &60, &5F, &5E, &5D
 EQUB &5C, &5B, &5A, &59, &58, &57, &56, &55

\ &5900

 EQUB &40, &20, &00, &20, &28, &01, &20, &1D
 EQUB &40, &AD, &00, &B8, &B5, &1F, &AF, &43
 EQUB &68, &68, &00, &20, &70, &13, &1D, &26
 EQUB &F3, &42, &81, &F0, &4A, &12, &ED, &10
 EQUB &00, &97, &54, &3B, &06, &23, &72, &09
 EQUB &ED, &2E, &54, &B1, &9D, &25, &E8, &07
 EQUB &72, &09, &54, &50, &1B, &05, &98, &26
 EQUB &ED, &65, &54, &84, &84, &04, &EB, &10
 EQUB &02, &7E, &58, &07, &9C, &15, &FC, &11
 EQUB &70, &65, &68, &08, &83, &17, &FD, &12
 EQUB &ED, &C3, &88, &FA, &E1, &02, &EF, &34
 EQUB &40, &26, &66, &C9, &0A, &0F, &6C, &1E
 EQUB &68, &3F, &D2, &A6, &30, &06, &70, &1D
 EQUB &F3, &33, &3B, &38, &26, &25, &08, &11
 EQUB &ED, &A5, &B3, &F7, &54, &10, &A6, &08
 EQUB &C0, &67, &97, &B6, &58, &1A, &EB, &2B
 EQUB &40, &E5, &1B, &C2, &DA, &1F, &DC, &36
 EQUB &70, &A3, &FF, &A8, &98, &07, &C2, &23
 EQUB &ED, &6A, &FF, &63, &5F, &04, &7D, &1E
 EQUB &02, &76, &FF, &BC, &90, &24, &C6, &18
 EQUB &70, &4E, &FF, &84, &68, &27, &8E, &19
 EQUB &ED, &AF, &FF, &3F, &C9, &1A, &49, &09
 EQUB &02, &20, &FF, &FA, &28, &25, &FA, &23
 EQUB &C0, &20, &FF, &62, &28, &00, &62, &28
 EQUB &40, &45, &25, &20, &50, &34, &60, &D0
 EQUB &09, &A5, &63, &20, &10, &46, &10, &02
 EQUB &C6, &77, &0A, &26, &77, &60, &A0, &B5
 EQUB &C9, &A0, &F0, &07, &C9, &A8, &D0, &05
 EQUB &4E, &FB, &62, &A0, &C3, &4C, &CF, &53
 EQUB &B9, &61, &5F, &C9, &8B, &F0, &04, &B9
 EQUB &60, &5F, &60, &4A, &60, &26, &77, &60
 EQUB &00, &00, &C0, &28, &AE, &02, &FC, &00

\ &5A00

 EQUB &09, &05, &00, &01, &01, &00, &68, &00
 EQUB &68, &45, &35, &2F, &2A, &A1, &00, &A1
 EQUB &6A, &52, &48, &41, &86, &92, &98, &08
 EQUB &21, &2D, &00, &20, &7F, &55, &4C, &72
 EQUB &54, &00

.CallTrackHook

 JMP &5700

.trackChecksum

 EQUB &A6, &C2, &3E, &7F

 EQUS "REVS"            \ Game name

 EQUS "Snetterton"      \ Track name
 EQUB 13

 EQUB &0D, &72, &6B, &0D, &22, &20, &42, &52
 EQUB &41, &4E, &44, &53, &20, &48, &41, &54
 EQUB &43, &48, &22, &2C, &22, &20, &44, &4F
 EQUB &4E, &49, &4E, &47, &54, &4F, &4E, &20
 EQUB &50, &41, &52, &4B, &22, &2C, &22, &20
 EQUB &4F, &55, &4C, &54, &4F, &4E, &20, &50
 EQUB &41, &52, &4B, &20, &20, &20, &22, &2C
 EQUB &22, &20, &53, &4E, &45, &54, &54, &45
 EQUB &52, &54, &4F, &4E, &20, &20, &20, &20
 EQUB &22, &0D, &04, &06, &0A, &20, &DC, &22
 EQUB &22, &20, &20, &0D, &04, &10, &24, &20
 EQUB &F4, &20, &50, &72, &6F, &67, &72, &61
 EQUB &6D, &73, &20, &6F, &6E, &20, &74, &68
 EQUB &65, &20, &64, &69, &73, &63, &20, &6F
 EQUB &72, &20, &74, &61, &70, &65, &20, &0D
 EQUB &04, &1A, &11, &20, &DC, &42, &20, &2C
 EQUB &44, &20, &2C, &4F, &20, &2C, &53, &20
 EQUB &0D, &04, &24, &0E, &20, &DC, &22, &22
 EQUB &20, &20, &20, &20, &20, &20, &0D, &FF

\ ******************************************************************************
\
\ Save Snetterton.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/Snetterton.bin", CODE%, P%

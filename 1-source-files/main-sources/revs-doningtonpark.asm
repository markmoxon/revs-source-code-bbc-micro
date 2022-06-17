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

 EQUB &D3, &D1, &1E, &D1, &D0, &FF, &D1, &FF
 EQUB &E1, &D1, &1C, &F6, &D0, &3F, &F6, &51
 EQUB &F3, &D1, &19, &15, &D0, &08, &15, &00
 EQUB &F2, &D3, &19, &18, &D3, &12, &19, &0A
 EQUB &04, &D7, &19, &1B, &D6, &FF, &1B, &FF
 EQUB &13, &DB, &15, &3E, &DA, &2D, &3E, &5B
 EQUB &23, &DE, &14, &54, &DD, &19, &55, &0F
 EQUB &23, &E3, &14, &57, &E3, &FF, &58, &8A
 EQUB &35, &ED, &14, &50, &ED, &FF, &51, &FF
 EQUB &45, &F5, &0D, &39, &F6, &06, &39, &FF
 EQUB &55, &F4, &0B, &31, &F5, &1E, &31, &0A
 EQUB &54, &F5, &09, &2A, &F6, &23, &2B, &78
 EQUB &64, &FE, &06, &19, &FF, &13, &1A, &0D
 EQUB &64, &FD, &06, &16, &FE, &20, &16, &FF
 EQUB &73, &EF, &09, &05, &F0, &1D, &05, &0E
 EQUB &73, &EE, &09, &03, &EF, &FF, &03, &FF
 EQUB &73, &ED, &0D, &F8, &EE, &0E, &F8, &FF
 EQUB &83, &ED, &11, &EA, &EE, &21, &EB, &00
 EQUB &83, &F0, &14, &E3, &F1, &0F, &E3, &72
 EQUB &93, &F5, &17, &DB, &F6, &1B, &DB, &11
 EQUB &A3, &F3, &18, &D5, &F4, &FF, &D5, &FF
 EQUB &A3, &EA, &1A, &CF, &EA, &1B, &CE, &6F
 EQUB &B3, &DC, &1E, &C5, &DC, &12, &C4, &08
 EQUB &B3, &DA, &1E, &C5, &D9, &06, &C4, &76
 EQUB &C3, &D7, &1E, &C6, &D6, &25, &C5, &0E
 EQUB &03, &CF, &14, &BB, &CE, &FF, &BC, &FF
 EQUB &85, &75, &A9, &CD, &4C, &00, &0C, &45
 EQUB &25, &4C, &50, &34, &98, &20, &00, &0C
 EQUB &85, &75, &20, &00, &0C, &06, &74, &2A
 EQUB &60, &C9, &0B, &B0, &03, &20, &F3, &12
 EQUB &4C, &F3, &12, &8D, &55, &4F, &8D, &59
 EQUB &4F, &60, &00, &3A, &00, &00, &00, &00

\ &5400

 EQUB &49, &8A, &CA, &27, &FC, &1B, &8C, &39
 EQUB &94, &D1, &C9, &C1, &D6, &D7, &E1, &47
 EQUB &F3, &2C, &43, &24, &12, &12, &13, &14
 EQUB &12, &26, &24, &25, &15, &4C, &4C, &4C
 EQUB &44, &4C, &4C, &19, &24, &46, &25, &2F
 EQUB &00, &00, &00, &00, &00, &00, &10, &03
 EQUB &FE, &FA, &00, &00, &00, &00, &00, &01
 EQUB &02, &05, &01, &00, &01, &01, &00, &00
 EQUB &00, &00, &00, &00, &FD, &FE, &00, &00
 EQUB &00, &01, &00, &06, &FC, &00, &00, &FE
 EQUB &FE, &FE, &00, &01, &02, &04, &04, &00
 EQUB &00, &00, &00, &00, &00, &07, &00, &02
 EQUB &01, &01, &21, &34, &40, &48, &55, &64
 EQUB &75, &8D, &9C, &A0, &B4, &C0, &00, &08
 EQUB &13, &10, &AD, &FC, &53, &0A, &AD, &FD
 EQUB &53, &2A, &48, &2A, &2A, &2A, &29, &07
 EQUB &85, &75, &4A, &68, &29, &3F, &90, &04
 EQUB &49, &3F, &69, &00, &AA, &BC, &BF, &57
 EQUB &BD, &BF, &58, &AA, &A5, &75, &18, &69
 EQUB &01, &29, &02, &D0, &06, &84, &76, &86
 EQUB &77, &F0, &04, &86, &76, &84, &77, &A5
 EQUB &75, &C9, &04, &90, &06, &A9, &00, &E5
 EQUB &76, &85, &76, &A5, &75, &C9, &06, &B0
 EQUB &0A, &C9, &02, &90, &06, &A9, &00, &E5
 EQUB &77, &85, &77, &A4, &02, &A9, &86, &85
 EQUB &75, &A5, &76, &99, &00, &54, &20, &EB
 EQUB &54, &99, &00, &58, &A5, &77, &99, &00
 EQUB &56, &20, &EB, &54, &49, &FF, &18, &69
 EQUB &01, &99, &00, &57, &AD, &FE, &53, &99
 EQUB &00, &55, &60, &08, &4C, &1B, &46, &A5
 EQUB &01, &29, &40, &F0, &03, &20, &82, &55
 EQUB &A5, &24, &18, &69, &03, &60, &03, &60

\ &5500

 EQUB &72, &1B, &72, &72, &EF, &AF, &BC, &72
 EQUB &79, &62, &62, &62, &A0, &62, &62, &C8
 EQUB &BD, &D7, &B6, &ED, &56, &5A, &55, &55
 EQUB &54, &56, &56, &57, &57, &55, &56, &57
 EQUB &58, &54, &54, &56, &55, &53, &57, &59
 EQUB &00, &00, &00, &00, &00, &00, &4B, &71
 EQUB &94, &73, &00, &00, &00, &00, &A9, &C7
 EQUB &94, &88, &83, &00, &53, &6E, &B6, &AD
 EQUB &B2, &FD, &00, &00, &DE, &46, &00, &00
 EQUB &00, &3F, &00, &05, &9F, &00, &00, &C1
 EQUB &2A, &D8, &5B, &66, &72, &BE, &4B, &00
 EQUB &00, &00, &00, &00, &00, &DD, &BC, &24
 EQUB &62, &A4, &04, &F1, &F4, &FE, &05, &EF
 EQUB &21, &FE, &F6, &05, &42, &07, &02, &01
 EQUB &FB, &05, &A5, &01, &29, &40, &F0, &06
 EQUB &20, &E0, &13, &20, &C4, &55, &60, &20
 EQUB &E0, &13, &AC, &FA, &53, &AD, &FF, &53
 EQUB &38, &24, &25, &30, &13, &69, &00, &D9
 EQUB &28, &57, &90, &22, &A9, &00, &C8, &CC
 EQUB &FB, &53, &90, &1A, &A0, &00, &F0, &16
 EQUB &E9, &01, &B0, &12, &98, &29, &7F, &A8
 EQUB &C0, &01, &B0, &03, &AC, &FB, &53, &88
 EQUB &B9, &28, &57, &38, &E9, &01, &8D, &FF
 EQUB &53, &8C, &FA, &53, &60, &24, &43, &30
 EQUB &FB, &4C, &0B, &14, &86, &45, &AC, &FA
 EQUB &53, &30, &2F, &B9, &28, &55, &85, &74
 EQUB &B9, &28, &54, &24, &25, &20, &40, &0E
 EQUB &85, &75, &A5, &74, &18, &6D, &FC, &53
 EQUB &8D, &FC, &53, &A5, &75, &6D, &FD, &53
 EQUB &8D, &FD, &53, &B9, &28, &56, &24, &25
 EQUB &20, &50, &34, &18, &6D, &FE, &53, &8D
 EQUB &FE, &53, &20, &72, &54, &A6, &45, &60

\ &5600

 EQUB &A9, &E9, &8D, &DF, &24, &A9, &53, &8D
 EQUB &E0, &24, &A9, &C9, &8D, &CC, &45, &A9
 EQUB &59, &8D, &CD, &45, &A9, &4B, &8D, &72
 EQUB &27, &A9, &A9, &8D, &10, &13, &A9, &88
 EQUB &8D, &11, &13, &A9, &16, &4C, &F3, &53
 EQUB &FA, &01, &FE, &02, &00, &00, &00, &00
 EQUB &00, &00, &FF, &00, &01, &00, &00, &00
 EQUB &00, &00, &00, &00, &FF, &FE, &FE, &FF
 EQUB &00, &00, &00, &01, &00, &00, &00, &02
 EQUB &00, &00, &00, &04, &00, &02, &00, &00
 EQUB &00, &FF, &00, &00, &00, &FF, &FF, &FF
 EQUB &00, &02, &00, &FD, &FF, &FF, &00, &00
 EQUB &00, &00, &E6, &09, &08, &56, &34, &1D
 EQUB &EC, &CC, &E8, &08, &C2, &0D, &08, &0B
 EQUB &22, &08, &84, &1B, &B9, &05, &59, &85
 EQUB &02, &98, &4A, &4A, &4A, &A8, &B9, &46
 EQUB &58, &8D, &FC, &53, &B9, &64, &58, &8D
 EQUB &FD, &53, &B9, &28, &58, &8D, &FE, &53
 EQUB &B9, &82, &58, &4A, &6A, &8D, &FA, &53
 EQUB &A9, &0E, &6A, &8D, &B3, &23, &A9, &00
 EQUB &8D, &FF, &53, &24, &25, &30, &03, &20
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
 EQUB &4B, &88, &84, &75, &4C, &33, &19, &00

\ &5700

 EQUB &A2, &13, &BD, &14, &54, &85, &75, &BD
 EQUB &00, &54, &85, &74, &A0, &00, &BD, &00
 EQUB &55, &91, &74, &C8, &BD, &14, &55, &91
 EQUB &74, &CA, &10, &E6, &A9, &4C, &8D, &1A
 EQUB &26, &8D, &8B, &24, &4C, &00, &58, &00
 EQUB &04, &14, &0B, &0F, &11, &03, &03, &03
 EQUB &03, &09, &10, &3A, &10, &16, &07, &04
 EQUB &04, &09, &08, &12, &04, &05, &0A, &08
 EQUB &12, &09, &0A, &08, &08, &07, &06, &0B
 EQUB &03, &06, &0F, &07, &06, &0E, &03, &07
 EQUB &06, &0C, &0C, &08, &04, &03, &06, &02
 EQUB &17, &0C, &06, &0D, &05, &05, &07, &05
 EQUB &09, &0D, &4F, &B6, &0E, &39, &21, &31
 EQUB &2A, &29, &1D, &FC, &29, &F6, &FC, &D6
 EQUB &B5, &FE, &8D, &EA, &1F, &99, &48, &5F
 EQUB &60, &A4, &6F, &B9, &E8, &06, &C9, &10
 EQUB &D0, &0F, &B9, &80, &08, &C9, &02, &90
 EQUB &03, &4E, &FB, &62, &A0, &D7, &4C, &DC
 EQUB &53, &48, &C9, &58, &D0, &04, &A9, &27
 EQUB &D0, &06, &C9, &A8, &D0, &09, &A9, &21
 EQUB &D9, &80, &08, &90, &0A, &B0, &0B, &C9
 EQUB &60, &F0, &04, &C9, &B0, &D0, &03, &4E
 EQUB &FB, &62, &68, &4C, &D8, &59, &20, &50
 EQUB &34, &4C, &D0, &53, &4C, &EF, &53, &00
 EQUB &01, &03, &04, &06, &07, &09, &0A, &0C
 EQUB &0D, &0F, &10, &12, &13, &15, &16, &17
 EQUB &19, &1A, &1C, &1D, &1F, &20, &21, &23
 EQUB &24, &26, &27, &28, &2A, &2B, &2D, &2E
 EQUB &2F, &31, &32, &33, &35, &36, &37, &39
 EQUB &3A, &3B, &3C, &3E, &3F, &40, &41, &43
 EQUB &44, &45, &46, &47, &49, &4A, &4B, &4C
 EQUB &4D, &4E, &4F, &51, &52, &53, &54, &55

\ &5800

 EQUB &A9, &20, &8D, &48, &12, &8D, &FB, &12
 EQUB &8D, &38, &25, &8D, &CB, &45, &8D, &23
 EQUB &2F, &A9, &EA, &8D, &45, &25, &A9, &0D
 EQUB &8D, &EA, &24, &A9, &A2, &8D, &E9, &1F
 EQUB &A9, &00, &8D, &1B, &23, &4C, &00, &56
 EQUB &FC, &FC, &00, &00, &00, &F0, &00, &00
 EQUB &00, &D6, &DE, &DE, &F4, &10, &10, &10
 EQUB &2C, &2C, &20, &20, &17, &15, &01, &FC
 EQUB &FC, &F9, &E9, &E6, &FF, &00, &00, &00
 EQUB &00, &34, &FB, &FB, &B6, &CE, &E6, &45
 EQUB &45, &1F, &99, &BC, &BC, &76, &BD, &BD
 EQUB &D9, &4D, &11, &11, &11, &62, &86, &96
 EQUB &8E, &28, &C8, &00, &00, &00, &00, &3B
 EQUB &04, &04, &10, &4C, &58, &87, &87, &6A
 EQUB &71, &9B, &9B, &87, &7E, &7E, &65, &75
 EQUB &A7, &A7, &A7, &CE, &D3, &11, &03, &DF
 EQUB &F3, &00, &01, &00, &14, &20, &28, &30
 EQUB &40, &48, &50, &68, &70, &78, &8C, &91
 EQUB &90, &94, &A1, &A0, &A8, &B0, &BC, &C4
 EQUB &D4, &D8, &DC, &DA, &DE, &DA, &E2, &00
 EQUB &18, &18, &47, &84, &18, &18, &47, &19
 EQUB &19, &19, &58, &20, &5F, &35, &58, &00
 EQUB &00, &58, &64, &3F, &18, &18, &53, &18
 EQUB &59, &18, &18, &18, &18, &18, &00, &78
 EQUB &78, &78, &78, &78, &78, &78, &78, &77
 EQUB &77, &77, &77, &77, &76, &76, &76, &76
 EQUB &75, &75, &75, &74, &74, &74, &73, &73
 EQUB &72, &72, &71, &71, &70, &70, &6F, &6F
 EQUB &6E, &6E, &6D, &6C, &6C, &6B, &6B, &6A
 EQUB &69, &68, &68, &67, &66, &65, &65, &64
 EQUB &63, &62, &61, &60, &60, &5F, &5E, &5D
 EQUB &5C, &5B, &5A, &59, &58, &57, &56, &55

\ &5900

 EQUB &00, &20, &00, &20, &24, &01, &20, &4F
 EQUB &70, &20, &C4, &28, &24, &03, &28, &43
 EQUB &ED, &20, &6C, &90, &24, &1F, &90, &09
 EQUB &73, &72, &6C, &33, &52, &01, &2C, &0C
 EQUB &44, &42, &6C, &9A, &48, &0E, &B5, &4A
 EQUB &70, &04, &44, &00, &0A, &09, &1B, &31
 EQUB &ED, &28, &CC, &A8, &41, &13, &0A, &0D
 EQUB &42, &02, &CC, &29, &4D, &21, &17, &1A
 EQUB &ED, &4C, &CC, &AD, &DA, &14, &7C, &36
 EQUB &68, &97, &F4, &E9, &8E, &23, &BD, &12
 EQUB &73, &1D, &24, &9D, &14, &0E, &71, &0F
 EQUB &70, &AB, &26, &E7, &82, &1E, &68, &29
 EQUB &ED, &29, &48, &BF, &13, &20, &16, &07
 EQUB &2A, &6F, &64, &B0, &33, &00, &12, &2E
 EQUB &73, &F5, &44, &CC, &B9, &02, &2E, &06
 EQUB &40, &EA, &A4, &37, &E1, &09, &0B, &18
 EQUB &28, &58, &0E, &1B, &53, &22, &23, &1C
 EQUB &73, &C8, &DE, &FB, &C3, &24, &03, &12
 EQUB &70, &F9, &A8, &4B, &C2, &0F, &E3, &14
 EQUB &ED, &83, &28, &2C, &75, &24, &6F, &0D
 EQUB &42, &B0, &9B, &CF, &40, &0B, &01, &19
 EQUB &70, &1E, &A9, &12, &AE, &26, &44, &24
 EQUB &ED, &56, &96, &5E, &E6, &24, &90, &05
 EQUB &42, &15, &8C, &47, &C1, &03, &5A, &07
 EQUB &ED, &17, &70, &9E, &A3, &0C, &BD, &1B
 EQUB &00, &D0, &09, &A5, &63, &20, &10, &46
 EQUB &10, &02, &C6, &77, &0A, &26, &77, &60
 EQUB &A0, &B5, &C9, &18, &D0, &02, &A0, &CD
 EQUB &C9, &30, &F0, &04, &C9, &28, &D0, &02
 EQUB &A0, &BC, &4C, &DC, &53, &B9, &61, &5F
 EQUB &C9, &8B, &F0, &04, &B9, &60, &5F, &60
 EQUB &4A, &60, &C8, &28, &CF, &02, &FE, &01

\ &5A00

 EQUB &17, &13, &00, &01, &01, &00, &68, &00
 EQUB &68, &45, &3C, &33, &2C, &A1, &00, &A1
 EQUB &6A, &5D, &4F, &45, &86, &92, &98, &04
 EQUB &21, &14, &00, &20, &7F, &55, &4C, &72
 EQUB &54, &00

.CallTrackHook

 JMP &5700

.trackChecksum

 EQUB &A8, &CD, &4B, &65

 EQUS "REVS"            \ Game name

 EQUS "Donington Park"  \ Track name
 EQUB 13

 EQUB &22, &20, &42, &52
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
\ Save DoningtonPark.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/DoningtonPark.bin", CODE%, P%

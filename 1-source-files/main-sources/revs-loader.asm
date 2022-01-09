\ ******************************************************************************
\
\ REVS LOADER SOURCE
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
\   * Revs1.bin
\
\ ******************************************************************************

GUARD &7C00             \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

LOAD% = &2000           \ The load address of the main code binary

CODE% = &2000           \ The address of the main game code

\ ******************************************************************************
\
\ REVS LOADER
\
\ Produces the binary file Revs1.bin that contains the game loader.
\
\ ******************************************************************************

osbyte_flush_buffer_class = &0F

L0000 = &0000
L0080 = &0080
L0100 = &0100
L0400 = &0400
L0500 = &0500
L0600 = &0600
L0700 = &0700
L0CFF = &0CFF
L0D00 = &0D00
crtc_horz_total = &FE00
crtc_horz_displayed = &FE01
osbyte = &FFF4
oscli = &FFF7

ORG CODE%

.Start
    LDA #&C9
    STA L0D00
    LDX #6
.loop_C2007
    LDA L20A8,X
    STA L0CFF,X
    DEX
    BNE loop_C2007
    LDA #4
    STA L0080
    LDX #0
    LDY #0
.C2018
    DEX
    BNE C2018
    DEY
    BNE C2018
    DEC L0080
    BNE C2018
    LDA #&0C
    JMP RunRevs

    LDA #osbyte_flush_buffer_class
    LDX #0
    LDY #0
    JSR osbyte
    LDA #&0B
    STA crtc_horz_total
    LDA #0
    STA crtc_horz_displayed
    SEI
    LDX #&FF
    TXS
    LDX #0
.C2040
    LDA L0000,X
    STA L0700,X
    LDA L20AF,X
    STA L0400,X
    LDA L21AF,X
    STA L0500,X
    LDA L22AF,X
    STA L0600,X
    LDA L23AF,X
    STA L0000,X
    LDA L24AF,X
    STA L0100,X
    INX
    BNE C2040
    JMP L0000

    EQUS "ACCESS SECURITY VIOLATION"
    EQUB &0A, &0D
    EQUS "Protected by Toby Butler & Tim Sorrel"
.L20A8
    EQUB &6C, &A9, &4E, &8D, 0  , &7C, &40
.L20AF
    EQUB &BB, &60, &C2, &CF, &12, &62, &FF, &E5, &92, 2  , &A7, &EF
    EQUB &86, &A5, &E2, &93, &F2, &41, &E2, &32, &92, &E3, 1  , &D5
    EQUB &67, &9D, &61, &74, &F2, &25, &6E, &FE, &27, &D1, &62, &B4
    EQUB &DE, &79, &B7, &47, &9E, &1F, &82, &F5, &7E, &BB, &22, &94
    EQUB &FD, &F7, &E2
    EQUS "1wR"
    EQUB &EF, &31, &1D, &B6, &86, &9F, &AF, &B5, &0E, &7F, &EF, &2F
    EQUB &C6, &97, &3A, &76, &99, &2F, &9E, &1F, &82, &F7, &F7, &8A
    EQUB &A3, &49, &6F, &8F, &44, &17, &A7, &E5, &22, &CF, &67, &6D
    EQUB &A7, &5A, &53, &FA, &26, &DF, 2  , &FF, &F2, &AB, &52, &7D
    EQUB &B7, &A1, &17, &2A, 3  , &2A, &D4, &6F, &40, &97, &17, &FD
    EQUB &B8, &C7, &AA, &23, &E1, &52, &36, &E1, &57, &98, &FE, &A7
    EQUB &AA, &A7, &89
    EQUS "v@", '"', "G"
    EQUB 1  , &C2, &56, &1E, &10, &1F, &86, &E7, &76, &9D, &1F
    EQUS "u6A"
    EQUB &A2, &C8, &81, &42, &D6, &FD, &D5, &CD
    EQUS "%OV"
    EQUB &17, &C6, &CD, &4F, &C5, &C6, &91, &F2, &B9, &31, &17, &2A
    EQUB 3  , &6A, &D1, &9F, &92, &8B, &F2, &56, &67, &1A, &13, &7A
    EQUB &E3, &EF, &82, &9B, 2  , &6A, &77, &0A, &23, &8A, &FF, &FF
    EQUB &F2, &AB, &12
    EQUS "xGz3"
    EQUB &9A, &0D, &5F, &EF, &9F, &92, &8B, &32, &55, &C2, &24, &A7
    EQUB &D0, &C7, &FA, &B3, &1A, &8B, &2A, &5E, &BA, &2E, &2F, &C2
    EQUB &DB, &42, &A2
    EQUS "'`Gz3"
    EQUB &9A, 9  , &5F, &CF, &9F, &92, &8B, &32, &55, &0E, &D0, &D2
    EQUB &F2, &37, &D5, &97, &AA, &83, &DF
    EQUS "_z,F"
.L21AF
    EQUB 0  , &3A, &F1, &0F, &FB, &56, &FE, &2F, &F6, &56, &FF, &7B
    EQUB &ED, &7B, &EA, &7B, &EB, &56, &9E, &DE, &CB, &F9, &4D, &B1
    EQUB &57, &E5, &98, &EE, &78, &EE, &54, &FD, &99, &E8, &79, &E8
    EQUB &55, &FC, &99, &E9, &79, &E9, &39, &F5, &6B, &EB, &2B, &E0
    EQUB &5E, &EF, &3E, &F6, &6B, &F2, &2A, &E9, &5F, &E9, &3F, &F6
    EQUB &4A, &F7, &70, &DA, &AA, &FF, &68, &EF
    EQUS "1)5"
    EQUB &1F, &EE
    EQUS ")1r"
    EQUB &BD, &FD, &7D, &FD, &D8, &CD, &FC, &7D, &F7, &B2, &F1, &72
    EQUB &F1, &D7, &C2, &F3, &BD, &72, &E7, &B2, &F2, &73, &F2, &EE
    EQUB &96, &D6, &C3, &F2, &73, &E7, &D6, &C0, &F1, &70, &E7, &57
    EQUB &F8, &40, &F6, &ED, &90, &E7, &71, &E7, &5D, &F4, &91, &E0
    EQUB &71, &E0, &3E, &24, 3  , &36, &E1, &23, &F7, &56, &E0, &36
    EQUB &E2, &93, &15, &EB
    EQUS "zjX"
    EQUB &1A, &22, &F0, &34, &E5, &CA, &54, &E6, &18, &F8, &E9, &94
    EQUB &F8, &74, &F8, &40, &E7, &61, &F8, &5D, &F8, &0E, &D9, &F1
    EQUB 0  , &F7, &5D, &F9, &11, &AA, &FE, &6A, &E9
    EQUS "g%?"
    EQUB 5  , &29, &E7, &28, &F9, &4B, &F9, &27, &E6, &3E, &0E, &8E
    EQUB &96, &4F, &ED, &44, &12, &60, &A9, &13, &60, &A8, &13, &40
    EQUB &A8, &12, &79, &EC, &26, &3C, &14, &CC, &C4, &E8, &42, &E8
    EQUB &66, &E3, &15, &42, &FE, &66, &E3, &15, &6E, &C8
    EQUS "Cog"
    EQUB &FA, &14, &43, &94, &6F, &FD
    EQUS "Cil"
    EQUB &FF, &4B, &16, &49, &16, 1  
    EQUS "!TW"
    EQUB &EE, &79, &FE, &38, &1F, &4D, &FE, &F0, &81, &C0
.L22AF
    EQUB &7A, &E9, &36, 7  , &2F, &15, &56, &FF, &7A, &E6, &7B, &E2
    EQUB &7B, &DD, &DE, &B6, &FA, &4E, &B1, &1B, &FD, &78, &EB, &DD
    EQUB &8C, &F9, &2D, &BB, &1B, &EB, &B8, &F4, &F6, &B9, &F1, &55
    EQUB &F5, &79, &EB, &59, &E6, &79, &E4, &5E, &E0, &7E, &DB, &5E
    EQUB &E7, &7E, &DA, &DB, &E8, &FF, &4A, &E4, &DA, &9F, &FF, &2A
    EQUB &E3, &DA, &70, &FF, &5C, &FD, &7C, &F9, &5C, &FC, &7C, &F8
    EQUB &5C, &FF, &7D, &FA, &5D, &FF, &7D, &FB, &94, &F7, &F8, &94
    EQUB &F2, &F7, &52, &E8, &72, &ED, &52, &D7, &72, &EC, &52, &D6
    EQUB &73, &EA, &D6, &9E, &F0, &BA, &E5, &F0
    EQUS "_nx%"
    EQUB &8B, &57, &0A, &1D, &48, &10, &F3, &68, &74, &8A, &24, 3  
    EQUS "]sy\"
    EQUB &8A, &56, &7B, &D4, &5B, &F5, &51, &FD, &D3, &5B, &F5, &51
    EQUB &60, &D3, &5A, &F4, &50, &F2, &52, &F2, &18, &18, &38, &22
    EQUB 9  , &79, &21, 9  , &53, &FF, &D1, &59, &F7, &53, &6E, &D1
    EQUB &58, &F6, &D0, &B8, &F4, &40, &0B, &90, &59, &0F, &62, &AC
    EQUB &11, &61, &AE, &11, &46, &EF, &62, &AF, &11, &47, &E6
    EQUS "Ff>"
    EQUB &13, &63, &AE, &10, &8E, &69, &BE, &88, &8C, &9F, &8E, &85
    EQUB &84, &83, &8A, &ED, &74, &BF, &89, &8D, &9E, &8F, &84, &85
    EQUB &82, &8B, &EC, &73, &B9, &8E, &9D, &98, &D9, &EB, &A7, &84
    EQUB &8A, &8F, &83, &84, &8D, &72, &EA, &B8, &8F, &9D, &83, &84
    EQUB &8D, &C9, &9D, &88, &99, &8C, &E9, &99, &C7, &AE, &AD, &0D
    EQUB &2F, &62, &FD, &12, &D6, &A0
    EQUS "V+!2"
.L23AF
    EQUB &78, &A9, &FF, &8D, &44, &FE, &A9, &91, &8D, &64, &FE, &A9
    EQUB &F0, &8D, &45, &FE, &A9, &45, &8D, &65, &FE, &20, &F0, 0  
    EQUB &68, &4A, &80, &94, &52, &FE, &50, &C4, &FF, &F2, &41, &53
    EQUB &BF, &F1, &4D, &87, &9A, &B8
    EQUS "O28"
    EQUB &80, &9B, &63, &C1, &F2, &D0, &7B, &E1, &5B, &54, &E9, &FC
    EQUB 1  , &33, &86, &62, &C5, &77, &35, &D9, &F9, &42, &BC, 7  
    EQUB &3E, &C0, &BD, &83, &49, &EA, &58, &C6, &91, &89, &E7, &0D
    EQUS "(iD$"
    EQUB &B2, &84, &C6, &C9, &C1, &92, &5E, &C4, &30, &18, &C0, &55
    EQUB &BF, &8F, &ED, &43, 1  , &86, &A2, &C8, &BC, &2B, &11, &D1
    EQUB &96, &6C, &FD, &96, 1  , &49, &78, &96, &1F, 0  , &28, &BA
    EQUB &0D, &B0, &88, &E1, &E0, &AA, &33, &51, &E8, &DA, &AA, &5C
    EQUB &6B, &10, &4A, &A2, &BB, &F9, &43, &8E, &5E, &A7, &AF, &F7
    EQUB &12, &E0, &83, &EB, &25, &1A, &82, &7B, &AA, 0  , &C4, &76
    EQUB &30, &D9, &DD, &19, &26, &EF, &8E, &FA, &79, &D9, &C9, &32
    EQUB &DC, &64, &1A
    EQUS "N<o"
    EQUB &CF, &DE, &0E, &B5, &A5
    EQUS "Q(@tk1"
    EQUB &90, &23, 9  , 7  , &80, &1D, &DB, 6  , &15, &A4, &DF, &81
    EQUB 1  , &BD, &DA, &62, &88
    EQUS "{E!5_vXY"
    EQUB &81, 5  , &AA, &F4, &EA, &A6, &0A, &44, &C3, &C9, &99, &78
    EQUB &9B, &E6, &7F, &C5, &B4, &87, &DA, &17, &8F, &5A, &ED, &23
    EQUB &5C, &DC, &8C, &ED, &C1, &18
    EQUS "hHi"
    EQUB 1  , &AA, &86, 0  , &B5, 0  , &20, 5  , 1  , &95, 0  , &E8
.L24AF
    EQUB &E0, &F0, &D0, &F4, &60, &20, &0F, 1  , &4D, &45, &FE, &4D
    EQUB &65, &FE
    EQUS "`MD"
    EQUB &FE, &20, &30, 1  , &4D, &44, &FE, &2C, &64, &FE, &70, &F8
    EQUB &4D, &45, &FE, &4D, &64, &FE, &4D, &44, &FE, &4D, &45, &FE
    EQUB &4D, &45, &FE, &2C, &64, &FE
    EQUS "`  "
    EQUB 1  , &2C, &44, &FE, &30, &FB, &4D, &45, &FE, &20, &29, 1  
    EQUB &4D, &65, &FE, &4C, &29, 1  
    EQUS "`L-"
    EQUB 1  , &60, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
.RunRevs
    LDX #<(runRevs)
    LDY #>(runRevs)
    JMP oscli

.runRevs
    EQUS "*R.Revs?"
    EQUB &0D, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , &3D, &15, &14, &15, 7  , &15, &FC, &14, &6E, &14
    EQUB &13, 9  , 0  , 0  

\ ******************************************************************************
\
\ Save Revs1.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/Revs1.bin", LOAD%, P%

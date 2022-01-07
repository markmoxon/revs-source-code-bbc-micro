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

ORG CODE%
    CPU 1

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

    ORG &2000

.Start
.pydis_start
    LDA #&C9                                                          ; 2000: A9 C9       ..
    STA L0D00                                                         ; 2002: 8D 00 0D    ...
    LDX #6                                                            ; 2005: A2 06       ..
; &2007 referenced 1 time by &200E
.loop_C2007
    LDA L20A8,X                                                       ; 2007: BD A8 20    ..
    STA L0CFF,X                                                       ; 200A: 9D FF 0C    ...
    DEX                                                               ; 200D: CA          .
    BNE loop_C2007                                                    ; 200E: D0 F7       ..
    LDA #4                                                            ; 2010: A9 04       ..
    STA L0080                                                         ; 2012: 85 80       ..
    LDX #0                                                            ; 2014: A2 00       ..
    LDY #0                                                            ; 2016: A0 00       ..
; &2018 referenced 3 times by &2019, &201C, &2020
.C2018
    DEX                                                               ; 2018: CA          .
    BNE C2018                                                         ; 2019: D0 FD       ..
    DEY                                                               ; 201B: 88          .
    BNE C2018                                                         ; 201C: D0 FA       ..
    DEC L0080                                                         ; 201E: C6 80       ..
    BNE C2018                                                         ; 2020: D0 F6       ..
    LDA #&0C                                                          ; 2022: A9 0C       ..
    JMP RunRevs                                                       ; 2024: 4C 00 25    L.%

    LDA #osbyte_flush_buffer_class                                    ; 2027: A9 0F       ..
    LDX #0                                                            ; 2029: A2 00       ..
    LDY #0                                                            ; 202B: A0 00       ..
    JSR osbyte                                                        ; 202D: 20 F4 FF     ..
    LDA #&0B                                                          ; 2030: A9 0B       ..
    STA crtc_horz_total                                               ; 2032: 8D 00 FE    ...
    LDA #0                                                            ; 2035: A9 00       ..
    STA crtc_horz_displayed                                           ; 2037: 8D 01 FE    ...
    SEI                                                               ; 203A: 78          x
    LDX #&FF                                                          ; 203B: A2 FF       ..
    TXS                                                               ; 203D: 9A          .
    LDX #0                                                            ; 203E: A2 00       ..
; &2040 referenced 1 time by &2063
.C2040
    LDA L0000,X                                                       ; 2040: B5 00       ..
    STA L0700,X                                                       ; 2042: 9D 00 07    ...
    LDA L20AF,X                                                       ; 2045: BD AF 20    ..
    STA L0400,X                                                       ; 2048: 9D 00 04    ...
    LDA L21AF,X                                                       ; 204B: BD AF 21    ..!
    STA L0500,X                                                       ; 204E: 9D 00 05    ...
    LDA L22AF,X                                                       ; 2051: BD AF 22    .."
    STA L0600,X                                                       ; 2054: 9D 00 06    ...
    LDA L23AF,X                                                       ; 2057: BD AF 23    ..#
    STA L0000,X                                                       ; 205A: 95 00       ..
    LDA L24AF,X                                                       ; 205C: BD AF 24    ..$
    STA L0100,X                                                       ; 205F: 9D 00 01    ...
    INX                                                               ; 2062: E8          .
    BNE C2040                                                         ; 2063: D0 DB       ..
    JMP L0000                                                         ; 2065: 4C 00 00    L..

    EQUS "ACCESS SECURITY VIOLATION"                                  ; 2068: 41 43 43... ACC
    EQUB &0A, &0D                                                     ; 2081: 0A 0D       ..
    EQUS "Protected by Toby Butler & Tim Sorrel"                      ; 2083: 50 72 6F... Pro
; &20A8 referenced 1 time by &2007
.L20A8
    EQUB &6C, &A9, &4E, &8D, 0  , &7C, &40                            ; 20A8: 6C A9 4E... l.N
; &20AF referenced 1 time by &2045
.L20AF
    EQUB &BB, &60, &C2, &CF, &12, &62, &FF, &E5, &92, 2  , &A7, &EF   ; 20AF: BB 60 C2... .`.
    EQUB &86, &A5, &E2, &93, &F2, &41, &E2, &32, &92, &E3, 1  , &D5   ; 20BB: 86 A5 E2... ...
    EQUB &67, &9D, &61, &74, &F2, &25, &6E, &FE, &27, &D1, &62, &B4   ; 20C7: 67 9D 61... g.a
    EQUB &DE, &79, &B7, &47, &9E, &1F, &82, &F5, &7E, &BB, &22, &94   ; 20D3: DE 79 B7... .y.
    EQUB &FD, &F7, &E2                                                ; 20DF: FD F7 E2    ...
    EQUS "1wR"                                                        ; 20E2: 31 77 52    1wR
    EQUB &EF, &31, &1D, &B6, &86, &9F, &AF, &B5, &0E, &7F, &EF, &2F   ; 20E5: EF 31 1D... .1.
    EQUB &C6, &97, &3A, &76, &99, &2F, &9E, &1F, &82, &F7, &F7, &8A   ; 20F1: C6 97 3A... ..:
    EQUB &A3, &49, &6F, &8F, &44, &17, &A7, &E5, &22, &CF, &67, &6D   ; 20FD: A3 49 6F... .Io
    EQUB &A7, &5A, &53, &FA, &26, &DF, 2  , &FF, &F2, &AB, &52, &7D   ; 2109: A7 5A 53... .ZS
    EQUB &B7, &A1, &17, &2A, 3  , &2A, &D4, &6F, &40, &97, &17, &FD   ; 2115: B7 A1 17... ...
    EQUB &B8, &C7, &AA, &23, &E1, &52, &36, &E1, &57, &98, &FE, &A7   ; 2121: B8 C7 AA... ...
    EQUB &AA, &A7, &89                                                ; 212D: AA A7 89    ...
    EQUS "v@", '"', "G"                                               ; 2130: 76 40 22... v@"
    EQUB 1  , &C2, &56, &1E, &10, &1F, &86, &E7, &76, &9D, &1F        ; 2134: 01 C2 56... ..V
    EQUS "u6A"                                                        ; 213F: 75 36 41    u6A
    EQUB &A2, &C8, &81, &42, &D6, &FD, &D5, &CD                       ; 2142: A2 C8 81... ...
    EQUS "%OV"                                                        ; 214A: 25 4F 56    %OV
    EQUB &17, &C6, &CD, &4F, &C5, &C6, &91, &F2, &B9, &31, &17, &2A   ; 214D: 17 C6 CD... ...
    EQUB 3  , &6A, &D1, &9F, &92, &8B, &F2, &56, &67, &1A, &13, &7A   ; 2159: 03 6A D1... .j.
    EQUB &E3, &EF, &82, &9B, 2  , &6A, &77, &0A, &23, &8A, &FF, &FF   ; 2165: E3 EF 82... ...
    EQUB &F2, &AB, &12                                                ; 2171: F2 AB 12    ...
    EQUS "xGz3"                                                       ; 2174: 78 47 7A... xGz
    EQUB &9A, &0D, &5F, &EF, &9F, &92, &8B, &32, &55, &C2, &24, &A7   ; 2178: 9A 0D 5F... .._
    EQUB &D0, &C7, &FA, &B3, &1A, &8B, &2A, &5E, &BA, &2E, &2F, &C2   ; 2184: D0 C7 FA... ...
    EQUB &DB, &42, &A2                                                ; 2190: DB 42 A2    .B.
    EQUS "'`Gz3"                                                      ; 2193: 27 60 47... '`G
    EQUB &9A, 9  , &5F, &CF, &9F, &92, &8B, &32, &55, &0E, &D0, &D2   ; 2198: 9A 09 5F... .._
    EQUB &F2, &37, &D5, &97, &AA, &83, &DF                            ; 21A4: F2 37 D5... .7.
    EQUS "_z,F"                                                       ; 21AB: 5F 7A 2C... _z,
; &21AF referenced 1 time by &204B
.L21AF
    EQUB 0  , &3A, &F1, &0F, &FB, &56, &FE, &2F, &F6, &56, &FF, &7B   ; 21AF: 00 3A F1... .:.
    EQUB &ED, &7B, &EA, &7B, &EB, &56, &9E, &DE, &CB, &F9, &4D, &B1   ; 21BB: ED 7B EA... .{.
    EQUB &57, &E5, &98, &EE, &78, &EE, &54, &FD, &99, &E8, &79, &E8   ; 21C7: 57 E5 98... W..
    EQUB &55, &FC, &99, &E9, &79, &E9, &39, &F5, &6B, &EB, &2B, &E0   ; 21D3: 55 FC 99... U..
    EQUB &5E, &EF, &3E, &F6, &6B, &F2, &2A, &E9, &5F, &E9, &3F, &F6   ; 21DF: 5E EF 3E... ^.>
    EQUB &4A, &F7, &70, &DA, &AA, &FF, &68, &EF                       ; 21EB: 4A F7 70... J.p
    EQUS "1)5"                                                        ; 21F3: 31 29 35    1)5
    EQUB &1F, &EE                                                     ; 21F6: 1F EE       ..
    EQUS ")1r"                                                        ; 21F8: 29 31 72    )1r
    EQUB &BD, &FD, &7D, &FD, &D8, &CD, &FC, &7D, &F7, &B2, &F1, &72   ; 21FB: BD FD 7D... ..}
    EQUB &F1, &D7, &C2, &F3, &BD, &72, &E7, &B2, &F2, &73, &F2, &EE   ; 2207: F1 D7 C2... ...
    EQUB &96, &D6, &C3, &F2, &73, &E7, &D6, &C0, &F1, &70, &E7, &57   ; 2213: 96 D6 C3... ...
    EQUB &F8, &40, &F6, &ED, &90, &E7, &71, &E7, &5D, &F4, &91, &E0   ; 221F: F8 40 F6... .@.
    EQUB &71, &E0, &3E, &24, 3  , &36, &E1, &23, &F7, &56, &E0, &36   ; 222B: 71 E0 3E... q.>
    EQUB &E2, &93, &15, &EB                                           ; 2237: E2 93 15... ...
    EQUS "zjX"                                                        ; 223B: 7A 6A 58    zjX
    EQUB &1A, &22, &F0, &34, &E5, &CA, &54, &E6, &18, &F8, &E9, &94   ; 223E: 1A 22 F0... .".
    EQUB &F8, &74, &F8, &40, &E7, &61, &F8, &5D, &F8, &0E, &D9, &F1   ; 224A: F8 74 F8... .t.
    EQUB 0  , &F7, &5D, &F9, &11, &AA, &FE, &6A, &E9                  ; 2256: 00 F7 5D... ..]
    EQUS "g%?"                                                        ; 225F: 67 25 3F    g%?
    EQUB 5  , &29, &E7, &28, &F9, &4B, &F9, &27, &E6, &3E, &0E, &8E   ; 2262: 05 29 E7... .).
    EQUB &96, &4F, &ED, &44, &12, &60, &A9, &13, &60, &A8, &13, &40   ; 226E: 96 4F ED... .O.
    EQUB &A8, &12, &79, &EC, &26, &3C, &14, &CC, &C4, &E8, &42, &E8   ; 227A: A8 12 79... ..y
    EQUB &66, &E3, &15, &42, &FE, &66, &E3, &15, &6E, &C8             ; 2286: 66 E3 15... f..
    EQUS "Cog"                                                        ; 2290: 43 6F 67    Cog
    EQUB &FA, &14, &43, &94, &6F, &FD                                 ; 2293: FA 14 43... ..C
    EQUS "Cil"                                                        ; 2299: 43 69 6C    Cil
    EQUB &FF, &4B, &16, &49, &16, 1                                   ; 229C: FF 4B 16... .K.
    EQUS "!TW"                                                        ; 22A2: 21 54 57    !TW
    EQUB &EE, &79, &FE, &38, &1F, &4D, &FE, &F0, &81, &C0             ; 22A5: EE 79 FE... .y.
; &22AF referenced 1 time by &2051
.L22AF
    EQUB &7A, &E9, &36, 7  , &2F, &15, &56, &FF, &7A, &E6, &7B, &E2   ; 22AF: 7A E9 36... z.6
    EQUB &7B, &DD, &DE, &B6, &FA, &4E, &B1, &1B, &FD, &78, &EB, &DD   ; 22BB: 7B DD DE... {..
    EQUB &8C, &F9, &2D, &BB, &1B, &EB, &B8, &F4, &F6, &B9, &F1, &55   ; 22C7: 8C F9 2D... ..-
    EQUB &F5, &79, &EB, &59, &E6, &79, &E4, &5E, &E0, &7E, &DB, &5E   ; 22D3: F5 79 EB... .y.
    EQUB &E7, &7E, &DA, &DB, &E8, &FF, &4A, &E4, &DA, &9F, &FF, &2A   ; 22DF: E7 7E DA... .~.
    EQUB &E3, &DA, &70, &FF, &5C, &FD, &7C, &F9, &5C, &FC, &7C, &F8   ; 22EB: E3 DA 70... ..p
    EQUB &5C, &FF, &7D, &FA, &5D, &FF, &7D, &FB, &94, &F7, &F8, &94   ; 22F7: 5C FF 7D... \.}
    EQUB &F2, &F7, &52, &E8, &72, &ED, &52, &D7, &72, &EC, &52, &D6   ; 2303: F2 F7 52... ..R
    EQUB &73, &EA, &D6, &9E, &F0, &BA, &E5, &F0                       ; 230F: 73 EA D6... s..
    EQUS "_nx%"                                                       ; 2317: 5F 6E 78... _nx
    EQUB &8B, &57, &0A, &1D, &48, &10, &F3, &68, &74, &8A, &24, 3     ; 231B: 8B 57 0A... .W.
    EQUS "]sy\"                                                       ; 2327: 5D 73 79... ]sy
    EQUB &8A, &56, &7B, &D4, &5B, &F5, &51, &FD, &D3, &5B, &F5, &51   ; 232B: 8A 56 7B... .V{
    EQUB &60, &D3, &5A, &F4, &50, &F2, &52, &F2, &18, &18, &38, &22   ; 2337: 60 D3 5A... `.Z
    EQUB 9  , &79, &21, 9  , &53, &FF, &D1, &59, &F7, &53, &6E, &D1   ; 2343: 09 79 21... .y!
    EQUB &58, &F6, &D0, &B8, &F4, &40, &0B, &90, &59, &0F, &62, &AC   ; 234F: 58 F6 D0... X..
    EQUB &11, &61, &AE, &11, &46, &EF, &62, &AF, &11, &47, &E6        ; 235B: 11 61 AE... .a.
    EQUS "Ff>"                                                        ; 2366: 46 66 3E    Ff>
    EQUB &13, &63, &AE, &10, &8E, &69, &BE, &88, &8C, &9F, &8E, &85   ; 2369: 13 63 AE... .c.
    EQUB &84, &83, &8A, &ED, &74, &BF, &89, &8D, &9E, &8F, &84, &85   ; 2375: 84 83 8A... ...
    EQUB &82, &8B, &EC, &73, &B9, &8E, &9D, &98, &D9, &EB, &A7, &84   ; 2381: 82 8B EC... ...
    EQUB &8A, &8F, &83, &84, &8D, &72, &EA, &B8, &8F, &9D, &83, &84   ; 238D: 8A 8F 83... ...
    EQUB &8D, &C9, &9D, &88, &99, &8C, &E9, &99, &C7, &AE, &AD, &0D   ; 2399: 8D C9 9D... ...
    EQUB &2F, &62, &FD, &12, &D6, &A0                                 ; 23A5: 2F 62 FD... /b.
    EQUS "V+!2"                                                       ; 23AB: 56 2B 21... V+!
; &23AF referenced 1 time by &2057
.L23AF
    EQUB &78, &A9, &FF, &8D, &44, &FE, &A9, &91, &8D, &64, &FE, &A9   ; 23AF: 78 A9 FF... x..
    EQUB &F0, &8D, &45, &FE, &A9, &45, &8D, &65, &FE, &20, &F0, 0     ; 23BB: F0 8D 45... ..E
    EQUB &68, &4A, &80, &94, &52, &FE, &50, &C4, &FF, &F2, &41, &53   ; 23C7: 68 4A 80... hJ.
    EQUB &BF, &F1, &4D, &87, &9A, &B8                                 ; 23D3: BF F1 4D... ..M
    EQUS "O28"                                                        ; 23D9: 4F 32 38    O28
    EQUB &80, &9B, &63, &C1, &F2, &D0, &7B, &E1, &5B, &54, &E9, &FC   ; 23DC: 80 9B 63... ..c
    EQUB 1  , &33, &86, &62, &C5, &77, &35, &D9, &F9, &42, &BC, 7     ; 23E8: 01 33 86... .3.
    EQUB &3E, &C0, &BD, &83, &49, &EA, &58, &C6, &91, &89, &E7, &0D   ; 23F4: 3E C0 BD... >..
    EQUS "(iD$"                                                       ; 2400: 28 69 44... (iD
    EQUB &B2, &84, &C6, &C9, &C1, &92, &5E, &C4, &30, &18, &C0, &55   ; 2404: B2 84 C6... ...
    EQUB &BF, &8F, &ED, &43, 1  , &86, &A2, &C8, &BC, &2B, &11, &D1   ; 2410: BF 8F ED... ...
    EQUB &96, &6C, &FD, &96, 1  , &49, &78, &96, &1F, 0  , &28, &BA   ; 241C: 96 6C FD... .l.
    EQUB &0D, &B0, &88, &E1, &E0, &AA, &33, &51, &E8, &DA, &AA, &5C   ; 2428: 0D B0 88... ...
    EQUB &6B, &10, &4A, &A2, &BB, &F9, &43, &8E, &5E, &A7, &AF, &F7   ; 2434: 6B 10 4A... k.J
    EQUB &12, &E0, &83, &EB, &25, &1A, &82, &7B, &AA, 0  , &C4, &76   ; 2440: 12 E0 83... ...
    EQUB &30, &D9, &DD, &19, &26, &EF, &8E, &FA, &79, &D9, &C9, &32   ; 244C: 30 D9 DD... 0..
    EQUB &DC, &64, &1A                                                ; 2458: DC 64 1A    .d.
    EQUS "N<o"                                                        ; 245B: 4E 3C 6F    N<o
    EQUB &CF, &DE, &0E, &B5, &A5                                      ; 245E: CF DE 0E... ...
    EQUS "Q(@tk1"                                                     ; 2463: 51 28 40... Q(@
    EQUB &90, &23, 9  , 7  , &80, &1D, &DB, 6  , &15, &A4, &DF, &81   ; 2469: 90 23 09... .#.
    EQUB 1  , &BD, &DA, &62, &88                                      ; 2475: 01 BD DA... ...
    EQUS "{E!5_vXY"                                                   ; 247A: 7B 45 21... {E!
    EQUB &81, 5  , &AA, &F4, &EA, &A6, &0A, &44, &C3, &C9, &99, &78   ; 2482: 81 05 AA... ...
    EQUB &9B, &E6, &7F, &C5, &B4, &87, &DA, &17, &8F, &5A, &ED, &23   ; 248E: 9B E6 7F... ...
    EQUB &5C, &DC, &8C, &ED, &C1, &18                                 ; 249A: 5C DC 8C... \..
    EQUS "hHi"                                                        ; 24A0: 68 48 69    hHi
    EQUB 1  , &AA, &86, 0  , &B5, 0  , &20, 5  , 1  , &95, 0  , &E8   ; 24A3: 01 AA 86... ...
; &24AF referenced 1 time by &205C
.L24AF
    EQUB &E0, &F0, &D0, &F4, &60, &20, &0F, 1  , &4D, &45, &FE, &4D   ; 24AF: E0 F0 D0... ...
    EQUB &65, &FE                                                     ; 24BB: 65 FE       e.
    EQUS "`MD"                                                        ; 24BD: 60 4D 44    `MD
    EQUB &FE, &20, &30, 1  , &4D, &44, &FE, &2C, &64, &FE, &70, &F8   ; 24C0: FE 20 30... . 0
    EQUB &4D, &45, &FE, &4D, &64, &FE, &4D, &44, &FE, &4D, &45, &FE   ; 24CC: 4D 45 FE... ME.
    EQUB &4D, &45, &FE, &2C, &64, &FE                                 ; 24D8: 4D 45 FE... ME.
    EQUS "`  "                                                        ; 24DE: 60 20 20    `
    EQUB 1  , &2C, &44, &FE, &30, &FB, &4D, &45, &FE, &20, &29, 1     ; 24E1: 01 2C 44... .,D
    EQUB &4D, &65, &FE, &4C, &29, 1                                   ; 24ED: 4D 65 FE... Me.
    EQUS "`L-"                                                        ; 24F3: 60 4C 2D    `L-
    EQUB 1  , &60, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0               ; 24F6: 01 60 00... .`.
; &2500 referenced 1 time by &2024
.RunRevs
    LDX #<(runRevs)                                                   ; 2500: A2 07       ..
    LDY #>(runRevs)                                                   ; 2502: A0 25       .%
    JMP oscli                                                         ; 2504: 4C F7 FF    L..

.runRevs
    EQUS "*R.Revs?"                                                   ; 2507: 2A 52 2E... *R.
    EQUB &0D, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 250F: 0D 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 251B: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 2527: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 2533: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 253F: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 254B: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 2557: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 2563: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 256F: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 257B: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 2587: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 2593: 00 00 00... ...
    EQUB 0  , 0  , &3D, &15, &14, &15, 7  , &15, &FC, &14, &6E, &14   ; 259F: 00 00 3D... ..=
    EQUB &13, 9  , 0  , 0                                             ; 25AB: 13 09 00... ...
.pydis_end

; Label references by decreasing frequency:
;     L0000:                 3
;     C2018:                 3
;     L0080:                 2
;     L0100:                 1
;     L0400:                 1
;     L0500:                 1
;     L0600:                 1
;     L0700:                 1
;     L0CFF:                 1
;     L0D00:                 1
;     loop_C2007:            1
;     C2040:                 1
;     L20A8:                 1
;     L20AF:                 1
;     L21AF:                 1
;     L22AF:                 1
;     L23AF:                 1
;     L24AF:                 1
;     RunRevs:               1
;     crtc_horz_total:       1
;     crtc_horz_displayed:   1
;     osbyte:                1
;     oscli:                 1

; Automatically generated labels:
;     C2018
;     C2040
;     L0000
;     L0080
;     L0100
;     L0400
;     L0500
;     L0600
;     L0700
;     L0CFF
;     L0D00
;     L20A8
;     L20AF
;     L21AF
;     L22AF
;     L23AF
;     L24AF
;     loop_C2007
    ASSERT <(runRevs) == &07
    ASSERT >(runRevs) == &25
    ASSERT osbyte_flush_buffer_class == &0F

SAVE "3-assembled-output/Revs1.bin", pydis_start, pydis_end

\ ******************************************************************************
\
\ Save Revs1.bin
\
\ ******************************************************************************

\SAVE "3-assembled-output/Revs1.bin", LOAD%, P%

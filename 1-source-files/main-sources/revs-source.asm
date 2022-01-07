\ ******************************************************************************
\
\ REVS SOURCE
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
\   * Revs.bin
\
\ ******************************************************************************

GUARD &7C00             \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

LOAD% = &1200           \ The load address of the main code binary

CODE% = &1200           \ The address of the main game code

\ ******************************************************************************
\
\ REVS MAIN GAME CODE
\
\ Produces the binary file Revs.bin that contains the main game code.
\
\ ******************************************************************************

ORG CODE%
    CPU 1

osbyte_read_write_escape_break_effect = &C8
osbyte_tape = &8C
osword_envelope = &08
osbyte_read_adc_or_get_buffer_status = &80
osword_read_char = &0A

L0019 = &0019
L001F = &001F
L003C = &003C
L003E = &003E
L003F = &003F
L0040 = &0040
L004E = &004E
L0051 = &0051
L0058 = &0058
P = &0070
Q = &0071
R = &0072
S = &0073
L0074 = &0074
L0075 = &0075
L0076 = &0076
L0077 = &0077
L0078 = &0078
L0079 = &0079
L007A = &007A
L007B = &007B
L007C = &007C
L007D = &007D
L007E = &007E
L0083 = &0083
L0084 = &0084
L0085 = &0085
L05F5 = &05F5
L05FE = &05FE
L0900 = &0900
L0901 = &0901
L0902 = &0902
L0A00 = &0A00
L0A01 = &0A01
L0A02 = &0A02
L0D00 = &0D00
L0E50 = &0E50
C120E = &120E
L1300 = &1300
L1500 = &1500
L70DB = &70DB
L7725 = &7725
trackChecksum = &7800
L7900 = &7900
L79FF = &79FF
osword = &FFF1
osbyte = &FFF4
LFFFC = &FFFC

    ORG &1200

; Move block from &1200-&12FF to &7900-&79FF and jump to &790E
; &1200 referenced 1 time by &1202
.Entry
.pydis_start
    LDY #0                                                            ; 1200: A0 00       ..
; &1202 referenced 1 time by &1209
.entr1
    LDA Entry,Y                                                       ; 1202: B9 00 12    ...
    STA L7900,Y                                                       ; 1205: 99 00 79    ..y
    INY                                                               ; 1208: C8          .
    BNE entr1                                                         ; 1209: D0 F7       ..
    JMP SwapCode                                                      ; 120B: 4C 0E 79    L.y

COPYBLOCK &1200, &120E, &7900
CLEAR &1200, &120E
; Disable the ESCAPE key and clear memory if the BREAK key is pressed
; &120E referenced 1 time by &120B
; Disable the ESCAPE key and clear memory if the BREAK key is pressed
; &120E referenced 1 time by &120B

    ORG &790E
; Disable the ESCAPE key and clear memory if the BREAK key is pressed
; &120E referenced 1 time by &120B
.SwapCode
    LDA #osbyte_read_write_escape_break_effect                        ; 120E: A9 C8       ..  :790E[3]
    LDX #3                                                            ; 1210: A2 03       ..  :7910[3]
    LDY #0                                                            ; 1212: A0 00       ..  :7912[3]
    JSR osbyte                                                        ; 1214: 20 F4 FF     .. :7914[3]
; *TAPE
    LDA #osbyte_tape                                                  ; 1217: A9 8C       ..  :7917[3]
    LDX #0                                                            ; 1219: A2 00       ..  :7919[3]
    JSR osbyte                                                        ; 121B: 20 F4 FF     .. :791B[3]
; Set (Q P) = &5300 = trackData, destintion address for track data
    LDA #0                                                            ; 121E: A9 00       ..  :791E[3]
    STA P                                                             ; 1220: 85 70       .p  :7920[3]
    LDA #&53 ; 'S'                                                    ; 1222: A9 53       .S  :7922[3]
    STA Q                                                             ; 1224: 85 71       .q  :7924[3]
; Set (S R) = &70DB, source address of track data
    LDA #&DB                                                          ; 1226: A9 DB       ..  :7926[3]
    STA R                                                             ; 1228: 85 72       .r  :7928[3]
    LDA #&70 ; 'p'                                                    ; 122A: A9 70       .p  :792A[3]
    STA S                                                             ; 122C: 85 73       .s  :792C[3]
; Swap memory between &70DB-&7724 to &5300-&5949 and decrement
; checksum bytes in &7800-&7803
    LDY #0                                                            ; 122E: A0 00       ..  :792E[3]
; Swap Y-th byte of (Q P) and (S R)
; &1230 referenced 2 times by &7949, &794F
.swap1
    LDA (R),Y                                                         ; 1230: B1 72       .r  :7930[3]
    PHA                                                               ; 1232: 48          H   :7932[3]
    LDA (P),Y                                                         ; 1233: B1 70       .p  :7933[3]
    STA (R),Y                                                         ; 1235: 91 72       .r  :7935[3]
    PLA                                                               ; 1237: 68          h   :7937[3]
    STA (P),Y                                                         ; 1238: 91 70       .p  :7938[3]
; Decrement the relevant checksum byte at &7800-&7803
    AND #3                                                            ; 123A: 29 03       ).  :793A[3]
    TAX                                                               ; 123C: AA          .   :793C[3]
    DEC trackChecksum,X                                               ; 123D: DE 00 78    ..x :793D[3]
; Increment loop counter
    INY                                                               ; 1240: C8          .   :7940[3]
; Increment high bytes to move on to next page
    BNE swap2                                                         ; 1241: D0 04       ..  :7941[3]
    INC Q                                                             ; 1243: E6 71       .q  :7943[3]
    INC S                                                             ; 1245: E6 73       .s  :7945[3]
; If we have not yet reached &7725, jump back to swap1 to keep going
; &1247 referenced 1 time by &7941
.swap2
    CPY #&25 ; '%'                                                    ; 1247: C0 25       .%  :7947[3]
    BNE swap1                                                         ; 1249: D0 E5       ..  :7949[3]
    LDA S                                                             ; 124B: A5 73       .s  :794B[3]
    CMP #&77 ; 'w'                                                    ; 124D: C9 77       .w  :794D[3]
    BNE swap1                                                         ; 124F: D0 DF       ..  :794F[3]
; Now check that all three checksum bytes in &7800-&7803 are zero
    LDX #3                                                            ; 1251: A2 03       ..  :7951[3]
; &1253 referenced 1 time by &7959
.swap3
    LDA trackChecksum,X                                               ; 1253: BD 00 78    ..x :7953[3]
; If a checksum byte is non-zero, jump to swap4 to reset the machine
    BNE swap4                                                         ; 1256: D0 05       ..  :7956[3]
    DEX                                                               ; 1258: CA          .   :7958[3]
; Loop back to check the next checksum byte
    BPL swap3                                                         ; 1259: 10 F8       ..  :7959[3]
; All checksum bytes are zero, so jump to swap4 to keep going
    BMI MoveCode                                                      ; 125B: 30 03       0.  :795B[3]
; Reset the machine
; &125D referenced 1 time by &7956
.swap4
    JMP (LFFFC)                                                       ; 125D: 6C FC FF    l.. :795D[3]

; Move block (blockStartHi blockStartLo) - (blockEndHi blockEndLo)-1
; to (blockToHi blockToLo)
;   * Move &1500-&15DA to &7000-&70DA
;   * Move &1300-&14FF to &0B00-&0CFF
;   * Move &5A80-&645B to &0D00-&16DB
;   * Move &64D0-&6BFF to &5FD0-&63FF
;   * Zero &5A80-&5E3F
; &1260 referenced 1 time by &795B
.MoveCode
    LDX #4                                                            ; 1260: A2 04       ..  :7960[3]
    LDY #0                                                            ; 1262: A0 00       ..  :7962[3]
; &1264 referenced 2 times by &7999, &79A7
.move1
    LDA blockStartLo,X                                                ; 1264: BD AF 79    ..y :7964[3]
    STA P                                                             ; 1267: 85 70       .p  :7967[3]
    LDA blockStartHi,X                                                ; 1269: BD B4 79    ..y :7969[3]
    STA Q                                                             ; 126C: 85 71       .q  :796C[3]
    LDA blockToLo,X                                                   ; 126E: BD C3 79    ..y :796E[3]
    STA R                                                             ; 1271: 85 72       .r  :7971[3]
    LDA blockToHi,X                                                   ; 1273: BD C8 79    ..y :7973[3]
    STA S                                                             ; 1276: 85 73       .s  :7976[3]
; &1278 referenced 3 times by &798D, &7994, &799E
.move2
L7979 = move2+1
    LDA (P),Y                                                         ; 1278: B1 70       .p  :7978[3]
; &1279 referenced 1 time by &79A4
    STA (R),Y                                                         ; 127A: 91 72       .r  :797A[3]
    INC P                                                             ; 127C: E6 70       .p  :797C[3]
    BNE move3                                                         ; 127E: D0 02       ..  :797E[3]
    INC Q                                                             ; 1280: E6 71       .q  :7980[3]
; &1282 referenced 1 time by &797E
.move3
    INC R                                                             ; 1282: E6 72       .r  :7982[3]
    BNE move4                                                         ; 1284: D0 02       ..  :7984[3]
    INC S                                                             ; 1286: E6 73       .s  :7986[3]
; &1288 referenced 1 time by &7984
.move4
    LDA P                                                             ; 1288: A5 70       .p  :7988[3]
    CMP blockEndLo,X                                                  ; 128A: DD B9 79    ..y :798A[3]
    BNE move2                                                         ; 128D: D0 E9       ..  :798D[3]
    LDA Q                                                             ; 128F: A5 71       .q  :798F[3]
    CMP blockEndHi,X                                                  ; 1291: DD BE 79    ..y :7991[3]
    BNE move2                                                         ; 1294: D0 E2       ..  :7994[3]
    DEX                                                               ; 1296: CA          .   :7996[3]
    BMI move5                                                         ; 1297: 30 11       0.  :7997[3]
    BNE move1                                                         ; 1299: D0 C9       ..  :7999[3]
; We get here when X = 0
; Modify the instruction at move2 to LDA #0, so the last block move
; actually zeroes the block
    LDA ldaZero                                                       ; 129B: AD AD 79    ..y :799B[3]
    STA move2                                                         ; 129E: 8D 78 79    .xy :799E[3]
    LDA L79AE                                                         ; 12A1: AD AE 79    ..y :79A1[3]
    STA L7979                                                         ; 12A4: 8D 79 79    .yy :79A4[3]
; Loop back to move1 to zero the rest of the block
    JMP move1                                                         ; 12A7: 4C 64 79    Ldy :79A7[3]

; &12AA referenced 1 time by &7997
.move5
    JMP C63BD                                                         ; 12AA: 4C BD 63    L.c :79AA[3]

; &12AD referenced 1 time by &799B
.ldaZero
L79AE = ldaZero+1
    LDA #0                                                            ; 12AD: A9 00       ..  :79AD[3]
; &12AE referenced 1 time by &79A1
; &12AF referenced 1 time by &7964
.blockStartLo
    EQUB &80, &D0, &80, 0  , 0                                        ; 12AF: 80 D0 80... ... :79AF[3]
; &12B4 referenced 1 time by &7969
.blockStartHi
    EQUB &5A, &64, &5A, &13, &15                                      ; 12B4: 5A 64 5A... ZdZ :79B4[3]
; &12B9 referenced 1 time by &798A
.blockEndLo
    EQUB &40, 0  , &5C, 0  , &DB                                      ; 12B9: 40 00 5C... @.\ :79B9[3]
; &12BE referenced 1 time by &7991
.blockEndHi
    EQUB &5E, &6C, &64, &15, &15                                      ; 12BE: 5E 6C 64... ^ld :79BE[3]
; &12C3 referenced 1 time by &796E
.blockToLo
    EQUB &80, &D0, 0  , 0  , 0                                        ; 12C3: 80 D0 00... ... :79C3[3]
; &12C8 referenced 1 time by &7973
.blockToHi
    EQUB &5A, &5F, &0D, &0B, &70                                      ; 12C8: 5A 5F 0D... Z_. :79C8[3]

    EQUB 9  , &B9, 2  , &50, &9D, 1  , 9  , &9D, &79, 9  , &B9, 3     ; 12CD: 09 B9 02... ... :79CD[3]
    EQUB &50, &9D, 2  , 9  , &B9, 1  , &51, &9D, 0  , &0A, &B9, 2     ; 12D9: 50 9D 02... P.. :79D9[3]
    EQUB &51, &9D, 1  , &0A, &9D, &79, &0A, &B9, 3  , &51, &9D, 2     ; 12E5: 51 9D 01... Q.. :79E5[3]
    EQUB &0A, &B9, 4  , &50, &9D, &78, 9  , &B9, 6  , &50, &9D, &7A   ; 12F1: 0A B9 04... ... :79F1[3]
    EQUB 9  , &B9                                                     ; 12FD: 09 B9       ..  :79FD[3]
    ORG C120E + (L79FF - SwapCode)
    COPYBLOCK SwapCode, L79FF, C120E
    CLEAR SwapCode, L79FF

    EQUB 4                                                            ; 12FF: 04          .
; &1300 referenced 1 time by &0B58
; &1300 referenced 1 time by &0B58

    ORG &0B00
; &1300 referenced 1 time by &0B58
.movedFrom1300
    EQUB &10, &10                                                     ; 1300: 10 10       ..  :0B00[2]
; &1302 referenced 1 time by &0B55
.L0B02
    EQUB &10, &10, &10, &10, &10, &10, &10, &10, &10, &10, &10, &10   ; 1302: 10 10 10... ... :0B02[2]
    EQUB &10, &10, &10, 0  , &F6, &FF, 3  , 0  , &FF, 0  , &11, 0     ; 130E: 10 10 10... ... :0B0E[2]
    EQUB &F6, &FF, &BB, 0  , &FF, 0  , &12, 0  , &F6, &FF, &28, 0     ; 131A: F6 FF BB... ... :0B1A[2]
    EQUB &FF, 0  , &13, 0  , 1  , 0  , &82, 0  , &FF, 0  , &10, 0     ; 1326: FF 00 13... ... :0B26[2]
    EQUB &F6, &FF, 6  , 0  , 4  , 0  , 1  , 1  , 2  , &FE, &FA, 4     ; 1332: F6 FF 06... ... :0B32[2]
    EQUB 1  , 1  , &0A, 0  , 0  , 0  , &48, 0                         ; 133E: 01 01 0A... ... :0B3E[2]
; &1346 referenced 3 times by &0B4A, &0B65, &0B73
.L0B46
    EQUB &FF                                                          ; 1346: FF          .   :0B46[2]
    LDY L05FE                                                         ; 1347: AC FE 05    ... :0B47[2]
    STX L0B46                                                         ; 134A: 8E 46 0B    .F. :0B4A[2]
    ASL A                                                             ; 134D: 0A          .   :0B4D[2]
    ASL A                                                             ; 134E: 0A          .   :0B4E[2]
    ASL A                                                             ; 134F: 0A          .   :0B4F[2]
    CLC                                                               ; 1350: 18          .   :0B50[2]
    ADC #&10                                                          ; 1351: 69 10       i.  :0B51[2]
    TAX                                                               ; 1353: AA          .   :0B53[2]
    TYA                                                               ; 1354: 98          .   :0B54[2]
    STA L0B02,X                                                       ; 1355: 9D 02 0B    ... :0B55[2]
    LDA movedFrom1300,X                                               ; 1358: BD 00 0B    ... :0B58[2]
    AND #3                                                            ; 135B: 29 03       ).  :0B5B[2]
    TAY                                                               ; 135D: A8          .   :0B5D[2]
    LDA #7                                                            ; 135E: A9 07       ..  :0B5E[2]
    STA L62BD,Y                                                       ; 1360: 99 BD 62    ..b :0B60[2]
    BNE C0B6E                                                         ; 1363: D0 09       ..  :0B63[2]
    STX L0B46                                                         ; 1365: 8E 46 0B    .F. :0B65[2]
    CLC                                                               ; 1368: 18          .   :0B68[2]
    ADC #&38 ; '8'                                                    ; 1369: 69 38       i8  :0B69[2]
    TAX                                                               ; 136B: AA          .   :0B6B[2]
    LDA #osword_envelope                                              ; 136C: A9 08       ..  :0B6C[2]
; &136E referenced 1 time by &0B63
.C0B6E
    LDY #&0B                                                          ; 136E: A0 0B       ..  :0B6E[2]
    JSR osword                                                        ; 1370: 20 F1 FF     .. :0B70[2]
    LDX L0B46                                                         ; 1373: AE 46 0B    .F. :0B73[2]
    RTS                                                               ; 1376: 60          `   :0B76[2]

    LDX #1                                                            ; 1377: A2 01       ..  :0B77[2]
; &1379 referenced 1 time by &0B8D
.loop_C0B79
    LDA L5F3D,X                                                       ; 1379: BD 3D 5F    .=_ :0B79[2]
    ASL A                                                             ; 137C: 0A          .   :0B7C[2]
    ASL A                                                             ; 137D: 0A          .   :0B7D[2]
    STA L0075                                                         ; 137E: 85 75       .u  :0B7E[2]
    LDA L0BA0,X                                                       ; 1380: BD A0 0B    ... :0B80[2]
    JSR sub_C0C00                                                     ; 1383: 20 00 0C     .. :0B83[2]
    CLC                                                               ; 1386: 18          .   :0B86[2]
    ADC #&5A ; 'Z'                                                    ; 1387: 69 5A       iZ  :0B87[2]
    STA L62A8,X                                                       ; 1389: 9D A8 62    ..b :0B89[2]
    DEX                                                               ; 138C: CA          .   :0B8C[2]
    BPL loop_C0B79                                                    ; 138D: 10 EA       ..  :0B8D[2]
    LDA L5F3E                                                         ; 138F: AD 3E 5F    .>_ :0B8F[2]
    ASL A                                                             ; 1392: 0A          .   :0B92[2]
    ADC L5F3E                                                         ; 1393: 6D 3E 5F    m>_ :0B93[2]
    ADC L5F3D                                                         ; 1396: 6D 3D 5F    m=_ :0B96[2]
    LSR A                                                             ; 1399: 4A          J   :0B99[2]
    ADC #&3C ; '<'                                                    ; 139A: 69 3C       i<  :0B9A[2]
    STA L62F1                                                         ; 139C: 8D F1 62    ..b :0B9C[2]
    RTS                                                               ; 139F: 60          `   :0B9F[2]

; &13A0 referenced 1 time by &0B80
.L0BA0
    EQUB &CD, &CD                                                     ; 13A0: CD CD       ..  :0BA0[2]
    LDA #0                                                            ; 13A2: A9 00       ..  :0BA2[2]
    STA L5EE0,Y                                                       ; 13A4: 99 E0 5E    ..^ :0BA4[2]
    LDA L5E40,Y                                                       ; 13A7: B9 40 5E    .@^ :0BA7[2]
    SEC                                                               ; 13AA: 38          8   :0BAA[2]
    SBC L62D2                                                         ; 13AB: ED D2 62    ..b :0BAB[2]
    STA L5E40,Y                                                       ; 13AE: 99 40 5E    .@^ :0BAE[2]
    LDA L5E90,Y                                                       ; 13B1: B9 90 5E    ..^ :0BB1[2]
    SBC L62E2                                                         ; 13B4: ED E2 62    ..b :0BB4[2]
    STA L5E90,Y                                                       ; 13B7: 99 90 5E    ..^ :0BB7[2]
    LDA L5F20,Y                                                       ; 13BA: B9 20 5F    . _ :0BBA[2]
    SEC                                                               ; 13BD: 38          8   :0BBD[2]
    SBC L004E                                                         ; 13BE: E5 4E       .N  :0BBE[2]
    STA L5F20,Y                                                       ; 13C0: 99 20 5F    . _ :0BC0[2]
    CMP L001F                                                         ; 13C3: C5 1F       ..  :0BC3[2]
    BCC C0BCB                                                         ; 13C5: 90 04       ..  :0BC5[2]
    STA L001F                                                         ; 13C7: 85 1F       ..  :0BC7[2]
    STY L0051                                                         ; 13C9: 84 51       .Q  :0BC9[2]
; &13CB referenced 1 time by &0BC5
.C0BCB
    RTS                                                               ; 13CB: 60          `   :0BCB[2]

    LDA L0900,Y                                                       ; 13CC: B9 00 09    ... :0BCC[2]
    CLC                                                               ; 13CF: 18          .   :0BCF[2]
    ADC L0074                                                         ; 13D0: 65 74       et  :0BD0[2]
    STA L0900,X                                                       ; 13D2: 9D 00 09    ... :0BD2[2]
    LDA L0A00,Y                                                       ; 13D5: B9 00 0A    ... :0BD5[2]
    ADC L0083                                                         ; 13D8: 65 83       e.  :0BD8[2]
    STA L0A00,X                                                       ; 13DA: 9D 00 0A    ... :0BDA[2]
    LDA L0901,Y                                                       ; 13DD: B9 01 09    ... :0BDD[2]
    CLC                                                               ; 13E0: 18          .   :0BE0[2]
    ADC L0075                                                         ; 13E1: 65 75       eu  :0BE1[2]
    STA L0901,X                                                       ; 13E3: 9D 01 09    ... :0BE3[2]
    LDA L0A01,Y                                                       ; 13E6: B9 01 0A    ... :0BE6[2]
    ADC L0084                                                         ; 13E9: 65 84       e.  :0BE9[2]
    STA L0A01,X                                                       ; 13EB: 9D 01 0A    ... :0BEB[2]
    LDA L0902,Y                                                       ; 13EE: B9 02 09    ... :0BEE[2]
    CLC                                                               ; 13F1: 18          .   :0BF1[2]
    ADC L0076                                                         ; 13F2: 65 76       ev  :0BF2[2]
    STA L0902,X                                                       ; 13F4: 9D 02 09    ... :0BF4[2]
    LDA L0A02,Y                                                       ; 13F7: B9 02 0A    ... :0BF7[2]
    ADC L0085                                                         ; 13FA: 65 85       e.  :0BFA[2]
    STA L0A02,X                                                       ; 13FC: 9D 02 0A    ... :0BFC[2]
    RTS                                                               ; 13FF: 60          `   :0BFF[2]

; &1400 referenced 1 time by &0B83
.sub_C0C00
    STA L0074                                                         ; 1400: 85 74       .t  :0C00[2]
    LDA #0                                                            ; 1402: A9 00       ..  :0C02[2]
    LSR L0074                                                         ; 1404: 46 74       Ft  :0C04[2]
    BCC C0C0B                                                         ; 1406: 90 03       ..  :0C06[2]
    CLC                                                               ; 1408: 18          .   :0C08[2]
    ADC L0075                                                         ; 1409: 65 75       eu  :0C09[2]
; &140B referenced 1 time by &0C06
.C0C0B
    ROR A                                                             ; 140B: 6A          j   :0C0B[2]
    ROR L0074                                                         ; 140C: 66 74       ft  :0C0C[2]
    BCC C0C13                                                         ; 140E: 90 03       ..  :0C0E[2]
    CLC                                                               ; 1410: 18          .   :0C10[2]
    ADC L0075                                                         ; 1411: 65 75       eu  :0C11[2]
; &1413 referenced 1 time by &0C0E
.C0C13
    ROR A                                                             ; 1413: 6A          j   :0C13[2]
    ROR L0074                                                         ; 1414: 66 74       ft  :0C14[2]
    BCC C0C1B                                                         ; 1416: 90 03       ..  :0C16[2]
    CLC                                                               ; 1418: 18          .   :0C18[2]
    ADC L0075                                                         ; 1419: 65 75       eu  :0C19[2]
; &141B referenced 1 time by &0C16
.C0C1B
    ROR A                                                             ; 141B: 6A          j   :0C1B[2]
    ROR L0074                                                         ; 141C: 66 74       ft  :0C1C[2]
    BCC C0C23                                                         ; 141E: 90 03       ..  :0C1E[2]
    CLC                                                               ; 1420: 18          .   :0C20[2]
    ADC L0075                                                         ; 1421: 65 75       eu  :0C21[2]
; &1423 referenced 1 time by &0C1E
.C0C23
    ROR A                                                             ; 1423: 6A          j   :0C23[2]
    ROR L0074                                                         ; 1424: 66 74       ft  :0C24[2]
    BCC C0C2B                                                         ; 1426: 90 03       ..  :0C26[2]
    CLC                                                               ; 1428: 18          .   :0C28[2]
    ADC L0075                                                         ; 1429: 65 75       eu  :0C29[2]
; &142B referenced 1 time by &0C26
.C0C2B
    ROR A                                                             ; 142B: 6A          j   :0C2B[2]
    ROR L0074                                                         ; 142C: 66 74       ft  :0C2C[2]
    BCC C0C33                                                         ; 142E: 90 03       ..  :0C2E[2]
    CLC                                                               ; 1430: 18          .   :0C30[2]
    ADC L0075                                                         ; 1431: 65 75       eu  :0C31[2]
; &1433 referenced 1 time by &0C2E
.C0C33
    ROR A                                                             ; 1433: 6A          j   :0C33[2]
    ROR L0074                                                         ; 1434: 66 74       ft  :0C34[2]
    BCC C0C3B                                                         ; 1436: 90 03       ..  :0C36[2]
    CLC                                                               ; 1438: 18          .   :0C38[2]
    ADC L0075                                                         ; 1439: 65 75       eu  :0C39[2]
; &143B referenced 1 time by &0C36
.C0C3B
    ROR A                                                             ; 143B: 6A          j   :0C3B[2]
    ROR L0074                                                         ; 143C: 66 74       ft  :0C3C[2]
    BCC C0C43                                                         ; 143E: 90 03       ..  :0C3E[2]
    CLC                                                               ; 1440: 18          .   :0C40[2]
    ADC L0075                                                         ; 1441: 65 75       eu  :0C41[2]
; &1443 referenced 1 time by &0C3E
.C0C43
    ROR A                                                             ; 1443: 6A          j   :0C43[2]
    ROR L0074                                                         ; 1444: 66 74       ft  :0C44[2]
    RTS                                                               ; 1446: 60          `   :0C46[2]

    ASL L0074                                                         ; 1447: 06 74       .t  :0C47[2]
    ROL A                                                             ; 1449: 2A          *   :0C49[2]
    BCS C0C50                                                         ; 144A: B0 04       ..  :0C4A[2]
    CMP L0076                                                         ; 144C: C5 76       .v  :0C4C[2]
    BCC C0C53                                                         ; 144E: 90 03       ..  :0C4E[2]
; &1450 referenced 1 time by &0C4A
.C0C50
    SBC L0076                                                         ; 1450: E5 76       .v  :0C50[2]
    SEC                                                               ; 1452: 38          8   :0C52[2]
; &1453 referenced 1 time by &0C4E
.C0C53
    ROL L0074                                                         ; 1453: 26 74       &t  :0C53[2]
    ROL A                                                             ; 1455: 2A          *   :0C55[2]
    BCS C0C5C                                                         ; 1456: B0 04       ..  :0C56[2]
    CMP L0076                                                         ; 1458: C5 76       .v  :0C58[2]
    BCC C0C5F                                                         ; 145A: 90 03       ..  :0C5A[2]
; &145C referenced 1 time by &0C56
.C0C5C
    SBC L0076                                                         ; 145C: E5 76       .v  :0C5C[2]
    SEC                                                               ; 145E: 38          8   :0C5E[2]
; &145F referenced 1 time by &0C5A
.C0C5F
    ROL L0074                                                         ; 145F: 26 74       &t  :0C5F[2]
    ROL A                                                             ; 1461: 2A          *   :0C61[2]
    BCS C0C68                                                         ; 1462: B0 04       ..  :0C62[2]
    CMP L0076                                                         ; 1464: C5 76       .v  :0C64[2]
    BCC C0C6B                                                         ; 1466: 90 03       ..  :0C66[2]
; &1468 referenced 1 time by &0C62
.C0C68
    SBC L0076                                                         ; 1468: E5 76       .v  :0C68[2]
    SEC                                                               ; 146A: 38          8   :0C6A[2]
; &146B referenced 1 time by &0C66
.C0C6B
    ROL L0074                                                         ; 146B: 26 74       &t  :0C6B[2]
    ROL A                                                             ; 146D: 2A          *   :0C6D[2]
    BCS C0C74                                                         ; 146E: B0 04       ..  :0C6E[2]
    CMP L0076                                                         ; 1470: C5 76       .v  :0C70[2]
    BCC C0C77                                                         ; 1472: 90 03       ..  :0C72[2]
; &1474 referenced 1 time by &0C6E
.C0C74
    SBC L0076                                                         ; 1474: E5 76       .v  :0C74[2]
    SEC                                                               ; 1476: 38          8   :0C76[2]
; &1477 referenced 1 time by &0C72
.C0C77
    ROL L0074                                                         ; 1477: 26 74       &t  :0C77[2]
    ROL A                                                             ; 1479: 2A          *   :0C79[2]
    BCS C0C80                                                         ; 147A: B0 04       ..  :0C7A[2]
    CMP L0076                                                         ; 147C: C5 76       .v  :0C7C[2]
    BCC C0C83                                                         ; 147E: 90 03       ..  :0C7E[2]
; &1480 referenced 1 time by &0C7A
.C0C80
    SBC L0076                                                         ; 1480: E5 76       .v  :0C80[2]
    SEC                                                               ; 1482: 38          8   :0C82[2]
; &1483 referenced 1 time by &0C7E
.C0C83
    ROL L0074                                                         ; 1483: 26 74       &t  :0C83[2]
    ROL A                                                             ; 1485: 2A          *   :0C85[2]
    BCS C0C8C                                                         ; 1486: B0 04       ..  :0C86[2]
    CMP L0076                                                         ; 1488: C5 76       .v  :0C88[2]
    BCC C0C8F                                                         ; 148A: 90 03       ..  :0C8A[2]
; &148C referenced 1 time by &0C86
.C0C8C
    SBC L0076                                                         ; 148C: E5 76       .v  :0C8C[2]
    SEC                                                               ; 148E: 38          8   :0C8E[2]
; &148F referenced 1 time by &0C8A
.C0C8F
    ROL L0074                                                         ; 148F: 26 74       &t  :0C8F[2]
    ROL A                                                             ; 1491: 2A          *   :0C91[2]
    BCS C0C98                                                         ; 1492: B0 04       ..  :0C92[2]
    CMP L0076                                                         ; 1494: C5 76       .v  :0C94[2]
    BCC C0C9B                                                         ; 1496: 90 03       ..  :0C96[2]
; &1498 referenced 1 time by &0C92
.C0C98
    SBC L0076                                                         ; 1498: E5 76       .v  :0C98[2]
    SEC                                                               ; 149A: 38          8   :0C9A[2]
; &149B referenced 1 time by &0C96
.C0C9B
    ROL L0074                                                         ; 149B: 26 74       &t  :0C9B[2]
    ROL A                                                             ; 149D: 2A          *   :0C9D[2]
    BCS C0CA2                                                         ; 149E: B0 02       ..  :0C9E[2]
    CMP L0076                                                         ; 14A0: C5 76       .v  :0CA0[2]
; &14A2 referenced 1 time by &0C9E
.C0CA2
    ROL L0074                                                         ; 14A2: 26 74       &t  :0CA2[2]
    RTS                                                               ; 14A4: 60          `   :0CA4[2]

    LDA L007E                                                         ; 14A5: A5 7E       .~  :0CA5[2]
    CMP #&67 ; 'g'                                                    ; 14A7: C9 67       .g  :0CA7[2]
    BCS C0CC2                                                         ; 14A9: B0 17       ..  :0CA9[2]
    LDA L0078                                                         ; 14AB: A5 78       .x  :0CAB[2]
    LSR L0079                                                         ; 14AD: 46 79       Fy  :0CAD[2]
    ROR A                                                             ; 14AF: 6A          j   :0CAF[2]
    LSR L0079                                                         ; 14B0: 46 79       Fy  :0CB0[2]
    ROR A                                                             ; 14B2: 6A          j   :0CB2[2]
    LSR L0079                                                         ; 14B3: 46 79       Fy  :0CB3[2]
    ROR A                                                             ; 14B5: 6A          j   :0CB5[2]
    CLC                                                               ; 14B6: 18          .   :0CB6[2]
    ADC L007A                                                         ; 14B7: 65 7A       ez  :0CB7[2]
    STA L007C                                                         ; 14B9: 85 7C       .|  :0CB9[2]
    LDA L0079                                                         ; 14BB: A5 79       .y  :0CBB[2]
    ADC L007B                                                         ; 14BD: 65 7B       e{  :0CBD[2]
    STA L007D                                                         ; 14BF: 85 7D       .}  :0CBF[2]
    RTS                                                               ; 14C1: 60          `   :0CC1[2]

; &14C2 referenced 1 time by &0CA9
.C0CC2
    LSR L0079                                                         ; 14C2: 46 79       Fy  :0CC2[2]
    ROR L0078                                                         ; 14C4: 66 78       fx  :0CC4[2]
    LDA L007B                                                         ; 14C6: A5 7B       .{  :0CC6[2]
    STA L0074                                                         ; 14C8: 85 74       .t  :0CC8[2]
    LDA L007A                                                         ; 14CA: A5 7A       .z  :0CCA[2]
    LSR L0074                                                         ; 14CC: 46 74       Ft  :0CCC[2]
    ROR A                                                             ; 14CE: 6A          j   :0CCE[2]
    LSR L0074                                                         ; 14CF: 46 74       Ft  :0CCF[2]
    ROR A                                                             ; 14D1: 6A          j   :0CD1[2]
    LSR L0074                                                         ; 14D2: 46 74       Ft  :0CD2[2]
    ROR A                                                             ; 14D4: 6A          j   :0CD4[2]
    STA L0075                                                         ; 14D5: 85 75       .u  :0CD5[2]
    LDA L0078                                                         ; 14D7: A5 78       .x  :0CD7[2]
    CLC                                                               ; 14D9: 18          .   :0CD9[2]
    ADC L007A                                                         ; 14DA: 65 7A       ez  :0CDA[2]
    STA L007C                                                         ; 14DC: 85 7C       .|  :0CDC[2]
    LDA L0079                                                         ; 14DE: A5 79       .y  :0CDE[2]
    ADC L007B                                                         ; 14E0: 65 7B       e{  :0CE0[2]
    STA L007D                                                         ; 14E2: 85 7D       .}  :0CE2[2]
    LDA L007C                                                         ; 14E4: A5 7C       .|  :0CE4[2]
    SEC                                                               ; 14E6: 38          8   :0CE6[2]
    SBC L0075                                                         ; 14E7: E5 75       .u  :0CE7[2]
    STA L007C                                                         ; 14E9: 85 7C       .|  :0CE9[2]
    LDA L007D                                                         ; 14EB: A5 7D       .}  :0CEB[2]
    SBC L0074                                                         ; 14ED: E5 74       .t  :0CED[2]
    STA L007D                                                         ; 14EF: 85 7D       .}  :0CEF[2]
    RTS                                                               ; 14F1: 60          `   :0CF1[2]

    EQUB &F1, &0C, &E5, &74, &8D, &F6, &0C, &60, 0  , 0  , 0  , 0     ; 14F2: F1 0C E5... ... :0CF2[2]
    EQUB 0  , 0                                                       ; 14FE: 00 00       ..  :0CFE[2]
    ORG L1300 + (L0D00 - movedFrom1300)
    COPYBLOCK movedFrom1300, L0D00, L1300
    CLEAR movedFrom1300, L0D00


    ORG &7000
.movedFrom1500
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 1500: 00 00 00... ... :7000[1]
    EQUB 0  , 0  , &10, &30, 0  , 0  , &10, &30, &70, &F0, &F0, &F0   ; 150C: 00 00 10... ... :700C[1]
    EQUB &70, &F0, &F0, &F0, &F0, &E0, &A1, 3  , &E1, &81, &C3, &16   ; 1518: 70 F0 F0... p.. :7018[1]
    EQUB &0F, &2D, &87, &2D, &2D, &5A, &0F, &0F, &87, &0F, &0F, &0F   ; 1524: 0F 2D 87... .-. :7024[1]
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F   ; 1530: 0F 0F 0F... ... :7030[1]
    EQUB &0F, &0F, 5  , &0C, &0F, &0F, &0F, 7  , &0A, 2  , 4  , 0     ; 153C: 0F 0F 05... ... :703C[1]
    EQUB &0F, 6  , 6  , 8  , 4  , 0  , &F0, 0  , 5  , &0D, 9  , 0     ; 1548: 0F 06 06... ... :7048[1]
    EQUB &70, &30, &E1, &C3, &0D, 2  , 0  , 0  , &F0, &87, &0F, &0E   ; 1554: 70 30 E1... p0. :7054[1]
    EQUB &0B, 4  , 0  , 0  , &F0, &1E, &0F, 7  , &0A, &0B, 9  , 0     ; 1560: 0B 04 00... ... :7060[1]
    EQUB &E0, &C0, &78, &3C, &0F, 6  , 6  , 1  , 2  , 0  , &F0, 0     ; 156C: E0 C0 78... ..x :706C[1]
    EQUB &0F, &0F, &0F, &0E, 5  , 4  , 2  , 0  , &0F, &0F, &0F, &0F   ; 1578: 0F 0F 0F... ... :7078[1]
    EQUB &0F, &0F, &0A, 3  , &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F   ; 1584: 0F 0F 0A... ... :7084[1]
    EQUB &4B, &A5, &0F, &0F, &1E, &0F, &0F, &0F, &78, &18, &3C, &86   ; 1590: 4B A5 0F... K.. :7090[1]
    EQUB &0F, &4B, &1E, &4B, &E0, &F0, &F0, &F0, &F0, &70, &58, &0C   ; 159C: 0F 4B 1E... .K. :709C[1]
    EQUB 0  , 0  , &80, &C0, &E0, &F0, &F0, &F0, 0  , 0  , 0  , 0     ; 15A8: 00 00 80... ... :70A8[1]
    EQUB 0  , 0  , &80, &C0, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 15B4: 00 00 80... ... :70B4[1]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 15C0: 00 00 00... ... :70C0[1]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 15CC: 00 00 00... ... :70CC[1]
    EQUB 0  , 0                                                       ; 15D8: 00 00       ..  :70D8[1]
    EQUB 0                                                            ; 15DA: 00          .   :70DA[1]
    ORG L1500 + (L70DB - movedFrom1500)
    COPYBLOCK movedFrom1500, L70DB, L1500
    CLEAR movedFrom1500, L70DB

    EQUB &20, 0  , &63, &60, &A6, 3  , &10, 3  , &20, &CB, &2A, &20   ; 15DB: 20 00 63...  .c
    EQUB &84, &50, &E4, &4D, &D0, &F6, &A2, &16, &86, &45, &20, &D1   ; 15E7: 84 50 E4... .P.
    EQUB &2A, &CA, &E0, &14, &B0, &F6, &A6, &4D, &20, &CB             ; 15F3: 2A CA E0... *..
    EQUS "*` "                                                        ; 15FD: 2A 60 20    *`
    EQUB &0E, &2B, &A2, &F4, &20, &CC, &0B, &20, &0E, &2B, &A2, &FD   ; 1600: 0E 2B A2... .+.
    EQUB &20, &CC, &0B, &A9, &14, &85, &42, &A9, 2                    ; 160C: 20 CC 0B...  ..
    EQUS " ]*"                                                        ; 1615: 20 5D 2A     ]*
    EQUB &A9, &15, &85, &42, &A9, 1  , &A2, &F4                       ; 1618: A9 15 85... ...
    EQUS " _*"                                                        ; 1620: 20 5F 2A     _*
    EQUB &A9, &16, &85, &42, &A9, 0  , &A2, &FA                       ; 1623: A9 16 85... ...
    EQUS " _*"                                                        ; 162B: 20 5F 2A     _*
    EQUB &A6, &45, &60, &C9, 5  , &90, &F9, &BD, &8C, 1  , &30, &F4   ; 162E: A6 45 60... .E`
    EQUB &FE, &8C, 1  , &60, &A2, &FD, &85                            ; 163A: FE 8C 01... ...
    EQUS "7 E!"                                                       ; 1641: 37 20 45... 7 E
    EQUB &A4, &42, &A5, &8A, &99, &80, 3  , &A5, &8B, &99, &98, 3     ; 1645: A4 42 A5... .B.
    EQUB &20, &B1, &2A, &20, &85, &22, &A4, &42, &B0, &2C, &38, &E9   ; 1651: 20 B1 2A...  .*
    EQUB 1  , &30, &27, &99, &B0, 3  , &A5, &2B, &38, &E9, 9  , &AA   ; 165D: 01 30 27... .0'
    EQUB &A5, &2A, &CA, &F0, &0C, &10, 6  , &4A, &E8, &D0, &FC, &F0   ; 1669: A5 2A CA... .*.
    EQUB 4  , &0A, &CA, &D0, &FC, &99, &C8, 3  , &B9, &8C, 1  , &29   ; 1675: 04 0A CA... ...
    EQUB &70, 5  , &37, &4C, &AD, &2A, &A4, &42, &B9, &8C, 1  , 9     ; 1681: 70 05 37... p.7
    EQUB &80, &99, &8C, 1  , &60, &A0, &25, &20, &A5, &0C, &A5, &7D   ; 168D: 80 99 8C... ...
    EQUB &85, &55, &D0, &0E, &C4, &7C, &90, &0A, &C6, &68, &A5, &7C   ; 1699: 85 55 D0... .U.
    EQUB &85, &41, &A5, &42, &85, &67, &60, &86, &45, &BD, &3C, 1     ; 16A5: 85 41 A5... .A.
    EQUB &AA, &BD, &8C, 1                                             ; 16B1: AA BD 8C... ...
    EQUS "05)"                                                        ; 16B5: 30 35 29    05)
    EQUB &0F, &85, &37, &BD, &80, 3  , &38, &E5, &0A, &85, &74, &BD   ; 16B8: 0F 85 37... ..7
    EQUB &98, 3  , &E5, &0B, &10, 6  , &C9, &E0, &90, &1E, &B0, 4     ; 16C4: 98 03 E5... ...
    EQUB &C9, &20, &B0, &18, 6  , &74, &2A, 6  , &74, &2A, &18, &69   ; 16D0: C9 20 B0... . .
    EQUB &20, &DD, &4D, &A9, 0  , &85, &64, &20, &EA, &18, &20, &E2   ; 16DC: 20 DD 4D...  .M
    EQUB &7B, &2C, &F4, 5  , &70, &0B, &A2, 0  , &20, &11, &50, &20   ; 16E8: 7B 2C F4... {,.
    EQUB 5  , &18, &20, &CE, &11, &A9, 0  , &8D, &F4, 5  , &20, &77   ; 16F4: 05 18 20... ..
    EQUB &0B                                                          ; 1700: 0B          .
    EQUS " RP J{ y"                                                   ; 1701: 20 52 50...  RP
    EQUB &15, &20, &A1, &46, &20, &F6                                 ; 1709: 15 20 A1... . .
    EQUS "$ &F "                                                      ; 170F: 24 20 26... $ &
    EQUB &B9, &24, &20, &FE, &0F, &20, &74, &0E, &20, &B6             ; 1714: B9 24 20... .$
    EQUS "f  "                                                        ; 171E: 66 20 20    f
    EQUB &1A, &20, &74, &0E, &20, &BC, &18, &20, &A4, &4C, &A2, &17   ; 1721: 1A 20 74... . t
    EQUB &20, &D1, &2A, &20, &12, &1B                                 ; 172D: 20 D1 2A...  .*
    EQUS " 7& "                                                       ; 1733: 20 37 26...  7&
    EQUB &15, &1E, &20, 0                                             ; 1737: 15 1E 20... ..
    EQUS "{ t"                                                        ; 173B: 7B 20 74    { t
    EQUB &0E                                                          ; 173E: 0E          .
    EQUS " DO "                                                       ; 173F: 20 44 4F...  DO
    EQUB &B9, &1B, &20, &1E, &11, &20, &E2, &7B, &AD, &43, &4F, &10   ; 1743: B9 1B 20... ..
    EQUB 3  , &EE, &43, &4F, &AD, &F6, &62, &F0, &37, &EE, &F6, &62   ; 174F: 03 EE 43... ..C
    EQUB &A9, &9C, &8D, &F7, &62, &AD, &F7, &62, &30, &FB, &AD        ; 175B: A9 9C 8D... ...
    EQUS ";_0"                                                        ; 1766: 3B 5F 30    ;_0
    EQUB &84, &A5, &6C, &10, &85, &AD, &3A, &5F, &F0, &83, &20, &F6   ; 1769: 84 A5 6C... ..l
    EQUB &43, &AD                                                     ; 1775: 43 AD       C.
    EQUS ";_0"                                                        ; 1777: 3B 5F 30    ;_0
    EQUB &EA, &A2, &30, &20, &FC, &17, &20, &63, &11, &AD, &F4, 5     ; 177A: EA A2 30... ..0
    EQUB &30, &32, &A9, &20, &8D, &F4, 5  , &D0, &2B, &A0, &0B, &20   ; 1786: 30 32 A9... 02.
    EQUB &E5, &0E, &AD, &F4, 5  , &F0, &0F, &10, &D8, &29, &40, &F0   ; 1792: E5 0E AD... ...
    EQUB &1B, &A5, 0  , &F0, &17, &A9, 0  , &8D, &F4, 5  , &A6, &0F   ; 179E: 1B A5 00... ...
    EQUB &F0, 5  , &CA, &F0, &C4, &86, &0F, &20, &74, &0E             ; 17AA: F0 05 CA... ...
    EQUS " :QL"                                                       ; 17B4: 20 3A 51...  :Q
    EQUB 1  , &17, &A9, &80, &20, &EA, &18                            ; 17B8: 01 17 A9... ...
    EQUS " #O`"                                                       ; 17BF: 20 23 4F...  #O
    EQUB &F8, &A9, 9  , &A4, &46, &CC, &19, &5A, &D0, 2  , &A9, &18   ; 17C3: F8 A9 09... ...
    EQUB &18, &7D, &B4, 6  , &9D, &B4, 6  , 8  , &BD, &CC, 6  , &69   ; 17CF: 18 7D B4... .}.
    EQUB 0  , &C9, &60, &90, 2  , &A9, 0  , &9D, &CC, 6  , &BD, &E4   ; 17DB: 00 C9 60... ..`
    EQUB 6  , &69, 0  , &9D, &E4, 6  , &10, &0A, &20, &11, &50, &A4   ; 17E7: 06 69 00... .i.
    EQUB &6F, &A9, &80, &99, &DC, 4  , &28, &D8                       ; 17F3: 6F A9 80... o..
    EQUS "` pM"                                                       ; 17FB: 60 20 70... ` p
    EQUB &A2                                                          ; 17FF: A2          .
    EQUS "- tM`"                                                      ; 1800: 2D 20 74... - t
    EQUB &A9, 0  , &A2, &68, &95, 0  , &CA, &10, &FB, &A2, &7F, &9D   ; 1805: A9 00 A2... ...
    EQUB &80, &62, &CA, &10, &FA, &20, &65, &0B, &A2, &17, &8E, &F9   ; 1811: 80 62 CA... .b.
    EQUB &62, &AD, &FF, &59, &9D, &E8, 8  , &AD, &FE, &59, &9D, &D0   ; 181D: 62 AD FF... b..
    EQUB 8  , &A9, 0  , &9D, &E8, 6  , &9D, &80, 8  , &CA, &10, &E9   ; 1829: 08 A9 00... ...
    EQUB &20, &A2, &63, &A9, 1                                        ; 1835: 20 A2 63...  .c
    EQUS "$l0"                                                        ; 183A: 24 6C 30    $l0
    EQUB &0E, &AE, &17, &5A, &A4, 3  , &20, &7F, &26, &20, &A2, &63   ; 183D: 0E AE 17... ...
    EQUB &AD, &18, &5A, &20, &9B, &10, &A2, &13, &A9, &80, &9D, &8C   ; 1849: AD 18 5A... ..Z
    EQUB 1  , &9D, &DC, 4  , &A9, 0  , &9D, &B4, 4  , &9D, &14, 1     ; 1855: 01 9D DC... ...
    EQUB &9D, &64, 1  , &9D, &50, 1  , &9D, 0  , 1  , &9D, &50, &38   ; 1861: 9D 64 01... .d.
    EQUB &A9, &FF, &9D, &A4, 1  , &CA, &10, &DC, &A9, 1  , &85, &40   ; 186D: A9 FF 9D... ...
    EQUB &85, &30, &A2, 7  , &86, 9  , &CA, &86, 6  , &86, 8  , &CA   ; 1879: 85 30 A2... .0.
    EQUB &9D, &93, &62, &CA, &10, &FA, &20, &D0, &42, &A5, &6C, &30   ; 1885: 9D 93 62... ..b
    EQUB &13, &A2, &28, &20, &FC, &17, &A2, 1  , &20, &11, &50, &20   ; 1891: 13 A2 28... ..(
    EQUB &1D, &50, &A9, &DF, &8D, &EF, &62, &60, &85, &66, &8D, &FE   ; 189D: 1D 50 A9... .P.
    EQUB &62, &A2                                                     ; 18A9: 62 A2       b.
    EQUS "+ tM"                                                       ; 18AB: 2B 20 74... + t
    EQUB &A2                                                          ; 18AF: A2          .
    EQUS ", pM"                                                       ; 18B0: 2C 20 70... , p
    EQUB &A5, 3  , &20, &C8, &65, &85, &2F, &60, &A6, &51, &A4, &1F   ; 18B4: A5 03 20... ..
    EQUB &BD, &B8, &5E, &18, &69, &14, &10, &0C, &BD, &90, &5E, &18   ; 18C0: BD B8 5E... ..^
    EQUB &69, &14, &30, 4  , &A9, &20, &D0, 2  , &A9, &23, &99, &60   ; 18CC: 69 14 30... i.0
    EQUB &5F, &A9, &21, &A0, &4F, &BE, &60, &5F, &F0, 1  , &8A, &99   ; 18D8: 5F A9 21... _.!
    EQUB &60, &5F, &88, &10, &F4, &60, &85, &74, &A2, 3  , &BD, &2F   ; 18E4: 60 5F 88... `_.
    EQUB &19, &95, &70, &CA, &10, &F8, &A2, 0  , &A0, &4F, &A9, 0     ; 18F0: 19 95 70... ..p
    EQUB &85                                                          ; 18FC: 85          .
    EQUS "v$t0"                                                       ; 18FD: 76 24 74... v$t
    EQUB 4  , &B1, &70, &91, &72, &B1, &72, &91, &70, &E6, &76, &88   ; 1901: 04 B1 70... ..p
    EQUB &98, &DD, 0  , &39, &D0, &EB, &A5, &72, &38, &E5, &76, &85   ; 190D: 98 DD 00... ...
    EQUB &72, &B0, 2  , &C6, &73, &A5, &70, &18, &69, &80, &85, &70   ; 1919: 72 B0 02... r..
    EQUB &90, 2  , &E6, &71, &E8, &E0, &29, &D0, &CA, &60, 0  , &30   ; 1925: 90 02 E6... ...
    EQUB &B0, &7F, &BD, &90, &5E, &18, &69, &14, &C9                  ; 1931: B0 7F BD... ...
    EQUS "(fv`"                                                       ; 193A: 28 66 76... (fv
    EQUB &8D, &70, &19, &84, &4B, &88, &84                            ; 193E: 8D 70 19... .p.
    EQUS "u 3"                                                        ; 1945: 75 20 33    u 3
    EQUB &19, &A4, &1F, &4C, &77, &19, &A5, &76, &10, 3  , &20, &33   ; 1948: 19 A4 1F... ...
    EQUB &19, &BD, &20, &5F, &C9, &50, &B0                            ; 1954: 19 BD 20... ..
    EQUS "$$v"                                                        ; 195B: 24 24 76    $$v
    EQUB &10, 5  , &DD, &21, &5F, &F0, &40, &C5, &7F, &B0, &3C, &85   ; 195E: 10 05 DD... ...
    EQUB &82, &8A, &4C, &73, &19, &99, 0  , 4  , &88, &C4, &82, &D0   ; 196A: 82 8A 4C... ..L
    EQUB &F8, &84, &7F, &E8, &30, &1A, &E4, &75, &90, &CE, &BD        ; 1976: F8 84 7F... ...
    EQUS " _0"                                                        ; 1981: 20 5F 30     _0
    EQUB 9  , &C5, &7F, &90, 5  , &A5, &7F, &9D, &20, &5F, &8A, 9     ; 1984: 09 C5 7F... ...
    EQUB &80, &AA, &A9, 0  , &F0, &D3, &A6, &50, &BD, &E0, &5E, &10   ; 1990: 80 AA A9... ...
    EQUB 5  , &E8, &E4, &75, &90, &F6, &86, &50, &60, &A9, &80, &1D   ; 199C: 05 E8 E4... ...
    EQUB &E0, &5E, &9D, &E0, &5E, &30, &CA, &84, &27, &85, &4C, &C5   ; 19A8: E0 5E 9D... .^.
    EQUB &4B, &B0, &68, &18, &79, &FC, &30, &85, &4F, &B9, &1E, &2B   ; 19B4: 4B B0 68... K.h
    EQUB &8D, &50, &2F, &8D, &92, &2F, &B9, &22, &2B, &8D, &4F, &2F   ; 19C0: 8D 50 2F... .P/
    EQUB &8D, &91, &2F, &A6, &4F, &A4                                 ; 19CC: 8D 91 2F... ../
    EQUS "L8 &+"                                                      ; 19D2: 4C 38 20... L8
    EQUB &E8, &C8, &C4, &4B, &B0, &42, &B9, &E0, &5E, &30, &F5, &A5   ; 19D7: E8 C8 C4... ...
    EQUB &4C, &C5, &50, &90, &10, &D0, &13, &B9, &DF, &5E, &29, 3     ; 19E3: 4C C5 50... L.P
    EQUB &D0, &1F, &84, &50, &38, &A5, &27, &F0, &1D, &A5, &8C, &18   ; 19EF: D0 1F 84... ...
    EQUB &90, &18, &B9, &DF, &5E, &29, 3  , &D0, &0C, &A5, &27, &C9   ; 19FB: 90 18 B9... ...
    EQUB 1  , &F0, &0B, &C9, 2  , &F0, 7  , &A9, 0  , &0A, &0A, &18   ; 1A07: 01 F0 0B... ...
    EQUS "e2 &+"                                                      ; 1A13: 65 32 20... e2
    EQUB &84, &4C, &86, &4F, &4C, &D7, &19, &60, &A9, &80, &85, &70   ; 1A18: 84 4C 86... .L.
    EQUB &A5, &51, &18, &69, &28, &AA, &C9, &31, &B0, 2  , &A9, &31   ; 1A24: A5 51 18... .Q.
    EQUB &85, &50, &A9, 0  , &85, &72, &85, &8E, &A4, &12, &20, &3E   ; 1A30: 85 50 A9... .P.
    EQUB &19, &A0, 0  , &84, &32, &A5, &50, &20, &AF, &19, &A9, 8     ; 1A3C: 19 A0 00... ...
    EQUB &85, &32, &A0, 0  , &84, &8C, &C8, &A5, &51, &18             ; 1A48: 85 32 A0... .2.
    EQUS "i( "                                                        ; 1A52: 69 28 20    i(
    EQUB &AF, &19, &A5, &50, &A2, 4  , &20, &98, &1A, &84, &2C, &A5   ; 1A55: AF 19 A5... ...
    EQUB &51, &AA, &C9, 9  , &B0, 2  , &A9, 9  , &85, &50, &A6, &51   ; 1A61: 51 AA C9... Q..
    EQUB &A9, &50, &A4, &15, &20, &3E, &19, &A9, &1C, &85, &8C, &A9   ; 1A6D: A9 50 A4... .P.
    EQUB &10, &85, &32, &A0, 2  , &A5, &51, &20, &AF, &19, &A9, &1C   ; 1A79: 10 85 32... ..2
    EQUB &85, &32, &A0, 3  , &A5, &50, &20, &AF, &19, &A5, &50, &A2   ; 1A85: 85 32 A0... .2.
    EQUB &14, &20, &98, &1A, &84, &29, &60, &86, &88, &85, &75, &C6   ; 1A91: 14 20 98... . .
    EQUB &4B, &AD, &F2, &62, &C9, &28, &90, &60, &B0, &64, &BC, &20   ; 1A9D: 4B AD F2... K..
    EQUB &5F, &C0, &50, &B0, &55, &BD, &E0                            ; 1AA9: 5F C0 50... _.P
    EQUS "^0P"                                                        ; 1AB0: 5E 30 50    ^0P
    EQUB &A5, &88, &C9, &14, &F0, &0B, &BD, &A0, &5E, &85, &77, &BD   ; 1AB3: A5 88 C9... ...
    EQUB &90, &5E, &4C, &CC, &1A, &BD, &90, &5E, &85, &77, &BD, &A0   ; 1ABF: 90 5E 4C... .^L
    EQUB &5E, &18, &69, &14, &30, &32, &A5, &77, &18, &69, &14, &10   ; 1ACB: 5E 18 69... ^.i
    EQUB &2B, &BD, &E1, &5E, &10, 7  , &E8, &E6, &75, &E4, &4B, &90   ; 1AD7: 2B BD E1... +..
    EQUB &F4, &B9, &60, &5F, &85, &74, &B9, &60, &5F, &F0, &0B, &29   ; 1AE3: F4 B9 60... ..`
    EQUB &1C, &C5, &88, &F0, 5                                        ; 1AEF: 1C C5 88... ...
    EQUS "jEt0"                                                       ; 1AF4: 6A 45 74... jEt
    EQUB &0A, &BD, &E0, &5E, &29, 3  , 5  , &88, &99, &60, &5F, &E6   ; 1AF8: 0A BD E0... ...
    EQUB &75, &A6, &75, &E4, &4B, &90, &9C, &A6, &50, &BC, &20, &5F   ; 1B04: 75 A6 75... u.u
    EQUB &C8, &60, &A0, 0  , &C4, &57, &F0, &67, &BE, &B4, &62, &84   ; 1B10: C8 60 A0... .`.
    EQUB &56, &B9, &99                                                ; 1B1C: 56 B9 99    V..
    EQUS "b) "                                                        ; 1B1F: 62 29 20    b)
    EQUB &F0, 5  , &A9, &0F, &8D, &FE, &38, &B9, &BA, &62, &85, &75   ; 1B22: F0 05 A9... ...
    EQUB &B9, &B7, &62, &0A, &26, &75, &85, &74, &18                  ; 1B2E: B9 B7 62... ..b
    EQUS "}@^"                                                        ; 1B37: 7D 40 5E    }@^
    EQUB &85, &76, &BD, &90                                           ; 1B3A: 85 76 BD... .v.
    EQUS "^eu"                                                        ; 1B3E: 5E 65 75    ^eu
    EQUB &C9, &18, &90, 4  , &C9, &E8, &90, &2B, 6  , &76, &2A, 6     ; 1B41: C9 18 90... ...
    EQUB &76, &2A, &18, &69, &50, &85, &35, &BD, &20, &5F, &85, &36   ; 1B4D: 76 2A 18... v*.
    EQUB &A0, 2  , 6                                                  ; 1B59: A0 02 06    ...
    EQUS "t&u"                                                        ; 1B5C: 74 26 75    t&u
    EQUB &88, &D0, &F9, &A5, &75, &10, 5  , &49, &FF, &18, &69, 1     ; 1B5F: 88 D0 F9... ...
    EQUB &85, &2A, &A9, 6  , &85, &37, &20, &B4, &1F, &A9, &F0, &8D   ; 1B6B: 85 2A A9... .*.
    EQUB &FE, &38, &A4, &56, &C8, &4C, &14, &1B, &A9, 0  , &85, &57   ; 1B77: FE 38 A4... .8.
    EQUB &60, &A5, &2F, &F0, &1A, &F8, &18, &65, &31, &85, &31, &D8   ; 1B83: 60 A5 2F... `./
    EQUB &F0, &11, &C9, &21, &B0, &0D, &A2, 0  , &86, &2F, &86, &78   ; 1B8F: F0 11 C9... ...
    EQUB &A2, &0A, &A0, &18, &20, &D0, &37, &2C, &FE, &62, &10, &0E   ; 1B9B: A2 0A A0... ...
    EQUB &A4, &4D, &A9, &18                                           ; 1BA7: A4 4D A9... .M.
    EQUS " sf"                                                        ; 1BAB: 20 73 66     sf
    EQUB &A4, &5B, &A9                                                ; 1BAE: A4 5B A9    .[.
    EQUS "! sfN"                                                      ; 1BB1: 21 20 73... ! s
    EQUB &FE, &62, &60, &A5, &68, &F0, &5E, &A9, 0  , &85             ; 1BB6: FE 62 60... .b`
    EQUS "h8fv"                                                       ; 1BC0: 68 38 66... h8f
    EQUB &A9, &25, &38, &E5, &41, &B0, 2  , &A9, 5  , &0A, &85, &75   ; 1BC4: A9 25 38... .%8
    EQUB &A6, &67, &A4, &6F, &C9, &28, &90, 7  , &A5, &6C, &10, 3     ; 1BD0: A6 67 A4... .g.
    EQUB &20, &AB, &11, &BD, &98, 3  , &38, &E5, &0B, &0A, &0A, 8     ; 1BDC: 20 AB 11...  ..
    EQUB &B9, &50, 1  , &E0, &14, &B0, &0F, &DD, &50, 1  , &B0, 5     ; 1BE8: B9 50 01... .P.
    EQUB &BD, &50, 1  , &D0, 5  , &69, &0B, &9D, &50, 1  , &20, 0     ; 1BF4: BD 50 01... .P.
    EQUB &0C, &C9, &10, &90, 2  , &A9, &10                            ; 1C00: 0C C9 10... ...
    EQUS "( @"                                                        ; 1C07: 28 20 40    ( @
    EQUB &0E, &8D, &E2, &62, &A9, &80, &8D, &A6, &62, &8D, &A7, &62   ; 1C0A: 0E 8D E2... ...
    EQUB &A9, 4  , &20, &47, &0B, &60, &84, &7B, &A6, &79, &86, &78   ; 1C16: A9 04 20... ..
    EQUB &29, 3  , &AA, &BD, &8F, &62, &85, &79, &A5, &85, &85, &7C   ; 1C22: 29 03 AA... )..
    EQUB &A5, &84, &29, &0C, &4A, &4A, &AA, &BD, &8F, &62, &85, &76   ; 1C2E: A5 84 29... ..)
    EQUB &A9, 0  , &85, &70, &C0, 1  , &D0, &18, &A5, &7E, &10, 7     ; 1C3A: A9 00 85... ...
    EQUS "8ji"                                                        ; 1C46: 38 6A 69    8ji
    EQUB 0  , &4C, &4E, &1C, &4A, &18, &65, &35, &85                  ; 1C49: 00 4C 4E... .LN
    EQUS "~JJ"                                                        ; 1C52: 7E 4A 4A    ~JJ
    EQUB &85, &85, &4C, &66, &1C, &A5, &8D, &85, &85, &A5, &8F, &85   ; 1C55: 85 85 4C... ..L
    EQUB &7E, &C0, 0  , &D0, &15, &A5, &83, &10, 7                    ; 1C61: 7E C0 00... ~..
    EQUS "8ji"                                                        ; 1C6A: 38 6A 69    8ji
    EQUB 0  , &4C, &72, &1C, &4A, &18, &65, &35, &85, &8F, &4A, &4A   ; 1C6D: 00 4C 72... .Lr
    EQUB &85, &8D, &A5, &85, &C9, &14                                 ; 1C79: 85 8D A5... ...
    EQUS "&tJfp"                                                      ; 1C7F: 26 74 4A... &tJ
    EQUB &18, &69, &30, &85, &71, &A6, &85, &E0, &28, &90, 3  , &4C   ; 1C84: 18 69 30... .i0
    EQUB &94, &1D, &A5, &47, &DD, 0  , &39, &B0, 3  , &BD, 0  , &39   ; 1C90: 94 1D A5... ...
    EQUB &85, &82, &C5, &7F, &90, 8  , &C0, 1  , &D0, 1               ; 1C9C: 85 82 C5... ...
    EQUS "`L|"                                                        ; 1CA6: 60 4C 7C    `L|
    EQUB &1D, &A5, &84, &29, &10, &F0, &13, &98, &F0, &10             ; 1CA9: 1D A5 84... ...
    EQUS "Et)"                                                        ; 1CB3: 45 74 29    Et)
    EQUB 1  , &F0, &0A, &A5, &84, &29, 3  , &AA, &BD, &8F, &62, &85   ; 1CB6: 01 F0 0A... ...
    EQUB &76, &A5, &7E, &29, 3  , &AA, &BD, &E8, &3F, &49, &FF, &25   ; 1CC2: 76 A5 7E... v.~
    EQUB &76, &85, &76, &C0, 1  , &B0, &40, &BD                       ; 1CCE: 76 85 76... v.v
    EQUS "|3%x"                                                       ; 1CD6: 7C 33 25... |3%
    EQUB &85, &74, &A5, &79, &3D, &FC, &33, 5  , &74, &3D, &E8, &3F   ; 1CDA: 85 74 A5... .t.
    EQUB 5  , &76, &85, &7A, &A5, &48, &F0, &0F, &A9, 0  , &85, &48   ; 1CE6: 05 76 85... .v.
    EQUB &A5, &8C, &85, &7D, &49, &FF                                 ; 1CF2: A5 8C 85... ...
    EQUS "%zL%"                                                       ; 1CF8: 25 7A 4C... %zL
    EQUB &1D, &A6, &85, &E4, &8D, &D0, 7  , &A5, &7A, &85             ; 1CFC: 1D A6 85... ...
    EQUS "yL|"                                                        ; 1D06: 79 4C 7C    yL|
    EQUB &1D, &A5, &7A, &D0, 2  , &A9, &55, &A4, &7F, &4C, &E8, &1D   ; 1D09: 1D A5 7A... ..z
    EQUB &D0, &1D, &BD, &7C, &33, &85, &7D, &49, &FF                  ; 1D15: D0 1D BD... ...
    EQUS "%y="                                                        ; 1D1E: 25 79 3D    %y=
    EQUB &E8, &3F, 5  , &76, &A6, &85, &E4, &8D, &D0, &19, &85, &79   ; 1D21: E8 3F 05... .?.
    EQUB &A5, &7D, &85, &8C                                           ; 1D2D: A5 7D 85... .}.
    EQUS "fH`"                                                        ; 1D31: 66 48 60    fH`
    EQUB &A5, &8C, &1D, &D0, &39, &85, &7D, &49, &FF                  ; 1D34: A5 8C 1D... ...
    EQUS "%x="                                                        ; 1D3D: 25 78 3D    %x=
    EQUB &E8, &3F, 5  , &76, &85, &7A, &A9, 0  , &85, &8C, &A4, &7F   ; 1D40: E8 3F 05... .?.
    EQUB &4C, &6B, &1D, &B1, &70, &F0, &0A, &C9, &55, &D0, 9  , &A5   ; 1D4C: 4C 6B 1D... Lk.
    EQUB &7A, &D0, &0D, &F0, 9  , &20, &9E, &1E, &25, &7D, 5  , &7A   ; 1D58: 7A D0 0D... z..
    EQUB &D0, 2  , &A9, &55, &91, &70, &88, &C4, &82, &D0, &E0, &A6   ; 1D64: D0 02 A9... ...
    EQUB &7B, &E0, 1  , &F0, &1E, &E6, &85, &20, &AF, &1D, &C6, &85   ; 1D70: 7B E0 01... {..
    EQUB &A5, &7C, &C9, &28, &90, 4  , &A9, &FF, &85, &7C, &A5, &85   ; 1D7C: A5 7C C9... .|.
    EQUB &18, &E5, &7C, &F0, 6  , &30, 4  , &AA, &20, &38, &1E, &60   ; 1D88: 18 E5 7C... ..|
    EQUB &A4, &7B, &C0, 1  , &F0, &F9, &A5, &7C, &C9, &28, &B0, &F3   ; 1D94: A4 7B C0... .{.
    EQUB &A9, &28, &85, &85, &D0, &E0, &8E, &DE, &1D, &8C, &D5, &1D   ; 1DA0: A9 28 85... .(.
    EQUB &8D, &DC, &1D, &A5, &85, &C9, &28, &B0, &2F, &18             ; 1DAC: 8D DC 1D... ...
    EQUS "i`J"                                                        ; 1DB6: 69 60 4A    i`J
    EQUB &85, &71, &A9, 0  , &6A, &85, &70, &A4, &7F, &4C, &E0, &1D   ; 1DB9: 85 71 A9... .q.
    EQUB &C9, &55, &D0, 2  , &A9, 0  , &91, &72, &88, &C4, &82, &F0   ; 1DC5: C9 55 D0... .U.
    EQUB &12, &B1, &70, &D0, 9  , &20, &9E, &1E, &D0, 2  , &A9, &55   ; 1DD1: 12 B1 70... ..p
    EQUB &91, &70, &88, &C4, &82, &D0, &EE, &60, &91, &70, &88, &C4   ; 1DDD: 91 70 88... .p.
    EQUB &82, &D0, &F9, &4C, &7C, &1D, &85, &42, &86, &85, &84, &7F   ; 1DE9: 82 D0 F9... ...
    EQUB &BD, 0  , &39, &85, &82, &A2, &72, &A0, &EF, &A9, 0  , &20   ; 1DF5: BD 00 39... ..9
    EQUB &A6, &1D, &A2, &70, &A0, 9  , &A9, &55, &E6, &85, &20, &A6   ; 1E01: A6 1D A2... ...
    EQUB &1D, &A6, &85, &E4, &42, &D0, &DD, &60, &A9, 5  , &85, &73   ; 1E0D: 1D A6 85... ...
    EQUB &A9, 4  , &85, &72, &A0, &1B, &A2, 3  , &A9, 6  , &20, &EF   ; 1E19: A9 04 85... ...
    EQUB &1D, &A9, &44, &85, &73, &A9, 0  , &85, &72, &A0, &2B, &A2   ; 1E25: 1D A9 44... ..D
    EQUB &1A, &A9, &22, &20, &EF, &1D, &60, &A5, &78, &D0, 2  , &A9   ; 1E31: 1A A9 22... .."
    EQUB &55, &85, &76, &A9, &7F, &38, &E5, &7F, &85                  ; 1E3D: 55 85 76... U.v
    EQUS "teG"                                                        ; 1E46: 74 65 47    teG
    EQUB &85, &86, &A5, &85, &85, &75, &18                            ; 1E49: 85 86 A5... ...
    EQUS "i_J"                                                        ; 1E50: 69 5F 4A    i_J
    EQUB &85, &71, &85, &73, &A9, 0  , &6A, &38, &E5, &74, &85, &70   ; 1E53: 85 71 85... .q.
    EQUB &49, &80, &85, &72, &10, 2  , &C6, &73, &B0, 4  , &C6, &71   ; 1E5F: 49 80 85... I..
    EQUB &C6, &73, &A4, &75, &B9, &4F, &3F, &88, &88, &84, &75, &C5   ; 1E6B: C6 73 A4... .s.
    EQUB &47, &90, &0A, &65, &74, &A8, &10, 7  , &E0, 2  , &B0, &10   ; 1E77: 47 90 0A... G..
    EQUB &60, &A4, &86, &A5, &76, &E0, 2  , &90, &0C, &91, &70, &91   ; 1E83: 60 A4 86... `..
    EQUB &72, &C8, &10, &F9, &CA, &CA, &D0, &D2, &60, &91, &70, &C8   ; 1E8F: 72 C8 10... r..
    EQUB &10, &FB, &60, &C4, &1F, &90, 6  , &F0, 4  , &AD, &FD, &38   ; 1E9B: 10 FB 60... ..`
    EQUB &60, &A5, &85, &D9, &54, 5  , &B0, &18, &D9, 0  , 6  , &B0   ; 1EA7: 60 A5 85... `..
    EQUB &21, &D9, &50, 6  , &B0, &0A, &D9, &A4, 5  , &B0, &0D, &B9   ; 1EB3: 21 D9 50... !.P
    EQUB &60, &5F, &90, &1F, &AD, &FC, &38, &60, &AD, &FF, &38, &60   ; 1EBF: 60 5F 90... `_.
    EQUB &C4, &2C, &B0, &F8, &B9, 0  , 4  , &4C, &DC, &1E, &C4, &29   ; 1ECB: C4 2C B0... .,.
    EQUB &B0, &EE, &B9, &50, 4  , &29, &7F, &AA, &BD, &DF, &5E, &29   ; 1ED7: B0 EE B9... ...
    EQUB 3  , &AA, &BD, &FC                                           ; 1EE3: 03 AA BD... ...
    EQUS "8` "                                                        ; 1EE7: 38 60 20    8`
    EQUB &C5, &63, &D0, 3  , &4C, &2D, &16, &B0, &FB, &C9, 5  , &B0   ; 1EEA: C5 63 D0... .c.
    EQUB &11, &4C, &F4, &15, &20, &C5, &63, &F0, 6  , &B0, 4  , &A5   ; 1EF6: 11 4C F4... .L.
    EQUB &76, &D0, &0C, &4C, &95, &1F, &A5, &74, &49, 1  , &4A, &A9   ; 1F02: 76 D0 0C... v..
    EQUB 3  , &E9, 0  , &A2, &32, &C9, 2  , &F0, 2  , &A2, &0A, &AD   ; 1F0E: 03 E9 00... ...
    EQUB &A2, &62, &85, &76, &4A, &AD, &A5, &62, &90, &0C, &A9, 0     ; 1F1A: A2 62 85... .b.
    EQUB &38, &E5, &76, &85, &76, &A9, 0  , &ED, &A5, &62, &18, &69   ; 1F26: 38 E5 76... 8.v
    EQUB 1  , &E0, &32, &D0, 2  , &E9, 2  , &85, &77, &BD             ; 1F32: 01 E0 32... ..2
    EQUS "@^8"                                                        ; 1F3C: 40 5E 38    @^8
    EQUB &E5, &76, &85, &74, &BD, &90, &5E, &E5, &77, 8  , &20, &40   ; 1F3F: E5 76 85... .v.
    EQUB &0E, &85, &76, &A4, &22, &A9, &3C, &38, &E5, &63, &10, 2     ; 1F4B: 0E 85 76... ..v
    EQUB &A9, 0  , &0A, &69, &20, &85, &75, &B9, 1  , 7  , &29, &7F   ; 1F57: A9 00 0A... ...
    EQUB &C9, &40, &90, 2  , &A9, 2  , &C9, 8  , &90, 2  , &A9, 7     ; 1F63: C9 40 90... .@.
    EQUB &0A, &0A, &0A, &0A, &C5, &75, &90, 2  , &85, &75, &20, &BF   ; 1F6F: 0A 0A 0A... ...
    EQUB &0D, &A5                                                     ; 1F7B: 0D A5       ..
    EQUS "u( @"                                                       ; 1F7D: 75 28 20... u(
    EQUB &0E, &85, &75, &A5, &74, &29, &FE, &85, &74, &AD, &A2, &62   ; 1F81: 0E 85 75... ..u
    EQUB &4A, &B0, 5  , &20, &44, &0E, &85, &75, &AD, &A2, &62, &4C   ; 1F8D: 4A B0 05... J..
    EQUB &12, &16, &90, &0A, &AD, &A2, &62, &29, &FE, &85, &74, &AD   ; 1F99: 12 16 90... ...
    EQUB &A5, &62, &60, &90, 5  , &BD, &80, 8  , &C9, 3  , &6E, &FB   ; 1FA5: A5 62 60... .b`
    EQUB &62, &60, &EA, &86, &74, &A2, 3  , &BD, &FC, &38, &9D, &8F   ; 1FB1: 62 60 EA... b`.
    EQUB &62, &CA, &10, &F7, &A9, &F0, &8D, &FE, &38, &A5, &74, &C9   ; 1FBD: 62 CA 10... b..
    EQUB &17, &F0, &12, &C9, &14, &90, 5  , &A6, &4D, &BD, &3C, 1     ; 1FC9: 17 F0 12... ...
    EQUB &29, 3  , &AA, &BD, &FC, &38, &8D, &90, &62, &A2, 0  , &86   ; 1FD5: 29 03 AA... )..
    EQUB &2B, &A5, &2A, &CD, &FC, &62, &B0, 2  , &A6, &1F, &8E, &FD   ; 1FE1: 2B A5 2A... +.*
    EQUB &62, &C9, &40, &B0, 8  , &0A, &0A, &85, &2A, &A9, 2  , &85   ; 1FED: 62 C9 40... b.@
    EQUB &2B, &A6, &37, &E0, &0A, &90, 2  , &A2, 9  , &8E, &F3, &62   ; 1FF9: 2B A6 37... +.7
    EQUB &BD, &DD, &3C, &85, &81, &BD, &DE, &3C, &85, &8A, &BD, &D0   ; 2005: BD DD 3C... ..<
    EQUB &3C, &85, &8E                                                ; 2011: 3C 85 8E    <..
    EQUS " * "                                                        ; 2014: 20 2A 20     *
    EQUB &B0, &10, &20, &9A, &20, &A6, &37, &AD, &F3, &62, &C9, 9     ; 2017: B0 10 20... ..
    EQUB &D0, 4  , &A5, &25, &10, &D9, &60, &A5, &2A, &8D, &FA, &5F   ; 2023: D0 04 A5... ...
    EQUB &4A, &8D, &FB, &5F, &4A, &8D, &FC, &5F, &4A, &8D, &FD, &5F   ; 202F: 4A 8D FB... J..
    EQUB &4A, &8D, &FE, &5F, &4A, &8D, &FF, &5F, &A4, &81, &A2, 0     ; 203B: 4A 8D FE... J..
    EQUB &86, &77, &B9, &80, &44, &10, &24, &29, 7  , &AA, &BD, &F8   ; 2047: 86 77 B9... .w.
    EQUB &5F, &85, &74, &B9, &80, &44, &85                            ; 2053: 5F 85 74... _.t
    EQUS "uJJJ)"                                                      ; 205A: 75 4A 4A... uJJ
    EQUB 7  , &AA, &BD, &F8, &5F, &18                                 ; 205F: 07 AA BD... ...
    EQUS "et$uP"                                                      ; 2065: 65 74 24... et$
    EQUB &0B, &18, &6D, &FB                                           ; 206A: 0B 18 6D... ..m
    EQUS "_Lv "                                                       ; 206E: 5F 4C 76... _Lv
    EQUB &AA, &BD, &F8, &5F, &A6, &2B, &F0, 6  , &4A, &CA, &D0, &FC   ; 2072: AA BD F8... ...
    EQUB &69, 0  , &A6, &77, &9D, &F8, &5E, &49, &FF, &10, &0F, &18   ; 207E: 69 00 A6... i..
    EQUB &69, 1  , &9D, 0  , &5F, &E6, &77, &C8, &C4, &8A, &D0, &B3   ; 208A: 69 01 9D... i..
    EQUB &18                                                          ; 2096: 18          .
    EQUS "`8`"                                                        ; 2097: 60 38 60    `8`
    EQUB &A4, &8E, &AD, &FC, &38, &85, &79, &A9, 0  , &85, &48, &85   ; 209A: A4 8E AD... ...
    EQUB &8C, &BE, &50, &35, &BD, &F8, &5E, &18                       ; 20A6: 8C BE 50... ..P
    EQUS "e60Z"                                                       ; 20AE: 65 36 30... e60
    EQUB &C9, &50, &90, 2  , &A9, &4F, &85, &7F, &BE, &D0, &35, &BD   ; 20B2: C9 50 90... .P.
    EQUB &F8, &5E, &18                                                ; 20BE: F8 5E 18    .^.
    EQUS "e60"                                                        ; 20C1: 65 36 30    e60
    EQUB 5  , &CD, &FD, &62, &B0, 5  , &AD, &FD, &62, &EA, &EA, &C5   ; 20C4: 05 CD FD... ...
    EQUB &7F, &B0, &39, &85, &47, &BE, &50, &36, &BD, &F8, &5E, &85   ; 20D0: 7F B0 39... ..9
    EQUB &7E, &BE, &D0, &36, &BD, &F8, &5E, &85, &83, &B9, &50, &37   ; 20DC: 7E BE D0... ~..
    EQUB &85, &84, &84, &1B, &A0, 1  , &20, &1C, &1C, &24, &84, &30   ; 20E8: 85 84 84... ...
    EQUB &22, &A9, 0  , &A0, 2  , &20, &1C, &1C, &24, &84, &70, 6     ; 20F4: 22 A9 00... "..
    EQUB &A4, &1B, &C8, &4C, &9C                                      ; 2100: A4 1B C8... ...
    EQUS " `)@"                                                       ; 2105: 20 60 29...  `)
    EQUB &D0, &FB, &C8, &B9                                           ; 2109: D0 FB C8... ...
    EQUS "P70"                                                        ; 210D: 50 37 30    P70
    EQUB &F6, &29, &40, &D0, &F1, &F0, &EB, &A4, &1B, &C8, &84, &1B   ; 2110: F6 29 40... .)@
    EQUB &BE, &50, &36, &BD, &F8, &5E, &85, &83, &B9, &D0, &36, &85   ; 211C: BE 50 36... .P6
    EQUB &84, &A0, 0  , &20, &1C, &1C, &A4, &1B, &BE, &50, &35, &BD   ; 2128: 84 A0 00... ...
    EQUB &F8, &5E, &85, &83, &B9, &50, &37, &85, &84, &A0, 0  , &20   ; 2134: F8 5E 85... .^.
    EQUB &1C, &1C, &4C, &F1, &20, &A0, 0  , &BD, 0  , 9  , &38, &F9   ; 2140: 1C 1C 4C... ..L
    EQUB &80, &62, &85, &80, &BD, 0  , &0A, &F9, &83, &62, &85, &86   ; 214C: 80 62 85... .b.
    EQUB &10, &0B, &A9, 0  , &38, &E5, &80, &85, &80, &A9, 0  , &E5   ; 2158: 10 0B A9... ...
    EQUB &86, &85, &83, &BD, 2  , 9  , &38, &F9, &82, &62, &85, &82   ; 2164: 86 85 83... ...
    EQUB &BD, 2  , &0A, &F9, &85, &62, &85, &88, &10, &0B, &A9, 0     ; 2170: BD 02 0A... ...
    EQUB &38, &E5, &82, &85, &82, &A9, 0  , &E5, &88, &85, &85, &C5   ; 217C: 38 E5 82... 8..
    EQUB &83, &90, 8  , &D0, &19, &A5, &82, &C5, &80, &B0, &13, &A5   ; 2188: 83 90 08... ...
    EQUB &85, &85, &79, &A5, &82, &85, &78, &A5, &80, &85, &7A, &A5   ; 2194: 85 85 79... ..y
    EQUB &83, &85, &7B, &4C, &C1, &21, 8  , &A5, &83, &85, &79, &A5   ; 21A0: 83 85 7B... ..{
    EQUB &80, &85, &78, &A5, &82, &85, &7A, &A5, &85, &85, &7B, &28   ; 21AC: 80 85 78... ..x
    EQUB &F0                                                          ; 21B8: F0          .
    EQUS "SL9", '"'                                                   ; 21B9: 53 4C 39... SL9
    EQUB 6  , &82, &26, &85, 6  , &80, &2A, &90, &F7, &6A, &85, &76   ; 21BD: 06 82 26... ..&
    EQUB &A5, &82, &85, &74, &A5, &85, &C5, &76, &F0                  ; 21C9: A5 82 85... ...
    EQUS ": G"                                                        ; 21D2: 3A 20 47    : G
    EQUB &0C, &A9, 0  , &85, &8A, &A4, &74, &B9, 0  , &61, &85        ; 21D5: 0C A9 00... ...
    EQUS "~Jf"                                                        ; 21E0: 7E 4A 66    ~Jf
    EQUB &8A, &4A, &66, &8A, &4A, &66, &8A, &85, &8B, &A5, &86, &45   ; 21E3: 8A 4A 66... .Jf
    EQUB &88, &30, &0D, &A9, 0  , &38, &E5, &8A, &85, &8A, &A9, 0     ; 21EF: 88 30 0D... .0.
    EQUB &E5, &8B, &85, &8B, &A9, &40, &24, &86, &10, 2  , &A9, &C0   ; 21FB: E5 8B 85... ...
    EQUB &18, &65, &8B, &85, &8B, &60, &A9, &FF, &85, &7E, &A9, 0     ; 2207: 18 65 8B... .e.
    EQUB &85, &8A, &24, &86, &10, &0E, &24, &88, &10, 5  , &A9, &A0   ; 2213: 85 8A 24... ..$
    EQUB &85, &8B, &60, &A9, &E0, &85, &8B, &60, &24, &88, &10, 5     ; 221F: 85 8B 60... ..`
    EQUB &A9, &60, &85, &8B, &60, &A9, &20, &85, &8B, &60, 6  , &80   ; 222B: A9 60 85... .`.
    EQUB &26, &83, 6  , &82, &2A, &90, &F7, &6A, &85, &76, &A5, &80   ; 2237: 26 83 06... &..
    EQUB &85, &74, &A5, &83, &C5, &76, &F0, &C2, &20, &47, &0C, &A9   ; 2243: 85 74 A5... .t.
    EQUB 0  , &85, &8A, &A4, &74, &B9, 0  , &61, &85                  ; 224F: 00 85 8A... ...
    EQUS "~Jf"                                                        ; 2258: 7E 4A 66    ~Jf
    EQUB &8A, &4A, &66, &8A, &4A, &66, &8A, &85, &8B, &A5, &86, &45   ; 225B: 8A 4A 66... .Jf
    EQUB &88, &10, &0D, &A9, 0  , &38, &E5, &8A, &85, &8A, &A9, 0     ; 2267: 88 10 0D... ...
    EQUB &E5, &8B, &85, &8B, &A9, 0  , &24, &88, &10, 2  , &A9, &80   ; 2273: E5 8B 85... ...
    EQUB &18, &65, &8B, &85, &8B, &60, &A0, 0  , &BD, 1  , 9  , &38   ; 227F: 18 65 8B... .e.
    EQUB &F9, &81, &62, &85, &81, &BD, 1  , &0A, &F9, &84, &62, &85   ; 228B: F9 81 62... ..b
    EQUB &87, &10, &0B, &A9, 0  , &38, &E5, &81, &85, &81, &A9, 0     ; 2297: 87 10 0B... ...
    EQUB &E5, &87, &4A, &66, &81, &4A, &66, &81, &4A, &66, &81, &85   ; 22A3: E5 87 4A... ..J
    EQUB &84, &C5, &7D, &90, &0A, &D0, 6  , &A5, &81, &C5, &7C, &90   ; 22AF: 84 C5 7D... ..}
    EQUB 2  , &38, &60, &A0, 0  , &A5, &7D, &4C, &CA, &22, 6  , &81   ; 22BB: 02 38 60... .8`
    EQUB &26, &84, &C8, 6  , &7C, &2A, &90, &F6, &6A, &85, &76, &84   ; 22C7: 26 84 C8... &..
    EQUB &2B, &A8, &B9, &80, &61, &85, &2A, &A5, &81, &85, &74, &A5   ; 22D3: 2B A8 B9... +..
    EQUB &84, &20, &47, &0C, &A5, &74, &C9, &80, &B0, &15, &24, &87   ; 22DF: 84 20 47... . G
    EQUB &10, 8  , &A9, &3C, &38, &E5, &74, &4C, &F8, &22, &18        ; 22EB: 10 08 A9... ...
    EQUS "i<8"                                                        ; 22F6: 69 3C 38    i<8
    EQUB &E5, &0D, &85, &8D, &18, &60, &AD, &F5, &62, &F0, 8  , &20   ; 22F9: E5 0D 85... ...
    EQUB &A0, &12, &A9, 0  , &8D, &F5, &62, &A4, 5  , &C0, 6  , &F0   ; 2305: A0 12 A9... ...
    EQUB &EC, &A4, 6  , &C0, 6  , &F0, &18, &C4, 8  , &F0, &0F, &84   ; 2311: EC A4 06... ...
    EQUB &74, &98, &18, &69, &28, &A8, &20, &A2, &0B, &A4, &74, &20   ; 231D: 74 98 18... t..
    EQUB &A2, &0B, &C8, &C0, 6  , &90, &E8, &A9, 6  , &38, &E5, 8     ; 2329: A2 0B C8... ...
    EQUB &0A, &0A, &0A, &24, &25, &10, &13, &85, &74, &AD, &FF, 6     ; 2335: 0A 0A 0A... ...
    EQUB &18, &69, 8  , &38, &E5, &74, &B0, &12, &6D, &FA             ; 2341: 18 69 08... .i.
    EQUS "YL[#"                                                       ; 234B: 59 4C 5B... YL[
    EQUB &18, &6D, &FF, 6  , &CD, &FA, &59, &90, 3  , &ED, &FA, &59   ; 234F: 18 6D FF... .m.
    EQUB &A8, &84, 4  , &A6, 8  , &86, &42, &A2, &FD, &20, 8  , &12   ; 235B: A8 84 04... ...
    EQUS " E!"                                                        ; 2367: 20 45 21     E!
    EQUB &A4                                                          ; 236A: A4          .
    EQUS "B$%"                                                        ; 236B: 42 24 25    B$%
    EQUB &10, 4  , &98, &49, &28, &A8, &20, &C0, &23, &A6, &42, &E0   ; 236E: 10 04 98... ...
    EQUB &28, &B0, &1D, &A2, &FD, &20, &85, &22, &A6, &42, &A5, &8D   ; 237A: 28 B0 1D... (..
    EQUB &9D, &20, &5F, &9D, &48, &5F, &C5, &1F, &90, &0A, &D0, 4     ; 2386: 9D 20 5F... . _
    EQUB &E4, &51, &90, 4  , &85, &1F, &86, &51, &8A, &18, &69, &28   ; 2392: E4 51 90... .Q.
    EQUB &C9, &3C, &B0, &0A, &AA, &A5, 4  , &18, &69, 3  , &A8        ; 239E: C9 3C B0... .<.
    EQUS "L`#"                                                        ; 23A9: 4C 60 23    L`#
    EQUB &A6, 8  , &CA, &20, &DC, &12, &A9, 7  , &C5, &52, &B0, 2     ; 23AC: A6 08 CA... ...
    EQUB &85, &1F                                                     ; 23B8: 85 1F       ..
    EQUS "` E!"                                                       ; 23BA: 60 20 45... ` E
    EQUB &A4, &12, &A5, &8A, &38, &E5, &0A, &99, &40, &5E, &A5, &8B   ; 23BE: A4 12 A5... ...
    EQUB &E5, &0B, &99, &90, &5E, &4C, &A5, &0C, &85, &12, &A9, 0     ; 23CA: E5 0B 99... ...
    EQUB &85, &42, &20, &BB, &23, &C5, &11, &90, 8  , &D0, &1B, &A5   ; 23D6: 85 42 20... .B
    EQUB &10, &C5, &7C, &90, &15, &A5, &7D, &85, &11, &A5, &7C, &85   ; 23E2: 10 C5 7C... ..|
    EQUB &10, &A5, &42, &85, &13, &A4, &12, &84, &5C, &B9, &90, &5E   ; 23EE: 10 A5 42... ..B
    EQUB &85, &5E, &20, &85, &22, &B0, 2  , &10, &67, &A5, &42, &D0   ; 23FA: 85 5E 20... .^
    EQUB 1  , &60, &A9, 0  , &85, &75, &A4, &14, &86, &77, &BD, 0     ; 2406: 01 60 A9... .`.
    EQUB 9  , &38, &F9, 0  , 9  , &85, &74, &BD, 0  , &0A, &F9, 0     ; 2412: 09 38 F9... .8.
    EQUB &0A, &18, &10, 1  , &38, 8                                   ; 241E: 0A 18 10... ...
    EQUS "jft(jft"                                                    ; 2424: 6A 66 74... jft
    EQUB &85, &76, &A6, &75, &B9, 0  , 9  , &18, &65, &74, &9D, &FA   ; 242B: 85 76 A6... .v.
    EQUB 9  , &B9, 0  , &0A, &65, &76, &9D, &FA, &0A, &E8, &E0, 3     ; 2437: 09 B9 00... ...
    EQUB &F0, &0B, &86, &75, &A6, &77, &C8, &E8, &86, &77, &4C, &10   ; 2443: F0 0B 86... ...
    EQUB &24, &A2, &FA, &20, &BB, &23, &20, &85, &22, &B0, &0F, &A6   ; 244F: 24 A2 FA... $..
    EQUB &14, &A5, &57, &85                                           ; 245B: 14 A5 57... ..W
    EQUS "V e%"                                                       ; 245F: 56 20 65... V e
    EQUB &A5, &56, &85, &57, &E6, &12                                 ; 2463: A5 56 85... .V.
    EQUS "` e%"                                                       ; 2469: 60 20 65... ` e
    EQUB &A5, &42, &C5, &13, &F0, &1D, &90, &1B, &A4, &12, &B9, &90   ; 246D: A5 42 C5... .B.
    EQUB &5E, &10, 2  , &49, &FF, &C9, &14, &90, &0E, &B9, &8F, &5E   ; 2479: 5E 10 02... ^..
    EQUB &10, 2  , &49, &FF, &C9, &14, &B0, &2B, &4C, 3  , &24, &86   ; 2485: 10 02 49... ..I
    EQUB &14, &E6, &12, &E6, &42, &A4, &42, &C0, &12, &B0, &1C, &B9   ; 2491: 14 E6 12... ...
    EQUB &D0, &3D, &85, &74, &8A, &38, &E5, &0E, &C5, &74, &B0, 7     ; 249D: D0 3D 85... .=.
    EQUB &8A, &18                                                     ; 24A9: 8A 18       ..
    EQUS "ixL"                                                        ; 24AB: 69 78 4C    ixL
    EQUB &B1, &24, &8A, &38, &E5, &74, &AA, &4C, &D8, &23, &60, &A5   ; 24AE: B1 24 8A... .$.
    EQUB &44, &38, &ED, &E2, &62, &10, 2  , &49, &FF, &0A, &C9, &80   ; 24BA: 44 38 ED... D8.
    EQUB &45, &25, &10, &0C, &90, 2  , &49, &7F, &C9, &FC, &B0, 4     ; 24C6: 45 25 10... E%.
    EQUB &20, &FB, &13, &60, &A5, &13, &C9, &0C, &F0, 5  , &B0, &0B   ; 24D2: 20 FB 13...  ..
    EQUB &20, &F3, &12, &24, &43, &10, &10, &20, &F3, &12, &60, &C9   ; 24DE: 20 F3 12...  ..
    EQUB &0E, &90, 8  , &F0, 3  , &20, &0B, &14, &20, &0B, &14, &60   ; 24EA: 0E 90 08... ...
    EQUB &A9, 0  , &85, &1F, &20, &FF, &22, &A9, &FF, &85, &11, &A9   ; 24F6: A9 00 85... ...
    EQUB &0D, &85, &13, &A9, 0                                        ; 2502: 0D 85 13... ...
    EQUS " J%"                                                        ; 2507: 20 4A 25     J%
    EQUB &A9, 6  , &20, &D2, &23, &A5, &12, &85, &15, &A9, &80        ; 250A: A9 06 20... ..
    EQUS " J%"                                                        ; 2515: 20 4A 25     J%
    EQUB &A9, &2E, &20, &D2, &23, &A5, &51, &C9, &28, &90, 5  , &38   ; 2518: A9 2E 20... ..
    EQUB &E9, &28, &85, &51, &A8, &84, &52, &A5, &1F, &C9, &4F, &90   ; 2524: E9 28 85... .(.
    EQUB 4  , &A9, &4E, &85, &1F, &99, &20, &5F, &99, &48, &5F, &B9   ; 2530: 04 A9 4E... ..N
    EQUB &90, &5E, &38, &F9, &B8                                      ; 253C: 90 5E 38... .^8
    EQUS "^ P4J"                                                      ; 2541: 5E 20 50... ^ P
    EQUB &8D, &FC, &62, &60, &A6                                      ; 2546: 8D FC 62... ..b
    EQUS "$E%"                                                        ; 254B: 24 45 25    $E%
    EQUB &10, &0A, &8A, &18, &69, &78, &AA, &A9, &78, &38, &D0, 3     ; 254E: 10 0A 8A... ...
    EQUB &A9, 0  , &18, &85, &0E, &A9, 0  , &2A, &85, &49, &60, &A4   ; 255A: A9 00 18... ...
    EQUB &49, &E0, &78, &B0, 5  , &BD, 2  , 7  , &90, 3  , &BD, &8A   ; 2566: 49 E0 78... I.x
    EQUB 6                                                            ; 2572: 06          .
    EQUS "9l0"                                                        ; 2573: 39 6C 30    9l0
    EQUB &85, &77, &29, 7  , &A8, &B9, &6E, &30, &85, &76, &A5, &42   ; 2576: 85 77 29... .w)
    EQUB &C9, 3  , &B0, 3  , &4C, &FD, &25, &A5, &2B, &38, &F9, &76   ; 2582: C9 03 B0... ...
    EQUB &30, &A8, &A9, 0  , &85, &75, &A5, &2A, &88, &F0, &10, &10   ; 258E: 30 A8 A9... 0..
    EQUB 8                                                            ; 259A: 08          .
    EQUS "Fuj"                                                        ; 259B: 46 75 6A    Fuj
    EQUB &C8, &D0, &FA, &F0, 6  , &0A, &26, &75, &88, &D0, &FA, &85   ; 259E: C8 D0 FA... ...
    EQUB &74, &A5                                                     ; 25AA: 74 A5       t.
    EQUS "IJjE%"                                                      ; 25AC: 49 4A 6A... IJj
    EQUB &10, &0D, &A9, 0  , &38, &E5, &74, &85, &74, &A9, 0  , &E5   ; 25B1: 10 0D A9... ...
    EQUB &75, &85, &75, &A4, &12, &B9, &40, &5E, &18, &65, &74, &99   ; 25BD: 75 85 75... u.u
    EQUB &50, &5E, &B9, &90                                           ; 25C9: 50 5E B9... P^.
    EQUS "^eu"                                                        ; 25CD: 5E 65 75    ^eu
    EQUB &99, &A0, &5E, &A5, &77, &29, &18, &F0, &24, &A4, &57, &C0   ; 25D0: 99 A0 5E... ..^
    EQUB 3  , &B0, &1E, &A5, &12, &99, &B4, &62, &A5, &77, &99, &99   ; 25DC: 03 B0 1E... ...
    EQUB &62, &29, 1  , &F0, 4                                        ; 25E8: 62 29 01... b).
    EQUS "Fuft"                                                       ; 25ED: 46 75 66... Fuf
    EQUB &A5, &74, &99, &B7, &62, &A5, &75, &99, &BA, &62, &E6, &57   ; 25F1: A5 74 99... .t.
    EQUB &8A, &29, 1  , &F0, 4  , &A9, 2  , &D0, 2  , &A5, &76, &A4   ; 25FD: 8A 29 01... .).
    EQUB &12, &99, &E0, &5E, &A5, &8D, &99, &20, &5F, &C9, &50, &B0   ; 2609: 12 99 E0... ...
    EQUB 8  , &C5, &1F, &90, 4  , &85, &1F, &84, &51, &60, &A2, &16   ; 2615: 08 C5 1F... ...
    EQUB &BD, &8C, 1  , 9  , &80, &9D, &8C, 1  , &CA, &10, &F5, &60   ; 2621: BD 8C 01... ...
    EQUB &A2, 6  , &C6, &74, &D0, &FC, &CA, &D0, &F9, &60, &AD        ; 262D: A2 06 C6... ...
    EQUS ";_0"                                                        ; 2638: 3B 5F 30    ;_0
    EQUB &F1, &A6, &5B, &BC, &3C, 1  , &B9, &8C, 1  , &29, &7F, &99   ; 263B: F1 A6 5B... ..[
    EQUB &8C, 1  , &20, &ED, &27, &20, &92, &26, &20, &1F, &26, &20   ; 2647: 8C 01 20... ..
    EQUB &A2, &63, &A6, 3  , &A0, 5  , &24, &25, &10, 6  , &20, &84   ; 2653: A2 63 A6... .c.
    EQUS "PLf& ~P"                                                    ; 265F: 50 4C 66... PLf
    EQUB &8C, &F4, &62, &86, &1D, &20, &F2, &28, &A6, &1D, &AC, &F4   ; 2666: 8C F4 62... ..b
    EQUB &62, &88, &10, &E3, &20, &DF, &66, &A6, &5B, &20, &F2, &28   ; 2672: 62 88 10... b..
    EQUB &60, &BD, &3C, 1  , &85, &74, &B9, &3C, 1  , &9D, &3C, 1     ; 267E: 60 BD 3C... `.<
    EQUB &AA, &A5, &74, &99, &3C, 1  , &A8, &60, &A6, 3  , &86, &77   ; 268A: AA A5 74... ..t
    EQUB &BD, &3C, 1  , &85                                           ; 2696: BD 3C 01... .<.
    EQUS "t ~P"                                                       ; 269A: 74 20 7E... t ~
    EQUB &BD, &3C, 1  , &86, &78, &A8, &A6, &74, &A9, 0  , &85, &7F   ; 269E: BD 3C 01... .<.
    EQUB &9D, &14, 1  , &20, &A4, &27, &B0, &34, &10, &35, &C9, &F6   ; 26AA: 9D 14 01... ...
    EQUB &90, &2E, &A6, &77, &A4, &78, &20, &7F                       ; 26B6: 90 2E A6... ...
    EQUS "&8n"                                                        ; 26BE: 26 38 6E    &8n
    EQUB &FE, &62, &C4, &6F, &D0, 4  , &A9, &99, &D0, 6  , &E4, &6F   ; 26C1: FE 62 C4... .b.
    EQUB &D0, &17, &A9, 1  , &85, &74, &B9, &B4, 4  , &26, &79, &FD   ; 26CD: D0 17 A9... ...
    EQUB &B4, 4  , &D0, 9  , &F8, &18, &A5                            ; 26D9: B4 04 D0... ...
    EQUS "te/"                                                        ; 26E0: 74 65 2F    te/
    EQUB &85, &2F, &D8, &4C, &8C, &27, &C9, 5  , &B0, &F9, &BD, &50   ; 26E3: 85 2F D8... ./.
    EQUB &38, &18, &F9, &50, &38, &BD, &50, 1  , &F9, &50, 1  , &66   ; 26EF: 38 18 F9... 8..
    EQUB &76, &10, &E8, &4A, &C9, &1E, &90, 2  , &A9, &1E, &C9, 4     ; 26FB: 76 10 E8... v..
    EQUB &B0, 2  , &A9, 4  , &85, &83, &A5, &74, &C9, 4  , &B9, 0     ; 2707: B0 02 A9... ...
    EQUB 1  , &29, &40, &F0, &11, &B0, 2  , 9  , &80, &85, &7F, &BD   ; 2713: 01 29 40... .)@
    EQUB &78, 1  , &D9, &78, 1                                        ; 271F: 78 01 D9... x..
    EQUS "ftL}'"                                                      ; 2724: 66 74 4C... ftL
    EQUB &B0, &17, &A9, &40, &85, &7F, &B9, &78, 1  , &DD, &78, 1     ; 2729: B0 17 A9... ...
    EQUS "ft)"                                                        ; 2735: 66 74 29    ft)
    EQUB &FF                                                          ; 2738: FF          .
    EQUS " P4"                                                        ; 2739: 20 50 34     P4
    EQUB &C9, &3C, &90, 4  , &B0, 7  , &46, &76, &B9, &78, 1  , &85   ; 273C: C9 3C 90... .<.
    EQUB &74, &BD, &8C, 1  , &10, &10, &AD, &68, &FE, &29, &1F, &D0   ; 2748: 74 BD 8C... t..
    EQUB &37, &A5, &76, &29, &80, 5  , &7F, &4C, &8A, &27, &B9, &78   ; 2754: 37 A5 76... 7.v
    EQUB 1  , &38, &FD, &78, 1  , &B0, 2  , &49, &FF, &C9, &64, &B0   ; 2760: 01 38 FD... .8.
    EQUB &1F, &C9, &50, &B0, &15, &C9, &3C, &B0, 8  , &A5, &76, &29   ; 276C: 1F C9 50... ..P
    EQUB &80, 5  , &7F, &85, &7F, &A5, &74, &29, &80, 5  , &83, &9D   ; 2778: 80 05 7F... ...
    EQUB &14, 1  , &A5, &7F, 9  , &10, &85, &7F, &BD, 0  , 1  , &4A   ; 2784: 14 01 A5... ...
    EQUB &A5, &7F, &B0, 3  , &9D, 0  , 1  , &A6, &77, &20, &84, &50   ; 2790: A5 7F B0... ...
    EQUB &E4, 3  , &F0, 3  , &4C, &94, &26, &60, &B9, &64, 1  , &38   ; 279C: E4 03 F0... ...
    EQUB &FD, &64, 1  , &B9, &D0, 8  , &FD, &D0, 8  , &85, &74, &B9   ; 27A8: FD 64 01... .d.
    EQUB &E8, 8  , &FD, &E8, 8  , 8  , &10, 3  , &20, &40, &0E, &85   ; 27B4: E8 08 FD... ...
    EQUB &75, &38, &F0, &14, &68, &49, &80, 8  , &AD, &FC, &59, &38   ; 27C0: 75 38 F0... u8.
    EQUB &E5, &74, &85, &74, &AD, &FD, &59, &E5, &75, &D0, &13, &18   ; 27CC: E5 74 85... .t.
    EQUB &66, &79, &A5, &74, &C9, &80, &B0, &0A                       ; 27D8: 66 79 A5... fy.
    EQUS "( P4"                                                       ; 27E0: 28 20 50... ( P
    EQUB &85, &74, &A5, &74, &18                                      ; 27E4: 85 74 A5... .t.
    EQUS "`(8`"                                                       ; 27E9: 60 28 38... `(8
    EQUB &A5, &6D, &30, &FB, &A2, &14, &4C, &E7, &28, &BD, 0  , 1     ; 27ED: A5 6D 30... .m0
    EQUB &30, &60, &BC, &E8, 6  , &B9, 0  , &59, &10, &0A, &BD, &50   ; 27F9: 30 60 BC... 0`.
    EQUB 1  , &DD, &A4, 1  , &B0, &74, &90, &22, &4A, &B0, &1F, &B9   ; 2805: 01 DD A4... ...
    EQUB 7  , &53, &9D, &A4, 1  , &18, &FD, &50, 1  , &B0, &13, &4A   ; 2811: 07 53 9D... .S.
    EQUB &4A, 9  , &C0, &85, &74, &BD, &80, 8  , &38, &F9, 5  , &53   ; 281D: 4A 09 C0... J..
    EQUB &B0, &54, &C5, &74, &B0, &2C, &BD, &50, 1  , &C9, &3C, &B0   ; 2829: B0 54 C5... .T.
    EQUB 2  , &A9, &16, &85, &74, &BD, 0  , 1  , &29, &40, &F0, 2     ; 2835: 02 A9 16... ...
    EQUB &A9, 5  , &18, &7D, &28, 1  , &24, &6C, &10, 3  , &ED, &1A   ; 2841: A9 05 18... ...
    EQUB &5A, &A0, 0  , &38, &E5, &74, &B0, 1  , &88, &84             ; 284D: 5A A0 00... Z..
    EQUS "uLa("                                                       ; 2857: 75 4C 61... uLa
    EQUB &A9, &FF, &85, &75, &A9, 0  , &0A, &26, &75, &0A, &26, &75   ; 285B: A9 FF 85... ...
    EQUB &18                                                          ; 2867: 18          .
    EQUS "}P8"                                                        ; 2868: 7D 50 38    }P8
    EQUB &9D, &50, &38, &A5                                           ; 286B: 9D 50 38... .P8
    EQUS "u}P"                                                        ; 286F: 75 7D 50    u}P
    EQUB 1  , &C9, &BE, &90, 5  , &A9, 0  , &9D, &50, &38, &9D, &50   ; 2872: 01 C9 BE... ...
    EQUB 1  , &A9, 1  , &85, &76, &BD, &50, 1  , &18, &7D, &64, 1     ; 287E: 01 A9 01... ...
    EQUB &9D, &64, 1  , &90, 3  , &20, &7C, &14, &C6, &76, &10, &ED   ; 288A: 9D 64 01... .d.
    EQUB &BD, &8C, 1  , &0A, &B0                                      ; 2896: BD 8C 01... ...
    EQUS "K00"                                                        ; 289B: 4B 30 30    K00
    EQUB &BD, &14, 1  , &29, &40, &F0, &29, &BD, &78, 1  , &5D, &14   ; 289E: BD 14 01... ...
    EQUB 1  , &10, &21, &BD, &78, 1  , &10, &0F, &C9, &EC, &90, 5     ; 28AA: 01 10 21... ..!
    EQUB &DE, &78, 1  , &B0, &2C, &C9, &E2, &90, &0F, &B0, &26, &C9   ; 28B6: DE 78 01... .x.
    EQUB &14, &B0, 5  , &FE, &78, 1  , &90, &1D, &C9, &1E, &90, &19   ; 28C2: 14 B0 05... ...
    EQUB &BD, &14, 1  , &29, &BF, &18, &10, 9  , &49, &7F, &7D, &78   ; 28CE: BD 14 01... ...
    EQUB 1  , &B0, 7  , &90, 8  , &7D, &78, 1  , &B0, 3  , &9D, &78   ; 28DA: 01 B0 07... ...
    EQUB 1  , &CA, &30, 7  , &E4, &6F, &F0, &F9, &4C, &F6, &27, &60   ; 28E6: 01 CA 30... ..0
    EQUB &BD, &3C, 1  , &85, &45, &85, &42, &AA, &A0, &17, &38, &20   ; 28F2: BD 3C 01... .<.
    EQUB &AB, &27, &B0, &0F                                           ; 28FE: AB 27 B0... .'.
    EQUS "E%0"                                                        ; 2902: 45 25 30    E%0
    EQUB &0B, &A5                                                     ; 2905: 0B A5       ..
    EQUS "t P4"                                                       ; 2907: 74 20 50... t P
    EQUB &85, &74, &C9, &28, &90, 3  , &4C, &A6, &2A, &0A, &18        ; 290B: 85 74 C9... .t.
    EQUS "etI"                                                        ; 2916: 65 74 49    etI
    EQUB &FF                                                          ; 2919: FF          .
    EQUS "8e$"                                                        ; 291A: 38 65 24    8e$
    EQUB &10, 3  , &18, &69, &78, &A8, &BD, 0  , 1  , &29, &10, &D0   ; 291D: 10 03 18... ...
    EQUB &0D, &BD, &50, 1  , &C9, &32, &90, 6  , &B9, 1  , 7  , &9D   ; 2929: 0D BD 50... ..P
    EQUB &14, 1  , &B9, 0  , 7  , &85, &0C, &84, &74, &A8, &BD, &64   ; 2935: 14 01 B9... ...
    EQUB 1  , &85, &84, &BD, &78, 1  , &85, &85, &B9, 0  , &54, &85   ; 2941: 01 85 84... ...
    EQUB &86, &B9, 0  , &55, &85, &87, &B9, 0  , &56, &85, &88, &A2   ; 294D: 86 B9 00... ...
    EQUB 0  , &A5, &84, &85, &75, &A4, &74, &A9, 0  , &85, &76, &B5   ; 2959: 00 A5 84... ...
    EQUB &86, &10, &13, &49, &FF, &18, &69, 1  , &20, 0  , &0C, &49   ; 2965: 86 10 13... ...
    EQUB &FF, &18, &69, 1  , &B0, 7  , &C6, &76, &90, 3  , &20, 0     ; 2971: FF 18 69... ..i
    EQUB &0C, &18, &79, 0  , 9  , &9D, &FD, 9  , &B9, 0  , &0A, 8     ; 297D: 0C 18 79... ..y
    EQUB &E0, 1  , &D0, 2  , &29, &1F                                 ; 2989: E0 01 D0... ...
    EQUS "(ev"                                                        ; 298F: 28 65 76    (ev
    EQUB &9D, &FD, &0A, &C8, &E8, &E0, 3  , &D0, &C5, &A4, &0C, &B9   ; 2992: 9D FD 0A... ...
    EQUB 0  , &57, &85, &86, &B9, 0  , &58, &85, &88, &A2, 0  , &A5   ; 299E: 00 57 85... .W.
    EQUB &85, &85, &75, &A9, 0  , &85, &76, &B5, &86, &10, &13, &49   ; 29AA: 85 85 75... ..u
    EQUB &FF, &18, &69, 1  , &20, 0  , &0C, &49, &FF, &18, &69, 1     ; 29B6: FF 18 69... ..i
    EQUB &B0, 7  , &C6, &76, &90, 3  , &20, 0  , &0C, &0A, &26, &76   ; 29C2: B0 07 C6... ...
    EQUB &0A, &26, &76, &18, &7D, &FD, 9  , &9D, &FD, 9  , &BD, &FD   ; 29CE: 0A 26 76... .&v
    EQUB &0A, &65, &76, &9D, &FD, &0A, &E8, &E8, &E0, 4  , &D0, &C7   ; 29DA: 0A 65 76... .ev
    EQUB &AD, &FE, 9  , &18, &69, &90, &8D, &FE, 9  , &90, 3  , &EE   ; 29E6: AD FE 09... ...
    EQUB &FE, &0A, &A9, 4                                             ; 29F2: FE 0A A9... ...
    EQUS " ]*"                                                        ; 29F6: 20 5D 2A     ]*
    EQUB &A6, &45, &A5, &55, &C9, 3  , &B0, &4F, &A5, &1D, &C5, &4D   ; 29F9: A6 45 A5... .E.
    EQUB &D0, &46, &BD, &8C, 1  , &30, 3  , &DE, &8C, 1  , &A4, &0C   ; 2A05: D0 46 BD... .F.
    EQUB &20, &42, &14, &20, &0E, &2B, &A0, &FD, &A2, &FA, &20, &CC   ; 2A11: 20 42 14...  B.
    EQUB &0B, &20, &0E, &2B, &A2, &F4, &20, &CC, &0B, &20, &0E, &2B   ; 2A1D: 0B 20 0E... . .
    EQUB &A2, &FD, &20, &CC, &0B, &A9, &14, &85, &42, &A9, 2          ; 2A29: A2 FD 20... ..
    EQUS " ]*"                                                        ; 2A34: 20 5D 2A     ]*
    EQUB &A9, &15, &85, &42, &A9, 1  , &A2, &F4                       ; 2A37: A9 15 85... ...
    EQUS " _*"                                                        ; 2A3F: 20 5F 2A     _*
    EQUB &A9, &16, &85, &42, &A9, 0  , &A2, &FA                       ; 2A42: A9 16 85... ...
    EQUS " _*"                                                        ; 2A4A: 20 5F 2A     _*
    EQUB &A6, &45, &60, &C9, 5  , &90, &F9, &BD, &8C, 1  , &30, &F4   ; 2A4D: A6 45 60... .E`
    EQUB &FE, &8C, 1  , &60, &A2, &FD, &85                            ; 2A59: FE 8C 01... ...
    EQUS "7 E!"                                                       ; 2A60: 37 20 45... 7 E
    EQUB &A4, &42, &A5, &8A, &99, &80, 3  , &A5, &8B, &99, &98, 3     ; 2A64: A4 42 A5... .B.
    EQUB &20, &B1, &2A, &20, &85, &22, &A4, &42, &B0, &2C, &38, &E9   ; 2A70: 20 B1 2A...  .*
    EQUB 1  , &30, &27, &99, &B0, 3  , &A5, &2B, &38, &E9, 9  , &AA   ; 2A7C: 01 30 27... .0'
    EQUB &A5, &2A, &CA, &F0, &0C, &10, 6  , &4A, &E8, &D0, &FC, &F0   ; 2A88: A5 2A CA... .*.
    EQUB 4  , &0A, &CA, &D0, &FC, &99, &C8, 3  , &B9, &8C, 1  , &29   ; 2A94: 04 0A CA... ...
    EQUB &70, 5  , &37, &4C, &AD, &2A, &A4, &42, &B9, &8C, 1  , 9     ; 2AA0: 70 05 37... p.7
    EQUB &80, &99, &8C, 1  , &60, &A0, &25, &20, &A5, &0C, &A5, &7D   ; 2AAC: 80 99 8C... ...
    EQUB &85, &55, &D0, &0E, &C4, &7C, &90, &0A, &C6, &68, &A5, &7C   ; 2AB8: 85 55 D0... .U.
    EQUB &85, &41, &A5, &42, &85, &67, &60, &86, &45, &BD, &3C, 1     ; 2AC4: 85 41 A5... .A.
    EQUB &AA, &BD, &8C, 1                                             ; 2AD0: AA BD 8C... ...
    EQUS "05)"                                                        ; 2AD4: 30 35 29    05)
    EQUB &0F, &85, &37, &BD, &80, 3  , &38, &E5, &0A, &85, &74, &BD   ; 2AD7: 0F 85 37... ..7
    EQUB &98, 3  , &E5, &0B, &10, 6  , &C9, &E0, &90, &1E, &B0, 4     ; 2AE3: 98 03 E5... ...
    EQUB &C9, &20, &B0, &18, 6  , &74, &2A, 6  , &74, &2A, &18, &69   ; 2AEF: C9 20 B0... . .
    EQUB &50, &85, &35, &BD, &B0, 3  , &85, &36, &BD, &C8, 3  , &85   ; 2AFB: 50 85 35... P.5
    EQUB &2A, &20, &B4, &1F, &A6, &45, &60, &A2, 2  , &B5, &83, &18   ; 2B07: 2A 20 B4... * .
    EQUB &10, 1  , &38, &76, &83, &76, &74, &CA, &10, &F3, &60, 5     ; 2B13: 10 01 38... ..8
    EQUB 6  , 6  , 5  , &A4, &50, 0  , &54, 8  , &85, &54, &A9, 0     ; 2B1F: 06 06 05... ...
    EQUB &85, &1E, &B9                                                ; 2B2B: 85 1E B9    ...
    EQUS " _8"                                                        ; 2B2E: 20 5F 38     _8
    EQUB &E9, 1  , &C9, &4E, &B0, 9  , &BD, &90, &5E, &10, 2  , &49   ; 2B31: E9 01 C9... ...
    EQUB &FF, &C9, &14, &66, &88, &BD, &90, &5E, &85, &77, &BD, &40   ; 2B3D: FF C9 14... ...
    EQUB &5E, &0A, &26, &77, &0A, &26, &77, &A5, &77, &18, &69, &80   ; 2B49: 5E 0A 26... ^.&
    EQUB &85, &77, &B9, &20, &5F, &85, &82, &86, &45, &84, &1B, &28   ; 2B55: 85 77 B9... .w.
    EQUB &B0, &67, &24, &88, &50, &14, &30, &61, &A6, &7E, &A4, &7F   ; 2B61: B0 67 24... .g$
    EQUB &A5, &77, &85, &7E, &A5, &82, &85, &7F, &86, &77, &84, &82   ; 2B6D: A5 77 85... .w.
    EQUB &C6, &1E, &A5, &82, &38, &E5, &7F, &85, &87, &10, 5  , &A9   ; 2B79: C6 1E A5... ...
    EQUB 0  , &38, &E5, &87, &85, &84, &A5, &88, &29, &C0, &F0, &3C   ; 2B85: 00 38 E5... .8.
    EQUB &A4, &45, &A6, &4F, &B9                                      ; 2B91: A4 45 A6... .E.
    EQUS "@^8"                                                        ; 2B96: 40 5E 38    @^8
    EQUB &FD, &40, &5E, &85, &74, &B9, &90, &5E, &FD, &90, &5E, &85   ; 2B99: FD 40 5E... .@^
    EQUB &86, &20, &40, &0E, &C9, &40, &B0, &0C, 6  , &74, &2A, &C9   ; 2BA5: 86 20 40... . @
    EQUB &40, &B0, 7  , 6  , &74, &2A, &10, 4  , &46, &84, &46, &84   ; 2BB1: 40 B0 07... @..
    EQUB &85, &83, &A5, &86, &45, &1E, &85, &86, &A5, &83, &4C, &DB   ; 2BBD: 85 83 A5... ...
    EQUB &2B, &4C, &FC, &2C, &A5, &7E, &38, &E5, &77, &66, &86, &30   ; 2BC9: 2B 4C FC... +L.
    EQUB 5  , &49, &FF, &18, &69, 1  , &85, &83, &D0, 4  , 5  , &84   ; 2BD5: 05 49 FF... .I.
    EQUB &F0, &E7, &A5, &88, &29, &C0, &F0, 4  , &A5, &86, &29, &80   ; 2BE1: F0 E7 A5... ...
    EQUB &85, &53, &A5, &87, &D0, 6  , &A5, &1E, &49, &FF, &85, &87   ; 2BED: 85 53 A5... .S.
    EQUB &10, 4  , &A9, &88, &D0, 2  , &A9, &C8, &8D, &60, &2F, &8D   ; 2BF9: 10 04 A9... ...
    EQUB &A2, &2F, &A9, &EA, &8D, &47, &2F, &8D, &89, &2F, &A4, &54   ; 2C05: A2 2F A9... ./.
    EQUB &A2, 0  , &B9, &D0, &5F, &9D, &8F, &62, &3D, &FC, &33, &9D   ; 2C11: A2 00 B9... ...
    EQUB &9C, &62, &C8, &E8, &E0, 4  , &D0, &EE, &A5, &27, &0A, &0A   ; 2C1D: 9C 62 C8... .b.
    EQUB &0A, &85, &74, &AD, &8F                                      ; 2C29: 0A 85 74... ..t
    EQUS "bJJJ)"                                                      ; 2C2E: 62 4A 4A... bJJ
    EQUB 3  , 5  , &74, 9  , &40, &85, &34, &AD, &8F, &62, &D0, 5     ; 2C33: 03 05 74... ..t
    EQUB &A9, &55, &8D, &8F, &62, &85, &8B, &AD, &92                  ; 2C3F: A9 55 8D... .U.
    EQUS "bJ)"                                                        ; 2C48: 62 4A 29    bJ)
    EQUB 1  , &2C, &92, &62, &10, 2  , 9  , 2  , 9  , &80, 5  , &74   ; 2C4B: 01 2C 92... .,.
    EQUB &85, &33, &A5, &1B, &18, &69, 1  , &C5, &4B, &F0, 6  , &A5   ; 2C57: 85 33 A5... .3.
    EQUB &82, &C9, &50, &90, 8  , &A9, 0  , &24, &87, &30, 2  , &A9   ; 2C63: 82 C9 50... ..P
    EQUB &4F, &85, &82, &A5, &7E, &38, &E9, &30, &85                  ; 2C6F: 4F 85 82... O..
    EQUS "uJJ"                                                        ; 2C78: 75 4A 4A    uJJ
    EQUB &85, &85, &C9, &28, &B0, &65, &4A, &18, &69, &30, &85, &71   ; 2C7B: 85 85 C9... ...
    EQUB &85, &73, &18, &69, 1  , &85, &8F, &A5, &75, &29, 7  , &AA   ; 2C87: 85 73 18... .s.
    EQUB &A4, &7F, &A5, &83, &C5, &84, &90, &54, &AD, &8F, &62, &C9   ; 2C93: A4 7F A5... ...
    EQUB &FF, &F0, &12, &A5, &33, &29, 3  , &C9, 3  , &F0, &0A, &A9   ; 2C9F: FF F0 12... ...
    EQUB &60, &8D, &D7, &2F, &8D, &C0, &2F, &D0, &2B, &A9, &E0, &8D   ; 2CAB: 60 8D D7... `..
    EQUB &D7, &2F, &8D, &C0, &2F, &A5, &27, &C9, 2  , &6A, &45, &86   ; 2CB7: D7 2F 8D... ./.
    EQUB &10, &1A, &AD, &60, &2F, &8D, &47, &2F, &8D, &89, &2F, &A9   ; 2CC3: 10 1A AD... ...
    EQUB &EA, &8D, &60, &2F, &8D, &A2, &2F, &A5, &87, &10, 4  , &C8   ; 2CCF: EA 8D 60... ..`
    EQUB &4C, &DF, &2C, &88, &A5, &86, &10, 6  , &20, &9A, &2D, &4C   ; 2CDB: 4C DF 2C... L.,
    EQUB &FC, &2C, &20, &17, &2D, &4C, &FC, &2C, &A5, &86, &10, 6     ; 2CE7: FC 2C 20... .,
    EQUB &20, &99, &2E, &4C, &FC                                      ; 2CF3: 20 99 2E...  ..
    EQUS ",  ."                                                       ; 2CF8: 2C 20 20... ,
    EQUB &A5, &1E, &30, 8  , &A5, &77, &85, &7E, &A5, &82, &85, &7F   ; 2CFC: A5 1E 30... ..0
    EQUB &A6, &45, &A4, &1B, &60, &A5, &53, &F0, &EB, &20, &12, &2F   ; 2D08: A6 45 A4... .E.
    EQUB &4C, &FC, &2C, &BD, &50, &3E, &8D, &28, &2D, &A2, &80, &A5   ; 2D14: 4C FC 2C... L.,
    EQUB &83, &49, &FF, &18, &69, 1  , &18, &90, 0  , &A2, &80, &65   ; 2D20: 83 49 FF... .I.
    EQUB &84, &90, 7  , &E5, &83, &A2, 0                              ; 2D2C: 84 90 07... ...
    EQUS " E/e"                                                       ; 2D33: 20 45 2F...  E/
    EQUB &84, &90, 7  , &E5, &83, &A2, 1                              ; 2D37: 84 90 07... ...
    EQUS " E/e"                                                       ; 2D3E: 20 45 2F...  E/
    EQUB &84, &90, 7  , &E5, &83, &A2, 2                              ; 2D42: 84 90 07... ...
    EQUS " E/e"                                                       ; 2D49: 20 45 2F...  E/
    EQUB &84, &90, 7  , &E5, &83, &A2, 3                              ; 2D4D: 84 90 07... ...
    EQUS " E/ "                                                       ; 2D54: 20 45 2F...  E/
    EQUB &D7, &2F, &E6, &85, &65, &84, &90, 7  , &E5, &83, &A2, 0     ; 2D58: D7 2F E6... ./.
    EQUB &20, &87, &2F, &65, &84, &90, 7  , &E5, &83, &A2, 1  , &20   ; 2D64: 20 87 2F...  ./
    EQUB &87, &2F, &65, &84, &90, 7  , &E5, &83, &A2, 2  , &20, &87   ; 2D70: 87 2F 65... ./e
    EQUB &2F, &65, &84, &90, 7  , &E5, &83, &A2, 3  , &20, &87, &2F   ; 2D7C: 2F 65 84... /e.
    EQUB &20, &C0, &2F, &E6, &73, &E6, &71, &E6, &8F, &E6, &85, &A6   ; 2D88: 20 C0 2F...  ./
    EQUB &73, &E0, &44, &D0, &90, &60, &BD, &D0, &40, &8D, &AB, &2D   ; 2D94: 73 E0 44... s.D
    EQUB &A2, &80, &A5, &83, &49, &FF, &18, &69, 1  , &18, &90, 0     ; 2DA0: A2 80 A5... ...
    EQUB &A2, &80, &65, &84, &90, 7  , &E5, &83, &A2, 3  , &20, &87   ; 2DAC: A2 80 65... ..e
    EQUB &2F, &65, &84, &90, 7  , &E5, &83, &A2, 2  , &20, &87, &2F   ; 2DB8: 2F 65 84... /e.
    EQUB &65, &84, &90, 7  , &E5, &83, &A2, 1  , &20, &87, &2F, &65   ; 2DC4: 65 84 90... e..
    EQUB &84, &90, 7  , &E5, &83, &A2, 0  , &20, &87, &2F, &20, &C0   ; 2DD0: 84 90 07... ...
    EQUB &2F, &C6, &85, &65, &84, &90, 7  , &E5, &83, &A2, 3          ; 2DDC: 2F C6 85... /..
    EQUS " E/e"                                                       ; 2DE7: 20 45 2F...  E/
    EQUB &84, &90, 7  , &E5, &83, &A2, 2                              ; 2DEB: 84 90 07... ...
    EQUS " E/e"                                                       ; 2DF2: 20 45 2F...  E/
    EQUB &84, &90, 7  , &E5, &83, &A2, 1                              ; 2DF6: 84 90 07... ...
    EQUS " E/e"                                                       ; 2DFD: 20 45 2F...  E/
    EQUB &84, &90, 7  , &E5, &83, &A2, 0                              ; 2E01: 84 90 07... ...
    EQUS " E/ "                                                       ; 2E08: 20 45 2F...  E/
    EQUB &D7, &2F, &C6, &73, &C6, &71, &C6, &8F, &C6, &85, &A6, &73   ; 2E0C: D7 2F C6... ./.
    EQUB &E0, &2F, &18, &D0, &8F, &4C, &12, &2F, &BD, &D0, &3E, &8D   ; 2E18: E0 2F 18... ./.
    EQUB &2F, &2E, &A5, &84, &49, &FF, &18, &69, 1  , &18, &90, 0     ; 2E24: 2F 2E A5... /..
    EQUB &A2, 0                                                       ; 2E30: A2 00       ..
    EQUS " E/e"                                                       ; 2E32: 20 45 2F...  E/
    EQUB &83, &90, &F7, &E5, &84, &A2, 1                              ; 2E36: 83 90 F7... ...
    EQUS " E/e"                                                       ; 2E3D: 20 45 2F...  E/
    EQUB &83, &90, &F7, &E5, &84, &A2, 2                              ; 2E41: 83 90 F7... ...
    EQUS " E/e"                                                       ; 2E48: 20 45 2F...  E/
    EQUB &83, &90, &F7, &E5, &84, &A2, 3                              ; 2E4C: 83 90 F7... ...
    EQUS " E/e"                                                       ; 2E53: 20 45 2F...  E/
    EQUB &83, &90, &F7, &E5, &84, &E6, &85, &A2, 0  , &20, &87, &2F   ; 2E57: 83 90 F7... ...
    EQUB &65, &83, &90, &F7, &E5, &84, &A2, 1  , &20, &87, &2F, &65   ; 2E63: 65 83 90... e..
    EQUB &83, &90, &F7, &E5, &84, &A2, 2  , &20, &87, &2F, &65, &83   ; 2E6F: 83 90 F7... ...
    EQUB &90, &F7, &E5, &84, &A2, 3  , &20, &87, &2F, &65, &83, &90   ; 2E7B: 90 F7 E5... ...
    EQUB &F7, &E5, &84, &E6, &73, &E6, &71, &E6, &8F, &E6, &85, &A6   ; 2E87: F7 E5 84... ...
    EQUB &73, &E0, &44, &D0, &98, &60, &BD, &D8, &3E, &8D, &A8, &2E   ; 2E93: 73 E0 44... s.D
    EQUB &A5, &84, &49, &FF, &18, &69, 1  , &18, &90, 0  , &A2, 3     ; 2E9F: A5 84 49... ..I
    EQUB &20, &87, &2F, &65, &83, &90, &F7, &E5, &84, &A2, 2  , &20   ; 2EAB: 20 87 2F...  ./
    EQUB &87, &2F, &65, &83, &90, &F7, &E5, &84, &A2, 1  , &20, &87   ; 2EB7: 87 2F 65... ./e
    EQUB &2F, &65, &83, &90, &F7, &E5, &84, &A2, 0  , &20, &87, &2F   ; 2EC3: 2F 65 83... /e.
    EQUB &65, &83, &90, &F7, &E5, &84, &C6, &85, &A2, 3               ; 2ECF: 65 83 90... e..
    EQUS " E/e"                                                       ; 2ED9: 20 45 2F...  E/
    EQUB &83, &90, &F7, &E5, &84, &A2, 2                              ; 2EDD: 83 90 F7... ...
    EQUS " E/e"                                                       ; 2EE4: 20 45 2F...  E/
    EQUB &83, &90, &F7, &E5, &84, &A2, 1                              ; 2EE8: 83 90 F7... ...
    EQUS " E/e"                                                       ; 2EEF: 20 45 2F...  E/
    EQUB &83, &90, &F7, &E5, &84, &A2, 0                              ; 2EF3: 83 90 F7... ...
    EQUS " E/e"                                                       ; 2EFA: 20 45 2F...  E/
    EQUB &83, &90, &F7, &E5, &84, &C6, &73, &C6, &71, &C6, &8F, &C6   ; 2EFE: 83 90 F7... ...
    EQUB &85, &A6, &73, &E0, &2F, &18, &D0, &97, &AD, &47, &2F, &8D   ; 2F0A: 85 A6 73... ..s
    EQUB &18, &2F, &EA, &A5, &1E, &30, 5  , &A5                       ; 2F16: 18 2F EA... ./.
    EQUS "4L*/"                                                       ; 2F1E: 34 4C 2A... 4L*
    EQUB &88, &B9, &60, &5F, &D0, &1C, &A5, &33, &C0, &50, &B0, &16   ; 2F22: 88 B9 60... ..`
    EQUB &AE, &F2, &62, &E0, &28, &90, &0C, &85, &74, &29, 3  , &C9   ; 2F2E: AE F2 62... ..b
    EQUB 3  , &A5, &74, &B0, 2  , &29, &FC, &99                       ; 2F3A: 03 A5 74... ..t
    EQUS "`_`"                                                        ; 2F42: 60 5F 60    `_`
    EQUB &85, &8A, &EA, &C4, &82, &F0, &32, &A5, &85, &99, 0  , &70   ; 2F45: 85 8A EA... ...
    EQUB &B1, &72, &D0, &0E, &BD, &8F, &62, &91, &72, &A5, &8B, &91   ; 2F51: B1 72 D0... .r.
    EQUB &70, &A5, &8A, &C8, &18, &60, &C0, &2C, &B0, 5  , &20, &EE   ; 2F5D: 70 A5 8A... p..
    EQUB &2F, &90, &F2, &C9, &55, &D0, 2  , &A9, 0                    ; 2F69: 2F 90 F2... /..
    EQUS "=|3"                                                        ; 2F72: 3D 7C 33    =|3
    EQUB &1D, &9C, &62, &D0, &DE, &A9, &55, &D0, &DA, &BA, &E8, &E8   ; 2F75: 1D 9C 62... ..b
    EQUB &9A, &A5, &53, &D0, &93, &60, &85, &8A, &EA, &C4, &82, &F0   ; 2F81: 9A A5 53... ..S
    EQUB &F0, &A5, &85, &99, 0  , &70, &B1, &70, &D0, &0E, &BD, &8F   ; 2F8D: F0 A5 85... ...
    EQUB &62, &91, &70, &A5, &8B, &91, &8E, &A5, &8A, &C8, &18, &60   ; 2F99: 62 91 70... b.p
    EQUB &C0, &2C, &B0, 5  , &20, &EE, &2F, &90, &F2, &C9, &55, &D0   ; 2FA5: C0 2C B0... .,.
    EQUB 2  , &A9, 0                                                  ; 2FB1: 02 A9 00    ...
    EQUS "=|3"                                                        ; 2FB4: 3D 7C 33    =|3
    EQUB &1D, &9C, &62, &D0, &DE, &A9, &55, &D0, &DA, &E0, &80, &D0   ; 2FB7: 1D 9C 62... ..b
    EQUB &0F, &C0, &2C, &B0, 5  , &20, &EE, &2F, &90, 6  , &AA, &A9   ; 2FC3: 0F C0 2C... ..,
    EQUB &FF, &91, &70, &8A, &A2, &80, &18, &60, &E0, &80, &D0, &0F   ; 2FCF: FF 91 70... ..p
    EQUB &C0, &2C, &B0, 5  , &20, &EE, &2F, &90, 6  , &AA, &A9, &FF   ; 2FDB: C0 2C B0... .,.
    EQUB &91, &72, &8A, &A2, &80, &18, &60, &85, &74, &86, &75, &A6   ; 2FE7: 91 72 8A... .r.
    EQUB &85, &98, &DD, 0  , &39, &D0, 1  , &18, &A5, &74, &A6, &75   ; 2FF3: 85 98 DD... ...
    EQUB &60, &FE, &1F, &0A, &0C, &83                                 ; 2FFF: 60 FE 1F... `..
    EQUS "STANDARD OF"                                                ; 3005: 53 54 41... STA
    EQUB &D7, &1F, &0E, &0E, &FF, &FC, &A3, &FC, &A3, &FC, &A1, &FF   ; 3010: D7 1F 0E... ...
    EQUB &A8, &A9, &F0, &C4, &82, &B0, &0C, &C4, &7F, &90, 8  , &AE   ; 301C: A8 A9 F0... ...
    EQUB &68, &FE, &3D, 0                                             ; 3028: 68 FE 3D... h.=
    EQUS " %a"                                                        ; 302C: 20 25 61     %a
    EQUB &91, &70, &88, &10, &14, &98, &29, 7  , &C9, 7  , &90, &0D   ; 302F: 91 70 88... .p.
    EQUB &A5, &70, &38, &E9, &38, &85, &70, &A5, &71, &E9, 1  , &85   ; 303B: A5 70 38... .p8
    EQUB &71, &C4, &77, &B0, &D1, &A4, &78, &60, &FF, 0  , 0  , 0     ; 3047: 71 C4 77... q.w
    EQUB 0  , 6  , 6  , 6  , 6  , 6  , 6  , 6  , 3  , 3  , 3  , 3     ; 3053: 00 06 06... ...
    EQUB 3  , 1  , 1  , 1  , 0  , 0  , 0  , 5  , 4  , 3  , 2  , 1     ; 305F: 03 01 01... ...
    EQUB 0  , &2D, &33, 0  , 0  , 1  , 1  , 1  , 1  , 1  , 1  , 5     ; 306B: 00 2D 33... .-3
    EQUB 5  , 3  , 4  , 3  , 4  , 4  , 4  , &38, &38, &97, &97, &97   ; 3077: 05 03 04... ...
    EQUB &97, &A8, &A8, &A8, &A8, &A8, &A8, &A8, &A8, &A8, &A8, &A8   ; 3083: 97 A8 A8... ...
    EQUB &A8, &A8, &A8, &A8, &A8, &A8, &A8, &B9, &B9, &B9, &B9, &B9   ; 308F: A8 A8 A8... ...
    EQUB &B9, &33, &A8, &20, 0  , &7E, &84, &75, &BC                  ; 309B: B9 33 A8... .3.
    EQUS "P09"                                                        ; 30A4: 50 30 39    P09
    EQUB &F9, &36, &19, &F9, &35, &A4, &75, &91, &72, &E0, 3  , &F0   ; 30A7: F9 36 19... .6.
    EQUB 3  , &4C, &18, &7F, &4C, &BF, &7B, &85, &82, &84, &78, &B9   ; 30B3: 03 4C 18... .L.
    EQUB &9E, &3B, &85, &71, &B9, &26, &3B, &85, &70, &B9, &FA, &3E   ; 30BF: 9E 3B 85... .;.
    EQUB &85, &77, &B9, &FA, &40, &28, &8D                            ; 30CB: 85 77 B9... .w.
    EQUS "|||||kkkkkZZZZIIII8888''''"                                 ; 30D2: 7C 7C 7C... |||
    EQUB &16, &16, &16, &16, &16, &16, &16, &16, &16, &16, &16, 5     ; 30EC: 16 16 16... ...
    EQUB 5  , 5  , 5  , 5  , &10, 0  , 0  , &10, &1C, &1C, &1C, &1C   ; 30F8: 05 05 05... ...
    EQUB &1C, &1B, &1B, &1B, &1B, &1A, &1A, &1A, &19, &19, &18, &18   ; 3104: 1C 1B 1B... ...
    EQUB &17, &16, &15, &14, &14, &14, &81, &81, &81, &81, &81, &81   ; 3110: 17 16 15... ...
    EQUB &79, &35, &A8, &20, 0  , &7C, &3D, &D0, &38, &1D, &50, &33   ; 311C: 79 35 A8... y5.
    EQUB &91, &70, &BC, &80, &30, &CC, &7D, &7F, &F0, &10, &A9, &91   ; 3128: 91 70 BC... .p.
    EQUB &8D, &0F, &7E, &8C, &88, &7F, &8C, &7D, &7F, &A9, &60, &8D   ; 3134: 8D 0F 7E... ..~
    EQUB 0  , &7E, &BC, &D0, &30, &8C, &9B, &7F, &BD, 0               ; 3140: 00 7E BC... .~.
    EQUS "D=P9"                                                       ; 314A: 44 3D 50... D=P
    EQUB &1D, &D0                                                     ; 314E: 1D D0       ..
    EQUS "Bduuuuu"                                                    ; 3150: 42 64 75... Bdu
    EQUB &86, &86, &86, &86, &86, &97, &97, &97, &97, &A8, &A8, &A8   ; 3157: 86 86 86... ...
    EQUB &A8, &B9, &B9, &B9, &B9, &CA, &CA, &CA, &CA, &DB, &DB, &DB   ; 3163: A8 B9 B9... ...
    EQUB &DB, &DB, &DB, &DB, &DB, &DB, &DB, &DB, &EC, &EC, &EC, &EC   ; 316F: DB DB DB... ...
    EQUB &EC, &28, &28, 0  , 0  , &81, &81, &81, &81, &81, &81, &81   ; 317B: EC 28 28... .((
    EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81   ; 3187: 81 81 81... ...
    EQUB &81, &81, &81, &24, &7F, &A9, &60, &8D, 0  , &7C, &A4, &70   ; 3193: 81 81 81... ...
    EQUB &C8, &98, &29, 7  , &D0, &14, &98, &18, &69, &38, &85, &70   ; 319F: C8 98 29... ..)
    EQUB &85, &72, &A5, &71, &69, 1  , &85, &71, &69, 1  , &85, &73   ; 31AB: 85 72 A5... .r.
    EQUB &90, 4  , &84, &70, &84, &72, &A9, &F1, &38, &FD, &80, &30   ; 31B7: 90 04 84... ...
    EQUB &8D, &68, &7F, &BC, &50, &30, &BD, 4  , 5                    ; 31C3: 8D 68 7F... .h.
    EQUS "9y6"                                                        ; 31CC: 39 79 36    9y6
    EQUB &19, &A2, 3  , &C4, &1F, &90, 5  , &BD, &7C, &3D, &D0, 3     ; 31CF: 19 A2 03... ...
    EQUB &BD, &78, &3D, &91, &70, &99, 4  , 5  , &99, 0  , &44, &CA   ; 31DB: BD 78 3D... .x=
    EQUB &10, 2  , &A2, 3  , &88, &C4, &75, &D0, &E2, &E6, &74, &A5   ; 31E7: 10 02 A2... ...
    EQUB &70, &49, &80, &85, &70, &30, 2  , &E6                       ; 31F3: 70 49 80... pI.
    EQUS "qLh="                                                       ; 31FB: 71 4C 68... qLh
    EQUB 0  , &20, &35, &FF, &81, &80, &43, &F0, 8  , &A9, 0  , &9D   ; 31FF: 00 20 35... . 5
    EQUB &80, &43, &B9, 0  , &60, &A0, &38, &91, &72, &E0, &2C, &F0   ; 320B: 80 43 B9... .C.
    EQUB &25, &CA, &A4, &70, &C8, &98, &29, 7  , &F0, 7  , &84, &70   ; 3217: 25 CA A4... %..
    EQUB &84, &72, &4C, &F7, &7B, &98, &18, &69, &38, &85, &70, &85   ; 3223: 84 72 4C... .rL
    EQUB &72, &A5, &71, &69, 1  , &85, &71, &69, 1  , &85, &73, &4C   ; 322F: 72 A5 71... r.q
    EQUB &F7, &7B, &60, &CA, &BC, &50, &31, &CC, &24, &7F, &F0, &10   ; 323B: F7 7B 60... .{`
    EQUB &A9, &91, &8D, &0F, &7C, &8C, &2F, &7F, &8C, &84, &73, &85   ; 3247: A9 91 8D... ...
    EQUB &72, &A0, 0  , &B1, &72, &20, &92, &50, &C8, &C0, &0C, &D0   ; 3253: 72 A0 00... r..
    EQUB &F6, &60, &A2, &FF, &20, &50, &0E, &D0, &13, &A2, &86, &20   ; 325F: F6 60 A2... .`.
    EQUB &50, &0E, &D0, &0C, &24, &1C, &30, &0A, &A6, &6B, &9A, &66   ; 326B: 50 0E D0... P..
    EQUB &1C, &4C, &E0, &63, &46, &1C, &60, 0  , 0  , &31, &30, &FF   ; 3277: 1C 4C E0... .L.
    EQUB &41, &B9, 0  , &60, &A0, &10, &91, &72, &BC, &80, &41, &F0   ; 3283: 41 B9 00... A..
    EQUB 8  , &A9, 0  , &9D, &80, &41, &B9, 0  , &60, &A0, &18, &91   ; 328F: 08 A9 00... ...
    EQUB &72, &BC, 0  , &42, &F0, 8  , &A9, 0  , &9D, 0  , &42, &B9   ; 329B: 72 BC 00... r..
    EQUB 0  , &60, &A0, &20, &91, &72, &BC, &80, &42, &F0, 8  , &A9   ; 32A7: 00 60 A0... .`.
    EQUB 0  , &9D, &80, &42, &B9, 0  , &60, &A0, &28, &91, &72, &BC   ; 32B3: 00 9D 80... ...
    EQUB 0  , &43, &F0, 8  , &A9, 0  , &9D, 0  , &43, &B9, 0  , &60   ; 32BF: 00 43 F0... .C.
    EQUB &A0, &30, &91, &72, &BC, &A5, &74, &C9, &20, &D0, 2  , &A9   ; 32CB: A0 30 91... .0.
    EQUB &30, &38, &E9, &30, &C9, &0A, &B0, &1C, &85, &74, &A6, &75   ; 32D7: 30 38 E9... 08.
    EQUB &E0, &20, &18, &F0, &13, &0A, &0A, &65, &74, &0A, &85, &74   ; 32E3: E0 20 18... . .
    EQUB &8A, &38, &E9, &30, &C9, &0A, &B0, 4  , &65, &74, &C9        ; 32EF: 8A 38 E9... .8.
    EQUS ")`fg_^20"                                                   ; 32FA: 29 60 66... )`f
    EQUB &FF, &BC, 0  , &3F, &F0, 8  , &A9, 0  , &9D, 0  , &3F, &B9   ; 3302: FF BC 00... ...
    EQUB 0  , &60, &A0, &F0, &91, &70, &BC, &80, &3F, &F0, 8  , &A9   ; 330E: 00 60 A0... .`.
    EQUB 0  , &9D, &80, &3F, &B9, 0  , &60, &A0, &F8, &91, &70, &BC   ; 331A: 00 9D 80... ...
    EQUB 0  , &40, &F0, 8  , &A9, 0  , &9D, 0  , &40, &B9, 0  , &60   ; 3326: 00 40 F0... .@.
    EQUB &A0, 0  , &91, &72, &BC, &80, &40, &F0, 8  , &A9, 0  , &9D   ; 3332: A0 00 91... ...
    EQUB &80, &40, &B9, 0  , &60, &A0, 8  , &91, &72, &BC, 0  , &41   ; 333E: 80 40 B9... .@.
    EQUB &F0, 8  , &A9, 0  , &9D, 0  , 0  , 0  , &F0, &70, &30, &10   ; 334A: F0 08 A9... ...
    EQUB 0                                                            ; 3356: 00          .
    EQUS "pp0"                                                        ; 3357: 70 70 30    pp0
    EQUB &10, 0  , &70, &30, &10, 0  , &70, &30, &10, 0  , &70, &30   ; 335A: 10 00 70... ..p
    EQUB &10, 0  , &70, &30, &10, 0                                   ; 3366: 10 00 70... ..p
    EQUS "p@0 0"                                                      ; 336C: 70 40 30... p@0
    EQUB &10, &10, &10, 0  , 0  , 0                                   ; 3371: 10 10 10... ...
    EQUS "@p@00"                                                      ; 3377: 40 70 40... @p@
    EQUB 0  , &88, &CC, &EE, &81, &81, &81, &81, &81, &81, &81, &60   ; 337C: 00 88 CC... ...
    EQUB &A0, &C8, &91, &70, &BC, 0  , &3D, &F0, 8  , &A9, 0  , &9D   ; 3388: A0 C8 91... ...
    EQUB 0  , &3D, &B9, 0  , &60, &A0, &D0, &91, &70, &BC, &80, &3D   ; 3394: 00 3D B9... .=.
    EQUB &F0, 8  , &A9, 0  , &9D, &80, &3D, &B9, 0  , &60, &A0, &D8   ; 33A0: F0 08 A9... ...
    EQUB &91, &70, &BC, 0  , &3E, &F0, 8  , &A9, 0  , &9D, 0  , &3E   ; 33AC: 91 70 BC... .p.
    EQUB &B9, 0  , &60, &A0, &E0, &91, &70, &BC, &80, &3E, &F0, 8     ; 33B8: B9 00 60... ..`
    EQUB &A9, 0  , &9D, &80, &3E, &B9, 0  , &60, &A0, &E8, &91, &70   ; 33C4: A9 00 9D... ...
    EQUB 0  , 0  , &F0, &E0, &C0, &80, 0  , &E0, &E0, &C0, &80, 0     ; 33D0: 00 00 F0... ...
    EQUB &E0, &C0, &80, 0  , &E0, &C0, &80, 0  , &E0, &C0, &80, 0     ; 33DC: E0 C0 80... ...
    EQUB &E0, &C0, &80, 0  , &E0, &20, &C0, &40, &C0, &80, &80, &80   ; 33E8: E0 C0 80... ...
    EQUB 0  , 0  , 0  , &20, &E0, &20, &C0, &C0, &FF, &77, &33, &11   ; 33F4: 00 00 00... ...
    EQUS "ENTER "                                                     ; 3400: 45 4E 54... ENT
    EQUB &FF, &81, &81, &81, &81, &81, &60, &A0, &A8, &91, &70, &BC   ; 3406: FF 81 81... ...
    EQUB 0  , &3B, &F0, 8  , &A9, 0  , &9D, 0  , &3B, &B9, 0  , &60   ; 3412: 00 3B F0... .;.
    EQUB &A0, &B0, &91, &70, &BC, &80, &3B, &F0, 8  , &A9, 0  , &9D   ; 341E: A0 B0 91... ...
    EQUB &80, &3B, &B9, 0  , &60, &A0, &B8, &91, &70, &BC, 0  , &3C   ; 342A: 80 3B B9... .;.
    EQUB &F0, 8  , &A9, 0  , &9D, 0  , &3C, &B9, 0  , &60, &A0, &C0   ; 3436: F0 08 A9... ...
    EQUB &91, &70, &BC, &80, &3C, &F0, 8  , &A9, 0  , &9D, &80, &3C   ; 3442: 91 70 BC... .p.
    EQUB &B9, 0  , &10, 5  , &49, &FF, &18, &69, 1  , &60, 7  , &17   ; 344E: B9 00 10... ...
    EQUS "GW#3cs"                                                     ; 345A: 47 57 23... GW#
    EQUB &80, &90, &C0, &D0, &A5, &B5, &E5, &F5, 3  , &13             ; 3460: 80 90 C0... ...
    EQUS "#3CScs"                                                     ; 346A: 23 33 43... #3C
    EQUB &84, &94, &A4, &B4, &C4, &D4, &E4, &F4                       ; 3470: 84 94 A4... ...
    EQUS "&6fv"                                                       ; 3478: 26 36 66... &6f
    EQUB &A1, &B1, &E1, &F1, &1F, &0D, &12                            ; 347C: A1 B1 E1... ...
    EQUS "front"                                                      ; 3483: 66 72 6F... fro
    EQUB &A2, &85, &D8, &FF, &81, &81, &81, &81, &70, &BC, 0  , &39   ; 3488: A2 85 D8... ...
    EQUB &F0, 8  , &A9, 0  , &9D, 0  , &39, &B9, 0  , &60, &A0, &90   ; 3494: F0 08 A9... ...
    EQUB &91, &70, &BC, &80, &39, &F0, 8  , &A9, 0  , &9D, &80, &39   ; 34A0: 91 70 BC... .p.
    EQUB &B9, 0  , &60, &A0, &98, &91, &70, &BC, 0  , &3A, &F0, 8     ; 34AC: B9 00 60... ..`
    EQUB &A9, 0  , &9D, 0  , &3A, &B9, 0  , &60, &A0, &A0, &91, &70   ; 34B8: A9 00 9D... ...
    EQUB &BC, &80, &3A, &F0, 8  , &A9, 0  , &9D, &80, &3A, &B9, 0     ; 34C4: BC 80 3A... ..:
    EQUB &A9, 0  , &85, &78, &A2, &1E                                 ; 34D0: A9 00 85... ...
    EQUS " ~M"                                                        ; 34D6: 20 7E 4D     ~M
    EQUB &A2, &9D, &20, &50, &0E, &F0, &F9, &A2, &9D, &20, &50, &0E   ; 34D9: A2 9D 20... ..
    EQUB &F0, &10                                                     ; 34E5: F0 10       ..
    EQUS " a2$x"                                                      ; 34E7: 20 61 32...  a2
    EQUB &10, &F2, &A2, &B6, &20, &50, &0E, &D0, &EB                  ; 34EC: 10 F2 A2... ...
    EQUS "Fx`"                                                        ; 34F5: 46 78 60    Fx`
    EQUB &80, &40, &20, &10, 0  , 0  , 0  , 0                         ; 34F8: 80 40 20... .@
    EQUS "Amateur"                                                    ; 3500: 41 6D 61... Ama
    EQUB &FF                                                          ; 3507: FF          .
    EQUS " POINTS"                                                    ; 3508: 20 50 4F...  PO
    EQUB &FF, &81, &81, &81, &81, &D0, &38, &1D, &50, &33, &91, &70   ; 350F: FF 81 81... ...
    EQUB &BD, 0                                                       ; 351B: BD 00       ..
    EQUS "D=P9"                                                       ; 351D: 44 3D 50... D=P
    EQUB &1D, &D0, &33, &A8, &20, 0  , &7E, &E0, &1C, &D0, &C5, &4C   ; 3521: 1D D0 33... ..3
    EQUB &18, &7F, &BC, 0  , &38, &F0, 8  , &A9, 0  , &9D, 0  , &38   ; 352D: 18 7F BC... ...
    EQUB &B9, 0  , &60, &A0, &80, &91, &70, &BC, &80, &38, &F0, 8     ; 3539: B9 00 60... ..`
    EQUB &A9, 0  , &9D, &80, &38, &B9, 0  , &60, &A0, &88, &91, &0F   ; 3545: A9 00 9D... ...
    EQUB &0F, &0E, &0E, &0D, 5  , 6  , &0F, 4  , &0E, 0  , &0D, &0F   ; 3551: 0F 0E 0E... ...
    EQUB &0F, 2  , 3  , 4  , 9  , 6  , &0F, &0E, 0  , &0D, 7  , 4     ; 355D: 0F 02 03... ...
    EQUB &0A, 0  , 1  , &0C, &0C, 2  , 1  , 1  , &0A, 3  , 4  , 0     ; 3569: 0A 00 01... ...
    EQUB 1  , 3  , 1  , 3  , 0  , &80, &C0, &40, &60, &E0             ; 3575: 01 03 01... ...
    EQUS "   "                                                        ; 357F: 20 20 20
    EQUB &9C, &86, &9D, &84, &FF                                      ; 3582: 9C 86 9D... ...
    EQUS "ACCUMULATED"                                                ; 3587: 41 43 43... ACC
    EQUB &FB, &FF, &81, &81, &81, &81, 8  , &A9, 0  , &9D, &80, &37   ; 3592: FB FF 81... ...
    EQUB &B9, 0  , &60, &A0, &78, &91                                 ; 359E: B9 00 60... ..`
    EQUS "pLV}"                                                       ; 35A4: 70 4C 56... pLV
    EQUB &A9, &60, &8D, &EE, &7E, &CA, &BC, &50, &31, &CC, &24, &7D   ; 35A8: A9 60 8D... .`.
    EQUB &F0, &16, &A9, &91, &8D, &0F, &7C, &8C, &2F, &7D, &8C, &24   ; 35B4: F0 16 A9... ...
    EQUB &7D, &A9, &60, &8D, 0  , &7C, &BC, &D0, &30, &8C             ; 35C0: 7D A9 60... }.`
    EQUS "M} "                                                        ; 35CA: 4D 7D 20    M}
    EQUB &F3, &7E, &3D, &0E, &0E, &0B, &0B, &0B, 6  , &0F, &0D, 5     ; 35CD: F3 7E 3D... .~=
    EQUB &0D, 7  , &0B, &0E, &0E, 3  , 4  , 9  , 8  , &0F, &0D, &0D   ; 35D9: 0D 07 0B... ...
    EQUB 7  , 9  , &0D, 6  , 9  , 2  , &0C, &0A, &0A, 8  , 2  , &0A   ; 35E5: 07 09 0D... ...
    EQUB 8  , 4  , &0A, 3  , 3  , &0A, 3  , &0A, 0  , &10             ; 35F1: 08 04 0A... ...
    EQUS "0 `p@FORMULA 3  CHAMPIONSHIP"                               ; 35FB: 30 20 60... 0 `
    EQUB &FF, &81, &81, &81, &81, &F0, 8  , &A9, 0  , &9D, 0  , &36   ; 3617: FF 81 81... ...
    EQUB &B9, 0  , &60, &A0, &60, &91, &70, &BC, &80, &36, &F0, 8     ; 3623: B9 00 60... ..`
    EQUB &A9, 0  , &9D, &80, &36, &B9, 0  , &60, &A0, &68, &91, &70   ; 362F: A9 00 9D... ...
    EQUB &BC, 0  , &37, &F0, 8  , &A9, 0  , &9D, 0  , &37, &B9, 0     ; 363B: BC 00 37... ..7
    EQUB &60, &A0, &70, &91, &70, &BC, &80, &37, &F0, 9  , 2  , 8     ; 3647: 60 A0 70... `.p
    EQUB 4  , &0A, &0D, &0B, 9  , &0E, 8  , 4  , 8  , 9  , 2  , 8     ; 3653: 04 0A 0D... ...
    EQUB 8  , &0D, &0D, &0C, &0B, 8  , 2  , 8  , &0F, &0A, 8  , 9     ; 365F: 08 0D 0D... ...
    EQUB 8  , 9  , 3  , &0B, &0B, 8  , &0B, 8  , 8  , 1  , 8  , 8     ; 366B: 08 09 03... ...
    EQUB 9  , 1  , &FF                                                ; 3677: 09 01 FF    ...
    EQUS "w33"                                                        ; 367A: 77 33 33    w33
    EQUB &11, &11, &11, &AB                                           ; 367D: 11 11 11... ...
    EQUS "YOUR TIME IS UP!"                                           ; 3681: 59 4F 55... YOU
    EQUB &AB, &FF                                                     ; 3691: AB FF       ..
    EQUS "PRESS "                                                     ; 3693: 50 52 45... PRE
    EQUB &FF, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81   ; 3699: FF 81 81... ...
    EQUB &81, &81, &A0, &48, &91, &70, &BC, 0  , &35, &F0, 8  , &A9   ; 36A5: 81 81 A0... ...
    EQUB 0  , &9D, 0  , &35, &B9, 0  , &60, &A0, &50, &91, &70, &BC   ; 36B1: 00 9D 00... ...
    EQUB &80, &35, &F0, 8  , &A9, 0  , &9D, &80, &35, &B9, 0  , &60   ; 36BD: 80 35 F0... .5.
    EQUB &A0, &58, &91, &70, &BC, 0  , &36, &0A, 1  , &0C, 0  , 2     ; 36C9: A0 58 91... .X.
    EQUB 5  , 3  , 1  , 6  , &0C, 9  , 0  , &0A, 1  , 0  , 0  , 5     ; 36D5: 05 03 01... ...
    EQUB 5  , 4  , 3  , &0A, 9  , 0  , 7  , 2  , 0  , 1  , 0  , &0B   ; 36E1: 05 04 03... ...
    EQUB 1  , 3  , 1  , 0  , 3  , 0  , 9  , 0  , 1  , 9  , 0  , 0     ; 36ED: 01 03 01... ...
    EQUB &FF, &EE, &CC, &CC, &88, &88, &88, &FE, &EB, &A7, &D3        ; 36F9: FF EE CC... ...
    EQUS "NAME OF"                                                    ; 3704: 4E 41 4D... NAM
    EQUB &D4, &1F, &0C, &11, &83                                      ; 370B: D4 1F 0C... ...
    EQUS "____________"                                               ; 3710: 5F 5F 5F... ___
    EQUB &1F, 9  , &10, &85, &D8, &FF, &1F, 2  , &0A, &86, &FF, &81   ; 371C: 1F 09 10... ...
    EQUB &81, &81, &81, &81, 0  , &60, &A0, &38, &91, &70, &BC, 0     ; 3728: 81 81 81... ...
    EQUB &34, &F0, 8  , &A9, 0  , &9D, 0  , &34, &B9, 0  , &60, &A0   ; 3734: 34 F0 08... 4..
    EQUB &40, &91, &70, &BC, &80, &34, &F0, 8  , &A9, 0  , &9D, &80   ; 3740: 40 91 70... @.p
    EQUB &34, &B9, 0  , &60, &0A, &0A, 8  , 8  , &45, 8  , 8  , 9     ; 374C: 34 B9 00... 4..
    EQUB &4A, &88, 8  , 8  , &0A, &4A, 2  , 0  , 2  , &4A, 8  , 5     ; 3758: 4A 88 08... J..
    EQUB &88, 8  , 8  , 2                                             ; 3764: 88 08 08... ...
    EQUS "BHR"                                                        ; 3768: 42 48 52    BHR
    EQUB 8  , &11, &51, 0  , &48, &0A, &52, 0  , 0  , &40, 0  , &40   ; 376B: 08 11 51... ..Q
    EQUB 0  , &40                                                     ; 3777: 00 40       .@
; &3779 referenced 1 time by &42DE
.L3779
    EQUS "RN12345Position"                                            ; 3779: 52 4E 31... RN1
    EQUB &A8                                                          ; 3788: A8          .
    EQUS "In front:"                                                  ; 3789: 49 6E 20... In
    EQUB &AD, &FF                                                     ; 3792: AD FF       ..
    EQUS "Laps to go"                                                 ; 3794: 4C 61 70... Lap
    EQUB &A8                                                          ; 379E: A8          .
    EQUS "Behind:"                                                    ; 379F: 42 65 68... Beh
    EQUB &B2, &FF, &C6, &FF, &81, &81, &32, &B9, 0  , &60, &A0, &28   ; 37A6: B2 FF C6... ...
    EQUB &91, &70, &BC, 0  , &33, &F0, 8  , &A9, 0  , &9D, 0  , &33   ; 37B2: 91 70 BC... .p.
    EQUB &B9, 0  , &60, &A0, &30, &91, &70, &BC, &80, &33, &F0, 8     ; 37BE: B9 00 60... ..`
    EQUB &A9, 0  , &9D, &80, &33, &B9, &8E, &CC, &62, &8C, &CD        ; 37CA: A9 00 9D... ...
    EQUS "bHJJJJ"                                                     ; 37D5: 62 48 4A... bHJ
    EQUB &D0, 8  , &A9, &1F                                           ; 37DB: D0 08 A9... ...
    EQUS "$x0"                                                        ; 37DF: 24 78 30    $x0
    EQUB 2  , &A9, &F0, &18                                           ; 37E2: 02 A9 F0... ...
    EQUS "i0 "                                                        ; 37E6: 69 30 20    i0
    EQUB &92, &50, 6  , &78, &68, 6  , &78, &B0, &0C, &29, &0F, &D0   ; 37E9: 92 50 06... .P.
    EQUB 2  , &A9, &1F, &18                                           ; 37F5: 02 A9 1F... ...
    EQUS "i0 "                                                        ; 37F9: 69 30 20    i0
    EQUB &92, &50, &60, &FF, &FE, &EC, &DA, &D5, &ED, &DB, &D5, &EE   ; 37FC: 92 50 60... .P`
    EQUB &DC, &D5, &EB, &D2                                           ; 3808: DC D5 EB... ...
    EQUS "DURATION OF QUALIFYING LAPS"                                ; 380C: 44 55 52... DUR
    EQUB &FF                                                          ; 3827: FF          .
    EQUS " ] "                                                        ; 3828: 20 5D 20     ]
    EQUB &FF, &9D, &80, &31, &B9, 0  , &60, &A0, &18, &91, &70, &BC   ; 382B: FF 9D 80... ...
    EQUB 0  , &32, &F0, 8  , &A9, 0  , &9D, 0  , &32, &B9, 0  , &60   ; 3837: 00 32 F0... .2.
    EQUB &A0, &20, &91, &70, &BC, &80, &32, &F0, 8  , &A9, 0  , &9D   ; 3843: A0 20 91... . .
    EQUB &80, &A9, 4  , &A0, 0  , &A2, 1  , &20, &F4, &FF             ; 384F: 80 A9 04... ...
    EQUS " 9O"                                                        ; 3859: 20 39 4F     9O
    EQUB &A2, 9  , &A9, 0  , &85, &69, &9D, &F4, 5  , &CA, &10, &FA   ; 385C: A2 09 A9... ...
    EQUB &A9, &F6, &8D, &FE, 5  , &BA, &86                            ; 3868: A9 F6 8D... ...
    EQUS "k ", '"', "Z"                                               ; 386F: 6B 20 22... k "
    EQUB &A9, &BE, &A0, 0  , &A2, &20, &20, &F4, &FF, &4C, &E0, &63   ; 3873: A9 BE A0... ...
    EQUB &FF, &EC                                                     ; 387F: FF EC       ..
    EQUS "PRACTICE"                                                   ; 3881: 50 52 41... PRA
    EQUB &ED                                                          ; 3889: ED          .
    EQUS "COMPETITION"                                                ; 388A: 43 4F 4D... COM
    EQUB &FF, &FF, &AD                                                ; 3895: FF FF AD    ...
    EQUS "PLEASE"                                                     ; 3898: 50 4C 45... PLE
    EQUB &A2                                                          ; 389E: A2          .
    EQUS "WAIT"                                                       ; 389F: 57 41 49... WAI
    EQUB &AD, &FF, &1F, 9  , 2  , &FF, &81, &81, &81, &A9, 0  , &9D   ; 38A3: AD FF 1F... ...
    EQUB &80, &30, &B9, 0  , &60, &A0, 8  , &91, &70, &BC, 0  , &31   ; 38AF: 80 30 B9... .0.
    EQUB &F0, 8  , &A9, 0  , &9D, 0  , &31, &B9, 0  , &60, &A0, &10   ; 38BB: F0 08 A9... ...
    EQUB &91, &70, &BC, &80, &31, &F0, 8  , &A9, 0  , &FF, &FF, &88   ; 38C7: 91 70 BC... .p.
    EQUB &88, &CC, &EE, &FF, &88, &88, &CC, &EE, &FF, &88, &CC, &EE   ; 38D3: 88 CC EE... ...
    EQUB &FF, &88, &CC, &EE, &FF, &88, &CC, &EE, &FF, &88, &CC, &EE   ; 38DF: FF 88 CC... ...
    EQUB &FF, &88, &88, &CC, &CC, &CC, &EE, &EE, &EE, &FF, &FF, &FF   ; 38EB: FF 88 88... ...
    EQUB &88, &88, &88, &CC, &CC, 0  , &0F, &F0, &FF, &1B, &1B, &1B   ; 38F7: 88 88 88... ...
    EQUB &15, 3  , 2  , 2  , 6  , &0B, &0F, &13, &17, &1B             ; 3903: 15 03 02... ...
    EQUS "&++++++++++++&"                                             ; 390D: 26 2B 2B... &++
    EQUB &1B, &17, &13, &0F, &0B, 6  , 2  , 2  , 3  , &15, &1B, &1B   ; 391B: 1B 17 13... ...
    EQUB &1B, &1B, &FF, &81, &81, &F3, &7E, &4C, &13, &7D, &BD        ; 3927: 1B 1B FF... ...
    EQUS "`_)"                                                        ; 3932: 60 5F 29    `_)
    EQUB 3  , &A8, &B9, &FC, &38, &BC, 0  , &30, &F0, 8  , &A9, 0     ; 3935: 03 A8 B9... ...
    EQUB &9D, 0  , &30, &B9, 0  , &60, &A0, 0  , &91, &70, &BC, &80   ; 3941: 9D 00 30... ..0
    EQUB &30, &F0, 8  , &FF, &FF, &11, &11, &33, &77, &FF, &11, &11   ; 394D: 30 F0 08... 0..
    EQUB &33, &77, &FF, &11, &33, &77, &FF, &11, &33, &77, &FF, &11   ; 3959: 33 77 FF... 3w.
    EQUB &33, &77, &FF, &11, &33, &77, &FF, &11, &11                  ; 3965: 33 77 FF... 3w.
    EQUS "333www"                                                     ; 396E: 33 33 33... 333
    EQUB &FF, &FF, &FF, &11, &11, &11                                 ; 3974: FF FF FF... ...
    EQUS "33uuuu555555554444443332221100//..--,,+*)('&"               ; 397A: 33 33 75... 33u
    EQUB &A2, &9C, 8  , 8  , &E7, &FF, &8D, &DA, &7B, &A9, &91, &8D   ; 39A6: A2 9C 08... ...
    EQUB &0F, &7C, &8D, &0F, &7C, &8D, &0F, &7E, &A9, &E0, &8D, &EE   ; 39B2: 0F 7C 8D... .|.
    EQUB &7E, &60, &A9, 0  , &85, &70, &85, &72, &A2, &67, &86, &71   ; 39BE: 7E 60 A9... ~`.
    EQUB &E8, &86, &73, &A2                                           ; 39CA: E8 86 73... ..s
    EQUS "O w3"                                                       ; 39CE: 4F 20 77... O w
    EQUB &11, 0  , &80, 1  , &C1, &81, &C2, &42, &C0, &83, &43, &20   ; 39D2: 11 00 80... ...
    EQUB 4  , &84, &9D, &CF, &CE, &EE, &DD, &EE, 0  , 0  , 0  , 0     ; 39DE: 04 84 9D... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 39EA: 00 00 00... ...
    EQUB 0  , 0  , &77, &BB, &DD, &EE, &77, &BB, &DD, &EE, &1F, 5     ; 39F6: 00 00 77... ..w
    EQUB &18, &86, &D9                                                ; 3A02: 18 86 D9    ...
    EQUS "SPACE BAR TO CONTINUE"                                      ; 3A05: 53 50 41... SPA
    EQUB &FF, &45, &FF                                                ; 3A1A: FF 45 FF    .E.
    EQUS "GRID POSITIONS"                                             ; 3A1D: 47 52 49... GRI
    EQUB &FF, &B8, 6  , &20, &D6, &37, 6  , &78, &B0, &0B, &A9, &2E   ; 3A2B: FF B8 06... ...
    EQUB &20, &92, &50, &BD, &A0, 6  , &20, &D6, &37, &60, &AD, &24   ; 3A37: 20 92 50...  .P
    EQUB &7D, &8D, &D4, &7B, &AD, &24, &7F, &8D, &D7, &7B, &AD, &7D   ; 3A43: 7D 8D D4... }..
    EQUB &7F, &A0, 1  , &B9, &71, &3A, &85, &74, &BE, &6F, &3A, &A9   ; 3A4F: 7F A0 01... ...
    EQUB &97, &9D, &79, &7C, &A9, &E2, &E8, &9D, &79, &7C, &A9, &E6   ; 3A5B: 97 9D 79... ..y
    EQUB &E4, &74, &D0, &F6, &88, &10, &E4, &60, 0  , &78, &23, &9B   ; 3A67: E4 74 D0... .t.
    EQUB &AF                                                          ; 3A73: AF          .
    EQUS "FINISHED"                                                   ; 3A74: 46 49 4E... FIN
    EQUB &AF, &FF, 0  , 0  , &A6                                      ; 3A7C: AF FF 00... ...
    EQUS "Less than one minute to go"                                 ; 3A81: 4C 65 73... Les
    EQUB &A6, &FF, &1F, 5  , &14, &84, &9D, &86, &33, &A2, &9C, &A5   ; 3A9B: A6 FF 1F... ...
    EQUB &83, &FF, &81, &81, &81, &A9, &F0, &A2, 9  , &9D, &C0, &42   ; 3AA7: 83 FF 81... ...
    EQUB &CA, &10, &FA, &68, &A2, 5  , &9D, &C2                       ; 3AB3: CA 10 FA... ...
    EQUS "BEt"                                                        ; 3ABB: 42 45 74    BEt
    EQUB &CA, &10, &F8, &60, &85, &78, &BD, &D0, 6  , &20, &D6, &37   ; 3ABE: CA 10 F8... ...
    EQUB &A9, &3A, &20, &92, &50, &BD, 0  , 0  , &1D, &87, &15, &80   ; 3ACA: A9 3A 20... .:
    EQUB &80, &80, 0  , 7  , &80, 0  , &88, &91, &97, &9D, &28, &93   ; 3AD6: 80 80 00... ...
    EQUB 0  , &80, 0  , &80, 0  , 0  , 0  , &80, 0  , 0  , 0  , 0     ; 3AE2: 00 80 00... ...
    EQUB 0  , &80, &A6, &E0, &13, &22, &8A, 0  , &9D, &80, &80, &80   ; 3AEE: 00 80 A6... ...
    EQUB &80, &80, &94, &A8, &F3, 0  , &97, &A5, &7A, 8  , &F5, &73   ; 3AFA: 80 80 94... ...
; &3B06 referenced 1 time by &5112
.L3B06
    EQUS "XYZ[]^_`bcdeghijlmnoqrstvwxy{|}~@H"                         ; 3B06: 58 59 5A... XYZ
    EQUB &18                                                          ; 3B28: 18          .
    EQUS "0px"                                                        ; 3B29: 30 70 78    0px
    EQUB &D0, &1D, &E0, &A0, &F0, &0D, &CA, &10, &12, &E0, &C0, &B0   ; 3B2C: D0 1D E0... ...
    EQUB &EF, &A9, &A5, &A0, &77, &D0, &0C, &A5                       ; 3B38: EF A9 A5... ...
    EQUS "j)?"                                                        ; 3B40: 6A 29 3F    j)?
    EQUB &D0, &F4, &A2, &28, &A9, &F2, &A0, 5  , &86, &6D, &48, &84   ; 3B43: D0 F4 A2... ...
    EQUS "t6B:50C<?5>>4><<<86223=87<40=C>:59@=7C?:8B:677"             ; 3B4F: 74 36 42... t6B
    EQUS "7;"                                                         ; 3B7D: 37 3B       7;
    EQUB 0                                                            ; 3B7F: 00          .
    EQUS "88<5B:"                                                     ; 3B80: 38 38 3C... 88<
    EQUB &E8, &88, &C8, &E8, &CA, &C8, &88, &CA, &88, &E8, &E8, &C8   ; 3B86: E8 88 C8... ...
    EQUB &C8, &CA, &CA, &88, &18, &EA, &EA, &18, &18, &EA, &EA, &18   ; 3B92: C8 CA CA... ...
    EQUS "uutuvv"                                                     ; 3B9E: 75 75 74... uut
    EQUB &12, &11, &10, &0E, &0D, &0C, &81, &81, &A5, &84, &99, &93   ; 3BA4: 12 11 10... ...
    EQUB &62, &20, &B6, &7F, &88, &10, &E5, &60, &A5, &6C, &10, &4D   ; 3BB0: 62 20 B6... b .
    EQUB &A6, &6D, &F0, &49, &10, &10, &E0, &80, &D0, &0C, &24, &61   ; 3BBC: A6 6D F0... .m.
    EQUB &10, 2  , &A2, &F0, &A0, 0  , &A9, &80, 4  , 7  , 9  , 7     ; 3BC8: 10 02 A2... ...
    EQUB 0  , &0B, 7  , 3  , 0  , 0  , 0  , 4  , 4  , 0  , &AA, &AF   ; 3BD4: 00 0B 07... ...
    EQUB &B3, &AF, &A2, &B8, &AF, &81, &81, &85, &84, &A3, &83, &85   ; 3BE0: B3 AF A2... ...
    EQUB &83, &83, &87, &87, &7F, &84, &87, &16, 7  , &17, 0  , &0A   ; 3BEC: 83 83 87... ...
    EQUB &20, 0  , 0  , 0  , 0  , 0  , 0  , &FF, &EB, &D2             ; 3BF8: 20 00 00...  ..
    EQUS "WING SETTINGS"                                              ; 3C02: 57 49 4E... WIN
    EQUB &D8                                                          ; 3C0F: D8          .
    EQUS "range 0 to 40"                                              ; 3C10: 72 61 6E... ran
    EQUB &1F, &0E, &10                                                ; 3C1D: 1F 0E 10    ...
    EQUS "rear"                                                       ; 3C20: 72 65 61... rea
    EQUB &A2, &85, &D8, &FF, &81, &81, &81, &81, &E5, &74, &85, &7F   ; 3C24: A2 85 D8... ...
    EQUB &BD, &98, 3  , &38, &E5, &0B, &38, &E9, 4                    ; 3C30: BD 98 03... ...
    EQUS "JJJ"                                                        ; 3C39: 4A 4A 4A    JJJ
    EQUB &85, &76, &A0, 5  , &A5, &76, &D9, &A4, &3B, &F0, 9  , &B9   ; 3C3C: 85 76 A0... .v.
    EQUB &93, &62, &F0, &0C, &A9, 0  , &F0, 2  , &A2, 5  , &20, &D0   ; 3C48: 93 62 F0... .b.
    EQUB &41, &A2, &18                                                ; 3C54: 41 A2 18    A..
    EQUS " ~M "                                                       ; 3C57: 20 7E 4D...  ~M
    EQUB &E0, &3E, &8D, &3E, &5F, &A2, &19                            ; 3C5B: E0 3E 8D... .>.
    EQUS " ~M "                                                       ; 3C62: 20 7E 4D...  ~M
    EQUB &E0, &3E, &8D                                                ; 3C66: E0 3E 8D    .>.
    EQUS "=_ "                                                        ; 3C69: 3D 5F 20    =_
    EQUB &D0, &34, &60, &AD, &3A, &5F, &18, &69, 7  , &AA             ; 3C6C: D0 34 60... .4`
    EQUS " ~M`"                                                       ; 3C76: 20 7E 4D...  ~M
    EQUB &1F, &18, 2  , &DA, &D6, &FF, &A2                            ; 3C7A: 1F 18 02... ...
    EQUS "BEST LAP TIMES"                                             ; 3C81: 42 45 53... BES
    EQUB &A2, &FF                                                     ; 3C8F: A2 FF       ..
    EQUS " mins"                                                      ; 3C91: 20 6D 69...  mi
    EQUB &FF                                                          ; 3C96: FF          .
    EQUS " laps"                                                      ; 3C97: 20 6C 61...  la
    EQUB &FF                                                          ; 3C9C: FF          .
    EQUS " RACE"                                                      ; 3C9D: 20 52 41...  RA
    EQUB &FF                                                          ; 3CA2: FF          .
    EQUS "ins"                                                        ; 3CA3: 69 6E 73    ins
    EQUB &FF, &81, &81, &81, &81, &81, &44, &88, &F0, &F0, &F0, &F0   ; 3CA6: FF 81 81... ...
    EQUB &F0, &F0, &70, &30, &A4, &5B, &BE, &3C, 1  , &BD, &8C, 1     ; 3CB2: F0 F0 70... ..p
    EQUB &30, &20, &BD, &C8, 3                                        ; 3CBE: 30 20 BD... 0 .
    EQUS "JJJ"                                                        ; 3CC3: 4A 4A 4A    JJJ
    EQUB &85, &74, &18, &69, &B6, &85, &84, &A9, &B6, &38, 0  , 5     ; 3CC6: 85 74 18... .t.
    EQUB 9  , &0E, &12, &19, &1A, &1B, &1E                            ; 3CD2: 09 0E 12... ...
    EQUS " ", '"', "%'"                                               ; 3CD9: 20 22 25...  "%
    EQUB 0  , 8  , &10, &18, &1E                                      ; 3CDD: 00 08 10... ...
    EQUS "&),159>BF"                                                  ; 3CE2: 26 29 2C... &),
    EQUB &8A, &4A, &4A, &18, &69, &40, &A8, &8A, &29, 3  , &0A, &0A   ; 3CEB: 8A 4A 4A... .JJ
    EQUB &85, &74, &0A, &18                                           ; 3CF7: 85 74 0A... .t.
    EQUS "etiP`"                                                      ; 3CFB: 65 74 69... eti
    EQUB &FE, &EC, &D3                                                ; 3D00: FE EC D3    ...
    EQUS "ANOTHER"                                                    ; 3D03: 41 4E 4F... ANO
    EQUB &D4, &ED                                                     ; 3D0A: D4 ED       ..
    EQUS "START"                                                      ; 3D0C: 53 54 41... STA
    EQUB &D7, &FF, &8D, &81, &9D, &83, &C8, &A2, &9C, &FF, &81, &81   ; 3D11: D7 FF 8D... ...
    EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &0E, &0E   ; 3D1D: 81 81 81... ...
    EQUB &0E, 0  , &80, &E0                                           ; 3D29: 0E 00 80... ...
    EQUS "twwww"                                                      ; 3D2D: 74 77 77... tww
    EQUB 0  , &10, &70, &E2, &EE, &EE, &EE, &EE, &91, &AA, 0  , &11   ; 3D32: 00 10 70... ..p
    EQUB 0  , &33, &22, &11, &22, &44, &99, &22, &88, &EE             ; 3D3E: 00 33 22... .3"
    EQUS "3Dp0"                                                       ; 3D48: 33 44 70... 3Dp
    EQUB &10, &10, &88, 0  , &85, &74, &A9, &20, &20, &92, &50, &C6   ; 3D4C: 10 10 88... ...
    EQUB &74, &D0, &F7, &60, &A9, 0  , &85, 0  , &85, &74, &85, &70   ; 3D58: 74 D0 F7... t..
    EQUB &A9, &30, &85, &71, &A6, &74, &E0, &28, &F0, &ED, &BD, 0     ; 3D64: A9 30 85... .0.
    EQUB &39, &85, &75, &A0, &46, &4C, &D0, &31, &AA, &77, &AA, &DD   ; 3D70: 39 85 75... 9.u
    EQUB &0A, 7  , &0A, &0D, &FE, &EC, &CF, &ED, &D0, &EE, &D1, &EB   ; 3D7C: 0A 07 0A... ...
    EQUB &A4, &D2                                                     ; 3D88: A4 D2       ..
    EQUS "THE CLASS OF"                                               ; 3D8A: 54 48 45... THE
    EQUB &D7, &FF, &81, &81, &81, &81, &88, &88                       ; 3D96: D7 FF 81... ...
    EQUS "DDDDD"                                                      ; 3D9E: 44 44 44... DDD
    EQUB 4  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 8  , 0  , 0  , 5     ; 3DA3: 04 00 00... ...
    EQUB 5  , 5  , 5  , 5  , &12, &12, &12, &12, 3  , 1  , &41, 1     ; 3DAF: 05 05 05... ...
    EQUB 5  , 7  , 7  , 3  , &83, &83, &83, &83, &0F, &0F, &0F, &0F   ; 3DBB: 05 07 07... ...
    EQUB &0F, &0F, &0F, &0F, &1C, &1D, &0C, &0E, &0E, 0  , &27, &12   ; 3DC7: 0F 0F 0F... ...
    EQUB 9  , 3  , 3  , 3  , 3  , 3  , 3  , 3  , 3  , 3  , 3  , 3     ; 3DD3: 09 03 03... ...
    EQUB 3  , 3  , 3  , &86, &8E, &8D, &8D, &EB, &8B, &DF, &96, &A6   ; 3DDF: 03 03 03... ...
    EQUB &E9, &8C, &8A, &CE, &EE, 4  , 9  , &19, 0  , 5  , &0A, &14   ; 3DEB: E9 8C 8A... ...
    EQUB 9  , 6  , 4  , 3  , 2  , 1  , 1  , 0  , 0  , &FE, &EB, &A5   ; 3DF7: 09 06 04... ...
    EQUB &82, &D4, &D8, &FF                                           ; 3E03: 82 D4 D8... ...
    EQUS "Professional"                                               ; 3E07: 50 72 6F... Pro
    EQUB &FF, &81, &81, &81, &81, 0  , &10, &80, 0  , 0  , 7  , &0F   ; 3E13: FF 81 81... ...
    EQUB 0  , 0  , 0  , 1  , 3  , &1E, &3C, &68, &16, &16, &3C, &68   ; 3E1F: 00 00 00... ...
    EQUB &F0, &80, &F0, 0  , &F0, &10, &F0, &10, &E1, &21, &E1, &21   ; 3E2B: F0 80 F0... ...
    EQUB 8  , 8  , 8  , 9  , 8  , 1  , &40, 1  , 6  , 0  , 0  , 8     ; 3E37: 08 08 08... ...
    EQUB 8  , 8  , 8  , 8  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 3E43: 08 08 08... ...
    EQUB &88, 8  , &13, &1E                                           ; 3E4F: 88 08 13... ...
    EQUS ")9DOZ"                                                      ; 3E53: 29 39 44... )9D
    EQUB 2  , &0D, &18                                                ; 3E58: 02 0D 18    ...
    EQUS "#3>IT"                                                      ; 3E5B: 23 33 3E... #3>
    EQUB &98, &29, 1  , &18, &65, &42, &AA, &BD, &74, &3E, &8D, &85   ; 3E60: 98 29 01... .).
    EQUB &35, &BD, &76, &3E, &8D, &83, &35, &60, &84, &85, &86, &87   ; 3E6C: 35 BD 76... 5.v
    EQUB &81, &84, &83, &82, &83, &84, &81, &87                       ; 3E78: 81 84 83... ...
    EQUS "SELECT "                                                    ; 3E80: 53 45 4C... SEL
    EQUB &FF                                                          ; 3E87: FF          .
    EQUS " DRIVER"                                                    ; 3E88: 20 44 52...  DR
    EQUB &FF, &81, &81, &81, &81                                      ; 3E8F: FF 81 81... ...
    EQUS "DD", '"'                                                    ; 3E94: 44 44 22    DD"
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 9     ; 3E97: 00 00 00... ...
    EQUB &0A, &0A, &0A, 9  , 1  , 1  , 1  , 1  , 9  , 8  , &28, 0     ; 3EA3: 0A 0A 0A... ...
    EQUB &F0, &80, &F0, &80                                           ; 3EAF: F0 80 F0... ...
    EQUS "xHxH"                                                       ; 3EB3: 78 48 78... xHx
    EQUB &86, &86, &C3, &61, &F0, &10, &F0, 0  , 0  , 0  , 0  , 8     ; 3EB7: 86 86 C3... ...
    EQUB &0C, &87, &C3, &61, 0  , 0  , 0  , &10, 0  , 0  , &0E, &0F   ; 3EC3: 0C 87 C3... ...
    EQUB 0  , 0  , &0B, &16                                           ; 3ECF: 00 00 0B... ...
    EQUS "!.9DOOD9.!"                                                 ; 3ED3: 21 2E 39... !.9
    EQUB &16, &0B, 0  , &A9, &74, &A0, 0  , &A2, 2  , &20, 0  , &63   ; 3EDD: 16 0B 00... ...
    EQUB &20, &D0, &32, &90, &0B, &88, &30, &EF, &A9, &7F, &20, &EE   ; 3EE9: 20 D0 32...  .2
    EQUB &FF, &4C, &EE, &3E, &60, &AA, &AC, &B0, &B0, &AC, &AA, &1F   ; 3EF5: FF 4C EE... .L.
    EQUB 5  , &12, &84, &9D, &86, &32, &A2, &9C, &A5, &83, &FF, &81   ; 3F01: 05 12 84... ...
    EQUB &81, &81, &81, &FF, &44, &FF, &AA, &FF, &11, &FF, &11, &FF   ; 3F0D: 81 81 81... ...
    EQUB &BB, &77, &CF, &47, &CF, &8F, &8F, &8F, &8F, &8F, &0F, &0F   ; 3F19: BB 77 CF... .w.
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0A, &0E, &0E, &0C, &1C, &1C   ; 3F25: 0F 0F 0F... ...
    EQUB &1C, &1C, &84, &84, &84, &84, &0C, 8  , &28, 8  , 0  , 0     ; 3F31: 1C 1C 84... ...
    EQUB 0  , 4  , &0A, &0A, &0A, 4  , 0  , 0  , 0  , 0  , 0  , 0     ; 3F3D: 00 04 0A... ...
    EQUB 0  , 0                                                       ; 3F49: 00 00       ..
    EQUS "DDDDD"                                                      ; 3F4B: 44 44 44... DDD
    EQUB &1B, &1B, &1B, &15, 3  , 2  , 2  , 2  , 6  , &0B, &0F, &13   ; 3F50: 1B 1B 1B... ...
    EQUB &17, &1B                                                     ; 3F5C: 17 1B       ..
    EQUS "&+++++++++++&"                                              ; 3F5E: 26 2B 2B... &++
    EQUB &1B, &17, &13, &0F, &0B, 6  , 2  , 2  , 2  , 3  , &15, &1B   ; 3F6B: 1B 17 13... ...
    EQUB &1B, &1B                                                     ; 3F77: 1B 1B       ..
    EQUS "   BehiNovice"                                              ; 3F79: 20 20 20...
    EQUB &FF, &81, &81, &81, &81, &81                                 ; 3F86: FF 81 81... ...
    EQUS "@@b@Qb"                                                     ; 3F8C: 40 40 62... @@b
    EQUB &80                                                          ; 3F92: 80          .
    EQUS "p00"                                                        ; 3F93: 70 30 30    p00
    EQUB &10, &98, 0  , &44, &88, &F0, &F0, &F0, &F0, &F0, &F0, &F0   ; 3F96: 10 98 00... ...
    EQUB &70, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0   ; 3FA2: 70 F0 F0... p..
    EQUB &F0, &F0, &F0, &E0, &C0, &E0, &C0, &80, &80, &11, 0  , &22   ; 3FAE: F0 F0 F0... ...
    EQUB &11, &44, &22, &99, &44, &11, &77, &CC, &22, &88, &66, &33   ; 3FBA: 11 44 22... .D"
    EQUB &99, &22, &CC, &77, &AA, &88, &FF, &11, &77, &AA, &88, &EA   ; 3FC6: 99 22 CC... .".
    EQUB &EA, &C8, &EA, &88, &C8, &EA, &C8, &EA, &EA, &88, &EA, &C8   ; 3FD2: EA C8 EA... ...
    EQUB &88, &EA                                                     ; 3FDE: 88 EA       ..
; &3FE0 referenced 1 time by &510A
.L3FE0
    EQUB 0  , &40, &80, &C0, 0  , &40, &80, &C0, &77, &BB, &DD, &EE   ; 3FE0: 00 40 80... .@.
    EQUB &77, &BB, &DD, &EE, 0  , &40, &80, &C0, 0  , &40, &80, &C0   ; 3FEC: 77 BB DD... w..
    EQUB 0  , &40, &80, &C0, 0  , &40, &80, &C0, &81, &81, &81, &81   ; 3FF8: 00 40 80... .@.
    EQUB &81, &81, &81, 7  , 1  , 1  , 0  , &88, &88, &88, &88, 0     ; 4004: 81 81 81... ...
    EQUB 0  , 0  , 0  , 4  , 5  , 5  , 5  , 1  , 1  , 0  , &20, 8     ; 4010: 00 00 00... ...
    EQUB 4  , 4  , 4                                                  ; 401C: 04 04 04    ...
    EQUS "IHh,$$4"                                                    ; 401F: 49 48 68... IHh
    EQUB &16, &0F, &0B, 7  , &0F, &0F, 7  , 7  , 7  , &0F, &0F, &0F   ; 4026: 16 0F 0B... ...
    EQUB &0F, &0F, &0F, &0F, &0F                                      ; 4032: 0F 0F 0F... ...
    EQUS ":l(ll,,"                                                    ; 4037: 3A 6C 28... :l(
    EQUB &1C                                                          ; 403E: 1C          .
    EQUS "wffwfff"                                                    ; 403F: 77 66 66... wff
    EQUB 0  , &CC, &66, &66, &CC, &CC, &66, &66, 0  , &80             ; 4046: 00 CC 66... ..f
    EQUS "Max ThrottleJohnny TurboDavey RocketGloria Sla"             ; 4050: 4D 61 78... Max
    EQUS "p "                                                         ; 407E: 70 20       p
    EQUB &81, &81, &81, &40, 0  , 8  , &0C, &0C, 0  , 0  , 0  , 0     ; 4080: 81 81 81... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 2  , 2  , 2  , 2  , 2     ; 408C: 00 00 00... ...
    EQUB 0  , 0  , 0  , &0C, 4  , &0C, 8  , &0C, 5  , 5  , 5  , 5     ; 4098: 00 00 00... ...
    EQUB 5  , 0  , 0  , &10, 0  , 0  , 0  , &20, 0  , 1  , 3  , 3     ; 40A4: 05 00 00... ...
    EQUB &16                                                          ; 40B0: 16          .
    EQUS "4<,xH"                                                      ; 40B1: 34 3C 2C... 4<,
    EQUB &F0, &90, &C3, &43, &C2, &86, &84, &84, &84, &1C, 0  , 0     ; 40B6: F0 90 C3... ...
    EQUB 0  , 0  , 6  , 4  , 6  , 2  , 2  , 2  , 2  , 2  , 0  , 0     ; 40C2: 00 00 06... ...
    EQUB 0  , 0                                                       ; 40CE: 00 00       ..
    EQUS "ZOD9)"                                                      ; 40D0: 5A 4F 44... ZOD
    EQUB &1E, &13, 8                                                  ; 40D5: 1E 13 08    ...
    EQUS "TI>3#"                                                      ; 40D8: 54 49 3E... TI>
    EQUB &18, &0D, 2  , &0C, &1F, 4  , 3  , &EA, &AA, &EA, &1F, &24   ; 40DD: 18 0D 02... ...
    EQUB 2  , &FF, &A9, 0  , &9D, &A0, 6  , &9D, &B8, 6  , &A9, &10   ; 40E9: 02 FF A9... ...
    EQUB &9D, &D0, 6  , &60, &77, &C2, &C0, &BC, &BC, &C0, &C2, &81   ; 40F5: 9D D0 06... ...
    EQUB &81, &81, &0F, &0F, &0F, &0D, &0E, &0F, &0F, &0E, &0E, &0E   ; 4101: 81 81 0F... ...
    EQUS ")!aCBB"                                                     ; 410D: 29 21 61... )!a
    EQUB &C2, &86, 8  , 8  , 0  , &41, 0  , 1  , 1  , 1  , 1  , 0     ; 4113: C2 86 08... ...
    EQUB 0  , 8  , 8  , 8  , 0  , 8  , &0C, 8  , 8  , 0  , &88, &88   ; 411F: 00 08 08... ...
    EQUB &88, &88, &0E, &0A, &0E, 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 412B: 88 88 0E... ...
    EQUB 0  , &14, &0A, &0E, &0A, 4                                   ; 4137: 00 14 0A... ...
    EQUS "<,4"                                                        ; 413D: 3C 2C 34    <,4
    EQUB &16, &12, &12, &12, 3  , &86, &C2, &C3, &43, &E1, &21, &F0   ; 4140: 16 12 12... ...
    EQUB &90, 0  , 0  , 0                                             ; 414C: 90 00 00... ...
    EQUS "Hugh JengineDesmond DashPercy Veer  Gary Clipp"             ; 4150: 48 75 67... Hug
    EQUS "er"                                                         ; 417E: 65 72       er
    EQUB &81, &81, &81, &81, &E0, &F0, &F0, &F0, &F0, &F0, 0  , 0     ; 4180: 81 81 81... ...
    EQUB 0  , 0  , &80, &C0, &E0, &F0, &F0, &F0, &F0, &F0, &F0, &F0   ; 418C: 00 00 80... ...
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &E0, &E0, &C0   ; 4198: F0 F0 F0... ...
    EQUB &C0, &80, &91, 0  , &22, &11, 0  , &22, 0  , &55, &22, &99   ; 41A4: C0 80 91... ...
    EQUB &44, &22, &99, 0  , &11, &77, &CC, &11, &EE                  ; 41B0: 44 22 99... D".
    EQUS "3U", '"', "w"                                               ; 41B9: 33 55 22... 3U"
    EQUB &99, &22, &EE, &55, &DD, &45, &AB, &45, &67, &AB, &CF, &47   ; 41BD: 99 22 EE... .".
    EQUB &8B, &0F, &0F, &0F, &0F, &0F, &0F, &BD, &D0, &3B, &8D, &E2   ; 41C9: 8B 0F 0F... ...
    EQUB &40, &BD, &D7, &3B, &8D, &E3, &40, &BD, &DE, &3B, &8D, &E5   ; 41D5: 40 BD D7... @..
    EQUB &40, &BD, &E5, &3B, &8D, &14, &3D, &BD, &EC, &3B, &8D, &16   ; 41E1: 40 BD E5... @..
    EQUB &3D, &8A, &18, &69, &C8, &8D, &17, &3D, &A2                  ; 41ED: 3D 8A 18... =..
    EQUS "! ~M`y{|}~"                                                 ; 41F6: 21 20 7E... ! ~
    EQUB &A5, &FB, &A6, &FF, &81, &81, &81, &81, &81, &81, &81, &81   ; 4200: A5 FB A6... ...
    EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &0F, &0F   ; 420C: 81 81 81... ...
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &1F, &4A, &0E, &0F, &0F, &0F   ; 4218: 0F 0F 0F... ...
    EQUB &0F, &0F, 0  , &AA, &44, &33, &CC, &AA, &66, &DC, &44, 0     ; 4224: 0F 0F 00... ...
    EQUB &22, &11, &FC, &E0, &80, 0  , 0  , 0  , &44, &11, &C0, &70   ; 4230: 22 11 FC... "..
    EQUB &10, 0  , &F0                                                ; 423C: 10 00 F0    ...
    EQUS "p00"                                                        ; 423F: 70 30 30    p00
    EQUB &10, &10, 0  , &80, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &70   ; 4242: 10 10 00... ...
    EQUB &C0, &C0                                                     ; 424E: C0 C0       ..
    EQUS "Willy SwerveSid Spoiler Billy BumperSlim Chanc"             ; 4250: 57 69 6C... Wil
    EQUS "e Lap Time"                                                 ; 427E: 65 20 4C... e L
    EQUB &A3, &3A, &A9                                                ; 4288: A3 3A A9    .:.
    EQUS "Best Time"                                                  ; 428B: 42 65 73... Bes
    EQUB &A8, &FF, &81, &81, &81, &81, &81, &81, &F0, &90, &E1, &21   ; 4294: A8 FF 81... ...
    EQUB &F0, &61, &C3, &87, &86, &0C, &18, 0  , &0F, &0C, 8  , 0     ; 42A0: F0 61 C3... .a.
    EQUB 0  , 0  , 0  , 6  , &0F, 0  , 0  , 0  , 0  , 0  , 7  , 5     ; 42AC: 00 00 00... ...
    EQUB &1E, 7  , 3  , 1  , &40, 0  , 0  , 0  , &F0, &C0             ; 42B8: 1E 07 03... ...
    EQUS "x,<"                                                        ; 42C2: 78 2C 3C    x,<
    EQUB &16, 3  , 1  , 7  , 0  , &83, 3  , &82, 1  , &C1, &81        ; 42C5: 16 03 01... ...
; &42D0 referenced 1 time by &6458
.sub_C42D0
    LDA #&22 ; '"'                                                    ; 42D0: A9 22       ."
    STA L62CC                                                         ; 42D2: 8D CC 62    ..b
    STA L0077                                                         ; 42D5: 85 77       .w
    LDA #&D7                                                          ; 42D7: A9 D7       ..
    STA L62CD                                                         ; 42D9: 8D CD 62    ..b
    LDX L0040                                                         ; 42DC: A6 40       .@
    LDA L3779,X                                                       ; 42DE: BD 79 37    .y7
    JSR sub_C508C                                                     ; 42E1: 20 8C 50     .P
    LDX #&FF                                                          ; 42E4: A2 FF       ..
    STX L0077                                                         ; 42E6: 86 77       .w
    JSR sub_C508C                                                     ; 42E8: 20 8C 50     .P
    RTS                                                               ; 42EB: 60          `

    EQUB &A2, &13, &20, &EB, &40, &CA, &10, &FA, &60, &85, &52, &83   ; 42EC: A2 13 20... ..
    EQUB &45, &86, &56, &82, &53, &FF, &75, &75, &FE, &EB, &A6, &D2   ; 42F8: 45 86 56... E.V
    EQUS "NUMBER OF LAPS"                                             ; 4304: 4E 55 4D... NUM
    EQUB &EC, &DA, &D6, &ED, &DB, &D6, &EE, &DC, &D6, &FF, 0  , 0     ; 4312: EC DA D6... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 431E: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 1  , 1     ; 432A: 00 00 00... ...
    EQUB 1  , 1  , 0  , 0  , 0  , 0  , 5  , 5  , 5  , 2  , 0  , 0     ; 4336: 01 01 00... ...
    EQUB 0  , 0  , 1  , 1  , 1  , 1  , 3  , &92, &12, &12, &F0, &80   ; 4342: 00 00 01... ...
    EQUB &F0, &80                                                     ; 434E: F0 80       ..
    EQUS "Harry Fume  Dan DipstickWilma Cargo Miles Behi"             ; 4350: 48 61 72... Har
    EQUS "ndTHE  PITS"                                                ; 437E: 6E 64 54... ndT
    EQUB &FF, &1F, 4  , &0E, &88, &86, &D9, &1F, 5  , &10, &84, &9D   ; 4389: FF 1F 04... ...
    EQUB &86, &31, &A2, &9C, &A5, &83, &FF, &20, 0  , 1  , 1  , &0F   ; 4395: 86 31 A2... .1.
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , &0F, 3  , 1  , 0  , &20   ; 43A1: 00 00 00... ...
    EQUB 0  , 8  , 8  , &F0, &68, &3C, &1E, &16, 3  , 1  , 0  , &F0   ; 43AD: 00 08 08... ...
    EQUB &10, &F0, &10, &F0, &90, &78, &48, 8  , 8  , 8  , 8  , &0C   ; 43B9: 10 F0 10... ...
    EQUB &94, &84, &84, 0  , 6  , 2  , 6  , 4  , 6  , 0  , 0  , &A9   ; 43C5: 94 84 84... ...
    EQUB 2                                                            ; 43D1: 02          .
    EQUS " P="                                                        ; 43D2: 20 50 3D     P=
    EQUB &A9, &20, &85, &78, &BD, &E4, &39, &D0, 9  , &A9, 2          ; 43D5: A9 20 85... . .
    EQUS " P=Fx"                                                      ; 43E0: 20 50 3D...  P=
    EQUB &D0, 3  , &20, &D6, &37, &BD                                 ; 43E5: D0 03 20... ..
    EQUS "d8 "                                                        ; 43EB: 64 38 20    d8
    EQUB &D6, &37, &A9, 1                                             ; 43EE: D6 37 A9... .7.
    EQUS " P=`"                                                       ; 43F2: 20 50 3D...  P=
    EQUB &A2, 3  , &20, &5A, &0E, &CA, &10, &FA, &60, 0  , &81, &81   ; 43F6: A2 03 20... ..
    EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81   ; 4402: 81 81 81... ...
    EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81   ; 440E: 81 81 81... ...
    EQUB &81, &81, &22, 0  , &44, &88, &33, &22, &CC, &33, 0  , &55   ; 441A: 81 81 22... .."
    EQUB &22, &CC                                                     ; 4426: 22 CC       ".
    EQUS "3Uf3"                                                       ; 4428: 33 55 66... 3Uf
    EQUB &8F, &25, 7  , &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F   ; 442C: 8F 25 07... .%.
    EQUB &0F, &0F, &0F, &0F, &0E, 0  , &1C, &0C, &14, 8  , &38, &18   ; 4438: 0F 0F 0F... ...
    EQUB &F0, &30, &E1, &43, &C3, &86, &0C, 8  , &87, &0E, &0C, 8     ; 4444: F0 30 E1... .0.
    EQUS "Roland SlideRick Shaw   Peter Out   Dummy Driv"             ; 4450: 52 6F 6C... Rol
    EQUS "er"                                                         ; 447E: 65 72       er
    EQUB &9C, &EE, &9E, &9F, 3  , 4  , &AF, 5  , &9D, &A5, &A7, 4     ; 4480: 9C EE 9E... ...
    EQUB &AE, &AF, 6  , 7  , &E6, &9C, &9E, &9F, 3  , &AF, &B7, 6     ; 448C: AE AF 06... ...
    EQUB 3  , &A6, &AE, 5  , &B7, 7  , &E6, &9F, 3  , &A5, &AE, &AF   ; 4498: 03 A6 AE... ...
    EQUB &B7, 7  , &E6, &9F, &B7, 3  , &A6, 7  , &E5, &9D, &9E, 3     ; 44A4: B7 07 E6... ...
    EQUB 4  , &9E, 3  , &B7, 6  , 3  , &A5, &A6, &B7, &A6, &A7, &AE   ; 44B0: 04 9E 03... ...
    EQUB 5  , 7  , &A6, 4  , &AE, &AF, &A6, 4  , &AE, &AF, &BD, &14   ; 44BC: 05 07 A6... ...
    EQUB &5A, &8D, &40, &5F, &85, &75, &AD, &FA                       ; 44C8: 5A 8D 40... Z.@
    EQUS "YJJJ"                                                       ; 44D0: 59 4A 4A... YJJ
    EQUB &A8, &B9, &D0, &59, &4A, 8  , &4A, &B0, 3  , &20, 0  , &0C   ; 44D4: A8 B9 D0... ...
    EQUB &0A, &28, &6A, &99, &B0, &5F, &88, &10, &EC, &60, &A5, &2D   ; 44E0: 0A 28 6A... .(j
    EQUB &F0, 7  , &C6, &28, &C6                                      ; 44EC: F0 07 C6... ...
    EQUS "(L-E"                                                       ; 44F1: 28 4C 2D... (L-
    EQUB &85, &28, &85, &26, &AC, &F0, &62, &A5, &40, &F0, &10, &A5   ; 44F5: 85 28 85... .(.
    EQUB &3E, &30, &0C, &F0, 6  , &A5, &3D, &D0, &0C, &F0, 4  , &A5   ; 4501: 3E 30 0C... >0.
    EQUB &63, &D0, &11, &98, &F0, &1A, &10, &0C, &C8, &C8, &30, &11   ; 450D: 63 D0 11... c..
    EQUB &C0, 4  , &90, &0D, &A0, 3  , &B0, 9  , &88, &10, 6  , &C0   ; 4519: C0 04 90... ...
    EQUB &FB, &B0, 2  , &A0, &FB, &8C, &F0, &62, &A6, &22, &BC, 0     ; 4525: FB B0 02... ...
    EQUB 7  , &A5, &0D, &85, &76, &B9, 0  , &54, &59, 0  , &56, 8     ; 4531: 07 A5 0D... ...
    EQUB &B9, 0  , &56, 8                                             ; 453D: B9 00 56... ..V
    EQUS " P4"                                                        ; 4541: 20 50 34     P4
    EQUB &C9, &3C, 8  , &90, 6  , &B9, 0                              ; 4544: C9 3C 08... .<.
    EQUS "T P4"                                                       ; 454B: 54 20 50... T P
    EQUB &85, &74, &4A, &18                                           ; 454F: 85 74 4A... .tJ
    EQUS "etJJ("                                                      ; 4553: 65 74 4A... etJ
    EQUB &B0, 2                                                       ; 4558: B0 02       ..
    EQUS "I?("                                                        ; 455A: 49 3F 28    I?(
    EQUB &10, 2  , &49, &80                                           ; 455D: 10 02 49... ..I
    EQUS "( P48"                                                      ; 4561: 28 20 50... ( P
    EQUB &E5, &0B, &85, &44, &10, 2  , &49, &FF, &C9, &40, &90, 2     ; 4566: E5 0B 85... ...
    EQUB &49, &7F, &8D, &F2                                           ; 4572: 49 7F 8D... I..
    EQUS "bI?"                                                        ; 4576: 62 49 3F    bI?
    EQUB &85, &74, &4A, &18                                           ; 4579: 85 74 4A... .tJ
    EQUS "et "                                                        ; 457D: 65 74 20    et
    EQUB &10, &46, &18, &65, &5D, &18, &6D, &F0, &62, &18, &65, &28   ; 4580: 10 46 18... .F.
    EQUB &18, &65, &0D, &18, &10, 1  , &38, &6A, &85, &0D, &38, &E5   ; 458C: 18 65 0D... .e.
    EQUB &76, &85, &4E, &A9, 0  , &85, &77, &A5, &26, &38, &E9, 4     ; 4598: 76 85 4E... v.N
    EQUB &50, 2  , &A9, &C8, &85, &26, &18, &65, &2D, &F0, 4  , &70   ; 45A4: 50 02 A9... P..
    EQUB &16, &10, &16, &A5                                           ; 45B0: 16 10 16... ...
    EQUS "& P4"                                                       ; 45B4: 26 20 50... & P
    EQUB &C9, 5  , &90, 7  , &20, &CB, &4D, &A9, 1  , &D0, 6  , &A9   ; 45B8: C9 05 90... ...
    EQUB 0  , &F0, 2  , &A9, &7F, &85, &2D, &0A, &26, &77, &0A, &26   ; 45C4: 00 F0 02... ...
    EQUB &77, &85, &76, &A6, &6F, &BD, &64, 1  , &20, &10, &46, &10   ; 45D0: 77 85 76... w.v
    EQUB 2  , &C6, &77, &A4, &22, &18, &79, 1  , 9  , 8  , &18, &69   ; 45DC: 02 C6 77... ..w
    EQUB &AC, 8  , &18, &65, &76, &8D, &81, &62, &B9, 1  , &0A        ; 45E8: AC 08 18... ...
    EQUS "ew(i"                                                       ; 45F3: 65 77 28... ew(
    EQUB 0  , &28, &69, 0  , &8D, &84, &62, &A5, &63, &85, &75, &A9   ; 45F7: 00 28 69... .(i
    EQUB &21, &20, 0  , &0C, 6  , &75, &18, &65, &75, &9D, &50, 1     ; 4603: 21 20 00... ! .
    EQUB &60, &85, &75, &B9, 0                                        ; 460F: 60 85 75... `.u
    EQUS "UE%"                                                        ; 4614: 55 45 25    UE%
    EQUB 8  , &B9, 0                                                  ; 4617: 08 B9 00    ...
    EQUS "U P4 "                                                      ; 461A: 55 20 50... U P
    EQUB 0  , &0C                                                     ; 461F: 00 0C       ..
    EQUS "( P4`"                                                      ; 4621: 28 20 50... ( P
    EQUB &A5, &5E, &38, &E5                                           ; 4626: A5 5E 38... .^8
    EQUS "D P4"                                                       ; 462A: 44 20 50... D P
    EQUB &C9                                                          ; 462E: C9          .
    EQUS "@fC"                                                        ; 462F: 40 66 43    @fC
    EQUB &10, 5  , &49, &7F, &18, &69, 1  , &48, &A0, &BA             ; 4632: 10 05 49... ..I
    EQUS " vF"                                                        ; 463C: 20 76 46     vF
    EQUB &A6, &5C, &E0, &28, &90, 2  , &49, &FF, &A6                  ; 463F: A6 5C E0... .\.
    EQUS "o$% P4H"                                                    ; 4648: 6F 24 25... o$%
    EQUB &FD, &78, 1  , &B0, 2  , &49, &FF, &C9, &16, &20, &A8, &1F   ; 464F: FD 78 01... .x.
    EQUB &68, &9D, &78, 1  , &68, &49, &FF, &18, &69, &41, &A0, &88   ; 465B: 68 9D 78... h.x
    EQUS " vF"                                                        ; 4667: 20 76 46     vF
    EQUB &0A, &0A                                                     ; 466A: 0A 0A       ..
    EQUS "$C0"                                                        ; 466C: 24 43 30    $C0
    EQUB 2  , &49, &FF, &9D, &64, 1  , &60, &20, &87, &46, &85, &75   ; 466F: 02 49 FF... .I.
    EQUB &98, &20, 0  , &0C, &85, &75, &A5, &10, &20, 0  , &0C, &60   ; 467B: 98 20 00... . .
    EQUB &C9, &1A, &90, &0E, &C9, &2E, &90, 4  , &18, &69, &BE, &60   ; 4687: C9 1A 90... ...
    EQUB &0A, &0A, &18                                                ; 4693: 0A 0A 18    ...
    EQUS "i4`"                                                        ; 4696: 69 34 60    i4`
    EQUB &85, &74, &0A, &18, &65, &74, &0A, &60, &A5, &0B, &A6, &0A   ; 4699: 85 74 0A... .t.
    EQUB &20, 1  , &0D, &20, &B9, &48, &AD, &D8, &62, &85, &38, &AD   ; 46A5: 20 01 0D...  ..
    EQUB &E8, &62, &85, &39, &AD, &D9, &62, &85, &74, &AD, &E9        ; 46B1: E8 62 85... .b.
    EQUS "b @"                                                        ; 46BC: 62 20 40    b @
    EQUB &0E, &85, &63, &A5, &74, &85, &2E, &A4, &63, &D0, 3  , &29   ; 46BF: 0E 85 63... ..c
    EQUB &F0, &A8, &84, 0                                             ; 46CB: F0 A8 84... ...
    EQUS " )G "                                                       ; 46CF: 20 29 47...  )G
    EQUB &CF, &4B, &20, &CE, &49, &A2, 1                              ; 46D3: CF 4B 20... .K
    EQUS " yG"                                                        ; 46DA: 20 79 47     yG
    EQUB &A5, &38, &8D, &D8, &62, &A5, &39, &8D, &E8, &62, &AD, &D8   ; 46DD: A5 38 8D... .8.
    EQUB &62, &18, &65, &3A, &8D, &D8, &62, &AD, &E8                  ; 46E9: 62 18 65... b.e
    EQUS "be;"                                                        ; 46F2: 62 65 3B    be;
    EQUB &8D, &E8, &62, &20, &A5, &47, &A2, 0                         ; 46F5: 8D E8 62... ..b
    EQUS " yG "                                                       ; 46FD: 20 79 47...  yG
    EQUB &C5, &47, &20, &F9, &47, &A5, &2D, &C9, 2  , &90, &0D, &A2   ; 4701: C5 47 20... .G
    EQUB 2  , &A9, 0  , &9D, &D5, &62, &9D, &E5, &62, &CA, &10, &F7   ; 470D: 02 A9 00... ...
    EQUS " eL "                                                       ; 4719: 20 65 4C...  eL
    EQUB &C1                                                          ; 471D: C1          .
    EQUS "H 7I "                                                      ; 471E: 48 20 37... H 7
    EQUB &EF, &48, &20, &EA, &44, &60, &AD, &D2, &62, &85, &74, &A0   ; 4723: EF 48 20... .H
    EQUB &58, &AD, &E2                                                ; 472F: 58 AD E2    X..
    EQUS "b SG"                                                       ; 4732: 62 20 53... b S
    EQUB &85, &75, &AD, &D8, &62, &38, &E5, &74, &8D, &D8, &62, &AD   ; 4736: 85 75 AD... .u.
    EQUB &E8, &62, &E5, &75, &8D, &E8                                 ; 4742: E8 62 E5... .b.
    EQUS "b eG"                                                       ; 4748: 62 20 65... b e
    EQUB &85, &3B, &A5, &74, &85, &3A, &60, 8  , &20, &40, &0E, &85   ; 474C: 85 3B A5... .;.
    EQUB &76, &84, &75, &20, &BF, &0D, &A5                            ; 4758: 76 84 75... v.u
    EQUS "u( @"                                                       ; 475F: 75 28 20... u(
    EQUB &0E, &60, &A5, &75, &18, &10, 1                              ; 4763: 0E 60 A5... .`.
    EQUS "8jH"                                                        ; 476A: 38 6A 48    8jH
    EQUB &A5, &74, &6A, &18, &65, &74, &85                            ; 476D: A5 74 6A... .tj
    EQUS "theu`"                                                      ; 4774: 74 68 65... the
    EQUB &A5, &2D, &C9, 2  , &B0, &10, &20, &91, &4A, &BD, &A6, &62   ; 4779: A5 2D C9... .-.
    EQUB &29, &C0, &D0, &0C, &A5, &6A, &29, 2  , &D0, 5  , &A2, 3     ; 4785: 29 C0 D0... )..
    EQUB &20, &5A, &0E, &60, &20, &F7, &4A, &AD, &C0, &62, &D0, 7     ; 4791: 20 5A 0E...  Z.
    EQUB &A0, 1  , &A9, 3  , &20, &4A, &0B, &60, &A2, 2  , &A0, 9     ; 479D: A0 01 A9... ...
    EQUB &A9, &80, &85, &79, &A9, &0E                                 ; 47A9: A9 80 85... ...
    EQUS " tH"                                                        ; 47AF: 20 74 48     tH
    EQUB &A2, 2  , &A0, 8  , &A9, &40, &85, &79, &A9, 9               ; 47B2: A2 02 A0... ...
    EQUS " tH"                                                        ; 47BC: 20 74 48     tH
    EQUB &A2, 8  , &20, &E5, &47, &60, &A2, 2  , &A0, &0C, &A9, 0     ; 47BF: A2 08 20... ..
    EQUB &85, &79, &A9, &0E                                           ; 47CB: 85 79 A9... .y.
    EQUS " tH"                                                        ; 47CF: 20 74 48     tH
    EQUB &A2, 2  , &A0, &0A, &A9, &C0, &85, &79, &A9, &0C             ; 47D2: A2 02 A0... ...
    EQUS " tH"                                                        ; 47DC: 20 74 48     tH
    EQUB &A2, &0A, &20, &E5, &47, &60, &BD, &D0, &62, &18, &6D, &DE   ; 47DF: A2 0A 20... ..
    EQUB &62, &9D, &D0, &62, &BD, &E0, &62, &6D, &EE, &62, &9D, &E0   ; 47EB: 62 9D D0... b..
    EQUB &62, &60, &A0, &4E, &AD, &DA, &62, &38, &ED, &DB, &62, &85   ; 47F7: 62 60 A0... b`.
    EQUB &74, &AD, &EA, &62, &ED, &EB                                 ; 4803: 74 AD EA... t..
    EQUS "b SG"                                                       ; 4809: 62 20 53... b S
    EQUB &8D, &E5, &62, &A5, &74, &8D, &D5, &62, &A0, 1  , &A2, 3     ; 480D: 8D E5 62... ..b
    EQUB &BD, &EA, &62, &18, &10, 1  , &38, &7E, &EA, &62, &7E, &DA   ; 4819: BD EA 62... ..b
    EQUB &62, &CA, &10, &F0, &88, &10, &EB, &A2, 2  , &A9, 1  , &85   ; 4825: 62 CA 10... b..
    EQUB &78, &BD, &DB, &62, &85, &74, &BD, &EB, &62, &85             ; 4831: 78 BD DB... x..
    EQUS "u eG"                                                       ; 483B: 75 20 65... u e
    EQUB &85, &75, &A5, &74, &18, &7D, &DA, &62, &85, &74, &A0, &CD   ; 483F: 85 75 A5... .u.
    EQUB &A5, &75, &7D, &EA                                           ; 484B: A5 75 7D... .u}
    EQUS "b SG"                                                       ; 484F: 62 20 53... b S
    EQUB 6  , &74, &2A, &A4, &78, &99, &E6, &62, &A5, &74, &99, &D6   ; 4853: 06 74 2A... .t*
    EQUB &62, &C6, &78, &CA, &CA, &10, &CC, &AD, &E7, &62, &8D, &FF   ; 485F: 62 C6 78... b.x
    EQUB &62, &60, &A4, &7F, &85                                      ; 486B: 62 60 A4... b`.
    EQUS "yLvH"                                                       ; 4870: 79 4C 76... yLv
    EQUB &85, &7C, &B9, &D0, &62, &85, &80, &B9, &E0, &62, &85, &81   ; 4874: 85 7C B9... .|.
    EQUB &BD, &A0, &62, &85, &82, &BD, &A3, &62, &85, &83, &20, &D7   ; 4880: BD A0 62... ..b
    EQUB &0D, &85, &75, &A4                                           ; 488C: 0D 85 75... ..u
    EQUS "|$yp"                                                       ; 4890: 7C 24 79... |$y
    EQUB &12, &A5, &74, &99, &D0, &62, &A5, &75, &99, &E0             ; 4894: 12 A5 74... ..t
    EQUS "b`0"                                                        ; 489E: 62 60 30    b`0
    EQUB 5  , &20, &44, &0E, &85, &75, &B9, &D0, &62, &18, &65, &74   ; 48A1: 05 20 44... . D
    EQUB &99, &D0, &62, &B9, &E0                                      ; 48AD: 99 D0 62... ..b
    EQUS "beu"                                                        ; 48B2: 62 65 75    beu
    EQUB &99, &E0, &62, &60, &A0, 0  , &A9, 8  , &A2, &C0, &D0, 6     ; 48B5: 99 E0 62... ..b
    EQUB &A0, 6  , &A9, 3  , &A2, &40, &84, &7F, &85, &7C, &86, &88   ; 48C1: A0 06 A9... ...
    EQUB &A2, 1  , &A9, 0                                             ; 48CD: A2 01 A9... ...
    EQUS " mH"                                                        ; 48D1: 20 6D 48     mH
    EQUB &CA, &E6, &7F, &A5, &88                                      ; 48D4: CA E6 7F... ...
    EQUS " mH"                                                        ; 48D9: 20 6D 48     mH
    EQUB &E8, &E6, &7C, &A9, 0                                        ; 48DC: E8 E6 7C... ..|
    EQUS " mH"                                                        ; 48E1: 20 6D 48     mH
    EQUB &CA, &C6, &7F, &A5, &88, &49, &80                            ; 48E4: CA C6 7F... ...
    EQUS " mH`"                                                       ; 48EB: 20 6D 48...  mH
    EQUB &A2, 1  , &A0, 2  , &A9, 0  , &85, &76, &BD, &D0, &62, &85   ; 48EF: A2 01 A0... ...
    EQUB &74, &BD, &E0, &62, &10, 2  , &C6, &76, 6                    ; 48FB: 74 BD E0... t..
    EQUS "t*&v"                                                       ; 4904: 74 2A 26... t*&
    EQUB &85, &75, &B9, &B1                                           ; 4908: 85 75 B9... .u.
    EQUS "bet"                                                        ; 490C: 62 65 74    bet
    EQUB &99, &B1, &62, &B9, &80                                      ; 490F: 99 B1 62... ..b
    EQUS "beu"                                                        ; 4914: 62 65 75    beu
    EQUB &99, &80, &62, &B9, &83                                      ; 4917: 99 80 62... ..b
    EQUS "bev"                                                        ; 491C: 62 65 76    bev
    EQUB &99, &83, &62, &88, &88, &CA, &10, &CC, &A5, &0A, &18, &6D   ; 491F: 99 83 62... ..b
    EQUB &D2, &62, &85, &0A, &A5, &0B, &6D, &E2, &62, &85, &0B, &60   ; 492B: D2 62 85... .b.
    EQUB &A2, 2  , &A9, 0  , &85, &76, &BD, &D3, &62, &85, &74, &BD   ; 4937: A2 02 A9... ...
    EQUB &E3, &62, &10, 2  , &C6, &76, &A0, 3  , &E0, 2  , &D0, 2     ; 4943: E3 62 10... .b.
    EQUB &A0, 5  , 6                                                  ; 494F: A0 05 06    ...
    EQUS "t*&v"                                                       ; 4952: 74 2A 26... t*&
    EQUB &88, &D0, &F8, &85, &75, &BD, &AE, &62, &18, &65, &74, &9D   ; 4956: 88 D0 F8... ...
    EQUB &AE, &62, &BD, &D0                                           ; 4962: AE 62 BD... .b.
    EQUS "beu"                                                        ; 4966: 62 65 75    beu
    EQUB &9D, &D0, &62, &BD, &E0                                      ; 4969: 9D D0 62... ..b
    EQUS "bev"                                                        ; 496E: 62 65 76    bev
    EQUB &9D, &E0, &62, &CA, &10, &C2, &60, &A2, &DC, &20, &50, &0E   ; 4971: 9D E0 62... ..b
    EQUB &F0, &0D, &A4, &40, &88, &F0, 4  , &A5, &63, &D0, &0B, &A9   ; 497D: F0 0D A4... ...
    EQUB 0  , &F0, &39, &AD, &68, &FE, &25, 9  , &D0, &28, &A2, 7     ; 4989: 00 F0 39... ..9
    EQUB &86, 9  , &A2, &FF, &86, &61, &30, &1E, &85, &59, &A5, &3C   ; 4995: 86 09 A2... ...
    EQUB &A6, &3E, &CA, &D0, &0A, &69, 7  , &C5, &3F, &B0, 4  , &C9   ; 49A1: A6 3E CA... .>.
    EQUB &8C, &90, &15, &C9, &2A, &90, 5  , &38, &E9, &0C, &B0, 2     ; 49AD: 8C 90 15... ...
    EQUB &A9, &28, &85, &74, &AD, &68, &FE, &29, 7  , &18, &65, &74   ; 49B9: A9 28 85... .(.
    EQUB &85, &3C, &85, &5A, &A9, 0  , &4C, &87, &4A, &A5, &61, &F0   ; 49C5: 85 3C 85... .<.
    EQUB &A6, &A5, &2D, &D0, &C9, &A5, &58, &30, &C3, &A4, &40, &88   ; 49D1: A6 A5 2D... ..-
    EQUB &F0, &C0, &A5, &2E, &85, &74, &A5, &63, 6  , &74, &2A, 8     ; 49DD: F0 C0 A5... ...
    EQUB &30, 3  , 6  , &74, &2A, &85, &75, &A6, &40, &BD, 6  , &5A   ; 49E9: 30 03 06... 0..
    EQUB &20, 0  , &0C, 6                                             ; 49F5: 20 00 0C...  ..
    EQUS "t*("                                                        ; 49F9: 74 2A 28    t*(
    EQUB &10, 3  , 6                                                  ; 49FC: 10 03 06    ...
    EQUS "t*$Y"                                                       ; 49FF: 74 2A 24... t*$
    EQUB &10, &32, &A4, &3E, &88, &D0, &1C, &A4, &63, &C0, &16, &B0   ; 4A03: 10 32 A4... .2.
    EQUB &16, &A4, &6D, &10, &0E, &C0, &A0, &D0, &0E, &48, &A5        ; 4A0F: 16 A4 6D... ..m
    EQUS "j)?"                                                        ; 4A1A: 6A 29 3F    j)?
    EQUB &C9, &35, &68, &90, 4  , &C5, &5A, &90, 6  , &A0, 0  , &84   ; 4A1D: C9 35 68... .5h
    EQUB &59, &F0, &0B, &A5, &5A, &C9, &6C, &90, 5  , &38, &E9, 2     ; 4A29: 59 F0 0B... Y..
    EQUB &85, &5A, &85, &3C, &C9, &AA, &90, 2  , &A9, &AA, &C9, 3     ; 4A35: 85 5A 85... .Z.
    EQUB &B0, 5  , &E6, &61, &4C, &C9, &49, &38, &E9, &42, &30, 4     ; 4A41: B0 05 E6... ...
    EQUB &C9, &11, &B0, 7  , &0A, &18, &69, &98, &4C, &7F, &4A, &38   ; 4A4D: C9 11 B0... ...
    EQUB &E9, &11, &C9, 4  , &B0, 7  , &49, &FF, &18, &69, &BB, &B0   ; 4A59: E9 11 C9... ...
    EQUB &19, &38, &E9, 4  , &C9, 5  , &B0, 9  , &0A, &0A, &49, &FF   ; 4A65: 19 38 E9... .8.
    EQUB &18, &69, &B7, &B0, 9  , &38, &E9, 5  , &0A, &49, &FF, &18   ; 4A71: 18 69 B7... .i.
    EQUB &69, &A3, &85, &75, &BD, &0D, &5A, &20, 0  , &0C, &85, &3D   ; 4A7D: 69 A3 85... i..
    EQUB &A5, &3C, &18, &69, &19, &85, &5F, &60, &AD, &D8, &62, &85   ; 4A89: A5 3C 18... .<.
    EQUB &74, &0D, &E8, &62, 8  , &AD, &E8                            ; 4A95: 74 0D E8... t..
    EQUS "b B"                                                        ; 4A9C: 62 20 42    b B
    EQUB &0E, &A0, 5  , 6  , &74, &2A, &88, &D0, &FA, &9D, &EA, &62   ; 4A9F: 0E A0 05... ...
    EQUB &28, &F0, 6  , &4D, &E8, &62, &38, &10, &3F, &A5, &74, &9D   ; 4AAB: 28 F0 06... (..
    EQUB &DA, &62, &20, &88, &4B, &90, &11, &A9, 0  , &8D, &DC, &62   ; 4AB7: DA 62 20... .b
    EQUB &8D, &EC, &62, &AD, &EA                                      ; 4AC3: 8D EC 62... ..b
    EQUS "b P4L"                                                      ; 4AC8: 62 20 50... b P
    EQUB &ED                                                          ; 4ACD: ED          .
    EQUS "J BK"                                                       ; 4ACE: 4A 20 42... J B
    EQUB &BD, &EC                                                     ; 4AD2: BD EC       ..
    EQUS "b P4"                                                       ; 4AD4: 62 20 50... b P
    EQUB &85, &74, &BD, &EA                                           ; 4AD8: 85 74 BD... .t.
    EQUS "b P4"                                                       ; 4ADC: 62 20 50... b P
    EQUB &C5, &74, &90, 5                                             ; 4AE0: C5 74 90... .t.
    EQUS "FtL"                                                        ; 4AE4: 46 74 4C    FtL
    EQUB &EA, &4A, &4A, &18, &65, &74, &DD, &AA, &62, &D0, 1  , &18   ; 4AE7: EA 4A 4A... .JJ
    EQUB &7E, &A6, &62, &60, &A9, 0  , &9D, &EC, &62, &9D, &DC, &62   ; 4AF3: 7E A6 62... ~.b
    EQUB &A0, 8                                                       ; 4AFF: A0 08       ..
    EQUS " aK"                                                        ; 4B01: 20 61 4B     aK
    EQUB &AD, &E8, &62, &49, &80, &85, &79, &A9, 0  , &85, &74, &BD   ; 4B04: AD E8 62... ..b
    EQUB &AC, &62, &86                                                ; 4B10: AC 62 86    .b.
    EQUS "x GK "                                                      ; 4B13: 78 20 47... x G
    EQUB &88, &4B, &B0, &25, &DD, &AC, &62, &90, &1D, &A9, 0  , &85   ; 4B18: 88 4B B0... .K.
    EQUB &74, &BD, &AC                                                ; 4B24: 74 BD AC    t..
    EQUS "b BK"                                                       ; 4B27: 62 20 42... b B
    EQUB &A4, &3E, &88, &D0, &11, &E0, 0  , &F0, &0D, &A9, 0  , &9D   ; 4B2B: A4 3E 88... .>.
    EQUB &EA, &62, &9D, &DA, &62, &F0, 3                              ; 4B37: EA 62 9D... .b.
    EQUS " BK`"                                                       ; 4B3E: 20 42 4B...  BK
    EQUB &A4, &3E, &88, &F0, &0A, &C5, &8F, &90, 6  , &A5, &8E, &85   ; 4B42: A4 3E 88... .>.
    EQUB &74, &A5, &8F                                                ; 4B4E: 74 A5 8F    t..
    EQUS "$y @"                                                       ; 4B51: 24 79 20... $y
    EQUB &0E, &A4, &78, &99, &EA, &62, &A5, &74, &99, &DA, &62, &60   ; 4B55: 0E A4 78... ..x
    EQUB &B9, &D0, &62, &85, &8E, &B9, &E0, &62, &10, &0C, &A9, 0     ; 4B61: B9 D0 62... ..b
    EQUB &38, &E5, &8E, &85, &8E, &A9, 0  , &F9, &E0, &62, &A0, 5     ; 4B6D: 38 E5 8E... 8..
    EQUB 6  , &8E, &2A, &30, 6  , &88, &D0, &F8, &85, &8F, &60, &A9   ; 4B79: 06 8E 2A... ..*
    EQUB &7F, &D0, &F9, &8A, &18, &69, 2  , &85, &78, &A4, &3E, &88   ; 4B85: 7F D0 F9... ...
    EQUB &F0, &1C, &A0, 9                                             ; 4B91: F0 1C A0... ...
    EQUS " aK"                                                        ; 4B95: 20 61 4B     aK
    EQUB &AD, &E9, &62, &49, &80, &85, &79, &BD, &AA, &62, &E0, 1     ; 4B98: AD E9 62... ..b
    EQUB &F0, &16, &4A, &18, &7D, &AA                                 ; 4BA4: F0 16 4A... ..J
    EQUS "bJL"                                                        ; 4BAA: 62 4A 4C    bJL
    EQUB &BC, &4B, &E0, 1  , &D0, &1A, &A5, &40, &38, &E9, 1  , &85   ; 4BAD: BC 4B E0... .K.
    EQUB &79, &A5, &3D, &85, &75, &A5, &3F, &20, 0  , &0C, &A4, &3E   ; 4BB9: 79 A5 3D... y.=
    EQUB &88, &D0, 3                                                  ; 4BC5: 88 D0 03    ...
    EQUS "Jft"                                                        ; 4BC8: 4A 66 74    Jft
    EQUB &18                                                          ; 4BCB: 18          .
    EQUS "`8`"                                                        ; 4BCC: 60 38 60    `8`
    EQUB &A9, 0  , &A4, &3E, &D0, &0C, &AD, &FF, &62, 8               ; 4BCF: A9 00 A4... ...
    EQUS "JJJ("                                                       ; 4BD9: 4A 4A 4A... JJJ
    EQUB &10, 2  , 9  , &E0, &85, &79, &49, &FF, &18, &69, 1  , &85   ; 4BDD: 10 02 09... ...
    EQUB &78, &A5, &63, &85, &75, &A2, 0  , &AD                       ; 4BE9: 78 A5 63... x.c
    EQUS "=q-"                                                        ; 4BF1: 3D 71 2D    =q-
    EQUB 5  , &72, &85, &77, &AD, &3D, &71, &C9, &FF, &F0, 7  , &AD   ; 4BF4: 05 72 85... .r.
    EQUB 5  , &72, &C9, &FF, &D0, &1E, &AD, &68, &FE, &20, 0  , &0C   ; 4C00: 05 72 C9... .r.
    EQUB &29, 7  , &AA, &D0, 1  , &E8, &A5, &5D, &D0, &0E, &A5, &5D   ; 4C0C: 29 07 AA... )..
    EQUB 5  , &2D, &D0, 8  , &2C, &FB, &62, &10, 3  , &20, &C9, &4D   ; 4C18: 05 2D D0... .-.
    EQUB &86, &5D, &A2, 1  , &A5, &63, &C9, &35, &90, 2  , &A9, &35   ; 4C24: 86 5D A2... .].
    EQUB &85, &75, &BD, &A8, &62, &20, 0  , &0C, &2C, &E9             ; 4C30: 85 75 BD... .u.
    EQUS "b P4"                                                       ; 4C3A: 62 20 50... b P
    EQUB &18                                                          ; 4C3E: 18          .
    EQUS "}aL"                                                        ; 4C3F: 7D 61 4C    }aL
    EQUB &A0, &F3, &84, &75, &A4, &77, &C0, &FF, &D0, 5  , &BD, &63   ; 4C42: A0 F3 84... ...
    EQUB &4C, &A0, &FF, &18, &75, &78, &9D, &AA, &62, &20, 0  , &0C   ; 4C4E: 4C A0 FF... L..
    EQUB &9D, &AC, &62, &CA, &10, &C8                                 ; 4C5A: 9D AC 62... ..b
    EQUS "`55"                                                        ; 4C60: 60 35 35    `55
    EQUB &19, &1A, &A5                                                ; 4C63: 19 1A A5    ...
    EQUS "9 P4"                                                       ; 4C66: 39 20 50... 9 P
    EQUB &85, &75, &C5, &63, &B0, 2  , &A5, &63, &A4, &5D, &F0, 1     ; 4C6A: 85 75 C5... .u.
    EQUB &0A, &85, &77, &20, 0  , &0C, &85, &75, &A0, 6  , &A5, &39   ; 4C76: 0A 85 77... ..w
    EQUB &20, &A0, &48, &A5, &63, &85, &75, &AD, &F1, &62, &20, 0     ; 4C82: 20 A0 48...  .H
    EQUB &0C, &18, &69, 8  , &85, &76, &A5, &77, &85, &75, &20, &BF   ; 4C8E: 0C 18 69... ..i
    EQUB &0D, &A0, 7  , &AD, &E9, &62, &20, &A0, &48, &60, &A6, &6F   ; 4C9A: 0D A0 07... ...
    EQUB &BC, &E8, 6  , &B9, 0                                        ; 4CA6: BC E8 06... ...
    EQUS "SJJJJ"                                                      ; 4CAB: 53 4A 4A... SJJ
    EQUB &85, &45, &CD, &F9, &62, &D0, 4  , &69, 0  , &29, &0F, &AA   ; 4CB0: 85 45 CD... .E.
    EQUB &A0, 2  , &84, &77, &BD, &E0                                 ; 4CBC: A0 02 84... ...
    EQUS "S !M"                                                       ; 4CC2: 53 20 21... S !
    EQUB &A0, 4  , &BD, &F0                                           ; 4CC6: A0 04 BD... ...
    EQUS "S !M"                                                       ; 4CCA: 53 20 21... S !
    EQUB &A0, 2  , &BD, &D0                                           ; 4CCE: A0 02 BD... ...
    EQUS "S !M"                                                       ; 4CD2: 53 20 21... S !
    EQUB &BD, &EA, &59, &29, 7  , &18, &69, 7  , &85, &37, &BD, &EA   ; 4CD6: BD EA 59... ..Y
    EQUB &59, &29, &F8, &A8, &A2, &FD, &20, 8  , &12, &A0, 6          ; 4CE2: 59 29 F8... Y).
    EQUS " G!"                                                        ; 4CED: 20 47 21     G!
    EQUB &A5, &8A, &8D, &97, 3  , &A5, &8B, &8D, &AF, 3  , &38, &E5   ; 4CF0: A5 8A 8D... ...
    EQUB &0B                                                          ; 4CFC: 0B          .
    EQUS " P4"                                                        ; 4CFD: 20 50 34     P4
    EQUB &C9, &40, &90, 5  , &A4, &45, &8C, &F9, &62, &A0, &25, &C9   ; 4D00: C9 40 90... .@.
    EQUB &6E, &90, 2  , &A0, &50, &A9, &17, &85, &42, &20, &B3, &2A   ; 4D0C: 6E 90 02... n..
    EQUB &A0, 6  , &20, &87                                           ; 4D18: A0 06 20... ..
    EQUS '"', " v*`H"                                                 ; 4D1C: 22 20 76... " v
    EQUB &A9, 0  , &85, &74, &85, &76, &68, &10, 2  , &C6             ; 4D22: A9 00 85... ...
    EQUS "vFvjft"                                                     ; 4D2C: 76 46 76... vFv
    EQUB &88, &D0, &F8, &85, &75, &A4, &77, &C6, &77, &B9, &80, &62   ; 4D32: 88 D0 F8... ...
    EQUB &38, &E5, &74, &99, &86, &62, &B9, &83, &62, &E5, &75, &99   ; 4D3E: 38 E5 74... 8.t
    EQUB &89, &62, &60, &86, &4A, &8E                                 ; 4D4A: 89 62 60... .b`
    EQUS ":_ "                                                        ; 4D50: 3A 5F 20    :_
    EQUB &C6, &44, &8A, &9D, &3C, 1  , &4A, &EA, &9D, &A0, 4          ; 4D53: C6 44 8A... .D.
    EQUS " ]c"                                                        ; 4D5E: 20 5D 63     ]c
    EQUB &A9, 0  , &9D, &64, &38, &9D, &E4, &39, &9D, &F0, 4  , &8A   ; 4D61: A9 00 9D... ...
    EQUB &D0, &E6, &60, &A9, &21, &D0, 2  , &A9, &18, &8D, &CD, &62   ; 4D6D: D0 E6 60... ..`
    EQUB &A9, 1  , &8D, &CC, &62, &A0, 0  , &BD, &50, &3B, &85, &73   ; 4D79: A9 01 8D... ...
    EQUB &BD, &D0, &3A, &85, &72, &B1, &72, &C9, &FF, &F0, &38, &C9   ; 4D85: BD D0 3A... ..:
    EQUB &C8, &90, &22, &38, &E9, &C8, &85, &74, &8A, &48, &98, &48   ; 4D91: C8 90 22... .."
    EQUB &A6, &74, &E0, &36, &D0, 8  , &A2, 0  , &20, &D0, &41, &4C   ; 4D9D: A6 74 E0... .t.
    EQUB &AE                                                          ; 4DA9: AE          .
    EQUS "M ~Mh"                                                      ; 4DAA: 4D 20 7E... M ~
    EQUB &A8, &68, &AA, &C8, &4C, &80, &4D, &C9, &A0, &90, 7  , &E9   ; 4DAF: A8 68 AA... .h.
    EQUB &A0                                                          ; 4DBB: A0          .
    EQUS " P="                                                        ; 4DBC: 20 50 3D     P=
    EQUB &F0, 3  , &20, &92, &50, &C8, &4C, &8A, &4D, &60, &A5, &63   ; 4DBF: F0 03 20... ..
    EQUB &4A, &85, &26, &4A, &85, &28, &E6                            ; 4DCB: 4A 85 26... J.&
    EQUS "-8n"                                                        ; 4DD2: 2D 38 6E    -8n
    EQUB &D2, &62, &A9, 4  , &20, &47, &0B, &60, &78, &A2, &0D, &8E   ; 4DD5: D2 62 A9... .b.
    EQUB 0  , &FE, &BD, &0F, &4F, &8D, 1  , &FE, &CA, &10, &F4, &CA   ; 4DE1: 00 FE BD... ...
    EQUB &8E                                                          ; 4DED: 8E          .
    EQUS "COX"                                                        ; 4DEE: 43 4F 58    COX
    EQUB &A9, &9A, &A2, &C4, &20, &F4, &FF, &18, &A9, 7  , &8D, &21   ; 4DF1: A9 9A A2... ...
    EQUB &FE, &69, &10, &90, &F9, &78, &AD, 4  , 2  , &8D, &1D, &4F   ; 4DFD: FE 69 10... .i.
    EQUB &AD, 5  , 2  , &8D, &1E, &4F, &A9, 2  , &2C, &4D, &FE, &F0   ; 4E09: AD 05 02... ...
    EQUB &FB, &A9, &40, &8D, &6B, &FE, &0D, &4B, &FE, &8D, &4B, &FE   ; 4E15: FB A9 40... ..@
    EQUB &A9, &C0, &8D, &6E, &FE, &8D, &4E, &FE, &A9, &D4, &8D, &64   ; 4E21: A9 C0 8D... ...
    EQUB &FE, &A9, &11, &8D, &65, &FE, &A9, 1  , &8D, &46, &FE, &A9   ; 4E2D: FE A9 11... ...
    EQUB &3D, &8D, &45, &FE, &A9, &1E, &8D, &46, &FE, &8D, &66, &FE   ; 4E39: 3D 8D 45... =.E
    EQUB &A9, &4E, &8D, &47, &FE, &8D, &67, &FE, &A9, &4E, &8D, 5     ; 4E45: A9 4E 8D... .N.
    EQUB 2  , &A9, &5C, &8D, 4  , 2                                   ; 4E51: 02 A9 5C... ..\
    EQUS "X`l"                                                        ; 4E57: 58 60 6C    X`l
    EQUB &1D, &4F, &AD, &6D, &FE, &29, &40, &F0, &F6, &8D, &6D, &FE   ; 4E5A: 1D 4F AD... .O.
    EQUB &8A, &48, &D8, &AD, &43, &4F, &F0, &0E, &30, &22, &C9, 2     ; 4E66: 8A 48 D8... .H.
    EQUB &90, &27, &F0, &4D, &C9, 3  , &F0, &5C, &B0, &6B, &A9, &88   ; 4E72: 90 27 F0... .'.
    EQUB &8D, &20, &FE, &A2, &0F, &BD, &68, &34, &8D, &21, &FE, &CA   ; 4E7E: 8D 20 FE... . .
    EQUB &10, &F7, &A9, &C4, &A2, &0F, &D0, &6F, &C9, &FF, &D0, &74   ; 4E8A: 10 F7 A9... ...
    EQUB &EE, &43, &4F, &F0, &F1, &A9, &C4, &8D, &20, &FE, &18, &A9   ; 4E96: EE 43 4F... .CO
    EQUB 3  , &8D, &21, &FE, &69, &10, &90, &F9, &A9, &3C, &38, &ED   ; 4EA2: 03 8D 21... ..!
    EQUB &1F, &4F, &8D, &21, &4F, &A9, &15, &ED, &20, &4F, &8D, &22   ; 4EAE: 1F 4F 8D... .O.
    EQUB &4F, &AD, &1F, &4F, &AE, &20, &4F, &B0, &3E, &A2, &0F, &BD   ; 4EBA: 4F AD 1F... O..
    EQUB &58, &34, &8D, &21, &FE, &CA, &10, &F7, &AD, &21, &4F, &AE   ; 4EC6: 58 34 8D... X4.
    EQUB &22, &4F, &D0, &2B, &A2, 3  , &BD, &78, &34, &8D, &21, &FE   ; 4ED2: 22 4F D0... "O.
    EQUB &CA, &10, &F7, &A9, 0  , &A2, &1E, &D0, &1A, &A2, 3  , &BD   ; 4EDE: CA 10 F7... ...
    EQUB &7C, &34, &8D, &21, &FE, &CA, &10, &F7, &8E                  ; 4EEA: 7C 34 8D... |4.
    EQUS "CO "                                                        ; 4EF3: 43 4F 20    CO
    EQUB &A4, &52, &A9, &FF, &8D, &69, &FE, &A9, &16, &A2, &0B, &8E   ; 4EF6: A4 52 A9... .R.
    EQUB &67, &FE, &8D, &66, &FE, &EE                                 ; 4F02: 67 FE 8D... g..
    EQUS "COh"                                                        ; 4F08: 43 4F 68    COh
    EQUB &AA, &A5, &FC                                                ; 4F0B: AA A5 FC    ...
    EQUS "@?(1$&"                                                     ; 4F0E: 40 3F 28... @?(
    EQUB 0  , &1A, &20, 1  , 7  , &67, 8  , &0B, &50, 0  , 0  , &D8   ; 4F14: 00 1A 20... ..
    EQUB 4  , &64, &10, &78, &AD, &1D, &4F, &8D, 4  , 2  , &AD, &1E   ; 4F20: 04 64 10... .d.
    EQUB &4F, &8D, 5  , 2  , &A9, &40, &8D, &6E, &FE, &58, &20, &F6   ; 4F2C: 4F 8D 05... O..
    EQUB &43, &A9, &80, &85, &64, &A2                                 ; 4F38: 43 A9 80... C..
    EQUS ". ~M`"                                                      ; 4F3E: 2E 20 7E... . ~
    EQUB 0  , &A9, &3C, &38, &E5, &1F, &10, 9  , &C9, &F5, &B0, &0C   ; 4F43: 00 A9 3C... ..<
    EQUB &A9, &F5, &38, &B0, 7  , &C9, &12, &90, 3  , &A9, &12, &18   ; 4F4F: A9 F5 38... ..8
    EQUB 8  , &85, &75, &A9, 0                                        ; 4F5B: 08 85 75... ..u
    EQUS "fuj(fujx"                                                   ; 4F60: 66 75 6A... fuj
    EQUB &18, &69, &D8, &8D, &1F, &4F, &A9, 4  , &65, &75, &8D        ; 4F68: 18 69 D8... .i.
    EQUS " OX`,"                                                      ; 4F73: 20 4F 58...  OX
    EQUB &F8, &62, &30, &14, &E0, &14, &B0, &10, &BD, &8C, 1  , &0A   ; 4F78: F8 62 30... .b0
    EQUB &30, &0A, &E4, &6F, &D0, &0B, &C6, &30, &F0, 3  , &E6, &30   ; 4F84: 30 0A E4... 0..
    EQUB &60, &A9, &80, &85, &66, &BD, &B4, 4  , &30, 3  , &FE, &B4   ; 4F90: 60 A9 80... `..
    EQUB 4  , &24, &6C, &10, 7  , &C5, &6E, &90, &12, &F0, 8  , &60   ; 4F9C: 04 24 6C... .$l
    EQUB &E4, &6F, &F0, &0B, &90, 9  , &60, &E4, &6F, &D0, 4  , &A9   ; 4FA8: E4 6F F0... .o.
    EQUB &50, &85, &0F, &F8, &38, &AD, &B4, 6  , &FD, &98, 8  , &85   ; 4FB4: 50 85 0F... P..
    EQUB &74, &AD, &CC, 6  , &FD, &AC, 8  , &B0, 3  , &69, &60, &18   ; 4FC0: 74 AD CC... t..
    EQUB &85, &75, &AD, &E4, 6  , &FD, &DC, 4  , &85, &79, &90, &23   ; 4FCC: 85 75 AD... .u.
    EQUB &38, &A5, &74, &FD, &A0, 6  , &A5, &75, &FD, &B8, 6  , &A5   ; 4FD8: 38 A5 74... 8.t
    EQUB &79, &FD, &D0, 6  , &B0, &11, &A5, &74, &29, &F0, &9D, &A0   ; 4FE4: 79 FD D0... y..
    EQUB 6  , &A5, &75, &9D, &B8, 6  , &A5, &79, &9D, &D0, 6  , &AD   ; 4FF0: 06 A5 75... ..u
    EQUB &B4, 6  , &9D, &98, 8  , &AD, &CC, 6  , &9D, &AC, 8  , &AD   ; 4FFC: B4 06 9D... ...
    EQUB &E4, 6  , &9D, &DC, 4  , &D8, &60, &EA, &EA, &A9, 0  , &9D   ; 5008: E4 06 9D... ...
    EQUB &B4, 6  , &9D, &CC, 6  , &9D, &E4, 6  , &60, &A2, &20, &8E   ; 5014: B4 06 9D... ...
    EQUB &CC, &62, &E8, &8E, &CD, &62, &A6, &6F, &A9, &26, &20, &9C   ; 5020: CC 62 E8... .b.
    EQUB &7B, &A9, &28, &A2, &0A, &8E, &CC, &62, &A2, &21, &8E, &CD   ; 502C: 7B A9 28... {.(
    EQUB &62, &A2, &15, &20, &9C, &7B, &60                            ; 5038: 62 A2 15... b..
; &503F referenced 1 time by &63C6
.sub_C503F
    LDA #osbyte_read_adc_or_get_buffer_status                         ; 503F: A9 80       ..
    JSR osbyte                                                        ; 5041: 20 F4 FF     ..
    TYA                                                               ; 5044: 98          .
    LDX #1                                                            ; 5045: A2 01       ..
    CLC                                                               ; 5047: 18          .
    ADC #&80                                                          ; 5048: 69 80       i.
    BPL C504F                                                         ; 504A: 10 03       ..
    EOR #&FF                                                          ; 504C: 49 FF       I.
    DEX                                                               ; 504E: CA          .
; &504F referenced 1 time by &504A
.C504F
    CMP #&0A                                                          ; 504F: C9 0A       ..
    RTS                                                               ; 5051: 60          `

    EQUB &A6, &46, &D0, 6  , &AE, &19, &5A, &E8, &F0, 3  , &CA, &86   ; 5052: A6 46 D0... .F.
    EQUB &46, &A5, &6D, &30, 5  , &A2, 0  , &20, &C3, &17, &E6, &6A   ; 505E: 46 A5 6D... F.m
    EQUB &D0, 3  , &EE, &DF, &62, &AD, &CC, 6  , &F0, 6  , &A5, &6A   ; 506A: D0 03 EE... ...
    EQUB &29, &1F, &D0, 3                                             ; 5076: 29 1F D0... )..
    EQUS " ]c`"                                                       ; 507A: 20 5D 63...  ]c
    EQUB &CA, &10, 2  , &A2, &13, &60, &E8, &E0, &14, &90, 2  , &A2   ; 507E: CA 10 02... ...
    EQUB 0  , &60                                                     ; 508A: 00 60       .`
; &508C referenced 2 times by &42E1, &42E8
.sub_C508C
    STA L62C3                                                         ; 508C: 8D C3 62    ..b
    JMP C509D                                                         ; 508F: 4C 9D 50    L.P

    EQUS "$d0`"                                                       ; 5092: 24 64 30... $d0
    EQUB &8D, &C3, &62, &A9, 0  , &85, &77                            ; 5096: 8D C3 62... ..b
; &509D referenced 1 time by &508F
.C509D
    TXA                                                               ; 509D: 8A          .
    PHA                                                               ; 509E: 48          H
    TYA                                                               ; 509F: 98          .
    PHA                                                               ; 50A0: 48          H
    LDY #>(L62C3)                                                     ; 50A1: A0 62       .b
    LDX #<(L62C3)                                                     ; 50A3: A2 C3       ..
    LDA #osword_read_char                                             ; 50A5: A9 0A       ..
    JSR osword                                                        ; 50A7: 20 F1 FF     ..
    LDA L0077                                                         ; 50AA: A5 77       .w
    BEQ C50C6                                                         ; 50AC: F0 18       ..
    LDX #8                                                            ; 50AE: A2 08       ..
; &50B0 referenced 1 time by &50C4
.loop_C50B0
    LDA L62C3,X                                                       ; 50B0: BD C3 62    ..b
    BIT L0077                                                         ; 50B3: 24 77       $w
    BMI C50BC                                                         ; 50B5: 30 05       0.
    AND #&F0                                                          ; 50B7: 29 F0       ).
    JMP C50C0                                                         ; 50B9: 4C C0 50    L.P

; &50BC referenced 1 time by &50B5
.C50BC
    ASL A                                                             ; 50BC: 0A          .
    ASL A                                                             ; 50BD: 0A          .
    ASL A                                                             ; 50BE: 0A          .
    ASL A                                                             ; 50BF: 0A          .
; &50C0 referenced 1 time by &50B9
.C50C0
    STA L62C3,X                                                       ; 50C0: 9D C3 62    ..b
    DEX                                                               ; 50C3: CA          .
    BNE loop_C50B0                                                    ; 50C4: D0 EA       ..
; &50C6 referenced 1 time by &50AC
.C50C6
    LDY L62CD                                                         ; 50C6: AC CD 62    ..b
    LDA L62CC                                                         ; 50C9: AD CC 62    ..b
    JSR sub_C50FA                                                     ; 50CC: 20 FA 50     .P
    LDX #8                                                            ; 50CF: A2 08       ..
; &50D1 referenced 1 time by &50E9
.loop_C50D1
    LDA L62C3,X                                                       ; 50D1: BD C3 62    ..b
    STA (P),Y                                                         ; 50D4: 91 70       .p
    DEY                                                               ; 50D6: 88          .
    BPL C50E8                                                         ; 50D7: 10 0F       ..
    LDA P                                                             ; 50D9: A5 70       .p
    SEC                                                               ; 50DB: 38          8
    SBC #&40 ; '@'                                                    ; 50DC: E9 40       .@
    STA P                                                             ; 50DE: 85 70       .p
    LDA Q                                                             ; 50E0: A5 71       .q
    SBC #1                                                            ; 50E2: E9 01       ..
    STA Q                                                             ; 50E4: 85 71       .q
    LDY #7                                                            ; 50E6: A0 07       ..
; &50E8 referenced 1 time by &50D7
.C50E8
    DEX                                                               ; 50E8: CA          .
    BNE loop_C50D1                                                    ; 50E9: D0 E6       ..
    INC L62CC                                                         ; 50EB: EE CC 62    ..b
    PLA                                                               ; 50EE: 68          h
    TAY                                                               ; 50EF: A8          .
    PLA                                                               ; 50F0: 68          h
    TAX                                                               ; 50F1: AA          .
    LDA L62C3                                                         ; 50F2: AD C3 62    ..b
    RTS                                                               ; 50F5: 60          `

    EQUB &20, &EE, &FF, &60                                           ; 50F6: 20 EE FF...  ..
; &50FA referenced 1 time by &50CC
.sub_C50FA
    ASL A                                                             ; 50FA: 0A          .
    ASL A                                                             ; 50FB: 0A          .
    STA P                                                             ; 50FC: 85 70       .p
    LDA #0                                                            ; 50FE: A9 00       ..
    ASL P                                                             ; 5100: 06 70       .p
    ROL A                                                             ; 5102: 2A          *
    STA Q                                                             ; 5103: 85 71       .q
    TYA                                                               ; 5105: 98          .
    LSR A                                                             ; 5106: 4A          J
    LSR A                                                             ; 5107: 4A          J
    LSR A                                                             ; 5108: 4A          J
    TAX                                                               ; 5109: AA          .
    LDA L3FE0,X                                                       ; 510A: BD E0 3F    ..?
    CLC                                                               ; 510D: 18          .
    ADC P                                                             ; 510E: 65 70       ep
    STA P                                                             ; 5110: 85 70       .p
    LDA L3B06,X                                                       ; 5112: BD 06 3B    ..;
    ADC Q                                                             ; 5115: 65 71       eq
    STA Q                                                             ; 5117: 85 71       .q
    TYA                                                               ; 5119: 98          .
    AND #7                                                            ; 511A: 29 07       ).
    TAY                                                               ; 511C: A8          .
    RTS                                                               ; 511D: 60          `

    EQUB &A6, &69, &F0, &17, &CA, &BD, &A8, 7  , &85, &70, &BD, &D0   ; 511E: A6 69 F0... .i.
    EQUB 7  , &85, &71, &BD, &80, 7  , &A0, 0  , &91, &70, &CA, &10   ; 512A: 07 85 71... ..q
    EQUB &EC, &84                                                     ; 5136: EC 84       ..
    EQUS "i` "                                                        ; 5138: 69 60 20    i`
    EQUB &1E, &51, &20, &A8, &51, &AD, &A2, &62, &85, &74, &4A, 8     ; 513B: 1E 51 20... .Q
    EQUB &A9, 2  , &B0, 2  , &A9, 5  , &85, &76, &AD, &A5, &62, 6     ; 5147: A9 02 B0... ...
    EQUB &74, &2A, &B0, 8  , &C9, &26, &90, &15, &C9, &3D, &90, 2     ; 5153: 74 2A B0... t*.
    EQUB &A9, &3C, &49, &FF, &69, &4C, &A8, &84, &74, &BE, &80, &39   ; 515F: A9 3C 49... .<I
    EQUB &86, &83                                                     ; 516B: 86 83       ..
    EQUS "L~Q"                                                        ; 516D: 4C 7E 51    L~Q
    EQUB &AA, &86, &74, &A5, &76, &49, 1  , &85, &76, &BD, &80, &39   ; 5170: AA 86 74... ..t
    EQUB &85, &83, &0A, &18, &69, 4  , &49, &FF, &A8, &8A, &28, &90   ; 517C: 85 83 0A... ...
    EQUB 2  , &49, &FF, &18, &69, &50, &85, &77, &29, &FC, &20, &FC   ; 5188: 02 49 FF... .I.
    EQUB &50, &A5, &77, &0A, &29, 7  , &85, &77, &A9, 4  , &85, &79   ; 5194: 50 A5 77... P.w
    EQUB &A9, 6  , &85, &75, &20, 4  , &52, &60, &A9, 0  , &85, &79   ; 51A0: A9 06 85... ...
    EQUB &A5, &3C, &C9, &1E, &B0, 2  , &A9, &1E, &85, &74, &4A, &18   ; 51AC: A5 3C C9... .<.
    EQUS "etj8"                                                       ; 51B8: 65 74 6A... etj
    EQUB &E9, &4C, &B0, 2  , &69, &98, &A2, &FF, &38, &E8, &E9, &26   ; 51BC: E9 4C B0... .L.
    EQUB &B0, &FB, &69, &26, &C9, &13, &90, 8  , &E9, &13, &49, &FF   ; 51C8: B0 FB 69... ..i
    EQUB &18, &69, &14, &38, &A8, &84, &74, &8A, &29, 3  , &AA, &8A   ; 51D4: 18 69 14... .i.
    EQUB &2A, &85, &76, &29, &FC, &F0, 2  , &A9, 7  , &85, &77, &B9   ; 51E0: 2A 85 76... *.v
    EQUB 0  , &31, &85, &83, &85, &75, &BD, &FC, &32, &29, &F8, &85   ; 51EC: 00 31 85... .1.
    EQUB &70, &BD, &FC, &32, &29, 7  , &A8, &BD, &7C, &39, &85, &71   ; 51F8: 70 BD FC... p..
    EQUB &A6, &76, &BD, &86, &3B, &8D, &20, &52, &BD, &8E, &3B, &8D   ; 5204: A6 76 BD... .v.
    EQUB &9B, &52, &A6, &77, &A9, 0  , &38, &E5, &83, &18, &65, &74   ; 5210: 9B 52 A6... .R.
    EQUB &90, 3  , &E5, &83, &C8, &85, &8A, &8A, &4A, &29, 3  , 5     ; 521C: 90 03 E5... ...
    EQUB &79, &85, &76, &8A, &10, &0F, &A2, 7  , &A5, &70, &38, &E9   ; 5228: 79 85 76... y.v
    EQUB 8  , &85, &70, &B0, &15, &C6, &71, &B0, &11, &C9, 8  , &90   ; 5234: 08 85 70... ..p
    EQUB &0D, &A2, 0  , &A5, &70, &18, &69, 8  , &85, &70, &90, 2     ; 5240: 0D A2 00... ...
    EQUB &E6, &71, &86, &77, &A6, &69, &98, &10, &12, &A5, &70, &38   ; 524C: E6 71 86... .q.
    EQUB &E9, &40, &85, &70, &A5, &71, &E9, 1  , &85, &71, &A0, 7     ; 5258: E9 40 85... .@.
    EQUB &98, &D0, &14, &C9, 8  , &90, &10, &A5, &70, &18, &69, &40   ; 5264: 98 D0 14... ...
    EQUB &85, &70, &A5, &71, &69, 1  , &85, &71, &A0, 0  , &98, 5     ; 5270: 85 70 A5... .p.
    EQUB &70, &9D, &A8, 7  , &A5, &71, &9D, &D0, 7  , &B1, &70, &9D   ; 527C: 70 9D A8... p..
    EQUB &80, 7  , &E6, &69, &A6, &76, &3D, &E8, &3F, &1D, &F8, &34   ; 5288: 80 07 E6... ...
    EQUB &91, &70, &A6, &77, &A5, &8A, &18, &E8, &C6, &75, &30, 3     ; 5294: 91 70 A6... .p.
    EQUB &4C, &1A, &52, &60, &EE, &F7, &62, &A5, &63, &18             ; 52A0: 4C 1A 52... L.R
    EQUS "i0m"                                                        ; 52AA: 69 30 6D    i0m
    EQUB &FA, &62, &8D, &FA, &62, &90, &41, &A5, 0  , &F0, &3D, &A2   ; 52AD: FA 62 8D... .b.
    EQUB 4  , &BD, &C0, &6F, &5D, &F6, &52, &9D, &C0, &6F, &BD, &F8   ; 52B9: 04 BD C0... ...
    EQUB &70, &5D, &FB, &52, &9D, &F8, &70, &E0, 3  , &B0, &12, &BD   ; 52C5: 70 5D FB... p].
    EQUB &85, &6E, &49, &F0, &9D, &85, &6E, &BD, &BD, &6F, &49, &F0   ; 52D1: 85 6E 49... .nI
    EQUB &9D, &BD, &6F, &D0, &10, &BD, &8A, &6E, &49, &C0, &9D, &8A   ; 52DD: 9D BD 6F... ..o
    EQUB &6E, &BD, &B2                                                ; 52E9: 6E BD B2    n..
    EQUS "oI0"                                                        ; 52EC: 6F 49 30    oI0
    EQUB &9D, &B2, &6F, &CA, &10, &C5, &60, &F0, &F0, &C0, &C0, &80   ; 52EF: 9D B2 6F... ..o
    EQUB &F0, &F0, &30, &30, &10                                      ; 52FB: F0 F0 30... ..0
.trackData

    ORG &70DB
    EQUB 0  , 0  , 0  , &10, &10                                      ; 5300: 00 00 00... ... :70DB[4]
    EQUS " `p"                                                        ; 5305: 20 60 70     `p :70E0[4]
    EQUB &C0, &80, &80, 0  , 0  , 0  , 0  , &C0, &60, &10, &10, 0     ; 5308: C0 80 80... ... :70E3[4]
    EQUB 0  , &30, &10, 0  , 0  , 0  , &80, &80                       ; 5314: 00 30 10... .0. :70EF[4]
    EQUS "@@ "                                                        ; 531C: 40 40 20    @@  :70F7[4]
    EQUB &90, &90                                                     ; 531F: 90 90       ..  :70FA[4]
    EQUS "@@  "                                                       ; 5321: 40 40 20... @@  :70FC[4]
    EQUB 0  , &80, &80, &80, 0  , 8  , &0F, &0F                       ; 5325: 00 80 80... ... :7100[4]
    EQUS " `@@"                                                       ; 532D: 20 60 40...  `@ :7108[4]
    EQUB &80, &80, &80, &0C, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 5331: 80 80 80... ... :710C[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , &80                  ; 533D: 00 00 00... ... :7118[4]
    EQUS "@@@@@  "                                                    ; 5346: 40 40 40... @@@ :7121[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 534D: 00 00 00... ... :7128[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , &10, &30   ; 5359: 00 00 00... ... :7134[4]
    EQUB 0  , 0  , &10, &30, &70, &F0, &F0, &F0, &70, &F0, &F0, &F0   ; 5365: 00 00 10... ... :7140[4]
    EQUB &F0, &E0, &C0, &C0, &F0, &E0, &C0, &80, 1  , 3  , 3  , &16   ; 5371: F0 E0 C0... ... :714C[4]
    EQUB &52, 7  , &2D, &0F, &87, &4B, &0F, &0F, &0F, &0F, &87, &0F   ; 537D: 52 07 2D... R.- :7158[4]
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0B, &0A   ; 5389: 0F 0F 0F... ... :7164[4]
    EQUB &0F, &0E, 7  , 4  , 8  , 0  , &30, 0  , &0A, 0  , &30, 0     ; 5395: 0F 0E 07... ... :7170[4]
    EQUB &F0, 0  , &F0, 0  , &70, 0  , &F0, 0  , &F0, &10, &F0, &30   ; 53A1: F0 00 F0... ... :717C[4]
    EQUB &F0, &30, &E1, &43, &86, &86, &0C, &0C, &87, &0C, 8  , 0     ; 53AD: F0 30 E1... .0. :7188[4]
    EQUB 0  , 0  , &80, 0  , 0  , 0  , &10, &80, 0  , 1  , 1  , 1     ; 53B9: 00 00 80... ... :7194[4]
    EQUB 0  , 0  , &80, &10, 0  , 0  , 0  , &0C, &1E, 3  , 1  , 0     ; 53C5: 00 00 80... ... :71A0[4]
    EQUB 0  , 0  , &10, 0  , &F0, &C0, &78, &2C, &16, &16, 3  , 3     ; 53D1: 00 00 10... ... :71AC[4]
    EQUB &E0, 0  , &F0, 0  , &F0, &80, &F0, &C0, 5  , 0  , &C0, 0     ; 53DD: E0 00 F0... ... :71B8[4]
    EQUB &F0, 0  , &F0, 0  , &0F, 7  , &0E, 2  , 1  , 0  , &C0, 0     ; 53E9: F0 00 F0... ... :71C4[4]
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0D, 5  , &0F, &0F, &1E, &0F   ; 53F5: 0F 0F 0F... ... :71D0[4]
    EQUB &0F, &0F, &0F, &0F, &A4, &0E, &4B, &0F, &1E, &2D, &0F, &0F   ; 5401: 0F 0F 0F... ... :71DC[4]
    EQUB &F0, &70, &30, &10, 8  , &0C, &0C, &86, &E0, &F0, &F0, &F0   ; 540D: F0 70 30... .p0 :71E8[4]
    EQUB &F0                                                          ; 5419: F0          .   :71F4[4]
    EQUS "p00"                                                        ; 541A: 70 30 30    p00 :71F5[4]
    EQUB 0  , 0  , &80, &C0, &E0, &F0, &F0, &F0, 0  , 0  , 0  , 0     ; 541D: 00 00 80... ... :71F8[4]
    EQUB 0  , 0  , &80, &C0, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 5429: 00 00 80... ... :7204[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , &10                  ; 5435: 00 00 00... ... :7210[4]
    EQUS "     @@"                                                    ; 543E: 20 20 20...     :7219[4]
    EQUB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0               ; 5445: 00 00 00... ... :7220[4]
    EQUS "@`  "                                                       ; 5455: 40 60 20... @`  :7230[4]
    EQUB &10, &10, &10, 3  , 0  , &10, &10, &10, 0  , 1  , &0F, &0F   ; 5459: 10 10 10... ... :7234[4]
    EQUB 1  , &E0, &F0, &F0, &F0, &F0, &F0, &F0, &0F, 3  , &C1, &E0   ; 5465: 01 E0 F0... ... :7240[4]
    EQUB &F0, &F0, &F0, &F0, 0  , &0C, &0E, 7  , &83, &C1, &E1, &E0   ; 5471: F0 F0 F0... ... :724C[4]
    EQUB 0  , 0  , 0  , 0  , &0F, &0F, &0F, &0F                       ; 547D: 00 00 00... ... :7258[4]
    EQUS "     "                                                      ; 5485: 20 20 20...     :7260[4]
    EQUB &0F, &0F, &0F, 0  , 0  , 0  , 0  , 0  , 0  , &0F, &0F, 0     ; 548A: 0F 0F 0F... ... :7265[4]
    EQUB 0  , 0  , &10                                                ; 5496: 00 00 10    ... :7271[4]
    EQUS "0px"                                                        ; 5499: 30 70 78    0px :7274[4]
    EQUB &F0, &70, &70, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &E0   ; 549C: F0 70 70... .pp :7277[4]
    EQUB &E0, &C0, &80, 0  , 0  , &80, 0  , 0  , 1  , 1  , 3  , 3     ; 54A8: E0 C0 80... ... :7283[4]
    EQUB 7  , 7  , &3C, &0F, &4B, &0F, &4B, &87, &0F, &0F, &0F, &0F   ; 54B4: 07 07 3C... ..< :728F[4]
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0C, &0B, &0E, &0C, 4     ; 54C0: 0F 0F 0F... ... :729B[4]
    EQUB &0C, &0E, 8  , &10, 0  , &70, 0  , &F0, 0  , &F0, 0  , &F0   ; 54CC: 0C 0E 08... ... :72A7[4]
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0   ; 54D8: 00 F0 00... ... :72B3[4]
    EQUB 0  , &E1, &21, &C3, &43, &C2, &86, &84, &84, 8  , 0  , &40   ; 54E4: 00 E1 21... ..! :72BF[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 6  , 4  , 6  , 2  , 6  , 0     ; 54F0: 00 00 00... ... :72CB[4]
    EQUB 0  , 1  , 1  , 0  , 0  , 0  , 0  , 0  , 0  , 4  , &0C, 0     ; 54FC: 00 01 01... ... :72D7[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 3  , 1  , 1  , 1  , 1  , 0     ; 5508: 00 00 00... ... :72E3[4]
    EQUB 0  , 1  , 0  , &20, 0  , 0  , 0  , 0  , 0                    ; 5514: 00 01 00... ... :72EF[4]
    EQUS "xH<,4"                                                      ; 551D: 78 48 3C... xH< :72F8[4]
    EQUB &16, &12, &12, &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0   ; 5522: 16 12 12... ... :72FD[4]
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, 0  , 7  , 1  , &80, 0  , &E0   ; 552E: 00 F0 00... ... :7309[4]
    EQUB 0  , &F0, 0  , &0F, &0F, 3  , &0D, 7  , 3  , 2  , 3  , &0F   ; 553A: 00 F0 00... ... :7315[4]
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0E, &C3, &0F, &2D, &0F   ; 5546: 0F 0F 0F... ... :7321[4]
    EQUB &2D, &1E, &0F, &10, 0  , 0  , 8  , 8  , &0C, &0C, &0E, &F0   ; 5552: 2D 1E 0F... -.. :732D[4]
    EQUB &F0                                                          ; 555E: F0          .   :7339[4]
    EQUS "pp0"                                                        ; 555F: 70 70 30    pp0 :733A[4]
    EQUB &10, 0  , 0  , &E0, &E0, &F0, &F0, &F0, &F0, &F0, &F0, 0     ; 5562: 10 00 00... ... :733D[4]
    EQUB 0  , 0  , &80, &C0, &E0, &E1, &F0, 0  , 0  , 0  , 0  , 0     ; 556E: 00 00 80... ... :7349[4]
    EQUB 0  , &0F, &0F                                                ; 557A: 00 0F 0F    ... :7355[4]
    EQUS "@@@@@"                                                      ; 557D: 40 40 40... @@@ :7358[4]
    EQUB &0F, &0F, &0F, 0  , 0  , 0  , 0  , &0F, &0F, &0F, &0F, 0     ; 5582: 0F 0F 0F... ... :735D[4]
    EQUB 3  , 7  , &0E, &1C                                           ; 558E: 03 07 0E... ... :7369[4]
    EQUS "8xp"                                                        ; 5592: 38 78 70    8xp :736D[4]
    EQUB &0F, &0C, &38, &70, &F0, &F0, &F0, &F0, 8  , &70, &F0, &F0   ; 5595: 0F 0C 38... ..8 :7370[4]
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0   ; 55A1: F0 F0 F0... ... :737C[4]
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0   ; 55AD: F0 F0 F0... ... :7388[4]
    EQUB &F0, &F0, &F0, &F0, &0F, 7  , &87, &87, &83, &C3, &C3, &C3   ; 55B9: F0 F0 F0... ... :7394[4]
    EQUB &0F, &0F, &0F, &0F, &0F, &1E, &1E, &3C, &1E                  ; 55C5: 0F 0F 0F... ... :73A0[4]
    EQUS "<<x"                                                        ; 55CE: 3C 3C 78    <<x :73A9[4]
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &E0, &E0, &C0   ; 55D1: F0 F0 F0... ... :73AC[4]
    EQUB &E0, &C0, &80, &80, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 55DD: E0 C0 80... ... :73B8[4]
    EQUB 1  , 1  , 1  , 3  , &25, &16, &0F, &4B, &0F, &C3, &0F, &0F   ; 55E9: 01 01 01... ... :73C4[4]
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0E, &0E, &0D, &0E, &0F, &0C   ; 55F5: 0F 0F 0F... ... :73D0[4]
    EQUB &0E, 8  , &14, 8  , &10, 8  , &70, 0  , &F0, 0  , &F0, 0     ; 5601: 0E 08 14... ... :73DC[4]
    EQUB &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0     ; 560D: F0 00 F0... ... :73E8[4]
    EQUB &F0, 0  , &F0, 0  , &F0, &10, &F0, &10, &F0, &30, &E1, &21   ; 5619: F0 00 F0... ... :73F4[4]
    EQUB &94, &0C, 8  , 8  , 8  , 8  , 8  , 0  , 0  , 4  , 4  , 7     ; 5625: 94 0C 08... ... :7400[4]
    EQUB 2  , 2  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 5631: 02 02 00... ... :740C[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 563D: 00 00 00... ... :7418[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 5649: 00 00 00... ... :7424[4]
    EQUB 0  , 0  , 2  , 5  , 7  , 5  , 2  , 0  , &92, 3  , 1  , 1     ; 5655: 00 00 02... ... :7430[4]
    EQUB 1  , 1  , 1  , 0  , &F0, &80, &F0, &80, &F0, &C0, &78, &48   ; 5661: 01 01 01... ... :743C[4]
    EQUB &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0     ; 566D: F0 00 F0... ... :7448[4]
    EQUB &F0, 0  , &F0, 0  , &80, 1  , &E0, 0  , &F0, 0  , &F0, 0     ; 5679: F0 00 F0... ... :7454[4]
    EQUB &0B, 7  , &0F, 3  , 7  , 1  , &82, 1  , &0F, &0F, &0F, &0F   ; 5685: 0B 07 0F... ... :7460[4]
    EQUB &0F, &0F, 7  , 7  , &4A, &86, &0F, &2D, &0F, &3C, &0F, &0F   ; 5691: 0F 0F 07... ... :746C[4]
    EQUB 0  , 0  , 0  , 0  , 8  , 8  , 8  , &0C, &70, &30, &10, &10   ; 569D: 00 00 00... ... :7478[4]
    EQUB 0  , 0  , 0  , 0  , &F0, &F0, &F0, &F0, &F0                  ; 56A9: 00 00 00... ... :7484[4]
    EQUS "pp0"                                                        ; 56B2: 70 70 30    pp0 :748D[4]
    EQUB &87, &C3, &C3, &E1, &F0, &F0, &F0, &F0, &0F, &0F, &0F, &0F   ; 56B5: 87 C3 C3... ... :7490[4]
    EQUB &0F, &87, &87, &C3, &0F, &0E, &1E, &1E, &1C                  ; 56C1: 0F 87 87... ... :749C[4]
    EQUS "<<<"                                                        ; 56CA: 3C 3C 3C    <<< :74A5[4]
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0   ; 56CD: F0 F0 F0... ... :74A8[4]
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0   ; 56D9: F0 F0 F0... ... :74B4[4]
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0   ; 56E5: F0 F0 F0... ... :74C0[4]
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &E1, &E0, &C0   ; 56F1: F0 F0 F0... ... :74CC[4]
    EQUB &87, &87, &84, &1C                                           ; 56FD: 87 87 84... ... :74D8[4]
    EQUS "80p"                                                        ; 5701: 38 30 70    80p :74DC[4]
    EQUB &F0, &78, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0   ; 5704: F0 78 F0... .x. :74DF[4]
    EQUB &E0, &E0, &C0, &C0, &80, &80, &80, 0  , 0  , 0  , 0  , 0     ; 5710: E0 E0 C0... ... :74EB[4]
    EQUB 0  , 0  , 0  , &22, 0  , 0  , 0  , &22, 0  , &12, &8B, 7     ; 571C: 00 00 00... ... :74F7[4]
    EQUB &AD, &0F, &4B, &0F, &2D, &0F, &0F, &87, &0F, &0F, &0F, &0F   ; 5728: AD 0F 4B... ..K :7503[4]
    EQUB &0F, &0F, &0F, &0E, &0F, 8  , &0E, 8  , &0C, &30, 0  , &70   ; 5734: 0F 0F 0F... ... :750F[4]
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0   ; 5740: 00 F0 00... ... :751B[4]
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0   ; 574C: 00 F0 00... ... :7527[4]
    EQUB 0  , &F0, 0  , &F0, 0  , &E1, &21, &E1, &21, &E1, &21, &E1   ; 5758: 00 F0 00... ... :7533[4]
    EQUB &21, &40, 0  , 0  , 0  , 0  , 1  , &40, &41, 0  , 0  , 0     ; 5764: 21 40 00... !@. :753F[4]
    EQUB 0  , 0  , 8  , 8  , 8  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 5770: 00 00 08... ... :754B[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , &10, &10, 0  , 0  , 0     ; 577C: 00 00 00... ... :7557[4]
    EQUB 0  , 0  , 0  , &80, &80, 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 5788: 00 00 00... ... :7563[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 3  , 2  , 3  , &20, 0  , 0     ; 5794: 00 00 00... ... :756F[4]
    EQUB 0  , 0  , 8                                                  ; 57A0: 00 00 08    ... :757B[4]
    EQUS "((xHxHxHxH"                                                 ; 57A3: 28 28 78... ((x :757E[4]
    EQUB &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0     ; 57AD: F0 00 F0... ... :7588[4]
    EQUB &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0     ; 57B9: F0 00 F0... ... :7594[4]
    EQUB &C0, 0  , &E0, 0  , &F0, 0  , &F0, 0  , &0F, &0F, 7  , &0F   ; 57C5: C0 00 E0... ... :75A0[4]
    EQUB 1  , 7  , 1  , 3  , &0F, &0F, &1E, &0F, &0F, &0F, &0F, &0F   ; 57D1: 01 07 01... ... :75AC[4]
    EQUB &84, &1D, &0E, &5B, &0F, &2D, &0F, &4B, 0  , 0  , &44, 0     ; 57DD: 84 1D 0E... ... :75B8[4]
    EQUB 0  , 0  , &44, 0  , &10, &10, 0  , 0  , 0  , 0  , 0  , 0     ; 57E9: 00 00 44... ..D :75C4[4]
    EQUB &F0, &F0, &F0                                                ; 57F5: F0 F0 F0    ... :75D0[4]
    EQUS "pp00"                                                       ; 57F8: 70 70 30... pp0 :75D3[4]
    EQUB &10, &E1, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &1E, &1E, &12   ; 57FC: 10 E1 F0... ... :75D7[4]
    EQUB &83, &C1, &C0, &E0, &F0, &F0, &F0, &F0, &F0, &F0             ; 5808: 83 C1 C0... ... :75E3[4]
    EQUS "xp0"                                                        ; 5812: 78 70 30    xp0 :75ED[4]
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0   ; 5815: F0 F0 F0... ... :75F0[4]
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &E0, 0  , 0  , 0  , 0     ; 5821: F0 F0 F0... ... :75FC[4]
    EQUB &F0, &E0, &C0, 0  , 0  , 0  , 0  , &10, &80, &10             ; 582D: F0 E0 C0... ... :7608[4]
    EQUS "00p"                                                        ; 5837: 30 30 70    00p :7612[4]
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0   ; 583A: F0 F0 F0... ... :7615[4]
    EQUB &F0, &E0, &E0, &C0, &80, &80, 0  , 0  , 0  , 0  , &22, &88   ; 5846: F0 E0 E0... ... :7621[4]
    EQUB 0  , &11, 0  , 0  , &11, &88, &44, &88, &22, &11, &44, &89   ; 5852: 00 11 00... ... :762D[4]
    EQUB 1  , &89, 3  , 3  , &47, &9A, 7  , &87, &0F, &0F, &C3, &0F   ; 585E: 01 89 03... ... :7639[4]
    EQUB &0F, &0F, &0F, &0F, &0E, &0D, &0F, &0F, &0D, &0E, &0C, &18   ; 586A: 0F 0F 0F... ... :7645[4]
    EQUB 0  , &38, 0  , &70, 0  , &70, 0  , &F0, 0  , &F0, 0  , &F0   ; 5876: 00 38 00... .8. :7651[4]
    EQUB 0  , &F0, &61, &F0, 0  , &F0, 0  , &F0, 0  , &F0, &0F, &F0   ; 5882: 00 F0 61... ..a :765D[4]
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, &3C, &F0, 0  , &F0, 0  , &F0   ; 588E: 00 F0 00... ... :7669[4]
    EQUB 0  , &F0, 0  , &E1, &21, &E1, &21, &E1, &21, &E1, &21, 0     ; 589A: 00 F0 00... ... :7675[4]
    EQUB 1  , 0  , 0  , 0  , &40, 0  , 8  , 8  , 8  , 0  , 0  , 0     ; 58A6: 01 00 00... ... :7681[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 58B2: 00 00 00... ... :768D[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 58BE: 00 00 00... ... :7699[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 1  , 0     ; 58CA: 00 00 00... ... :76A5[4]
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 2  , 8  , 8  , 0  , 0  , 0     ; 58D6: 00 00 00... ... :76B1[4]
    EQUB &20, 0  , 1                                                  ; 58E2: 20 00 01     .. :76BD[4]
    EQUS "xHxHxHxH"                                                   ; 58E5: 78 48 78... xHx :76C0[4]
    EQUB &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0     ; 58ED: F0 00 F0... ... :76C8[4]
    EQUB &F0, 0  , &F0, &C3, &F0, 0  , &F0, 0  , &F0, 0  , &F0, &0F   ; 58F9: F0 00 F0... ... :76D4[4]
    EQUB &F0, 0  , &F0, 0  , &F0, 0  , &F0, &68, &81, 0  , &C1, 0     ; 5905: F0 00 F0... ... :76E0[4]
    EQUB &E0, 0  , &E0, 0  , &0F, 7  , &0B, &0F, &0F, &0B, 7  , 3     ; 5911: E0 00 E0... ... :76EC[4]
    EQUB &1E, &0F, &0F, &3C, &0F, &0F, &0F, &0F, &19, 8  , &19, &0C   ; 591D: 1E 0F 0F... ... :76F8[4]
    EQUB &0C, &2E, &95, &0E, 0  , &88, &11, &22, &11, &44, &88, &22   ; 5929: 0C 2E 95... ... :7704[4]
    EQUB 0  , 0  , 0  , &44, &11, 0  , &88, 0  , &F0, &F0             ; 5935: 00 00 00... ... :7710[4]
    EQUS "pp0"                                                        ; 593F: 70 70 30    pp0 :771A[4]
    EQUB &10, &10, 0  , &F0, &F0, &F0, &F0, &F0                       ; 5942: 10 10 00... ... :771D[4]
    ORG trackData + (L7725 - L70DB)
    COPYBLOCK L70DB, L7725, trackData
    CLEAR L70DB, L7725

    EQUB &F0, &F0, &F0, &10, &80, &C0, &C0, &E0, &F0, &F0, &F0, &F0   ; 594A: F0 F0 F0... ...
    EQUB &70, &30, 0  , 0  , 0  , 0  , &80, &F0, &F0, &F0, &70, 0     ; 5956: 70 30 00... p0.
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , &10, &30, &70, &F0        ; 5962: 00 00 00... ...
    EQUS "00p"                                                        ; 596D: 30 30 70    00p
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0   ; 5970: F0 F0 F0... ...
    EQUB &E0, &F0, &E0, &C0, &C0, &80, &80, 0  , 0  , 0  , 0  , &22   ; 597C: E0 F0 E0... ...
    EQUB &88, &22, &22, 0  , &44, 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 5988: 88 22 22... .""
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 5994: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 59A0: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 59AC: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 59B8: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 59C4: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 59D0: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 59DC: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 59E8: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 59F4: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 5A00: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 5A0C: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 5A18: 00 00 00... ...
    EQUB 0  , &A9, 0  , &9D, &78, &38, &9D, &F8, &39, &85, &75, &BC   ; 5A24: 00 A9 00... ...
    EQUB &3C, 1  , &E0, 6  , &D0, 3  , &AC, &3C, 1  , &AD             ; 5A30: 3C 01 E0... <..
    EQUS "8_8"                                                        ; 5A3A: 38 5F 38    8_8
    EQUB &E9, 1  , &F0, &19, &C4, &6F, &F0, 8  , &CC, &39, &5F, &B0   ; 5A3D: E9 01 F0... ...
    EQUB &10, &0A, &D0, &12, &85, &75, &AD                            ; 5A49: 10 0A D0... ...
    EQUS "8_ "                                                        ; 5A50: 38 5F 20    8_
    EQUB 0  , &0C, &85                                                ; 5A53: 00 0C 85    ...
    EQUS "uLaZ"                                                       ; 5A56: 75 4C 61... uLa
    EQUB &AD, &38, &5F, &D0, 0  , &85, &74, &F8, &BD, &F7, &3D, &18   ; 5A5A: AD 38 5F... .8_
    EQUS "}x8"                                                        ; 5A66: 7D 78 38    }x8
    EQUB &9D, &78, &38, &BD, &F8, &39, &69, 0  , &9D, &F8, &39, &C6   ; 5A69: 9D 78 38... .x8
    EQUB &74, &D0, &EA, &C6, &75, &10, &E6, &20, &98                  ; 5A75: 74 D0 EA... t..
    EQUS "f`@"                                                        ; 5A7E: 66 60 40    f`@
    EQUB &85, &7B, &86, &74, &20, &B3, &0D, &85, &78, &A5, &75, &85   ; 5A81: 85 7B 86... .{.
    EQUB &79, &A2, 1  , &86, &42, &A2, 0                              ; 5A8D: 79 A2 01... y..
    EQUS "${P"                                                        ; 5A94: 24 7B 50    ${P
    EQUB 3  , &E8, &C6, &42, &C9, &7A, &90, 8  , &B0, &2E, &A5, &78   ; 5A97: 03 E8 C6... ...
    EQUB &C9, &F0, &B0, &28, &A9, &AB, &20, 0  , &0C, &20, 0  , &0C   ; 5AA3: C9 F0 B0... ...
    EQUB &85, &76, &20, &BF, &0D, &A5, &78, &38, &E5, &74, &85, &74   ; 5AAF: 85 76 20... .v
    EQUB &A5, &79, &E5, &75, 6  , &74, &2A, &9D, &A3, &62, &A5, &74   ; 5ABB: A5 79 E5... .y.
    EQUB &29, &FE, &9D, &A0, &62, &4C, &7F, &0D, &A9, 0  , &38, &E5   ; 5AC7: 29 FE 9D... )..
    EQUB &78, &85, &74, &A9, &C9, &E5, &79, &85, &75, &85, &76, &20   ; 5AD3: 78 85 74... x.t
    EQUB &BF, &0D, 6                                                  ; 5ADF: BF 0D 06    ...
    EQUS "t&u"                                                        ; 5AE2: 74 26 75    t&u
    EQUB &A9, 0  , &38, &E5, &74, &29, &FE, &9D, &A0, &62, &A9, 0     ; 5AE5: A9 00 38... ..8
    EQUB &E5, &75, &90, 7  , &A9, &FE, &9D, &A0, &62, &A9, &FF, &9D   ; 5AF1: E5 75 90... .u.
    EQUB &A3, &62, &E4, &42, &F0, &14, &A6, &42, &A9, 0  , &38, &E5   ; 5AFD: A3 62 E4... .b.
    EQUB &78, &85, &78, &A9, &C9, &E5, &79, &85, &79, &85, &75, &4C   ; 5B09: 78 85 78... x.x
    EQUB &1B, &0D, &A5, &7B, &10, 8  , &A9, 1  , &0D, &A0, &62, &8D   ; 5B15: 1B 0D A5... ...
    EQUB &A0, &62, &A5, &7B, &0A, &45, &7B, &10, 8  , &A9, 1  , &0D   ; 5B21: A0 62 A5... .b.
    EQUB &A1, &62, &8D, &A1, &62, &60, 6  , &74, &2A, 6  , &74, &2A   ; 5B2D: A1 62 8D... .b.
    EQUB &85, &76, &A9, &C9, &85, &75, &20, 2  , &0C, &85, &77, &A5   ; 5B39: 85 76 A9... .v.
    EQUB &76, &20, 0  , &0C, &85, &75, &A5, &77, &18, &65, &74, &85   ; 5B45: 76 20 00... v .
    EQUB &74, &90, 2  , &E6, &75, &60, &A5, &81, &10, &13, &A9, 0     ; 5B51: 74 90 02... t..
    EQUB &38, &E5, &80, &85, &80, &A9, 0  , &E5, &81, &85, &81, &A5   ; 5B5D: 38 E5 80... 8..
    EQUB &79, &49, &80, &85, &79, &A5, &82, &29, 1  , &F0, 6  , &A5   ; 5B69: 79 49 80... yI.
    EQUB &79, &49, &80, &85, &79, &A5, &81, &85, &75, &A5, &82, &20   ; 5B75: 79 49 80... yI.
    EQUB 0  , &0C, &85, &77, &A5, &74, &18, &69, &80, &85, &76, &90   ; 5B81: 00 0C 85... ...
    EQUB 2  , &E6, &77, &A5, &83, &20, 0  , &0C, &85, &78, &A5, &74   ; 5B8D: 02 E6 77... ..w
    EQUB &18, &65, &77, &85, &77, &90, 2  , &E6, &78, &A5, &80, &85   ; 5B99: 18 65 77... .ew
    EQUB &75, &A5, &83, &20, 0  , &0C, &85, &75, &A5, &74, &18, &65   ; 5BA5: 75 A5 83... u..
    EQUB &76, &A5                                                     ; 5BB1: 76 A5       v.
    EQUS "uew"                                                        ; 5BB3: 75 65 77    uew
    EQUB &85, &74, &90, 2  , &E6, &78, &A5                            ; 5BB6: 85 74 90... .t.
    EQUS "x$y"                                                        ; 5BBD: 78 24 79    x$y
    EQUB &10, &0D, &85, &75, &A9, 0  , &38, &E5, &74, &85, &74, &A9   ; 5BC0: 10 0D 85... ...
    EQUB 0  , &E5, &75, &60, &A9, &81, &A0, &FF, &20, &F4, &FF, &E0   ; 5BCC: 00 E5 75... ..u
    EQUB &FF, &60, &48, &BD, &BD, &62, &F0, &12, &A9, 0  , &9D, &BD   ; 5BD8: FF 60 48... .`H
    EQUB &62, &8A, 9  , 4  , &AA, &A9, &15, &20, &F4, &FF, &8A, &29   ; 5BE4: 62 8A 09... b..
    EQUB &FB, &AA, &68, &60, &AD, &A6, &62, &0D, &A7, &62, &10, &16   ; 5BF0: FB AA 68... ..h
    EQUB &AD, &68, &FE, &C9, &3F, &B0, &0F, &29, 3  , &18, &69, &82   ; 5BFC: AD 68 FE... .h.
    EQUB &8D, &2C, &0B, &A9, 3  , &A0, 1  , &20, &4A, &0B, &A6, &60   ; 5C08: 8D 2C 0B... .,.
    EQUB &E4, &5F, &F0, &48, &90, 3  , &CA, &B0, 1  , &E8, &86, &60   ; 5C14: E4 5F F0... ._.
    EQUB &E0, &1C, &90, &3D, &8A, &38, &E9, &5C, &B0, &0E, &48, &A9   ; 5C20: E0 1C 90... ...
    EQUB 0  , &20, &47, &0B, &68, &18, &69, &BB, &A0, 0  , &F0, 8     ; 5C2C: 00 20 47... . G
    EQUB &A2, 0  , &20, &5A, &0E, &AC, &FE, 5  , &8D, &1C, &0B, &A9   ; 5C38: A2 00 20... ..
    EQUB 1  , &20, &4A, &0B, &AC, &FE, 5  , &F0, &0E, &A5, &60, &38   ; 5C44: 01 20 4A... . J
    EQUB &E9, &40, &B0, 4  , &A0, 0  , &F0, 3  , &8D, &24, &0B, &A9   ; 5C50: E9 40 B0... .@.
    EQUB 2  , &20, &4A, &0B, &60, &20, &F6, &43, &60, &84, &74, &A2   ; 5C5C: 02 20 4A... . J
    EQUB &FF, &20, &50, &0E, &D0, &75, &A4, &74, &84, &74, &BE, &E2   ; 5C68: FF 20 50... . P
    EQUS "= P"                                                        ; 5C74: 3D 20 50    = P
    EQUB &0E, &F0, 7  , &A4, &74, &88, &10, &F1, &30, &10, &A4, &74   ; 5C77: 0E F0 07... ...
    EQUB &B9, &D4, &39, &29, &0F, &AA, &B9, &D4, &39, &29, &F0, &9D   ; 5C83: B9 D4 39... ..9
    EQUB &F4, 5  , &AD, &F7, 5  , &F0, &16, &10, &0D, &20, &F6, &43   ; 5C8F: F4 05 AD... ...
    EQUB &20, &B6, &66, &A2, &A6, &20, &50, &0E, &D0, &F6, &E6, &60   ; 5C9B: 20 B6 66...  .f
    EQUB &A9, 0  , &8D, &F7, 5  , &AC, &FE, 5  , &A5, &6A, &29, 1     ; 5CA7: A9 00 8D... ...
    EQUB &D0, &29, &AD, &F6, 5  , &F0, &29, &10, 7  , &C8, &F0, 9     ; 5CB3: D0 29 AD... .).
    EQUB &30, 7  , &10, &1B, &88, &C0, &F1, &90, &16, &8C, &FE, 5     ; 5CBF: 30 07 10... 0..
    EQUB &98, &49, &FF, &18, &69, 1  , &0A, &0A, &0A, &8D, &44, &0B   ; 5CCB: 98 49 FF... .I.
    EQUB &A9, 0  , &20, &65, &0B, &E6, &60, &A9, 0  , &8D, &F6, 5     ; 5CD7: A9 00 20... ..
    EQUB &60, &85, &78, &F8, &A2, 0  , &86, &76, &8E, 0  , 1  , &E8   ; 5CE3: 60 85 78... `.x
    EQUB &86, &77, &BC, &3C, 1  , &8A, &9D, 0  , 1  , &BD, &3B, 1     ; 5CEF: 86 77 BC... .w.
    EQUB &AA                                                          ; 5CFB: AA          .
    EQUS "8$xp90Q"                                                    ; 5CFC: 38 24 78... 8$x
    EQUB &B9, &A0, 6  , &FD, &A0, 6  , &85, &75, &B9, &B8, 6  , &FD   ; 5D03: B9 A0 06... ...
    EQUB &B8, 6  , &85, &79, &B9, &D0, 6  , &FD, &D0, 6  , &90, &51   ; 5D0F: B8 06 85... ...
    EQUB 5  , &75, 5  , &79, &D0, 9  , &A6, &77, &CA, &BD, 0  , 1     ; 5D1B: 05 75 05... .u.
    EQUB &9D, 1  , 1  , &A6, &77, &E8, &E0, &14, &90, &BE, &A5, &76   ; 5D27: 9D 01 01... ...
    EQUB &D0, &B2, &D8, &20, &A2, &63, &60, &BD, &64, &38, &F9, &64   ; 5D33: D0 B2 D8... ...
    EQUB &38, &85, &75, &BD, &E4, &39, &F9, &E4, &39, &85, &79, &BD   ; 5D3F: 38 85 75... 8.u
    EQUB &F0, 4  , &F9, &F0, 4  , &90, &1A, &B0, &C7, &B9, &98, 8     ; 5D4B: F0 04 F9... ...
    EQUB &FD, &98, 8  , &85, &75, &B9, &AC, 8  , &FD, &AC, 8  , &85   ; 5D57: FD 98 08... ...
    EQUB &79, &B9, &DC, 4  , &FD, &DC, 4  , &B0, &BE, &86, &74, &A6   ; 5D63: 79 B9 DC... y..
    EQUB &77, &98, &9D, &3B, 1  , &A5, &74, &9D, &3C, 1  , &C6, &76   ; 5D6F: 77 98 9D... w..
    EQUB &4C, &AA, &0F, &A5, &6C, &10                                 ; 5D7B: 4C AA 0F... L..
    EQUS "0$f"                                                        ; 5D81: 30 24 66    0$f
    EQUB &10, &24, &A9, 0  , &85, &66, &85, &78, &A6, &6F, &BD, &B4   ; 5D84: 10 24 A9... .$.
    EQUB 4  , &C9, 1  , &49, &FF, &65, &6E, 8  , &20, &C8, &65, &A2   ; 5D90: 04 C9 01... ...
    EQUB &0C, &A0, &21, &20, &D0, &37, &28, &10, 5  , &A2, &35, &20   ; 5D9C: 0C A0 21... ..!
    EQUB &FC, &17, &A5, &0F, &D0, &6C, &20, &84, &1B, &60, &A2, 1     ; 5DA8: FC 17 A5... ...
    EQUB &20, &C3, &17                                                ; 5DB4: 20 C3 17     ..
    EQUS "$fp"                                                        ; 5DB7: 24 66 70    $fp
    EQUB &1B, &10                                                     ; 5DBA: 1B 10       ..
    EQUS "2Ff"                                                        ; 5DBC: 32 46 66    2Ff
    EQUB &A9, &21, &18, &6D, &EF, &62, &8D, &EF, &62, &F0, 5  , &A9   ; 5DBF: A9 21 18... .!.
    EQUS "& /P"                                                       ; 5DCB: 26 20 2F... & /
    EQUB &A2, 1  , &20, &11, &50, &F0, &19, &AD, &EF, &62, &F0, &0F   ; 5DCF: A2 01 20... ..
    EQUB &CE, &EF, &62, &D0, &0F, &20, &1D, &50, &A9, 2               ; 5DDB: CE EF 62... ..b
    EQUS " P="                                                        ; 5DE5: 20 50 3D     P=
    EQUB &F0, 5  , &90, 3                                             ; 5DE8: F0 05 90... ...
    EQUS " -P"                                                        ; 5DEC: 20 2D 50     -P
    EQUB &AD                                                          ; 5DEF: AD          .
    EQUS ";_0&"                                                       ; 5DF0: 3B 5F 30... ;_0
    EQUB &CD, &E4, 6  , &90, &10, &D0, &1F                            ; 5DF4: CD E4 06... ...
    EQUS "$ep"                                                        ; 5DFB: 24 65 70    $ep
    EQUB &1B, &A9, &40, &85, &65, &A2                                 ; 5DFE: 1B A9 40... ..@
    EQUS ") tM`"                                                      ; 5E04: 29 20 74... ) t
    EQUB &A5, &65, &30, &0D, &A9, &C0, &85, &65, &A9, &3C, &85, &0F   ; 5E09: A5 65 30... .e0
    EQUB &A2                                                          ; 5E15: A2          .
    EQUS "* tM`"                                                      ; 5E16: 2A 20 74... * t
    EQUB &85                                                          ; 5E1B: 85          .
    EQUS "v8n"                                                        ; 5E1C: 76 38 6E    v8n
    EQUB &F8, &62, &A2, &13, &20, &7C, &14, &CA, &10, &FA, &AD, &D0   ; 5E1F: F8 62 A2... .b.
    EQUB 8  , &0D, &E8, 8  , &D0, &F0, &A9, &FF, &85, &78, &D0, &18   ; 5E2B: 08 0D E8... ...
    EQUB &A5, &76, &85, &77, &8A, &48, &BD, &3C, 1                    ; 5E37: A5 76 85... .v.
; &5E40 referenced 2 times by &0BA7, &0BAE
.L5E40
    EQUB &AA, &20, &C3, &14, &68, &AA, &C6, &77, &10, &F1, &E8, &E0   ; 5E40: AA 20 C3... . .
    EQUB &14, &90, &E8, &E6, &78, &A6, &78, &E0, &14, &90, &E0, &A2   ; 5E4C: 14 90 E8... ...
    EQUB &17, &20, &7C, &14, &A0, &17, &A6                            ; 5E58: 17 20 7C... . |
    EQUS "o8 "                                                        ; 5E5F: 6F 38 20    o8
    EQUB &AB, &27, &B0, &F1, &C9, &20, &D0, &ED, &A2, &17, &A9, &31   ; 5E62: AB 27 B0... .'.
    EQUB &85, &76, &85, &42, &20, &C3, &14, &C6, &76, &D0, &F9, &E6   ; 5E6E: 85 76 85... .v.
    EQUB &42, &20, &C3, &14, &90, &F9, &A9, &50, &A0, &13, &BE, &3C   ; 5E7A: 42 20 C3... B .
    EQUB 1  , &49, &FF, &9D, &78, 1  , &88, &10, &F5, &A9             ; 5E86: 01 49 FF... .I.
; &5E90 referenced 2 times by &0BB1, &0BB7
.L5E90
    EQUB 0  , &85, &24, &20, &F7, &12, &C6, &42, &D0, &F9, &4E, &F8   ; 5E90: 00 85 24... ..$
    EQUB &62, &60, &A5, &11, &C9, 2  , &90, &3E, &A5                  ; 5E9C: 62 60 A5... b`.
    EQUS "^ P4"                                                       ; 5EA5: 5E 20 50... ^ P
    EQUB &C9, &60, &B0, &0B, &A9, &14, &2C, &E2                       ; 5EA9: C9 60 B0... .`.
    EQUS "b P4L"                                                      ; 5EB1: 62 20 50... b P
    EQUB &0B, &1C, &CE, &F6, &62, &E6, &1F                            ; 5EB6: 0B 1C CE... ...
    EQUS " \= "                                                       ; 5EBD: 20 5C 3D...  \=
    EQUB &F6, &43, &A9, 4  , &20, &47, &0B, &A9, 0  , &A2, &1E, &9D   ; 5EC1: F6 43 A9... .C.
    EQUB &D0, &62, &CA, &10, &FA, &85, &61, &85, &26, &85, &60, &85   ; 5ECD: D0 62 CA... .b.
    EQUB &5F, &A9, &7F, &85, &2D, &A9, &1F                            ; 5ED9: 5F A9 7F... _..
; &5EE0 referenced 1 time by &0BA4
.L5EE0
    EQUB &85, 9  , &60, &A9, 0  , &85, 0  , &85, &6D, &20, &1F, &26   ; 5EE0: 85 09 60... ..`
    EQUB &A6, &6F, &20, &BE, &11                                      ; 5EEC: A6 6F 20... .o
    EQUS " RP"                                                        ; 5EF1: 20 52 50     RP
    EQUB &A0, 0  , &20, &E5, &0E, &AD, &F4, 5                         ; 5EF4: A0 00 20... ..
    EQUS "0, "                                                        ; 5EFC: 30 2C 20    0,
    EQUB &ED, &27, &20, &92, &26, &20, &A2, &63, &A2, &13, &A5, &6C   ; 5EFF: ED 27 20... .'
    EQUB &30, &0C, &E4, &6F, &D0, &19, &AD, &DF, &62, &C9, &0E, &90   ; 5F0B: 30 0C E4... 0..
    EQUB &D9, &60, &BD, &8C, 1  , &29, &40, &D0, 7                    ; 5F17: D9 60 BD... .`.
; &5F20 referenced 2 times by &0BBA, &0BC0
.L5F20
    EQUB &A5, &6E, &DD, &B4, 4  , &B0, &CA, &CA, &10, &EF, &60, &E0   ; 5F20: A5 6E DD... .n.
    EQUB &14, &B0, &1E, &BD, &78, 1  , &29, &7F, 9  , &45, &9D, &14   ; 5F2C: 14 B0 1E... ...
    EQUB 1  , &A9, &91, &9D, 0                                        ; 5F38: 01 A9 91... ...
; &5F3D referenced 2 times by &0B79, &0B96
.L5F3D
    EQUB 1                                                            ; 5F3D: 01          .
; &5F3E referenced 2 times by &0B8F, &0B93
.L5F3E
    EQUB &A5, &6E, &DD, &B4, 4  , &A9, &C0, &9D, &8C, 1  , &90, 3     ; 5F3E: A5 6E DD... .n.
    EQUB &9D, &DC, 4  , &60, &A6, &6F, &86, &45, &86, &42, &A4        ; 5F4A: 9D DC 04... ...
    EQUS '"', " 7)"                                                   ; 5F55: 22 20 37... " 7
    EQUB &A2, 2  , &BD, &FD, 9  , &9D, &80, &62, &BD, &FD, &0A, &9D   ; 5F59: A2 02 BD... ...
    EQUB &83, &62, &CA, &10, &F1, &A5, &22, &18, &69, 3  , &C9, &78   ; 5F65: 83 62 CA... .b.
    EQUB &90, 2  , &A9, 0  , &A8, &A6                                 ; 5F71: 90 02 A9... ...
    EQUS "E 7)"                                                       ; 5F77: 45 20 37... E 7
    EQUB &BD, &80, 3  , &85, &0A, &BD, &98, 3  , &45, &25, &85, &0B   ; 5F7B: BD 80 03... ...
    EQUB &60, &B9, 1  , &59, &9D, 0  , 9  , &B9, 2  , &59, &9D, 1     ; 5F87: 60 B9 01... `..
    EQUB 9  , &B9, 3  , &59, &9D, 2  , 9  , &B9, 1  , &53, &9D, 0     ; 5F93: 09 B9 03... ...
    EQUB &0A, &B9, 2  , &53, &9D, 1  , &0A, &B9, 3  , &53, &9D, 2     ; 5F9F: 0A B9 02... ...
    EQUB &0A, &60, &20, 8  , &12, &B9, 4  , &59, &9D, &78, 9  , &B9   ; 5FAB: 0A 60 20... .`
    EQUB 6  , &59, &9D, &7A, 9  , &B9, 4  , &53, &9D, &78, &0A, &B9   ; 5FB7: 06 59 9D... .Y.
    EQUB 6  , &53, &9D, &7A, &0A, &B9, 5  , &59, &85, 2  , &BD, 1     ; 5FC3: 06 53 9D... .S.
    EQUB 9  , &9D, &79, 9  , &BD, 1  , &0A, &9D, &79, &0A, &60, &A5   ; 5FCF: 09 9D 79... ..y
    EQUB &24, &38, &E9, &60, &10, 3  , &18, &69, &78, &85, &22, &60   ; 5FDB: 24 38 E9... $8.
    EQUB &A6, &24, &A0, 6  , &8C, &F5, &62, &A5, &62, &F0, 2  , &84   ; 5FE7: A6 24 A0... .$.
    EQUB 6  , &A5, &25, &30, &0C, &AC, &FF, 6  , &20, &2D, &12, &B9   ; 5FF3: 06 A5 25... ..%
    EQUB 0  , &53, &4C, &8E, &12, &A4                                 ; 5FFF: 00 53 4C... .SL
    EQUS "! -"                                                        ; 6005: 21 20 2D    ! -
    EQUB &12, &20, &E0, &13, &A9, 2  , &29, 7  , &85, 7  , &AC, &FF   ; 6008: 12 20 E0... . .
    EQUB 6  , &B9, 0  , &59, &85, 1  , &A9, 0  , &9D, 2  , 7  , &60   ; 6014: 06 B9 00... ...
    EQUB &A2, &2C, &BD, &40, &5E, &9D, &41, &5E, &BD, &90, &5E, &9D   ; 6020: A2 2C BD... .,.
    EQUB &91, &5E, &BD, &20, &5F, &9D, &21, &5F, &E0, &28, &D0, 2     ; 602C: 91 5E BD... .^.
    EQUB &A2, 5  , &CA, &10, &E5, &A9, 6  , &38, &E5, 7  , &85, 5     ; 6038: A2 05 CA... ...
    EQUB &20, &C8, &12, &60, &A6, 6  , &E8, &E0, 6  , &90, 2  , &A2   ; 6044: 20 C8 12...  ..
    EQUB 6  , &E4, 5  , &B0, 2  , &A6, 5  , &86, 6  , &A6, 8  , &E8   ; 6050: 06 E4 05... ...
    EQUB &E8, &E4, 6  , &B0, 2  , &86, 6  , &CA, &E4, 5  , &B0, 2     ; 605C: E8 E4 06... ...
    EQUB &A2, 5  , &E0, 6  , &90, 2  , &A2, 5  , &86, 8  , &60, &18   ; 6068: A2 05 E0... ...
    EQUB &20, &33, &14, &A5, &24, &85, &23, &18, &69, 3  , &C9, &78   ; 6074: 20 33 14...  3.
    EQUB &90, 2  , &A9, 0  , &85, &24, &A2, &17, &A5, &25, &30, &1A   ; 6080: 90 02 A9... ...
    EQUB &AD, &FA                                                     ; 608C: AD FA       ..
    EQUS "YJ)"                                                        ; 608E: 59 4A 29    YJ)
    EQUB &F8, &DD, &E8, 6  , &D0, 4  , &A9, 1  , &85                  ; 6091: F8 DD E8... ...
    EQUS "0 |"                                                        ; 609A: 30 20 7C    0 |
    EQUB &14, &90, &13, &20, &67, &12, &4C, &CC, &13, &AD, &FF, 6     ; 609D: 14 90 13... ...
    EQUB &85, &21, &20, &C3, &14, &90, 3  , &20, &67, &12, &A4, 2     ; 60A9: 85 21 20... .!
    EQUB &20, &42, &14, &A6, &24, &A5, 1  , &4A, 8  , &A5, 1  , &B0   ; 60B5: 20 42 14...  B.
    EQUB &0D, &AC, &97, 8  , &C0, 1  , &90, 4  , &C0, &0A, &90, 2     ; 60C1: 0D AC 97... ...
    EQUB &29, &F9, &85, &77, &AC, &FF, 6  , &B9, 7  , &59, &28, &90   ; 60CD: 29 F9 85... )..
    EQUB &0B, &4A, &A8, &A5, &77, &CC, &97, 8  , &F0, &19, &D0, &13   ; 60D9: 0B 4A A8... .J.
    EQUB &38, &ED, &97, 8  , &A8, &A5, &77, &C0, 7  , &F0, &0C, &C0   ; 60E5: 38 ED 97... 8..
    EQUB &0E, &F0, 6  , &C0, &15, &F0, 2  , &29, &E7, &29, &DF, &25   ; 60F1: 0E F0 06... ...
    EQUB 1  , &9D, 2  , 7  , &A4, &23, &20, &CC, &0B, &20, &4D, &12   ; 60FD: 01 9D 02... ...
    EQUB &A4, 2  , &A9, 0  , &85, &83, &85, &85, &B9, 0  , &57, &10   ; 6109: A4 02 A9... ...
    EQUB 2  , &C6, &83, &0A, &26, &83, &0A, &26, &83, &18, &7D, 0     ; 6115: 02 C6 83... ...
    EQUB 9  , &9D, &78, 9  , &A5, &83, &7D, 0  , &0A, &9D, &78, &0A   ; 6121: 09 9D 78... ..x
    EQUB &B9, 0  , &58, &10, 2  , &C6, &85, &0A, &26, &85, &0A, &26   ; 612D: B9 00 58... ..X
    EQUB &85, &18, &7D, 2  , 9  , &9D, &7A, 9  , &A5, &85, &7D, 2     ; 6139: 85 18 7D... ..}
    EQUB &0A, &9D, &7A, &0A, &20, &DA, &13, &A6, &24, &A5, 2  , &9D   ; 6145: 0A 9D 7A... ..z
    EQUB 0  , 7  , &20, &5A, &12, &20, &0E, &15, &60, &A5, 1  , &29   ; 6151: 00 07 20... ..
    EQUB 1  , &F0, &1A, &A5, &25, &30, &0C, &A4, 2  , &C8, &CC, &FB   ; 615D: 01 F0 1A... ...
    EQUB &59, &D0, &0C, &A0, 0  , &F0, 8  , &A4, 2  , &D0, 3  , &AC   ; 6169: 59 D0 0C... Y..
    EQUB &FB, &59, &88, &84, 2  , &60, &A9, 6  , &85, 6  , &A2, &40   ; 6175: FB 59 88... .Y.
    EQUB &86, &1A, &20, &20, &14, &A9, 0  , &85, &1A                  ; 6181: 86 1A 20... ..
    EQUS "`8 3"                                                       ; 618A: 60 38 20... `8
    EQUB &14, &A2, &28, &86                                           ; 618E: 14 A2 28... ..(
    EQUS "b  "                                                        ; 6192: 62 20 20    b
    EQUB &14, &A2                                                     ; 6195: 14 A2       ..
    EQUS "'  "                                                        ; 6197: 27 20 20    '
    EQUB &14, &A9, 0  , &85, &62, &60, &A5, &25, &49, &80, &85, &25   ; 619A: 14 A9 00... ...
    EQUB &20, &DA, &13, &86, &42, &20, &F7, &12, &C6, &42, &D0, &F9   ; 61A6: 20 DA 13...  ..
    EQUB &60, &A6                                                     ; 61B2: 60 A6       `.
    EQUS "ojE%0"                                                      ; 61B4: 6F 6A 45... ojE
    EQUB 4  , &20, &7C, &14, &60, &20, &C3, &14, &60, &A9, 0  , &85   ; 61B9: 04 20 7C... . |
    EQUB &83, &85, &84, &85, &85, &B9, 0  , &54, &85, &74, &10, 2     ; 61C5: 83 85 84... ...
    EQUB &C6, &83, &B9, 0  , &55, &85, &75, &10, 2  , &C6, &84, &B9   ; 61D1: C6 83 B9... ...
    EQUB 0  , &56, &85, &76, &10, 2  , &C6, &85, &A5, &25, &F0, &12   ; 61DD: 00 56 85... .V.
    EQUB &A2, 2  , &A9, 0  , &38, &F5, &74, &95, &74, &A9, 0  , &F5   ; 61E9: A2 02 A9... ...
    EQUB &83, &95, &83, &CA, &10, &F0, &60, &BC, &E8, 6  , &BD, &80   ; 61F5: 83 95 83... ...
    EQUB 8  , &18, &69, 1  , &D9, 7  , &59, 8  , &90, &10, &98, &18   ; 6201: 08 18 69... ..i
    EQUB &69, 8  , &CD, &FA, &59, &90, 2  , &A9, 0  , &9D, &E8, 6     ; 620D: 69 08 CD... i..
    EQUB &A9, 0  , &9D, &80, 8  , &FE, &D0, 8  , &D0, 3  , &FE, &E8   ; 6219: A9 00 9D... ...
    EQUB 8  , &BD, &D0, 8  , &CD, &FC, &59, &D0, &13, &BD, &E8, 8     ; 6225: 08 BD D0... ...
    EQUB &CD, &FD, &59, &D0, &0B, &A9, 0  , &9D, &D0, 8  , &9D, &E8   ; 6231: CD FD 59... ..Y
    EQUB 8                                                            ; 623D: 08          .
    EQUS " wO(`"                                                      ; 623E: 20 77 4F...  wO
    EQUB &BC, &E8, 6  , &BD, &80, 8  , &18, &D0, &11, &98, &D0, 3     ; 6243: BC E8 06... ...
    EQUB &AD, &FA, &59, &38, &E9, 8  , &9D, &E8, 6  , &A8, &B9, 7     ; 624F: AD FA 59... ..Y
    EQUB &59, &38, 8  , &38, &E9, 1  , &9D, &80, 8  , &BD, &D0, 8     ; 625B: 59 38 08... Y8.
    EQUB &D0, &20, &DE, &E8, 8  , &10, &1B, &AD, &FC, &59, &9D, &D0   ; 6267: D0 20 DE... . .
    EQUB 8  , &AD, &FD, &59, &9D, &E8, 8  , &E4, &6F, &D0, &E6, &BD   ; 6273: 08 AD FD... ...
    EQUB &B4, 4  , &F0, &E1, &DE, &B4, 4  , &4C, &E4, &14, &DE, &D0   ; 627F: B4 04 F0... ...
    EQUB 8  , &28, &60, &AC, &FF, 6  , &98                            ; 628B: 08 28 60... .(`
    EQUS "JJJ"                                                        ; 6292: 4A 4A 4A    JJJ
    EQUB &AA, &A5, &17, &D0, &3D, &A5, 1  , &4A, &B0, &0F, &AD, &97   ; 6295: AA A5 17... ...
    EQUB 8  , &D9, 5  , &53, &B0, &0B, &BD                            ; 62A1: 08 D9 05... ...
; &62A8 referenced 1 time by &0B89
.L62A8
    EQUB &B0, &5F, 9  , &40, &D0, &45, &A5, &20, &30, 6  , &98, &18   ; 62A8: B0 5F 09... ._.
    EQUB &69, 8  , &A8, &E8, &B9, 0  , &59, &29, 1                    ; 62B4: 69 08 A8... i..
; &62BD referenced 1 time by &0B60
.L62BD
    EQUB &F0, &E8, &B9, 5  , &53, &85                                 ; 62BD: F0 E8 B9... ...
; &62C3 referenced 5 times by &508C, &50B0, &50C0, &50D1, &50F2
.L62C3
    EQUB &17, &F0, &E1, &B9, 7  , &53, &85, &20, &29                  ; 62C3: 17 F0 E1... ...
; &62CC referenced 3 times by &42D2, &50C9, &50EB
.L62CC
    EQUB &7F                                                          ; 62CC: 7F          .
; &62CD referenced 2 times by &42D9, &50C6
.L62CD
    EQUB &85, &18, &BD, &B0, &5F                                      ; 62CD: 85 18 BD... ...
; &62D2 referenced 1 time by &0BAB
.L62D2
    EQUB &85, &16, &4C, &73, &15, &C6, &17, &A5, &17                  ; 62D2: 85 16 4C... ..L
    EQUS "JJJ"                                                        ; 62DB: 4A 4A 4A    JJJ
    EQUB &85, &74, &A5, &17                                           ; 62DE: 85 74 A5... .t.
; &62E2 referenced 1 time by &0BB4
.L62E2
    EQUB &38, &E5, &18, &B0, 6  , &65, &74, &A9, 0  , &B0, 6  , &A5   ; 62E2: 38 E5 18... 8..
    EQUB &16, &B0, 2                                                  ; 62EE: 16 B0 02    ...
; &62F1 referenced 1 time by &0B9C
.L62F1
    EQUB &49, &80, &A4, &24, &99, 1  , 7  , &60, &A9, 0  , &85, &76   ; 62F1: 49 80 A4... I..
    EQUB &85, &74, &85, &58, &A2, &9D, &20, &50, &0E, 8  , &2C, &F5   ; 62FD: 85 74 85... .t.
    EQUB 5  , &10, &27, &A2, 1                                        ; 6309: 05 10 27... ..'
    EQUS " ?P"                                                        ; 630E: 20 3F 50     ?P
    EQUB &85, &75, &20, 0  , &0C, &28, &F0, 6                         ; 6311: 85 75 20... .u
    EQUS "JftJft"                                                     ; 6319: 4A 66 74... Jft
    EQUB &85, &75, &A5, &74, &29, &FE, &85, &74, &8A, 5  , &74, &85   ; 631F: 85 75 A5... .u.
    EQUB &74, &A5, &75, &4C, &E9, &1E, &EA, &EA, &A2, &A9, &20, &50   ; 632B: 74 A5 75... t.u
    EQUB &0E, &D0, 4  , &A9, 2  , &85, &76, &A2, &A8, &20, &50, &0E   ; 6337: 0E D0 04... ...
    EQUB &D0, 2  , &E6, &76, &A9, 3  , &85, &75, &28, &F0, &11, &A9   ; 6343: D0 02 E6... ...
    EQUB 0  , &A2, 2  , &EC, &A5, &62, &90, 2  , &A9, 1  , &85, &75   ; 634F: 00 A2 02... ...
    EQUB &A9, &80, &85, &74, &A5, &76, &F0, &11, &C9, 3  , &F0, &54   ; 635B: A9 80 85... ...
    EQUB &4D, &A2, &62, &29, 1  , &F0                                 ; 6367: 4D A2 62... M.b
    EQUS "! D"                                                        ; 636D: 21 20 44    ! D
    EQUB &0E, &4C, &0D, &16, &AD, &DA, &62, &29, &F0, &85, &74, &AD   ; 6370: 0E 4C 0D... .L.
    EQUB &EA                                                          ; 637C: EA          .
    EQUS "b @"                                                        ; 637D: 62 20 40    b @
    EQUB &0E                                                          ; 6380: 0E          .
    EQUS "JftJft"                                                     ; 6381: 4A 66 74... Jft
    EQUB &CD, &A5, &62, &20, &9B, &1F, &85, &75, &4C, &FA, &1E, &38   ; 6387: CD A5 62... ..b
    EQUB &E5, &74, &85, &74, &AD, &A5, &62, &E5, &75, &C9, &C8, &90   ; 6393: E5 74 85... .t.
    EQUB &0D, &20, &42, &0E, &85, &75, &A5, &74, &49, 1  , &85, &74   ; 639F: 0D 20 42... . B
    EQUB &A5, &75, &C9, &91, &90, 2  , &A9, &91, &8D, &A5, &62, &A5   ; 63AB: A5 75 C9... .u.
    EQUB &74, &8D, &A2, &62, &A5, &0F                                 ; 63B7: 74 8D A2... t..
; &63BD referenced 1 time by &79AA
.C63BD
    BNE C63F8                                                         ; 63BD: D0 39       .9
    BIT L05F5                                                         ; 63BF: 2C F5 05    ,..
    BPL C63DE                                                         ; 63C2: 10 1A       ..
    LDX #2                                                            ; 63C4: A2 02       ..
    JSR sub_C503F                                                     ; 63C6: 20 3F 50     ?P
    BCC C63F8                                                         ; 63C9: 90 2D       .-
    STA L0074                                                         ; 63CB: 85 74       .t
    LSR L0074                                                         ; 63CD: 46 74       Ft
    ASL A                                                             ; 63CF: 0A          .
    ADC L0074                                                         ; 63D0: 65 74       et
    BCS C63D8                                                         ; 63D2: B0 04       ..
    CMP #&FA                                                          ; 63D4: C9 FA       ..
    BCC C6401                                                         ; 63D6: 90 29       .)
; &63D8 referenced 1 time by &63D2
.C63D8
    CPX #0                                                            ; 63D8: E0 00       ..
    BEQ C63F4                                                         ; 63DA: F0 18       ..
    BNE C63E7                                                         ; 63DC: D0 09       ..
; &63DE referenced 1 time by &63C2
.C63DE
    LDX #&AE                                                          ; 63DE: A2 AE       ..
    JSR L0E50                                                         ; 63E0: 20 50 0E     P.
    BNE C63EB                                                         ; 63E3: D0 06       ..
    LDX #1                                                            ; 63E5: A2 01       ..
; &63E7 referenced 1 time by &63DC
.C63E7
    LDA #&FF                                                          ; 63E7: A9 FF       ..
    BNE C6401                                                         ; 63E9: D0 16       ..
; &63EB referenced 1 time by &63E3
.C63EB
    LDX #&BE                                                          ; 63EB: A2 BE       ..
    JSR L0E50                                                         ; 63ED: 20 50 0E     P.
    BNE C63F8                                                         ; 63F0: D0 06       ..
    LDX #0                                                            ; 63F2: A2 00       ..
; &63F4 referenced 1 time by &63DA
.C63F4
    LDA #&FA                                                          ; 63F4: A9 FA       ..
    BNE C6401                                                         ; 63F6: D0 09       ..
; &63F8 referenced 3 times by &63BD, &63C9, &63F0
.C63F8
    LDX #&80                                                          ; 63F8: A2 80       ..
    LDA L003C                                                         ; 63FA: A5 3C       .<
    LSR A                                                             ; 63FC: 4A          J
    LSR A                                                             ; 63FD: 4A          J
    CLC                                                               ; 63FE: 18          .
    ADC #5                                                            ; 63FF: 69 05       i.
; &6401 referenced 3 times by &63D6, &63E9, &63F6
.C6401
    STX L003E                                                         ; 6401: 86 3E       .>
    STA L003F                                                         ; 6403: 85 3F       .?
    BIT L05F5                                                         ; 6405: 2C F5 05    ,..
    BPL C6423                                                         ; 6408: 10 19       ..
    LDX #0                                                            ; 640A: A2 00       ..
    LDA #osbyte_read_adc_or_get_buffer_status                         ; 640C: A9 80       ..
    JSR osbyte                                                        ; 640E: 20 F4 FF     ..
    TXA                                                               ; 6411: 8A          .
    AND #1                                                            ; 6412: 29 01       ).
    BEQ C6431                                                         ; 6414: F0 1B       ..
    LDY L003E                                                         ; 6416: A4 3E       .>
    DEY                                                               ; 6418: 88          .
    BNE C6437                                                         ; 6419: D0 1C       ..
    LDA L003F                                                         ; 641B: A5 3F       .?
    CMP #&C8                                                          ; 641D: C9 C8       ..
    BCS C643B                                                         ; 641F: B0 1A       ..
    BCC C6437                                                         ; 6421: 90 14       ..
; &6423 referenced 1 time by &6408
.C6423
    LDX #&9F                                                          ; 6423: A2 9F       ..
    JSR L0E50                                                         ; 6425: 20 50 0E     P.
    BEQ C6437                                                         ; 6428: F0 0D       ..
    LDX #&EF                                                          ; 642A: A2 EF       ..
    JSR L0E50                                                         ; 642C: 20 50 0E     P.
    BEQ C643B                                                         ; 642F: F0 0A       ..
; &6431 referenced 1 time by &6414
.C6431
    LDA #0                                                            ; 6431: A9 00       ..
    STA L0019                                                         ; 6433: 85 19       ..
    BEQ C645B                                                         ; 6435: F0 24       .$
; &6437 referenced 3 times by &6419, &6421, &6428
.C6437
    LDA #&FF                                                          ; 6437: A9 FF       ..
    BNE C643D                                                         ; 6439: D0 02       ..
; &643B referenced 2 times by &641F, &642F
.C643B
    LDA #1                                                            ; 643B: A9 01       ..
; &643D referenced 1 time by &6439
.C643D
    DEC L0058                                                         ; 643D: C6 58       .X
    LDX L0019                                                         ; 643F: A6 19       ..
    BNE C645B                                                         ; 6441: D0 18       ..
    STA L0019                                                         ; 6443: 85 19       ..
    CLC                                                               ; 6445: 18          .
    ADC L0040                                                         ; 6446: 65 40       e@
    CMP #&FF                                                          ; 6448: C9 FF       ..
    BEQ C6454                                                         ; 644A: F0 08       ..
    CMP #7                                                            ; 644C: C9 07       ..
    BNE C6456                                                         ; 644E: D0 06       ..
    LDA #6                                                            ; 6450: A9 06       ..
    BNE C6456                                                         ; 6452: D0 02       ..
; &6454 referenced 1 time by &644A
.C6454
    LDA #0                                                            ; 6454: A9 00       ..
; &6456 referenced 2 times by &644E, &6452
.C6456
    STA L0040                                                         ; 6456: 85 40       .@
    JSR sub_C42D0                                                     ; 6458: 20 D0 42     .B
; &645B referenced 2 times by &6435, &6441
.C645B
    RTS                                                               ; 645B: 60          `

    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 645C: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6468: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6474: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6480: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 648C: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6498: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 64A4: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 64B0: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 64BC: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , &88, &CC, &EE   ; 64C8: 00 00 00... ...
    EQUB &0F, &8F, &CF, &EF, &F0, &F8, &FC, &FE, 0  , 8  , &0C, &0E   ; 64D4: 0F 8F CF... ...
    EQUB 0  , &80, &C0, &E0, &0F, 7  , 3  , 1  , &F0, &70, &30, &10   ; 64E0: 00 80 C0... ...
    EQUB &FF, &77, &33, &11, &FF, &7F, &3F, &1F, &FF, &F7, &F3, &F1   ; 64EC: FF 77 33... .w3
    EQUB 3  , &60, &30, &18, &0C, 6  , 3  , 1  , 0  , 1  , 2  , 3     ; 64F8: 03 60 30... .`0
    EQUB 4  , 5  , 6  , 7  , 8  , 9  , &0A, &0B, &0C, &0D, &0E, &0F   ; 6504: 04 05 06... ...
    EQUB &10, &11, &12, &13, &14, &15, &16, &17, &18, &19, &1A, &1B   ; 6510: 10 11 12... ...
    EQUB &1C, &1D, &1E, &1F                                           ; 651C: 1C 1D 1E... ...
    EQUS " !", '"', "#$%&'()*+,-./0123456789:;<=>?@ABCDE"             ; 6520: 20 21 22...  !"
    EQUS "FGHIJKLMNOPQRST"                                            ; 6546: 46 47 48... FGH
    EQUB 0                                                            ; 6555: 00          .
    EQUS "VWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~"                  ; 6556: 56 57 58... VWX
    EQUB &7F, &80, &81, &82, &83, &84, &85, &86, &87, &88, &89, &8A   ; 657F: 7F 80 81... ...
    EQUB &8B, &8C, &8D, &8E, &8F, &90, &91, &92, &93, &94, &95, &96   ; 658B: 8B 8C 8D... ...
    EQUB &97, &98, &99, &9A, &9B, &9C, &9D, &9E, &9F, &A0, &A1, &A2   ; 6597: 97 98 99... ...
    EQUB &A3, &A4, &A5, &A6, &A7, &A8, &A9, &AA, &AB, &AC, &AD, &AE   ; 65A3: A3 A4 A5... ...
    EQUB &AF, &B0, &B1, &B2, &B3, &B4, &B5, &B6, &B7, &B8, &B9, &BA   ; 65AF: AF B0 B1... ...
    EQUB &BB, &BC, &BD, &BE, &BF, &C0, &C1, &C2, &C3, &C4, &C5, &C6   ; 65BB: BB BC BD... ...
    EQUB &C7, &C8, &C9, &CA, &CB, &CC, &CD, &CE, &CF, &D0, &D1, &D2   ; 65C7: C7 C8 C9... ...
    EQUB &D3, &D4, &D5, &D6, &D7, &D8, &D9, &DA, &DB, &DC, &DD, &DE   ; 65D3: D3 D4 D5... ...
    EQUB &DF, &E0, &E1, &E2, &E3, &E4, &E5, &E6, &E7, &E8, &E9, &EA   ; 65DF: DF E0 E1... ...
    EQUB &EB, &EC, &ED, &EE, &EF, &F0, &F1, &F2, &F3, &F4, &F5, &F6   ; 65EB: EB EC ED... ...
    EQUB &F7, &F8, &F9, &FA, &FB, &FC, &FD, &FE, &FF, 0  , 1  , 3     ; 65F7: F7 F8 F9... ...
    EQUB 4  , 5  , 6  , 8  , 9  , &0A, &0B, &0D, &0E, &0F, &11, &12   ; 6603: 04 05 06... ...
    EQUB &13, &14, &16, &17, &18, &19, &1B, &1C, &1D, &1E             ; 660F: 13 14 16... ...
    EQUS " !", '"', "$%&')*+,./01345679:;<>?@ACDEFGIJKLM"             ; 6619: 20 21 22...  !"
    EQUS "OPQRSUVWXY[\]^_`bcdefghjklmnoprstuvwxyz|}~"                 ; 663F: 4F 50 51... OPQ
    EQUB &7F, &80, &81, &82, &83, &84, &85, &86, &87, &89, &8A, &8B   ; 6669: 7F 80 81... ...
    EQUB &8C, &8D, &8E, &8F, &90, &91, &92, &93, &94, &95, &96, &97   ; 6675: 8C 8D 8E... ...
    EQUB &98, &99, &9A, &9B, &9C, &9D, &9E, &9F, &A0, &A1, &A2, &A3   ; 6681: 98 99 9A... ...
    EQUB &A4, &A5, &A6, &A7, &A8, &A9, &AA, &AB, &AC, &AD, &AE, &AF   ; 668D: A4 A5 A6... ...
    EQUB &B0, &B1, &B1, &B2, &B3, &B4, &B5, &B6, &B7, &B8, &B9, &BA   ; 6699: B0 B1 B1... ...
    EQUB &BB, &BC, &BC, &BD, &BE, &BF, &C0, &C1, &C2, &C3, &C3, &C4   ; 66A5: BB BC BC... ...
    EQUB &C5, &C6, &C7, &C8, &C9, &C9, &CA, &CB, &CC, &CD, &CE, &CE   ; 66B1: C5 C6 C7... ...
    EQUB &CF, &D0, &D1, &D2, &D3, &D3, &D4, &D5, &D6, &D7, &D7, &D8   ; 66BD: CF D0 D1... ...
    EQUB &D9, &DA, &DB, &DB, &DC, &DD, &DE, &DE, &DF, &E0, &E1, &E1   ; 66C9: D9 DA DB... ...
    EQUB &E2, &E3, &E4, &E4, &E5, &E6, &E7, &E7, &E8, &E9, &EA, &EA   ; 66D5: E2 E3 E4... ...
    EQUB &EB, &EC, &EC, &ED, &EE, &EF, &EF, &F0, &F1, &F1, &F2, &F3   ; 66E1: EB EC EC... ...
    EQUB &F3, &F4, &F5, &F5, &F6, &F7, &F8, &F8, &F9, &FA, &FA, &FB   ; 66ED: F3 F4 F5... ...
    EQUB &FB, &FC, &FD, &FD, &FE, &FF, &FF, &FF, &FE, &FC, &FA, &F8   ; 66F9: FB FC FD... ...
    EQUB &F6, &F5, &F3, &F1, &EF, &ED, &EC, &EA, &E8, &E7, &E5, &E4   ; 6705: F6 F5 F3... ...
    EQUB &E2, &E0, &DF, &DD, &DC, &DA, &D9, &D8, &D6, &D5, &D3, &D2   ; 6711: E2 E0 DF... ...
    EQUB &D1, &CF, &CE, &CD, &CC, &CA, &C9, &C8, &C7, &C5, &C4, &C3   ; 671D: D1 CF CE... ...
    EQUB &C2, &C1, &C0, &BF, &BD, &BC, &BB, &BA, &B9, &B8, &B7, &B6   ; 6729: C2 C1 C0... ...
    EQUB &B5, &B4, &B3, &B2, &B1, &B0, &AF, &AE, &AD, &AC, &AC, &AB   ; 6735: B5 B4 B3... ...
    EQUB &AA, &A9, &A8, &A7, &A6, &A5, &A5, &A4, &A3, &A2, &A1, &A1   ; 6741: AA A9 A8... ...
    EQUB &A0, &9F, &9E, &9E, &9D, &9C, &9B, &9B, &9A, &99, &98, &98   ; 674D: A0 9F 9E... ...
    EQUB &97, &96, &96, &95, &94, &94, &93, &92, &92, &91, &90, &90   ; 6759: 97 96 96... ...
    EQUB &8F, &8E, &8E, &8D, &8D, &8C, &8B, &8B, &8A, &8A, &89, &89   ; 6765: 8F 8E 8E... ...
    EQUB &88, &87, &87, &86, &86, &85, &85, &84, &84, &83, &83, &82   ; 6771: 88 87 87... ...
    EQUB &82, &81, &81, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 677D: 82 81 81... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6789: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6795: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 67A1: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 67AD: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 67B9: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 67C5: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 67D1: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 67DD: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 67E9: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , &85   ; 67F5: 00 00 00... ...
    EQUB &70, &84, &71, &86, &77, &A9, 2  , &A2, 0  , &20, &F4, &FF   ; 6801: 70 84 71... p.q
    EQUB &A9, &15, &A2, 0  , &20, &F4, &FF, &A0, 0  , &20, &E0, &FF   ; 680D: A9 15 A2... ...
    EQUB &B0, &2A, &C9, &0D, &F0, &33, &C9, &20, &90, &F3, &D0, 4     ; 6819: B0 2A C9... .*.
    EQUB &C0, 0  , &F0, &ED, &C9, &7F, &90, 7  , &D0, &E7, &88, &10   ; 6825: C0 00 F0... ...
    EQUB &0D, &30, &E0, &C4, &77, &D0, 4  , &A9, 7  , &D0, 3  , &91   ; 6831: 0D 30 E0... .0.
    EQUB &70, &C8, &20, &EE, &FF, &4C, &16, &63, &98, &48, &A9, &7E   ; 683D: 70 C8 20... p.
    EQUB &20, &F4, &FF, &68, &A8, &4C, &16, &63, &C8, &C4, &77, &D0   ; 6849: 20 F4 FF...  ..
    EQUB 1  , &60, &A9, &20, &91, &70, &D0, &F4, &A6, &4A, &AD, &68   ; 6855: 01 60 A9... .`.
    EQUB &FE, 8  , &29, &7F, &A0, &10, &C9, 4  , &90, &10, &E9, 4     ; 6861: FE 08 29... ..)
    EQUB &88, &D0, &F7, &A0, 9  , &C9, 7  , &90, 5  , &E9, 7  , &88   ; 686D: 88 D0 F7... ...
    EQUB &D0, &F7                                                     ; 6879: D0 F7       ..
    EQUS "( P4"                                                       ; 687B: 28 20 50... ( P
    EQUB &0A, &38, &FD, &A0, 4  , &85, &74, &AC, &3A, &5F, &88, &F0   ; 687F: 0A 38 FD... .8.
    EQUB 9  , &10, 4  , &0A, &4C, &95                                 ; 688B: 09 10 04... ...
    EQUS "c&tj"                                                       ; 6891: 63 26 74... c&t
    EQUB &18                                                          ; 6895: 18          .
    EQUS "m@_"                                                        ; 6896: 6D 40 5F    m@_
    EQUB &9D, &28, 1                                                  ; 6899: 9D 28 01    .(.
    EQUS " ~P"                                                        ; 689C: 20 7E 50     ~P
    EQUB &86, &4A, &60, &A5, &6F, &A2, &13, &DD, &3C, 1  , &F0, 3     ; 689F: 86 4A 60... .J`
    EQUB &CA, &10, &F8, &86, 3  , &20, &84, &50, &86, &5B, &A6, 3     ; 68AB: CA 10 F8... ...
    EQUS " ~P"                                                        ; 68B7: 20 7E 50     ~P
    EQUB &86                                                          ; 68BA: 86          .
    EQUS "M`LP8"                                                      ; 68BB: 4D 60 4C... M`L
    EQUB &EA, &EA, &EA, &EA, &EA, &48, &AD, &F8, 5  , &8D, &E3, &77   ; 68C0: EA EA EA... ...
    EQUB &4A, &8D, &E4, &77, &4A, &8D, &DC, &77, &4A, &8D, &DB, &77   ; 68CC: 4A 8D E4... J..
    EQUB &A5                                                          ; 68D8: A5          .
    EQUS "%*h"                                                        ; 68D9: 25 2A 68    %*h
    EQUB &AE, &F8, 5  , &60, &A2, 0  , &8E, &F4, 5                    ; 68DC: AE F8 05... ...
    EQUS " MM"                                                        ; 68E5: 20 4D 4D     MM
    EQUB &A2, 4  , &20, &D0                                           ; 68E8: A2 04 20... ..
    EQUS "A P:"                                                       ; 68EC: 41 20 50... A P
    EQUB &A2                                                          ; 68F0: A2          .
    EQUS "' ~M"                                                       ; 68F1: 27 20 7E... ' ~
    EQUB &A2, 2                                                       ; 68F5: A2 02       ..
    EQUS " qe"                                                        ; 68F7: 20 71 65     qe
    EQUB &E0, 1  , &B0, &0C, &86, &6F, &CA, &8E                       ; 68FA: E0 01 B0... ...
    EQUS ";_ "                                                        ; 6902: 3B 5F 20    ;_
    EQUB &EC                                                          ; 6905: EC          .
    EQUS "B Ze"                                                       ; 6906: 42 20 5A... B Z
    EQUB &A9, 0  , &8D, &3C, &5F, &A2, &15                            ; 690A: A9 00 8D... ...
    EQUS " ~M"                                                        ; 6911: 20 7E 4D     ~M
    EQUB &A2, 3                                                       ; 6914: A2 03       ..
    EQUS " qe"                                                        ; 6916: 20 71 65     qe
    EQUB &8E                                                          ; 6919: 8E          .
    EQUS ":_ "                                                        ; 691A: 3A 5F 20    :_
    EQUB &C6, &44, &A2, &16                                           ; 691D: C6 44 A2... .D.
    EQUS " ~M"                                                        ; 6921: 20 7E 4D     ~M
    EQUB &A2, 3                                                       ; 6924: A2 03       ..
    EQUS " qe"                                                        ; 6926: 20 71 65     qe
    EQUB &BD, &F0, &3D, &8D                                           ; 6929: BD F0 3D... ..=
    EQUS ";_ "                                                        ; 692D: 3B 5F 20    ;_
    EQUB &EC, &42, &A9, &14, &85, &6F, &C6, &6F, &A6, &6F, &20, &EB   ; 6930: EC 42 A9... .B.
    EQUB &40, &AD, &3C, &5F, &F0, &15, &20, &87                       ; 693C: 40 AD 3C... @.<
    EQUS "f Ze"                                                       ; 6944: 66 20 5A... f Z
    EQUB &A5, &6F, &CD, &39, &5F, &D0, &E7, &A9, 0  , &20, &64, &0F   ; 6948: A5 6F CD... .o.
    EQUB &4C, &B3, &64, &A2, &17                                      ; 6954: 4C B3 64... L.d
    EQUS " ~M "                                                       ; 6959: 20 7E 4D...  ~M
    EQUB &D4                                                          ; 695D: D4          .
    EQUS "f Ze"                                                       ; 695E: 66 20 5A... f Z
    EQUB &A6, &6F, &F0, &0E, &A2, &1B                                 ; 6962: A6 6F F0... .o.
    EQUS " ~M"                                                        ; 6968: 20 7E 4D     ~M
    EQUB &A2, 2                                                       ; 696B: A2 02       ..
    EQUS " qe"                                                        ; 696D: 20 71 65     qe
    EQUB &E0, 0  , &F0, &C2, &A5, &6F, &8D, &39, &5F, &A9, 0  , &20   ; 6970: E0 00 F0... ...
    EQUB &64, &0F, &A2, 0  , &AC, &4F, 1  , &CC, &39, &5F, &90, &1A   ; 697C: 64 0F A2... d..
    EQUB &B9, &B8, 6  , &38, &FD, 0  , &5A, &B9, &D0, 6  , &FD, 3     ; 6988: B9 B8 06... ...
    EQUB &5A, &B0, 3  , &E8, &D0, &E6, &EC, &3A, &5F, &B0, 3  , &8E   ; 6994: 5A B0 03... Z..
    EQUB &3A, &5F, &AE                                                ; 69A0: 3A 5F AE    :_.
    EQUS ":_ "                                                        ; 69A3: 3A 5F 20    :_
    EQUB &C6, &44, &A2, &1A                                           ; 69A6: C6 44 A2... .D.
    EQUS " ~M o< "                                                    ; 69AA: 20 7E 4D...  ~M
    EQUB &D0, &34, &A2, 2  , &A9, 0  , &20, &D3, &65, &A0, &13, &B9   ; 69B1: D0 34 A2... .4.
    EQUB &3C, 1  , &99, &C8, 4  , &CD, &39, &5F, &90, 8  , &AA, &B9   ; 69BD: 3C 01 99... <..
    EQUB 0  , 1  , &4A, &9D, &A0, 4  , &88, &10, &EA, &AD, &3C, &5F   ; 69C9: 00 01 4A... ..J
    EQUB &D0, &1B, &A2, &1C                                           ; 69D5: D0 1B A2... ...
    EQUS " ~M"                                                        ; 69D9: 20 7E 4D     ~M
    EQUB &A9, &14, &38, &ED, &39, &5F, &8D, &38, &5F, &A2, 3          ; 69DC: A9 14 38... ..8
    EQUS " qe"                                                        ; 69E7: 20 71 65     qe
    EQUB &BD, &F4, &3D, &85, &6E, &8E, &3F, &5F, &A9, &14, &85, &6F   ; 69EA: BD F4 3D... ..=
    EQUB &C6, &6F, &20, &87, &66, &A2, &13, &BD, &C8, 4  , &9D, &3C   ; 69F6: C6 6F 20... .o
    EQUB 1  , &CA, &10, &F7, &20, &EC, &42, &A9, &80                  ; 6A02: 01 CA 10... ...
    EQUS " \e"                                                        ; 6A0B: 20 5C 65     \e
    EQUB &A9, &80, &20, &64, &0F, &A2, 5                              ; 6A0E: A9 80 20... ..
    EQUS " %Z"                                                        ; 6A15: 20 25 5A     %Z
    EQUB &CA, &10, &FA, &A9, 0  , &20, &64, &0F, &A2, 6               ; 6A18: CA 10 FA... ...
    EQUS " %Z"                                                        ; 6A22: 20 25 5A     %Z
    EQUB &A9, &80, &20, &64, &0F, &A2, 1  , &A9, 4  , &20, &D3, &65   ; 6A25: A9 80 20... ..
    EQUB &A9, 0  , &20, &64, &0F, &A2, 6  , &A9, 0  , &20, &D3, &65   ; 6A31: A9 00 20... ..
    EQUB &A9                                                          ; 6A3D: A9          .
    EQUS "@ d"                                                        ; 6A3E: 40 20 64    @ d
    EQUB &0F, &A2, 3  , &8E, &3C, &5F, &A9, &88, &20, &D3             ; 6A41: 0F A2 03... ...
    EQUS "e$x"                                                        ; 6A4B: 65 24 78    e$x
    EQUB &10, &D5, &A5, &6F, &CD, &39, &5F, &D0, &9F, &4C, &1F, &64   ; 6A4E: 10 D5 A5... ...
    EQUB &A9, &28, &85, &6C, &85                                      ; 6A5A: A9 28 85... .(.
    EQUS "m P< "                                                      ; 6A5F: 6D 20 50... m P
    EQUB &DC, &16, &2C, &F4, 5  , &70, &F5, &10, 3                    ; 6A64: DC 16 2C... ..,
    EQUS " s2`"                                                       ; 6A6D: 20 73 32...  s2
    EQUB &A0, 0  , &84, &77, &86                                      ; 6A71: A0 00 84... ...
    EQUS "u a2"                                                       ; 6A76: 75 20 61... u a
    EQUB &A4, &75, &84, &76, &BE, &E0                                 ; 6A7A: A4 75 84... .u.
    EQUS "9 P"                                                        ; 6A80: 39 20 50    9 P
    EQUB &0E, &F0, 7  , &A4, &76, &88, &10, &F1, &30, &EA, &A4, &76   ; 6A83: 0E F0 07... ...
    EQUB &D0, &0D, &A5, &77, &F0, &E2, &A9, &98, &8D, &C5, &7F, &A6   ; 6A8F: D0 0D A5... ...
    EQUB &78, &CA, &60, &84, &78, &A5, &77, &D0, 7  , &A2, &1E, &86   ; 6A9B: 78 CA 60... x.`
    EQUS "w ~M"                                                       ; 6AA7: 77 20 7E... w ~
    EQUB &A2, 0  , &A0, 1  , &A9, &84, &C4, &78, &D0, 2  , &A9, &81   ; 6AAB: A2 00 A0... ...
    EQUB &9D, &85, &7E, &8A, &18, &69, &50, &AA, &C8, &C4, &75, &90   ; 6AB7: 9D 85 7E... ..~
    EQUB &EB, &F0, &E9, &D0, &AF, &C9, &0A, &90, 2  , &69, 5  , &F8   ; 6AC3: EB F0 E9... ...
    EQUB &69, 1  , &D8                                                ; 6ACF: 69 01 D8    i..
    EQUS "`H)"                                                        ; 6AD2: 60 48 29    `H)
    EQUB &0F, &85, &42, &20, &D0, &41, &A0, 0  , &84, &1B, &A9, 0     ; 6AD5: 0F 85 42... ..B
    EQUB &85                                                          ; 6AE1: 85          .
    EQUS "x `>"                                                       ; 6AE2: 78 20 60... x `
    EQUB &A2                                                          ; 6AE6: A2          .
    EQUS "  ~M"                                                       ; 6AE7: 20 20 7E...   ~
    EQUB &A4, &1B, &B9, 0  , 1                                        ; 6AEB: A4 1B B9... ...
    EQUS "$l0"                                                        ; 6AF0: 24 6C 30    $l0
    EQUB 1  , &98, &20, &C8, &65, &20, &D6, &37, &A2, &1F             ; 6AF3: 01 98 20... ..
    EQUS " ~M"                                                        ; 6AFD: 20 7E 4D     ~M
    EQUB &A4, &1B                                                     ; 6B00: A4 1B       ..
    EQUS " {f"                                                        ; 6B02: 20 7B 66     {f
    EQUB &A2, &1F                                                     ; 6B05: A2 1F       ..
    EQUS " ~M"                                                        ; 6B07: 20 7E 4D     ~M
    EQUB &A6                                                          ; 6B0A: A6          .
    EQUS "EhH"                                                        ; 6B0B: 45 68 48    EhH
    EQUB &D0, 8  , &A9, &26, &20, &9C                                 ; 6B0E: D0 08 A9... ...
    EQUS "{LCf0"                                                      ; 6B14: 7B 4C 43... {LC
    EQUB &11, &A5, &1B, &18, &69, &14, &C9, &1A, &AA, &90, &1C, &A9   ; 6B19: 11 A5 1B... ...
    EQUB 7                                                            ; 6B25: 07          .
    EQUS " P="                                                        ; 6B26: 20 50 3D     P=
    EQUB &F0, &18, &A9, &28, &85, &78, &BD, &F0, 4  , &F0, &0C, &20   ; 6B29: F0 18 A9... ...
    EQUB &D6, &37, &BD, &E4, &39, &20, &E7                            ; 6B35: D6 37 BD... .7.
    EQUS "CLCf "                                                      ; 6B3C: 43 4C 43... CLC
    EQUB &D0, &43, &A4, &1B, &C8, &C0, &14, &D0, &93, &A9, 3          ; 6B41: D0 43 A4... .C.
    EQUS " P="                                                        ; 6B4C: 20 50 3D     P=
    EQUB &A9, &9C, &20, &EE, &FF, &A5, &6C, &10, &16, &A2             ; 6B4F: A9 9C 20... ..
    EQUS "1 ~M o<"                                                    ; 6B59: 31 20 7E... 1 ~
    EQUB &AD, &3F, &5F, &18, &69, &DA, &8D, &7D, &3C, &A2             ; 6B60: AD 3F 5F... .?_
    EQUS "2 ~Mh "                                                     ; 6B6A: 32 20 7E... 2 ~
    EQUB &D2, &34, &60, &8D, &CD, &62, &A9, &1B, &8D, &CC, &62, &BE   ; 6B70: D2 34 60... .4`
    EQUB &3C, 1  , &86, &45, &20, &EB                                 ; 6B7C: 3C 01 86... <..
    EQUS "< P2`"                                                      ; 6B82: 3C 20 50... < P
    EQUB &A2, &1D                                                     ; 6B87: A2 1D       ..
    EQUS " ~M"                                                        ; 6B89: 20 7E 4D     ~M
    EQUB &A6, &6F, &20, &EB                                           ; 6B8C: A6 6F 20... .o
    EQUS "< P2 "                                                      ; 6B90: 3C 20 50... < P
    EQUB &D0, &34, &60, &F8, &B9, &64, &38, &18                       ; 6B95: D0 34 60... .4`
    EQUS "}x8"                                                        ; 6B9D: 7D 78 38    }x8
    EQUB &99, &64, &38, &B9, &E4, &39, &7D, &F8, &39, &99, &E4, &39   ; 6BA0: 99 64 38... .d8
    EQUB &B9, &F0, 4  , &69, 0  , &99, &F0, 4  , &D8, &60, &A6, &1F   ; 6BAC: B9 F0 04... ...
    EQUB &A9, &80, &9D, &A4, 5  , &9D, &50, 6  , &9D, 0  , 6  , &9D   ; 6BB8: A9 80 9D... ...
    EQUB &54, 5  , &CA, &10, &F1, &A2, &4F, &A9, 0  , &9D, &60, &5F   ; 6BC4: 54 05 CA... T..
    EQUB &CA, &10, &FA, &60, &A6, &6F, &20, &EB, &3C, &A2, &0C, &20   ; 6BD0: CA 10 FA... ...
    EQUB 0  , &63, &60, &A6, 3  , &10, 3  , &20, &CB, &2A, &20, &84   ; 6BDC: 00 63 60... .c`
    EQUB &50, &E4, &4D, &D0, &F6, &A2, &16, &86, &45, &20, &D1, &2A   ; 6BE8: 50 E4 4D... P.M
    EQUB &CA, &E0, &14, &B0, &F6, &A6, &4D, &20, &CB, &2A, &60, 0     ; 6BF4: CA E0 14... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6C00: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6C0C: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6C18: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6C24: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6C30: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6C3C: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6C48: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6C54: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6C60: 00 00 00... ...
    EQUB 0                                                            ; 6C6C: 00          .
    EQUS "00@"                                                        ; 6C6D: 30 30 40    00@
    EQUB 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0     ; 6C70: 00 00 00... ...
    EQUB 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0     ; 6C7C: 00 F0 F0... ...
    EQUB 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0     ; 6C88: 00 00 00... ...
    EQUB 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0     ; 6C94: 00 F0 F0... ...
    EQUB 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0     ; 6CA0: 00 00 00... ...
    EQUB 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0     ; 6CAC: 00 F0 F0... ...
    EQUB 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0     ; 6CB8: 00 00 00... ...
    EQUB 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0     ; 6CC4: 00 F0 F0... ...
    EQUB 0  , 0  , 0  , 0  , 0  , &C0, &C0, &20, 0  , 0  , 0  , 0     ; 6CD0: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6CDC: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6CE8: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6CF4: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6D00: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6D0C: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6D18: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6D24: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6D30: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6D3C: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6D48: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6D54: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6D60: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6D6C: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6D78: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6D84: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6D90: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , &10, &10, &10   ; 6D9C: 00 00 00... ...
    EQUB &70, &40, &F0, &80, &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0     ; 6DA8: 70 40 F0... p@.
    EQUB &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &E1, &16   ; 6DB4: F0 00 F0... ...
    EQUB &F0, 0  , &F0, 0  , &C3, &2D, &5A, &C3, &F0, 0  , &F0, 7     ; 6DC0: F0 00 F0... ...
    EQUB &78, &A5, &87, &1E, &F0, 0  , &0F, &B4, &D2, &0F, &2D, &0F   ; 6DCC: 78 A5 87... x..
    EQUB &F0, 7  , &78, &F0, &4B, &1E, &4B, &0F, &F0, &0E, &E1, &F0   ; 6DD8: F0 07 78... ..x
    EQUB &2D, &87, &2D, &0F, &F0, 0  , &0F, &D2, &B4, &0F, &4B, &0F   ; 6DE4: 2D 87 2D... -.-
    EQUB &F0, 0  , &F0, &0E, &E1, &5A, &1E, &87, &F0, 0  , &F0, 0     ; 6DF0: F0 00 F0... ...
    EQUB &3C, &4B, &A5, &3C, &F0, 0  , &F0, 0  , &F0, 0  , &78, &86   ; 6DFC: 3C 4B A5... <K.
    EQUB &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &E0, &20, &F0, &10   ; 6E08: F0 00 F0... ...
    EQUB &F0, 0  , &F0, 0  , 0  , 0  , 0  , 0  , 0  , &80, &80, &80   ; 6E14: F0 00 F0... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6E20: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6E2C: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6E38: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6E44: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6E50: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6E5C: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6E68: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6E74: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , &A0, &50, &B0, 0  , 0  , 0  , 0     ; 6E80: 00 00 00... ...
    EQUB 0  , &D0, &A0, &40, 0  , 0  , 0  , 0  , 0  , &F0, &10, 0     ; 6E8C: 00 D0 A0... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , &80, &C0, 0  , 0  , 0  , 0     ; 6E98: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6EA4: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6EB0: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6EBC: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6EC8: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , &10        ; 6ED4: 00 00 00... ...
    EQUS "00 0@p"                                                     ; 6EDF: 30 30 20... 00
    EQUB &C0, &F0, &80, &F0, 0  , &F0, 0  , &E1, 3  , &96, &0F, &F0   ; 6EE5: C0 F0 80... ...
    EQUB 1  , &87, &3C, &4B, &C3, &87                                 ; 6EF1: 01 87 3C... ..<
    EQUS "K-i"                                                        ; 6EF7: 4B 2D 69    K-i
    EQUB &87, &1E, &0F, &87, &0F, &0F, &87, &4B, &0F, &0F, &0F, &0F   ; 6EFA: 87 1E 0F... ...
    EQUB &0F, &0F, &87, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F   ; 6F06: 0F 0F 87... ...
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F   ; 6F12: 0F 0F 0F... ...
    EQUB &0E, 1  , &0F, &0F, &0F, &0F, &0F, &0F, 7  , 8  , &0F, &0F   ; 6F1E: 0E 01 0F... ...
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &1E, &0F, &0F, &0F, &0F, &0F   ; 6F2A: 0F 0F 0F... ...
    EQUB &0F, &0F, &1E, &2D, &0F, &0F, &0F, &0F, &0F, &0F, &4B, &69   ; 6F36: 0F 0F 1E... ...
    EQUB &1E, &87, &0F, &1E, &0F, &0F, &F0, 8  , &1E, &C3, &2D, &3C   ; 6F42: 1E 87 0F... ...
    EQUB &1E, &2D, &F0, 0  , &F0, 0  , &78, &0C, &96, &0F, &C0, &40   ; 6F4E: 1E 2D F0... .-.
    EQUB &C0, &20, &E0, &30, &F0, &10, 0  , 0  , 0  , 0  , 0  , 0     ; 6F5A: C0 20 E0... . .
    EQUB &80, &C0, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6F66: 80 C0 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6F72: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6F7E: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6F8A: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6F96: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , &10, &30, 0  , 0  , 0  , 0  , 0  , &F0   ; 6FA2: 00 00 00... ...
    EQUB &80, 0  , 0  , 0  , 0  , 0  , 0  , &B0, &50, &20, 0  , 0     ; 6FAE: 80 00 00... ...
    EQUB 0  , 0  , 0  , &50, &A0, &D0, &20, &40, &90, &90             ; 6FBA: 00 00 00... ...
    EQUS "  @@"                                                       ; 6FC4: 20 20 40...   @
    EQUB &C0, &80, 0  , 0  , 0  , &10, &10, &20, 0  , 0  , &30, &60   ; 6FC8: C0 80 00... ...
    EQUB &80, &80, 0  , 0  , &40, &60, &E0, &30, &10, &10, 0  , 0     ; 6FD4: 80 80 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , &80, &80, 0  , 0  , 0  , 0     ; 6FE0: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0     ; 6FEC: 00 00 00... ...
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0                         ; 6FF8: 00 00 00... ...
COPYBLOCK &7900, &790E, &1200
.pydis_end

; Label references by decreasing frequency:
;     L0074:          28
;     L0076:          16
;     P:              14
;     L0075:          12
;     Q:              10
;     R:               6
;     L0079:           6
;     S:               5
;     L62C3:           5
;     L0077:           4
;     L007C:           4
;     L007D:           4
;     L0E50:           4
;     osbyte:          4
;     L0019:           3
;     L0040:           3
;     L0078:           3
;     L007A:           3
;     L007B:           3
;     C1278:           3
;     L1346:           3
;     L62CC:           3
;     C63F8:           3
;     C6401:           3
;     C6437:           3
;     L001F:           2
;     L003E:           2
;     L003F:           2
;     L05F5:           2
;     L0900:           2
;     L0901:           2
;     L0902:           2
;     L0A00:           2
;     L0A01:           2
;     L0A02:           2
;     C1230:           2
;     C1264:           2
;     sub_C508C:       2
;     L5E40:           2
;     L5E90:           2
;     L5F20:           2
;     L5F3D:           2
;     L5F3E:           2
;     L62CD:           2
;     C643B:           2
;     C6456:           2
;     C645B:           2
;     trackChecksum:   2
;     osword:          2
;     L003C:           1
;     L004E:           1
;     L0051:           1
;     L0058:           1
;     L007E:           1
;     L0083:           1
;     L0084:           1
;     L0085:           1
;     L05FE:           1
;     Entry:           1
;     entr1:           1
;     C120E:           1
;     C1247:           1
;     C1253:           1
;     C125D:           1
;     C1260:           1
;     L1279:           1
;     C1282:           1
;     C1288:           1
;     C12AA:           1
;     C12AD:           1
;     L12AE:           1
;     L12AF:           1
;     L12B4:           1
;     L12B9:           1
;     L12BE:           1
;     L12C3:           1
;     L12C8:           1
;     L1300:           1
;     L1302:           1
;     C136E:           1
;     C1379:           1
;     L13A0:           1
;     C13CB:           1
;     sub_C1400:       1
;     C140B:           1
;     C1413:           1
;     C141B:           1
;     C1423:           1
;     C142B:           1
;     C1433:           1
;     C143B:           1
;     C1443:           1
;     C1450:           1
;     C1453:           1
;     C145C:           1
;     C145F:           1
;     C1468:           1
;     C146B:           1
;     C1474:           1
;     C1477:           1
;     C1480:           1
;     C1483:           1
;     C148C:           1
;     C148F:           1
;     C1498:           1
;     C149B:           1
;     C14A2:           1
;     C14C2:           1
;     L3779:           1
;     L3B06:           1
;     L3FE0:           1
;     sub_C42D0:       1
;     sub_C503F:       1
;     C504F:           1
;     C509D:           1
;     loop_C50B0:      1
;     C50BC:           1
;     C50C0:           1
;     C50C6:           1
;     loop_C50D1:      1
;     C50E8:           1
;     sub_C50FA:       1
;     L5EE0:           1
;     L62A8:           1
;     L62BD:           1
;     L62D2:           1
;     L62E2:           1
;     L62F1:           1
;     C63BD:           1
;     C63D8:           1
;     C63DE:           1
;     C63E7:           1
;     C63EB:           1
;     C63F4:           1
;     C6423:           1
;     C6431:           1
;     C643D:           1
;     C6454:           1
;     L7900:           1
;     LFFFC:           1

; Automatically generated labels:
;     C0B6E
;     C0BCB
;     C0C0B
;     C0C13
;     C0C1B
;     C0C23
;     C0C2B
;     C0C33
;     C0C3B
;     C0C43
;     C0C50
;     C0C53
;     C0C5C
;     C0C5F
;     C0C68
;     C0C6B
;     C0C74
;     C0C77
;     C0C80
;     C0C83
;     C0C8C
;     C0C8F
;     C0C98
;     C0C9B
;     C0CA2
;     C0CC2
;     C120E
;     C1230
;     C1247
;     C1253
;     C125D
;     C1260
;     C1264
;     C1278
;     C1282
;     C1288
;     C12AA
;     C12AD
;     C136E
;     C1379
;     C13CB
;     C140B
;     C1413
;     C141B
;     C1423
;     C142B
;     C1433
;     C143B
;     C1443
;     C1450
;     C1453
;     C145C
;     C145F
;     C1468
;     C146B
;     C1474
;     C1477
;     C1480
;     C1483
;     C148C
;     C148F
;     C1498
;     C149B
;     C14A2
;     C14C2
;     C504F
;     C509D
;     C50BC
;     C50C0
;     C50C6
;     C50E8
;     C63BD
;     C63D8
;     C63DE
;     C63E7
;     C63EB
;     C63F4
;     C63F8
;     C6401
;     C6423
;     C6431
;     C6437
;     C643B
;     C643D
;     C6454
;     C6456
;     C645B
;     L0019
;     L001F
;     L003C
;     L003E
;     L003F
;     L0040
;     L004E
;     L0051
;     L0058
;     L0074
;     L0075
;     L0076
;     L0077
;     L0078
;     L0079
;     L007A
;     L007B
;     L007C
;     L007D
;     L007E
;     L0083
;     L0084
;     L0085
;     L05F5
;     L05FE
;     L0900
;     L0901
;     L0902
;     L0A00
;     L0A01
;     L0A02
;     L0B02
;     L0B46
;     L0BA0
;     L0D00
;     L0E50
;     L1279
;     L12AE
;     L12AF
;     L12B4
;     L12B9
;     L12BE
;     L12C3
;     L12C8
;     L1300
;     L1302
;     L1346
;     L13A0
;     L1500
;     L3779
;     L3B06
;     L3FE0
;     L5E40
;     L5E90
;     L5EE0
;     L5F20
;     L5F3D
;     L5F3E
;     L62A8
;     L62BD
;     L62C3
;     L62CC
;     L62CD
;     L62D2
;     L62E2
;     L62F1
;     L70DB
;     L7725
;     L7900
;     L7979
;     L79AE
;     L79FF
;     LFFFC
;     loop_C0B79
;     loop_C50B0
;     loop_C50D1
;     sub_C0C00
;     sub_C1400
;     sub_C42D0
;     sub_C503F
;     sub_C508C
;     sub_C50FA
    ASSERT <(L62C3) == &C3
    ASSERT >(L62C3) == &62
    ASSERT osbyte_read_adc_or_get_buffer_status == &80
    ASSERT osbyte_read_write_escape_break_effect == &C8
    ASSERT osbyte_tape == &8C
    ASSERT osword_envelope == &08
    ASSERT osword_read_char == &0A

SAVE "3-assembled-output/Revs.bin", pydis_start, pydis_end

\ ******************************************************************************
\
\ Save Revs.bin
\
\ ******************************************************************************

\SAVE "3-assembled-output/Revs.bin", LOAD%, P%

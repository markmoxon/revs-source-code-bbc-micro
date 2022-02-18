\ ******************************************************************************
\
\ REVS NURBURGRING TRACK SOURCE
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
\ REVS NURBURGRING TRACK
\
\ Produces the binary file Nurburgring.bin that contains the Nurburgring track.
\
\ ******************************************************************************

ORG CODE%

.trackData

 EQUB &01, &2E, &1F, &00, &2D, &FF, &00, &FF
 EQUB &13, &2E, &1D, &26, &2D, &4D, &26, &92
 EQUB &22, &2E, &18, &4E, &2D, &0E, &4E, &07
 EQUB &32, &31, &17, &50, &31, &2D, &51, &22
 EQUB &41, &35, &13, &5F, &34, &FF, &5E, &FF
 EQUB &53, &2B, &11, &72, &2A, &10, &71, &B5
 EQUB &55, &27, &0F, &7B, &26, &1F, &7A, &0F
 EQUB &55, &1D, &0D, &7E, &1E, &0C, &7D, &79
 EQUB &55, &16, &0B, &7C, &16, &18, &7B, &0D
 EQUB &64, &12, &09, &80, &11, &FF, &81, &FF
 EQUB &63, &15, &07, &89, &14, &58, &89, &70
 EQUB &73, &14, &00, &B2, &13, &1D, &B2, &0E
 EQUB &83, &1B, &03, &B3, &1C, &34, &B3, &FF
 EQUB &93, &1A, &0D, &96, &1C, &25, &96, &0F
 EQUB &93, &20, &14, &8D, &21, &00, &8E, &FF
 EQUB &93, &23, &15, &8B, &23, &21, &8C, &17
 EQUB &A3, &28, &18, &86, &29, &4B, &87, &9C
 EQUB &B3, &39, &21, &65, &3A, &1B, &65, &0F
 EQUB &C5, &3F, &20, &63, &3E, &17, &64, &A2
 EQUB &C4, &4B, &1E, &67, &4B, &20, &68, &12
 EQUB &D3, &52, &1B, &62, &54, &36, &62, &FF
 EQUB &E3, &55, &11, &42, &56, &32, &42, &1C
 EQUB &E2, &53, &10, &39, &54, &47, &38, &C1
 EQUB &F3, &40, &18, &18, &41, &13, &18, &07
 EQUB &F3, &40, &1A, &13, &41, &27, &13, &24
 EQUB &F3, &3E, &1E, &08, &3F, &1A, &08, &7F
 EQUB &F3, &37, &1F, &FD, &38, &1F, &FC, &10
 EQUB &30, &30, &0D, &21, &E8, &FF, &20, &FF
 EQUB &A5, &44, &20, &50, &34, &C9, &19, &B0
 EQUB &07, &A5, &0D, &10, &03, &4C, &55, &56
 EQUB &4C, &51, &B4, &08, &00, &12, &11, &08
 EQUB &08, &F0, &EC, &2D, &16, &04, &F0, &08

\ &5400

\ C64 addr -> BBC addr = value poked in (plus any related pokes)

\ &11FD -> &1249 = &5672 (also needs &11FC -> &1248 = &20)
\ &123E -> &128A = &5A1B
\ &138B -> &13CA = &5572
\ &13E8 -> &1427 = &5572
\ &12B0 -> &12FC = &54EB (also needs &12AF -> &12FB = &20)
\ &227C -> &2539 = &5772 (also needs &227B -> &2538 = &20)
\ &1578 -> &1594 = &59D9
\ &4D28 -> &4CD1 = &5562
\ &4D20 -> &4CC9 = &5662
\ &4D18 -> &4CC1 = &5762
\ &4526 -> &44D6 = &58A0
\ &4D2E -> &4CD7 = &5462
\ &4D38 -> &4CE1 = &5462
\ &B468 -> &1947 = &56C4
\ &2286 -> &2543 = &5555

\ modAddrLo
\ EQUB &FD, &3E, &8B, &E8, &B0, &7C, &78, &28
\ EQUB &20, &18, &26, &2E, &38, &68, &86

 EQUB &49, &8A, &CA, &27, &FC, &39, &94, &D1
 EQUB &C9, &C1, &D6, &D7, &E1, &47, &43

 EQUB &33, &3C, &4A, &57, &61 \ Unused

 \ &5414

\ modAddrHi
\ EQUB &11, &12, &13, &13, &12, &22, &15, &4D
\ EQUB &4D, &4D, &45, &4D, &4D, &B4, &22

 EQUB &12, &12, &13, &14, &12, &25, &15, &4C
 EQUB &4C, &4C, &44, &4C, &4C, &19, &25

 EQUB &2E, &3F, &4F, &57, &5B \ Unused

 EQUB &00, &00, &00, &00, &07, &00, &FD, &FE
 EQUB &FE, &00, &00, &00, &00, &FD, &05, &FF
 EQUB &FF, &00, &05, &00, &00, &FE, &00, &01
 EQUB &00, &00, &00, &00, &FC, &FC, &00, &03
 EQUB &00, &00, &00, &01, &00, &00, &00, &FC
 EQUB &03, &00, &00, &04, &04, &05, &05, &05
 EQUB &05, &05, &05, &07, &0B, &10, &14, &18
 EQUB &1C, &20, &01, &08, &14, &20, &35, &44
 EQUB &5B, &60, &6D, &7C, &8D, &90, &9C, &AC
 EQUB &B5, &D4

\ EQUB &AD, &FC, &53, &0A, &AD, &FD
\ EQUB &53, &2A, &48, &2A, &2A, &2A, &29, &07
\ EQUB &85, &75, &4A, &68, &29, &3F, &90, &04
\ EQUB &49, &3F, &69, &00, &AA, &BC, &BF, &57
\ EQUB &BD, &BF, &58, &AA, &A5, &75, &18, &69
\ EQUB &01, &29, &02, &D0, &06, &84, &76, &86
\ EQUB &77, &F0, &04, &86, &76, &84, &77, &A5
\ EQUB &75, &C9, &04, &90, &06, &A9, &00, &E5
\ EQUB &76, &85, &76, &A5, &75, &C9, &06, &B0
\ EQUB &0A, &C9, &02, &90, &06, &A9, &00, &E5
\ EQUB &77, &85, &77, &A4, &02, &A9, &9A, &85
\ EQUB &75, &A5, &76, &99, &00, &54, &20, &5C
\ EQUB &55, &99, &00, &58, &A5, &77, &99, &00
\ EQUB &56, &20, &5C, &55, &49, &FF, &18, &69
\ EQUB &01, &99, &00, &57, &AD, &FE, &53, &99
\ EQUB &00, &55, &60, &A5, &91, &29, &40, &F0
\ EQUB &03, &20, &82, &55, &A5, &24, &18, &69
\ EQUB &03, &60

.L5472
 LDA $53FC
 ASL A
 LDA $53FD
 ROL A
 PHA
 ROL A
 ROL A
 ROL A
 AND #$07
 STA $75
 LSR A
 PLA
 AND #$3F
 BCC L548C
 EOR #$3F
 ADC #$00
.L548C
 TAX
 LDY $57BF,X
 LDA $58BF,X
 TAX
 LDA $75
 CLC
 ADC #$01
 AND #$02
 BNE L54A3
 STY $76
 STX $77
 BEQ L54A7
.L54A3
 STX $76
 STY $77
.L54A7
 LDA $75
 CMP #$04
 BCC L54B3
 LDA #$00
 SBC $76
 STA $76
.L54B3
 LDA $75
 CMP #$06
 BCS L54C3
 CMP #$02
 BCC L54C3
 LDA #$00
 SBC $77
 STA $77
.L54C3
 LDY $02
 LDA #$9A
 STA $75
 LDA $76
 STA $5400,Y
 JSR $555C
 STA $5800,Y
 LDA $77
 STA $5600,Y
 JSR $555C
 EOR #$FF
 CLC
 ADC #$01
 STA $5700,Y
 LDA $53FE
 STA $5500,Y
 RTS

.L54EB
 LDA $91
 AND #$40
 BEQ L54F4
 JSR $5582
.L54F4
 LDA $24
 CLC
 ADC #$03
 RTS

EQUB &0C, &08, &03, &FE, &FB, &00

\ &5500

\ Value to poke into modAddr
 EQUB &72, &1B, &72, &72, &EB, &72, &D9, &62
 EQUB &62, &62, &A0, &62, &62, &C4, &55

 EQUB &00, &00, &00, &00, &00 \ Unused

\ Value to poke into modAddr+1
 EQUB &56, &5A, &55, &55, &54, &57, &59, &55
 EQUB &56, &57, &58, &54, &54, &56, &55

 EQUB &00, &00, &00, &00, &00 \ Unused

 EQUB &00, &00, &00, &00, &E8, &00, &54, &C6
 EQUB &C6, &00, &00, &00, &00, &8F, &9E, &B7
 EQUB &B7, &00, &93, &00, &00, &37, &00, &AD
 EQUB &00, &00, &00, &00, &09, &09, &00, &68
 EQUB &00, &00, &00, &45, &00, &00, &00, &9B
 EQUB &9C, &F6, &00, &35, &35, &85, &75, &A9
 EQUB &CD, &4C, &00, &0C, &08, &4C, &6B, &46
 EQUB &FC, &FC, &01, &FA, &FB, &09, &1C, &06
 EQUB &09, &FE, &00, &03, &DF, &FB, &FA, &FF
 EQUB &D9, &1F

\ EQUB &A5, &91, &29, &40, &F0, &06, &20, &A1
\ EQUB &13, &20, &BD, &55, &60, &20, &A1, &13
\ EQUB &AC, &FA, &53, &AD, &FF, &53, &38, &24
\ EQUB &25, &30, &13, &69, &00, &D9, &28, &57
\ EQUB &90, &22, &A9, &00, &C8, &CC, &FB, &53
\ EQUB &90, &1A, &A0, &00, &F0, &16, &E9, &01
\ EQUB &B0, &12, &98, &29, &7F, &A8, &C0, &01
\ EQUB &B0, &03, &AC, &FB, &53, &88, &B9, &28
\ EQUB &57, &38, &E9, &01, &8D, &FF, &53, &8C
\ EQUB &FA, &53, &60, &86, &45, &AC, &FA, &53
\ EQUB &30, &2F, &B9, &28, &55, &85, &74, &B9
\ EQUB &28, &54, &24, &25, &20, &40, &0E, &85
\ EQUB &75, &A5, &74, &18, &6D, &FC, &53, &8D
\ EQUB &FC, &53, &A5, &75, &6D, &FD, &53, &8D
\ EQUB &FD, &53, &B9, &28, &56, &24, &25, &20
\ EQUB &50, &34, &18, &6D, &FE, &53, &8D, &FE
\ EQUB &53, &20, &72, &54, &A6, &45, &60

.L5572
 LDA $91
 AND #$40
 BEQ L557E
 JSR $13A1
 JSR L55BD
.L557E
 RTS
 JSR $13A1
 LDY $53FA
 LDA $53FF
 SEC
 BIT $25
 BMI L55A0
 ADC #$00
 CMP $5728,Y
 BCC L55B6
 LDA #$00
 INY
 CPY $53FB
 BCC L55B6
 LDY #$00
 BEQ L55B6
.L55A0
 SBC #$01
 BCS L55B6
 TYA
 AND #$7F
 TAY
 CPY #$01
 BCS L55AF
 LDY $53FB
.L55AF
 DEY
 LDA $5728,Y
 SEC
 SBC #$01
.L55B6
 STA $53FF
 STY $53FA
 RTS
.L55BD
 STX $45
 LDY $53FA
 BMI L55F3
 LDA $5528,Y
 STA $74
 LDA $5428,Y
 BIT $25
 JSR $0E40
 STA $75
 LDA $74
 CLC
 ADC $53FC
 STA $53FC
 LDA $75
 ADC $53FD
 STA $53FD
 LDA $5628,Y
 BIT $25
 JSR $3450
 CLC
 ADC $53FE
 STA $53FE
.L55F3
 JSR $5472
 LDX $45
 RTS

 EQUB &0D, &0A, &07, &03, &00, &00, &00

\ &5600

\ EQUB &A9, &04, &8D, &74, &35, &A9, &0B, &8D
\ EQUB &F4, &35, &A9, &AD, &8D, &1C, &46, &A9
\ EQUB &57, &8D, &1D, &46, &A9, &4B, &8D, &46
\ EQUB &25, &A9, &FF, &8D, &2B, &28, &60

 LDA #&04
 STA &3574      \ Same, changes 0 to 4

 LDA #&0B
 STA &35F4      \ Same, changes 3 to &B

\ &461C/D -> &45CC/D = &57AD (also needs &461B -> &45CB = &20)

\ LDA #&AD
\ STA &461C
\ LDA #&57
\ STA &461D

 LDA #&AD
 STA &45CC
 LDA #&57
 STA &45CD

\ &2546 -> &2772 = &4B

\ LDA #&4B
\ STA &2546

 LDA #&4B
 STA &2772

\ &282B -> &298E = &FF

\ LDA #&FF
\ STA &282B

 LDA #&FF
 STA &298E

 RTS

 EQUB &6F
 EQUB &73, &75, &74, &6F, &66, &5B, &52, &4E
 EQUB &00, &00, &FF, &00, &00, &00, &00, &00
 EQUB &01, &01, &00, &00, &FF, &00, &00, &00
 EQUB &01, &01, &01, &00, &01, &00, &00, &FF
 EQUB &00, &FF, &FE, &00, &00, &00, &00, &FF
 EQUB &FF, &00, &01, &01, &00, &01, &00, &00
 EQUB &FF, &FF, &FF, &00, &FF, &AD, &FF, &88
 EQUB &C9, &30, &B0, &03, &46, &76, &60, &4C
 EQUB &51, &B4, &F8, &06, &43, &23, &27, &0C
 EQUB &16, &FA, &A6, &09, &FA, &08, &09, &5D
 EQUB &1B, &F5

\ EQUB &84, &1B, &B9, &05, &59, &85
\ EQUB &02, &98, &4A, &4A, &4A, &A8, &B9, &46
\ EQUB &58, &8D, &FC, &53, &B9, &64, &58, &8D
\ EQUB &FD, &53, &B9, &28, &58, &8D, &FE, &53
\ EQUB &B9, &82, &58, &4A, &6A, &8D, &FA, &53
\ EQUB &A9, &0E, &6A, &8D, &C0, &20, &A9, &00
\ EQUB &8D, &FF, &53, &24, &25, &30, &03, &20
\ EQUB &BD, &55, &A4, &1B, &A5, &02, &60, &85
\ EQUB &75, &68, &20, &00, &0C, &28, &F0, &09
\ EQUB &85, &75, &20, &00, &0C, &06, &74, &2A
\ EQUB &60, &4C, &00, &0C, &98, &29, &20, &85
\ EQUB &82, &A9, &00, &85, &7F, &88, &B9, &E0
\ EQUB &84, &C5, &1F, &B0, &1E, &C5, &7F, &B0
\ EQUB &F2, &A5, &7F, &69, &00, &99, &E0, &84
\ EQUB &A5, &82, &D0, &E9, &A5, &7F, &8D, &0C
\ EQUB &1B, &C8, &20, &7E, &22, &88, &38, &66
\ EQUB &82, &30, &DA, &A4, &4B, &88, &84, &75
\ EQUB &4C, &E0, &53

.L5672
 STY $1B
 LDA $5905,Y
 STA $02
 TYA
 LSR A
 LSR A
 LSR A
 TAY
 LDA $5846,Y
 STA $53FC
 LDA $5864,Y
 STA $53FD
 LDA $5828,Y
 STA $53FE
 LDA $5882,Y
 LSR A
 ROR A
 STA $53FA
 LDA #$0E
 ROR A
 STA $20C0
 LDA #$00
 STA $53FF
 BIT $25
 BMI L56AA
 JSR $55BD
.L56AA
 LDY $1B
 LDA $02
 RTS
 STA $75
 PLA
 JSR $0C00
 PLP
 BEQ L56C1
 STA $75
 JSR $0C00
 ASL $74
 ROL A
 RTS
.L56C1
 JMP $0C00
 TYA
 AND #$20
 STA $82
 LDA #$00
.L56CB
 STA $7F
.L56CD
 DEY
 LDA $84E0,Y
 CMP $1F
 BCS L56F3
 CMP $7F
 BCS L56CB
 LDA $7F
 ADC #$00
 STA $84E0,Y
 LDA $82
 BNE L56CD
 LDA $7F
 STA $1B0C
 INY
 JSR $227E
 DEY
 SEC
 ROR $82
 BMI L56CD
.L56F3
 LDY $4B
 DEY
 STY $75
 JMP $53E0

 EQUB &78, &78, &78, &78, &00

\ &5700

\ EQUB &A2, &0E, &BD, &14, &54, &85, &75, &BD
\ EQUB &00, &54, &85, &74, &A0, &00, &BD, &00
\ EQUB &55, &91, &74, &C8, &BD, &14, &55, &91
\ EQUB &74, &CA, &10, &E6, &4C, &00, &58

 LDX #&0E

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
 JMP &5800

 EQUB &AE
 EQUB &AB, &AA, &AD, &B2, &BA, &C3, &C6, &C8
 EQUB &53, &28, &16, &16, &07, &02, &14, &0A
 EQUB &07, &0B, &22, &03, &13, &18, &10, &2F
 EQUB &22, &09, &19, &26, &17, &19, &06, &0F
 EQUB &23, &0C, &1A, &08, &07, &08, &1C, &16
 EQUB &06, &24, &1B, &14, &15, &31, &0A, &0C
 EQUB &07, &11, &1D, &15, &04, &57, &57, &57
 EQUB &57, &57, &57, &57, &57, &57, &56, &55
 EQUB &55, &54, &48, &0D, &B5, &DF, &CA, &FD
 EQUB &B7, &14, &3D, &04, &40, &FD, &03, &49
 EQUB &BE, &29

\ EQUB &8D, &0C, &1B, &99, &08, &85
\ EQUB &B9, &00, &84, &38, &F9, &28, &84, &B9
\ EQUB &50, &84, &F9, &78, &84, &10, &0C, &B9
\ EQUB &00, &84, &99, &28, &84, &B9, &50, &84
\ EQUB &99, &78, &84, &B9, &E0, &84, &99, &08
\ EQUB &85, &C0, &06, &B0, &08, &A9, &00, &99
\ EQUB &A0, &84, &99, &C8, &84, &C8, &C0, &09
\ EQUB &90, &CE, &A4, &51, &60

.L5772
 STA $1B0C
 STA $8508,Y
.L5778
 LDA $8400,Y
 SEC
 SBC $8428,Y
 LDA $8450,Y
 SBC $8478,Y
 BPL L5793
 LDA $8400,Y
 STA $8428,Y
 LDA $8450,Y
 STA $8478,Y
.L5793
 LDA $84E0,Y
 STA $8508,Y
 CPY #$06
 BCS L57A5
 LDA #$00
 STA $84A0,Y
 STA $84C8,Y
.L57A5
 INY
 CPY #$09
 BCC L5778
 LDY $51
 RTS

\ EQUB &D0, &09, &A5
\ EQUB &63, &20, &60, &46, &10, &02, &C6, &77
\ EQUB &0A, &26, &77, &60

.L57AD

 BNE L57B8
 LDA $63

\ &4660 -> &4610

\ JSR $4660

 JSR &4610

 BPL L57B8
 DEC $77

.L57B8

 ASL A
 ROL $77
 RTS

 EQUB &F6, &F3, &F0, &00
 EQUB &01, &03, &04, &06, &07, &09, &0A, &0C
 EQUB &0D, &0F, &10, &12, &13, &15, &16, &17
 EQUB &19, &1A, &1C, &1D, &1F, &20, &21, &23
 EQUB &24, &26, &27, &28, &2A, &2B, &2D, &2E
 EQUB &2F, &31, &32, &33, &35, &36, &37, &39
 EQUB &3A, &3B, &3C, &3E, &3F, &40, &41, &43
 EQUB &44, &45, &46, &47, &49, &4A, &4B, &4C
 EQUB &4D, &4E, &4F, &51, &52, &53, &54, &55

\ &5800

\ EQUB &A9, &20, &8D, &FC, &11, &8D, &AF, &12
\ EQUB &8D, &7B, &22, &8D, &1B, &46, &A9, &EA
\ EQUB &8D, &88, &22, &A9, &A2, &8D, &0B, &1B
\ EQUB &4C, &00, &56

\ &11FC -> &1248 = &20
\ &12AF -> &12FB = &20
\ &227B -> &2538 = &20
\ &461B -> &45CB = &20

\ LDA #&20
\ STA &11FC
\ STA &12AF
\ STA &227B
\ STA &461B

 LDA #&20
 STA &1248
 STA &12FB
 STA &2538
 STA &45CB

\ &2288 -> &2545 = &EA

\ LDA #&EA
\ STA &2288

 LDA #&EA
 STA &2545

\ &1B0B -> &1FE9 = &A2

\ LDA #&A2
\ STA &1B0B

 LDA #&A2
 STA &1FE9

 JMP &5600

 EQUB &3A, &34, &2D, &25, &1E
 EQUB &16, &0E, &1B, &28, &34, &3E, &41, &43
 EQUB &FA, &FA, &E4, &E4, &EB, &F6, &E3, &E3
 EQUB &E3, &E3, &E3, &0E, &27, &3E, &3E, &3E
 EQUB &2F, &EF, &EF, &EF, &D9, &EE, &02, &33
 EQUB &33, &1B, &FE, &47, &44, &41, &00, &00
 EQUB &00, &58, &0E, &0E, &0E, &76, &76, &56
 EQUB &56, &3D, &98, &98, &F7, &F7, &1A, &1A
 EQUB &A1, &A1, &91, &91, &F5, &F5, &39, &D3
 EQUB &D3, &19, &1C, &1E, &00, &00, &00, &37
 EQUB &ED, &ED, &ED, &B2, &B2, &0C, &0C, &F5
 EQUB &80, &80, &53, &53, &6D, &6D, &31, &31
 EQUB &7C, &7C, &95, &95, &6D, &96, &96, &C3
 EQUB &BF, &BC, &00, &04, &12, &1A, &26, &2E
 EQUB &36, &3B, &3A, &3F, &3E, &4A, &4E, &56
 EQUB &5A, &5E, &60, &72, &7A, &7E, &82, &8E
 EQUB &92, &9E, &A2, &AA, &AE, &D3, &D3, &D3
 EQUB &18, &18, &67, &48, &19, &19, &52, &30
 EQUB &47, &18, &18, &3B, &19, &3C, &00, &3D
 EQUB &19, &52, &50, &53, &18, &3D, &21, &6A
 EQUB &71, &18, &43, &18, &A9, &AA, &AA, &78
 EQUB &78, &78, &78, &78, &78, &78, &78, &77
 EQUB &77, &77, &77, &77, &76, &76, &76, &76
 EQUB &75, &75, &75, &74, &74, &74, &73, &73
 EQUB &72, &72, &71, &71, &70, &70, &6F, &6F
 EQUB &6E, &6E, &6D, &6C, &6C, &6B, &6B, &6A
 EQUB &69, &68, &68, &67, &66, &65, &65, &64
 EQUB &63, &62, &61, &60, &60, &5F, &5E, &5D
 EQUB &5C, &5B, &5A, &59, &58, &57, &56, &55

\ &5900

 EQUB &42, &E0, &40, &00, &BF, &01, &00, &53
 EQUB &70, &E0, &4E, &E8, &BF, &05, &E8, &54
 EQUB &ED, &E0, &75, &48, &BF, &0A, &48, &09
 EQUB &73, &E8, &79, &AB, &A9, &14, &C4, &25
 EQUB &44, &79, &89, &34, &77, &12, &B2, &2D
 EQUB &68, &FB, &90, &03, &F9, &18, &81, &16
 EQUB &F3, &57, &F6, &35, &55, &07, &B3, &18
 EQUB &34, &AB, &3E, &C1, &0B, &20, &B1, &10
 EQUB &ED, &9B, &6E, &41, &FB, &22, &31, &10
 EQUB &02, &85, &9E, &C3, &70, &0B, &17, &13
 EQUB &70, &1E, &77, &4C, &09, &0C, &A0, &5A
 EQUB &ED, &5D, &F7, &D6, &45, &16, &89, &19
 EQUB &6A, &24, &9A, &41, &44, &07, &3E, &3D
 EQUB &73, &E7, &F9, &A9, &07, &1C, &A6, &19
 EQUB &40, &D8, &07, &3B, &5C, &0D, &3C, &06
 EQUB &6D, &5A, &7B, &F1, &DE, &13, &F2, &0F
 EQUB &6A, &1C, &A5, &EA, &1D, &22, &6B, &51
 EQUB &F3, &32, &40, &0F, &33, &23, &90, &0F
 EQUB &74, &4A, &41, &06, &E4, &0A, &13, &1C
 EQUB &ED, &8A, &65, &9E, &24, &26, &AB, &16
 EQUB &72, &E5, &F2, &8F, &05, &14, &A7, &45
 EQUB &6D, &97, &5A, &37, &B7, &09, &4F, &14
 EQUB &6A, &6F, &C4, &41, &69, &1D, &B0, &50
 EQUB &F3, &AF, &17, &C1, &A9, &1D, &30, &0C
 EQUB &6D, &BC, &7B, &5C, &BD, &01, &DD, &18
 EQUB &70, &48, &17, &C0, &3D, &19, &28, &1D
 EQUB &ED, &25, &73, &32, &1A, &0E, &9A, &19
 EQUB &42

\ EQUB &08, &48, &A4, &6F, &B9, &E8, &88
\ EQUB &A0, &B5, &C9, &58, &D0, &02, &A0, &D4
\ EQUB &C9, &40, &D0, &02, &A0, &CD, &C9, &D0
\ EQUB &D0, &02, &A0, &CA, &98, &4C, &AF, &56

.L59D9
 PHP
 PHA
 LDY $6F
 LDA $88E8,Y
 LDY #$B5
 CMP #$58
 BNE L59E8
 LDY #$D4
.L59E8
 CMP #$40
 BNE L59EE
 LDY #$CD
.L59EE
 CMP #$D0
 BNE L59F4
 LDY #$CA
.L59F4
 TYA
 JMP $56AF

 EQUB &B5, &B8, &D8, &28, &D6, &03, &B0, &03

\ &5A00

 EQUB &45, &41, &00, &01, &01, &00, &48, &00
 EQUB &48, &2F, &28, &23, &1E, &A8, &00, &A8
 EQUB &6F, &5D, &52, &46, &C2, &D3, &DC, &04
 EQUB &21, &19, &00, &20, &7F, &55, &4C, &72
 EQUB &54, &00

.CallTrackHook

 JMP &5700
\ JMP &9C00

.trackChecksum

 EQUB &60, &00, &00, &78

 EQUS "REVS"            \ Game name

 EQUS "Nurburgring"     \ Track name
 EQUB 13

\ EQUB &00, &00, &00, &00, &00, &00, &00
\ EQUB &4C, &00, &57, &00, &00, &00, &00, &00
\ EQUB &00, &00, &00, &00, &00, &00, &00, &00
\ EQUB &00, &00, &00, &00, &00, &00, &00, &00
\ EQUB &00, &00, &00, &00, &00, &00, &00, &00
\ EQUB &00, &00, &00, &00, &00, &00, &00, &00
\ EQUB &00, &00, &00, &00, &00, &00, &00, &00
\ EQUB &00, &00, &00, &00, &00, &00, &00, &00
\ EQUB &00, &00, &00, &00, &00, &00, &00, &00
\ EQUB &00, &00, &00, &00, &00, &00, &00, &00
\ EQUB &00, &00, &00, &00, &00, &00, &00, &00
\ EQUB &92, &5D, &28, &00, &03, &33, &00, &8B
\ EQUB &3B, &80, &00, &00, &8B, &3B, &80, &00
\ EQUB &00, &8B, &3B, &80, &00, &00, &8B, &47
\ EQUB &A0, &00, &00, &8B, &55, &E4, &00, &00
\ EQUB &8B, &2F, &EC, &00, &00, &8B, &1D, &5C
\ EQUB &00, &00, &8A, &6D, &58, &00, &00, &8A
\ EQUB &34, &D8, &00, &00, &8A, &14, &28, &00
\ EQUB &00, &8A, &28, &F0, &00, &00, &8A, &22
\ EQUB &E8, &00, &00, &8A, &59, &20, &00, &00
\ EQUB &8A, &57, &38, &00, &00, &8B, &03, &60
\ EQUS "NURBURGRING"
\ EQUB &FF

\ ******************************************************************************
\
\ Save Nurburgring.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/Nurburgring.bin", CODE%, P%

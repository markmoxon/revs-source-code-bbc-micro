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

CODE% = &0B00           \ The address of the main game code

\ ******************************************************************************
\
\ REVS MAIN GAME CODE
\
\ Produces the binary file Revs.bin that contains the main game code.
\
\ ******************************************************************************

ORG CODE%

osword_envelope = &08
osbyte_inkey = &81
osbyte_flush_buffer = &15
osbyte_read_adc_or_get_buffer_status = &80
osbyte_set_cursor_editing = &04
osbyte_read_write_adc_conversion_type = &BE
osbyte_write_video_ula_control = &9A
osword_read_char = &0A
osbyte_select_input_stream = &02
osbyte_acknowledge_escape = &7E
osbyte_read_write_escape_break_effect = &C8
osbyte_tape = &8C

L0000 = &0000
L0001 = &0001
L0002 = &0002
L0003 = &0003
L0004 = &0004
L0005 = &0005
L0006 = &0006
L0007 = &0007
L0008 = &0008
L0009 = &0009
L000A = &000A
L000B = &000B
L000C = &000C
L000D = &000D
L000E = &000E
L000F = &000F
L0010 = &0010
L0011 = &0011
L0012 = &0012
L0013 = &0013
L0014 = &0014
L0015 = &0015
L0016 = &0016
L0017 = &0017
L0018 = &0018
L0019 = &0019
L001A = &001A
L001B = &001B
L001C = &001C
L001D = &001D
L001E = &001E
L001F = &001F
L0020 = &0020
L0021 = &0021
L0022 = &0022
L0023 = &0023
L0024 = &0024
L0025 = &0025
L0026 = &0026
L0027 = &0027
L0028 = &0028
L0029 = &0029
L002A = &002A
L002B = &002B
L002C = &002C
L002D = &002D
L002E = &002E
L002F = &002F
L0030 = &0030
L0031 = &0031
L0032 = &0032
L0033 = &0033
L0034 = &0034
L0035 = &0035
L0036 = &0036
L0037 = &0037
L0038 = &0038
L0039 = &0039
L003A = &003A
L003B = &003B
L003C = &003C
L003D = &003D
L003E = &003E
L003F = &003F
L0040 = &0040
L0041 = &0041
L0042 = &0042
L0043 = &0043
L0044 = &0044
L0045 = &0045
L0046 = &0046
L0047 = &0047
L0048 = &0048
L0049 = &0049
L004A = &004A
L004B = &004B
L004C = &004C
L004D = &004D
L004E = &004E
L004F = &004F
L0050 = &0050
L0051 = &0051
L0052 = &0052
L0053 = &0053
L0054 = &0054
L0055 = &0055
L0056 = &0056
L0057 = &0057
L0058 = &0058
L0059 = &0059
L005A = &005A
L005B = &005B
L005C = &005C
L005D = &005D
L005E = &005E
L005F = &005F
L0060 = &0060
L0061 = &0061
L0062 = &0062
L0063 = &0063
L0064 = &0064
L0065 = &0065
L0066 = &0066
L0067 = &0067
L0068 = &0068
L0069 = &0069
L006A = &006A
L006B = &006B
L006C = &006C
L006D = &006D
L006E = &006E
L006F = &006F
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
L007F = &007F
L0080 = &0080
L0081 = &0081
L0082 = &0082
L0083 = &0083
L0084 = &0084
L0085 = &0085
L0086 = &0086
L0087 = &0087
L0088 = &0088
L008A = &008A
L008B = &008B
L008C = &008C
L008D = &008D
L008E = &008E
L008F = &008F
L00FC = &00FC
L0100 = &0100
L0101 = &0101
L0114 = &0114
L0128 = &0128
L013B = &013B
L013C = &013C
L014F = &014F
L0150 = &0150
L0164 = &0164
L0178 = &0178
L018C = &018C
L01A4 = &01A4
irq1v = &0204
L0380 = &0380
L0397 = &0397
L0398 = &0398
L03AF = &03AF
L03B0 = &03B0
L03C8 = &03C8
L0400 = &0400
L0450 = &0450
L04A0 = &04A0
L04B4 = &04B4
L04C8 = &04C8
L04DC = &04DC
L04F0 = &04F0
L0504 = &0504
L0554 = &0554
L05A4 = &05A4
L05F4 = &05F4
L05F5 = &05F5
L05F6 = &05F6
L05F7 = &05F7
L05F8 = &05F8
L05FE = &05FE
L0600 = &0600
L0650 = &0650
L068A = &068A
L06A0 = &06A0
L06B4 = &06B4
L06B8 = &06B8
L06CC = &06CC
L06D0 = &06D0
L06E4 = &06E4
L06E8 = &06E8
L06FF = &06FF
L0700 = &0700
L0701 = &0701
L0702 = &0702
L0780 = &0780
L07A8 = &07A8
L07D0 = &07D0
L0880 = &0880
L0897 = &0897
L0898 = &0898
L08AC = &08AC
L08D0 = &08D0
L08E8 = &08E8
L0900 = &0900
L0901 = &0901
L0902 = &0902
L0978 = &0978
L0979 = &0979
L097A = &097A
L09FA = &09FA
L09FD = &09FD
L09FE = &09FE
L0A00 = &0A00
L0A01 = &0A01
L0A02 = &0A02
L0A78 = &0A78
L0A79 = &0A79
L0A7A = &0A7A
L0AFA = &0AFA
L0AFD = &0AFD
L0AFE = &0AFE
L5E40 = &5E40
L5E41 = &5E41
L5E50 = &5E50
L5E8F = &5E8F
L5E90 = &5E90
L5E91 = &5E91
L5EA0 = &5EA0
L5EB8 = &5EB8
L5EDF = &5EDF
L5EE0 = &5EE0
L5EE1 = &5EE1
L5EF8 = &5EF8
L5F00 = &5F00
L5F20 = &5F20
L5F21 = &5F21
L5F38 = &5F38
L5F39 = &5F39
L5F3A = &5F3A
L5F3B = &5F3B
L5F3C = &5F3C
L5F3D = &5F3D
L5F3E = &5F3E
L5F3F = &5F3F
L5F40 = &5F40
L5F48 = &5F48
L5F60 = &5F60
L5FB0 = &5FB0
L713D = &713D
L7205 = &7205
L77DB = &77DB
L77DC = &77DC
L77E3 = &77E3
L77E4 = &77E4
trackChecksum = &7800
L7B00 = &7B00
L7B4A = &7B4A
L7B9C = &7B9C
L7BE2 = &7BE2
L7C79 = &7C79
L7E85 = &7E85
L7FC5 = &7FC5
crtc_horz_total = &FE00
crtc_horz_displayed = &FE01
video_ula_control = &FE20
video_ula_palette = &FE21
system_via_t1c_h = &FE45
system_via_t1l_l = &FE46
system_via_t1l_h = &FE47
system_via_acr = &FE4B
system_via_ifr = &FE4D
system_via_ier = &FE4E
user_via_t1c_l = &FE64
user_via_t1c_h = &FE65
user_via_t1l_l = &FE66
user_via_t1l_h = &FE67
user_via_t2c_l = &FE68
user_via_t2c_h = &FE69
user_via_acr = &FE6B
user_via_ifr = &FE6D
user_via_ier = &FE6E
osrdch = &FFE0
oswrch = &FFEE
osword = &FFF1
osbyte = &FFF4
LFFFC = &FFFC

    ORG &0B00

.soundEnvelopes
.pydis_start
L0B02 = soundEnvelopes+2
L0B1C = soundEnvelopes+28
L0B24 = soundEnvelopes+36
L0B2C = soundEnvelopes+44
L0B44 = soundEnvelopes+68
L0B46 = soundEnvelopes+70
L0B47 = soundEnvelopes+71
    EQUB &10, &10, &10, &10, &10, &10, &10, &10
    EQUB &10, &10, &10, &10, &10, &10, &10, &10
    EQUB &10, 0  , &F6, &FF, 3  , 0  , &FF, 0  
    EQUB &11, 0  , &F6, &FF, &BB, 0  , &FF, 0  
    EQUB &12, 0  , &F6, &FF, &28, 0  , &FF, 0  
    EQUB &13, 0  , 1  , 0  , &82, 0  , &FF, 0  
    EQUB &10, 0  , &F6, &FF, 6  , 0  , 4  , 0  
    EQUB 1  , 1  , 2  , &FE, &FA, 4  , 1  , 1  
    EQUB &0A, 0  , 0  , 0  , &48, 0  , &FF, &AC
    EQUB &FE, 5  
; overlapping: LDY L05FE
.sub_C0B4A
    STX L0B46
    ASL A
    ASL A
    ASL A
    CLC
    ADC #&10
    TAX
    TYA
    STA L0B02,X
    LDA soundEnvelopes,X
    AND #3
    TAY
    LDA #7
    STA L62BD,Y
    BNE C0B6E
.sub_C0B65
    STX L0B46
    CLC
    ADC #&38 ; '8'
    TAX
    LDA #osword_envelope
.C0B6E
    LDY #&0B
    JSR osword
    LDX L0B46
    RTS

.sub_C0B77
    LDX #1
.loop_C0B79
    LDA L5F3D,X
    ASL A
    ASL A
    STA L0075
    LDA L0BA0,X
    JSR sub_C0C00
    CLC
    ADC #&5A ; 'Z'
    STA L62A8,X
    DEX
    BPL loop_C0B79
    LDA L5F3E
    ASL A
    ADC L5F3E
    ADC L5F3D
    LSR A
    ADC #&3C ; '<'
    STA L62F1
    RTS

.L0BA0
    EQUB &CD, &CD
.sub_C0BA2
    LDA #0
    STA L5EE0,Y
    LDA L5E40,Y
    SEC
    SBC L62D2
    STA L5E40,Y
    LDA L5E90,Y
    SBC L62E2
    STA L5E90,Y
    LDA L5F20,Y
    SEC
    SBC L004E
    STA L5F20,Y
    CMP L001F
    BCC C0BCB
    STA L001F
    STY L0051
.C0BCB
    RTS

.sub_C0BCC
    LDA L0900,Y
    CLC
    ADC L0074
    STA L0900,X
    LDA L0A00,Y
    ADC L0083
    STA L0A00,X
    LDA L0901,Y
    CLC
    ADC L0075
    STA L0901,X
    LDA L0A01,Y
    ADC L0084
    STA L0A01,X
    LDA L0902,Y
    CLC
    ADC L0076
    STA L0902,X
    LDA L0A02,Y
    ADC L0085
    STA L0A02,X
    RTS

.sub_C0C00
    STA L0074
.sub_C0C02
    LDA #0
    LSR L0074
    BCC C0C0B
    CLC
    ADC L0075
.C0C0B
    ROR A
    ROR L0074
    BCC C0C13
    CLC
    ADC L0075
.C0C13
    ROR A
    ROR L0074
    BCC C0C1B
    CLC
    ADC L0075
.C0C1B
    ROR A
    ROR L0074
    BCC C0C23
    CLC
    ADC L0075
.C0C23
    ROR A
    ROR L0074
    BCC C0C2B
    CLC
    ADC L0075
.C0C2B
    ROR A
    ROR L0074
    BCC C0C33
    CLC
    ADC L0075
.C0C33
    ROR A
    ROR L0074
    BCC C0C3B
    CLC
    ADC L0075
.C0C3B
    ROR A
    ROR L0074
    BCC C0C43
    CLC
    ADC L0075
.C0C43
    ROR A
    ROR L0074
    RTS

.sub_C0C47
    ASL L0074
    ROL A
    BCS C0C50
    CMP L0076
    BCC C0C53
.C0C50
    SBC L0076
    SEC
.C0C53
    ROL L0074
    ROL A
    BCS C0C5C
    CMP L0076
    BCC C0C5F
.C0C5C
    SBC L0076
    SEC
.C0C5F
    ROL L0074
    ROL A
    BCS C0C68
    CMP L0076
    BCC C0C6B
.C0C68
    SBC L0076
    SEC
.C0C6B
    ROL L0074
    ROL A
    BCS C0C74
    CMP L0076
    BCC C0C77
.C0C74
    SBC L0076
    SEC
.C0C77
    ROL L0074
    ROL A
    BCS C0C80
    CMP L0076
    BCC C0C83
.C0C80
    SBC L0076
    SEC
.C0C83
    ROL L0074
    ROL A
    BCS C0C8C
    CMP L0076
    BCC C0C8F
.C0C8C
    SBC L0076
    SEC
.C0C8F
    ROL L0074
    ROL A
    BCS C0C98
    CMP L0076
    BCC C0C9B
.C0C98
    SBC L0076
    SEC
.C0C9B
    ROL L0074
    ROL A
    BCS C0CA2
    CMP L0076
.C0CA2
    ROL L0074
    RTS

.C0CA5
    LDA L007E
    CMP #&67 ; 'g'
    BCS C0CC2
    LDA L0078
    LSR L0079
    ROR A
    LSR L0079
    ROR A
    LSR L0079
    ROR A
    CLC
    ADC L007A
    STA L007C
    LDA L0079
    ADC L007B
    STA L007D
    RTS

.C0CC2
    LSR L0079
    ROR L0078
    LDA L007B
    STA L0074
    LDA L007A
    LSR L0074
    ROR A
    LSR L0074
    ROR A
    LSR L0074
    ROR A
    STA L0075
    LDA L0078
    CLC
    ADC L007A
    STA L007C
    LDA L0079
    ADC L007B
    STA L007D
    LDA L007C
    SEC
    SBC L0075
    STA L007C
    LDA L007D
    SBC L0074
    STA L007D
    RTS

    EQUB &F1, &0C, &E5, &74, &8D, &F6, &0C, &60
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , &40
.sub_C0D01
    STA L007B
    STX L0074
    JSR sub_C0DB3
    STA L0078
    LDA L0075
    STA L0079
    LDX #1
    STX L0042
    LDX #0
    BIT L007B
    BVC C0D1B
    INX
    DEC L0042
.C0D1B
    CMP #&7A ; 'z'
    BCC C0D27
    BCS C0D4F
    LDA L0078
    CMP #&F0
    BCS C0D4F
.C0D27
    LDA #&AB
    JSR sub_C0C00
    JSR sub_C0C00
    STA L0076
    JSR sub_C0DBF
    LDA L0078
    SEC
    SBC L0074
    STA L0074
    LDA L0079
    SBC L0075
    ASL L0074
    ROL A
    STA L62A3,X
    LDA L0074
    AND #&FE
    STA L62A0,X
    JMP C0D7F

.C0D4F
    LDA #0
    SEC
    SBC L0078
    STA L0074
    LDA #&C9
    SBC L0079
    STA L0075
    STA L0076
    JSR sub_C0DBF
    ASL L0074
    ROL L0075
    LDA #0
    SEC
    SBC L0074
    AND #&FE
    STA L62A0,X
    LDA #0
    SBC L0075
    BCC C0D7C
    LDA #&FE
    STA L62A0,X
    LDA #&FF
.C0D7C
    STA L62A3,X
.C0D7F
    CPX L0042
    BEQ C0D97
    LDX L0042
    LDA #0
    SEC
    SBC L0078
    STA L0078
    LDA #&C9
    SBC L0079
    STA L0079
    STA L0075
    JMP C0D1B

.C0D97
    LDA L007B
    BPL C0DA3
    LDA #1
    ORA L62A0
    STA L62A0
.C0DA3
    LDA L007B
    ASL A
    EOR L007B
    BPL C0DB2
    LDA #1
    ORA L62A1
    STA L62A1
.C0DB2
    RTS

.sub_C0DB3
    ASL L0074
    ROL A
    ASL L0074
    ROL A
    STA L0076
    LDA #&C9
    STA L0075
.sub_C0DBF
    JSR sub_C0C02
    STA L0077
    LDA L0076
    JSR sub_C0C00
    STA L0075
    LDA L0077
    CLC
    ADC L0074
    STA L0074
    BCC C0DD6
    INC L0075
.C0DD6
    RTS

.sub_C0DD7
    LDA L0081
    BPL C0DEE
    LDA #0
    SEC
    SBC L0080
    STA L0080
    LDA #0
    SBC L0081
    STA L0081
    LDA L0079
    EOR #&80
    STA L0079
.C0DEE
    LDA L0082
    AND #1
    BEQ C0DFA
    LDA L0079
    EOR #&80
    STA L0079
.C0DFA
    LDA L0081
    STA L0075
    LDA L0082
    JSR sub_C0C00
    STA L0077
    LDA L0074
    CLC
    ADC #&80
    STA L0076
    BCC C0E10
    INC L0077
.C0E10
    LDA L0083
    JSR sub_C0C00
    STA L0078
    LDA L0074
    CLC
    ADC L0077
    STA L0077
    BCC C0E22
    INC L0078
.C0E22
    LDA L0080
    STA L0075
    LDA L0083
    JSR sub_C0C00
    STA L0075
    LDA L0074
    CLC
    ADC L0076
    LDA L0075
    ADC L0077
    STA L0074
    BCC C0E3C
    INC L0078
.C0E3C
    LDA L0078
    BIT L0079
.sub_C0E40
    BPL C0E4F
.sub_C0E42
    STA L0075
.sub_C0E44
    LDA #0
    SEC
    SBC L0074
    STA L0074
    LDA #0
    SBC L0075
.C0E4F
    RTS

.sub_C0E50
    LDA #osbyte_inkey
    LDY #&FF
    JSR osbyte
    CPX #&FF
    RTS

.sub_C0E5A
    PHA
    LDA L62BD,X
    BEQ C0E72
    LDA #0
    STA L62BD,X
    TXA
    ORA #4
    TAX
    LDA #osbyte_flush_buffer
    JSR osbyte
    TXA
    AND #&FB
    TAX
.C0E72
    PLA
    RTS

.sub_C0E74
    LDA L62A6
    ORA L62A7
    BPL C0E92
    LDA user_via_t2c_l
    CMP #&3F ; '?'
    BCS C0E92
    AND #3
    CLC
    ADC #&82
    STA L0B2C
    LDA #3
    LDY #1
    JSR sub_C0B4A
.C0E92
    LDX L0060
    CPX L005F
    BEQ C0EE0
    BCC C0E9D
    DEX
    BCS C0E9E
.C0E9D
    INX
.C0E9E
    STX L0060
    CPX #&1C
    BCC C0EE1
    TXA
    SEC
    SBC #&5C ; '\'
    BCS C0EB8
    PHA
    LDA #0
    JSR L0B47
    PLA
    CLC
    ADC #&BB
    LDY #0
    BEQ C0EC0
.C0EB8
    LDX #0
    JSR sub_C0E5A
    LDY L05FE
.C0EC0
    STA L0B1C
    LDA #1
    JSR sub_C0B4A
    LDY L05FE
    BEQ C0EDB
    LDA L0060
    SEC
    SBC #&40 ; '@'
    BCS C0ED8
    LDY #0
    BEQ C0EDB
.C0ED8
    STA L0B24
.C0EDB
    LDA #2
    JSR sub_C0B4A
.C0EE0
    RTS

.C0EE1
    JSR sub_C43F6
    RTS

.sub_C0EE5
    STY L0074
    LDX #&FF
    JSR sub_C0E50
    BNE C0F63
    LDY L0074
.loop_C0EF0
    STY L0074
    LDX L3DE2,Y
    JSR sub_C0E50
    BEQ C0F01
    LDY L0074
    DEY
    BPL loop_C0EF0
    BMI C0F11
.C0F01
    LDY L0074
    LDA L39D4,Y
    AND #&0F
    TAX
    LDA L39D4,Y
    AND #&F0
    STA L05F4,X
.C0F11
    LDA L05F7
    BEQ C0F2C
    BPL C0F25
    JSR sub_C43F6
.loop_C0F1B
    JSR sub_C66B6
    LDX #&A6
    JSR sub_C0E50
    BNE loop_C0F1B
.C0F25
    INC L0060
    LDA #0
    STA L05F7
.C0F2C
    LDY L05FE
    LDA L006A
    AND #1
    BNE C0F5E
    LDA L05F6
    BEQ C0F63
    BPL C0F43
    INY
    BEQ C0F48
    BMI C0F48
    BPL C0F5E
.C0F43
    DEY
    CPY #&F1
    BCC C0F5E
.C0F48
    STY L05FE
    TYA
    EOR #&FF
    CLC
    ADC #1
    ASL A
    ASL A
    ASL A
    STA L0B44
    LDA #0
    JSR sub_C0B65
    INC L0060
.C0F5E
    LDA #0
    STA L05F6
.C0F63
    RTS

.sub_C0F64
    STA L0078
    SED
.C0F67
    LDX #0
    STX L0076
    STX L0100
    INX
.C0F6F
    STX L0077
    LDY L013C,X
    TXA
    STA L0100,X
    LDA L013B,X
    TAX
    SEC
    BIT L0078
    BVS C0FBA
    BMI C0FD4
    LDA L06A0,Y
    SBC L06A0,X
    STA L0075
    LDA L06B8,Y
    SBC L06B8,X
    STA L0079
    LDA L06D0,Y
    SBC L06D0,X
    BCC C0FEC
.C0F9B
    ORA L0075
    ORA L0079
    BNE C0FAA
    LDX L0077
    DEX
    LDA L0100,X
    STA L0101,X
.C0FAA
    LDX L0077
    INX
    CPX #&14
    BCC C0F6F
    LDA L0076
    BNE C0F67
    CLD
    JSR sub_C63A2
    RTS

.C0FBA
    LDA L3864,X
    SBC L3864,Y
    STA L0075
    LDA L39E4,X
    SBC L39E4,Y
    STA L0079
    LDA L04F0,X
    SBC L04F0,Y
    BCC C0FEC
    BCS C0F9B
.C0FD4
    LDA L0898,Y
    SBC L0898,X
    STA L0075
    LDA L08AC,Y
    SBC L08AC,X
    STA L0079
    LDA L04DC,Y
    SBC L04DC,X
    BCS C0FAA
.C0FEC
    STX L0074
    LDX L0077
    TYA
    STA L013B,X
    LDA L0074
    STA L013C,X
    DEC L0076
    JMP C0FAA

.sub_C0FFE
    LDA L006C
    BPL C1032
    BIT L0066
    BPL C102A
    LDA #0
    STA L0066
    STA L0078
    LDX L006F
    LDA L04B4,X
    CMP #1
    EOR #&FF
    ADC L006E
    PHP
    JSR sub_C65C8
    LDX #&0C
    LDY #&21 ; '!'
    JSR sub_C37D0
    PLP
    BPL C102A
    LDX #&35 ; '5'
    JSR sub_C17FC
.C102A
    LDA L000F
    BNE C109A
    JSR sub_C1B84
    RTS

.C1032
    LDX #1
    JSR sub_C17C3
    BIT L0066
    BVS C1056
    BPL C106F
    LSR L0066
    LDA #&21 ; '!'
    CLC
    ADC L62EF
    STA L62EF
    BEQ C104F
    LDA #&26 ; '&'
    JSR sub_C502F
.C104F
    LDX #1
    JSR sub_C5011
    BEQ C106F
.C1056
    LDA L62EF
    BEQ C106A
    DEC L62EF
    BNE C106F
    JSR sub_C501D
    LDA #2
    JSR sub_C3D50
    BEQ C106F
.C106A
    BCC C106F
    JSR sub_C502D
.C106F
    LDA L5F3B
    BMI C109A
    CMP L06E4
    BCC C1089
    BNE C109A
    BIT L0065
    BVS C109A
    LDA #&40 ; '@'
    STA L0065
    LDX #&29 ; ')'
    JSR sub_C4D74
    RTS

.C1089
    LDA L0065
    BMI C109A
    LDA #&C0
    STA L0065
    LDA #&3C ; '<'
    STA L000F
    LDX #&2A ; '*'
    JSR sub_C4D74
.C109A
    RTS

.sub_C109B
    STA L0076
    SEC
    ROR L62F8
.loop_C10A1
    LDX #&13
.loop_C10A3
    JSR sub_C147C
    DEX
    BPL loop_C10A3
    LDA L08D0
    ORA L08E8
    BNE loop_C10A1
    LDA #&FF
    STA L0078
    BNE C10CF
.C10B7
    LDA L0076
    STA L0077
.loop_C10BB
    TXA
    PHA
    LDA L013C,X
    TAX
    JSR sub_C14C3
    PLA
    TAX
    DEC L0077
    BPL loop_C10BB
    INX
    CPX #&14
    BCC C10B7
.C10CF
    INC L0078
    LDX L0078
    CPX #&14
    BCC C10B7
.C10D7
    LDX #&17
    JSR sub_C147C
    LDY #&17
    LDX L006F
    SEC
    JSR sub_C27AB
    BCS C10D7
    CMP #&20 ; ' '
    BNE C10D7
    LDX #&17
    LDA #&31 ; '1'
    STA L0076
    STA L0042
.loop_C10F2
    JSR sub_C14C3
    DEC L0076
    BNE loop_C10F2
.loop_C10F9
    INC L0042
    JSR sub_C14C3
    BCC loop_C10F9
    LDA #&50 ; 'P'
    LDY #&13
.loop_C1104
    LDX L013C,Y
    EOR #&FF
    STA L0178,X
    DEY
    BPL loop_C1104
    LDA #0
    STA L0024
.loop_C1113
    JSR sub_C12F7
    DEC L0042
    BNE loop_C1113
    LSR L62F8
    RTS

.sub_C111E
    LDA L0011
    CMP #2
    BCC C1162
    LDA L005E
    JSR sub_C3450
    CMP #&60 ; '`'
    BCS C1138
    LDA #&14
    BIT L62E2
    JSR sub_C3450
    JMP C1C0B

.C1138
    DEC L62F6
    INC L001F
    JSR sub_C3D5C
    JSR sub_C43F6
    LDA #4
    JSR L0B47
    LDA #0
    LDX #&1E
.loop_C114C
    STA L62D0,X
    DEX
    BPL loop_C114C
    STA L0061
    STA L0026
    STA L0060
    STA L005F
    LDA #&7F
    STA L002D
    LDA #&1F
    STA L0009
.C1162
    RTS

.sub_C1163
    LDA #0
    STA L0000
    STA L006D
    JSR sub_C261F
    LDX L006F
    JSR sub_C11BE
.C1171
    JSR sub_C5052
    LDY #0
    JSR sub_C0EE5
    LDA L05F4
    BMI C11AA
    JSR sub_C27ED
    JSR sub_C2692
    JSR sub_C63A2
    LDX #&13
    LDA L006C
    BMI C1199
    CPX L006F
    BNE C11AA
    LDA L62DF
    CMP #&0E
    BCC C1171
    RTS

.C1199
    LDA L018C,X
    AND #&40 ; '@'
    BNE C11A7
    LDA L006E
    CMP L04B4,X
    BCS C1171
.C11A7
    DEX
    BPL C1199
.C11AA
    RTS

.sub_C11AB
    CPX #&14
    BCS C11CD
    LDA L0178,X
    AND #&7F
    ORA #&45 ; 'E'
    STA L0114,X
    LDA #&91
    STA L0100,X
.sub_C11BE
    LDA L006E
    CMP L04B4,X
    LDA #&C0
    STA L018C,X
    BCC C11CD
    STA L04DC,X
.C11CD
    RTS

.sub_C11CE
    LDX L006F
    STX L0045
    STX L0042
    LDY L0022
    JSR C2937
    LDX #2
.loop_C11DB
    LDA L09FD,X
    STA L6280,X
    LDA L0AFD,X
    STA L6283,X
    DEX
    BPL loop_C11DB
    LDA L0022
    CLC
    ADC #3
    CMP #&78 ; 'x'
    BCC C11F5
    LDA #0
.C11F5
    TAY
    LDX L0045
    JSR C2937
    LDA L0380,X
    STA L000A
.C1200
    LDA L0398,X
    EOR L0025
    STA L000B
    RTS

.sub_C1208
    LDA L5901,Y
    STA L0900,X
    LDA L5902,Y
    STA L0901,X
    LDA L5903,Y
    STA L0902,X
    LDA L5301,Y
    STA L0A00,X
    LDA L5302,Y
    STA L0A01,X
    LDA L5303,Y
    STA L0A02,X
    RTS

.sub_C122D
    JSR sub_C1208
    LDA L5904,Y
    STA L0978,X
    LDA L5906,Y
    STA L097A,X
    LDA L5304,Y
    STA L0A78,X
    LDA L5306,Y
    STA L0A7A,X
    LDA L5905,Y
    STA L0002
.sub_C124D
    LDA L0901,X
    STA L0979,X
    LDA L0A01,X
    STA L0A79,X
    RTS

.sub_C125A
    LDA L0024
    SEC
    SBC #&60 ; '`'
    BPL C1264
    CLC
    ADC #&78 ; 'x'
.C1264
    STA L0022
    RTS

.sub_C1267
    LDX L0024
    LDY #6
    STY L62F5
    LDA L0062
    BEQ C1274
    STY L0006
.C1274
    LDA L0025
    BMI C1284
    LDY L06FF
    JSR sub_C122D
    LDA L5300,Y
    JMP C128E

.C1284
    LDY L0021
    JSR sub_C122D
    JSR sub_C13E0
    LDA #2
.C128E
    AND #7
    STA L0007
    LDY L06FF
    LDA L5900,Y
    STA L0001
    LDA #0
    STA L0702,X
    RTS

.sub_C12A0
    LDX #&2C ; ','
.loop_C12A2
    LDA L5E40,X
    STA L5E41,X
    LDA L5E90,X
    STA L5E91,X
    LDA L5F20,X
    STA L5F21,X
    CPX #&28 ; '('
    BNE C12BA
    LDX #5
.C12BA
    DEX
    BPL loop_C12A2
    LDA #6
    SEC
    SBC L0007
    STA L0005
    JSR sub_C12C8
    RTS

.sub_C12C8
    LDX L0006
    INX
    CPX #6

    BCC C12D1
    LDX #6
.C12D1
    CPX L0005
    BCS C12D7
    LDX L0005
.C12D7
    STX L0006
    LDX L0008
    INX
.sub_C12DC
    INX
    CPX L0006
    BCS C12E3
    STX L0006
.C12E3
    DEX
    CPX L0005
    BCS C12EA
    LDX #5
.C12EA
    CPX #6
    BCC C12F0
    LDX #5
.C12F0
    STX L0008
    RTS

.sub_C12F3
    CLC
    JSR sub_C1433
.sub_C12F7
    LDA L0024
    STA L0023
    CLC
    ADC #3
    CMP #&78 ; 'x'
    BCC C1304
    LDA #0
.C1304
    STA L0024
    LDX #&17
    LDA L0025
    BMI C1326
    LDA L59FA
    LSR A
    AND #&F8
    CMP L06E8,X
    BNE C131B
    LDA #1
    STA L0030
.C131B
    JSR sub_C147C
    BCC C1333
    JSR sub_C1267
    JMP C13CC

.C1326
    LDA L06FF
    STA L0021
    JSR sub_C14C3
    BCC C1333
    JSR sub_C1267
.C1333
    LDY L0002
    JSR sub_C1442
    LDX L0024
    LDA L0001
    LSR A
    PHP
    LDA L0001
    BCS C134F
    LDY L0897
    CPY #1
    BCC C134D
    CPY #&0A
    BCC C134F
.C134D
    AND #&F9
.C134F
    STA L0077
    LDY L06FF
    LDA L5907,Y
    PLP
    BCC C1365
    LSR A
    TAY
    LDA L0077
    CPY L0897
    BEQ C137C
    BNE C1378
.C1365
    SEC
    SBC L0897
    TAY
    LDA L0077
    CPY #7
    BEQ C137C
    CPY #&0E
    BEQ C137A
    CPY #&15
    BEQ C137A
.C1378
    AND #&E7
.C137A
    AND #&DF
.C137C
    AND L0001
    STA L0702,X
    LDY L0023
    JSR sub_C0BCC
    JSR sub_C124D
    LDY L0002
    LDA #0
    STA L0083
    STA L0085
    LDA L5700,Y
    BPL C1398
    DEC L0083
.C1398
    ASL A
    ROL L0083
    ASL A
    ROL L0083
    CLC
    ADC L0900,X
    STA L0978,X
    LDA L0083
    ADC L0A00,X
    STA L0A78,X
    LDA L5800,Y
    BPL C13B4
    DEC L0085
.C13B4
    ASL A
    ROL L0085
    ASL A
    ROL L0085
    CLC
    ADC L0902,X
    STA L097A,X
    LDA L0085
    ADC L0A02,X
    STA L0A7A,X
    JSR sub_C13DA
.C13CC
    LDX L0024
    LDA L0002
    STA L0700,X
    JSR sub_C125A
    JSR sub_C150E
    RTS

.sub_C13DA
    LDA L0001
    AND #1
    BEQ C13FA
.sub_C13E0
    LDA L0025
    BMI C13F0
    LDY L0002
    INY
    CPY L59FB
    BNE C13F8
    LDY #0
    BEQ C13F8
.C13F0
    LDY L0002
    BNE C13F7
    LDY L59FB
.C13F7
    DEY
.C13F8
    STY L0002
.C13FA
    RTS

.sub_C13FB
    LDA #6
    STA L0006
    LDX #&40 ; '@'
    STX L001A
    JSR sub_C1420
    LDA #0
    STA L001A
    RTS

.sub_C140B
    SEC
    JSR sub_C1433
    LDX #&28 ; '('
    STX L0062
    JSR sub_C1420
    LDX #&27 ; '''
    JSR sub_C1420
    LDA #0
    STA L0062
    RTS

.sub_C1420
    LDA L0025
    EOR #&80
    STA L0025
    JSR sub_C13DA
    STX L0042
.loop_C142B
    JSR sub_C12F7
    DEC L0042
    BNE loop_C142B
    RTS

.sub_C1433
    LDX L006F
    ROR A
    EOR L0025
    BMI C143E
    JSR sub_C147C
    RTS

.C143E
    JSR sub_C14C3
    RTS

.sub_C1442
    LDA #0
    STA L0083
    STA L0084
    STA L0085
    LDA L5400,Y
    STA L0074
    BPL C1453
    DEC L0083
.C1453
    LDA L5500,Y
    STA L0075
    BPL C145C
    DEC L0084
.C145C
    LDA L5600,Y
    STA L0076
    BPL C1465
    DEC L0085
.C1465
    LDA L0025
    BEQ C147B
    LDX #2
.loop_C146B
    LDA #0
    SEC
    SBC L0074,X
    STA L0074,X
    LDA #0
    SBC L0083,X
    STA L0083,X
    DEX
    BPL loop_C146B
.C147B
    RTS

.sub_C147C
    LDY L06E8,X
    LDA L0880,X
    CLC
    ADC #1
    CMP L5907,Y
    PHP
    BCC C149B
    TYA
    CLC
    ADC #8
    CMP L59FA
    BCC C1496
    LDA #0
.C1496
    STA L06E8,X
    LDA #0
.C149B
    STA L0880,X
    INC L08D0,X
    BNE C14A6
    INC L08E8,X
.C14A6
    LDA L08D0,X
    CMP L59FC
    BNE C14C1
    LDA L08E8,X
    CMP L59FD
    BNE C14C1
    LDA #0
    STA L08D0,X
    STA L08E8,X
    JSR sub_C4F77
.C14C1
    PLP
    RTS

.sub_C14C3
    LDY L06E8,X
    LDA L0880,X
    CLC
    BNE C14DD
    TYA
    BNE C14D2
    LDA L59FA
.C14D2
    SEC
    SBC #8
    STA L06E8,X
    TAY
    LDA L5907,Y
    SEC
.C14DD
    PHP
    SEC
    SBC #1
    STA L0880,X
.C14E4
    LDA L08D0,X
    BNE C1509
    DEC L08E8,X
    BPL C1509
    LDA L59FC
    STA L08D0,X
    LDA L59FD
    STA L08E8,X
    CPX L006F
    BNE C14E4
    LDA L04B4,X
    BEQ C14E4
    DEC L04B4,X
    JMP C14E4

.C1509
    DEC L08D0,X
    PLP
    RTS

.sub_C150E
    LDY L06FF
    TYA
    LSR A
    LSR A
    LSR A
    TAX
    LDA L0017
    BNE C1557
    LDA L0001
    LSR A
    BCS C152E
    LDA L0897
    CMP L5305,Y
    BCS C1532
.C1527
    LDA L5FB0,X
    ORA #&40 ; '@'
    BNE C1573
.C152E
    LDA L0020
    BMI C1538
.C1532
    TYA
    CLC
    ADC #8
    TAY
    INX
.C1538
    LDA L5900,Y
    AND #1
    BEQ C1527
    LDA L5305,Y
    STA L0017
    BEQ C1527
    LDA L5307,Y
    STA L0020
    AND #&7F
    STA L0018
    LDA L5FB0,X
    STA L0016
    JMP C1573

.C1557
    DEC L0017
    LDA L0017
    LSR A
    LSR A
    LSR A
    STA L0074
    LDA L0017
    SEC
    SBC L0018
    BCS C156D
    ADC L0074
    LDA #0
    BCS C1573
.C156D
    LDA L0016
    BCS C1573
    EOR #&80
.C1573
    LDY L0024
    STA L0701,Y
    RTS

.sub_C1579
    LDA #0
    STA L0076
    STA L0074
    STA L0058
    LDX #&9D
    JSR sub_C0E50
    PHP
    BIT L05F5
    BPL C15B3
    LDX #1
    JSR sub_C503F
    STA L0075
    JSR sub_C0C00
    PLP
    BEQ C159F
    LSR A
    ROR L0074
    LSR A
    ROR L0074
.C159F
    STA L0075
    LDA L0074
    AND #&FE
    STA L0074
    TXA
    ORA L0074
    STA L0074
    LDA L0075
    JMP C1EE9

    EQUB &EA, &EA
.C15B3
    LDX #&A9
    JSR sub_C0E50
    BNE C15BE
    LDA #2
    STA L0076
.C15BE
    LDX #&A8
    JSR sub_C0E50
    BNE C15C7
    INC L0076
.C15C7
    LDA #3
    STA L0075
    PLP
    BEQ C15DF
    LDA #0
    LDX #2
    CPX L62A5
    BCC C15D9
    LDA #1
.C15D9
    STA L0075
    LDA #&80
    STA L0074
.C15DF
    LDA L0076
    BEQ C15F4
    CMP #3
    BEQ C163B
    EOR L62A2
    AND #1
    BEQ C160F
    JSR sub_C0E44
    JMP C160D

.C15F4
    LDA L62DA
    AND #&F0
    STA L0074
    LDA L62EA
    JSR sub_C0E40
    LSR A
    ROR L0074
    LSR A
    ROR L0074
    CMP L62A5
    JSR sub_C1F9B
.C160D
    STA L0075
.C160F
    JMP C1EFA

.C1612
    SEC
    SBC L0074
    STA L0074
    LDA L62A5
    SBC L0075
    CMP #&C8
    BCC C162D
    JSR sub_C0E42
    STA L0075
    LDA L0074
    EOR #1
    STA L0074
    LDA L0075
.C162D
    CMP #&91
    BCC C1633
    LDA #&91
.C1633
    STA L62A5
    LDA L0074
    STA L62A2
.C163B
    LDA L000F
    BNE C1678
    BIT L05F5
    BPL C165E
    LDX #2
    JSR sub_C503F
    BCC C1678
    STA L0074
    LSR L0074
    ASL A
    ADC L0074
    BCS C1658
    CMP #&FA
    BCC C1681
.C1658
    CPX #0
    BEQ C1674
    BNE C1667
.C165E
    LDX #&AE
    JSR sub_C0E50
    BNE C166B
    LDX #1
.C1667
    LDA #&FF
    BNE C1681
.C166B
    LDX #&BE
    JSR sub_C0E50
    BNE C1678
    LDX #0
.C1674
    LDA #&FA
    BNE C1681
.C1678
    LDX #&80
    LDA L003C
    LSR A
    LSR A
    CLC
    ADC #5
.C1681
    STX L003E
    STA L003F
    BIT L05F5
    BPL C16A3
    LDX #0
    LDA #osbyte_read_adc_or_get_buffer_status
    JSR osbyte
    TXA
    AND #1
    BEQ C16B1
    LDY L003E
    DEY
    BNE C16B7
    LDA L003F
    CMP #&C8
    BCS C16BB
    BCC C16B7
.C16A3
    LDX #&9F
    JSR sub_C0E50
    BEQ C16B7
    LDX #&EF
    JSR sub_C0E50
    BEQ C16BB
.C16B1
    LDA #0
    STA L0019
    BEQ C16DB
.C16B7
    LDA #&FF
    BNE C16BD
.C16BB
    LDA #1
.C16BD
    DEC L0058
    LDX L0019
    BNE C16DB
    STA L0019
    CLC
    ADC L0040
    CMP #&FF
    BEQ C16D4
    CMP #7
    BNE C16D6
    LDA #6
    BNE C16D6
.C16D4
    LDA #0
.C16D6
    STA L0040
    JSR sub_C42D0
.C16DB
    RTS

.sub_C16DC
    JSR sub_C4DDD
    LDA #0
    STA L0064
    JSR sub_C18EA
    JSR L7BE2
    BIT L05F4
    BVS C16F9
.C16EE
    LDX #0
    JSR sub_C5011
.C16F3
    JSR sub_C1805
.C16F6
    JSR sub_C11CE
.C16F9
    LDA #0
    STA L05F4
    JSR sub_C0B77
.C1701
    JSR sub_C5052
    JSR L7B4A
    JSR sub_C1579
    JSR sub_C46A1
    JSR sub_C24F6
    JSR sub_C4626
    JSR sub_C24B9
    JSR sub_C0FFE
    JSR sub_C0E74
    JSR sub_C66B6
    JSR sub_C1A20
    JSR sub_C0E74
    JSR sub_C18BC
    JSR sub_C4CA4
    LDX #&17
    JSR sub_C2AD1
    JSR sub_C1B12
    JSR sub_C2637
    JSR sub_C1E15
    JSR L7B00
    JSR sub_C0E74
    JSR sub_C4F44
    JSR sub_C1BB9
    JSR sub_C111E
    JSR L7BE2
    LDA L4F43
    BPL C1753
    INC L4F43
.C1753
    LDA L62F6
    BEQ C178F
    INC L62F6
    LDA #&9C
    STA L62F7
.loop_C1760
    LDA L62F7
    BMI loop_C1760
.loop_C1765
    LDA L5F3B
    BMI C16EE
    LDA L006C
    BPL C16F3
    LDA L5F3A
    BEQ C16F6
.C1773
    JSR sub_C43F6
    LDA L5F3B
    BMI loop_C1765
    LDX #&30 ; '0'
    JSR sub_C17FC
    JSR sub_C1163
    LDA L05F4
    BMI C17BA
    LDA #&20 ; ' '
    STA L05F4
    BNE C17BA
.C178F
    LDY #&0B
    JSR sub_C0EE5
    LDA L05F4
    BEQ C17A8
    BPL C1773
    AND #&40 ; '@'
    BEQ C17BA
    LDA L0000
    BEQ C17BA
    LDA #0
    STA L05F4
.C17A8
    LDX L000F
    BEQ C17B1
    DEX
    BEQ C1773
    STX L000F
.C17B1
    JSR sub_C0E74
    JSR sub_C513A
    JMP C1701

.C17BA
    LDA #&80
    JSR sub_C18EA
    JSR sub_C4F23
    RTS

.sub_C17C3
    SED
    LDA #9
    LDY L0046
    CPY L5A19
    BNE C17CF
    LDA #&18
.C17CF
    CLC
    ADC L06B4,X
    STA L06B4,X
    PHP
    LDA L06CC,X
    ADC #0
    CMP #&60 ; '`'
    BCC C17E2
    LDA #0
.C17E2
    STA L06CC,X
    LDA L06E4,X
    ADC #0
    STA L06E4,X
    BPL C17F9
    JSR sub_C5011
    LDY L006F
    LDA #&80
    STA L04DC,Y
.C17F9
    PLP
    CLD
    RTS

.sub_C17FC
    JSR sub_C4D70
    LDX #&2D ; '-'
    JSR sub_C4D74
    RTS

.sub_C1805
    LDA #0
    LDX #&68 ; 'h'
.loop_C1809
    STA L0000,X
    DEX
    BPL loop_C1809
    LDX #&7F
.loop_C1810
    STA L6280,X
    DEX
    BPL loop_C1810
    JSR sub_C0B65
    LDX #&17
    STX L62F9
.loop_C181E
    LDA L59FF
    STA L08E8,X
    LDA L59FE
    STA L08D0,X
    LDA #0
    STA L06E8,X
    STA L0880,X
    DEX
    BPL loop_C181E
    JSR sub_C63A2
    LDA #1
    BIT L006C
    BMI C184C
    LDX L5A17
    LDY L0003
    JSR sub_C267F
    JSR sub_C63A2
    LDA L5A18
.C184C
    JSR sub_C109B
    LDX #&13
.C1851
    LDA #&80
    STA L018C,X
    STA L04DC,X
    LDA #0
    STA L04B4,X
    STA L0114,X
    STA L0164,X
    STA L0150,X
    STA L0100,X
    STA C3850,X
    LDA #&FF
    STA L01A4,X
    DEX
    BPL C1851
    LDA #1
    STA L0040
    STA L0030
    LDX #7
    STX L0009
    DEX
    STX L0006
    STX L0008
    DEX
.loop_C1885
    STA L6293,X
    DEX
    BPL loop_C1885
    JSR sub_C42D0
    LDA L006C
    BMI C18A5
    LDX #&28 ; '('
    JSR sub_C17FC
    LDX #1
    JSR sub_C5011
    JSR sub_C501D
    LDA #&DF
    STA L62EF
    RTS

.C18A5
    STA L0066
    STA L62FE
    LDX #&2B ; '+'
    JSR sub_C4D74
    LDX #&2C ; ','
    JSR sub_C4D70
    LDA L0003
    JSR sub_C65C8
    STA L002F
    RTS

.sub_C18BC
    LDX L0051
    LDY L001F
    LDA L5EB8,X
    CLC
    ADC #&14
    BPL C18D4
    LDA L5E90,X
    CLC
    ADC #&14
    BMI C18D4
    LDA #&20 ; ' '
    BNE C18D6
.C18D4
    LDA #&23 ; '#'
.C18D6
    STA L5F60,Y
    LDA #&21 ; '!'
    LDY #&4F ; 'O'
.loop_C18DD
    LDX L5F60,Y
    BEQ C18E3
    TXA
.C18E3
    STA L5F60,Y
    DEY
    BPL loop_C18DD
    RTS

.sub_C18EA
    STA L0074
    LDX #3
.loop_C18EE
    LDA L192F,X
    STA P,X
    DEX
    BPL loop_C18EE
    LDX #0
.C18F8
    LDY #&4F ; 'O'
    LDA #0
    STA L0076
.loop_C18FE
    BIT L0074
    BMI C1906
    LDA (P),Y
    STA (R),Y
.C1906
    LDA (R),Y
    STA (P),Y
    INC L0076
    DEY
    TYA
    CMP L3900,X
    BNE loop_C18FE
    LDA R
    SEC
    SBC L0076
    STA R
    BCS C191E
    DEC S
.C191E
    LDA P
    CLC
    ADC #&80
    STA P
    BCC C1929
    INC Q
.C1929
    INX
    CPX #&29 ; ')'
    BNE C18F8
    RTS

.L192F
    EQUB 0  , &30, &B0, &7F
.sub_C1933
    LDA L5E90,X
    CLC
    ADC #&14
    CMP #&28 ; '('
    ROR L0076
    RTS

.sub_C193E
    STA L1970
    STY L004B
    DEY
    STY L0075
    JSR sub_C1933
    LDY L001F
    JMP C1977

.C194E
    LDA L0076
    BPL C1955
    JSR sub_C1933
.C1955
    LDA L5F20,X
    CMP #&50 ; 'P'
    BCS C1980
    BIT L0076
    BPL C1965
    CMP L5F21,X
    BEQ C19A5
.C1965
    CMP L007F
    BCS C19A5
.C1969
    STA L0082
    TXA
    JMP C1973

.loop_C196F
L1970 = loop_C196F+1
    STA L0400,Y
    DEY
.C1973
    CPY L0082
    BNE loop_C196F
.C1977
    STY L007F
.C1979
    INX
    BMI C1996
    CPX L0075
    BCC C194E
.C1980
    LDA L5F20,X
    BMI C198E
    CMP L007F
    BCC C198E
    LDA L007F
    STA L5F20,X
.C198E
    TXA
    ORA #&80
    TAX
    LDA #0
    BEQ C1969
.C1996
    LDX L0050
.loop_C1998
    LDA L5EE0,X
    BPL C19A2
    INX
    CPX L0075
    BCC loop_C1998
.C19A2
    STX L0050
    RTS

.C19A5
    LDA #&80
    ORA L5EE0,X
    STA L5EE0,X
    BMI C1979
.sub_C19AF
    STY L0027
    STA L004C
    CMP L004B
    BCS C1A1F
    CLC
    ADC L30FC,Y
    STA L004F
    LDA L2B1E,Y
    STA L2F50
    STA L2F92
    LDA L2B22,Y
    STA L2F4F
    STA L2F91
    LDX L004F
    LDY L004C
    SEC
    JSR sub_C2B26
.C19D7
    INX
    INY
    CPY L004B
    BCS C1A1F
    LDA L5EE0,Y
    BMI C19D7
    LDA L004C
    CMP L0050
    BCC C19F8
    BNE C19FD
    LDA L5EDF,Y
    AND #3
    BNE C1A10
    STY L0050
    SEC
    LDA L0027
    BEQ C1A15
.C19F8
    LDA L008C
    CLC
    BCC C1A15
.C19FD
    LDA L5EDF,Y
    AND #3
    BNE C1A10
    LDA L0027
    CMP #1
    BEQ C1A15
    CMP #2
    BEQ C1A15
    LDA #0
.C1A10
    ASL A
    ASL A
    CLC
    ADC L0032
.C1A15
    JSR sub_C2B26
    STY L004C
    STX L004F
    JMP C19D7

.C1A1F
    RTS

.sub_C1A20
    LDA #&80
    STA P
    LDA L0051
    CLC
    ADC #&28 ; '('
    TAX
    CMP #&31 ; '1'
    BCS C1A30
    LDA #&31 ; '1'
.C1A30
    STA L0050
    LDA #0
    STA R
    STA L008E
    LDY L0012
    JSR sub_C193E
    LDY #0
    STY L0032
    LDA L0050
    JSR sub_C19AF
    LDA #8
    STA L0032
    LDY #0
    STY L008C
    INY
    LDA L0051
    CLC
    ADC #&28 ; '('
    JSR sub_C19AF
    LDA L0050
    LDX #4
    JSR sub_C1A98
    STY L002C
    LDA L0051
    TAX
    CMP #9
    BCS C1A69
    LDA #9
.C1A69
    STA L0050
    LDX L0051
    LDA #&50 ; 'P'
    LDY L0015
    JSR sub_C193E
    LDA #&1C
    STA L008C
    LDA #&10
    STA L0032
    LDY #2
    LDA L0051
    JSR sub_C19AF
    LDA #&1C
    STA L0032
    LDY #3
    LDA L0050
    JSR sub_C19AF
    LDA L0050
    LDX #&14
    JSR sub_C1A98
    STY L0029
    RTS

.sub_C1A98
    STX L0088
    STA L0075
    DEC L004B
    LDA L62F2
    CMP #&28 ; '('
    BCC C1B05
    BCS C1B0B
.C1AA7
    LDY L5F20,X
    CPY #&50 ; 'P'
    BCS C1B03
    LDA L5EE0,X
    BMI C1B03
    LDA L0088
    CMP #&14
    BEQ C1AC4
    LDA L5EA0,X
    STA L0077
    LDA L5E90,X
    JMP C1ACC

.C1AC4
    LDA L5E90,X
    STA L0077
    LDA L5EA0,X
.C1ACC
    CLC
    ADC #&14
    BMI C1B03
    LDA L0077
    CLC
    ADC #&14
    BPL C1B03
.loop_C1AD8
    LDA L5EE1,X
    BPL C1AE4
    INX
    INC L0075
    CPX L004B
    BCC loop_C1AD8
.C1AE4
    LDA L5F60,Y
    STA L0074
    LDA L5F60,Y
    BEQ C1AF9
    AND #&1C
    CMP L0088
    BEQ C1AF9
    ROR A
    EOR L0074
    BMI C1B03
.C1AF9
    LDA L5EE0,X
    AND #3
    ORA L0088
    STA L5F60,Y
.C1B03
    INC L0075
.C1B05
    LDX L0075
    CPX L004B
    BCC C1AA7
.C1B0B
    LDX L0050
    LDY L5F20,X
    INY
    RTS

.sub_C1B12
    LDY #0
.C1B14
    CPY L0057
    BEQ C1B7F
    LDX L62B4,Y
    STY L0056
    LDA L6299,Y
    AND #&20 ; ' '
    BEQ C1B29
    LDA #&0F
    STA L38FE
.C1B29
    LDA L62BA,Y
    STA L0075
    LDA L62B7,Y
    ASL A
    ROL L0075
    STA L0074
    CLC
    ADC L5E40,X
    STA L0076
    LDA L5E90,X
    ADC L0075
    CMP #&18
    BCC C1B49
    CMP #&E8
    BCC C1B74
.C1B49
    ASL L0076
    ROL A
    ASL L0076
    ROL A
    CLC
    ADC #&50 ; 'P'
    STA L0035
    LDA L5F20,X
    STA L0036
    LDY #2
.loop_C1B5B
    ASL L0074
    ROL L0075
    DEY
    BNE loop_C1B5B
    LDA L0075
    BPL C1B6B
    EOR #&FF
    CLC
    ADC #1
.C1B6B
    STA L002A
    LDA #6
    STA L0037
    JSR sub_C1FB4
.C1B74
    LDA #&F0
    STA L38FE
    LDY L0056
    INY
    JMP C1B14

.C1B7F
    LDA #0
    STA L0057
    RTS

.sub_C1B84
    LDA L002F
    BEQ C1BA2
    SED
    CLC
    ADC L0031
    STA L0031
    CLD
    BEQ C1BA2
    CMP #&21 ; '!'
    BCS C1BA2
    LDX #0
    STX L002F
    STX L0078
    LDX #&0A
    LDY #&18
    JSR sub_C37D0
.C1BA2
    BIT L62FE
    BPL C1BB5
    LDY L004D
    LDA #&18
    JSR sub_C6673
    LDY L005B
    LDA #&21 ; '!'
    JSR sub_C6673
.C1BB5
    LSR L62FE
    RTS

.sub_C1BB9
    LDA L0068
    BEQ C1C1B
    LDA #0
    STA L0068
    SEC
    ROR L0076
    LDA #&25 ; '%'
    SEC
    SBC L0041
    BCS C1BCD
    LDA #5
.C1BCD
    ASL A
    STA L0075
    LDX L0067
    LDY L006F
    CMP #&28 ; '('
    BCC C1BDF
    LDA L006C
    BPL C1BDF
    JSR sub_C11AB
.C1BDF
    LDA L0398,X
    SEC
    SBC L000B
    ASL A
    ASL A
    PHP
    LDA L0150,Y
    CPX #&14
    BCS C1BFE
    CMP L0150,X
    BCS C1BF9
    LDA L0150,X
    BNE C1BFE
.C1BF9
    ADC #&0B
    STA L0150,X
.C1BFE
    JSR sub_C0C00
    CMP #&10
    BCC C1C07
    LDA #&10
.C1C07
    PLP
    JSR sub_C0E40
.C1C0B
    STA L62E2
    LDA #&80
    STA L62A6
    STA L62A7
    LDA #4
    JSR L0B47
.C1C1B
    RTS

.sub_C1C1C
    STY L007B
    LDX L0079
    STX L0078
    AND #3
    TAX
    LDA L628F,X
    STA L0079
    LDA L0085
    STA L007C
    LDA L0084
    AND #&0C
    LSR A
    LSR A
    TAX
    LDA L628F,X
    STA L0076
    LDA #0
    STA P
    CPY #1
    BNE C1C5A
    LDA L007E
    BPL C1C4D
    SEC
    ROR A
    ADC #0
    JMP C1C4E

.C1C4D
    LSR A
.C1C4E
    CLC
    ADC L0035
    STA L007E
    LSR A
    LSR A
    STA L0085
    JMP C1C66

.C1C5A
    LDA L008D
    STA L0085
    LDA L008F
    STA L007E
    CPY #0
    BNE C1C7B
.C1C66
    LDA L0083
    BPL C1C71
    SEC
    ROR A
    ADC #0
    JMP C1C72

.C1C71
    LSR A
.C1C72
    CLC
    ADC L0035
    STA L008F
    LSR A
    LSR A
    STA L008D
.C1C7B
    LDA L0085
    CMP #&14
    ROL L0074
    LSR A
    ROR P
    CLC
    ADC #&30 ; '0'
    STA Q
    LDX L0085
    CPX #&28 ; '('
    BCC C1C92
    JMP C1D94

.C1C92
    LDA L0047
    CMP L3900,X
    BCS C1C9C
    LDA L3900,X
.C1C9C
    STA L0082
    CMP L007F
    BCC C1CAA
    CPY #1
    BNE C1CA7
    RTS

.C1CA7
    JMP C1D7C

.C1CAA
    LDA L0084
    AND #&10
    BEQ C1CC3
    TYA
    BEQ C1CC3
    EOR L0074
    AND #1
    BEQ C1CC3
    LDA L0084
    AND #3
    TAX
    LDA L628F,X
    STA L0076
.C1CC3
    LDA L007E
    AND #3
    TAX
    LDA L3FE8,X
    EOR #&FF
    AND L0076
    STA L0076
    CPY #1
    BCS C1D15
    LDA L337C,X
    AND L0078
    STA L0074
    LDA L0079
    AND L33FC,X
    ORA L0074
    AND L3FE8,X
    ORA L0076
    STA L007A
    LDA L0048
    BEQ C1CFD
    LDA #0
    STA L0048
    LDA L008C
    STA L007D
    EOR #&FF
    AND L007A
    JMP C1D25

.C1CFD
    LDX L0085
    CPX L008D
    BNE C1D0A
    LDA L007A
    STA L0079
    JMP C1D7C

.C1D0A
    LDA L007A
    BNE C1D10
    LDA #&55 ; 'U'
.C1D10
    LDY L007F
    JMP C1DE8

.C1D15
    BNE C1D34
    LDA L337C,X
    STA L007D
    EOR #&FF
    AND L0079
    AND L3FE8,X
    ORA L0076
.C1D25
    LDX L0085
    CPX L008D
    BNE C1D44
    STA L0079
    LDA L007D
    STA L008C
    ROR L0048
    RTS

.C1D34
    LDA L008C
    ORA L39D0,X
    STA L007D
    EOR #&FF
    AND L0078
    AND L3FE8,X
    ORA L0076
.C1D44
    STA L007A
    LDA #0
    STA L008C
    LDY L007F
    JMP C1D6B

.loop_C1D4F
    LDA (P),Y
    BEQ C1D5D
    CMP #&55 ; 'U'
    BNE C1D60
    LDA L007A
    BNE C1D68
    BEQ C1D66
.C1D5D
    JSR sub_C1E9E
.C1D60
    AND L007D
    ORA L007A
    BNE C1D68
.C1D66
    LDA #&55 ; 'U'
.C1D68
    STA (P),Y
    DEY
.C1D6B
    CPY L0082
    BNE loop_C1D4F
    LDX L007B
    CPX #1
    BEQ C1D93
    INC L0085
    JSR sub_C1DAF
    DEC L0085
.C1D7C
    LDA L007C
    CMP #&28 ; '('
    BCC C1D86
    LDA #&FF
    STA L007C
.C1D86
    LDA L0085
    CLC
    SBC L007C
    BEQ C1D93
    BMI C1D93
    TAX
    JSR sub_C1E38
.C1D93
    RTS

.C1D94
    LDY L007B
    CPY #1
    BEQ C1D93
    LDA L007C
    CMP #&28 ; '('
    BCS C1D93
    LDA #&28 ; '('
    STA L0085
    BNE C1D86
.sub_C1DA6
    STX L1DDE
    STY L1DD5
    STA L1DDC
.sub_C1DAF
    LDA L0085
    CMP #&28 ; '('
    BCS C1DE4
    CLC
    ADC #&60 ; '`'
    LSR A
    STA Q
    LDA #0
    ROR A
    STA P
    LDY L007F
    JMP C1DE0

    EQUB &C9, &55, &D0, 2  , &A9, 0  , &91, &72, &88, &C4, &82, &F0
    EQUB &12
.loop_C1DD2
    LDA (P),Y
.sub_C1DD4
L1DD5 = sub_C1DD4+1
    BNE C1DDF
    JSR sub_C1E9E
    BNE C1DDD
.sub_C1DDB
L1DDC = sub_C1DDB+1
    LDA #&55 ; 'U'
.C1DDD
L1DDE = C1DDD+1
    STA (P),Y
.C1DDF
    DEY
.C1DE0
    CPY L0082
    BNE loop_C1DD2
.C1DE4
    RTS

.loop_C1DE5
    STA (P),Y
    DEY
.C1DE8
    CPY L0082
    BNE loop_C1DE5
    JMP C1D7C

.sub_C1DEF
    STA L0042
.C1DF1
    STX L0085
    STY L007F
    LDA L3900,X
    STA L0082
    LDX #&72 ; 'r'
    LDY #&EF
    LDA #0
    JSR sub_C1DA6
    LDX #&70 ; 'p'
    LDY #9
    LDA #&55 ; 'U'
    INC L0085
    JSR sub_C1DA6
    LDX L0085
    CPX L0042
    BNE C1DF1
    RTS

.sub_C1E15
    LDA #5
    STA S
    LDA #4
    STA R
    LDY #&1B
    LDX #3
    LDA #6
    JSR sub_C1DEF
    LDA #&44 ; 'D'
    STA S
    LDA #0
    STA R
    LDY #&2B ; '+'
    LDX #&1A
    LDA #&22 ; '"'
    JSR sub_C1DEF
    RTS

.sub_C1E38
    LDA L0078
    BNE C1E3E
    LDA #&55 ; 'U'
.C1E3E
    STA L0076
    LDA #&7F
    SEC
    SBC L007F
    STA L0074
    ADC L0047
    STA L0086
    LDA L0085
    STA L0075
    CLC
    ADC #&5F ; '_'
    LSR A
    STA Q
    STA S
    LDA #0
    ROR A
    SEC
    SBC L0074
    STA P
    EOR #&80
    STA R
    BPL C1E67
    DEC S
.C1E67
    BCS C1E6D
.C1E69
    DEC Q
    DEC S
.C1E6D
    LDY L0075
    LDA L3F4F,Y
    DEY
    DEY
    STY L0075
    CMP L0047
    BCC C1E84
    ADC L0074
    TAY
    BPL C1E86
    CPX #2
    BCS C1E93
    RTS

.C1E84
    LDY L0086
.C1E86
    LDA L0076
    CPX #2
    BCC C1E98
.loop_C1E8C
    STA (P),Y
    STA (R),Y
    INY
    BPL loop_C1E8C
.C1E93
    DEX
    DEX
    BNE C1E69
    RTS

.C1E98
    STA (P),Y
    INY
    BPL C1E98
    RTS

.sub_C1E9E
    CPY L001F
    BCC C1EA8
    BEQ C1EA8
    LDA L38FD
    RTS

.C1EA8
    LDA L0085
    CMP L0554,Y
    BCS C1EC7
    CMP L0600,Y
    BCS C1ED5
    CMP L0650,Y
    BCS C1EC3
    CMP L05A4,Y
    BCS C1ECB
    LDA L5F60,Y
    BCC C1EE2
.C1EC3
    LDA L38FC
    RTS

.C1EC7
    LDA L38FF
    RTS

.C1ECB
    CPY L002C
    BCS C1EC7
    LDA L0400,Y
    JMP C1EDC

.C1ED5
    CPY L0029
    BCS C1EC7
    LDA L0450,Y
.C1EDC
    AND #&7F
    TAX
    LDA L5EDF,X
.C1EE2
    AND #3
    TAX
    LDA L38FC,X
    RTS

.C1EE9
    JSR sub_C63C5
    BNE C1EF1
.loop_C1EEE
    JMP C162D

.C1EF1
    BCS loop_C1EEE
    CMP #5
    BCS C1F08
    JMP C15F4

.C1EFA
    JSR sub_C63C5
    BEQ C1F05
    BCS C1F05
    LDA L0076
    BNE C1F11
.C1F05
    JMP C1F95

.C1F08
    LDA L0074
    EOR #1
    LSR A
    LDA #3
    SBC #0
.C1F11
    LDX #&32 ; '2'
    CMP #2
    BEQ C1F19
    LDX #&0A
.C1F19
    LDA L62A2
    STA L0076
    LSR A
    LDA L62A5
    BCC C1F30
    LDA #0
    SEC
    SBC L0076
    STA L0076
    LDA #0
    SBC L62A5
.C1F30
    CLC
    ADC #1
    CPX #&32 ; '2'
    BNE C1F39
    SBC #2
.C1F39
    STA L0077
    LDA L5E40,X
    SEC
    SBC L0076
    STA L0074
    LDA L5E90,X
    SBC L0077
    PHP
    JSR sub_C0E40
    STA L0076
    LDY L0022
    LDA #&3C ; '<'
    SEC
    SBC L0063
    BPL C1F59
    LDA #0
.C1F59
    ASL A
    ADC #&20 ; ' '
    STA L0075
    LDA L0701,Y
    AND #&7F
    CMP #&40 ; '@'
    BCC C1F69
    LDA #2
.C1F69
    CMP #8
    BCC C1F6F
    LDA #7
.C1F6F
    ASL A
    ASL A
    ASL A
    ASL A
    CMP L0075
    BCC C1F79
    STA L0075
.C1F79
    JSR sub_C0DBF
    LDA L0075
    PLP
    JSR sub_C0E40
    STA L0075
    LDA L0074
    AND #&FE
    STA L0074
    LDA L62A2
    LSR A
    BCS C1F95
    JSR sub_C0E44
    STA L0075
.C1F95
    LDA L62A2
    JMP C1612

.sub_C1F9B
    BCC C1FA7
    LDA L62A2
    AND #&FE
    STA L0074
    LDA L62A5
.C1FA7
    RTS

.sub_C1FA8
    BCC C1FAF
    LDA L0880,X
    CMP #3
.C1FAF
    ROR L62FB
    RTS

    EQUB &EA
.sub_C1FB4
    STX L0074
    LDX #3
.loop_C1FB8
    LDA L38FC,X
    STA L628F,X
    DEX
    BPL loop_C1FB8
    LDA #&F0
    STA L38FE
    LDA L0074
    CMP #&17
    BEQ C1FDE
    CMP #&14
    BCC C1FD5
    LDX L004D
    LDA L013C,X
.C1FD5
    AND #3
    TAX
    LDA L38FC,X
    STA L6290
.C1FDE
    LDX #0
    STX L002B
    LDA L002A
    CMP L62FC
    BCS C1FEB
    LDX L001F
.C1FEB
    STX L62FD
    CMP #&40 ; '@'
    BCS C1FFA
    ASL A
    ASL A
    STA L002A
    LDA #2
    STA L002B
.C1FFA
    LDX L0037
    CPX #&0A
    BCC C2002
    LDX #9
.C2002
    STX L62F3
    LDA L3CDD,X
    STA L0081
    LDA L3CDE,X
    STA L008A
    LDA L3CD0,X
    STA L008E
    JSR sub_C202A
    BCS C2029
    JSR sub_C209A
    LDX L0037
    LDA L62F3
    CMP #9
    BNE C2029
    LDA L0025
    BPL C2002
.C2029
    RTS

.sub_C202A
    LDA L002A
    STA L5FFA
    LSR A
    STA L5FFB
    LSR A
    STA L5FFC
    LSR A
    STA L5FFD
    LSR A
    STA L5FFE
    LSR A
    STA L5FFF
    LDY L0081
    LDX #0
    STX L0077
.C2049
    LDA L4480,Y
    BPL C2072
    AND #7
    TAX
    LDA L5FF8,X
    STA L0074
    LDA L4480,Y
    STA L0075
    LSR A
    LSR A
    LSR A
    AND #7
    TAX
    LDA L5FF8,X
    CLC
    ADC L0074
    BIT L0075
    BVC C2076
    CLC
    ADC L5FFB
    JMP C2076

.C2072
    TAX
    LDA L5FF8,X
.C2076
    LDX L002B
    BEQ C2080
.loop_C207A
    LSR A
    DEX
    BNE loop_C207A
    ADC #0
.C2080
    LDX L0077
    STA L5EF8,X
    EOR #&FF
    BPL C2098
    CLC
    ADC #1
    STA L5F00,X
    INC L0077
    INY
    CPY L008A
    BNE C2049
    CLC
    RTS

.C2098
    SEC
    RTS

.sub_C209A
    LDY L008E
.C209C
    LDA L38FC
    STA L0079
    LDA #0
    STA L0048
    STA L008C
    LDX L3550,Y
    LDA L5EF8,X
    CLC
    ADC L0036
    BMI C210C
    CMP #&50 ; 'P'
    BCC C20B8
    LDA #&4F ; 'O'
.C20B8
    STA L007F
    LDX L35D0,Y
    LDA L5EF8,X
    CLC
    ADC L0036
    BMI C20CA
    CMP L62FD
    BCS C20CF
.C20CA
    LDA L62FD
    NOP
    NOP
.C20CF
    CMP L007F
    BCS C210C
    STA L0047
    LDX L3650,Y
    LDA L5EF8,X
    STA L007E
    LDX L36D0,Y
    LDA L5EF8,X
    STA L0083
    LDA L3750,Y
    STA L0084
    STY L001B
    LDY #1
    JSR sub_C1C1C
.C20F1
    BIT L0084
    BMI C2117
    LDA #0
    LDY #2
    JSR sub_C1C1C
    BIT L0084
    BVS C2106
    LDY L001B
.loop_C2102
    INY
    JMP C209C

.C2106
    RTS

.loop_C2107
    AND #&40 ; '@'
    BNE C2106
    INY
.C210C
    LDA L3750,Y
    BMI loop_C2107
    AND #&40 ; '@'
    BNE C2106
    BEQ loop_C2102
.C2117
    LDY L001B
    INY
    STY L001B
    LDX L3650,Y
    LDA L5EF8,X
    STA L0083
    LDA L36D0,Y
    STA L0084
    LDY #0
    JSR sub_C1C1C
    LDY L001B
    LDX L3550,Y
    LDA L5EF8,X
    STA L0083
    LDA L3750,Y
    STA L0084
    LDY #0
    JSR sub_C1C1C
    JMP C20F1

.sub_C2145
    LDY #0
.sub_C2147
    LDA L0900,X
    SEC
    SBC L6280,Y
    STA L0080
    LDA L0A00,X
    SBC L6283,Y
    STA L0086
    BPL C2165
    LDA #0
    SEC
    SBC L0080
    STA L0080
    LDA #0
    SBC L0086
.C2165
    STA L0083
    LDA L0902,X
    SEC
    SBC L6282,Y
    STA L0082
    LDA L0A02,X
    SBC L6285,Y
    STA L0088
    BPL C2185
    LDA #0
    SEC
    SBC L0082
    STA L0082
    LDA #0
    SBC L0088
.C2185
    STA L0085
    CMP L0083
    BCC C2193
    BNE C21A6
    LDA L0082
    CMP L0080
    BCS C21A6
.C2193
    LDA L0085
    STA L0079
    LDA L0082
    STA L0078
    LDA L0080
    STA L007A
    LDA L0083
    STA L007B
    JMP C21C1

.C21A6
    PHP
    LDA L0083
    STA L0079
    LDA L0080
    STA L0078
    LDA L0082
    STA L007A
    LDA L0085
    STA L007B
    PLP
    BEQ C220D
    JMP C2239

.loop_C21BD
    ASL L0082
    ROL L0085
.C21C1
    ASL L0080
    ROL A
    BCC loop_C21BD
    ROR A
    STA L0076
    LDA L0082
    STA L0074
    LDA L0085
    CMP L0076
    BEQ C220D
    JSR sub_C0C47
    LDA #0
    STA L008A
    LDY L0074
    LDA L6100,Y
    STA L007E
    LSR A
    ROR L008A
    LSR A
    ROR L008A
    LSR A
    ROR L008A
    STA L008B
    LDA L0086
    EOR L0088
    BMI C21FF
    LDA #0
    SEC
    SBC L008A
    STA L008A
    LDA #0
    SBC L008B
    STA L008B
.C21FF
    LDA #&40 ; '@'
    BIT L0086
    BPL C2207
    LDA #&C0
.C2207
    CLC
    ADC L008B
    STA L008B
    RTS

.C220D
    LDA #&FF
    STA L007E
    LDA #0
    STA L008A
    BIT L0086
    BPL C2227
    BIT L0088
    BPL C2222
    LDA #&A0
    STA L008B
    RTS

.C2222
    LDA #&E0
    STA L008B
    RTS

.C2227
    BIT L0088
    BPL C2230
    LDA #&60 ; '`'
    STA L008B
    RTS

.C2230
    LDA #&20 ; ' '
    STA L008B
    RTS

.loop_C2235
    ASL L0080
    ROL L0083
.C2239
    ASL L0082
    ROL A
    BCC loop_C2235
    ROR A
    STA L0076
    LDA L0080
    STA L0074
    LDA L0083
    CMP L0076
    BEQ C220D
    JSR sub_C0C47
    LDA #0
    STA L008A
    LDY L0074
    LDA L6100,Y
    STA L007E
    LSR A
    ROR L008A
    LSR A
    ROR L008A
    LSR A
    ROR L008A
    STA L008B
    LDA L0086
    EOR L0088
    BPL C2277
    LDA #0
    SEC
    SBC L008A
    STA L008A
    LDA #0
    SBC L008B
    STA L008B
.C2277
    LDA #0
    BIT L0088
    BPL C227F
    LDA #&80
.C227F
    CLC
    ADC L008B
    STA L008B
    RTS

.sub_C2285
    LDY #0
.sub_C2287
    LDA L0901,X
    SEC
    SBC L6281,Y
    STA L0081
    LDA L0A01,X
    SBC L6284,Y
    STA L0087
    BPL C22A5
    LDA #0
    SEC
    SBC L0081
    STA L0081
    LDA #0
    SBC L0087
.C22A5
    LSR A
    ROR L0081
    LSR A
    ROR L0081
    LSR A
    ROR L0081
    STA L0084
    CMP L007D
    BCC C22BE
    BNE C22BC
    LDA L0081
    CMP L007C
    BCC C22BE
.C22BC
    SEC
    RTS

.C22BE
    LDY #0
    LDA L007D
    JMP C22CA

.loop_C22C5
    ASL L0081
    ROL L0084
    INY
.C22CA
    ASL L007C
    ROL A
    BCC loop_C22C5
    ROR A
    STA L0076
    STY L002B
    TAY
    LDA L6180,Y
    STA L002A
    LDA L0081
    STA L0074
    LDA L0084
    JSR sub_C0C47
    LDA L0074
    CMP #&80
    BCS C22FE
    BIT L0087
    BPL C22F5
    LDA #&3C ; '<'
    SEC
    SBC L0074
    JMP C22F8

.C22F5
    CLC
    ADC #&3C ; '<'
.C22F8
    SEC
    SBC L000D
    STA L008D
    CLC
.C22FE
    RTS

.sub_C22FF
    LDA L62F5
    BEQ C230C
    JSR sub_C12A0
    LDA #0
    STA L62F5
.C230C
    LDY L0005
    CPY #6
    BEQ C22FE
    LDY L0006
    CPY #6
    BEQ C2330
.loop_C2318
    CPY L0008
    BEQ C232B
    STY L0074
    TYA
    CLC
    ADC #&28 ; '('
    TAY
    JSR sub_C0BA2
    LDY L0074
    JSR sub_C0BA2
.C232B
    INY
    CPY #6
    BCC loop_C2318
.C2330
    LDA #6
    SEC
    SBC L0008
    ASL A
    ASL A
    ASL A
    BIT L0025
    BPL C234F
    STA L0074
    LDA L06FF
    CLC
    ADC #8
    SEC
    SBC L0074
    BCS C235B
    ADC L59FA
    JMP C235B

.C234F
    CLC
    ADC L06FF
    CMP L59FA
    BCC C235B
    SBC L59FA
.C235B
    TAY
    STY L0004
    LDX L0008
.C2360
    STX L0042
    LDX #&FD
    JSR sub_C1208
    JSR sub_C2145
    LDY L0042
    BIT L0025
    BPL C2374
    TYA
    EOR #&28 ; '('
    TAY
.C2374
    JSR sub_C23C0
    LDX L0042
    CPX #&28 ; '('
    BCS C239A
    LDX #&FD
    JSR sub_C2285
    LDX L0042
    LDA L008D
    STA L5F20,X
    STA L5F48,X
    CMP L001F
    BCC C239A
    BNE C2396
    CPX L0051
    BCC C239A
.C2396
    STA L001F
    STX L0051
.C239A
    TXA
    CLC
    ADC #&28 ; '('
    CMP #&3C ; '<'
    BCS C23AC
    TAX
    LDA L0004
    CLC
    ADC #3
    TAY
    JMP C2360

.C23AC
    LDX L0008
    DEX
    JSR sub_C12DC
    LDA #7
    CMP L0052
    BCS C23BA
    STA L001F
.C23BA
    RTS

.sub_C23BB
    JSR sub_C2145
    LDY L0012
.sub_C23C0
    LDA L008A
    SEC
    SBC L000A
    STA L5E40,Y
    LDA L008B
    SBC L000B
    STA L5E90,Y
    JMP C0CA5

.sub_C23D2
    STA L0012
    LDA #0
    STA L0042
.C23D8
    JSR sub_C23BB
    CMP L0011
    BCC C23E7
    BNE C23FC
    LDA L0010
    CMP L007C
    BCC C23FC
.C23E7
    LDA L007D
    STA L0011
    LDA L007C
    STA L0010
    LDA L0042
    STA L0013
    LDY L0012
    STY L005C
    LDA L5E90,Y
    STA L005E
.C23FC
    JSR sub_C2285
    BCS C2403
    BPL C246A
.C2403
    LDA L0042
    BNE C2408
    RTS

.C2408
    LDA #0
    STA L0075
    LDY L0014
    STX L0077
.C2410
    LDA L0900,X
    SEC
    SBC L0900,Y
    STA L0074
    LDA L0A00,X
    SBC L0A00,Y
    CLC
    BPL C2423
    SEC
.C2423
    PHP
    ROR A
    ROR L0074
    PLP
    ROR A
    ROR L0074
    STA L0076
    LDX L0075
    LDA L0900,Y
    CLC
    ADC L0074
    STA L09FA,X
    LDA L0A00,Y
    ADC L0076
    STA L0AFA,X
    INX
    CPX #3
    BEQ C2450
    STX L0075
    LDX L0077
    INY
    INX
    STX L0077
    JMP C2410

.C2450
    LDX #&FA
    JSR sub_C23BB
    JSR sub_C2285
    BCS C2469
    LDX L0014
    LDA L0057
    STA L0056
    JSR sub_C2565
    LDA L0056
    STA L0057
    INC L0012
.C2469
    RTS

.C246A
    JSR sub_C2565
    LDA L0042
    CMP L0013
    BEQ C2490
    BCC C2490
    LDY L0012
    LDA L5E90,Y
    BPL C247E
    EOR #&FF
.C247E
    CMP #&14
    BCC C2490
    LDA L5E8F,Y
    BPL C2489
    EOR #&FF
.C2489
    CMP #&14
    BCS C24B8
    JMP C2403

.C2490
    STX L0014
    INC L0012
    INC L0042
    LDY L0042
    CPY #&12
    BCS C24B8
    LDA L3DD0,Y
    STA L0074
    TXA
    SEC
    SBC L000E
    CMP L0074
    BCS C24B0
    TXA
    CLC
    ADC #&78 ; 'x'
    JMP C24B1

.C24B0
    TXA
.C24B1
    SEC
    SBC L0074
    TAX
    JMP C23D8

.C24B8
    RTS

.sub_C24B9
    LDA L0044
    SEC
    SBC L62E2
    BPL C24C3
    EOR #&FF
.C24C3
    ASL A
    CMP #&80
    EOR L0025
    BPL C24D6
    BCC C24CE
    EOR #&7F
.C24CE
    CMP #&FC
    BCS C24D6
    JSR sub_C13FB
    RTS

.C24D6
    LDA L0013
    CMP #&0C
    BEQ C24E1
    BCS C24E9
    JSR sub_C12F3
.C24E1
    BIT L0043
    BPL C24F5
    JSR sub_C12F3
    RTS

.C24E9
    CMP #&0E
    BCC C24F5
    BEQ C24F2
    JSR sub_C140B
.C24F2
    JSR sub_C140B
.C24F5
    RTS

.sub_C24F6
    LDA #0
    STA L001F
    JSR sub_C22FF
    LDA #&FF
    STA L0011
    LDA #&0D
    STA L0013
    LDA #0
    JSR sub_C254A
    LDA #6
    JSR sub_C23D2
    LDA L0012
    STA L0015
    LDA #&80
    JSR sub_C254A
    LDA #&2E ; '.'
    JSR sub_C23D2
    LDA L0051
    CMP #&28 ; '('
    BCC C2528
    SEC
    SBC #&28 ; '('
    STA L0051
.C2528
    TAY
    STY L0052
    LDA L001F
    CMP #&4F ; 'O'
    BCC C2535
    LDA #&4E ; 'N'
    STA L001F
.C2535
    STA L5F20,Y
    STA L5F48,Y
    LDA L5E90,Y
    SEC
    SBC L5EB8,Y
    JSR sub_C3450
    LSR A
    STA L62FC
    RTS

.sub_C254A
    LDX L0024
    EOR L0025
    BPL C255A
    TXA
    CLC
    ADC #&78 ; 'x'
    TAX
    LDA #&78 ; 'x'
    SEC
    BNE C255D
.C255A
    LDA #0
    CLC
.C255D
    STA L000E
    LDA #0
    ROL A
    STA L0049
    RTS

.sub_C2565
    LDY L0049
    CPX #&78 ; 'x'
    BCS C2570
    LDA L0702,X
    BCC C2573
.C2570
    LDA L068A,X
.C2573
    AND L306C,Y
    STA L0077
    AND #7
    TAY
    LDA L306E,Y
    STA L0076
    LDA L0042
    CMP #3
    BCS C2589
    JMP C25FD

.C2589
    LDA L002B
    SEC
    SBC L3076,Y
    TAY
    LDA #0
    STA L0075
    LDA L002A
    DEY
    BEQ C25A9
    BPL C25A3
.loop_C259B
    LSR L0075
    ROR A
    INY
    BNE loop_C259B
    BEQ C25A9
.C25A3
    ASL A
    ROL L0075
    DEY
    BNE C25A3
.C25A9
    STA L0074
    LDA L0049
    LSR A
    ROR A
    EOR L0025
    BPL C25C0
    LDA #0
    SEC
    SBC L0074
    STA L0074
    LDA #0
    SBC L0075
    STA L0075
.C25C0
    LDY L0012
    LDA L5E40,Y
    CLC
    ADC L0074
    STA L5E50,Y
    LDA L5E90,Y
    ADC L0075
    STA L5EA0,Y
    LDA L0077
    AND #&18
    BEQ C25FD
    LDY L0057
    CPY #3
    BCS C25FD
    LDA L0012
    STA L62B4,Y
    LDA L0077
    STA L6299,Y
    AND #1
    BEQ C25F1
    LSR L0075
    ROR L0074
.C25F1
    LDA L0074
    STA L62B7,Y
    LDA L0075
    STA L62BA,Y
    INC L0057
.C25FD
    TXA
    AND #1
    BEQ C2606
    LDA #2
    BNE C2608
.C2606
    LDA L0076
.C2608
    LDY L0012
    STA L5EE0,Y
    LDA L008D
    STA L5F20,Y
    CMP #&50 ; 'P'
    BCS C261E
    CMP L001F
    BCC C261E
    STA L001F
    STY L0051
.C261E
    RTS

.sub_C261F
    LDX #&16
.loop_C2621
    LDA L018C,X
    ORA #&80
    STA L018C,X
    DEX
    BPL loop_C2621
    RTS

.loop_C262D
    LDX #6
.C262F
    DEC L0074
    BNE C262F
    DEX
    BNE C262F
    RTS

.sub_C2637
    LDA L5F3B
    BMI loop_C262D
    LDX L005B
    LDY L013C,X
    LDA L018C,Y
    AND #&7F
    STA L018C,Y
    JSR sub_C27ED
    JSR sub_C2692
    JSR sub_C261F
    JSR sub_C63A2
    LDX L0003
    LDY #5
.loop_C2659
    BIT L0025
    BPL C2663
    JSR sub_C5084
    JMP C2666

.C2663
    JSR sub_C507E
.C2666
    STY L62F4
    STX L001D
    JSR sub_C28F2
    LDX L001D
    LDY L62F4
    DEY
    BPL loop_C2659
    JSR sub_C66DF
    LDX L005B
    JSR sub_C28F2
    RTS

.sub_C267F
    LDA L013C,X
    STA L0074
    LDA L013C,Y
    STA L013C,X
    TAX
    LDA L0074
    STA L013C,Y
    TAY
    RTS

.sub_C2692
    LDX L0003
.C2694
    STX L0077
    LDA L013C,X
    STA L0074
    JSR sub_C507E
    LDA L013C,X
    STX L0078
    TAY
    LDX L0074
    LDA #0
    STA L007F
    STA L0114,X
    JSR sub_C27A4
    BCS C26E6
    BPL C26E9
    CMP #&F6
    BCC C26E6
    LDX L0077
    LDY L0078
    JSR sub_C267F
    SEC
    ROR L62FE
    CPY L006F
    BNE C26CB
    LDA #&99
    BNE C26D1
.C26CB
    CPX L006F
    BNE C26E6
    LDA #1
.C26D1
    STA L0074
    LDA L04B4,Y
    ROL L0079
    SBC L04B4,X
    BNE C26E6
    SED
    CLC
    LDA L0074
    ADC L002F
    STA L002F
    CLD
.C26E6
    JMP C278C

.C26E9
    CMP #5
    BCS C26E6
    LDA C3850,X
    CLC
    SBC C3850,Y
    LDA L0150,X
    SBC L0150,Y
    ROR L0076
    BPL C26E6
    LSR A
    CMP #&1E
    BCC C2705
    LDA #&1E
.C2705
    CMP #4
    BCS C270B
    LDA #4
.C270B
    STA L0083
    LDA L0074
    CMP #4
    LDA L0100,Y
    AND #&40 ; '@'
    BEQ C2729
    BCS C271C
    ORA #&80
.C271C
    STA L007F
    LDA L0178,X
    CMP L0178,Y
    ROR L0074
    JMP C277D

.C2729
    BCS C2742
    LDA #&40 ; '@'
    STA L007F
    LDA L0178,Y
    CMP L0178,X
    ROR L0074
    AND #&FF
    JSR sub_C3450
    CMP #&3C ; '<'
    BCC C2744
    BCS C2749
.C2742
    LSR L0076
.C2744
    LDA L0178,Y
    STA L0074
.C2749
    LDA L018C,X
    BPL C275E
    LDA user_via_t2c_l
    AND #&1F
    BNE C278C
    LDA L0076
    AND #&80
    ORA L007F
    JMP C278A

.C275E
    LDA L0178,Y
    SEC
    SBC L0178,X
    BCS C2769
    EOR #&FF
.C2769
    CMP #&64 ; 'd'
    BCS C278C
    CMP #&50 ; 'P'
    BCS C2786
    CMP #&3C ; '<'
    BCS C277D
    LDA L0076
    AND #&80
    ORA L007F
    STA L007F
.C277D
    LDA L0074
    AND #&80
    ORA L0083
    STA L0114,X
.C2786
    LDA L007F
    ORA #&10
.C278A
    STA L007F
.C278C
    LDA L0100,X
    LSR A
    LDA L007F
    BCS C2797
    STA L0100,X
.C2797
    LDX L0077
    JSR sub_C5084
    CPX L0003
    BEQ C27A3
    JMP C2694

.C27A3
    RTS

.sub_C27A4
    LDA L0164,Y
    SEC
    SBC L0164,X
.sub_C27AB
    LDA L08D0,Y
    SBC L08D0,X
    STA L0074
    LDA L08E8,Y
    SBC L08E8,X
    PHP
    BPL C27BF
    JSR sub_C0E40
.C27BF
    STA L0075
    SEC
    BEQ C27D8
    PLA
    EOR #&80
    PHP
    LDA L59FC
    SEC
    SBC L0074
    STA L0074
    LDA L59FD
    SBC L0075
    BNE C27EA
    CLC
.C27D8
    ROR L0079
    LDA L0074
    CMP #&80
    BCS C27EA
    PLP
    JSR sub_C3450
    STA L0074
    LDA L0074
    CLC
    RTS

.C27EA
    PLP
    SEC
.loop_C27EC
    RTS

.sub_C27ED
    LDA L006D
    BMI loop_C27EC
    LDX #&14
    JMP C28E7

.C27F6
    LDA L0100,X
    BMI C285B
    LDY L06E8,X
    LDA L5900,Y
    BPL C280D
    LDA L0150,X
    CMP L01A4,X
    BCS C287F
    BCC C282F
.C280D
    LSR A
    BCS C282F
    LDA L5307,Y
    STA L01A4,X
    CLC
    SBC L0150,X
    BCS C282F
    LSR A
    LSR A
    ORA #&C0
    STA L0074
    LDA L0880,X
    SEC
    SBC L5305,Y
    BCS C287F
    CMP L0074
    BCS C285B
.C282F
    LDA L0150,X
    CMP #&3C ; '<'
    BCS C2838
    LDA #&16
.C2838
    STA L0074
    LDA L0100,X
    AND #&40 ; '@'
    BEQ C2843
    LDA #5
.C2843
    CLC
    ADC L0128,X
    BIT L006C
    BPL C284E
    SBC L5A1A
.C284E
    LDY #0
    SEC
    SBC L0074
    BCS C2856
    DEY
.C2856
    STY L0075
    JMP C2861

.C285B
    LDA #&FF
    STA L0075
    LDA #0
.C2861
    ASL A
    ROL L0075
    ASL A
    ROL L0075
    CLC
    ADC C3850,X
    STA C3850,X
    LDA L0075
    ADC L0150,X
    CMP #&BE
    BCC C287C
    LDA #0
    STA C3850,X
.C287C
    STA L0150,X
.C287F
    LDA #1
    STA L0076
.loop_C2883
    LDA L0150,X
    CLC
    ADC L0164,X
    STA L0164,X
    BCC C2892
    JSR sub_C147C
.C2892
    DEC L0076
    BPL loop_C2883
    LDA L018C,X
    ASL A
    BCS C28E7
    BMI C28CE
    LDA L0114,X
    AND #&40 ; '@'
    BEQ C28CE
    LDA L0178,X
    EOR L0114,X
    BPL C28CE
    LDA L0178,X
    BPL C28C1
    CMP #&EC
    BCC C28BB
    DEC L0178,X
    BCS C28E7
.C28BB
    CMP #&E2
    BCC C28CE
    BCS C28E7
.C28C1
    CMP #&14
    BCS C28CA
    INC L0178,X
    BCC C28E7
.C28CA
    CMP #&1E
    BCC C28E7
.C28CE
    LDA L0114,X
    AND #&BF
    CLC
    BPL C28DF
    EOR #&7F
    ADC L0178,X
    BCS C28E4
    BCC C28E7
.C28DF
    ADC L0178,X
    BCS C28E7
.C28E4
    STA L0178,X
.C28E7
    DEX
    BMI C28F1
    CPX L006F
    BEQ C28E7
    JMP C27F6

.C28F1
    RTS

.sub_C28F2
    LDA L013C,X
    STA L0045
    STA L0042
    TAX
    LDY #&17
    SEC
    JSR sub_C27AB
    BCS C2911
    EOR L0025
    BMI C2911
    LDA L0074
    JSR sub_C3450
    STA L0074
    CMP #&28 ; '('
    BCC C2914
.C2911
    JMP C2AA6

.C2914
    ASL A
    CLC
    ADC L0074
    EOR #&FF
    SEC
    ADC L0024
    BPL C2922
    CLC
    ADC #&78 ; 'x'
.C2922
    TAY
    LDA L0100,X
    AND #&10
    BNE C2937
    LDA L0150,X
    CMP #&32 ; '2'
    BCC C2937
    LDA L0701,Y
    STA L0114,X
.C2937
    LDA L0700,Y
    STA L000C
    STY L0074
    TAY
    LDA L0164,X
    STA L0084
    LDA L0178,X
    STA L0085
    LDA L5400,Y
    STA L0086
    LDA L5500,Y
    STA L0087
    LDA L5600,Y
    STA L0088
    LDX #0
    LDA L0084
    STA L0075
    LDY L0074
.C2960
    LDA #0
    STA L0076
    LDA L0086,X
    BPL C297B
    EOR #&FF
    CLC
    ADC #1
    JSR sub_C0C00
    EOR #&FF
    CLC
    ADC #1
    BCS C297E
    DEC L0076
    BCC C297E
.C297B
    JSR sub_C0C00
.C297E
    CLC
    ADC L0900,Y
    STA L09FD,X
    LDA L0A00,Y
    PHP
    CPX #1
    BNE C298F
    AND #&1F
.C298F
    PLP
    ADC L0076
    STA L0AFD,X
    INY
    INX
    CPX #3
    BNE C2960
    LDY L000C
    LDA L5700,Y
    STA L0086
    LDA L5800,Y
    STA L0088
    LDX #0
    LDA L0085
    STA L0075
.C29AD
    LDA #0
    STA L0076
    LDA L0086,X
    BPL C29C8
    EOR #&FF
    CLC
    ADC #1
    JSR sub_C0C00
    EOR #&FF
    CLC
    ADC #1
    BCS C29CB
    DEC L0076
    BCC C29CB
.C29C8
    JSR sub_C0C00
.C29CB
    ASL A
    ROL L0076
    ASL A
    ROL L0076
    CLC
    ADC L09FD,X
    STA L09FD,X
    LDA L0AFD,X
    ADC L0076
    STA L0AFD,X
    INX
    INX
    CPX #4
    BNE C29AD
    LDA L09FE
    CLC
    ADC #&90
    STA L09FE
    BCC C29F4
    INC L0AFE
.C29F4
    LDA #4
    JSR sub_C2A5D
    LDX L0045
    LDA L0055
    CMP #3
    BCS C2A50
    LDA L001D
    CMP L004D
    BNE C2A4D
    LDA L018C,X
    BMI C2A0F
    DEC L018C,X
.C2A0F
    LDY L000C
    JSR sub_C1442
    JSR sub_C2B0E
    LDY #&FD
    LDX #&FA
    JSR sub_C0BCC
    JSR sub_C2B0E
    LDX #&F4
    JSR sub_C0BCC
    JSR sub_C2B0E
    LDX #&FD
    JSR sub_C0BCC
    LDA #&14
    STA L0042
    LDA #2
    JSR sub_C2A5D
    LDA #&15
    STA L0042
    LDA #1
    LDX #&F4
    JSR sub_C2A5F
    LDA #&16
    STA L0042
    LDA #0
    LDX #&FA
    JSR sub_C2A5F
.C2A4D
    LDX L0045
    RTS

.C2A50
    CMP #5
    BCC C2A4D
    LDA L018C,X
    BMI C2A4D
    INC L018C,X
    RTS

.sub_C2A5D
    LDX #&FD
.sub_C2A5F
    STA L0037
    JSR sub_C2145
    LDY L0042
    LDA L008A
    STA L0380,Y
    LDA L008B
    STA L0398,Y
    JSR sub_C2AB1
    JSR sub_C2285
.sub_C2A76
    LDY L0042
    BCS C2AA6
    SEC
    SBC #1
    BMI C2AA6
    STA L03B0,Y
    LDA L002B
    SEC
    SBC #9
    TAX
    LDA L002A
    DEX
    BEQ C2A99
    BPL C2A95
.loop_C2A8F
    LSR A
    INX
    BNE loop_C2A8F
    BEQ C2A99
.C2A95
    ASL A
    DEX
    BNE C2A95
.C2A99
    STA L03C8,Y
    LDA L018C,Y
    AND #&70 ; 'p'
    ORA L0037
    JMP C2AAD

.C2AA6
    LDY L0042
    LDA L018C,Y
    ORA #&80
.C2AAD
    STA L018C,Y
    RTS

.sub_C2AB1
    LDY #&25 ; '%'
.sub_C2AB3
    JSR C0CA5
    LDA L007D
    STA L0055
    BNE C2ACA
    CPY L007C
    BCC C2ACA
    DEC L0068
    LDA L007C
    STA L0041
    LDA L0042
    STA L0067
.C2ACA
    RTS

.sub_C2ACB
    STX L0045
    LDA L013C,X
    TAX
.sub_C2AD1
    LDA L018C,X
    BMI C2B0B
    AND #&0F
    STA L0037
    LDA L0380,X
    SEC
    SBC L000A
    STA L0074
    LDA L0398,X
    SBC L000B
    BPL C2AEF
    CMP #&E0
    BCC C2B0B
    BCS C2AF3
.C2AEF
    CMP #&20 ; ' '
    BCS C2B0B
.C2AF3
    ASL L0074
    ROL A
    ASL L0074
    ROL A
    CLC
    ADC #&50 ; 'P'
    STA L0035
    LDA L03B0,X
    STA L0036
    LDA L03C8,X
    STA L002A
    JSR sub_C1FB4
.C2B0B
    LDX L0045
    RTS

.sub_C2B0E
    LDX #2
.loop_C2B10
    LDA L0083,X
    CLC
    BPL C2B16
    SEC
.C2B16
    ROR L0083,X
    ROR L0074,X
    DEX
    BPL loop_C2B10
    RTS

.L2B1E
    EQUB 5, 6, 6, 5
.L2B22
    EQUB &A4, &50, 0  , &54
.sub_C2B26
    PHP
    STA L0054
    LDA #0
    STA L001E
    LDA L5F20,Y
    SEC
    SBC #1
    CMP #&4E ; 'N'
    BCS C2B40
    LDA L5E90,X
    BPL C2B3E
    EOR #&FF
.C2B3E
    CMP #&14
.C2B40
    ROR L0088
    LDA L5E90,X
    STA L0077
    LDA L5E40,X
    ASL A
    ROL L0077
    ASL A
    ROL L0077
    LDA L0077
    CLC
    ADC #&80
    STA L0077
    LDA L5F20,Y
    STA L0082
    STX L0045
    STY L001B
    PLP
    BCS C2BCA
    BIT L0088
    BVC C2B7B
    BMI C2BCA
    LDX L007E
    LDY L007F
    LDA L0077
    STA L007E
    LDA L0082
    STA L007F
    STX L0077
    STY L0082
    DEC L001E
.C2B7B
    LDA L0082
    SEC
    SBC L007F
    STA L0087
    BPL C2B89
    LDA #0
    SEC
    SBC L0087
.C2B89
    STA L0084
    LDA L0088
    AND #&C0
    BEQ C2BCD
    LDY L0045
    LDX L004F
    LDA L5E40,Y
    SEC
    SBC L5E40,X
    STA L0074
    LDA L5E90,Y
    SBC L5E90,X
    STA L0086
    JSR sub_C0E40
    CMP #&40 ; '@'
    BCS C2BB9
    ASL L0074
    ROL A
    CMP #&40 ; '@'
    BCS C2BBB
    ASL L0074
    ROL A
    BPL C2BBD
.C2BB9
    LSR L0084
.C2BBB
    LSR L0084
.C2BBD
    STA L0083
    LDA L0086
    EOR L001E
    STA L0086
    LDA L0083
    JMP C2BDB

.C2BCA
    JMP C2CFC

.C2BCD
    LDA L007E
    SEC
    SBC L0077
    ROR L0086
    BMI C2BDB
    EOR #&FF
    CLC
    ADC #1
.C2BDB
    STA L0083
    BNE C2BE3
    ORA L0084
    BEQ C2BCA
.C2BE3
    LDA L0088
    AND #&C0
    BEQ C2BED
    LDA L0086
    AND #&80
.C2BED
    STA L0053
    LDA L0087
    BNE C2BF9
    LDA L001E
    EOR #&FF
    STA L0087
.C2BF9
    BPL C2BFF
    LDA #&88
    BNE C2C01
.C2BFF
    LDA #&C8
.C2C01
    STA C2F60
    STA C2FA2
    LDA #&EA
    STA C2F47
    STA C2F89
    LDY L0054
    LDX #0
.loop_C2C13
    LDA L5FD0,Y
    STA L628F,X
    AND L33FC,X
    STA L629C,X
    INY
    INX
    CPX #4
    BNE loop_C2C13
    LDA L0027
    ASL A
    ASL A
    ASL A
    STA L0074
    LDA L628F
    LSR A
    LSR A
    LSR A
    AND #3
    ORA L0074
    ORA #&40 ; '@'
    STA L0034
    LDA L628F
    BNE C2C44
    LDA #&55 ; 'U'
    STA L628F
.C2C44
    STA L008B
    LDA L6292
    LSR A
    AND #1
    BIT L6292
    BPL C2C53
    ORA #2
.C2C53
    ORA #&80
    ORA L0074
    STA L0033
    LDA L001B
    CLC
    ADC #1
    CMP L004B
    BEQ C2C68
    LDA L0082
    CMP #&50 ; 'P'
    BCC C2C70
.C2C68
    LDA #0
    BIT L0087
    BMI C2C70
    LDA #&4F ; 'O'
.C2C70
    STA L0082
    LDA L007E
    SEC
    SBC #&30 ; '0'
    STA L0075
    LSR A
    LSR A
    STA L0085
    CMP #&28 ; '('
    BCS C2CE6
    LSR A
    CLC
    ADC #&30 ; '0'
    STA Q
    STA S
    CLC
    ADC #1
    STA L008F
    LDA L0075
    AND #7
    TAX
    LDY L007F
    LDA L0083
    CMP L0084
    BCC C2CEF
    LDA L628F
    CMP #&FF
    BEQ C2CB4
    LDA L0033
    AND #3
    CMP #3
    BEQ C2CB4
    LDA #&60 ; '`'
    STA C2FD7
    STA C2FC0
    BNE C2CDF
.C2CB4
    LDA #&E0
    STA C2FD7
    STA C2FC0
    LDA L0027
    CMP #2
    ROR A
    EOR L0086
    BPL C2CDF
    LDA C2F60
    STA C2F47
    STA C2F89
    LDA #&EA
    STA C2F60
    STA C2FA2
    LDA L0087
    BPL C2CDE
    INY
    JMP C2CDF

.C2CDE
    DEY
.C2CDF
    LDA L0086
    BPL C2CE9
    JSR sub_C2D9A
.C2CE6
    JMP C2CFC

.C2CE9
    JSR sub_C2D17
    JMP C2CFC

.C2CEF
    LDA L0086
    BPL C2CF9
    JSR sub_C2E99
    JMP C2CFC

.C2CF9
    JSR sub_C2E20
.C2CFC
    LDA L001E
    BMI C2D08
    LDA L0077
    STA L007E
    LDA L0082
    STA L007F
.C2D08
    LDX L0045
    LDY L001B
    RTS

    EQUB &A5, &53, &F0, &EB, &20, &12, &2F, &4C, &FC, &2C
.sub_C2D17
    LDA L3E50,X
    STA L2D28
    LDX #&80
    LDA L0083
    EOR #&FF
    CLC
    ADC #1
    CLC
.sub_C2D27
L2D28 = sub_C2D27+1
    BCC C2D29
.C2D29
    LDX #&80
    ADC L0084
    BCC C2D36
    SBC L0083
    LDX #0
    JSR sub_C2F45
.C2D36
    ADC L0084
    BCC C2D41
    SBC L0083
    LDX #1
    JSR sub_C2F45
.C2D41
    ADC L0084
    BCC C2D4C
    SBC L0083
    LDX #2
    JSR sub_C2F45
.C2D4C
    ADC L0084
    BCC C2D57
    SBC L0083
    LDX #3
    JSR sub_C2F45
.C2D57
    JSR C2FD7
    INC L0085
    ADC L0084
    BCC C2D67
    SBC L0083
    LDX #0
    JSR sub_C2F87
.C2D67
    ADC L0084
    BCC C2D72
    SBC L0083
    LDX #1
    JSR sub_C2F87
.C2D72
    ADC L0084
    BCC C2D7D
    SBC L0083
    LDX #2
    JSR sub_C2F87
.C2D7D
    ADC L0084
    BCC C2D88
    SBC L0083
    LDX #3
    JSR sub_C2F87
.C2D88
    JSR C2FC0
    INC S
    INC Q
    INC L008F
    INC L0085
    LDX S
    CPX #&44 ; 'D'
    BNE C2D29
    RTS

.sub_C2D9A
    LDA L40D0,X
    STA L2DAB
    LDX #&80
    LDA L0083
    EOR #&FF
    CLC
    ADC #1
    CLC
.sub_C2DAA
L2DAB = sub_C2DAA+1
    BCC C2DAC
.C2DAC
    LDX #&80
    ADC L0084
    BCC C2DB9
    SBC L0083
    LDX #3
    JSR sub_C2F87
.C2DB9
    ADC L0084
    BCC C2DC4
    SBC L0083
    LDX #2
    JSR sub_C2F87
.C2DC4
    ADC L0084
    BCC C2DCF
    SBC L0083
    LDX #1
    JSR sub_C2F87
.C2DCF
    ADC L0084
    BCC C2DDA
    SBC L0083
    LDX #0
    JSR sub_C2F87
.C2DDA
    JSR C2FC0
    DEC L0085
    ADC L0084
    BCC C2DEA
    SBC L0083
    LDX #3
    JSR sub_C2F45
.C2DEA
    ADC L0084
    BCC C2DF5
    SBC L0083
    LDX #2
    JSR sub_C2F45
.C2DF5
    ADC L0084
    BCC C2E00
    SBC L0083
    LDX #1
    JSR sub_C2F45
.C2E00
    ADC L0084
    BCC C2E0B
    SBC L0083
    LDX #0
    JSR sub_C2F45
.C2E0B
    JSR C2FD7
    DEC S
    DEC Q
    DEC L008F
    DEC L0085
    LDX S
    CPX #&2F ; '/'
    CLC
    BNE C2DAC
    JMP C2F12

.sub_C2E20
    LDA L3ED0,X
    STA L2E2F
    LDA L0084
    EOR #&FF
    CLC
    ADC #1
    CLC
.sub_C2E2E
L2E2F = sub_C2E2E+1
    BCC C2E30
.C2E30
    LDX #0
    JSR sub_C2F45
    ADC L0083
    BCC C2E30
    SBC L0084
.loop_C2E3B
    LDX #1
    JSR sub_C2F45
    ADC L0083
    BCC loop_C2E3B
    SBC L0084
.loop_C2E46
    LDX #2
    JSR sub_C2F45
    ADC L0083
    BCC loop_C2E46
    SBC L0084
.loop_C2E51
    LDX #3
    JSR sub_C2F45
    ADC L0083
    BCC loop_C2E51
    SBC L0084
    INC L0085
.loop_C2E5E
    LDX #0
    JSR sub_C2F87
    ADC L0083
    BCC loop_C2E5E
    SBC L0084
.loop_C2E69
    LDX #1
    JSR sub_C2F87
    ADC L0083
    BCC loop_C2E69
    SBC L0084
.loop_C2E74
    LDX #2
    JSR sub_C2F87
    ADC L0083
    BCC loop_C2E74
    SBC L0084
.loop_C2E7F
    LDX #3
    JSR sub_C2F87
    ADC L0083
    BCC loop_C2E7F
    SBC L0084
    INC S
    INC Q
    INC L008F
    INC L0085
    LDX S
    CPX #&44 ; 'D'
    BNE C2E30
    RTS

.sub_C2E99
    LDA L3ED8,X
    STA L2EA8
    LDA L0084
    EOR #&FF
    CLC
    ADC #1
    CLC
.sub_C2EA7
L2EA8 = sub_C2EA7+1
    BCC C2EA9
.C2EA9
    LDX #3
    JSR sub_C2F87
    ADC L0083
    BCC C2EA9
    SBC L0084
.loop_C2EB4
    LDX #2
    JSR sub_C2F87
    ADC L0083
    BCC loop_C2EB4
    SBC L0084
.loop_C2EBF
    LDX #1
    JSR sub_C2F87
    ADC L0083
    BCC loop_C2EBF
    SBC L0084
.loop_C2ECA
    LDX #0
    JSR sub_C2F87
    ADC L0083
    BCC loop_C2ECA
    SBC L0084
    DEC L0085
.loop_C2ED7
    LDX #3
    JSR sub_C2F45
    ADC L0083
    BCC loop_C2ED7
    SBC L0084
.loop_C2EE2
    LDX #2
    JSR sub_C2F45
    ADC L0083
    BCC loop_C2EE2
    SBC L0084
.loop_C2EED
    LDX #1
    JSR sub_C2F45
    ADC L0083
    BCC loop_C2EED
    SBC L0084
.loop_C2EF8
    LDX #0
    JSR sub_C2F45
    ADC L0083
    BCC loop_C2EF8
    SBC L0084
    DEC S
    DEC Q
    DEC L008F
    DEC L0085
    LDX S
    CPX #&2F ; '/'
    CLC
    BNE C2EA9
.C2F12
    LDA C2F47
    STA C2F18
.C2F18
    NOP
.C2F19
    LDA L001E
    BMI C2F22
    LDA L0034
    JMP C2F2A

.C2F22
    DEY
    LDA L5F60,Y
    BNE C2F44
    LDA L0033
.C2F2A
    CPY #&50 ; 'P'
    BCS C2F44
    LDX L62F2
    CPX #&28 ; '('
    BCC C2F41
    STA L0074
    AND #3
    CMP #3
    LDA L0074
    BCS C2F41
    AND #&FC
.C2F41
    STA L5F60,Y
.C2F44
    RTS

.sub_C2F45
    STA L008A
.C2F47
    NOP
    CPY L0082
    BEQ C2F7E
    LDA L0085
.sub_C2F4E
L2F4F = sub_C2F4E+1
L2F50 = sub_C2F4E+2
    STA L7000,Y
    LDA (R),Y
    BNE C2F63
    LDA L628F,X
.C2F58
    STA (R),Y
    LDA L008B
    STA (P),Y
.loop_C2F5E
    LDA L008A
.C2F60
    INY
    CLC
    RTS

.C2F63
    CPY #&2C ; ','
    BCS C2F6C
    JSR sub_C2FEE
    BCC loop_C2F5E
.C2F6C
    CMP #&55 ; 'U'
    BNE C2F72
    LDA #0
.C2F72
    AND L337C,X
    ORA L629C,X
    BNE C2F58
    LDA #&55 ; 'U'
    BNE C2F58
.C2F7E
    TSX
    INX
    INX
    TXS
    LDA L0053
    BNE C2F19
    RTS

.sub_C2F87
    STA L008A
.C2F89
    NOP
    CPY L0082
    BEQ C2F7E
    LDA L0085
.sub_C2F90
L2F91 = sub_C2F90+1
L2F92 = sub_C2F90+2
    STA L7000,Y
    LDA (P),Y
    BNE C2FA5
    LDA L628F,X
.C2F9A
    STA (P),Y
    LDA L008B
    STA (L008E),Y
.loop_C2FA0
    LDA L008A
.C2FA2
    INY
    CLC
    RTS

.C2FA5
    CPY #&2C ; ','
    BCS C2FAE
    JSR sub_C2FEE
    BCC loop_C2FA0
.C2FAE
    CMP #&55 ; 'U'
    BNE C2FB4
    LDA #0
.C2FB4
    AND L337C,X
    ORA L629C,X
    BNE C2F9A
    LDA #&55 ; 'U'
    BNE C2F9A
.C2FC0
    CPX #&80
    BNE C2FD3
    CPY #&2C ; ','
    BCS C2FCD
    JSR sub_C2FEE
    BCC C2FD3
.C2FCD
    TAX
    LDA #&FF
    STA (P),Y
    TXA
.C2FD3
    LDX #&80
    CLC
    RTS

.C2FD7
    CPX #&80
    BNE C2FEA
    CPY #&2C ; ','
    BCS C2FE4
    JSR sub_C2FEE
    BCC C2FEA
.C2FE4
    TAX
    LDA #&FF
    STA (R),Y
    TXA
.C2FEA
    LDX #&80
    CLC
    RTS

.sub_C2FEE
    STA L0074
    STX L0075
    LDX L0085
    TYA
    CMP L3900,X
    BNE C2FFB
    CLC
.C2FFB
    LDA L0074
    LDX L0075
    RTS

    EQUB &FE, &1F, &0A, &0C, &83
    EQUS "STANDARD OF"
    EQUB &D7, &1F, &0E, &0E, &FF, &FC, &A3, &FC, &A3, &FC, &A1, &FF
    EQUB &A8, &A9, &F0, &C4, &82, &B0, &0C, &C4, &7F, &90, 8  , &AE
    EQUB &68, &FE, &3D, 0  , &20, &25, &61, &91, &70, &88, &10, &14
    EQUB &98, &29, 7  , &C9, 7  , &90, &0D, &A5, &70, &38, &E9, &38
    EQUB &85, &70, &A5, &71, &E9, 1  , &85, &71, &C4, &77, &B0, &D1
    EQUB &A4, &78, &60, &FF, 0  , 0  , 0  , 0  , 6  , 6  , 6  , 6  
    EQUB 6  , 6  , 6  , 3  , 3  , 3  , 3  , 3  , 1  , 1  , 1  , 0  
    EQUB 0  , 0  , 5  , 4  , 3  , 2  , 1  
    EQUB 0
.L306C
    EQUB &2D, &33
.L306E
    EQUB 0, 0, 1, 1, 1, 1, 1, 1
.L3076
    EQUB 5  , 5  , 3  , 4  , 3  , 4  , 4  , 4  , &38, &38, &97, &97
    EQUB &97, &97, &A8, &A8, &A8, &A8, &A8, &A8, &A8, &A8, &A8, &A8
    EQUB &A8, &A8, &A8, &A8, &A8, &A8, &A8, &A8, &B9, &B9, &B9, &B9
    EQUB &B9, &B9, &33, &A8, &20, 0  , &7E, &84, &75, &BC, &50, &30
    EQUB &39, &F9, &36, &19, &F9, &35, &A4, &75, &91, &72, &E0, 3  
    EQUB &F0, 3  , &4C, &18, &7F, &4C, &BF, &7B, &85, &82, &84, &78
    EQUB &B9, &9E, &3B, &85, &71, &B9, &26, &3B, &85, &70, &B9, &FA
    EQUB &3E, &85, &77, &B9, &FA, &40, &28, &8D, &7C, &7C, &7C, &7C
    EQUB &7C, &6B, &6B, &6B, &6B, &6B, &5A, &5A, &5A, &5A, &49, &49
    EQUB &49, &49, &38, &38, &38, &38, &27, &27, &27, &27, &16, &16
    EQUB &16, &16, &16, &16, &16, &16, &16, &16, &16, 5  , 5  , 5  
    EQUB 5  , 5  
.L30FC
    EQUB &10, 0  , 0  , &10
.L3100
    EQUB &1C, &1C, &1C, &1C, &1C, &1B, &1B, &1B, &1B, &1A, &1A, &1A
    EQUB &19, &19, &18, &18, &17, &16, &15, &14, &14, &14, &81, &81
    EQUB &81, &81, &81, &81, &79, &35, &A8, &20, 0  , &7C, &3D, &D0
    EQUB &38, &1D, &50, &33, &91, &70, &BC, &80, &30, &CC, &7D, &7F
    EQUB &F0, &10, &A9, &91, &8D, &0F, &7E, &8C, &88, &7F, &8C, &7D
    EQUB &7F, &A9, &60, &8D, 0  , &7E, &BC, &D0, &30, &8C, &9B, &7F
    EQUB &BD, 0  , &44, &3D, &50, &39, &1D, &D0, &42, &64, &75, &75
    EQUB &75, &75, &75, &86, &86, &86, &86, &86, &97, &97, &97, &97
    EQUB &A8, &A8, &A8, &A8, &B9, &B9, &B9, &B9, &CA, &CA, &CA, &CA
    EQUB &DB, &DB, &DB, &DB, &DB, &DB, &DB, &DB, &DB, &DB, &DB, &EC
    EQUB &EC, &EC, &EC, &EC, &28, &28, 0  , 0  , &81, &81, &81, &81
    EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81
    EQUB &81, &81, &81, &81, &81, &81, &24, &7F, &A9, &60, &8D, 0  
    EQUB &7C, &A4, &70, &C8, &98, &29, 7  , &D0, &14, &98, &18, &69
    EQUB &38, &85, &70, &85, &72, &A5, &71, &69, 1  , &85, &71, &69
    EQUB 1  , &85, &73, &90, 4  , &84, &70, &84, &72, &A9, &F1, &38
    EQUB &FD, &80, &30, &8D, &68, &7F, &BC, &50, &30, &BD, 4  , 5  
    EQUB &39, &79, &36, &19
.C31D0
    LDX #3
.loop_C31D2
    CPY L001F
    BCC C31DB
    LDA L3D7C,X
    BNE C31DE
.C31DB
    LDA L3D78,X
.C31DE
    STA (P),Y
    STA L0504,Y
    STA L4400,Y
    DEX
    BPL C31EB
    LDX #3
.C31EB
    DEY
    CPY L0075
    BNE loop_C31D2
    INC L0074
    LDA P
    EOR #&80
    STA P
    BMI C31FC
    INC Q
.C31FC
    JMP C3D68

    EQUB 0  , &20, &35, &FF, &81, &80, &43, &F0, 8  , &A9, 0  , &9D
    EQUB &80, &43, &B9, 0  , &60, &A0, &38, &91, &72, &E0, &2C, &F0
    EQUB &25, &CA, &A4, &70, &C8, &98, &29, 7  , &F0, 7  , &84, &70
    EQUB &84, &72, &4C, &F7, &7B, &98, &18, &69, &38, &85, &70, &85
    EQUB &72, &A5, &71, &69, 1  , &85, &71, &69, 1  , &85, &73, &4C
    EQUB &F7, &7B, &60, &CA, &BC, &50, &31, &CC, &24, &7F, &F0, &10
    EQUB &A9, &91, &8D, &0F, &7C, &8C, &2F, &7F, &8C
.sub_C3250
    STY S
    STA R
    LDY #0
.loop_C3256
    LDA (R),Y
    JSR sub_C5092
    INY
    CPY #&0C
    BNE loop_C3256
    RTS

.sub_C3261
    LDX #&FF
    JSR sub_C0E50
    BNE C327B
    LDX #&86
    JSR sub_C0E50
    BNE C327B
    BIT L001C
    BMI C327D
.sub_C3273
    LDX L006B
    TXS
    ROR L001C
    JMP C63E0

.C327B
    LSR L001C
.C327D
    RTS

    EQUB 0  , 0  , &31, &30, &FF, &41, &B9, 0  , &60, &A0, &10, &91
    EQUB &72, &BC, &80, &41, &F0, 8  , &A9, 0  , &9D, &80, &41, &B9
    EQUB 0  , &60, &A0, &18, &91, &72, &BC, 0  , &42, &F0, 8  , &A9
    EQUB 0  , &9D, 0  , &42, &B9, 0  , &60, &A0, &20, &91, &72, &BC
    EQUB &80, &42, &F0, 8  , &A9, 0  , &9D, &80, &42, &B9, 0  , &60
    EQUB &A0, &28, &91, &72, &BC, 0  , &43, &F0, 8  , &A9, 0  , &9D
    EQUB 0  , &43, &B9, 0  , &60, &A0, &30, &91, &72, &BC
.sub_C32D0
    LDA L0074
    CMP #&20 ; ' '
    BNE C32D8
    LDA #&30 ; '0'
.C32D8
    SEC
    SBC #&30 ; '0'
    CMP #&0A
    BCS C32FB
    STA L0074
    LDX L0075
    CPX #&20 ; ' '
    CLC
    BEQ C32FB
    ASL A
    ASL A
    ADC L0074
    ASL A
    STA L0074
    TXA
    SEC
    SBC #&30 ; '0'
    CMP #&0A
    BCS C32FB
    ADC L0074
    CMP #&29 ; ')'
.C32FB
    RTS

.L32FC
    EQUB &66, &67, &5F, &5E, &32, &30, &FF, &BC, 0  , &3F, &F0, 8  
    EQUB &A9, 0  , &9D, 0  , &3F, &B9, 0  , &60, &A0, &F0, &91, &70
    EQUB &BC, &80, &3F, &F0, 8  , &A9, 0  , &9D, &80, &3F, &B9, 0  
    EQUB &60, &A0, &F8, &91, &70, &BC, 0  , &40, &F0, 8  , &A9, 0  
    EQUB &9D, 0  , &40, &B9, 0  , &60, &A0, 0  , &91, &72, &BC, &80
    EQUB &40, &F0, 8  , &A9, 0  , &9D, &80, &40, &B9, 0  , &60, &A0
    EQUB 8  , &91, &72, &BC, 0  , &41, &F0, 8  , &A9, 0  , &9D, 0  
    EQUB 0  , 0  , &F0, &70, &30, &10, 0  , &70, &70, &30, &10, 0  
    EQUB &70, &30, &10, 0  , &70, &30, &10, 0  , &70, &30, &10, 0  
    EQUB &70, &30, &10, 0  , &70, &40, &30, &20, &30, &10, &10, &10
    EQUB 0  , 0  , 0  , &40, &70, &40, &30, &30
.L337C
    EQUB 0  , &88, &CC, &EE, &81, &81, &81, &81, &81, &81, &81, &60
    EQUB &A0, &C8, &91, &70, &BC, 0  , &3D, &F0, 8  , &A9, 0  , &9D
    EQUB 0  , &3D, &B9, 0  , &60, &A0, &D0, &91, &70, &BC, &80, &3D
    EQUB &F0, 8  , &A9, 0  , &9D, &80, &3D, &B9, 0  , &60, &A0, &D8
    EQUB &91, &70, &BC, 0  , &3E, &F0, 8  , &A9, 0  , &9D, 0  , &3E
    EQUB &B9, 0  , &60, &A0, &E0, &91, &70, &BC, &80, &3E, &F0, 8  
    EQUB &A9, 0  , &9D, &80, &3E, &B9, 0  , &60, &A0, &E8, &91, &70
    EQUB 0  , 0  , &F0, &E0, &C0, &80, 0  , &E0, &E0, &C0, &80, 0  
    EQUB &E0, &C0, &80, 0  , &E0, &C0, &80, 0  , &E0, &C0, &80, 0  
    EQUB &E0, &C0, &80, 0  , &E0, &20, &C0, &40, &C0, &80, &80, &80
    EQUB 0  , 0  , 0  , &20, &E0, &20, &C0, &C0
.L33FC
    EQUB &FF, &77, &33, &11
    EQUS "ENTER "
    EQUB &FF, &81, &81, &81, &81, &81, &60, &A0, &A8, &91, &70, &BC
    EQUB 0  , &3B, &F0, 8  , &A9, 0  , &9D, 0  , &3B, &B9, 0  , &60
    EQUB &A0, &B0, &91, &70, &BC, &80, &3B, &F0, 8  , &A9, 0  , &9D
    EQUB &80, &3B, &B9, 0  , &60, &A0, &B8, &91, &70, &BC, 0  , &3C
    EQUB &F0, 8  , &A9, 0  , &9D, 0  , &3C, &B9, 0  , &60, &A0, &C0
    EQUB &91, &70, &BC, &80, &3C, &F0, 8  , &A9, 0  , &9D, &80, &3C
    EQUB &B9, 0  
.sub_C3450
    BPL C3457
    EOR #&FF
    CLC
    ADC #1
.C3457
    RTS

.L3458
L3468 = L3458+16
L3478 = L3458+32
L347C = L3458+36
    EQUB 7  , &17, &47, &57, &23, &33, &63, &73, &80, &90, &C0, &D0
    EQUB &A5, &B5, &E5, &F5, 3  , &13, &23, &33, &43, &53, &63, &73
    EQUB &84, &94, &A4, &B4, &C4, &D4, &E4, &F4, &26, &36, &66, &76
    EQUB &A1, &B1, &E1, &F1, &1F, &0D, &12
    EQUS "front"
    EQUB &A2, &85, &D8, &FF, &81, &81, &81, &81, &70, &BC, 0  , &39
    EQUB &F0, 8  , &A9, 0  , &9D, 0  , &39, &B9, 0  , &60, &A0, &90
    EQUB &91, &70, &BC, &80, &39, &F0, 8  , &A9, 0  , &9D, &80, &39
    EQUB &B9, 0  , &60, &A0, &98, &91, &70, &BC, 0  , &3A, &F0, 8  
    EQUB &A9, 0  , &9D, 0  , &3A, &B9, 0  , &60, &A0, &A0, &91, &70
    EQUB &BC, &80, &3A, &F0, 8  , &A9, 0  , &9D, &80, &3A, &B9, 0  
.sub_C34D0
    LDA #0
.sub_C34D2
    STA L0078
    LDX #&1E
    JSR sub_C4D7E
.loop_C34D9
    LDX #&9D
    JSR sub_C0E50
    BEQ loop_C34D9
.C34E0
    LDX #&9D
    JSR sub_C0E50
    BEQ C34F7
    JSR sub_C3261
    BIT L0078
    BPL C34E0
    LDX #&B6
    JSR sub_C0E50
    BNE C34E0
    LSR L0078
.C34F7
    RTS

.L34F8
    EQUB &80, &40, &20, &10, 0  , 0  , 0  , 0  
    EQUS "Amateur"
    EQUB &FF
    EQUS " POINTS"
    EQUB &FF, &81, &81, &81, &81, &D0, &38, &1D, &50, &33, &91, &70
    EQUB &BD, 0  , &44, &3D, &50, &39, &1D, &D0, &33, &A8, &20, 0  
    EQUB &7E, &E0, &1C, &D0, &C5, &4C, &18, &7F, &BC, 0  , &38, &F0
    EQUB 8  , &A9, 0  , &9D, 0  , &38, &B9, 0  , &60, &A0, &80, &91
    EQUB &70, &BC, &80, &38, &F0, 8  , &A9, 0  , &9D, &80, &38, &B9
    EQUB 0  , &60, &A0, &88, &91
.L3550
    EQUB &0F, &0F, &0E, &0E, &0D, 5  , 6  , &0F, 4  , &0E, 0  , &0D
    EQUB &0F, &0F, 2  , 3  , 4  , 9  , 6  , &0F, &0E, 0  , &0D, 7  
    EQUB 4  , &0A, 0  , 1  , &0C, &0C, 2  , 1  , 1  , &0A, 3  , 4  
    EQUB 0  , 1  , 3  , 1  , 3  , 0  , &80, &C0, &40, &60, &E0, &20
    EQUB &20, &20, &9C
.L3583
    EQUB &86, &9D
.L3585
    EQUB &84, &FF
    EQUS "ACCUMULATED"
    EQUB &FB, &FF, &81, &81, &81, &81, 8  , &A9, 0  , &9D, &80, &37
    EQUB &B9, 0  , &60, &A0, &78, &91, &70, &4C, &56, &7D, &A9, &60
    EQUB &8D, &EE, &7E, &CA, &BC, &50, &31, &CC, &24, &7D, &F0, &16
    EQUB &A9, &91, &8D, &0F, &7C, &8C, &2F, &7D, &8C, &24, &7D, &A9
    EQUB &60, &8D, 0  , &7C, &BC, &D0, &30, &8C, &4D, &7D, &20, &F3
    EQUB &7E, &3D
.L35D0
    EQUB &0E, &0E, &0B, &0B, &0B, 6  , &0F, &0D, 5  , &0D, 7  , &0B
    EQUB &0E, &0E, 3  , 4  , 9  , 8  , &0F, &0D, &0D, 7  , 9  , &0D
    EQUB 6  , 9  , 2  , &0C, &0A, &0A, 8  , 2  , &0A, 8  , 4  , &0A
    EQUB 3  , 3  , &0A, 3  , &0A, 0  , &10, &30, &20, &60, &70, &40
    EQUS "FORMULA 3  CHAMPIONSHIP"
    EQUB &FF, &81, &81, &81, &81, &F0, 8  , &A9, 0  , &9D, 0  , &36
    EQUB &B9, 0  , &60, &A0, &60, &91, &70, &BC, &80, &36, &F0, 8  
    EQUB &A9, 0  , &9D, &80, &36, &B9, 0  , &60, &A0, &68, &91, &70
    EQUB &BC, 0  , &37, &F0, 8  , &A9, 0  , &9D, 0  , &37, &B9, 0  
    EQUB &60, &A0, &70, &91, &70, &BC, &80, &37, &F0
.L3650
    EQUB 9  , 2  , 8  , 4  , &0A, &0D, &0B, 9  , &0E, 8  , 4  , 8  
    EQUB 9  , 2  , 8  , 8  , &0D, &0D, &0C, &0B, 8  , 2  , 8  , &0F
    EQUB &0A, 8  , 9  , 8  , 9  , 3  , &0B, &0B, 8  , &0B, 8  , 8  
    EQUB 1  , 8  , 8  , 9  , 1  , &FF, &77, &33, &33, &11, &11, &11
    EQUB &AB
    EQUS "YOUR TIME IS UP!"
    EQUB &AB, &FF
    EQUS "PRESS "
    EQUB &FF, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81
    EQUB &81, &81, &A0, &48, &91, &70, &BC, 0  , &35, &F0, 8  , &A9
    EQUB 0  , &9D, 0  , &35, &B9, 0  , &60, &A0, &50, &91, &70, &BC
    EQUB &80, &35, &F0, 8  , &A9, 0  , &9D, &80, &35, &B9, 0  , &60
    EQUB &A0, &58, &91, &70, &BC, 0  , &36
.L36D0
    EQUB &0A, 1  , &0C, 0  , 2  , 5  , 3  , 1  , 6  , &0C, 9  , 0  
    EQUB &0A, 1  , 0  , 0  , 5  , 5  , 4  , 3  , &0A, 9  , 0  , 7  
    EQUB 2  , 0  , 1  , 0  , &0B, 1  , 3  , 1  , 0  , 3  , 0  , 9  
    EQUB 0  , 1  , 9  , 0  , 0  , &FF, &EE, &CC, &CC, &88, &88, &88
    EQUB &FE, &EB, &A7, &D3
    EQUS "NAME OF"
    EQUB &D4, &1F, &0C, &11, &83
    EQUS "____________"
    EQUB &1F, 9  , &10, &85, &D8, &FF, &1F, 2  , &0A, &86, &FF, &81
    EQUB &81, &81, &81, &81, 0  , &60, &A0, &38, &91, &70, &BC, 0  
    EQUB &34, &F0, 8  , &A9, 0  , &9D, 0  , &34, &B9, 0  , &60, &A0
    EQUB &40, &91, &70, &BC, &80, &34, &F0, 8  , &A9, 0  , &9D, &80
    EQUB &34, &B9, 0  , &60
.L3750
    EQUB &0A, &0A, 8  , 8  , &45, 8  , 8  , 9  , &4A, &88, 8  , 8  
    EQUB &0A, &4A, 2  , 0  , 2  , &4A, 8  , 5  , &88, 8  , 8  , 2  
    EQUB &42, &48, &52, 8  , &11, &51, 0  , &48, &0A, &52, 0  , 0  
    EQUB &40, 0  , &40, 0  , &40
.L3779
    EQUS "RN12345Position"
    EQUB &A8
    EQUS "In front:"
    EQUB &AD, &FF
    EQUS "Laps to go"
    EQUB &A8
    EQUS "Behind:"
    EQUB &B2, &FF, &C6, &FF, &81, &81, &32, &B9, 0  , &60, &A0, &28
    EQUB &91, &70, &BC, 0  , &33, &F0, 8  , &A9, 0  , &9D, 0  , &33
    EQUB &B9, 0  , &60, &A0, &30, &91, &70, &BC, &80, &33, &F0, 8  
    EQUB &A9, 0  , &9D, &80, &33, &B9
.sub_C37D0
    STX L62CC
    STY L62CD
.sub_C37D6
    PHA
    LSR A
    LSR A
    LSR A
    LSR A
    BNE C37E5
    LDA #&1F
    BIT L0078
    BMI C37E5
    LDA #&F0
.C37E5
    CLC
    ADC #&30 ; '0'
    JSR sub_C5092
    ASL L0078
    PLA
    ASL L0078
    BCS C37FE
    AND #&0F
    BNE C37F8
    LDA #&1F
.C37F8
    CLC
    ADC #&30 ; '0'
    JSR sub_C5092
.C37FE
    RTS

    EQUB &FF, &FE, &EC, &DA, &D5, &ED, &DB, &D5, &EE, &DC, &D5, &EB
    EQUB &D2
    EQUS "DURATION OF QUALIFYING LAPS"
    EQUB &FF
    EQUS " ] "
    EQUB &FF, &9D, &80, &31, &B9, 0  , &60, &A0, &18, &91, &70, &BC
    EQUB 0  , &32, &F0, 8  , &A9, 0  , &9D, 0  , &32, &B9, 0  , &60
    EQUB &A0, &20, &91, &70, &BC, &80, &32, &F0, 8  , &A9, 0  , &9D
    EQUB &80
.C3850
    LDA #osbyte_set_cursor_editing
    LDY #0
    LDX #1
    JSR osbyte
    JSR sub_C4F39
    LDX #9
    LDA #0
    STA L0069
.loop_C3862
L3864 = loop_C3862+2
    STA L05F4,X
    DEX
    BPL loop_C3862
    LDA #&F6
    STA L05FE
    TSX
    STX L006B
    JSR sub_C5A22
    LDA #osbyte_read_write_adc_conversion_type
    LDY #0
.sub_C3877
L3878 = sub_C3877+1
    LDX #&20 ; ' '
    JSR osbyte
    JMP C63E0

    EQUB &FF, &EC
    EQUS "PRACTICE"
    EQUB &ED
    EQUS "COMPETITION"
    EQUB &FF, &FF, &AD
    EQUS "PLEASE"
    EQUB &A2
    EQUS "WAIT"
    EQUB &AD, &FF, &1F, 9  , 2  , &FF, &81, &81, &81, &A9, 0  , &9D
    EQUB &80, &30, &B9, 0  , &60, &A0, 8  , &91, &70, &BC, 0  , &31
    EQUB &F0, 8  , &A9, 0  , &9D, 0  , &31, &B9, 0  , &60, &A0, &10
    EQUB &91, &70, &BC, &80, &31, &F0, 8  , &A9, 0  , &FF, &FF, &88
    EQUB &88, &CC, &EE, &FF, &88, &88, &CC, &EE, &FF, &88, &CC, &EE
    EQUB &FF, &88, &CC, &EE, &FF, &88, &CC, &EE, &FF, &88, &CC, &EE
    EQUB &FF, &88, &88, &CC, &CC, &CC, &EE, &EE, &EE, &FF, &FF, &FF
    EQUB &88, &88, &88, &CC, &CC
.L38FC
    EQUB 0
.L38FD
    EQUB &0F
.L38FE
    EQUB &F0
.L38FF
    EQUB &FF
.L3900
    EQUB &1B, &1B, &1B, &15, 3  , 2  , 2  , 6  , &0B, &0F, &13, &17
    EQUB &1B
    EQUS "&++++++++++++&"
    EQUB &1B, &17, &13, &0F, &0B, 6  , 2  , 2  , 3  , &15, &1B, &1B
    EQUB &1B, &1B, &FF, &81, &81, &F3, &7E, &4C, &13, &7D, &BD, &60
    EQUB &5F, &29, 3  , &A8, &B9, &FC, &38, &BC, 0  , &30, &F0, 8  
    EQUB &A9, 0  , &9D, 0  , &30, &B9, 0  , &60, &A0, 0  , &91, &70
    EQUB &BC, &80, &30, &F0, 8  , &FF, &FF, &11, &11, &33, &77, &FF
    EQUB &11, &11, &33, &77, &FF, &11, &33, &77, &FF, &11, &33, &77
    EQUB &FF, &11, &33, &77, &FF, &11, &33, &77, &FF, &11, &11, &33
    EQUB &33, &33, &77, &77, &77, &FF, &FF, &FF, &11, &11, &11, &33
    EQUB &33
.L397C
    EQUB &75, &75, &75, &75
.L3980
    EQUB &35, &35, &35, &35, &35, &35, &35, &35, &34, &34, &34, &34
    EQUB &34, &34, &33, &33, &33, &32, &32, &32, &31, &31, &30, &30
    EQUB &2F, &2F, &2E, &2E, &2D, &2D, &2C, &2C, &2B, &2A, &29, &28
    EQUB &27, &26, &A2, &9C, 8  , 8  , &E7, &FF, &8D, &DA, &7B, &A9
    EQUB &91, &8D, &0F, &7C, &8D, &0F, &7C, &8D, &0F, &7E, &A9, &E0
    EQUB &8D, &EE, &7E, &60, &A9, 0  , &85, &70, &85, &72, &A2, &67
    EQUB &86, &71, &E8, &86, &73, &A2, &4F, &20
.L39D0
    EQUB &77, &33, &11, 0  
.L39D4
    EQUB &80, 1  , &C1, &81, &C2, &42, &C0, &83, &43, &20, 4  , &84
.L39E0
    EQUB &9D, &CF, &CE, &EE
.L39E4
    EQUB &DD, &EE, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
.L39F8
    EQUB &77, &BB, &DD, &EE, &77, &BB, &DD, &EE, &1F, 5  , &18, &86
    EQUB &D9
    EQUS "SPACE BAR TO CONTINUE"
    EQUB &FF, &45, &FF
    EQUS "GRID POSITIONS"
    EQUB &FF, &B8, 6  , &20, &D6, &37, 6  , &78, &B0, &0B, &A9, &2E
    EQUB &20, &92, &50, &BD, &A0, 6  , &20, &D6, &37, &60, &AD, &24
    EQUB &7D, &8D, &D4, &7B, &AD, &24, &7F, &8D, &D7, &7B, &AD, &7D
    EQUB &7F
.sub_C3A50
    LDY #1
.loop_C3A52
    LDA L3A71,Y
    STA L0074
    LDX L3A6F,Y
    LDA #&97
    STA L7C79,X
    LDA #&E2
.loop_C3A61
    INX
    STA L7C79,X
    LDA #&E6
    CPX L0074
    BNE loop_C3A61
    DEY
    BPL loop_C3A52
    RTS

.L3A6F
    EQUB 0  , &78
.L3A71
    EQUB &23, &9B, &AF
    EQUS "FINISHED"
    EQUB &AF, &FF, 0  , 0  , &A6
    EQUS "Less than one minute to go"
    EQUB &A6, &FF, &1F, 5  , &14, &84, &9D, &86, &33, &A2, &9C, &A5
    EQUB &83, &FF, &81, &81, &81, &A9, &F0, &A2, 9  , &9D, &C0, &42
    EQUB &CA, &10, &FA, &68, &A2, 5  , &9D, &C2, &42, &45, &74, &CA
    EQUB &10, &F8, &60, &85, &78, &BD, &D0, 6  , &20, &D6, &37, &A9
    EQUB &3A, &20, &92, &50, &BD
.L3AD0
    EQUB 0  , 0  , &1D, &87, &15, &80, &80, &80, 0  , 7  , &80, 0  
    EQUB &88, &91, &97, &9D, &28, &93, 0  , &80, 0  , &80, 0  , 0  
    EQUB 0  , &80, 0  , 0  , 0  , 0  , 0  , &80, &A6, &E0, &13, &22
    EQUB &8A, 0  , &9D, &80, &80, &80, &80, &80, &94, &A8, &F3, 0  
    EQUB &97, &A5, &7A, 8  , &F5, &73
.L3B06
    EQUB &58, &59, &5A, &5B, &5D, &5E, &5F, &60, &62, &63, &64, &65
    EQUB &67, &68, &69, &6A, &6C, &6D, &6E, &6F, &71, &72, &73, &74
    EQUB &76, &77, &78, &79, &7B, &7C, &7D, &7E, &40, &48, &18, &30
    EQUB &70, &78, &D0, &1D, &E0, &A0, &F0, &0D, &CA, &10, &12, &E0
    EQUB &C0, &B0, &EF, &A9, &A5, &A0, &77, &D0, &0C, &A5, &6A, &29
    EQUB &3F, &D0, &F4, &A2, &28, &A9, &F2, &A0, 5  , &86, &6D, &48
    EQUB &84, &74
.L3B50
    EQUB &36, &42, &3A, &35, &30, &43, &3C, &3F, &35, &3E, &3E, &34
    EQUB &3E, &3C, &3C, &3C, &38, &36, &32, &32, &33, &3D, &38, &37
    EQUB &3C, &34, &30, &3D, &43, &3E, &3A, &35, &39, &40, &3D, &37
    EQUB &43, &3F, &3A, &38, &42, &3A, &36, &37, &37, &37, &3B, 0  
    EQUB &38, &38, &3C, &35, &42, &3A
.L3B86
    EQUB &E8, &88, &C8, &E8, &CA, &C8, &88, &CA
.L3B8E
    EQUB &88, &E8, &E8, &C8, &C8, &CA, &CA, &88, &18, &EA, &EA, &18
    EQUB &18, &EA, &EA, &18, &75, &75, &74, &75, &76, &76, &12, &11
    EQUB &10, &0E, &0D, &0C, &81, &81, &A5, &84, &99, &93, &62, &20
    EQUB &B6, &7F, &88, &10, &E5, &60, &A5, &6C, &10, &4D, &A6, &6D
    EQUB &F0, &49, &10, &10, &E0, &80, &D0, &0C, &24, &61, &10, 2  
    EQUB &A2, &F0, &A0, 0  , &A9, &80
.L3BD0
    EQUB 4  , 7  , 9  , 7  , 0  , &0B, 7  
.L3BD7
    EQUB 3, 0, 0, 0, 4, 4, 0
.L3BDE
    EQUB &AA, &AF, &B3, &AF, &A2, &B8, &AF
.L3BE5
    EQUB &81, &81, &85, &84, &A3, &83, &85
.L3BEC
    EQUB &83, &83, &87, &87, &7F, &84, &87, &16, 7  , &17, 0  , &0A
    EQUB &20, 0  , 0  , 0  , 0  , 0  , 0  , &FF, &EB, &D2
    EQUS "WING SETTINGS"
    EQUB &D8
    EQUS "range 0 to 40"
    EQUB &1F, &0E, &10
    EQUS "rear"
    EQUB &A2, &85, &D8, &FF, &81, &81, &81, &81, &E5, &74, &85, &7F
    EQUB &BD, &98, 3  , &38, &E5, &0B, &38, &E9, 4  , &4A, &4A, &4A
    EQUB &85, &76, &A0, 5  , &A5, &76, &D9, &A4, &3B, &F0, 9  , &B9
    EQUB &93, &62, &F0, &0C, &A9, 0  , &F0, 2  
.sub_C3C50
    LDX #5
    JSR sub_C41D0
    LDX #&18
    JSR sub_C4D7E
    JSR C3EE0
    STA L5F3E
    LDX #&19
    JSR sub_C4D7E
    JSR C3EE0
    STA L5F3D
    JSR sub_C34D0
    RTS

.sub_C3C6F
    LDA L5F3A
    CLC
    ADC #7
    TAX
    JSR sub_C4D7E
    RTS

    EQUB &1F, &18, 2  
.L3C7D
    EQUB &DA, &D6, &FF, &A2
    EQUS "BEST LAP TIMES"
    EQUB &A2, &FF
    EQUS " mins"
    EQUB &FF
    EQUS " laps"
    EQUB &FF
    EQUS " RACE"
    EQUB &FF
    EQUS "ins"
    EQUB &FF, &81, &81, &81, &81, &81, &44, &88, &F0, &F0, &F0, &F0
    EQUB &F0, &F0, &70, &30, &A4, &5B, &BE, &3C, 1  , &BD, &8C, 1  
    EQUB &30, &20, &BD, &C8, 3  , &4A, &4A, &4A, &85, &74, &18, &69
    EQUB &B6, &85, &84, &A9, &B6, &38
.L3CD0
    EQUB 0  , 5  , 9  , &0E, &12, &19, &1A, &1B, &1E, &20, &22, &25
    EQUB &27
.L3CDD
    EQUB 0
.L3CDE
    EQUB 8  , &10, &18, &1E, &26, &29, &2C, &31, &35, &39, &3E, &42
    EQUB &46
.sub_C3CEB
    TXA
    LSR A
    LSR A
    CLC
    ADC #&40 ; '@'
    TAY
    TXA
    AND #3
    ASL A
    ASL A
    STA L0074
    ASL A
    CLC
    ADC L0074
    ADC #&50 ; 'P'
    RTS

    EQUB &FE, &EC, &D3
    EQUS "ANOTHER"
    EQUB &D4, &ED
    EQUS "START"
    EQUB &D7, &FF, &8D
.L3D14
    EQUB &81, &9D
.L3D16
    EQUB &83
.L3D17
    EQUB &C8, &A2, &9C, &FF, &81, &81, &81, &81, &81, &81, &81, &81
    EQUB &81, &81, &81, &81, &0E, &0E, &0E, 0  , &80, &E0, &74, &77
    EQUB &77, &77, &77, 0  , &10, &70, &E2, &EE, &EE, &EE, &EE, &91
    EQUB &AA, 0  , &11, 0  , &33, &22, &11, &22, &44, &99, &22, &88
    EQUB &EE, &33, &44, &70, &30, &10, &10, &88, 0  
.sub_C3D50
    STA L0074
.loop_C3D52
    LDA #&20 ; ' '
    JSR sub_C5092
    DEC L0074
    BNE loop_C3D52
.loop_C3D5B
    RTS

.sub_C3D5C
    LDA #0
    STA L0000
    STA L0074
    STA P
    LDA #&30 ; '0'
    STA Q
.C3D68
    LDX L0074
    CPX #&28 ; '('
    BEQ loop_C3D5B
    LDA L3900,X
    STA L0075
    LDY #&46 ; 'F'
    JMP C31D0

.L3D78
    EQUB &AA, &77, &AA, &DD
.L3D7C
    EQUB &0A, 7  , &0A, &0D, &FE, &EC, &CF, &ED, &D0, &EE, &D1, &EB
    EQUB &A4, &D2
    EQUS "THE CLASS OF"
    EQUB &D7, &FF, &81, &81, &81, &81, &88, &88
    EQUB &44, &44, &44, &44, &44, 4  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 8  , 0  , 0  , 5  , 5  , 5  , 5  , 5  , &12, &12, &12
    EQUB &12, 3  , 1  , &41, 1  , 5  , 7  , 7  , 3  , &83, &83, &83
    EQUB &83, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &1C, &1D, &0C
    EQUB &0E, &0E
.L3DD0
    EQUB 0  , &27, &12, 9  , 3  , 3  , 3  , 3  , 3  , 3  , 3  , 3  
    EQUB 3  , 3  , 3  , 3  , 3  , 3  
.L3DE2
    EQUB &86, &8E, &8D, &8D, &EB, &8B, &DF, &96, &A6, &E9, &8C, &8A
    EQUB &CE, &EE
.L3DF0
    EQUB 4  , 9  , &19, 0  
.L3DF4
    EQUB 5  , &0A, &14
.L3DF7
    EQUB 9  , 6  , 4  , 3  , 2  , 1  , 1  , 0  , 0  , &FE, &EB, &A5
    EQUB &82, &D4, &D8, &FF
    EQUS "Professional"
    EQUB &FF, &81, &81, &81, &81, 0  , &10, &80, 0  , 0  , 7  , &0F
    EQUB 0  , 0  , 0  , 1  , 3  , &1E, &3C, &68, &16, &16, &3C, &68
    EQUB &F0, &80, &F0, 0  , &F0, &10, &F0, &10, &E1, &21, &E1, &21
    EQUB 8  , 8  , 8  , 9  , 8  , 1  , &40, 1  , 6  , 0  , 0  , 8  
    EQUB 8  , 8  , 8  , 8  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB &88
.L3E50
    EQUB 8  , &13, &1E, &29, &39, &44, &4F, &5A, 2  , &0D, &18, &23
    EQUB &33, &3E, &49, &54
.sub_C3E60
    TYA
    AND #1
    CLC
    ADC L0042
    TAX
    LDA L3E74,X
    STA L3585
    LDA L3E76,X
    STA L3583
    RTS

.L3E74
    EQUB &84, &85
.L3E76
    EQUB &86, &87, &81, &84, &83, &82, &83, &84, &81, &87
    EQUS "SELECT "
    EQUB &FF
    EQUS " DRIVER"
    EQUB &FF, &81, &81, &81, &81, &44, &44, &22, 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 9  , &0A, &0A, &0A, 9  
    EQUB 1  , 1  , 1  , 1  , 9  , 8  , &28, 0  , &F0, &80, &F0, &80
    EQUB &78, &48, &78, &48, &86, &86, &C3, &61, &F0, &10, &F0, 0  
    EQUB 0  , 0  , 0  , 8  , &0C, &87, &C3, &61, 0  , 0  , 0  , &10
    EQUB 0  , 0  , &0E, &0F, 0  
.L3ED0
    EQUB 0  , &0B, &16, &21, &2E, &39, &44, &4F
.L3ED8
    EQUB &4F, &44, &39, &2E, &21, &16, &0B, 0  
.C3EE0
    LDA #&74 ; 't'
    LDY #0
    LDX #2
    JSR sub_C6300
    JSR sub_C32D0
    BCC C3EF9
.loop_C3EEE
    DEY
    BMI C3EE0
    LDA #&7F
    JSR oswrch
    JMP loop_C3EEE

.C3EF9
    RTS

    EQUB &AA, &AC, &B0, &B0, &AC, &AA, &1F, 5  , &12, &84, &9D, &86
    EQUB &32, &A2, &9C, &A5, &83, &FF, &81, &81, &81, &81, &FF, &44
    EQUB &FF, &AA, &FF, &11, &FF, &11, &FF, &BB, &77, &CF, &47, &CF
    EQUB &8F, &8F, &8F, &8F, &8F, &0F, &0F, &0F, &0F, &0F, &0F, &0F
    EQUB &0F, &0A, &0E, &0E, &0C, &1C, &1C, &1C, &1C, &84, &84, &84
    EQUB &84, &0C, 8  , &28, 8  , 0  , 0  , 0  , 4  , &0A, &0A, &0A
    EQUB 4  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , &44, &44, &44
    EQUB &44
.L3F4F
    EQUB &44, &1B, &1B, &1B, &15, 3  , 2  , 2  , 2  , 6  , &0B, &0F
    EQUB &13, &17, &1B
    EQUS "&+++++++++++&"
    EQUB &1B, &17, &13, &0F, &0B, 6  , 2  , 2  , 2  , 3  , &15, &1B
    EQUB &1B, &1B, &20, &20, &20, &42, &65, &68, &69
    EQUS "Novice"
    EQUB &FF, &81, &81, &81, &81, &81, &40, &40, &62, &40, &51, &62
    EQUB &80, &70, &30, &30, &10, &98, 0  , &44, &88, &F0, &F0, &F0
    EQUB &F0, &F0, &F0, &F0, &70, &F0, &F0, &F0, &F0, &F0, &F0, &F0
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &E0, &C0, &E0, &C0, &80
    EQUB &80, &11, 0  , &22, &11, &44, &22, &99, &44, &11, &77, &CC
    EQUB &22, &88, &66, &33, &99, &22, &CC, &77, &AA, &88, &FF, &11
    EQUB &77, &AA, &88, &EA, &EA, &C8, &EA, &88, &C8, &EA, &C8, &EA
    EQUB &EA, &88, &EA, &C8, &88, &EA
.L3FE0
    EQUB 0  , &40, &80, &C0, 0  , &40, &80, &C0
.L3FE8
    EQUB &77, &BB, &DD, &EE, &77, &BB, &DD, &EE, 0  , &40, &80, &C0
    EQUB 0  , &40, &80, &C0, 0  , &40, &80, &C0, 0  , &40, &80, &C0
    EQUB &81, &81, &81, &81, &81, &81, &81, 7  , 1  , 1  , 0  , &88
    EQUB &88, &88, &88, 0  , 0  , 0  , 0  , 4  , 5  , 5  , 5  , 1  
    EQUB 1  , 0  , &20, 8  , 4  , 4  , 4  , &49, &48, &68, &2C, &24
    EQUB &24, &34, &16, &0F, &0B, 7  , &0F, &0F, 7  , 7  , 7  , &0F
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0F, &3A, &6C, &28, &6C, &6C
    EQUB &2C, &2C, &1C, &77, &66, &66, &77, &66, &66, &66, 0  , &CC
    EQUB &66, &66, &CC, &CC, &66, &66, 0  , &80
    EQUS "Max ThrottleJohnny TurboDavey RocketGloria Sla"
    EQUS "p "
    EQUB &81, &81, &81, &40, 0  , 8  , &0C, &0C, 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 2  , 2  , 2  , 2  , 2  
    EQUB 0  , 0  , 0  , &0C, 4  , &0C, 8  , &0C, 5  , 5  , 5  , 5  
    EQUB 5  , 0  , 0  , &10, 0  , 0  , 0  , &20, 0  , 1  , 3  , 3  
    EQUB &16, &34, &3C, &2C, &78, &48, &F0, &90, &C3, &43, &C2, &86
    EQUB &84, &84, &84, &1C, 0  , 0  , 0  , 0  , 6  , 4  , 6  , 2  
    EQUB 2  , 2  , 2  , 2  , 0  , 0  , 0  , 0  
.L40D0
    EQUB &5A, &4F, &44, &39, &29, &1E, &13, 8  , &54, &49, &3E, &33
    EQUB &23, &18, &0D, 2  , &0C, &1F
.L40E2
    EQUB 4
.L40E3
    EQUB 3  , &EA
.L40E5
    EQUB &AA, &EA, &1F, &24, 2  , &FF
.sub_C40EB
    LDA #0
    STA L06A0,X
    STA L06B8,X
    LDA #&10
    STA L06D0,X
    RTS

    EQUB &77, &C2, &C0, &BC, &BC, &C0, &C2, &81, &81, &81, &0F, &0F
    EQUB &0F, &0D, &0E, &0F, &0F, &0E, &0E, &0E, &29, &21, &61, &43
    EQUB &42, &42, &C2, &86, 8  , 8  , 0  , &41, 0  , 1  , 1  , 1  
    EQUB 1  , 0  , 0  , 8  , 8  , 8  , 0  , 8  , &0C, 8  , 8  , 0  
    EQUB &88, &88, &88, &88, &0E, &0A, &0E, 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , &14, &0A, &0E, &0A, 4  , &3C, &2C, &34, &16
    EQUB &12, &12, &12, 3  , &86, &C2, &C3, &43, &E1, &21, &F0, &90
    EQUB 0  , 0  , 0  
    EQUS "Hugh JengineDesmond DashPercy Veer  Gary Clipp"
    EQUS "er"
    EQUB &81, &81, &81, &81, &E0, &F0, &F0, &F0, &F0, &F0, 0  , 0  
    EQUB 0  , 0  , &80, &C0, &E0, &F0, &F0, &F0, &F0, &F0, &F0, &F0
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &E0, &E0, &C0
    EQUB &C0, &80, &91, 0  , &22, &11, 0  , &22, 0  , &55, &22, &99
    EQUB &44, &22, &99, 0  , &11, &77, &CC, &11, &EE, &33, &55, &22
    EQUB &77, &99, &22, &EE, &55, &DD, &45, &AB, &45, &67, &AB, &CF
    EQUB &47, &8B, &0F, &0F, &0F, &0F, &0F, &0F
.sub_C41D0
    LDA L3BD0,X
    STA L40E2
    LDA L3BD7,X
    STA L40E3
    LDA L3BDE,X
    STA L40E5
    LDA L3BE5,X
    STA L3D14
    LDA L3BEC,X
    STA L3D16
    TXA
    CLC
    ADC #&C8
    STA L3D17
    LDX #&21 ; '!'
    JSR sub_C4D7E
    RTS

    EQUB &79, &7B, &7C, &7D, &7E, &A5, &FB, &A6, &FF, &81, &81, &81
    EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81
    EQUB &81, &81, &81, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &1F
    EQUB &4A, &0E, &0F, &0F, &0F, &0F, &0F, 0  , &AA, &44, &33, &CC
    EQUB &AA, &66, &DC, &44, 0  , &22, &11, &FC, &E0, &80, 0  , 0  
    EQUB 0  , &44, &11, &C0, &70, &10, 0  , &F0, &70, &30, &30, &10
    EQUB &10, 0  , &80, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &70, &C0
    EQUB &C0
    EQUS "Willy SwerveSid Spoiler Billy BumperSlim Chanc"
    EQUS "e Lap Time"
    EQUB &A3, &3A, &A9
    EQUS "Best Time"
    EQUB &A8, &FF, &81, &81, &81, &81, &81, &81, &F0, &90, &E1, &21
    EQUB &F0, &61, &C3, &87, &86, &0C, &18, 0  , &0F, &0C, 8  , 0  
    EQUB 0  , 0  , 0  , 6  , &0F, 0  , 0  , 0  , 0  , 0  , 7  , 5  
    EQUB &1E, 7  , 3  , 1  , &40, 0  , 0  , 0  , &F0, &C0, &78, &2C
    EQUB &3C, &16, 3  , 1  , 7  , 0  , &83, 3  , &82, 1  , &C1, &81
.sub_C42D0
    LDA #&22 ; '"'
    STA L62CC
    STA L0077
    LDA #&D7
    STA L62CD
    LDX L0040
    LDA L3779,X
    JSR sub_C508C
    LDX #&FF
    STX L0077
    JSR sub_C508C
    RTS

.sub_C42EC
    LDX #&13
.loop_C42EE
    JSR sub_C40EB
    DEX
    BPL loop_C42EE
    RTS

    EQUB &85, &52, &83, &45, &86, &56, &82, &53, &FF, &75, &75, &FE
    EQUB &EB, &A6, &D2
    EQUS "NUMBER OF LAPS"
    EQUB &EC, &DA, &D6, &ED, &DB, &D6, &EE, &DC, &D6, &FF, 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 1  , 1  
    EQUB 1  , 1  , 0  , 0  , 0  , 0  , 5  , 5  , 5  , 2  , 0  , 0  
    EQUB 0  , 0  , 1  , 1  , 1  , 1  , 3  , &92, &12, &12, &F0, &80
    EQUB &F0, &80
    EQUS "Harry Fume  Dan DipstickWilma Cargo Miles Behi"
    EQUS "ndTHE  PITS"
    EQUB &FF, &1F, 4  , &0E, &88, &86, &D9, &1F, 5  , &10, &84, &9D
    EQUB &86, &31, &A2, &9C, &A5, &83, &FF, &20, 0  , 1  , 1  , &0F
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , &0F, 3  , 1  , 0  , &20
    EQUB 0  , 8  , 8  , &F0, &68, &3C, &1E, &16, 3  , 1  , 0  , &F0
    EQUB &10, &F0, &10, &F0, &90, &78, &48, 8  , 8  , 8  , 8  , &0C
    EQUB &94, &84, &84, 0  , 6  , 2  , 6  , 4  , 6  , 0  , 0  
.sub_C43D0
    LDA #2
    JSR sub_C3D50
    LDA #&20 ; ' '
    STA L0078
    LDA L39E4,X
    BNE C43E7
    LDA #2
    JSR sub_C3D50
    LSR L0078
    BNE C43EA
.C43E7
    JSR sub_C37D6
.C43EA
    LDA L3864,X
    JSR sub_C37D6
    LDA #1
    JSR sub_C3D50
    RTS

.sub_C43F6
    LDX #3
.loop_C43F8
    JSR sub_C0E5A
    DEX
    BPL loop_C43F8
    RTS

    EQUB 0
.L4400
    EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81
    EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81
    EQUB &81, &81, &81, &81, &22, 0  , &44, &88, &33, &22, &CC, &33
    EQUB 0  , &55, &22, &CC, &33, &55, &66, &33, &8F, &25, 7  , &0F
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F
    EQUB &0E, 0  , &1C, &0C, &14, 8  , &38, &18, &F0, &30, &E1, &43
    EQUB &C3, &86, &0C, 8  , &87, &0E, &0C, 8  
    EQUS "Roland SlideRick Shaw   Peter Out   Dummy Driv"
    EQUS "er"
.L4480
    EQUB &9C, &EE, &9E, &9F, 3  , 4  , &AF, 5  , &9D, &A5, &A7, 4  
    EQUB &AE, &AF, 6  , 7  , &E6, &9C, &9E, &9F, 3  , &AF, &B7, 6  
    EQUB 3  , &A6, &AE, 5  , &B7, 7  , &E6, &9F, 3  , &A5, &AE, &AF
    EQUB &B7, 7  , &E6, &9F, &B7, 3  , &A6, 7  , &E5, &9D, &9E, 3  
    EQUB 4  , &9E, 3  , &B7, 6  , 3  , &A5, &A6, &B7, &A6, &A7, &AE
    EQUB 5  , 7  , &A6, 4  , &AE, &AF, &A6, 4  , &AE, &AF
.sub_C44C6
    LDA L5A14,X
    STA L5F40
    STA L0075
    LDA L59FA
    LSR A
    LSR A
    LSR A
    TAY
.loop_C44D5
    LDA L59D0,Y
    LSR A
    PHP
    LSR A
    BCS C44E0
    JSR sub_C0C00
.C44E0
    ASL A
    PLP
    ROR A
    STA L5FB0,Y
    DEY
    BPL loop_C44D5
    RTS

.sub_C44EA
    LDA L002D
    BEQ C44F5
    DEC L0028
    DEC L0028
    JMP C452D

.C44F5
    STA L0028
    STA L0026
    LDY L62F0
    LDA L0040
    BEQ C4510
    LDA L003E
    BMI C4510
    BEQ C450C
    LDA L003D
    BNE C4516
    BEQ C4510
.C450C
    LDA L0063
    BNE C4521
.C4510
    TYA
    BEQ C452D
    BPL C4521
    INY
.C4516
    INY
    BMI C452A
    CPY #4
    BCC C452A
    LDY #3
    BCS C452A
.C4521
    DEY
    BPL C452A
    CPY #&FB
    BCS C452A
    LDY #&FB
.C452A
    STY L62F0
.C452D
    LDX L0022
    LDY L0700,X
    LDA L000D
    STA L0076
    LDA L5400,Y
    EOR L5600,Y
    PHP
    LDA L5600,Y
    PHP
    JSR sub_C3450
    CMP #&3C ; '<'
    PHP
    BCC C454F
    LDA L5400,Y
    JSR sub_C3450
.C454F
    STA L0074
    LSR A
    CLC
    ADC L0074
    LSR A
    LSR A
    PLP
    BCS C455C
    EOR #&3F ; '?'
.C455C
    PLP
    BPL C4561
    EOR #&80
.C4561
    PLP
    JSR sub_C3450
    SEC
    SBC L000B
    STA L0044
    BPL C456E
    EOR #&FF
.C456E
    CMP #&40 ; '@'
    BCC C4574
    EOR #&7F
.C4574
    STA L62F2
    EOR #&3F ; '?'
    STA L0074
    LSR A
    CLC
    ADC L0074
    JSR sub_C4610
    CLC
    ADC L005D
    CLC
    ADC L62F0
    CLC
    ADC L0028
    CLC
    ADC L000D
    CLC
    BPL C4593
    SEC
.C4593
    ROR A
    STA L000D
    SEC
    SBC L0076
    STA L004E
    LDA #0
    STA L0077
    LDA L0026
    SEC
    SBC #4
    BVC C45A8
    LDA #&C8
.C45A8
    STA L0026
    CLC
    ADC L002D
    BEQ C45B3
    BVS C45C7
    BPL C45C9
.C45B3
    LDA L0026
    JSR sub_C3450
    CMP #5
    BCC C45C3
    JSR sub_C4DCB
    LDA #1
    BNE C45C9
.C45C3
    LDA #0
    BEQ C45C9
.C45C7
    LDA #&7F
.C45C9
    STA L002D
    ASL A
    ROL L0077
    ASL A
    ROL L0077
    STA L0076
    LDX L006F
    LDA L0164,X
    JSR sub_C4610
    BPL C45DF
    DEC L0077
.C45DF
    LDY L0022
    CLC
    ADC L0901,Y
    PHP
    CLC
    ADC #&AC
    PHP
    CLC
    ADC L0076
    STA L6281
    LDA L0A01,Y
    ADC L0077
    PLP
    ADC #0
    PLP
    ADC #0
    STA L6284
    LDA L0063
    STA L0075
    LDA #&21 ; '!'
    JSR sub_C0C00
    ASL L0075
    CLC
    ADC L0075
    STA L0150,X
    RTS

.sub_C4610
    STA L0075
    LDA L5500,Y
    EOR L0025
    PHP
    LDA L5500,Y
    JSR sub_C3450
    JSR sub_C0C00
    PLP
    JSR sub_C3450
    RTS

.sub_C4626
    LDA L005E
    SEC
    SBC L0044
    JSR sub_C3450
    CMP #&40 ; '@'
    ROR L0043
    BPL C4639
    EOR #&7F
    CLC
    ADC #1
.C4639
    PHA
    LDY #&BA
    JSR sub_C4676
    LDX L005C
    CPX #&28 ; '('
    BCC C4647
    EOR #&FF
.C4647
    LDX L006F
    BIT L0025
    JSR sub_C3450
    PHA
    SBC L0178,X
    BCS C4656
    EOR #&FF
.C4656
    CMP #&16
    JSR sub_C1FA8
    PLA
    STA L0178,X
    PLA
    EOR #&FF
    CLC
    ADC #&41 ; 'A'
    LDY #&88
    JSR sub_C4676
    ASL A
    ASL A
    BIT L0043
    BMI C4672
    EOR #&FF
.C4672
    STA L0164,X
    RTS

.sub_C4676
    JSR sub_C4687
    STA L0075
    TYA
    JSR sub_C0C00
    STA L0075
    LDA L0010
    JSR sub_C0C00
    RTS

.sub_C4687
    CMP #&1A
    BCC C4699
    CMP #&2E ; '.'
    BCC C4693
    CLC
    ADC #&BE
    RTS

.C4693
    ASL A
    ASL A
    CLC
    ADC #&34 ; '4'
    RTS

.C4699
    STA L0074
    ASL A
    CLC
    ADC L0074
    ASL A
    RTS

.sub_C46A1
    LDA L000B
    LDX L000A
    JSR sub_C0D01
    JSR sub_C48B9
    LDA L62D8
    STA L0038
    LDA L62E8
    STA L0039
    LDA L62D9
    STA L0074
    LDA L62E9
    JSR sub_C0E40
    STA L0063
    LDA L0074
    STA L002E
    LDY L0063
    BNE C46CD
    AND #&F0
    TAY
.C46CD
    STY L0000
    JSR sub_C4729
    JSR sub_C4BCF
    JSR sub_C49CE
    LDX #1
    JSR sub_C4779
    LDA L0038
    STA L62D8
    LDA L0039
    STA L62E8
    LDA L62D8
    CLC
    ADC L003A
    STA L62D8
    LDA L62E8
    ADC L003B
    STA L62E8
    JSR sub_C47A5
    LDX #0
    JSR sub_C4779
    JSR sub_C47C5
    JSR sub_C47F9
    LDA L002D
    CMP #2
    BCC C4719
    LDX #2
    LDA #0
.loop_C4710
    STA L62D5,X
    STA L62E5,X
    DEX
    BPL loop_C4710
.C4719
    JSR sub_C4C65
    JSR sub_C48C1
    JSR sub_C4937
    JSR sub_C48EF
    JSR sub_C44EA
    RTS

.sub_C4729
    LDA L62D2
    STA L0074
    LDY #&58 ; 'X'
    LDA L62E2
    JSR sub_C4753
    STA L0075
    LDA L62D8
    SEC
    SBC L0074
    STA L62D8
    LDA L62E8
    SBC L0075
    STA L62E8
    JSR sub_C4765
    STA L003B
    LDA L0074
    STA L003A
    RTS

.sub_C4753
    PHP
    JSR sub_C0E40
    STA L0076
    STY L0075
    JSR sub_C0DBF
    LDA L0075
    PLP
    JSR sub_C0E40
    RTS

.sub_C4765
    LDA L0075
    CLC
    BPL C476B
    SEC
.C476B
    ROR A
    PHA
    LDA L0074
    ROR A
    CLC
    ADC L0074
    STA L0074
    PLA
    ADC L0075
    RTS

.sub_C4779
    LDA L002D
    CMP #2
    BCS C478F
    JSR sub_C4A91
    LDA L62A6,X
    AND #&C0
    BNE C4795
    LDA L006A
    AND #2
    BNE C4794
.C478F
    LDX #3
    JSR sub_C0E5A
.C4794
    RTS

.C4795
    JSR sub_C4AF7
    LDA L62C0
    BNE C47A4
    LDY #1
    LDA #3
    JSR sub_C0B4A
.C47A4
    RTS

.sub_C47A5
    LDX #2
    LDY #9
    LDA #&80
    STA L0079
    LDA #&0E
    JSR sub_C4874
    LDX #2
    LDY #8
    LDA #&40 ; '@'
    STA L0079
    LDA #9
    JSR sub_C4874
    LDX #8
    JSR sub_C47E5
    RTS

.sub_C47C5
    LDX #2
    LDY #&0C
    LDA #0
    STA L0079
    LDA #&0E
    JSR sub_C4874
    LDX #2
    LDY #&0A
    LDA #&C0
    STA L0079
    LDA #&0C
    JSR sub_C4874
    LDX #&0A
    JSR sub_C47E5
    RTS

.sub_C47E5
    LDA L62D0,X
    CLC
    ADC L62DE
    STA L62D0,X
    LDA L62E0,X
    ADC L62EE
    STA L62E0,X
    RTS

.sub_C47F9
    LDY #&4E ; 'N'
    LDA L62DA
    SEC
    SBC L62DB
    STA L0074
    LDA L62EA
    SBC L62EB
    JSR sub_C4753
    STA L62E5
    LDA L0074
    STA L62D5
    LDY #1
.loop_C4817
    LDX #3
.loop_C4819
    LDA L62EA,X
    CLC
    BPL C4820
    SEC
.C4820
    ROR L62EA,X
    ROR L62DA,X
    DEX
    BPL loop_C4819
    DEY
    BPL loop_C4817
    LDX #2
    LDA #1
    STA L0078
.C4832
    LDA L62DB,X
    STA L0074
    LDA L62EB,X
    STA L0075
    JSR sub_C4765
    STA L0075
    LDA L0074
    CLC
    ADC L62DA,X
    STA L0074
    LDY #&CD
    LDA L0075
    ADC L62EA,X
    JSR sub_C4753
    ASL L0074
    ROL A
    LDY L0078
    STA L62E6,Y
    LDA L0074
    STA L62D6,Y
    DEC L0078
    DEX
    DEX
    BPL C4832
    LDA L62E7
    STA L62FF
    RTS

.sub_C486D
    LDY L007F
    STA L0079
    JMP C4876

.sub_C4874
    STA L007C
.C4876
    LDA L62D0,Y
    STA L0080
    LDA L62E0,Y
    STA L0081
    LDA L62A0,X
    STA L0082
    LDA L62A3,X
    STA L0083
    JSR sub_C0DD7
    STA L0075
    LDY L007C
    BIT L0079
    BVS C48A7
    LDA L0074
    STA L62D0,Y
    LDA L0075
    STA L62E0,Y
    RTS

.sub_C48A0
    BMI C48A7
    JSR sub_C0E44
    STA L0075
.C48A7
    LDA L62D0,Y
    CLC
    ADC L0074
    STA L62D0,Y
    LDA L62E0,Y
    ADC L0075
    STA L62E0,Y
    RTS

.sub_C48B9
    LDY #0
    LDA #8
    LDX #&C0
    BNE C48C7
.sub_C48C1
    LDY #6
    LDA #3
    LDX #&40 ; '@'
.C48C7
    STY L007F
    STA L007C
    STX L0088
    LDX #1
    LDA #0
    JSR sub_C486D
    DEX
    INC L007F
    LDA L0088
    JSR sub_C486D
    INX
    INC L007C
    LDA #0
    JSR sub_C486D
    DEX
    DEC L007F
    LDA L0088
    EOR #&80
    JSR sub_C486D
    RTS

.sub_C48EF
    LDX #1
    LDY #2
.C48F3
    LDA #0
    STA L0076
    LDA L62D0,X
    STA L0074
    LDA L62E0,X
    BPL C4903
    DEC L0076
.C4903
    ASL L0074
    ROL A
    ROL L0076
    STA L0075
    LDA L62B1,Y
    ADC L0074
    STA L62B1,Y
    LDA L6280,Y
    ADC L0075
    STA L6280,Y
    LDA L6283,Y
    ADC L0076
    STA L6283,Y
    DEY
    DEY
    DEX
    BPL C48F3
    LDA L000A
    CLC
    ADC L62D2
    STA L000A
    LDA L000B
    ADC L62E2
    STA L000B
    RTS

.sub_C4937
    LDX #2
.C4939
    LDA #0
    STA L0076
    LDA L62D3,X
    STA L0074
    LDA L62E3,X
    BPL C4949
    DEC L0076
.C4949
    LDY #3
    CPX #2
    BNE C4951
    LDY #5
.C4951
    ASL L0074
    ROL A
    ROL L0076
    DEY
    BNE C4951
    STA L0075
    LDA L62AE,X
    CLC
    ADC L0074
    STA L62AE,X
    LDA L62D0,X
    ADC L0075
    STA L62D0,X
    LDA L62E0,X
    ADC L0076
    STA L62E0,X
    DEX
    BPL C4939
    RTS

.C4978
    LDX #&DC
    JSR sub_C0E50
    BEQ C498C
    LDY L0040
    DEY
    BEQ C4988
    LDA L0063
    BNE C4993
.C4988
    LDA #0
    BEQ C49C5
.C498C
    LDA user_via_t2c_l
    AND L0009
    BNE C49BB
.C4993
    LDX #7
    STX L0009
    LDX #&FF
    STX L0061
    BMI C49BB
.C499D
    STA L0059
.C499F
    LDA L003C
    LDX L003E
    DEX
    BNE C49B0
    ADC #7
    CMP L003F
    BCS C49B0
    CMP #&8C
    BCC C49C5
.C49B0
    CMP #&2A ; '*'
    BCC C49B9
    SEC
    SBC #&0C
    BCS C49BB
.C49B9
    LDA #&28 ; '('
.C49BB
    STA L0074
    LDA user_via_t2c_l
    AND #7
    CLC
    ADC L0074
.C49C5
    STA L003C
    STA L005A
.C49C9
    LDA #0
    JMP C4A87

.sub_C49CE
    LDA L0061
    BEQ C4978
    LDA L002D
    BNE C499F
    LDA L0058
    BMI C499D
    LDY L0040
    DEY
    BEQ C499F
    LDA L002E
    STA L0074
    LDA L0063
    ASL L0074
    ROL A
    PHP
    BMI C49EE
    ASL L0074
    ROL A
.C49EE
    STA L0075
    LDX L0040
    LDA L5A06,X
    JSR sub_C0C00
    ASL L0074
    ROL A
    PLP
    BPL C4A01
    ASL L0074
    ROL A
.C4A01
    BIT L0059
    BPL C4A37
    LDY L003E
    DEY
    BNE C4A26
    LDY L0063
    CPY #&16
    BCS C4A26
    LDY L006D
    BPL C4A22
    CPY #&A0
    BNE C4A26
    PHA
    LDA L006A
    AND #&3F ; '?'
    CMP #&35 ; '5'
    PLA
    BCC C4A26
.C4A22
    CMP L005A
    BCC C4A2C
.C4A26
    LDY #0
    STY L0059
    BEQ C4A37
.C4A2C
    LDA L005A
    CMP #&6C ; 'l'
    BCC C4A37
    SEC
    SBC #2
    STA L005A
.C4A37
    STA L003C
    CMP #&AA
    BCC C4A3F
    LDA #&AA
.C4A3F
    CMP #3
    BCS C4A48
    INC L0061
    JMP C49C9

.C4A48
    SEC
    SBC #&42 ; 'B'
    BMI C4A51
    CMP #&11
    BCS C4A58
.C4A51
    ASL A
    CLC
    ADC #&98
    JMP C4A7F

.C4A58
    SEC
    SBC #&11
    CMP #4
    BCS C4A66
    EOR #&FF
    CLC
    ADC #&BB
    BCS C4A7F
.C4A66
    SEC
    SBC #4
    CMP #5
    BCS C4A76
    ASL A
    ASL A
    EOR #&FF
    CLC
    ADC #&B7
    BCS C4A7F
.C4A76
    SEC
    SBC #5
    ASL A
    EOR #&FF
    CLC
    ADC #&A3
.C4A7F
    STA L0075
    LDA L5A0D,X
    JSR sub_C0C00
.C4A87
    STA L003D
    LDA L003C
    CLC
    ADC #&19
    STA L005F
    RTS

.sub_C4A91
    LDA L62D8
    STA L0074
    ORA L62E8
    PHP
    LDA L62E8
    JSR sub_C0E42
    LDY #5
.loop_C4AA2
    ASL L0074
    ROL A
    DEY
    BNE loop_C4AA2
    STA L62EA,X
    PLP
    BEQ C4AB4
    EOR L62E8
    SEC
    BPL C4AF3
.C4AB4
    LDA L0074
    STA L62DA,X
    JSR sub_C4B88
    BCC C4ACF
    LDA #0
    STA L62DC
    STA L62EC
    LDA L62EA
    JSR sub_C3450
    JMP C4AED

.C4ACF
    JSR sub_C4B42
    LDA L62EC,X
    JSR sub_C3450
    STA L0074
    LDA L62EA,X
    JSR sub_C3450
    CMP L0074
    BCC C4AE9
    LSR L0074
    JMP C4AEA

.C4AE9
    LSR A
.C4AEA
    CLC
    ADC L0074
.C4AED
    CMP L62AA,X
    BNE C4AF3
    CLC
.C4AF3
    ROR L62A6,X
    RTS

.sub_C4AF7
    LDA #0
    STA L62EC,X
    STA L62DC,X
    LDY #8
    JSR sub_C4B61
    LDA L62E8
    EOR #&80
    STA L0079
    LDA #0
    STA L0074
    LDA L62AC,X
    STX L0078
    JSR sub_C4B47
    JSR sub_C4B88
    BCS C4B41
    CMP L62AC,X
    BCC C4B3E
    LDA #0
    STA L0074
    LDA L62AC,X
    JSR sub_C4B42
    LDY L003E
    DEY
    BNE C4B41
    CPX #0
    BEQ C4B41
    LDA #0
    STA L62EA,X
    STA L62DA,X
    BEQ C4B41
.C4B3E
    JSR sub_C4B42
.C4B41
    RTS

.sub_C4B42
    LDY L003E
    DEY
    BEQ C4B51
.sub_C4B47
    CMP L008F
    BCC C4B51
    LDA L008E
    STA L0074
    LDA L008F
.C4B51
    BIT L0079
    JSR sub_C0E40
    LDY L0078
    STA L62EA,Y
    LDA L0074
    STA L62DA,Y
    RTS

.sub_C4B61
    LDA L62D0,Y
    STA L008E
    LDA L62E0,Y
    BPL C4B77
    LDA #0
    SEC
    SBC L008E
    STA L008E
    LDA #0
    SBC L62E0,Y
.C4B77
    LDY #5
.loop_C4B79
    ASL L008E
    ROL A
    BMI C4B84
    DEY
    BNE loop_C4B79
.loop_C4B81
    STA L008F
    RTS

.C4B84
    LDA #&7F
    BNE loop_C4B81
.sub_C4B88
    TXA
    CLC
    ADC #2
    STA L0078
    LDY L003E
    DEY
    BEQ C4BAF
    LDY #9
    JSR sub_C4B61
    LDA L62E9
    EOR #&80
    STA L0079
    LDA L62AA,X
    CPX #1
    BEQ C4BBC
    LSR A
    CLC
    ADC L62AA,X
    LSR A
    JMP C4BBC

.C4BAF
    CPX #1
    BNE C4BCD
    LDA L0040
    SEC
    SBC #1
    STA L0079
    LDA L003D
.C4BBC
    STA L0075
    LDA L003F
    JSR sub_C0C00
    LDY L003E
    DEY
    BNE C4BCB
    LSR A
    ROR L0074
.C4BCB
    CLC
    RTS

.C4BCD
    SEC
    RTS

.sub_C4BCF
    LDA #0
    LDY L003E
    BNE C4BE1
    LDA L62FF
    PHP
    LSR A
    LSR A
    LSR A
    PLP
    BPL C4BE1
    ORA #&E0
.C4BE1
    STA L0079
    EOR #&FF
    CLC
    ADC #1
    STA L0078
    LDA L0063
    STA L0075
    LDX #0
    LDA L713D
    AND L7205
    STA L0077
    LDA L713D
    CMP #&FF
    BEQ C4C06
    LDA L7205
    CMP #&FF
    BNE C4C24
.C4C06
    LDA user_via_t2c_l
    JSR sub_C0C00
    AND #7
    TAX
    BNE C4C12
    INX
.C4C12
    LDA L005D
    BNE C4C24
    LDA L005D
    ORA L002D
    BNE C4C24
    BIT L62FB
    BPL C4C24
    JSR sub_C4DC9
.C4C24
    STX L005D
    LDX #1
.C4C28
    LDA L0063
    CMP #&35 ; '5'
    BCC C4C30
    LDA #&35 ; '5'
.C4C30
    STA L0075
    LDA L62A8,X
    JSR sub_C0C00
    BIT L62E9
    JSR sub_C3450
    CLC
    ADC L4C61,X
    LDY #&F3
    STY L0075
    LDY L0077
    CPY #&FF
    BNE C4C51
    LDA L4C63,X
    LDY #&FF
.C4C51
    CLC
    ADC L0078,X
    STA L62AA,X
    JSR sub_C0C00
    STA L62AC,X
    DEX
    BPL C4C28
    RTS

.L4C61
    EQUB &35, &35
.L4C63
    EQUB &19, &1A
.sub_C4C65
    LDA L0039
    JSR sub_C3450
    STA L0075
    CMP L0063
    BCS C4C72
    LDA L0063
.C4C72
    LDY L005D
    BEQ C4C77
    ASL A
.C4C77
    STA L0077
    JSR sub_C0C00
    STA L0075
    LDY #6
    LDA L0039
    JSR sub_C48A0
    LDA L0063
    STA L0075
    LDA L62F1
    JSR sub_C0C00
    CLC
    ADC #8
    STA L0076
    LDA L0077
    STA L0075
    JSR sub_C0DBF
    LDY #7
    LDA L62E9
    JSR sub_C48A0
    RTS

.sub_C4CA4
    LDX L006F
    LDY L06E8,X
    LDA L5300,Y
    LSR A
    LSR A
    LSR A
    LSR A
    STA L0045
    CMP L62F9
    BNE C4CBB
    ADC #0
    AND #&0F
.C4CBB
    TAX
    LDY #2
    STY L0077
    LDA L53E0,X
    JSR sub_C4D21
    LDY #4
    LDA L53F0,X
    JSR sub_C4D21
    LDY #2
    LDA L53D0,X
    JSR sub_C4D21
    LDA L59EA,X
    AND #7
    CLC
    ADC #7
    STA L0037
    LDA L59EA,X
    AND #&F8
    TAY
    LDX #&FD
    JSR sub_C1208
    LDY #6
    JSR sub_C2147
    LDA L008A
    STA L0397
    LDA L008B
    STA L03AF
    SEC
    SBC L000B
    JSR sub_C3450
    CMP #&40 ; '@'
    BCC C4D09
    LDY L0045
    STY L62F9
.C4D09
    LDY #&25 ; '%'
    CMP #&6E ; 'n'
    BCC C4D11
    LDY #&50 ; 'P'
.C4D11
    LDA #&17
    STA L0042
    JSR sub_C2AB3
    LDY #6
    JSR sub_C2287
    JSR sub_C2A76
    RTS

.sub_C4D21
    PHA
    LDA #0
    STA L0074
    STA L0076
    PLA
    BPL C4D2D
    DEC L0076
.C4D2D
    LSR L0076
    ROR A
    ROR L0074
    DEY
    BNE C4D2D
    STA L0075
    LDY L0077
    DEC L0077
    LDA L6280,Y
    SEC
    SBC L0074
    STA L6286,Y
    LDA L6283,Y
    SBC L0075
    STA L6289,Y
    RTS

.sub_C4D4D
    STX L004A
    STX L5F3A
    JSR sub_C44C6
.loop_C4D55
    TXA
    STA L013C,X
    LSR A
    NOP
    STA L04A0,X
    JSR sub_C635D
    LDA #0
    STA L3864,X
    STA L39E4,X
    STA L04F0,X
    TXA
    BNE loop_C4D55
    RTS

.sub_C4D70
    LDA #&21 ; '!'
    BNE C4D76
.sub_C4D74
    LDA #&18
.C4D76
    STA L62CD
    LDA #1
    STA L62CC
.sub_C4D7E
    LDY #0
.C4D80
    LDA L3B50,X
    STA S
    LDA L3AD0,X
    STA R
.C4D8A
    LDA (R),Y
    CMP #&FF
    BEQ C4DC8
    CMP #&C8
    BCC C4DB6
    SEC
    SBC #&C8
    STA L0074
    TXA
    PHA
    TYA
    PHA
    LDX L0074
    CPX #&36 ; '6'
    BNE C4DAB
    LDX #0
    JSR sub_C41D0
    JMP C4DAE

.C4DAB
    JSR sub_C4D7E
.C4DAE
    PLA
    TAY
    PLA
    TAX
    INY
    JMP C4D80

.C4DB6
    CMP #&A0
    BCC C4DC1
    SBC #&A0
    JSR sub_C3D50
    BEQ C4DC4
.C4DC1
    JSR sub_C5092
.C4DC4
    INY
    JMP C4D8A

.C4DC8
    RTS

.sub_C4DC9
    LDA L0063
.sub_C4DCB
    LSR A
    STA L0026
    LSR A
    STA L0028
    INC L002D
    SEC
    ROR L62D2
    LDA #4
    JSR L0B47
    RTS

.sub_C4DDD
    SEI
    LDX #&0D
.loop_C4DE0
    STX crtc_horz_total
    LDA L4F0F,X
    STA crtc_horz_displayed
    DEX
    BPL loop_C4DE0
    DEX
    STX L4F43
    CLI
    LDA #osbyte_write_video_ula_control
    LDX #&C4
    JSR osbyte
    CLC
    LDA #7
.loop_C4DFB
    STA video_ula_palette
    ADC #&10
    BCC loop_C4DFB
    SEI
    LDA irq1v
    STA L4F1D
    LDA irq1v+1
    STA L4F1E
    LDA #2
.loop_C4E11
    BIT system_via_ifr
    BEQ loop_C4E11
    LDA #&40 ; '@'
    STA user_via_acr
    ORA system_via_acr
    STA system_via_acr
    LDA #&C0
    STA user_via_ier
    STA system_via_ier
    LDA #&D4
    STA user_via_t1c_l
    LDA #&11
    STA user_via_t1c_h
    LDA #1
    STA system_via_t1l_l
    LDA #&3D ; '='
    STA system_via_t1c_h
    LDA #&1E
    STA system_via_t1l_l
    STA user_via_t1l_l
    LDA #&4E ; 'N'
    STA system_via_t1l_h
    STA user_via_t1l_h
    LDA #&4E ; 'N'
    STA irq1v+1
    LDA #&5C ; '\'
    STA irq1v
    CLI
    RTS

.loop_C4E59
    JMP (L4F1D)

    LDA user_via_ifr
    AND #&40 ; '@'
    BEQ loop_C4E59
    STA user_via_ifr
    TXA
    PHA
    CLD
    LDA L4F43
    BEQ C4E7C
    BMI C4E92
    CMP #2
    BCC C4E9B
    BEQ C4EC3
    CMP #3
    BEQ C4ED6
    BCS C4EE7
.C4E7C
    LDA #&88
    STA video_ula_control
    LDX #&0F
.loop_C4E83
    LDA L3468,X
    STA video_ula_palette
    DEX
    BPL loop_C4E83
.loop_C4E8C
    LDA #&C4
    LDX #&0F
    BNE C4F01
.C4E92
    CMP #&FF
    BNE C4F0A
    INC L4F43
    BEQ loop_C4E8C
.C4E9B
    LDA #&C4
    STA video_ula_control
    CLC
    LDA #3
.loop_C4EA3
    STA video_ula_palette
    ADC #&10
    BCC loop_C4EA3
    LDA #&3C ; '<'
    SEC
    SBC L4F1F
    STA L4F21
    LDA #&15
    SBC L4F20
    STA L4F22
    LDA L4F1F
    LDX L4F20
    BCS C4F01
.C4EC3
    LDX #&0F
.loop_C4EC5
    LDA L3458,X
    STA video_ula_palette
    DEX
    BPL loop_C4EC5
    LDA L4F21
    LDX L4F22
    BNE C4F01
.C4ED6
    LDX #3
.loop_C4ED8
    LDA L3478,X
    STA video_ula_palette
    DEX
    BPL loop_C4ED8
    LDA #0
    LDX #&1E
    BNE C4F01
.C4EE7
    LDX #3
.loop_C4EE9
    LDA L347C,X
    STA video_ula_palette
    DEX
    BPL loop_C4EE9
    STX L4F43
    JSR L52A4
    LDA #&FF
    STA user_via_t2c_h
    LDA #&16
    LDX #&0B
.C4F01
    STX user_via_t1l_h
    STA user_via_t1l_l
    INC L4F43
.C4F0A
    PLA
    TAX
    LDA L00FC
    RTI

.L4F0F
    EQUB &3F, &28, &31, &24, &26, 0  , &1A, &20, 1  , 7  , &67, 8  
    EQUB &0B, &50
.L4F1D
    EQUB 0
.L4F1E
    EQUB 0
.L4F1F
    EQUB &D8
.L4F20
    EQUB 4
.L4F21
    EQUB &64
.L4F22
    EQUB &10
.sub_C4F23
    SEI
    LDA L4F1D
    STA irq1v
    LDA L4F1E
    STA irq1v+1
    LDA #&40 ; '@'
    STA user_via_ier
    CLI
    JSR sub_C43F6
.sub_C4F39
    LDA #&80
    STA L0064
    LDX #&2E ; '.'
    JSR sub_C4D7E
    RTS

.L4F43
    EQUB 0
.sub_C4F44
    LDA #&3C ; '<'
    SEC
    SBC L001F
    BPL C4F54
    CMP #&F5
    BCS C4F5B
    LDA #&F5
    SEC
    BCS C4F5B
.C4F54
    CMP #&12
    BCC C4F5B
    LDA #&12
    CLC
.C4F5B
    PHP
    STA L0075
    LDA #0
    ROR L0075
    ROR A
    PLP
    ROR L0075
    ROR A
    SEI
    CLC
    ADC #&D8
    STA L4F1F
    LDA #4
    ADC L0075
    STA L4F20
    CLI
    RTS

.sub_C4F77
    BIT L62F8
    BMI C4F90
    CPX #&14
    BCS C4F90
    LDA L018C,X
    ASL A
    BMI C4F90
    CPX L006F
    BNE C4F95
    DEC L0030
    BEQ C4F91
    INC L0030
.C4F90
    RTS

.C4F91
    LDA #&80
    STA L0066
.C4F95
    LDA L04B4,X
    BMI C4F9D
    INC L04B4,X
.C4F9D
    BIT L006C
    BPL C4FA8
    CMP L006E
    BCC C4FB7
    BEQ C4FAF
    RTS

.C4FA8
    CPX L006F
    BEQ C4FB7
    BCC C4FB7
    RTS

.C4FAF
    CPX L006F
    BNE C4FB7
    LDA #&50 ; 'P'
    STA L000F
.C4FB7
    SED
    SEC
    LDA L06B4
    SBC L0898,X
    STA L0074
    LDA L06CC
    SBC L08AC,X
    BCS C4FCC
    ADC #&60 ; '`'
    CLC
.C4FCC
    STA L0075
    LDA L06E4
    SBC L04DC,X
    STA L0079
    BCC C4FFB
    SEC
    LDA L0074
    SBC L06A0,X
    LDA L0075
    SBC L06B8,X
    LDA L0079
    SBC L06D0,X
    BCS C4FFB
    LDA L0074
    AND #&F0
    STA L06A0,X
    LDA L0075
    STA L06B8,X
    LDA L0079
    STA L06D0,X
.C4FFB
    LDA L06B4
    STA L0898,X
    LDA L06CC
    STA L08AC,X
    LDA L06E4
    STA L04DC,X
    CLD
    RTS

    EQUB &EA, &EA
.sub_C5011
    LDA #0
    STA L06B4,X
    STA L06CC,X
    STA L06E4,X
    RTS

.sub_C501D
    LDX #&20 ; ' '
    STX L62CC
    INX
    STX L62CD
    LDX L006F
    LDA #&26 ; '&'
    JSR L7B9C
.sub_C502D
    LDA #&28 ; '('
.sub_C502F
    LDX #&0A
    STX L62CC
    LDX #&21 ; '!'
    STX L62CD
    LDX #&15
    JSR L7B9C
    RTS

.sub_C503F
    LDA #osbyte_read_adc_or_get_buffer_status
    JSR osbyte
    TYA
    LDX #1
    CLC
    ADC #&80
    BPL C504F
    EOR #&FF
    DEX
.C504F
    CMP #&0A
    RTS

.sub_C5052
    LDX L0046
    BNE C505C
    LDX L5A19
    INX
    BEQ C505F
.C505C
    DEX
    STX L0046
.C505F
    LDA L006D
    BMI C5068
    LDX #0
    JSR sub_C17C3
.C5068
    INC L006A
    BNE C506F
    INC L62DF
.C506F
    LDA L06CC
    BEQ C507A
    LDA L006A
    AND #&1F
    BNE C507D
.C507A
    JSR sub_C635D
.C507D
    RTS

.sub_C507E
    DEX
    BPL C5083
    LDX #&13
.C5083
    RTS

.sub_C5084
    INX
    CPX #&14
    BCC C508B
    LDX #0
.C508B
    RTS

.sub_C508C
    STA L62C3
    JMP C509D

.sub_C5092
    BIT L0064
    BMI C50F6
    STA L62C3
    LDA #0
    STA L0077
.C509D
    TXA
    PHA
    TYA
    PHA
    LDY #>(L62C3)
    LDX #<(L62C3)
    LDA #osword_read_char
    JSR osword
    LDA L0077
    BEQ C50C6
    LDX #8
.loop_C50B0
    LDA L62C3,X
    BIT L0077
    BMI C50BC
    AND #&F0
    JMP C50C0

.C50BC
    ASL A
    ASL A
    ASL A
    ASL A
.C50C0
    STA L62C3,X
    DEX
    BNE loop_C50B0
.C50C6
    LDY L62CD
    LDA L62CC
    JSR sub_C50FA
    LDX #8
.loop_C50D1
    LDA L62C3,X
    STA (P),Y
    DEY
    BPL C50E8
    LDA P
    SEC
    SBC #&40 ; '@'
    STA P
    LDA Q
    SBC #1
    STA Q
    LDY #7
.C50E8
    DEX
    BNE loop_C50D1
    INC L62CC
    PLA
    TAY
    PLA
    TAX
    LDA L62C3
    RTS

.C50F6
    JSR oswrch
    RTS

.sub_C50FA
    ASL A
    ASL A
.sub_C50FC
    STA P
    LDA #0
    ASL P
    ROL A
    STA Q
    TYA
    LSR A
    LSR A
    LSR A
    TAX
    LDA L3FE0,X
    CLC
    ADC P
    STA P
    LDA L3B06,X
    ADC Q
    STA Q
    TYA
    AND #7
    TAY
    RTS

.sub_C511E
    LDX L0069
    BEQ C5139
    DEX
.loop_C5123
    LDA L07A8,X
    STA P
    LDA L07D0,X
    STA Q
    LDA L0780,X
    LDY #0
    STA (P),Y
    DEX
    BPL loop_C5123
    STY L0069
.C5139
    RTS

.sub_C513A
    JSR sub_C511E
    JSR sub_C51A8
    LDA L62A2
    STA L0074
    LSR A
    PHP
    LDA #2
    BCS C514D
    LDA #5
.C514D
    STA L0076
    LDA L62A5
    ASL L0074
    ROL A
    BCS C515F
    CMP #&26 ; '&'
    BCC C5170
    CMP #&3D ; '='
    BCC C5161
.C515F
    LDA #&3C ; '<'
.C5161
    EOR #&FF
    ADC #&4C ; 'L'
    TAY
    STY L0074
    LDX L3980,Y
    STX L0083
    JMP C517E

.C5170
    TAX
    STX L0074
    LDA L0076
    EOR #1
    STA L0076
    LDA L3980,X
    STA L0083
.C517E
    ASL A
    CLC
    ADC #4
    EOR #&FF
    TAY
    TXA
    PLP
    BCC C518B
    EOR #&FF
.C518B
    CLC
    ADC #&50 ; 'P'
    STA L0077
    AND #&FC
    JSR sub_C50FC
    LDA L0077
    ASL A
    AND #7
    STA L0077
    LDA #4
    STA L0079
    LDA #6
    STA L0075
    JSR sub_C5204
    RTS

.sub_C51A8
    LDA #0
    STA L0079
    LDA L003C
    CMP #&1E
    BCS C51B4
    LDA #&1E
.C51B4
    STA L0074
    LSR A
    CLC
    ADC L0074
    ROR A
    SEC
    SBC #&4C ; 'L'
    BCS C51C2
    ADC #&98
.C51C2
    LDX #&FF
    SEC
.loop_C51C5
    INX
    SBC #&26 ; '&'
    BCS loop_C51C5
    ADC #&26 ; '&'
    CMP #&13
    BCC C51D8
    SBC #&13
    EOR #&FF
    CLC
    ADC #&14
    SEC
.C51D8
    TAY
    STY L0074
    TXA
    AND #3
    TAX
    TXA
    ROL A
    STA L0076
    AND #&FC
    BEQ C51E9
    LDA #7
.C51E9
    STA L0077
    LDA L3100,Y
    STA L0083
    STA L0075
    LDA L32FC,X
    AND #&F8
    STA P
    LDA L32FC,X
    AND #7
    TAY
    LDA L397C,X
    STA Q
.sub_C5204
    LDX L0076
    LDA L3B86,X
    STA C5220
    LDA L3B8E,X
    STA C529B
    LDX L0077
    LDA #0
    SEC
    SBC L0083
    CLC
.C521A
    ADC L0074
    BCC C5221
    SBC L0083
.C5220
    INY
.C5221
    STA L008A
    TXA
    LSR A
    AND #3
    ORA L0079
    STA L0076
    TXA
    BPL C523D
    LDX #7
    LDA P
    SEC
    SBC #8
    STA P
    BCS C524E
    DEC Q
    BCS C524E
.C523D
    CMP #8
    BCC C524E
    LDX #0
    LDA P
    CLC
    ADC #8
    STA P
    BCC C524E
    INC Q
.C524E
    STX L0077
    LDX L0069
    TYA
    BPL C5267
    LDA P
    SEC
    SBC #&40 ; '@'
    STA P
    LDA Q
    SBC #1
    STA Q
    LDY #7
    TYA
    BNE C527B
.C5267
    CMP #8
    BCC C527B
    LDA P
    CLC
    ADC #&40 ; '@'
    STA P
    LDA Q
    ADC #1
    STA Q
    LDY #0
    TYA
.C527B
    ORA P
    STA L07A8,X
    LDA Q
    STA L07D0,X
    LDA (P),Y
    STA L0780,X
    INC L0069
    LDX L0076
    AND L3FE8,X
    ORA L34F8,X
    STA (P),Y
    LDX L0077
    LDA L008A
    CLC
.C529B
    INX
    DEC L0075
    BMI C52A3
    JMP C521A

.C52A3
    RTS

.L52A4
    EQUB &EE, &F7, &62, &A5, &63, &18, &69, &30, &6D, &FA, &62, &8D
    EQUB &FA, &62, &90, &41, &A5, 0  , &F0, &3D, &A2, 4  , &BD, &C0
    EQUB &6F, &5D, &F6, &52, &9D, &C0, &6F, &BD, &F8, &70, &5D, &FB
    EQUB &52, &9D, &F8, &70, &E0, 3  , &B0, &12, &BD, &85, &6E, &49
    EQUB &F0, &9D, &85, &6E, &BD, &BD, &6F, &49, &F0, &9D, &BD, &6F
    EQUB &D0, &10, &BD, &8A, &6E, &49, &C0, &9D, &8A, &6E, &BD, &B2
    EQUB &6F, &49, &30, &9D, &B2, &6F, &CA, &10, &C5, &60, &F0, &F0
    EQUB &C0, &C0, &80, &F0, &F0, &30, &30, &10
.L5300
L5301 = L5300+1
L5302 = L5300+2
L5303 = L5300+3
L5304 = L5300+4
L5305 = L5300+5
L5306 = L5300+6
L5307 = L5300+7
L53D0 = L5300+208
L53E0 = L5300+224
L53F0 = L5300+240
L5400 = L5300+256
L5500 = L5300+512
L5600 = L5300+768
L5700 = L5300+1024
L5800 = L5300+1280
L5900 = L5300+1536
L5901 = L5300+1537
L5902 = L5300+1538
L5903 = L5300+1539
L5904 = L5300+1540
L5905 = L5300+1541
L5906 = L5300+1542
L5907 = L5300+1543
    EQUB 0  , 0  , 0  , &10, &10, &20, &60, &70, &C0, &80, &80, 0  
    EQUB 0  , 0  , 0  , &C0, &60, &10, &10, 0  , 0  , &30, &10, 0  
    EQUB 0  , 0  , &80, &80, &40, &40, &20, &90, &90, &40, &40, &20
    EQUB &20, 0  , &80, &80, &80, 0  , 8  , &0F, &0F, &20, &60, &40
    EQUB &40, &80, &80, &80, &0C, 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , &80, &40, &40
    EQUB &40, &40, &40, &20, &20, 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , &10, &30, 0  , 0  , &10, &30, &70, &F0, &F0
    EQUB &F0, &70, &F0, &F0, &F0, &F0, &E0, &C0, &C0, &F0, &E0, &C0
    EQUB &80, 1  , 3  , 3  , &16, &52, 7  , &2D, &0F, &87, &4B, &0F
    EQUB &0F, &0F, &0F, &87, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F
    EQUB &0F, &0F, &0F, &0B, &0A, &0F, &0E, 7  , 4  , 8  , 0  , &30
    EQUB 0  , &0A, 0  , &30, 0  , &F0, 0  , &F0, 0  , &70, 0  , &F0
    EQUB 0  , &F0, &10, &F0, &30, &F0, &30, &E1, &43, &86, &86, &0C
    EQUB &0C, &87, &0C, 8  , 0  , 0  , 0  , &80, 0  , 0  , 0  , &10
    EQUB &80, 0  , 1  , 1  , 1  , 0  , 0  , &80, &10, 0  , 0  , 0  
    EQUB &0C, &1E, 3  , 1  , 0  , 0  , 0  , &10, 0  , &F0, &C0, &78
    EQUB &2C, &16, &16, 3  , 3  , &E0, 0  , &F0, 0  , &F0, &80, &F0
    EQUB &C0, 5  , 0  , &C0, 0  , &F0, 0  , &F0, 0  , &0F, 7  , &0E
    EQUB 2  , 1  , 0  , &C0, 0  , &0F, &0F, &0F, &0F, &0F, &0F, &0D
    EQUB 5  , &0F, &0F, &1E, &0F, &0F, &0F, &0F, &0F, &A4, &0E, &4B
    EQUB &0F, &1E, &2D, &0F, &0F, &F0, &70, &30, &10, 8  , &0C, &0C
    EQUB &86, &E0, &F0, &F0, &F0, &F0, &70, &30, &30, 0  , 0  , &80
    EQUB &C0, &E0, &F0, &F0, &F0, 0  , 0  , 0  , 0  , 0  , 0  , &80
    EQUB &C0, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , &10, &20, &20, &20, &20, &20, &40
    EQUB &40, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , &40, &60, &20, &20, &10, &10, &10
    EQUB 3  , 0  , &10, &10, &10, 0  , 1  , &0F, &0F, 1  , &E0, &F0
    EQUB &F0, &F0, &F0, &F0, &F0, &0F, 3  , &C1, &E0, &F0, &F0, &F0
    EQUB &F0, 0  , &0C, &0E, 7  , &83, &C1, &E1, &E0, 0  , 0  , 0  
    EQUB 0  , &0F, &0F, &0F, &0F, &20, &20, &20, &20, &20, &0F, &0F
    EQUB &0F, 0  , 0  , 0  , 0  , 0  , 0  , &0F, &0F, 0  , 0  , 0  
    EQUB &10, &30, &70, &78, &F0, &70, &70, &F0, &F0, &F0, &F0, &F0
    EQUB &F0, &F0, &F0, &E0, &E0, &C0, &80, 0  , 0  , &80, 0  , 0  
    EQUB 1  , 1  , 3  , 3  , 7  , 7  , &3C, &0F, &4B, &0F, &4B, &87
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0C
    EQUB &0B, &0E, &0C, 4  , &0C, &0E, 8  , &10, 0  , &70, 0  , &F0
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0
    EQUB 0  , &F0, 0  , &F0, 0  , &E1, &21, &C3, &43, &C2, &86, &84
    EQUB &84, 8  , 0  , &40, 0  , 0  , 0  , 0  , 0  , 0  , 6  , 4  
    EQUB 6  , 2  , 6  , 0  , 0  , 1  , 1  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 4  , &0C, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 3  , 1  
    EQUB 1  , 1  , 1  , 0  , 0  , 1  , 0  , &20, 0  , 0  , 0  , 0  
    EQUB 0  , &78, &48, &3C, &2C, &34, &16, &12, &12, &F0, 0  , &F0
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0
    EQUB 0  , 7  , 1  , &80, 0  , &E0, 0  , &F0, 0  , &0F, &0F, 3  
    EQUB &0D, 7  , 3  , 2  , 3  , &0F, &0F, &0F, &0F, &0F, &0F, &0F
    EQUB &0F, &0E, &C3, &0F, &2D, &0F, &2D, &1E, &0F, &10, 0  , 0  
    EQUB 8  , 8  , &0C, &0C, &0E, &F0, &F0, &70, &70, &30, &10, 0  
    EQUB 0  , &E0, &E0, &F0, &F0, &F0, &F0, &F0, &F0, 0  , 0  , 0  
    EQUB &80, &C0, &E0, &E1, &F0, 0  , 0  , 0  , 0  , 0  , 0  , &0F
    EQUB &0F, &40, &40, &40, &40, &40, &0F, &0F, &0F, 0  , 0  , 0  
    EQUB 0  , &0F, &0F, &0F, &0F, 0  , 3  , 7  , &0E, &1C, &38, &78
    EQUB &70, &0F, &0C, &38, &70, &F0, &F0, &F0, &F0, 8  , &70, &F0
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0
    EQUB &F0, &F0, &F0, &F0, &F0, &0F, 7  , &87, &87, &83, &C3, &C3
    EQUB &C3, &0F, &0F, &0F, &0F, &0F, &1E, &1E, &3C, &1E, &3C, &3C
    EQUB &78, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &E0, &E0
    EQUB &C0, &E0, &C0, &80, &80, 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 1  , 1  , 1  , 3  , &25, &16, &0F, &4B, &0F, &C3, &0F
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0E, &0E, &0D, &0E, &0F
    EQUB &0C, &0E, 8  , &14, 8  , &10, 8  , &70, 0  , &F0, 0  , &F0
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, &10, &F0, &10, &F0, &30, &E1
    EQUB &21, &94, &0C, 8  , 8  , 8  , 8  , 8  , 0  , 0  , 4  , 4  
    EQUB 7  , 2  , 2  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 2  , 5  , 7  , 5  , 2  , 0  , &92, 3  , 1  
    EQUB 1  , 1  , 1  , 1  , 0  , &F0, &80, &F0, &80, &F0, &C0, &78
    EQUB &48, &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0
    EQUB 0  , &F0, 0  , &F0, 0  , &80, 1  , &E0, 0  , &F0, 0  , &F0
    EQUB 0  , &0B, 7  , &0F, 3  , 7  , 1  , &82, 1  , &0F, &0F, &0F
    EQUB &0F, &0F, &0F, 7  , 7  , &4A, &86, &0F, &2D, &0F, &3C, &0F
    EQUB &0F, 0  , 0  , 0  , 0  , 8  , 8  , 8  , &0C, &70, &30, &10
    EQUB &10, 0  , 0  , 0  , 0  , &F0, &F0, &F0, &F0, &F0, &70, &70
    EQUB &30, &87, &C3, &C3, &E1, &F0, &F0, &F0, &F0, &0F, &0F, &0F
    EQUB &0F, &0F, &87, &87, &C3, &0F, &0E, &1E, &1E, &1C, &3C, &3C
    EQUB &3C, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &E1, &E0
    EQUB &C0, &87, &87, &84, &1C, &38, &30, &70, &F0, &78, &F0, &F0
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &E0, &E0, &C0, &C0
    EQUB &80, &80, &80, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , &22
    EQUB 0  , 0  , 0  , &22, 0  , &12, &8B, 7  , &AD, &0F, &4B, &0F
    EQUB &2D, &0F, &0F, &87, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0E
    EQUB &0F, 8  , &0E, 8  , &0C, &30, 0  , &70, 0  , &F0, 0  , &F0
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0
    EQUB 0  , &E1, &21, &E1, &21, &E1, &21, &E1, &21, &40, 0  , 0  
    EQUB 0  , 0  , 1  , &40, &41, 0  , 0  , 0  , 0  , 0  , 8  , 8  
    EQUB 8  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , &10, &10, 0  , 0  , 0  , 0  , 0  , 0  , &80
    EQUB &80, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 3  , 2  , 3  , &20, 0  , 0  , 0  , 0  , 8  , &28
    EQUB &28, &78, &48, &78, &48, &78, &48, &78, &48, &F0, 0  , &F0
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &C0, 0  , &E0
    EQUB 0  , &F0, 0  , &F0, 0  , &0F, &0F, 7  , &0F, 1  , 7  , 1  
    EQUB 3  , &0F, &0F, &1E, &0F, &0F, &0F, &0F, &0F, &84, &1D, &0E
    EQUB &5B, &0F, &2D, &0F, &4B, 0  , 0  , &44, 0  , 0  , 0  , &44
    EQUB 0  , &10, &10, 0  , 0  , 0  , 0  , 0  , 0  , &F0, &F0, &F0
    EQUB &70, &70, &30, &30, &10, &E1, &F0, &F0, &F0, &F0, &F0, &F0
    EQUB &F0, &1E, &1E, &12, &83, &C1, &C0, &E0, &F0, &F0, &F0, &F0
    EQUB &F0, &F0, &78, &70, &30, &F0, &F0, &F0, &F0, &F0, &F0, &F0
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0
    EQUB &E0, 0  , 0  , 0  , 0  , &F0, &E0, &C0, 0  , 0  , 0  , 0  
    EQUB &10, &80, &10, &30, &30, &70, &F0, &F0, &F0, &F0, &F0, &F0
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &E0, &E0, &C0, &80, &80
    EQUB 0  , 0  , 0  , 0  , &22, &88, 0  , &11, 0  , 0  , &11, &88
    EQUB &44, &88, &22, &11, &44, &89, 1  , &89, 3  , 3  , &47, &9A
    EQUB 7  , &87, &0F, &0F, &C3, &0F, &0F, &0F, &0F, &0F, &0E, &0D
    EQUB &0F, &0F, &0D, &0E, &0C, &18, 0  , &38, 0  , &70, 0  , &70
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, &61, &F0, 0  , &F0
    EQUB 0  , &F0, 0  , &F0, &0F, &F0, 0  , &F0, 0  , &F0, 0  , &F0
    EQUB &3C, &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &E1, &21, &E1
    EQUB &21, &E1, &21, &E1, &21, 0  , 1  , 0  , 0  , 0  , &40, 0  
    EQUB 8  , 8  , 8  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 1  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 2  , 8  , 8  , 0  , 0  , 0  , &20, 0  , 1  , &78, &48, &78
    EQUB &48, &78, &48, &78, &48, &F0, 0  , &F0, 0  , &F0, 0  , &F0
    EQUB 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, &C3, &F0, 0  , &F0
    EQUB 0  , &F0, 0  , &F0, &0F, &F0, 0  , &F0, 0  , &F0, 0  , &F0
    EQUB &68, &81, 0  , &C1, 0  , &E0, 0  , &E0, 0  , &0F, 7  , &0B
    EQUB &0F, &0F, &0B, 7  , 3  , &1E, &0F, &0F, &3C, &0F, &0F, &0F
    EQUB &0F, &19, 8  , &19, &0C, &0C, &2E, &95, &0E, 0  , &88, &11
    EQUB &22, &11, &44, &88, &22, 0  , 0  , 0  , &44, &11, 0  , &88
    EQUB 0  , &F0, &F0, &70, &70, &30, &10, &10, 0  , &F0, &F0, &F0
    EQUB &F0
    EQUB &F0, &F0, &F0, &F0, &10, &80, &C0, &C0, &E0, &F0, &F0, &F0
    EQUB &F0, &70, &30, 0  , 0  , 0  , 0  , &80, &F0, &F0, &F0, &70
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , &10, &30, &70, &F0
    EQUS "00p"
    EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0
    EQUB &E0, &F0, &E0, &C0, &C0, &80, &80, 0  , 0  , 0  , 0  , &22
    EQUB &88, &22, &22, 0  , &44, 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
.L59D0
    EQUB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    EQUB 0, 0, 0, 0, 0
.L59EA
    EQUB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
.L59FA
    EQUB 0
.L59FB
    EQUB 0
.L59FC
    EQUB 0
.L59FD
    EQUB 0
.L59FE
    EQUB 0
.L59FF
    EQUB 0
.L5A00
    EQUB 0, 0, 0
.L5A03
    EQUB 0, 0, 0
.L5A06
    EQUB 0, 0, 0, 0, 0, 0, 0
.L5A0D
    EQUB 0, 0, 0, 0, 0, 0, 0
.L5A14
    EQUB 0, 0, 0
.L5A17
    EQUB 0
.L5A18
    EQUB 0
.L5A19
    EQUB 0
.L5A1A
    EQUB 0, 0, 0, 0, 0, 0, 0, 0
.sub_C5A22
    BRK
    EQUB 0, 0
.sub_C5A25
    LDA #0
    STA L3878,X
    STA L39F8,X
    STA L0075
    LDY L013C,X
    CPX #6
    BNE C5A39
    LDY L013C
.C5A39
    LDA L5F38
    SEC
    SBC #1
    BEQ C5A5A
    CPY L006F
    BEQ C5A4D
    CPY L5F39
    BCS C5A5A
    ASL A
    BNE C5A5F
.C5A4D
    STA L0075
    LDA L5F38
    JSR sub_C0C00
    STA L0075
    JMP C5A61

.C5A5A
    LDA L5F38
    BNE C5A5F
.C5A5F
    STA L0074
.C5A61
    SED
.C5A62
    LDA L3DF7,X
    CLC
    ADC L3878,X
    STA L3878,X
    LDA L39F8,X
    ADC #0
    STA L39F8,X
    DEC L0074
    BNE C5A62
    DEC L0075
    BPL C5A62
    JSR sub_C6698
    RTS


    ORG &5FD0

.L5FD0
    EQUB 0  , &88, &CC, &EE, &0F, &8F, &CF, &EF, &F0, &F8, &FC, &FE
    EQUB 0  , 8  , &0C, &0E, 0  , &80, &C0, &E0, &0F, 7  , 3  , 1  
    EQUB &F0, &70, &30, &10, &FF, &77, &33, &11, &FF, &7F, &3F, &1F
    EQUB &FF, &F7, &F3, &F1
.L5FF8
    EQUB 3  , &60
.L5FFA
    EQUB &30
.L5FFB
    EQUB &18
.L5FFC
    EQUB &0C
.L5FFD
    EQUB 6
.L5FFE
    EQUB 3
.L5FFF
    EQUB 1  , 0  , 1  , 2  , 3  , 4  , 5  , 6  , 7  , 8  , 9  , &0A
    EQUB &0B, &0C, &0D, &0E, &0F, &10, &11, &12, &13, &14, &15, &16
    EQUB &17, &18, &19, &1A, &1B, &1C, &1D, &1E, &1F, &20, &21, &22
    EQUB &23, &24, &25, &26, &27, &28, &29, &2A, &2B, &2C, &2D, &2E
    EQUB &2F, &30, &31, &32, &33, &34, &35, &36, &37, &38, &39, &3A
    EQUB &3B, &3C, &3D, &3E, &3F, &40, &41, &42, &43, &44, &45, &46
    EQUB &47, &48, &49, &4A, &4B, &4C, &4D, &4E, &4F, &50, &51, &52
    EQUB &53, &54, 0  , &56, &57, &58, &59, &5A, &5B, &5C, &5D, &5E
    EQUB &5F, &60, &61, &62, &63, &64, &65, &66, &67, &68, &69, &6A
    EQUB &6B, &6C, &6D, &6E, &6F, &70, &71, &72, &73, &74, &75, &76
    EQUB &77, &78, &79, &7A, &7B, &7C, &7D, &7E, &7F, &80, &81, &82
    EQUB &83, &84, &85, &86, &87, &88, &89, &8A, &8B, &8C, &8D, &8E
    EQUB &8F, &90, &91, &92, &93, &94, &95, &96, &97, &98, &99, &9A
    EQUB &9B, &9C, &9D, &9E, &9F, &A0, &A1, &A2, &A3, &A4, &A5, &A6
    EQUB &A7, &A8, &A9, &AA, &AB, &AC, &AD, &AE, &AF, &B0, &B1, &B2
    EQUB &B3, &B4, &B5, &B6, &B7, &B8, &B9, &BA, &BB, &BC, &BD, &BE
    EQUB &BF, &C0, &C1, &C2, &C3, &C4, &C5, &C6, &C7, &C8, &C9, &CA
    EQUB &CB, &CC, &CD, &CE, &CF, &D0, &D1, &D2, &D3, &D4, &D5, &D6
    EQUB &D7, &D8, &D9, &DA, &DB, &DC, &DD, &DE, &DF, &E0, &E1, &E2
    EQUB &E3, &E4, &E5, &E6, &E7, &E8, &E9, &EA, &EB, &EC, &ED, &EE
    EQUB &EF, &F0, &F1, &F2, &F3, &F4, &F5, &F6, &F7, &F8, &F9, &FA
    EQUB &FB, &FC, &FD, &FE, &FF
.L6100
    EQUB 0  , 1  , 3  , 4  , 5  , 6  , 8  , 9  , &0A, &0B, &0D, &0E
    EQUB &0F, &11, &12, &13, &14, &16, &17, &18, &19, &1B, &1C, &1D
    EQUB &1E, &20, &21, &22, &24, &25, &26, &27, &29, &2A, &2B, &2C
    EQUB &2E, &2F, &30, &31, &33, &34, &35, &36, &37, &39, &3A, &3B
    EQUB &3C, &3E, &3F, &40, &41, &43, &44, &45, &46, &47, &49, &4A
    EQUB &4B, &4C, &4D, &4F, &50, &51, &52, &53, &55, &56, &57, &58
    EQUB &59, &5B, &5C, &5D, &5E, &5F, &60, &62, &63, &64, &65, &66
    EQUB &67, &68, &6A, &6B, &6C, &6D, &6E, &6F, &70, &72, &73, &74
    EQUB &75, &76, &77, &78, &79, &7A, &7C, &7D, &7E, &7F, &80, &81
    EQUB &82, &83, &84, &85, &86, &87, &89, &8A, &8B, &8C, &8D, &8E
    EQUB &8F, &90, &91, &92, &93, &94, &95, &96
.L6180
    EQUB &97, &98, &99, &9A, &9B, &9C, &9D, &9E, &9F, &A0, &A1, &A2
    EQUB &A3, &A4, &A5, &A6, &A7, &A8, &A9, &AA, &AB, &AC, &AD, &AE
    EQUB &AF, &B0, &B1, &B1, &B2, &B3, &B4, &B5, &B6, &B7, &B8, &B9
    EQUB &BA, &BB, &BC, &BC, &BD, &BE, &BF, &C0, &C1, &C2, &C3, &C3
    EQUB &C4, &C5, &C6, &C7, &C8, &C9, &C9, &CA, &CB, &CC, &CD, &CE
    EQUB &CE, &CF, &D0, &D1, &D2, &D3, &D3, &D4, &D5, &D6, &D7, &D7
    EQUB &D8, &D9, &DA, &DB, &DB, &DC, &DD, &DE, &DE, &DF, &E0, &E1
    EQUB &E1, &E2, &E3, &E4, &E4, &E5, &E6, &E7, &E7, &E8, &E9, &EA
    EQUB &EA, &EB, &EC, &EC, &ED, &EE, &EF, &EF, &F0, &F1, &F1, &F2
    EQUB &F3, &F3, &F4, &F5, &F5, &F6, &F7, &F8, &F8, &F9, &FA, &FA
    EQUB &FB, &FB, &FC, &FD, &FD, &FE, &FF, &FF, &FF, &FE, &FC, &FA
    EQUB &F8, &F6, &F5, &F3, &F1, &EF, &ED, &EC, &EA, &E8, &E7, &E5
    EQUB &E4, &E2, &E0, &DF, &DD, &DC, &DA, &D9, &D8, &D6, &D5, &D3
    EQUB &D2, &D1, &CF, &CE, &CD, &CC, &CA, &C9, &C8, &C7, &C5, &C4
    EQUB &C3, &C2, &C1, &C0, &BF, &BD, &BC, &BB, &BA, &B9, &B8, &B7
    EQUB &B6, &B5, &B4, &B3, &B2, &B1, &B0, &AF, &AE, &AD, &AC, &AC
    EQUB &AB, &AA, &A9, &A8, &A7, &A6, &A5, &A5, &A4, &A3, &A2, &A1
    EQUB &A1, &A0, &9F, &9E, &9E, &9D, &9C, &9B, &9B, &9A, &99, &98
    EQUB &98, &97, &96, &96, &95, &94, &94, &93, &92, &92, &91, &90
    EQUB &90, &8F, &8E, &8E, &8D, &8D, &8C, &8B, &8B, &8A, &8A, &89
    EQUB &89, &88, &87, &87, &86, &86, &85, &85, &84, &84, &83, &83
    EQUB &82, &82, &81, &81
.L6280
    EQUB 0
.L6281
    EQUB 0
.L6282
    EQUB 0
.L6283
    EQUB 0
.L6284
    EQUB 0
.L6285
    EQUB 0
.L6286
    EQUB 0, 0, 0
.L6289
    EQUB 0, 0, 0, 0, 0, 0
.L628F
    EQUB 0
.L6290
    EQUB 0, 0
.L6292
    EQUB 0
.L6293
    EQUB 0, 0, 0, 0, 0, 0
.L6299
    EQUB 0, 0, 0
.L629C
    EQUB 0, 0, 0, 0
.L62A0
    EQUB 0
.L62A1
    EQUB 0
.L62A2
    EQUB 0
.L62A3
    EQUB 0, 0
.L62A5
    EQUB 0
.L62A6
    EQUB 0
.L62A7
    EQUB 0
.L62A8
    EQUB 0, 0
.L62AA
    EQUB 0, 0
.L62AC
    EQUB 0, 0
.L62AE
    EQUB 0, 0, 0
.L62B1
    EQUB 0, 0, 0
.L62B4
    EQUB 0, 0, 0
.L62B7
    EQUB 0, 0, 0
.L62BA
    EQUB 0, 0, 0
.L62BD
    EQUB 0, 0, 0
.L62C0
    EQUB 0, 0, 0
.L62C3
    EQUB 0, 0, 0, 0, 0, 0, 0, 0, 0
.L62CC
    EQUB 0
.L62CD
    EQUB 0, 0, 0
.L62D0
    EQUB 0, 0
.L62D2
    EQUB 0
.L62D3
    EQUB 0, 0
.L62D5
    EQUB 0
.L62D6
    EQUB 0, 0
.L62D8
    EQUB 0
.L62D9
    EQUB 0
.L62DA
    EQUB 0
.L62DB
    EQUB 0
.L62DC
    EQUB 0, 0
.L62DE
    EQUB 0
.L62DF
    EQUB 0
.L62E0
    EQUB 0, 0
.L62E2
    EQUB 0
.L62E3
    EQUB 0, 0
.L62E5
    EQUB 0
.L62E6
    EQUB 0
.L62E7
    EQUB 0
.L62E8
    EQUB 0
.L62E9
    EQUB 0
.L62EA
    EQUB 0
.L62EB
    EQUB 0
.L62EC
    EQUB 0, 0
.L62EE
    EQUB 0
.L62EF
    EQUB 0
.L62F0
    EQUB 0
.L62F1
    EQUB 0
.L62F2
    EQUB 0
.L62F3
    EQUB 0
.L62F4
    EQUB 0
.L62F5
    EQUB 0
.L62F6
    EQUB 0
.L62F7
    EQUB 0
.L62F8
    EQUB 0
.L62F9
    EQUB 0, 0
.L62FB
    EQUB 0
.L62FC
    EQUB 0
.L62FD
    EQUB 0
.L62FE
    EQUB 0
.L62FF
    EQUB 0
.sub_C6300
    STA P
    STY Q
    STX L0077
    LDA #osbyte_select_input_stream
    LDX #0
    JSR osbyte
    LDA #osbyte_flush_buffer
    LDX #0
    JSR osbyte
.loop_C6314
    LDY #0
.C6316
    JSR osrdch
    BCS C6345
    CMP #&0D
    BEQ C6352
    CMP #&20 ; ' '
    BCC C6316
    BNE C6329
    CPY #0
    BEQ C6316
.C6329
    CMP #&7F
    BCC C6334
    BNE C6316
    DEY
    BPL C633F
    BMI loop_C6314
.C6334
    CPY L0077
    BNE C633C
    LDA #7
    BNE C633F
.C633C
    STA (P),Y
    INY
.C633F
    JSR oswrch
    JMP C6316

.C6345
    TYA
    PHA
    LDA #osbyte_acknowledge_escape
    JSR osbyte
    PLA
    TAY
    JMP C6316

.loop_C6351
    INY
.C6352
    CPY L0077
    BNE C6357
    RTS

.C6357
    LDA #&20 ; ' '
    STA (P),Y
    BNE loop_C6351
.sub_C635D
    LDX L004A
    LDA user_via_t2c_l
    PHP
    AND #&7F
    LDY #&10
.loop_C6367
    CMP #4
    BCC C637B
    SBC #4
    DEY
    BNE loop_C6367
    LDY #9
.loop_C6372
    CMP #7
    BCC C637B
    SBC #7
    DEY
    BNE loop_C6372
.C637B
    PLP
    JSR sub_C3450
    ASL A
    SEC
    SBC L04A0,X
    STA L0074
    LDY L5F3A
    DEY
    BEQ C6395
    BPL C6392
    ASL A
    JMP C6395

.C6392
    ROL L0074
    ROR A
.C6395
    CLC
    ADC L5F40
    STA L0128,X
    JSR sub_C507E
    STX L004A
    RTS

.sub_C63A2
    LDA L006F
    LDX #&13
.loop_C63A6
    CMP L013C,X
    BEQ C63AE
    DEX
    BPL loop_C63A6
.C63AE
    STX L0003
    JSR sub_C5084
    STX L005B
    LDX L0003
    JSR sub_C507E
    STX L004D
    RTS

.C63BD
    JMP C3850

    EQUB &EA, &EA, &EA, &EA, &EA
.sub_C63C5
    PHA
    LDA L05F8
    STA L77E3
    LSR A
    STA L77E4
    LSR A
    STA L77DC
    LSR A
    STA L77DB
    LDA L0025
    ROL A
    PLA
    LDX L05F8
    RTS

.C63E0
    LDX #0
    STX L05F4
    JSR sub_C4D4D
    LDX #4
    JSR sub_C41D0
    JSR sub_C3A50
    LDX #&27 ; '''
    JSR sub_C4D7E
    LDX #2
    JSR sub_C6571
    CPX #1
    BCS C640A
    STX L006F
    DEX
    STX L5F3B
    JSR sub_C42EC
    JSR sub_C655A
.C640A
    LDA #0
    STA L5F3C
    LDX #&15
    JSR sub_C4D7E
    LDX #3
    JSR sub_C6571
    STX L5F3A
    JSR sub_C44C6
.C641F
    LDX #&16
    JSR sub_C4D7E
    LDX #3
    JSR sub_C6571
    LDA L3DF0,X
    STA L5F3B
    JSR sub_C42EC
    LDA #&14
    STA L006F
.C6436
    DEC L006F
    LDX L006F
    JSR sub_C40EB
    LDA L5F3C
    BEQ C6457
    JSR sub_C6687
    JSR sub_C655A
    LDA L006F
    CMP L5F39
    BNE C6436
    LDA #0
    JSR sub_C0F64
    JMP C64B3

.C6457
    LDX #&17
    JSR sub_C4D7E
    JSR sub_C66D4
    JSR sub_C655A
    LDX L006F
    BEQ C6474
    LDX #&1B
    JSR sub_C4D7E
    LDX #2
    JSR sub_C6571
    CPX #0
    BEQ C6436
.C6474
    LDA L006F
    STA L5F39
    LDA #0
    JSR sub_C0F64
    LDX #0
.loop_C6480
    LDY L014F
    CPY L5F39
    BCC C64A2
    LDA L06B8,Y
    SEC
    SBC L5A00,X
    LDA L06D0,Y
    SBC L5A03,X
    BCS C649A
    INX
    BNE loop_C6480
.C649A
    CPX L5F3A
    BCS C64A2
    STX L5F3A
.C64A2
    LDX L5F3A
    JSR sub_C44C6
    LDX #&1A
    JSR sub_C4D7E
    JSR sub_C3C6F
    JSR sub_C34D0
.C64B3
    LDX #2
    LDA #0
    JSR sub_C65D3
    LDY #&13
.loop_C64BC
    LDA L013C,Y
    STA L04C8,Y
    CMP L5F39
    BCC C64CF
    TAX
    LDA L0100,Y
    LSR A
    STA L04A0,X
.C64CF
    DEY
    BPL loop_C64BC
    LDA L5F3C
    BNE C64F2
    LDX #&1C
    JSR sub_C4D7E
    LDA #&14
    SEC
    SBC L5F39
    STA L5F38
    LDX #3
    JSR sub_C6571
    LDA L3DF4,X
    STA L006E
    STX L5F3F
.C64F2
    LDA #&14
    STA L006F
.C64F6
    DEC L006F
    JSR sub_C6687
    LDX #&13
.loop_C64FD
    LDA L04C8,X
    STA L013C,X
    DEX
    BPL loop_C64FD
    JSR sub_C42EC
    LDA #&80
    JSR sub_C655C
    LDA #&80
    JSR sub_C0F64
    LDX #5
.loop_C6515
    JSR sub_C5A25
    DEX
    BPL loop_C6515
    LDA #0
    JSR sub_C0F64
    LDX #6
    JSR sub_C5A25
.C6525
    LDA #&80
    JSR sub_C0F64
    LDX #1
    LDA #4
    JSR sub_C65D3
    LDA #0
    JSR sub_C0F64
    LDX #6
    LDA #0
    JSR sub_C65D3
    LDA #&40 ; '@'
    JSR sub_C0F64
    LDX #3
    STX L5F3C
    LDA #&88
    JSR sub_C65D3
    BIT L0078
    BPL C6525
    LDA L006F
    CMP L5F39
    BNE C64F6
    JMP C641F

.sub_C655A
    LDA #&28 ; '('
.sub_C655C
    STA L006C
    STA L006D
.loop_C6560
    JSR sub_C3C50
    JSR sub_C16DC
    BIT L05F4
    BVS loop_C6560
    BPL C6570
    JSR sub_C3273
.C6570
    RTS

.sub_C6571
    LDY #0
    STY L0077
    STX L0075
.C6577
    JSR sub_C3261
    LDY L0075
.loop_C657C
    STY L0076
    LDX L39E0,Y
    JSR sub_C0E50
    BEQ C658D
    LDY L0076
    DEY
    BPL loop_C657C
    BMI C6577
.C658D
    LDY L0076
    BNE C659E
    LDA L0077
    BEQ C6577
    LDA #&98
    STA L7FC5
    LDX L0078
    DEX
    RTS

.C659E
    STY L0078
    LDA L0077
    BNE C65AB
    LDX #&1E
    STX L0077
    JSR sub_C4D7E
.C65AB
    LDX #0
    LDY #1
.C65AF
    LDA #&84
    CPY L0078
    BNE C65B7
    LDA #&81
.C65B7
    STA L7E85,X
    TXA
    CLC
    ADC #&50 ; 'P'
    TAX
    INY
    CPY L0075
    BCC C65AF
    BEQ C65AF
    BNE C6577
.sub_C65C8
    CMP #&0A
    BCC C65CE
    ADC #5
.C65CE
    SED
    ADC #1
    CLD
    RTS

.sub_C65D3
    PHA
    AND #&0F
    STA L0042
    JSR sub_C41D0
    LDY #0
.C65DD
    STY L001B
    LDA #0
    STA L0078
    JSR sub_C3E60
    LDX #&20 ; ' '
    JSR sub_C4D7E
    LDY L001B
    LDA L0100,Y
    BIT L006C
    BMI C65F5
    TYA
.C65F5
    JSR sub_C65C8
    JSR sub_C37D6
    LDX #&1F
    JSR sub_C4D7E
    LDY L001B
    JSR sub_C667B
    LDX #&1F
    JSR sub_C4D7E
    LDX L0045
    PLA
    PHA
    BNE C6618
    LDA #&26 ; '&'
    JSR L7B9C
    JMP C6643

.C6618
    BMI C662B
    LDA L001B
    CLC
    ADC #&14
    CMP #&1A
    TAX
    BCC C6640
    LDA #7
    JSR sub_C3D50
    BEQ C6643
.C662B
    LDA #&28 ; '('
    STA L0078
    LDA L04F0,X
    BEQ C6640
    JSR sub_C37D6
    LDA L39E4,X
    JSR C43E7
    JMP C6643

.C6640
    JSR sub_C43D0
.C6643
    LDY L001B
    INY
    CPY #&14
    BNE C65DD
    LDA #3
    JSR sub_C3D50
    LDA #&9C
    JSR oswrch
    LDA L006C
    BPL C666E
    LDX #&31 ; '1'
    JSR sub_C4D7E
    JSR sub_C3C6F
    LDA L5F3F
    CLC
    ADC #&DA
    STA L3C7D
    LDX #&32 ; '2'
    JSR sub_C4D7E
.C666E
    PLA
    JSR sub_C34D2
    RTS

.sub_C6673
    STA L62CD
    LDA #&1B
    STA L62CC
.sub_C667B
    LDX L013C,Y
    STX L0045
    JSR sub_C3CEB
    JSR sub_C3250
    RTS

.sub_C6687
    LDX #&1D
    JSR sub_C4D7E
    LDX L006F
    JSR sub_C3CEB
    JSR sub_C3250
    JSR sub_C34D0
    RTS

.sub_C6698
    SED
    LDA L3864,Y
    CLC
    ADC L3878,X
    STA L3864,Y
    LDA L39E4,Y
    ADC L39F8,X
    STA L39E4,Y
    LDA L04F0,Y
    ADC #0
    STA L04F0,Y
    CLD
    RTS

.sub_C66B6
    LDX L001F
    LDA #&80
.loop_C66BA
    STA L05A4,X
    STA L0650,X
    STA L0600,X
    STA L0554,X
    DEX
    BPL loop_C66BA
    LDX #&4F ; 'O'
    LDA #0
.loop_C66CD
    STA L5F60,X
    DEX
    BPL loop_C66CD
    RTS

.sub_C66D4
    LDX L006F
    JSR sub_C3CEB
    LDX #&0C
    JSR sub_C6300
    RTS

.sub_C66DF
    LDX L0003
    BPL C66E6
.loop_C66E3
    JSR sub_C2ACB
.C66E6
    JSR sub_C5084
    CPX L004D
    BNE loop_C66E3
    LDX #&16
.loop_C66EF
    STX L0045
    JSR sub_C2AD1
    DEX
    CPX #&14
    BCS loop_C66EF
    LDX L004D
    JSR sub_C2ACB
    RTS

    EQUB 0

    ORG &6C00

.L6C00
L7000 = L6C00+1024
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , &30, &30, &40, 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0  
    EQUB 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0  
    EQUB 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0  
    EQUB 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0  
    EQUB 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0  
    EQUB 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0  
    EQUB 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0  
    EQUB 0  , 0  , 0  , 0  , 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0  
    EQUB 0  , &F0, &F0, 0  , 0  , 0  , 0  , 0  , 0  , &C0, &C0, &20
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
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , &10, &10, &10, &70, &40, &F0, &80, &F0, 0  , &F0, 0  
    EQUB &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  
    EQUB &F0, 0  , &E1, &16, &F0, 0  , &F0, 0  , &C3, &2D, &5A, &C3
    EQUB &F0, 0  , &F0, 7  , &78, &A5, &87, &1E, &F0, 0  , &0F, &B4
    EQUB &D2, &0F, &2D, &0F, &F0, 7  , &78, &F0, &4B, &1E, &4B, &0F
    EQUB &F0, &0E, &E1, &F0, &2D, &87, &2D, &0F, &F0, 0  , &0F, &D2
    EQUB &B4, &0F, &4B, &0F, &F0, 0  , &F0, &0E, &E1, &5A, &1E, &87
    EQUB &F0, 0  , &F0, 0  , &3C, &4B, &A5, &3C, &F0, 0  , &F0, 0  
    EQUB &F0, 0  , &78, &86, &F0, 0  , &F0, 0  , &F0, 0  , &F0, 0  
    EQUB &E0, &20, &F0, &10, &F0, 0  , &F0, 0  , 0  , 0  , 0  , 0  
    EQUB 0  , &80, &80, &80, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , &A0, &50, &B0
    EQUB 0  , 0  , 0  , 0  , 0  , &D0, &A0, &40, 0  , 0  , 0  , 0  
    EQUB 0  , &F0, &10, 0  , 0  , 0  , 0  , 0  , 0  , 0  , &80, &C0
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , &10, &30, &30, &20, &30, &40, &70, &C0, &F0, &80
    EQUB &F0, 0  , &F0, 0  , &E1, 3  , &96, &0F, &F0, 1  , &87, &3C
    EQUB &4B, &C3, &87, &4B, &2D, &69, &87, &1E, &0F, &87, &0F, &0F
    EQUB &87, &4B, &0F, &0F, &0F, &0F, &0F, &0F, &87, &0F, &0F, &0F
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0E, 1  , &0F, &0F, &0F, &0F
    EQUB &0F, &0F, 7  , 8  , &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F
    EQUB &1E, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &1E, &2D, &0F, &0F
    EQUB &0F, &0F, &0F, &0F, &4B, &69, &1E, &87, &0F, &1E, &0F, &0F
    EQUB &F0, 8  , &1E, &C3, &2D, &3C, &1E, &2D, &F0, 0  , &F0, 0  
    EQUB &78, &0C, &96, &0F, &C0, &40, &C0, &20, &E0, &30, &F0, &10
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , &80, &C0, 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , &10, &30
    EQUB 0  , 0  , 0  , 0  , 0  , &F0, &80, 0  , 0  , 0  , 0  , 0  
    EQUB 0  , &B0, &50, &20, 0  , 0  , 0  , 0  , 0  , &50, &A0, &D0
    EQUB &20, &40, &90, &90, &20, &20, &40, &40, &C0, &80, 0  , 0  
    EQUB 0  , &10, &10, &20, 0  , 0  , &30, &60, &80, &80, 0  , 0  
    EQUB &40, &60, &E0, &30, &10, &10, 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , &80, &80, 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , &10, &30, 0  , 0  , &10, &30
    EQUB &70, &F0, &F0, &F0, &70, &F0, &F0, &F0, &F0, &E0, &A1, 3  
    EQUB &E1, &81, &C3, &16, &0F, &2D, &87, &2D, &2D, &5A, &0F, &0F
    EQUB &87, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, 5  , &0C, &0F, &0F, &0F, 7  
    EQUB &0A, 2  , 4  , 0  , &0F, 6  , 6  , 8  , 4  , 0  , &F0, 0  
    EQUB 5  , &0D, 9  , 0  , &70, &30, &E1, &C3, &0D, 2  , 0  , 0  
    EQUB &F0, &87, &0F, &0E, &0B, 4  , 0  , 0  , &F0, &1E, &0F, 7  
    EQUB &0A, &0B, 9  , 0  , &E0, &C0, &78, &3C, &0F, 6  , 6  , 1  
    EQUB 2  , 0  , &F0, 0  , &0F, &0F, &0F, &0E, 5  , 4  , 2  , 0  
    EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0A, 3  , &0F, &0F, &0F, &0F
    EQUB &0F, &0F, &0F, &0F, &4B, &A5, &0F, &0F, &1E, &0F, &0F, &0F
    EQUB &78, &18, &3C, &86, &0F, &4B, &1E, &4B, &E0, &F0, &F0, &F0
    EQUB &F0, &70, &58, &0C, 0  , 0  , &80, &C0, &E0, &F0, &F0, &F0
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , &80, &C0, 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0  , 0  , 0  , 0  , 0  , 0  
    EQUB 0

    ORG &7900

; Move block from &1200-&12FF to &7900-&79FF and jump to &790E
.Entry
    LDY #0
.entr1
    LDA C1200,Y
    STA Entry,Y
    INY
    BNE entr1
    JMP SwapCode

; Disable the ESCAPE key and clear memory if the BREAK key is pressed
.SwapCode
    LDA #osbyte_read_write_escape_break_effect
    LDX #3
    LDY #0
    JSR osbyte
; *TAPE
    LDA #osbyte_tape
    LDX #0
    JSR osbyte
; Set (Q P) = &5300 = trackData, destintion address for track data
    LDA #0
    STA P
    LDA #&53 ; 'S'
    STA Q
; Set (S R) = &70DB, source address of track data
    LDA #&DB
    STA R
    LDA #&70 ; 'p'
    STA S
; Swap memory between &70DB-&7724 to &5300-&5949 and decrement
; checksum bytes in &7800-&7803
    LDY #0
; Swap Y-th byte of (Q P) and (S R)
.swap1
    LDA (R),Y
    PHA
    LDA (P),Y
    STA (R),Y
    PLA
    STA (P),Y
; Decrement the relevant checksum byte at &7800-&7803
    AND #3
    TAX
    DEC trackChecksum,X
; Increment loop counter
    INY
; Increment high bytes to move on to next page
    BNE swap2
    INC Q
    INC S
; If we have not yet reached &7725, jump back to swap1 to keep going
.swap2
    CPY #&25 ; '%'
    BNE swap1
    LDA S
    CMP #&77 ; 'w'
    BNE swap1
; Now check that all three checksum bytes in &7800-&7803 are zero
    LDX #3
.swap3
    LDA trackChecksum,X
; If a checksum byte is non-zero, jump to swap4 to reset the machine
    BNE swap4
    DEX
; Loop back to check the next checksum byte
    BPL swap3
; All checksum bytes are zero, so jump to swap4 to keep going
    BMI MoveCode
; Reset the machine
.swap4
    JMP (LFFFC)

; Move block (blockStartHi blockStartLo) - (blockEndHi blockEndLo)-1
; to (blockToHi blockToLo)
;   * Move &1500-&15DA to &7000-&70DA
;   * Move &1300-&14FF to &0B00-&0CFF
;   * Move &5A80-&645B to &0D00-&16DB
;   * Move &64D0-&6BFF to &5FD0-&63FF
;   * Zero &5A80-&5E3F
.MoveCode
    LDX #4
    LDY #0
.move1
    LDA blockStartLo,X
    STA P
    LDA blockStartHi,X
    STA Q
    LDA blockToLo,X
    STA R
    LDA blockToHi,X
    STA S
.move2
L7979 = move2+1
    LDA (P),Y
    STA (R),Y
    INC P
    BNE move3
    INC Q
.move3
    INC R
    BNE move4
    INC S
.move4
    LDA P
    CMP blockEndLo,X
    BNE move2
    LDA Q
    CMP blockEndHi,X
    BNE move2
    DEX
    BMI move5
    BNE move1
; We get here when X = 0
; Modify the instruction at move2 to LDA #0, so the last block move
; actually zeroes the block
    LDA ldaZero
    STA move2
    LDA L79AE
    STA L7979
; Loop back to move1 to zero the rest of the block
    JMP move1

.move5
    JMP C63BD

.ldaZero
L79AE = ldaZero+1
    LDA #0
.blockStartLo
    EQUB &80, &D0, &80, 0  , 0  
.blockStartHi
    EQUB &5A, &64, &5A, &13, &15
.blockEndLo
    EQUB &40, 0  , &5C, 0  , &DB
.blockEndHi
    EQUB &5E, &6C, &64, &15, &15
.blockToLo
    EQUB &80, &D0, 0  , 0  , 0  
.blockToHi
    EQUB &5A, &5F, &0D, &0B, &70
    EQUB 9  , &B9, 2  , &50, &9D, 1  , 9  , &9D, &79, 9  , &B9, 3  
    EQUB &50, &9D, 2  , 9  , &B9, 1  , &51, &9D, 0  , &0A, &B9, 2  
    EQUB &51, &9D, 1  , &0A, &9D, &79, &0A, &B9, 3  , &51, &9D, 2  
    EQUB &0A, &B9, 4  , &50, &9D, &78, 9  , &B9, 6  , &50, &9D, &7A
    EQUB 9  , &B9, 4  

    ORG &8000

    EQUB &20, 0  , &63, &60, &A6, 3  , &10, 3  , &20, &CB, &2A, &20
    EQUB &84, &50, &E4, &4D, &D0, &F6, &A2, &16, &86, &45, &20, &D1
    EQUB &2A, &CA, &E0, &14, &B0, &F6, &A6, &4D, &20, &CB, &2A, &60
    EQUB &20, &0E, &2B, &A2, &F4, &20, &CC, &0B, &20, &0E, &2B, &A2
    EQUB &FD, &20, &CC, &0B, &A9, &14, &85, &42, &A9, 2  , &20, &5D
    EQUB &2A, &A9, &15, &85, &42, &A9, 1  , &A2, &F4, &20, &5F, &2A
    EQUB &A9, &16, &85, &42, &A9, 0  , &A2, &FA, &20, &5F, &2A, &A6
    EQUB &45, &60, &C9, 5  , &90, &F9, &BD, &8C, 1  , &30, &F4, &FE
    EQUB &8C, 1  , &60, &A2, &FD, &85, &37, &20, &45, &21, &A4, &42
    EQUB &A5, &8A, &99, &80, 3  , &A5, &8B, &99, &98, 3  , &20, &B1
    EQUB &2A, &20, &85, &22, &A4, &42, &B0, &2C, &38, &E9, 1  , &30
    EQUB &27, &99, &B0, 3  , &A5, &2B, &38, &E9, 9  , &AA, &A5, &2A
    EQUB &CA, &F0, &0C, &10, 6  , &4A, &E8, &D0, &FC, &F0, 4  , &0A
    EQUB &CA, &D0, &FC, &99, &C8, 3  , &B9, &8C, 1  , &29, &70, 5  
    EQUB &37, &4C, &AD, &2A, &A4, &42, &B9, &8C, 1  , 9  , &80, &99
    EQUB &8C, 1  , &60, &A0, &25, &20, &A5, &0C, &A5, &7D, &85, &55
    EQUB &D0, &0E, &C4, &7C, &90, &0A, &C6, &68, &A5, &7C, &85, &41
    EQUB &A5, &42, &85, &67, &60, &86, &45, &BD, &3C, 1  , &AA, &BD
    EQUB &8C, 1  , &30, &35, &29, &0F, &85, &37, &BD, &80, 3  , &38
    EQUB &E5, &0A, &85, &74, &BD, &98, 3  , &E5, &0B, &10, 6  , &C9
    EQUB &E0, &90, &1E, &B0, 4  , &C9, &20, &B0, &18, 6  , &74, &2A
    EQUB 6  , &74, &2A
    EQUB &18, &69

                              \ Game addr to file addr
COPYBLOCK &5FD0, &6700, &64D0 \ 5fd0-66ff to 64d0-6bff
COPYBLOCK &0D00, &16DC, &5A80 \ 0d00-16db to 5a80-645b
COPYBLOCK &7000, &70DB, &1500 \ 7000-70da to 1500-15da
COPYBLOCK &0B00, &0D00, &1300 \ 0b00-0cff to 1300-14ff
COPYBLOCK &7900, &7A00, &1200 \ 7900-79ff to 1200-12ff

COPYBLOCK &8000, &8101, &15DB \ Restore noise in 15db-16db

CLEAR &645C, &64D0            \ Zeroes in 645c-64cf

\ ******************************************************************************
\
\ Save Revs.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/Revs.bin", LOAD%, &7000

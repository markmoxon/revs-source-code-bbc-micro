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

IRQ1V = &0204           \ The IRQ1V vector that we intercept to implement the
                        \ screen mode

VIA = &FE00             \ Memory-mapped space for accessing internal hardware,
                        \ such as the video ULA, 6845 CRTC and 6522 VIAs (also
                        \ known as SHEILA)

OSRDCH = &FFE0          \ The address for the OSRDCH routine
OSWRCH = &FFEE          \ The address for the OSWRCH routine
OSBYTE = &FFF4          \ The address for the OSBYTE routine
OSWORD = &FFF1          \ The address for the OSWORD routine

LOAD% = &1200           \ The load address of the main code binary

LOAD_END% = &7000       \ The address of the end of the main code binary

CODE% = &0B00           \ The address of the main game code

trackLoad = &70DB       \ The load address of the track data file

\ ******************************************************************************
\
\       Name: Zero page
\       Type: Workspace
\    Address: &0070 to &008F
\   Category: Workspaces
\    Summary: Mainly temporary variables that are used a lot
\
\ ******************************************************************************

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
printMode = &0064
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
T = &0074
U = &0075
V = &0076
W = &0077
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

L6E85 = &6E85
L6E8A = &6E8A
L6FB2 = &6FB2
L6FBD = &6FBD
L6FC0 = &6FC0

L7000 = &7000
L70F8 = &70F8
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

\ ******************************************************************************
\
\ REVS MAIN GAME CODE
\
\ Produces the binary file Revs.bin that contains the main game code.
\
\ ******************************************************************************

\ ******************************************************************************
\
\       Name: Entry
\       Type: Subroutine
\   Category: Setup
\    Summary: The main entry point for the game: move code into upper memory and
\             call it
\
\ ******************************************************************************

ORG &1200

.Entry

 LDY #0                 \ We start by copying the following block in memory:
                        \
                        \   * &1200-&12FF is copied to &7900-&79FF
                        \
                        \ so set up a byte counter in Y
.entr1

 LDA &1200,Y            \ Copy the Y-th byte of &1200 to the Y-th byte of &7900
 STA &7900,Y

 INY                    \ Increment the byte counter

 BNE entr1              \ Loop back until we have copied a whole page of bytes

 JMP SwapCode           \ Jump to the routine that we just moved to continue the
                        \ setup process

\ Code between &7900 and &79FF starts out at &1200 before being moved

COPYBLOCK &1200, &12FF, &7900
CLEAR &1200, &12FF

\ ******************************************************************************
\
\       Name: SwapCode
\       Type: Subroutine
\   Category: Setup
\    Summary: Move the track data to the right place and run a checksum on it
\
\ ******************************************************************************

ORG &790E

.SwapCode

 LDA #200               \ Call OSBYTE with A = 200, X = 3 and Y = 0 to disable
 LDX #3                 \ the ESCAPE key and clear memory if the BREAK key is
 LDY #0                 \ pressed
 JSR OSBYTE

 LDA #140               \ Call OSBYTE with A = 140 and X = 0 to select the tape
 LDX #0                 \ filing system (i.e. do a *TAPE command)
 JSR OSBYTE

                        \ We now want to move the track data from trackLoad
                        \ (which is where the loading process loads the track
                        \ file) to trackData (which is where the game expects
                        \ to find the track data)
                        \
                        \ At the same time, we also want to move the data that
                        \ is currently at trackData, which is part of the
                        \ dashboard image, into screen memory at trackLoad
                        \
                        \ trackLoad is &70DB and trackData is &5300, so we
                        \ want to do the following:
                        \
                        \   * Swap &70DB-&7724 and &5300-&5949
                        \
                        \ At the same time, we want to perform a checksum on the
                        \ track data and compare the results with the four
                        \ checksum bytes in trackChecksum

 LDA #LO(trackData)     \ Set (Q P) = trackData
 STA P                  \
 LDA #HI(trackData)     \ so that's one address for the swap
 STA Q

 LDA #LO(trackLoad)     \ Set (S R) = trackLoad
 STA R                  \
 LDA #HI(trackLoad)     \ so that's the other address for the swap
 STA S

 LDY #0                 \ Set a byte counter in Y for the swap

.swap1

 LDA (R),Y              \ Swap the Y-th bytes of (Q P) and (S R)
 PHA
 LDA (P),Y
 STA (R),Y
 PLA
 STA (P),Y

 AND #3                 \ Decrement the relevant checksum byte
 TAX                    \
 DEC trackChecksum,X    \ The checksum bytes work like this:
                        \
                        \   * trackChecksum+0 counts the number of data bytes
                        \     ending in %00
                        \
                        \   * trackChecksum+1 counts the number of data bytes
                        \     ending in %01
                        \
                        \   * trackChecksum+2 counts the number of data bytes
                        \     ending in %10
                        \
                        \   * trackChecksum+3 counts the number of data bytes
                        \     ending in %11
                        \
                        \ This code checks off the relevant checksum byte for
                        \ the data byte in A, so if all the data is correct,
                        \ this will eventually decrement all four bytes to zero

 INY                    \ Increment the loop counter

 BNE swap2              \ If we have just crossed a page boundary, increment the
 INC Q                  \ high bytes of (Q P) and (S R) to move on to next page
 INC S

.swap2

 CPY #&25               \ If we have not yet reached address &7725, which is the
 BNE swap1              \ address after the end of the track data, jump back to
 LDA S                  \ swap1 to keep swapping data
 CMP #&77
 BNE swap1

 LDX #3                 \ The data swap is now done, so we now check that all
                        \ three checksum bytes at trackChecksum are zero, so set
                        \ a counter in X to work through the four bytes

.swap3

 LDA trackChecksum,X    \ If the X-th checksum byte is non-zero, the checksum
 BNE swap4              \ has failed, so jump to swap4 to reset the machine

 DEX                    \ Decrement the checksum byte counter

 BPL swap3              \ Loop back to check the next checksum byte

 BMI MoveCode           \ If we get here then all four checksum bytes are zero,
                        \ so jump to swap4 to keep going (this BMI is
                        \ effectively a JMP as we just passed through a BPL)

.swap4

 JMP (&FFFC)            \ The checksum has failed, so reset the machine

\ ******************************************************************************
\
\       Name: MoveCode
\       Type: Subroutine
\   Category: Setup
\    Summary: Move and reset various blocks around in memory
\
\ ------------------------------------------------------------------------------
\
\ This routine moves another batch of memory blocks, as well as zeroing a
\ section of memory. Together with the Entry and SwapCode routines, the various
\ memory-moving routines implement the following operations:
\
\   * Main code loads at:   &1200-&6FFF
\   * Track data loads at:  &70DB-&7813
\
\   * The Entry routine does the following:
\
\     * Move &1200-&12FF to &7900-&79FF
\
\   * The SwapCode routine does the following:
\
\     * Swap memory between &70DB-&7724 and &5300-&5949
\
\   * The MoveCode routine does the following:
\
\     * Move &1500-&15DA to &7000-&70DA
\     * Move &1300-&14FF to &0B00-&0CFF
\     * Move &5A80-&645B to &0D00-&16DB
\     * Move &64D0-&6BFF to &5FD0-&63FF
\     * Zero &5A80-&5E3F
\
\ Put together, these routines reorganise the game binary, which has the
\ following file structure:
\
\   * &1200-&12FF   moves to &7900-&79FF in memory
\   * &1300-&14FF   moves to &0B00-&0CFF in memory
\   * &1500-&15da   moves to &7000-&70DA in memory
\   * &15DB-&16DB   contains workspace noise
\   * &16DC-&5A7F   stays put
\   * &5300-&5949   swaps with track data at &70DB-&7724 in memory
\   * &594A-&5A79   stays put
\   * &5A80-&645B   moves to &0D00-&16DB in memory
\   * &645C-&64CF   stays put (this just contains zeroes)
\   * &64D0-&6BFF   moves to &5FD0-&63FF in memory
\   * &6C00-&6FFF   stays put
\
\ and with the following for the track binary:
\
\   * &70DB-&7724   swaps with game data at &5300-&5949 in memory
\
\ The routines move, swap and reset various parts of the file, to give the
\ following in-memory layout for when the game is running:
\
\   * &0B00-&0CFF   moves from &1300-&14FF in the game binary
\   * &0D00-&16DB   moves from &5A80-&645B in the game binary
\   * &16DC-&52FF   stays put
\   * &5300-&5949   swaps with &70DB-&7724 in the track binary
\   * &594A-&5FCF   stays put
\   * &5FD0-&66FF   moves from &64D0-&6BFF in the game binary
\   * &6700-&6FFF   stays put
\   * &7000-&70DA   moves from &1500-&15DA in the game binary
\   * &70DB-&7724   swaps with &5300-&5949 in the game binary
\   * &7725-&78FF   not used
\   * &7900-&79FF   moves from &1200-&12FF in the game binary
\
\ For details on the workspace noise in the final game binary at &15DB-&16DB,
\ see the "Save Revs.bin" section at the end of this source file.

\ ******************************************************************************

.MoveCode

                        \ We are going to process the five memory blocks defined
                        \ in (blockStartHi blockStartLo)-(blockEndHi blockEndLo)
                        \
                        \ We will either zero the memory block (for the first
                        \ block in the table), or move the block to the address
                        \ in (blockToHi blockToLo)
                        \
                        \ We work through the blocks from the last entry to the
                        \ first, so we end up doing this:
                        \
                        \   * Move &1500-&15DA to &7000-&70DA
                        \   * Move &1300-&14FF to &0B00-&0CFF
                        \   * Move &5A80-&645B to &0D00-&16DB
                        \   * Move &64D0-&6BFF to &5FD0-&63FF
                        \   * Zero &5A80-&5E3F

 LDX #4                 \ Set a block counter in X to work through the five
                        \ memory blocks, starting with the block defined at
                        \ the end of the block tables

 LDY #0                 \ Set Y as a byte counter

.move1

 LDA blockStartLo,X     \ Set (Q P) to the X-th address from (blockStartHi
 STA P                  \ blockStartLo)
 LDA blockStartHi,X
 STA Q

 LDA blockToLo,X        \ Set (S R) to the X-th address from (blockToHi
 STA R                  \ blockToLo)
 LDA blockToHi,X
 STA S

.move2

 LDA (P),Y              \ Copy the Y-th byte of (Q P) to the Y-th byte of (S R)
 STA (R),Y              \
                        \ The LDA (P),Y instruction gets modified to LDA #0 for
                        \ the last block that we process, i.e. when X = 0

 INC P                  \ Increment the address in (Q P), starting with the low
                        \ byte

 BNE move3              \ Increment the high byte if we cross a page boundary
 INC Q

.move3

 INC R                  \ Increment the address in (S R), starting with the low
                        \ byte

 BNE move4              \ Increment the high byte if we cross a page boundary
 INC S

.move4

 LDA P                  \ If (Q P) <> (blockEndHi blockEndLo) then jump back to
 CMP blockEndLo,X       \ move2 to process the next byte in the block
 BNE move2
 LDA Q
 CMP blockEndHi,X
 BNE move2

 DEX                    \ We have finished processing a block, so decrement the
                        \ block counter in X to move on to the next block (i.e.
                        \ the previous entry in the table)

 BMI move5              \ If X < 0 then we have finished processing all five
                        \ blocks, so jump to move5

 BNE move1              \ If X <> 0, i.e. X > 0, then jump up to move1 to move
                        \ the next block

 LDA ldaZero            \ We get here when X = 0, which means we have reached
 STA move2              \ the last block to process (i.e. the first entry in the
 LDA ldaZero+1          \ block tables)
 STA move2+1            \
                        \ We don't want to copy this block, we want to zero it,
                        \ so we modify the instruction at move2 to LDA #0, so
                        \ the code zeroes the block rather than moving it

 JMP move1              \ Jump back to move1 to zero the final block

.move5

 JMP Protect            \ If we get here we have processed all the blocks in the
                        \ block tables, so jump to Protect to continue setting
                        \ up the game

\ ******************************************************************************
\
\       Name: ldaZero
\       Type: Variable
\   Category: Setup
\    Summary: Contains code that's used for modifying the MoveCode routine
\
\ ******************************************************************************

.ldaZero

 LDA #0                 \ The instruction at move2 in the MoveCode routine is
                        \ modified to this instruction so the routine zeroes a
                        \ block of memory rather than moving it

\ ******************************************************************************
\
\       Name: blockStartLo
\       Type: Variable
\   Category: Setup
\    Summary: Low byte of the start address of blocks moved by the MoveCode
\             routine
\
\ ******************************************************************************

.blockStartLo

 EQUB &80, &D0, &80, &00, &00

\ ******************************************************************************
\
\       Name: blockStartHi
\       Type: Variable
\   Category: Setup
\    Summary: High byte of the start address of blocks moved by the MoveCode
\             routine
\
\ ******************************************************************************

.blockStartHi

 EQUB &5A, &64, &5A, &13, &15

\ ******************************************************************************
\
\       Name: blockEndLo
\       Type: Variable
\   Category: Setup
\    Summary: Low byte of the end address of blocks moved by the MoveCode
\             routine
\
\ ******************************************************************************

.blockEndLo

 EQUB &40, &00, &5C, &00, &DB

\ ******************************************************************************
\
\       Name: blockEndHi
\       Type: Variable
\   Category: Setup
\    Summary: High byte of the end address of blocks moved by the MoveCode
\             routine
\
\ ******************************************************************************

.blockEndHi

 EQUB &5E, &6C, &64, &15, &15

\ ******************************************************************************
\
\       Name: blockToLo
\       Type: Variable
\   Category: Setup
\    Summary: Low byte of the destination address of blocks moved by the
\             MoveCode routine
\
\ ******************************************************************************

.blockToLo

 EQUB &80, &D0, &00, &00, &00

\ ******************************************************************************
\
\       Name: blockToHi
\       Type: Variable
\   Category: Setup
\    Summary: High byte of the destination address of blocks moved by the
\             MoveCode routine
\
\ ******************************************************************************

.blockToHi

 EQUB &5A, &5F, &0D, &0B, &70

 EQUB &09, &B9          \ These bytes appear to be unused
 EQUB &02, &50
 EQUB &9D, &01
 EQUB &09, &9D
 EQUB &79, &09
 EQUB &B9, &03
 EQUB &50, &9D
 EQUB &02, &09
 EQUB &B9, &01
 EQUB &51, &9D
 EQUB &00, &0A
 EQUB &B9, &02
 EQUB &51, &9D
 EQUB &01, &0A
 EQUB &9D, &79
 EQUB &0A, &B9
 EQUB &03, &51
 EQUB &9D, &02
 EQUB &0A, &B9
 EQUB &04, &50
 EQUB &9D, &78
 EQUB &09, &B9
 EQUB &06, &50
 EQUB &9D, &7A
 EQUB &09, &B9
 EQUB &04

\ ******************************************************************************
\
\       Name: soundEnvelopes
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

ORG &0B00

.soundEnvelopes

 EQUB &10, &10, &10, &10, &10, &10, &10, &10
 EQUB &10, &10, &10, &10, &10, &10, &10, &10
 EQUB &10, &00, &F6, &FF, &03, &00, &FF, &00
 EQUB &11, &00, &F6, &FF, &BB, &00, &FF, &00
 EQUB &12, &00, &F6, &FF, &28, &00, &FF, &00
 EQUB &13, &00, &01, &00, &82, &00, &FF, &00
 EQUB &10, &00, &F6, &FF, &06, &00, &04, &00
 EQUB &01, &01, &02, &FE, &FA, &04, &01, &01
 EQUB &0A, &00, &00, &00, &48, &00

\ ******************************************************************************
\
\       Name: L0B46
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L0B46

 EQUB &FF

\ ******************************************************************************
\
\       Name: sub_C0B47
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0B47

 LDY L05FE

\ ******************************************************************************
\
\       Name: sub_C0B4A
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0B4A

 STX L0B46
 ASL A
 ASL A
 ASL A
 CLC
 ADC #&10
 TAX
 TYA
 STA soundEnvelopes+2,X
 LDA soundEnvelopes,X
 AND #3
 TAY
 LDA #7
 STA L62BD,Y
 BNE C0B6E

\ ******************************************************************************
\
\       Name: sub_C0B65
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0B65

 STX L0B46
 CLC
 ADC #&38
 TAX
 LDA #8                 \ osword_envelope

.C0B6E

 LDY #&0B
 JSR OSWORD
 LDX L0B46
 RTS

\ ******************************************************************************
\
\       Name: sub_C0B77
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0B77

 LDX #1

.loop_C0B79

 LDA L5F3D,X
 ASL A
 ASL A
 STA U
 LDA L0BA0,X
 JSR sub_C0C00
 CLC
 ADC #&5A
 STA L62A8,X
 DEX
 BPL loop_C0B79
 LDA L5F3E
 ASL A
 ADC L5F3E
 ADC L5F3D
 LSR A
 ADC #&3C
 STA L62F1
 RTS

\ ******************************************************************************
\
\       Name: L0BA0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L0BA0

 EQUB &CD, &CD

\ ******************************************************************************
\
\       Name: sub_C0BA2
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C0BCC
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0BCC

 LDA L0900,Y
 CLC
 ADC T
 STA L0900,X
 LDA L0A00,Y
 ADC L0083
 STA L0A00,X
 LDA L0901,Y
 CLC
 ADC U
 STA L0901,X
 LDA L0A01,Y
 ADC L0084
 STA L0A01,X
 LDA L0902,Y
 CLC
 ADC V
 STA L0902,X
 LDA L0A02,Y
 ADC L0085
 STA L0A02,X
 RTS

\ ******************************************************************************
\
\       Name: sub_C0C00
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0C00

 STA T

\ ******************************************************************************
\
\       Name: sub_C0C02
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0C02

 LDA #0
 LSR T
 BCC C0C0B
 CLC
 ADC U

.C0C0B

 ROR A
 ROR T
 BCC C0C13
 CLC
 ADC U

.C0C13

 ROR A
 ROR T
 BCC C0C1B
 CLC
 ADC U

.C0C1B

 ROR A
 ROR T
 BCC C0C23
 CLC
 ADC U

.C0C23

 ROR A
 ROR T
 BCC C0C2B
 CLC
 ADC U

.C0C2B

 ROR A
 ROR T
 BCC C0C33
 CLC
 ADC U

.C0C33

 ROR A
 ROR T
 BCC C0C3B
 CLC
 ADC U

.C0C3B

 ROR A
 ROR T
 BCC C0C43
 CLC
 ADC U

.C0C43

 ROR A
 ROR T
 RTS

\ ******************************************************************************
\
\       Name: sub_C0C47
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0C47

 ASL T
 ROL A
 BCS C0C50
 CMP V
 BCC C0C53

.C0C50

 SBC V
 SEC

.C0C53

 ROL T
 ROL A
 BCS C0C5C
 CMP V
 BCC C0C5F

.C0C5C

 SBC V
 SEC

.C0C5F

 ROL T
 ROL A
 BCS C0C68
 CMP V
 BCC C0C6B

.C0C68

 SBC V
 SEC

.C0C6B

 ROL T
 ROL A
 BCS C0C74
 CMP V
 BCC C0C77

.C0C74

 SBC V
 SEC

.C0C77

 ROL T
 ROL A
 BCS C0C80
 CMP V
 BCC C0C83

.C0C80

 SBC V
 SEC

.C0C83

 ROL T
 ROL A
 BCS C0C8C
 CMP V
 BCC C0C8F

.C0C8C

 SBC V
 SEC

.C0C8F

 ROL T
 ROL A
 BCS C0C98
 CMP V
 BCC C0C9B

.C0C98

 SBC V
 SEC

.C0C9B

 ROL T
 ROL A
 BCS C0CA2
 CMP V

.C0CA2

 ROL T
 RTS

\ ******************************************************************************
\
\       Name: C0CA5
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.C0CA5

 LDA L007E
 CMP #&67
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
 STA T
 LDA L007A
 LSR T
 ROR A
 LSR T
 ROR A
 LSR T
 ROR A
 STA U
 LDA L0078
 CLC
 ADC L007A
 STA L007C
 LDA L0079
 ADC L007B
 STA L007D
 LDA L007C
 SEC
 SBC U
 STA L007C
 LDA L007D
 SBC T
 STA L007D
 RTS

 EQUB &F1, &0C, &E5, &74, &8D, &F6, &0C, &60
 EQUB &00, &00, &00, &00, &00, &00, &40

\ ******************************************************************************
\
\       Name: sub_C0D01
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0D01

 STA L007B
 STX T
 JSR sub_C0DB3
 STA L0078
 LDA U
 STA L0079
 LDX #1
 STX L0042
 LDX #0
 BIT L007B
 BVC C0D1B
 INX
 DEC L0042

.C0D1B

 CMP #&7A
 BCC C0D27
 BCS C0D4F
 LDA L0078
 CMP #&F0
 BCS C0D4F

.C0D27

 LDA #&AB
 JSR sub_C0C00
 JSR sub_C0C00
 STA V
 JSR sub_C0DBF
 LDA L0078
 SEC
 SBC T
 STA T
 LDA L0079
 SBC U
 ASL T
 ROL A
 STA L62A3,X
 LDA T
 AND #&FE
 STA L62A0,X
 JMP C0D7F

.C0D4F

 LDA #0
 SEC
 SBC L0078
 STA T
 LDA #&C9
 SBC L0079
 STA U
 STA V
 JSR sub_C0DBF
 ASL T
 ROL U
 LDA #0
 SEC
 SBC T
 AND #&FE
 STA L62A0,X
 LDA #0
 SBC U
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
 STA U
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

\ ******************************************************************************
\
\       Name: sub_C0DB3
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0DB3

 ASL T
 ROL A
 ASL T
 ROL A
 STA V
 LDA #&C9
 STA U

\ ******************************************************************************
\
\       Name: sub_C0DBF
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0DBF

 JSR sub_C0C02
 STA W
 LDA V
 JSR sub_C0C00
 STA U
 LDA W
 CLC
 ADC T
 STA T
 BCC C0DD6
 INC U

.C0DD6

 RTS

\ ******************************************************************************
\
\       Name: sub_C0DD7
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STA U
 LDA L0082
 JSR sub_C0C00
 STA W
 LDA T
 CLC
 ADC #&80
 STA V
 BCC C0E10
 INC W

.C0E10

 LDA L0083
 JSR sub_C0C00
 STA L0078
 LDA T
 CLC
 ADC W
 STA W
 BCC C0E22
 INC L0078

.C0E22

 LDA L0080
 STA U
 LDA L0083
 JSR sub_C0C00
 STA U
 LDA T
 CLC
 ADC V
 LDA U
 ADC W
 STA T
 BCC C0E3C
 INC L0078

.C0E3C

 LDA L0078
 BIT L0079

\ ******************************************************************************
\
\       Name: sub_C0E40
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0E40

 BPL C0E4F

\ ******************************************************************************
\
\       Name: sub_C0E42
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0E42

 STA U

\ ******************************************************************************
\
\       Name: sub_C0E44
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0E44

 LDA #0
 SEC
 SBC T
 STA T
 LDA #0
 SBC U

.C0E4F

 RTS

\ ******************************************************************************
\
\       Name: sub_C0E50
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0E50

 LDA #129               \ osbyte_inkey
 LDY #&FF
 JSR OSBYTE
 CPX #&FF
 RTS

\ ******************************************************************************
\
\       Name: sub_C0E5A
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0E5A

 PHA
 LDA L62BD,X
 BEQ C0E72
 LDA #0
 STA L62BD,X
 TXA
 ORA #4
 TAX
 LDA #21                \ osbyte_flush_buffer
 JSR OSBYTE
 TXA
 AND #&FB
 TAX

.C0E72

 PLA
 RTS

\ ******************************************************************************
\
\       Name: sub_C0E74
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0E74

 LDA L62A6
 ORA L62A7
 BPL C0E92
 LDA VIA+&68            \ user_via_t2c_l
 CMP #&3F
 BCS C0E92
 AND #3
 CLC
 ADC #&82
 STA soundEnvelopes+44
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
 SBC #&5C
 BCS C0EB8
 PHA
 LDA #0
 JSR sub_C0B47
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

 STA soundEnvelopes+28
 LDA #1
 JSR sub_C0B4A
 LDY L05FE
 BEQ C0EDB
 LDA L0060
 SEC
 SBC #&40
 BCS C0ED8
 LDY #0
 BEQ C0EDB

.C0ED8

 STA soundEnvelopes+36

.C0EDB

 LDA #2
 JSR sub_C0B4A

.C0EE0

 RTS

.C0EE1

 JSR sub_C43F6
 RTS

\ ******************************************************************************
\
\       Name: sub_C0EE5
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0EE5

 STY T
 LDX #&FF
 JSR sub_C0E50
 BNE C0F63
 LDY T

.loop_C0EF0

 STY T
 LDX L3DE2,Y
 JSR sub_C0E50
 BEQ C0F01
 LDY T
 DEY
 BPL loop_C0EF0
 BMI C0F11

.C0F01

 LDY T
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
 STA soundEnvelopes+68
 LDA #0
 JSR sub_C0B65
 INC L0060

.C0F5E

 LDA #0
 STA L05F6

.C0F63

 RTS

\ ******************************************************************************
\
\       Name: sub_C0F64
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0F64

 STA L0078
 SED

.C0F67

 LDX #0
 STX V
 STX L0100
 INX

.C0F6F

 STX W
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
 STA U
 LDA L06B8,Y
 SBC L06B8,X
 STA L0079
 LDA L06D0,Y
 SBC L06D0,X
 BCC C0FEC

.C0F9B

 ORA U
 ORA L0079
 BNE C0FAA
 LDX W
 DEX
 LDA L0100,X
 STA L0101,X

.C0FAA

 LDX W
 INX
 CPX #&14
 BCC C0F6F
 LDA V
 BNE C0F67
 CLD
 JSR sub_C63A2
 RTS

.C0FBA

 LDA setp1+2,X
 SBC setp1+2,Y
 STA U
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
 STA U
 LDA L08AC,Y
 SBC L08AC,X
 STA L0079
 LDA L04DC,Y
 SBC L04DC,X
 BCS C0FAA

.C0FEC

 STX T
 LDX W
 TYA
 STA L013B,X
 LDA T
 STA L013C,X
 DEC V
 JMP C0FAA

\ ******************************************************************************
\
\       Name: sub_C0FFE
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 LDY #&21
 JSR sub_C37D0
 PLP
 BPL C102A
 LDX #&35
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
 LDA #&21
 CLC
 ADC L62EF
 STA L62EF
 BEQ C104F
 LDA #&26
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
 LDA #&40
 STA L0065
 LDX #&29
 JSR sub_C4D74
 RTS

.C1089

 LDA L0065
 BMI C109A
 LDA #&C0
 STA L0065
 LDA #&3C
 STA L000F
 LDX #&2A
 JSR sub_C4D74

.C109A

 RTS

\ ******************************************************************************
\
\       Name: sub_C109B
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C109B

 STA V
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

 LDA V
 STA W

.loop_C10BB

 TXA
 PHA
 LDA L013C,X
 TAX
 JSR sub_C14C3
 PLA
 TAX
 DEC W
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
 CMP #&20
 BNE C10D7
 LDX #&17
 LDA #&31
 STA V
 STA L0042

.loop_C10F2

 JSR sub_C14C3
 DEC V
 BNE loop_C10F2

.loop_C10F9

 INC L0042
 JSR sub_C14C3
 BCC loop_C10F9
 LDA #&50
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

\ ******************************************************************************
\
\       Name: sub_C111E
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C111E

 LDA L0011
 CMP #2
 BCC C1162
 LDA L005E
 JSR sub_C3450
 CMP #&60
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
 JSR sub_C0B47
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

\ ******************************************************************************
\
\       Name: sub_C1163
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 AND #&40
 BNE C11A7
 LDA L006E
 CMP L04B4,X
 BCS C1171

.C11A7

 DEX
 BPL C1199

.C11AA

 RTS

\ ******************************************************************************
\
\       Name: sub_C11AB
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C11AB

 CPX #&14
 BCS C11CD
 LDA L0178,X
 AND #&7F
 ORA #&45
 STA L0114,X
 LDA #&91
 STA L0100,X

\ ******************************************************************************
\
\       Name: sub_C11BE
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C11BE

 LDA L006E
 CMP L04B4,X
 LDA #&C0
 STA L018C,X
 BCC C11CD
 STA L04DC,X

.C11CD

 RTS

\ ******************************************************************************
\
\       Name: sub_C11CE
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 CMP #&78
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

\ ******************************************************************************
\
\       Name: sub_C1208
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1208

 LDA trackData+1537,Y
 STA L0900,X
 LDA trackData+1538,Y
 STA L0901,X
 LDA trackData+1539,Y
 STA L0902,X
 LDA trackData+1,Y
 STA L0A00,X
 LDA trackData+2,Y
 STA L0A01,X
 LDA trackData+3,Y
 STA L0A02,X
 RTS

\ ******************************************************************************
\
\       Name: sub_C122D
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C122D

 JSR sub_C1208
 LDA trackData+1540,Y
 STA L0978,X
 LDA trackData+1542,Y
 STA L097A,X
 LDA trackData+4,Y
 STA L0A78,X
 LDA trackData+6,Y
 STA L0A7A,X
 LDA trackData+1541,Y
 STA L0002

\ ******************************************************************************
\
\       Name: sub_C124D
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C124D

 LDA L0901,X
 STA L0979,X
 LDA L0A01,X
 STA L0A79,X
 RTS

\ ******************************************************************************
\
\       Name: sub_C125A
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C125A

 LDA L0024
 SEC
 SBC #&60
 BPL C1264
 CLC
 ADC #&78

.C1264

 STA L0022
 RTS

\ ******************************************************************************
\
\       Name: sub_C1267
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 LDA trackData,Y
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
 LDA trackData+1536,Y
 STA L0001
 LDA #0
 STA L0702,X
 RTS

\ ******************************************************************************
\
\       Name: sub_C12A0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C12A0

 LDX #&2C

.loop_C12A2

 LDA L5E40,X
 STA L5E41,X
 LDA L5E90,X
 STA L5E91,X
 LDA L5F20,X
 STA L5F21,X
 CPX #&28
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

\ ******************************************************************************
\
\       Name: sub_C12C8
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C12DC
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C12F3
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C12F3

 CLC
 JSR sub_C1433

\ ******************************************************************************
\
\       Name: sub_C12F7
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C12F7

 LDA L0024
 STA L0023
 CLC
 ADC #3
 CMP #&78
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

 STA W
 LDY L06FF
 LDA trackData+1543,Y
 PLP
 BCC C1365
 LSR A
 TAY
 LDA W
 CPY L0897
 BEQ C137C
 BNE C1378

.C1365

 SEC
 SBC L0897
 TAY
 LDA W
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
 LDA trackData+1024,Y
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
 LDA trackData+1280,Y
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

\ ******************************************************************************
\
\       Name: sub_C13DA
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C13DA

 LDA L0001
 AND #1
 BEQ C13FA

\ ******************************************************************************
\
\       Name: sub_C13E0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C13FB
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C13FB

 LDA #6
 STA L0006
 LDX #&40
 STX L001A
 JSR sub_C1420
 LDA #0
 STA L001A
 RTS

\ ******************************************************************************
\
\       Name: sub_C140B
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C140B

 SEC
 JSR sub_C1433
 LDX #&28
 STX L0062
 JSR sub_C1420
 LDX #&27
 JSR sub_C1420
 LDA #0
 STA L0062
 RTS

\ ******************************************************************************
\
\       Name: sub_C1420
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C1433
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C1442
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1442

 LDA #0
 STA L0083
 STA L0084
 STA L0085
 LDA trackData+256,Y
 STA T
 BPL C1453
 DEC L0083

.C1453

 LDA trackData+512,Y
 STA U
 BPL C145C
 DEC L0084

.C145C

 LDA trackData+768,Y
 STA V
 BPL C1465
 DEC L0085

.C1465

 LDA L0025
 BEQ C147B
 LDX #2

.loop_C146B

 LDA #0
 SEC
 SBC T,X
 STA T,X
 LDA #0
 SBC L0083,X
 STA L0083,X
 DEX
 BPL loop_C146B

.C147B

 RTS

\ ******************************************************************************
\
\       Name: sub_C147C
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C147C

 LDY L06E8,X
 LDA L0880,X
 CLC
 ADC #1
 CMP trackData+1543,Y
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

\ ******************************************************************************
\
\       Name: sub_C14C3
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 LDA trackData+1543,Y
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

\ ******************************************************************************
\
\       Name: sub_C150E
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 CMP trackData+5,Y
 BCS C1532

.C1527

 LDA L5FB0,X
 ORA #&40
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

 LDA trackData+1536,Y
 AND #1
 BEQ C1527
 LDA trackData+5,Y
 STA L0017
 BEQ C1527
 LDA trackData+7,Y
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
 STA T
 LDA L0017
 SEC
 SBC L0018
 BCS C156D
 ADC T
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

\ ******************************************************************************
\
\       Name: sub_C1579
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1579

 LDA #0
 STA V
 STA T
 STA L0058
 LDX #&9D
 JSR sub_C0E50
 PHP
 BIT L05F5
 BPL C15B3
 LDX #1
 JSR sub_C503F
 STA U
 JSR sub_C0C00
 PLP
 BEQ C159F
 LSR A
 ROR T
 LSR A
 ROR T

.C159F

 STA U
 LDA T
 AND #&FE
 STA T
 TXA
 ORA T
 STA T
 LDA U
 JMP C1EE9

 EQUB &EA, &EA

.C15B3

 LDX #&A9
 JSR sub_C0E50
 BNE C15BE
 LDA #2
 STA V

.C15BE

 LDX #&A8
 JSR sub_C0E50
 BNE C15C7
 INC V

.C15C7

 LDA #3
 STA U
 PLP
 BEQ C15DF
 LDA #0
 LDX #2
 CPX L62A5
 BCC C15D9
 LDA #1

.C15D9

 STA U
 LDA #&80
 STA T

.C15DF

 LDA V
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
 STA T
 LDA L62EA
 JSR sub_C0E40
 LSR A
 ROR T
 LSR A
 ROR T
 CMP L62A5
 JSR sub_C1F9B

.C160D

 STA U

.C160F

 JMP C1EFA

.C1612

 SEC
 SBC T
 STA T
 LDA L62A5
 SBC U
 CMP #&C8
 BCC C162D
 JSR sub_C0E42
 STA U
 LDA T
 EOR #1
 STA T
 LDA U

.C162D

 CMP #&91
 BCC C1633
 LDA #&91

.C1633

 STA L62A5
 LDA T
 STA L62A2

.C163B

 LDA L000F
 BNE C1678
 BIT L05F5
 BPL C165E
 LDX #2
 JSR sub_C503F
 BCC C1678
 STA T
 LSR T
 ASL A
 ADC T
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
 LDA #128               \ osbyte_read_adc_or_get_buffer_status
 JSR OSBYTE
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

\ ******************************************************************************
\
\       Name: sub_C16DC
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C16DC

 JSR sub_C4DDD
 LDA #0
 STA printMode
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
 LDX #&30
 JSR sub_C17FC
 JSR sub_C1163
 LDA L05F4
 BMI C17BA
 LDA #&20
 STA L05F4
 BNE C17BA

.C178F

 LDY #&0B
 JSR sub_C0EE5
 LDA L05F4
 BEQ C17A8
 BPL C1773
 AND #&40
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

\ ******************************************************************************
\
\       Name: sub_C17C3
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 CMP #&60
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

\ ******************************************************************************
\
\       Name: sub_C17FC
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C17FC

 JSR sub_C4D70
 LDX #&2D
 JSR sub_C4D74
 RTS

\ ******************************************************************************
\
\       Name: sub_C1805
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1805

 LDA #0
 LDX #&68

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
 STA SetupGame,X
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
 LDX #&28
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
 LDX #&2B
 JSR sub_C4D74
 LDX #&2C
 JSR sub_C4D70
 LDA L0003
 JSR sub_C65C8
 STA L002F
 RTS

\ ******************************************************************************
\
\       Name: sub_C18BC
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 LDA #&20
 BNE C18D6

.C18D4

 LDA #&23

.C18D6

 STA L5F60,Y
 LDA #&21
 LDY #&4F

.loop_C18DD

 LDX L5F60,Y
 BEQ C18E3
 TXA

.C18E3

 STA L5F60,Y
 DEY
 BPL loop_C18DD
 RTS

\ ******************************************************************************
\
\       Name: sub_C18EA
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C18EA

 STA T
 LDX #3

.loop_C18EE

 LDA L192F,X
 STA P,X
 DEX
 BPL loop_C18EE
 LDX #0

.C18F8

 LDY #&4F
 LDA #0
 STA V

.loop_C18FE

 BIT T
 BMI C1906
 LDA (P),Y
 STA (R),Y

.C1906

 LDA (R),Y
 STA (P),Y
 INC V
 DEY
 TYA
 CMP L3900,X
 BNE loop_C18FE
 LDA R
 SEC
 SBC V
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
 CPX #&29
 BNE C18F8
 RTS

\ ******************************************************************************
\
\       Name: L192F
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L192F

 EQUB &00, &30, &B0, &7F

\ ******************************************************************************
\
\       Name: sub_C1933
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1933

 LDA L5E90,X
 CLC
 ADC #&14
 CMP #&28
 ROR V
 RTS

\ ******************************************************************************
\
\       Name: sub_C193E
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C193E

 STA loop_C196F+1
 STY L004B
 DEY
 STY U
 JSR sub_C1933
 LDY L001F
 JMP C1977

.C194E

 LDA V
 BPL C1955
 JSR sub_C1933

.C1955

 LDA L5F20,X
 CMP #&50
 BCS C1980
 BIT V
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
 CPX U
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
 CPX U
 BCC loop_C1998

.C19A2

 STX L0050
 RTS

.C19A5

 LDA #&80
 ORA L5EE0,X
 STA L5EE0,X
 BMI C1979

\ ******************************************************************************
\
\       Name: sub_C19AF
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C19AF

 STY L0027
 STA L004C
 CMP L004B
 BCS C1A1F
 CLC
 ADC L30FC,Y
 STA L004F
 LDA L2B1E,Y
 STA sub_C2F4E+2
 STA sub_C2F90+2
 LDA L2B22,Y
 STA sub_C2F4E+1
 STA sub_C2F90+1
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

\ ******************************************************************************
\
\       Name: sub_C1A20
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1A20

 LDA #&80
 STA P
 LDA L0051
 CLC
 ADC #&28
 TAX
 CMP #&31
 BCS C1A30
 LDA #&31

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
 ADC #&28
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
 LDA #&50
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

\ ******************************************************************************
\
\       Name: sub_C1A98
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1A98

 STX L0088
 STA U
 DEC L004B
 LDA L62F2
 CMP #&28
 BCC C1B05
 BCS C1B0B

.C1AA7

 LDY L5F20,X
 CPY #&50
 BCS C1B03
 LDA L5EE0,X
 BMI C1B03
 LDA L0088
 CMP #&14
 BEQ C1AC4
 LDA L5EA0,X
 STA W
 LDA L5E90,X
 JMP C1ACC

.C1AC4

 LDA L5E90,X
 STA W
 LDA L5EA0,X

.C1ACC

 CLC
 ADC #&14
 BMI C1B03
 LDA W
 CLC
 ADC #&14
 BPL C1B03

.loop_C1AD8

 LDA L5EE1,X
 BPL C1AE4
 INX
 INC U
 CPX L004B
 BCC loop_C1AD8

.C1AE4

 LDA L5F60,Y
 STA T
 LDA L5F60,Y
 BEQ C1AF9
 AND #&1C
 CMP L0088
 BEQ C1AF9
 ROR A
 EOR T
 BMI C1B03

.C1AF9

 LDA L5EE0,X
 AND #3
 ORA L0088
 STA L5F60,Y

.C1B03

 INC U

.C1B05

 LDX U
 CPX L004B
 BCC C1AA7

.C1B0B

 LDX L0050
 LDY L5F20,X
 INY
 RTS

\ ******************************************************************************
\
\       Name: sub_C1B12
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1B12

 LDY #0

.C1B14

 CPY L0057
 BEQ C1B7F
 LDX L62B4,Y
 STY L0056
 LDA L6299,Y
 AND #&20
 BEQ C1B29
 LDA #&0F
 STA L38FE

.C1B29

 LDA L62BA,Y
 STA U
 LDA L62B7,Y
 ASL A
 ROL U
 STA T
 CLC
 ADC L5E40,X
 STA V
 LDA L5E90,X
 ADC U
 CMP #&18
 BCC C1B49
 CMP #&E8
 BCC C1B74

.C1B49

 ASL V
 ROL A
 ASL V
 ROL A
 CLC
 ADC #&50
 STA L0035
 LDA L5F20,X
 STA L0036
 LDY #2

.loop_C1B5B

 ASL T
 ROL U
 DEY
 BNE loop_C1B5B
 LDA U
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

\ ******************************************************************************
\
\       Name: sub_C1B84
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1B84

 LDA L002F
 BEQ C1BA2
 SED
 CLC
 ADC L0031
 STA L0031
 CLD
 BEQ C1BA2
 CMP #&21
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
 LDA #&21
 JSR sub_C6673

.C1BB5

 LSR L62FE
 RTS

\ ******************************************************************************
\
\       Name: sub_C1BB9
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1BB9

 LDA L0068
 BEQ C1C1B
 LDA #0
 STA L0068
 SEC
 ROR V
 LDA #&25
 SEC
 SBC L0041
 BCS C1BCD
 LDA #5

.C1BCD

 ASL A
 STA U
 LDX L0067
 LDY L006F
 CMP #&28
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
 JSR sub_C0B47

.C1C1B

 RTS

\ ******************************************************************************
\
\       Name: sub_C1C1C
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STA V
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
 ROL T
 LSR A
 ROR P
 CLC
 ADC #&30
 STA Q
 LDX L0085
 CPX #&28
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
 EOR T
 AND #1
 BEQ C1CC3
 LDA L0084
 AND #3
 TAX
 LDA L628F,X
 STA V

.C1CC3

 LDA L007E
 AND #3
 TAX
 LDA L3FE8,X
 EOR #&FF
 AND V
 STA V
 CPY #1
 BCS C1D15
 LDA L337C,X
 AND L0078
 STA T
 LDA L0079
 AND L33FC,X
 ORA T
 AND L3FE8,X
 ORA V
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
 LDA #&55

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
 ORA V

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
 ORA V

.C1D44

 STA L007A
 LDA #0
 STA L008C
 LDY L007F
 JMP C1D6B

.loop_C1D4F

 LDA (P),Y
 BEQ C1D5D
 CMP #&55
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

 LDA #&55

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
 CMP #&28
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
 CMP #&28
 BCS C1D93
 LDA #&28
 STA L0085
 BNE C1D86

\ ******************************************************************************
\
\       Name: sub_C1DA6
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1DA6

 STX C1DDD+1
 STY sub_C1DD4+1
 STA sub_C1DDB+1

\ ******************************************************************************
\
\       Name: sub_C1DAF
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1DAF

 LDA L0085
 CMP #&28
 BCS C1DE4
 CLC
 ADC #&60
 LSR A
 STA Q
 LDA #0
 ROR A
 STA P
 LDY L007F
 JMP C1DE0

 EQUB &C9, &55, &D0, &02, &A9, &00, &91, &72, &88, &C4, &82, &F0
 EQUB &12

.loop_C1DD2

 LDA (P),Y

\ ******************************************************************************
\
\       Name: sub_C1DD4
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1DD4

 BNE C1DDF
 JSR sub_C1E9E
 BNE C1DDD

\ ******************************************************************************
\
\       Name: sub_C1DDB
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1DDB

 LDA #&55

.C1DDD

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

\ ******************************************************************************
\
\       Name: sub_C1DEF
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1DEF

 STA L0042

.C1DF1

 STX L0085
 STY L007F
 LDA L3900,X
 STA L0082
 LDX #&72
 LDY #&EF
 LDA #0
 JSR sub_C1DA6
 LDX #&70
 LDY #9
 LDA #&55
 INC L0085
 JSR sub_C1DA6
 LDX L0085
 CPX L0042
 BNE C1DF1
 RTS

\ ******************************************************************************
\
\       Name: sub_C1E15
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1E15

 LDA #5
 STA S
 LDA #4
 STA R
 LDY #&1B
 LDX #3
 LDA #6
 JSR sub_C1DEF
 LDA #&44
 STA S
 LDA #0
 STA R
 LDY #&2B
 LDX #&1A
 LDA #&22
 JSR sub_C1DEF
 RTS

\ ******************************************************************************
\
\       Name: sub_C1E38
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1E38

 LDA L0078
 BNE C1E3E
 LDA #&55

.C1E3E

 STA V
 LDA #&7F
 SEC
 SBC L007F
 STA T
 ADC L0047
 STA L0086
 LDA L0085
 STA U
 CLC
 ADC #&5F
 LSR A
 STA Q
 STA S
 LDA #0
 ROR A
 SEC
 SBC T
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

 LDY U
 LDA L3F4F,Y
 DEY
 DEY
 STY U
 CMP L0047
 BCC C1E84
 ADC T
 TAY
 BPL C1E86
 CPX #2
 BCS C1E93
 RTS

.C1E84

 LDY L0086

.C1E86

 LDA V
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

\ ******************************************************************************
\
\       Name: sub_C1E9E
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: C1EE9
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 LDA V
 BNE C1F11

.C1F05

 JMP C1F95

.C1F08

 LDA T
 EOR #1
 LSR A
 LDA #3
 SBC #0

.C1F11

 LDX #&32
 CMP #2
 BEQ C1F19
 LDX #&0A

.C1F19

 LDA L62A2
 STA V
 LSR A
 LDA L62A5
 BCC C1F30
 LDA #0
 SEC
 SBC V
 STA V
 LDA #0
 SBC L62A5

.C1F30

 CLC
 ADC #1
 CPX #&32
 BNE C1F39
 SBC #2

.C1F39

 STA W
 LDA L5E40,X
 SEC
 SBC V
 STA T
 LDA L5E90,X
 SBC W
 PHP
 JSR sub_C0E40
 STA V
 LDY L0022
 LDA #&3C
 SEC
 SBC L0063
 BPL C1F59
 LDA #0

.C1F59

 ASL A
 ADC #&20
 STA U
 LDA L0701,Y
 AND #&7F
 CMP #&40
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
 CMP U
 BCC C1F79
 STA U

.C1F79

 JSR sub_C0DBF
 LDA U
 PLP
 JSR sub_C0E40
 STA U
 LDA T
 AND #&FE
 STA T
 LDA L62A2
 LSR A
 BCS C1F95
 JSR sub_C0E44
 STA U

.C1F95

 LDA L62A2
 JMP C1612

\ ******************************************************************************
\
\       Name: sub_C1F9B
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1F9B

 BCC C1FA7
 LDA L62A2
 AND #&FE
 STA T
 LDA L62A5

.C1FA7

 RTS

\ ******************************************************************************
\
\       Name: sub_C1FA8
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1FA8

 BCC C1FAF
 LDA L0880,X
 CMP #3

.C1FAF

 ROR L62FB
 RTS

 EQUB &EA

\ ******************************************************************************
\
\       Name: sub_C1FB4
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C1FB4

 STX T
 LDX #3

.loop_C1FB8

 LDA L38FC,X
 STA L628F,X
 DEX
 BPL loop_C1FB8
 LDA #&F0
 STA L38FE
 LDA T
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
 CMP #&40
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

\ ******************************************************************************
\
\       Name: sub_C202A
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STX W

.C2049

 LDA L4480,Y
 BPL C2072
 AND #7
 TAX
 LDA L5FF8,X
 STA T
 LDA L4480,Y
 STA U
 LSR A
 LSR A
 LSR A
 AND #7
 TAX
 LDA L5FF8,X
 CLC
 ADC T
 BIT U
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

 LDX W
 STA L5EF8,X
 EOR #&FF
 BPL C2098
 CLC
 ADC #1
 STA L5F00,X
 INC W
 INY
 CPY L008A
 BNE C2049
 CLC
 RTS

.C2098

 SEC
 RTS

\ ******************************************************************************
\
\       Name: sub_C209A
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 CMP #&50
 BCC C20B8
 LDA #&4F

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

 AND #&40
 BNE C2106
 INY

.C210C

 LDA L3750,Y
 BMI loop_C2107
 AND #&40
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

\ ******************************************************************************
\
\       Name: sub_C2145
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2145

 LDY #0

\ ******************************************************************************
\
\       Name: sub_C2147
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STA V
 LDA L0082
 STA T
 LDA L0085
 CMP V
 BEQ C220D
 JSR sub_C0C47
 LDA #0
 STA L008A
 LDY T
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

 LDA #&40
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
 LDA #&60
 STA L008B
 RTS

.C2230

 LDA #&20
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
 STA V
 LDA L0080
 STA T
 LDA L0083
 CMP V
 BEQ C220D
 JSR sub_C0C47
 LDA #0
 STA L008A
 LDY T
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

\ ******************************************************************************
\
\       Name: sub_C2285
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2285

 LDY #0

\ ******************************************************************************
\
\       Name: sub_C2287
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STA V
 STY L002B
 TAY
 LDA L6180,Y
 STA L002A
 LDA L0081
 STA T
 LDA L0084
 JSR sub_C0C47
 LDA T
 CMP #&80
 BCS C22FE
 BIT L0087
 BPL C22F5
 LDA #&3C
 SEC
 SBC T
 JMP C22F8

.C22F5

 CLC
 ADC #&3C

.C22F8

 SEC
 SBC L000D
 STA L008D
 CLC

.C22FE

 RTS

\ ******************************************************************************
\
\       Name: sub_C22FF
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STY T
 TYA
 CLC
 ADC #&28
 TAY
 JSR sub_C0BA2
 LDY T
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
 STA T
 LDA L06FF
 CLC
 ADC #8
 SEC
 SBC T
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
 EOR #&28
 TAY

.C2374

 JSR sub_C23C0
 LDX L0042
 CPX #&28
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
 ADC #&28
 CMP #&3C
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

\ ******************************************************************************
\
\       Name: sub_C23BB
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C23BB

 JSR sub_C2145
 LDY L0012

\ ******************************************************************************
\
\       Name: sub_C23C0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C23C0

 LDA L008A
 SEC
 SBC L000A
 STA L5E40,Y
 LDA L008B
 SBC L000B
 STA L5E90,Y
 JMP C0CA5

\ ******************************************************************************
\
\       Name: sub_C23D2
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STA U
 LDY L0014
 STX W

.C2410

 LDA L0900,X
 SEC
 SBC L0900,Y
 STA T
 LDA L0A00,X
 SBC L0A00,Y
 CLC
 BPL C2423
 SEC

.C2423

 PHP
 ROR A
 ROR T
 PLP
 ROR A
 ROR T
 STA V
 LDX U
 LDA L0900,Y
 CLC
 ADC T
 STA L09FA,X
 LDA L0A00,Y
 ADC V
 STA L0AFA,X
 INX
 CPX #3
 BEQ C2450
 STX U
 LDX W
 INY
 INX
 STX W
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
 STA T
 TXA
 SEC
 SBC L000E
 CMP T
 BCS C24B0
 TXA
 CLC
 ADC #&78
 JMP C24B1

.C24B0

 TXA

.C24B1

 SEC
 SBC T
 TAX
 JMP C23D8

.C24B8

 RTS

\ ******************************************************************************
\
\       Name: sub_C24B9
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C24F6
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 LDA #&2E
 JSR sub_C23D2
 LDA L0051
 CMP #&28
 BCC C2528
 SEC
 SBC #&28
 STA L0051

.C2528

 TAY
 STY L0052
 LDA L001F
 CMP #&4F
 BCC C2535
 LDA #&4E
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

\ ******************************************************************************
\
\       Name: sub_C254A
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C254A

 LDX L0024
 EOR L0025
 BPL C255A
 TXA
 CLC
 ADC #&78
 TAX
 LDA #&78
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

\ ******************************************************************************
\
\       Name: sub_C2565
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2565

 LDY L0049
 CPX #&78
 BCS C2570
 LDA L0702,X
 BCC C2573

.C2570

 LDA L068A,X

.C2573

 AND L306C,Y
 STA W
 AND #7
 TAY
 LDA L306E,Y
 STA V
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
 STA U
 LDA L002A
 DEY
 BEQ C25A9
 BPL C25A3

.loop_C259B

 LSR U
 ROR A
 INY
 BNE loop_C259B
 BEQ C25A9

.C25A3

 ASL A
 ROL U
 DEY
 BNE C25A3

.C25A9

 STA T
 LDA L0049
 LSR A
 ROR A
 EOR L0025
 BPL C25C0
 LDA #0
 SEC
 SBC T
 STA T
 LDA #0
 SBC U
 STA U

.C25C0

 LDY L0012
 LDA L5E40,Y
 CLC
 ADC T
 STA L5E50,Y
 LDA L5E90,Y
 ADC U
 STA L5EA0,Y
 LDA W
 AND #&18
 BEQ C25FD
 LDY L0057
 CPY #3
 BCS C25FD
 LDA L0012
 STA L62B4,Y
 LDA W
 STA L6299,Y
 AND #1
 BEQ C25F1
 LSR U
 ROR T

.C25F1

 LDA T
 STA L62B7,Y
 LDA U
 STA L62BA,Y
 INC L0057

.C25FD

 TXA
 AND #1
 BEQ C2606
 LDA #2
 BNE C2608

.C2606

 LDA V

.C2608

 LDY L0012
 STA L5EE0,Y
 LDA L008D
 STA L5F20,Y
 CMP #&50
 BCS C261E
 CMP L001F
 BCC C261E
 STA L001F
 STY L0051

.C261E

 RTS

\ ******************************************************************************
\
\       Name: sub_C261F
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C261F

 LDX #&16

.loop_C2621

 LDA L018C,X
 ORA #&80
 STA L018C,X
 DEX
 BPL loop_C2621
 RTS

\ ******************************************************************************
\
\       Name: loop_C262D
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.loop_C262D

 LDX #6

.C262F

 DEC T
 BNE C262F
 DEX
 BNE C262F
 RTS

\ ******************************************************************************
\
\       Name: sub_C2637
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C267F
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C267F

 LDA L013C,X
 STA T
 LDA L013C,Y
 STA L013C,X
 TAX
 LDA T
 STA L013C,Y
 TAY
 RTS

\ ******************************************************************************
\
\       Name: sub_C2692
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2692

 LDX L0003

.C2694

 STX W
 LDA L013C,X
 STA T
 JSR sub_C507E
 LDA L013C,X
 STX L0078
 TAY
 LDX T
 LDA #0
 STA L007F
 STA L0114,X
 JSR sub_C27A4
 BCS C26E6
 BPL C26E9
 CMP #&F6
 BCC C26E6
 LDX W
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

 STA T
 LDA L04B4,Y
 ROL L0079
 SBC L04B4,X
 BNE C26E6
 SED
 CLC
 LDA T
 ADC L002F
 STA L002F
 CLD

.C26E6

 JMP C278C

.C26E9

 CMP #5
 BCS C26E6
 LDA SetupGame,X
 CLC
 SBC SetupGame,Y
 LDA L0150,X
 SBC L0150,Y
 ROR V
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
 LDA T
 CMP #4
 LDA L0100,Y
 AND #&40
 BEQ C2729
 BCS C271C
 ORA #&80

.C271C

 STA L007F
 LDA L0178,X
 CMP L0178,Y
 ROR T
 JMP C277D

.C2729

 BCS C2742
 LDA #&40
 STA L007F
 LDA L0178,Y
 CMP L0178,X
 ROR T
 AND #&FF
 JSR sub_C3450
 CMP #&3C
 BCC C2744
 BCS C2749

.C2742

 LSR V

.C2744

 LDA L0178,Y
 STA T

.C2749

 LDA L018C,X
 BPL C275E
 LDA VIA+&68            \ user_via_t2c_l
 AND #&1F
 BNE C278C
 LDA V
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

 CMP #&64
 BCS C278C
 CMP #&50
 BCS C2786
 CMP #&3C
 BCS C277D
 LDA V
 AND #&80
 ORA L007F
 STA L007F

.C277D

 LDA T
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

 LDX W
 JSR sub_C5084
 CPX L0003
 BEQ C27A3
 JMP C2694

.C27A3

 RTS

\ ******************************************************************************
\
\       Name: sub_C27A4
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C27A4

 LDA L0164,Y
 SEC
 SBC L0164,X

\ ******************************************************************************
\
\       Name: sub_C27AB
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C27AB

 LDA L08D0,Y
 SBC L08D0,X
 STA T
 LDA L08E8,Y
 SBC L08E8,X
 PHP
 BPL C27BF
 JSR sub_C0E40

.C27BF

 STA U
 SEC
 BEQ C27D8
 PLA
 EOR #&80
 PHP
 LDA L59FC
 SEC
 SBC T
 STA T
 LDA L59FD
 SBC U
 BNE C27EA
 CLC

.C27D8

 ROR L0079
 LDA T
 CMP #&80
 BCS C27EA
 PLP
 JSR sub_C3450
 STA T
 LDA T
 CLC
 RTS

.C27EA

 PLP
 SEC

.loop_C27EC

 RTS

\ ******************************************************************************
\
\       Name: sub_C27ED
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C27ED

 LDA L006D
 BMI loop_C27EC
 LDX #&14
 JMP C28E7

.C27F6

 LDA L0100,X
 BMI C285B
 LDY L06E8,X
 LDA trackData+1536,Y
 BPL C280D
 LDA L0150,X
 CMP L01A4,X
 BCS C287F
 BCC C282F

.C280D

 LSR A
 BCS C282F
 LDA trackData+7,Y
 STA L01A4,X
 CLC
 SBC L0150,X
 BCS C282F
 LSR A
 LSR A
 ORA #&C0
 STA T
 LDA L0880,X
 SEC
 SBC trackData+5,Y
 BCS C287F
 CMP T
 BCS C285B

.C282F

 LDA L0150,X
 CMP #&3C
 BCS C2838
 LDA #&16

.C2838

 STA T
 LDA L0100,X
 AND #&40
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
 SBC T
 BCS C2856
 DEY

.C2856

 STY U
 JMP C2861

.C285B

 LDA #&FF
 STA U
 LDA #0

.C2861

 ASL A
 ROL U
 ASL A
 ROL U
 CLC
 ADC SetupGame,X
 STA SetupGame,X
 LDA U
 ADC L0150,X
 CMP #&BE
 BCC C287C
 LDA #0
 STA SetupGame,X

.C287C

 STA L0150,X

.C287F

 LDA #1
 STA V

.loop_C2883

 LDA L0150,X
 CLC
 ADC L0164,X
 STA L0164,X
 BCC C2892
 JSR sub_C147C

.C2892

 DEC V
 BPL loop_C2883
 LDA L018C,X
 ASL A
 BCS C28E7
 BMI C28CE
 LDA L0114,X
 AND #&40
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

\ ******************************************************************************
\
\       Name: sub_C28F2
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 LDA T
 JSR sub_C3450
 STA T
 CMP #&28
 BCC C2914

.C2911

 JMP C2AA6

.C2914

 ASL A
 CLC
 ADC T
 EOR #&FF
 SEC
 ADC L0024
 BPL C2922
 CLC
 ADC #&78

.C2922

 TAY
 LDA L0100,X
 AND #&10
 BNE C2937
 LDA L0150,X
 CMP #&32
 BCC C2937
 LDA L0701,Y
 STA L0114,X

.C2937

 LDA L0700,Y
 STA L000C
 STY T
 TAY
 LDA L0164,X
 STA L0084
 LDA L0178,X
 STA L0085
 LDA trackData+256,Y
 STA L0086
 LDA trackData+512,Y
 STA L0087
 LDA trackData+768,Y
 STA L0088
 LDX #0
 LDA L0084
 STA U
 LDY T

.C2960

 LDA #0
 STA V
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
 DEC V
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
 ADC V
 STA L0AFD,X
 INY
 INX
 CPX #3
 BNE C2960
 LDY L000C
 LDA trackData+1024,Y
 STA L0086
 LDA trackData+1280,Y
 STA L0088
 LDX #0
 LDA L0085
 STA U

.C29AD

 LDA #0
 STA V
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
 DEC V
 BCC C29CB

.C29C8

 JSR sub_C0C00

.C29CB

 ASL A
 ROL V
 ASL A
 ROL V
 CLC
 ADC L09FD,X
 STA L09FD,X
 LDA L0AFD,X
 ADC V
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

\ ******************************************************************************
\
\       Name: sub_C2A5D
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2A5D

 LDX #&FD

\ ******************************************************************************
\
\       Name: sub_C2A5F
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C2A76
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 AND #&70
 ORA L0037
 JMP C2AAD

.C2AA6

 LDY L0042
 LDA L018C,Y
 ORA #&80

.C2AAD

 STA L018C,Y
 RTS

\ ******************************************************************************
\
\       Name: sub_C2AB1
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2AB1

 LDY #&25

\ ******************************************************************************
\
\       Name: sub_C2AB3
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C2ACB
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2ACB

 STX L0045
 LDA L013C,X
 TAX

\ ******************************************************************************
\
\       Name: sub_C2AD1
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2AD1

 LDA L018C,X
 BMI C2B0B
 AND #&0F
 STA L0037
 LDA L0380,X
 SEC
 SBC L000A
 STA T
 LDA L0398,X
 SBC L000B
 BPL C2AEF
 CMP #&E0
 BCC C2B0B
 BCS C2AF3

.C2AEF

 CMP #&20
 BCS C2B0B

.C2AF3

 ASL T
 ROL A
 ASL T
 ROL A
 CLC
 ADC #&50
 STA L0035
 LDA L03B0,X
 STA L0036
 LDA L03C8,X
 STA L002A
 JSR sub_C1FB4

.C2B0B

 LDX L0045
 RTS

\ ******************************************************************************
\
\       Name: sub_C2B0E
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2B0E

 LDX #2

.loop_C2B10

 LDA L0083,X
 CLC
 BPL C2B16
 SEC

.C2B16

 ROR L0083,X
 ROR T,X
 DEX
 BPL loop_C2B10
 RTS

\ ******************************************************************************
\
\       Name: L2B1E
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L2B1E

 EQUB 5, 6, 6, 5

\ ******************************************************************************
\
\       Name: L2B22
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L2B22

 EQUB &A4, &50, &00, &54

\ ******************************************************************************
\
\       Name: sub_C2B26
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2B26

 PHP
 STA L0054
 LDA #0
 STA L001E
 LDA L5F20,Y
 SEC
 SBC #1
 CMP #&4E
 BCS C2B40
 LDA L5E90,X
 BPL C2B3E
 EOR #&FF

.C2B3E

 CMP #&14

.C2B40

 ROR L0088
 LDA L5E90,X
 STA W
 LDA L5E40,X
 ASL A
 ROL W
 ASL A
 ROL W
 LDA W
 CLC
 ADC #&80
 STA W
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
 LDA W
 STA L007E
 LDA L0082
 STA L007F
 STX W
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
 STA T
 LDA L5E90,Y
 SBC L5E90,X
 STA L0086
 JSR sub_C0E40
 CMP #&40
 BCS C2BB9
 ASL T
 ROL A
 CMP #&40
 BCS C2BBB
 ASL T
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
 SBC W
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
 STA T
 LDA L628F
 LSR A
 LSR A
 LSR A
 AND #3
 ORA T
 ORA #&40
 STA L0034
 LDA L628F
 BNE C2C44
 LDA #&55
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
 ORA T
 STA L0033
 LDA L001B
 CLC
 ADC #1
 CMP L004B
 BEQ C2C68
 LDA L0082
 CMP #&50
 BCC C2C70

.C2C68

 LDA #0
 BIT L0087
 BMI C2C70
 LDA #&4F

.C2C70

 STA L0082
 LDA L007E
 SEC
 SBC #&30
 STA U
 LSR A
 LSR A
 STA L0085
 CMP #&28
 BCS C2CE6
 LSR A
 CLC
 ADC #&30
 STA Q
 STA S
 CLC
 ADC #1
 STA L008F
 LDA U
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
 LDA #&60
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
 LDA W
 STA L007E
 LDA L0082
 STA L007F

.C2D08

 LDX L0045
 LDY L001B
 RTS

 LDA L0053
 BEQ C2CFC
 JSR C2F12
 JMP C2CFC

\ ******************************************************************************
\
\       Name: sub_C2D17
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2D17

 LDA L3E50,X
 STA sub_C2D27+1
 LDX #&80
 LDA L0083
 EOR #&FF
 CLC
 ADC #1
 CLC

\ ******************************************************************************
\
\       Name: sub_C2D27
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2D27

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
 CPX #&44
 BNE C2D29
 RTS

\ ******************************************************************************
\
\       Name: sub_C2D9A
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2D9A

 LDA L40D0,X
 STA sub_C2DAA+1
 LDX #&80
 LDA L0083
 EOR #&FF
 CLC
 ADC #1
 CLC

\ ******************************************************************************
\
\       Name: sub_C2DAA
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2DAA

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
 CPX #&2F
 CLC
 BNE C2DAC
 JMP C2F12

\ ******************************************************************************
\
\       Name: sub_C2E20
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2E20

 LDA L3ED0,X
 STA sub_C2E2E+1
 LDA L0084
 EOR #&FF
 CLC
 ADC #1
 CLC

\ ******************************************************************************
\
\       Name: sub_C2E2E
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2E2E

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
 CPX #&44
 BNE C2E30
 RTS

\ ******************************************************************************
\
\       Name: sub_C2E99
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2E99

 LDA L3ED8,X
 STA sub_C2EA7+1
 LDA L0084
 EOR #&FF
 CLC
 ADC #1
 CLC

\ ******************************************************************************
\
\       Name: sub_C2EA7
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2EA7

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
 CPX #&2F
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

 CPY #&50
 BCS C2F44
 LDX L62F2
 CPX #&28
 BCC C2F41
 STA T
 AND #3
 CMP #3
 LDA T
 BCS C2F41
 AND #&FC

.C2F41

 STA L5F60,Y

.C2F44

 RTS

\ ******************************************************************************
\
\       Name: sub_C2F45
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2F45

 STA L008A

.C2F47

 NOP
 CPY L0082
 BEQ C2F7E
 LDA L0085

\ ******************************************************************************
\
\       Name: sub_C2F4E
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2F4E

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

 CPY #&2C
 BCS C2F6C
 JSR sub_C2FEE
 BCC loop_C2F5E

.C2F6C

 CMP #&55
 BNE C2F72
 LDA #0

.C2F72

 AND L337C,X
 ORA L629C,X
 BNE C2F58
 LDA #&55
 BNE C2F58

.C2F7E

 TSX
 INX
 INX
 TXS
 LDA L0053
 BNE C2F19
 RTS

\ ******************************************************************************
\
\       Name: sub_C2F87
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2F87

 STA L008A

.C2F89

 NOP
 CPY L0082
 BEQ C2F7E
 LDA L0085

\ ******************************************************************************
\
\       Name: sub_C2F90
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2F90

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

 CPY #&2C
 BCS C2FAE
 JSR sub_C2FEE
 BCC loop_C2FA0

.C2FAE

 CMP #&55
 BNE C2FB4
 LDA #0

.C2FB4

 AND L337C,X
 ORA L629C,X
 BNE C2F9A
 LDA #&55
 BNE C2F9A

.C2FC0

 CPX #&80
 BNE C2FD3
 CPY #&2C
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
 CPY #&2C
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

\ ******************************************************************************
\
\       Name: sub_C2FEE
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2FEE

 STA T
 STX U
 LDX L0085
 TYA
 CMP L3900,X
 BNE C2FFB
 CLC

.C2FFB

 LDA T
 LDX U
 RTS

 EQUB &FE, &1F, &0A, &0C, &83
 EQUS "STANDARD OF"
 EQUB &D7, &1F, &0E, &0E, &FF, &FC, &A3, &FC, &A3, &FC, &A1, &FF
 EQUB &A8, &A9, &F0, &C4, &82, &B0, &0C, &C4, &7F, &90, &08, &AE
 EQUB &68, &FE, &3D, &00, &20, &25, &61, &91, &70, &88, &10, &14
 EQUB &98, &29, &07, &C9, &07, &90, &0D, &A5, &70, &38, &E9, &38
 EQUB &85, &70, &A5, &71, &E9, &01, &85, &71, &C4, &77, &B0, &D1
 EQUB &A4, &78, &60, &FF, &00, &00, &00, &00, &06, &06, &06, &06
 EQUB &06, &06, &06, &03, &03, &03, &03, &03, &01, &01, &01, &00
 EQUB &00, &00, &05, &04, &03, &02, &01
 EQUB 0

\ ******************************************************************************
\
\       Name: L306C
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L306C

 EQUB &2D, &33

\ ******************************************************************************
\
\       Name: L306E
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L306E

 EQUB 0, 0, 1, 1, 1, 1, 1, 1

\ ******************************************************************************
\
\       Name: L3076
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3076

 EQUB &05, &05, &03, &04, &03, &04, &04, &04, &38, &38, &97, &97
 EQUB &97, &97, &A8, &A8, &A8, &A8, &A8, &A8, &A8, &A8, &A8, &A8
 EQUB &A8, &A8, &A8, &A8, &A8, &A8, &A8, &A8, &B9, &B9, &B9, &B9
 EQUB &B9, &B9, &33, &A8, &20, &00, &7E, &84, &75, &BC, &50, &30
 EQUB &39, &F9, &36, &19, &F9, &35, &A4, &75, &91, &72, &E0, &03
 EQUB &F0, &03, &4C, &18, &7F, &4C, &BF, &7B, &85, &82, &84, &78
 EQUB &B9, &9E, &3B, &85, &71, &B9, &26, &3B, &85, &70, &B9, &FA
 EQUB &3E, &85, &77, &B9, &FA, &40, &28, &8D, &7C, &7C, &7C, &7C
 EQUB &7C, &6B, &6B, &6B, &6B, &6B, &5A, &5A, &5A, &5A, &49, &49
 EQUB &49, &49, &38, &38, &38, &38, &27, &27, &27, &27, &16, &16
 EQUB &16, &16, &16, &16, &16, &16, &16, &16, &16, &05, &05, &05
 EQUB &05, &05

\ ******************************************************************************
\
\       Name: L30FC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L30FC

 EQUB &10, &00, &00, &10

\ ******************************************************************************
\
\       Name: L3100
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3100

 EQUB &1C, &1C, &1C, &1C, &1C, &1B, &1B, &1B, &1B, &1A, &1A, &1A
 EQUB &19, &19, &18, &18, &17, &16, &15, &14, &14, &14, &81, &81
 EQUB &81, &81, &81, &81, &79, &35, &A8, &20, &00, &7C, &3D, &D0
 EQUB &38, &1D, &50, &33, &91, &70, &BC, &80, &30, &CC, &7D, &7F
 EQUB &F0, &10, &A9, &91, &8D, &0F, &7E, &8C, &88, &7F, &8C, &7D
 EQUB &7F, &A9, &60, &8D, &00, &7E, &BC, &D0, &30, &8C, &9B, &7F
 EQUB &BD, &00, &44, &3D, &50, &39, &1D, &D0, &42, &64, &75, &75
 EQUB &75, &75, &75, &86, &86, &86, &86, &86, &97, &97, &97, &97
 EQUB &A8, &A8, &A8, &A8, &B9, &B9, &B9, &B9, &CA, &CA, &CA, &CA
 EQUB &DB, &DB, &DB, &DB, &DB, &DB, &DB, &DB, &DB, &DB, &DB, &EC
 EQUB &EC, &EC, &EC, &EC, &28, &28, &00, &00, &81, &81, &81, &81
 EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81
 EQUB &81, &81, &81, &81, &81, &81, &24, &7F, &A9, &60, &8D, &00
 EQUB &7C, &A4, &70, &C8, &98, &29, &07, &D0, &14, &98, &18, &69
 EQUB &38, &85, &70, &85, &72, &A5, &71, &69, &01, &85, &71, &69
 EQUB &01, &85, &73, &90, &04, &84, &70, &84, &72, &A9, &F1, &38
 EQUB &FD, &80, &30, &8D, &68, &7F, &BC, &50, &30, &BD, &04, &05
 EQUB &39, &79, &36, &19

\ ******************************************************************************
\
\       Name: C31D0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 CPY U
 BNE loop_C31D2
 INC T
 LDA P
 EOR #&80
 STA P
 BMI C31FC
 INC Q

.C31FC

 JMP C3D68

 EQUB &00, &20, &35, &FF, &81, &80, &43, &F0, &08, &A9, &00, &9D
 EQUB &80, &43, &B9, &00, &60, &A0, &38, &91, &72, &E0, &2C, &F0
 EQUB &25, &CA, &A4, &70, &C8, &98, &29, &07, &F0, &07, &84, &70
 EQUB &84, &72, &4C, &F7, &7B, &98, &18, &69, &38, &85, &70, &85
 EQUB &72, &A5, &71, &69, &01, &85, &71, &69, &01, &85, &73, &4C
 EQUB &F7, &7B, &60, &CA, &BC, &50, &31, &CC, &24, &7F, &F0, &10
 EQUB &A9, &91, &8D, &0F, &7C, &8C, &2F, &7F, &8C

\ ******************************************************************************
\
\       Name: sub_C3250
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C3250

 STY S
 STA R
 LDY #0

.loop_C3256

 LDA (R),Y
 JSR PrintCharacter
 INY
 CPY #&0C
 BNE loop_C3256
 RTS

\ ******************************************************************************
\
\       Name: sub_C3261
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C3261

 LDX #&FF
 JSR sub_C0E50
 BNE C327B
 LDX #&86
 JSR sub_C0E50
 BNE C327B
 BIT L001C
 BMI C327D

\ ******************************************************************************
\
\       Name: sub_C3273
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C3273

 LDX L006B
 TXS
 ROR L001C
 JMP StartGame

.C327B

 LSR L001C

.C327D

 RTS

 EQUB &00, &00, &31, &30, &FF, &41, &B9, &00, &60, &A0, &10, &91
 EQUB &72, &BC, &80, &41, &F0, &08, &A9, &00, &9D, &80, &41, &B9
 EQUB &00, &60, &A0, &18, &91, &72, &BC, &00, &42, &F0, &08, &A9
 EQUB &00, &9D, &00, &42, &B9, &00, &60, &A0, &20, &91, &72, &BC
 EQUB &80, &42, &F0, &08, &A9, &00, &9D, &80, &42, &B9, &00, &60
 EQUB &A0, &28, &91, &72, &BC, &00, &43, &F0, &08, &A9, &00, &9D
 EQUB &00, &43, &B9, &00, &60, &A0, &30, &91, &72, &BC

\ ******************************************************************************
\
\       Name: sub_C32D0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C32D0

 LDA T
 CMP #&20
 BNE C32D8
 LDA #&30

.C32D8

 SEC
 SBC #&30
 CMP #&0A
 BCS C32FB
 STA T
 LDX U
 CPX #&20
 CLC
 BEQ C32FB
 ASL A
 ASL A
 ADC T
 ASL A
 STA T
 TXA
 SEC
 SBC #&30
 CMP #&0A
 BCS C32FB
 ADC T
 CMP #&29

.C32FB

 RTS

\ ******************************************************************************
\
\       Name: L32FC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L32FC

 EQUB &66, &67, &5F, &5E, &32, &30, &FF, &BC, &00, &3F, &F0, &08
 EQUB &A9, &00, &9D, &00, &3F, &B9, &00, &60, &A0, &F0, &91, &70
 EQUB &BC, &80, &3F, &F0, &08, &A9, &00, &9D, &80, &3F, &B9, &00
 EQUB &60, &A0, &F8, &91, &70, &BC, &00, &40, &F0, &08, &A9, &00
 EQUB &9D, &00, &40, &B9, &00, &60, &A0, &00, &91, &72, &BC, &80
 EQUB &40, &F0, &08, &A9, &00, &9D, &80, &40, &B9, &00, &60, &A0
 EQUB &08, &91, &72, &BC, &00, &41, &F0, &08, &A9, &00, &9D, &00
 EQUB &00, &00, &F0, &70, &30, &10, &00, &70, &70, &30, &10, &00
 EQUB &70, &30, &10, &00, &70, &30, &10, &00, &70, &30, &10, &00
 EQUB &70, &30, &10, &00, &70, &40, &30, &20, &30, &10, &10, &10
 EQUB &00, &00, &00, &40, &70, &40, &30, &30

\ ******************************************************************************
\
\       Name: L337C
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L337C

 EQUB &00, &88, &CC, &EE, &81, &81, &81, &81, &81, &81, &81, &60
 EQUB &A0, &C8, &91, &70, &BC, &00, &3D, &F0, &08, &A9, &00, &9D
 EQUB &00, &3D, &B9, &00, &60, &A0, &D0, &91, &70, &BC, &80, &3D
 EQUB &F0, &08, &A9, &00, &9D, &80, &3D, &B9, &00, &60, &A0, &D8
 EQUB &91, &70, &BC, &00, &3E, &F0, &08, &A9, &00, &9D, &00, &3E
 EQUB &B9, &00, &60, &A0, &E0, &91, &70, &BC, &80, &3E, &F0, &08
 EQUB &A9, &00, &9D, &80, &3E, &B9, &00, &60, &A0, &E8, &91, &70
 EQUB &00, &00, &F0, &E0, &C0, &80, &00, &E0, &E0, &C0, &80, &00
 EQUB &E0, &C0, &80, &00, &E0, &C0, &80, &00, &E0, &C0, &80, &00
 EQUB &E0, &C0, &80, &00, &E0, &20, &C0, &40, &C0, &80, &80, &80
 EQUB &00, &00, &00, &20, &E0, &20, &C0, &C0

\ ******************************************************************************
\
\       Name: L33FC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L33FC

 EQUB &FF, &77, &33, &11
 EQUS "ENTER "
 EQUB &FF, &81, &81, &81, &81, &81, &60, &A0, &A8, &91, &70, &BC
 EQUB &00, &3B, &F0, &08, &A9, &00, &9D, &00, &3B, &B9, &00, &60
 EQUB &A0, &B0, &91, &70, &BC, &80, &3B, &F0, &08, &A9, &00, &9D
 EQUB &80, &3B, &B9, &00, &60, &A0, &B8, &91, &70, &BC, &00, &3C
 EQUB &F0, &08, &A9, &00, &9D, &00, &3C, &B9, &00, &60, &A0, &C0
 EQUB &91, &70, &BC, &80, &3C, &F0, &08, &A9, &00, &9D, &80, &3C
 EQUB &B9, &00

\ ******************************************************************************
\
\       Name: sub_C3450
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C3450

 BPL C3457
 EOR #&FF
 CLC
 ADC #1

.C3457

 RTS

\ ******************************************************************************
\
\       Name: L3458
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3458

 EQUB &07, &17, &47, &57, &23, &33, &63, &73, &80, &90, &C0, &D0
 EQUB &A5, &B5, &E5, &F5

\ ******************************************************************************
\
\       Name: L3468
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3468

 EQUB &03, &13, &23, &33, &43, &53, &63, &73, &84, &94, &A4, &B4
 EQUB &C4, &D4, &E4, &F4

\ ******************************************************************************
\
\       Name: L3478
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3478

 EQUB &26, &36, &66, &76

\ ******************************************************************************
\
\       Name: L347C
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L347C

 EQUB &A1, &B1, &E1, &F1, &1F, &0D, &12
 EQUS "front"
 EQUB &A2, &85, &D8, &FF, &81, &81, &81, &81, &70, &BC, &00, &39
 EQUB &F0, &08, &A9, &00, &9D, &00, &39, &B9, &00, &60, &A0, &90
 EQUB &91, &70, &BC, &80, &39, &F0, &08, &A9, &00, &9D, &80, &39
 EQUB &B9, &00, &60, &A0, &98, &91, &70, &BC, &00, &3A, &F0, &08
 EQUB &A9, &00, &9D, &00, &3A, &B9, &00, &60, &A0, &A0, &91, &70
 EQUB &BC, &80, &3A, &F0, &08, &A9, &00, &9D, &80, &3A, &B9, &00

\ ******************************************************************************
\
\       Name: sub_C34D0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C34D0

 LDA #0

\ ******************************************************************************
\
\       Name: sub_C34D2
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C34D2

 STA L0078
 LDX #&1E
 JSR PrintToken

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

\ ******************************************************************************
\
\       Name: L34F8
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L34F8

 EQUB &80, &40, &20, &10, &00, &00, &00, &00
 EQUS "Amateur"
 EQUB &FF
 EQUS " POINTS"
 EQUB &FF, &81, &81, &81, &81, &D0, &38, &1D, &50, &33, &91, &70
 EQUB &BD, &00, &44, &3D, &50, &39, &1D, &D0, &33, &A8, &20, &00
 EQUB &7E, &E0, &1C, &D0, &C5, &4C, &18, &7F, &BC, &00, &38, &F0
 EQUB &08, &A9, &00, &9D, &00, &38, &B9, &00, &60, &A0, &80, &91
 EQUB &70, &BC, &80, &38, &F0, &08, &A9, &00, &9D, &80, &38, &B9
 EQUB &00, &60, &A0, &88, &91

\ ******************************************************************************
\
\       Name: L3550
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3550

 EQUB &0F, &0F, &0E, &0E, &0D, &05, &06, &0F, &04, &0E, &00, &0D
 EQUB &0F, &0F, &02, &03, &04, &09, &06, &0F, &0E, &00, &0D, &07
 EQUB &04, &0A, &00, &01, &0C, &0C, &02, &01, &01, &0A, &03, &04
 EQUB &00, &01, &03, &01, &03, &00, &80, &C0, &40, &60, &E0, &20
 EQUB &20, &20, &9C

\ ******************************************************************************
\
\       Name: L3583
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3583

 EQUB &86, &9D

\ ******************************************************************************
\
\       Name: L3585
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3585

 EQUB &84, &FF
 EQUS "ACCUMULATED"
 EQUB &FB, &FF, &81, &81, &81, &81, &08, &A9, &00, &9D, &80, &37
 EQUB &B9, &00, &60, &A0, &78, &91, &70, &4C, &56, &7D, &A9, &60
 EQUB &8D, &EE, &7E, &CA, &BC, &50, &31, &CC, &24, &7D, &F0, &16
 EQUB &A9, &91, &8D, &0F, &7C, &8C, &2F, &7D, &8C, &24, &7D, &A9
 EQUB &60, &8D, &00, &7C, &BC, &D0, &30, &8C, &4D, &7D, &20, &F3
 EQUB &7E, &3D

\ ******************************************************************************
\
\       Name: L35D0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L35D0

 EQUB &0E, &0E, &0B, &0B, &0B, &06, &0F, &0D, &05, &0D, &07, &0B
 EQUB &0E, &0E, &03, &04, &09, &08, &0F, &0D, &0D, &07, &09, &0D
 EQUB &06, &09, &02, &0C, &0A, &0A, &08, &02, &0A, &08, &04, &0A
 EQUB &03, &03, &0A, &03, &0A, &00, &10, &30, &20, &60, &70, &40
 EQUS "FORMULA 3  CHAMPIONSHIP"
 EQUB &FF, &81, &81, &81, &81, &F0, &08, &A9, &00, &9D, &00, &36
 EQUB &B9, &00, &60, &A0, &60, &91, &70, &BC, &80, &36, &F0, &08
 EQUB &A9, &00, &9D, &80, &36, &B9, &00, &60, &A0, &68, &91, &70
 EQUB &BC, &00, &37, &F0, &08, &A9, &00, &9D, &00, &37, &B9, &00
 EQUB &60, &A0, &70, &91, &70, &BC, &80, &37, &F0

\ ******************************************************************************
\
\       Name: L3650
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3650

 EQUB &09, &02, &08, &04, &0A, &0D, &0B, &09, &0E, &08, &04, &08
 EQUB &09, &02, &08, &08, &0D, &0D, &0C, &0B, &08, &02, &08, &0F
 EQUB &0A, &08, &09, &08, &09, &03, &0B, &0B, &08, &0B, &08, &08
 EQUB &01, &08, &08, &09, &01, &FF, &77, &33, &33, &11, &11, &11
 EQUB &AB
 EQUS "YOUR TIME IS UP!"
 EQUB &AB, &FF
 EQUS "PRESS "
 EQUB &FF, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81
 EQUB &81, &81, &A0, &48, &91, &70, &BC, &00, &35, &F0, &08, &A9
 EQUB &00, &9D, &00, &35, &B9, &00, &60, &A0, &50, &91, &70, &BC
 EQUB &80, &35, &F0, &08, &A9, &00, &9D, &80, &35, &B9, &00, &60
 EQUB &A0, &58, &91, &70, &BC, &00, &36

\ ******************************************************************************
\
\       Name: L36D0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L36D0

 EQUB &0A, &01, &0C, &00, &02, &05, &03, &01, &06, &0C, &09, &00
 EQUB &0A, &01, &00, &00, &05, &05, &04, &03, &0A, &09, &00, &07
 EQUB &02, &00, &01, &00, &0B, &01, &03, &01, &00, &03, &00, &09
 EQUB &00, &01, &09, &00, &00, &FF, &EE, &CC, &CC, &88, &88, &88
 EQUB &FE, &EB, &A7, &D3
 EQUS "NAME OF"
 EQUB &D4, &1F, &0C, &11, &83
 EQUS "____________"
 EQUB &1F, &09, &10, &85, &D8, &FF, &1F, &02, &0A, &86, &FF, &81
 EQUB &81, &81, &81, &81, &00, &60, &A0, &38, &91, &70, &BC, &00
 EQUB &34, &F0, &08, &A9, &00, &9D, &00, &34, &B9, &00, &60, &A0
 EQUB &40, &91, &70, &BC, &80, &34, &F0, &08, &A9, &00, &9D, &80
 EQUB &34, &B9, &00, &60

\ ******************************************************************************
\
\       Name: L3750
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3750

 EQUB &0A, &0A, &08, &08, &45, &08, &08, &09, &4A, &88, &08, &08
 EQUB &0A, &4A, &02, &00, &02, &4A, &08, &05, &88, &08, &08, &02
 EQUB &42, &48, &52, &08, &11, &51, &00, &48, &0A, &52, &00, &00
 EQUB &40, &00, &40, &00, &40

\ ******************************************************************************
\
\       Name: L3779
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3779

 EQUS "RN12345Position"
 EQUB &A8
 EQUS "In front:"
 EQUB &AD, &FF
 EQUS "Laps to go"
 EQUB &A8
 EQUS "Behind:"
 EQUB &B2, &FF, &C6, &FF, &81, &81, &32, &B9, &00, &60, &A0, &28
 EQUB &91, &70, &BC, &00, &33, &F0, &08, &A9, &00, &9D, &00, &33
 EQUB &B9, &00, &60, &A0, &30, &91, &70, &BC, &80, &33, &F0, &08
 EQUB &A9, &00, &9D, &80, &33, &B9

\ ******************************************************************************
\
\       Name: sub_C37D0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C37D0

 STX L62CC
 STY L62CD

\ ******************************************************************************
\
\       Name: sub_C37D6
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 ADC #&30
 JSR PrintCharacter
 ASL L0078
 PLA
 ASL L0078
 BCS C37FE
 AND #&0F
 BNE C37F8
 LDA #&1F

.C37F8

 CLC
 ADC #&30
 JSR PrintCharacter

.C37FE

 RTS

\ ******************************************************************************
\
\       Name: L37FF
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

 EQUB &FF, &FE, &EC, &DA, &D5, &ED, &DB, &D5, &EE, &DC, &D5, &EB
 EQUB &D2
 EQUS "DURATION OF QUALIFYING LAPS"
 EQUB &FF
 EQUS " ] "
 EQUB &FF, &9D, &80, &31, &B9, &00, &60, &A0, &18, &91, &70, &BC
 EQUB &00, &32, &F0, &08, &A9, &00, &9D, &00, &32, &B9, &00, &60
 EQUB &A0, &20, &91, &70, &BC, &80, &32, &F0, &08, &A9, &00, &9D
 EQUB &80

\ ******************************************************************************
\
\       Name: SetupGame
\       Type: Subroutine
\   Category: Setup
\    Summary: Set the screen mode, clear various variables and start the game
\
\ ******************************************************************************

.SetupGame

 LDA #4                 \ Call OSBYTE with A = 4, X = 1 and Y = 0 to disable
 LDY #0                 \ cursor editing
 LDX #1
 JSR OSBYTE

 JSR SetScreenMode7     \ Change to screen mode 7 and hide the cursor

 LDX #9                 \ We now zero the ten bytes at L05F4-L05FD, so set a
                        \ loop counter in X

 LDA #0                 \ Set L0069 = 0
 STA L0069

.setp1

 STA L05F4,X            \ Zero the X-th byte at L05F4
                        \
                        \ The address in this instruction gets modified

 DEX                    \ Decrement the loop counter

 BPL setp1              \ Loop back until we have zeroed all ten bytes

 LDA #246               \ Set L05FE = 246
 STA L05FE

 TSX                    \ Set L006B to the stack pointer
 STX L006B

 JSR sub_C5A22          \ Contains BRK, must get changed first ???

 LDA #190               \ Call OSBYTE with A = 190, X = 32 and Y = 0 to set the
 LDY #0                 \ ADC conversion type to 32-bit conversion (though only
 LDX #32                \ values of 8 and 12 are supported, so this is odd)
 JSR OSBYTE

 JMP StartGame          \ Jump to StartGame to start the game

\ ******************************************************************************
\
\       Name: L387F
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

 EQUB &FF, &EC
 EQUS "PRACTICE"
 EQUB &ED
 EQUS "COMPETITION"
 EQUB &FF, &FF, &AD
 EQUS "PLEASE"
 EQUB &A2
 EQUS "WAIT"
 EQUB &AD, &FF, &1F, &09, &02, &FF, &81, &81, &81, &A9, &00, &9D
 EQUB &80, &30, &B9, &00, &60, &A0, &08, &91, &70, &BC, &00, &31
 EQUB &F0, &08, &A9, &00, &9D, &00, &31, &B9, &00, &60, &A0, &10
 EQUB &91, &70, &BC, &80, &31, &F0, &08, &A9, &00, &FF, &FF, &88
 EQUB &88, &CC, &EE, &FF, &88, &88, &CC, &EE, &FF, &88, &CC, &EE
 EQUB &FF, &88, &CC, &EE, &FF, &88, &CC, &EE, &FF, &88, &CC, &EE
 EQUB &FF, &88, &88, &CC, &CC, &CC, &EE, &EE, &EE, &FF, &FF, &FF
 EQUB &88, &88, &88, &CC, &CC

\ ******************************************************************************
\
\       Name: L38FC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L38FC

 EQUB 0

\ ******************************************************************************
\
\       Name: L38FD
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L38FD

 EQUB &0F

\ ******************************************************************************
\
\       Name: L38FE
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L38FE

 EQUB &F0

\ ******************************************************************************
\
\       Name: L38FF
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L38FF

 EQUB &FF

\ ******************************************************************************
\
\       Name: L3900
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3900

 EQUB &1B, &1B, &1B, &15, &03, &02, &02, &06, &0B, &0F, &13, &17
 EQUB &1B
 EQUS "&++++++++++++&"
 EQUB &1B, &17, &13, &0F, &0B, &06, &02, &02, &03, &15, &1B, &1B
 EQUB &1B, &1B, &FF, &81, &81, &F3, &7E, &4C, &13, &7D, &BD, &60
 EQUB &5F, &29, &03, &A8, &B9, &FC, &38, &BC, &00, &30, &F0, &08
 EQUB &A9, &00, &9D, &00, &30, &B9, &00, &60, &A0, &00, &91, &70
 EQUB &BC, &80, &30, &F0, &08, &FF, &FF, &11, &11, &33, &77, &FF
 EQUB &11, &11, &33, &77, &FF, &11, &33, &77, &FF, &11, &33, &77
 EQUB &FF, &11, &33, &77, &FF, &11, &33, &77, &FF, &11, &11, &33
 EQUB &33, &33, &77, &77, &77, &FF, &FF, &FF, &11, &11, &11, &33
 EQUB &33

\ ******************************************************************************
\
\       Name: L397C
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L397C

 EQUB &75, &75, &75, &75

\ ******************************************************************************
\
\       Name: L3980
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3980

 EQUB &35, &35, &35, &35, &35, &35, &35, &35, &34, &34, &34, &34
 EQUB &34, &34, &33, &33, &33, &32, &32, &32, &31, &31, &30, &30
 EQUB &2F, &2F, &2E, &2E, &2D, &2D, &2C, &2C, &2B, &2A, &29, &28
 EQUB &27, &26, &A2, &9C, &08, &08, &E7, &FF, &8D, &DA, &7B, &A9
 EQUB &91, &8D, &0F, &7C, &8D, &0F, &7C, &8D, &0F, &7E, &A9, &E0
 EQUB &8D, &EE, &7E, &60, &A9, &00, &85, &70, &85, &72, &A2, &67
 EQUB &86, &71, &E8, &86, &73, &A2, &4F, &20

\ ******************************************************************************
\
\       Name: L39D0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L39D0

 EQUB &77, &33, &11, &00

\ ******************************************************************************
\
\       Name: L39D4
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L39D4

 EQUB &80, &01, &C1, &81, &C2, &42, &C0, &83, &43, &20, &04, &84

\ ******************************************************************************
\
\       Name: L39E0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L39E0

 EQUB &9D, &CF, &CE, &EE

\ ******************************************************************************
\
\       Name: L39E4
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L39E4

 EQUB &DD, &EE, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00

\ ******************************************************************************
\
\       Name: L39F8
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L39F8

 EQUB &77, &BB, &DD, &EE, &77, &BB, &DD, &EE, &1F, &05, &18, &86
 EQUB &D9
 EQUS "SPACE BAR TO CONTINUE"
 EQUB &FF, &45, &FF
 EQUS "GRID POSITIONS"
 EQUB &FF, &B8, &06, &20, &D6, &37, &06, &78, &B0, &0B, &A9, &2E
 EQUB &20, &92, &50, &BD, &A0, &06, &20, &D6, &37, &60, &AD, &24
 EQUB &7D, &8D, &D4, &7B, &AD, &24, &7F, &8D, &D7, &7B, &AD, &7D
 EQUB &7F

\ ******************************************************************************
\
\       Name: sub_C3A50
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C3A50

 LDY #1

.loop_C3A52

 LDA L3A71,Y
 STA T
 LDX L3A6F,Y
 LDA #&97
 STA L7C79,X
 LDA #&E2

.loop_C3A61

 INX
 STA L7C79,X
 LDA #&E6
 CPX T
 BNE loop_C3A61
 DEY
 BPL loop_C3A52
 RTS

\ ******************************************************************************
\
\       Name: L3A6F
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3A6F

 EQUB &00, &78

\ ******************************************************************************
\
\       Name: L3A71
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3A71

 EQUB &23, &9B, &AF
 EQUS "FINISHED"
 EQUB &AF, &FF, &00, &00, &A6
 EQUS "Less than one minute to go"
 EQUB &A6, &FF, &1F, &05, &14, &84, &9D, &86, &33, &A2, &9C, &A5
 EQUB &83, &FF, &81, &81, &81, &A9, &F0, &A2, &09, &9D, &C0, &42
 EQUB &CA, &10, &FA, &68, &A2, &05, &9D, &C2, &42, &45, &74, &CA
 EQUB &10, &F8, &60, &85, &78, &BD, &D0, &06, &20, &D6, &37, &A9
 EQUB &3A, &20, &92, &50, &BD

\ ******************************************************************************
\
\       Name: tokenLo
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.tokenLo

 EQUB &00, &00, &1D, &87, &15, &80, &80, &80, &00, &07, &80, &00
 EQUB &88, &91, &97, &9D, &28, &93, &00, &80, &00, &80, &00, &00
 EQUB &00, &80, &00, &00, &00, &00, &00, &80, &A6

 EQUB &E0               \ Token 33

 EQUB &13, &22
 EQUB &8A, &00, &9D, &80, &80, &80, &80, &80, &94, &A8
 
 EQUB LO(token46)        \ Token 46
 
 EQUB &00
 EQUB &97, &A5, &7A, &08, &F5, &73

\ ******************************************************************************
\
\       Name: L3B06
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3B06

 EQUB &58, &59, &5A, &5B, &5D, &5E, &5F, &60, &62, &63, &64, &65
 EQUB &67, &68, &69, &6A, &6C, &6D, &6E, &6F, &71, &72, &73, &74
 EQUB &76, &77, &78, &79, &7B, &7C, &7D, &7E, &40, &48, &18, &30
 EQUB &70, &78, &D0, &1D, &E0, &A0, &F0, &0D, &CA, &10, &12, &E0
 EQUB &C0, &B0, &EF, &A9, &A5, &A0, &77, &D0, &0C, &A5, &6A, &29
 EQUB &3F, &D0, &F4, &A2, &28, &A9, &F2, &A0, &05, &86, &6D, &48
 EQUB &84, &74

\ ******************************************************************************
\
\       Name: tokenHi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.tokenHi

 EQUB &36, &42, &3A, &35, &30, &43, &3C, &3F, &35, &3E, &3E, &34
 EQUB &3E, &3C, &3C, &3C, &38, &36, &32, &32, &33, &3D, &38, &37
 EQUB &3C, &34, &30, &3D, &43, &3E, &3A, &35, &39

 EQUB &40               \ Token 33
 
 EQUB &3D, &37
 EQUB &43, &3F, &3A, &38, &42, &3A, &36, &37, &37, &37

 EQUB HI(token46)        \ Token 46

 EQUB &00
 EQUB &38, &38, &3C, &35, &42, &3A

\ ******************************************************************************
\
\       Name: L3B86
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3B86

 EQUB &E8, &88, &C8, &E8, &CA, &C8, &88, &CA

\ ******************************************************************************
\
\       Name: L3B8E
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3B8E

 EQUB &88, &E8, &E8, &C8, &C8, &CA, &CA, &88, &18, &EA, &EA, &18
 EQUB &18, &EA, &EA, &18, &75, &75, &74, &75, &76, &76, &12, &11
 EQUB &10, &0E, &0D, &0C, &81, &81, &A5, &84, &99, &93, &62, &20
 EQUB &B6, &7F, &88, &10, &E5, &60, &A5, &6C, &10, &4D, &A6, &6D
 EQUB &F0, &49, &10, &10, &E0, &80, &D0, &0C, &24, &61, &10, &02
 EQUB &A2, &F0, &A0, &00, &A9, &80

\ ******************************************************************************
\
\       Name: L3BD0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3BD0

 EQUB &04, &07, &09, &07, &00, &0B, &07

\ ******************************************************************************
\
\       Name: L3BD7
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3BD7

 EQUB 3, 0, 0, 0, 4, 4, 0

\ ******************************************************************************
\
\       Name: L3BDE
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3BDE

 EQUB &AA, &AF, &B3, &AF, &A2, &B8, &AF

\ ******************************************************************************
\
\       Name: L3BE5
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3BE5

 EQUB &81, &81, &85, &84, &A3, &83, &85

\ ******************************************************************************
\
\       Name: L3BEC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3BEC

 EQUB &83, &83, &87, &87, &7F, &84, &87

.token46

 EQUB 22, 7             \ Switch to screen mode 7 with VDU 22, 7

 EQUB 23, 0, 10, 32     \ Set 6845 register R10 = 32
 EQUB 0, 0, 0           \
 EQUB 0, 0, 0           \ This is the "cursor start" register, so this sets the
                        \ cursor start line at 32, effectively disabling the
                        \ cursor

 EQUB 255               \ End token
 
 EQUB &EB, &D2
 EQUS "WING SETTINGS"
 EQUB &D8
 EQUS "range 0 to 40"
 EQUB &1F, &0E, &10
 EQUS "rear"
 EQUB &A2, &85, &D8, &FF, &81, &81, &81, &81, &E5, &74, &85, &7F
 EQUB &BD, &98, &03, &38, &E5, &0B, &38, &E9, &04, &4A, &4A, &4A
 EQUB &85, &76, &A0, &05, &A5, &76, &D9, &A4, &3B, &F0, &09, &B9
 EQUB &93, &62, &F0, &0C, &A9, &00, &F0, &02

\ ******************************************************************************
\
\       Name: sub_C3C50
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C3C50

 LDX #5
 JSR sub_C41D0
 LDX #&18
 JSR PrintToken
 JSR C3EE0
 STA L5F3E
 LDX #&19
 JSR PrintToken
 JSR C3EE0
 STA L5F3D
 JSR sub_C34D0
 RTS

\ ******************************************************************************
\
\       Name: sub_C3C6F
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C3C6F

 LDA L5F3A
 CLC
 ADC #7
 TAX
 JSR PrintToken
 RTS

 EQUB &1F, &18, &02

\ ******************************************************************************
\
\       Name: L3C7D
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 EQUB &F0, &F0, &70, &30, &A4, &5B, &BE, &3C, &01, &BD, &8C, &01
 EQUB &30, &20, &BD, &C8, &03, &4A, &4A, &4A, &85, &74, &18, &69
 EQUB &B6, &85, &84, &A9, &B6, &38

\ ******************************************************************************
\
\       Name: L3CD0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3CD0

 EQUB &00, &05, &09, &0E, &12, &19, &1A, &1B, &1E, &20, &22, &25
 EQUB &27

\ ******************************************************************************
\
\       Name: L3CDD
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3CDD

 EQUB 0

\ ******************************************************************************
\
\       Name: L3CDE
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3CDE

 EQUB &08, &10, &18, &1E, &26, &29, &2C, &31, &35, &39, &3E, &42
 EQUB &46

\ ******************************************************************************
\
\       Name: sub_C3CEB
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C3CEB

 TXA
 LSR A
 LSR A
 CLC
 ADC #&40
 TAY
 TXA
 AND #3
 ASL A
 ASL A
 STA T
 ASL A
 CLC
 ADC T
 ADC #&50
 RTS

\ ******************************************************************************
\
\       Name: L3D00
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

 EQUB &FE, &EC, &D3
 EQUS "ANOTHER"
 EQUB &D4, &ED
 EQUS "START"
 EQUB &D7, &FF, &8D

\ ******************************************************************************
\
\       Name: L3D14
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3D14

 EQUB &81, &9D

\ ******************************************************************************
\
\       Name: L3D16
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3D16

 EQUB &83

\ ******************************************************************************
\
\       Name: L3D17
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3D17

 EQUB &C8, &A2, &9C, &FF, &81, &81, &81, &81, &81, &81, &81, &81
 EQUB &81, &81, &81, &81, &0E, &0E, &0E, &00, &80, &E0, &74, &77
 EQUB &77, &77, &77, &00, &10, &70, &E2, &EE, &EE, &EE, &EE, &91
 EQUB &AA, &00, &11, &00, &33, &22, &11, &22, &44, &99, &22, &88
 EQUB &EE, &33, &44, &70, &30, &10, &10, &88, &00

\ ******************************************************************************
\
\       Name: sub_C3D50
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   0-39 (from recursive token number 160-199)
\
\ Returns:
\
\   Z flag              Set (so a BEQ following the routine call will always
\                       branch)
\
\ ******************************************************************************

.sub_C3D50

 STA T

.loop_C3D52

 LDA #&20
 JSR PrintCharacter
 DEC T
 BNE loop_C3D52

.loop_C3D5B

 RTS

\ ******************************************************************************
\
\       Name: sub_C3D5C
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C3D5C

 LDA #0
 STA L0000
 STA T
 STA P
 LDA #&30
 STA Q

.C3D68

 LDX T
 CPX #&28
 BEQ loop_C3D5B
 LDA L3900,X
 STA U
 LDY #&46
 JMP C31D0

\ ******************************************************************************
\
\       Name: L3D78
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3D78

 EQUB &AA, &77, &AA, &DD

\ ******************************************************************************
\
\       Name: L3D7C
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3D7C

 EQUB &0A, &07, &0A, &0D, &FE, &EC, &CF, &ED, &D0, &EE, &D1, &EB
 EQUB &A4, &D2
 EQUS "THE CLASS OF"
 EQUB &D7, &FF, &81, &81, &81, &81, &88, &88
 EQUB &44, &44, &44, &44, &44, &04, &00, &00, &00, &00, &00, &00
 EQUB &00, &08, &00, &00, &05, &05, &05, &05, &05, &12, &12, &12
 EQUB &12, &03, &01, &41, &01, &05, &07, &07, &03, &83, &83, &83
 EQUB &83, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &1C, &1D, &0C
 EQUB &0E, &0E

\ ******************************************************************************
\
\       Name: L3DD0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3DD0

 EQUB &00, &27, &12, &09, &03, &03, &03, &03, &03, &03, &03, &03
 EQUB &03, &03, &03, &03, &03, &03

\ ******************************************************************************
\
\       Name: L3DE2
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3DE2

 EQUB &86, &8E, &8D, &8D, &EB, &8B, &DF, &96, &A6, &E9, &8C, &8A
 EQUB &CE, &EE

\ ******************************************************************************
\
\       Name: L3DF0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3DF0

 EQUB &04, &09, &19, &00

\ ******************************************************************************
\
\       Name: L3DF4
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3DF4

 EQUB &05, &0A, &14

\ ******************************************************************************
\
\       Name: L3DF7
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3DF7

 EQUB &09, &06, &04, &03, &02, &01, &01, &00, &00, &FE, &EB, &A5
 EQUB &82, &D4, &D8, &FF
 EQUS "Professional"
 EQUB &FF, &81, &81, &81, &81, &00, &10, &80, &00, &00, &07, &0F
 EQUB &00, &00, &00, &01, &03, &1E, &3C, &68, &16, &16, &3C, &68
 EQUB &F0, &80, &F0, &00, &F0, &10, &F0, &10, &E1, &21, &E1, &21
 EQUB &08, &08, &08, &09, &08, &01, &40, &01, &06, &00, &00, &08
 EQUB &08, &08, &08, &08, &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &88

\ ******************************************************************************
\
\       Name: L3E50
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3E50

 EQUB &08, &13, &1E, &29, &39, &44, &4F, &5A, &02, &0D, &18, &23
 EQUB &33, &3E, &49, &54

\ ******************************************************************************
\
\       Name: sub_C3E60
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: L3E74
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3E74

 EQUB &84, &85

\ ******************************************************************************
\
\       Name: L3E76
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3E76

 EQUB &86, &87, &81, &84, &83, &82, &83, &84, &81, &87
 EQUS "SELECT "
 EQUB &FF
 EQUS " DRIVER"
 EQUB &FF, &81, &81, &81, &81, &44, &44, &22, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &09, &0A, &0A, &0A, &09
 EQUB &01, &01, &01, &01, &09, &08, &28, &00, &F0, &80, &F0, &80
 EQUB &78, &48, &78, &48, &86, &86, &C3, &61, &F0, &10, &F0, &00
 EQUB &00, &00, &00, &08, &0C, &87, &C3, &61, &00, &00, &00, &10
 EQUB &00, &00, &0E, &0F, &00

\ ******************************************************************************
\
\       Name: L3ED0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3ED0

 EQUB &00, &0B, &16, &21, &2E, &39, &44, &4F

\ ******************************************************************************
\
\       Name: L3ED8
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3ED8

 EQUB &4F, &44, &39, &2E, &21, &16, &0B, &00

\ ******************************************************************************
\
\       Name: C3EE0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************


.C3EE0

 LDA #&74
 LDY #0
 LDX #2
 JSR sub_C6300
 JSR sub_C32D0
 BCC C3EF9

.loop_C3EEE

 DEY
 BMI C3EE0
 LDA #&7F
 JSR OSWRCH
 JMP loop_C3EEE

.C3EF9

 RTS

\ ******************************************************************************
\
\       Name: L3EFA
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

 EQUB &AA, &AC, &B0, &B0, &AC, &AA, &1F, &05, &12, &84, &9D, &86
 EQUB &32, &A2, &9C, &A5, &83, &FF, &81, &81, &81, &81, &FF, &44
 EQUB &FF, &AA, &FF, &11, &FF, &11, &FF, &BB, &77, &CF, &47, &CF
 EQUB &8F, &8F, &8F, &8F, &8F, &0F, &0F, &0F, &0F, &0F, &0F, &0F
 EQUB &0F, &0A, &0E, &0E, &0C, &1C, &1C, &1C, &1C, &84, &84, &84
 EQUB &84, &0C, &08, &28, &08, &00, &00, &00, &04, &0A, &0A, &0A
 EQUB &04, &00, &00, &00, &00, &00, &00, &00, &00, &44, &44, &44
 EQUB &44

\ ******************************************************************************
\
\       Name: L3F4F
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3F4F

 EQUB &44, &1B, &1B, &1B, &15, &03, &02, &02, &02, &06, &0B, &0F
 EQUB &13, &17, &1B
 EQUS "&+++++++++++&"
 EQUB &1B, &17, &13, &0F, &0B, &06, &02, &02, &02, &03, &15, &1B
 EQUB &1B, &1B, &20, &20, &20, &42, &65, &68, &69
 EQUS "Novice"
 EQUB &FF, &81, &81, &81, &81, &81, &40, &40, &62, &40, &51, &62
 EQUB &80, &70, &30, &30, &10, &98, &00, &44, &88, &F0, &F0, &F0
 EQUB &F0, &F0, &F0, &F0, &70, &F0, &F0, &F0, &F0, &F0, &F0, &F0
 EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &E0, &C0, &E0, &C0, &80
 EQUB &80, &11, &00, &22, &11, &44, &22, &99, &44, &11, &77, &CC
 EQUB &22, &88, &66, &33, &99, &22, &CC, &77, &AA, &88, &FF, &11
 EQUB &77, &AA, &88, &EA, &EA, &C8, &EA, &88, &C8, &EA, &C8, &EA
 EQUB &EA, &88, &EA, &C8, &88, &EA

\ ******************************************************************************
\
\       Name: L3FE0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3FE0

 EQUB &00, &40, &80, &C0, &00, &40, &80, &C0

\ ******************************************************************************
\
\       Name: L3FE8
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3FE8

 EQUB &77, &BB, &DD, &EE, &77, &BB, &DD, &EE, &00, &40, &80, &C0
 EQUB &00, &40, &80, &C0, &00, &40, &80, &C0, &00, &40, &80, &C0
 EQUB &81, &81, &81, &81, &81, &81, &81, &07, &01, &01, &00, &88
 EQUB &88, &88, &88, &00, &00, &00, &00, &04, &05, &05, &05, &01
 EQUB &01, &00, &20, &08, &04, &04, &04, &49, &48, &68, &2C, &24
 EQUB &24, &34, &16, &0F, &0B, &07, &0F, &0F, &07, &07, &07, &0F
 EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0F, &3A, &6C, &28, &6C, &6C
 EQUB &2C, &2C, &1C, &77, &66, &66, &77, &66, &66, &66, &00, &CC
 EQUB &66, &66, &CC, &CC, &66, &66, &00, &80
 EQUS "Max ThrottleJohnny TurboDavey RocketGloria Sla"
 EQUS "p "
 EQUB &81, &81, &81, &40, &00, &08, &0C, &0C, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &02, &02, &02, &02, &02
 EQUB &00, &00, &00, &0C, &04, &0C, &08, &0C, &05, &05, &05, &05
 EQUB &05, &00, &00, &10, &00, &00, &00, &20, &00, &01, &03, &03
 EQUB &16, &34, &3C, &2C, &78, &48, &F0, &90, &C3, &43, &C2, &86
 EQUB &84, &84, &84, &1C, &00, &00, &00, &00, &06, &04, &06, &02
 EQUB &02, &02, &02, &02, &00, &00, &00, &00

\ ******************************************************************************
\
\       Name: L40D0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L40D0

 EQUB &5A, &4F, &44, &39, &29, &1E, &13, &08, &54, &49, &3E, &33
 EQUB &23, &18, &0D, &02, &0C, &1F

\ ******************************************************************************
\
\       Name: L40E2
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L40E2

 EQUB 4

\ ******************************************************************************
\
\       Name: L40E3
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L40E3

 EQUB &03, &EA

\ ******************************************************************************
\
\       Name: L40E5
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L40E5

 EQUB &AA, &EA, &1F, &24, &02, &FF

\ ******************************************************************************
\
\       Name: sub_C40EB
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C40EB

 LDA #0
 STA L06A0,X
 STA L06B8,X
 LDA #&10
 STA L06D0,X
 RTS

\ ******************************************************************************
\
\       Name: L40F9
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

 EQUB &77, &C2, &C0, &BC, &BC, &C0, &C2, &81, &81, &81, &0F, &0F
 EQUB &0F, &0D, &0E, &0F, &0F, &0E, &0E, &0E, &29, &21, &61, &43
 EQUB &42, &42, &C2, &86, &08, &08, &00, &41, &00, &01, &01, &01
 EQUB &01, &00, &00, &08, &08, &08, &00, &08, &0C, &08, &08, &00
 EQUB &88, &88, &88, &88, &0E, &0A, &0E, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &14, &0A, &0E, &0A, &04, &3C, &2C, &34, &16
 EQUB &12, &12, &12, &03, &86, &C2, &C3, &43, &E1, &21, &F0, &90
 EQUB &00, &00, &00
 EQUS "Hugh JengineDesmond DashPercy Veer  Gary Clipp"
 EQUS "er"
 EQUB &81, &81, &81, &81, &E0, &F0, &F0, &F0, &F0, &F0, &00, &00
 EQUB &00, &00, &80, &C0, &E0, &F0, &F0, &F0, &F0, &F0, &F0, &F0
 EQUB &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &E0, &E0, &C0
 EQUB &C0, &80, &91, &00, &22, &11, &00, &22, &00, &55, &22, &99
 EQUB &44, &22, &99, &00, &11, &77, &CC, &11, &EE, &33, &55, &22
 EQUB &77, &99, &22, &EE, &55, &DD, &45, &AB, &45, &67, &AB, &CF
 EQUB &47, &8B, &0F, &0F, &0F, &0F, &0F, &0F

\ ******************************************************************************
\
\       Name: sub_C41D0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   Offset:
\
\                         * 0 when printing token 160+54
\
\ ******************************************************************************

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

 TXA                    \ Set L3D17 = X + 200
 CLC
 ADC #200
 STA L3D17

 LDX #33                \ Print token 33
 JSR PrintToken

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: L41FB
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

 EQUB &79, &7B, &7C, &7D, &7E, &A5, &FB, &A6, &FF, &81, &81, &81
 EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81
 EQUB &81, &81, &81, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &1F
 EQUB &4A, &0E, &0F, &0F, &0F, &0F, &0F, &00, &AA, &44, &33, &CC
 EQUB &AA, &66, &DC, &44, &00, &22, &11, &FC, &E0, &80, &00, &00
 EQUB &00, &44, &11, &C0, &70, &10, &00, &F0, &70, &30, &30, &10
 EQUB &10, &00, &80, &F0, &F0, &F0, &F0, &F0, &F0, &F0, &70, &C0
 EQUB &C0
 EQUS "Willy SwerveSid Spoiler Billy BumperSlim Chanc"
 EQUS "e Lap Time"
 EQUB &A3, &3A, &A9
 EQUS "Best Time"
 EQUB &A8, &FF, &81, &81, &81, &81, &81, &81, &F0, &90, &E1, &21
 EQUB &F0, &61, &C3, &87, &86, &0C, &18, &00, &0F, &0C, &08, &00
 EQUB &00, &00, &00, &06, &0F, &00, &00, &00, &00, &00, &07, &05
 EQUB &1E, &07, &03, &01, &40, &00, &00, &00, &F0, &C0, &78, &2C
 EQUB &3C, &16, &03, &01, &07, &00, &83, &03, &82, &01, &C1, &81

\ ******************************************************************************
\
\       Name: sub_C42D0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C42D0

 LDA #&22
 STA L62CC
 STA W
 LDA #&D7
 STA L62CD
 LDX L0040
 LDA L3779,X
 JSR sub_C508C
 LDX #&FF
 STX W
 JSR sub_C508C
 RTS

\ ******************************************************************************
\
\       Name: sub_C42EC
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C42EC

 LDX #&13

.loop_C42EE

 JSR sub_C40EB
 DEX
 BPL loop_C42EE
 RTS

\ ******************************************************************************
\
\       Name: L42F5
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

 EQUB &85, &52, &83, &45, &86, &56, &82, &53, &FF, &75, &75, &FE
 EQUB &EB, &A6, &D2
 EQUS "NUMBER OF LAPS"
 EQUB &EC, &DA, &D6, &ED, &DB, &D6, &EE, &DC, &D6, &FF, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &00
 EQUB &00, &00, &00, &00, &00, &00, &00, &00, &00, &00, &01, &01
 EQUB &01, &01, &00, &00, &00, &00, &05, &05, &05, &02, &00, &00
 EQUB &00, &00, &01, &01, &01, &01, &03, &92, &12, &12, &F0, &80
 EQUB &F0, &80
 EQUS "Harry Fume  Dan DipstickWilma Cargo Miles Behi"
 EQUS "ndTHE  PITS"
 EQUB &FF, &1F, &04, &0E, &88, &86, &D9, &1F, &05, &10, &84, &9D
 EQUB &86, &31, &A2, &9C, &A5, &83, &FF, &20, &00, &01, &01, &0F
 EQUB &00, &00, &00, &00, &00, &00, &00, &0F, &03, &01, &00, &20
 EQUB &00, &08, &08, &F0, &68, &3C, &1E, &16, &03, &01, &00, &F0
 EQUB &10, &F0, &10, &F0, &90, &78, &48, &08, &08, &08, &08, &0C
 EQUB &94, &84, &84, &00, &06, &02, &06, &04, &06, &00, &00

\ ******************************************************************************
\
\       Name: sub_C43D0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C43D0

 LDA #2
 JSR sub_C3D50
 LDA #&20
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

 LDA setp1+2,X
 JSR sub_C37D6
 LDA #1
 JSR sub_C3D50
 RTS

\ ******************************************************************************
\
\       Name: sub_C43F6
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C43F6

 LDX #3

.loop_C43F8

 JSR sub_C0E5A
 DEX
 BPL loop_C43F8
 RTS

 EQUB 0

\ ******************************************************************************
\
\       Name: L4400
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4400

 EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81
 EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81
 EQUB &81, &81, &81, &81, &22, &00, &44, &88, &33, &22, &CC, &33
 EQUB &00, &55, &22, &CC, &33, &55, &66, &33, &8F, &25, &07, &0F
 EQUB &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F, &0F
 EQUB &0E, &00, &1C, &0C, &14, &08, &38, &18, &F0, &30, &E1, &43
 EQUB &C3, &86, &0C, &08, &87, &0E, &0C, &08
 EQUS "Roland SlideRick Shaw   Peter Out   Dummy Driv"
 EQUS "er"

\ ******************************************************************************
\
\       Name: L4480
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4480

 EQUB &9C, &EE, &9E, &9F, &03, &04, &AF, &05, &9D, &A5, &A7, &04
 EQUB &AE, &AF, &06, &07, &E6, &9C, &9E, &9F, &03, &AF, &B7, &06
 EQUB &03, &A6, &AE, &05, &B7, &07, &E6, &9F, &03, &A5, &AE, &AF
 EQUB &B7, &07, &E6, &9F, &B7, &03, &A6, &07, &E5, &9D, &9E, &03
 EQUB &04, &9E, &03, &B7, &06, &03, &A5, &A6, &B7, &A6, &A7, &AE
 EQUB &05, &07, &A6, &04, &AE, &AF, &A6, &04, &AE, &AF

\ ******************************************************************************
\
\       Name: sub_C44C6
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C44C6

 LDA L5A14,X
 STA L5F40
 STA U
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

\ ******************************************************************************
\
\       Name: sub_C44EA
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STA V
 LDA trackData+256,Y
 EOR trackData+768,Y
 PHP
 LDA trackData+768,Y
 PHP
 JSR sub_C3450
 CMP #&3C
 PHP
 BCC C454F
 LDA trackData+256,Y
 JSR sub_C3450

.C454F

 STA T
 LSR A
 CLC
 ADC T
 LSR A
 LSR A
 PLP
 BCS C455C
 EOR #&3F

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

 CMP #&40
 BCC C4574
 EOR #&7F

.C4574

 STA L62F2
 EOR #&3F
 STA T
 LSR A
 CLC
 ADC T
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
 SBC V
 STA L004E
 LDA #0
 STA W
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
 ROL W
 ASL A
 ROL W
 STA V
 LDX L006F
 LDA L0164,X
 JSR sub_C4610
 BPL C45DF
 DEC W

.C45DF

 LDY L0022
 CLC
 ADC L0901,Y
 PHP
 CLC
 ADC #&AC
 PHP
 CLC
 ADC V
 STA L6281
 LDA L0A01,Y
 ADC W
 PLP
 ADC #0
 PLP
 ADC #0
 STA L6284
 LDA L0063
 STA U
 LDA #&21
 JSR sub_C0C00
 ASL U
 CLC
 ADC U
 STA L0150,X
 RTS

\ ******************************************************************************
\
\       Name: sub_C4610
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4610

 STA U
 LDA trackData+512,Y
 EOR L0025
 PHP
 LDA trackData+512,Y
 JSR sub_C3450
 JSR sub_C0C00
 PLP
 JSR sub_C3450
 RTS

\ ******************************************************************************
\
\       Name: sub_C4626
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4626

 LDA L005E
 SEC
 SBC L0044
 JSR sub_C3450
 CMP #&40
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
 CPX #&28
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
 ADC #&41
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

\ ******************************************************************************
\
\       Name: sub_C4676
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4676

 JSR sub_C4687
 STA U
 TYA
 JSR sub_C0C00
 STA U
 LDA L0010
 JSR sub_C0C00
 RTS

\ ******************************************************************************
\
\       Name: sub_C4687
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4687

 CMP #&1A
 BCC C4699
 CMP #&2E
 BCC C4693
 CLC
 ADC #&BE
 RTS

.C4693

 ASL A
 ASL A
 CLC
 ADC #&34
 RTS

.C4699

 STA T
 ASL A
 CLC
 ADC T
 ASL A
 RTS

\ ******************************************************************************
\
\       Name: sub_C46A1
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STA T
 LDA L62E9
 JSR sub_C0E40
 STA L0063
 LDA T
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

\ ******************************************************************************
\
\       Name: sub_C4729
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4729

 LDA L62D2
 STA T
 LDY #&58
 LDA L62E2
 JSR sub_C4753
 STA U
 LDA L62D8
 SEC
 SBC T
 STA L62D8
 LDA L62E8
 SBC U
 STA L62E8
 JSR sub_C4765
 STA L003B
 LDA T
 STA L003A
 RTS

\ ******************************************************************************
\
\       Name: sub_C4753
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4753

 PHP
 JSR sub_C0E40
 STA V
 STY U
 JSR sub_C0DBF
 LDA U
 PLP
 JSR sub_C0E40
 RTS

\ ******************************************************************************
\
\       Name: sub_C4765
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4765

 LDA U
 CLC
 BPL C476B
 SEC

.C476B

 ROR A
 PHA
 LDA T
 ROR A
 CLC
 ADC T
 STA T
 PLA
 ADC U
 RTS

\ ******************************************************************************
\
\       Name: sub_C4779
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C47A5
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C47A5

 LDX #2
 LDY #9
 LDA #&80
 STA L0079
 LDA #&0E
 JSR sub_C4874
 LDX #2
 LDY #8
 LDA #&40
 STA L0079
 LDA #9
 JSR sub_C4874
 LDX #8
 JSR sub_C47E5
 RTS

\ ******************************************************************************
\
\       Name: sub_C47C5
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C47E5
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C47E5

 LDA L62D0,X
 CLC
 ADC L62DE
 STA L62D0,X
 LDA L62E0,X
 ADC L62EE
 STA L62E0,X
 RTS

\ ******************************************************************************
\
\       Name: sub_C47F9
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C47F9

 LDY #&4E
 LDA L62DA
 SEC
 SBC L62DB
 STA T
 LDA L62EA
 SBC L62EB
 JSR sub_C4753
 STA L62E5
 LDA T
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
 STA T
 LDA L62EB,X
 STA U
 JSR sub_C4765
 STA U
 LDA T
 CLC
 ADC L62DA,X
 STA T
 LDY #&CD
 LDA U
 ADC L62EA,X
 JSR sub_C4753
 ASL T
 ROL A
 LDY L0078
 STA L62E6,Y
 LDA T
 STA L62D6,Y
 DEC L0078
 DEX
 DEX
 BPL C4832
 LDA L62E7
 STA L62FF
 RTS

\ ******************************************************************************
\
\       Name: sub_C486D
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C486D

 LDY L007F
 STA L0079
 JMP C4876

\ ******************************************************************************
\
\       Name: sub_C4874
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STA U
 LDY L007C
 BIT L0079
 BVS C48A7
 LDA T
 STA L62D0,Y
 LDA U
 STA L62E0,Y
 RTS

\ ******************************************************************************
\
\       Name: sub_C48A0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C48A0

 BMI C48A7
 JSR sub_C0E44
 STA U

.C48A7

 LDA L62D0,Y
 CLC
 ADC T
 STA L62D0,Y
 LDA L62E0,Y
 ADC U
 STA L62E0,Y
 RTS

\ ******************************************************************************
\
\       Name: sub_C48B9
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C48B9

 LDY #0
 LDA #8
 LDX #&C0
 BNE C48C7

\ ******************************************************************************
\
\       Name: sub_C48C1
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C48C1

 LDY #6
 LDA #3
 LDX #&40

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

\ ******************************************************************************
\
\       Name: sub_C48EF
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C48EF

 LDX #1
 LDY #2

.C48F3

 LDA #0
 STA V
 LDA L62D0,X
 STA T
 LDA L62E0,X
 BPL C4903
 DEC V

.C4903

 ASL T
 ROL A
 ROL V
 STA U
 LDA L62B1,Y
 ADC T
 STA L62B1,Y
 LDA L6280,Y
 ADC U
 STA L6280,Y
 LDA L6283,Y
 ADC V
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

\ ******************************************************************************
\
\       Name: sub_C4937
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4937

 LDX #2

.C4939

 LDA #0
 STA V
 LDA L62D3,X
 STA T
 LDA L62E3,X
 BPL C4949
 DEC V

.C4949

 LDY #3
 CPX #2
 BNE C4951
 LDY #5

.C4951

 ASL T
 ROL A
 ROL V
 DEY
 BNE C4951
 STA U
 LDA L62AE,X
 CLC
 ADC T
 STA L62AE,X
 LDA L62D0,X
 ADC U
 STA L62D0,X
 LDA L62E0,X
 ADC V
 STA L62E0,X
 DEX
 BPL C4939
 RTS

\ ******************************************************************************
\
\       Name: C4978
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

 LDA VIA+&68            \ user_via_t2c_l
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

 CMP #&2A
 BCC C49B9
 SEC
 SBC #&0C
 BCS C49BB

.C49B9

 LDA #&28

.C49BB

 STA T
 LDA VIA+&68            \ user_via_t2c_l
 AND #7
 CLC
 ADC T

.C49C5

 STA L003C
 STA L005A

.C49C9

 LDA #0
 JMP C4A87

\ ******************************************************************************
\
\       Name: sub_C49CE
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STA T
 LDA L0063
 ASL T
 ROL A
 PHP
 BMI C49EE
 ASL T
 ROL A

.C49EE

 STA U
 LDX L0040
 LDA L5A06,X
 JSR sub_C0C00
 ASL T
 ROL A
 PLP
 BPL C4A01
 ASL T
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
 AND #&3F
 CMP #&35
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
 CMP #&6C
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
 SBC #&42
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

 STA U
 LDA L5A0D,X
 JSR sub_C0C00

.C4A87

 STA L003D
 LDA L003C
 CLC
 ADC #&19
 STA L005F
 RTS

\ ******************************************************************************
\
\       Name: sub_C4A91
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4A91

 LDA L62D8
 STA T
 ORA L62E8
 PHP
 LDA L62E8
 JSR sub_C0E42
 LDY #5

.loop_C4AA2

 ASL T
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

 LDA T
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
 STA T
 LDA L62EA,X
 JSR sub_C3450
 CMP T
 BCC C4AE9
 LSR T
 JMP C4AEA

.C4AE9

 LSR A

.C4AEA

 CLC
 ADC T

.C4AED

 CMP L62AA,X
 BNE C4AF3
 CLC

.C4AF3

 ROR L62A6,X
 RTS

\ ******************************************************************************
\
\       Name: sub_C4AF7
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STA T
 LDA L62AC,X
 STX L0078
 JSR sub_C4B47
 JSR sub_C4B88
 BCS C4B41
 CMP L62AC,X
 BCC C4B3E
 LDA #0
 STA T
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

\ ******************************************************************************
\
\       Name: sub_C4B42
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4B42

 LDY L003E
 DEY
 BEQ C4B51

\ ******************************************************************************
\
\       Name: sub_C4B47
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4B47

 CMP L008F
 BCC C4B51
 LDA L008E
 STA T
 LDA L008F

.C4B51

 BIT L0079
 JSR sub_C0E40
 LDY L0078
 STA L62EA,Y
 LDA T
 STA L62DA,Y
 RTS

\ ******************************************************************************
\
\       Name: sub_C4B61
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C4B88
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

 STA U
 LDA L003F
 JSR sub_C0C00
 LDY L003E
 DEY
 BNE C4BCB
 LSR A
 ROR T

.C4BCB

 CLC
 RTS

.C4BCD

 SEC
 RTS

\ ******************************************************************************
\
\       Name: sub_C4BCF
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STA U
 LDX #0
 LDA L713D
 AND L7205
 STA W
 LDA L713D
 CMP #&FF
 BEQ C4C06
 LDA L7205
 CMP #&FF
 BNE C4C24

.C4C06

 LDA VIA+&68            \ user_via_t2c_l
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
 CMP #&35
 BCC C4C30
 LDA #&35

.C4C30

 STA U
 LDA L62A8,X
 JSR sub_C0C00
 BIT L62E9
 JSR sub_C3450
 CLC
 ADC L4C61,X
 LDY #&F3
 STY U
 LDY W
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

\ ******************************************************************************
\
\       Name: L4C61
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4C61

 EQUB &35, &35

\ ******************************************************************************
\
\       Name: L4C63
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4C63

 EQUB &19, &1A

\ ******************************************************************************
\
\       Name: sub_C4C65
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4C65

 LDA L0039
 JSR sub_C3450
 STA U
 CMP L0063
 BCS C4C72
 LDA L0063

.C4C72

 LDY L005D
 BEQ C4C77
 ASL A

.C4C77

 STA W
 JSR sub_C0C00
 STA U
 LDY #6
 LDA L0039
 JSR sub_C48A0
 LDA L0063
 STA U
 LDA L62F1
 JSR sub_C0C00
 CLC
 ADC #8
 STA V
 LDA W
 STA U
 JSR sub_C0DBF
 LDY #7
 LDA L62E9
 JSR sub_C48A0
 RTS

\ ******************************************************************************
\
\       Name: sub_C4CA4
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4CA4

 LDX L006F
 LDY L06E8,X
 LDA trackData,Y
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
 STY W
 LDA trackData+224,X
 JSR sub_C4D21
 LDY #4
 LDA trackData+240,X
 JSR sub_C4D21
 LDY #2
 LDA trackData+208,X
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
 CMP #&40
 BCC C4D09
 LDY L0045
 STY L62F9

.C4D09

 LDY #&25
 CMP #&6E
 BCC C4D11
 LDY #&50

.C4D11

 LDA #&17
 STA L0042
 JSR sub_C2AB3
 LDY #6
 JSR sub_C2287
 JSR sub_C2A76
 RTS

\ ******************************************************************************
\
\       Name: sub_C4D21
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4D21

 PHA
 LDA #0
 STA T
 STA V
 PLA
 BPL C4D2D
 DEC V

.C4D2D

 LSR V
 ROR A
 ROR T
 DEY
 BNE C4D2D
 STA U
 LDY W
 DEC W
 LDA L6280,Y
 SEC
 SBC T
 STA L6286,Y
 LDA L6283,Y
 SBC U
 STA L6289,Y
 RTS

\ ******************************************************************************
\
\       Name: sub_C4D4D
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 STA setp1+2,X
 STA L39E4,X
 STA L04F0,X
 TXA
 BNE loop_C4D55
 RTS

\ ******************************************************************************
\
\       Name: sub_C4D70
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4D70

 LDA #&21
 BNE C4D76

\ ******************************************************************************
\
\       Name: sub_C4D74
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4D74

 LDA #&18

.C4D76

 STA L62CD

 LDA #1                 \ Set L62CC = 1
 STA L62CC

\ ******************************************************************************
\
\       Name: PrintToken
\       Type: Subroutine
\   Category: Text
\    Summary: Print a recursive token
\
\ ------------------------------------------------------------------------------
\
\ Addresses of token strings are in the (tokenHi tokenLo) table.
\
\ Arguments:
\
\   X                   The token number (0 to 54)
\
\ ******************************************************************************

.PrintToken

 LDY #0                 \ We are about to work our way through the token, one
                        \ byte at a time, so set a byte counter in Y

.toke1

 LDA tokenHi,X          \ Set (S R) = the X-th entry in (tokenHi tokenLo), which
 STA S                  \ points to the string of bytes in token X
 LDA tokenLo,X
 STA R

.toke2

 LDA (R),Y              \ Set A to the Y-th byte at (S R), which contains the
                        \ next character in the token

 CMP #255               \ If A = 255 then we have reached the end of the token,
 BEQ toke8              \ so jump to toke8 to return from the subroutine

 CMP #200               \ If A < 200 then this byte is not another token, so
 BCC toke5              \ jump to toke5

 SEC                    \ A >= 200, so this is a pointer to another token
 SBC #200               \ embedded in the current token, so subtract 200 to get
                        \ the embedded token's number

 STA T                  \ Store the embedded token's number in T

 TXA                    \ Store X and Y on the stack so we can retrieve them
 PHA                    \ after printing the embedded token
 TYA
 PHA

 LDX T                  \ Set X to the number of the embedded token we need to
                        \ print

 CPX #54                \ If X <> 54, jump to toke3 to skip the following three
 BNE toke3              \ instructions and print the embedded token

 LDX #0                 \ X = 54, so ???
 JSR sub_C41D0

 JMP toke4              \ Skip the following instruction

.toke3

 JSR PrintToken         \ Print the embedded token in X recursively (so if it
                        \ also contains embedded tokens, they will also be
                        \ expanded and printed)

.toke4

 PLA                    \ Retrieve X and Y from the stack
 TAY
 PLA
 TAX

 INY                    \ Increment the byte counter

 JMP toke1              \ Loop back to print the next byte in the token, making
                        \ sure to recalculate (S R) as it will have been
                        \ corrupted by the call to PrintToken

.toke5

                        \ If we get here then A < 200, so this byte is not
                        \ another token

 CMP #160               \ If A < 160, jump to toke6 to skip the following three
 BCC toke6              \ instructions

 SBC #160               \ A is in the range 160 to 199, so subtract 160 to get
                        \ the range 0 to 39

 JSR sub_C3D50          \ Print token 160-199 ???

 BEQ toke7              \ Skip the following instruction (this BNE is
                        \ effectively a JMP as sub_C3D50 sets the Z flag)

.toke6

 JSR PrintCharacter     \ Print character 0-159 ???

.toke7

 INY                    \ Increment the byte counter

 JMP toke2              \ Loop back to print the next byte in the token

.toke8

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: sub_C4DC9
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4DC9

 LDA L0063

\ ******************************************************************************
\
\       Name: sub_C4DCB
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4DCB

 LSR A
 STA L0026
 LSR A
 STA L0028
 INC L002D
 SEC
 ROR L62D2
 LDA #4
 JSR sub_C0B47
 RTS

\ ******************************************************************************
\
\       Name: sub_C4DDD
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4DDD

 SEI
 LDX #&0D

.loop_C4DE0

 STX VIA+&00            \ crtc_horz_total
 LDA L4F0F,X
 STA VIA+&01            \ crtc_horz_displayed
 DEX
 BPL loop_C4DE0
 DEX
 STX L4F43
 CLI
 LDA #154               \ osbyte_write_video_ula_control
 LDX #&C4
 JSR OSBYTE
 CLC
 LDA #7

.loop_C4DFB

 STA VIA+&21            \ video_ula_palette
 ADC #&10
 BCC loop_C4DFB
 SEI
 LDA IRQ1V
 STA L4F1D
 LDA IRQ1V+1
 STA L4F1E
 LDA #2

.loop_C4E11

 BIT VIA+&4D            \ system_via_ifr
 BEQ loop_C4E11
 LDA #&40
 STA VIA+&6B            \ user_via_acr
 ORA VIA+&4B            \ system_via_acr
 STA VIA+&4B            \ system_via_acr
 LDA #&C0
 STA VIA+&6E            \ user_via_ier
 STA VIA+&4E            \ system_via_ier
 LDA #&D4
 STA VIA+&64            \ user_via_t1c_l
 LDA #&11
 STA VIA+&65            \ user_via_t1c_h
 LDA #1
 STA VIA+&46            \ system_via_t1l_l
 LDA #&3D
 STA VIA+&45            \ system_via_t1c_h
 LDA #&1E
 STA VIA+&46            \ system_via_t1l_l
 STA VIA+&66            \ user_via_t1l_l
 LDA #&4E
 STA VIA+&47            \ system_via_t1l_h
 STA VIA+&67            \ user_via_t1l_h
 LDA #&4E
 STA IRQ1V+1
 LDA #&5C
 STA IRQ1V
 CLI
 RTS

\ ******************************************************************************
\
\       Name: loop_C4E59
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.loop_C4E59

 JMP (L4F1D)

 LDA VIA+&6D            \ user_via_ifr
 AND #&40
 BEQ loop_C4E59
 STA VIA+&6D            \ user_via_ifr
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
 STA VIA+&20            \ video_ula_control
 LDX #&0F

.loop_C4E83

 LDA L3468,X
 STA VIA+&21            \ video_ula_palette
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
 STA VIA+&20            \ video_ula_control
 CLC
 LDA #3

.loop_C4EA3

 STA VIA+&21            \ video_ula_palette
 ADC #&10
 BCC loop_C4EA3
 LDA #&3C
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
 STA VIA+&21            \ video_ula_palette
 DEX
 BPL loop_C4EC5
 LDA L4F21
 LDX L4F22
 BNE C4F01

.C4ED6

 LDX #3

.loop_C4ED8

 LDA L3478,X
 STA VIA+&21            \ video_ula_palette
 DEX
 BPL loop_C4ED8
 LDA #0
 LDX #&1E
 BNE C4F01

.C4EE7

 LDX #3

.loop_C4EE9

 LDA L347C,X
 STA VIA+&21            \ video_ula_palette
 DEX
 BPL loop_C4EE9
 STX L4F43
 JSR sub_C52A4
 LDA #&FF
 STA VIA+&69            \ user_via_t2c_h
 LDA #&16
 LDX #&0B

.C4F01

 STX VIA+&67            \ user_via_t1l_h
 STA VIA+&66            \ user_via_t1l_l
 INC L4F43

.C4F0A

 PLA
 TAX
 LDA &FC
 RTI

\ ******************************************************************************
\
\       Name: L4F0F
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4F0F

 EQUB &3F, &28, &31, &24, &26, &00, &1A, &20, &01, &07, &67, &08
 EQUB &0B, &50

\ ******************************************************************************
\
\       Name: L4F1D
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4F1D

 EQUB 0

\ ******************************************************************************
\
\       Name: L4F1E
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4F1E

 EQUB 0

\ ******************************************************************************
\
\       Name: L4F1F
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4F1F

 EQUB &D8

\ ******************************************************************************
\
\       Name: L4F20
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4F20

 EQUB 4

\ ******************************************************************************
\
\       Name: L4F21
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4F21

 EQUB &64

\ ******************************************************************************
\
\       Name: L4F22
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4F22

 EQUB &10

\ ******************************************************************************
\
\       Name: sub_C4F23
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4F23

 SEI
 LDA L4F1D
 STA IRQ1V
 LDA L4F1E
 STA IRQ1V+1
 LDA #&40
 STA VIA+&6E            \ user_via_ier
 CLI
 JSR sub_C43F6

\ ******************************************************************************
\
\       Name: SetScreenMode7
\       Type: Subroutine
\   Category: Setup
\    Summary: Change to screen mode 7 and hide the cursor
\
\ ******************************************************************************

.SetScreenMode7

 LDA #128               \ Set printMode = 128 so the call to PrintToken prints
 STA printMode          \ characters using OSWRCH (for mode 7)

 LDX #46                \ Print token 46, which changes to screen mode 7 and
 JSR PrintToken         \ hides the cursor

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: L4F43
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4F43

 EQUB 0

\ ******************************************************************************
\
\       Name: sub_C4F44
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C4F44

 LDA #&3C
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
 STA U
 LDA #0
 ROR U
 ROR A
 PLP
 ROR U
 ROR A
 SEI
 CLC
 ADC #&D8
 STA L4F1F
 LDA #4
 ADC U
 STA L4F20
 CLI
 RTS

\ ******************************************************************************
\
\       Name: sub_C4F77
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 LDA #&50
 STA L000F

.C4FB7

 SED
 SEC
 LDA L06B4
 SBC L0898,X
 STA T
 LDA L06CC
 SBC L08AC,X
 BCS C4FCC
 ADC #&60
 CLC

.C4FCC

 STA U
 LDA L06E4
 SBC L04DC,X
 STA L0079
 BCC C4FFB
 SEC
 LDA T
 SBC L06A0,X
 LDA U
 SBC L06B8,X
 LDA L0079
 SBC L06D0,X
 BCS C4FFB
 LDA T
 AND #&F0
 STA L06A0,X
 LDA U
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

 NOP
 NOP

\ ******************************************************************************
\
\       Name: sub_C5011
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C5011

 LDA #0
 STA L06B4,X
 STA L06CC,X
 STA L06E4,X
 RTS

\ ******************************************************************************
\
\       Name: sub_C501D
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C501D

 LDX #&20
 STX L62CC
 INX
 STX L62CD
 LDX L006F
 LDA #&26
 JSR L7B9C

\ ******************************************************************************
\
\       Name: sub_C502D
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C502D

 LDA #&28

\ ******************************************************************************
\
\       Name: sub_C502F
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C502F

 LDX #&0A
 STX L62CC
 LDX #&21
 STX L62CD
 LDX #&15
 JSR L7B9C
 RTS

\ ******************************************************************************
\
\       Name: sub_C503F
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C503F

 LDA #128               \ osbyte_read_adc_or_get_buffer_status
 JSR OSBYTE
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

\ ******************************************************************************
\
\       Name: sub_C5052
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C507E
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C507E

 DEX
 BPL C5083
 LDX #&13

.C5083

 RTS

\ ******************************************************************************
\
\       Name: sub_C5084
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C5084

 INX
 CPX #&14
 BCC C508B
 LDX #0

.C508B

 RTS

\ ******************************************************************************
\
\       Name: sub_C508C
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C508C

 STA L62C3
 JMP char1

\ ******************************************************************************
\
\       Name: PrintCharacter
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character on-screen
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   Character number (0 to 159)
\
\   printMode           Bit 7 determines how the character is printed on-screen:
\
\                         * 0 = poke the character directly into screen memory
\
\                         * 1 = print the character with OSWRCH (for mode 7)
\
\   (Q P)               The screen address to print the character when bit 7 of
\                       printMode is clear
\
\ ******************************************************************************

.PrintCharacter

 BIT printMode          \ If bit 7 of printMode is set, jump to char8 to print
 BMI char8              \ the character in A with OSWRCH

 STA L62C3

 LDA #0
 STA W

.char1

 TXA
 PHA
 TYA
 PHA

 LDY #HI(L62C3)
 LDX #LO(L62C3)
 LDA #10                \ Read definition of char in L62C3 into L62C3+1..8
 JSR OSWORD

 LDA W
 BEQ char5
 LDX #8

.char2

 LDA L62C3,X
 BIT W
 BMI char3
 AND #&F0
 JMP char4

.char3

 ASL A
 ASL A
 ASL A
 ASL A

.char4

 STA L62C3,X
 DEX
 BNE char2

.char5

 LDY L62CD
 LDA L62CC
 JSR sub_C50FA
 LDX #8

.char6

 LDA L62C3,X
 STA (P),Y
 DEY
 BPL char7
 LDA P
 SEC
 SBC #&40
 STA P
 LDA Q
 SBC #1
 STA Q
 LDY #7

.char7

 DEX

 BNE char6

 INC L62CC

 PLA
 TAY
 PLA
 TAX

 LDA L62C3

 RTS                    \ Return from the subroutine

.char8

 JSR OSWRCH             \ Print the character in A

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: sub_C50FA
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C50FA

 ASL A
 ASL A

\ ******************************************************************************
\
\       Name: sub_C50FC
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C511E
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C513A
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C513A

 JSR sub_C511E
 JSR sub_C51A8
 LDA L62A2
 STA T
 LSR A
 PHP
 LDA #2
 BCS C514D
 LDA #5

.C514D

 STA V
 LDA L62A5
 ASL T
 ROL A
 BCS C515F
 CMP #&26
 BCC C5170
 CMP #&3D
 BCC C5161

.C515F

 LDA #&3C

.C5161

 EOR #&FF
 ADC #&4C
 TAY
 STY T
 LDX L3980,Y
 STX L0083
 JMP C517E

.C5170

 TAX
 STX T
 LDA V
 EOR #1
 STA V
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
 ADC #&50
 STA W
 AND #&FC
 JSR sub_C50FC
 LDA W
 ASL A
 AND #7
 STA W
 LDA #4
 STA L0079
 LDA #6
 STA U
 JSR sub_C5204
 RTS

\ ******************************************************************************
\
\       Name: sub_C51A8
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C51A8

 LDA #0
 STA L0079
 LDA L003C
 CMP #&1E
 BCS C51B4
 LDA #&1E

.C51B4

 STA T
 LSR A
 CLC
 ADC T
 ROR A
 SEC
 SBC #&4C
 BCS C51C2
 ADC #&98

.C51C2

 LDX #&FF
 SEC

.loop_C51C5

 INX
 SBC #&26
 BCS loop_C51C5
 ADC #&26
 CMP #&13
 BCC C51D8
 SBC #&13
 EOR #&FF
 CLC
 ADC #&14
 SEC

.C51D8

 TAY
 STY T
 TXA
 AND #3
 TAX
 TXA
 ROL A
 STA V
 AND #&FC
 BEQ C51E9
 LDA #7

.C51E9

 STA W
 LDA L3100,Y
 STA L0083
 STA U
 LDA L32FC,X
 AND #&F8
 STA P
 LDA L32FC,X
 AND #7
 TAY
 LDA L397C,X
 STA Q

\ ******************************************************************************
\
\       Name: sub_C5204
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C5204

 LDX V
 LDA L3B86,X
 STA C5220
 LDA L3B8E,X
 STA C529B
 LDX W
 LDA #0
 SEC
 SBC L0083
 CLC

.C521A

 ADC T
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
 STA V
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

 STX W
 LDX L0069
 TYA
 BPL C5267
 LDA P
 SEC
 SBC #&40
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
 ADC #&40
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
 LDX V
 AND L3FE8,X
 ORA L34F8,X
 STA (P),Y
 LDX W
 LDA L008A
 CLC

.C529B

 INX
 DEC U
 BMI C52A3
 JMP C521A

.C52A3

 RTS

\ ******************************************************************************
\
\       Name: sub_C52A4
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C52A4

 INC L62F7
 LDA L0063
 CLC
 ADC #&30
 ADC L62FA
 STA L62FA
 BCC C52F5
 LDA L0000
 BEQ C52F5
 LDX #4

.C52BA

 LDA L6FC0,X
 EOR L52F6,X
 STA L6FC0,X
 LDA L70F8,X
 EOR L52FB,X
 STA L70F8,X
 CPX #3
 BCS C52E2
 LDA L6E85,X
 EOR #&F0
 STA L6E85,X
 LDA L6FBD,X
 EOR #&F0
 STA L6FBD,X
 BNE C52F2

.C52E2

 LDA L6E8A,X
 EOR #&C0
 STA L6E8A,X
 LDA L6FB2,X
 EOR #&30
 STA L6FB2,X

.C52F2

 DEX
 BPL C52BA

.C52F5

 RTS

\ ******************************************************************************
\
\       Name: L52F6
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L52F6

 EQUB &F0, &F0, &C0, &C0, &80

\ ******************************************************************************
\
\       Name: L52FB
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L52FB

 EQUB &F0, &F0, &30, &30, &10

\ ******************************************************************************
\
\       Name: trackData
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.trackData

 SKIP 1610

\ ******************************************************************************
\
\       Name: L594A
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L594A

INCBIN "1-source-files/images/dashboard2.bin"

 SKIP 67

\ ******************************************************************************
\
\       Name: L59D0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L59D0

 EQUB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
 EQUB 0, 0, 0, 0, 0

\ ******************************************************************************
\
\       Name: L59EA
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L59EA

 EQUB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

\ ******************************************************************************
\
\       Name: L59FA
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L59FA

 EQUB 0

\ ******************************************************************************
\
\       Name: L59FB
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L59FB

 EQUB 0

\ ******************************************************************************
\
\       Name: L59FC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L59FC

 EQUB 0

\ ******************************************************************************
\
\       Name: L59FD
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L59FD

 EQUB 0

\ ******************************************************************************
\
\       Name: L59FE
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L59FE

 EQUB 0

\ ******************************************************************************
\
\       Name: L59FF
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L59FF

 EQUB 0

\ ******************************************************************************
\
\       Name: L5A00
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5A00

 EQUB 0, 0, 0

\ ******************************************************************************
\
\       Name: L5A03
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5A03

 EQUB 0, 0, 0

\ ******************************************************************************
\
\       Name: L5A06
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5A06

 EQUB 0, 0, 0, 0, 0, 0, 0

\ ******************************************************************************
\
\       Name: L5A0D
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5A0D

 EQUB 0, 0, 0, 0, 0, 0, 0

\ ******************************************************************************
\
\       Name: L5A14
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5A14

 EQUB 0, 0, 0

\ ******************************************************************************
\
\       Name: L5A17
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5A17

 EQUB 0

\ ******************************************************************************
\
\       Name: L5A18
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5A18

 EQUB 0

\ ******************************************************************************
\
\       Name: L5A19
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5A19

 EQUB 0

\ ******************************************************************************
\
\       Name: L5A1A
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5A1A

 EQUB 0, 0, 0, 0, 0, 0, 0, 0

\ ******************************************************************************
\
\       Name: sub_C5A22
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C5A22

 BRK
 EQUB 0, 0

\ ******************************************************************************
\
\       Name: sub_C5A25
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C5A25

 LDA #0
 STA SetupGame+40,X
 STA L39F8,X
 STA U
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

 STA U
 LDA L5F38
 JSR sub_C0C00
 STA U
 JMP C5A61

.C5A5A

 LDA L5F38
 BNE C5A5F

.C5A5F

 STA T

.C5A61

 SED

.C5A62

 LDA L3DF7,X
 CLC
 ADC SetupGame+40,X
 STA SetupGame+40,X
 LDA L39F8,X
 ADC #0
 STA L39F8,X
 DEC T
 BNE C5A62
 DEC U
 BPL C5A62
 JSR sub_C6698
 RTS

ORG &5FD0

\ ******************************************************************************
\
\       Name: L5FD0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5FD0

 EQUB &00, &88, &CC, &EE, &0F, &8F, &CF, &EF, &F0, &F8, &FC, &FE
 EQUB &00, &08, &0C, &0E, &00, &80, &C0, &E0, &0F, &07, &03, &01
 EQUB &F0, &70, &30, &10, &FF, &77, &33, &11, &FF, &7F, &3F, &1F
 EQUB &FF, &F7, &F3, &F1

\ ******************************************************************************
\
\       Name: L5FF8
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5FF8

 EQUB &03, &60

\ ******************************************************************************
\
\       Name: L5FFA
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5FFA

 EQUB &30

\ ******************************************************************************
\
\       Name: L5FFB
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5FFB

 EQUB &18

\ ******************************************************************************
\
\       Name: L5FFC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5FFC

 EQUB &0C

\ ******************************************************************************
\
\       Name: L5FFD
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5FFD

 EQUB 6

\ ******************************************************************************
\
\       Name: L5FFE
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5FFE

 EQUB 3

\ ******************************************************************************
\
\       Name: L5FFF
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5FFF

 EQUB &01, &00, &01, &02, &03, &04, &05, &06, &07, &08, &09, &0A
 EQUB &0B, &0C, &0D, &0E, &0F, &10, &11, &12, &13, &14, &15, &16
 EQUB &17, &18, &19, &1A, &1B, &1C, &1D, &1E, &1F, &20, &21, &22
 EQUB &23, &24, &25, &26, &27, &28, &29, &2A, &2B, &2C, &2D, &2E
 EQUB &2F, &30, &31, &32, &33, &34, &35, &36, &37, &38, &39, &3A
 EQUB &3B, &3C, &3D, &3E, &3F, &40, &41, &42, &43, &44, &45, &46
 EQUB &47, &48, &49, &4A, &4B, &4C, &4D, &4E, &4F, &50, &51, &52
 EQUB &53, &54, &00, &56, &57, &58, &59, &5A, &5B, &5C, &5D, &5E
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

\ ******************************************************************************
\
\       Name: L6100
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L6100

 EQUB &00, &01, &03, &04, &05, &06, &08, &09, &0A, &0B, &0D, &0E
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

\ ******************************************************************************
\
\       Name: L6180
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: L6280
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L6280

 EQUB 0

\ ******************************************************************************
\
\       Name: L6281
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L6281

 EQUB 0

\ ******************************************************************************
\
\       Name: L6282
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L6282

 EQUB 0

\ ******************************************************************************
\
\       Name: L6283
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L6283

 EQUB 0

\ ******************************************************************************
\
\       Name: L6284
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L6284

 EQUB 0

\ ******************************************************************************
\
\       Name: L6285
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L6285

 EQUB 0

\ ******************************************************************************
\
\       Name: L6286
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L6286

 EQUB 0, 0, 0

\ ******************************************************************************
\
\       Name: L6289
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L6289

 EQUB 0, 0, 0, 0, 0, 0

\ ******************************************************************************
\
\       Name: L628F
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L628F

 EQUB 0

\ ******************************************************************************
\
\       Name: L6290
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L6290

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L6292
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L6292

 EQUB 0

\ ******************************************************************************
\
\       Name: L6293
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L6293

 EQUB 0, 0, 0, 0, 0, 0

\ ******************************************************************************
\
\       Name: L6299
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L6299

 EQUB 0, 0, 0

\ ******************************************************************************
\
\       Name: L629C
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L629C

 EQUB 0, 0, 0, 0

\ ******************************************************************************
\
\       Name: L62A0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62A0

 EQUB 0

\ ******************************************************************************
\
\       Name: L62A1
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62A1

 EQUB 0

\ ******************************************************************************
\
\       Name: L62A2
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62A2

 EQUB 0

\ ******************************************************************************
\
\       Name: L62A3
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62A3

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62A5
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62A5

 EQUB 0

\ ******************************************************************************
\
\       Name: L62A6
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62A6

 EQUB 0

\ ******************************************************************************
\
\       Name: L62A7
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62A7

 EQUB 0

\ ******************************************************************************
\
\       Name: L62A8
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62A8

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62AA
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62AA

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62AC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62AC

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62AE
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62AE

 EQUB 0, 0, 0

\ ******************************************************************************
\
\       Name: L62B1
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62B1

 EQUB 0, 0, 0

\ ******************************************************************************
\
\       Name: L62B4
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62B4

 EQUB 0, 0, 0

\ ******************************************************************************
\
\       Name: L62B7
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62B7

 EQUB 0, 0, 0

\ ******************************************************************************
\
\       Name: L62BA
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62BA

 EQUB 0, 0, 0

\ ******************************************************************************
\
\       Name: L62BD
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62BD

 EQUB 0, 0, 0

\ ******************************************************************************
\
\       Name: L62C0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62C0

 EQUB 0, 0, 0

\ ******************************************************************************
\
\       Name: L62C3
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62C3

 EQUB 0, 0, 0, 0, 0, 0, 0, 0, 0

\ ******************************************************************************
\
\       Name: L62CC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62CC

 EQUB 0

\ ******************************************************************************
\
\       Name: L62CD
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62CD

 EQUB 0, 0, 0

\ ******************************************************************************
\
\       Name: L62D0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D0

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62D2
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D2

 EQUB 0

\ ******************************************************************************
\
\       Name: L62D3
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D3

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62D5
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D5

 EQUB 0

\ ******************************************************************************
\
\       Name: L62D6
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D6

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62D8
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D8

 EQUB 0

\ ******************************************************************************
\
\       Name: L62D9
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D9

 EQUB 0

\ ******************************************************************************
\
\       Name: L62DA
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62DA

 EQUB 0

\ ******************************************************************************
\
\       Name: L62DB
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62DB

 EQUB 0

\ ******************************************************************************
\
\       Name: L62DC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62DC

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62DE
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62DE

 EQUB 0

\ ******************************************************************************
\
\       Name: L62DF
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62DF

 EQUB 0

\ ******************************************************************************
\
\       Name: L62E0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E0

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62E2
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E2

 EQUB 0

\ ******************************************************************************
\
\       Name: L62E3
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E3

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62E5
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E5

 EQUB 0

\ ******************************************************************************
\
\       Name: L62E6
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E6

 EQUB 0

\ ******************************************************************************
\
\       Name: L62E7
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E7

 EQUB 0

\ ******************************************************************************
\
\       Name: L62E8
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E8

 EQUB 0

\ ******************************************************************************
\
\       Name: L62E9
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E9

 EQUB 0

\ ******************************************************************************
\
\       Name: L62EA
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62EA

 EQUB 0

\ ******************************************************************************
\
\       Name: L62EB
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62EB

 EQUB 0

\ ******************************************************************************
\
\       Name: L62EC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62EC

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62EE
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62EE

 EQUB 0

\ ******************************************************************************
\
\       Name: L62EF
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62EF

 EQUB 0

\ ******************************************************************************
\
\       Name: L62F0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62F0

 EQUB 0

\ ******************************************************************************
\
\       Name: L62F1
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62F1

 EQUB 0

\ ******************************************************************************
\
\       Name: L62F2
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62F2

 EQUB 0

\ ******************************************************************************
\
\       Name: L62F3
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62F3

 EQUB 0

\ ******************************************************************************
\
\       Name: L62F4
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62F4

 EQUB 0

\ ******************************************************************************
\
\       Name: L62F5
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62F5

 EQUB 0

\ ******************************************************************************
\
\       Name: L62F6
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62F6

 EQUB 0

\ ******************************************************************************
\
\       Name: L62F7
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62F7

 EQUB 0

\ ******************************************************************************
\
\       Name: L62F8
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62F8

 EQUB 0

\ ******************************************************************************
\
\       Name: L62F9
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62F9

 EQUB 0

\ ******************************************************************************
\
\       Name: L62FA
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62FA

 EQUB 0

\ ******************************************************************************
\
\       Name: L62FB
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62FB

 EQUB 0

\ ******************************************************************************
\
\       Name: L62FC
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62FC

 EQUB 0

\ ******************************************************************************
\
\       Name: L62FD
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62FD

 EQUB 0

\ ******************************************************************************
\
\       Name: L62FE
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62FE

 EQUB 0

\ ******************************************************************************
\
\       Name: L62FF
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62FF

 EQUB 0

\ ******************************************************************************
\
\       Name: sub_C6300
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C6300

 STA P
 STY Q
 STX W
 LDA #2                 \ osbyte_select_input_stream
 LDX #0
 JSR OSBYTE
 LDA #21                \ osbyte_flush_buffer
 LDX #0
 JSR OSBYTE

.loop_C6314

 LDY #0

.C6316

 JSR OSRDCH
 BCS C6345
 CMP #&0D
 BEQ C6352
 CMP #&20
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

 CPY W
 BNE C633C
 LDA #7
 BNE C633F

.C633C

 STA (P),Y
 INY

.C633F

 JSR OSWRCH
 JMP C6316

.C6345

 TYA
 PHA
 LDA #126               \ osbyte_acknowledge_escape
 JSR OSBYTE
 PLA
 TAY
 JMP C6316

.loop_C6351

 INY

.C6352

 CPY W
 BNE C6357
 RTS

.C6357

 LDA #&20
 STA (P),Y
 BNE loop_C6351

\ ******************************************************************************
\
\       Name: sub_C635D
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C635D

 LDX L004A
 LDA VIA+&68            \ user_via_t2c_l
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
 STA T
 LDY L5F3A
 DEY
 BEQ C6395
 BPL C6392
 ASL A
 JMP C6395

.C6392

 ROL T
 ROR A

.C6395

 CLC
 ADC L5F40
 STA L0128,X
 JSR sub_C507E
 STX L004A
 RTS

\ ******************************************************************************
\
\       Name: sub_C63A2
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: Protect
\       Type: Subroutine
\   Category: Setup
\    Summary: Decrypt the game code (disabled)
\
\ ******************************************************************************

.Protect

 JMP SetupGame          \ Jump to SetupGame to continue setting up the game

 NOP                    \ Presumably this contained some kind of copy protection
 NOP                    \ or decryption code that has been replaced by NOPs in
 NOP                    \ this unprotected version of the game
 NOP
 NOP

\ ******************************************************************************
\
\       Name: sub_C63C5
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: StartGame
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.StartGame

 LDX #0
 STX L05F4
 JSR sub_C4D4D
 LDX #4
 JSR sub_C41D0
 JSR sub_C3A50
 LDX #&27
 JSR PrintToken
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
 JSR PrintToken
 LDX #3
 JSR sub_C6571
 STX L5F3A
 JSR sub_C44C6

.C641F

 LDX #&16
 JSR PrintToken
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
 JSR PrintToken
 JSR sub_C66D4
 JSR sub_C655A
 LDX L006F
 BEQ C6474
 LDX #&1B
 JSR PrintToken
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
 JSR PrintToken
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
 JSR PrintToken
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
 LDA #&40
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

\ ******************************************************************************
\
\       Name: sub_C655A
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C655A

 LDA #&28

\ ******************************************************************************
\
\       Name: sub_C655C
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: sub_C6571
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C6571

 LDY #0
 STY W
 STX U

.C6577

 JSR sub_C3261
 LDY U

.loop_C657C

 STY V
 LDX L39E0,Y
 JSR sub_C0E50
 BEQ C658D
 LDY V
 DEY
 BPL loop_C657C
 BMI C6577

.C658D

 LDY V
 BNE C659E
 LDA W
 BEQ C6577
 LDA #&98
 STA L7FC5
 LDX L0078
 DEX
 RTS

.C659E

 STY L0078
 LDA W
 BNE C65AB
 LDX #&1E
 STX W
 JSR PrintToken

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
 ADC #&50
 TAX
 INY
 CPY U
 BCC C65AF
 BEQ C65AF
 BNE C6577

\ ******************************************************************************
\
\       Name: sub_C65C8
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C65C8

 CMP #&0A
 BCC C65CE
 ADC #5

.C65CE

 SED
 ADC #1
 CLD
 RTS

\ ******************************************************************************
\
\       Name: sub_C65D3
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 LDX #&20
 JSR PrintToken
 LDY L001B
 LDA L0100,Y
 BIT L006C
 BMI C65F5
 TYA

.C65F5

 JSR sub_C65C8
 JSR sub_C37D6
 LDX #&1F
 JSR PrintToken
 LDY L001B
 JSR sub_C667B
 LDX #&1F
 JSR PrintToken
 LDX L0045
 PLA
 PHA
 BNE C6618
 LDA #&26
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

 LDA #&28
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
 JSR OSWRCH
 LDA L006C
 BPL C666E
 LDX #&31
 JSR PrintToken
 JSR sub_C3C6F
 LDA L5F3F
 CLC
 ADC #&DA
 STA L3C7D
 LDX #&32
 JSR PrintToken

.C666E

 PLA
 JSR sub_C34D2
 RTS

\ ******************************************************************************
\
\       Name: sub_C6673
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C6673

 STA L62CD
 LDA #&1B
 STA L62CC

\ ******************************************************************************
\
\       Name: sub_C667B
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C667B

 LDX L013C,Y
 STX L0045
 JSR sub_C3CEB
 JSR sub_C3250
 RTS

\ ******************************************************************************
\
\       Name: sub_C6687
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C6687

 LDX #&1D
 JSR PrintToken
 LDX L006F
 JSR sub_C3CEB
 JSR sub_C3250
 JSR sub_C34D0
 RTS

\ ******************************************************************************
\
\       Name: sub_C6698
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C6698

 SED
 LDA setp1+2,Y
 CLC
 ADC SetupGame+40,X
 STA setp1+2,Y
 LDA L39E4,Y
 ADC L39F8,X
 STA L39E4,Y
 LDA L04F0,Y
 ADC #0
 STA L04F0,Y
 CLD
 RTS

\ ******************************************************************************
\
\       Name: sub_C66B6
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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
 LDX #&4F
 LDA #0

.loop_C66CD

 STA L5F60,X
 DEX
 BPL loop_C66CD
 RTS

\ ******************************************************************************
\
\       Name: sub_C66D4
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C66D4

 LDX L006F
 JSR sub_C3CEB
 LDX #&0C
 JSR sub_C6300
 RTS

\ ******************************************************************************
\
\       Name: sub_C66DF
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

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

\ ******************************************************************************
\
\       Name: dashboard
\       Type: Variable
\   Category: Dashboard
\    Summary: Dashboard image
\
\ ------------------------------------------------------------------------------
\
\ The dashboard image from &6C00 to &7724 in memory is sliced up and spread
\ throughout the game binary:
\
\   * &6C00-&6FFF is at &6C00-&6FFF in file - very top of dashboard
\   * &7000-&70DA is at &1500-&15DA in file - top section of steering wheel
\   * &70DB-&7724 is at &5300-&5949 in file - middle section of dashboard
\
\ The bottom of the dashboard appears to be spread around even more.
\
\ There is a also a segment of tyre at &7725-&7768.
\
\ ******************************************************************************

ORG &6C00

.L6C00

INCBIN "1-source-files/images/dashboard1.bin"

\ ******************************************************************************
\
\ Save Revs.bin
\
\ ******************************************************************************

\ We now move all the game code from where it runs (i.e. where it's been
\ assembled by the above source code) to its position in the game binary file
\
\ So the following commands move blocks of code from the address when the game
\ is running, to the address within the binary game file
\
\ This is effectively the reverse of the Entry, SwapCode and MoveCode routines;
\ they unpack the code from the game binary into memory, while the following
\ does the opposite and packs the code from memory into the game binary

COPYBLOCK &5FD0, &6700, &64D0   \ &5FD0-&66FF to &64D0-&6BFF
COPYBLOCK &0D00, &16DC, &5A80   \ &0D00-&16DB to &5A80-&645B
COPYBLOCK &7000, &70DB, &1500   \ &7000-&70DA to &1500-&15DA
COPYBLOCK &70DB, &7725, &5300   \ &70DB-&7724 to &5300-&5949
COPYBLOCK &0B00, &0D00, &1300   \ &0B00-&0CFF to &1300-&14FF
COPYBLOCK &7900, &7A00, &1200   \ &7900-&79FF to &1200-&12FF
CLEAR &645C, &64D0              \ Reset &645C-&64CF to zero

\ The second COPYBLOCK above moves code out of &0D00-&16DB
\
\ This vacated block then gets filled by further COPYBLOCK commands that copy
\ code into &1200-&12FF, &1300-&14FF and &1500-&15DA
\
\ We are going to save the binary file from address &1200 onwards, as that's
\ where the game binary loads, so we can ignore anything before &1200, but this
\ still leaves a gap at &15DB-&16DB which has had code assembled into it, but
\ that code has been moved elsewhere as part of the binary file packing process
\
\ In the original game binary this block contains background noise from the
\ compilation process, which doesn't have any effect on the game, but if we want
\ to assemble a file that matches the original game binary, we need to put this
\ noise back, as follows

ORG &15DB
CLEAR &15DB, &16DC

 EQUB &20, &00, &63, &60, &A6, &03, &10, &03, &20, &CB, &2A, &20
 EQUB &84, &50, &E4, &4D, &D0, &F6, &A2, &16, &86, &45, &20, &D1
 EQUB &2A, &CA, &E0, &14, &B0, &F6, &A6, &4D, &20, &CB, &2A, &60
 EQUB &20, &0E, &2B, &A2, &F4, &20, &CC, &0B, &20, &0E, &2B, &A2
 EQUB &FD, &20, &CC, &0B, &A9, &14, &85, &42, &A9, &02, &20, &5D
 EQUB &2A, &A9, &15, &85, &42, &A9, &01, &A2, &F4, &20, &5F, &2A
 EQUB &A9, &16, &85, &42, &A9, &00, &A2, &FA, &20, &5F, &2A, &A6
 EQUB &45, &60, &C9, &05, &90, &F9, &BD, &8C, &01, &30, &F4, &FE
 EQUB &8C, &01, &60, &A2, &FD, &85, &37, &20, &45, &21, &A4, &42
 EQUB &A5, &8A, &99, &80, &03, &A5, &8B, &99, &98, &03, &20, &B1
 EQUB &2A, &20, &85, &22, &A4, &42, &B0, &2C, &38, &E9, &01, &30
 EQUB &27, &99, &B0, &03, &A5, &2B, &38, &E9, &09, &AA, &A5, &2A
 EQUB &CA, &F0, &0C, &10, &06, &4A, &E8, &D0, &FC, &F0, &04, &0A
 EQUB &CA, &D0, &FC, &99, &C8, &03, &B9, &8C, &01, &29, &70, &05
 EQUB &37, &4C, &AD, &2A, &A4, &42, &B9, &8C, &01, &09, &80, &99
 EQUB &8C, &01, &60, &A0, &25, &20, &A5, &0C, &A5, &7D, &85, &55
 EQUB &D0, &0E, &C4, &7C, &90, &0A, &C6, &68, &A5, &7C, &85, &41
 EQUB &A5, &42, &85, &67, &60, &86, &45, &BD, &3C, &01, &AA, &BD
 EQUB &8C, &01, &30, &35, &29, &0F, &85, &37, &BD, &80, &03, &38
 EQUB &E5, &0A, &85, &74, &BD, &98, &03, &E5, &0B, &10, &06, &C9
 EQUB &E0, &90, &1E, &B0, &04, &C9, &20, &B0, &18, &06, &74, &2A
 EQUB &06, &74, &2A, &18, &69

SAVE "3-assembled-output/Revs.bin", LOAD%, LOAD_END%

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

INCLUDE "1-source-files/main-sources/revs-header.h.asm"

_ACORNSOFT              = (_VARIANT = 1)
_SUPERIOR               = (_VARIANT = 2)

GUARD &8000             \ Guard against assembling over sideways ROMs

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

CODE% = &0B00           \ The address of the main game code

LOAD% = &1200           \ The load address of the main code binary

LOAD_END% = &7000       \ The address of the end of the main code binary

dashData = &3000        \ The address of the first code block that gets swapped
                        \ in and out of screen memory, along with parts of the
                        \ dashboard image

trackLoad = &70DB       \ The load address of the track data file

trackChecksum = &7800   \ The address of the checksums in the track data file
                        \ after it is loaded but before it is moved in memory

tyreLeft1 = &6E85       \ The left and right tyres in screen memory
tyreLeft2 = &6E8A
tyreRight1 = &6FB2
tyreRight2 = &6FBD
tyreLeft3 = &6FC0
tyreRight3 = &70F8

L7000 = &7000
L713D = &713D
L7205 = &7205

assistLeft1 = &77DB     \ Centre-bottom of dashboard in screen memory for
assistLeft2 = &77DC     \ showing steering assist the indicator
assistRight1 = &77E3
assistRight2 = &77E4

row2_column1 = &7C79    \ Chequered flag mode 7 screen address
row18_column5 = &7E85   \ The first entry's number in a mode 7 menu
row24_column5 = &7FC5   \ Location of "PRESS SPACE BAR TO CONTINUE" prompt

\ ******************************************************************************
\
\       Name: Zero page
\       Type: Workspace
\    Address: &0070 to &008F
\   Category: Workspaces
\    Summary: Mainly temporary variables that are used a lot
\
\ ******************************************************************************

ORG &0000

.carMoving

 SKIP 1                 \ Flag to denote whether the car is moving
                        \
                        \   * 0 = not moving
                        \
                        \   * Non-zero = moving

.L0001

 SKIP 1                 \ 

.L0002

 SKIP 1                 \ 

.currentPosition

 SKIP 1                 \ The position of the current player
                        \
                        \ This refers to the current player's position in the
                        \ driversInOrder list

.L0004

 SKIP 1                 \ 

.L0005

 SKIP 1                 \ 

.L0006

 SKIP 1                 \ 

.L0007

 SKIP 1                 \ 

.L0008

 SKIP 1                 \ 

.L0009

 SKIP 1                 \ 

.L000A

 SKIP 1                 \ 

.L000B

 SKIP 1                 \ 

.L000C

 SKIP 1                 \ 

.L000D

 SKIP 1                 \ 

.L000E

 SKIP 1                 \ 

.L000F

 SKIP 1                 \ 

.L0010

 SKIP 1                 \ 

.L0011

 SKIP 1                 \ 

.L0012

 SKIP 1                 \ 

.L0013

 SKIP 1                 \ 

.L0014

 SKIP 1                 \ 

.L0015

 SKIP 1                 \ 

.L0016

 SKIP 1                 \ 

.L0017

 SKIP 1                 \ 

.L0018

 SKIP 1                 \ 

.gearChange

 SKIP 1                 \ Used to store the direction of the gear change
                        \
                        \   * 1 = change up
                        \
                        \   * 0 = no gear change
                        \
                        \   * -1 = change down

.L001A

 SKIP 1                 \ 

.rowCounter

 SKIP 1                 \ 

.pressingShiftArrow

 SKIP 1                 \ Bit 7 is set if we are pressing SHIFT and right arrow
                        \ (which restarts the game)

.L001D

 SKIP 1                 \ 

.L001E

 SKIP 1                 \ 

.L001F

 SKIP 1                 \ 

.L0020

 SKIP 1                 \ 

.L0021

 SKIP 1                 \ 

.L0022

 SKIP 1                 \ 

.L0023

 SKIP 1                 \ 

.L0024

 SKIP 1                 \ 

.L0025

 SKIP 1                 \ 

.L0026

 SKIP 1                 \ 

.L0027

 SKIP 1                 \ 

.L0028

 SKIP 1                 \ 

.L0029

 SKIP 1                 \ 

.L002A

 SKIP 1                 \ 

.L002B

 SKIP 1                 \ 

.L002C

 SKIP 1                 \ 

.L002D

 SKIP 1                 \ 

.speedLo

 SKIP 1                 \ Low byte of the car's speed
                        \
                        \ In mph? This looks like the fractional part

.L002F

 SKIP 1                 \ 

.L0030

 SKIP 1                 \ 

.L0031

 SKIP 1                 \ 

.L0032

 SKIP 1                 \ 

.L0033

 SKIP 1                 \ 

.L0034

 SKIP 1                 \ 

.L0035

 SKIP 1                 \ 

.L0036

 SKIP 1                 \ 

.L0037

 SKIP 1                 \ 

.L0038

 SKIP 1                 \ 

.L0039

 SKIP 1                 \ 

.L003A

 SKIP 1                 \ 

.L003B

 SKIP 1                 \ 

.revs

 SKIP 1                 \ The current revs, as shown on the rev counter

.L003D

 SKIP 1                 \ 

.throttleBrakeState

 SKIP 1                 \ Denotes whether the throttle or brake are being
                        \ applied
                        \
                        \   * Bit 7 is set if there is no brake or throttle key
                        \     press
                        \
                        \   * 0 = brakes are being applied
                        \
                        \   * 1 = throttle is being applied

.throttleBrake

 SKIP 1                 \ The amount of throttle or brake being applied

.gearNumber

 SKIP 1                 \ The current gear number
                        \
                        \  * 0 = reverse
                        \
                        \  * 1 = neutral
                        \
                        \  * 2-7 = 1 to 5

.L0041

 SKIP 1                 \ 

.colourScheme

 SKIP 0                 \ The number of the table colour scheme passed to the
                        \ SetRowColours routine:
                        \
                        \ Scheme 0: Even rows: 132 on 134 (blue on cyan)
                        \           Odd rows:  134 on 135 (cyan on white)
                        \
                        \ Scheme 4: Even rows: 129 on 132 (red on blue)
                        \           Odd rows:  131 on 130 (yellow on green)
                        \
                        \ Scheme 8: Even rows: 131 on 132 (yellow on blue)
                        \           Odd rows:  129 on 135 (red on white)
 
.L0042

 SKIP 1                 \ 

.L0043

 SKIP 1                 \ 

.L0044

 SKIP 1                 \ 

.driverPrinted

 SKIP 0                 \ The number of the driver we just printed in the
                        \ PrintPositionName routine

.L0045

 SKIP 1                 \ 

.L0046

 SKIP 1                 \ 

.L0047

 SKIP 1                 \ 

.L0048

 SKIP 1                 \ 

.L0049

 SKIP 1                 \ 

.driverNumber

 SKIP 1                 \ Current driver number (0 to 19)

.L004B

 SKIP 1                 \ 

.L004C

 SKIP 1                 \ 

.positionAhead

 SKIP 1                 \ The number of the position ahead of the current
                        \ player's position
                        \
                        \ This refers to the current player's position in the
                        \ driversInOrder list
                        \
                        \ The position ahead of the leader is last place

.L004E

 SKIP 1                 \ 

.L004F

 SKIP 1                 \ 

.L0050

 SKIP 1                 \ 

.L0051

 SKIP 1                 \ 

.L0052

 SKIP 1                 \ 

.L0053

 SKIP 1                 \ 

.L0054

 SKIP 1                 \ 

.L0055

 SKIP 1                 \ 

.L0056

 SKIP 1                 \ 

.L0057

 SKIP 1                 \ 

.gearChangeKey

 SKIP 1                 \ Determines whether or not a gear change key has been
                        \ pressed
                        \
                        \   * Bit 7 set = a gear change key has been pressed

.L0059

 SKIP 1                 \ 

.L005A

 SKIP 1                 \ 

.positionBehind

 SKIP 1                 \ The number of the position behind the current player's
                        \ position
                        \
                        \ This refers to the current player's position in the
                        \ driversInOrder list
                        \
                        \ The position behind last place is the leader

.L005C

 SKIP 1                 \ 

.L005D

 SKIP 1                 \ 

.L005E

 SKIP 1                 \ 

.L005F

 SKIP 1                 \ 

.L0060

 SKIP 1                 \ 

.L0061

 SKIP 1                 \ 

.L0062

 SKIP 1                 \ 

.speedHi

 SKIP 1                 \ High byte of the car's speed
                        \
                        \ In mph? This looks like the integer part

.printMode

 SKIP 1                 \ Determines how the next character is printed
                        \ on-screen:
                        \
                        \  * 0 = poke the character directly into screen memory
                        \
                        \  * 1 = print the character with OSWRCH (for mode 7)

.L0065

 SKIP 1                 \ 

.L0066

 SKIP 1                 \ 

.L0067

 SKIP 1                 \ 

.L0068

 SKIP 1                 \ 

.lineBufferSize

 SKIP 1                 \ The size of the line buffer
                        \
                        \ Zeroed in SetupGame

.L006A

 SKIP 1                 \ 

.startingStack

 SKIP 1                 \ The value of the stack pointer when the game starts,
                        \ so we can restore it when restarting the game

.raceStarted

 SKIP 1                 \ Flag determining whether the race has started
                        \
                        \   * Bit 7 clear = this is practice or a qualifying lap
                        \
                        \   * Bit 7 set = the race has started

.L006D

 SKIP 1                 \ 

.numberOfLaps

 SKIP 1                 \ The number of laps in the race (5, 10 or 20)

.currentPlayer

 SKIP 1                 \ The number of the current player
                        \
                        \   * 0 for practice
                        \
                        \   * 0 to 19 for competition

.P

 SKIP 1                 \ Temporary storage, used in a number of places

.Q

 SKIP 1                 \ Temporary storage, used in a number of places

.R

 SKIP 1                 \ Temporary storage, used in a number of places

.S

 SKIP 1                 \ Temporary storage, used in a number of places

.T

 SKIP 1                 \ Temporary storage, used in a number of places

.U

 SKIP 1                 \ Temporary storage, used in a number of places

.V

 SKIP 1                 \ Temporary storage, used in a number of places

.W

 SKIP 1                 \ Temporary storage, used in a number of places

.G

 SKIP 1                 \ Temporary storage, used in a number of places

.H

 SKIP 1                 \ Temporary storage, used in a number of places

.I

 SKIP 1                 \ Temporary storage, used in a number of places

.J

 SKIP 1                 \ Temporary storage, used in a number of places

.K

 SKIP 1                 \ Temporary storage, used in a number of places

.L

 SKIP 1                 \ Temporary storage, used in a number of places

.M

 SKIP 1                 \ Temporary storage, used in a number of places

.N

 SKIP 1                 \ Temporary storage, used in a number of places

.PP

 SKIP 1                 \ Temporary storage, used in a number of places

.QQ

 SKIP 1                 \ Temporary storage, used in a number of places

.RR

 SKIP 1                 \ Temporary storage, used in a number of places

.SS

 SKIP 1                 \ Temporary storage, used in a number of places

.TT

 SKIP 1                 \ Temporary storage, used in a number of places

.UU

 SKIP 1                 \ Temporary storage, used in a number of places

.VV

 SKIP 1                 \ Temporary storage, used in a number of places

.WW

 SKIP 1                 \ Temporary storage, used in a number of places

.GG

 SKIP 1                 \ Temporary storage, used in a number of places

.HH
 
 SKIP 1                 \ This byte does not appear to benused

.II

 SKIP 1                 \ Temporary storage, used in a number of places

.JJ

 SKIP 1                 \ Temporary storage, used in a number of places

.KK

 SKIP 1                 \ Temporary storage, used in a number of places

.LL

 SKIP 1                 \ Temporary storage, used in a number of places

.MM

 SKIP 1                 \ Temporary storage, used in a number of places

.NN

 SKIP 1                 \ Temporary storage, used in a number of places

\ ******************************************************************************
\
\       Name: Stack variables
\       Type: Workspace
\    Address: &0100 to &0175
\   Category: Workspaces
\    Summary: Variables that share page 1 with the stack
\
\ ******************************************************************************

ORG &0100

.positionNumber

 SKIP 20                \ Position numbers to show in the first column of the
                        \ driver table

.L0114

 SKIP 20                \ 

.driverSpeed

 SKIP 20                \ The speed of this driver in the race (88 to 162)
                        \
                        \ The speed for each driver depends on a number of
                        \ factors, and is calculated in the SetDriverSpeed
                        \ routine
                        \
                        \ Indexed by driver number (0 to 19)

.driversInOrder

 SKIP 20                \ A list of driver numbers in order
                        \
                        \ For example, during a race, this contains the race
                        \ position of each driver in the race (i.e. first place,
                        \ second place etc.)
                        \
                        \ It is also used to sort drivers by lap time and points
                        \ for the driver table
                        \
                        \ Indexed by driver number (0 to 19)
                        \
                        \ Gets set in InitialiseDrivers to the number of each
                        \ driver, so the initial order is driver number

.L3850Hi

 SKIP 20                \ 

.L0164

 SKIP 20                \ 

.L0178

 SKIP 20                \ 

.L018C

 SKIP 24                \ 

.L01A4

 SKIP 20                \ 


\ ******************************************************************************
\
\       Name: Main variable workspace
\       Type: Workspace
\    Address: &0380 to &07F8 and &0880 to &0AFF
\   Category: Workspaces
\    Summary: The main block of game variables
\
\ ******************************************************************************

ORG &0380

.L0380

 SKIP 23                \ 

.L0397

 SKIP 1                 \ 

.L0398

 SKIP 23                \ 

.L03AF

 SKIP 1                 \ 

.L03B0

 SKIP 24                \ 

.L03C8

 SKIP 56                \ 

.L0400

 SKIP 80                \ 

.L0450

 SKIP 80                \ 

.driverGridRow

 SKIP 20                \ The grid row for each driver (0 to 9)
                        \
                        \ There are two cars per grid row, with grid row 0 at
                        \ the front including the car in pole position
                        \
                        \ There are 20 cars, in rows 0 to 9
                        \
                        \ Indexed by driver number (0 to 19)
                        \
                        \ Gets set in InitialiseDrivers

.L04B4

 SKIP 20                \ 

.driversInOrder2

 SKIP 20                \ Used to store a copy of the driversInOrder list

.bestLapMinutes

 SKIP 20                \ 

.totalPointsTop

 SKIP 20                \ Top byte of total accumulated points for each driver
                        \
                        \ Indexed by driver number (0 to 19)
                        \
                        \ Gets set to 0 in InitialiseDrivers
                        \
                        \ Stored as a 24-bit value (totalPointsTop totalPointsHi
                        \ totalPointsLo)

.firstPixelTyre

 SKIP 80                \ Storage for the first track pixel byte along the edge
                        \ of the left tyre
                        \
                        \ This table is used to store the track pixel byte that
                        \ would be shown along the edge of the left tyre, but
                        \ which is partially obscured by the edge
                        \
                        \ This is stored so we can retrieve it when masking the
                        \ pixel byte with the tyre edge when we draw the track
                        \ line that starts at the edge of the left tyre
                        \
                        \ There is a byte for each track line from 43 (the track
                        \ line at the top of the dashboard) down to 3 (the lowest
                        \ track line, just above where the wing mirror joins the
                        \ car body)
                        \
                        \ Lines 0 to 2 are not used

.L0554

 SKIP 80                \ 

.L05A4

 SKIP 80                \ 

.configStop

 SKIP 1                 \ A key has been pressed that stops the race
                        \
                        \   * Bit 5 set = retire from race/lap
                        \     (SHIFT-f7 pressed)
                        \
                        \   * Bit 7 and bit 6 set = pit stop
                        \     (SHIFT-f0 pressed)
                        \
                        \   * Bit 7 set and bit 6 clear = restart game
                        \     (SHIFT and right arrow pressed)
                        \
                        \ Zeroed in SetupGame

.configJoystick

 SKIP 1                 \ A key has been pressed to set joystick or keyboard
                        \
                        \   * No bits set = keyboard
                        \     (SHIFT-f1 pressed)
                        \
                        \   * Bit 7 set = joystick
                        \     (SHIFT-f2 pressed)
                        \
                        \ Zeroed in SetupGame

.configVolume

 SKIP 1                 \ A key has been pressed to change the volume
                        \
                        \   * Bit 7 and bit 6 set = volume down
                        \     (SHIFT-f4 pressed)
                        \
                        \   * Bit 7 clear and bit 6 set = volume up
                        \     (SHIFT-f5 pressed)
                        \
                        \ Zeroed in SetupGame

.configPause

 SKIP 1                 \ A key has been pressed to pause the game
                        \
                        \   * Bit 7 set = pause game
                        \     (COPY pressed)
                        \
                        \   * Bit 6 set = unpause game
                        \     (DELETE pressed)
                        \
                        \ Zeroed in SetupGame

.configAssist

 SKIP 1                 \ A key has been pressed to toggle steering assist
                        \
                        \   * No bits set = disable steering assist
                        \     (SHIFT-f3 pressed)
                        \
                        \   * Bit 7 set = enable steering assist
                        \     (SHIFT-f6 pressed)
                        \
                        \ Zeroed in SetupGame

 SKIP 5

.volumeLevel

 SKIP 2                 \ The game's volume level
                        \
                        \ This uses the operating system's volume scale, with
                        \ -15 being full volume and 0 being silent
                        \
                        \ Set to -10 (246) in SetupGame

.L0600

 SKIP 80                \ 

.L0650

 SKIP 80                \ 

.driverTenths

 SKIP 20                \ The tenths of seconds of each driver's lap time,
                        \ stored in BCD
                        \
                        \ Indexed by driver number (0 to 19)

.currentTenths

 SKIP 4                 \ Tenths for current lap time for multi-player X

.driverSeconds

 SKIP 20                \ The seconds of each driver's lap time, stored in BCD
                        \
                        \ Indexed by driver number (0 to 19)
.currentSeconds

 SKIP 4                 \ Seconds for current lap time for multi-player X

.driverMinutes

 SKIP 20                \ The minutes of each driver's lap time, stored in BCD
                        \
                        \ Indexed by driver number (0 to 19)

.currentMinutes

 SKIP 4                 \ Minutes for current lap time for multi-player X

.L06E8

 SKIP 23                \ 

.L06FF

 SKIP 1                 \ 

.L0700

 SKIP 1                 \ 

.L0701

 SKIP 1                 \ 

.L0702

 SKIP 126               \ 

.lineBufferPixel

 SKIP 40                \ The original screen contents of this pixel in the line
                        \ buffer

.lineBufferAddrLo

 SKIP 40                \ The low byte of the screen address of this pixel in
                        \ the line buffer

.lineBufferAddrHi

 SKIP 40                \ The low byte of the screen address of this pixel in
                        \ the line buffer

ORG &0880

.L0880

 SKIP 23                \ 

.L0897

 SKIP 1                 \ 

.bestLapTenths

 SKIP 20                \ 

.bestLapSeconds

 SKIP 36                \ 

.L08D0

 SKIP 24                \ 

.L08E8

 SKIP 24                \ 

.L0900

 SKIP 1                 \ 

.L0901

 SKIP 1                 \ 

.L0902

 SKIP 118               \ 

.L0978

 SKIP 1                 \ 

.L0979

 SKIP 1                 \ 

.L097A

 SKIP 128               \ 

.L09FA

 SKIP 3                 \ 

.L09FD

 SKIP 1                 \ 

.L09FE

 SKIP 2                 \ 

.L0A00

 SKIP 1                 \ 

.L0A01

 SKIP 1                 \ 

.L0A02

 SKIP 118               \ 

.L0A78

 SKIP 1                 \ 

.L0A79

 SKIP 1                 \ 

.L0A7A

 SKIP 128               \ 

.L0AFA

 SKIP 3                 \ 

.L0AFD

 SKIP 1                 \ 

.L0AFE

 SKIP 2                 \ 

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
\  Deep dive: The jigsaw puzzle binary
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

\ This code starts out at &1200 and is run there, before it moves itself to
\ &7900-&790D along with the rest of the page, so the following moves this code
\ next to the block that runs at &790E-&79FF

COPYBLOCK &1200, &120E, &7900
CLEAR &1200, &120E

\ ******************************************************************************
\
\       Name: SwapCode
\       Type: Subroutine
\   Category: Setup
\    Summary: Move the track data to the right place and run a checksum on it
\  Deep dive: The jigsaw puzzle binary
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
                        \   * Swap &70DB-&77FF and &5300-&5A24
                        \
                        \ At the same time, we want to perform a checksum on the
                        \ track data and compare the results with the four
                        \ checksum bytes in trackChecksum
                        \
                        \ The following does this in batches of 256 bytes, using
                        \ Y as an index that goes from 0 to 255. The checks are
                        \ done at the end of the loop, and they check the value
                        \ of Y first (against &25), and then the high byte of
                        \ the higher address (against &77) but only if the Y
                        \ test fails, so the swaps end up being:
                        \
                        \   * Swap &5300 + 0-255 with &70DB + 0-255
                        \   * Swap &5400 + 0-255 with &71DB + 0-255
                        \   * Swap &5500 + 0-255 with &72DB + 0-255
                        \   * Swap &5600 + 0-255 with &73DB + 0-255
                        \   * Swap &5700 + 0-255 with &74DB + 0-255
                        \   * Swap &5800 + 0-255 with &75DB + 0-255
                        \   * Swap &5900 + 0-255 with &76DB + 0-255
                        \   * Swap &5A00 + 0-&24 with &77DB + 0-&24
                        \
                        \ So the last operation swaps &5A24 and &77FF

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

 BNE swap2              \ If we have finshed swapping a page of bytes, increment
 INC Q                  \ the high bytes of (Q P) and (S R) to move on to next
 INC S                  \ page

.swap2

 CPY #&25               \ If we have not yet reached addresses &5A24 and &77FF,
 BNE swap1              \ jump back to swap1 to keep swapping data
 LDA S
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
\  Deep dive: The jigsaw puzzle binary
\
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

IF _ACORNSOFT

 JMP SetupGame          \ If we get here we have processed all the blocks in the
                        \ block tables, so jump to SetupGame to continue setting
                        \ up the game

ELIF _SUPERIOR

 JMP Protect            \ If we get here we have processed all the blocks in the
                        \ block tables, so jump to Protect to continue setting
                        \ up the game

ENDIF

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
\       Name: soundBlock
\       Type: Variable
\   Category: Sound
\    Summary: Temporary storage for data relating to sounds 0 to 3
\
\ ******************************************************************************

ORG &0B00

.soundBlock

 EQUB &10, &10          \ Sound #0
 EQUB &10, &10

 EQUB &10, &10          \ Sound #1
 EQUB &10, &10

 EQUB &10, &10          \ Sound #2
 EQUB &10, &10

 EQUB &10, &10          \ Sound #3
 EQUB &10, &10

\ ******************************************************************************
\
\       Name: soundData
\       Type: Variable
\   Category: Sound
\    Summary: OSWORD blocks for making the various game sounds
\
\ ------------------------------------------------------------------------------
\
\ Sound data. To make a sound, the MakeSound passes the bytes in this table to
\ OSWORD 7. These bytes are the OSWORD equivalents of the parameters passed to
\ the SOUND keyword in BASIC. The parameters have these meanings:
\
\   channel/flush, amplitude (or envelope number if 1-4), pitch, duration
\
\ where each value consists of two bytes, with the low byte first and the high
\ byte second.
\
\ For the channel/flush parameter, the first byte is the channel while the
\ second is the flush control (where a flush control of 0 queues the sound,
\ while a flush control of 1 makes the sound instantly). When written in
\ hexadecimal, the first figure gives the flush control, while the second is
\ the channel (so &13 indicates flush control = 1 and channel = 3).
\
\ ******************************************************************************

.soundData

 EQUB &10, &00          \ Sound #0
 EQUB &F6, &FF

 EQUB &03, &00          \ Sound #1
 EQUB &FF, &00

 EQUB &11, &00          \ Sound #2
 EQUB &F6, &FF

 EQUB &BB, &00          \ Sound #3
 EQUB &FF, &00

 EQUB &12, &00          \ Sound #4
 EQUB &F6, &FF

 EQUB &28, &00          \ Sound #5
 EQUB &FF, &00

 EQUB &13, &00          \ Sound #6
 EQUB &01, &00

 EQUB &82, &00          \ Sound #7
 EQUB &FF, &00

 EQUB &10, &00          \ Sound #8
 EQUB &F6, &FF

 EQUB &06, &00          \ Sound #9
 EQUB &04, &00

\ ******************************************************************************
\
\       Name: envelopeData
\       Type: Variable
\   Category: Sound
\    Summary: Data for the sound envelope
\
\ ------------------------------------------------------------------------------
\
\ There is one sound envelope defined in Revs:
\
\   * Envelope 1 defines the engine sound
\
\ ******************************************************************************

.envelopeData

 EQUB 1, 1, 2, -2, -6, 4, 1, 1, 10, 0, 0, 0, 72, 0

\ ******************************************************************************
\
\       Name: xTemp
\       Type: Variable
\   Category: Sound
\    Summary: Temporary storage for X so it can be preserved through calls to
\             the sound routines
\
\ ******************************************************************************

.xTemp

 EQUB &FF

\ ******************************************************************************
\
\       Name: MakeSound
\       Type: Subroutine
\   Category: Sound
\    Summary: Make a sound
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The sound number from the soundData table (0 to 7)
\
\   Y                   A value to store in byte #2 in this sound's soundBlock
\
\ Other entry points:
\
\   MakeSound-3         Use the current volume level for argument Y
\
\ ******************************************************************************

 LDY volumeLevel        \ Set Y to the current volumeLevel, to store in byte #2
                        \ in this sound's soundBlock

.MakeSound

 STX xTemp              \ Store the value of X in xTemp, so we can preserve it
                        \ through the routine

 ASL A                  \ Set A = A * 8
 ASL A                  \
 ASL A                  \ so we can use it as an index into the soundData table,
                        \ which has 8 bytes per entry

 CLC                    \ Set (Y X) = soundData + A
 ADC #LO(soundData)     \
 TAX                    \ starting with the low byte in X

                        \ We now use the low byte in X to point to this sound's
                        \ corresponding four-byte block in soundBlock (though it
                        \ is unclear what effect this has, as soundBlock is
                        \ never written to and soundBlock+2 is never read)

 TYA                    \ Store Y in byte #2 of this sound's soundBlock
 STA soundBlock+2,X

 LDA soundBlock,X       \ Set Y to byte #0 of this sound's soundBlock, reduced
 AND #3                 \ to the range 0 to 3, to give us the relevant sound
 TAY                    \ buffer for this sound

 LDA #7                 \ Set A = 7 for the OSWORD command to make a sound

 STA soundBuffer,Y      \ Set the Y-th sound buffer status to 7, which is
                        \ non-zero and indicates that we are making a sound on
                        \ this channel

 BNE MakeSoundEnvelope  \ Jump to MakeSoundEnvelope to set up Y and apply the
                        \ OSWORD command to the (Y X) block, which makes the
                        \ relevant sound (this BNE is effectively a JMP as A is
                        \ never zero)

\ ******************************************************************************
\
\       Name: DefineEnvelope
\       Type: Subroutine
\   Category: Sound
\    Summary: Define a sound envelope
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The offset of the sound envelope data in envelopeData:
\
\                         * A = 0 for the first (and only) envelope definition
\
\ Returns:
\
\   X                   X is unchanged
\
\ ******************************************************************************

.DefineEnvelope

 STX xTemp              \ Store the value of X in xTemp, so we can preserve it
                        \ through the routine

 CLC                    \ Set (Y X) = envelopeData + A
 ADC #LO(envelopeData)  \
 TAX                    \ starting with the low byte

 LDA #8                 \ Set A = 8 for the OSWORD command to define an envelope

                        \ Fall through into MakeSoundEnvelope to set up Y and
                        \ apply the OSWORD command to the (Y X) block, which
                        \ defines the relevant sound envelope

\ ******************************************************************************
\
\       Name: MakeSoundEnvelope
\       Type: Subroutine
\   Category: Sound
\    Summary: Either make a sound or set up an envelope
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The action:
\
\                         * A = 7 make a sound
\
\                         * A = 8 to define a sound envelope
\
\   X                   The low byte of the address of the OSWORD block
\
\   xTemp               The value of X to restore at the end of the routine
\
\ ******************************************************************************

.MakeSoundEnvelope

 LDY #HI(soundData)     \ Set y to the high byte of the soundData block
                        \ address, so (Y X) now points to the relevant envelope
                        \ or sound data block

 JSR OSWORD             \ Call OSWORD with action A, as follows:
                        \
                        \  * A = 7 to make the sound at (Y X)
                        \
                        \  * A = 8 to set up the sound envelope at (Y X)

 LDX xTemp              \ Fetch the value of X we stored before calling the
                        \ routine, so it doesn't change

 RTS                    \ Return from the subroutine

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

.P0B79

 LDA frontWingSetting,X
 ASL A
 ASL A
 STA U
 LDA L0BA0,X

 JSR Multiply8x8        \ Set (A T) = A * U

 CLC
 ADC #&5A
 STA L62A8,X
 DEX
 BPL P0B79
 LDA rearWingSetting
 ASL A
 ADC rearWingSetting
 ADC frontWingSetting
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
 SBC L62D2Lo
 STA L5E40,Y
 LDA L5E90,Y
 SBC L62E2Hi
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
 ADC SS
 STA L0A00,X
 LDA L0901,Y
 CLC
 ADC U
 STA L0901,X
 LDA L0A01,Y
 ADC TT
 STA L0A01,X
 LDA L0902,Y
 CLC
 ADC V
 STA L0902,X
 LDA L0A02,Y
 ADC UU
 STA L0A02,X
 RTS

\ ******************************************************************************
\
\       Name: Multiply8x8
\       Type: Subroutine
\   Category: Maths
\    Summary: Calculate (A T) = T * U
\
\ ------------------------------------------------------------------------------
\
\ Do the following multiplication of two unsigned 8-bit numbers:
\
\   (A T) = A * U
\
\ Returns:
\
\   X                   X is unchanged
\
\ Other entry points:
\
\   Multiply8x8+2       Calculate (A T) = T * U
\
\ ******************************************************************************

.Multiply8x8

 STA T                  \ Set T = A

                        \ We now calculate (A T) = T * U
                        \                        = A * U

 LDA #0                 \ Set A = 0 so we can start building the answer in A

 LSR T                  \ Set T = T >> 1
                        \ and C flag = bit 0 of T

                        \ We are now going to work our way through the bits of
                        \ T, and do a shift-add for any bits that are set,
                        \ keeping the running total in A, and instead of using a
                        \ loop, we unroll the calculation, starting with bit 0

 BCC P%+5               \ If C (i.e. the next bit from T) is set, do the
 CLC                    \ addition for this bit of T:
 ADC U                  \
                        \   A = A + U

 ROR A                  \ Shift A right to catch the next digit of our result,
                        \ which the next ROR sticks into the left end of T while
                        \ also extracting the next bit of T

 ROR T                  \ Add the overspill from shifting A to the right onto
                        \ the start of T, and shift T right to fetch the next
                        \ bit for the calculation into the C flag

 BCC P%+5               \ Repeat the shift-and-add loop for bit 1
 CLC
 ADC U
 ROR A
 ROR T

 BCC P%+5               \ Repeat the shift-and-add loop for bit 2
 CLC
 ADC U
 ROR A
 ROR T

 BCC P%+5               \ Repeat the shift-and-add loop for bit 3
 CLC
 ADC U
 ROR A
 ROR T

 BCC P%+5               \ Repeat the shift-and-add loop for bit 4
 CLC
 ADC U
 ROR A
 ROR T

 BCC P%+5               \ Repeat the shift-and-add loop for bit 5
 CLC
 ADC U
 ROR A
 ROR T

 BCC P%+5               \ Repeat the shift-and-add loop for bit 6
 CLC
 ADC U
 ROR A
 ROR T

 BCC P%+5               \ Repeat the shift-and-add loop for bit 7
 CLC
 ADC U
 ROR A
 ROR T

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: Divide8x8
\       Type: Subroutine
\   Category: Maths
\    Summary: Calculate T = A * 256 / V
\
\ ------------------------------------------------------------------------------
\
\ In the same way that shift-and-add implements a binary version of the manual
\ long multiplication process, shift-and-subtract implements long division. We
\ shift bits out of the left end of the number being divided (A), subtracting
\ the largest possible multiple of the divisor (V) after each shift; each bit of
\ A where we can subtract Q gives a 1 the answer to the division, otherwise it
\ gives a 0.
\
\ Arguments:
\
\   T                   This has an effect, not sure what ???
\
\   A                   Unsigned integer
\
\   V                   Unsigned integer
\
\ ******************************************************************************

.Divide8x8

 ASL T                  \ Shift T left, which clears bit 0 of T, ready for us to
                        \ start building the result

                        \ We now repeat the following five instruction block
                        \ eight times, one for each bit in T

 ROL A                  \ Shift A to the left to extract the next bit from the
                        \ number being divided

 BCS P%+6               \ If we just shifted a 1 out of A, skip the next two
                        \ instructions and jump straight to the subtraction

 CMP V                  \ If A < V skip the following two instructions with the
 BCC P%+5               \ C flag clear, so we shift a 0 into the result in T

 SBC V                  \ A >= V, so set A = A - V and set the C flag so we
 SEC                    \ shift a 1 into the result in T

 ROL T                  \ Shift T to the left, pulling the C flag into bit 0

 ROL A                  \ Repeat the shift-and-subtract loop for bit 1
 BCS P%+6
 CMP V
 BCC P%+5
 SBC V
 SEC
 ROL T

 ROL A                  \ Repeat the shift-and-subtract loop for bit 2
 BCS P%+6
 CMP V
 BCC P%+5
 SBC V
 SEC
 ROL T

 ROL A                  \ Repeat the shift-and-subtract loop for bit 3
 BCS P%+6
 CMP V
 BCC P%+5
 SBC V
 SEC
 ROL T

 ROL A                  \ Repeat the shift-and-subtract loop for bit 4
 BCS P%+6
 CMP V
 BCC P%+5
 SBC V
 SEC
 ROL T

 ROL A                  \ Repeat the shift-and-subtract loop for bit 5
 BCS P%+6
 CMP V
 BCC P%+5
 SBC V
 SEC
 ROL T

 ROL A                  \ Repeat the shift-and-subtract loop for bit 6
 BCS P%+6
 CMP V
 BCC P%+5
 SBC V
 SEC
 ROL T

 ROL A                  \ Repeat the shift-and-subtract loop for bit 7, but
 BCS P%+4               \ without the subtraction, as we don't need to keep
 CMP V                  \ calculating A once its top bit has been extracted
 ROL T

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: sub_C0CA5
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C0CA5

 LDA M
 CMP #&67
 BCS C0CC2
 LDA G
 LSR H
 ROR A
 LSR H
 ROR A
 LSR H
 ROR A
 CLC
 ADC I
 STA K
 LDA H
 ADC J
 STA L
 RTS

.C0CC2

 LSR H
 ROR G
 LDA J
 STA T
 LDA I
 LSR T
 ROR A
 LSR T
 ROR A
 LSR T
 ROR A
 STA U
 LDA G
 CLC
 ADC I
 STA K
 LDA H
 ADC J
 STA L
 LDA K
 SEC
 SBC U
 STA K
 LDA L
 SBC T
 STA L
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

 STA J
 STX T
 JSR sub_C0DB3
 STA G
 LDA U
 STA H
 LDX #1
 STX L0042
 LDX #0
 BIT J
 BVC C0D1B
 INX
 DEC L0042

.C0D1B

 CMP #&7A
 BCC C0D27
 BCS C0D4F
 LDA G
 CMP #&F0
 BCS C0D4F

.C0D27

 LDA #&AB

 JSR Multiply8x8        \ Set (A T) = A * U

 JSR Multiply8x8        \ Set (A T) = A * U

 STA V
 JSR sub_C0DBF
 LDA G
 SEC
 SBC T
 STA T
 LDA H
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
 SBC G
 STA T
 LDA #&C9
 SBC H
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
 SBC G
 STA G
 LDA #&C9
 SBC H
 STA H
 STA U
 JMP C0D1B

.C0D97

 LDA J
 BPL C0DA3
 LDA #1
 ORA L62A0
 STA L62A0

.C0DA3

 LDA J
 ASL A
 EOR J
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

 JSR Multiply8x8+2      \ Set (A T) = T * U

 STA W
 LDA V

 JSR Multiply8x8        \ Set (A T) = A * U

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

 LDA QQ
 BPL C0DEE
 LDA #0
 SEC
 SBC PP
 STA PP
 LDA #0
 SBC QQ
 STA QQ
 LDA H
 EOR #&80
 STA H

.C0DEE

 LDA RR
 AND #1
 BEQ C0DFA
 LDA H
 EOR #&80
 STA H

.C0DFA

 LDA QQ
 STA U
 LDA RR

 JSR Multiply8x8        \ Set (A T) = A * U

 STA W
 LDA T
 CLC
 ADC #&80
 STA V
 BCC C0E10
 INC W

.C0E10

 LDA SS

 JSR Multiply8x8        \ Set (A T) = A * U

 STA G
 LDA T
 CLC
 ADC W
 STA W
 BCC C0E22
 INC G

.C0E22

 LDA PP
 STA U
 LDA SS

 JSR Multiply8x8        \ Set (A T) = A * U

 STA U
 LDA T
 CLC
 ADC V
 LDA U
 ADC W
 STA T
 BCC C0E3C
 INC G

.C0E3C

 LDA G
 BIT H

\ ******************************************************************************
\
\       Name: Absolute16Bit
\       Type: Subroutine
\   Category: Maths
\    Summary: Calculate the absolute value (modulus) of a 16-bit number
\
\ ------------------------------------------------------------------------------
\
\ This routine sets (A T) = |A T|.
\
\ Arguments:
\
\   (A T)               The number to make positive
\
\ ******************************************************************************

.Absolute16Bit

 BPL ScanKeyboard-1     \ If the high byte in A is already positive, return from
                        \ the subroutine (as ScanKeyboard-1 contains an RTS)

                        \ Otherwise fall through into Negate16Bit to negate the
                        \ number in (A T), which will make it positive, so this
                        \ sets (A T) = |A T|

\ ******************************************************************************
\
\       Name: Negate16Bit
\       Type: Subroutine
\   Category: Maths
\    Summary: Negate a 16-bit number
\
\ ------------------------------------------------------------------------------
\
\ This routine negates the 16-bit number (A T).
\
\ Other entry points:
\
\   Negate16Bit+2       Set (A T) = -(U T)
\
\ ******************************************************************************

.Negate16Bit

 STA U                  \ Set (U T) = (A T)

 LDA #0                 \ Set (A T) = 0 - (U T)
 SEC                    \           = -(A T)
 SBC T                  \
 STA T                  \ starting with the low bytes

 LDA #0                 \ And then the high bytes
 SBC U

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: ScanKeyboard
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the kayboard for a specific key press
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The negative inkey value of the key to scan for (in the
\                       range &80 to &FF)
\
\ Returns:
\
\   Z flag              Set if the key in X is being pressed, in which case BEQ
\                       will branch
\
\                       CLear if the key in X is not being pressed, in which
\                       case BNE will branch
\
\ Other entry points:
\
\   ScanKeyboard-1      Contains an RTS
\
\ ******************************************************************************

.ScanKeyboard

 LDA #129               \ Call OSBYTE with A = 129, Y = &FF and the inkey value
 LDY #&FF               \ in X, to scan the keyboard for key X
 JSR OSBYTE

 CPX #&FF               \ If the key in X is being pressed, the above call sets
                        \ both X and Y to &FF, so this sets the Z flag depending
                        \ on whether the key is being pressed (so a BEQ after
                        \ the call will branch if the key in X is being pressed)

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: FlushSoundBuffer
\       Type: Subroutine
\   Category: Sound
\    Summary: Flush the specified sound buffer
\
\ ------------------------------------------------------------------------------
\
\ This routine flushes the specified sound channel buffer, but only if that
\ channel's soundBuffer value is non-zero.
\
\ Arguments:
\
\   X                   The number of the sound channel buffer to flush (0 to 3)
\
\ Returns:
\
\   X                   X is unchanged
\
\   A                   A is unchanged
\
\ ******************************************************************************

.FlushSoundBuffer

 PHA                    \ Store the value of A on the stack so we can retrieve
                        \ it before returning from the routine

 LDA soundBuffer,X      \ If this buffer's soundBuffer value is zero, then there
 BEQ flus1              \ is nothing to flush, so jump to flus1 to return from
                        \ the subroutine

 LDA #0                 \ Set this buffer's soundBuffer value for this buffer to
 STA soundBuffer,X      \ 0 to indicate that it has been flushed

 TXA                    \ Set bit 2 of X
 ORA #%00000100         \
 TAX                    \ This changes X from the original range of 0 to 3, into
                        \ the range 4 to 7, so it now matches the relevant sound
                        \ buffer number (as buffers 4 to 7 are the buffers for
                        \ sound channels 0 to 3)

 LDA #21                \ Call OSBYTE with A = 21 to flush buffer X, which
 JSR OSBYTE             \ flushes the relevant sound channel buffer

 TXA                    \ Clear bit 2 of X, to reverse the X OR 4 above
 AND #%11111011
 TAX

.flus1

 PLA                    \ Retrieve the value of A that we stored on the stack
                        \ above, so it remains unchanged by the routine

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: sub_C0E74
\       Type: Subroutine
\   Category: Sound
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
 STA soundData+28

 LDA #3
 LDY #1
 JSR MakeSound

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
 JSR MakeSound-3
 PLA
 CLC
 ADC #&BB
 LDY #0
 BEQ C0EC0

.C0EB8

 LDX #0                 \ Flush the buffer for sound channel 0
 JSR FlushSoundBuffer

 LDY volumeLevel

.C0EC0

 STA soundData+12

 LDA #1
 JSR MakeSound

 LDY volumeLevel
 BEQ C0EDB
 LDA L0060
 SEC
 SBC #&40
 BCS C0ED8
 LDY #0
 BEQ C0EDB

.C0ED8

 STA soundData+20

.C0EDB

 LDA #2
 JSR MakeSound

.C0EE0

 RTS

.C0EE1

 JSR FlushSoundBuffers  \ Flush all four sound channel buffers

 RTS

\ ******************************************************************************
\
\       Name: ProcessShiftedKeys
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Check for shifted keys (i.e. those that need SHIFT holding down to
\             trigger) and process them accordingly
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   Scan for the first Y + 1 keys from shiftedKeys
\
\ ******************************************************************************

.ProcessShiftedKeys

 STY T                  \ Set T to the number of keys to scan

 LDX #&FF               \ Scan the keyboard to see if SHIFT is being pressed
 JSR ScanKeyboard

 BNE shif10             \ If SHIFT is not being pressed, jump to shif10 to
                        \ return from the subroutine

 LDY T                  \ Set Y to the number of keys to scan, to use as a loop
                        \ counter as we work our way backwards through the
                        \ shiftedKeys table, from entry Y to entry 0

.shif1

 STY T                  \ Set T to the loop counter

 LDX shiftedKeys,Y      \ Fetch the next key number from the shiftedKeys table

 JSR ScanKeyboard       \ Scan the keyboard to see if this key is being pressed

 BEQ shif2              \ If this key is being pressed, jump to shif2 to update
                        \ the relevant configuration setting

 LDY T                  \ Otherwise set Y to the value of the loop counter

 DEY                    \ Decrement the loop counter to point to the next key in
                        \ the table (working backwards)

 BPL shif1              \ Loop back to check the next key in the table until we
                        \ have checked them all

 BMI shif3              \ None of the keys are being pressed, so jump to shif3
                        \ to skip updating the configuration bytes (this BMI is
                        \ effectively a JMP as we just passed through a BPL)

.shif2

                        \ If we get here then the Y-th key is being pressed,
                        \ along with SHIFT, so we now update the relevant
                        \ configuration byte, according to the settings in the
                        \ configKeys table

 LDY T                  \ Otherwise set Y to the value of the loop counter,
                        \ which gives us the offset of key that is being pressed
                        \ within the shiftedKeys table

 LDA configKeys,Y       \ Set X to the low nibble for this key's corresonding
 AND #&0F               \ entry in the configKeys, which contains the offset of
 TAX                    \ the configuration byte from the first configuration
                        \ byte at configStop

 LDA configKeys,Y       \ Set A to the high nibble for this key's corresonding
 AND #&F0               \ entry in the configKeys, which contains the value that
                        \ we need for the corresponding configuration byte

 STA configStop,X       \ Set the coresponding configuration byte to the value
                        \ in A

.shif3

 LDA configPause        \ If configPause = 0, then neither COPY nor DELETE are
 BEQ shif6              \ being, so jump to shif6

                        \ If we get here then one of the pause buttons is being
                        \ pressed

 BPL shif5              \ If bit 7 of configPause is clear, then this means bit
                        \ 6 must be set, which only happens when the unpause key
                        \ (DELETE) is being pressed, so jump to shif5 to unpause
                        \ the game

                        \ Otherwise we need to pause the game

 JSR FlushSoundBuffers  \ Flush all four sound channel buffers to stop the sound
                        \ while we are paused

.shif4

 JSR Reset0554          \ Reset the blocks at L05A4, L0554, L0600, L0650 and
                        \ L5F60

 LDX #&A6               \ Scan the keyboard to see if DELETE is being pressed
 JSR ScanKeyboard

 BNE shif4              \ If DELETE is not being pressed, loop back to shif4 to
                        \ remain paused, otherwise keep going to unpause the
                        \ game

.shif5

 INC L0060              \ Increment L0060

 LDA #0                 \ Set configPause = 0 to clear the pause/unpause key
 STA configPause        \ press

.shif6

 LDY volumeLevel        \ Set Y to the volume level, which uses the operating
                        \ system's volume scale, with -15 being full volume and
                        \ 0 being silent

 LDA L006A              \ If bit 0 of L006A is set, jump to shif9
 AND #1
 BNE shif9

 LDA configVolume       \ If configVolume = 0, jump to shif10 to return from the
 BEQ shif10             \ subroutine

 BPL shif7              \ If bit 7 of configVolume is clear, then this means bit
                        \ 6 must be set, which only happens when the volume up
                        \ (f5) key is being pressed, so jump to shif7

                        \ If we get here then we need to turn the volume down

 INY                    \ Increment Y to decrease the volume

 BEQ shif8              \ If Y is 0 or negative, then it is still a valid volume
 BMI shif8              \ level, so jump to shif8 to update the volume setting

 BPL shif9              \ Otherwise we have already turned the volume down as
                        \ far as it will go, so jump to shif9 to clear the key
                        \ press and return from the subroutine (this BPL is
                        \ effectively a JMP as we just passed through a BMI)

.shif7

                        \ If we get here then we need to turn the volume up

 DEY                    \ Decrement Y to increase the volume

 CPY #241               \ If Y < -15, then we have already turned the volume up
 BCC shif9              \ as far as it will go, so jump to shif9 to clear the
                        \ key press and return from the subroutine

                        \ Otherwise fall through into shif8 to update the
                        \ volume setting

.shif8

 STY volumeLevel        \ Store the updated volume level in volumeLevel

 TYA                    \ Set A = -Y, negated using two's complement 
 EOR #&FF
 CLC
 ADC #1

 ASL A                  \ Set envelopeData+12 = A << 3
 ASL A                  \                       = -Y * 8
 ASL A                  \
 STA envelopeData+12    \ which is 0 for no volume, or 120 for full volume, so
                        \ this sets the target level for the end of the attack
                        \ phase to a higher figure for higher volume settings

 LDA #0                 \ Set up the envelope for the engine sound, with the
 JSR DefineEnvelope     \ volume changed accordingly

 INC L0060              \ Increment L0060

.shif9

 LDA #0                 \ Set configVolume = 0 to clear the volume key press
 STA configVolume

.shif10

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SortDrivers
\       Type: Subroutine
\   Category: Drivers
\    Summary: Create a sorted list of driver numbers, ordered as specified
\
\ ------------------------------------------------------------------------------
\
\ This routine sorts the driver list in driversInOrder according to the value
\ specified by argument A. It also populates positionNumber with the position
\ numbers for the sorted driver list, which will typically run from 0 to 19,
\ but may also contain repeated numbers in the case of a tie.
\
\ The routine uses a basic bubble sort algorithm, swapping neighbouring drivers
\ repeatedly until the whole list is sorted. This is not very efficient, but as
\ this is only done when showing the driver table between races, that doesn't
\ matter.
\
\ Arguments:
\
\   A                   Determines the order of the sorted list to create:
\
\                           * 0 = most recent lap times
\
\                           * Bit 6 set = accumulated points
\
\                           * Bit 7 set = best lap times
\
\ Returns:
\
\   positionNumber      A list of position numbers, from 0 to 19, ready to print
\                       in the first column of the driver table (with 1 added),
\                       with drivers who are tied in the same position sharing
\                       the same number
\
\   driversInOrder      A list of driver numbers, sorted according to the value
\                       specified by argument A
\
\ ******************************************************************************

.SortDrivers

 STA G                  \ Store A in G

 SED                    \ Set the D flag to switch arithmetic to Binary Coded
                        \ Decimal (BCD)

.sort1

 LDX #0                 \ Set V = 0, which we will use to indicate whether the
 STX V                  \ driversInOrder list is sorted
                        \
                        \ We start at 0 to indicate it is sorted, and change it
                        \ if we have to reorder the list

 STX positionNumber     \ Set the first entry in positionNumber to 0, as the
                        \ winning driver will always be in position 0

 INX                    \ Set X = 1 as a position counter, counting through 1 to
                        \ 19, which denotes the position number that we are
                        \ processing in this iteration of the loop (we skip the
                        \ first position as we already set it)

.sort2

 STX W                  \ Store the position counter in W

 LDY driversInOrder,X   \ Set Y to the number of the driver at position X in the
                        \ driversInOrder list ("this driver")

 TXA                    \ Set the X-th entry in positionNumber to the position
 STA positionNumber,X   \ counter (as the X-th driver is in position X)

 LDA driversInOrder-1,X \ Set X to the number of the driver at position X - 1 in
 TAX                    \ the driversInOrder list ("the driver ahead")

 SEC                    \ Set the C flag for the subtractions below

 BIT G                  \ If bit 6 of G is set, jump to sort5 to compare total
 BVS sort5              \ points

 BMI sort6              \ If bit 7 of G is set, jump to sort6 to compare best
                        \ lap times

                        \ If we get here then bit 6 and 7 of G are clear, so we
                        \ compare most recent lap times

 LDA driverTenths,Y     \ Set (A H U) =   this driver's lap time
 SBC driverTenths,X     \               - lap time of the driver ahead
 STA U                  \
                        \ starting with the low bytes

 LDA driverSeconds,Y    \ Then the high bytes
 SBC driverSeconds,X
 STA H

 LDA driverMinutes,Y    \ And then the top bytes
 SBC driverMinutes,X

 BCC sort7              \ If the subtraction underflowed, then this driver's
                        \ lap time is quicker than the lap time of the driver
                        \ ahead, which is the wrong way round if we are trying
                        \ to create a list where the winner has the fastest lap
                        \ time, so jump to sort7 to swap them around in the
                        \ driversInOrder list

.sort3

 ORA U                  \ At this point (A H U) contains the difference between
 ORA H                  \ the two drivers' times/points, so this jumps to sort4
 BNE sort4              \ if any of the bytes in (A U H) are non-zero, i.e. if
                        \ the two drivers have different times/points

 LDX W                  \ The two drivers have identical times/points, so set
 DEX                    \ we need to set the current driver's position number to
 LDA positionNumber,X   \ be the same as the position number of the driver ahead
 STA positionNumber+1,X \ as there is a tie

.sort4

                        \ If we get here then we move on to the next position

 LDX W                  \ Fetch the position counter that we stored in W above

 INX                    \ Increment the position counter to the next position

 CPX #20                \ Loop back until we have gone through the whole table
 BCC sort2              \ of 20 positions

 LDA V                  \ If V <> 0 then we had to alter the order of the
 BNE sort1              \ driversInOrder list, as it wasn't fully sorted, so
                        \ we jump back to sort1 to repeat the whole process as
                        \ we don't yet know that the list is fully sorted

 CLD                    \ Otherwise the driversInOrder list is sorted, so clear
                        \ the D flag to switch arithmetic to normal

 JSR SetPlayerPositions \ Set the player's current position, plus the position
                        \ ahead and the position behind

 RTS                    \ Return from the subroutine

.sort5

 LDA totalPointsLo,X    \ Set (A H U) =   total points of the driver ahead
 SBC totalPointsLo,Y    \               - this driver's total points
 STA U                  \
                        \ starting with the low bytes

 LDA totalPointsHi,X    \ Then the high bytes
 SBC totalPointsHi,Y
 STA H

 LDA totalPointsTop,X   \ And then the top bytes
 SBC totalPointsTop,Y

 BCC sort7              \ If the subtraction underflowed, then this driver has
                        \ more points than the driver ahead, which is the wrong
                        \ way round if we are trying to create a list where the
                        \ winner has the most points, so jump to sort7 to swap
                        \ them around in the driversInOrder list

 BCS sort3              \ Jump to sort3 to check for a tie and move on to the
                        \ next position (this BCS is effectively a JMP as we
                        \ just passed through a BCC)

.sort6

 LDA bestLapTenths,Y    \ Set (A H U) =   this driver's best lap time
 SBC bestLapTenths,X    \               - best lap time of the driver ahead
 STA U                  \
                        \ starting with the low bytes

 LDA bestLapSeconds,Y   \ Then the high bytes
 SBC bestLapSeconds,X
 STA H

 LDA bestLapMinutes,Y   \ And then the top bytes
 SBC bestLapMinutes,X

 BCS sort4              \ If the subtraction didn't underflow then the drivers
                        \ are in the correct order, so jump to sort4 to move on
                        \ to the next position

                        \ Otherwise the subtraction underflowed, so this
                        \ driver's best lap time is quicker than the best lap
                        \ time of the driver ahead, which is the wrong way round
                        \ if we are trying to create a list where the winner has
                        \ the fastest lap time, so fall through into sort7 to
                        \ swap them around in the driversInOrder list

.sort7

                        \ If we get here then the two drivers we are comparing
                        \ are in the wrong order in the driversInOrder list, so
                        \ we need to swap them round
                        \
                        \ At this point X contains the number of the driver
                        \ ahead and Y contains the number of this driver

 STX T                  \ Store the number of the driver ahead in T

 LDX W                  \ Set X to the position counter

 TYA                    \ Set A to the number of this driver

 STA driversInOrder-1,X \ Set the number of the driver ahead (i.e. the position
                        \ before the one we are processing) to A (i.e. the
                        \ number of this driver)

 LDA T                  \ Set the number of this driver (i.e. the current
 STA driversInOrder,X   \ position) to T (i.e. the number of the driver ahead)

 DEC V                  \ Decrement V so that is it non-zero, to indicate that
                        \ we had to swap an entry in the driversInOrder list

 JMP sort4              \ Jump to sort4 to move on to the next position

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

 LDA raceStarted
 BPL C1032
 BIT L0066
 BPL C102A
 LDA #0
 STA L0066
 STA G
 LDX currentPlayer
 LDA L04B4,X
 CMP #1
 EOR #&FF
 ADC numberOfLaps
 PHP

 JSR GetDriverNumberBCD

 LDX #&0C
 LDY #&21
 JSR Print2DigitBCD-6

 PLP
 BPL C102A

 LDX #53                \ Blank out the first text line at the top of the screen
 JSR PrintSecondLineGap \ and print token 53 on the second line, to give:
                        \
                        \    "                                      "
                        \    "               FINISHED               "

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
 ADC L62EFHi
 STA L62EFHi
 BEQ C104F

 LDA #%00100110         \ Print the current lap time at the top of the screen in
 JSR PrintThisLapTime+2 \ the following format:
                        \
                        \   * %00 Minutes: No leading zeroes, print both digits
                        \   * %10 Seconds: Leading zeroes, print both digits
                        \   * %0  Tenths: Print tenths of a second
                        \   * %11 Tenths: Leading zeroes, no second digit

.C104F

 LDX #1                 \ Zero (currentTenths currentSeconds currentMinutes)+1
 JSR ZeroLapTime

 BEQ C106F              \ Jump to C106F (this BNE is effectively a JMP as the
                        \ ZeroLapTime routine sets the Z flag)

.C1056

 LDA L62EFHi
 BEQ C106A
 DEC L62EFHi
 BNE C106F
 JSR PrintBestLapTime

 LDA #2                 \ Print two spaces
 JSR PrintSpaces

 BEQ C106F

.C106A

 BCC C106F

 JSR PrintThisLapTime   \ Print the current lap time at the top of the screen in
                        \ the following format:
                        \
                        \   * Minutes: No leading zeroes, print both digits
                        \   * Seconds: Leading zeroes, print both digits
                        \   * Tenths: Do not print tenths of a second

.C106F

 LDA qualifyingTime
 BMI C109A
 CMP currentMinutes
 BCC C1089
 BNE C109A
 BIT L0065
 BVS C109A
 LDA #&40
 STA L0065

 LDX #41                \ Print token 41 on the first text line at the top of
 JSR PrintFirstLine     \ the screen, to give:
                        \
                        \   "      Less than one minute to go      "

 RTS                    \ Return from the subroutine

.C1089

 LDA L0065
 BMI C109A

 LDA #&C0
 STA L0065

 LDA #60
 STA L000F

 LDX #42                \ Print token 42 on the first text line at the top of
 JSR PrintFirstLine     \ the screen, to give:
                        \
                        \   "           YOUR TIME IS UP!           "

.C109A

 RTS                    \ Return from the subroutine

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

.P10A1

 LDX #&13

.P10A3

 JSR sub_C147C
 DEX
 BPL P10A3
 LDA L08D0
 ORA L08E8
 BNE P10A1
 LDA #&FF
 STA G
 BNE C10CF

.C10B7

 LDA V
 STA W

.P10BB

 TXA
 PHA
 LDA driversInOrder,X
 TAX
 JSR sub_C14C3
 PLA
 TAX
 DEC W
 BPL P10BB
 INX
 CPX #&14
 BCC C10B7

.C10CF

 INC G
 LDX G
 CPX #&14
 BCC C10B7

.C10D7

 LDX #&17
 JSR sub_C147C
 LDY #&17
 LDX currentPlayer
 SEC
 JSR sub_C27AB
 BCS C10D7
 CMP #&20
 BNE C10D7
 LDX #&17
 LDA #&31
 STA V
 STA L0042

.P10F2

 JSR sub_C14C3
 DEC V
 BNE P10F2

.P10F9

 INC L0042
 JSR sub_C14C3
 BCC P10F9
 LDA #&50
 LDY #&13

.P1104

 LDX driversInOrder,Y
 EOR #&FF
 STA L0178,X
 DEY
 BPL P1104
 LDA #0
 STA L0024

.P1113

 JSR sub_C12F7
 DEC L0042
 BNE P1113
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

 JSR Absolute8Bit       \ Set A = |A|

 CMP #&60
 BCS C1138
 LDA #&14
 BIT L62E2Hi

 JSR Absolute8Bit       \ Set A = |A|

 JMP C1C0B

.C1138

 DEC L62F6
 INC L001F
 JSR sub_C3D5C

 JSR FlushSoundBuffers  \ Flush all four sound channel buffers

 LDA #4
 JSR MakeSound-3
 LDA #0
 LDX #&1E

.P114C

 STA L62D0Lo,X
 DEX
 BPL P114C
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

 LDA #0                 \ Set carMoving = 0 to denote that the car is stationary
 STA carMoving

 STA L006D              \ Set L006D = 0

 JSR SetL018CBit7
 LDX currentPlayer
 JSR sub_C11BE

.C1171

 JSR sub_C5052

 LDY #0                 \ Check for SHIFT and right arrow
 JSR ProcessShiftedKeys

 LDA configStop
 BMI C11AA
 JSR sub_C27ED
 JSR sub_C2692

 JSR SetPlayerPositions \ Set the player's current position, plus the position
                        \ ahead and the position behind

 LDX #&13
 LDA raceStarted
 BMI C1199
 CPX currentPlayer
 BNE C11AA
 LDA L62DFHi
 CMP #&0E
 BCC C1171
 RTS

.C1199

 LDA L018C,X
 AND #&40
 BNE C11A7
 LDA numberOfLaps
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
 STA positionNumber,X

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

 LDA numberOfLaps
 CMP L04B4,X
 LDA #&C0
 STA L018C,X
 BCC C11CD
 STA bestLapMinutes,X

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

 LDX currentPlayer
 STX L0045
 STX L0042
 LDY L0022
 JSR sub_C2937
 LDX #2

.P11DB

 LDA L09FD,X
 STA L6280,X
 LDA L0AFD,X
 STA L6283,X
 DEX
 BPL P11DB
 LDA L0022
 CLC
 ADC #3
 CMP #&78
 BCC C11F5
 LDA #0

.C11F5

 TAY
 LDX L0045
 JSR sub_C2937
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

 LDA trackData+&601,Y
 STA L0900,X
 LDA trackData+&602,Y
 STA L0901,X
 LDA trackData+&603,Y
 STA L0902,X
 LDA trackData+&001,Y
 STA L0A00,X
 LDA trackData+&002,Y
 STA L0A01,X
 LDA trackData+&003,Y
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
 LDA trackData+&604,Y
 STA L0978,X
 LDA trackData+&606,Y
 STA L097A,X
 LDA trackData+&004,Y
 STA L0A78,X
 LDA trackData+&006,Y
 STA L0A7A,X
 LDA trackData+&605,Y
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
 LDA trackData+&600,Y
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

 LDX #44

.P12A2

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
 BPL P12A2
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
 LDA trackData+&6FA
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
 LDA trackData+&607,Y
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
 STA SS
 STA UU
 LDA trackData+&400,Y
 BPL C1398
 DEC SS

.C1398

 ASL A
 ROL SS
 ASL A
 ROL SS
 CLC
 ADC L0900,X
 STA L0978,X
 LDA SS
 ADC L0A00,X
 STA L0A78,X
 LDA trackData+&500,Y
 BPL C13B4
 DEC UU

.C13B4

 ASL A
 ROL UU
 ASL A
 ROL UU
 CLC
 ADC L0902,X
 STA L097A,X
 LDA UU
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
 CPY trackData+&6FB
 BNE C13F8
 LDY #0
 BEQ C13F8

.C13F0

 LDY L0002
 BNE C13F7
 LDY trackData+&6FB

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

.P142B

 JSR sub_C12F7
 DEC L0042
 BNE P142B
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

 LDX currentPlayer
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
 STA SS
 STA TT
 STA UU
 LDA trackData+&100,Y
 STA T
 BPL C1453
 DEC SS

.C1453

 LDA trackData+&200,Y
 STA U
 BPL C145C
 DEC TT

.C145C

 LDA trackData+&300,Y
 STA V
 BPL C1465
 DEC UU

.C1465

 LDA L0025
 BEQ C147B
 LDX #2

.P146B

 LDA #0
 SEC
 SBC T,X
 STA T,X
 LDA #0
 SBC SS,X
 STA SS,X
 DEX
 BPL P146B

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
 CMP trackData+&607,Y
 PHP
 BCC C149B
 TYA
 CLC
 ADC #8
 CMP trackData+&6FA
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
 CMP trackData+&6FC
 BNE C14C1
 LDA L08E8,X
 CMP trackData+&6FD
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
 LDA trackData+&6FA

.C14D2

 SEC
 SBC #8
 STA L06E8,X
 TAY
 LDA trackData+&607,Y
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
 LDA trackData+&6FC
 STA L08D0,X
 LDA trackData+&6FD
 STA L08E8,X
 CPX currentPlayer
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
 CMP trackData+&005,Y
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

 LDA trackData+&600,Y
 AND #1
 BEQ C1527
 LDA trackData+&005,Y
 STA L0017
 BEQ C1527
 LDA trackData+&007,Y
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
\       Name: ProcessDrivingKeys (Part 1 of 6)
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Process joystick steering
\
\ ------------------------------------------------------------------------------
\
\ This routine scans for key presses, or joystick (when configured), and updates
\ the following variables accordingly:
\
\   * Steering: (steeringHi steeringLo)
\
\   * Brake/throttle: throttleBrakeState, throttleBrake
\
\   * Gear changes: gearChangeKey, gearChange, gearNumber
\
\ ******************************************************************************

.ProcessDrivingKeys

 LDA #0                 \ Set V = 0, which we will use to indicate whether any
 STA V                  \ steering is being applied (0 indicates that none is
                        \ being applied, which we may change later)

 STA T                  \ Set T = 0, which we will use to record whether SPACE
                        \ is being pressed, which makes the steering wheel turn
                        \ more quickly

 STA gearChangeKey      \ Set gearChangeKey = 0, which we will use to indicate
                        \ whether any gear change are being applied (0 indicates
                        \ that no gear changes are being applied, which we may
                        \ change later)

IF _ACORNSOFT

 BIT configJoystick     \ If bit 7 of configJoystick is clear then the joystick
 BPL keys2              \ is not configured, so jump to keys2 to check for key
                        \ presses for the steering

 LDX #&9D               \ Scan the keyboard to see if SPACE is being pressed, as
 JSR ScanKeyboard       \ this will affect the speed of any steering changes

 PHP                    \ Store the result of the scan on the stack

ELIF _SUPERIOR

 LDX #&9D               \ Scan the keyboard to see if SPACE is being pressed, as
 JSR ScanKeyboard       \ this will affect the speed of any steering changes

 PHP                    \ Store the result of the scan on the stack

 BIT configJoystick     \ If bit 7 of configJoystick is clear then the joystick
 BPL keys2              \ is not configured, so jump to keys2 to check for key
                        \ presses for the steering

ENDIF

 LDX #1                 \ Read the joystick x-axis into A and X (A is set to the
 JSR GetADCChannel      \ high byte of the channel, X is set to the sign of A
                        \ where 0 = negative/left, 1 = positive/right)

 STA U                  \ Store the x-axis high byte in U

 JSR Multiply8x8        \ Set (A T) = A * U
                        \           = A * A
                        \           = A^2
                        \           = x-axis^2

 PLP                    \ Retrieve the result of the keyboard scan above, when
                        \ we scanned for SPACE

 BEQ keys1              \ If SPACE is being pressed, jump to keys1 so the value
                        \ of (A T) will be four times higher

 LSR A                  \ Set (A T) = (A T) / 4
 ROR T                  \           = x-axis^2 / 4
 LSR A
 ROR T

.keys1

IF _ACORNSOFT

 PHA

ELIF _SUPERIOR

 STA U                  \ Set (U T) = (A T)

ENDIF

 LDA T                  \ Clear bit 0 of T
 AND #%11111110
 STA T

 TXA                    \ Set bit 0 of T to the sign bit in X (1 = right,
 ORA T                  \ 0 = left)
 STA T

IF _ACORNSOFT

 PLA

 JMP keys11

ELIF _SUPERIOR

 LDA U                  \ Set (A T) = (U T)
                        \
                        \ so (A T) contains the joystick x-axis high byte,
                        \ squared, divided by 4 if SPACE is not being pressed,
                        \ and converted into a sign-magnitude number with the
                        \ sign in bit 0 (0 = left, 1 = right)

 JMP AssistSteering     \ Jump to AssistSteering, which in turn jumps back to
                        \ keys7 or keys11 in part 2

 NOP                    \ These instructions are unused, and are included to
 NOP                    \ pad out the code from when the steering assist code
                        \ was inserted into the original version

ENDIF

\ ******************************************************************************
\
\       Name: ProcessDrivingKeys (Part 2 of 6)
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Process keyboard steering
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.keys2

 LDX #&A9               \ Scan the keyboard to see if "L" is being pressed
 JSR ScanKeyboard

 BNE keys3              \ If "L" is not being pressed, jump to keys3

 LDA #2                 \ Set V = 2
 STA V

.keys3

 LDX #&A8               \ Scan the keyboard to see if ";" is being pressed
 JSR ScanKeyboard

 BNE keys4              \ If ";" is not being pressed, jump to keys4

 INC V                  \ Set V = 1

.keys4

                        \ By this point, we have:
                        \
                        \   * V = 1 if ";" is being pressed (steer right)
                        \
                        \   * V = 2 if "L" is being pressed (steer left)
                        \
                        \   * V = 0 if neither is being pressed

 LDA #3                 \ Set U = 3
 STA U

IF _ACORNSOFT

 LDX #&9D               \ Scan the keyboard to see if SPACE is being pressed
 JSR ScanKeyboard

ELIF _SUPERIOR

 PLP                    \ Retrieve the result of the keyboard scan above, when
                        \ we scanned for SPACE

ENDIF

 BEQ keys6              \ If SPACE is being pressed, jump to keys6

 LDA #0                 \ Set A = 0

 LDX #2                 \ If steeringHi > 2, jump to keys5 to skip the following
 CPX steeringHi         \ instruction
 BCC keys5

 LDA #1                 \ Set A = 1

.keys5

 STA U                  \ Set U = A, which will be 1 if steeringHi > 2, or
                        \ 0 otherwise

 LDA #128               \ Set T = 128
 STA T

.keys6

 LDA V                  \ If V = 0 then no steering is being applied, so jump to
 BEQ keys7              \ keys7

 CMP #3                 \ If V = 3, jump to keys13 to move on to the throttle
 BEQ keys13             \ and brake keys without applying any steering

 EOR steeringLo         \ If bit 0 of steeringLo is clear, jump to keys9
 AND #1
 BEQ keys9

 JSR Negate16Bit+2      \ Set (A T) = -(U T)

 JMP keys8              \ Jump to keys8

.keys7

 LDA L62DAHi            \ Set T = L62DAHi top nibble only
 AND #&F0
 STA T

 LDA L62EAHi            \ Set (A T) = (L62EAHi L62DAHi-top-nibble)

 JSR Absolute16Bit      \ Set (A T) = |A T|

 LSR A                  \ Set (A T) = (A T) >> 2
 ROR T                  \           = |A T| / 4
 LSR A
 ROR T

IF _ACORNSOFT

 CMP #12
 BCC keys8
 LDA #12

ELIF _SUPERIOR

 CMP steeringHi         \ If A < steeringHi, clear the C flag
                        \ If A >= steeringHi, set the C flag

 JSR sub_C1F9B          \ If the C flag is set (i.e. A >= steeringHi), set:
                        \
                        \   (A T) = (steeringHi steeringLo) with bit 0 cleared

ENDIF

.keys8

 STA U                  \ Set (U T) = (A T)

.keys9

IF _ACORNSOFT

 LDA steeringLo

ELIF _SUPERIOR

 JMP AssistSteeringKeys \ Jump to AssistSteeringKeys, which in turn jumps back
                        \ to keys10, so this is effectively a JSR call

ENDIF

.keys10

 SEC
 SBC T
 STA T
 LDA steeringHi
 SBC U

 CMP #200
 BCC keys11

 JSR Negate16Bit        \ Set (A T) = -(A T)

 STA U

 LDA T
 EOR #1
 STA T

 LDA U

.keys11

 CMP #145
 BCC keys12

 LDA #145

.keys12

 STA steeringHi         \ Set (steeringHi steeringLo) = (A T)
 LDA T
 STA steeringLo

\ ******************************************************************************
\
\       Name: ProcessDrivingKeys (Part 3 of 6)
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Process joystick brake and throttle
\
\ ******************************************************************************

.keys13

 LDA L000F              \ If L000F is non-zero, jump to keys19 to skip the whole
 BNE keys19             \ brake/throttle section

 BIT configJoystick     \ If bit 7 of configJoystick is clear then the joystick
 BPL keys15             \ is not configured, so jump to keys15 to check for key
                        \ presses for the brake/throttle

 LDX #2                 \ Read the joystick y-axis into A and X, clearing the
 JSR GetADCChannel      \ C flag if A < 10, setting A to the high byte, and
                        \ setting X to 1 if the stick is up, or 0 if the stick
                        \ is down

 BCC keys19             \ If A < 10 then the joystick is pretty close to the
                        \ centre, so jump to keys19 so we don't register any
                        \ throttle or brake activity

 STA T                  \ Set T = A / 2
 LSR T

 ASL A                  \ Set A = A * 2

 ADC T                  \ Set A = A + T
                        \       = A * 2 + A / 2
                        \       = 2.5 * A

 BCS keys14             \ If the addition overflowed, the the joystick has moved
                        \ a long way from the centre, so jump to keys14 to apply
                        \ the brakes or throttle at full power

 CMP #250               \ If A < 250, jump to keys20 to store A in throttleBrake
 BCC keys20             \ and X in throttleBrakeState, so we store the amount of
                        \ brakes or throttle to apply

.keys14

 CPX #0                 \ If X = 0 then the joystick y-axis is negative (down),
 BEQ keys18             \ so jump to keys18 to apply the brakes

 BNE keys16             \ Otherwise the joystick y-axis is positive (up), so
                        \ jump to keys16 to increase the throttle (this BNE is
                        \ effectively a JMP as we already know X is non-zero)

\ ******************************************************************************
\
\       Name: ProcessDrivingKeys (Part 4 of 6)
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Process keyboard brake and throttle
\
\ ******************************************************************************

.keys15

 LDX #&AE               \ Scan the keyboard to see if "S" is being pressed (the
 JSR ScanKeyboard       \ throttle key)

 BNE keys17             \ If "S" is not being pressed, jump to keys17 to check
                        \ the next key

 LDX #1                 \ Set X = 1 to store in throttleBrakeState below

.keys16

 LDA #255               \ Set A = 255 to store in throttleBrake below

 BNE keys20             \ Jump to keys20 (this BNE is effectively a JMP as A is
                        \ never zero)

.keys17

 LDX #&BE               \ Scan the keyboard to see if "A" is being pressed (the
 JSR ScanKeyboard       \ brake key)

 BNE keys19             \ If "A" is not being pressed, jump to keys19

 LDX #0                 \ Set X = 0 to store in throttleBrakeState below

.keys18

 LDA #250               \ Set A = 250 to store in throttleBrake below

 BNE keys20             \ Jump to keys20 (this BNE is effectively a JMP as A is
                        \ never zero)

.keys19

                        \ If we get here then neither of the throttle keys are
                        \ being pressed, or the joystick isn't being moved
                        \ enough to register a change

 LDX #%10000000         \ Set bit 7 of X to store in throttleBrakeState below

 LDA revs               \ Set A = 5 + revs / 4
 LSR A                  \
 LSR A                  \ to store in throttleBrake below
 CLC
 ADC #5

.keys20

 STX throttleBrakeState \ Store X in throttleBrakeState

 STA throttleBrake      \ Store A in throttleBrake

                        \ By the time we get here, one of the following is true:
                        \
                        \   * There is no brake or throttle action from keyboard
                        \     or joystick:
                        \
                        \       throttleBrakeState = bit 7 set
                        \       throttleBrake = 5 + revs / 4
                        \
                        \   * Joystick is enabled and 2.5 * y-axis < 250 (so
                        \     joystick is in the zone around the centre)
                        \
                        \       throttleBrakeState = 0 for joystick down, brake
                        \                            1 for joystick up, throttle
                        \       throttleBrake = 2.5 * y-axis
                        \
                        \   * "S" (throttle) is being pressed (or joystick has
                        \     2.5 * y-axis >= 250):
                        \
                        \       throttleBrakeState = 1
                        \       throttleBrake = 255
                        \
                        \   * "A" (brake) is being pressed (or joystick has
                        \     2.5 * y-axis >= 250)
                        \
                        \       throttleBrakeState = 0
                        \       throttleBrake = 250

\ ******************************************************************************
\
\       Name: ProcessDrivingKeys (Part 5 of 6)
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Process joystick gear change
\
\ ******************************************************************************

 BIT configJoystick     \ If bit 7 of configJoystick is clear then the joystick
 BPL keys21             \ is not configured, so jump to keys21 to skip the
                        \ following joystick-specific gear checks

 LDX #0                 \ Call OSBYTE with A = 128 and X = 0 to fetch the ADC
 LDA #128               \ channel that was last used for ADC conversion,
 JSR OSBYTE             \ returning the channel number in Y, and the status of
                        \ the two fire buttons in X

 TXA                    \ If bit 0 of X is zero, then no fire buttons are being
 AND #1                 \ pressed, so jump to keys22 to check the next key
 BEQ keys22

 LDY throttleBrakeState \ If throttleBrakeState <> 1, then the throttle is not
 DEY                    \ being applied, so jump to keys23
 BNE keys23

                        \ If we get here then the fire button is being pressed
                        \ and the throttle is being applied, which is the
                        \ joystick method for changing gear, so now we jump to
                        \ the correct part below to change up or down a gear

 LDA throttleBrake      \ If the throttle amount is >= 200, jump to keys24 to
 CMP #200               \ change up a gear
 BCS keys24

 BCC keys23             \ Otherwise jump to keys23 to change down a gear

\ ******************************************************************************
\
\       Name: ProcessDrivingKeys (Part 6 of 6)
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Process keyboard gear change
\
\ ******************************************************************************

.keys21

 LDX #&9F               \ Scan the keyboard to see if TAB is being pressed
 JSR ScanKeyboard

 BEQ keys23             \ If TAB is being pressed, jump to keys23

 LDX #&EF               \ Scan the keyboard to see if "Q" is being pressed
 JSR ScanKeyboard

 BEQ keys24             \ If "Q" is being pressed, jump to keys24

.keys22

                        \ If we get here then the gear is not being changed

 LDA #0                 \ Set gearChange = 0 to indicate that we are not in the
 STA gearChange         \ process of changing gear

 BEQ keys28             \ Jump to keys28 to return from the subroutine (this BEQ
                        \ is effectively a JMP as A is always zero)

.keys23

                        \ If we get here then either TAB is being pressed, or
                        \ the joystick fire button is being pressed while the
                        \ stick is in the "change down" part of the joystick
                        \ range, so we need to change down a gear

 LDA #&FF               \ Set A = -1 so we change down a gear

 BNE keys25             \ Jump to keys25 to change the gear 

.keys24

                        \ If we get here then either "Q" is being pressed, or
                        \ the joystick fire button is being pressed while the
                        \ stick is in the "change up" part of the joystick
                        \ range, so we need to change up a gear

 LDA #1                 \ Set A = 1 so we change up a gear

.keys25

 DEC gearChangeKey      \ Set bit 7 of gearChangeKey (as we set gearChangeKey to
                        \ zero above)

 LDX gearChange         \ If gearChange is non-zero then we are already changing
 BNE keys28             \ gear, so jump to keys28 to return from the subroutine

 STA gearChange         \ Set gearChange to -1 or 1

 CLC                    \ Add A to the current gearNumber to get the number of
 ADC gearNumber         \ the new gear, after the change

 CMP #&FF               \ If the gear change will result in a gear of -1, jump
 BEQ keys26             \ to keys26 to set the gear number to 0 (the lowest gear
                        \ number)

 CMP #7                 \ If the new gear is not 7, jump to keys27 to change to
 BNE keys27             \ this gear

 LDA #6                 \ Otherwise set A to 6, which is the highest gear number
 BNE keys27             \ allowed, and jump to keys27 to set this as the new
                        \ gear number (this BNE is effectively a JMP as A is
                        \ never zero)

.keys26

 LDA #0                 \ If we get here then we just tried to change down too
                        \ far, so set the number of the new gear to zero

.keys27

 STA gearNumber         \ Store the new gear number in gearNumber

 JSR PrintGearNumber    \ Print the new gear number on the gear stick

.keys28

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: MainDrivingLoop (Part 1 of 5)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Main driving loop: Switch to the track and start the main loop
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   configStop          Contains details of why we are exiting the driving loop:
\
\                         * Bit 5 set = retire from race/lap
\                           (SHIFT-f7 pressed)
\                       
\                         * Bit 7 and bit 6 set = pit stop
\                           (SHIFT-f0 pressed)
\
\                         * Bit 7 set and bit 6 clear = restart game
\                           (SHIFT and right arrow pressed)
\
\ ******************************************************************************

.MainDrivingLoop

 JSR SetCustomScreen    \ Switch to the custom screen mode, which also sets
                        \ screenSection to -2, so the interrupt handler doesn't
                        \ do any palette switching just yet, but leaves the
                        \ palette mapped to black, so the screen is blank

 LDA #0                 \ Set printMode = 0 so text printing pokes directly into
 STA printMode          \ screen memory

 JSR CopyDashData       \ Copy the dash data from the main game code to screen
                        \ memory

 JSR DrawTrackView      \ Copy the data from the dash data blocks to the screen
                        \ to draw the track view, though as the screen is
                        \ currently mapped to black, this doesn't show anything,
                        \ but it does zero all the dash data blocks, so they are
                        \ ready to be filled with the track view

 BIT configStop         \ If bit 6 of configStop is set then we are returning to
 BVS main4              \ the track after visiting the pits, so jump to main4
                        \ to reset the pit stop flag and enter the driving loop

.main1

                        \ We jump back here when restarting practice laps

 LDX #0                 \ Zero (currentTenths currentSeconds currentMinutes)
 JSR ZeroLapTime

.main2

                        \ We jump back here when restarting qualifying laps

 JSR sub_C1805          \ ??? Set up the top two text lines

.main3

                        \ We jump back here when restarting a Novice race

 JSR sub_C11CE          \ ??? Sets up the track

.main4

 LDA #0                 \ Set configStop = 0 so we clear out any existing
 STA configStop         \ stop-related key presses

 JSR sub_C0B77          \ ??? Something to do with wing settings

\ ******************************************************************************
\
\       Name: MainDrivingLoop (Part 2 of 5)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Main driving loop: The body of the main loop
\
\ ******************************************************************************

.main5

                        \ The main driving loop starts here, and we loop back to
                        \ here from part 5

 JSR sub_C5052

 JSR sub_C7B4A

 JSR ProcessDrivingKeys \ Check for and process the main driving keys

 JSR sub_C46A1

 JSR sub_C24F6

 JSR sub_C4626

 JSR sub_C24B9

 JSR sub_C0FFE

 JSR sub_C0E74

 JSR Reset0554          \ Reset the blocks at L05A4, L0554, L0600, L0650 and
                        \ L5F60

 JSR sub_C1A20

 JSR sub_C0E74

 JSR sub_C18BC

 JSR sub_C4CA4

 LDX #23
 JSR sub_C2AD1

 JSR sub_C1B12

 JSR sub_C2637

 JSR sub_C1E15

 JSR UpdateMirrors      \ Update the view in the wing mirrors

 JSR sub_C0E74

 JSR sub_C4F44

 JSR sub_C1BB9

 JSR sub_C111E

 JSR DrawTrackView      \ Copy the data from the dash data blocks to the screen
                        \ to draw the track view

\ ******************************************************************************
\
\       Name: MainDrivingLoop (Part 3 of 5)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Main driving loop: Process rejoining the race or lap after a crash
\
\ ******************************************************************************

 LDA screenSection      \ If screenSection is positive, jump to main6 to skip
 BPL main6              \ the following instruction

 INC screenSection      \ If screenSection is negative, then we increment it
                        \
                        \ This kickstarts the custom screen interrupt handler
                        \ on the first time round the main driving loop, as the
                        \ call to SetCustomScreen at the start of the routine
                        \ sets screenSection to -2, and this increment bumps it
                        \ up to -1, which makes the screen handler start
                        \ applying the custom screen effect
                        \
                        \ In other words, this displays the driving screen for
                        \ the first time, after waiting for all the drawing
                        \ routines in part 2 to finish, so we don't get to see
                        \ the screen being drawn

.main6

 LDA L62F6              \ If L62F6 = 0, jump to main10 to continue the main
 BEQ main10             \ driving loop in part 5

 INC L62F6              \ Otherwise L62F6  is non-zero, so increment L62F6

                        \ We now pause for a few seconds, before jumping back to
                        \ the relevant starting point for the loop

 LDA #156               \ Set irqCounter = 156
 STA irqCounter

.main7

 LDA irqCounter         \ Fetch irqCounter, which gets incremented every time
                        \ the IRQ routine reaches section 4 of the custom screen

 BMI main7              \ Loop back to main7 until irqCounter increments round
                        \ to zero (so we wait for it to go from 156 to 0, which
                        \ takes around three seconds at 50 ticks per second)

.main8

 LDA qualifyingTime     \ If bit 7 of qualifyingTime is set then this is a
 BMI main1              \ practice lap (i.e. qualifyingTime = 255), so jump back
                        \ to main1

 LDA raceStarted        \ If bit 7 of raceStarted is clear then this is either
 BPL main2              \ a practice or qualifying lap, but we didn't just jump
                        \ to main1, so this must be qualifying, so jump back to
                        \ main2

 LDA raceClass          \ If raceClass = 0 then this is a Novice race, so jump
 BEQ main3              \ back to main3

                        \ Otherwise this is an Amateur or a Professional race,
                        \ and not a Novice race, practice or a qualifying lap

\ ******************************************************************************
\
\       Name: MainDrivingLoop (Part 4 of 5)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Main driving loop: Leave the track
\
\ ******************************************************************************

.main9

                        \ If we get here then either:
                        \
                        \   * We have quit the race or lap by pressing SHIFT-f4
                        \     (in which case we jumped here from part 5)
                        \
                        \   * This is either an Amateur or a Professional race
                        \     and we crashed (in which case we fell through from
                        \     part 3)
                        \
                        \   * L000F = 1 (in which case we jumped here from part
                        \     5)
                        \
                        \ In all cases, we are done racing and need to leave
                        \ the track

 JSR FlushSoundBuffers  \ Flush all four sound channel buffers

 LDA qualifyingTime     \ If bit 7 of qualifyingTime is set then this is a
 BMI main8              \ practice lap (i.e. qualifyingTime = 255), so jump to
                        \ main1 via main8, so we start a new practice lap

 LDX #48                \ Blank out the first text line at the top of the screen
 JSR PrintSecondLineGap \ and print token 48 on the second line, to give:
                        \
                        \    "                                      "
                        \    "             PLEASE  WAIT             "

 JSR sub_C1163          \ ???

 LDA configStop         \ If bit 7 of configStop is set then we must be pressing
 BMI main13             \ either SHIFT-f0 for a pit stop or SHIFT and right
                        \ arrow to restart the game, so jump to main13 to leave
                        \ the track

 LDA #%00100000         \ Set bit 5 of configStop to indicate that we have
 STA configStop         \ retired from the race (so we leave the track
                        \ permanently rather than just visiting the pits)

 BNE main13             \ Jump to main13 to leave the track (this BNE is
                        \ effectively a JMP as A is never zero)

\ ******************************************************************************
\
\       Name: MainDrivingLoop (Part 5 of 5)
\       Type: Subroutine
\   Category: Main loop
\    Summary: Main driving loop: Process driving keys, potentially leaving the
\             track, and loop back to part 2
\
\ ******************************************************************************

.main10

IF _ACORNSOFT

 LDY #9                 \ Check for all the shifted keys (i.e. those that need
 JSR ProcessShiftedKeys \ SHIFT holding down to trigger) and process them
                        \ accordingly

ELIF _SUPERIOR

 LDY #11                \ Check for all the shifted keys (i.e. those that need
 JSR ProcessShiftedKeys \ SHIFT holding down to trigger) and process them
                        \ accordingly

ENDIF

 LDA configStop         \ If configStop = 0, then we aren't pressing one of the
 BEQ main11             \ keys that stops the race, so jump to main11 to keep
                        \ iterating round the main driving loop

 BPL main9              \ If bit 7 of configStop is clear then we must be
                        \ pressing SHIFT-f7 to retire from the race, so jump to
                        \ main9 to leave the track

 AND #%01000000         \ If bit 6 of configStop is clear (and we know bit 7 is
 BEQ main13             \ set), then we must be pressing SHIFT and right arrow,
                        \ so jump to main13 to leave the track and restart the
                        \ game

                        \ If we get here then we know both bit 6 and bit 7 must
                        \ be set, so we must be pressing SHIFT-f0 to return to
                        \ the pits

 LDA carMoving          \ If carMoving = 0 then the car is stationary, so jump
 BEQ main13             \ to main13 to leave the track and return to the pits

 LDA #0                 \ We can't enter the pits if the car is moving, so set
 STA configStop         \ configStop = 0 so we clear out the SHIFT-f4 key press

.main11

 LDX L000F              \ Set X = L000F

 BEQ main12             \ If X = 0, i.e. L000F = 0, jump to main12 to continue
                        \ the main driving loop

 DEX                    \ Set X = L000F - 1

 BEQ main9              \ If X = 0, i.e. L000F = 1, jump to main9 to leave the
                        \ track

 STX L000F              \ Set L000F = X, i.e. decrement L000F when it is neither
                        \ 0 or 1

.main12

 JSR sub_C0E74          \ ??? Sound related

 JSR UpdateDashboard    \ Update the rev counter on the dashboard

 JMP main5              \ Loop back to main5 to repeat the main driving loop

.main13

                        \ If we get here then we leave the track and switch back
                        \ to mode 7, either to visit the pits or because the
                        \ driving is done

 LDA #%10000000         \ Copy the dash data from screen memory back to the main
 JSR CopyDashData       \ game code

 JSR KillCustomScreen   \ Disable the custom screen mode and switch to mode 7

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: sub_C17C3
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   0 or 1
\
\ ******************************************************************************

.sub_C17C3

 SED                    \ Set the D flag to switch arithmetic to Binary Coded
                        \ Decimal (BCD)

 LDA #9
 LDY L0046
 CPY trackData+&719
 BNE C17CF
 LDA #&18

.C17CF

 CLC
 ADC currentTenths,X
 STA currentTenths,X
 PHP
 LDA currentSeconds,X
 ADC #0
 CMP #&60
 BCC C17E2
 LDA #0

.C17E2

 STA currentSeconds,X
 LDA currentMinutes,X
 ADC #0
 STA currentMinutes,X
 BPL C17F9

 JSR ZeroLapTime          \ Zero (currentTenths currentSeconds currentMinutes)+X

 LDY currentPlayer
 LDA #&80
 STA bestLapMinutes,Y

.C17F9

 PLP

 CLD                    \ Clear the D flag to switch arithmetic to normal

 RTS

\ ******************************************************************************
\
\       Name: PrintSecondLineGap
\       Type: Subroutine
\   Category: Text
\    Summary: Prints a text token on the second text line at the top of the
\             driving screen, with an empty gap on the line above
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The token number (0 to 54) to print on the second text
\                       line at the top of the screen
\
\ ******************************************************************************

.PrintSecondLineGap

 JSR PrintSecondLine    \ Print token X on the second text line at the top of
                        \ the screen

 LDX #45                \ Print token 45 (38 spaces) on the first text line of
 JSR PrintFirstLine     \ at the top of the screen, which blanks the top line

 RTS                    \ Return from the subroutine

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

.P1809

 STA carMoving,X
 DEX
 BPL P1809
 LDX #&7F

.P1810

 STA L6280,X
 DEX
 BPL P1810

 JSR DefineEnvelope

 LDX #&17
 STX L62F9

.P181E

 LDA trackData+&6FF
 STA L08E8,X
 LDA trackData+&6FE
 STA L08D0,X
 LDA #0
 STA L06E8,X
 STA L0880,X
 DEX
 BPL P181E

 JSR SetPlayerPositions \ Set the player's current position, plus the position
                        \ ahead and the position behind

 LDA #1
 BIT raceStarted
 BMI C184C
 LDX trackData+&717
 LDY currentPosition
 JSR SwapDriverPosition

 JSR SetPlayerPositions \ Set the player's current position, plus the position
                        \ ahead and the position behind

 LDA trackData+&718

.C184C

 JSR sub_C109B
 LDX #&13

.C1851

 LDA #&80
 STA L018C,X
 STA bestLapMinutes,X
 LDA #0
 STA L04B4,X
 STA L0114,X
 STA L0164,X
 STA L3850Hi,X
 STA positionNumber,X
 STA L3850Lo,X
 LDA #&FF
 STA L01A4,X
 DEX
 BPL C1851
 LDA #1
 STA gearNumber
 STA L0030
 LDX #7
 STX L0009
 DEX
 STX L0006
 STX L0008
 DEX

.P1885

 STA L6293,X
 DEX
 BPL P1885
 JSR PrintGearNumber
 LDA raceStarted
 BMI C18A5

 LDX #40                \ Blank out the first text line at the top of the screen
 JSR PrintSecondLineGap \ and print token 40 on the second line, to give:
                        \
                        \    "                                      "
                        \    "Lap Time   :         Best Time        "

 LDX #1                 \ Zero (currentTenths currentSeconds currentMinutes)+1
 JSR ZeroLapTime

 JSR PrintBestLapTime

 LDA #&DF
 STA L62EFHi

 RTS

.C18A5

 STA L0066
 STA L62FE

 LDX #43                \ Print token 43 on the first text line at the top of
 JSR PrintFirstLine     \ the screen and token 44 on the second line, to give:
 LDX #44                \
 JSR PrintSecondLine    \    "Position        In front:             "
                        \    "Laps to go        Behind:                  "
                        \
                        \ Token 44 includes five extra spaces at the end, though
                        \ I'm not sure why

 LDA currentPosition
 JSR GetDriverNumberBCD
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
 LDY #79

.P18DD

 LDX L5F60,Y
 BEQ C18E3
 TXA

.C18E3

 STA L5F60,Y
 DEY
 BPL P18DD
 RTS

\ ******************************************************************************
\
\       Name: CopyDashData
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Copy the dash data from the main game code to screen memory, and
\             vice versa
\  Deep dive: The jigsaw puzzle binary
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The direction of the copy:
\
\                         * Bit 7 clear = copy from game code to screen memory
\
\                         * Bit 7 set = copy from screen memory to game code
\
\ ******************************************************************************

.CopyDashData

 STA T                  \ Store A in T, so bit 7 of T determines the direction
                        \ of the copy

 LDX #3                 \ First, we copy the four bytes at dashDataAddress to
                        \ P, Q, R and S, so set a loop counter in X for the four
                        \ bytes

.dash1

 LDA dashDataAddress,X  \ Copy the X-th byte of dashDataAddress to the X-th
 STA P,X                \ byte of P

 DEX                    \ Decrement the loop counter

 BPL dash1              \ Loop back until we have copied all four bytes

                        \ So we now have the following:
                        \
                        \   (Q P) = the location of the first block in the main
                        \           game code
                        \
                        \   (S R) = the location of the first block in screen
                        \           memory (i.e. at the end of screen memory, as
                        \           the first block in the game code is the last
                        \           block in screen memory)
                        \
                        \ We now copy 41 blocks of memory from one address to
                        \ the other, with the direction determined by the value
                        \ of bit 7 in T (which we set above)
                        \
                        \ We work through each block by starting at offset 79
                        \ from the start of (Q P) and (S R), and decrementing
                        \ the offset until it matches the dashDataOffset value
                        \ for this block
                        \
                        \ We store the block number (which goes from 0 to 40)
                        \ in X, and the offset (which goes from 79 down to
                        \ dashDataOffset,X + 1) in Y

 LDX #0                 \ Set a block counter in X to count through 41 blocks

.dash2

 LDY #79                \ Each block we want to copy ends at the start address
                        \ plus 79, so set an index counter in Y, which we can
                        \ use to work our way backwards through each byte in
                        \ the block

 LDA #0                 \ Set V = 0 to act as a byte counter to go from 0 to the
 STA V                  \ number of bytes copied

.dash3

 BIT T                  \ If bit 7 of T is set, skip the following two
 BMI dash4              \ instructions so we copy from (S R) to (Q P)

 LDA (P),Y              \ Copy the Y-th byte of (Q P) to the Y-th byte of (S R)
 STA (R),Y

.dash4

 LDA (R),Y              \ Copy the Y-th byte of (S R) to the Y-th byte of (Q P)
 STA (P),Y

 INC V                  \ Increment the byte counter

 DEY                    \ Decrement the index counter

 TYA                    \ If Y <> the dashDataOffset value for block X, loop
 CMP dashDataOffset,X   \ to keep copying the contents of this block
 BNE dash3

                        \ We have copied a block of memory, so we now need to
                        \ update (Q P) and (S R) to point to the next block to
                        \ copy
                        \
                        \ When in screen memory, the blocks are stored one after
                        \ the other, in reverse order, so the address of the
                        \ next block to copy is the start address of the block
                        \ we just copied in (S R), minus the size of the block
                        \ we just copied, which is in V, so the next block will
                        \ be at (S R) - V

 LDA R                  \ Set (S R) = (S R) - V
 SEC                    \
 SBC V                  \ starting with the low bytes
 STA R

 BCS dash5              \ And decrementing the high byte of (S R) if the low
 DEC S                  \ byte wraps around

.dash5

                        \ When in the main game code, the blocks are stored
                        \ every &80 bytes, so the address of the next block is
                        \ (Q P) + &80
                        \
                        \ Note that each block takes up a different amount of
                        \ memory, as follows:
                        \
                        \   Block starts at: (Q P) + dashDataOffset,X + 1
                        \   Block ends at:   (Q P) + 79
                        \
                        \ It's the value of (Q P) that is spaced out by &80 for
                        \ each block, rather than the actual data in the block
                        \ (for each block, (Q P) to (Q P) + dashDataOffset,X
                        \ is used for other purposes)

 LDA P                  \ Set (Q P) = (Q P) + &80
 CLC                    \
 ADC #&80               \ starting with the low bytes
 STA P

 BCC dash6              \ And incrementing the high byte of (Q P) if the low
 INC Q                  \ byte overflows

.dash6

 INX                    \ Increment the block counter to point to the next block
                        \ to copy

 CPX #41                \ Loop back to copy the next block until we have copied
 BNE dash2              \ all 41 blocks

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: dashDataAddress
\       Type: Variable
\   Category: Dashboard
\    Summary: Addresses for copying the first block of dash data between the
\             main game code and screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashDataAddress

 EQUW dashData          \ The location of the first block in the game code

 EQUW &8000 - 80        \ The location of the first block in screen memory

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

 STA P196F+1
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

 CMP N
 BCS C19A5

.C1969

 STA RR
 TXA
 JMP C1973

.P196F

 STA L0400,Y
 DEY

.C1973

 CPY RR
 BNE P196F

.C1977

 STY N

.C1979

 INX
 BMI C1996
 CPX U
 BCC C194E

.C1980

 LDA L5F20,X
 BMI C198E
 CMP N
 BCC C198E
 LDA N
 STA L5F20,X

.C198E

 TXA
 ORA #&80
 TAX
 LDA #0
 BEQ C1969

.C1996

 LDX L0050

.P1998

 LDA L5EE0,X
 BPL C19A2
 INX
 CPX U
 BCC P1998

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
 STA mod_C2F4E+2
 STA mod_C2F90+2
 LDA L2B22,Y
 STA mod_C2F4E+1
 STA mod_C2F90+1
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

 LDA KK
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
 STA MM
 LDY L0012
 JSR sub_C193E
 LDY #0
 STY L0032
 LDA L0050
 JSR sub_C19AF
 LDA #8
 STA L0032
 LDY #0
 STY KK
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
 STA KK
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

 STX GG
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
 LDA GG
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

.P1AD8

 LDA L5EE1,X
 BPL C1AE4
 INX
 INC U
 CPX L004B
 BCC P1AD8

.C1AE4

 LDA L5F60,Y
 STA T
 LDA L5F60,Y
 BEQ C1AF9
 AND #&1C
 CMP GG
 BEQ C1AF9
 ROR A
 EOR T
 BMI C1B03

.C1AF9

 LDA L5EE0,X
 AND #3
 ORA GG
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
 STA colourByte+2

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

.P1B5B

 ASL T
 ROL U
 DEY
 BNE P1B5B
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
 STA colourByte+2
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

 SED                    \ Set the D flag to switch arithmetic to Binary Coded
                        \ Decimal (BCD)

 CLC
 ADC L0031
 STA L0031

 CLD                    \ Clear the D flag to switch arithmetic to normal

 BEQ C1BA2
 CMP #&21
 BCS C1BA2
 LDX #0
 STX L002F
 STX G
 LDX #&0A
 LDY #&18
 JSR Print2DigitBCD-6

.C1BA2

 BIT L62FE
 BPL C1BB5

 LDY positionAhead      \ Set Y to the position of the driver in front of us

 LDA #24                \ Print the name of driver Y in the "In front:" part of
 JSR PrintNearestDriver \ the header

 LDY positionBehind     \ Set Y to the position of the driver behind us

 LDA #33                \ Print the name of driver Y in the "Behind:" part of
 JSR PrintNearestDriver \ the header

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
 LDY currentPlayer
 CMP #&28
 BCC C1BDF
 LDA raceStarted
 BPL C1BDF
 JSR sub_C11AB

.C1BDF

 LDA L0398,X
 SEC
 SBC L000B
 ASL A
 ASL A
 PHP
 LDA L3850Hi,Y
 CPX #&14
 BCS C1BFE
 CMP L3850Hi,X
 BCS C1BF9
 LDA L3850Hi,X
 BNE C1BFE

.C1BF9

 ADC #&0B
 STA L3850Hi,X

.C1BFE

 JSR Multiply8x8        \ Set (A T) = A * U

 CMP #&10
 BCC C1C07
 LDA #&10

.C1C07

 PLP

 JSR Absolute16Bit      \ Set (A T) = |A T|

.C1C0B

 STA L62E2Hi
 LDA #&80
 STA L62A6
 STA L62A7
 LDA #4
 JSR MakeSound-3

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

 STY J
 LDX H
 STX G
 AND #3
 TAX
 LDA L628F,X
 STA H
 LDA UU
 STA K
 LDA TT
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
 LDA M
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
 STA M
 LSR A
 LSR A
 STA UU
 JMP C1C66

.C1C5A

 LDA LL
 STA UU
 LDA NN
 STA M
 CPY #0
 BNE C1C7B

.C1C66

 LDA SS
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
 STA NN
 LSR A
 LSR A
 STA LL

.C1C7B

 LDA UU
 CMP #&14
 ROL T
 LSR A
 ROR P
 CLC
 ADC #&30
 STA Q

IF _ACORNSOFT

 STA &1D8C
 LDA P
 STA &1D8B

ENDIF

 LDX UU
 CPX #&28
 BCC C1C92
 JMP C1D94

.C1C92

 LDA L0047
 CMP dashDataOffset,X
 BCS C1C9C
 LDA dashDataOffset,X

.C1C9C

 STA RR
 CMP N
 BCC C1CAA
 CPY #1
 BNE C1CA7
 RTS

.C1CA7

 JMP C1D7C

.C1CAA

 LDA TT
 AND #&10
 BEQ C1CC3
 TYA
 BEQ C1CC3
 EOR T
 AND #1
 BEQ C1CC3
 LDA TT
 AND #3
 TAX
 LDA L628F,X
 STA V

.C1CC3

 LDA M
 AND #3
 TAX
 LDA yLookupLo+8,X
 EOR #&FF
 AND V
 STA V
 CPY #1
 BCS C1D15
 LDA L337C,X
 AND G
 STA T
 LDA H
 AND L33FC,X
 ORA T
 AND yLookupLo+8,X
 ORA V
 STA I
 LDA L0048
 BEQ C1CFD
 LDA #0
 STA L0048
 LDA KK
 STA L
 EOR #&FF
 AND I
 JMP C1D25

.C1CFD

 LDX UU
 CPX LL
 BNE C1D0A
 LDA I
 STA H
 JMP C1D7C

.C1D0A

 LDA I
 BNE C1D10
 LDA #&55

.C1D10

 LDY N
 JMP C1DE8

.C1D15

 BNE C1D34
 LDA L337C,X
 STA L
 EOR #&FF
 AND H
 AND yLookupLo+8,X
 ORA V

.C1D25

 LDX UU
 CPX LL
 BNE C1D44
 STA H
 LDA L
 STA KK
 ROR L0048
 RTS

.C1D34

 LDA KK
 ORA L39D0,X
 STA L
 EOR #&FF
 AND G
 AND yLookupLo+8,X
 ORA V

.C1D44

 STA I

IF _ACORNSOFT

 BNE L1D52
 LDA #&55

.L1D52

 STA &87

ENDIF

 LDA #0
 STA KK

IF _ACORNSOFT

 LDY RR
 LDA (P),Y
 STA W
 LDA #&AA
 STA (P),Y

ENDIF

 LDY N
 JMP C1D6B

.P1D4F

IF _SUPERIOR

 LDA (P),Y
 BEQ C1D5D

ENDIF

 CMP #&55
 BNE C1D60

IF _ACORNSOFT

 LDA #0

ELIF _SUPERIOR

 LDA I
 BNE C1D68
 BEQ C1D66

.C1D5D

 JSR sub_C1E9E

ENDIF

.C1D60

 AND L
 ORA I
 BNE C1D68

.C1D66

 LDA #&55

.C1D68

 STA (P),Y
 DEY

.C1D6B

IF _ACORNSOFT

 LDA (P),Y
 BNE L1D90

.L1D7C

 JSR sub_C1E9E
 AND &7D
 ORA &7A
 BNE L1D87
 LDA #&55

.L1D87

 STA (P),Y
 DEY
 LDX token26,Y
 BEQ L1D87
 TXA

.L1D90

 CMP #&AA
 BNE P1D4F

 LDA #0
 STA (P),Y
 CPY RR
 BNE L1D7C
 LDA W
 STA (P),Y

ELIF _SUPERIOR

 CPY RR
 BNE P1D4F

ENDIF

 LDX J
 CPX #1
 BEQ C1D93
 INC UU
 JSR sub_C1DAF
 DEC UU

.C1D7C

 LDA K
 CMP #&28
 BCC C1D86
 LDA #&FF
 STA K

.C1D86

 LDA UU
 CLC
 SBC K
 BEQ C1D93
 BMI C1D93
 TAX
 JSR sub_C1E38

.C1D93

 RTS

.C1D94

 LDY J
 CPY #1
 BEQ C1D93
 LDA K
 CMP #&28
 BCS C1D93
 LDA #&28
 STA UU
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

IF _ACORNSOFT

 STY mod_1E25+1

ELIF _SUPERIOR

 STY mod_1DD4+1

ENDIF

 STA mod_1DDB+1

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

 LDA UU
 CMP #&28
 BCS C1DE4
 CLC
 ADC #&60
 LSR A
 STA Q

IF _ACORNSOFT

 STA mod_1E1D+2
 LDA #0
 ROR A
 STA P
 STA mod_1E1D+1
 LDY RR
 LDA (P),Y
 STA W
 LDA #&AA
 STA (P),Y

ELIF _SUPERIOR

 LDA #0
 ROR A
 STA P

ENDIF

 LDY N

IF _ACORNSOFT

 JMP P1DD2

ELIF _SUPERIOR

 JMP C1DE0

ENDIF

 CMP #&55
 BNE L160D
 LDA #0

.L160D

 STA (R),Y

.C1E0E

 DEY

IF _SUPERIOR

 CPY &82
 BEQ C1DE4

ENDIF

.P1DD2

 LDA (P),Y

.mod_1DD4

IF _ACORNSOFT

 BNE L1E23

.C1E13

ELIF _SUPERIOR

 BNE C1DDF

ENDIF

 JSR sub_C1E9E
 BNE C1DDD

.mod_1DDB

 LDA #&55

.C1DDD

 STA (P),Y

.C1DDF

 DEY

.C1DE0

IF _ACORNSOFT

.mod_1E1D

 LDX token26,Y
 BEQ C1DDD
 TXA

.L1E23

 CMP #&AA

.mod_1E25

 BNE C1E0E
 LDA #0
 STA (P),Y

ENDIF

 CPY RR

IF _ACORNSOFT

 BNE C1E13
 LDA W
 STA (P),Y

ELIF _SUPERIOR

 BNE P1DD2

ENDIF

.C1DE4

 RTS

.P1DE5

 STA (P),Y
 DEY

.C1DE8

 CPY RR
 BNE P1DE5
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

 STX UU
 STY N
 LDA dashDataOffset,X
 STA RR
 LDX #&72

IF _ACORNSOFT

 LDY #&DF

ELIF _SUPERIOR

 LDY #&EF

ENDIF

 LDA #0
 JSR sub_C1DA6
 LDX #&70

IF _ACORNSOFT

 LDY #&E7

ELIF _SUPERIOR

 LDY #9

ENDIF

 LDA #&55
 INC UU
 JSR sub_C1DA6
 LDX UU
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

.C1E23

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

 LDA G
 BNE C1E3E
 LDA #&55

.C1E3E

 STA V
 LDA #&7F
 SEC
 SBC N
 STA T
 ADC L0047
 STA VV
 LDA UU
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

 LDY VV

.C1E86

 LDA V
 CPX #2
 BCC C1E98

.P1E8C

 STA (P),Y
 STA (R),Y
 INY
 BPL P1E8C

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

IF _ACORNSOFT

 LDA L001F
 JSR C1F9E

ENDIF

 LDA colourByte+1
 RTS

.C1EA8

IF _ACORNSOFT

 LDA #0
 STA T

ENDIF

 LDA UU

IF _ACORNSOFT

 CMP L05A4,Y
 ROL T
 CMP L0650,Y
 ROL T
 CMP L0600,Y
 ROL T
 CMP L0554,Y
 LDA T
 ROL A
 BNE C1ECB

ELIF _SUPERIOR

 CMP L0554,Y
 BCS C1EC7
 CMP L0600,Y
 BCS C1ED5
 CMP L0650,Y
 BCS C1EC3
 CMP L05A4,Y
 BCS C1ECB

ENDIF

 LDA L5F60,Y

IF _ACORNSOFT

 AND #&EC
 CMP #&40
 BEQ C1F31
 CMP #&88
 BEQ C1F31
 CMP #&04
 BEQ C1F31
 LDA L0554,Y
 BPL C1F3E
 BMI C1F41

.C1F31

 LDA L5F60,Y
 AND #&10
 BNE C1F3E
 JSR C1F5C
 JMP C1F41

.C1F3E 

 JSR C1F7F

.C1F41

 LDA L5F60,Y
 AND #3
 TAX
 LDA colourByte,X
 RTS

ELIF _SUPERIOR

 BCC C1EE2

ENDIF

.C1EC3

 LDA colourByte
 RTS

.C1EC7

 LDA colourByte+3
 RTS

.C1ECB

IF _ACORNSOFT

 LSR A
 BCS C1EC7
 LSR A
 BCS C1F7F
 LSR A
 BCS C1EC3

.C1F5C

ENDIF

 CPY L002C
 BCS C1EC7

IF _ACORNSOFT

 LDX L0400,Y
 BMI sub_C1F95
 JSR C1F9B

.L1F68

 LDA (P),Y
 BNE L1F7A
 LDA L0650,Y
 BMI L1F77
 CMP UU
 DEY
 BCS L1F68
 INY

.L1F77

 JSR C1FA1

.L1F7A

 LDY V
 JMP C1F8B

.C1F7F

 CPY L0029
 BCS C1EC7
 LDX L0450,Y
 BMI sub_C1F95
 JSR C1F9B

.C1F8B

ELIF _SUPERIOR

 LDA L0400,Y
 JMP C1EDC

.C1ED5

 CPY L0029
 BCS C1EC7
 LDA L0450,Y

.C1EDC

 AND #&7F
 TAX

ENDIF

 LDA L5EDF,X

.C1EE2

 AND #3
 TAX
 LDA colourByte,X
 RTS

\ ******************************************************************************
\
\       Name: sub_C1F95
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

IF _ACORNSOFT

.sub_C1F95

 TXA
 AND #&7F
 TAX
 BPL C1F8B

.C1F9B

 LDA L5F20,X

.C1F9E

 STY V
 TAY

.C1FA1

 CPY V
 BCS L1FB1
 CPY RR
 BCC L1FB1
 LDA (P),Y
 BNE L1FB1
 LDA #&AA
 STA (P),Y

.L1FB1

 LDY V
 RTS

ENDIF

\ ******************************************************************************
\
\       Name: AssistSteering
\       Type: Subroutine
\   Category: Keyboard
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ Jumps back to keys11 or keys7 (joystick) or keys10 (keyboard).
\
\ Arguments:
\
\   (A T)               Contains the scaled joystick x-coordinate as a
\                       sign-magnitude number with the sign in bit 0
\
\   V                   
\
\ Returns:
\
\   V
\
\ Other entry points:
\
\   AssistSteeringKeys  For keyboard-controlled steering
\
\ ******************************************************************************

IF _SUPERIOR

.AssistSteering

 JSR GetSteeringAssist  \ Set X = configAssist, set the C flag to bit 7 of
                        \ L0025, and update the steering assist indicator on the
                        \ dashboard

 BNE C1EF1              \ If steering assist is enabled, jump to C1EF1 to skip
                        \ the following instruction, otherwise we jump to keys11

.P1EEE

 JMP keys11             \ Jump to keys11 in the ProcessDrivingKeys routine

.C1EF1

 BCS P1EEE              \ If bit 7 of L0025 is set, jump to P1EEE to jump to
                        \ keys11 in the ProcessDrivingKeys routine

 CMP #5                 \ If A >= 5, jump to C1F08
 BCS C1F08

 JMP keys7              \ Jump to keys7 in the ProcessDrivingKeys routine

.AssistSteeringKeys

 JSR GetSteeringAssist  \ Set X = configAssist, set the C flag to bit 7 of
                        \ L0025, and update the steering assist indicator on the
                        \ dashboard

 BEQ C1F05              \ If steering assist is not enabled, jump to C1F05 to
                        \ set A and jump to keys10 in the ProcessDrivingKeys
                        \ routine

 BCS C1F05              \ If bit 7 of L0025 is set, jump to C1F05

 LDA V                  \ If V is non-zero, jump to C1F11
 BNE C1F11

.C1F05

 JMP C1F95              \ Jump to C1F95 to set A and jump to keys10 in the
                        \ ProcessDrivingKeys routine

.C1F08

 LDA T
 EOR #1
 LSR A

 LDA #3
 SBC #0

.C1F11

 LDX #50

 CMP #2
 BEQ C1F19

 LDX #10

.C1F19

 LDA steeringLo
 STA V

 LSR A

 LDA steeringHi
 BCC C1F30

 LDA #0
 SEC
 SBC V
 STA V

 LDA #0
 SBC steeringHi

.C1F30

 CLC
 ADC #1

 CPX #50
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

 JSR Absolute16Bit      \ Set (A T) = |A T|

 STA V

 LDY L0022

 LDA #60
 SEC
 SBC speedHi

 BPL C1F59

 LDA #0

.C1F59

 ASL A
 ADC #32
 STA U

 LDA L0701,Y

 AND #%01111111

 CMP #64
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

 JSR Absolute16Bit      \ Set (A T) = |A T|

 STA U

 LDA T
 AND #%11111110
 STA T

 LDA steeringLo
 LSR A

 BCS C1F95

 JSR Negate16Bit+2      \ Set (A T) = -(U T)

 STA U

.C1F95

 LDA steeringLo

 JMP keys10

ENDIF

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

IF _SUPERIOR

.sub_C1F9B

 BCC C1FA7              \ If the C flag is clear, jump to C1FA7 to return from
                        \ the subroutine

 LDA steeringLo         \ Set T = steeringLo with bit 0 cleared
 AND #%11111110
 STA T

 LDA steeringHi         \ Set A = steeringHi, so (A T) = (steeringHi steeringLo)
                        \ with bit 0 cleared

.C1FA7

 RTS                    \ Return from the subroutine

ENDIF

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

IF _SUPERIOR

.sub_C1FA8

 BCC C1FAF
 LDA L0880,X
 CMP #3

.C1FAF

 ROR L62FB
 RTS

 NOP

ENDIF

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

.P1FB8

 LDA colourByte,X
 STA L628F,X
 DEX
 BPL P1FB8
 LDA #&F0
 STA colourByte+2
 LDA T
 CMP #&17
 BEQ C1FDE
 CMP #&14
 BCC C1FD5
 LDX positionAhead
 LDA driversInOrder,X

.C1FD5

 AND #3
 TAX
 LDA colourByte,X
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
 STA QQ
 LDA L3CDE,X
 STA II
 LDA L3CD0,X
 STA MM
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
 LDY QQ
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

.P207A

 LSR A
 DEX
 BNE P207A
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
 CPY II
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

 LDY MM

.C209C

 LDA colourByte
 STA H
 LDA #0
 STA L0048
 STA KK
 LDX L3550,Y
 LDA L5EF8,X
 CLC
 ADC L0036
 BMI C210C
 CMP #&50
 BCC C20B8
 LDA #79

.C20B8

 STA N
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

 CMP N
 BCS C210C
 STA L0047
 LDX L3650,Y
 LDA L5EF8,X
 STA M
 LDX L36D0,Y
 LDA L5EF8,X
 STA SS
 LDA L3750,Y
 STA TT
 STY rowCounter
 LDY #1
 JSR sub_C1C1C

.C20F1

 BIT TT
 BMI C2117
 LDA #0
 LDY #2
 JSR sub_C1C1C
 BIT TT
 BVS C2106
 LDY rowCounter

.P2102

 INY
 JMP C209C

.C2106

 RTS

.P2107

 AND #&40
 BNE C2106
 INY

.C210C

 LDA L3750,Y
 BMI P2107
 AND #&40
 BNE C2106
 BEQ P2102

.C2117

 LDY rowCounter
 INY
 STY rowCounter
 LDX L3650,Y
 LDA L5EF8,X
 STA SS
 LDA L36D0,Y
 STA TT
 LDY #0
 JSR sub_C1C1C
 LDY rowCounter
 LDX L3550,Y
 LDA L5EF8,X
 STA SS
 LDA L3750,Y
 STA TT
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
 STA PP
 LDA L0A00,X
 SBC L6283,Y
 STA VV
 BPL C2165
 LDA #0
 SEC
 SBC PP
 STA PP
 LDA #0
 SBC VV

.C2165

 STA SS
 LDA L0902,X
 SEC
 SBC L6282,Y
 STA RR
 LDA L0A02,X
 SBC L6285,Y
 STA GG
 BPL C2185
 LDA #0
 SEC
 SBC RR
 STA RR
 LDA #0
 SBC GG

.C2185

 STA UU
 CMP SS
 BCC C2193
 BNE C21A6
 LDA RR
 CMP PP
 BCS C21A6

.C2193

 LDA UU
 STA H
 LDA RR
 STA G
 LDA PP
 STA I
 LDA SS
 STA J
 JMP C21C1

.C21A6

 PHP
 LDA SS
 STA H
 LDA PP
 STA G
 LDA RR
 STA I
 LDA UU
 STA J
 PLP
 BEQ C220D
 JMP C2239

.P21BD

 ASL RR
 ROL UU

.C21C1

 ASL PP
 ROL A
 BCC P21BD
 ROR A
 STA V
 LDA RR
 STA T
 LDA UU
 CMP V
 BEQ C220D

 JSR Divide8x8          \ Set T = A * 256 / V

 LDA #0
 STA II
 LDY T
 LDA L6100,Y
 STA M
 LSR A
 ROR II
 LSR A
 ROR II
 LSR A
 ROR II
 STA JJ
 LDA VV
 EOR GG
 BMI C21FF
 LDA #0
 SEC
 SBC II
 STA II
 LDA #0
 SBC JJ
 STA JJ

.C21FF

 LDA #&40
 BIT VV
 BPL C2207
 LDA #&C0

.C2207

 CLC
 ADC JJ
 STA JJ
 RTS

.C220D

 LDA #&FF
 STA M
 LDA #0
 STA II
 BIT VV
 BPL C2227
 BIT GG
 BPL C2222
 LDA #&A0
 STA JJ
 RTS

.C2222

 LDA #&E0
 STA JJ
 RTS

.C2227

 BIT GG
 BPL C2230
 LDA #&60
 STA JJ
 RTS

.C2230

 LDA #&20
 STA JJ
 RTS

.P2235

 ASL PP
 ROL SS

.C2239

 ASL RR
 ROL A
 BCC P2235
 ROR A
 STA V
 LDA PP
 STA T
 LDA SS
 CMP V
 BEQ C220D

 JSR Divide8x8          \ Set T = A * 256 / V

 LDA #0
 STA II
 LDY T
 LDA L6100,Y
 STA M
 LSR A
 ROR II
 LSR A
 ROR II
 LSR A
 ROR II
 STA JJ
 LDA VV
 EOR GG
 BPL C2277
 LDA #0
 SEC
 SBC II
 STA II
 LDA #0
 SBC JJ
 STA JJ

.C2277

 LDA #0
 BIT GG
 BPL C227F
 LDA #&80

.C227F

 CLC
 ADC JJ
 STA JJ
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
 STA QQ
 LDA L0A01,X
 SBC L6284,Y
 STA WW
 BPL C22A5
 LDA #0
 SEC
 SBC QQ
 STA QQ
 LDA #0
 SBC WW

.C22A5

 LSR A
 ROR QQ
 LSR A
 ROR QQ
 LSR A
 ROR QQ
 STA TT
 CMP L
 BCC C22BE
 BNE C22BC
 LDA QQ
 CMP K
 BCC C22BE

.C22BC

 SEC
 RTS

.C22BE

 LDY #0
 LDA L
 JMP C22CA

.P22C5

 ASL QQ
 ROL TT
 INY

.C22CA

 ASL K
 ROL A
 BCC P22C5
 ROR A
 STA V
 STY L002B
 TAY
 LDA L6180,Y
 STA L002A
 LDA QQ
 STA T
 LDA TT

 JSR Divide8x8          \ Set T = A * 256 / V

 LDA T
 CMP #&80
 BCS C22FE
 BIT WW
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
 STA LL
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

.P2318

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
 BCC P2318

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
 ADC trackData+&6FA
 JMP C235B

.C234F

 CLC
 ADC L06FF
 CMP trackData+&6FA
 BCC C235B
 SBC trackData+&6FA

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
 LDA LL
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

 LDA II
 SEC
 SBC L000A
 STA L5E40,Y
 LDA JJ
 SBC L000B
 STA L5E90,Y
 JMP sub_C0CA5

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
 CMP K
 BCC C23FC

.C23E7

 LDA L
 STA L0011
 LDA K
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
 SBC L62E2Hi
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
 CMP #79
 BCC C2535
 LDA #&4E
 STA L001F

.C2535

 STA L5F20,Y
 STA L5F48,Y
 LDA L5E90,Y
 SEC
 SBC L5EB8,Y

 JSR Absolute8Bit       \ Set A = |A|

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

 LDA L0650+58,X

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

.P259B

 LSR U
 ROR A
 INY
 BNE P259B
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
 LDA LL
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
\       Name: SetL018CBit7
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.SetL018CBit7

 LDX #22                \ We are about to process 23 bytes at L018C, so set a
                        \ loop counter in X

.P2621

 LDA L018C,X            \ Set bit 7 in the X-th byte of L018C
 ORA #%10000000
 STA L018C,X

 DEX                    \ Decrement the loop counter

 BPL P2621              \ Loop back until we have set bit 7 in all 23 bytes

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: Delay
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Delay for a specified number of loops
\
\ ------------------------------------------------------------------------------
\
\ This routine performs T + (5 * 256) loop iterations, to create a delay.
\
\ ******************************************************************************

.Delay

 LDX #6                 \ Set X as the counter for the outer loop

.dely1

 DEC T                  \ Loop around for T iterations in the inner loop
 BNE dely1

 DEX                    \ Loop around for X iterations in the outer loop
 BNE dely1

 RTS                    \ Return from the subroutine

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

 LDA qualifyingTime
 BMI Delay
 LDX positionBehind
 LDY driversInOrder,X
 LDA L018C,Y
 AND #&7F
 STA L018C,Y
 JSR sub_C27ED
 JSR sub_C2692
 JSR SetL018CBit7

 JSR SetPlayerPositions \ Set the player's current position, plus the position
                        \ ahead and the position behind

 LDX currentPosition
 LDY #5

.P2659

 BIT L0025
 BPL C2663

 JSR GetPositionBehind  \ Set X to the number of the position behind position X

 JMP C2666

.C2663

 JSR GetPositionAhead   \ Set X to the number of the position ahead of position
                        \ X

.C2666

 STY L62F4
 STX L001D
 JSR sub_C28F2
 LDX L001D
 LDY L62F4
 DEY
 BPL P2659
 JSR sub_C66DF
 LDX positionBehind
 JSR sub_C28F2
 RTS

\ ******************************************************************************
\
\       Name: SwapDriverPosition
\       Type: Subroutine
\   Category: Drivers
\    Summary: Swap the position for two drivers (i.e. overtake)
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The driver number
\
\   Y                   The other driver number
\
\ Returns:
\
\   X                   The new position for driver X
\
\   Y                   The new position for driver Y
\
\ ******************************************************************************

.SwapDriverPosition

 LDA driversInOrder,X   \ Set T = driver X's current position
 STA T

 LDA driversInOrder,Y   \ Set A = driver Y's current position

 STA driversInOrder,X   \ Set driver X's new position to A (i.e. driver Y's old
                        \ position) 

 TAX                    \ Set X = the new position for driver X

 LDA T                  \ Set driver Y's new position to T (i.e. driver X's old
 STA driversInOrder,Y   \ position)

 TAY                    \ Set Y = the new position for driver Y

 RTS                    \ Return from the subroutine

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

 LDX currentPosition

.C2694

 STX W
 LDA driversInOrder,X
 STA T

 JSR GetPositionAhead   \ Set X to the number of the position ahead of position
                        \ X

 LDA driversInOrder,X
 STX G
 TAY
 LDX T
 LDA #0
 STA N
 STA L0114,X
 JSR sub_C27A4
 BCS C26E6
 BPL C26E9
 CMP #&F6
 BCC C26E6
 LDX W
 LDY G
 JSR SwapDriverPosition
 SEC
 ROR L62FE
 CPY currentPlayer
 BNE C26CB
 LDA #&99
 BNE C26D1

.C26CB

 CPX currentPlayer
 BNE C26E6
 LDA #1

.C26D1

 STA T
 LDA L04B4,Y
 ROL H
 SBC L04B4,X
 BNE C26E6

 SED                    \ Set the D flag to switch arithmetic to Binary Coded
                        \ Decimal (BCD)

 CLC
 LDA T
 ADC L002F
 STA L002F

 CLD                    \ Clear the D flag to switch arithmetic to normal

.C26E6

 JMP C278C

.C26E9

 CMP #5
 BCS C26E6
 LDA L3850Lo,X
 CLC
 SBC L3850Lo,Y
 LDA L3850Hi,X
 SBC L3850Hi,Y
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

 STA SS
 LDA T
 CMP #4
 LDA positionNumber,Y
 AND #&40
 BEQ C2729
 BCS C271C
 ORA #&80

.C271C

 STA N
 LDA L0178,X
 CMP L0178,Y
 ROR T
 JMP C277D

.C2729

 BCS C2742
 LDA #&40
 STA N
 LDA L0178,Y
 CMP L0178,X
 ROR T
 AND #&FF

 JSR Absolute8Bit       \ Set A = |A|

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
 ORA N
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
 ORA N
 STA N

.C277D

 LDA T
 AND #&80
 ORA SS
 STA L0114,X

.C2786

 LDA N
 ORA #&10

.C278A

 STA N

.C278C

 LDA positionNumber,X
 LSR A
 LDA N
 BCS C2797
 STA positionNumber,X

.C2797

 LDX W

 JSR GetPositionBehind  \ Set X to the number of the position behind position X

 CPX currentPosition
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

 JSR Absolute16Bit      \ Set (A T) = |A T|


.C27BF

 STA U
 SEC
 BEQ C27D8
 PLA
 EOR #&80
 PHP
 LDA trackData+&6FC
 SEC
 SBC T
 STA T
 LDA trackData+&6FD
 SBC U
 BNE C27EA
 CLC

.C27D8

 ROR H
 LDA T
 CMP #&80
 BCS C27EA
 PLP

 JSR Absolute8Bit       \ Set A = |A|

 STA T
 LDA T
 CLC
 RTS

.C27EA

 PLP
 SEC

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
\ Other entry points:
\
\   sub_C27ED-1         Contains an RTS
\
\ ******************************************************************************

.sub_C27ED

 LDA L006D              \ If bit 7 of L006D is set, return from the subroutine
 BMI sub_C27ED-1        \ (as sub_C27ED-1 contains an RTS)

 LDX #&14
 JMP C28E7

.C27F6

 LDA positionNumber,X
 BMI C285B
 LDY L06E8,X
 LDA trackData+&600,Y
 BPL C280D
 LDA L3850Hi,X
 CMP L01A4,X
 BCS C287F
 BCC C282F

.C280D

 LSR A
 BCS C282F
 LDA trackData+&007,Y
 STA L01A4,X
 CLC
 SBC L3850Hi,X
 BCS C282F
 LSR A
 LSR A
 ORA #&C0
 STA T
 LDA L0880,X
 SEC
 SBC trackData+&005,Y
 BCS C287F
 CMP T
 BCS C285B

.C282F

 LDA L3850Hi,X
 CMP #&3C
 BCS C2838
 LDA #&16

.C2838

 STA T
 LDA positionNumber,X
 AND #&40
 BEQ C2843
 LDA #5

.C2843

 CLC
 ADC driverSpeed,X
 BIT raceStarted
 BPL C284E
 SBC trackData+&71A

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
 ADC L3850Lo,X
 STA L3850Lo,X
 LDA U
 ADC L3850Hi,X
 CMP #&BE
 BCC C287C
 LDA #0
 STA L3850Lo,X

.C287C

 STA L3850Hi,X

.C287F

 LDA #1
 STA V

.P2883

 LDA L3850Hi,X
 CLC
 ADC L0164,X
 STA L0164,X
 BCC C2892
 JSR sub_C147C

.C2892

 DEC V
 BPL P2883
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
 CPX currentPlayer
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

 LDA driversInOrder,X
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

 JSR Absolute8Bit       \ Set A = |A|

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
 LDA positionNumber,X
 AND #&10
 BNE sub_C2937
 LDA L3850Hi,X
 CMP #&32
 BCC sub_C2937
 LDA L0701,Y
 STA L0114,X

\ ******************************************************************************
\
\       Name: sub_C2937
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C2937

 LDA L0700,Y
 STA L000C
 STY T
 TAY
 LDA L0164,X
 STA TT
 LDA L0178,X
 STA UU
 LDA trackData+&100,Y
 STA VV
 LDA trackData+&200,Y
 STA WW
 LDA trackData+&300,Y
 STA GG
 LDX #0
 LDA TT
 STA U
 LDY T

.C2960

 LDA #0
 STA V
 LDA VV,X
 BPL C297B
 EOR #&FF
 CLC
 ADC #1

 JSR Multiply8x8        \ Set (A T) = A * U

 EOR #&FF
 CLC
 ADC #1
 BCS C297E
 DEC V
 BCC C297E

.C297B

 JSR Multiply8x8        \ Set (A T) = A * U

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
 LDA trackData+&400,Y
 STA VV
 LDA trackData+&500,Y
 STA GG
 LDX #0
 LDA UU
 STA U

.C29AD

 LDA #0
 STA V
 LDA VV,X
 BPL C29C8
 EOR #&FF
 CLC
 ADC #1

 JSR Multiply8x8        \ Set (A T) = A * U

 EOR #&FF
 CLC
 ADC #1
 BCS C29CB
 DEC V
 BCC C29CB

.C29C8

 JSR Multiply8x8        \ Set (A T) = A * U

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
 CMP positionAhead
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
 LDA II
 STA L0380,Y
 LDA JJ
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

.P2A8F

 LSR A
 INX
 BNE P2A8F
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

 JSR sub_C0CA5
 LDA L
 STA L0055
 BNE C2ACA
 CPY K
 BCC C2ACA
 DEC L0068
 LDA K
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
 LDA driversInOrder,X
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

.P2B10

 LDA SS,X
 CLC
 BPL C2B16
 SEC

.C2B16

 ROR SS,X
 ROR T,X
 DEX
 BPL P2B10
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

 ROR GG
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
 STA RR
 STX L0045
 STY rowCounter
 PLP
 BCS C2BCA
 BIT GG
 BVC C2B7B
 BMI C2BCA
 LDX M
 LDY N
 LDA W
 STA M
 LDA RR
 STA N
 STX W
 STY RR
 DEC L001E

.C2B7B

 LDA RR
 SEC
 SBC N
 STA WW
 BPL C2B89
 LDA #0
 SEC
 SBC WW

.C2B89

 STA TT
 LDA GG
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
 STA VV

 JSR Absolute16Bit      \ Set (A T) = |A T|

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

 LSR TT

.C2BBB

 LSR TT

.C2BBD

 STA SS
 LDA VV
 EOR L001E
 STA VV
 LDA SS
 JMP C2BDB

.C2BCA

 JMP C2CFC

.C2BCD

 LDA M
 SEC
 SBC W
 ROR VV
 BMI C2BDB
 EOR #&FF
 CLC
 ADC #1

.C2BDB

 STA SS
 BNE C2BE3
 ORA TT
 BEQ C2BCA

.C2BE3

 LDA GG
 AND #&C0
 BEQ C2BED
 LDA VV
 AND #&80

.C2BED

 STA L0053
 LDA WW
 BNE C2BF9
 LDA L001E
 EOR #&FF
 STA WW

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

.P2C13

 LDA L5FD0,Y
 STA L628F,X
 AND L33FC,X
 STA L629C,X
 INY
 INX
 CPX #4
 BNE P2C13
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

 STA JJ
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
 LDA rowCounter
 CLC
 ADC #1
 CMP L004B
 BEQ C2C68
 LDA RR
 CMP #&50
 BCC C2C70

.C2C68

 LDA #0
 BIT WW
 BMI C2C70
 LDA #79

.C2C70

 STA RR
 LDA M
 SEC
 SBC #&30
 STA U
 LSR A
 LSR A
 STA UU
 CMP #&28
 BCS C2CE6
 LSR A
 CLC
 ADC #&30
 STA Q
 STA S
 CLC
 ADC #1
 STA NN
 LDA U
 AND #7
 TAX
 LDY N
 LDA SS
 CMP TT
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
 EOR VV
 BPL C2CDF
 LDA C2F60
 STA C2F47
 STA C2F89
 LDA #&EA
 STA C2F60
 STA C2FA2
 LDA WW
 BPL C2CDE
 INY
 JMP C2CDF

.C2CDE

 DEY

.C2CDF

 LDA VV
 BPL C2CE9
 JSR sub_C2D9A

.C2CE6

 JMP C2CFC

.C2CE9

 JSR sub_C2D17
 JMP C2CFC

.C2CEF

 LDA VV
 BPL C2CF9
 JSR sub_C2E99
 JMP C2CFC

.C2CF9

 JSR sub_C2E20

.C2CFC

 LDA L001E
 BMI C2D08
 LDA W
 STA M
 LDA RR
 STA N

.C2D08

 LDX L0045
 LDY rowCounter
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
 STA mod_C2D27+1
 LDX #&80
 LDA SS
 EOR #&FF
 CLC
 ADC #1
 CLC

.mod_C2D27

 BCC C2D29

.C2D29

 LDX #&80
 ADC TT
 BCC C2D36
 SBC SS
 LDX #0
 JSR sub_C2F45

.C2D36

 ADC TT
 BCC C2D41
 SBC SS
 LDX #1
 JSR sub_C2F45

.C2D41

 ADC TT
 BCC C2D4C
 SBC SS
 LDX #2
 JSR sub_C2F45

.C2D4C

 ADC TT
 BCC C2D57
 SBC SS
 LDX #3
 JSR sub_C2F45

.C2D57

 JSR C2FD7
 INC UU
 ADC TT
 BCC C2D67
 SBC SS
 LDX #0
 JSR sub_C2F87

.C2D67

 ADC TT
 BCC C2D72
 SBC SS
 LDX #1
 JSR sub_C2F87

.C2D72

 ADC TT
 BCC C2D7D
 SBC SS
 LDX #2
 JSR sub_C2F87

.C2D7D

 ADC TT
 BCC C2D88
 SBC SS
 LDX #3
 JSR sub_C2F87

.C2D88

 JSR C2FC0
 INC S
 INC Q
 INC NN
 INC UU
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
 STA mod_C2DAA+1
 LDX #&80
 LDA SS
 EOR #&FF
 CLC
 ADC #1
 CLC

.mod_C2DAA

 BCC C2DAC

.C2DAC

 LDX #&80
 ADC TT
 BCC C2DB9
 SBC SS
 LDX #3
 JSR sub_C2F87

.C2DB9

 ADC TT
 BCC C2DC4
 SBC SS
 LDX #2
 JSR sub_C2F87

.C2DC4

 ADC TT
 BCC C2DCF
 SBC SS
 LDX #1
 JSR sub_C2F87

.C2DCF

 ADC TT
 BCC C2DDA
 SBC SS
 LDX #0
 JSR sub_C2F87

.C2DDA

 JSR C2FC0
 DEC UU
 ADC TT
 BCC C2DEA
 SBC SS
 LDX #3
 JSR sub_C2F45

.C2DEA

 ADC TT
 BCC C2DF5
 SBC SS
 LDX #2
 JSR sub_C2F45

.C2DF5

 ADC TT
 BCC C2E00
 SBC SS
 LDX #1
 JSR sub_C2F45

.C2E00

 ADC TT
 BCC C2E0B
 SBC SS
 LDX #0
 JSR sub_C2F45

.C2E0B

 JSR C2FD7
 DEC S
 DEC Q
 DEC NN
 DEC UU
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
 STA mod_C2E2E+1
 LDA TT
 EOR #&FF
 CLC
 ADC #1
 CLC

.mod_C2E2E

 BCC C2E30

.C2E30

 LDX #0
 JSR sub_C2F45
 ADC SS
 BCC C2E30
 SBC TT

.P2E3B

 LDX #1
 JSR sub_C2F45
 ADC SS
 BCC P2E3B
 SBC TT

.P2E46

 LDX #2
 JSR sub_C2F45
 ADC SS
 BCC P2E46
 SBC TT

.P2E51

 LDX #3
 JSR sub_C2F45
 ADC SS
 BCC P2E51
 SBC TT
 INC UU

.P2E5E

 LDX #0
 JSR sub_C2F87
 ADC SS
 BCC P2E5E
 SBC TT

.P2E69

 LDX #1
 JSR sub_C2F87
 ADC SS
 BCC P2E69
 SBC TT

.P2E74

 LDX #2
 JSR sub_C2F87
 ADC SS
 BCC P2E74
 SBC TT

.P2E7F

 LDX #3
 JSR sub_C2F87
 ADC SS
 BCC P2E7F
 SBC TT
 INC S
 INC Q
 INC NN
 INC UU
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
 STA mod_C2EA7+1
 LDA TT
 EOR #&FF
 CLC
 ADC #1
 CLC

.mod_C2EA7

 BCC C2EA9

.C2EA9

 LDX #3
 JSR sub_C2F87
 ADC SS
 BCC C2EA9
 SBC TT

.P2EB4

 LDX #2
 JSR sub_C2F87
 ADC SS
 BCC P2EB4
 SBC TT

.P2EBF

 LDX #1
 JSR sub_C2F87
 ADC SS
 BCC P2EBF
 SBC TT

.P2ECA

 LDX #0
 JSR sub_C2F87
 ADC SS
 BCC P2ECA
 SBC TT
 DEC UU

.P2ED7

 LDX #3
 JSR sub_C2F45
 ADC SS
 BCC P2ED7
 SBC TT

.P2EE2

 LDX #2
 JSR sub_C2F45
 ADC SS
 BCC P2EE2
 SBC TT

.P2EED

 LDX #1
 JSR sub_C2F45
 ADC SS
 BCC P2EED
 SBC TT

.P2EF8

 LDX #0
 JSR sub_C2F45
 ADC SS
 BCC P2EF8
 SBC TT
 DEC S
 DEC Q
 DEC NN
 DEC UU
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

 STA II

.C2F47

 NOP
 CPY RR
 BEQ C2F7E
 LDA UU

.mod_C2F4E

 STA L7000,Y
 LDA (R),Y
 BNE C2F63
 LDA L628F,X

.C2F58

 STA (R),Y
 LDA JJ
 STA (P),Y

.P2F5E

 LDA II

.C2F60

 INY
 CLC
 RTS

.C2F63

 CPY #44
 BCS C2F6C
 JSR sub_C2FEE
 BCC P2F5E

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

 STA II

.C2F89

 NOP
 CPY RR
 BEQ C2F7E
 LDA UU

.mod_C2F90

 STA L7000,Y
 LDA (P),Y
 BNE C2FA5
 LDA L628F,X

.C2F9A

 STA (P),Y
 LDA JJ
 STA (MM),Y

.P2FA0

 LDA II

.C2FA2

 INY
 CLC
 RTS

.C2FA5

 CPY #44
 BCS C2FAE
 JSR sub_C2FEE
 BCC P2FA0

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
 CPY #44
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
 CPY #44
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
 LDX UU
 TYA
 CMP dashDataOffset,X
 BNE C2FFB
 CLC

.C2FFB

 LDA T
 LDX U
 RTS

\ ******************************************************************************
\
\       Name: token26
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 26
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token26

 EQUB 200 + 54          \ Print token 54 ("FORMULA 3  CHAMPIONSHIP" header)

 EQUB 31, 10, 12        \ Move text cursor to column 10, row 12

 EQUB 131               \ Set foreground colour to yellow alphanumeric

 EQUS "STANDARD OF"     \ Print "STANDARD OF"

 EQUB 200 + 15          \ Print token 15 (" RACE")

 EQUB 31, 14, 14        \ Move text cursor to column 14, row 14

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token4
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 4
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token4

 EQUB 200 + 52          \ Print token 52 (multicoloured "REVS")

 EQUB 160 + 3           \ Print 3 spaces

 EQUB 200 + 52          \ Print token 52 (multicoloured "REVS")

 EQUB 160 + 3           \ Print 3 spaces

 EQUB 200 + 52          \ Print token 52 (multicoloured "REVS")

 EQUB 160 + 1           \ Print 1 space

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: dashData0
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData0

 SKIP 52                \ Populated with code from &7FCC to &7FFF

\ ******************************************************************************
\
\       Name: tyreEdgeIndex
\       Type: Variable
\   Category: Graphics
\    Summary: Index of the mask and pixel bytes for the tyre edges on a specific
\             track line
\
\ ------------------------------------------------------------------------------
\
\ This table points to the index of the mask or pixel byte to use from the
\ leftTyreMask/rightTyreMask and leftTyrePixels/rightTyrePixels tables for a
\ specific track line. This is used when clipping track lines to the tyre edges.
\
\ There is a byte for each track line from 27 (the track line at the top of the
\ tyres) down to 3 (the lowest track line, just above where the wing mirror
\ joins the car body). Lines 0 to 2 are not used.

\ ******************************************************************************

.tyreEdgeIndex

 EQUB 0                 \ Line  0
 EQUB 0                 \ Line  1
 EQUB 0                 \ Line  2
 EQUB 0                 \ Line  3
 EQUB 6                 \ Line  4
 EQUB 6                 \ Line  5
 EQUB 6                 \ Line  6
 EQUB 6                 \ Line  7
 EQUB 6                 \ Line  8
 EQUB 6                 \ Line  9
 EQUB 6                 \ Line 10
 EQUB 3                 \ Line 11
 EQUB 3                 \ Line 12
 EQUB 3                 \ Line 13
 EQUB 3                 \ Line 14
 EQUB 3                 \ Line 15
 EQUB 1                 \ Line 16
 EQUB 1                 \ Line 17
 EQUB 1                 \ Line 18
 EQUB 0                 \ Line 19
 EQUB 0                 \ Line 20
 EQUB 0                 \ Line 21
 EQUB 5                 \ Line 22
 EQUB 4                 \ Line 23
 EQUB 3                 \ Line 24
 EQUB 2                 \ Line 25
 EQUB 1                 \ Line 26
 EQUB 0                 \ Line 27

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

 EQUB &05, &05, &03, &04, &03, &04, &04, &04, &38, &38

\ ******************************************************************************
\
\       Name: staDrawByteTyre
\       Type: Variable
\   Category: Graphics
\    Summary: Low address bytes of the STA instructions in the DRAW_BYTE macros,
\             for use when drawing track lines around the tyres
\
\ ------------------------------------------------------------------------------
\
\ This table contains the low byte offset of the address of the STA (P),Y
\ instruction for the track line, which we convert into an RTS when drawing the
\ track line up against the right tyre, so we stop in time. As the tyres are
\ reflections of each other, we can also use this to calculate the starting
\ point for the line that starts at the left tyre: see part 3 of DrawTrackView
\ for details.
\
\ ******************************************************************************

.staDrawByteTyre

 EQUB  8 * 17 + 15      \ Line  0 = LO(address) of STA (P),Y in DRAW_BYTE 34
 EQUB  8 * 17 + 15      \ Line  1 = LO(address) of STA (P),Y in DRAW_BYTE 34
 EQUB  8 * 17 + 15      \ Line  2 = LO(address) of STA (P),Y in DRAW_BYTE 34
 EQUB  8 * 17 + 15      \ Line  3 = LO(address) of STA (P),Y in DRAW_BYTE 34
 EQUB  9 * 17 + 15      \ Line  4 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line  5 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line  6 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line  7 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line  8 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line  9 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line 10 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line 11 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line 12 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line 13 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line 14 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line 15 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line 16 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line 17 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line 18 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line 19 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line 20 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB  9 * 17 + 15      \ Line 21 = LO(address) of STA (P),Y in DRAW_BYTE 35
 EQUB 10 * 17 + 15      \ Line 22 = LO(address) of STA (P),Y in DRAW_BYTE 36
 EQUB 10 * 17 + 15      \ Line 23 = LO(address) of STA (P),Y in DRAW_BYTE 36
 EQUB 10 * 17 + 15      \ Line 24 = LO(address) of STA (P),Y in DRAW_BYTE 36
 EQUB 10 * 17 + 15      \ Line 25 = LO(address) of STA (P),Y in DRAW_BYTE 36
 EQUB 10 * 17 + 15      \ Line 26 = LO(address) of STA (P),Y in DRAW_BYTE 36
 EQUB 10 * 17 + 15      \ Line 27 = LO(address) of STA (P),Y in DRAW_BYTE 36

\ ******************************************************************************
\
\       Name: dashData1
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData1

 SKIP 52                \ Populated with code from &7F98 to &7FCB

\ ******************************************************************************
\
\       Name: ldaDrawByte
\       Type: Variable
\   Category: Graphics
\    Summary: Low address bytes of the LDA #0 instructions in the DRAW_BYTE
\             macros, for use when drawing track lines around the dashboard
\
\ ******************************************************************************

.ldaDrawByte

IF _ACORNSOFT

 EQUB &1C               \ Line 0 is unused and contains workspace noise

ELIF _SUPERIOR

 EQUB &28               \ Line 0 is unused and contains workspace noise

ENDIF

 EQUB 8 * 17 + 5        \ Line  1 = LO(address) of LDA #0 in DRAW_BYTE 34
 EQUB 7 * 17 + 5        \ Line  2 = LO(address) of LDA #0 in DRAW_BYTE 33
 EQUB 7 * 17 + 5        \ Line  3 = LO(address) of LDA #0 in DRAW_BYTE 33
 EQUB 7 * 17 + 5        \ Line  4 = LO(address) of LDA #0 in DRAW_BYTE 33
 EQUB 7 * 17 + 5        \ Line  5 = LO(address) of LDA #0 in DRAW_BYTE 33
 EQUB 7 * 17 + 5        \ Line  6 = LO(address) of LDA #0 in DRAW_BYTE 33
 EQUB 6 * 17 + 5        \ Line  7 = LO(address) of LDA #0 in DRAW_BYTE 32
 EQUB 6 * 17 + 5        \ Line  8 = LO(address) of LDA #0 in DRAW_BYTE 32
 EQUB 6 * 17 + 5        \ Line  9 = LO(address) of LDA #0 in DRAW_BYTE 32
 EQUB 6 * 17 + 5        \ Line 10 = LO(address) of LDA #0 in DRAW_BYTE 32
 EQUB 6 * 17 + 5        \ Line 11 = LO(address) of LDA #0 in DRAW_BYTE 32
 EQUB 5 * 17 + 5        \ Line 12 = LO(address) of LDA #0 in DRAW_BYTE 31
 EQUB 5 * 17 + 5        \ Line 13 = LO(address) of LDA #0 in DRAW_BYTE 31
 EQUB 5 * 17 + 5        \ Line 14 = LO(address) of LDA #0 in DRAW_BYTE 31
 EQUB 5 * 17 + 5        \ Line 15 = LO(address) of LDA #0 in DRAW_BYTE 31
 EQUB 4 * 17 + 5        \ Line 16 = LO(address) of LDA #0 in DRAW_BYTE 30
 EQUB 4 * 17 + 5        \ Line 17 = LO(address) of LDA #0 in DRAW_BYTE 30
 EQUB 4 * 17 + 5        \ Line 18 = LO(address) of LDA #0 in DRAW_BYTE 30
 EQUB 4 * 17 + 5        \ Line 19 = LO(address) of LDA #0 in DRAW_BYTE 30
 EQUB 3 * 17 + 5        \ Line 20 = LO(address) of LDA #0 in DRAW_BYTE 29
 EQUB 3 * 17 + 5        \ Line 21 = LO(address) of LDA #0 in DRAW_BYTE 29
 EQUB 3 * 17 + 5        \ Line 22 = LO(address) of LDA #0 in DRAW_BYTE 29
 EQUB 3 * 17 + 5        \ Line 23 = LO(address) of LDA #0 in DRAW_BYTE 29
 EQUB 2 * 17 + 5        \ Line 24 = LO(address) of LDA #0 in DRAW_BYTE 28
 EQUB 2 * 17 + 5        \ Line 25 = LO(address) of LDA #0 in DRAW_BYTE 28
 EQUB 2 * 17 + 5        \ Line 26 = LO(address) of LDA #0 in DRAW_BYTE 28
 EQUB 2 * 17 + 5        \ Line 27 = LO(address) of LDA #0 in DRAW_BYTE 28
 EQUB 1 * 17 + 5        \ Line 28 = LO(address) of LDA #0 in DRAW_BYTE 27
 EQUB 1 * 17 + 5        \ Line 29 = LO(address) of LDA #0 in DRAW_BYTE 27
 EQUB 1 * 17 + 5        \ Line 30 = LO(address) of LDA #0 in DRAW_BYTE 27
 EQUB 1 * 17 + 5        \ Line 31 = LO(address) of LDA #0 in DRAW_BYTE 27
 EQUB 1 * 17 + 5        \ Line 32 = LO(address) of LDA #0 in DRAW_BYTE 27
 EQUB 1 * 17 + 5        \ Line 33 = LO(address) of LDA #0 in DRAW_BYTE 27
 EQUB 1 * 17 + 5        \ Line 34 = LO(address) of LDA #0 in DRAW_BYTE 27
 EQUB 1 * 17 + 5        \ Line 35 = LO(address) of LDA #0 in DRAW_BYTE 27
 EQUB 1 * 17 + 5        \ Line 36 = LO(address) of LDA #0 in DRAW_BYTE 27
 EQUB 1 * 17 + 5        \ Line 37 = LO(address) of LDA #0 in DRAW_BYTE 27
 EQUB 1 * 17 + 5        \ Line 38 = LO(address) of LDA #0 in DRAW_BYTE 27
 EQUB 0 * 17 + 5        \ Line 39 = LO(address) of LDA #0 in DRAW_BYTE 26
 EQUB 0 * 17 + 5        \ Line 40 = LO(address) of LDA #0 in DRAW_BYTE 26
 EQUB 0 * 17 + 5        \ Line 41 = LO(address) of LDA #0 in DRAW_BYTE 26
 EQUB 0 * 17 + 5        \ Line 42 = LO(address) of LDA #0 in DRAW_BYTE 26
 EQUB 0 * 17 + 5        \ Line 43 = LO(address) of LDA #0 in DRAW_BYTE 26

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
\       Name: handPixels
\       Type: Variable
\   Category: Graphics
\    Summary: The number of pixels in the longest axis for the rev counter hand
\             at various points in a half-quadrant
\
\ ------------------------------------------------------------------------------
\
\ This table contains values that are used to calculate the coordinates of the
\ end of the hand in the rev counter.
\
\ The contents of the table are very close to the following (the values from
\ the following calculation are shown in the comments below - they are close,
\ but not quite a perfect match, so I haven't got this exactly right):
\
\ FOR I%, 0, 21
\  EQUB INT(0.5 + 28 * COS((PI / 4) * I% / 21))
\ NEXT
\
\ This gives the length of the adjacent side of a right-angled triangle, with a
\ hypoteneuse of length 28, and an angle ranging from 0 to PI/4 (i.e. one
\ eighth of a circle), split up into 21 points per eighth of a circle.
\
\ In other words, if we have a clock whose centre is at the origin, then this
\ table contains the x-coordinate of the end of a clock hand of length 28 as it
\ moves from 3 o'clock to half past 4.
\
\ ******************************************************************************

.handPixels

 EQUB 28                \ INT(0.5 + 28.00) = 28
 EQUB 28                \ INT(0.5 + 27.98) = 28
 EQUB 28                \ INT(0.5 + 27.92) = 28
 EQUB 28                \ INT(0.5 + 27.82) = 28
 EQUB 28                \ INT(0.5 + 27.69) = 28
 EQUB 27                \ INT(0.5 + 27.51) = 28 (doesn't match)
 EQUB 27                \ INT(0.5 + 27.30) = 27
 EQUB 27                \ INT(0.5 + 27.05) = 27
 EQUB 27                \ INT(0.5 + 26.76) = 27
 EQUB 26                \ INT(0.5 + 26.43) = 26
 EQUB 26                \ INT(0.5 + 26.06) = 26
 EQUB 26                \ INT(0.5 + 25.66) = 26
 EQUB 25                \ INT(0.5 + 25.23) = 25
 EQUB 25                \ INT(0.5 + 24.76) = 25
 EQUB 24                \ INT(0.5 + 24.25) = 24
 EQUB 24                \ INT(0.5 + 23.71) = 24
 EQUB 23                \ INT(0.5 + 23.13) = 23
 EQUB 22                \ INT(0.5 + 22.53) = 23 (doesn't match)
 EQUB 21                \ INT(0.5 + 21.89) = 22 (doesn't match)
 EQUB 20                \ INT(0.5 + 21.22) = 21 (doesn't match)
 EQUB 20                \ INT(0.5 + 20.53) = 21 (doesn't match)
 EQUB 20                \ INT(0.5 + 19.80) = 20

 EQUB &81, &81, &81     \ These bytes appear to be unused
 EQUB &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData2
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData2

 SKIP 52                \ Populated with code from &7F64 to &7F97

\ ******************************************************************************
\
\       Name: staDrawByte
\       Type: Variable
\   Category: Graphics
\    Summary: Low address bytes of the STA instructions in the DRAW_BYTE macros,
\             for use when drawing track lines around the dashboard
\
\ ******************************************************************************

.staDrawByte

 EQUB  3 * 17 + 15      \ Line  0 = LO(address) of STA (P),Y in DRAW_BYTE  3
 EQUB  5 * 17 + 15      \ Line  1 = LO(address) of STA (P),Y in DRAW_BYTE  5
 EQUB  6 * 17 + 15      \ Line  2 = LO(address) of STA (P),Y in DRAW_BYTE  6
 EQUB  6 * 17 + 15      \ Line  3 = LO(address) of STA (P),Y in DRAW_BYTE  6
 EQUB  6 * 17 + 15      \ Line  4 = LO(address) of STA (P),Y in DRAW_BYTE  6
 EQUB  6 * 17 + 15      \ Line  5 = LO(address) of STA (P),Y in DRAW_BYTE  6
 EQUB  6 * 17 + 15      \ Line  6 = LO(address) of STA (P),Y in DRAW_BYTE  6
 EQUB  7 * 17 + 15      \ Line  7 = LO(address) of STA (P),Y in DRAW_BYTE  7
 EQUB  7 * 17 + 15      \ Line  8 = LO(address) of STA (P),Y in DRAW_BYTE  7
 EQUB  7 * 17 + 15      \ Line  9 = LO(address) of STA (P),Y in DRAW_BYTE  7
 EQUB  7 * 17 + 15      \ Line 10 = LO(address) of STA (P),Y in DRAW_BYTE  7
 EQUB  7 * 17 + 15      \ Line 11 = LO(address) of STA (P),Y in DRAW_BYTE  7
 EQUB  8 * 17 + 15      \ Line 12 = LO(address) of STA (P),Y in DRAW_BYTE  8
 EQUB  8 * 17 + 15      \ Line 13 = LO(address) of STA (P),Y in DRAW_BYTE  8
 EQUB  8 * 17 + 15      \ Line 14 = LO(address) of STA (P),Y in DRAW_BYTE  8
 EQUB  8 * 17 + 15      \ Line 15 = LO(address) of STA (P),Y in DRAW_BYTE  8
 EQUB  9 * 17 + 15      \ Line 16 = LO(address) of STA (P),Y in DRAW_BYTE  9
 EQUB  9 * 17 + 15      \ Line 17 = LO(address) of STA (P),Y in DRAW_BYTE  9
 EQUB  9 * 17 + 15      \ Line 18 = LO(address) of STA (P),Y in DRAW_BYTE  9
 EQUB  9 * 17 + 15      \ Line 19 = LO(address) of STA (P),Y in DRAW_BYTE  9
 EQUB 10 * 17 + 15      \ Line 20 = LO(address) of STA (P),Y in DRAW_BYTE 10
 EQUB 10 * 17 + 15      \ Line 21 = LO(address) of STA (P),Y in DRAW_BYTE 10
 EQUB 10 * 17 + 15      \ Line 22 = LO(address) of STA (P),Y in DRAW_BYTE 10
 EQUB 10 * 17 + 15      \ Line 23 = LO(address) of STA (P),Y in DRAW_BYTE 10
 EQUB 11 * 17 + 15      \ Line 24 = LO(address) of STA (P),Y in DRAW_BYTE 11
 EQUB 11 * 17 + 15      \ Line 25 = LO(address) of STA (P),Y in DRAW_BYTE 11
 EQUB 11 * 17 + 15      \ Line 26 = LO(address) of STA (P),Y in DRAW_BYTE 11
 EQUB 11 * 17 + 15      \ Line 27 = LO(address) of STA (P),Y in DRAW_BYTE 11
 EQUB 12 * 17 + 15      \ Line 28 = LO(address) of STA (P),Y in DRAW_BYTE 12
 EQUB 12 * 17 + 15      \ Line 29 = LO(address) of STA (P),Y in DRAW_BYTE 12
 EQUB 12 * 17 + 15      \ Line 30 = LO(address) of STA (P),Y in DRAW_BYTE 12
 EQUB 12 * 17 + 15      \ Line 31 = LO(address) of STA (P),Y in DRAW_BYTE 12
 EQUB 12 * 17 + 15      \ Line 32 = LO(address) of STA (P),Y in DRAW_BYTE 12
 EQUB 12 * 17 + 15      \ Line 33 = LO(address) of STA (P),Y in DRAW_BYTE 12
 EQUB 12 * 17 + 15      \ Line 34 = LO(address) of STA (P),Y in DRAW_BYTE 12
 EQUB 12 * 17 + 15      \ Line 35 = LO(address) of STA (P),Y in DRAW_BYTE 12
 EQUB 12 * 17 + 15      \ Line 36 = LO(address) of STA (P),Y in DRAW_BYTE 12
 EQUB 12 * 17 + 15      \ Line 37 = LO(address) of STA (P),Y in DRAW_BYTE 12
 EQUB 12 * 17 + 15      \ Line 38 = LO(address) of STA (P),Y in DRAW_BYTE 12
 EQUB 13 * 17 + 15      \ Line 39 = LO(address) of STA (P),Y in DRAW_BYTE 13
 EQUB 13 * 17 + 15      \ Line 40 = LO(address) of STA (P),Y in DRAW_BYTE 13
 EQUB 13 * 17 + 15      \ Line 41 = LO(address) of STA (P),Y in DRAW_BYTE 13
 EQUB 13 * 17 + 15      \ Line 42 = LO(address) of STA (P),Y in DRAW_BYTE 13
 EQUB 13 * 17 + 15      \ Line 43 = LO(address) of STA (P),Y in DRAW_BYTE 13

\ ******************************************************************************
\
\       Name: L317C
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L317C

 EQUB &28
 EQUB &28
 EQUB &00
 EQUB &00

\ ******************************************************************************
\
\       Name: L3180
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3180

 EQUB &81, &81, &81, &81
 EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81
 EQUB &81, &81, &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData3
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData3

 SKIP 58                \ Populated with code from &7F2A to &7F63

\ ******************************************************************************
\
\       Name: sub_C31D0
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C31D0

 LDX #3

.P31D2

 CPY L001F
 BCC C31DB
 LDA L3D7C,X
 BNE C31DE

.C31DB

 LDA L3D78,X

.C31DE

 STA (P),Y
 STA firstPixelTyre,Y
 STA firstPixelTrack,Y
 DEX
 BPL C31EB
 LDX #3

.C31EB

 DEY
 CPY U
 BNE P31D2
 INC T
 LDA P
 EOR #&80
 STA P
 BMI C31FC
 INC Q

.C31FC

 JMP C3D68

 EQUB 0                 \ This byte appears to be unused

\ ******************************************************************************
\
\       Name: token18
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 18
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token18

 EQUS " 5"              \ Print " 5"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3203
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3203

 EQUB &81

\ ******************************************************************************
\
\       Name: dashData4
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData4

 SKIP 76                \ Populated with code from &7EDE to &7F29

\ ******************************************************************************
\
\       Name: PrintDriverName
\       Type: Subroutine
\   Category: Text
\    Summary: Print a driver's name
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   (Y A)               Address of 12-character driver name
\
\ ******************************************************************************

.PrintDriverName

 STY S                  \ Set (S R) = (Y A)
 STA R

 LDY #0                 \ Set a character counter in Y

.name1

 LDA (R),Y              \ Set A to the Y-th character from (S R)

 JSR PrintCharacter     \ Print the character in A

 INY                    \ Increment the character counter

 CPY #12                \ Loop back to print the next character until we have
 BNE name1              \ printed all 12 characters

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: CheckRestartKeys
\       Type: Subroutine
\   Category: Keyboard
\    Summary: If the restart keys are being pressed, restart the game
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   RestartGame         Restart the game, putting the C flag into bit 7 of
\                       pressingShiftArrow
\
\ ******************************************************************************

.CheckRestartKeys

 LDX #&FF               \ Scan the keyboard to see if SHIFT is being pressed
 JSR ScanKeyboard

 BNE rest1              \ If SHIFT is not being pressed, jump to rest1

 LDX #&86               \ Scan the keyboard to see if right arrow is being
 JSR ScanKeyboard       \ pressed (if it is this will also set the C flag)

 BNE rest1              \ If right arrow is not being pressed, jump to rest1

 BIT pressingShiftArrow \ If bit 7 of pressingShiftArrow is set, then we are
 BMI rest2              \ still pressing Shift-arrow from a previous restart, so
                        \ jump to rest2 to return from the subroutine without
                        \ anything doing

                        \ If we get here then SHIFT-arrow is being pressed and
                        \ bit 7 of pressingShiftArrow is clear, so this is a
                        \ new pressing SHIFT-arrow, so we fall through into
                        \ RestartGame with the C flag set to restart the game
                        \ and set bit 7 of pressingShiftArrow

.RestartGame

 LDX startingStack      \ Set the stack pointer to the value it had when the
 TXS                    \ game started, which clears any stored addresses put on
                        \ the stack by the code we are now exiting from

 ROR pressingShiftArrow \ Shift the C flag into bit 7 of pressingShiftArrow

 JMP MainLoop           \ Jump to the start of the main gane loop to restart the
                        \ game

.rest1

 LSR pressingShiftArrow \ Clear bit 7 of pressingShiftArrow to indicate that we
                        \ are no longer pressing SHIFT-arrow

.rest2

 RTS                    \ Return from the subroutine

 EQUB 0, 0              \ These bytes appear to be unused

\ ******************************************************************************
\
\       Name: token19
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 19
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token19

 EQUS "10"              \ Print "10"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: dashData5
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData5

 SKIP 77                \ Populated with code from &7E91 to &7EDD

\ ******************************************************************************
\
\       Name: GetNumberFromText
\       Type: Subroutine
\   Category: Text
\    Summary: Convert a two-digit string into a number
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   T                   The first digit of the number, as text
\
\   U                   The second digit of the number, as text
\
\ Returns:
\
\   A                   The numerical value of the number
\
\   C flag              The status of the conversion:
\
\                         * Clear if the string is a valid number and A <= 40
\
\                         * Set if string is not a valid number, or A > 40
\
\ ******************************************************************************

.GetNumberFromText

 LDA T                  \ Set A to the character containing the first digit

 CMP #' '               \ If the first digit is not a space, skip the following
 BNE tnum1              \ instruction

 LDA #'0'               \ The first digit is a space, so convert it to a "0"

.tnum1

 SEC                    \ Subtract the ASCII value for "0" to get the numerical
 SBC #'0'               \ value of the first digit into A

 CMP #10                \ If the value of the first digit is greater than 10,
 BCS tnum2              \ then this is not a valid number, so jump to tnum2 to
                        \ return from the subroutine with the C flag set, to
                        \ indicate an error

 STA T                  \ Set T = the value of the first digit

 LDX U                  \ Set X to the character containing the second digit

 CPX #' '               \ If the second digit is a space, then jump to tnum2 to
 CLC                    \ return from the subroutine with the value of the first
 BEQ tnum2              \ digit in A and the C flag clear, to indicate success

 ASL A                  \ Set T = (A << 2 + T) << 1
 ASL A                  \       = (A * 4 + A) * 2
 ADC T                  \       = 10 * A
 ASL A                  \
 STA T                  \ So T contains 10 * the numerical value of the first
                        \ digit

 TXA                    \ Set A to the character containing the second digit

 SEC                    \ Subtract the ASCII value for "0" to get the numerical
 SBC #'0'               \ value of the second digit

 CMP #10                \ If the value of the second digit is greater than 10,
 BCS tnum2              \ then this is not a valid number, so jump to tnum2 to
                        \ return from the subroutine with the C flag set, to
                        \ indicate an error

 ADC T                  \ Set A = A + T
                        \       = the numerical value of the second digit
                        \         + 10 * the numerical value of the first digit
                        \
                        \ which is the numerical value of the two-digit string

 CMP #41                \ If A < 41, clear the C flag, otherwise set it

.tnum2

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: startDialLo
\       Type: Variable
\   Category: Graphics
\    Summary: The low byte of the screen address of the start of the dial hand
\             on the rev counter
\
\ ******************************************************************************

.startDialLo

 EQUB &66               \ Quadrant 0 (12:00 to 3:00) = &7566
 EQUB &67               \ Quadrant 1 (3:00 to 6:00)  = &7567
 EQUB &5F               \ Quadrant 2 (6:00 to 9:00)  = &755F
 EQUB &5E               \ Quadrant 3 (9:00 to 12:00) = &755E

\ ******************************************************************************
\
\       Name: token20
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 20
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token20

 EQUS "20"              \ Print "20"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: dashData6
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData6

 SKIP 77                \ Populated with code from &7E44 to &7E90

\ ******************************************************************************
\
\       Name: leftDashPixels
\       Type: Variable
\   Category: Graphics
\    Summary: Pixels along the left edge of the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Contains a pixel byte for the white border (colour 2) along the left edge of
\ the dashboard.

\ There is a byte for each track line from 43 (the track line at the top of the
\ dashboard) down to 3 (the lowest track line, just above where the wing mirror
\ joins the car body). Lines 0 to 2 are not used.
\
\ Each pixel is a colour 2 pixel, so the high nibble contains a 1 and the low
\ nibble contains a 0, to give colour %10. Colour 2 is mapped to white at this
\ point of the custom screen.
\
\ ******************************************************************************

.leftDashPixels

 EQUB %00000000         \ Line  0
 EQUB %00000000         \ Line  1
 EQUB %11110000         \ Line  2
 EQUB %01110000         \ Line  3
 EQUB %00110000         \ Line  4
 EQUB %00010000         \ Line  5
 EQUB %00000000         \ Line  6
 EQUB %01110000         \ Line  7
 EQUB %01110000         \ Line  8
 EQUB %00110000         \ Line  9
 EQUB %00010000         \ Line 10
 EQUB %00000000         \ Line 11
 EQUB %01110000         \ Line 12
 EQUB %00110000         \ Line 13
 EQUB %00010000         \ Line 14
 EQUB %00000000         \ Line 15
 EQUB %01110000         \ Line 16
 EQUB %00110000         \ Line 17
 EQUB %00010000         \ Line 18
 EQUB %00000000         \ Line 19
 EQUB %01110000         \ Line 20
 EQUB %00110000         \ Line 21
 EQUB %00010000         \ Line 22
 EQUB %00000000         \ Line 23
 EQUB %01110000         \ Line 24
 EQUB %00110000         \ Line 25
 EQUB %00010000         \ Line 26
 EQUB %00000000         \ Line 27
 EQUB %01110000         \ Line 28
 EQUB %01000000         \ Line 29
 EQUB %00110000         \ Line 30
 EQUB %00100000         \ Line 31
 EQUB %00110000         \ Line 32
 EQUB %00010000         \ Line 33
 EQUB %00010000         \ Line 34
 EQUB %00010000         \ Line 35
 EQUB %00000000         \ Line 36
 EQUB %00000000         \ Line 37
 EQUB %00000000         \ Line 38
 EQUB %01000000         \ Line 39
 EQUB %01110000         \ Line 40
 EQUB %01000000         \ Line 41
 EQUB %00110000         \ Line 42
 EQUB %00110000         \ Line 43

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

 EQUB &00, &88, &CC, &EE

\ ******************************************************************************
\
\       Name: L3380
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3380

 EQUB &81, &81, &81, &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData7
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData7

 SKIP 73                \ Populated with code from &7DFB to &7E43

\ ******************************************************************************
\
\       Name: rightDashPixels
\       Type: Variable
\   Category: Graphics
\    Summary: Pixels along the right edge of the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Contains a pixel byte for the white border (colour 2) along the right edge of
\ the dashboard.
\
\ There is a byte for each track line from 43 (the track line at the top of the
\ dashboard) down to 3 (the lowest track line, just above where the wing mirror
\ joins the car body). Lines 0 to 2 are not used.
\
\ Each pixel is a colour 2 pixel, so the high nibble contains a 1 and the low
\ nibble contains a 0, to give colour %10. Colour 2 is mapped to white at this
\ point of the custom screen.
\
\ ******************************************************************************

.rightDashPixels

 EQUB %00000000         \ Line  0
 EQUB %00000000         \ Line  1
 EQUB %11110000         \ Line  2
 EQUB %11100000         \ Line  3
 EQUB %11000000         \ Line  4
 EQUB %10000000         \ Line  5
 EQUB %00000000         \ Line  6
 EQUB %11100000         \ Line  7
 EQUB %11100000         \ Line  8
 EQUB %11000000         \ Line  9
 EQUB %10000000         \ Line 10
 EQUB %00000000         \ Line 11
 EQUB %11100000         \ Line 12
 EQUB %11000000         \ Line 13
 EQUB %10000000         \ Line 14
 EQUB %00000000         \ Line 15
 EQUB %11100000         \ Line 16
 EQUB %11000000         \ Line 17
 EQUB %10000000         \ Line 18
 EQUB %00000000         \ Line 19
 EQUB %11100000         \ Line 20
 EQUB %11000000         \ Line 21
 EQUB %10000000         \ Line 22
 EQUB %00000000         \ Line 23
 EQUB %11100000         \ Line 24
 EQUB %11000000         \ Line 25
 EQUB %10000000         \ Line 26
 EQUB %00000000         \ Line 27
 EQUB %11100000         \ Line 28
 EQUB %00100000         \ Line 29
 EQUB %11000000         \ Line 30
 EQUB %01000000         \ Line 31
 EQUB %11000000         \ Line 32
 EQUB %10000000         \ Line 33
 EQUB %10000000         \ Line 34
 EQUB %10000000         \ Line 35
 EQUB %00000000         \ Line 36
 EQUB %00000000         \ Line 37
 EQUB %00000000         \ Line 38
 EQUB %00100000         \ Line 39
 EQUB %11100000         \ Line 40
 EQUB %00100000         \ Line 41
 EQUB %11000000         \ Line 42
 EQUB %11000000         \ Line 43
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

\ ******************************************************************************
\
\       Name: token11
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 11
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token11

 EQUS "ENTER "          \ Print "ENTER "

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3407
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3407

 EQUB &81, &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData8
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData8

 SKIP 68                \ Populated with code from &7DB7 to &7DFA

\ ******************************************************************************
\
\       Name: Absolute8Bit
\       Type: Subroutine
\   Category: Maths
\    Summary: Calculate the absolute value (modulus) of an 8-bit number
\
\ ------------------------------------------------------------------------------
\
\ This routine returns |A|.
\
\ Arguments:
\
\   A                   The number to make positive
\
\ ******************************************************************************

.Absolute8Bit

 BPL aval1              \ If A is positive then it already contains its absolute
                        \ value, so jump to aval1 to return from the subroutine

 EOR #&FF               \ Negate the value in A using two's complement, as the
 CLC                    \ following is true when A is negative:
 ADC #1                 \
                        \   |A| = -A
                        \       = ~A + 1

.aval1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: paletteSection2
\       Type: Variable
\   Category: Screen mode
\    Summary: Colour palette for screen section 2 in the custom screen mode
\             (part of the mode 5 portion)
\  Deep dive: Hidden secrets of the custom screen mode
\
\ ------------------------------------------------------------------------------
\
\ Palette data is given as a set of bytes, with each byte mapping a logical
\ colour to a physical one. In each byte, the logical colour is given in bits
\ 4-7 and the physical colour in bits 0-3. See p.379 of the Advanced User Guide
\ for details of how palette mapping works, as in modes 4 and 5 we have to do
\ multiple palette commands to change the colours correctly, and the physical
\ colour value is EOR'd with 7, just to make things even more confusing.
\
\ Each of these mappings requires six calls to SHEILA &21 - see p.379 of the
\ Advanced User Guide for an explanation.
\
\ ******************************************************************************

.paletteSection2

 EQUB &07, &17          \ Map logical colour 0 to physical colour 0 (black)
 EQUB &47, &57

 EQUB &23, &33          \ Map logical colour 1 to physical colour 4 (blue)
 EQUB &63, &73

 EQUB &80, &90          \ Map logical colour 2 to physical colour 7 (white)
 EQUB &C0, &D0

 EQUB &A5, &B5          \ Map logical colour 3 to physical colour 2 (green)
 EQUB &E5, &F5

\ ******************************************************************************
\
\       Name: paletteSection0
\       Type: Variable
\   Category: Screen mode
\    Summary: Colour palette for screen section 0 in the custom screen mode (the
\             mode 4 portion)
\  Deep dive: Hidden secrets of the custom screen mode
\
\ ******************************************************************************

.paletteSection0

 EQUB &03, &13          \ Map logical colour 0 to physical colour 4 (blue)
 EQUB &23, &33
 EQUB &43, &53
 EQUB &63, &73

 EQUB &84, &94          \ Map logical colour 1 to physical colour 3 (yellow)
 EQUB &A4, &B4
 EQUB &C4, &D4
 EQUB &E4, &F4

\ ******************************************************************************
\
\       Name: paletteSection3
\       Type: Variable
\   Category: Screen mode
\    Summary: Colour palette for screen section 3 in the custom screen mode
\             (part of the mode 5 portion)
\  Deep dive: Hidden secrets of the custom screen mode
\
\ ******************************************************************************

.paletteSection3

 EQUB &26, &36          \ Map logical colour 1 to physical colour 1 (red)
 EQUB &66, &76

\ ******************************************************************************
\
\       Name: paletteSection4
\       Type: Variable
\   Category: Screen mode
\    Summary: Colour palette for screen section 4 in the custom screen mode
\             (part of the mode 5 portion)
\  Deep dive: Hidden secrets of the custom screen mode
\
\ ******************************************************************************

.paletteSection4

 EQUB &A1, &B1          \ Map logical colour 3 to physical colour 6 (cyan)
 EQUB &E1, &F1

\ ******************************************************************************
\
\       Name: token25
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 25
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token25

 EQUB 31, 13, 18        \ Move text cursor to column 13, row 18

 EQUS "front"           \ Print "front"

 EQUB 160 + 2           \ Print 2 spaces

 EQUB 133               \ Set foreground colour to magenta alphanumeric

 EQUB 200 + 16          \ Print token 16 (" > ")

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L348C
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

 EQUB &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData9
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData9

 SKIP 64                \ Populated with code from &7D77 to &7DB6

\ ******************************************************************************
\
\       Name: WaitForSpace
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Print a prompt, wait for the SPACE key to be released, and wait
\             for SPACE to be pressed
\
\ ******************************************************************************

.WaitForSpace

 LDA #0                 \ Set A = 0 so WaitForSpaceReturn waits for SPACE to be
                        \ pressed

                        \ Fall through into WaitForSpaceReturn to print the
                        \ prompt, wait for the SPACE key to be released, and
                        \ wait for SPACE to be pressed

\ ******************************************************************************
\
\       Name: WaitForSpaceReturn
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Print a prompt, wait for the SPACE key to be released, and wait
\             for either SPACE or RETURN to be pressed
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   Determines the key to wait for:
\
\                         * Bit 7 clear = wait for SPACE to be pressed
\
\                         * Bit 7 set = wait for SPACE or RETURN to be pressed
\
\ Returns:
\
\   G                   If bit 7 was set on entry, then it is cleared if RETURN
\                       was pressed, but remains set if SPACE was pressed
\
\ ******************************************************************************

.WaitForSpaceReturn

 STA G                  \ Store A in G so we can check the value of bit 7 below

 LDX #30                \ Print token 30 ("PRESS SPACE BAR TO CONTINUE" in cyan
 JSR PrintToken         \ at column 5, row 24)

.wait1

 LDX #&9D               \ Scan the keyboard to see if SPACE is being pressed
 JSR ScanKeyboard

 BEQ wait1              \ If SPACE is being pressed, loop back to wait1 until
                        \ it is released

.wait2

 LDX #&9D               \ Scan the keyboard to see if SPACE is being pressed
 JSR ScanKeyboard

 BEQ C34F7              \ If SPACE is being pressed, jump to C34F7 to return
                        \ from the subroutine

 JSR CheckRestartKeys   \ Check whether the restart keys are being pressed, and
                        \ if they are, restart the game (the restart keys are
                        \ SHIFT and right arrow)

 BIT G                  \ If bit 7 of G is clear, jump back to wait2 to wait for
 BPL wait2              \ SPACE to be pressed

 LDX #&B6               \ Scan the keyboard to see if RETURN is being pressed
 JSR ScanKeyboard

 BNE wait2              \ If RETURN is not being pressed, jump back to wait2 to
                        \ wait for RETURN is being pressed

 LSR G                  \ Clear bit 7 of G

.C34F7

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: pixelByte
\       Type: Variable
\   Category: Graphics
\    Summary: A table of pixel bytes with individual pixels set
\
\ ******************************************************************************

.pixelByte

 EQUB %10000000         \ Pixel byte with the first pixel set to colour 2
 EQUB %01000000         \ Pixel byte with the second pixel set to colour 2
 EQUB %00100000         \ Pixel byte with the third pixel set to colour 2
 EQUB %00010000         \ Pixel byte with the fourth pixel set to colour 2

 EQUB %00000000         \ Pixel byte with the first pixel set to colour 0
 EQUB %00000000         \ Pixel byte with the second pixel set to colour 0
 EQUB %00000000         \ Pixel byte with the third pixel set to colour 0
 EQUB %00000000         \ Pixel byte with the fourth pixel set to colour 0

\ ******************************************************************************
\
\       Name: token8
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 8
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token8

 EQUS "Amateur"         \ Print "Amateur"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token51
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 51
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token51

 EQUS " POINTS"         \ Print " POINTS"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3510
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3510

 EQUB &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData10
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData10

 SKIP 60                \ Populated with code from &7D3B to &7D76

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
 EQUB &00, &01, &03, &01, &03

\ ******************************************************************************
\
\       Name: leftTyrePixels
\       Type: Variable
\   Category: Graphics
\    Summary: Pixels along the edge of the left tyre
\
\ ------------------------------------------------------------------------------
\
\ Contains a pixel byte for the white border (colour 2) along the edge of the
\ left tyre.

\ The tyreEdgeIndex table maps track line numbers to entries in this table.
\
\ Each pixel is a colour 2 pixel, so the high nibble contains a 1 and the low
\ nibble contains a 0, to give colour %10. Colour 2 is mapped to white at this
\ point of the custom screen.
\
\ ******************************************************************************

.leftTyrePixels

 EQUB %00000000
 EQUB %10000000
 EQUB %11000000
 EQUB %01000000
 EQUB %01100000
 EQUB %11100000
 EQUB %00100000

\ ******************************************************************************
\
\       Name: token31
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 31
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token31

 EQUS "  "              \ Print "  "

 EQUB 156               \ Set background colour to black

 EQUB 134, 157          \ Set background colour (configurable, default is cyan)

 EQUB 132               \ Set foreground colour (configurable, default is blue
                        \ alphanumeric

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token3
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 3
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token3

 EQUS "ACCUMULATED"     \ Print "ACCUMULATED"

 EQUB 200 + 51          \ Print token 51 (" POINTS")

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3594
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3594

 EQUB &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData11
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData11

 SKIP 56                \ Populated with code from &7D03 to &7D3A

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
 EQUB &03, &03, &0A, &03, &0A

\ ******************************************************************************
\
\       Name: rightTyrePixels
\       Type: Variable
\   Category: Graphics
\    Summary: Pixels along the edge of the right tyre
\
\ ------------------------------------------------------------------------------
\
\ Contains a pixel byte for the white border (colour 2) along the edge of the
\ right tyre.

\ The tyreEdgeIndex table maps track line numbers to entries in this table.
\
\ Each pixel is a colour 2 pixel, so the high nibble contains a 1 and the low
\ nibble contains a 0, to give colour %10. Colour 2 is mapped to white at this
\ point of the custom screen.
\
\ ******************************************************************************

.rightTyrePixels

 EQUB %00000000
 EQUB %00010000
 EQUB %00110000
 EQUB %00100000
 EQUB %01100000
 EQUB %01110000
 EQUB %01000000

\ ******************************************************************************
\
\       Name: token0
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 0
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token0

 EQUS "FORMULA 3  "     \ Print "FORMULA 3  "

 EQUS "CHAMPIONSHIP"    \ Print "CHAMPIONSHIP"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3618
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3618

 EQUB &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData12
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData12

 SKIP 52                \ Populated with code from &7CCF to &7D02

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
 EQUB &01, &08, &08, &09, &01

\ ******************************************************************************
\
\       Name: leftTyreMask
\       Type: Variable
\   Category: Graphics
\    Summary: Pixel mask for the edge of the left tyre
\
\ ------------------------------------------------------------------------------
\
\ Contains a mask byte for the track pixels along the edge of the left tyre.
\
\ The tyreEdgeIndex table maps track line numbers to entries in this table.
\
\ Set bits correspond to the track pixels, while clear bits correspond to the
\ tyre pixels.
\
\ ******************************************************************************

.leftTyreMask

 EQUB %11111111
 EQUB %01110111
 EQUB %00110011
 EQUB %00110011
 EQUB %00010001
 EQUB %00010001
 EQUB %00010001

\ ******************************************************************************
\
\       Name: token42
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 42
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token42

 EQUB 160 + 11          \ Print 11 spaces

 EQUS "YOUR TIME "      \ Print "YOUR TIME "

 EQUS "IS UP!"          \ Print "IS UP!"

 EQUB 160 + 11          \ Print 11 spaces

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token17
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 17
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token17

 EQUS "PRESS "          \ Print "PRESS "

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L369A
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L369A

 EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81
 EQUB &81, &81

\ ******************************************************************************
\
\       Name: dashData13
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData13

 SKIP 41                \ Populated with code from &7CA6 to &7CCE

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
 EQUB &00, &01, &09, &00, &00

\ ******************************************************************************
\
\       Name: rightTyreMask
\       Type: Variable
\   Category: Graphics
\    Summary: Pixel mask for the edge of the right tyre
\
\ ------------------------------------------------------------------------------
\
\ Contains a mask byte for the track pixels along the edge of the right tyre.
\
\ The tyreEdgeIndex table maps track line numbers to entries in this table.
\
\ Set bits correspond to the track pixels, while clear bits correspond to the
\ tyre pixels.
\
\ ******************************************************************************

.rightTyreMask

 EQUB %11111111
 EQUB %11101110
 EQUB %11001100
 EQUB %11001100
 EQUB %10001000
 EQUB %10001000
 EQUB %10001000

\ ******************************************************************************
\
\       Name: token23
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 23
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token23

 EQUB 200 + 54          \ Print token 54 ("FORMULA 3  CHAMPIONSHIP" header)

 EQUB 200 + 35          \ Print token 35 (cyan, move cursor to prompt position)

 EQUB 160 + 7           \ Print 7 spaces

 EQUB 200 + 11          \ Print token 11 ("ENTER ")

 EQUS "NAME OF"         \ Print "NAME OF"

 EQUB 200 + 12          \ Print token 12 (" DRIVER")

 EQUB 31, 12, 17        \ Move text cursor to column 12, row 17

 EQUB 131               \ Set foreground colour to yellow alphanumeric

 EQUS "____________"    \ Print "____________"

 EQUB 31, 9, 16         \ Move text cursor to column 9, row 16

 EQUB 133               \ Set foreground colour to magenta alphanumeric

 EQUB 200 + 16          \ Print token 16 (" > ")

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token35
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 35
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token35

 EQUB 31, 2, 10         \ Move text cursor to column 2, row 10

 EQUB 134               \ Set foreground colour to cyan alphanumeric

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3727
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3727

 EQUB &81, &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData14
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData14

 SKIP 36                \ Populated with code from &7C82 to &7CA5

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
\       Name: gearNumberText
\       Type: Variable
\   Category: Text
\    Summary: The character to print on the gear stick for each gear
\
\ ******************************************************************************

.gearNumberText

 EQUS "RN12345"

\ ******************************************************************************
\
\       Name: token43
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 43
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token43

 EQUS "Position"        \ Print "Position"

 EQUB 160 + 8           \ Print 8 spaces

 EQUS "In front:"       \ Print "In front:"

 EQUB 160 + 13          \ Print 13 spaces

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token44
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 44
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token44

 EQUS "Laps to go"      \ Print "Laps to go"

 EQUB 160 + 8           \ Print 8 spaces

 EQUS "Behind:"         \ Print "Behind:"

 EQUB 160 + 18          \ Print 18 spaces

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token45
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 45
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token45

 EQUB 160 + 38          \ Print 38 spaces

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L37AA
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L37AA

 EQUB &81, &81

\ ******************************************************************************
\
\       Name: dashData15
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData15

 SKIP 36                \ Populated with code from &7C5E to &7C81

\ ******************************************************************************
\
\       Name: Print2DigitBCD
\       Type: Subroutine
\   Category: Text
\    Summary: Print a binary coded decimal (BCD) number in the specified format
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number to print (in BCD)
\
\   G                   Flags to control how the number is printed:
\
\                         * Bit 7: clear = do not print leading zeroes
\                                  set = print leading zeroes
\
\                         * Bit 6: clear = print second digit
\                                  set = do not print second digit
\
\ Returns:
\
\   G                   G is shifted left by two places, so bits 4 and 5 will be
\                       used to determine the printing style in the next call to
\                       Print2DigitBCD
\
\ Other entry points:
\
\   (X, Y)              The screen coordinate where we should print the number,
\                       where X is the character column and Y is the pixel row
\                       of the bottom of the character
\
\ ******************************************************************************

 STX xCursor            \ Set the cursor to (X, Y), so we print the number at
 STY yCursor            \ the specified screen location

.Print2DigitBCD

 PHA                    \ Store A on the stack so we can retrieve it later

 LSR A                  \ Shift the high nibble of A into bits 0-3, so A
 LSR A                  \ contains the first digit of the BCD number
 LSR A
 LSR A

 BNE pnum1              \ If the result is non-zero, jump to pnum1 to print the
                        \ digit in A

                        \ Otherwise the first digit is a zero, which we either
                        \ print as a capital "O" (so it doesn't have a line
                        \ through it), or as a space, depending on the setting
                        \ in G, which controls whether or not to print leading
                        \ zeroes

 LDA #'O'-'0'           \ Set A so we print a capital "O" in pnum1

 BIT G                  \ If bit 7 of G is set, jump to pnum1 to print a capital
 BMI pnum1              \ "O"

 LDA #LO(' '-'0')       \ Otherwise bit 7 of G is clear and we do not print
                        \ leading zeroes, so instead set A so we print a space
                        \ in pnum1

.pnum1

 CLC                    \ Print the high nibble in A as a digit (or, if the high
 ADC #'0'               \ nibble is zero, print a capitel "O" or a space, as per
 JSR PrintCharacter     \ the above)

                        \ Now for the second digit

 ASL G                  \ Shift G to the left, so bit 6 is now in bit 7

 PLA                    \ Retrieve the original value of A, which contains the
                        \ BCD number to print

 ASL G                  \ If bit 7 of G is set (i.e. bit 6 of the original G),
 BCS pnum3              \ jump to pnum3 to skip printing the second digit, and
                        \ return from the subroutine

 AND #%00001111         \ Extract the low nibble of the BCD number into A

 BNE pnum2              \ If the low nibble is non-zero, jump to pnum2 to skip
                        \ the following instruction

 LDA #'O'-'0'           \ Set A so we print a capital "O" in pnum2

.pnum2

 CLC                    \ Print the low nibble in A as a digit (or, if the low
 ADC #'0'               \ nibble is zero, print a capital "O")
 JSR PrintCharacter

.pnum3

 RTS                    \ Return from the subroutine

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

.L37FF

 EQUB &FF

\ ******************************************************************************
\
\       Name: token22
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 22
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token22

 EQUB 200 + 54          \ Print token 54 ("FORMULA 3  CHAMPIONSHIP" header)

 EQUB 200 + 36          \ Print token 36 (menu option 1 with "PRESS" prompt)

 EQUB 200 + 18          \ Print token 18 (" 5")

 EQUB 200 + 13          \ Print token 13 (" mins")

 EQUB 200 + 37          \ Print token 37 (menu option 2)

 EQUB 200 + 19          \ Print token 19 ("10")

 EQUB 200 + 13          \ Print token 13 (" mins")

 EQUB 200 + 38          \ Print token 38 (menu option 3)

 EQUB 200 + 20          \ Print token 20 ("20")

 EQUB 200 + 13          \ Print token 13 (" mins")

 EQUB 200 + 35          \ Print token 35 (cyan, move cursor to prompt position)

 EQUB 200 + 10          \ Print token 10 ("SELECT ")

 EQUS "DURATION OF "    \ Print "DURATION OF "

 EQUS "QUALIFYING LAPS" \ Print "QUALIFYING LAPS"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token16
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 16
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token16

 EQUS " ] "             \ Print " ] "

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: dashData16
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData16

 SKIP 36                \ Populated with code from &7C3A to &7C5D

\ ******************************************************************************
\
\       Name: L3850Lo
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ******************************************************************************

.L3850Lo

IF _ACORNSOFT

 EQUB &FF, &88
 EQUB &88, &CC
 EQUB &CC, &CC
 EQUB &CC, &CC
 EQUB &CC, &EE
 EQUB &EE, &EE
 EQUB &EE, &FF
 EQUB &FF, &FF
 EQUB &88, &88
 EQUB &88, &CC

ELIF _SUPERIOR

 SKIP 20

ENDIF

\ ******************************************************************************
\
\       Name: totalPointsLo
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ******************************************************************************

.totalPointsLo

IF _ACORNSOFT

 EQUB &CC, &CC
 EQUB &EE, &FF
 EQUB &FF, &88
 EQUB &CC, &EE
 EQUB &FF, &FF
 EQUB &FF, &FF
 EQUB &FF, &FF
 EQUB &FF, &FF
 EQUB &FF, &FF
 EQUB &FF, &FF

ELIF _SUPERIOR

 SKIP 20                \ Low byte of total accumulated points for each driver
                        \
                        \ Indexed by driver number (0 to 19)
                        \
                        \ Gets set to 0 in InitialiseDrivers
                        \
                        \ Stored as a 24-bit value (totalPointsTop totalPointsHi
                        \ totalPointsLo)

ENDIF

\ ******************************************************************************
\
\       Name: racePointsLo
\       Type: Variable
\   Category: Drivers
\    Summary: Used to store the low byte of the race points being awarded to
\             the driver in race position X
\
\ ******************************************************************************

.racePointsLo

IF _ACORNSOFT

 EQUB &FF, &FF
 EQUB &FF, &FF
 EQUB &FF, &FF
 EQUB &FF, &FF

ELIF _SUPERIOR

 SKIP 8

ENDIF

\ ******************************************************************************
\
\       Name: token39
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 39
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token39

 EQUB 200 + 36          \ Print token 36 (menu option 1 with "PRESS" prompt)

 EQUS "PRACTICE"        \ Print "PRACTICE"

 EQUB 200 + 37          \ Print token 37 (menu option 2)

 EQUS "COMPETITION"     \ Print "COMPETITION"

 EQUB 255               \ End token

 EQUB &FF               \ This byte appears to be unused

\ ******************************************************************************
\
\       Name: token48
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 48
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token48

 EQUB 160 + 13          \ Print 13 spaces

 EQUS "PLEASE"          \ Print "PLEASE"

 EQUB 160 + 2           \ Print 2 spaces

 EQUS "WAIT"            \ Print "WAIT"

 EQUB 160 + 13          \ Print 13 spaces

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token49
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 49
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token49

 EQUB 31, 9, 2          \ Move text cursor to column 9, row 2

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L38A9
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L38A9

 EQUB &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData17
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData17

 SKIP 36                \ Populated with code from &7C16 to &7C39

\ ******************************************************************************
\
\       Name: leftDashMask
\       Type: Variable
\   Category: Graphics
\    Summary: Pixel mask for the left edge of the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Contains a mask byte for the track pixels along the left edge of the central
\ part of the dashboard.
\
\ There is a byte for each track line from 43 (the track line at the top of the
\ dashboard) down to 3 (the lowest track line, just above where the wing mirror
\ joins the car body). Lines 0 to 2 are not used.
\
\ Set bits correspond to the track pixels, while clear bits correspond to the
\ dashboard pixels.
\
\ ******************************************************************************

.leftDashMask

 EQUB %11111111         \ Line  0
 EQUB %11111111         \ Line  1
 EQUB %10001000         \ Line  2
 EQUB %10001000         \ Line  3
 EQUB %11001100         \ Line  4
 EQUB %11101110         \ Line  5
 EQUB %11111111         \ Line  6
 EQUB %10001000         \ Line  7
 EQUB %10001000         \ Line  8
 EQUB %11001100         \ Line  9
 EQUB %11101110         \ Line 10
 EQUB %11111111         \ Line 11
 EQUB %10001000         \ Line 12
 EQUB %11001100         \ Line 13
 EQUB %11101110         \ Line 14
 EQUB %11111111         \ Line 15
 EQUB %10001000         \ Line 16
 EQUB %11001100         \ Line 17
 EQUB %11101110         \ Line 18
 EQUB %11111111         \ Line 19
 EQUB %10001000         \ Line 20
 EQUB %11001100         \ Line 21
 EQUB %11101110         \ Line 22
 EQUB %11111111         \ Line 23
 EQUB %10001000         \ Line 24
 EQUB %11001100         \ Line 25
 EQUB %11101110         \ Line 26
 EQUB %11111111         \ Line 27
 EQUB %10001000         \ Line 28
 EQUB %10001000         \ Line 29
 EQUB %11001100         \ Line 30
 EQUB %11001100         \ Line 31
 EQUB %11001100         \ Line 32
 EQUB %11101110         \ Line 33
 EQUB %11101110         \ Line 34
 EQUB %11101110         \ Line 35
 EQUB %11111111         \ Line 36
 EQUB %11111111         \ Line 37
 EQUB %11111111         \ Line 38
 EQUB %10001000         \ Line 39
 EQUB %10001000         \ Line 40
 EQUB %10001000         \ Line 41
 EQUB %11001100         \ Line 42
 EQUB %11001100         \ Line 43

\ ******************************************************************************
\
\       Name: colourByte
\       Type: Variable
\   Category: Graphics
\    Summary: Mode 5 bytes containing four pixels of each colour
\
\ ******************************************************************************

.colourByte

 EQUB &00               \ Four pixels of colour 0
 EQUB &0F               \ Four pixels of colour 1
 EQUB &F0               \ Four pixels of colour 2
 EQUB &FF               \ Four pixels of colour 3

\ ******************************************************************************
\
\       Name: dashDataOffset
\       Type: Variable
\   Category: Dashboard
\    Summary: Offset of the dash data within each dash data block
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashDataOffset

 EQUB dashData0  - (dashData + &80 *  0) - 1
 EQUB dashData1  - (dashData + &80 *  1) - 1
 EQUB dashData2  - (dashData + &80 *  2) - 1
 EQUB dashData3  - (dashData + &80 *  3) - 1
 EQUB dashData4  - (dashData + &80 *  4) - 1
 EQUB dashData5  - (dashData + &80 *  5) - 1
 EQUB dashData6  - (dashData + &80 *  6) - 1
 EQUB dashData7  - (dashData + &80 *  7) - 1
 EQUB dashData8  - (dashData + &80 *  8) - 1
 EQUB dashData9  - (dashData + &80 *  9) - 1
 EQUB dashData10 - (dashData + &80 * 10) - 1
 EQUB dashData11 - (dashData + &80 * 11) - 1
 EQUB dashData12 - (dashData + &80 * 12) - 1
 EQUB dashData13 - (dashData + &80 * 13) - 1
 EQUB dashData14 - (dashData + &80 * 14) - 1
 EQUB dashData15 - (dashData + &80 * 15) - 1
 EQUB dashData16 - (dashData + &80 * 16) - 1
 EQUB dashData17 - (dashData + &80 * 17) - 1
 EQUB dashData18 - (dashData + &80 * 18) - 1
 EQUB dashData19 - (dashData + &80 * 19) - 1
 EQUB dashData20 - (dashData + &80 * 20) - 1
 EQUB dashData21 - (dashData + &80 * 21) - 1
 EQUB dashData22 - (dashData + &80 * 22) - 1
 EQUB dashData23 - (dashData + &80 * 23) - 1
 EQUB dashData24 - (dashData + &80 * 24) - 1
 EQUB dashData25 - (dashData + &80 * 25) - 1
 EQUB dashData26 - (dashData + &80 * 26) - 1
 EQUB dashData27 - (dashData + &80 * 27) - 1
 EQUB dashData28 - (dashData + &80 * 28) - 1
 EQUB dashData29 - (dashData + &80 * 29) - 1
 EQUB dashData30 - (dashData + &80 * 30) - 1
 EQUB dashData31 - (dashData + &80 * 31) - 1
 EQUB dashData32 - (dashData + &80 * 32) - 1
 EQUB dashData33 - (dashData + &80 * 33) - 1
 EQUB dashData34 - (dashData + &80 * 34) - 1
 EQUB dashData35 - (dashData + &80 * 35) - 1
 EQUB dashData36 - (dashData + &80 * 36) - 1
 EQUB dashData37 - (dashData + &80 * 37) - 1
 EQUB dashData38 - (dashData + &80 * 38) - 1
 EQUB dashData39 - (dashData + &80 * 39) - 1
 EQUB dashData40 - (dashData + &80 * 40) - 1

 EQUB &FF

\ ******************************************************************************
\
\       Name: L392A
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L392A

 EQUB &81, &81

\ ******************************************************************************
\
\       Name: dashData18
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData18

 SKIP 36                \ Populated with code from &7BF2 to &7C15

\ ******************************************************************************
\
\       Name: rightDashMask
\       Type: Variable
\   Category: Dashboard
\    Summary: Pixel mask for the right edge of the dashboard
\
\ ------------------------------------------------------------------------------
\
\ Contains a mask byte for the track pixels along the right edge of the central
\ part of the dashboard.
\
\ There is a byte for each track line from 43 (the track line at the top of the
\ dashboard) down to 3 (the lowest track line, just above where the wing mirror
\ joins the car body). Lines 0 to 2 are not used.
\
\ Set bits correspond to the track pixels, while clear bits correspond to the
\ dashboard pixels.
\
\ ******************************************************************************

.rightDashMask

 EQUB %11111111         \ Line  0
 EQUB %11111111         \ Line  1
 EQUB %00010001         \ Line  2
 EQUB %00010001         \ Line  3
 EQUB %00110011         \ Line  4
 EQUB %01110111         \ Line  5
 EQUB %11111111         \ Line  6
 EQUB %00010001         \ Line  7
 EQUB %00010001         \ Line  8
 EQUB %00110011         \ Line  9
 EQUB %01110111         \ Line 10
 EQUB %11111111         \ Line 11
 EQUB %00010001         \ Line 12
 EQUB %00110011         \ Line 13
 EQUB %01110111         \ Line 14
 EQUB %11111111         \ Line 15
 EQUB %00010001         \ Line 16
 EQUB %00110011         \ Line 17
 EQUB %01110111         \ Line 18
 EQUB %11111111         \ Line 19
 EQUB %00010001         \ Line 20
 EQUB %00110011         \ Line 21
 EQUB %01110111         \ Line 22
 EQUB %11111111         \ Line 23
 EQUB %00010001         \ Line 24
 EQUB %00110011         \ Line 25
 EQUB %01110111         \ Line 26
 EQUB %11111111         \ Line 27
 EQUB %00010001         \ Line 28
 EQUB %00010001         \ Line 29
 EQUB %00110011         \ Line 30
 EQUB %00110011         \ Line 31
 EQUB %00110011         \ Line 32
 EQUB %01110111         \ Line 33
 EQUB %01110111         \ Line 34
 EQUB %01110111         \ Line 35
 EQUB %11111111         \ Line 36
 EQUB %11111111         \ Line 37
 EQUB %11111111         \ Line 38
 EQUB %00010001         \ Line 39
 EQUB %00010001         \ Line 40
 EQUB %00010001         \ Line 41
 EQUB %00110011         \ Line 42
 EQUB %00110011         \ Line 43

\ ******************************************************************************
\
\       Name: startDialHi
\       Type: Variable
\   Category: Graphics
\    Summary: The high byte of the screen address of the start of the dial hand
\             on the rev counter
\
\ ******************************************************************************

.startDialHi

 EQUB &75               \ Quadrant 0 (12:00 to 3:00) = &7566
 EQUB &75               \ Quadrant 1 (3:00 to 6:00)  = &7567
 EQUB &75               \ Quadrant 2 (6:00 to 9:00)  = &755F
 EQUB &75               \ Quadrant 3 (9:00 to 12:00) = &755E

\ ******************************************************************************
\
\       Name: wheelPixels
\       Type: Variable
\   Category: Graphics
\    Summary: The number of pixels in the longest axis for the steering wheel
\             line at various points in a quadrant
\
\ ------------------------------------------------------------------------------
\
\ This table contains values that are used to calculate the coordinates of the
\ end of the line on the steering wheel.
\
\ The contents of the table are very close to the following (the values from
\ the following calculation are shown in the comments below - they are close,
\ but not quite a perfect match, so I haven't got this exactly right):
\
\ FOR I%, 0, 37
\  EQUB INT(0.5 + 53 * COS((PI / 8) * I% / 21))
\ NEXT
\
\ This gives the length of the adjacent side of a right-angled triangle, with a
\ hypoteneuse of length 53, and an angle ranging from 0 to PI/4 (i.e. one
\ eighth of a circle), split up into 21 points per eighth of a circle (so the
\ table's 38 points cover almost a quarter of a circle).
\
\ In other words, if we have a clock whose centre is at the origin, then this
\ table contains the x-coordinate of the end of a clock hand of length 28 as it
\ moves from 3 o'clock to half past 4.
\
\ ******************************************************************************

.wheelPixels

 EQUB 53                \ INT(0.5 + 53.00) = 53
 EQUB 53                \ INT(0.5 + 52.99) = 53
 EQUB 53                \ INT(0.5 + 52.96) = 53
 EQUB 53                \ INT(0.5 + 52.92) = 53
 EQUB 53                \ INT(0.5 + 52.85) = 53
 EQUB 53                \ INT(0.5 + 52.77) = 53
 EQUB 53                \ INT(0.5 + 52.67) = 53
 EQUB 53                \ INT(0.5 + 52.55) = 53
 EQUB 52                \ INT(0.5 + 52.41) = 52
 EQUB 52                \ INT(0.5 + 52.25) = 52
 EQUB 52                \ INT(0.5 + 52.08) = 52
 EQUB 52                \ INT(0.5 + 51.88) = 52
 EQUB 52                \ INT(0.5 + 51.67) = 52
 EQUB 52                \ INT(0.5 + 51.44) = 51 (doesn't match)
 EQUB 51                \ INT(0.5 + 51.19) = 51
 EQUB 51                \ INT(0.5 + 50.93) = 51
 EQUB 51                \ INT(0.5 + 50.65) = 51
 EQUB 50                \ INT(0.5 + 50.34) = 50
 EQUB 50                \ INT(0.5 + 50.03) = 50
 EQUB 50                \ INT(0.5 + 49.69) = 50
 EQUB 49                \ INT(0.5 + 49.34) = 49
 EQUB 49                \ INT(0.5 + 48.97) = 49
 EQUB 48                \ INT(0.5 + 48.58) = 49 (doesn't match)
 EQUB 48                \ INT(0.5 + 48.17) = 48
 EQUB 47                \ INT(0.5 + 47.75) = 48 (doesn't match)
 EQUB 47                \ INT(0.5 + 47.31) = 47
 EQUB 46                \ INT(0.5 + 46.86) = 47 (doesn't match)
 EQUB 46                \ INT(0.5 + 46.39) = 46
 EQUB 45                \ INT(0.5 + 45.90) = 46 (doesn't match)
 EQUB 45                \ INT(0.5 + 45.40) = 45
 EQUB 44                \ INT(0.5 + 44.88) = 45 (doesn't match)
 EQUB 44                \ INT(0.5 + 44.34) = 44
 EQUB 43                \ INT(0.5 + 43.79) = 44 (doesn't match)
 EQUB 42                \ INT(0.5 + 43.22) = 43 (doesn't match)
 EQUB 41                \ INT(0.5 + 42.64) = 43 (doesn't match)
 EQUB 40                \ INT(0.5 + 42.05) = 42 (doesn't match)
 EQUB 39                \ INT(0.5 + 41.44) = 41 (doesn't match)
 EQUB 38                \ INT(0.5 + 40.81) = 41 (doesn't match)

\ ******************************************************************************
\
\       Name: token32
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 32
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token32

 EQUB 160 + 2           \ Print 2 spaces

 EQUB 156               \ Set background colour to black

 EQUB 8, 8              \ Backspace to the left by two characters

 EQUB 200 + 31          \ Print token 31 (two spaces and configurable colours)

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: dashData19
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData19

 SKIP 36                \ Populated with code from &7BCE to &7BF1

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
\       Name: configKeys
\       Type: Variable
\   Category: Keyboard
\    Summary: Details of the configuration settings that are set by the shifted
\             configuration keys
\
\ ------------------------------------------------------------------------------
\
\ The low nibble of each setting indicates which configuration byte should be
\ updated when this key is pressed, as an offset from configStop, and the high
\ nibble contains the value that it should be set to.
\
\ The values in this table correspond with the keys defined in the shiftedKeys
\ table.
\
\ ******************************************************************************

.configKeys

                        \ SHIFT + key   Bits affected     Config byte      Value

 EQUB &80               \ Right arrow   Set bit 7         configStop         &80
 EQUB &01               \ f1            Clear all bits    configJoystick     &00
 EQUB &C1               \ f2            Set bits 6 & 7    configJoystick     &C0
 EQUB &81               \ f2            Set bit 7         configJoystick     &80
 EQUB &C2               \ f4            Set bits 6 & 7    configVolume       &C0
 EQUB &42               \ f5            Set bit 6         configVolume       &40
 EQUB &C0               \ f0            Set bits 6 & 7    configStop         &C0
 EQUB &83               \ COPY          Set bit 7         configPause        &80
 EQUB &43               \ DELETE        Set bit 6         configPause        &40
 EQUB &20               \ f7            Set bit 5         configStop         &20

IF _ACORNSOFT

 EQUB &77, &BB          \ These values are workspace noise and have no meaning

ELIF _SUPERIOR

 EQUB &04               \ f3            Clear all bits    configAssist       &00
 EQUB &84               \ f6            Set bit 7         configAssist       &80

ENDIF

\ ******************************************************************************
\
\       Name: menuKeysSuperior
\       Type: Variable
\   Category: Keyboard
\    Summary: Negative inkey values for the menu keys (SPACE, "1", "2" and "3")
\             for the Superior Software release
\
\ ******************************************************************************

IF _ACORNSOFT

 EQUB &DD, &EE          \ These values are workspace noise and have no meaning
 EQUB &77, &BB

ELIF _SUPERIOR

.menuKeysSuperior

 EQUB &9D               \ Negative inkey value for SPACE
 EQUB &CF               \ Negative inkey value for "1"
 EQUB &CE               \ Negative inkey value for "2"
 EQUB &EE               \ Negative inkey value for "3"

ENDIF

\ ******************************************************************************
\
\       Name: totalPointsHi
\       Type: Variable
\   Category: Drivers
\    Summary: High byte of total accumulated points for each driver
\
\ ------------------------------------------------------------------------------
\
\ Indexed by driver number (0 to 19)
\
\ Gets set in InitialiseDrivers
\
\ Stored as a 24-bit value (totalPointsTop totalPointsHi totalPointsLo)
\
\ ******************************************************************************

.totalPointsHi

 EQUB &DD, &EE          \ These values are workspace noise and have no meaning
 EQUB 0, 0, 0, 0, 0, 0
 EQUB 0, 0, 0, 0, 0, 0
 EQUB 0, 0, 0, 0, 0, 0

\ ******************************************************************************
\
\       Name: racePointsHi
\       Type: Variable
\   Category: Drivers
\    Summary: High byte of race points calculated for each position
\
\ ******************************************************************************

.racePointsHi

 EQUB &77, &BB          \ These values are workspace noise and have no meaning
 EQUB &DD, &EE
 EQUB &77, &BB
 EQUB &DD, &EE

\ ******************************************************************************
\
\       Name: token30
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 30
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token30

 EQUB 31, 5, 24         \ Move text cursor to column 5, row 24

 EQUB 134               \ Set foreground colour to cyan alphanumeric

 EQUB 200 + 17          \ Print token 17 ("PRESS ")

 EQUS "SPACE BAR "      \ Print "SPACE BAR "

 EQUS "TO CONTINUE"     \ Print "TO CONTINUE"

 EQUB 255               \ End token

 EQUB &45, &FF          \ These bytes appear to be unused

\ ******************************************************************************
\
\       Name: token2
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 2
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token2

 EQUS "GRID POSITIONS"  \ Print "GRID POSITIONS"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: dashData20
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData20

 SKIP 36                \ Populated with code from &7BAA to &7BCD

\ ******************************************************************************
\
\       Name: PrintHeaderChecks
\       Type: Subroutine
\   Category: Text
\    Summary: Print chequered lines above and below the header
\
\ ******************************************************************************

.PrintHeaderChecks

 LDY #1                 \ We are about to print two chequered lines, so set a
                        \ line counter in Y

.head1

 LDA endChecks,Y        \ Set T to the screen address offset of the end of the
 STA T                  \ Y-th chequered line

 LDX startChecks,Y      \ Set A to the screen address offset of the start of the
                        \ Y-th chequered line

 LDA #151               \ Poke the "white graphics" character into the X-th byte
 STA row2_column1,X     \ of screen memory at column 1, row 2, so the subsequent
                        \ bytes are shown as graphics characters

 LDA #226               \ Set A to the graphics character with the top-right and
                        \ bottom-right blocks set to white, to form the first
                        \ character of the line (i.e. the first two checks in
                        \ the chequered line)

.head2

 INX                    \ Increment the screen address offset to move along one
                        \ character

 STA row2_column1,X     \ Poke character A into screen memory

 LDA #230               \ Set A to the graphics character with the top-right,
                        \ bottom-right and centre-left blocks set to white, to
                        \ form the rest of the checks on the chequered line

 CPX T                  \ Loop back to print the next character in the line
 BNE head2              \ until we have reached the screen address in T

 DEY                    \ Decrement the line counter

 BPL head1              \ Loop back to print the second line

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: startChecks
\       Type: Variable
\   Category: Text
\    Summary: The screen address offset of the start of each chequered header
\             line
\
\ ******************************************************************************

.startChecks

 EQUB 0                 \ Start the first line at row 2, column 1 (as the offset
                        \ is added to row2_column1)

 EQUB 40 * 3            \ Start the second line on row 5, column 1 (as there are
                        \ 40 characters per row)

\ ******************************************************************************
\
\       Name: endChecks
\       Type: Variable
\   Category: Text
\    Summary: The screen address offset of the end of each chequered header line
\
\ ******************************************************************************

.endChecks

 EQUB 35                \ End the first line after 35 characters

 EQUB 35 + (40 * 3)     \ End the first line after 35 characters

\ ******************************************************************************
\
\       Name: token53
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 53
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token53

 EQUB 160 + 15          \ Print 15 spaces

 EQUS "FINISHED"        \ Print "FINISHED"

 EQUB 160 + 15          \ Print 15 spaces

 EQUB 255               \ End token

 EQUB 0, 0              \ These bytes appear to be unused

\ ******************************************************************************
\
\       Name: token41
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 41
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token41

 EQUB 160 + 6           \ Print 6 spaces

 EQUS "Less than one "  \ Print "Less than one "

 EQUS "minute to go"    \ Print "minute to go"

 EQUB 160 + 6           \ Print 6 spaces

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token38
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 38
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token38

 EQUB 31, 5, 20         \ Move text cursor to column 5, row 20

 EQUB 132, 157          \ Set background colour to blue

 EQUB 134               \ Set foreground colour to cyan alphanumeric

 EQUS "3"               \ Print "3"

 EQUB 160 + 2           \ Print 2 spaces

 EQUB 156               \ Set background colour to black

 EQUB 160 + 5           \ Print 5 spaces

 EQUB 131               \ Set foreground colour to yellow alphanumeric

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3AA9
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3AA9

 EQUB &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData21
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData21

 SKIP 36                \ Populated with code from &7B86 to &7BA9

\ ******************************************************************************
\
\       Name: tokenLo
\       Type: Variable
\   Category: Text
\    Summary: Low byte of the token address lookup table
\  Deep dive: Text tokens
\
\ ------------------------------------------------------------------------------
\
\ Note that token 47 is not used.
\
\ ******************************************************************************

.tokenLo

 EQUB LO(token0)
 EQUB LO(token1)
 EQUB LO(token2)
 EQUB LO(token3)
 EQUB LO(token4)
 EQUB LO(token5)
 EQUB LO(token6)
 EQUB LO(token7)
 EQUB LO(token8)
 EQUB LO(token9)
 EQUB LO(token10)
 EQUB LO(token11)
 EQUB LO(token12)
 EQUB LO(token13)
 EQUB LO(token14)
 EQUB LO(token15)
 EQUB LO(token16)
 EQUB LO(token17)
 EQUB LO(token18)
 EQUB LO(token19)
 EQUB LO(token20)
 EQUB LO(token21)
 EQUB LO(token22)
 EQUB LO(token23)
 EQUB LO(token24)
 EQUB LO(token25)
 EQUB LO(token26)
 EQUB LO(token27)
 EQUB LO(token28)
 EQUB LO(token29)
 EQUB LO(token30)
 EQUB LO(token31)
 EQUB LO(token32)
 EQUB LO(token33)
 EQUB LO(token34)
 EQUB LO(token35)
 EQUB LO(token36)
 EQUB LO(token37)
 EQUB LO(token38)
 EQUB LO(token39)
 EQUB LO(token40)
 EQUB LO(token41)
 EQUB LO(token42)
 EQUB LO(token43)
 EQUB LO(token44)
 EQUB LO(token45)
 EQUB LO(token46)
 EQUB 0
 EQUB LO(token48)
 EQUB LO(token49)
 EQUB LO(token50)
 EQUB LO(token51)
 EQUB LO(token52)
 EQUB LO(token53)

\ ******************************************************************************
\
\       Name: yLookupHi
\       Type: Variable
\   Category: Graphics
\    Summary: Lookup table for converting pixel y-coordinate to high byte of
\             screen address
\
\ ------------------------------------------------------------------------------
\
\ This table returns the high byte of the screen address of the start of the
\ row, for the custom screen mode.
\
\ Note that the custom screen mode starts at address &5A80, so the first two
\ entries in this table do not point to screen memory; the first two character
\ rows in this table are off the top of the custom screen, so the first row
\ on-screen is the third row. This is why, when we print the top two lines of
\ text in the custom screen with the PrintCharacter routine, we do so at the
\ following y-coordinates:
\
\   * yCursor = 24 for the first line of text
\
\   * yCursor = 33 for the second line of text
\
\ To see where these are on-screen, we need to subtract 16 for the first two
\ character rows which are off the top of the screen, to give:
\
\   * y-coordinate = 8 for the first line of text
\
\   * y-coordinate = 17 for the second line of text
\
\ The value passed to PrintCharacter points to the bottom row of the character
\ to print, so the first coordinate points to the ninth pixel row (as the first
\ pixel row is row 0), and the second points to the 18th pixel row. There are
\ eight pixels in each character row, so this prints the first row of text so
\ that it has a one-pixel margin between the top of the text and the top of the
\ screen, and i prints the second row so that it has a one-pixel margin between
\ the top of the text and the bottom of the line above.
\
\ I don't know why this table starts at &5800 and not &5A80, but that's how it
\ is.
\
\ ******************************************************************************

.yLookupHi

FOR I%, 0, 31

 EQUB HI(&5800 + (I% * &140))

NEXT

\ ******************************************************************************
\
\       Name: mirrorAddressLo
\       Type: Variable
\   Category: Dashboard
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.mirrorAddressLo

 EQUB &40, &48, &18
 EQUB &30, &70, &78

\ ******************************************************************************
\
\       Name: dashData22
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData22

 SKIP 36                \ Populated with code from &7B62 to &7B85

\ ******************************************************************************
\
\       Name: tokenHi
\       Type: Variable
\   Category: Text
\    Summary: high byte of the token address lookup table
\  Deep dive: Text tokens
\
\ ------------------------------------------------------------------------------
\
\ Note that token 47 is not used.
\
\ ******************************************************************************

.tokenHi

 EQUB HI(token0)
 EQUB HI(token1)
 EQUB HI(token2)
 EQUB HI(token3)
 EQUB HI(token4)
 EQUB HI(token5)
 EQUB HI(token6)
 EQUB HI(token7)
 EQUB HI(token8)
 EQUB HI(token9)
 EQUB HI(token10)
 EQUB HI(token11)
 EQUB HI(token12)
 EQUB HI(token13)
 EQUB HI(token14)
 EQUB HI(token15)
 EQUB HI(token16)
 EQUB HI(token17)
 EQUB HI(token18)
 EQUB HI(token19)
 EQUB HI(token20)
 EQUB HI(token21)
 EQUB HI(token22)
 EQUB HI(token23)
 EQUB HI(token24)
 EQUB HI(token25)
 EQUB HI(token26)
 EQUB HI(token27)
 EQUB HI(token28)
 EQUB HI(token29)
 EQUB HI(token30)
 EQUB HI(token31)
 EQUB HI(token32)
 EQUB HI(token33)
 EQUB HI(token34)
 EQUB HI(token35)
 EQUB HI(token36)
 EQUB HI(token37)
 EQUB HI(token38)
 EQUB HI(token39)
 EQUB HI(token40)
 EQUB HI(token41)
 EQUB HI(token42)
 EQUB HI(token43)
 EQUB HI(token44)
 EQUB HI(token45)
 EQUB HI(token46)
 EQUB 0
 EQUB HI(token48)
 EQUB HI(token49)
 EQUB HI(token50)
 EQUB HI(token51)
 EQUB HI(token52)
 EQUB HI(token53)

\ ******************************************************************************
\
\       Name: shortAxis
\       Type: Variable
\   Category: Graphics
\    Summary: Code modifications for the DrawDashboardLine line-drawing routine
\
\ ------------------------------------------------------------------------------
\
\ When drawing a line, the short axis is only stepped along when the slope error
\ adds up to a whole pixel, so this steps along the shorter axis of the line's
\ vector. See the DrawDashboardLine routine for details.
\
\ ******************************************************************************

.shortAxis

 INX                    \ V = 0, INX and DEY = Steep slope, right and up
 DEY                    \ V = 1, DEY and INX = Shallow slope, right and up
 INY                    \ V = 2, INY and INX = Shallow slope, right and down
 INX                    \ V = 3, INX and INY = Steep slope, right and down
 DEX                    \ V = 4, DEX and INY = Steep slope, left and down
 INY                    \ V = 5, INY and DEX
 DEY                    \ V = 6, DEY and DEX
 DEX                    \ V = 7, DEX and DEY

\ ******************************************************************************
\
\       Name: stepAxis
\       Type: Variable
\   Category: Graphics
\    Summary: Code modifications for the DrawDashboardLine line-drawing routine
\
\ ------------------------------------------------------------------------------
\
\ When drawing a line, we step along the longer axis of the line's vector by one
\ pixel for loop around the line-drawing routine. See the DrawDashboardLine
\ routine for details.
\
\ ******************************************************************************

.stepAxis

 DEY                    \ V = 0, INX and DEY = Steep slope, right and up
 INX                    \ V = 1, DEY and INX = Shallow slope, right and up
 INX                    \ V = 2, INY and INX = Shallow slope, right and down
 INY                    \ V = 3, INX and INY = Steep slope, right and down
 INY                    \ V = 4, DEX and INY = Steep slope, left and down
 DEX                    \ V = 5, INY and DEX
 DEX                    \ V = 6, DEY and DEX
 DEY                    \ V = 7, DEX and DEY

 EQUB &18, &EA
 EQUB &EA, &18
 EQUB &18, &EA
 EQUB &EA, &18

\ ******************************************************************************
\
\       Name: mirrorAddressHi
\       Type: Variable
\   Category: Dashboard
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.mirrorAddressHi

 EQUB &75, &75, &74
 EQUB &75, &76, &76

\ ******************************************************************************
\
\       Name: L3BA4
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3BA4

 EQUB &12, &11, &10, &0E, &0D, &0C

\ ******************************************************************************
\
\       Name: L3BAA
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3BAA

 EQUB &81, &81

\ ******************************************************************************
\
\       Name: dashData23
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData23

 SKIP 36                \ Populated with code from &7B3E to &7B61

\ ******************************************************************************
\
\       Name: headerX
\       Type: Variable
\   Category: Text
\    Summary: Column number for printing mode 7 headers
\
\ ------------------------------------------------------------------------------
\
\ The values in this table are used by the PrintHeader routine to print out
\ headers in mode 7.
\
\ ******************************************************************************

.headerX

 EQUB 4
 EQUB 7
 EQUB 9
 EQUB 7
 EQUB 0
 EQUB 11
 EQUB 7

\ ******************************************************************************
\
\       Name: headerY
\       Type: Variable
\   Category: Text
\    Summary: Row number for printing mode 7 headers
\
\ ------------------------------------------------------------------------------
\
\ The values in this table are used by the PrintHeader routine to print out
\ headers in mode 7.
\
\ ******************************************************************************

.headerY

 EQUB 3
 EQUB 0
 EQUB 0
 EQUB 0
 EQUB 4
 EQUB 4
 EQUB 0

\ ******************************************************************************
\
\       Name: headerSpaces
\       Type: Variable
\   Category: Text
\    Summary: Number of spaces for printing mode 7 headers
\
\ ------------------------------------------------------------------------------
\
\ The values in this table are used by the PrintHeader routine to print out
\ headers in mode 7.
\
\ ******************************************************************************

.headerSpaces

 EQUB 160 + 10
 EQUB 160 + 15
 EQUB 160 + 19
 EQUB 160 + 15
 EQUB 160 + 2
 EQUB 160 + 24
 EQUB 160 + 15

\ ******************************************************************************
\
\       Name: headerBackground
\       Type: Variable
\   Category: Text
\    Summary: Background colour for printing mode 7 headers
\
\ ------------------------------------------------------------------------------
\
\ The values in this table are used by the PrintHeader routine to print out
\ headers in mode 7.
\
\ ******************************************************************************

.headerBackground

 EQUB 129
 EQUB 129
 EQUB 133
 EQUB 132
 EQUB 163
 EQUB 131
 EQUB 133

\ ******************************************************************************
\
\       Name: headerForeground
\       Type: Variable
\   Category: Text
\    Summary: Foreground colour for printing mode 7 headers
\
\ ------------------------------------------------------------------------------
\
\ The values in this table are used by the PrintHeader routine to print out
\ headers in mode 7.
\
\ ******************************************************************************

.headerForeground

 EQUB 131
 EQUB 131
 EQUB 135
 EQUB 135
 EQUB 127
 EQUB 132
 EQUB 135

\ ******************************************************************************
\
\       Name: token46
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 46
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token46

 EQUB 22, 7             \ Switch to screen mode 7

 EQUB 23, 0, 10, 32     \ Disable cursor
 EQUB 0, 0, 0
 EQUB 0, 0, 0

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token24
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 24
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token24

 EQUB 200 + 35          \ Print token 35 (cyan, move cursor to prompt position)

 EQUB 200 + 10          \ Print token 10 ("SELECT ")

 EQUS "WING SETTINGS"   \ Print "WING SETTINGS"

 EQUB 200 + 16          \ Print token 16 (" > ")

 EQUS "range 0 to 40"   \ Print "range 0 to 40"

 EQUB 31, 14, 16        \ Move text cursor to column 14, row 16

 EQUS "rear"            \ Print "rear"

 EQUB 160 + 2           \ Print 2 spaces

 EQUB 133               \ Set foreground colour to magenta alphanumeric

 EQUB 200 + 16          \ Print token 16 (" > ")

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3C28
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3C28

 EQUB &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData24
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code that gets moved into screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData24

 SKIP 36                \ Populated with code from &7B1A to &7B3D

\ ******************************************************************************
\
\       Name: GetWingSettings
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Get the front and rear wing settings from the player
\
\ ******************************************************************************

.GetWingSettings

 LDX #5                 \ Print "THE  PITS" as a double-height header at column
 JSR PrintHeader        \ 11, row 4, in blue text on a yellow background

 LDX #24                \ Print token 24, which shows the prompt "SELECT WING
 JSR PrintToken         \ SETTINGS > range 0 to 40" and a further prompt of
                        \ "rear > "

 JSR GetNumberInput     \ Fetch a number from the keyboard

 STA rearWingSetting    \ Store the entered number in rearWingSetting

 LDX #25                \ Print token 25, which shows a prompt of "front > "
 JSR PrintToken

 JSR GetNumberInput     \ Fetch a number from the keyboard

 STA frontWingSetting   \ Store the entered number in frontWingSetting

 JSR WaitForSpace       \ Print a prompt and wait for SPACE to be pressed

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: PrintRaceClass
\       Type: Subroutine
\   Category: Text
\    Summary: Print the race class
\
\ ******************************************************************************

.PrintRaceClass

 LDA raceClass          \ Set A to the race class + 7, so that gives us:
 CLC                    \
 ADC #7                 \   * 7 for Novice
 TAX                    \   * 8 for Amateur
                        \   * 9 for Professional

 JSR PrintToken         \ Print token X, which will be token 7 ("Novice"), token
                        \ 8 ("Amateur") or token 9 ("Professional")

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: token50
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 50
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token50

 EQUB 31, 24, 2         \ Move text cursor to column 24, row 2

 EQUB 200 + 18          \ Print token (configurable token number, default is 18,
                        \ which is " 5")

 EQUB 200 + 14          \ Print token 14 (" laps")

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token6
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 6
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token6

 EQUB 160 + 2           \ Print 2 spaces

 EQUS "BEST LAP TIMES"  \ Print "BEST LAP TIMES"

 EQUB 160 + 2           \ Print 2 spaces

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token13
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 13
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token13

 EQUS " mins"           \ Print " mins"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token14
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 14
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token14

 EQUS " laps"           \ Print " laps"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token15
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 15
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token15

 EQUS " RACE"           \ Print " RACE"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3CA3
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3CA3

 EQUS "ins"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3CA7
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3CA7

 EQUB &81, &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData25
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains code and part of the dashboard image that gets moved into
\             screen memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData25

 SKIP 10                \ Populated with part of the dashboard image

 SKIP 26                \ Populated with code from &7B00 to &7B19

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
\       Name: GetDriverAddress
\       Type: Subroutine
\   Category: Text
\    Summary: Get the address of the specified driver's name
\
\ ------------------------------------------------------------------------------
\
\ This routine calculates the address of driver A's name using the following:
\
\   (Y A) = driverNames1 + (A div 4) * &100 + (A mod 4) * 12
\
\ The names of the 20 drivers are stored in in five blocks within the main game
\ code. Each block of contains four names, each of which is 12 characters long.
\ The blocks start every &100 (256) bytes, starting with the first block at
\ driverNames1 and going through to driverNames5.
\
\ Given driver number A, A div 4 is the block number, while A mod 4 is the
\ number of the 12-character name within that block. So we have:
\
\   * (A div 4) * &100 is the address of the start of the block containing the
\     name of driver A
\
\   * (A mod 4) * 12 is the offset of driver A's 12-character name within that
\     block
\
\ The first block is at driverNames1, so we add them together to arrive at the
\ calculation above.
\
\ Arguments:
\
\   X                   The driver number (0 to 19)
\
\ Returns:
\
\   (Y A)               The address of the driver's 12-character name
\
\ ******************************************************************************

.GetDriverAddress

 TXA                    \ We start with the high byte of the calculation, which
 LSR A                  \ is Y = HI(driverNames1) + (A div 4)
 LSR A
 CLC
 ADC #HI(driverNames1)
 TAY

                        \ And now we do the low byte calculation, which is
                        \ A = LO(driverNames1) + (A mod 4) * 12

 TXA                    \ Set A = (A mod 4) * 4
 AND #3
 ASL A
 ASL A

 STA T                  \ Set T = A
                        \       = (A mod 4) * 4

 ASL A                  \ Set A = (A mod 4) * 8

 CLC                    \ Set A = A + T
 ADC T                  \       = (A mod 4) * 8 + (A mod 4) * 4
                        \       = (A mod 4) * 12

 ADC #LO(driverNames1)  \ Set A = LO(driverNames1) + A
                        \       = LO(driverNames1) + (A mod 4) * 12

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: token27
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 27
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token27

 EQUB 200 + 54          \ Print token 54 ("FORMULA 3  CHAMPIONSHIP" header)

 EQUB 200 + 36          \ Print token 36 (menu option 1 with "PRESS" prompt)

 EQUB 200 + 11          \ Print token 11 ("ENTER ")

 EQUS "ANOTHER"         \ Print "ANOTHER"

 EQUB 200 + 12          \ Print token 12 (" DRIVER")

 EQUB 200 + 37          \ Print token 37 (menu option 2)

 EQUS "START"           \ Print "START"

 EQUB 200 + 15          \ Print token 15 (" RACE")

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token34
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 34
\
\ ------------------------------------------------------------------------------
\
\ The configurable values below are set in the PrintHeader routine.
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token34

 EQUB 141               \ Set double-height text

 EQUB 129, 157          \ Set background colour (configurable, default is red)

 EQUB 131               \ Set foreground colour (configurable, default is yellow
                        \ alphanumeric)

 EQUB 200+0             \ Print token (configurable token number, default is 0,
                        \ which is "FORMULA 3  CHAMPIONSHIP")

 EQUB 160+2             \ Print spaces (configurable, default is 2 spaces)

 EQUB 156               \ Set background colour to black

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3D1B
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3D1B

 EQUB &81, &81, &81, &81, &81, &81, &81, &81
 EQUB &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData26
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData26

 SKIP 41

\ ******************************************************************************
\
\       Name: PrintSpaces
\       Type: Subroutine
\   Category: Text
\    Summary: Print the specified number of spaces
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of spaces to print (1 to 39)
\
\ Returns:
\
\   Z flag              Set (so a BEQ following the routine call will always
\                       branch)
\
\ ******************************************************************************

.PrintSpaces

 STA T                  \ Set T to the number of spaces to print to use as a
                        \ loop counter

.spac1

 LDA #' '               \ Print a space
 JSR PrintCharacter

 DEC T                  \ Decrement the loop counter

 BNE spac1              \ Loop back until we have printed the right number of
                        \ spaces

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: sub_C3D5C
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   sub_C3D5C-1         Contains an RTS
\
\ ******************************************************************************

.sub_C3D5C

 LDA #0
 STA carMoving
 STA T
 STA P
 LDA #&30
 STA Q

\ ******************************************************************************
\
\       Name: sub_C3D68
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.C3D68

 LDX T
 CPX #&28
 BEQ sub_C3D5C-1
 LDA dashDataOffset,X
 STA U
 LDY #&46
 JMP sub_C31D0

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

 EQUB &0A, &07, &0A, &0D

\ ******************************************************************************
\
\       Name: token21
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 21
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token21

 EQUB 200 + 54          \ Print token 54 ("FORMULA 3  CHAMPIONSHIP" header)

 EQUB 200 + 36          \ Print token 36 (menu option 1 with "PRESS" prompt)

 EQUB 200 + 7           \ Print token 7 ("Novice")

 EQUB 200 + 37          \ Print token 37 (menu option 2)

 EQUB 200 + 8           \ Print token 8 ("Amateur")

 EQUB 200 + 38          \ Print token 38 (menu option 3)

 EQUB 200 + 9           \ Print token 9 ("Professional")

 EQUB 200 + 35          \ Print token 35 (cyan, move cursor to prompt position)

 EQUB 160 + 4           \ Print 4 spaces

 EQUB 200 + 10          \ Print token 10 ("SELECT ")

 EQUS "THE CLASS OF"    \ Print "THE CLASS OF"

 EQUB 200 + 15          \ Print token 15 (" RACE")

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3D98
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3D98

 EQUB &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData27
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData27

 SKIP 52

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
\       Name: shiftedKeys
\       Type: Variable
\   Category: Keyboard
\    Summary: Negative inkey values for the configuration keys that are pressed
\             in combination with SHIFT
\
\ ******************************************************************************

.shiftedKeys

 EQUB &86               \ Right arrow
 EQUB &8E               \ f1
 EQUB &8D               \ f2
 EQUB &8D               \ f2
 EQUB &EB               \ f4
 EQUB &8B               \ f5
 EQUB &DF               \ f0
 EQUB &96               \ COPY
 EQUB &A6               \ DELETE
 EQUB &E9               \ f7

IF _SUPERIOR

 EQUB &8C               \ f3
 EQUB &8A               \ f6

ENDIF

\ ******************************************************************************
\
\       Name: menuKeys
\       Type: Variable
\   Category: Keyboard
\    Summary: Negative inkey values for the menu keys (SPACE, "1", "2" and "3")
\             for the Acornsoft release
\
\ ******************************************************************************

IF _ACORNSOFT

.menuKeys

 EQUB &9D               \ Negative inkey value for SPACE
 EQUB &CF               \ Negative inkey value for "1"
 EQUB &CE               \ Negative inkey value for "2"
 EQUB &EE               \ Negative inkey value for "3"

ELIF _SUPERIOR

 EQUB &CE, &EE          \ These bytes appear to be unused

ENDIF

\ ******************************************************************************
\
\       Name: timeFromOption
\       Type: Variable
\   Category: Drivers
\    Summary: Table to convert from the option numbers in the qualifying lap
\             duration menu to the actual number of minutes
\
\ ------------------------------------------------------------------------------
\
\ Interestingly, the menu offers 5, 10 and 20 minutes, but these translate into
\ 5, 10 and 26 minutes of actual qualifying time.
\
\ ******************************************************************************

.timeFromOption

 EQUB 4, 9, 25

 EQUB 0                 \ This byte appears to be unused

\ ******************************************************************************
\
\       Name: lapsFromOption
\       Type: Variable
\   Category: Drivers
\    Summary: Table to convert from the option numbers in the laps menu to the
\             actual number of laps
\
\ ******************************************************************************

.lapsFromOption

 EQUB 5, 10, 20

\ ******************************************************************************
\
\       Name: pointsForPlace
\       Type: Variable
\   Category: Drivers
\    Summary: The points awarded for the top six places, plus the fastest lap
\
\ ******************************************************************************

.pointsForPlace

 EQUB 9                 \ Points for first place
 EQUB 6                 \ Points for second place
 EQUB 4                 \ Points for third place
 EQUB 3                 \ Points for fourth place
 EQUB 2                 \ Points for fifth place
 EQUB 1                 \ Points for sixth place

 EQUB 1                 \ Points for the fastest lap

 EQUB 0, 0              \ These bytes appear to be unused

\ ******************************************************************************
\
\       Name: token29
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 29
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token29

 EQUB 200 + 54          \ Print token 54 ("FORMULA 3  CHAMPIONSHIP" header)

 EQUB 200 + 35          \ Print token 35 (cyan, move cursor to prompt position)

 EQUB 160 + 5           \ Print 5 spaces

 EQUB 130               \ Set foreground colour to green alphanumeric

 EQUB 200 + 12          \ Print token 12 (" DRIVER")

 EQUB 200 + 16          \ Print token 16 (" > ")

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token9
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 9
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token9

 EQUS "Professional"    \ Print "Professional"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3E14
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3E14

 EQUB &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData28
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData28

 SKIP 56

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
\       Name: SetRowColours
\       Type: Subroutine
\   Category: Text
\    Summary: Set the foreground and background colorus for a table row
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   Table row number
\
\   colourScheme        Colour scheme: 0, 4, 8
\
\ ******************************************************************************

.SetRowColours

 TYA                    \ Set X = colourScheme      if Y is even
 AND #1                 \       = colourScheme + 1  if Y is odd
 CLC                    \
 ADC colourScheme       \ So X is now one of the following, depending on the
 TAX                    \ colour scheme and whether the row number is even or
                        \ odd:
                        \
                        \   * Scheme 0: 0 (even) or 1 (odd)
                        \   * Scheme 4: 4 (even) or 5 (odd)
                        \   * Scheme 8: 8 (even) or 9 (odd)
                        \
                        \ We now fetch the colour palette from the rowColours
                        \ table using the following offsets:
                        \
                        \   * Scheme 0: 0 on 2  (even) or 1 on 3  (odd)
                        \   * Scheme 4: 4 on 6  (even) or 5 on 7  (odd)
                        \   * Scheme 8: 8 on 10 (even) or 9 on 11 (odd)

 LDA rowColours,X       \ Set the configurable foreground colour in token 31 to
 STA token31+5          \ the X-th entry in the rowColours table

 LDA rowColours+2,X     \ Set the configurable background colour in token 31 to
 STA token31+3          \ the X+2-th entry in the rowColours table

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: rowColours
\       Type: Variable
\   Category: Text
\    Summary: Three different palettes for displaying even-odd rows in tables
\
\ ******************************************************************************

.rowColours

 EQUB 132, 133          \ Scheme 0: Even rows: 132 on 134 (blue on cyan)
 EQUB 134, 135          \           Odd rows:  134 on 135 (cyan on white)

 EQUB 129, 132          \ Scheme 4: Even rows: 129 on 132 (red on blue)
 EQUB 131, 130          \           Odd rows:  131 on 130 (yellow on green)

 EQUB 131, 132          \ Scheme 8: Even rows: 131 on 132 (yellow on blue)
 EQUB 129, 135          \           Odd rows:  129 on 135 (red on white)

\ ******************************************************************************
\
\       Name: token10
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 10
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token10

 EQUS "SELECT "         \ Print "SELECT "

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token12
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 12
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token12

 EQUS " DRIVER"         \ Print " DRIVER"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3E90
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3E90

 EQUB &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData29
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData29

 SKIP 60

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
\       Name: GetNumberInput
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Fetch a number between 0 and 40 from the keyboard
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The value of the number entered (0 to 40)
\
\ ******************************************************************************

.GetNumberInput

 LDA #LO(T)             \ Set (Y A) = T
 LDY #HI(T)

 LDX #2                 \ Fetch a string of up to two characters from the
 JSR GetTextInput       \ keyboard, store the characters at location T and U (as
                        \ U = T + 1), and set Y to the number of characters
                        \ entered

 JSR GetNumberFromText  \ Convert the two-character input into a number in A,
                        \ and report the conversion status in the C flag

 BCC numb2              \ If we got a valid number that is 40 or less then the C
                        \ flag will be clear, so jump to numb2 to return from
                        \ the subroutine

.numb1

 DEY                    \ Decrement the number of characters in the entered
                        \ string, which is in Y

 BMI GetNumberInput     \ If Y is now negative, then there are no characters
                        \ left on-screen, so jump back to the start of the
                        \ routine to try fetching another number

 LDA #127               \ Otherwise delete the last character shown on-screen by
 JSR OSWRCH             \ printing a delete character (ASCII 127)

 JMP numb1              \ Jump back to numb1 to delete any other on-screen
                        \ characters before starting again

.numb2

 RTS                    \ Return from the subroutine

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

.L3EFA

 EQUB &AA, &AC, &B0, &B0, &AC, &AA

\ ******************************************************************************
\
\       Name: token37
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 37
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token37
 
 EQUB 31, 5, 18         \ Move text cursor to column 5, row 18

 EQUB 132, 157          \ Set background colour to blue

 EQUB 134               \ Set foreground colour to cyan alphanumeric

 EQUS "2"               \ Print "2"

 EQUB 160 + 2           \ Print 2 spaces

 EQUB 156               \ Set background colour to black

 EQUB 160 + 5           \ Print 5 spaces

 EQUB 131               \ Set foreground colour to yellow alphanumeric

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3F0C
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3F0C

 EQUB &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData30
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData30

 SKIP 63

\ ******************************************************************************
\
\       Name: L3F4F
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ This gets copied to screen memory along with dashData30.
\
\ ******************************************************************************

.L3F4F

 SKIP 1

\ ******************************************************************************
\
\       Name: L3F50
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3F50

 EQUB &1B, &1B, &1B, &15, &03, &02, &02, &02, &06, &0B, &0F
 EQUB &13, &17, &1B, &26, &2B, &2B, &2B, &2B, &2B, &2B, &2B, &2B
 EQUS &2B, &2B, &2B, &26
 EQUB &1B, &17, &13, &0F, &0B, &06, &02, &02, &02, &03, &15, &1B
 EQUB &1B, &1B, &20, &20, &20, &42, &65, &68, &69

\ ******************************************************************************
\
\       Name: token7
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 7
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token7

 EQUS "Novice"          \ Print "Novice"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L3F87
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3F87

 EQUB &81, &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData31
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData31

 SKIP 68

\ ******************************************************************************
\
\       Name: L3FD0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L3FD0

 EQUB &88, &EA, &EA, &C8, &EA, &88, &C8, &EA, &C8, &EA
 EQUB &EA, &88, &EA, &C8, &88, &EA

\ ******************************************************************************
\
\       Name: yLookupLo
\       Type: Variable
\   Category: Graphics
\    Summary: Lookup table for converting pixel y-coordinate to low byte of
\             screen address
\
\ ------------------------------------------------------------------------------
\
\ For character rows 0 to 7 and 16 to 31, this table returns the low byte of
\ the screen address of the start of the row, for the custom screen mode.
\
\ For character rows 8 to 15, the table is reused, as these locations would
\ point to the blue sky, and we don't draw in the sky as it contains working
\ game code. Instead, the lookup table at yLookupLo+8 contains bitmasks for use
\ in the line-drawing routine at DrawDashboardLine.
\
\ ******************************************************************************

.yLookupLo

FOR I%, 0, 7

 EQUB LO(&5800 + (I% * &140))

NEXT

 EQUB %01110111         \ Clear the first pixel of a mode 5 pixel byte
 EQUB %10111011         \ Clear the second pixel of a mode 5 pixel byte
 EQUB %11011101         \ Clear the third pixel of a mode 5 pixel byte
 EQUB %11101110         \ Clear the fourth pixel of a mode 5 pixel byte

 EQUB %01110111         \ Clear the first pixel of a mode 5 pixel byte
 EQUB %10111011         \ Clear the second pixel of a mode 5 pixel byte
 EQUB %11011101         \ Clear the third pixel of a mode 5 pixel byte
 EQUB %11101110         \ Clear the fourth pixel of a mode 5 pixel byte

FOR I%, 16, 31

 EQUB LO(&5800 + (I% * &140))

NEXT

\ ******************************************************************************
\
\       Name: L4000
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4000

 EQUB &81, &81, &81, &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData32
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData32

 SKIP 73

\ ******************************************************************************
\
\       Name: driverNames1
\       Type: Variable
\   Category: Text
\    Summary: The first batch of driver names (1 of 5)
\
\ ******************************************************************************

.driverNames1

 EQUS "Max Throttle"
 EQUS "Johnny Turbo"
 EQUS "Davey Rocket"
 EQUS "Gloria Slap "

\ ******************************************************************************
\
\       Name: L4080
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4080

 EQUB &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData33
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData33

 SKIP 77

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
 EQUB &23, &18, &0D, &02

\ ******************************************************************************
\
\       Name: token33
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 33
\
\ ------------------------------------------------------------------------------
\
\ The configurable values below are set in the PrintHeader routine.
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token33

 EQUB 12                \ Clear text area (clear screen)

 EQUB 31, 4, 3          \ Move text cursor (configurable, default is column 4,
                        \ row 3)

 EQUB 200 + 34          \ Print token 34 (double-height, text and colours are
                        \ configurable)

 EQUB 160 + 10          \ Print spaces (configurable, default is 10 spaces)

 EQUB 200 + 34          \ Print token 34 (double-height, text and colours are
                        \ configurable)

 EQUB 31, 36, 2         \ Move text cursor to column 36, row 2

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: ResetLapTime
\       Type: Subroutine
\   Category: Drivers
\    Summary: Reset the current lap time to 10:00.0 for a specific driver
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The driver number (0 to 19)
\
\ ******************************************************************************

.ResetLapTime

 LDA #0                 \ Zero the driverTenths entry for driver X
 STA driverTenths,X

 STA driverSeconds,X    \ Zero the driverSeconds entry for driver X

 LDA #&10               \ Set the driverMinutes for driver X to 10 (as is it a
 STA driverMinutes,X    \ BCD number)

 RTS                    \ Return from the subroutine

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

.L40F9

 EQUB &77

\ ******************************************************************************
\
\       Name: L40FA
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L40FA

 EQUB &C2, &C0, &BC, &BC, &C0, &C2

\ ******************************************************************************
\
\       Name: L4100
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4100

 EQUB &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData34
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData34

 SKIP 77

\ ******************************************************************************
\
\       Name: driverNames2
\       Type: Variable
\   Category: Text
\    Summary: The second batch of driver names (2 of 5)
\
\ ******************************************************************************

.driverNames2

 EQUS "Hugh Jengine"
 EQUS "Desmond Dash"
 EQUS "Percy Veer  "
 EQUS "Gary Clipper"

\ ******************************************************************************
\
\       Name: L4180
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4180

 EQUB &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData35
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData35

 SKIP 76

\ ******************************************************************************
\
\       Name: PrintHeader
\       Type: Subroutine
\   Category: Text
\    Summary: Configure and print a double-height header in screen mode 7
\  Deep dive: Text tokens
\
\ ------------------------------------------------------------------------------
\
\ Prints a token as a double-height header, with the position and colours given
\ in the header tables, and a specific number of spaces between the top and
\ bottom parts of the double-height text (to ensure they line up).
\
\ The tokens are formatted as follows:
\
\   * Token 0 ("FORMULA 3  CHAMPIONSHIP")
\     Column 4, row 3
\     Yellow on red
\     10 spaces
\
\   * Token 1 ("      POINTS      ")
\     Column 7, row 0
\     Yellow on red
\     15 spaces
\
\   * Token 2 ("GRID POSITIONS")
\     Column 9, row 0
\     White on magenta
\     19 spaces
\
\   * Token 3 ("ACCUMULATED POINTS")
\     Column 7, row 0
\     White on blue
\     15 spaces
\
\   * Token 4 ("REVS   REVS   REVS")
\     Column 0, row 4
\     The colours of each letter in REVS are magenta/yellow/cyan/green
\     2 spaces
\
\     This token actually prints characters 141, 163, 157, 127 before printing
\     token 4 (which it does twice, one for each part of the header). 127 is
\     the DEL character, so this is the same as printing just 141 and 163,
\     which sets double-height, and then shows graphics character 163. This
\     latter character will blank as we are still in alphanumeric text mode...
\     so overall this just displays a double-height token 4, as token 4 contains
\     all the colour information for the individual letters
\
\   * Token 5 ("THE  PITS")
\     Column 11, row 4
\     Blue on yellow
\     24 spaces
\
\   * Token 6 ("  BEST LAP TIMES  ")
\     Column 7, row 0
\     White on magenta
\     15 spaces
\
\ Arguments:
\
\   X                   The number of the token to print as a double-height
\                       header
\
\ ******************************************************************************

.PrintHeader

 LDA headerX,X          \ Set the x-coordinate for the text in token 33
 STA token33+2

 LDA headerY,X          \ Set the y-coordinate for the text in token 33
 STA token33+3

 LDA headerSpaces,X     \ Set the number of spaces in token 33
 STA token33+5

 LDA headerBackground,X \ Set the background colour in token 34
 STA token34+1

 LDA headerForeground,X \ Set the foreground colour in token 34
 STA token34+3

 TXA                    \ Set the token embedded in token 34 to token X
 CLC
 ADC #200
 STA token34+4

 LDX #33                \ Print token 33, which prints token 34 in double-height
 JSR PrintToken         \ text with the colours and position configured above

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

 EQUB &79, &7B, &7C, &7D, &7E

\ ******************************************************************************
\
\       Name: token1
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 1
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token1

 EQUB 160 + 5           \ Print 5 spaces

 EQUB 200 + 51          \ Print token 51 (" POINTS")

 EQUB 160 + 6           \ Print 6 spaces

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L4204
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4204

 EQUB &81, &81, &81
 EQUB &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81, &81
 EQUB &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData36
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData36

 SKIP 58

\ ******************************************************************************
\
\       Name: driverNames3
\       Type: Variable
\   Category: Text
\    Summary: The third batch of driver names (3 of 5)
\
\ ******************************************************************************

.driverNames3

 EQUS "Willy Swerve"
 EQUS "Sid Spoiler "
 EQUS "Billy Bumper"
 EQUS "Slim Chance "

\ ******************************************************************************
\
\       Name: token40
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 40
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token40

 EQUS "Lap Time"        \ Print "Lap Time"

 EQUB 160 + 3           \ Print 3 spaces

 EQUS ":"               \ Print ":"

 EQUB 160 + 9           \ Print 9 spaces

 EQUS "Best Time"       \ Print "Best Time"

 EQUB 160 + 8           \ Print 8 spaces

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: L4296
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L4296

 EQUB &81, &81, &81, &81, &81, &81

\ ******************************************************************************
\
\       Name: dashData37
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData37

 SKIP 36

\ ******************************************************************************
\
\       Name: L42C0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ This gets copied to screen memory along with dashData37.
\
\ ******************************************************************************

.L42C0

 SKIP 2

\ ******************************************************************************
\
\       Name: L42C2
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ This gets copied to screen memory along with dashData37.
\
\ ******************************************************************************

.L42C2

 SKIP 14

\ ******************************************************************************
\
\       Name: PrintGearNumber
\       Type: Subroutine
\   Category: Text
\    Summary: Print the number of the current gear in double-width characters on
\             the gear stick
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The gear number to print on the stick:
\
\                         * 0 = reverse
\
\                         * 1 = neutral
\
\                         * 2-7 = 1 to 5
\
\ ******************************************************************************

.PrintGearNumber

 LDA #34                \ Move the cursor to character column 34
 STA xCursor

 STA W                  \ Set W to a non-zero value with bit 7 clear, so the
                        \ call to PrintCharacter-6 prints the left half of the
                        \ double-width character

 LDA #215               \ Move the cursor to pixel row 215
 STA yCursor

 LDX gearNumber         \ Set X to the current gear number

 LDA gearNumberText,X   \ Set A to the character to print for this gear number

 JSR PrintCharacter-6   \ Print the left half of the double-width character

 LDX #&FF               \ Set W to a non-zero value with bit 7 set, so the
 STX W                  \ call to PrintCharacter-6 prints the right half of the
                        \ double-width character

 JSR PrintCharacter-6   \ Print the right half of the double-width character

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: ResetLapTimes
\       Type: Subroutine
\   Category: Drivers
\    Summary: Reset the current lap times for all drivers
\
\ ******************************************************************************

.ResetLapTimes

 LDX #19                \ We are about to reset the current lap times for
                        \ all 20 drivers, so set a driver counter in X

.rall1

 JSR ResetLapTime       \ Reset the current lap time for driver X

 DEX                    \ Decrement the driver counter

 BPL rall1              \ Loop back to reset the next set of bytes until we have
                        \ reset all 20 drivers

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: token52
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 52
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token52

 EQUB 133               \ Set foreground colour to magenta alphanumeric

 EQUS "R"               \ Print "R"

 EQUB 131               \ Set foreground colour to yellow alphanumeric

 EQUS "E"               \ Print "E"

 EQUB 134               \ Set foreground colour to cyan alphanumeric

 EQUS "V"               \ Print "V"

 EQUB 130               \ Set foreground colour to green alphanumeric

 EQUS "S"               \ Print "S"

 EQUB 255               \ End token

 EQUB &75, &75          \ These bytes appear to be unused

\ ******************************************************************************
\
\       Name: token28
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 28
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token28

 EQUB 200 + 54          \ Print token 54 ("FORMULA 3  CHAMPIONSHIP" header)

 EQUB 200 + 35          \ Print token 35 (cyan, move cursor to prompt position)

 EQUB 160 + 6           \ Print 6 spaces

 EQUB 200 + 10          \ Print token 10 ("SELECT ")

 EQUS "NUMBER OF LAPS"  \ Print "NUMBER OF LAPS"
 
 EQUB 200 + 36          \ Print token 36 (menu option 1 with "PRESS" prompt)

 EQUB 200 + 18          \ Print token 18 (" 5")

 EQUB 200 + 14          \ Print token 14 (" laps")

 EQUB 200 + 37          \ Print token 37 (menu option 2)

 EQUB 200 + 19          \ Print token 19 ("10")

 EQUB 200 + 14          \ Print token 14 (" laps")

 EQUB 200 + 38          \ Print token 38 (menu option 3)

 EQUB 200 + 20          \ Print token 20 ("20")

 EQUB 200 + 14          \ Print token 14 (" laps")

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: dashData38
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData38

 SKIP 52

\ ******************************************************************************
\
\       Name: driverNames4
\       Type: Variable
\   Category: Text
\    Summary: The fourth batch of driver names (4 of 5)
\
\ ******************************************************************************

.driverNames4

 EQUS "Harry Fume  "
 EQUS "Dan Dipstick"
 EQUS "Wilma Cargo "
 EQUS "Miles Behind"

\ ******************************************************************************
\
\       Name: token5
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 5
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token5

 EQUS "THE  PITS"       \ Print "THE  PITS"

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: token36
\       Type: Variable
\   Category: Text
\    Summary: Text for recursive token 36
\  Deep dive: Text tokens
\
\ ******************************************************************************

.token36

 EQUB 31, 4, 14         \ Move text cursor to column 4, row 14

 EQUB 136               \ Set flashing text

 EQUB 134               \ Set foreground colour to cyan alphanumeric

 EQUB 200 + 17          \ Print token 17 ("PRESS ")

 EQUB 31, 5, 16         \ Move text cursor to column 5, row 16

 EQUB 132, 157          \ Set background colour to blue

 EQUB 134               \ Set foreground colour to cyan alphanumeric

 EQUS "1"               \ Print "1"

 EQUB 160 + 2           \ Print 2 spaces

 EQUB 156               \ Set background colour to black

 EQUB 160 + 5           \ Print 5 spaces

 EQUB 131               \ Set foreground colour to yellow alphanumeric

 EQUB 255               \ End token

\ ******************************************************************************
\
\       Name: dashData39
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData39

 SKIP 52

\ ******************************************************************************
\
\       Name: Print234DigitBCD
\       Type: Subroutine
\   Category: Text
\    Summary: Print a specific driver's accumulated points as a padded two-,
\             three- or four-digit number
\
\ ------------------------------------------------------------------------------
\
\ Print (totalPointsHi totalPointsLo) for driver X as a four-digit number,
\ followed by a space. The first two digits are printed as spaces if the high
\ byte is zero, and the third digit is printed as a space if applicable.
\
\ ******************************************************************************

.Print234DigitBCD

 LDA #2                 \ Print two spaces
 JSR PrintSpaces
 
 LDA #%00100000         \ Set G = %00100000, so if we print the high byte and
 STA G                  \ the first digit is 0, it will be replaced by a space

 LDA totalPointsHi,X    \ Set A to the X-th totalPointsHi value

 BNE Print4DigitBCD     \ If A is non-zero, jump to Print4DigitBCD to print the
                        \ (totalPointsHi totalPointsLo) for driver X as a
                        \ four-digit number

 LDA #2                 \ Otherwise print two spaces for the first two digits,
 JSR PrintSpaces        \ as the high byte is zero

 LSR G                  \ Shift G right one place to give to %00010000, so the
                        \ next call to Print2DigitBCD will print a space for the
                        \ first digit if it is zero

 BNE Print4DigitBCD+3   \ Jump to Print4DigitBCD+3 to print the second two
                        \ digits in totalPointsLo (this BNE is effectively a JMP
                        \ as the result of the LSR is never zero)

\ ******************************************************************************
\
\       Name: Print4DigitBCD
\       Type: Subroutine
\   Category: Text
\    Summary: Print a specific driver's accumulated points as a four-digit
\             number
\
\ ------------------------------------------------------------------------------
\
\ Print (totalPointsHi totalPointsLo) for driver X as a 4-digit number, followed
\ by a space. The second digit is always printed.
\
\ Arguments:
\
\   A                   Always called with totalPointsHi,X
\
\ Other entry points:
\
\   Print4DigitBCD+3    Do not print the first two digits (i.e. omit printing A)
\
\ ******************************************************************************

.Print4DigitBCD

 JSR Print2DigitBCD     \ Print the binary coded decimal (BCD) number in A

 LDA totalPointsLo,X    \ Print the low byte of the total accumulated points for
 JSR Print2DigitBCD     \ driver X, which is a binary coded decimal (BCD) number

 LDA #1                 \ Print a space
 JSR PrintSpaces

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: FlushSoundBuffers
\       Type: Subroutine
\   Category: Sound
\    Summary: Flush all four specified sound buffers
\
\ ******************************************************************************

.FlushSoundBuffers

 LDX #3                 \ We are about to flush all four sound channel buffers
                        \ (0 to 3), so set a loop counter in X

.P43F8

 JSR FlushSoundBuffer   \ Flush the buffer for sound channel X

 DEX                    \ Decrement the loop counter

 BPL P43F8              \ Loop back until we have flushed all four buffers

 RTS                    \ Return from the subroutine

 EQUB 0                 \ This byte appears to be unused

\ ******************************************************************************
\
\       Name: firstPixelTrack
\       Type: Variable
\   Category: Graphics
\    Summary: Storage for the first track pixel byte along the right edge of the
\             dashboard
\
\ ------------------------------------------------------------------------------
\
\ This table is used to store the track pixel byte that would be shown along
\ the right edge of the dashboard, but which is partially obscured by the edge.
\ This is stored so we can retrieve it when masking the pixel byte with the
\ dashboard edge when we draw the track line that starts at the right edge of
\ the dashboard.
\
\ There is a byte for each track line from 43 (the track line at the top of the
\ dashboard) down to 3 (the lowest track line, just above where the wing mirror
\ joins the car body). Lines 0 to 2 are not used.
\
\ ******************************************************************************

.firstPixelTrack

 EQUB &81, &81
 EQUB &81, &81
 EQUB &81, &81
 EQUB &81, &81
 EQUB &81, &81
 EQUB &81, &81
 EQUB &81, &81
 EQUB &81, &81
 EQUB &81, &81
 EQUB &81, &81
 EQUB &81, &81
 EQUB &81, &81
 EQUB &81, &81
 EQUB &81, &81

\ ******************************************************************************
\
\       Name: dashData40
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData40

 SKIP 52

\ ******************************************************************************
\
\       Name: driverNames5
\       Type: Variable
\   Category: Text
\    Summary: The fifth batch of driver names (5 of 5)
\
\ ------------------------------------------------------------------------------
\
\ The last driver name in this batch is used to store the player's name.
\
\ ******************************************************************************

.driverNames5

 EQUS "Roland Slide"
 EQUS "Rick Shaw   "
 EQUS "Peter Out   "
 EQUS "Dummy Driver"

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
\       Name: Set5FB0
\       Type: Subroutine
\   Category: Track
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The class of race:
\                       
\                         * 0 = Novice
\                       
\                         * 1 = Amateur
\                       
\                         * 2 = Professional
\
\ Returns:
\
\   X                   X is unchanged
\
\ ******************************************************************************

.Set5FB0

 LDA trackData+&714,X   \ Set baseSpeed = the X-th byte of trackData+&714
 STA baseSpeed          \
                        \ so baseSpeed contains the base speed for cars at the
                        \ chosen class or race, on this track
                        \
                        \ For Silverstone, this is:
                        \
                        \   * 134 for Novice
                        \   * 146 for Amateur
                        \   * 152 for Professional

 STA U                  \ Set U = baseSpeed

 LDA trackData+&6FA     \ Set Y = trackData+&6FA >> 3
 LSR A                  \       = &C0 >> 3
 LSR A                  \       = &18
 LSR A                  \       = 24
 TAY

                        \ Now we copy the 24 bytes between trackData+&6D0 and
                        \ trackData+&6FC to L5FB0, processing each byte as we go
                        \ (i.e. taking the input and storing the result):
                        \
                        \   * Bit 7 of the result = bit 0 of the input
                        \
                        \   * Bit 6 of the result = 0
                        \
                        \   * Bits 0-5 of the result are:
                        \
                        \     * A >> 2 * U / 256 if bit 1 of the input is clear
                        \     * A >> 2           if bit 1 of the input is set

.P44D5

 LDA trackData+&6D0,Y   \ Fetch the Y-th byte from trackData+&6D0 as the input

 LSR A                  \ Shift bit 0 of the input into the C flag and store it
 PHP                    \ on the stack so we can put it into bit 7 of the result

 LSR A                  \ Shift bit 1 of the input into the C flag

 BCS C44E0              \ If bit 1 of the input is set, skip the following
                        \ instruction

 JSR Multiply8x8        \ Bit 1 of the input is clear, so set (A T) = A * U
                        \
                        \ i.e. A = A * U / 256

.C44E0

 ASL A                  \ Set bit 7 of the result to bit 0 of the input
 PLP
 ROR A

 STA L5FB0,Y            \ Store the result in the Y-th byte of L5FB0

 DEY                    \ Decrement the loop counter

 BPL P44D5              \ Loop back until we have processed all Y bytes

 RTS                    \ Return from the subroutine

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
 LDA gearNumber
 BEQ C4510
 LDA throttleBrakeState
 BMI C4510
 BEQ C450C
 LDA L003D
 BNE C4516
 BEQ C4510

.C450C

 LDA speedHi
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
 LDA trackData+&100,Y
 EOR trackData+&300,Y
 PHP
 LDA trackData+&300,Y
 PHP

 JSR Absolute8Bit       \ Set A = |A|

 CMP #&3C
 PHP
 BCC C454F
 LDA trackData+&100,Y

 JSR Absolute8Bit       \ Set A = |A|

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

 JSR Absolute8Bit       \ Set A = |A|

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

 JSR Absolute8Bit       \ Set A = |A|

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
 LDX currentPlayer
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
 LDA speedHi
 STA U
 LDA #&21

 JSR Multiply8x8        \ Set (A T) = A * U

 ASL U
 CLC
 ADC U
 STA L3850Hi,X
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
 LDA trackData+&200,Y
 EOR L0025
 PHP
 LDA trackData+&200,Y

 JSR Absolute8Bit       \ Set A = |A|

 JSR Multiply8x8        \ Set (A T) = A * U

 PLP

 JSR Absolute8Bit       \ Set A = |A|

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

 JSR Absolute8Bit       \ Set A = |A|

 CMP #&40
 ROR L0043
 BPL C4639
 EOR #&7F
 CLC
 ADC #1

.C4639

 PHA

 LDY #186
 JSR sub_C4676

 LDX L005C
 CPX #&28
 BCC C4647
 EOR #&FF

.C4647

 LDX currentPlayer
 BIT L0025

 JSR Absolute8Bit       \ Set A = |A|

 PHA
 SBC L0178,X
 BCS C4656
 EOR #&FF

.C4656

 CMP #&16

IF _ACORNSOFT

 ROR L62FB

ELIF _SUPERIOR

 JSR sub_C1FA8

ENDIF

 PLA
 STA L0178,X
 PLA
 EOR #&FF
 CLC
 ADC #&41

 LDY #136
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
\ Arguments:
\
\   A                   
\
\   Y                   Called with Y = 136 or 186
\
\ ******************************************************************************

.sub_C4676

 JSR sub_C4687          \ Set U = A, scaled up by sub_C4687
 STA U                  \ Call it A+

 TYA                    \ Set (A T) = A * U
 JSR Multiply8x8        \           = Y * A+

 STA U                  \ Set (U T) = (A T)
                        \           = Y * A+

 LDA L0010              \ Set (A T) = A * U
 JSR Multiply8x8        \           = L0010 * U
                        \           = L0010 * (Y * A+ / 256)
                        \           = L0010 * A+ * (Y / 256)

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: sub_C4687
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\   When            Calculate               Range of result
\
\   A < 26          A = 3 * A               0 to 78
\   26 <= A < 46    A = 4 * A + 52          156 to 232
\   A >= 46         A = A + 190             236 and up
\
\ ******************************************************************************

.sub_C4687

 CMP #26                \ If A < 26, jump to C4699
 BCC C4699

 CMP #46                \ If A < 46, jump to C4693
 BCC C4693

                        \ If we get here then A >= 46

 CLC                    \ Set A = A + 190
 ADC #190

 RTS                    \ Return from the subroutine

.C4693

                        \ If we get here then 26 <= A < 46

 ASL A                  \ Set A = A << 2 + 52
 ASL A                  \       = 4 * A + 52
 CLC
 ADC #52

 RTS                    \ Return from the subroutine

.C4699

                        \ If we get here then A < 26

 STA T                  \ Set T = A

 ASL A                  \ Set A = A << 1 + T
 CLC                    \       = A * 2 + A
 ADC T                  \       = 3 * A
 ASL A

 RTS                    \ Return from the subroutine

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

 LDA L62D8Lo
 STA L0038
 LDA L62E8Hi
 STA L0039

 LDA L62D9Lo
 STA T
 LDA L62E9Hi

 JSR Absolute16Bit      \ Set (A T) = |A T|

 STA speedHi

 LDA T
 STA speedLo

 LDY speedHi
 BNE C46CD
 AND #&F0
 TAY

.C46CD

 STY carMoving
 JSR sub_C4729
 JSR sub_C4BCF
 JSR sub_C49CE
 LDX #1
 JSR sub_C4779
 LDA L0038
 STA L62D8Lo
 LDA L0039
 STA L62E8Hi
 LDA L62D8Lo
 CLC
 ADC L003A
 STA L62D8Lo
 LDA L62E8Hi
 ADC L003B
 STA L62E8Hi
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

.P4710

 STA L62D5Lo,X
 STA L62E5Hi,X
 DEX
 BPL P4710

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

 LDA L62D2Lo
 STA T
 LDY #&58
 LDA L62E2Hi
 JSR sub_C4753
 STA U
 LDA L62D8Lo
 SEC
 SBC T
 STA L62D8Lo
 LDA L62E8Hi
 SBC U
 STA L62E8Hi
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

 JSR Absolute16Bit      \ Set (A T) = |A T|

 STA V
 STY U
 JSR sub_C0DBF
 LDA U
 PLP

 JSR Absolute16Bit      \ Set (A T) = |A T|

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

 LDX #3                 \ Flush the buffer for sound channel 3
 JSR FlushSoundBuffer

.C4794

 RTS

.C4795

 JSR sub_C4AF7
 LDA soundBuffer+3
 BNE C47A4

 LDY #1
 LDA #3
 JSR MakeSound

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
 STA H
 LDA #&0E
 JSR sub_C4874
 LDX #2
 LDY #8
 LDA #&40
 STA H
 LDA #9
 JSR sub_C4874

 LDX #8                 \ Add (L62EEHi L62DELo) to (L62E8Hi L62D8Lo)
 JSR sub_C47E5

 RTS                    \ Return from the subroutine

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
 STA H
 LDA #&0E
 JSR sub_C4874
 LDX #2
 LDY #&0A
 LDA #&C0
 STA H
 LDA #&0C
 JSR sub_C4874

 LDX #10                 \ Add (L62EEHi L62DELo) to (L62EAHi L62DAHi)
 JSR sub_C47E5

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: sub_C47E5
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Add (L62EEHi L62DELo) to (L62E0Hi+X L62D0Lo+X)
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   Called with either 8 or 10:
\
\                         *  8 = add (L62EEHi L62DELo) to (L62E8Hi L62D8Lo)
\
\                         * 10 = add (L62EEHi L62DELo) to (L62EAHi L62DAHi)
\
\ ******************************************************************************

.sub_C47E5

 LDA L62D0Lo,X          \ Add (L62EEHi L62DELo) to (L62E0Hi+X L62D0Lo+X),
 CLC                    \ starting with the low bytes
 ADC L62DELo
 STA L62D0Lo,X

 LDA L62E0Hi,X          \ And then the high bytes
 ADC L62EEHi
 STA L62E0Hi,X

 RTS                    \ Return from the subroutine

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
 LDA L62DAHi
 SEC
 SBC L62DBHi
 STA T
 LDA L62EAHi
 SBC L62EBHi
 JSR sub_C4753
 STA L62E5Hi
 LDA T
 STA L62D5Lo
 LDY #1

.P4817

 LDX #3

.P4819

 LDA L62EAHi,X
 CLC
 BPL C4820
 SEC

.C4820

 ROR L62EAHi,X
 ROR L62DAHi,X
 DEX
 BPL P4819
 DEY
 BPL P4817
 LDX #2
 LDA #1
 STA G

.C4832

 LDA L62DBHi,X
 STA T
 LDA L62EBHi,X
 STA U
 JSR sub_C4765
 STA U
 LDA T
 CLC
 ADC L62DAHi,X
 STA T
 LDY #&CD
 LDA U
 ADC L62EAHi,X
 JSR sub_C4753
 ASL T
 ROL A
 LDY G
 STA L62E6Hi,Y
 LDA T
 STA L62D6Lo,Y
 DEC G
 DEX
 DEX
 BPL C4832
 LDA L62E7Hi
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

 LDY N
 STA H
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

 STA K

.C4876

 LDA L62D0Lo,Y
 STA PP
 LDA L62E0Hi,Y
 STA QQ
 LDA L62A0,X
 STA RR
 LDA L62A3,X
 STA SS
 JSR sub_C0DD7
 STA U
 LDY K
 BIT H
 BVS C48A7
 LDA T
 STA L62D0Lo,Y
 LDA U
 STA L62E0Hi,Y
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

 JSR Negate16Bit+2      \ Set (A T) = -(U T)

 STA U

.C48A7

 LDA L62D0Lo,Y
 CLC
 ADC T
 STA L62D0Lo,Y
 LDA L62E0Hi,Y
 ADC U
 STA L62E0Hi,Y
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

 STY N
 STA K
 STX GG
 LDX #1
 LDA #0
 JSR sub_C486D
 DEX
 INC N
 LDA GG
 JSR sub_C486D
 INX
 INC K
 LDA #0
 JSR sub_C486D
 DEX
 DEC N
 LDA GG
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
 LDA L62D0Lo,X
 STA T
 LDA L62E0Hi,X
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
 ADC L62D2Lo
 STA L000A
 LDA L000B
 ADC L62E2Hi
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
 LDA L62D3Lo,X
 STA T
 LDA L62E3Hi,X
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
 LDA L62D0Lo,X
 ADC U
 STA L62D0Lo,X
 LDA L62E0Hi,X
 ADC V
 STA L62E0Hi,X
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

 LDX #&DC               \ Scan the keyboard to see if "T" is being pressed
 JSR ScanKeyboard

 BEQ C498C              \ If "T" is being pressed, jump to C498C

 LDY gearNumber
 DEY
 BEQ C4988
 LDA speedHi
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

 LDA revs
 LDX throttleBrakeState
 DEX
 BNE C49B0
 ADC #7
 CMP throttleBrake
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

 STA revs
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

 LDA gearChangeKey      \ If bit 7 of gearChangeKey is set then a gear change
 BMI C499D              \ key is being pressed, so jump to C499D

 LDY gearNumber
 DEY
 BEQ C499F
 LDA speedLo
 STA T
 LDA speedHi
 ASL T
 ROL A
 PHP
 BMI C49EE
 ASL T
 ROL A

.C49EE

 STA U
 LDX gearNumber
 LDA trackData+&706,X

 JSR Multiply8x8        \ Set (A T) = A * U

 ASL T
 ROL A
 PLP
 BPL C4A01
 ASL T
 ROL A

.C4A01

 BIT L0059
 BPL C4A37
 LDY throttleBrakeState
 DEY
 BNE C4A26
 LDY speedHi
 CPY #&16
 BCS C4A26

 LDY L006D              \ Set Y = L006D

 BPL C4A22              \ If bit 7 of L006D is clear, jump to C4A22

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

 STA revs
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
 LDA trackData+&70D,X

 JSR Multiply8x8        \ Set (A T) = A * U

.C4A87

 STA L003D

 LDA revs
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

 LDA L62D8Lo
 STA T
 ORA L62E8Hi
 PHP
 LDA L62E8Hi

 JSR Negate16Bit        \ Set (A T) = -(A T)

 LDY #5

.P4AA2

 ASL T
 ROL A
 DEY
 BNE P4AA2
 STA L62EAHi,X
 PLP
 BEQ C4AB4
 EOR L62E8Hi
 SEC
 BPL C4AF3

.C4AB4

 LDA T
 STA L62DAHi,X
 JSR sub_C4B88
 BCC C4ACF
 LDA #0
 STA L62DCHi
 STA L62ECHi
 LDA L62EAHi

 JSR Absolute8Bit       \ Set A = |A|

 JMP C4AED

.C4ACF

 JSR sub_C4B42
 LDA L62ECHi,X

 JSR Absolute8Bit       \ Set A = |A|

 STA T
 LDA L62EAHi,X

 JSR Absolute8Bit       \ Set A = |A|

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
 STA L62ECHi,X
 STA L62DCHi,X
 LDY #8
 JSR sub_C4B61
 LDA L62E8Hi
 EOR #&80
 STA H
 LDA #0
 STA T
 LDA L62AC,X
 STX G
 JSR sub_C4B47
 JSR sub_C4B88
 BCS C4B41
 CMP L62AC,X
 BCC C4B3E
 LDA #0
 STA T
 LDA L62AC,X
 JSR sub_C4B42
 LDY throttleBrakeState
 DEY
 BNE C4B41
 CPX #0
 BEQ C4B41
 LDA #0
 STA L62EAHi,X
 STA L62DAHi,X
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

 LDY throttleBrakeState
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

 CMP NN
 BCC C4B51
 LDA MM
 STA T
 LDA NN

.C4B51

 BIT H

 JSR Absolute16Bit      \ Set (A T) = |A T|

 LDY G
 STA L62EAHi,Y
 LDA T
 STA L62DAHi,Y
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

 LDA L62D0Lo,Y
 STA MM
 LDA L62E0Hi,Y
 BPL C4B77
 LDA #0
 SEC
 SBC MM
 STA MM
 LDA #0
 SBC L62E0Hi,Y

.C4B77

 LDY #5

.P4B79

 ASL MM
 ROL A
 BMI C4B84
 DEY
 BNE P4B79

.P4B81

 STA NN
 RTS

.C4B84

 LDA #&7F
 BNE P4B81

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
 STA G
 LDY throttleBrakeState
 DEY
 BEQ C4BAF
 LDY #9
 JSR sub_C4B61
 LDA L62E9Hi
 EOR #&80
 STA H
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
 LDA gearNumber
 SEC
 SBC #1
 STA H
 LDA L003D

.C4BBC

 STA U
 LDA throttleBrake

 JSR Multiply8x8        \ Set (A T) = A * U

 LDY throttleBrakeState
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
 LDY throttleBrakeState
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

 STA H
 EOR #&FF
 CLC
 ADC #1
 STA G
 LDA speedHi
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

 JSR Multiply8x8        \ Set (A T) = A * U

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

 LDA speedHi
 CMP #&35
 BCC C4C30
 LDA #&35

.C4C30

 STA U
 LDA L62A8,X

 JSR Multiply8x8        \ Set (A T) = A * U

 BIT L62E9Hi

 JSR Absolute8Bit       \ Set A = |A|

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
 ADC G,X
 STA L62AA,X

 JSR Multiply8x8        \ Set (A T) = A * U

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

 JSR Absolute8Bit       \ Set A = |A|

 STA U
 CMP speedHi
 BCS C4C72
 LDA speedHi

.C4C72

 LDY L005D
 BEQ C4C77
 ASL A

.C4C77

 STA W

 JSR Multiply8x8        \ Set (A T) = A * U

 STA U
 LDY #6
 LDA L0039
 JSR sub_C48A0
 LDA speedHi
 STA U
 LDA L62F1

 JSR Multiply8x8        \ Set (A T) = A * U

 CLC
 ADC #8
 STA V
 LDA W
 STA U
 JSR sub_C0DBF
 LDY #7
 LDA L62E9Hi
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

 LDX currentPlayer
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
 LDA trackData+&0E0,X
 JSR sub_C4D21
 LDY #4
 LDA trackData+&0F0,X
 JSR sub_C4D21
 LDY #2
 LDA trackData+&0D0,X
 JSR sub_C4D21
 LDA trackData+&6EA,X
 AND #7
 CLC
 ADC #7
 STA L0037
 LDA trackData+&6EA,X
 AND #&F8
 TAY
 LDX #&FD
 JSR sub_C1208
 LDY #6
 JSR sub_C2147
 LDA II
 STA L0397
 LDA JJ
 STA L03AF
 SEC
 SBC L000B

 JSR Absolute8Bit       \ Set A = |A|

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
\       Name: InitialiseDrivers
\       Type: Subroutine
\   Category: Drivers
\    Summary: Initialise all 20 drivers on the starting grid
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The routine is always called with X = 0
\
\ ******************************************************************************

.InitialiseDrivers

 STX driverNumber       \ Set driverNumber = 0, to use as a loop counter when
                        \ initialising all 20 drivers

 STX raceClass          \ Set raceClass = 0 (Novice)

 JSR Set5FB0            \ Call Set5FB0 with X = 0 (Novice) to set up the 24
                        \ bytes at L5FB0, returning with X unchanged 

                        \ The following loop works starts with X = 0, and then
                        \ loops down from 19 to 1, working its way through each
                        \ of the 20 drivers

.driv1

 TXA                    \ Set A to the current driver number in X

 STA driversInOrder,X   \ Set driversInOrder for driver X to the driver number

 LSR A                  \ Set the grid row for driver X to driver number >> 1,
 NOP                    \ so drivers 0 and 1 are on row 0, drivers 2 and 3 are
 STA driverGridRow,X    \ on row 1, and so on, up to row 9 at the back of the
                        \ grid

 JSR SetDriverSpeed     \ Set the base speed for driver X
                        \
                        \ It also decrements X to the next driver number and
                        \ updates driverNumber accordingly

 LDA #0                 \ Zero (totalPointsTop totalPointsHi totalPointsLo) for
 STA totalPointsLo,X    \ driver X
 STA totalPointsHi,X
 STA totalPointsTop,X

 TXA                    \ If X <> 0, loop back to driv1 to process the next
 BNE driv1              \ driver, until we have processed all 20 of them

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: PrintSecondLine
\       Type: Subroutine
\   Category: Text
\    Summary: Prints a text token on the second text line at the top of the
\             driving screen
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The token number (0 to 54)
\
\ ******************************************************************************

.PrintSecondLine

 LDA #33                \ Set A = 33 to use as the value for yCursor below, so
                        \ we print the text token on the second text line at the
                        \ top of the driving screen

 BNE PrintFirstLine+2   \ Jump to PrintFirstLine+2 to print the token in X on
                        \ the second text line in the driving screen (this BNE
                        \ is effectively a JMP as A is never zero)

\ ******************************************************************************
\
\       Name: PrintFirstLine
\       Type: Subroutine
\   Category: Text
\    Summary: Prints a text token on the first text line at the top of the
\             driving screen
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The token number (0 to 54)
\
\ Other entry points:
\
\   PrintFirstLine+2    Print the token on the second text line at the top of
\                       the driving screen
\
\ ******************************************************************************

.PrintFirstLine

 LDA #24                \ Set A = 24 to use as the value for yCursor below, so
                        \ we print the text token on the first line of the two
                        \ text lines at the top of the driving screen

.C4D76

 STA yCursor            \ Move the cursor to pixel row A (which will either be
                        \ the first or the second text line at the top of the
                        \ screen)

 LDA #1                 \ Move the cursor to character column 1
 STA xCursor

                        \ Fall through into PrintToken to print the token in X
                        \ at (xCursor, yCursor)

\ ******************************************************************************
\
\       Name: PrintToken
\       Type: Subroutine
\   Category: Text
\    Summary: Print a recursive token
\  Deep dive: Text tokens
\
\ ------------------------------------------------------------------------------
\
\ Addresses of token strings are in the (tokenHi tokenLo) table. Tokens are
\ numbered from 0 to 54.
\
\ Each token's string contains bytes that are printed as follows:
\
\   * 0-159     Print character n
\   * 160-199   Print n - 160 spaces (0 to 39)
\   * 200-254   Print token n - 200 (0 to 54)
\   * 255       End of token
\
\ Arguments:
\
\   X                   The token number (0 to 54)
\
\   (xCursor, yCursor)  The on-screen position for the token
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

 LDX #0                 \ X = 54, so call PrintHeader with X = 0 to print
 JSR PrintHeader        \ "FORMULA 3  CHAMPIONSHIP" as a double-height header
                        \ at column 4, row 3, in yellow text on a red background

 JMP toke4              \ Skip the following instruction

.toke3

 JSR PrintToken         \ Print token X (so if it also contains embedded tokens,
                        \ they will also be expanded and printed)

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
                        \ the number of spaces to print, in the range 0 to 39

 JSR PrintSpaces        \ Print the number of spaces in A

 BEQ toke7              \ Skip the following instruction (this BNE is
                        \ effectively a JMP as PrintSpaces sets the Z flag)

.toke6

 JSR PrintCharacter     \ Print the character in A (which is in the range 0 to
                        \ 159)

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

 LDA speedHi

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
 ROR L62D2Lo
 LDA #4
 JSR MakeSound-3
 RTS

\ ******************************************************************************
\
\       Name: SetCustomScreen
\       Type: Subroutine
\   Category: Screen mode
\    Summary: Switch to the custom screen mode
\  Deep dive: Hidden secrets of the custom screen mode
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\    screenSection      screenSection is set to -2, so the interrupt handler at
\                       ScreenHandler does not do anything straight away, but
\                       leaves the palette mapped to black, so the screen is
\                       blank
\
\ ******************************************************************************

.SetCustomScreen

 SEI                    \ Disable interrupts so we can update the 6845 registers

                        \ First we switch screen mode to the custom screen mode
                        \ used for the race, which is based on mode 5 but is
                        \ shorter at 26 character rows rather than 40
                        \
                        \ We do this by first reprogramming registers R0 to R13
                        \ of the 6845 CRTC chip using the values in the
                        \ screenRegisters table (see the screenRegisters
                        \ variable for details), and then programming register 0
                        \ of the Video ULA to the same value as standard mode 5

 LDX #13                \ We are about to write values into registers R0 to R13
                        \ so set a register counter in X to count down from 13
                        \ to 0

.cust1

 STX VIA+&00            \ Put register number X into SHEILA &00, so we can now
                        \ set the value of this 6845 register

 LDA screenRegisters,X  \ Set register X to the X-th value of screenRegisters
 STA VIA+&01

 DEX                    \ Decrement the register counter

 BPL cust1              \ Loop back until we have set registers R0 to R13 to the
                        \ values in the screenRegisters table

 DEX                    \ Set screenSection = -2, as the above loop finishes
 STX screenSection      \ with X = -1

 CLI                    \ Re-enable interrupts

 LDA #154               \ Call OSBYTE with A = 154 to set register 0 of the
 LDX #%11000100         \ Video ULA to the value in X, which sets the following,
 JSR OSBYTE             \ reading from bit 7 to bit 0:
                        \
                        \   %1  = master cursor size = large cursor
                        \   %10 = width of cursor in bytes = 2
                        \   %0  = 6845 clock rate select = low frequency clock
                        \   %01 = number of characters per line = 20
                        \   %0  = teletext output select = on-chip serialiser
                        \   %0  = flash colour select = first colour selected
                        \
                        \ These values are the same as in standard mode 5, and
                        \ this call finishes the switch to our custom screen
                        \ mode
 
 CLC                    \ Clear the C flag for the additions in the following
                        \ loop

                        \ We now send the following bytes to the Video ULA
                        \ palette in SHEILA &21, by starting at 7 and adding &10
                        \ to send &07, &17, &27 ... &E7, &F7
                        \
                        \ This maps all four logical colours (the top nibble) to
                        \ &7 EOR 7 (the bottom nibble, EOR 7), which maps them
                        \ to colour 0, or black

 LDA #&07               \ Set A = &07 as the first byte to send

.cust2

 STA VIA+&21            \ Send A to SHEILA &21 to send the palette byte in A to
                        \ the Video ULA

 ADC #&10               \ Set A = A + &10

 BCC cust2              \ Loop back until the addition overflows after we send
                        \ &F7 to the ULA

 SEI                    \ Disable interrupts so we can update the VIAs

 LDA IRQ1V              \ Store the current address from the IRQ1V vector in
 STA irq1Address        \ irq1Address, so the IRQ handler can jump to it after
 LDA IRQ1V+1            \ implementing the custom screen mode
 STA irq1Address+1

 LDA #2                 \ This instruction appears to have no effect, as we are
                        \ about to overwrite A and the processor flags

.cust3

 BIT VIA+&4D            \ Read the 6522 System VIA interrupt flag register IFR
                        \ (SHEILA &4D), which has bit 1 set if vertical sync
                        \ has occurred on the video system

 BEQ cust3              \ Loop back to cust3 to keep reading the System VIA
                        \ until the vertical sync occurs

 LDA #%01000000         \ Set 6522 User VIA auxiliary control register ACR
 STA VIA+&6B            \ (SHEILA &6B) bits 7 and 6 to disable PB7 (which is one
                        \ of the pins on the user port) and set continuous
                        \ interrupts for timer 1

 ORA VIA+&4B            \ Set 6522 System VIA auxiliary control register ACR
 STA VIA+&4B            \ (SHEILA &6B) bit 6 to set continuous interrupts for
                        \ timer 1

 LDA #%11000000         \ Set 6522 User VIA interrupt enable register IER
 STA VIA+&6E            \ (SHEILA &4E) bits 6 and 7 (i.e. enable the Timer1
                        \ interrupt from the User VIA)

 STA VIA+&4E            \ Set 6522 System VIA interrupt enable register IER
                        \ (SHEILA &4E) bits 6 and 7 (i.e. enable the Timer1
                        \ interrupt from the System VIA)

 LDA #&D4               \ Set 6522 User VIA T1C-L timer 1 low-order counter to
 STA VIA+&64            \ (SHEILA &44) to &D4 (so this sets the low-order
                        \ counter but does not start counting until the
                        \ high-order counter is set)

 LDA #&11               \ Set 6522 User VIA T1C-H timer 1 high-order counter
 STA VIA+&65            \ (SHEILA &45) to &11 to start the T1 counter
                        \ counting down from &1164 (4452) at a rate of 1 MHz

 LDA #&01               \ Set 6522 System VIA T1L-L timer 1 low-order latches
 STA VIA+&46            \ to &01 (so this sets the low-order counter but does
                        \ not start counting until the high-order counter is
                        \ set)

 LDA #&3D               \ Set 6522 System VIA T1C-H timer 1 high-order counter
 STA VIA+&45            \ to &3D, to start the T1 counter counting down from
                        \ &3D01

 LDA #&1E               \ Set 6522 System VIA T1L-L timer 1 low-order latches
 STA VIA+&46            \ to &1E (so this sets the low-order counter but does
                        \ not start counting until the high-order counter is
                        \ set)

 STA VIA+&66            \ Set 6522 User VIA T1L-L timer 1 low-order latches
                        \ to &1E (so this sets the low-order counter but does
                        \ not start counting until the high-order counter is
                        \ set)

 LDA #&4E               \ Set 6522 System VIA T1L-H timer 1 high-order latches
 STA VIA+&47            \ to &4E (so this sets the timer to &4E1E (19998) but
                        \ does not start counting until the current timer has
                        \ run down)

 STA VIA+&67            \ Set 6522 User VIA T1L-H timer 1 high-order latches
                        \ to &4E (so this sets the timer to &4E1E (19998) but
                        \ does not start counting until the current timer has
                        \ run down)

 LDA #HI(ScreenHandler) \ Set the IRQ1V vector to ScreenHandler, so the
 STA IRQ1V+1            \ ScreenHandler routine is now the interrupt handler
 LDA #LO(ScreenHandler)
 STA IRQ1V

 CLI                    \ Re-enable interrupts

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: ScreenHandler
\       Type: Subroutine
\   Category: Screen mode
\    Summary: The IRQ handler for the custom screen mode
\  Deep dive: Hidden secrets of the custom screen mode
\
\ ------------------------------------------------------------------------------
\
\ The screen handler starts a new screen with screenSection = -1, and then
\ increments it through 0, 1, 2, 3, 4 and 5, at which point this handler stops
\ doing anything.
\
\ Other entry points:
\
\   ScreenHandler-3     Jump to the original IRQ handler
\
\ ******************************************************************************

 JMP (irq1Address)      \ Jump to the original address from IRQ1V to pass
                        \ control to the next interrupt handler

.ScreenHandler

 LDA VIA+&6D            \ Set A to the 6522 User VIA interrupt flag register IFR
                        \ (SHEILA &46D)

 AND #%01000000         \ Extract bit 6, which is set when 6522 User VIA timer 1
                        \ runs down to zero

 BEQ ScreenHandler-3    \ If the Timer1 interrupt has not fired, jump up to
                        \ ScreenHandler-3 as we do not need to do anything at
                        \ this point

 STA VIA+&6D            \ Set bit 6 of the 6522 User VIA interrupt flag register
                        \ IFR (SHEILA &6D) to clear the timer 1 interrupt (the
                        \ timer will already have restarted as we set it to
                        \ continuous interrupts in SetCustomScreen)

 TXA                    \ Store X on the stack so we can preserve it through the
 PHA                    \ interrupt handler

 CLD                    \ Clear the D flag to switch arithmetic to normal

 LDA screenSection      \ If screenSection = 0, jump to hand1
 BEQ hand1

 BMI hand4              \ If screenSection is negative, jump to hand4

 CMP #2                 \ If screenSection < 2, i.e. screenSection = 1, jump to
 BCC hand5              \ hand5

 BEQ hand7              \ If screenSection = 2, jump to hand7

 CMP #3                 \ If screenSection = 3, jump to hand9
 BEQ hand9

 BCS hand11             \ If screenSection >= 3, i.e. screenSection = 4, jump
                        \ to hand11

.hand1

                        \ If we get here, then screenSection = 0, so we set the
                        \ screen mode to 4 and the palette for the top two lines
                        \ of text (where the race information is printed)

 LDA #%10001000         \ Set the Video ULA control register (SHEILA &20) to
 STA VIA+&20            \ %10001000, which is the same as switching to mode 4

 LDX #15                \ We now send the 16 palette bytes at paletteSection0 to
                        \ the Video ULA palette in SHEILA &21, so set a loop
                        \ counter in X


.hand2

 LDA paletteSection0,X  \ Set the X-th byte of paletteSection0 to the Video ULA
 STA VIA+&21            \ palette

 DEX                    \ Decrement the loop counter

 BPL hand2              \ Loop back until we have sent all 16 bytes

.hand3

 LDA #&C4               \ Set (X A) = &0FC4 to latch into the User VIA timer 1,
 LDX #&0F               \ so on the next timer loop it counts down from &0FC4
                        \ (4036)

 BNE hand13             \ Jump to hand13 to latch (X A) into User VIA timer 1
                        \ and return from the subroutine (this BNE is
                        \ effectively a JMP as X is never zero)

.hand4

                        \ If we get here, then screenSection is negative

 CMP #&FF               \ If screenSection <> -1, then jump to hand14 to
 BNE hand14             \ return from the interrupt handler

                        \ If we get here, then screenSection = -1

 INC screenSection      \ Set screenSection = 0

 BEQ hand3              \ Jump to hand3 to set timer 1 counting down from &0FC4
                        \ and return from the interrupt handler (this BNE is
                        \ effectively a JMP as screenSection is always zero)

.hand5

                        \ If we get here, then screenSection = 1, so we change
                        \ the palette so everything is blue, as this is the
                        \ portion of cloudless sky between the text at the top
                        \ of the screen and the car and track at the bottom

 LDA #%11000100         \ Set the Video ULA control register (SHEILA &20) to
 STA VIA+&20            \ %11000100, which is the same as switching to mode 5

 CLC                    \ Clear the C flag for the additions in the following
                        \ loop

                        \ We now send the following bytes to the Video ULA
                        \ palette in SHEILA &21, by starting at 3 and adding &10
                        \ to send &03, &13, &23 ... &E3, &F3
                        \
                        \ This maps all four logical colours (the top nibble) to
                        \ &3 EOR 7 (the bottom nibble, EOR 7), which maps them
                        \ to colour 4, or blue

 LDA #&03               \ Set A = &03 as the first byte to send

.hand6

 STA VIA+&21            \ Send A to SHEILA &21 to send the palette byte in A to
                        \ the Video ULA

 ADC #&10               \ Set A = A + &10

 BCC hand6              \ Loop back until the addition overflows after we send
                        \ &F3 to the ULA

 LDA #&3C               \ Set (timer2Hi timer2Lo) = &153C - (timer1Hi timer1Lo)
 SEC                    \
 SBC timer1Lo           \ starting with the low bytes
 STA timer2Lo

 LDA #&15               \ And then the high bytes
 SBC timer1Hi
 STA timer2Hi

 LDA timer1Lo           \ Set (X A) = (timer1Hi timer1Lo) to latch into the User
 LDX timer1Hi           \ VIA timer 1, so on the next timer loop it counts down
                        \ from (timer1Hi timer1Lo)

 BCS hand13             \ Jump to hand13 to latch (X A) into User VIA timer 1
                        \ and return from the subroutine (this BCS is
                        \ effectively a JMP as the C flag is still set from
                        \ above)

.hand7

                        \ If we get here, then screenSection = 2

 LDX #15                \ We now send the 16 palette bytes at paletteSection2 to
                        \ the Video ULA palette in SHEILA &21, so set a loop
                        \ counter in X

.hand8

 LDA paletteSection2,X  \ Set the X-th byte of paletteSection2 to the Video ULA
 STA VIA+&21            \ palette

 DEX                    \ Decrement the loop counter

 BPL hand8              \ Loop back until we have sent all 16 bytes

 LDA timer2Lo           \ Set (X A) = (timer2Hi timer2Lo) to latch into the User
 LDX timer2Hi           \ VIA timer 1, so on the next timer loop it counts down
                        \ from (timer2Hi timer2Lo)

 BNE hand13             \ Jump to hand13 to latch (X A) into User VIA timer 1
                        \ and return from the subroutine (this BNE is
                        \ effectively a JMP as X is never zero)

.hand9

                        \ If we get here, then screenSection = 3

 LDX #3                 \ We now send the 3 palette bytes at paletteSection3 to
                        \ the Video ULA palette in SHEILA &21, so set a loop
                        \ counter in X

.hand10

 LDA paletteSection3,X  \ Set the X-th byte of paletteSection2 to the Video ULA
 STA VIA+&21            \ palette

 DEX                    \ Decrement the loop counter

 BPL hand10             \ Loop back until we have sent all 16 bytes

 LDA #&00               \ Set (X A) = &1E00 to latch into the User VIA timer 1,
 LDX #&1E               \ so on the next timer loop it counts down from &1E00
                        \ (7680)

 BNE hand13             \ Jump to hand13 to latch (X A) into User VIA timer 1
                        \ and return from the subroutine (this BNE is
                        \ effectively a JMP as X is never zero)

.hand11

                        \ If we get here, then screenSection = 4

 LDX #3                 \ We now send the 3 palette bytes at paletteSection4 to
                        \ the Video ULA palette in SHEILA &21, so set a loop
                        \ counter in X

.hand12

 LDA paletteSection4,X  \ Set the X-th byte of paletteSection2 to the Video ULA
 STA VIA+&21            \ palette

 DEX                    \ Decrement the loop counter

 BPL hand12             \ Loop back until we have sent all 16 bytes

 STX screenSection      \ Set screenSection = -1, as the above loop finishes
                        \ with X = 255

 JSR AnimateTyres       \ Animate the tyres on either side of the screen

 LDA #&FF               \ Set 6522 User VIA T2C-H timer 2 high-order counter
 STA VIA+&69            \ (SHEILA &69) to &FF to start the T2 counter
                        \ counting down from &FFxx at a rate of 1 MHz

 LDA #&16               \ Set (X A) = &0B16 to latch into the User VIA timer 1,
 LDX #&0B               \ so on the next timer loop it counts down from &0B16
                        \ (2838)

.hand13

 STX VIA+&67            \ Set 6522 User VIA T1L-H and T1L-L to set both timer 1
 STA VIA+&66            \ latches (so this sets the timer to (X A) but does not
                        \ start counting until the current timer has run down)

 INC screenSection      \ Increment the screen section counter to move on to the
                        \ next section

.hand14

 PLA                    \ Restore X from the stack
 TAX

 LDA &FC                \ Set A to the interrupt accumulator save register,
                        \ which restores A to the value it had on entering the
                        \ interrupt

 RTI                    \ Return from interrupts, so this interrupt is not
                        \ passed on to the next interrupt handler, but instead
                        \ the interrupt terminates here

\ ******************************************************************************
\
\       Name: screenRegisters
\       Type: Variable
\   Category: Screen mode
\    Summary: The 6845 registers for the custom screen mode
\  Deep dive: Hidden secrets of the custom screen mode
\
\ ------------------------------------------------------------------------------
\
\ The custom screen mode used during the race is based on standard mode 5, but
\ with the following differences:
\
\   * Horizontal sync position = 45 instead of 49
\   * Vertical displayed       = 26 instead of 32
\   * Vertical sync position   = 32 instead of 34
\   * Screen memory start      = &5A80 instead of &5800
\
\ So essentially it is a shorter mode 5 that takes up less memory, adjusts the
\ vertical and horizontal sync positions accordingly, and lives in screen memory
\ from &5A80 to &7AFF (as there are 26 character rows of 40 characters, with 8
\ bytes per character, giving 26 * 40 * 8 = 8320 bytes of screen memory, and
\ &5A80 + 8320 = &7B00).
\
\ ******************************************************************************

.screenRegisters

 EQUB 63                \ Set 6845 register R0 = 63
                        \
                        \ This is the "horizontal total" register, which sets
                        \ the horizontal sync frequency, i.e. the number of
                        \ horizontal characters minus one. This value is the
                        \ same as in standard mode 5

 EQUB 40                \ Set 6845 register R1 = 40
                        \
                        \ This is the "horizontal displayed" register, which
                        \ defines the number of character blocks per horizontal
                        \ character row. This value is the same as in standard
                        \ mode 5

 EQUB 49                \ Set 6845 register R2 = 45
                        \
                        \ This is the "horizontal sync position" register, which
                        \ defines the position of the horizontal sync pulse on
                        \ the horizontal line in terms of character widths from
                        \ the left-hand side of the screen. For comparison this
                        \ is 49 for mode 5, but is adjusted for our custom
                        \ screen

 EQUB &24               \ Set 6845 register R3 = &24
                        \
                        \ This is the "sync width" register, which sets the
                        \ horizontal sync width in characters using the low
                        \ nibble (i.e. 4), and the vertical sync width in the
                        \ high nibble (i.e. 2). These values are the same as in
                        \ standard mode 5

 EQUB 38                \ Set 6845 register R4 = 38
                        \
                        \ This is the "vertical total" register, which contains
                        \ the integer part of the vertical sync frequency minus
                        \ one. This value is the same as in standard mode 5

 EQUB 0                 \ Set 6845 register R5 = 0
                        \
                        \ This is the "vertical total adjust" register, which
                        \ contains the fractional part of the vertical sync
                        \ frequency. This value is the same as in standard mode
                        \ 5

 EQUB 26                \ Set 6845 register R6 = 26
                        \
                        \ This is the "vertical displayed" register, which sets
                        \ the number of displayed character rows to 26. For
                        \ comparison, this value is 32 for standard modes 4 and
                        \ 5, but we claw back six rows for storing code above
                        \ the end of screen memory

 EQUB 32                \ Set 6845 register R7 = 32
                        \
                        \ This is the "vertical sync position" register, which
                        \ determines the vertical sync position with respect to
                        \ the reference, programmed in character row times. For
                        \ comparison this is 34 for mode 5, but needs to be
                        \ adjusted for our custom screen's vertical sync

 EQUB %00000001         \ Set 6845 register R8 = %00000001
                        \
                        \ This is the "interlace and display" register, which
                        \ sets the following, reading from bit 7 to bit 0:
                        \
                        \   %00 = no delay in the cursor blanking signal
                        \   %00 = no delay in the display blanking signal
                        \   %00 = not used
                        \   %01 = interlace sync mode
                        \
                        \ These values are the same as in standard mode 5

 EQUB 7                 \ Set 6845 register R9 = 7
                        \
                        \ This is the "scan lines per character" register, and
                        \ contains the number of scan lines per character row,
                        \ including spacing, minus one. This value is the same
                        \ as in standard mode 5

 EQUB %01100111         \ Set 6845 register R10 = %01100111
                        \
                        \ This is the "cursor start" register, which sets the
                        \ following, reading from bit 7 to bit 0:
                        \
                        \   %0 = not used
                        \   %1 = enable blink feature
                        \   %1 = set blink frequency to 32 times the field rate
                        \   %00111 = cursor end scan line
                        \
                        \ These values are the same as in standard mode 5

 EQUB 8                 \ Set 6845 register R11 = 8
                        \
                        \ This is the "cursor end" register, which sets the
                        \ cursor end scan line. This value is the same as in
                        \ standard mode 5

 EQUB &0B               \ Set 6845 register R12 = &0B and R13 = &50
 EQUB &50               \
                        \ This sets 6845 registers (R12 R13) = &0B50 to point
                        \ to the start of screen memory in terms of character
                        \ rows. There are 8 pixel lines in each character row,
                        \ so to get the actual address of the start of screen
                        \ memory, we multiply by 8:
                        \
                        \   &0B50 * 8 = &5A80
                        \
                        \ So this sets the start of screen memory to &5A80

\ ******************************************************************************
\
\       Name: irq1Address
\       Type: Variable
\   Category: Screen mode
\    Summary: Stores the previous value of IRQ1V before we install our custom
\             IRQ handler
\
\ ******************************************************************************

.irq1Address

 EQUW 0

\ ******************************************************************************
\
\       Name: timer1Lo
\       Type: Variable
\   Category: Screen mode
\    Summary: Low byte of the timer offset between the start of section 2 and
\             the start of section 3
\  Deep dive: Hidden secrets of the custom screen mode
\
\ ******************************************************************************

.timer1Lo

 EQUB &D8

\ ******************************************************************************
\
\       Name: timer1Hi
\       Type: Variable
\   Category: Screen mode
\    Summary: High byte of the timer offset between the start of section 2 and
\             the start of section 3
\  Deep dive: Hidden secrets of the custom screen mode
\
\ ******************************************************************************

.timer1Hi

 EQUB &04

\ ******************************************************************************
\
\       Name: timer2Lo
\       Type: Variable
\   Category: Screen mode
\    Summary: Low byte of the timer offset between the start of section 3 and
\             the start of section 4
\  Deep dive: Hidden secrets of the custom screen mode
\
\ ******************************************************************************

.timer2Lo

 EQUB &64

\ ******************************************************************************
\
\       Name: timer2Hi
\       Type: Variable
\   Category: Screen mode
\    Summary: High byte of the timer offset between the start of section 3 and
\             the start of section 4
\  Deep dive: Hidden secrets of the custom screen mode
\
\ ******************************************************************************

.timer2Hi

 EQUB &10

\ ******************************************************************************
\
\       Name: KillCustomScreen
\       Type: Subroutine
\   Category: Screen mode
\    Summary: Disable the custom screen mode and switch to mode 7
\  Deep dive: Hidden secrets of the custom screen mode
\
\ ******************************************************************************

.KillCustomScreen

 SEI                    \ Disable interrupts so we can update the interrupt
                        \ vector and VIA

 LDA irq1Address        \ Set the IRQ1V vector to irq1Address, which removes the
 STA IRQ1V              \ custom screen interrupt handler from the chain
 LDA irq1Address+1
 STA IRQ1V+1

 LDA #%01000000         \ Set 6522 User VIA interrupt enable register IER
 STA VIA+&6E            \ (SHEILA &4E) bit 6 (i.e. disable the Timer1 interrupt
                        \ from the User VIA, as we no longer neeed it)

 CLI                    \ Re-enable interrupts

 JSR FlushSoundBuffers  \ Flush all four sound channel buffers

                        \ Fall througn into SetScreenMode7 to switch to mode 7

\ ******************************************************************************
\
\       Name: SetScreenMode7
\       Type: Subroutine
\   Category: Screen mode
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
\       Name: screenSection
\       Type: Variable
\   Category: Screen mode
\    Summary: The section of the screen that is currently being drawn by the
\             custom screen interrupt handler (0 to 4)
\  Deep dive: Hidden secrets of the custom screen mode
\
\ ******************************************************************************

.screenSection

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

 SEI                    \ Disable interrupts so we can update the custom screen
                        \ variables

 CLC                    \ Set (timer1Hi timer1Lo) = (U A) + &04D8
 ADC #&D8               \
 STA timer1Lo           \ starting with the low bytes

 LDA #&04               \ And then the high bytes
 ADC U
 STA timer1Hi

 CLI                    \ Re-enable interrupts

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
 CPX currentPlayer
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

 BIT raceStarted
 BPL C4FA8
 CMP numberOfLaps
 BCC C4FB7
 BEQ C4FAF
 RTS

.C4FA8

 CPX currentPlayer
 BEQ C4FB7
 BCC C4FB7
 RTS

.C4FAF

 CPX currentPlayer
 BNE C4FB7

 LDA #80
 STA L000F

.C4FB7

 SED                    \ Set the D flag to switch arithmetic to Binary Coded
                        \ Decimal (BCD)

 SEC
 LDA currentTenths
 SBC bestLapTenths,X
 STA T
 LDA currentSeconds
 SBC bestLapSeconds,X
 BCS C4FCC
 ADC #&60
 CLC

.C4FCC

 STA U
 LDA currentMinutes
 SBC bestLapMinutes,X
 STA H
 BCC C4FFB
 SEC
 LDA T
 SBC driverTenths,X
 LDA U
 SBC driverSeconds,X
 LDA H
 SBC driverMinutes,X
 BCS C4FFB
 LDA T
 AND #&F0
 STA driverTenths,X
 LDA U
 STA driverSeconds,X
 LDA H
 STA driverMinutes,X

.C4FFB

 LDA currentTenths
 STA bestLapTenths,X
 LDA currentSeconds
 STA bestLapSeconds,X
 LDA currentMinutes
 STA bestLapMinutes,X

 CLD                    \ Clear the D flag to switch arithmetic to normal

 RTS

 NOP
 NOP

\ ******************************************************************************
\
\       Name: ZeroLapTime
\       Type: Subroutine
\   Category: Drivers
\    Summary: Zero the current lap time
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The lap time to zero:
\
\                         * 0 = (currentTenths currentSeconds currentMinutes)
\
\                         * 1 = (currentTenths currentSeconds currentMinutes)+1
\
\ Returns:
\
\   A                   A = 0 and the Z flag is set (so a BEQ will branch)
\
\ ******************************************************************************

.ZeroLapTime

 LDA #0                 \ Zero currentTenths+X
 STA currentTenths,X

 STA currentSeconds,X   \ Zero currentSeconds+X

 STA currentMinutes,X   \ Zero currentMinutes+X

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: PrintBestLapTime
\       Type: Subroutine
\   Category: Text
\    Summary: Print the best lap time and the current lap time at the top of the
\             screen
\
\ ******************************************************************************

.PrintBestLapTime

 LDX #32                \ Move the cursor to character column 32 (to just after
 STX xCursor            \ "Best time" in token 40)

 INX                    \ Move the cursor to pixel row 33 (i.e. the second text
 STX yCursor            \ line at the top of the screen)

 LDX currentPlayer      \ Set X to the driver number of the current player

 LDA #%00100110         \ Print the best lap time for driver X in the following
 JSR PrintLapTime       \ format:
                        \
                        \   * %00 Minutes: No leading zeroes, print both digits
                        \   * %10 Seconds: Leading zeroes, print both digits
                        \   * %0  Tenths: Print tenths of a second
                        \   * %11 Tenths: Leading zeroes, no second digit

                        \ Fall through into PrintThisLapTime to print the
                        \ current lap time at the top of the screen

\ ******************************************************************************
\
\       Name: PrintThisLapTime
\       Type: Subroutine
\   Category: Text
\    Summary: Print the current lap time at the top of the screen
\
\ ------------------------------------------------------------------------------
\
\ This routine prints the current lap time in the header at the top of the
\ screen in the following format:
\
\   * Minutes: No leading zeroes, print both digits
\   * Seconds: Leading zeroes, print both digits
\   * Tenths: Do not print tenths of a second
\
\ Other entry points:
\
\   PrintThisLapTime+2  Format the lap time using the format value in A (see
\                       PrintLapTime for details)
\
\ ******************************************************************************

.PrintThisLapTime

 LDA #%00101000         \ Set A so the current lap time is printed in the
                        \ following format by the call to PrintLapTime:
                        \
                        \   * %00 Minutes: No leading zeroes, print both digits
                        \   * %10 Seconds: Leading zeroes, print both digits
                        \   * %1  Tenths: Do not print tenths of a second

 LDX #10                \ Move the cursor to character column 10 (to just after
 STX xCursor            \ "Lap time" in token 40)

 LDX #33                \ Move the cursor to pixel row 33 (i.e. the second text
 STX yCursor            \ line at the top of the screen)

 LDX #21                \ Print the lap time for the current lap (which is
 JSR PrintLapTime       \ stored just after driver 20's best lap time, i.e. for
                        \ driver 21, if there was one) in the format given in A

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: GetADCChannel
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Read the value of an ADC channel (used to read the joystick)
\
\ ------------------------------------------------------------------------------
\
\ This routine reads a joystick axis and returns a value with 0 representing the
\ stick being at the centre point, and -127 and +127 representing the right/left
\ or down/up values.
\
\ Arguments:
\
\   X                   The ADC channel to read:
\
\                         * 1 = joystick X
\
\                         * 2 = joystick Y
\
\ Returns:
\
\   A                   The high byte of the channel value, converted to an
\                       absolute figure in the range 0 to 127
\
\   X                   The sign of the result (1 = positive, 0 = negative)
\
\   C flag              Clear if A < 10
\
\ ******************************************************************************

.GetADCChannel

 LDA #128               \ Call OSBYTE with A = 128 to fetch the 16-bit value
 JSR OSBYTE             \ from ADC channel X, returning (Y X), i.e. the high
                        \ byte in Y and the low byte in X

 TYA                    \ Copy Y to A, so A contains the high byte of the
                        \ channel value

                        \ The channel value in A will be in the range 0 to 255,
                        \ with 128 representing the stick being in the centre,
                        \ so now we need to flip this around into the range 0 to
                        \ 127, with the sign given in X

 LDX #1                 \ Set X = 1

 CLC                    \ Set A = A + 128, so in terms of 8-bit mumbers, this
 ADC #128               \ does the following:
                        \
                        \   * 0-127 goes to 128-255
                        \
                        \   * 128-255 goes to 256-383, i.e. 0-127
                        \
                        \ So A is now in the range 128 to 255 for low readings
                        \ from the ADC (right or down), or 0 to 127 for high
                        \ readings (left or up)

 BPL adcc1              \ If A is in the range 0 to 127, skip the following two
                        \ instructions as the result is already in the correct
                        \ range, 0 to 127

 EOR #&FF               \ Flip the value of A, so the range 128 to 255 flips to
                        \ the range 127 to 0
 
 DEX                    \ Set X = 0 to denote a negative result, so the result
                        \ is in the range -127 to 0

.adcc1

 CMP #10                \ Clear the C flag if A < 10

 RTS                    \ Return from the subroutine

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
 LDX trackData+&719
 INX
 BEQ C505F

.C505C

 DEX
 STX L0046

.C505F

 LDA L006D              \ If bit 7 of L006D is set, jump to C5068
 BMI C5068

 LDX #0
 JSR sub_C17C3

.C5068

 INC L006A
 BNE C506F
 INC L62DFHi

.C506F

 LDA currentSeconds
 BEQ C507A
 LDA L006A
 AND #&1F
 BNE C507D

.C507A

 JSR SetDriverSpeed

.C507D

 RTS

\ ******************************************************************************
\
\       Name: GetPositionAhead
\       Type: Subroutine
\   Category: Drivers
\    Summary: Decrement X to the previous position number (from 19 to 0 and
\             round again), which gives the position ahead of X
\
\ ******************************************************************************

.GetPositionAhead

 DEX                    \ Decrement X

 BPL prev1              \ If X is >= 0, jump to prev1 to skip the following
                        \ instruction

 LDX #19                \ Set X = 19, so repeated calls to this routine will
                        \ decrement X down to 0, and then start again at 19

.prev1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: GetPositionBehind
\       Type: Subroutine
\   Category: Drivers
\    Summary: Increment X to the next position number (from 0 to 19 and round
\             again), which gives the position behind X
\
\ ******************************************************************************

.GetPositionBehind

 INX                    \ Increment X

 CPX #20                \ If X < 20, jump to next1 to skip the following
 BCC next1              \ instruction

 LDX #0                 \ Set X = 0, so repeated calls to this routine will
                        \ increment X up to 19, and then start again at 0

.next1

 RTS                    \ Return from the subroutine

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
\   A                   Character number (ASCII code, 0 to 159)
\
\   printMode           Bit 7 determines how the character is printed on-screen:
\
\                         * 0 = poke the character directly into screen memory
\                               (for the custom screen mode)
\
\                         * 1 = print the character with OSWRCH (for mode 7)
\
\   (xCursor, yCursor)  For the custom screen only, this is the coordinate where
\                       we should print the character, where xCursor is the
\                       character column and yCursor is the pixel row of the
\                       bottom of the character
\
\ Returns:
\
\   A                   A is unchanged
\
\ Other entry points:
\
\   PrintCharacter-6    Print double-width character (this is used to print the
\                       double-width number on the gear stick)
\
\                       The routine must be called twice to print double-width
\                       characters, which are drawn as follows:
\
\                         * Bit 7 of W is set = draw the right half
\
\                         * Bit 7 of W is clear = draw the left half
\
\                       W must be non-zero when the routine is called on this
\                       entry point, otherwise the routine will print characters
\                       at the normal width
\
\ ******************************************************************************

 STA characterDef       \ Store the character number in characterDef

 JMP char1              \ Jump to char1 to skip the printMode check and use the
                        \ current value of W

.PrintCharacter

 BIT printMode          \ If bit 7 of printMode is set, jump to char8 to print
 BMI char8              \ the character in A with OSWRCH

 STA characterDef       \ Store the character number in characterDef

 LDA #0                 \ Set W = 0 to indicate we should print a single-width
 STA W                  \ character

.char1

 TXA                    \ Store X and Y on the stack so we can retrieve them
 PHA                    \ after we have printed the character
 TYA
 PHA

 LDY #HI(characterDef)  \ Call OSWORD with A = 10 and (Y X) = characterDef,
 LDX #LO(characterDef)  \ which puts the character definition for the specified
 LDA #10                \ character into characterDef+1 to characterDef+8
 JSR OSWORD

 LDA W                  \ If W = 0, jump to char5 to skip the following
 BEQ char5

                        \ If we get here, then W is non-zero, so we now update
                        \ the character definition to contain just one half of
                        \ the character in the left half of the character
                        \ definition, as follows:
                        \
                        \   * If bit 7 of W is set, put the right half of the
                        \     character into left half of the character
                        \     definition
                        \
                        \   * If bit 7 of W is clear, put the left half of the
                        \     character into left half of the character
                        \     definition

 LDX #8                 \ We are now going to work our way through each pixel
                        \ row of the character definition, so set X as a loop
                        \ counter for each byte in the character definition

.char2

 LDA characterDef,X     \ Set A to the bitmap for the X-th row of the character
                        \ definition

 BIT W                  \ If bit 7 of W is set, jump to char3 to skip the next
 BMI char3              \ two instructions

 AND #%11110000         \ Clear the four pixels in the right half of the pixel
 JMP char4              \ row

.char3

 ASL A                  \ Shift A to the left so the right half of the pixel
 ASL A                  \ row moves to the left half
 ASL A
 ASL A

.char4

 STA characterDef,X     \ Store the updated pixel row byte in the X-th row of
                        \ the character definition

 DEX                    \ Decrement the row counter

 BNE char2              \ Loop back until we have processed all eight rows in
                        \ the character definition

.char5

 LDY yCursor            \ Set (Q P) to the screen address of the character block
 LDA xCursor            \ containing character column xCursor and pixel row
 JSR GetScreenAddress-2 \ yCursor, and set Y to the pixel row number within that
                        \ block
                        \
                        \ As yCursor is the pixel row of the bottom of where we
                        \ should print the character, (Q P) now points to the
                        \ address where the bottom pixel row of the character
                        \ should go

 LDX #8                 \ We are now going to work our way through each pixel
                        \ row of the character definition, poking each row to
                        \ screen memory, from the bottom row of the character
                        \ to the top, so set a counter in X for eight rows

.char6

 LDA characterDef,X     \ Store the X-th row of the character definition in the
 STA (P),Y              \ Y-th byte of (Q P)

 DEY                    \ Decrement the pixel row number to point to the row
                        \ above

 BPL char7              \ If Y is positive then we are still within the
                        \ character block, so jump to char7

 LDA P                  \ Otherwise we need to move to the bottom pixel row of
 SEC                    \ the character row above, so set:
 SBC #&40               \
 STA P                  \   (Q P) = (Q P) - &140
                        \
                        \ starting with the high bytes

 LDA Q                  \ And then the low bytes, so (Q P) contains the screen
 SBC #1                 \ address of the character block above (as each
 STA Q                  \ character row contains &140 bytes)

 LDY #7                 \ Set Y = 7 to point to the bottom pixel row in the new
                        \ character block

.char7

 DEX                    \ Decrement the character pixel row counter

 BNE char6              \ Loop back to poke the next row into screen memory
                        \ until we have poked all eight rows

 INC xCursor            \ Move the cursor to the right by one character, as we
                        \ have just printed a full character

 PLA                    \ Retrieve X and Y from the stack
 TAY
 PLA
 TAX

 LDA characterDef       \ Set A to the character number, so A is unchanged by
                        \ the routine

 RTS                    \ Return from the subroutine

.char8

 JSR OSWRCH             \ Print the character in A

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: GetScreenAddress
\       Type: Subroutine
\   Category: Graphics
\    Summary: Return the screen address for a specified screen coordinate
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The screen x-coordinate in pixels (0 to 159)
\
\   Y                   The screen y-coordinate in pixels
\
\ Returns:
\
\   (Q P)               The address of the character block containing the screen
\                       coordinates
\
\   Y                   The pixel row within the character block containing the
\                       screen coordinates
\
\ Other entry points:
\
\   GetScreenAddress-2  Treat the x-coordinate as a character column number
\                       rather than a pixel coordinate (0 to 39)
\
\ ******************************************************************************

 ASL A                  \ Set A = A << 2
 ASL A                  \       = x-coord << 2
                        \
                        \ so in the following, (Q P) gets set to x-coord << 3,
                        \ or x-coord * 8, which gives us the correct byte number
                        \ for this coordinate on the character row, as each
                        \ character block contains eight bytes

.GetScreenAddress

 STA P                  \ Set (Q P) = A << 1
 LDA #0                 \           = x-coord << 1
 ASL P                  \           = x-coord * 2
 ROL A                  \
 STA Q                  \ so (Q P) contains the correct byte number for this
                        \ coordinate as an offset from the start address of the
                        \ character row, as each character row contains 320
                        \ bytes, and the x-coordinate in A is in the range 0 to
                        \ 160 (i.e. each character block is two pixels wide)

 TYA                    \ Set X = Y
 LSR A                  \       = y-coord >> 3
 LSR A                  \
 LSR A                  \ so X is the character row number for this coordinate
 TAX

                        \ The X-th entry in the (yLookupHi yLookupLo) table
                        \ contains the screen address of the start of character
                        \ row X in the custom screen, so we now add this to
                        \ (Q P) to get the screen address of the correct
                        \ character block on this row

 LDA yLookupLo,X        \ Set (Q P) = (Q P) + X-th yLookup entry
 CLC                    \
 ADC P                  \ starting with the low bytes
 STA P

 LDA yLookupHi,X        \ And then the high bytes
 ADC Q
 STA Q

 TYA                    \ Set Y = Y mod 8, to set it to the pixel row within the
 AND #7                 \ character block for the coordinate
 TAY

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: EraseRevCounter
\       Type: Subroutine
\   Category: Graphics
\    Summary: Erase a line by replacing each pixel in the line with its original
\             contents
\
\ ******************************************************************************

.EraseRevCounter

 LDX lineBufferSize     \ Set X to the size of the line buffer

 BEQ erev2              \ If the line buffer is empty, jump to erev2 to return
                        \ from the subroutine, as there is no line to erase

 DEX                    \ Decrement X so that it can work as a buffer counter
                        \ working through buffer entries X down to 0

.erev1

 LDA lineBufferAddrLo,X \ Set (Q P) to the screen address of the X-th pixel in
 STA P                  \ the line buffer
 LDA lineBufferAddrHi,X
 STA Q

 LDA lineBufferPixel,X  \ Set A to the original screen contents of the X-th in
                        \ the line buffer

 LDY #0                 \ Restore the pixel to its original screen content, i.e.
 STA (P),Y              \ the pixel that was there before we drew a line over
                        \ the top of it

 DEX                    \ Decrement the buffer counter

 BPL erev1              \ Loop back until we have restored all the pixels in the
                        \ line buffer

 STY lineBufferSize     \ Set lineBufferSize = 0, to reset the line buffer

.erev2

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: UpdateDashboard
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Update the rev counter and steering wheel lines on the dashboard
\
\ ******************************************************************************

.UpdateDashboard

 JSR EraseRevCounter    \ Erase the dial hand on the rev counter and the line on
                        \ the steering wheel

 JSR DrawRevCounter     \ Redraw the dial hand on the rev counter

                        \ We now draw the line on the steering wheel

 LDA steeringLo         \ Set T = steeringLo
 STA T

 LSR A                  \ Set the C flag to bit 0 of steeringLo (the sign bit)
                        \ which is set if we are steering left, or clear if we
                        \ are steering right

 PHP                    \ Store the C flag on the stack

 LDA #2                 \ Set A = 2, to use as the value of V to send to the
                        \ DrawDashboardLine routine (shallow slope, right and
                        \ down)

 BCS upda1              \ If bit 0 of steeringLo is set, skip the following
                        \ instruction

 LDA #5                 \ Bit 0 of steeringLo is clear, so set A = 5 to use
                        \ as the value of V to send to the DrawDashboardLine
                        \ routine (shallow slope, left and down)

.upda1

 STA V                  \ Set V = A, which we will pass to the DrawDashboardLine
                        \ routine

 LDA steeringHi         \ Set A = steeringHi, so (A T) = (steeringHi steeringLo)

 ASL T                  \ Set (A T) = (A T) << 1
 ROL A                  \
                        \ setting the C flag to the top bit of (A T)

 BCS upda2              \ If the C flag is set, skip the following four
                        \ instructions to set A = 60, as the wheel is turned so
                        \ much that the indicator would be off the bottom of the
                        \ screen

 CMP #38                \ If A < 38, jump to upda4
 BCC upda4

 CMP #61                \ If A < 61, i.e. 38 <= A <= 60, jump to upda3 to
 BCC upda3              \ skip the following instruction

.upda2

 LDA #60                \ Set A = 60, the maximum value of A, so when we fall
                        \ through into the next calculation, with the C flag
                        \ set, we set:
                        \
                        \   Y = ~A + 76 + C
                        \     = ~A + 76 + 1
                        \     = ~A + 1 + 76
                        \     = -A + 76
                        \     = -60 + 76
                        \     = 16

.upda3

                        \ If we get here then the indicator is a long way away
                        \ from the centre of the wheel, as A >= 38

 EOR #&FF               \ Set Y = ~A + 76 + C
 ADC #76                \       = ~A + 1 + 75 + C
 TAY                    \       = 75 - A        when 38 <= A <= 60
                        \         16            when A > 60
                        \
                        \ so Y is in the range 37 to 16, with higher values of A
                        \ giving lower values of A
                        \
                        \ This represents the distance between this value on the
                        \ steering wheel and the nearest quadrant

 STY T                  \ Set T = Y (in the range 37 to 16) to pass to the
                        \ DrawDashboardLine routine as the amount of slope error
                        \ for each step slong the main axis

 LDX wheelPixels,Y      \ Set X to the number of pixels that would be along the
                        \ long axis of the line if the line went all the way to
                        \ the centre of the wheel, given the value of Y above

 STX SS                 \ Set SS = X to pass to the DrawDashboardLine routine
                        \ as the cumulative amount of slope error that equates
                        \ to a pixel in the shorter axis

 JMP upda5              \ Jump to upda5

.upda4

                        \ If we get here then the indicator is not far away from
                        \ the centre of the wheel, as A < 38

 TAX                    \ Set X = A (in the range 0 to 37)
                        \
                        \ This represents the distance between this value on the
                        \ steering wheel and the nearest quadrant

 STX T                  \ Set T = X (in the range 0 to 37) to pass to the
                        \ DrawDashboardLine routine as the amount of slope error
                        \ for each step slong the main axis

 LDA V                  \ Flip bit 0 of V, to flip it from the first half of the
 EOR #1                 \ quadrant to the second half
 STA V

                        \ By this point, V has the following value, which we
                        \ pass to the DrawDashboardLine routine
                        \
                        \   * 2 when sign bit of steeringLo is set and A >= 38
                        \     i.e. steering left a lot
                        \     Shallow slope, right and down
                        \
                        \   * 3 when sign bit of steeringLo is set and A < 38
                        \     i.e. steering left a little
                        \     Steep slope, right and down
                        \
                        \   * 4 when sign bit of steeringLo is clear and A < 38
                        \     i.e. steering right a little
                        \     Steep slope, left and down
                        \
                        \   * 5 when sign bit of steeringLo is clear and A >= 38
                        \     i.e. steering right a lot
                        \     Shallow slope, left and down
                        \
                        \ These are the opposite way round to the rev counter
                        \ hand, which is also drawn by the DrawDashboardLine
                        \ routine - this is because the rev counter hand is
                        \ drawn from the centre outwards, while the steering
                        \ wheel line is drawn from the outside in

 LDA wheelPixels,X      \ Set A to the number of pixels that would be along the
                        \ long axis of the line if the line went all the way to
                        \ the centre of the wheel, given the value of Y above

 STA SS                 \ Set SS = A to pass to the DrawDashboardLine routine
                        \ as the cumulative amount of slope error that equates
                        \ to a pixel in the shorter axis

.upda5

 ASL A                  \ Set A = A * 2 + 4
 CLC
 ADC #4

 EOR #&FF               \ Set Y = ~A
 TAY

 TXA                    \ Set A = X
                        \
                        \ where X is either the original value of A (0 to 37)
                        \ or the Y-th value of wheelPixels (where Y is 16 to
                        \ 37), which is in the range 38 to 51
                        \
                        \ In effect, this is the horizontal distance of the
                        \ steering line from the centre point

 PLP                    \ Set the C flag to bit 0 of steeringLo (the sign bit),
                        \ which we stored on the stack above

 BCC upda6              \ If bit 0 of steeringLo is clear, we are steering to
                        \ the right, so skip the following instruction

 EOR #&FF               \ Set A = ~A
                        \       = -A - 1
                        \
                        \ so the following addition becomes:
                        \
                        \   A = A + 80
                        \     = -A - 1 + 80
                        \     = 79 - A

.upda6

 CLC                    \ Set A = A + 80
 ADC #80                \
                        \ which turns A into the position on the steering wheel
                        \ where 80 is the centre point at the top middle of the
                        \ wheel

 STA W                  \ Set W = A, so W contains the position on the steering
                        \ wheel

 AND #%11111100         \ Clear bits 0 and 1 of A, to set A = A div 4

 JSR GetScreenAddress   \ Set (Q P) to the screen address for pixel coordinate
                        \ (A, Y), setting Y to the pixel row within the
                        \ character block containing the pixel (both of which we
                        \ pass to the DrawDashboardLine routine)

 LDA W                  \ Set W = W * 2 mod 8
 ASL A                  \
 AND #%00000111         \ This takes the x-coordinate of the line on the
 STA W                  \ steering wheel, doubled so we have 160 in the centre
                        \ of the steering wheel (so it matches the coordinates
                        \ in mode 5), and then we look at bits 0 to 2 only to
                        \ get the starting pixel to pass to DrawDashboardLine

 LDA #%100              \ Set H = %100, so the DrawDashboardLine looks up values
 STA H                  \ from the second half of the pixelByte and yLookup+8
                        \ tables (so the line is drawn on black rather than
                        \ white)

 LDA #6                 \ Set U = 6, so the line contains up to seven pixels
 STA U

 JSR DrawDashboardLine  \ Draw the dashboard line

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DrawRevCounter
\       Type: Subroutine
\   Category: Graphics
\    Summary: Draw the hand on the rev counter
\
\ ******************************************************************************

.DrawRevCounter

 LDA #%000              \ Set H = %000 to pass into DrawDashboardLine below
 STA H

 LDA revs               \ Set A = revs, which is the value we want to draw on
                        \ the rev counter, in the range 0 to 170

 CMP #30                \ If A >= 30, skip the following instruction
 BCS revs1

 LDA #30                \ Set A = 30, so A is always at least 30, and is now in
                        \ the range 30 to 170 (we do this because the hand on
                        \ the rev counter doesn't fall all the way back to zero)

.revs1

 STA T                  \ Set T = A

 LSR A                  \ Set A = A / 2 + T
 CLC                    \       = A / 2 + A
 ADC T                  \       = 1.5 * A
                        \       = 1.5 * revs
                        \
                        \ which is in the range 45 to 255

 ROR A                  \ Set A = A / 2
                        \       = 0.75 * revs
                        \
                        \ which is in the range 22 to 127

                        \ We now convert the value in A to the corresponding
                        \ position on the dial in terms of which quadrant it's
                        \ in, and which half of that quadrant, so we can pass
                        \ the details to the DrawDashboardLine routine

 SEC                    \ Set A = A - 76
 SBC #76

 BCS revs2              \ If the subtraction went past zero, add 152, to get:
 ADC #152               \
                        \   A = A + 76

                        \ So for A in the range 22 to 127, this converts:
                        \
                        \   A = 22-75  into A = 98-151
                        \   A = 76-127 into A = 0-51
                        \
                        \ If we consider a clock with 0 at 12 o'clock, then 38
                        \ at 3 o'clock, 76 at 6 o'clock and 114 at 9 o'clock,
                        \ A is now the position of the hand on that clock, i.e.
                        \ the position of the hand that we want to draw on the
                        \ rev counter

.revs2

                        \ We now calculate the quadrant that contains the hand
                        \ on the rev counter, numbered 0 to 3 counting clockwise
                        \ from top-right
                        \
                        \ We do this by calculating X = A / 38, by repeatedly
                        \ subtracting 38 from A until we go past zero

 LDX #&FF               \ We start by setting X = -1

 SEC                    \ Set the C flag for the subtraction

.revs3

 INX                    \ Increment X as we are doing a subtraction

 SBC #38                \ Set A = A - 38

 BCS revs3              \ If the subtraction didn't take us past zero, loop back
                        \ to subtract another 38

 ADC #38                \ Otherwise add the 38 back that pushed us over the
                        \ limit, so X now contains the quadrant number, and A
                        \ contains the remainder (i.e. the fraction that the
                        \ hand is past the start of the quadrant)

 CMP #19                \ If the remainder is < 19, skip the following, as A
 BCC revs4              \ contains the distance from the start of quadrant X to
                        \ the position of the hand (and the C flag is clear)

 SBC #19                \ Set A = ~(A - 19) + 20
 EOR #&FF               \       = ~(A - 19) + 1 + 19
 CLC                    \       = -(A - 19) + 19
 ADC #20                \       = 19 - (A - 19)
                        \
                        \ so A now contains the distance from the hand to the
                        \ end of quadrant X

 SEC                    \ Set the C flag to indicate that A is now the distance
                        \ from the hand to the end of the quadrant

.revs4

                        \ By this point:
                        \
                        \   X = quadrant number (0 to 3)
                        \
                        \   A = distance from start of quadrant to hand (C = 0)
                        \       distance from hand to end of quadrant   (C = 1)
                        \
                        \ where each quadrant is 38 in size, so A is <= 19
                        \
                        \ The C flag therefore represents which half of the
                        \ quadrant the hand is in, 0 denoting the first half and
                        \ 1 denoting the second half

 TAY                    \ Set Y = the distance between the hand and quadrant

 STY T                  \ Set T = the distance between the hand and quadrant

 TXA                    \ Ensure X is in the range 0 to 3 (it should be, but
 AND #3                 \ this makes absolutely sure)
 TAX

 TXA                    \ This sets bits 1 and 2 of V to the quadrant number,
 ROL A                  \ and bit 0 to the C flag, so the possible values are:
 STA V                  \
                        \   * 0 = %000 = Quadrant 0, first half, 12:00 to 1:30
                        \   * 1 = %001 = Quadrant 0, second half, 1:30 to 3:00
                        \   * 2 = %010 = Quadrant 1, first half, 3:00 to 4:30
                        \   * 3 = %011 = Quadrant 1, second half, 4:30 to 6:00
                        \   * 4 = %100 = Quadrant 2, first half, 6:00 to 7:30
                        \   * 5 = %101 = Quadrant 2, second half, 7:30 to 9:00
                        \   * 6 = %110 = Quadrant 3, first half, 9:00 to 10:30
                        \   * 7 = %111 = Quadrant 3, second half, 10:30 to 12:00
                        \
                        \ These are the quadrant values we need to pass to the
                        \ DrawDashboardLine routine below

 AND #%11111100         \ If bit 2 of A is zero, then the hand is in the right
 BEQ revs5              \ half of the dial, so jump to revs5 to set W = 0

 LDA #7                 \ Otherwise the hand is in the left half of the dial,
                        \ so set A so we set W = 7 below

.revs5

 STA W                  \ Set W = 0 if the hand is in the right half
                        \         7 if the hand is in the left half
                        \
                        \ so we start drawing from the leftmost pixel when
                        \ drawing to the right, or the rightmost pixel when
                        \ drawing to the left (which ensures that the hand joins
                        \ the centre spoke of the rev counter without a gap)

 LDA handPixels,Y       \ Set A to the number of pixels that are along the long
                        \ axis of the hand, given the distance between the hand
                        \ and quadrant that we set in Y above

 STA SS                 \ Set SS to the number of pixels along the long axis

 STA U                  \ Set U to the number of pixels along the long axis, to
                        \ pass through to the DrawDashboardLine routine below

 LDA startDialLo,X      \ Set the low byte of (Q P) to the low byte of the
 AND #%11111000         \ screen address for the starting point of the hand for
 STA P                  \ quadrant Y, which we get from the startDialLo table,
                        \ and clear bits 0 to 2 so the address points to the
                        \ top line of the relevant character block

 LDA startDialLo,X      \ Set Y to the pixel row within the character block
 AND #%00000111         \ for the starting point, which we get from bits 0 to 2
 TAY                    \ of the starting point's screen address

 LDA startDialHi,X      \ Set the high byte of (Q P) to the high byte of the
 STA Q                  \ screen address for the starting point of the hand for
                        \ quadrant Y, so (Q P) now contains the full address of
                        \ the starting point's character block

                        \ Fall through into DrawDashboardLine to draw a line
                        \ from the starting point given in (Q P) and Y, in the
                        \ direction given in V, with U pixels along the longest
                        \ axis, and in the half of the dial given in W

\ ******************************************************************************
\
\       Name: DrawDashboardLine
\       Type: Subroutine
\   Category: Graphics
\    Summary: Draw a hand on the rev counter or a line on the steering wheel
\
\ ------------------------------------------------------------------------------
\
\ This routine is a mode 5 Bresenham line-drawing routine, which modifies itself
\ to cater for lines of different slopes.
\
\ Arguments:
\
\   V                   The slope of the line to draw, which is expressed as a
\                       quadrant number, where quadrant 0 is from 12 o'clock to
\                       3 o'clock, with quadrants ordered 0 to 3 in a clockwise
\                       order:
\
\                         * 0 = %000 = Quadrant 0, first half (12:00 to 1:30)
\                                      Steep slope, right and up
\                                      Step up along y-axis (stepAxis = DEY)
\                                      Move right along x-axis (shortAxis = INX)
\
\                         * 1 = %001 = Quadrant 0, second half (1:30 to 3:00)
\                                      Shallow slope, right and up
\                                      Step right along x-axis (stepAxis = INX)
\                                      Move up along y-axis (shortAxis = DEY)
\
\                         * 2 = %010 = Quadrant 1, first half (3:00 to 4:30)
\                                      Shallow slope, right and down
\                                      Step right along x-axis (stepAxis = INX)
\                                      Move down along y-axis (shortAxis = INY)
\
\                         * 3 = %011 = Quadrant 1, second half (4:30 to 6:00)
\                                      Steep slope, right and down
\                                      Step down along y-axis (stepAxis = INY)
\                                      Move right along x-axis (shortAxis = INX)
\
\                         * 4 = %100 = Quadrant 2, first half (6:00 to 7:30)
\                                      Steep slope, left and down
\                                      Step down along y-axis (stepAxis = INY)
\                                      Move left along x-axis (shortAxis = DEX)
\
\                         * 5 = %101 = Quadrant 2, second half (7:30 to 9:00)
\                                      Shallow slope, left and down
\                                      Step left along x-axis (stepAxis = DEX)
\                                      Move down along y-axis (shortAxis = INY)
\
\                         * 6 = %110 = Quadrant 3, first half (9:00 to 10:30)
\                                      Shallow slope, left and up
\                                      Step left along x-axis (stepAxis = DEX)
\                                      Move up along y-axis (shortAxis = DEY)
\
\                         * 7 = %111 = Quadrant 3, second half (10:30 to 12:00)
\                                      Steep slope, left and up
\                                      Step up along y-axis (stepAxis = DEY)
\                                      Move left along x-axis (shortAxis = DEX)
\
\   (Q P)               The screen address of the character block containing
\                       the line's starting point
\
\   Y                   The pixel row within the character block containing the
\                       line's starting point (0 to 7)
\
\   U                   The number of pixels to step along the step axis:
\
\                         * The number of pixels along the longer (step) axis
\                           when drawing the rev counter
\
\                         * 6 when drawing the steering wheel line
\
\   T                   The slope error for each step along the step axis is
\                       T/SS, and T is set to:
\
\                         * The distance between the hand and quadrant when
\                           drawing the rev counter hand
\
\                         * When drawing the steering wheel line:
\
\                           0-37 when the line is close to the centre (in the
\                           top two quadrants either side of the centre)
\
\                           37-16 when line is further from the centre (in the
\                           left and right quadrants)
\
\   SS                  The slope error for each step along the step axis is
\                       T/SS, and SS is set to:
\
\                         * The same as U when drawing the rev counter hand
\                           i.e. the number of pixels along the longer (step)
\                           axis
\
\                         * A value from wheelPixels when drawing the steering
\                           wheel line (38 to 53)
\
\   H                   The starting index to use in the pixelByte and yLookup+8
\                       lookup tables:
\
\                         * %000 when drawing the rev counter hand, so the line
\                           gets drawn in white
\
\                         * %100 when drawing the steering wheel line, so the
\                           line gets drawn in black
\
\   W                   The pixel number (0-7) of the first pixel to draw
\                       along the x-axis
\
\ ******************************************************************************

.DrawDashboardLine

 LDX V                  \ Modify the instruction at dlin2 to the V-th shortAxis
 LDA shortAxis,X        \ instruction
 STA dlin2

 LDA stepAxis,X         \ Modify the instruction at dlin8 to the V-th stepAxis
 STA dlin8              \ instruction

                        \ The following code has the instructions for V = %010,
                        \ which has INY at dlin2 for the short axis, and INX at
                        \ dlin8 for the step axis, so that's this kind of line:
                        \
                        \   * Quadrant 1, first half (3:00 to 4:30)
                        \   * Shallow slope, right and down
                        \   * Step right along x-axis (stepAxis = INX)
                        \   * Move down along y-axis (shortAxis = INY)

 LDX W                  \ Set X = W, so X contains the position of the current
                        \ pixel within the pixel row, if there were eight pixels
                        \ per row

 LDA #0                 \ Set A = -SS
 SEC                    \
 SBC SS                 \ So this is the starting point for our slope error
                        \ calculation

 CLC                    \ Clear the C flag for the following addition

.dlin1

                        \ We use A to keep track of the slope error, adding the
                        \ step along the smaller axis (in T) until it reaches 0,
                        \ at which point it is a multiple of SS and we need
                        \ to move one pixel along the smaller axis

 ADC T                  \ Set A = A + T
                        \
                        \ So A is updated with the slope error

 BCC dlin3              \ If the addition didn't overflow, then the result in A
                        \ is still negative, so skip the following instruction

                        \ The slope error just overflowed (in other words, the
                        \ cumulative slope error in A just reached a multiple of
                        \ SS), so we need to adjust the slope error to make
                        \ it negative again, and we need to step along the
                        \ shorter axis

 SBC SS                 \ Subtract SS from the cumulative slope error to
                        \ bring it back to being negative, so we can detect when
                        \ it reaches next multiple of SS

.dlin2

 INY                    \ Increment Y to move down along the y-axis (i.e. along
                        \ the shorter axis)
                        \
                        \ This instruction is modified at the start of this
                        \ routine, depending on the slope of the line in V

.dlin3

 STA II                 \ Store the updated slope error in II, so we can
                        \ retrieve it below, ready for the next iteration of the
                        \ drawing loop

 TXA                    \ X contains the position of the current pixel within
 LSR A                  \ the pixel row, in the range 0 to 7, so set A to half
 AND #%00000011         \ this value to get the mode 5 pixel number (as there
                        \ are only four pixels per pixel byte on mode 5)

 ORA H                  \ Set bit 2 of A if this is the steering wheel, which
                        \ is the same as adding 4

 STA V                  \ Store the result in V, so V contains the pixel number
                        \ (0 to 3) of the pixel to draw, plus 4 if this is the
                        \ steering wheel (4 to 7)

 TXA                    \ X contains the position of the current pixel within
                        \ the pixel line, so put this in A

 BPL dlin4              \ If bit 7 of A is clear, jump to dlin4

                        \ Otherwise we need to move (Q P) to the previous
                        \ character block to the left, by subtracting 8 (as
                        \ there are 8 bytes per character block)

 LDX #7                 \ Set X = 7 to set as the new value of W below

 LDA P                  \ Set (Q P) = (Q P) - 8
 SEC                    \
 SBC #8                 \ starting with the low bytes
 STA P

 BCS dlin5              \ And then the high bytes
 DEC Q

 BCS dlin5              \ This instruction has no effect, as we already passed
                        \ through the BCS above, which is presumably a bug (this
                        \ should perhaps be a BCC?)

.dlin4

 CMP #8                 \ If A < 8, jump to dlin5
 BCC dlin5

                        \ Otherwise we need to move (Q P) to the next character
                        \ block to the right, by adding 8 (as there are 8 bytes
                        \ per character block)

 LDX #0                 \ Set X = 0 to set as the new value of W below

 LDA P                  \ Set (Q P) = (Q P) + 8
 CLC                    \
 ADC #8                 \ starting with the low bytes
 STA P

 BCC dlin5              \ And then the high bytes
 INC Q

.dlin5

 STX W                  \ Store X in W, so W moves along one pixel to the right

 LDX lineBufferSize     \ Set X to the size of the line buffer, which gives us
                        \ the index of the next empty space in the buffer

 TYA                    \ Y contains the number of the pixel row within the
                        \ current character block, so put this in A

 BPL dlin6              \ If A >=0, jump to dlin6

                        \ Otherwise we need to move (Q P) to the next character
                        \ row above, by subtracting &140 (as there are &140
                        \ bytes per character row)

 LDA P                  \ Set (Q P) = (Q P) - &140
 SEC                    \
 SBC #&40               \ starting with the high bytes
 STA P

 LDA Q                  \ And then the low bytes
 SBC #&01
 STA Q

 LDY #7                 \ Set Y = A = 7 as the new value of Y
 TYA

 BNE dlin7              \ Jump to dlin7 (this BNE is effectively a JMP as A is
                        \ never zero)

.dlin6

 CMP #8                 \ If A < 8, jump to dlin7
 BCC dlin7

                        \ Otherwise we need to move (Q P) to the next character
                        \ row below, by adding &140 (as there are &140 bytes per
                        \ character row)

 LDA P                  \ Set (Q P) = (Q P) + &140
 CLC                    \
 ADC #&40               \ starting with the high bytes
 STA P

 LDA Q                  \ And then the low bytes
 ADC #&01
 STA Q

 LDY #0                 \ Set Y = A = 0 as the new value of Y
 TYA

.dlin7

                        \ We now store the details of the pixel we are about
                        \ to overwrite in the line buffer, which stores a screen
                        \ address plus the original contents of that address
                        \
                        \ We get the screen address by adding the address of the
                        \ character block in P to the number of the pixel row
                        \ within the character in A, which we can do with an ORA
                        \ as P only occupies bits 3 to 7, while A only occupies
                        \ bits 0 to 2

 ORA P                  \ Store the address we are about to overwrite in the
 STA lineBufferAddrLo,X \ next empty space at the end of the line buffer, i.e.
                        \ the X-th byte of (lineBufferAddrHi lineBufferAddrLo),
                        \ starting with the low byte of the address

 LDA Q                  \ And then the high byte of the address
 STA lineBufferAddrHi,X

 LDA (P),Y              \ Store the current pixel contents into the pixel
 STA lineBufferPixel,X  \ contents buffer at lineBufferPixel

 INC lineBufferSize     \ Increment the size of the pixel buffers, as we just
                        \ added an entry

 LDX V                  \ Set X = V, so X now contains the pixel number
                        \ (0 to 3) of the pixel to draw, plus 4 if this is the
                        \ steering wheel (4 to 7)

 AND yLookupLo+8,X      \ Apply the bit mask from yLookup+8, so this clears the
                        \ X-th pixel in the pixel row (the table contains the
                        \ same bytes in 0 to 3 as in 0 to 7)

 ORA pixelByte,X        \ OR with a pixel byte with pixel X set, so this sets
                        \ the X-th pixel to colour 2 (white) if X is 0 to 3, or
                        \ colour 0 (black) if X is 4 to 7 - so the rev counter
                        \ hand is white, while the steering wheel line is black

 STA (P),Y              \ Draw the pixel byte to the screen

                        \ We now set up all the variables so we can loop back
                        \ to dlin1 for the next pixel

 LDX W                  \ Set X = W

 LDA II                 \ Set A to the current slope error, which we stored in
                        \ II above

 CLC                    \ Clear the C flag for the addition at the start of the
                        \ loop

.dlin8

 INX                    \ Increment X to step right along the x-axis (i.e. along
                        \ the longer axis)
                        \
                        \ This instruction is modified at the start of this
                        \ routine, depending on the slope of the line in V

 DEC U                  \ Decrement the pixel counter

 BMI dlin9              \ If we have drawn the correct number of pixels along
                        \ the longer axis, jump to dlin9 to return from the
                        \ subroutine as we have finished drawing the line

 JMP dlin1              \ Otherwise loop back to draw the next pixel

.dlin9

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: AnimateTyres
\       Type: Subroutine
\   Category: Screen mode
\    Summary: Update screen memory to animate the tyres
\
\ ******************************************************************************

.AnimateTyres

 INC irqCounter         \ Increment irqCounter, so it gets incremented every
                        \ time the IRQ routine reaches section 4 of the custom
                        \ screen

 LDA speedHi            \ Set tyreTravel = tyreTravel + speedHi + 48
 CLC
 ADC #48
 ADC tyreTravel
 STA tyreTravel

 BCC tyre4              \ If the addition didn't overflow, jump to tyre4 to
                        \ return from the subroutine

 LDA carMoving          \ If carMoving = 0 then the car is not moving and we
 BEQ tyre4              \ don't need to animate the tyres, so jump to tyre4 to
                        \ return from the subroutine

 LDX #4                 \ Set a loop counter to go from 4 to 0

.tyre1

 LDA tyreLeft3,X        \ Set tyreLeft3 = tyreLeft3 EOR tyreTread1
 EOR tyreTread1,X
 STA tyreLeft3,X

 LDA tyreRight3,X       \ Set tyreRight3 = tyreRight3 EOR tyreTread2
 EOR tyreTread2,X
 STA tyreRight3,X

 CPX #3                 \ If X >= 3, jump to tyre2 to skip the following
 BCS tyre2

 LDA tyreLeft1,X        \ Flip the top four bits of tyreLeft1
 EOR #%11110000
 STA tyreLeft1,X

 LDA tyreRight2,X       \ Flip the top four bits of tyreRight2
 EOR #%11110000
 STA tyreRight2,X

 BNE tyre3              \ If A is non-zero, jump to tyre3 to continue the loop

.tyre2

 LDA tyreLeft2,X        \ Flip bits 6 and 7 of tyreLeft2
 EOR #%11000000
 STA tyreLeft2,X

 LDA tyreRight1,X       \ Flip bits 4 and 5 of tyreRight1
 EOR #%00110000
 STA tyreRight1,X

.tyre3

 DEX                    \ Decrement the loop counter

 BPL tyre1              \ Loop back to 

.tyre4

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: tyreTread1
\       Type: Variable
\   Category: Screen mode
\    Summary: Tyre tread pattern
\
\ ******************************************************************************

.tyreTread1

 EQUB &F0, &F0, &C0, &C0, &80

\ ******************************************************************************
\
\       Name: tyreTread2
\       Type: Variable
\   Category: Screen mode
\    Summary: Tyre tread pattern
\
\ ******************************************************************************

.tyreTread2

 EQUB &F0, &F0, &30, &30, &10

\ ******************************************************************************
\
\       Name: trackData
\       Type: Variable
\   Category: Track
\    Summary: This is where the track data gets loaded
\
\ ------------------------------------------------------------------------------
\
\ See the track source in revs-silverstone.asm for details of the track data. It
\ covers trackData and dashData41 - the latter gets moved into screen memory as
\ part of the memory-moving process in the SwapData routine.
\
\ ******************************************************************************

.trackData

 SKIP 1610

\ ******************************************************************************
\
\       Name: dashData41
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\  Deep dive: The jigsaw puzzle binary
\
\ ******************************************************************************

.dashData41

 SKIP 67

 SKIP 149

\ ******************************************************************************
\
\       Name: CallTrackHook
\       Type: Subroutine
\   Category: Setup
\    Summary: The track file's hook code
\
\ ******************************************************************************

.CallTrackHook

 BRK                    \ The SwapCode routine replaces these three bytes with
 BRK                    \ the three bytes from just before the trackChecksum in
 BRK                    \ the track file, which contain the three bytes of hook
                        \ code for the track
                        \
                        \ In the default Silverstone track that comes with the
                        \ original version of Revs, the three bytes of hook code
                        \ contain the following:
                        \
                        \   RTS
                        \   NOP
                        \   NOP
                        \
                        \ so calling this routine does nothing (see the track
                        \ source in the revs-silverstone.asm file for details)
                        \
                        \ Other track files, such as those in the Revs 4 Tracks
                        \ expansion pack, contain JMP instructions in their hook
                        \ code, which allows the track authors to hook in entire
                        \ routines that get called when those tracks are loaded

\ ******************************************************************************
\
\       Name: AwardRacePoints
\       Type: Subroutine
\   Category: Drivers
\    Summary: Award points following a race
\
\ ------------------------------------------------------------------------------
\
\ This routine awards points to a driver for finishing in the top six in a race,
\ or for getting the fastest lap time. The points awarded are based on the
\ driver's race position, as per the pointsForPlace table:
\
\   * 9 points for first place
\   * 6 points for second place
\   * 4 points for third place
\   * 3 points for fourth place
\   * 2 points for fifth place
\   * 1 point for sixth place
\   * 1 point for the fastest lap
\
\ In single-player races, the points are awarded as above.
\
\ In multi-player races, an algorithm is used to share out the points in a way
\ that takes the relative skills into consideration. Specifically, the routine
\ awards this many points:
\
\   (U T) * the points from the above list
\
\ This is how (U T) is calculated:
\
\ * Single-player race:
\
\   (U T) = numberOfPlayers = 1, so we award the amount of points shown above
\
\ * Multi-player race:
\
\   If we are awarding points to the current player:
\
\       (U T) = (numberOfPlayers - 1) * numberOfPlayers
\
\   If we are awarding points to a human player but not the current player:
\
\       (U T) = numberOfPlayers
\
\   If we are awarding points to a computer driver:
\
\       (U T) = (numberOfPlayers - 1) * 2
\
\ I have no idea why the algorithm works like this. It needs more analysis!
\
\ Arguments:
\
\   X                   The race position to award points to:
\
\                         * 0 to 5 for the first six places
\
\                         * 6 for the fastest lap
\
\ ******************************************************************************

.AwardRacePoints

 LDA #0                 \ Zero the points in (racePointsHi racePointsLo) for
 STA racePointsLo,X     \ race position X
 STA racePointsHi,X

 STA U                  \ Set U = 0, to act as the high byte of (U T)

 LDY driversInOrder,X   \ Set Y to the number of the driver in race position X

 CPX #6                 \ If we called the routine with X = 0 to 5, then jump to
 BNE poin1              \ poin1 to skip the following instruction

 LDY driversInOrder     \ We called the routine with X = 6, so set Y to the
                        \ winning driver's number, i.e. the driver with the
                        \ fastest lap

.poin1

                        \ By this point, Y contains the number of the driver we
                        \ want to give the points to, so now we calculate the
                        \ number of points to award

 LDA numberOfPlayers    \ Set A to the number of players - 1
 SEC
 SBC #1

 BEQ poin3              \ If A = 0 then there is only one player, so jump to
                        \ poin3 to skip the following

 CPY currentPlayer      \ If Y is the number of the current player, jump to
 BEQ poin2              \ poin2

 CPY lowestPlayerNumber \ If Y >= lowestPlayerNumber then this is a human
 BCS poin3              \ player but not the current player, so jump to poin3

                        \ If we get here then we are awarding points to a
                        \ computer-controlled driver

 ASL A                  \ Double the value of A, to use as the value of T, so
                        \ we will get:
                        \
                        \   (U T) = (0 T)
                        \         = T
                        \         = A * 2
                        \         = (numberOfPlayers - 1) * 2

 BNE poin4              \ Jump to poin4 (this BNE is effectively a JMP, as A is
                        \ never zero)

.poin2

                        \ If we get here then we are awarding points to the
                        \ current player

 STA U                  \ Set U = A = numberOfPlayers - 1

 LDA numberOfPlayers    \ Set A = numberOfPlayers

 JSR Multiply8x8        \ Set (A T) = A * U
                        \           = (numberOfPlayers - 1) * numberOfPlayers

 STA U                  \ Set (U T) = (A T)
                        \           = (numberOfPlayers - 1) * numberOfPlayers

 JMP poin5              \ Jump to poin5

.poin3

                        \ If we get here then either there is only one player,
                        \ or we are awarding points to a human player but not
                        \ the current player

 LDA numberOfPlayers    \ Set A to the number of players, to use as the value of
                        \ T, so we will get:
                        \
                        \   (U T) = (0 T)
                        \         = (0 numberOfPlayers)
                        \         = numberOfPlayers

 BNE poin4              \ This instruction has no effect as poin4 is the next
                        \ instruction anyway

.poin4

 STA T                  \ Store A in T, so this sets (U T) = (U A)

.poin5

 SED                    \ Set the D flag to switch arithmetic to Binary Coded
                        \ Decimal (BCD)

                        \ We now do the following addition 256 * U + T times, so
                        \ the total number of points added is:
                        \
                        \   (256 * U + T) * (9, 6, 4, 3, 2 or 1)
                        \
                        \ or putting it another way:
                        \
                        \   (U T) * (9, 6, 4, 3, 2 or 1)

.poin6

 LDA pointsForPlace,X   \ Add the X-th entry in pointsForPlace to the X-th entry
 CLC                    \ in (racePointsHi racePointsLo),  starting with the low
 ADC racePointsLo,X     \ bytes
 STA racePointsLo,X

 LDA racePointsHi,X     \ And then the high bytes
 ADC #0
 STA racePointsHi,X

 DEC T                  \ Decrement the counter in T

 BNE poin6              \ Loop back to poin6 so we do the addition a total of T
                        \ times

 DEC U                  \ Decrement the counter in U

 BPL poin6              \ Loop back to poin6 so we do an additional U loops,
                        \ with the inner loop repeating 256 times as T is now 0,
                        \ so this does a total of 256 * U additional additions

 JSR AddRacePoints      \ Add the race points from above to the accumulated
                        \ points for driver Y

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: L5E40
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

ORG &5E40

.L5E40

 SKIP 1

\ ******************************************************************************
\
\       Name: L5E41
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5E41

 SKIP 15

\ ******************************************************************************
\
\       Name: L5E50
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5E50

 SKIP 63

\ ******************************************************************************
\
\       Name: L5E8F
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5E8F

 SKIP 1

\ ******************************************************************************
\
\       Name: L5E90
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5E90

 SKIP 1

\ ******************************************************************************
\
\       Name: L5E91
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5E91

 SKIP 15

\ ******************************************************************************
\
\       Name: L5EA0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5EA0

 SKIP 24

\ ******************************************************************************
\
\       Name: L5EB8
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5EB8

 SKIP 39

\ ******************************************************************************
\
\       Name: L5EDF
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5EDF

 SKIP 1

\ ******************************************************************************
\
\       Name: L5EE0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5EE0

 SKIP 1

\ ******************************************************************************
\
\       Name: L5EE1
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5EE1

 SKIP 23

\ ******************************************************************************
\
\       Name: L5EF8
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5EF8

 SKIP 8

\ ******************************************************************************
\
\       Name: L5F00
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5F00

 SKIP 32

\ ******************************************************************************
\
\       Name: L5F20
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5F20

 SKIP 1

\ ******************************************************************************
\
\       Name: L5F21
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5F21

 SKIP 23

\ ******************************************************************************
\
\       Name: numberOfPlayers
\       Type: Variable
\   Category: Drivers
\    Summary: The number of players
\
\ ******************************************************************************

.numberOfPlayers

 SKIP 1

\ ******************************************************************************
\
\       Name: lowestPlayerNumber
\       Type: Variable
\   Category: Drivers
\    Summary: The number of the player with the lowest player number
\
\ ******************************************************************************

.lowestPlayerNumber

 SKIP 1                 \ Contains 20 minus the number of players, so that's:
                        \
                        \   * 19 if there is one player
                        \   * 18 if there are two players
                        \
                        \ and so on, down to 0 if there are 20 players
                        \
                        \ Human players take the place of drivers with higher
                        \ numbers, so the first player takes the place of driver
                        \ 19 (the aptly called Dummy Driver, as they never get
                        \ to race), and the second player takes the place of
                        \ driver 18 (Peter Out), the third player replaces
                        \ driver 17 (Rick Shaw) and so on
                        \
                        \ So this not only represents the lowest player number,
                        \ but also the highest non-human driver number (which is
                        \ lowestPlayerNumber - 1)

\ ******************************************************************************
\
\       Name: raceClass
\       Type: Variable
\   Category: Drivers
\    Summary: The class of the current race
\
\ ******************************************************************************

.raceClass

 SKIP 1                 \ The class of race:
                        \
                        \   * 0 = Novice
                        \
                        \   * 1 = Amateur
                        \
                        \   * 2 = Professional

\ ******************************************************************************
\
\       Name: qualifyingTime
\       Type: Variable
\   Category: Drivers
\    Summary: The number of minutes of qualifying lap time
\
\ ******************************************************************************

.qualifyingTime

 SKIP 1                 \ The number of minutes of qualifying lap time, minus
                        \ one, as follows:
                        \
                        \   * 4 gives us 5 minutes of qualifying time
                        \
                        \   * 9 gives us 10 minutes of qualifying time
                        \
                        \   * 25 gives us 26 minutes of qualifying time
                        \
                        \   * 255 gives us infinite time (for practice)
                        \
                        \ Note that the third value should be 19 to match the
                        \ menu option of 20 minutes, but the value in the
                        \ timeFromOption table is incorrect

\ ******************************************************************************
\
\       Name: competitionStarted
\       Type: Variable
\   Category: Drivers
\    Summary: A flag to indicate whether or not the competition has started
\
\ ******************************************************************************

.competitionStarted

 SKIP 1                 \ Flag to indicate whether the competition has started:
                        \
                        \   * 0 = the competition has not started
                        \
                        \   * Non-zero = the competition has started

\ ******************************************************************************
\
\       Name: frontWingSetting
\       Type: Variable
\   Category: Driving model
\    Summary: The front wing setting, as entered by the player
\
\ ******************************************************************************

.frontWingSetting

 SKIP 1

\ ******************************************************************************
\
\       Name: rearWingSetting
\       Type: Variable
\   Category: Driving model
\    Summary: The rear wing setting, as entered by the player
\
\ ******************************************************************************

.rearWingSetting

 SKIP 1

\ ******************************************************************************
\
\       Name: lapsMenuOption
\       Type: Variable
\   Category: Drivers
\    Summary: The menu option chosen from the laps menu (0 to 2)
\
\ ******************************************************************************

.lapsMenuOption

 SKIP 1

\ ******************************************************************************
\
\       Name: baseSpeed
\       Type: Variable
\   Category: Drivers
\    Summary: The base speed for each car, copied from the track data
\
\ ******************************************************************************

.baseSpeed

 SKIP 1                 \ The base speed for each car, which is faster with a
                        \ higher class of race (this value is taken from the
                        \ track data at trackData+&714):
                        \
                        \   * 134 = Novice
                        \
                        \   * 146 = Amateur
                        \
                        \   * 152 = Professional

 SKIP 7

\ ******************************************************************************
\
\       Name: L5F48
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5F48

 SKIP 24

\ ******************************************************************************
\
\       Name: L5F60
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5F60

 SKIP 80

\ ******************************************************************************
\
\       Name: L5FB0
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L5FB0

 SKIP 32

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

IF _ACORNSOFT

 EQUB &6F

ELIF _SUPERIOR

 EQUB &30

ENDIF

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

IF _ACORNSOFT

 EQUB &6E

ELIF _SUPERIOR

 EQUB &18

ENDIF

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

IF _ACORNSOFT

 EQUB &32

ELIF _SUPERIOR

 EQUB &0C

ENDIF

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

IF _ACORNSOFT

 EQUB 0

ELIF _SUPERIOR

 EQUB 6

ENDIF

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

IF _ACORNSOFT

 EQUB &8D

ELIF _SUPERIOR

 EQUB 3

ENDIF

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

IF _ACORNSOFT

 EQUB &2B

ELIF _SUPERIOR

 EQUB &01

ENDIF

\ ******************************************************************************
\
\       Name: zeroIfYIs55
\       Type: Variable
\   Category: Graphics
\    Summary: A lookup table for zeroing Y if and only if it is &55
\
\ ******************************************************************************

.zeroIfYIs55

 FOR I%, 0, 255
  IF I% = &55
   EQUB 0
  ELSE
   EQUB I%
  ENDIF
 NEXT

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
\       Name: steeringLo
\       Type: Variable
\   Category: Driving model
\    Summary: The low byte of the steering wheel position
\
\ ------------------------------------------------------------------------------
\
\ The steering wheel position is stored as (steeringHi steeringLo), with the
\ sign bit in bit 0 of steeringLo, so it's a sign-magnitude number.
\
\ ******************************************************************************

.steeringLo

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
\       Name: steeringHi
\       Type: Variable
\   Category: Driving model
\    Summary: The high byte of the steering wheel position
\
\ ------------------------------------------------------------------------------
\
\ The steering wheel position is stored as (steeringHi steeringLo), with the
\ sign bit in bit 0 of steeringLo, so it's a sign-magnitude number.
\
\ ******************************************************************************

.steeringHi

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
\       Name: soundBuffer
\       Type: Variable
\   Category: Sound
\    Summary: Details of each sound channel's buffer status
\
\ ******************************************************************************

.soundBuffer

 EQUB 0, 0, 0, 0, 0, 0

\ ******************************************************************************
\
\       Name: characterDef
\       Type: Variable
\   Category: Text
\    Summary: Storage for a character definition when printing characters
\
\ ******************************************************************************

.characterDef

 EQUB 0                 \ The character number

 EQUB 0, 0, 0, 0        \ The eight bytes that make up the character definition,
 EQUB 0, 0, 0, 0        \ which gets populated by an OSWORD call

\ ******************************************************************************
\
\       Name: xCursor
\       Type: Variable
\   Category: Text
\    Summary: The cursor's x-coordinate, which can either be a pixel coordinate
\             or a character row
\
\ ******************************************************************************

.xCursor

 EQUB 0

\ ******************************************************************************
\
\       Name: yCursor
\       Type: Variable
\   Category: Text
\    Summary: The cursor's pixel y-coordinate
\
\ ------------------------------------------------------------------------------
\
\ In terms of printing text on-screen, we need to set:
\
\   * yCursor = 24 for the first line of text
\
\   * yCursor = 33 for the second line of text
\
\ See the notes on the yLookupHi variable for information about the values of
\ yCursor and how they relate to the custom screen.
\
\ ******************************************************************************

.yCursor

 EQUB 0

 EQUB 0, 0              \ These bytes appear to be unused

\ ******************************************************************************
\
\       Name: L62D0Lo
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D0Lo

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62D2Lo
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D2Lo

 EQUB 0

\ ******************************************************************************
\
\       Name: L62D3Lo
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D3Lo

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62D5Lo
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D5Lo

 EQUB 0

\ ******************************************************************************
\
\       Name: L62D6Lo
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D6Lo

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62D8Lo
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D8Lo

 EQUB 0

\ ******************************************************************************
\
\       Name: L62D9Lo
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62D9Lo

 EQUB 0

\ ******************************************************************************
\
\       Name: L62DAHi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62DAHi

 EQUB 0

\ ******************************************************************************
\
\       Name: L62DBHi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62DBHi

 EQUB 0

\ ******************************************************************************
\
\       Name: L62DCHi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62DCHi

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62DELo
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62DELo

 EQUB 0

\ ******************************************************************************
\
\       Name: L62DFHi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62DFHi

 EQUB 0

\ ******************************************************************************
\
\       Name: L62E0Hi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E0Hi

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62E2Hi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E2Hi

 EQUB 0

\ ******************************************************************************
\
\       Name: L62E3Hi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E3Hi

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62E5Hi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E5Hi

 EQUB 0

\ ******************************************************************************
\
\       Name: L62E6Hi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E6Hi

 EQUB 0

\ ******************************************************************************
\
\       Name: L62E7Hi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E7Hi

 EQUB 0

\ ******************************************************************************
\
\       Name: L62E8Hi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E8Hi

 EQUB 0

\ ******************************************************************************
\
\       Name: L62E9Hi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62E9Hi

 EQUB 0

\ ******************************************************************************
\
\       Name: L62EAHi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62EAHi

 EQUB 0

\ ******************************************************************************
\
\       Name: L62EBHi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62EBHi

 EQUB 0

\ ******************************************************************************
\
\       Name: L62ECHi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62ECHi

 EQUB 0, 0

\ ******************************************************************************
\
\       Name: L62EEHi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62EEHi

 EQUB 0

\ ******************************************************************************
\
\       Name: L62EFHi
\       Type: Variable
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.L62EFHi

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
\       Name: irqCounter
\       Type: Variable
\   Category: Screen mode
\    Summary: Counter that gets incremented every time the IRQ routine reaches
\             section 4 of the custom screen
\
\ ******************************************************************************

.irqCounter

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
\       Name: tyreTravel
\       Type: Variable
\   Category: Screen mode
\    Summary: Keeps track of how far we have travelled so we know when to
\             animate the tyres
\
\ ******************************************************************************

.tyreTravel

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
\       Name: GetTextInput
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Fetch a string from the keyboard, padded with spaces if required
\
\ ------------------------------------------------------------------------------
\
\ This routine fetches a string of characters from the keyboard and stores the
\ result in memory. The string is entered by pressing RETURN, at which point the
\ string in memory is padded with spaces so that it meets the required length.
\
\ The DELETE key is supported, leading spaces are ignored, and the ESCAPE key is
\ trapped and has no effect.
\
\ Arguments:
\
\   (Y A)               The address where the string should be stored
\
\   X                   The length of string that we require
\
\ Returns:
\
\   Y                   The number of characters entered, before any padding is
\                       applied
\
\ ******************************************************************************

.GetTextInput

 STA P                  \ Set (Q P) = (Y A)
 STY Q

 STX W                  \ Store the required length of input in W 

 LDA #2                 \ Call OSBYTE with A = 2 and X = 0 to select the 
 LDX #0                 \ keyboard as the input stream and disable RS423
 JSR OSBYTE

 LDA #21                \ Call OSBYTE with A = 21 and X = 0 to flush the
 LDX #0                 \ keyboard buffer
 JSR OSBYTE

.text1

 LDY #0                 \ Set Y = 0 to use as a counter for the number of
                        \ characters entered

.text2

 JSR OSRDCH             \ Call OSRDCH to read a character from the currently
                        \ selected input stream (i.e. the keyboard) into A

 BCS text7              \ If the call to OSRDCH set the C flag then there was an
                        \ error (probably caused by pressing ESCAPE), so jump to
                        \ text7 to process this

 CMP #13                \ If RETURN was pressed, jump to text9
 BEQ text9

 CMP #' '               \ If a control character was entered (i.e. with an ASCII
 BCC text2              \ code less than tyat of " "), jump back to text2 to
                        \ ignore it and wait for another key press

 BNE text3              \ If a key other than SPACE was pressed, jump to text3
                        \ skip the next two instructions

 CPY #0                 \ SPACE was pressed, so if no other characters have been
 BEQ text2              \ (i.e. Y = 0), jump back to text2 to ignore it

.text3

 CMP #127               \ If the character entered has an ASCII value < 127,
 BCC text4              \ jump to text4 to process it as a valid character

 BNE text2              \ If the character entered has an ASCII value > 127,
                        \ jump back to text2 to ignore it

                        \ If we get here then the DELETE key was pressed, which
                        \ has an ASCII value of 127

 DEY                    \ Decrement the number of characters entered in Y, to
                        \ process the deletion

 BPL text6              \ If Y is still positive, jump to text6 to print the
                        \ delete character, which will delete the last character
                        \ entered on-screen

 BMI text1              \ Y is negative, so we just deleted past the start of
                        \ the entered string, so jump to text1 to set Y to 0 and
                        \ start again (this BMI is effectively a JMP as we just
                        \ passed through a BPL)

.text4

                        \ If we get here then a valid character was entered

 CPY W                  \ If the number of characters entered in Y is not yet
 BNE text5              \ the required number in W, jump to text5 to store the
                        \ new character

 LDA #7                 \ Otherwise set A = 7 (the ASCII code for a beep) and
 BNE text6              \ jump to text6 to skip storing the new character and
                        \ make a beep, as we already have enough characters

.text5

                        \ If we get here then we have successfully fetched a new
                        \ character, so now we store it

 STA (P),Y              \ Store the character entered in the Y-th byte of (Q P)

 INY                    \ Increment the character counter in Y

.text6

 JSR OSWRCH             \ Print the character in A, which will either be the new
                        \ character, or a beep, or a delete

 JMP text2              \ Jump up to text2 to fetch the next character

.text7

                        \ If we get here then ESCAPE was pressed

 TYA                    \ Store the character count in Y on the stack
 PHA

 LDA #126               \ Call OSBYTE with A = 126 to acknowledge the ESCAPE
 JSR OSBYTE             \ condition

 PLA                    \ Retrieve the character count from the stack into Y
 TAY

 JMP text2              \ Jump up to text2 to fetch the next character

.text8

 INY                    \ We get here from below after appending a space to the
                        \ stored string, so we increment Y and repeat the
                        \ padding process until the string is full

.text9

                        \ If we get here then RETURN was pressed

 CPY W                  \ If the number of characters entered in Y is not yet
 BNE text10             \ the required number in W, jump to text10 to pad out
                        \ the string with spaces

 RTS                    \ Otherwise the string is the correct size, so we now
                        \ return from the subroutine

.text10

 LDA #' '               \ Append a space to the end of the stored string
 STA (P),Y

 BNE text8              \ Jump back to text8 to keep padding the string with
                        \ spaces (this BNE is effectively a JMP as A is never
                        \ zero)

\ ******************************************************************************
\
\       Name: SetDriverSpeed
\       Type: Subroutine
\   Category: Drivers
\    Summary: Set the speed for a specific driver
\
\ ------------------------------------------------------------------------------
\
\ The speed for a specific driver is based on a number of elements:
\
\   * A random element that is weighted to being small, but can sometimes be
\     larger
\
\   * The speed is affected by the driver's position on the grid: cars at the
\     front of the grid are faster than those at the back
\
\   * The speed is affected by the race class, with the range of different car
\     speeds in Professional races being tighter than in Amateur races, which
\     in turn are tighter than Novice races
\
\ This speed is then added to the track's base speed, which is stored as part of
\ the track data. The track's base speed is different depending on the race
\ class, so taking Silverstone as an example, we get these final ranges for the
\ front two cars:
\
\   * Novice       = 134 plus -28 to +28 = 106 to 162
\   * Amateur      = 146 plus -14 to +14 = 132 to 160
\   * Professional = 153 plus  -7 to  +7 = 146 to 160
\
\ and these final ranges for the two cars at the back:
\
\   * Novice       = 134 plus -46 to +8 =  88 to 142
\   * Amateur      = 146 plus -23 to +4 = 123 to 150
\   * Professional = 153 plus -12 to +2 = 141 to 155
\
\ So on Silverstone, the cars on the front of the grid in a Novice race can
\ actually be faster than those on the front of the grid in a Professional race,
\ though it's unlikely.
\
\ Arguments:
\
\   driverNumber        The number of the driver
\
\ Returns:
\
\   X                   The number of the previous driver
\
\ ******************************************************************************

.SetDriverSpeed

 LDX driverNumber       \ Set X to the driver number to initialise

                        \ We now start a lengthy calculation of a figure in A
                        \ that we will add to the track's base speed to
                        \ determine the speed for this driver, with a higher
                        \ figure in A giving the car a higher speed in the race

 LDA VIA+&68            \ Read 6522 User VIA T1C-L timer 2 low-order counter
                        \ (SHEILA &68), which will be a pretty random figure

 PHP                    \ Store the processor flags from the random timer value
                        \ on the stack

 AND #%01111111         \ Clear bit 0 of the random number in A, so A is now in
                        \ the range 0 to 127

                        \ The following calculates the following:
                        \
                        \   * If A is in the range 0 to 63, A = A mod 4
                        \
                        \   * If A is in the range 64 to 127, A = (A - 64) mod 7
                        \
                        \ Given that A starts out as a random number, this will
                        \ produce a random number with the following chances:
                        \
                        \   50% of the time, 25% chance of 0 to 3
                        \   50% of the time, 12.5% chance of 0 to 7
                        \
                        \ So the probability of getting each of the numbers from
                        \ 0 to 7 is:
                        \
                        \   0 to 3 = 0.5 * 0.25 + 0.5 * 0.125 = 0.1875 = 18.75%
                        \   4 to 7 = 0.5 * 0.125              = 0.0625 =  6.25%
                        \
                        \ So we're three times more likely to get a number in
                        \ the range 0 to 3 as in the range 4 to 7

 LDY #16                \ Set a loop counter in Y to subtract 16 lots of 4

.fast1

 CMP #4                 \ If A < 4, jump to fast3, as A now contains the
 BCC fast3              \ original value of A mod 4

 SBC #4                 \ A >= 4, so set A = A - 4

 DEY                    \ Decrement the loop counter

 BNE fast1              \ Loop back until we have either reduced A to be less
                        \ than 4, or we have subtracted 16 * 4 = 64

                        \ If we get here then the original A was 64 or more,
                        \ 64, and A is now in the range 0 to 63

 LDY #9                 \ Set a loop counter in Y to subtract 9 lots of 7

.fast2

 CMP #7                 \ If A < 7, jump to fast3, as A now contains the
 BCC fast3              \ original value of (A - 64) mod 7

 SBC #7                 \ A >= 7, so set A = A - 7

 DEY                    \ Decrement the loop counter

 BNE fast2              \ Loop back until we have either reduced A to be less
                        \ than 7, or we have subtracted 9 * 7 = 63

                        \ If we get here then the original A was 127, and we
                        \ first subtracted 64 and then 63 to give us 0

.fast3

                        \ We now have our random number in the range 0 to 7,
                        \ with 0 to 3 more likely than 4 to 7

 PLP                    \ Retrieve the processor flags from the random timer
                        \ value that we put on the stack above, which sets the
                        \ N flag randomly (amongst others)

 JSR Absolute8Bit       \ The first instruction of Absolute8Bit  is a BPL,
                        \ which normally skips negation for positive numbers,
                        \ but in this case it means the Absolute8Bit  routine
                        \ randomly changes the sign of A, so A is now in the
                        \ range -7 to +7, with -3 to +3 more likely than -7 to
                        \ -4 or 4 to 7

 ASL A                  \ Set A = A << 1, so A is now in the range -14 to +14,
                        \ with -6 to +6 more likely than -14 to -7 or 7 to 14

 SEC                    \ Set A = A - driverGridRow for this driver
 SBC driverGridRow,X    \
                        \ So A is left alone for the two cars at the front of
                        \ the grid, is reduced by 1 for the next two cars, and
                        \ is reduced by 9 for the two cars at the back

 STA T                  \ Set T = A

                        \ By this point, the value in A (and T) is in the range:
                        \
                        \   * -14 to +14 for the front two cars
                        \   * -15 to +13 for the next two cars
                        \     ...
                        \   * -23 to +4 for the last two cars
                        \
                        \ We now alter this according to the race class

 LDY raceClass          \ Set Y to the race class

 DEY                    \ Decrement Y, so it will be -1 for Novice, 0 for
                        \ Amateur and 1 for Professional

 BEQ fast5              \ If Y = 0 (Amateur), jump to fast5 to leave A alone

 BPL fast4              \ If Y = 1 (Professional), jump to fast4 to 

                        \ If we get here, then the race class is Novice

 ASL A                  \ Set A = A << 1
                        \
                        \ so A is now in the range:
                        \
                        \   * -28 to +28 for the front two cars
                        \   * -30 to +26 for the next two cars
                        \     ...
                        \   * -46 to +8 for the last two cars
                        \
                        \ This makes the range of speeds less tightly bunched,
                        \ so the race is less intense

 JMP fast5              \ Jump to fast5 to skip the following

.fast4

                        \ If we get here, then the race class is Professional

 ROL T                  \ Shift bit 7 of T into the C flag, and because T = A,
                        \ this puts bit 7 of A into the C flag

 ROR A                  \ Shift A right while inserting a copt of bit 7 into
                        \ bit 7, so this effectively divides A by two while
                        \ keeping the sign intact:
                        \
                        \   A = A / 2
                        \
                        \ So A is now in the range:
                        \
                        \   * -7 to +7 for the front two cars
                        \   * -8 to +6 for the next two cars
                        \     ...
                        \   * -12 to +2 for the last two cars
                        \
                        \ This makes the range of speeds more tightly bunched,
                        \ so the race is more intense

.fast5

                        \ By this point we have our value A, which determines
                        \ the speed of the driver based on our random number,
                        \ the car's grid position and the race class, so now we
                        \ add this to the track's base speed to get the driver's
                        \ speed for the race
                        \
                        \ The track's base speed is different depending on the
                        \ race class, so taking Silverstone as an example, we
                        \ get these final ranges for the front two cars:
                        \
                        \   * Novice       = 134 plus -28 to +28 = 106 to 162
                        \   * Amateur      = 146 plus -14 to +14 = 132 to 160
                        \   * Professional = 153 plus  -7 to  +7 = 146 to 160
                        \
                        \ and these final ranges for the two cars at the back:
                        \
                        \   * Novice       = 134 plus -46 to +8 =  88 to 142
                        \   * Amateur      = 146 plus -23 to +4 = 123 to 150
                        \   * Professional = 153 plus -12 to +2 = 141 to 155

 CLC                    \ Set the driverSpeed for driver X to baseSpeed + A
 ADC baseSpeed
 STA driverSpeed,X

 JSR GetPositionAhead   \ Set X to the number of the position ahead of position
                        \ X

 STX driverNumber       \ Set driverNumber = X

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: SetPlayerPositions
\       Type: Subroutine
\   Category: Drivers
\    Summary: Set the player's current position, plus the positions behind and
\             in front
\
\ ******************************************************************************

.SetPlayerPositions

 LDA currentPlayer      \ Set A to the number of the current player

 LDX #19                \ We are about to work our way through the ordered list
                        \ of drivers in driversInOrder, so set a loop counter
                        \ in X, starting at the end of the list (i.e. last
                        \ place)

.P63A6

 CMP driversInOrder,X   \ If the driver in position X in the list matches the
 BEQ C63AE              \ current player, jump to C63AE

 DEX                    \ Decrement the driver number

 BPL P63A6              \ Loop back until we have gone through the whole table

.C63AE

                        \ By this point, X contains the position within the
                        \ driversInOrder list of the current player

 STX currentPosition    \ Store the current player's position in currentPosition

 JSR GetPositionBehind  \ Set X to the number of the position behind this one

 STX positionBehind     \ Store the position behind the current player in
                        \ positionBehind

 LDX currentPosition    \ Set X to the number of the position ahead of the
 JSR GetPositionAhead   \ current player's position

 STX positionAhead      \ Store the position ahead of the current player in
                        \ positionAhead

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: Protect
\       Type: Subroutine
\   Category: Setup
\    Summary: Decrypt or unprotect the game code (disabled)
\
\ ******************************************************************************

IF _SUPERIOR

.Protect

 JMP SetupGame          \ Jump to SetupGame to continue setting up the game

 NOP                    \ Presumably this contained some kind of copy protection
 NOP                    \ or decryption code that has been replaced by NOPs in
 NOP                    \ this unprotected version of the game
 NOP
 NOP

ENDIF

\ ******************************************************************************
\
\       Name: GetSteeringAssist
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Fetch the current steering assist status and show or hide the
\             steering assist indicator
\
\ ------------------------------------------------------------------------------
\
\ The steering assist indicator is in the centre-bottom of the rev counter, and
\ is made up of four pixels in colour 2 (white) as follows:
\
\   ...xx...
\   ..x..x..
\
\ which would be encoded in mode 5 screen memory as follows:
\
\   %00010000   %10000000
\   %00100000   %01000000
\
\ This routine shows or hides the indicator according to the current setting of
\ configAssist, returning the value of configAssist in X.
\
\ Returns:
\
\   X                   The current value of configAssist:
\
\                         * %10000000 if steering assist is enabled
\
\                         * 0 if steering assist is not enabled
\
\   A                   A is unchanged
\
\   C flag              Set to bit 7 of L0025
\
\ ******************************************************************************

IF _SUPERIOR

.GetSteeringAssist

 PHA                    \ Store A on the stack so we can retrieve it below

 LDA configAssist       \ Set A to configAssist, which has the following value:
                        \
                        \   * %10000000 if steering assist is enabled
                        \
                        \   * 0 if steering assist is not enabled
                        \
                        \ The following updates screen memory to add a small
                        \ "hat" marker to the centre-bottom of the rev counter
                        \ when steering assist is enabled (or to to remove the
                        \ marker when it isn't enabled)

 STA assistRight1       \ Set assistRight1 = 0 or %10000000

 LSR A                  \ Set assistRight2 = 0 or %01000000
 STA assistRight2

 LSR A                  \ Set assistLeft2 = 0 or %00100000
 STA assistLeft2

 LSR A                  \ Set assistLeft1 = 0 or %00010000
 STA assistLeft1

 LDA L0025              \ Set the C flag to bit 7 of L0025
 ROL A

 PLA                    \ Restore the value of A that we put on the stack above

 LDX configAssist       \ Set X to configAssist

 RTS                    \ Return from the subroutine

ENDIF

\ ******************************************************************************
\
\       Name: SetupGame
\       Type: Subroutine
\   Category: Setup
\    Summary: Decrypt or unprotect the game code (disabled)
\
\ ******************************************************************************

IF _SUPERIOR

.SuperiorSetupGame

CLEAR &3850, &3880      \ In the Superior Software release of Revs, the steering
ORG &3850               \ assist routines take up extra memory, so we need to
                        \ claw back some memory from somewhere
                        \
                        \ The clever solution is to move the SetupGame routine,
                        \ which is run when the game loads, but is never needed
                        \ again, so in the Superior version, SetupGame is put
                        \ into the same block of memory as the L3850Lo,
                        \ totalPointsLo and totalPointsLo variables, which are
                        \ only used after the game has started
                        \
                        \ These lines rewind BeebAsm's assembly back to L3850Lo
                        \ (which is at address &3850), and clear the block that
                        \ is occupied by these three variables, so we can
                        \ assemble SetupGame in the right place while retaining
                        \ the correct addresses for the three variables
                        \
                        \ We also make a note of the current address, so we can
                        \ ORG back to it after assembling SetupGame

ENDIF

.SetupGame

 LDA #4                 \ Call OSBYTE with A = 4, X = 1 and Y = 0 to disable
 LDY #0                 \ cursor editing
 LDX #1
 JSR OSBYTE

 JSR SetScreenMode7     \ Change to screen mode 7 and hide the cursor

 LDX #9                 \ We now zero the ten bytes starting at configStop, so
                        \ set a loop counter in X

 LDA #0                 \ Set lineBufferSize = 0, to reset the line buffer
 STA lineBufferSize

.setp1

 STA configStop,X       \ Zero the X-th byte at configStop
                        \
                        \ The address in this instruction gets modified

 DEX                    \ Decrement the loop counter

 BPL setp1              \ Loop back until we have zeroed all ten bytes

 LDA #246               \ Set volumeLevel = -10, which sets the sound level to
 STA volumeLevel        \ medium (-15 is full volume, 0 is silent)

 TSX                    \ Store the stack pointer in startingStack so we can
 STX startingStack      \ restore it when restarting the game

 JSR CallTrackHook      \ Call the hook code in the track file (for Silverstone
                        \ the hook routine is just an RTS, so this does nothing)

IF _ACORNSOFT

                        \ Fall through into the main game loop to start the game

ELIF _SUPERIOR

 LDA #190               \ Call OSBYTE with A = 190, X = %00100000 and Y = 0 to
 LDY #0                 \ configure the digital joystick port on the BBC Master
 LDX #%00100000         \ Compact conversion type to 32-bit conversion (as the
 JSR OSBYTE             \ Superior Software version was released for this
                        \ machine)
                        \
                        \ The configuration does the following:
                        \
                        \   * Bit 7 clear = update channel values from cursor
                        \     keys and/or digital joystick
                        \
                        \   * Bit 6 clear = do not simulate key presses from the
                        \     digital joystick
                        \
                        \   * Bit 5 set = return fixed values to channels 1 and
                        \     2 as follows:
                        \
                        \     Left = &FFFF to channel 1
                        \     Centre (horizontal) = &7FFF to channel 1
                        \     Right = 0 to channel 1
                        \     Down = &FFFF to channel 2
                        \     Centre (vertical) = &7FFF to channel 2
                        \     Up = 0 to channel 2
                        \
                        \   * Bit 4 is unused
                        \
                        \   * Bits 0-3 clear = emulate the analogue speed of
                        \     joystick movement by returning slowly changing
                        \     values related to the joystick movement

 JMP MainLoop           \ Jump to the main game loop to start the game

 EQUB &FF               \ This byte appears to be unused

ORG SuperiorSetupGame   \ Switch back to the original address, so we can
                        \ continue with the assembly

ENDIF

\ ******************************************************************************
\
\       Name: MainLoop (Part 1 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: The main game loop: practice laps
\
\ ------------------------------------------------------------------------------
\
\ This part of the main loop implements practice laps.
\
\ ******************************************************************************

.MainLoop

 LDX #0                 \ Set configStop = 0 so we clear out any existing
 STX configStop         \ stop-related key presses

 JSR InitialiseDrivers  \ Initialise all 20 drivers

 LDX #4                 \ Print "REVS   REVS   REVS" as a double-height header
 JSR PrintHeader        \ at column 0, row 4, with the colours of each letter in
                        \ REVS set to magenta/yellow/cyan/green

 JSR PrintHeaderChecks  \ Print chequered lines above and below the header

 LDX #39                \ Print token 39, which shows a menu with the following
 JSR PrintToken         \ options:
                        \
                        \   1 = PRACTICE
                        \
                        \   2 = COMPETITION

 LDX #2                 \ Fetch the menu choice into X (0 to 1)
 JSR GetMenuOption

 CPX #1                 \ If X >= 1, then the choice was competition, so jump to
 BCS game1              \ game1 to start setting up the competition races

 STX currentPlayer      \ Otherwise X = 0 and the choice was practice, so set
                        \ currentPlayer = 0

 DEX                    \ Set qualifyingTime = 255, so that the time we spend
 STX qualifyingTime     \ practicing is as long as we want

 JSR ResetLapTimes      \ Reset the current lap times for all drivers

 JSR HeadToTrack        \ Head to the track to choose the wing settings and
                        \ start the practice laps, which the player exits by
                        \ pressing SHIFT and right arrow to restart the game
                        \ (so we don't return from this call)

\ ******************************************************************************
\
\       Name: MainLoop (Part 2 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: The main game loop: competition setup
\
\ ------------------------------------------------------------------------------
\
\ This part of the main loop gets all the general information required for the
\ competition: the race class and the duration of qualifying laps.
\
\ ******************************************************************************

.game1

 LDA #0                 \ Set competitionStarted = 0, to indicate that the
 STA competitionStarted \ competition hasn't started yet (so we still need to
                        \ get the race class, the number of laps, and the
                        \ players' names)

 LDX #21                \ Print token 21, which shows a menu with the following
 JSR PrintToken         \ options:
                        \
                        \   Prompt = SELECT THE CLASS OF RACE
                        \
                        \   1 = Novice
                        \
                        \   2 = Amateur
                        \
                        \   3 = Professional

 LDX #3                 \ Fetch the menu choice into X (0 to 2)
 JSR GetMenuOption

 STX raceClass          \ Set raceClass to the chosen race class (0 to 2)

 JSR Set5FB0            \ Call Set5FB0 to set up the 24 bytes at L5FB0 according
                        \ to the race class

.game2

 LDX #22                \ Print token 22, which shows a menu with the following
 JSR PrintToken         \ options:
                        \
                        \   Prompt = SELECT DURATION OF QUALIFYING LAPS
                        \
                        \   1 = 5 mins
                        \
                        \   2 = 10 mins
                        \
                        \   3 = 20 mins

 LDX #3                 \ Fetch the menu choice into X (0 to 2)
 JSR GetMenuOption

 LDA timeFromOption,X   \ Set the value of qualifyingTime to 4, 9 or 25, which
 STA qualifyingTime     \ should be the number of minutes of qualifying time
                        \ minus one, but the latter seems to be a bug

\ ******************************************************************************
\
\       Name: MainLoop (Part 3 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: The main game loop: qualifying laps
\
\ ------------------------------------------------------------------------------
\
\ This part of the main loop gets the players' driver names, and heads to the
\ track for their qualifying laps.
\
\ ******************************************************************************

 JSR ResetLapTimes      \ Reset the current lap times to 10:00.0 for all drivers

 LDA #20                \ Set currentPlayer = 20, so the first human player will
 STA currentPlayer      \ be number 19, the next one will be 18, and so on

.game3

 DEC currentPlayer      \ Decrement currentPlayer so it points to the next human
                        \ player

 LDX currentPlayer      \ Set X to the new player number

 JSR ResetLapTime       \ Reset the current lap time for the new player

 LDA competitionStarted \ If competitionStarted = 0, jump to game4 to ask for
 BEQ game4              \ the player's name, as the competition hasn't started
                        \ yet and we are still running qualifying laps

                        \ If we get here then the competition is in full swing,
                        \ so we need to run qualifying laps for all the human
                        \ players

 JSR PrintDriverPrompt  \ Print the "DRIVER ->" prompt and the player's name

 JSR HeadToTrack        \ Head to the track to choose the wing settings and
                        \ drive the qualifying laps, returning here when the
                        \ laps are finished

 LDA currentPlayer      \ If currentPlayer <> lowestPlayerNumber, then we still
 CMP lowestPlayerNumber \ have more qualifying laps to get, so jump back to
 BNE game3              \ game3 for the next player's qualifying laps

                        \ By this point we have all the qualifying times for the
                        \ human players

 LDA #0                 \ Sort the drivers by lap time, putting the results into
 JSR SortDrivers        \ positionNumber and driversInOrder

 JMP game9              \ Jump down to game9 to print the driver table, showing
                        \ the grid positions for the race

.game4

                        \ If we get here then we need to get the player's name,
                        \ as the competition has not yet started

 LDX #23                \ Print token 23, which shows the following prompt:
 JSR PrintToken         \
                        \   ENTER NAME OF DRIVER
                        \
                        \ and a text prompt:
                        \
                        \   > 
                        \     ------------

 JSR GetDriverName      \ Fetch the player's name from the keyboard

 JSR HeadToTrack        \ Head to the track to choose the wing settings and
                        \ start the qualifying laps, returning here when the
                        \ laps are finished

 LDX currentPlayer      \ If currentPlayer = 0 then we have got as many players
 BEQ game5              \ as we can handle (20 of them), so jump to game5 to
                        \ skip asking for another driver

 LDX #27                \ Print token 27, which shows a menu with the following
 JSR PrintToken         \ options:
                        \
                        \   1 = ENTER ANOTHER DRIVER
                        \
                        \   2 = START RACE

 LDX #2                 \ Fetch the menu choice into X (0 to 1)
 JSR GetMenuOption

 CPX #0                 \ If X = 0, then the choice was to enter another driver,
 BEQ game3              \ so jump back to game3 to add the new player and head
                        \ to the track for their qualifying laps

\ ******************************************************************************
\
\       Name: MainLoop (Part 4 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: The main game loop: the competition race
\
\ ------------------------------------------------------------------------------
\
\ This part of the main loop checks the slowest qualifying lap times to see if
\ we should make the game easier.
\
\ ******************************************************************************

.game5

 LDA currentPlayer      \ We have now got all the player names and qualifying
 STA lowestPlayerNumber \ times that we need, so store the player number in
                        \ lowestPlayerNumber, which will contain 19 if there is
                        \ one player, 18 if there are two, and so on
                        \
                        \ Human players take the place of drivers with higher
                        \ numbers, so the first player takes the place of driver
                        \ 19 (the aptly called Dummy Driver, as they never get
                        \ to race), and the second player takes the place of
                        \ driver 18 (Peter Out), the third player replaces
                        \ driver 17 (Rick Shaw) and so on
                        \
                        \ So this not only represents the lowest player number,
                        \ but also the highest non-human driver number (which is
                        \ lowestPlayerNumber - 1)

 LDA #0                 \ Sort the drivers by lap time, putting the results into
 JSR SortDrivers        \ positionNumber and driversInOrder, so they now contain
                        \ the order of the drivers on the grid for the coming
                        \ race

                        \ We now adjust the class of the race to cater for the
                        \ player's qualifying lap time, which makes things more
                        \ fun for a mixed group of player skills

 LDX #0                 \ Set X to the race class number for Novice

.game6

 LDY driversInOrder+19  \ Set Y to the driver number with the slowest lap time

 CPY lowestPlayerNumber \ If Y < lowestPlayerNumber, then driver Y is one of the
 BCC game8              \ computer-controlled drivers and they have the slowest
                        \ lap time, so jump to game8 as the race class doesn't
                        \ need changing

                        \ Otherwise the slowest lap time is by one of the human
                        \ players, so we now set the race class (i.e. the race
                        \ difficulty setting) according to the figures in the
                        \ track data)

 LDA driverSeconds,Y    \ Calculate the slowest lap time minus the time for
 SEC                    \ class X from the track data, starting with the seconds
 SBC trackData+&700,X

 LDA driverMinutes,Y    \ And then the minutes
 SBC trackData+&703,X

                        \ Note that for X = 2 (professional), the track data
                        \ figure is 0, so the C flag will always be set

 BCS game7              \ If the slowest lap time is longer than the figure from
                        \ trackData, jump to game7 to consider setting the class
                        \ to X, if it is easier than the current class
                        \
                        \ In other words, if the slowest lap time is really slow
                        \ and is by a human player, this can make the game
                        \ easier if the race class isn't already on Novice
                        \
                        \ For example, for Silverstone:
                        \
                        \   * We will consider setting the class to Novice if
                        \     the longest lap is > 1:51 and by a human player
                        \
                        \   * We will consider setting the class to Amateur if
                        \     the longest lap is <= 1:51 and > 1:41 and by a
                        \     human player
                        \
                        \   * We will consider setting the class to Professional
                        \     if the longest lap is <= 1:41 and by a human
                        \     player

                        \ If we get here, the slowest lap time is quicker than
                        \ the figure from the track data, so we now check the
                        \ next figure from the track data and try again

 INX                    \ Increment X to the next difficulty level

 BNE game6              \ Jump back to game6 to check the next race class (this
                        \ BNE is effectively a JMP as X is never zero)

.game7

 CPX raceClass          \ If X >= raceClass then X is the same or more difficult
 BCS game8              \ than the current setting, so jump to game8 to leave
                        \ the class unchanged

 STX raceClass          \ Otherwise set the race class to the easier class in X

\ ******************************************************************************
\
\       Name: MainLoop (Part 5 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: The main game loop: the competition race
\
\ ------------------------------------------------------------------------------
\
\ This part of the main loop heads to the track to run the actual race. We
\ print the driver table showing the grid positions, and set the grid row for
\ any human drivers. We then start a loop, running a race for each human player,
\ and asking for the number of laps in the race for the first such race. The
\ loop concludes in the next part of the main loop.
\
\ ******************************************************************************

.game8

 LDX raceClass          \ Set X to the race class

 JSR Set5FB0            \ Call Set5FB0 to set up the 24 bytes at L5FB0 according
                        \ to the race class

 LDX #26                \ Print token 26, which is a double-height header with
 JSR PrintToken         \ the text "STANDARD OF RACE"

 JSR PrintRaceClass     \ Print the race class

 JSR WaitForSpace       \ Print a prompt and wait for SPACE to be pressed

.game9

 LDX #2                 \ Print the driver table, showing lap times, under the
 LDA #0                 \ heading "GRID POSITIONS", so this shows the drivers
 JSR PrintDriverTable   \ in their starting positions on the grid

                        \ We now make a copy of the driversInOrder list into
                        \ driversInOrder2, so we can retrieve it below, and at
                        \ the same time we set the correct grid row for any
                        \ human players, depending on their starting position
                        \ on the grid (there are two cars per grid row)

 LDY #19                \ Set up a counter in Y so we can work through the
                        \ drivers in order, from the back of the grid to the
                        \ front

.game10

 LDA driversInOrder,Y   \ Copy the Y-th positon from driversInOrder to
 STA driversInOrder2,Y  \ driversInOrder2, setting A to the number of the driver
                        \ in position Y

 CMP lowestPlayerNumber \ If A < lowestPlayerNumber, then driver A is one of the
 BCC game11             \ computer-controlled drivers, so jump to game11 to skip
                        \ setting the grid number for the driver

                        \ If we get here then driver A is a human player

 TAX                    \ Set X = the player's driver number

 LDA positionNumber,Y   \ Set A = the position of the player on the grid

 LSR A                  \ Set the driver's grid row to A / 2, so the first two
 STA driverGridRow,X    \ drivers are on grid row 0, then the next two are on
                        \ grid row 1, and so on

.game11

 DEY                    \ Decrement the counter

 BPL game10             \ Loop back until we have saved all the positions

 LDA competitionStarted \ If competitionStarted <> 0, then the competition has
 BNE game12             \ already started, so jump to game12 to skip the lap
                        \ selection process

 LDX #28                \ Print token 28, which shows a menu with the following
 JSR PrintToken         \ options:
                        \
                        \   Prompt = SELECT NUMBER OF LAPS
                        \
                        \   1 = 5 laps
                        \
                        \   2 = 10 laps
                        \
                        \   3 = 20 laps

 LDA #20                \ Set numberOfPlayers = 20 - lowestPlayerNumber
 SEC                    \
 SBC lowestPlayerNumber \ so numberOfPlayers is 1 if there is one player, 2 if
 STA numberOfPlayers    \ there are two players, and so on

 LDX #3                 \ Fetch the menu choice into X (0 to 2)
 JSR GetMenuOption

 LDA lapsFromOption,X   \ Convert the menu choice (0 to 2) into the number of
 STA numberOfLaps       \ laps (5, 10, 20) using the lapsFromOption lookup, and
                        \ store the result in numberOfLaps

 STX lapsMenuOption     \ Store the menu choice (0 to 2) in lapsMenuOption

.game12

 LDA #20                \ We now work our way through the human players so each
 STA currentPlayer      \ one can race in turn, so set currentPlayer to 20 so
                        \ it gets decremented to 19 for the first player

.game13

 DEC currentPlayer      \ Decrement currentPlayer to move on to the next player

 JSR PrintDriverPrompt  \ Print the "DRIVER ->" prompt and the player's name

 LDX #19                \ We now restore the grid positions we saved above, so
                        \ set a counter in X

.game14

 LDA driversInOrder2,X  \ Restore the X-th positon from driversInOrder2 to
 STA driversInOrder,X   \ driversInOrder

 DEX                    \ Decrement the counter

 BPL game14             \ Loop back until we have restored all the positions

 JSR ResetLapTimes      \ Reset the current lap times for all drivers

 LDA #%10000000         \ Head to the track to choose the wing settings and
 JSR HeadToTrack+2      \ start the race (as bit 7 of A is set), returning here
                        \ when the race is finished

\ ******************************************************************************
\
\       Name: MainLoop (Part 6 of 6)
\       Type: Subroutine
\   Category: Main loop
\    Summary: The main game loop: race points and competition results
\
\ ------------------------------------------------------------------------------
\
\ This part of the main loop processes the points from the race and displays the
\ driver tables, and loops back to the previous part if there are more human
\ players in the race. When all the players have raced, we loop back to part 2
\ for the next race in the championship.
\
\ ******************************************************************************

 LDA #%10000000         \ Sort the drivers by best lap time, putting the results
 JSR SortDrivers        \ into positionNumber and driversInOrder

 LDX #5                 \ We now award points to the top six drivers in the
                        \ race, so set a counter in X

.game15

 JSR AwardRacePoints    \ Award points to the driver in race position X

 DEX                    \ Decrement the counter

 BPL game15             \ Loop back until we have awarded points to the top six
                        \ drivers

 LDA #0                 \ Sort the drivers by lap time, putting the results into
 JSR SortDrivers        \ positionNumber and driversInOrder

 LDX #6                 \ Award a point to the driver with the fastest lap
 JSR AwardRacePoints

.game16

 LDA #%10000000         \ Sort the drivers by lap time, putting the results into
 JSR SortDrivers        \ positionNumber and driversInOrder

 LDX #1                 \ Print the driver table, showing points awarded in the
 LDA #4                 \ last race, under the heading "POINTS", so this shows
 JSR PrintDriverTable   \ the best drivers from the last race, along with the
                        \ points awarded to the fastest six drivers

 LDA #0                 \ Sort the drivers by lap time, putting the results into
 JSR SortDrivers        \ positionNumber and driversInOrder

 LDX #6                 \ Print the driver table, showing lap times, under the
 LDA #0                 \ heading "BEST LAP TIMES", so this shows the lap times
 JSR PrintDriverTable   \ from the race

 LDA #%01000000         \ Sort the drivers by accumulated points, putting the
 JSR SortDrivers        \ results into positionNumber and driversInOrder

 LDX #3                 \ Set competitionStarted = 3, which is non-zero, so this
 STX competitionStarted \ indicates that the competition has started (so we
                        \ don't get asked to choose the number of laps or player
                        \ names)

 LDA #&88               \ Print the driver table, showing accumulated points,
 JSR PrintDriverTable   \ under the heading "ACCUMULATED POINTS", so this shows
                        \ the cumulative results of all races

 BIT G                  \ If bit 7 of G is clear, then RETURN was pressed, so
 BPL game16             \ jump back to game16 to show the driver tables again

 LDA currentPlayer      \ If currentPlayer <> lowestPlayerNumber, then we still
 CMP lowestPlayerNumber \ have more players to race, so jump back to game13 to
 BNE game13             \ start the next player's race

 JMP game2              \ Jump back to game2 to move on to the next race in the
                        \ competition

\ ******************************************************************************
\
\       Name: HeadToTrack
\       Type: Subroutine
\   Category: Main Loop
\    Summary: Get the wing settings and start a race, practice or qualifying lap
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   HeadToTrack+2       Called with A = %10000000 to start a race, as opposed to
\                       practice or a qualifying lap
\
\ ******************************************************************************

.HeadToTrack

 LDA #%00101000         \ Set A to the value for practice or a qualifying lap
                        \ (this instruction will be skipped when starting a race
                        \ by calling HeadToTrack+2)

 STA raceStarted        \ Set raceStarted to the value of A, so bit 7 gets set
                        \ if this is a race, but is clear for practice or a
                        \ qualifying lap

 STA L006D              \ Set L006D to the value of A, so bit 7 gets set if this
                        \ is a race, but bit 7 is clear and bits 3 and 5 are set
                        \ for practice or a qualifying lap

.race1

 JSR GetWingSettings    \ Get the front and rear wing settings from the player

 JSR MainDrivingLoop    \ Call the main driving loop to switch to the custom
                        \ mode, implement the driving part of the game, and
                        \ return here with the screen mode back to mode 7

 BIT configStop         \ If bit 6 of configStop is set then we are returning to
 BVS race1              \ the track after visiting the pits, so loop back to
                        \ race1 to get new wing settings before rejoining the
                        \ driving loop

 BPL race2              \ If bit 7 of configStop is clear then we did not use
                        \ SHIFT and right arrow to exit the main driving loop,
                        \ so jump to race2 to return from the subroutine

                        \ If we get here then bit 6 of configStop is clear and
                        \ bit 7 of configStop is set, which means we presses
                        \ SHIFT and right arrow to exit the main driving loop,
                        \ which is the key combination for resarting the whole
                        \ game

 JSR RestartGame        \ Jump to RestartGame to restart the game, which removes
                        \ the return address from the stack and jumps to the
                        \ main loop, so this call acts like JMP RestartGame

.race2

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: GetMenuOption
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan the keyboard for a menu entry number, highlight the choice,
\             show the SPACE bar message and return the choice number
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of entries in the menu
\
\ Returns:
\
\   X                   The chosen option, zero-based (so the first option is 0,
\                       the second option is 1, and so on)
\
\ ******************************************************************************

.GetMenuOption

 LDY #0                 \ Set W = 0, to indicate that we have not yet chosen an
 STY W                  \ option from the menu

 STX U                  \ Store the number of entries in U

.mopt1

 JSR CheckRestartKeys   \ Check whether the restart keys are being pressed, and
                        \ if they are, restart the game (the restart keys are
                        \ SHIFT and right arrow)

 LDY U                  \ We now loop through each valid menu option for this
                        \ menu and check whether the relevant key is being
                        \ pressed, so we set a loop counter in U to start from
                        \ the menu size and loop down to zero

.mopt2

 STY V                  \ Store the loop counter in V so we can retrieve it
                        \ below

IF _ACORNSOFT

 LDX menuKeys,Y         \ Fetch the key number for menu option Y

ELIF _SUPERIOR

 LDX menuKeysSuperior,Y \ Fetch the key number for menu option Y

ENDIF

 JSR ScanKeyboard       \ Scan the keyboard to see if this key is being pressed

 BEQ mopt3              \ If this key is being pressed, jump to mopt3

 LDY V                  \ Retrieve the value of the loop counter

 DEY                    \ Decrement the loop counter to scan for the next menu
                        \ option

 BPL mopt2              \ Loop back to check the key for the next option

 BMI mopt1              \ Loop back to mopt1 to keep checking through the option
                        \ keys (this BMI is effectively a JMP as we just passed
                        \ through a BPL)

.mopt3

 LDY V                  \ Set Y to the menu option that was chosen

 BNE mopt4              \ If Y is non-zero, jump to mopt4 to process the choice

                        \ If we get here, SPACE was pressed

 LDA W                  \ If W = 0 then we have not yet chosen an option from
 BEQ mopt1              \ the menu, so jump back to mopt1 to keep checking for
                        \ key presses, as SPACE is only a valid key press when
                        \ we have chosen an option

                        \ If we get here then we have already chosen an option
                        \ from the menu, and SPACE has been pressed

 LDA #152               \ Poke the mode 7 conceal character into screen memory,
 STA row24_column5      \ to hide row 24 from column 5 onwards, i.e. hide the
                        \ "PRESS SPACE BAR TO CONTINUE" prompt

 LDX G                  \ Set X = G - 1, to return as the zero-based choice
 DEX                    \ number

 RTS                    \ Return from the subroutine

.mopt4

 STY G                  \ Set G to the number of the choice we just made

 LDA W                  \ If W is non-zero, jump to mopt5 to skip the following
 BNE mopt5              \ three instructions

 LDX #30                \ Set X = 30 to pass to PrintToken below

 STX W                  \ Set W = 30, so W is now non-zero and denotes that we
                        \ have made a choice

 JSR PrintToken         \ Print token 30 ("PRESS SPACE BAR TO CONTINUE" in cyan
                        \ at column 5, row 24)

.mopt5

                        \ We now work our way through the menu, setting each
                        \ entry's background colour according to the choice made
                        \ (the chosen entry is set to red, while other entries
                        \ are set to blue)

 LDX #0                 \ Set an offset counter in X to step through the screen
                        \ address of the on-screen number for each menu entry,
                        \ starting at an offset of 0 (the offset is added to
                        \ row18_column5 in the loop below)

 LDY #1                 \ Set a counter in Y to count through the menu entries

.mopt6

 LDA #132               \ Set A to the mode 7 control code for blue, to set as
                        \ the background colour for the unselected menu entries

 CPY G                  \ If Y <> G then this is not the chosen entry, so skip
 BNE mopt7              \ the following instruction to leave A as blue

 LDA #129               \ Set A to the mode 7 control code for red, to set as
                        \ the background colour for the selected menu entry

.mopt7

 STA row18_column5,X    \ Poke the colour in A into screen memory at offset X
                        \ from column 5 on row 18, which is the screen address
                        \ of the number for the first menu entry (so this sets
                        \ the background colour of the current entry to A)

 TXA                    \ Set X = X + 80
 CLC                    \
 ADC #80                \ so X now points to the next menu entry, as 80 is two
 TAX                    \ lines of mode 7 characters, and the menu entries are
                        \ shown on every other line

 INY                    \ Increment the option counter in Y

 CPY U                  \ If Y <= U then loop back to set the background colour
 BCC mopt6              \ for the next option, until we have done all of them
 BEQ mopt6

 BNE mopt1              \ Jump back to mopt1 to keep checking for key presses,
                        \ so we can change the option, or press SPACE to lock in
                        \ our choice (this BNE is effectively a JMP as we just
                        \ passed through a BEQ)

\ ******************************************************************************
\
\       Name: GetDriverNumberBCD
\       Type: Subroutine
\   Category: Drivers
\    Summary: Convert a driver number into binary coded decimal (BCD), ready for
\             printing
\
\ ------------------------------------------------------------------------------
\
\ This routine converts a driver number in the range 0 to 19 into a BCD number
\ in the range 1 to 20, so the driver number can be printed.
\
\ Arguments:
\
\   A                   The driver number to be converted into BCD (0 to 19)
\
\ Returns:
\
\   A                   The driver number in BCD (1 to 20)
\
\ ******************************************************************************

.GetDriverNumberBCD

 CMP #10                \ If A < 10, skip the following instruction as A is in
 BCC ibcd1              \ the range 0 to 9, which is the same number in BCD

 ADC #5                 \ A >= 10, so set A = A + 6 (as the C flag is set) to
                        \ convert the number into BCD, like this:
                        \
                        \   * 10 = &0A -> &10 (i.e. 10 in BCD)
                        \   * 11 = &0B -> &11 (i.e. 11 in BCD)
                        \   * 12 = &0C -> &12 (i.e. 12 in BCD)
                        \   * 13 = &0D -> &13 (i.e. 13 in BCD)
                        \   * 14 = &0E -> &14 (i.e. 14 in BCD)
                        \   * 15 = &0F -> &15 (i.e. 15 in BCD)
                        \   * 16 = &10 -> &16 (i.e. 16 in BCD)
                        \   * 17 = &11 -> &17 (i.e. 17 in BCD)
                        \   * 18 = &12 -> &18 (i.e. 18 in BCD)
                        \   * 19 = &13 -> &19 (i.e. 19 in BCD)

.ibcd1

 SED                    \ Set the D flag to switch arithmetic to Binary Coded
                        \ Decimal (BCD)

 ADC #1                 \ Increment A in BCD mode, so the result is in the
                        \ range 1 to 20

 CLD                    \ Clear the D flag to switch arithmetic to normal

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: PrintDriverTable
\       Type: Subroutine
\   Category: Text
\    Summary: Print the table of drivers
\
\ ------------------------------------------------------------------------------
\
\ The driver table consists of the following:
\
\   * A header, as specified by the argument in X
\
\   * A table with one row for each driver, showing a number, a driver name and
\     a third column as specified by the argument in A
\
\   * A "PRESS SPACE TO CONTINUE" prompt below the table
\
\ If the table is being shown after practice or qualifying, the drivers are
\ shown in driver order, from 1 to 20, but if it is shown after a race, the
\ first column shows the numbers from the positionNumber table, the second
\ column shows the drivers in the order that they appear in the driversInOrder
\ list, and the race class is printed above the table.
\
\ The routine also waits for SPACE or RETURN to be pressed before returning.
\
\ Arguments:
\
\   X                   The number of the token to print as the header (see
\                       PrintHeader for more details):
\
\                         * 1 = "POINTS"
\
\                         * 2 = "GRID POSITIONS"
\
\                         * 3 = "ACCUMULATED POINTS"
\
\                         * 6 = "BEST LAP TIMES"
\
\   A                   Defines what to show in the third column in the table:
\
\                         * 0 = lap times
\
\                         * 4 = points awarded in the last race
\
\                         * &88 = accumulated points
\
\   positionNumber      A list of position numbers (for race tables only), which
\                       contains the numbers 0 to 19 in sequence, with tied
\                       positions represented by shared position numbers
\
\ Returns:
\
\   G                   Bit 7 is clear if RETURN was pressed, set if SPACE was
\                       pressed
\
\ ******************************************************************************

.PrintDriverTable

 PHA                    \ Store the value of A on the stack so we can retrieve
                        \ it below

 AND #%00001111         \ Set colourScheme to the lower nibble of A, which
 STA colourScheme       \ contains the colour scheme to use for the table, so we
                        \ can pass it to SetRowColours below

 JSR PrintHeader        \ Print the header specified in X

 LDY #0                 \ We are about to print a table containing 20 rows, one
                        \ for each driver, so set a row counter in Y

.dtab1

 STY rowCounter         \ Store the row counter in rowCounter

 LDA #%00000000         \ Set G = 0 so the call to Print2DigitBCD below will
 STA G                  \ print the second digit and will not print leading
                        \ zeroes when printing the driver number

 JSR SetRowColours      \ Set the colours in token 31 according to the colour
                        \ scheme we stored in colourScheme above, so they can be
                        \ used to set the colours of each table cell

 LDX #32                \ Print token 32, which prints two spaces and backspaces
 JSR PrintToken         \ followed by token 31, so this sets up the colours for
                        \ the first column

 LDY rowCounter         \ Set Y to the table row number

 LDA positionNumber,Y   \ Set A to the positionNumber for this row, to show in
                        \ the first column

 BIT raceStarted        \ If bit 7 of raceStarted is set, that means the results
 BMI dtab2              \ are from a finished race, so jump to dtab2 to skip the
                        \ following instruction, so we print the numbers from
                        \ positionNumber in the first column

 TYA                    \ Set A to the row number, so we print the row number in
                        \ the first column (i.e. 1 to 20, as )

.dtab2

 JSR GetDriverNumberBCD \ Convert the number in A into binary coded decimal
                        \ (BCD), adding 1 in the process

 JSR Print2DigitBCD     \ Print the binary coded decimal (BCD) number in A, and
                        \ because we set G to 0 above, it will print the second
                        \ digit and will not print leading zeroes

 LDX #31                \ Print token 31, which prints two spaces and sets the
 JSR PrintToken         \ colours as configured above, so this inserts a black
                        \ gap between the first and second table columns

 LDY rowCounter         \ Set Y to the table row number

 JSR PrintPositionName  \ Print the name of the driver in position Y, so row Y
                        \ of the table contains the details of the driver in
                        \ position Y, and set driverPrinted to the number of the
                        \ driver that was printed

 LDX #31                \ Print token 31, which prints two spaces and sets the
 JSR PrintToken         \ colours as configured above, so this inserts a black
                        \ gap between the second and third table columns

 LDX driverPrinted      \ Set X to the number of the driver we just printed

 PLA                    \ If the value of A that we stored on the stack at the
 PHA                    \ start of the routine is non-zero, jump to dtab3 to
 BNE dtab3              \ skip the following

                        \ If we get here then the value of A passed to the
                        \ routine was 0, so we now print the third column
                        \ containing the driver's best lap time

 LDA #%00100110         \ Print the lap time for driver X in the following
 JSR PrintLapTime       \ format:
                        \
                        \   * %00 Minutes: No leading zeroes, print both digits
                        \   * %10 Seconds: Leading zeroes, print both digits
                        \   * %0  Tenths: Print tenths of a second
                        \   * %11 Tenths: Leading zeroes, no second digit

 JMP dtab6              \ Jump down to dtab6 to move on to the next table row

.dtab3

                        \ If we get here then the value of A passed to the
                        \ routine was non-zero (i.e. 4 or &88)

 BMI dtab4              \ If bit 7 of A is set (i.e. A = &88), jump to dtab4

                        \ If we get here then the value of A passed to the
                        \ routine was 4, so we now print the third column
                        \ containing the points awarded to the driver in the
                        \ last race
                        \
                        \ Only the top six drivers from each race get points,
                        \ so we print a blank column for the other drivers

 LDA rowCounter         \ Set A = rowCounter + 20
 CLC
 ADC #20

 CMP #26                \ Set X = A, and if A < 26 (so rowCounter is 0 to 5),
 TAX                    \ jump to dtab5 to print the race points
 BCC dtab5

 LDA #7                 \ A >= 26 (so rowCounter is 6 to 19), so print seven
 JSR PrintSpaces        \ spaces in the last column

 BEQ dtab6              \ Jump to dtab6 to move on to the next table row (this
                        \ BEQ is effectively a JMP, as PrintSpaces sets the Z
                        \ flag)

.dtab4

                        \ If we get here then the value of A passed to the
                        \ routine had bit 7 set, so it must have been &88, so
                        \ we now print the third column containing the driver's
                        \ accumulated points

 LDA #%00101000         \ Set G, so the next three calls to Print2DigitBCD do
 STA G                  \ the following:
                        \
                        \   * No leading zeroes, print second digit
                        \   * Leading zeroes, print second digit
                        \   * Leading zeroes, print second digit
                        \
                        \ The second and third two calls to Print2DigitBCD are
                        \ in the Print4DigitBCD routine below

 LDA totalPointsTop,X   \ If the top byte of the driver's total points is zero,
 BEQ dtab5              \ jump to dtab5

 JSR Print2DigitBCD     \ Otherwise print the top byte of the driver's total
                        \ points, which is a binary coded decimal (BCD) number

 LDA totalPointsHi,X    \ Fetch the high byte of the driver's total points, to
                        \ pass to Print4DigitBCD

 JSR Print4DigitBCD     \ Print both the high and low bytes of the driver's
                        \ total points in full, followed by a space

 JMP dtab6              \ Jump to dtab6 to move on to the next table row

.dtab5

 JSR Print234DigitBCD   \ Print the high and low bytes of the driver's total
                        \ points, replacing leading zeroes with spaces, and
                        \ followed by a space

.dtab6

                        \ If we get here then we have finished printing the
                        \ current table row, so now we move on to the next row

 LDY rowCounter         \ Set Y to the table row number

 INY                    \ Increment the table row number

 CPY #20                \ Loop back to print the next table row, until we have
 BNE dtab1              \ printed all 20

 LDA #3                 \ Print three spaces to pad out the final row
 JSR PrintSpaces

 LDA #156               \ Print ASCII 156 to switch to a black background
 JSR OSWRCH

 LDA raceStarted        \ If bit 7 of raceStarted is clear, that means the
 BPL dtab7              \ results are from qualifying or practice, so jump to
                        \ dtab7 to skip the following so we do not print the
                        \ race class above ths table

                        \ We now print the race class and number of laps in the
                        \ gap between the page header and the top of the table

 LDX #49                \ Print token 49, which moves the cursor to column 9,
 JSR PrintToken         \ row 2

 JSR PrintRaceClass     \ Print the race class

 LDA lapsMenuOption     \ Set the configurable token in token 50 to 218 plus the
 CLC                    \ figure in lapsMenuOption, to give 218, 219 or 220,
 ADC #218               \ which correspond to the tokens for " 5", "10" and "20"
 STA token50+3

 LDX #50                \ Print token 50, which is "n laps", where n is the
 JSR PrintToken         \ number of laps we just configured

.dtab7

 PLA                    \ Retrieve the value of A that we stored on the stack at
                        \ the start of the routine

 JSR WaitForSpaceReturn \ Print a prompt and wait for SPACE or RETURN to be
                        \ pressed, depending on bit 7 of A

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: PrintNearestDriver
\       Type: Subroutine
\   Category: Text
\    Summary: Print a driver's name in the "In front" or "Behind" slot in the
\             header
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The position of the driver whose name we print
\
\   A                   The pixel row on which to print the driver name:
\
\                         * 24 = the first line of text at the top of the screen
\                                (i.e. the "In front:" section of token 43)
\
\                         * 33 = the second line of text at the top of the
\                                screen (i.e. the "Behind:" section of token 44)
\
\ ******************************************************************************

.PrintNearestDriver

 STA yCursor            \ Move the cursor to the pixel row in A

 LDA #27                \ Move the cursor to character column 27
 STA xCursor

                        \ Fall through into PrintPositionName to print the
                        \ driver name at column 27 on the specified row

\ ******************************************************************************
\
\       Name: PrintPositionName
\       Type: Subroutine
\   Category: Text
\    Summary: Print the name of the driver in a specific position in the driver
\             position list
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The position of the driver whose name we print
\
\ Returns:
\
\   driverPrinted       The number of the driver that we printed
\
\ ******************************************************************************

.PrintPositionName

 LDX driversInOrder,Y   \ Set X to the number of the driver in position Y

 STX driverPrinted      \ Store the driver number in driverPrinted, so we can
                        \ return it

 JSR GetDriverAddress   \ Set (Y A) to the address of driver X's name

 JSR PrintDriverName    \ Print the name of the driver at address (Y A)

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: PrintDriverPrompt
\       Type: Subroutine
\   Category: Text
\    Summary: Print the "DRIVER ->" prompt and a driver's name, to show whose
\             turn it is next when playing a multi-player game
\
\ ******************************************************************************

.PrintDriverPrompt

 LDX #29                \ Print token 29, which clears the screen, displays the
 JSR PrintToken         \ F3 header, and shows a " DRIVER -> " prompt

 LDX currentPlayer      \ Set X to the driver number of the current player

 JSR GetDriverAddress   \ Set (Y A) to the address of driver X's name

 JSR PrintDriverName    \ Print the name of the driver at address (Y A)

 JSR WaitForSpace       \ Print a prompt and wait for SPACE to be pressed

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: AddRacePoints
\       Type: Subroutine
\   Category: Driving
\    Summary: Add the race points to the driver's total points
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The race position whose points should be added
\
\   Y                   The driver who receives those points, i.e. who has then
\                       added to their total accumulated points
\
\ ******************************************************************************

.AddRacePoints

 SED                    \ Set the D flag to switch arithmetic to Binary Coded
                        \ Decimal (BCD)

 LDA totalPointsLo,Y    \ Add (0 racePointsHi racePointsLo) for position X to
 CLC                    \ (totalPointsTop totalPointsHi totalPointsLo) for
 ADC racePointsLo,X     \ driver Y, starting with the low bytes
 STA totalPointsLo,Y

 LDA totalPointsHi,Y    \ And then the high bytes
 ADC racePointsHi,X
 STA totalPointsHi,Y

 LDA totalPointsTop,Y   \ And then the top bytes
 ADC #0
 STA totalPointsTop,Y

 CLD                    \ Clear the D flag to switch arithmetic to normal

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: Reset0554
\       Type: Subroutine
\   Category: 
\    Summary: Reset the blocks at L05A4, L0554, L0600, L0650 and L5F60
\
\ ------------------------------------------------------------------------------
\
\ This routine does the following:
\
\   * Set L001F+1 bytes at L0554 to &80
\
\   * Set L001F+1 bytes at L05A4 to &80
\
\   * Set L001F+1 bytes at L0600 to &80
\
\   * Set L001F+1 bytes at L0650 to &80
\
\   * Set 80 bytes at L5F60 to 0
\
\ ******************************************************************************

.Reset0554

 LDX L001F              \ We start by setting L001F+1 bytes at L05A4, L0554
                        \ L0600 and L0650 to &80, so set a byte counter in X

 LDA #&80               \ Set A = &80 to use as our reset value

.P66BA

 STA L05A4,X            \ Set the X-th byte of L05A4 to &80

 STA L0650,X            \ Set the X-th byte of L0650 to &80

 STA L0600,X            \ Set the X-th byte of L0600 to &80

 STA L0554,X            \ Set the X-th byte of L0554 to &80

 DEX                    \ Decrement the byte counter

 BPL P66BA              \ Loop back until we have zeroed all L001F+1 bytes

 LDX #79                \ We now zero the 80 bytes at L5F60, so set a byte
                        \ counter in X

 LDA #0                 \ Set A = 0 to use as our zero value

.P66CD

 STA L5F60,X            \ Zero the X-th byte of L5F60

 DEX                    \ Decrement the byte counter

 BPL P66CD              \ Loop back until we have zeroed all 80 bytes

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: GetDriverName
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Fetch a player's name from the keyboard
\
\ ******************************************************************************

.GetDriverName

 LDX currentPlayer      \ Set X to the driver number of the current player

 JSR GetDriverAddress   \ Set (Y A) to the address of driver X's name

 LDX #12                \ Fetch a string of length 12 from the keyboard and
 JSR GetTextInput       \ store it in (Y A), padding the string out with spaces
                        \ if required

 RTS                    \ Return from the subroutine

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

 LDX currentPosition
 BPL C66E6

.P66E3

 JSR sub_C2ACB

.C66E6

 JSR GetPositionBehind  \ Set X to the number of the position behind position X

 CPX positionAhead
 BNE P66E3
 LDX #&16

.P66EF

 STX L0045
 JSR sub_C2AD1
 DEX
 CPX #&14
 BCS P66EF
 LDX positionAhead
 JSR sub_C2ACB
 RTS

\ ******************************************************************************
\
\       Name: dashData42
\       Type: Variable
\   Category: Dashboard
\    Summary: Contains part of the dashboard image that gets moved into screen
\             memory
\
\ ******************************************************************************

ORG &6C00

.dashData42

 SKIP 2853

\ ******************************************************************************
\
\       Name: UpdateMirrors
\       Type: Subroutine
\   Category: Dashboard
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

 ORG &7B00

.UpdateMirrors

 LDY positionBehind
 LDX driversInOrder,Y
 LDA L018C,X
 BMI L7B2A
 LDA L03C8,X
 LSR A
 LSR A
 LSR A
 STA T
 CLC
 ADC #&B6
 STA TT
 LDA #&B6
 SEC
 SBC T
 STA N
 LDA L0398,X
 SEC
 SBC L000B
 SEC
 SBC #&04
 LSR A
 LSR A
 LSR A

.L7B2A

 STA V
 LDY #&05

.L7B2E

 LDA V
 CMP L3BA4,Y
 BEQ L7B3E
 LDA L6293,Y
 BEQ L7B46
 LDA #0
 BEQ L7B40

.L7B3E

 LDA TT

.L7B40

 STA L6293,Y
 JSR DrawCarInMirror

.L7B46

 DEY
 BPL L7B2E
 RTS

\ ******************************************************************************
\
\       Name: sub_C7B4A
\       Type: Subroutine
\   Category: 
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.sub_C7B4A

 LDA raceStarted
 BPL L7B9B
 LDX L006D
 BEQ L7B9B
 BPL L7B64
 CPX #&80
 BNE L7B64
 BIT L0061
 BPL L7B5E
 LDX #&F0

.L7B5E

 LDY #&00
 LDA #&80
 BNE L7B81

.L7B64

 CPX #&A0
 BEQ L7B75
 DEX
 BPL L7B7D
 CPX #&C0
 BCS L7B5E

.L7B6F

 LDA #&A5
 LDY #&77
 BNE L7B81

.L7B75

 LDA L006A
 AND #&3F
 BNE L7B6F
 LDX #&28

.L7B7D

 LDA #&F2
 LDY #&05

.L7B81

 STX L006D
 PHA
 STY T
 LDA #&F0
 LDX #&09

.L7B8A

 STA L42C0,X
 DEX
 BPL L7B8A
 PLA
 LDX #&05

.L7B93

 STA L42C2,X
 EOR T
 DEX
 BPL L7B93

.L7B9B

 RTS

\ ******************************************************************************
\
\       Name: PrintLapTime
\       Type: Subroutine
\   Category: Text
\    Summary: Print the best lap time for a specific driver
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The driver number
\
\   A                   Flags to control how the time is printed:
\
\                         * Bit 7: clear = do not print leading zeroes in mins
\                                  set = print leading zeroes in mins
\
\                         * Bit 6: clear = print second digit in mins
\                                  set = do not print second digit in mins
\
\                         * Bit 5: clear = do not print leading zeroes in secs
\                                  set = print leading zeroes in secs
\
\                         * Bit 4: clear = print second digit in secs
\                                  set = do not print second digit in secs
\
\                         * Bit 3: clear = print tenths of a second
\                                  set = do not print tenths of a second
\
\                         * Bit 2: clear = do not print leading zeroes in tenths
\                                  set = print leading zeroes in tenths
\
\                         * Bit 1: clear = print second digit in tenths
\                                  set = do not print second digit in tenths
\
\ ******************************************************************************

.PrintLapTime

 STA G                  \ Store A in G so we can check the value of bit 7 below

 LDA driverMinutes,X    \ Print the number of minutes in driver X's lap time
 JSR Print2DigitBCD

 LDA #&3A               \ Print ":"
 JSR PrintCharacter

 LDA driverSeconds,X    \ Print the number of seconds in driver X's lap time
 JSR Print2DigitBCD

 ASL G                  \ If bit 7 of G is set, we do not want to print tenths
 BCS plap1              \ of a second, so jump to plap1 to return from the 
                        \ subroutine

 LDA #&2E               \ Print "."
 JSR PrintCharacter

 LDA driverTenths,X     \ Print the number of tenths of a second in driver X's
 JSR Print2DigitBCD     \ lap time

.plap1

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DrawTrackView (Part 4 of 4)
\       Type: Subroutine
\   Category: Graphics
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.view19

 LDA view3+1
 STA view20+1

 LDA view8+1
 STA view21+1

 LDA view14+1
 STA view22+1

 LDA #&91               \ Set A to the opcode for the STA (P),Y instruction

.view20

 STA DrawTrackBytes+15

.view21

 STA DrawTrackBytes+15

.view22

 STA byte2+15

 LDA #&E0               \ Modify CMP instruction in byte3
 STA byte3

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DrawTrackView (Part 1 of 4)
\       Type: Subroutine
\   Category: Graphics
\    Summary: Draw the top part of the track view using the data in the dash
\             data blocks
\
\ ******************************************************************************

.DrawTrackView

 LDA #0                 \ Set (Q P) = &6700 and (S R) = &6800, ready to pass to
 STA P                  \ the DrawTrackLine routine (so the track view gets
 STA R                  \ drawn at the correct place on screen, from &6701
 LDX #&67               \ onwards, as the first line is drawn at (Q P) + 1)
 STX Q
 INX
 STX S

 LDX #79                \ Set X = 79, to point to the first byte to draw from
                        \ each dash data block (i.e. the byte at the end of the
                        \ data block, at offset 79)

 JSR DrawTrackLine      \ Draw one-pixel high lines that correspond to dash data
                        \ offsets 79 to 44, returning from the subroutine after
                        \ drawing the line specified by offset X = 44 (so this
                        \ draws all the lines from the top of the track view,
                        \ down to the line just above the top of the dashboard)

 JMP view1              \ Jump to part 2 to draw the rest of the track view from
                        \ offsets 43 to 3, modifying the code so it draws the
                        \ rest of the lines around the shape of the dashboard

\ ******************************************************************************
\
\       Name: DrawTrackLine (Part 2 of 2)
\       Type: Subroutine
\   Category: Graphics
\    Summary: Draw a pixel line across the screen in the track view
\
\ ******************************************************************************

.prow2

                        \ At this point, X contains the offset within the dash
                        \ data of the pixel line to be drawn across the screen

 LDA L5F60,X            \ Fetch the colour of the first byte on the line from
 AND #%00000011         \ the X-th entry in L5F60 (bits 0 to 2)
 TAY

 LDA colourByte,Y       \ Set A to the pixel byte for four pixels in colour Y
                        \ to use as the first byte on the line

                        \ Fall through into DrawTrackBytes to draw the pixel
                        \ bytes that make up the line we want to draw
                        \
                        \ If we are drawing the lines above the top of the
                        \ dashboard, then the following then loops back to the
                        \ start of the DrawTrackLine routine to keep drawing
                        \ lines until we do reach the top of the dashboard, at
                        \ which point we return from the DrawTrackLine routine
                        \ to part 2 of DrawTrackView, which modifies the code to
                        \ draw subsequent lines around the shape of the
                        \ dashboard

\ ******************************************************************************
\
\       Name: DRAW_BYTE
\       Type: Macro
\   Category: Graphics
\    Summary: Draw a pixel byte as part of a horizontal line when drawing the
\             track view
\
\ ------------------------------------------------------------------------------
\
\ This routine draws a row of four pixels (i.e. one byte) as part of the track
\ view.
\
\ The track view is drawn one line at a time, with each line being one pixel
\ high. Each of these lines is drawn as a sequence of bytes, with each byte
\ containing four pixels.
\
\ Each macro instance copies one pixel byte into screen memory, so that's one
\ four-pixel block within the horizontal line. So the full sequence of macros,
\ from DRAW_BYTE 0 through DRAW_BYTE 39, draws a one-pixel high line across
\ the full width of the screen. In other words, each DRAW_BYTE macro draws a
\ character block's worth of line, as the screen is 40 character blocks wide.
\
\ Each macro instance moves one pixel byte, from offset X within dash data block
\ I%, into screen memory. The offset X is decremented for each run through the
\ sequence of macros, as data is stored at the end of each dash data block. So
\ as each pixel line is drawn, moving down the screen, X decrements down from 79
\ (the start of each dash data block) as we work our way through the data.
\
\ The destination address in screen memory for the data is governed by (Q P),
\ which points to the address of the pixel byte to update in the first byte
\ (i.e. the address of the first pixel in the line across the screen).
\
\ If the dash data byte is zero, then the current value of A is stored in screen
\ memory (i.e. the same value that was stored in the previous byte).
\
\ If the dash data byte is non-zero, then this is stored in A and screen memory,
\ unless it is &55, in which a zero is stored in A and screen memory.
\
\ As it is copied, the source dash data byte is zeroed, so the macro effectively
\ moves a byte into screen memory, clearing it in the process.
\
\ Arguments:
\
\   I%                  The pixel byte number (0 to 39)
\
\   X                   The offset within the dash data of the data to be drawn
\                       on the screen (from &7F down, as the dash data lives at
\                       the end of each dash data block)
\
\   A                   The value stored in screen memory in the previous pixel
\                       byte (or the starting value if this is pixel byte 0)
\
\   (Q P)               The screen address of the leftmost character block to
\                       update (i.e. the screen address of the pixel byte to
\                       draw in the first character block on the line, so this
\                       is the address of the start of the horizontal line that
\                       the seqential macros draw)
\
\   (S R)               Contains (Q P) + &100, to be used instead of (Q P) for
\                       pixel bytes 32 to 39
\
\ ******************************************************************************

MACRO DRAW_BYTE I%

 LDY dashData+&80*I%,X  \ Set Y to the X-th byte of dash data block I%

 BEQ P%+10              \ If Y = 0, skip the next three instructions (i.e. jump
                        \ to the LDY #LO(8*I%) instruction to leave the value of
                        \ A alone)

                        \ Otherwise Y is non-zero, and we do the following in
                        \ the next three instructions:
                        \
                        \   * Zero the location in code block I% from which we
                        \     just read a byte
                        \
                        \   * Set A to the byte we just read from code block I%,
                        \     unless the value is &55, in which case set A = 0

 LDA #0                 \ Zero the X-th byte of dash data block I%
 STA dashData+&80*I%,X

 LDA zeroIfYIs55,Y      \ Set A to the Y-th byte from zeroIfYIs55
                        \
                        \ This sets A = Y, unless Y = &55, in which case it sets
                        \ Y = 0, so that's:
                        \
                        \   If Y = &55, set A = 0, otherwise set A = Y
                        \
                        \ The zeroIfYIs55 table exists just to enable us to do
                        \ this logic in one instruction

                        \ If Y = 0 above, this is where we jump to

 LDY #LO(8*I%)          \ Store A in character block I% in screen memory, as an
 IF I% < 32             \ offset from (Q P)
  STA (P),Y             \
 ELSE                   \ (S R) is used instead of (Q P) for pixel bytes 32 to
  STA (R),Y             \ 39, which saves us from having to increment Q to cross
 ENDIF                  \ the page boundary, as (S R) = (Q P) + &100

                        \ Fall through into the next DRAW_BYTE macro to draw
                        \ the next pixel byte along to the right, continuing the
                        \ horizontal line of pixels

ENDMACRO

\ ******************************************************************************
\
\       Name: DrawTrackBytes (Part 1 of 3)
\       Type: Subroutine
\   Category: Graphics
\    Summary: Draw the pixel bytes that make up the track view (0 to 15)
\
\ ------------------------------------------------------------------------------
\
\ This routine draws pixel bytes 0 to 39, which draws a one-pixel high line in
\ the track view.
\
\ Note that this routine starts on a page boundary (DrawTrackBytes = &7C00).
\ This is important as it means the code can be modified at a specific address
\ using only the low byte of that address, as we know that high byte is the same
\ throughout the routine. This is why the staDrawByte and ldaDrawByte lookup
\ tables only need to store the low bytes of the addresses for instructions that
\ we need to modify.
\
\ ******************************************************************************

.DrawTrackBytes

 DRAW_BYTE 0            \ Draw pixel bytes 0 to 15
 DRAW_BYTE 1
 DRAW_BYTE 2
 DRAW_BYTE 3
 DRAW_BYTE 4
 DRAW_BYTE 5
 DRAW_BYTE 6
 DRAW_BYTE 7
 DRAW_BYTE 8
 DRAW_BYTE 9
 DRAW_BYTE 10
 DRAW_BYTE 11
 DRAW_BYTE 12
 DRAW_BYTE 13
 DRAW_BYTE 14
 DRAW_BYTE 15

 JMP byte1              \ Jump to part 2 to continue with pixel byte 16

\ ******************************************************************************
\
\       Name: DrawTrackView (Part 2 of 4)
\       Type: Subroutine
\   Category: Graphics
\    Summary: Draw the part of the track view that fits around the dashboard
\
\ ------------------------------------------------------------------------------
\
\ This routine modifes the DrawTrackBytes routine so that it draws all the
\ remaining lines in the track view so they fit around the shape of the
\ dashboard.
\
\ ******************************************************************************

.view1

                        \ We get here with X = 44, as in part 1 we drew the
                        \ lines specified by dash data offsets 79 to 44
                        \
                        \ In the following loop, we draw the lines specified by
                        \ dash data offsets 43 to 28

 LDA #&60               \ Set A to the opcode for the RTS instruction

 STA byte3              \ Modify the following instruction in DrawTrackBytes
                        \ (part 3):
                        \
                        \   CPX #44 -> RTS
                        \
                        \ so that calls to DrawTrackLine and DrawTrackBytes from
                        \ now on will draw individual lines rather than looping
                        \ back to DrawTrackLine as they did for the lines above
                        \ the dashboard

.view2

 DEX                    \ Decrement the dash data block pointer to point to
                        \ the data for the next line

 LDY staDrawByte,X      \ Set Y to the X-th entry in staDrawByte, which contains
                        \ the low byte of the address of the STA (P),Y
                        \ instruction in the DRAW_STRIPE macro given in the
                        \ table

 CPY view3+1            \ If the instruction at view3 has already been modified
 BEQ view5              \ to this address, jump to view5 to skip the following
                        \ modifications, as they have already been done on the
                        \ previous iteration of the loop

 LDA #&91               \ Set A to the opcode for the STA (P),Y instruction

.view3

 STA DrawTrackBytes+15  \ Modify the specified instruction back to STA (P),Y
                        \ (the address of the modified instruction is set by the
                        \ following, so the first time we run this line it has
                        \ no effect)

 STY view4+1            \ Modify the instruction at view4 to change the low byte
                        \ of the address to the X-th entry in staDrawByte, so
                        \ the instruction at view4 changes the STA (P),Y
                        \ instruction to an RTS in the DRAW_STRIPE macro given
                        \ in staDrawByte

 STY view3+1            \ Modify the instruction at view3 to change the low byte
                        \ of the address to the X-th entry in staDrawByte, so
                        \ the instruction at view3 changes the RTS instruction
                        \ back to STA (P),Y when we loop back around

 LDA #&60               \ Set A to the opcode for the RTS instruction

.view4

 STA DrawTrackBytes     \ Modify the specified instruction to an RTS so the next
                        \ call to DrawTrackLine will return at that point (the
                        \ address of the modified instruction is set above)

 LDY ldaDrawByte,X      \ Set Y to the X-th entry in ldaDrawByte, which contains
                        \ the low byte of the LDA #0 instruction in the specific
                        \ DRAW_STRIPE macro, as given in the table

 STY view6+1            \ Modify the instruction at view6 to change the low byte
                        \ of the address to the X-th entry in ldaDrawByte, so
                        \ the instruction at view6 changes so it jumps to the
                        \ LDA #0 instruction in the DRAW_BYTE macro specified in
                        \ the table

.view5

 JSR DrawTrackLine      \ Draw the left portion of this track line
                        \
                        \ This routine was modified above to return from the
                        \ subroutine at the STA instruction in the DRAW_BYTE
                        \ macro specified in the staDrawByte table, so this
                        \ returns the last pixel byte of this portion of the
                        \ line in A, i.e. the rightmost byte of the left portion
                        \ of the track line, where the line meets the left
                        \ border of the central part of the dashboard

 AND leftDashMask,X     \ We now merge the track byte in A with the left edge
 ORA leftDashPixels,X   \ of the dashboard, by masking out the pixels in A that
 STA (P),Y              \ are hidden by the dashboard (with AND leftDashMask),
                        \ and replacing them with the pixels from the left edge
                        \ of the dashboard (with ORA leftDashPixels)

 LDA firstPixelTrack,X  \ Fetch the the track pixel byte that would be shown
                        \ along the right edge of the dashboard, i.e. the
                        \ leftmost byte of the right portion of the track line,
                        \ where the line meets the right border of the central
                        \ part of the dashboard

 AND rightDashMask,X    \ We now merge the track byte in A with the right edge
 ORA rightDashPixels,X  \ of the dashboard, by masking out the pixels in A that
                        \ are hidden by the dashboard (with AND rightDashMask),
                        \ and replacing them with the pixels from the left edge
                        \ of the dashboard (with ORA rightDashPixels)

 TAY                    \ Copy the pixel byte into Y, because the following JSR
                        \ jumps straight to the LDA #0 instruction within the
                        \ DRAW_BYTE macro, and at that point the macro expects
                        \ the pixel byte to be in Y rather than A

.view6

 JSR byte2              \ Draw the right portion of this track line
                        \
                        \ This JSR was modified above to jump to the LDA #0
                        \ instruction in the DRAW_BYTE macro specified in the
                        \ ldaDrawByte table

 CPX #28                \ Loop back to keep drawing lines, working our way down
 BNE view2              \ through the dash data from entry 44 down to entry 28

 JMP view7              \ Jump to part 3 to draw the rest of the track view from
                        \ offsets 27 to 3, modifying the code so it draws the
                        \ rest of the lines around the shape of the dashboard
                        \ and the shape of the tyres

\ ******************************************************************************
\
\       Name: DrawTrackBytes (Part 2 of 3)
\       Type: Subroutine
\   Category: Graphics
\    Summary: Draw the pixel bytes that make up the track view (16 to 39)
\
\ ------------------------------------------------------------------------------
\
\ Note that the latter half of this routine, from .byte2 onwards, starts on a
\ page boundary (byte2 = &7E00). This is important as it means the code can be
\ modified at a specific address using only the low byte of that address, as we
\ know that high byte is the same throughout the routine. This is why the lookup
\ tables at staDrawByte and ldaDrawByte only need to store the low bytes of
\ the addresses for instructions that we need to modify.

\ ******************************************************************************

.byte1

 DRAW_BYTE 16           \ Draw pixel bytes 16 to 25
 DRAW_BYTE 17
 DRAW_BYTE 18
 DRAW_BYTE 19
 DRAW_BYTE 20
 DRAW_BYTE 21
 DRAW_BYTE 22
 DRAW_BYTE 23
 DRAW_BYTE 24
 DRAW_BYTE 25

.byte2

 DRAW_BYTE 26           \ Draw pixel bytes 26 to 39
 DRAW_BYTE 27
 DRAW_BYTE 28
 DRAW_BYTE 29
 DRAW_BYTE 30
 DRAW_BYTE 31
 DRAW_BYTE 32
 DRAW_BYTE 33
 DRAW_BYTE 34
 DRAW_BYTE 35
 DRAW_BYTE 36
 DRAW_BYTE 37
 DRAW_BYTE 38
 DRAW_BYTE 39

.byte3

 CPX #44                \ If X = 44, then we have just drawn the last pixel
 BEQ byte4              \ line above the top of the dashboard, so return from
                        \ the subroutine so we can modify the routine to draw
                        \ subsequent lines in two parts, to fit around the
                        \ dashboard (as byte3 contains an RTS)

 DEX                    \ Decrement the dash data pointer in X to move on to the
                        \ next pixel line

\ ******************************************************************************
\
\       Name: DrawTrackLine (Part 1 of 2)
\       Type: Subroutine
\   Category: Graphics
\    Summary: Draw a pixel line across the screen in the track view, broken up
\             into bytes
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The offset within the dash data of the data to be drawn
\                       on the screen (from &7F down, as the dash data lives at
\                       the end of each dash data block)
\
\   (Q P)               The screen address of the leftmost pixel of the line
\                       above where we want to draw the horizontal pixel line
\
\   (S R)               Contains (Q P) + &100
\
\ ******************************************************************************

.DrawTrackLine

                        \ We start by incrementing (Q P) and (S R) to point to
                        \ the next pixel row down the screen

 LDY P                  \ Set Y = P + 1, which is the low byte of (Q P) + 1
 INY

 TYA                    \ If Y mod 8 = 0 then incrementing (Q P) will take us
 AND #&07               \ into the next character block (i.e. from pixel row 7
 BEQ prow1              \ to pixel row 8), so jump to prow1 to update the screen
                        \ addresses accordingly

 STY P                  \ Otherwise set the low bytes of (Q P) and (S R) to Y,
 STY R                  \ so this does:
                        \
                        \   (Q P) = (Q P) + 1
                        \
                        \   (S R) = (S R) + 1
                        \
                        \ so they point to the next pixel row down the screen

 JMP prow2              \ Jump to part 2 to draw this pixel row

.prow1

 TYA                    \ Set (Q P) = Y + &138
 CLC                    \
 ADC #&38               \ starting with the low bytes
 STA P
 STA R

 LDA Q                  \ And then the high bytes, so (Q P) points to start of
 ADC #&01               \ the character block on the next character row (i.e.
 STA Q                  \ the next pixel row down)

 ADC #&01               \ Set (S R) = (Q P) + &100
 STA S

 JMP prow2              \ Jump to part 2 to draw this pixel row

\ ******************************************************************************
\
\       Name: DrawTrackBytes (Part 3 of 3)
\       Type: Subroutine
\   Category: Graphics
\    Summary: 
\
\ ******************************************************************************

.byte4

 RTS                    \ Return from the subroutine

\ ******************************************************************************
\
\       Name: DrawTrackView (Part 3 of 4)
\       Type: Subroutine
\   Category: Graphics
\    Summary: Draw the part of the track view that fits around the dashboard and
\             tyres
\
\ ------------------------------------------------------------------------------
\
\ This routine modifes the DrawTrackBytes routine so that it draws all the
\ remaining lines in the track view so they fit around the shape of the
\ dashboard and the tyres.
\
\ ******************************************************************************

                        \ We get here with X = 28, as in part 1 we drew the
                        \ lines specified by dash data offsets 79 to 44, and in
                        \ part 2 we drew the lines specified by dash data
                        \ offsets 43 to 28
                        \
                        \ In the following loop, we draw the lines specified by
                        \ dash data offsets 27 to 3

.view7

 DEX                    \ Decrement the dash data block pointer to point to
                        \ the data for the next line

 LDY staDrawByte,X      \ Set Y to the X-th entry in staDrawByte, which contains
                        \ the low byte of the address of the STA (P),Y
                        \ instruction in the DRAW_STRIPE macro given in the
                        \ table

 CPY view8+1            \ If the instruction at view8 has already been modified
 BEQ view10             \ to this address, jump to view10 to skip the following
                        \ modifications, as they have already been done on the
                        \ previous iteration of the loop

 LDA #&91               \ Set A to the opcode for the STA (P),Y instruction

.view8

 STA DrawTrackBytes+15  \ Modify the specified instruction back to STA (P),Y
                        \ (the address of the modified instruction is set by the
                        \ following, so the first time we run this line it has
                        \ no effect)

 STY view9+1            \ Modify the instruction at view9 to change the low byte
                        \ of the address to the X-th entry in staDrawByte, so
                        \ the instruction at view9 changes the STA (P),Y
                        \ instruction to an RTS in the DRAW_STRIPE macro given
                        \ in staDrawByte

 STY view8+1            \ Modify the instruction at view8 to change the low byte
                        \ of the address to the X-th entry in staDrawByte, so
                        \ the instruction at view8 changes the RTS instruction
                        \ back to STA (P),Y when we loop back around

 LDA #&60               \ Set A to the opcode for the RTS instruction

.view9

 STA DrawTrackBytes     \ Modify the specified instruction to an RTS so the next
                        \ call to DrawTrackLine will return at that point (the
                        \ address of the modified instruction is set above)

.view10

                        \ The following code is normally run at the start of the
                        \ DrawTrackLine routine, but we are going to call the
                        \ DrawTrackBytes routine to draw our line instead, so
                        \ we can skip the bytes that are hidden behind the left
                        \ tyre
                        \
                        \ So we repeat the code here, which increments the
                        \ screen addresses in (Q P) and (S R) to point to the
                        \ next pixel row down the screen

 LDY P                  \ Set Y = P + 1, which is the low byte of (Q P) + 1
 INY

 TYA                    \ If Y mod 8 <> 0 then incrementing (Q P) will keep us
 AND #&07               \ within the current character block (i.e. the new pixel
 BNE view11             \ row will be 7 or less), so jump to view11 to store the
                        \ incremented values

                        \ Otherwise incrementing (Q P) will take us into the
                        \ next character block (i.e. from pixel row 7 to pixel
                        \ row 8), so we need to update the screen addresses to
                        \ jump to the next character row

 TYA                    \ Set (Q P) = Y + &138
 CLC                    \
 ADC #&38               \ starting with the low bytes
 STA P
 STA R

 LDA Q                  \ And then the high bytes, so (Q P) points to start of
 ADC #&01               \ the character block on the next character row (i.e.
 STA Q                  \ the next pixel row down)

 ADC #&01               \ Set (S R) = (Q P) + &100
 STA S

 BCC view12             \ Jump to view12 to skip the following

.view11

                        \ If we get here then incrementing the screen addresses
                        \ keeps us within the current character block, so we can
                        \ store the incremented addresses in (Q P) and (S R)

 STY P                  \ Set the low bytes of (Q P) and (S R) to Y, so this
 STY R                  \ does:
                        \
                        \   (Q P) = (Q P) + 1
                        \
                        \   (S R) = (S R) + 1
                        \
                        \ so they point to the next pixel row down the screen

.view12

                        \ The staDrawByteTyre table contains the low byte offset
                        \ of the address of the STA (P),Y instruction for the
                        \ track line, which we convert into an RTS when drawing
                        \ the track line up against the right tyre, so we stop
                        \ in time (see the code that modifies view14 and view15
                        \ below)
                        \
                        \ As the tyres are reflections of each other, we can
                        \ also use this value to calculate the starting point
                        \ for the line that starts at the left tyre, which is
                        \ what we do now

 LDA #LO(byte3)+3       \ Set A = LO(byte3) + 3 - staDrawByteTyre
 SEC                    \
 SBC staDrawByteTyre,X  \ There are 14 instances of the DRAW_BYTE macro between
                        \ byte2 and byte3, ranging from DRAW_BYTE 26 up to
                        \ DRAW_BYTE 39
                        \
                        \ This calculation converts the low address byte from
                        \ the staDrawByteTyre table so that instead of pointing
                        \ to the LDA #0 instruction in the n-th DRAW_BYTE macro,
                        \ it points to the LDA #0 instruction in the 14-n-th
                        \ macro, as an offset from byte2
                        \
                        \ This effectively takes the end point given in the
                        \ staDrawByteTyre table and returns the start point if
                        \ the range DRAW_BYTE 26 to DRAW_BYTE 39 were
                        \ "reflected" into DRAW_BYTE 39 to DRAW_BYTE 26
                        \
                        \ This enables us to calculate the offset of the start
                        \ point's macro for the left tyre, as an offset from
                        \ DrawTrackBytes, which is what we want

 STA view13+1           \ Modify the instruction at view13 to change the low byte
                        \ of the address to A, so the instruction at view13
                        \ changes so it jumps to the LDA #0 instruction in the
                        \ DRAW_BYTE macro specified in the table

 LDY tyreEdgeIndex,X    \ Set Y to the index of the mask and pixel bytes for the
                        \ tyre edge for this track line, so we can use it below
                        \ to fetch the correct entries from leftTyreMask and
                        \ leftTyrePixels

 LDA firstPixelTyre,X   \ Fetch the the track pixel byte that would be shown
                        \ along the edge of the left tyre, i.e. the leftmost
                        \ byte of the track line, where the line meets the left
                        \ tyre

 AND leftTyreMask,Y     \ We now merge the track byte in A with the edge of the
 ORA leftTyrePixels,Y   \ left tyre, by masking out the pixels in A that are
                        \ hidden by the tyre (with AND leftTyreMask), and
                        \ replacing them with the pixels from the edge of the
                        \ left tyre (with ORA leftTyrePixels)

 TAY                    \ Copy the pixel byte into Y, because the following JSR
                        \ jumps straight to the LDA #0 instruction within the
                        \ DRAW_BYTE macro, and at that point the macro expects
                        \ the pixel byte to be in Y rather than A

.view13

 JSR DrawTrackBytes     \ Draw the left portion of this track line
                        \
                        \ This routine was modified above to return from the
                        \ subroutine at the STA instruction in the DRAW_BYTE
                        \ macro specified in the staDrawByte table, so this
                        \ returns the last pixel byte of this portion of the
                        \ line in A, i.e. the rightmost byte of the left portion
                        \ of the track line, where the line meets the left
                        \ border of the central part of the dashboard

 AND leftDashMask,X     \ We now merge the track byte in A with the left edge
 ORA leftDashPixels,X   \ of the dashboard, by masking out the pixels in A that
                        \ are hidden by the dashboard (with AND leftDashMask),
                        \ and replacing them with the pixels from the left edge
                        \ of the dashboard (with ORA leftDashPixels)

 STA (P),Y              \ Write the merged pixel byte into screen memory

 LDY staDrawByteTyre,X  \ Set Y to the X-th entry in staDrawByteTyre, which
                        \ contains the low byte of the address of the STA (P),Y
                        \ instruction in the DRAW_STRIPE macro given in the
                        \ table

 CPY view14+1           \ If the instruction at view14 has already been modified
 BEQ view16             \ to this address, jump to view16 to skip the following
                        \ modifications, as they have already been done on the
                        \ previous iteration of the loop

 LDA #&91               \ Set A to the opcode for the STA (P),Y instruction

.view14

 STA byte2+15           \ Modify the specified instruction back to STA (P),Y
                        \ (the address of the modified instruction is set by the
                        \ following, so the first time we run this line it has
                        \ no effect)

 STY view15+1           \ Modify the instruction at view15 to change the low byte
                        \ of the address to the X-th entry in staDrawByteTyre, so
                        \ the instruction at view15 changes the STA (P),Y
                        \ instruction to an RTS in the DRAW_STRIPE macro given
                        \ in staDrawByteTyre

 STY view14+1           \ Modify the instruction at view14 to change the low byte
                        \ of the address to the X-th entry in staDrawByteTyre, so
                        \ the instruction at view14 changes the STA (P),Y
                        \ instruction to an RTS in the DRAW_STRIPE macro given
                        \ in staDrawByteTyre

 LDA #&60               \ Set A to the opcode for the RTS instruction

.view15

 STA byte2              \ Modify the specified instruction to an RTS so the next
                        \ call to byte2 will return at that point (the address
                        \ of the modified instruction is set above)

.view16

 LDY ldaDrawByte,X      \ Set Y to the X-th entry in ldaDrawByte, which contains
                        \ the low byte of the LDA #0 instruction in the specific
                        \ DRAW_STRIPE macro, as given in the table

 STY view17+1           \ Modify the instruction at view17 to change the low byte
                        \ of the address to the X-th entry in ldaDrawByte, so
                        \ the instruction at view17 changes so it jumps to the
                        \ LDA #0 instruction in the DRAW_BYTE macro specified in
                        \ the table

 LDA firstPixelTrack,X  \ Fetch the the track pixel byte that would be shown
                        \ along the right edge of the dashboard, i.e. the
                        \ leftmost byte of the right portion of the track line,
                        \ where the line meets the right border of the central
                        \ part of the dashboard

 AND rightDashMask,X    \ We now merge the track byte in A with the right edge
 ORA rightDashPixels,X  \ of the dashboard, by masking out the pixels in A that
                        \ are hidden by the dashboard (with AND rightDashMask),
                        \ and replacing them with the pixels from the left edge
                        \ of the dashboard (with ORA rightDashPixels)

 TAY                    \ Copy the pixel byte into Y, because the following JSR
                        \ jumps straight to the LDA #0 instruction within the
                        \ DRAW_BYTE macro, and at that point the macro expects
                        \ the pixel byte to be in Y rather than A

.view17

 JSR byte2              \ Draw the right portion of this track line
                        \
                        \ This JSR was modified above to jump to the LDA #0
                        \ instruction in the DRAW_BYTE macro specified in the
                        \ ldaDrawByte table

 STY U                  \ Store Y in U so we can retrieve it below

 LDY tyreEdgeIndex,X    \ Set Y to the index of the mask and pixel bytes for the
                        \ tyre edge for this track line, so we can use it to
                        \ fetch the correct entries from rightTyreMask and
                        \ rightTyrePixels

 AND rightTyreMask,Y    \ We now merge the track byte in A with the edge of the
 ORA rightTyrePixels,Y  \ right tyre, by masking out the pixels in A that are
                        \ hidden by the tyre (with AND rightTyreMask), and
                        \ replacing them with the pixels from the edge of the
                        \ right tyre (with ORA rightTyrePixels)

 LDY U                  \ Retrieve the value of Y that we stored above

 STA (R),Y              \ Write the merged pixel byte into screen memory, using
                        \ (S R) as the screen address as this is at the right
                        \ end of the track line

 CPX #3                 \ If we just drew the line at dash data entry 3, jump
 BEQ view18             \ to view18 to stop drawing track lines

 JMP view7              \ Loop back to keep drawing lines, working our way down
                        \ through the dash data from entry 27 down to entry 3

.view18

 JMP view19             \ Jump to part 4 to reverse our code modifications

\ ******************************************************************************
\
\       Name: DrawCarInMirror
\       Type: Subroutine
\   Category: Dashboard
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ 
\
\ ******************************************************************************

.DrawCarInMirror

 STA RR
 STY G
 LDA mirrorAddressHi,Y
 STA Q
 LDA mirrorAddressLo,Y
 STA P

 LDA L3EFA,Y
 STA W
 LDA L40FA,Y
 TAY

.L7FCD

 LDA #&F0
 CPY RR
 BCS L7FDF
 CPY N
 BCC L7FDF
 LDX VIA+&68
 AND &2000,X
 AND L0061

.L7FDF

 STA (P),Y
 DEY
 BPL L7FF8
 TYA
 AND #&07
 CMP #&07
 BCC L7FF8
 LDA P
 SEC
 SBC #&38
 STA P
 LDA Q
 SBC #&01
 STA Q

.L7FF8

 CPY W
 BCS L7FCD
 LDY G
 RTS

 EQUB &FF

\ ******************************************************************************
\
\ Save Revs.bin
\
\ For an explanation of the following, see the deep dive on "The jigsaw puzzle
\ binary"
\
\ ******************************************************************************

\ Step 1: Insert the dashboard image into the game code, split into 18 pieces

ORG &9000

INCBIN "1-source-files/images/dashboard.bin"

COPYBLOCK &9EF6, &9EF6+10, dashData25
COPYBLOCK &9ECD, &9EF6, dashData26
COPYBLOCK &9E99, &9ECD, dashData27
COPYBLOCK &9E61, &9E99, dashData28
COPYBLOCK &9E25, &9E61, dashData29
COPYBLOCK &9DE5, &9E25, dashData30
COPYBLOCK &9DA1, &9DE5, dashData31
COPYBLOCK &9D58, &9DA1, dashData32
COPYBLOCK &9D0B, &9D58, dashData33
COPYBLOCK &9CBE, &9D0B, dashData34
COPYBLOCK &9C72, &9CBE, dashData35
COPYBLOCK &9C38, &9C72, dashData36
COPYBLOCK &9C04, &9C38, dashData37
COPYBLOCK &9BD0, &9C04, dashData38
COPYBLOCK &9B9C, &9BD0, dashData39
COPYBLOCK &9B68, &9B9C, dashData40
COPYBLOCK &9B25, &9B68, dashData41
COPYBLOCK &9000, &9B25, dashData42

\ Step 2: Insert the code that runs in screen memory into the game code, split
\ into 26 pieces

COPYBLOCK &7FCC, &8000, dashData0
COPYBLOCK &7F98, &7FCC, dashData1
COPYBLOCK &7F64, &7F98, dashData2
COPYBLOCK &7F2A, &7F64, dashData3
COPYBLOCK &7EDE, &7F2A, dashData4
COPYBLOCK &7E91, &7EDE, dashData5
COPYBLOCK &7E44, &7E91, dashData6
COPYBLOCK &7DFB, &7E44, dashData7
COPYBLOCK &7DB7, &7DFB, dashData8
COPYBLOCK &7D77, &7DB7, dashData9
COPYBLOCK &7D3B, &7D77, dashData10
COPYBLOCK &7D03, &7D3B, dashData11
COPYBLOCK &7CCF, &7D03, dashData12
COPYBLOCK &7CA6, &7CCF, dashData13
COPYBLOCK &7C82, &7CA6, dashData14
COPYBLOCK &7C5E, &7C82, dashData15
COPYBLOCK &7C3A, &7C5E, dashData16
COPYBLOCK &7C16, &7C3A, dashData17
COPYBLOCK &7BF2, &7C16, dashData18
COPYBLOCK &7BCE, &7BF2, dashData19
COPYBLOCK &7BAA, &7BCE, dashData20
COPYBLOCK &7B86, &7BAA, dashData21
COPYBLOCK &7B62, &7B86, dashData22
COPYBLOCK &7B3E, &7B62, dashData23
COPYBLOCK &7B1A, &7B3E, dashData24
COPYBLOCK &7AF6+10, &7B1A, dashData25+10

\ 3: Split the game code into the parts that make up the game binary file and
\ pack them together in the correct order

COPYBLOCK &5FD0, &6700, &64D0
COPYBLOCK &0D00, &16DC, &5A80
COPYBLOCK &7000, &70DB, &1500
COPYBLOCK &70DB, &7725, &5300
COPYBLOCK &0B00, &0D00, &1300
COPYBLOCK &7900, &7A00, &1200
CLEAR &645C, &64D0

\ 4: Add workspace noise to match the final game binary

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

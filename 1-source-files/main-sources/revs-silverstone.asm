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

GUARD &6000             \ Guard against assembling over screen memory

\ ******************************************************************************
\
\ Configuration variables
\
\ ******************************************************************************

LOAD% = &70DB           \ The load address of the main code binary

CODE% = &70DB           \ The address of the main game code

\ ******************************************************************************
\
\ REVS SILVERSTONE TRACK
\
\ Produces the binary file AVIA.bin that contains the main game code.
\
\ ******************************************************************************

ORG CODE%

 NOP

\ ******************************************************************************
\
\ Save Silvers.bin
\
\ ******************************************************************************

SAVE "3-assembled-output/Silvers.bin", LOAD%, P%

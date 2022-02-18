\ ******************************************************************************
\
\ REVS DISC IMAGE SCRIPT
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
\ This source file produces one of the following SSD disc images, depending on
\ which release is being built:
\
\   * revs-acornsoft.ssd
\   * revs-superior.ssd
\
\ This can be loaded into an emulator or a real BBC Micro.
\
\ ******************************************************************************

PUTFILE "1-source-files/boot-files/$.!BOOT.bin", "!BOOT", &FFFFFF, &FFFFFF
PUTFILE "1-source-files/basic-programs/$.REVS.bin", "REVS", &FF1900, &FF8023
PUTFILE "3-assembled-output/Revs1.bin", "Revs1", &002000, &002000
\PUTFILE "3-assembled-output/Nurburgring.bin", "Silvers", &0070DB, &0070DB
\PUTFILE "3-assembled-output/Snetterton.bin", "Silvers", &0070DB, &0070DB
PUTFILE "3-assembled-output/Silverstone.bin", "Silvers", &0070DB, &0070DB
PUTFILE "3-assembled-output/Revs.bin", "Revs?", &001200, &001200

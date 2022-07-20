\ ******************************************************************************
\
\ REVS DISC IMAGE SCRIPT
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
\ This source file produces one of the following SSD disc images, depending on
\ which release is being built:
\
\   * revs-acornsoft.ssd
\   * revs-superior.ssd
\
\ This can be loaded into an emulator or a real BBC Micro.
\
\ ******************************************************************************

INCLUDE "1-source-files/main-sources/revs-header.h.asm"

_ACORNSOFT              = (_VARIANT = 1)
_SUPERIOR               = (_VARIANT = 2)
_4TRACKS                = (_VARIANT = 3)
_REVSPLUS               = (_VARIANT = 4)

IF _ACORNSOFT

 PUTFILE "1-source-files/boot-files/$.!BOOT.bin", "!BOOT", &FFFFFF, &FFFFFF
 PUTFILE "1-source-files/basic-programs/$.REVS.bin", "REVS", &FF1900, &FF8023
 PUTFILE "3-assembled-output/Revs1.bin", "Revs1", &002000, &002000
 PUTFILE "3-assembled-output/Silverstone.bin", "Silvers", &0070DB, &0070DB
 PUTFILE "3-assembled-output/Revs2.bin", "Revs2", &001200, &001200

ELIF _4TRACKS

 PUTFILE "1-source-files/boot-files/$.!BOOT4.bin", "!BOOT", &FFFFFF, &FFFFFF
 PUTFILE "1-source-files/basic-programs/$.MENU.bin", "MENU", &FF1900, &FF8023
 PUTFILE "3-assembled-output/Revs1.bin", "Revs1", &002000, &002000
 PUTFILE "3-assembled-output/BrandsHatch.bin", "B", &0070DB, &0070DB
 PUTFILE "3-assembled-output/DoningtonPark.bin", "D", &0070DB, &0070DB
 PUTFILE "3-assembled-output/OultonPark.bin", "O", &0070DB, &0070DB
 PUTFILE "3-assembled-output/Snetterton.bin", "S", &0070DB, &0070DB
 PUTFILE "3-assembled-output/Revs2.bin", "Revs2", &001200, &001200

ELIF _SUPERIOR

 PUTFILE "1-source-files/boot-files/$.!BOOTS.bin", "!BOOT", &FFFFFF, &FFFFFF
 PUTFILE "1-source-files/basic-programs/$.REVSMEN.bin", "REVSMEN", &FF1900, &FF8023
 PUTFILE "1-source-files/images/$.5TRSCRN.bin", "5TRSCRN", &007C00, &007C00
 PUTFILE "3-assembled-output/BrandsHatch.bin", "BRANDS", &0070DB, &0070DB
 PUTFILE "3-assembled-output/DoningtonPark.bin", "DONING", &0070DB, &0070DB
 PUTFILE "3-assembled-output/OultonPark.bin", "OULTON", &0070DB, &0070DB
 PUTFILE "3-assembled-output/Snetterton.bin", "SNETTER", &0070DB, &0070DB
 PUTFILE "3-assembled-output/Silverstone.bin", "SILVER", &0070DB, &0070DB
 PUTFILE "3-assembled-output/Revs2.bin", "REVS2", &001200, &001200

ELIF _REVSPLUS

 PUTFILE "1-source-files/boot-files/$.!BOOTS.bin", "!BOOT", &FFFFFF, &FFFFFF
 PUTFILE "1-source-files/basic-programs/$.REVSPLUS.bin", "REVSMEN", &FF1900, &FF8023
 PUTFILE "1-source-files/images/$.PLUSCRN.bin", "PLUSCRN", &007C00, &007C00
 PUTFILE "3-assembled-output/BrandsHatch.bin", "BRANDS", &0070DB, &0070DB
 PUTFILE "3-assembled-output/DoningtonPark.bin", "DONING", &0070DB, &0070DB
 PUTFILE "3-assembled-output/OultonPark.bin", "OULTON", &0070DB, &0070DB
 PUTFILE "3-assembled-output/Snetterton.bin", "SNETTER", &0070DB, &0070DB
 PUTFILE "3-assembled-output/Silverstone.bin", "SILVER", &0070DB, &0070DB
 PUTFILE "3-assembled-output/Nurburgring.bin", "NURBURG", &0070DB, &0070DB
 PUTFILE "3-assembled-output/Revs2.bin", "REVS2", &001200, &001200
 PUTFILE "1-source-files/text-files/READMEPLUS.txt", "README", &FFFFFF, &FFFFFF

ENDIF

\PUTFILE "3-assembled-output/Nurburgring.bin", "Silvers", &0070DB, &0070DB

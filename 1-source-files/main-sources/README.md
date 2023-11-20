# Annotated source code for the BBC Micro disc version of Revs

This folder contains the annotated source code for the BBC Micro disc version of Revs.

* Main source files:

  * [revs-source.asm](revs-source.asm) contains the main source for the game

  * [revs-brandshatch.asm](revs-brandshatch.asm) contains the track data for Brands Hatch

  * [revs-doningtonpark.asm](revs-doningtonpark.asm) contains the track data for Donington Park

  * [revs-nurburgring.asm](revs-nurburgring.asm) contains the track data for the Nürburgring

  * [revs-oultonpark.asm](revs-oultonpark.asm) contains the track data for Oulton Park

  * [revs-silverstone.asm](revs-silverstone.asm) contains the track data for Silverstone

  * [revs-snetterton.asm](revs-snetterton.asm) contains the track data for Snetterton

* Other source files:

  * [revs-loader.asm](revs-loader.asm) contains the source for the loader

  * [revs-disc.asm](revs-disc.asm) builds the SSD disc image from the assembled binaries and other source files

* Files that are generated during the build process:

  * [revs-build-options.asm](revs-build-options.asm) stores the make options in BeebAsm format so they can be included in the assembly process

---

_Mark Moxon_
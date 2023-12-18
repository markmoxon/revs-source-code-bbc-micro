BEEBASM?=beebasm
PYTHON?=python

# A make command with no arguments will build the Acornsoft variant with
# crc32 verification of the game binaries
#
# Optional arguments for the make command are:
#
#   variant=<release>   Build the specified variant:
#
#                         acornsoft (default)
#                         4tracks
#                         superior
#                         revsplus
#
#   verify=no           Disable crc32 verification of the game binaries
#
# So, for example:
#
#   make variant=revsplus verify=no
#
# will build an the Revs+ variant with no crc32 verification

ifeq ($(variant), superior)
  variant-revs=2
  folder-revs=/superior
  suffix-revs=-superior
else ifeq ($(variant), 4tracks)
  variant-revs=3
  folder-revs=/4tracks
  suffix-revs=-4tracks
else ifeq ($(variant), revsplus)
  variant-revs=4
  folder-revs=/revsplus
  suffix-revs=-plus
else
  variant-revs=1
  folder-revs=/acornsoft
  suffix-revs=-acornsoft
endif

.PHONY:all
all:
	echo _VARIANT=$(variant-revs) > 1-source-files/main-sources/revs-build-options.asm
	$(BEEBASM) -i 1-source-files/main-sources/revs-silverstone.asm -v > 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-brandshatch.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-doningtonpark.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-oultonpark.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-snetterton.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-nurburgring.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-loader.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-source.asm -v >> 3-assembled-output/compile.txt
	$(PYTHON) 2-build-files/revs-checksum.py
	$(BEEBASM) -i 1-source-files/main-sources/revs-disc.asm -do 5-compiled-game-discs/revs$(suffix-revs).ssd -opt 3 -title "CAR"
ifneq ($(verify), no)
	@$(PYTHON) 2-build-files/crc32.py 4-reference-binaries$(folder-revs) 3-assembled-output
endif

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
# will build the Revs+ variant with no crc32 verification

ifeq ($(variant), superior)
  variant-number=2
  folder=superior
  suffix=-superior
else ifeq ($(variant), 4tracks)
  variant-number=3
  folder=4tracks
  suffix=-4tracks
else ifeq ($(variant), revsplus)
  variant-number=4
  folder=revsplus
  suffix=-plus
else
  variant-number=1
  folder=acornsoft
  suffix=-acornsoft
endif

.PHONY:all
all:
	echo _VARIANT=$(variant-number) > 1-source-files/main-sources/revs-build-options.asm
	$(BEEBASM) -i 1-source-files/main-sources/revs-silverstone.asm -v > 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-brandshatch.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-doningtonpark.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-oultonpark.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-snetterton.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-nurburgring.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-loader.asm -v >> 3-assembled-output/compile.txt
	$(BEEBASM) -i 1-source-files/main-sources/revs-source.asm -v >> 3-assembled-output/compile.txt
	$(PYTHON) 2-build-files/revs-checksum.py
	$(BEEBASM) -i 1-source-files/main-sources/revs-disc.asm -do 5-compiled-game-discs/revs$(suffix).ssd -opt 3 -title "CAR"
ifneq ($(verify), no)
	@$(PYTHON) 2-build-files/crc32.py 4-reference-binaries/$(folder) 3-assembled-output
endif

.PHONY:b2
b2:
	curl -G "http://localhost:48075/reset/b2"
	curl -H "Content-Type:application/binary" --upload-file "5-compiled-game-discs/revs$(suffix).ssd" "http://localhost:48075/run/b2?name=revs$(suffix).ssd"

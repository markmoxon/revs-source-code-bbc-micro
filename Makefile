BEEBASM?=beebasm
PYTHON?=python

# You can set the variant that gets built by adding 'variant=<rel>' to
# the make command, where <rel> is one of:
#
#   acornsoft
#   4tracks
#   superior
#
# So, for example:
#
#   make encrypt verify variant=superior
#
# will build the variant from the Superior Software release. If you
# omit the variant parameter, it will build the Acornsoft variant.

ifeq ($(variant), superior)
  variant-revs=2
  folder-revs=/superior
  suffix-revs=-superior
else ifeq ($(variant), 4tracks)
  variant-revs=3
  folder-revs=/4tracks
  suffix-revs=-4tracks
else
  variant-revs=1
  folder-revs=/acornsoft
  suffix-revs=-acornsoft
endif

.PHONY:build
build:
	echo _VARIANT=$(variant-revs) > 1-source-files/main-sources/revs-header.h.asm
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

.PHONY:verify
verify:
	@$(PYTHON) 2-build-files/crc32.py 4-reference-binaries$(folder-revs) 3-assembled-output

# Fully documented source code for Revs on the BBC Micro

![Screenshot of Revs on the BBC Micro](https://revs.bbcelite.com/images/github/Revs.png)

This repository contains source code for Revs on the BBC Micro, with every single line documented and (for the most part) explained.

It is a companion to the [revs.bbcelite.com website](https://revs.bbcelite.com).

See the [introduction](#introduction) for more information.

## Contents

* [Introduction](#introduction)

* [Acknowledgements](#acknowledgements)

  * [A note on licences, copyright etc.](#user-content-a-note-on-licences-copyright-etc)

* [Browsing the source in an IDE](#browsing-the-source-in-an-ide)

* [Folder structure](#folder-structure)

* [Building Revs from the source](#building-revs-from-the-source)

  * [Requirements](#requirements)
  * [Build targets](#build-targets)
  * [Windows](#windows)
  * [Mac and Linux](#mac-and-linux)
  * [Verifying the output](#verifying-the-output)
  * [Log files](#log-files)

* [Building different variants of Revs](#building-different-variants-of-revs)

  * [Building the Acornsoft variant](#building-the-acornsoft-variant)
  * [Building the Revs 4 Tracks variant](#building-the-revs-4-tracks-variant)
  * [Building the Superior Software variant](#building-the-superior-software-variant)
  * [Building the Revs+ variant](#building-the-revs-variant)
  * [Differences between the variants](#differences-between-the-variants)

## Introduction

This repository contains source code for Revs on the BBC Micro, with every single line documented and (for the most part) explained.

You can build the fully functioning game from this source. [Four variants](#building-different-variants-of-revs) are currently supported: the original 1985 Acornsoft release, the 1985 Revs 4 Tracks release, the 1986 Superior Software release, and a new release that includes the Nürburgring track, backported from the Commodore 64 version.

It is a companion to the [revs.bbcelite.com website](https://revs.bbcelite.com), which contains all the code from this repository, but laid out in a much more human-friendly fashion.

* If you want to browse the source and read about how Revs works under the hood, you will probably find [the website](https://revs.bbcelite.com) is a better place to start than this repository.

* If you would rather explore the source code in your favourite IDE, then the [annotated source](1-source-files/main-sources/revs-source.asm) is what you're looking for. It contains the exact same content as the website, so you won't be missing out (the website is generated from the source files, so they are guaranteed to be identical). You might also like to read the section on [Browsing the source in an IDE](#browsing-the-source-in-an-ide) for some tips.

* If you want to build Revs from the source on a modern computer, to produce a working game disc that can be loaded into a BBC Micro or an emulator, then you want the section on [Building Revs from the source](#building-revs-from-the-source).

My hope is that this repository will be useful for those who want to learn more about Revs and what makes it tick. It is provided on an educational and non-profit basis, with the aim of helping people appreciate the magic of Geoff Crammond's epic racing simulator, and the grandfather of modern sim racing.

## Acknowledgements

Revs was written by Geoffrey J Crammond and is copyright &copy; Acornsoft 1985.

The code on this site has been reconstructed from a disassembly of the version released on the [Complete BBC Micro Games Archive at bbcmicro.co.uk](http://bbcmicro.co.uk/game.php?id=267).

The commentary is copyright &copy; Mark Moxon. Any misunderstandings or mistakes in the documentation are entirely my fault.

### A note on licences, copyright etc.

This repository is _not_ provided with a licence, and there is intentionally no `LICENSE` file provided.

According to [GitHub's licensing documentation](https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/licensing-a-repository), this means that "the default copyright laws apply, meaning that you retain all rights to your source code and no one may reproduce, distribute, or create derivative works from your work".

The reason for this is that my commentary is intertwined with the original Revs game code, and the original game is copyright. The whole site is therefore covered by default copyright law, to ensure that this copyright is respected.

Under GitHub's rules, you have the right to read and fork this repository... but that's it. No other use is permitted, I'm afraid.

My hope is that the educational and non-profit intentions of this repository will enable it to stay hosted and available, but the original copyright holders do have the right to ask for it to be taken down, in which case I will comply without hesitation.  I do hope, though, that along with the various other disassemblies and commentaries of Acornsoft's games for the BBC Micro, it will remain viable.

## Browsing the source in an IDE

If you want to browse the source in an IDE, you might find the following useful.

* The most interesting files are in the [main-sources](1-source-files/main-sources) folder:

  * The main game's source code is in the [revs-source.asm](1-source-files/main-sources/revs-source.asm) file - this is the motherlode and probably contains all the stuff you're interested in. It produces a file called `Revs?` that contains the game code.

  * The data for the Silverstone track file is in the [revs-silverstone.asm](1-source-files/main-sources/revs-silverstone.asm) file. This produces a file called `Silvers` that gets loaded by the loader before the main game code is run.

  * The game's loader programs are in the [basic-programs](1-source-files/basic-programs) folder.

* It's probably worth skimming through the [notes on terminology and notations](https://revs.bbcelite.com/about_site/terminology_used_in_this_commentary.html) on the accompanying website, as this explains a number of terms used in the commentary, without which it might be a bit tricky to follow at times (in particular, you should understand the terminology I use for multi-byte numbers).

* The entry point for the [main game code](1-source-files/main-sources/revs-source.asm) is routine `Entry`, which you can find by searching for `Name: Entry`.

* The source code is designed to be read at an 80-column width and with a monospaced font, just like in the good old days.

I hope you enjoy exploring the inner workings of Revs as much as I have.

## Folder structure

There are five main folders in this repository, which reflect the order of the build process.

* [1-source-files](1-source-files) contains all the different source files, such as the main assembler source files, image binaries, BASIC loader programs, boot files and so on.

* [2-build-files](2-build-files) contains build-related scripts, such as the checksum and crc32 verification scripts.

* [3-assembled-output](3-assembled-output) contains the output from the assembly process, when the source files are assembled and the results processed by the build files.

* [4-reference-binaries](4-reference-binaries) contains the correct binaries for each release, so we can verify that our assembled output matches the reference.

* [5-compiled-game-discs](5-compiled-game-discs) contains the final output of the build process: an SSD disc image that contains the compiled game and which can be run on real hardware or in an emulator.

## Building Revs from the source

### Requirements

You will need the following to build Revs from the source:

* BeebAsm, which can be downloaded from the [BeebAsm repository](https://github.com/stardot/beebasm). Mac and Linux users will have to build their own executable with `make code`, while Windows users can just download the `beebasm.exe` file.

* Python. Both versions 2.7 and 3.x should work.

* Mac and Linux users may need to install `make` if it isn't already present (for Windows users, `make.exe` is included in this repository).

Let's look at how to build Revs from the source.

### Build targets

There is one main build target available:

* `build` - A version that exactly matches the original binaries

Builds are supported for both Windows and Mac/Linux systems. In all cases the build process is defined in the `Makefile` provided.

### Windows

For Windows users, there is a batch file called `make.bat` to which you can pass one of the build targets above. Before this will work, you should edit the batch file and change the values of the `BEEBASM` and `PYTHON` variables to point to the locations of your `beebasm.exe` and `python.exe` executables. You also need to change directory to the repository folder (i.e. the same folder as `make.bat`).

All being well, doing the following:

```
make.bat build
```

will produce a file called `revs-acornsoft.ssd` in the `5-compiled-game-discs` folder that contains the Acornsoft variant, which you can then load into an emulator, or into a real BBC Micro using a device like a Gotek.

### Mac and Linux

The build process uses a standard GNU `Makefile`, so you just need to install `make` if your system doesn't already have it. If BeebAsm or Python are not on your path, then you can either fix this, or you can edit the `Makefile` and change the `BEEBASM` and `PYTHON` variables in the first two lines to point to their locations. You also need to change directory to the repository folder (i.e. the same folder as `Makefile`).

All being well, doing the following:

```
make build
```

will produce a file called `revs-acornsoft.ssd` in the `5-compiled-game-discs` folder that contains the Acornsoft variant, which you can then load into an emulator, or into a real BBC Micro using a device like a Gotek.

### Verifying the output

The build process also supports a verification target that prints out checksums of all the generated files, along with the checksums of the files from the original sources.

You can run this verification step on its own, or you can run it once a build has finished. To run it on its own, use the following command on Windows:

```
make.bat verify
```

or on Mac/Linux:

```
make verify
```

To run a build and then verify the results, you can add two targets, like this on Windows:

```
make.bat build verify
```

or this on Mac/Linux:

```
make build verify
```

The Python script `crc32.py` in the `2-build-files` folder does the actual verification, and shows the checksums and file sizes of both sets of files, alongside each other, and with a Match column that flags any discrepancies.

The binaries in the `4-reference-binaries` folder are those extracted from the released version of the game, while those in the `3-assembled-output` folder are produced by the build process. For example, if you don't make any changes to the code and build the project with `make build verify`, then this is the output of the verification process:

```
Results for release: acornsoft
[--originals--]  [---output----]
Checksum   Size  Checksum   Size  Match  Filename
-----------------------------------------------------------
9ab958e9   1455  9ab958e9   1455   Yes   Revs1.bin
e22a0a93  24064  e22a0a93  24064   Yes   Revs2.bin
0b090b15   1849  0b090b15   1849   Yes   Silverstone.bin
```

The compiled binary matches the original, so we know we are producing the same final game as the Acornsoft variant.

### Log files

During compilation, details of every step are output in a file called `compile.txt` in the `3-assembled-output` folder. If you have problems, it might come in handy, and it's a great reference if you need to know the addresses of labels and variables for debugging (or just snooping around).

## Building different variants of Revs

This repository contains the source code for four different variants of Revs:

* The Acornsoft variant, which is the original release with the Silverstone track

* The Acornsoft Revs 4 Tracks variant, which adds four more tracks (Brands Hatch, Donington Park, Oulton Park and Snetterton)

* The Superior Software variant, which includes all five tracks, computer assisted steering (CAS), a tweaked drifting model, and support for digital joysticks

* The Revs+ variant, which includes everything from the Superior Software variant, plus the Nürburgring track, backported from the Commodore 64 version

By default the build process builds the Acornsoft variant, but you can build a specified variant using the `variant=` build parameter.

### Building the Acornsoft variant

You can add `variant=acornsoft` to produce the `revs-acornsoft.ssd` file containing the Acornsoft variant, though that's the default value so it isn't necessary.

The verification checksums for this version are as follows:

```
Results for release: acornsoft
[--originals--]  [---output----]
Checksum   Size  Checksum   Size  Match  Filename
-----------------------------------------------------------
9ab958e9   1455  9ab958e9   1455   Yes   Revs1.bin
e22a0a93  24064  e22a0a93  24064   Yes   Revs2.bin
0b090b15   1849  0b090b15   1849   Yes   Silverstone.bin
```

### Building the Revs 4 Tracks variant

You can build the Revs 4 Tracks variant by appending `variant=4tracks` to the `make` command, like this on Windows:

```
make.bat build verify variant=4tracks
```

or this on a Mac or Linux:

```
make build verify variant=4tracks
```

This will produce a file called `revs-4tracks.ssd` in the `5-compiled-game-discs` folder that contains the Revs 4 Tracks variant.

The verification checksums for this version are as follows:

```
Results for release: 4tracks
[--originals--]  [---output----]
Checksum   Size  Checksum   Size  Match  Filename
-----------------------------------------------------------
b367ef0f   2000  b367ef0f   2000   Yes   BrandsHatch.bin
18d57479   2000  18d57479   2000   Yes   DoningtonPark.bin
0f2aa17c   2000  0f2aa17c   2000   Yes   OultonPark.bin
9ab958e9   1455  9ab958e9   1455   Yes   Revs1.bin
e22a0a93  24064  e22a0a93  24064   Yes   Revs2.bin
0b090b15   1849  0b090b15   1849   Yes   Silverstone.bin
9dcd008c   2000  9dcd008c   2000   Yes   Snetterton.bin
```

### Building the Superior Software variant

You can build the Superior Software variant by appending `variant=superior` to the `make` command, like this on Windows:

```
make.bat build verify variant=superior
```

or this on a Mac or Linux:

```
make build verify variant=superior
```

This will produce a file called `revs-superior.ssd` in the `5-compiled-game-discs` folder that contains the Superior Software variant.

The verification checksums for this version are as follows:

```
Results for release: superior
[--originals--]  [---output----]
Checksum   Size  Checksum   Size  Match  Filename
-----------------------------------------------------------
b367ef0f   2000  b367ef0f   2000   Yes   BrandsHatch.bin
18d57479   2000  18d57479   2000   Yes   DoningtonPark.bin
0f2aa17c   2000  0f2aa17c   2000   Yes   OultonPark.bin
9ab958e9   1455  9ab958e9   1455   Yes   Revs1.bin
83e95a44  24064  83e95a44  24064   Yes   Revs2.bin
0b090b15   1849  0b090b15   1849   Yes   Silverstone.bin
9dcd008c   2000  9dcd008c   2000   Yes   Snetterton.bin
```

### Building the Revs+ variant

You can build the Revs+ variant by appending `variant=revsplus` to the `make` command, like this on Windows:

```
make.bat build verify variant=revsplus
```

or this on a Mac or Linux:

```
make build verify variant=revsplus
```

This will produce a file called `revs-plus.ssd` in the `5-compiled-game-discs` folder that contains the Revs+ variant.

The verification checksums for this version are as follows:

```
Results for release: revsplus
[--originals--]  [---output----]
Checksum   Size  Checksum   Size  Match  Filename
-----------------------------------------------------------
b367ef0f   2000  b367ef0f   2000   Yes   BrandsHatch.bin
18d57479   2000  18d57479   2000   Yes   DoningtonPark.bin
8d49adf8   2000  8d49adf8   2000   Yes   Nurburgring.bin
0f2aa17c   2000  0f2aa17c   2000   Yes   OultonPark.bin
9ab958e9   1455  9ab958e9   1455   Yes   Revs1.bin
83e95a44  24064  83e95a44  24064   Yes   Revs2.bin
0b090b15   1849  0b090b15   1849   Yes   Silverstone.bin
9dcd008c   2000  9dcd008c   2000   Yes   Snetterton.bin
```

### Differences between the variants

The game code is identical in the original Acornsoft and Revs 4 Tracks variants, but Revs 4 Tracks contains the four extra tracks and a load menu from which you can choose from the four new tracks.

The game code is identical in the Superior Software and Revs+ variants, but Revs+ includes the Nürburgring track, backported from the Commodore 64 version.

There are three main differences in the game code when comparing the Acornsoft/Revs 4 Tracks variants to the Superior Software/Revs+ variants:

* The Superior Software and Revs+ variants support computer assisted steering (CAS), which isn't present in the original Acornsoft variants.

* The Superior Software and Revs+ variants record player drift differently to the original Acornsoft variants. Player drift occurs when the player loses traction when sliding sideways. In the Superior Software and Revs+ variants, drifting is ignored if it occurs in the first three segments of a track section. This difference is implemented in the SetPlayerDriftS routine, which is not present in the original Acornsoft variants (though note that some of the tracks in Revs 4 Tracks do include this feature).

* The Superior Software and Revs+ variants support digital joysticks, as found on the BBC Master Compact.

---

_Mark Moxon_
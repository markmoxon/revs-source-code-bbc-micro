# Build files for the BBC Micro disc version of Revs

This folder contains support scripts for building the BBC Micro disc version of Revs.

* [crc32.py](crc32.py) calculates checksums during the verify stage and compares the results with the relevant binaries in the [4-reference-binaries](../4-reference-binaries) folder

* [py8dis](py8dis) contains configuration files and scripts from the initial disassembly of the game binary using the [py8dis](https://github.com/ZornsLemma/py8dis) disassembler

* [revs-checksum.py](revs-checksum.py) adds checksums to the assembled output

It also contains the `make.exe` executable for Windows, plus the required DLL files.

---

_Mark Moxon_
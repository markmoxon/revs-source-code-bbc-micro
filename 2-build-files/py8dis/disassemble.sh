python revs-loader.py > 1-source-files/revs-loader.asm
beebasm -i 1-source-files/revs-loader.asm -v > 3-assembled-output/compile.txt

python revs-silverstone.py > 1-source-files/revs-silverstone.asm
beebasm -i 1-source-files/revs-silverstone.asm -v > 3-assembled-output/compile.txt

python revs-source.py > 1-source-files/revs-source.asm
beebasm -i 1-source-files/revs-source.asm -v > 3-assembled-output/compile.txt

python 2-build-files/crc32.py 4-reference-binaries 3-assembled-output

cat 0-headers/revs-loader.asm 1-source-files/revs-loader.asm 0-footers/revs-loader.asm > ../Repositories/revs-beebasm/1-source-files/main-sources/revs-loader.asm
cat 0-headers/revs-silverstone.asm 1-source-files/revs-silverstone.asm 0-footers/revs-silverstone.asm > ../Repositories/revs-beebasm/1-source-files/main-sources/revs-silverstone.asm
cat 0-headers/revs-source.asm 1-source-files/revs-source.asm 0-footers/revs-source.asm > ../Repositories/revs-beebasm/1-source-files/main-sources/revs-source.asm

cp revs-loader.py ../Repositories/revs-beebasm/2-build-files/py8dis/
cp revs-source.py ../Repositories/revs-beebasm/2-build-files/py8dis/
cp revs-silverstone.py ../Repositories/revs-beebasm/2-build-files/py8dis/
cp disassemble.sh ../Repositories/revs-beebasm/2-build-files/py8dis/

cd ../Repositories/revs-beebasm
make build verify

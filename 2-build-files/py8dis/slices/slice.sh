dd if=Revs.bin of=1200-12ff.bin bs=1 skip=0 count=256
dd if=Revs.bin of=1300-14ff.bin bs=1 skip=256 count=512
dd if=Revs.bin of=1500-15da.bin bs=1 skip=768 count=219
dd if=Revs.bin of=15db-16db.bin bs=1 skip=987 count=257
dd if=Revs.bin of=16dc-5a7f.bin bs=1 skip=1244 count=17316
dd if=Revs.bin of=5a80-645b.bin bs=1 skip=18560 count=2524
dd if=Revs.bin of=645c-64cf.bin bs=1 skip=21084 count=116
dd if=Revs.bin of=64d0-6bff.bin bs=1 skip=21200 count=1840
dd if=Revs.bin of=6c00-6fff.bin bs=1 skip=23040 count=1024
cat 1200-12ff.bin 1300-14ff.bin 1500-15da.bin 15db-16db.bin 16dc-5a7f.bin 5a80-645b.bin 645c-64cf.bin 64d0-6bff.bin 6c00-6fff.bin > cat.bin
diff Revs.bin cat.bin

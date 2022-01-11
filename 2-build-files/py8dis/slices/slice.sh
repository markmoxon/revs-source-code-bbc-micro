# Slice the main Revs binary into the different blocks that are moved about
# in memory when the game is run

dd if=Revs.bin of=1200-12ff.bin bs=1 skip=0 count=256
dd if=Revs.bin of=1300-14ff.bin bs=1 skip=256 count=512
dd if=Revs.bin of=1500-15da.bin bs=1 skip=768 count=219
dd if=Revs.bin of=15db-16db.bin bs=1 skip=987 count=257
dd if=Revs.bin of=16dc-5a7f.bin bs=1 skip=1244 count=17316
dd if=Revs.bin of=5a80-645b.bin bs=1 skip=18560 count=2524
dd if=Revs.bin of=645c-64cf.bin bs=1 skip=21084 count=116
dd if=Revs.bin of=64d0-6bff.bin bs=1 skip=21200 count=1840
dd if=Revs.bin of=6c00-6fff.bin bs=1 skip=23040 count=1024

# Confirm that the slices match the original binary when reassembled

cat 1200-12ff.bin 1300-14ff.bin 1500-15da.bin 15db-16db.bin 16dc-5a7f.bin 5a80-645b.bin 645c-64cf.bin 64d0-6bff.bin 6c00-6fff.bin | diff Revs.bin -

# Extract the dashboard images from the main Revs binary

dd if=Revs.bin of=5300-5949.bin bs=1 skip=16640 count=1610
dd if=Revs.bin of=594a-594a.bin bs=1 skip=18250 count=67
cat 6c00-6fff.bin 1500-15da.bin 5300-5949.bin > dashboard1.bin
cat 594a-594a.bin > dashboard2.bin

#!/usr/bin/env python
#
# ******************************************************************************
#
# REVS CHECKSUM SCRIPT
#
# Written by Mark Moxon
#
# This script applies checksums to the Revs track data
#
# ******************************************************************************

from __future__ import print_function

print("Revs track checksum")

checksum_start = 0x5300
checksum_end = 0x5A25
checksum_offset = checksum_end - checksum_start

# Process all assembled track files
track_names = ["Silvers"]

for track_name in track_names:
    print("Adding checksum to", track_name)

    data_block = bytearray()
    track_file = open("3-assembled-output/" + track_name + ".bin", "rb")
    data_block.extend(track_file.read())
    track_file.close()

    # Track data checksum
    checksum = [0, 0, 0, 0]

    for i in range(0, checksum_end - checksum_start):
        checksum[data_block[i] % 4] += 1

    for i in range(0, 4):
        checksum[i] = checksum[i] % 256
        print("Commander checksum", i, "=", hex(checksum[i]))
        data_block[checksum_offset + i] = checksum[i]

    # Write updated track
    output_file = open("3-assembled-output/" + track_name + ".bin", "wb")
    output_file.write(data_block)
    output_file.close()

    print("3-assembled-output/" + track_name + ".bin file saved")

from commands import *
from trace6502 import *
import acorn


# Silvers loads from &70DB to &7813 inclusive (length &739)

load(0x70DB, "4-reference-binaries/Silvers.bin", "ae57b160dd877e5f4b964ab3106de843")
set_output_filename("3-assembled-output/Silvers.bin")

acorn.bbc()
config._lower_case = False

entry(0x70db, "trackData")

byte(0x70db, 0x7800 - 0x70db)

comment(0x7800, "Checksum bytes:")
comment(0x7800, "&7800 counts the number of data bytes ending in %00")
comment(0x7800, "&7801 counts the number of data bytes ending in %01")
comment(0x7800, "&7802 counts the number of data bytes ending in %10")
comment(0x7800, "&7803 counts the number of data bytes ending in %11")

comment(0x7804, "Track name")

string(0x7804)

go()

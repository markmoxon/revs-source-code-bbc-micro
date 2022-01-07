from commands import *
from trace6502 import *
import acorn


load(0x2000, "4-reference-binaries/Revs1.bin", "2e5a5b2a9a419e7be3bff586566ff8a5")
set_output_filename("3-assembled-output/Revs1.bin")

acorn.bbc()
config._lower_case = False

entry(0x2000, "Start")
entry(0x2027)

string(0x2068)

#move(0x0400, 0x20af, 0xff)
#move(0x0500, 0x21af, 0xff)
#move(0x0600, 0x22af, 0xff)
#move(0x0000, 0x23af, 0xff)
#move(0x0100, 0x24af, 0xff)

label(0x2500, "RunRevs")

label(0x2507, "runRevs")

string(0x2507)

go()

#!/usr/bin/env python3
with open("edid-original.bin", "rb") as f:
    original = bytearray(f.read())

block0 = bytearray(original[0:128])
block1 = bytearray(original[128:256])

# Update extension count 1 -> 2
block0[0x7E] = 0x02

# Recalculate Block 0 checksum
block0[0x7F] = 0
block0[0x7F] = (256 - (sum(block0) % 256)) % 256

# Create CTA-861 block with HDR data copied from DisplayID block
cta = bytearray(128)
cta[0:4] = [0x02, 0x03, 0x51, 0x80]  # CTA header
cta[4:35] = original[0xBF:0xDE]   # CTA data
cta[35:38] = [0xF6, 0x22, 0x02]
cta[38:58] = original[0x94:0xA8]
cta[41] = cta[41] & 0x7F
cta[58:61] = [0xF6, 0x22, 0x02]
cta[61:81] = original[0xA8:0xBC]

# CTA checksum
cta[127] = (256 - (sum(cta) % 256)) % 256

patched = bytes(block0) + bytes(cta) + bytes(block1)
with open("edid-patched-hdr.bin", "wb") as f:
    f.write(patched)

print(f"Patched EDID saved: {len(patched)} bytes")


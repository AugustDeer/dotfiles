"""
Fixes incorrect DT_VERDEF address.
TODO: Remove when nixpkgs uses patchelf >=0.19.3

DT_VERDEF points to .gnu.version_d, a table of version definitions. When
patchelf extends the .dynamic table to add libstdc++.so.6 dependency,
.gnu.version_d is relocated but DT_VERDEF is not updated. This error only
appears when another object requests a versioned symbol via DT_VERNEED. Bug
reported upstream in https://github.com/NixOS/patchelf/issues/664, and fixed
in version 0.19.3. However, nixpkgs still uses 0.15.2.

Ported from https://github.com/can1357/oh-my-pi/blob/4530cba18f6f68c0ba405966cd8dfd1093a03152/scripts/fix-dt-verdef.ts
"""

import struct
import sys

DT_NULL = 0
DT_VERDEF = 0x6FFFFFFC
SHT_DYNAMIC = 6
SHT_GNU_VERDEF = 0x6FFFFFFD


def repair(path: str) -> None:
    with open(path, "r+b") as file:
        header = file.read(64)
        if header[:4] != b"\x7fELF" or header[4] != 2 or header[5] != 1:
            raise SystemExit(f"{path}: not ELF64 little-endian")

        shoff = struct.unpack_from("<Q", header, 40)[0]
        shentsize = struct.unpack_from("<H", header, 58)[0]
        shnum = struct.unpack_from("<H", header, 60)[0]

        file.seek(shoff)
        sections = file.read(shentsize * shnum)

        verdef = None
        dynamic = None
        for index in range(shnum):
            base = index * shentsize
            section_type = struct.unpack_from("<I", sections, base + 4)[0]
            if section_type == SHT_GNU_VERDEF:
                verdef = struct.unpack_from("<Q", sections, base + 16)[0]
            elif section_type == SHT_DYNAMIC:
                dynamic = (
                    struct.unpack_from("<Q", sections, base + 24)[0],
                    struct.unpack_from("<Q", sections, base + 32)[0],
                )

        if verdef is None:
            print(f"{path}: no .gnu.version_d, nothing to do")
            return
        if dynamic is None:
            raise SystemExit(f"{path}: no SHT_DYNAMIC section")

        offset, size = dynamic
        file.seek(offset)
        entries = file.read(size)

        for cursor in range(0, len(entries) - 15, 16):
            tag, value = struct.unpack_from("<QQ", entries, cursor)
            if tag == DT_NULL:
                break
            if tag != DT_VERDEF:
                continue
            if value == verdef:
                print(f"{path}: DT_VERDEF already 0x{verdef:x}")
                return
            file.seek(offset + cursor + 8)
            file.write(struct.pack("<Q", verdef))
            print(f"{path}: DT_VERDEF 0x{value:x} -> 0x{verdef:x}")
            return

        raise SystemExit(f"{path}: .gnu.version_d present but no DT_VERDEF entry")


for target in sys.argv[1:]:
    repair(target)

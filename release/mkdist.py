#!/usr/bin/env python3
# ABIOSDSK Version 0.90 prerelease
# Copyright (C) 2026 Simplebooks Foundation
# Copyright (C) 2026 Josh Rodd
"""Package the ABIOSDSK.386 Version 0.90 prerelease.

Run from anywhere:  python3 mkdist.py

Writes into this directory (release/):
  ABIOSDSK.ZIP  - zip archive, maximum compression (deflate level 9),
                  formatted for old DOS decompressors: PKZIP 2.0+
                  headers (version 20, method 8), no ZIP64, no data
                  descriptors, no Unicode names, no extra fields,
                  DOS file attributes.  PKZIP 2.04g and later on DOS
                  unzip it; PKZIP 1.x-era tools cannot inflate method
                  8 and are not targets.
  ABIOSDSK.IMG  - 720 kB (80-track, 9-sector, double-sided) FAT12
                  disk image containing the same files, readable by
                  DOS 3.3+ and Windows 3.1.  Volume label ABIOSDSK.
                  Not bootable; booting it prints the standard
                  "Invalid system disk" message.

Only the files listed in FILES are packaged.
"""

import os
import struct
import sys
import zipfile
from datetime import datetime

HERE = os.path.dirname(os.path.abspath(__file__))
ZIP_NAME = "ABIOSDSK.ZIP"
IMA_NAME = "ABIOSDSK.IMG"

# Files packaged, in order.  All must be 8.3 DOS names.
FILES = [
    "ABIOSDSK.386",
    "ABIOSCHK.COM",
    "ADDINI.COM",
    "SETUP.INF",
    "README.TXT",
    "HELP.TXT",
    "LICENSE.TXT",
    "INSTALL.BAT",
    "TEST.BAT",
]

# ---------------------------------------------------------------------------
# ZIP
# ---------------------------------------------------------------------------


def make_zip(path):
    """Write a PKZIP-2.0-compatible, deflate-9 archive of FILES to path."""
    with zipfile.ZipFile(
        path, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9
    ) as zf:
        for name in FILES:
            src = os.path.join(HERE, name)
            zi = zipfile.ZipInfo.from_file(src, name)
            zi.create_system = 0  # DOS origin, not Unix
            zi.external_attr = 0x20  # DOS archive attribute
            zi.compress_type = zipfile.ZIP_DEFLATED
            with open(src, "rb") as f:
                zf.writestr(zi, f.read())
    # Sanity: nobody may have slipped ZIP64 or descriptor flags in.
    with zipfile.ZipFile(path) as zf:
        for zi in zf.infolist():
            assert zi.file_size < 0xFFFFFFFF and zi.compress_size < 0xFFFFFFFF
            assert zi.create_version <= 20 and zi.extract_version <= 20
            assert zi.flag_bits & 0x0008 == 0  # no data descriptor
            assert zi.flag_bits & 0x0800 == 0  # no UTF-8 names
            assert not zi.extra
            assert zi.compress_type == zipfile.ZIP_DEFLATED


# ---------------------------------------------------------------------------
# 720 kB FAT12 disk image
# ---------------------------------------------------------------------------

BYTES_PER_SECTOR = 512
SECTORS_PER_CLUSTER = 2
RESERVED_SECTORS = 1
NUM_FATS = 2
ROOT_ENTRIES = 112
TOTAL_SECTORS = 1440  # 720 kB: 80 cyl x 2 heads x 9 sectors
FAT_SECTORS = 3
SECTORS_PER_TRACK = 9
NUM_HEADS = 2
MEDIA = 0xF9  # 720 kB, 9 sectors/track, 2 heads
VOLUME_LABEL = b"ABIOSDSK"  # 8 chars, padded to 11

ROOT_START = RESERVED_SECTORS + NUM_FATS * FAT_SECTORS  # sector 7
ROOT_SECTORS = (ROOT_ENTRIES * 32 + BYTES_PER_SECTOR - 1) // BYTES_PER_SECTOR
DATA_START = ROOT_START + ROOT_SECTORS  # sector 14
DATA_SECTORS = TOTAL_SECTORS - DATA_START
NUM_CLUSTERS = DATA_SECTORS // SECTORS_PER_CLUSTER  # 713


def dos_datetime(ts):
    year, month, day, hour, minute, second = ts[:6]
    date = ((year - 1980) << 9) | (month << 5) | day
    time = (hour << 11) | (minute << 5) | (second // 2)
    return time, date


def serialize_fat(entries):
    """Pack a list of 12-bit FAT entries little-endian into bytes."""
    out = bytearray()
    for i in range(0, len(entries), 2):
        a = entries[i]
        b = entries[i + 1] if i + 1 < len(entries) else 0
        out.append(a & 0xFF)
        out.append(((a >> 8) & 0x0F) | ((b & 0x0F) << 4))
        out.append((b >> 4) & 0xFF)
    return out


def make_boot_sector():
    b = bytearray(BYTES_PER_SECTOR)
    b[0:3] = b"\xeb\x3c\x90"  # short jump + nop
    b[3:11] = b"ABIOSDSK"  # OEM name (8 chars)
    struct.pack_into("<H", b, 11, BYTES_PER_SECTOR)
    b[13] = SECTORS_PER_CLUSTER
    struct.pack_into("<H", b, 14, RESERVED_SECTORS)
    b[16] = NUM_FATS
    struct.pack_into("<H", b, 17, ROOT_ENTRIES)
    struct.pack_into("<H", b, 19, TOTAL_SECTORS)
    b[21] = MEDIA
    struct.pack_into("<H", b, 22, FAT_SECTORS)
    struct.pack_into("<H", b, 24, SECTORS_PER_TRACK)
    struct.pack_into("<H", b, 26, NUM_HEADS)
    struct.pack_into("<I", b, 28, 0)  # hidden sectors
    struct.pack_into("<I", b, 32, 0)  # total sectors 32 (unused)
    b[36] = 0  # drive number
    b[37] = 0
    b[38] = 0x29  # extended boot signature
    struct.pack_into("<I", b, 39, 0xAB10D500)  # volume serial
    b[43:54] = VOLUME_LABEL.ljust(11, b" ")
    b[54:62] = b"FAT12   "
    # Stub loader: "Invalid system disk" message, then wait for a key.
    code = bytes(
        [
            0x33,
            0xC0,  # xor ax,ax
            0xCD,
            0x13,  # int 13h          ; reset disk system
            0x0E,
            0x1F,  # push cs / pop ds
            0xBE,
            0x7E,
            0x7C,  # mov si,7C7Eh     ; message
            0xB4,
            0x0E,  # mov ah,0Eh       ; tty output
            0xAC,  # lodsb
            0x3C,
            0x00,  # cmp al,0
            0x74,
            0x04,  # jz +4
            0xCD,
            0x10,  # int 10h
            0xEB,
            0xF7,  # jmp -9
            0x30,
            0xE4,  # xor ah,ah
            0xCD,
            0x16,  # int 16h          ; wait for key
            0xCD,
            0x19,  # int 19h          ; reboot
        ]
    )
    b[0x3E : 0x3E + len(code)] = code
    msg = (
        b"Invalid system disk\r\n"
        b"Replace the disk, and then press any key\r\n\0"
    )
    b[0x7E : 0x7E + len(msg)] = msg
    b[510], b[511] = 0x55, 0xAA
    return b


def make_ima(path):
    """Write a 720 kB FAT12 image of FILES to path."""
    image = bytearray(TOTAL_SECTORS * BYTES_PER_SECTOR)
    image[0:BYTES_PER_SECTOR] = make_boot_sector()

    # Allocate contiguous cluster chains, files in FILES order.
    fat = [0] * (NUM_CLUSTERS + 2)
    # FAT[0] low byte is the media descriptor (0xF9 for 720 kB); FAT[1] is
    # the reserved end marker.  Serialized, the first FAT bytes read F9 FF FF.
    fat[0] = 0xF00 | MEDIA
    fat[1] = 0xFFF
    next_cluster = 2
    entries = []  # (name11, attr, time, date, cluster, size)
    for name in FILES:
        src = os.path.join(HERE, name)
        with open(src, "rb") as f:
            data = f.read()
        clusters = (len(data) + 1024 - 1) // 1024
        start = next_cluster
        for i in range(clusters):
            fat[next_cluster] = (
                0xFFF if i == clusters - 1 else next_cluster + 1
            )
            off = DATA_START + (next_cluster - 2) * SECTORS_PER_CLUSTER
            chunk = data[i * 1024 : (i + 1) * 1024].ljust(1024, b"\0")
            image[off * 512 : off * 512 + 1024] = chunk
            next_cluster += 1
        time, date = dos_datetime(
            datetime.fromtimestamp(os.stat(src).st_mtime).timetuple()
        )
        base, _, ext = name.partition(".")
        name11 = base[:8].upper().ljust(8) + ext[:3].upper().ljust(3)
        entries.append(
            (name11.encode("ascii"), 0x20, time, date, start, len(data))
        )

    fat_bytes = serialize_fat(fat)
    for i in range(NUM_FATS):
        off = (RESERVED_SECTORS + i * FAT_SECTORS) * BYTES_PER_SECTOR
        image[off : off + len(fat_bytes)] = fat_bytes

    # Root directory: volume label first, then the files.
    root = bytearray(ROOT_SECTORS * BYTES_PER_SECTOR)
    root[0:11] = VOLUME_LABEL.ljust(11, b" ")
    root[11] = 0x08  # volume label attribute
    pos = 32
    for name11, attr, time, date, cluster, size in entries:
        e = bytearray(32)
        e[0:11] = name11
        e[11] = attr
        struct.pack_into("<H", e, 22, time)
        struct.pack_into("<H", e, 24, date)
        struct.pack_into("<H", e, 26, cluster)
        struct.pack_into("<I", e, 28, size)
        root[pos : pos + 32] = e
        pos += 32
    root_off = ROOT_START * BYTES_PER_SECTOR
    image[root_off : root_off + len(root)] = root

    with open(path, "wb") as f:
        f.write(image)

    # Sanity checks on the result.
    assert len(image) == 720 * 1024
    assert next_cluster <= NUM_CLUSTERS + 1, "image full"


# ---------------------------------------------------------------------------


def main():
    os.chdir(HERE)
    missing = [
        n for n in FILES if not os.path.isfile(os.path.join(HERE, n))
    ]
    if missing:
        sys.exit("missing files: %s" % ", ".join(missing))
    make_zip(os.path.join(HERE, ZIP_NAME))
    make_ima(os.path.join(HERE, IMA_NAME))
    for n in (ZIP_NAME, IMA_NAME):
        print(
            "%-14s %8d bytes  %s"
            % (
                n,
                os.path.getsize(os.path.join(HERE, n)),
                os.path.join(HERE, n),
            )
        )


if __name__ == "__main__":
    main()

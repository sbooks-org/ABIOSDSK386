#!/usr/bin/env python3
"""Build low-memory Windows 3.x PIF launchers for the DOS stressors."""

import base64
import struct
import sys
from pathlib import Path

_TEMPLATE = base64.b64decode(
    "AABNUy1ET1MgUHJvbXB0AAAAAAAAAAAAAAAAAAAAAACAAoAAQ09NTUFORC5DT00A"
    "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    "AAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAH8BAP8ZUAAABwAAAAAA"
    "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
    "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAATUlDUk9TT0ZUIFBJRkVYAIcB"
    "AABxAVdJTkRPV1MgMjg2IDMuMAD//50BBgAAAAAAAAA="
)


def _field(data: bytearray, offset: int, length: int, value: str) -> None:
    encoded = value.encode("ascii")
    if len(encoded) >= length:
        raise ValueError(f"PIF field too long: {value!r}")
    data[offset : offset + length] = encoded + bytes(length - len(encoded))


def build_pif(title: str, program: str, arguments: str) -> bytes:
    data = bytearray(_TEMPLATE)
    _field(data, 0x02, 30, title)
    struct.pack_into("<H", data, 0x20, 512)  # desired conventional KB
    struct.pack_into("<H", data, 0x22, 384)  # required conventional KB
    _field(data, 0x24, 63, program)
    _field(data, 0x65, 64, r"C:\WINDOWS")
    _field(data, 0xA5, 64, arguments)
    return bytes(data)


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("usage: mkpif.py OUTPUT_DIRECTORY")
    output = Path(sys.argv[1])
    output.mkdir(parents=True, exist_ok=True)
    for number, seed in ((1, 111), (2, 222)):
        output.joinpath(f"DSTRS{number}.PIF").write_bytes(
            build_pif(
                f"ABIOSDSK DOS stress {number}",
                rf"C:\WINDOWS\DSTRS{number}.EXE",
                f"D{number}.DAT {seed} 10 D{number}.OK",
            )
        )


if __name__ == "__main__":
    main()

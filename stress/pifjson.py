#!/usr/bin/env python3
# ABIOSDSK Version 0.90 prerelease PIF utility
# Copyright (C) 2026 Simplebooks Foundation
# Copyright (C) 2026 Josh Rodd
"""Lossless JSON editor for classic and Windows 3.x PIF files."""

import argparse
import base64
import json
import struct
import sys
from pathlib import Path

PIFEX_OFFSET = 0x171
SECTION_NAME_SIZE = 16
SECTION_HEADER_SIZE = 6
SCHEMA = "pifjson/v1"

FLAG386 = {
    "allow_close": 0x0001,
    "background": 0x0002,
    "exclusive": 0x0004,
    "full_screen": 0x0008,
    "reserve_alt_tab": 0x0020,
    "reserve_alt_escape": 0x0040,
    "reserve_alt_space": 0x0080,
    "reserve_alt_enter": 0x0100,
    "reserve_alt_print_screen": 0x0200,
    "reserve_print_screen": 0x0400,
    "reserve_ctrl_escape": 0x0800,
    "detect_idle": 0x1000,
    "use_hma": 0x2000,
    "ems_locked": 0x8000,
}
FLAGXMS = {
    "xms_locked": 0x0001,
    "fast_paste": 0x0002,
    "locked_application": 0x0004,
}
VIDEO_FLAGS = {
    "emulate_text_mode": 0x0001,
    "monitor_text": 0x0002,
    "monitor_low_graphics": 0x0004,
    "monitor_high_graphics": 0x0008,
    "initialize_text": 0x0010,
    "initialize_low_graphics": 0x0020,
    "initialize_high_graphics": 0x0040,
    "retain_video": 0x0080,
}
HOTKEY_FLAGS = {
    "shift": 0x0001,
    "control": 0x0004,
    "alt": 0x0008,
}

BASE_FIELDS = {
    "reserved": (0x0000, "B"),
    "maximum_memory_kb": (0x0020, "H"),
    "minimum_memory_kb": (0x0022, "H"),
    "default_drive": (0x0064, "B"),
    "initial_screen_mode": (0x00E5, "B"),
    "text_pages": (0x00E6, "B"),
    "first_interrupt": (0x00E7, "B"),
    "last_interrupt": (0x00E8, "B"),
    "screen_rows": (0x00E9, "B"),
    "screen_columns": (0x00EA, "B"),
    "window_row": (0x00EB, "B"),
    "window_column": (0x00EC, "B"),
    "system_memory": (0x00ED, "H"),
    "program_flags": (0x016F, "H"),
}
BASE_STRINGS = {
    "title": (0x0002, 30),
    "program": (0x0024, 63),
    "startup_directory": (0x0065, 64),
    "parameters": (0x00A5, 64),
    "shared_program": (0x00EF, 64),
    "shared_data_file": (0x012F, 64),
}
DATA386_FIELDS = {
    "memory_limit_kb": (0x00, "h"),
    "memory_required_kb": (0x02, "h"),
    "foreground_priority": (0x04, "H"),
    "background_priority": (0x06, "H"),
    "maximum_ems_kb": (0x08, "h"),
    "minimum_ems_kb": (0x0A, "H"),
    "maximum_xms_kb": (0x0C, "h"),
    "minimum_xms_kb": (0x0E, "H"),
    "reserved_word": (0x16, "H"),
    "hotkey_scan_code": (0x18, "H"),
    "hotkey_enabled": (0x1C, "H"),
}
DATA286_FIELDS = {
    "xms_limit_kb": (0x00, "H"),
    "xms_required_kb": (0x02, "H"),
    "flags_raw": (0x04, "B"),
    "com_ports_raw": (0x05, "B"),
}


def _fits(data: bytes | bytearray, offset: int, size: int) -> bool:
    return 0 <= offset and offset + size <= len(data)


def _unpack(data: bytes | bytearray, offset: int, kind: str) -> int:
    return struct.unpack_from("<" + kind, data, offset)[0]


def _pack(data: bytearray, offset: int, kind: str, value: int) -> None:
    size = struct.calcsize("<" + kind)
    if not _fits(data, offset, size):
        raise ValueError(f"field at 0x{offset:X} is outside the PIF")
    struct.pack_into("<" + kind, data, offset, value)


def _decode_string(data: bytes | bytearray, offset: int, size: int) -> str:
    raw = bytes(data[offset : offset + size]).split(b"\0", 1)[0]
    return raw.decode("cp437").rstrip(" ")


def _encode_string(data: bytearray, offset: int, size: int, value: str) -> None:
    if _decode_string(data, offset, size) == value:
        return
    encoded = value.encode("cp437")
    if len(encoded) >= size:
        raise ValueError(f"string is too long for {size}-byte PIF field: {value!r}")
    if not _fits(data, offset, size):
        raise ValueError(f"string field at 0x{offset:X} is outside the PIF")
    data[offset : offset + size] = encoded + bytes(size - len(encoded))


def _decode_flags(raw: int, masks: dict[str, int]) -> dict[str, int | bool]:
    result: dict[str, int | bool] = {"raw": raw}
    result.update((name, bool(raw & mask)) for name, mask in masks.items())
    return result


def _encode_flags(value: dict, masks: dict[str, int]) -> int:
    raw = int(value["raw"])
    for name, mask in masks.items():
        if name not in value:
            continue
        if value[name]:
            raw |= mask
        else:
            raw &= ~mask
    return raw


def _decode_base(data: bytes) -> dict:
    result: dict = {}
    for name, (offset, kind) in BASE_FIELDS.items():
        size = struct.calcsize("<" + kind)
        if _fits(data, offset, size):
            result[name] = _unpack(data, offset, kind)
    for name, (offset, size) in BASE_STRINGS.items():
        if _fits(data, offset, size):
            result[name] = _decode_string(data, offset, size)
    if _fits(data, 0x0063, 1):
        result["execution_flags"] = _decode_flags(data[0x0063], {"close_on_exit": 0x10})
    if _fits(data, 0x0001, 1):
        stored = data[1]
        checksum = {"stored": stored}
        if len(data) >= PIFEX_OFFSET:
            calculated = sum(data[2:PIFEX_OFFSET]) & 0xFF
            checksum.update(calculated=calculated, valid=(stored == calculated))
        result["checksum"] = checksum
    return result


def _encode_base(data: bytearray, value: dict) -> None:
    for name, (offset, kind) in BASE_FIELDS.items():
        if name in value:
            _pack(data, offset, kind, int(value[name]))
    for name, (offset, size) in BASE_STRINGS.items():
        if name in value:
            _encode_string(data, offset, size, value[name])
    if "execution_flags" in value:
        _pack(data, 0x0063, "B", _encode_flags(value["execution_flags"], {"close_on_exit": 0x10}))


def _section_name(data: bytes | bytearray, offset: int) -> str:
    return _decode_string(data, offset, SECTION_NAME_SIZE)


def _find_sections(data: bytes | bytearray) -> list[dict]:
    if not _fits(data, PIFEX_OFFSET, SECTION_NAME_SIZE + SECTION_HEADER_SIZE):
        return []
    if _section_name(data, PIFEX_OFFSET) != "MICROSOFT PIFEX":
        return []

    sections = []
    offset = PIFEX_OFFSET
    visited = set()
    while offset != 0xFFFF:
        if offset in visited:
            raise ValueError(f"PIF extension chain loops at 0x{offset:X}")
        visited.add(offset)
        if not _fits(data, offset, SECTION_NAME_SIZE + SECTION_HEADER_SIZE):
            raise ValueError(f"PIF extension header at 0x{offset:X} is truncated")
        next_offset, data_offset, data_size = struct.unpack_from(
            "<HHH", data, offset + SECTION_NAME_SIZE
        )
        if data_size and not _fits(data, data_offset, data_size):
            raise ValueError(
                f"PIF extension {_section_name(data, offset)!r} data at "
                f"0x{data_offset:X}+0x{data_size:X} is truncated"
            )
        sections.append(
            {
                "name": _section_name(data, offset),
                "header_offset": offset,
                "next_offset": next_offset,
                "data_offset": data_offset,
                "data_size": data_size,
            }
        )
        offset = next_offset
    return sections


def _decode_386(data: bytes, offset: int, size: int) -> dict:
    result: dict = {}
    for name, (relative, kind) in DATA386_FIELDS.items():
        width = struct.calcsize("<" + kind)
        if relative + width <= size:
            result[name] = _unpack(data, offset + relative, kind)
    if size >= 0x12:
        result["behavior"] = _decode_flags(_unpack(data, offset + 0x10, "H"), FLAG386)
    if size >= 0x14:
        result["xms_flags"] = _decode_flags(_unpack(data, offset + 0x12, "H"), FLAGXMS)
    if size >= 0x16:
        result["video"] = _decode_flags(_unpack(data, offset + 0x14, "H"), VIDEO_FLAGS)
    if size >= 0x1C:
        result["hotkey_modifiers"] = _decode_flags(
            _unpack(data, offset + 0x1A, "H"), HOTKEY_FLAGS
        )
    if size >= 0x68:
        result["parameters"] = _decode_string(data, offset + 0x28, 64)
    return result


def _encode_386(data: bytearray, offset: int, size: int, value: dict) -> None:
    for name, (relative, kind) in DATA386_FIELDS.items():
        if name in value:
            width = struct.calcsize("<" + kind)
            if relative + width > size:
                raise ValueError(f"386 field {name!r} is outside its section")
            _pack(data, offset + relative, kind, int(value[name]))
    flag_fields = (
        ("behavior", 0x10, FLAG386),
        ("xms_flags", 0x12, FLAGXMS),
        ("video", 0x14, VIDEO_FLAGS),
        ("hotkey_modifiers", 0x1A, HOTKEY_FLAGS),
    )
    for name, relative, masks in flag_fields:
        if name in value:
            if relative + 2 > size:
                raise ValueError(f"386 field {name!r} is outside its section")
            _pack(data, offset + relative, "H", _encode_flags(value[name], masks))
    if "parameters" in value:
        if size < 0x68:
            raise ValueError("386 parameters are outside their section")
        _encode_string(data, offset + 0x28, 64, value["parameters"])


def _decode_286(data: bytes, offset: int, size: int) -> dict:
    result = {}
    for name, (relative, kind) in DATA286_FIELDS.items():
        width = struct.calcsize("<" + kind)
        if relative + width <= size:
            result[name] = _unpack(data, offset + relative, kind)
    return result


def _encode_286(data: bytearray, offset: int, size: int, value: dict) -> None:
    for name, (relative, kind) in DATA286_FIELDS.items():
        if name not in value:
            continue
        width = struct.calcsize("<" + kind)
        if relative + width > size:
            raise ValueError(f"286 field {name!r} is outside its section")
        _pack(data, offset + relative, kind, int(value[name]))


def pif_to_json(data: bytes) -> dict:
    result = {
        "schema": SCHEMA,
        "raw_file_base64": base64.b64encode(data).decode("ascii"),
        "file_size": len(data),
        "base": _decode_base(data),
        "extensions": [],
    }
    for layout in _find_sections(data):
        section = {"layout": layout}
        offset = layout["data_offset"]
        size = layout["data_size"]
        section["raw_data_base64"] = base64.b64encode(data[offset : offset + size]).decode("ascii")
        if layout["name"] == "WINDOWS 386 3.0":
            section["windows_386"] = _decode_386(data, offset, size)
        elif layout["name"].lstrip() == "WINDOWS 286 3.0":
            section["windows_286"] = _decode_286(data, offset, size)
        result["extensions"].append(section)
    return result


def json_to_pif(document: dict) -> bytes:
    if document.get("schema") != SCHEMA:
        raise ValueError(f"expected schema {SCHEMA!r}")
    data = bytearray(base64.b64decode(document["raw_file_base64"], validate=True))
    if document.get("file_size") != len(data):
        raise ValueError("file_size does not match raw_file_base64")
    _encode_base(data, document["base"])

    actual_sections = {item["header_offset"]: item for item in _find_sections(data)}
    for section in document.get("extensions", []):
        layout = section["layout"]
        header_offset = int(layout["header_offset"])
        actual = actual_sections.get(header_offset)
        if actual is None or actual != layout:
            raise ValueError(f"extension layout at 0x{header_offset:X} does not match the PIF")
        offset = actual["data_offset"]
        size = actual["data_size"]
        if "windows_386" in section:
            if actual["name"] != "WINDOWS 386 3.0":
                raise ValueError("windows_386 data is attached to the wrong section")
            _encode_386(data, offset, size, section["windows_386"])
        if "windows_286" in section:
            if actual["name"].lstrip() != "WINDOWS 286 3.0":
                raise ValueError("windows_286 data is attached to the wrong section")
            _encode_286(data, offset, size, section["windows_286"])

    if len(data) >= PIFEX_OFFSET:
        data[1] = sum(data[2:PIFEX_OFFSET]) & 0xFF
    return bytes(data)


def _write_json(document: dict, output: Path | None) -> None:
    text = json.dumps(document, indent=2, sort_keys=True) + "\n"
    if output is None:
        sys.stdout.write(text)
    else:
        output.write_text(text, encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    to_json = subparsers.add_parser("to-json", help="decode a PIF into editable JSON")
    to_json.add_argument("input", type=Path)
    to_json.add_argument("output", type=Path, nargs="?")
    from_json = subparsers.add_parser("from-json", help="encode JSON into a PIF")
    from_json.add_argument("input", type=Path)
    from_json.add_argument("output", type=Path)
    args = parser.parse_args()

    try:
        if args.command == "to-json":
            _write_json(pif_to_json(args.input.read_bytes()), args.output)
        else:
            document = json.loads(args.input.read_text(encoding="utf-8"))
            args.output.write_bytes(json_to_pif(document))
    except (OSError, ValueError, KeyError, json.JSONDecodeError) as error:
        parser.error(str(error))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

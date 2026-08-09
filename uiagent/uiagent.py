#!/usr/bin/env python3
"""Send one command to the Win16 UI agent over 86Box COM1 FIFOs."""
import argparse
import os
import selectors
import sys
import time
from pathlib import Path


def transact(base: Path, command: str, timeout: float) -> list[str]:
    incoming = Path(str(base) + ".out")
    outgoing = Path(str(base) + ".in")
    deadline = time.monotonic() + timeout
    while not incoming.exists() or not outgoing.exists():
        if time.monotonic() >= deadline:
            raise TimeoutError(f"86Box FIFOs did not appear: {incoming}, {outgoing}")
        time.sleep(0.05)
    read_fd = os.open(incoming, os.O_RDWR | os.O_NONBLOCK)
    write_fd = os.open(outgoing, os.O_RDWR | os.O_NONBLOCK)
    try:
        payload = (command.rstrip("\r\n") + "\r\n").encode("ascii")
        sent = 0
        while sent < len(payload):
            try:
                sent += os.write(write_fd, payload[sent:])
            except BlockingIOError:
                if time.monotonic() >= deadline:
                    raise TimeoutError("timed out writing command")
                time.sleep(0.01)
        selector = selectors.DefaultSelector()
        selector.register(read_fd, selectors.EVENT_READ)
        buffer = bytearray()
        lines: list[str] = []
        while time.monotonic() < deadline:
            events = selector.select(max(0.0, deadline - time.monotonic()))
            if not events:
                break
            try:
                chunk = os.read(read_fd, 4096)
            except BlockingIOError:
                continue
            if not chunk:
                continue
            buffer.extend(chunk)
            while b"\n" in buffer:
                raw, _, remainder = buffer.partition(b"\n")
                buffer[:] = remainder
                line = raw.rstrip(b"\r").decode("ascii", errors="replace")
                if line.startswith("READY "):
                    continue
                lines.append(line)
                if line == "END" or line.startswith("OK") or line.startswith("ERR"):
                    return lines
        raise TimeoutError(f"no complete response to {command!r}; received {lines!r}")
    finally:
        os.close(write_fd)
        os.close(read_fd)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("base", type=Path, help="configured FIFO base path")
    parser.add_argument("command", nargs=argparse.REMAINDER)
    parser.add_argument("--timeout", type=float, default=2.0)
    args = parser.parse_args()
    if not args.command:
        parser.error("a command is required")
    for line in transact(args.base, " ".join(args.command), args.timeout):
        print(line)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, TimeoutError) as error:
        print(f"uiagent: {error}", file=sys.stderr)
        raise SystemExit(1)

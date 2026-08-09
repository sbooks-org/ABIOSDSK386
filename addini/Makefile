# ABIOSDSK Version 0.90 prerelease
# addini module — native, DOS, and test builds.
# Copyright (C) 2026 Simplebooks Foundation
# Copyright (C) 2026 Josh Rodd
#
# Native Linux/macOS builds use the host C compiler.  The DOS build uses
# Microsoft Visual C++ 1.52 under DOSBox-X with the shared toolchain in
# ../work/msvc15.

CC ?= cc
CFLAGS ?= -O2 -Wall -Wextra -Werror
UPX ?= upx

NATIVE := addini
DOS := ADDINI.COM
DOS_BUILD := build/ADDINI.COM
SAMPLE := tests/SYSTEM.INI

.PHONY: all build native dos test system-ini clean help

all: native dos

build: native

native: $(NATIVE)

dos: $(DOS)

$(NATIVE): addini.c
	$(CC) $(CFLAGS) -o $@ addini.c

$(DOS): addini.c build-addini.sh Makefile
	@command -v $(UPX) >/dev/null 2>&1 || { \
		echo "upx is required to build $(DOS)" >&2; exit 1; }
	sh ./build-addini.sh
	cp $(DOS_BUILD) $@
	@before=$$(wc -c < "$(DOS_BUILD)" | tr -d '[:space:]'); \
	if ! $(UPX) --best "$@" >build/UPX.LOG 2>&1; then \
		cat build/UPX.LOG >&2; exit 1; \
	fi; \
	if ! $(UPX) -t -qq "$@" >>build/UPX.LOG 2>&1; then \
		cat build/UPX.LOG >&2; exit 1; \
	fi; \
	after=$$(wc -c < "$@" | tr -d '[:space:]'); \
	saved=$$((before - after)); \
	percent=$$(awk -v before="$$before" -v after="$$after" \
		'BEGIN { printf "%.1f", 100 * (before - after) / before }'); \
	printf '%s\n' \
		"$(DOS) compression: $$before -> $$after bytes; $$saved bytes ($$percent%) space saved"

# Fetch the sample SYSTEM.INI from the 86Box C: drive (see ~/.mtoolsrc).
$(SAMPLE):
	mkdir -p tests
	mcopy c:/WINDOWS/SYSTEM.INI $(SAMPLE)

test: native $(SAMPLE)
	sh tests/run.sh

clean:
	rm -f $(NATIVE) $(DOS) ADDINI.OBJ
	rm -rf build

help:
	@printf '%s\n' \
		'make            Build native addini and DOS ADDINI.COM.' \
		'make native     Build addini for the host Linux/macOS system.' \
		'make dos        Build and UPX-compress DOS-compatible ADDINI.COM.' \
		'make test       Build native addini and run all test cases.' \
		'make system-ini Fetch tests/SYSTEM.INI from C: via mcopy.' \
		'make clean      Remove native and DOS build artifacts.'

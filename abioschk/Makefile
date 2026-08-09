# ABIOSCHK Version 0.90 prerelease
# Standalone DOS diagnostic build.
# Copyright (C) 2026 Simplebooks Foundation
# Copyright (C) 2026 Josh Rodd

SHELL := /bin/sh
UASM ?= uasm
UPX ?= upx

DOS := ABIOSCHK.COM
RELEASE_RAW := build/release/ABIOSCHK.COM
DEBUG_RAW := build/debug/ABIOSCHK.RAW
DEBUG_DOS := build/debug/ABIOSCHK.COM
SOURCES := abioschk.asm ../src/abiosrm.asm ../src/abios.inc

.PHONY: all dos debug clean help

all: dos

dos: $(DOS)

$(RELEASE_RAW): $(SOURCES)
	mkdir -p build/release
	$(UASM) -bin -I../src -Fo="$@" abioschk.asm

$(DOS): $(RELEASE_RAW) Makefile
	@command -v $(UPX) >/dev/null 2>&1 || { \
		echo "upx is required to build $(DOS)" >&2; exit 1; }
	cp $(RELEASE_RAW) $@
	@before=$$(wc -c < "$(RELEASE_RAW)" | tr -d '[:space:]'); \
	if ! $(UPX) --best "$@" >build/release/UPX.LOG 2>&1; then \
		cat build/release/UPX.LOG >&2; exit 1; \
	fi; \
	if ! $(UPX) -t -qq "$@" >>build/release/UPX.LOG 2>&1; then \
		cat build/release/UPX.LOG >&2; exit 1; \
	fi; \
	after=$$(wc -c < "$@" | tr -d '[:space:]'); \
	saved=$$((before - after)); \
	percent=$$(awk -v before="$$before" -v after="$$after" \
		'BEGIN { printf "%.1f", 100 * (before - after) / before }'); \
	printf '%s\n' \
		"$(DOS) compression: $$before -> $$after bytes; $$saved bytes ($$percent%) space saved"

$(DEBUG_RAW): $(SOURCES)
	mkdir -p build/debug
	$(UASM) -bin -DABIOSDSK_DEBUG -I../src -Fo="$@" abioschk.asm

$(DEBUG_DOS): $(DEBUG_RAW) Makefile
	@command -v $(UPX) >/dev/null 2>&1 || { \
		echo "upx is required to build debug ABIOSCHK.COM" >&2; exit 1; }
	cp $(DEBUG_RAW) $@
	$(UPX) --best "$@" >build/debug/UPX.LOG 2>&1
	$(UPX) -t -qq "$@" >>build/debug/UPX.LOG 2>&1

debug: $(DEBUG_DOS)

clean:
	rm -f $(DOS)
	rm -rf build

help:
	@printf '%s\n' \
		'make          Build and UPX-compress release ABIOSCHK.COM.' \
		'make dos      Build and UPX-compress release ABIOSCHK.COM.' \
		'make debug    Build and UPX-compress debug ABIOSCHK.COM.' \
		'make clean    Remove ABIOSCHK build artifacts.'

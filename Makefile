# ABIOSDSK Version 0.90 prerelease
# Copyright (C) 2026 Simplebooks Foundation
# Copyright (C) 2026 Josh Rodd

SHELL := /bin/sh

RELEASE_BINARIES := \
	release/ABIOSDSK.386 \
	release/ABIOSCHK.COM \
	release/ADDINI.COM
RELEASE_CONTAINERS := release/ABIOSDSK.ZIP release/ABIOSDSK.IMG

.PHONY: all debug release package stress clean help

all: release

debug:
	MODE=debug ./build.sh
	$(MAKE) -C abioschk debug
	$(MAKE) -C addini dos
	cp abioschk/build/debug/ABIOSCHK.COM build/debug/abioschk.com
	cp addini/ADDINI.COM build/debug/addini.com
	@printf '%s\n' 'Debug binaries are in build/debug/.'

release:
	MODE=release ./build.sh
	$(MAKE) -C abioschk dos
	$(MAKE) -C addini dos
	cp abioschk/ABIOSCHK.COM build/release/abioschk.com
	cp addini/ADDINI.COM build/release/addini.com
	cp build/release/abiosdsk.386 release/ABIOSDSK.386
	cp build/release/abioschk.com release/ABIOSCHK.COM
	cp build/release/addini.com release/ADDINI.COM
	python3 release/mkdist.py

package: release

stress:
	./build-stress.sh

clean:
	rm -rf build/*
	rm -f $(RELEASE_BINARIES) $(RELEASE_CONTAINERS)
	$(MAKE) -C addini clean
	$(MAKE) -C abioschk clean

help:
	@printf '%s\n' \
		'make          Build and package the release version.' \
		'make release  Build and package the release version.' \
		'make debug    Build debug-stamped binaries in build/debug/.' \
		'make stress   Build the disk stress programs.' \
		'make clean    Remove generated build and release artifacts.'

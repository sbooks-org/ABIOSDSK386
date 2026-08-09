# ADDINI

ADDINI updates existing INI-file sections without rewriting the original file in place. The module provides:

- `addini`: native Linux/macOS build used for local testing.
- `ADDINI.COM`: DOS-compatible tiny-model build produced with Microsoft C under DOSBox-X.
- `addini.py`: Python implementation with matching behavior.

## Build

```sh
make            # native addini and DOS ADDINI.COM
make native     # native Linux/macOS executable only
make dos        # DOS-compatible ADDINI.COM only
make test       # run the cases against addini and addini.py
```

The DOS build uses the shared Microsoft toolchain under `../work/msvc15`, targets the 386 instruction set with `/G3`, and uses the size-optimized `/O1` compiler mode. The uncompressed compiler output is written to `build/ADDINI.COM`. The Makefile then creates the final `ADDINI.COM` with UPX, verifies the packed file, and reports the before/after sizes and percentage of space saved.

## Release compression dependency

[UPX](https://upx.github.io/) is required to build the final `ADDINI.COM` release artifact. DOS `.COM` packing uses UPX's 16-bit NRV2B backend and its standard 286-or-newer decompressor. Compression and `upx -t` verification are performed automatically by:

```sh
make dos
```

UPX's LZMA backend is not available for DOS `.COM` files.

See [INSTALL.md](INSTALL.md) for build-tool installation details.

# ADDINI build dependencies

## Native Linux/macOS build

Required:

- A C compiler available as `cc` (Clang or GCC)
- `make`
- Python 3 for the Python implementation and test suite

## DOS-compatible build

Required:

- DOSBox-X
- Microsoft Visual C++ 1.52 toolchain provisioned under `../work/msvc15/VISUALC/US/VC152C/MSVC15`

The DOS build is self-contained under this module except for the shared toolchain in `../work`. It compiles for the 386 instruction set with `/G3`, uses `/O1` size optimization, disables stack probes with `/Gs`, and links as a tiny-model `.COM` with `/TINY`.

## Tests

The sample `tests/SYSTEM.INI` can be refreshed from the configured mtools `C:` drive. This requires mtools and a working `C:` entry in `~/.mtoolsrc`:

```sh
make system-ini
make test
```

## Release compression

UPX is a required release dependency for compressing the final DOS artifact.

On macOS:

```sh
brew install upx
```

On Linux, install the `upx` or `upx-ucl` package supplied by the distribution, or obtain UPX from <https://github.com/upx/upx/releases>.

The Makefile automatically packs the DOS artifact with `--best`, verifies it with `upx -t`, and prints the uncompressed size, compressed size, and percentage of space saved:

```sh
make dos
```

The uncompressed compiler output remains at `build/ADDINI.COM`; the packed release artifact is `ADDINI.COM`. The standard UPX DOS `.COM` decompressor requires a 286 or newer, which is appropriate for ADDINI. Current UPX DOS `.COM` support uses the 16-bit NRV2B compressor rather than LZMA.

ABIOSDSK.386
============
v0.90

[![Latest Release](https://github.com/sbooks-org/ABIOSDSK386/releases/tag/v0.90)](https://github.com/sbooks-org/ABIOSDSK386/releases/tag/v0.90)

7 August 2026

This is an implementation of a 32-bit Disk Access driver for Windows 3.1 or
Windows for Workgroups 3.1/3.11 for PS/2 fixed disk controllers; specifically
the:

- IBM Fixed Disk Adapter (MFM / ST-506)
- ESDI Fixed Disk Controller
- Integrated Fixed Disk and Controller (ESDI)

Any controller supported by PS/2 ABIOS should work. Disk size will be limited
by whatever is supported by ABIOS. In practical terms, disks larger than
typical real MFM or ESDI disk sizes will not work.

A utility called ABIOSCHK.COM is included which runs the same tests the 32-bit
driver does to ensure things are working.

This has not been thoroughly tested and may crash or even corrupt data and
require completely reformatting your hard disk.

An installer utility is included in release/ along with a floppy image / zip
file to make installing it a little easier. You can also install it by going to
Control Panel, Drivers, Add, Unlisted or Updated Driver, choose A:\, and then
choose the PS/2 driver.

Files in work/ are covered under their own licence (the Windows DDK) which
permits use for developing device drivers.

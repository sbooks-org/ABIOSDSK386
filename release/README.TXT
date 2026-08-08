IBM PS/2 Fixed Disk Windows 3.1 Driver - Error Messages Reference
=================================================================
August 7, 2026
Version 0.90 prerelease
Copyright (C) 2026 Simplebooks Foundation
Copyright (C) 2026 Josh Rodd

ABIOSDSK.386 is a Windows 3.1 virtual device driver (VxD) that
provides 32-bit disk access to fixed disks attached through the
IBM PS/2 Advanced BIOS (ABIOS) interface.  See HELP.TXT for what
the driver does and how to install it.  This file lists every
message the driver can print and what each one means.

PRERELEASE LIMITS
-----------------

Version 0.90 is a prerelease and needs further testing.  It has
been tested only with DOS 3.30 on partitions smaller than 32 MB.
Only system-supported MFM and ESDI fixed-disk drive types are
supported.  The disk must already work through the system ABIOS and
INT 13h configuration.  SCSI, new drive types, and controller-specific
extensions are outside the scope of this release.

Messages appear on the DOS startup screen while Windows is
booting, before the Windows logo, because they are produced by
the driver's real-mode loader.  After printing a message the
driver aborts its own load and Windows continues starting
without it: your disks still work through the BIOS, but without
32-bit disk access through ABIOSDSK.  No further dialog appears,
because the driver reports its own failure.


MESSAGES THE DRIVER CAN GENERATE
--------------------------------

1. "ABIOSDSK: ABIOS is unavailable or could not be initialized."

   Printed when the real-mode loader cannot set ABIOS up.  This
   covers any of:

     - The machine has no ABIOS, or INT 15h ABIOS services are
       not working: reading the ABIOS system parameters (INT 15h
       AH=0400h) or the initialization table (INT 15h AH=0500h)
       failed or reported an error.
     - The ABIOS reports no initialization entries, or more than
       64 of them.
     - An ABIOS initializer routine refused to initialize its
       devices.

   Meaning: this computer's ABIOS cannot be used from Windows.
   If the machine is not a PS/2 or ABIOS-compatible system, this
   is expected and harmless -- remove the device=ABIOSDSK.386
   line from SYSTEM.INI.  If it is an ABIOS machine, the ABIOS
   may be disabled in Reference Disk / Setup, or another program
   (memory manager, resident utility) may be interfering with
   INT 15h.

2. "ABIOSDSK: ABIOS tables exceed the driver limits."

   Printed when the ABIOS is present and working, but its tables
   are too large for the fixed limits compiled into the driver:
   the compacted CDA (common data area) must fit in 4096 bytes,
   the total number of logical IDs in 64, and the request block
   within a 64 KB segment.

   Meaning: an unusually large ABIOS configuration (many
   devices, large function tables).  The driver refuses to
   operate on a configuration it was not sized for rather than
   risk corruption.  Nothing can be done short of rebuilding the
   driver with larger ABIOS_MAX_* limits; the machine's disks
   continue to work through the BIOS.

3. "ABIOSDSK: no non-SCSI ABIOS fixed disk passed INT 13h
   validation."

   Printed when ABIOS initialized successfully but no fixed-disk
   unit survived the driver's validation.  A unit is rejected
   for any of these reasons:

     - It is SCSI or another unsupported drive type.  Version 0.90
       supports only system-supported MFM and ESDI fixed disks.
     - It is not readable, is powered off, or reports an
       unusable geometry (block size other than 512 bytes, or
       fewer than two blocks).
     - It does not use interrupt level 14, the standard fixed
       disk IRQ.
     - Its contents failed the comparison test: the driver reads
       sector 0, the middle sector, and the last sector twice --
       once through ABIOS and once through INT 13h -- and the two
       reads did not match byte for byte.

   Meaning: ABIOS works, but no disk this driver is willing to
   touch was found.  If the machine really has an ABIOS fixed
   disk, suspect a damaged partition table or bad sectors at the
   tested locations, or a drive that is not on IRQ 14.

4. "ABIOSCHK: ABIOS fixed disk passed INT 13h comparison reads."

   This is a SUCCESS message, and it is not printed by
   ABIOSDSK.386 at all: it comes from ABIOSCHK.COM, the
   standalone diagnostic built from the same source.  Run
   ABIOSCHK.COM from a DOS prompt to test whether a machine's
   fixed disk will be accepted by the driver; exit code 0 with
   this message means it will.  On failure, ABIOSCHK.COM prints
   one of the three "ABIOSDSK:" messages above and exits with
   code 1.


SILENT CONDITIONS (NO MESSAGE)
------------------------------

The driver can decline to load without printing anything:

  - Windows earlier than 3.10 in 386 enhanced mode (for example
    Windows 3.0).  The driver requires the enhanced-mode Windows
    version to be at least 3.10 and otherwise vanishes silently.
  - 32BITDISKACCESS=OFF in the [386Enh] section of SYSTEM.INI.
    Without 32-bit disk access the driver has no reason to load,
    so it aborts quietly.  The Windows default is ON.


RUNTIME (PROTECTED-MODE) ERROR REPORTING
----------------------------------------

Once loaded, ABIOSDSK.386 prints nothing.  Disk errors that
occur while Windows is running -- a failing read, a drive that
drops off the bus, a media error -- are reported to the file
system through the BlockDev service as ordinary device or media
errors (BDS_Device_Error / BDS_Media_Error).  You see them as
the usual DOS/Windows error dialogs ("Drive not ready", "Sector
not found", "General failure reading drive X:"), not as
ABIOSDSK text.  The retry logic and the driver's timeouts handle
transient failures automatically; a persistent stream of such
errors means the drive itself is failing.


FILE LIST
---------

  ABIOSDSK.386   The driver (VxD).
  ABIOSCHK.COM   Utility to check if ABIOS disk access is stable.
  SETUP.INF      Windows 3.1 Setup-format installation file.
  HELP.TXT       Installation and usage help (no switches exist).
  README.TXT     This file.
  INSTALL.BAT    DOS installation helper.
  ADDINI.COM     Utility to add device= entry to SYSTEM.INI.
  TEST.BAT       Test harness for ADDINI and INSTALL.BAT.
  LICENSE.TXT    MIT 1-clause license and copyright notices.

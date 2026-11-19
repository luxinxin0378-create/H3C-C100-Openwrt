# H3C C100 OpenWrt / NAS

H3C C100 custom ImmortalWrt firmware for Intel Atom x5-Z8350.

## Verified device information

- Board: H3C C100
- CPU: Intel Atom x5-Z8350, x86_64
- UEFI: 64-bit
- RAM: 2 GB
- Internal storage: 16 GB eMMC (/dev/mmcblk0, 14.56 GiB)
- Ethernet: Realtek RTL8111/8168, PCI ID 10ec:8168, current driver r8168
- Current system: ImmortalWrt 24.10-SNAPSHOT, kernel 6.6.151
- Current partition layout: GPT; 32 MiB VFAT boot, 2 GiB system, small BIOS boot partition; squashfs root with F2FS overlay.

## Project goals

- x86_64 UEFI build for H3C C100.
- NAS features: SMB/Samba, NFS, USB storage, ext4/exFAT/NTFS support, disk tools, SMART tools, FileBrowser, Syncthing and download utilities.
- QModem cellular modem management with the recommended `luci-app-qmodem-next` interface.
- USB modem drivers for common QMI, MBIM, NCM, ECM, RNDIS and serial/AT-port modes, plus USB mode switching and modem utilities.
- USB host/storage support for external disks and USB peripherals.
- OpenClash LuCI package with a pre-staged Mihomo Meta core for x86_64 baseline (AMD64 v1).
- Preserve Realtek RTL8111 support; verify selected driver against the device.
- GitHub Actions build artifacts and versioned releases.

## Storage and safety

The internal eMMC is the system disk, not a suitable sole NAS data disk. Use an external USB disk or separately attached storage device for NAS data. The single Ethernet port limits throughput to one physical link; USB networking is visible on the current installation as usb0, but its role must be verified before changing network configuration.

The existing GPT layout is device-specific. A generic x86/64 combined EFI image may repartition the entire disk. Do not flash an image directly to the live eMMC until boot, partitioning, network, and recovery have been tested. Back up the full eMMC first.

## OpenClash core

The build workflow fetches an official Mihomo release asset for Linux AMD64 v1 and stages it as /etc/openclash/core/clash_meta. AMD64 v1 is selected for broad CPU compatibility. The OpenClash LuCI package and Linux TUN support are also included. The core is a proxy userspace executable, not a replacement Linux kernel. Check it with /etc/openclash/core/clash_meta -v after boot.

## Build

1. Open Actions.
2. Select H3C C100 firmware build.
3. Choose Run workflow.
4. Download the test image from workflow artifacts. A successful CI build does not by itself prove that the image is safe to write to this particular eMMC.

Build outputs are generic x86_64 EFI images; the workflow does not yet perform destructive device-specific eMMC installation.

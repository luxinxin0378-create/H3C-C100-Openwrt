# Build profile notes

## NAS profile

This is an OpenWrt-based NAS feature set, not a full TrueNAS/Unraid replacement.

Included package targets:
- SMB file sharing through Samba 4
- NFS server
- Windows network discovery through WSDD2
- USB mass-storage and UAS
- ext4, exFAT, NTFS3 and F2FS filesystem support where available in the selected kernel/feed
- block-mount, partitioning and disk inspection utilities
- SMART monitoring utilities
- FileBrowser, Syncthing and Aria2 where available in the selected feed

Package names can change between OpenWrt branches. The build log and generated manifest are the source of truth for what was actually selected. A package that is absent from the selected feed must be added from a compatible feed before it can be included.

## OpenClash profile

- LuCI package: luci-app-openclash from the upstream OpenClash repository.
- Proxy core: Mihomo Meta Linux AMD64 v1, installed at /etc/openclash/core/clash_meta.
- Kernel networking support: kmod-tun and nftables tproxy module.
- AMD64 v1 is chosen for compatibility with the Atom x5-Z8350. Do not switch to v2/v3 without verifying CPU flags.

## Quectel modem profile: RM500Q + EC20

Target modem support is explicitly set for both Quectel modules:

- **RM500Q-GL (5G):** USB QMI mode via `kmod-usb-net-qmi-wwan` + `uqmi`; MBIM via `kmod-usb-net-cdc-mbim` + `umbim`; NCM where the module firmware is configured for NCM via `kmod-usb-net-cdc-ncm`. Keep `kmod-usb-wdm` for the control endpoint and `kmod-usb-serial-option` for AT/diagnostic serial ports. A common upstream USB ID is Quectel `2c7c:0800`.
- **EC20 (4G):** `kmod-usb-serial-option` + `kmod-usb-serial-wwan` for AT/DIAG/GPS serial functions; QMI data mode via `kmod-usb-net-qmi-wwan` + `uqmi` when the exact EC20 hardware revision/USB composition exposes a QMI interface. A common EC20 R2.0/R2.1 USB ID is `2c7c:0125`.
- `usb-modeswitch` is included for devices that enumerate initially in a storage/installer mode.
- QModem is the LuCI management layer; it does not replace kernel drivers or guarantee every modem firmware/USB composition works automatically.

After connecting each modem, verify `lsusb`, `dmesg`, `ls -l /dev/ttyUSB*`, `ip link`, and `ls /dev/cdc-wdm*`. Confirm the exact VID:PID and USB interface layout before adding any device-specific ID quirk. Do not force an unverified USB ID or change the modem's USB composition blindly.

## Storage sizing

The C100 has 2 GB RAM and a 16 GB eMMC. The internal eMMC should hold the operating system only. Put NAS data on an external USB disk. Do not assume that a generic combined-efi image preserves the existing GPT layout or expands the F2FS overlay in the same way as the installed image.

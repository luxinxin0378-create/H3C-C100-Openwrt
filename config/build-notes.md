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

## Storage sizing

The C100 has 2 GB RAM and a 16 GB eMMC. The internal eMMC should hold the operating system only. Put NAS data on an external USB disk. Do not assume that a generic combined-efi image preserves the existing GPT layout or expands the F2FS overlay in the same way as the installed image.

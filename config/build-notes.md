# 构建配置笔记

## NAS 配置

这是基于 OpenWrt 的 NAS 功能集，不是完整的 TrueNAS/Unraid 替代品。

包含的目标包：
- 通过 Samba 4 提供 SMB 文件共享
- NFS 服务器
- 通过 WSDD2 实现 Windows 网络发现
- USB 大容量存储与 UAS
- ext4、exFAT、NTFS3 与 F2FS 文件系统支持（视所选内核/feed 可用性而定）
- block-mount、分区与磁盘检查工具
- SMART 监控工具
- FileBrowser、Syncthing 与 Aria2（视所选 feed 可用性而定）

包名可能随 OpenWrt 分支变化。构建日志与生成的 manifest 是实际选包结果的唯一依据。所选 feed 里没有的包，必须先从兼容的 feed 添加才能编入。

## OpenClash 配置

- LuCI 插件：来自 OpenClash 上游仓库的 luci-app-openclash。
- 代理内核：Mihomo Meta Linux AMD64 v1，安装到 /etc/openclash/core/clash_meta。
- 内核网络支持：kmod-tun 与 nftables tproxy 模块。
- 选 AMD64 v1 是为了兼容 Atom x5-Z8350。未验证 CPU 指令集之前不要换 v2/v3。

## Quectel 模组配置：RM500Q + EC20

明确支持两款 Quectel 模组：

- **RM500Q-GL（5G）：** USB QMI 模式走 `kmod-usb-net-qmi-wwan` + `uqmi`；MBIM 走 `kmod-usb-net-cdc-mbim` + `umbim`；模组固件配置为 NCM 模式时走 `kmod-usb-net-cdc-ncm`。保留 `kmod-usb-wdm`（控制端点）与 `kmod-usb-serial-option`（AT/诊断串口）。常见上游 USB ID 为 Quectel `2c7c:0800`。
- **EC20（4G）：** `kmod-usb-serial-option` + `kmod-usb-serial-wwan` 负责 AT/DIAG/GPS 串口功能；当具体硬件版本/USB 组合暴露 QMI 接口时，数据模式走 `kmod-usb-net-qmi-wwan` + `uqmi`。常见 EC20 R2.0/R2.1 USB ID 为 `2c7c:0125`。
- `usb-modeswitch` 用于处理初始枚举为存储/安装模式的设备。
- QModem 是 LuCI 管理层；它不替代内核驱动，也不保证每种模组固件/USB 组合都能自动工作。

模组接好后，用 `lsusb`、`dmesg`、`ls -l /dev/ttyUSB*`、`ip link`、`ls /dev/cdc-wdm*` 验证。添加任何设备专属 ID quirk 之前，先确认确切的 VID:PID 与 USB 接口布局。不要强行写入未验证的 USB ID，也不要盲目更改模组的 USB 组合。

## 存储容量规划

C100 有 2 GB 内存与 16 GB eMMC。内置 eMMC 只应存放操作系统。NAS 数据放外接 USB 盘。不要假设通用 combined-efi 镜像会保留现有 GPT 布局，或像已安装系统那样自动扩展 F2FS overlay。

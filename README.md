# H3C C100 OpenWrt / NAS

H3C C100 定制 ImmortalWrt 固件（Intel Atom x5-Z8350 平台）。

## 已验证的设备信息

- 主板：H3C C100
- CPU：Intel Atom x5-Z8350，x86_64
- UEFI：64 位
- 内存：2 GB
- 内置存储：16 GB eMMC（/dev/mmcblk0，14.56 GiB）
- 有线网卡：Realtek RTL8111/8168，PCI ID 10ec:8168，当前驱动 r8168
- 当前系统：ImmortalWrt 24.10-SNAPSHOT，内核 6.6.151
- 当前分区布局：GPT；32 MiB VFAT boot 分区、2 GiB 系统分区、小容量 BIOS boot 分区；squashfs 根 + F2FS overlay

## 项目目标

- 面向 H3C C100 的 x86_64 UEFI 固件构建。
- NAS 功能：SMB/Samba、NFS、USB 存储、ext4/exFAT/NTFS 支持、磁盘工具、SMART 监控、FileBrowser、Syncthing 与下载工具。
- 通过推荐的 `luci-app-qmodem-next` 界面管理蜂窝模组（QModem）。
- 明确支持的模组：Quectel RM500Q-GL（5G，QMI/MBIM/NCM 视 USB 组合而定）与 Quectel EC20（4G，option 串口 + 暴露 QMI 接口时的 QMI 拨号）。
- 常见 QMI、MBIM、NCM、ECM、RNDIS 与串口/AT 口模式的 USB 模组驱动，含 USB 模式切换与模组工具。
- USB 主机/存储支持，可外接磁盘与 USB 外设。
- OpenClash LuCI 插件，预置 x86_64 基线（AMD64 v1）的 Mihomo Meta 内核。
- 短信转发器（sms-forwarder-next，含 api_type 开机自愈）+ 调优（BBR / 代理 TCP 调优 / DNS 缓存）+ 脚本环境（bash/curl/jq/python3）。
- 保留 Realtek RTL8111 支持；驱动选型需在设备上验证。
- GitHub Actions 构建 artifact 与版本化 Release。

## 存储与安全

内置 eMMC 是系统盘，不适合单独作为 NAS 数据盘。NAS 数据请使用外接 USB 磁盘或独立存储设备。设备只有一个以太网口，吞吐上限受单链路限制；当前系统里可见 USB 网络 usb0，但在改动网络配置前必须先验证其用途。

现有 GPT 分区布局是这台设备特有的。通用 x86/64 combined EFI 镜像可能重整整个磁盘。在启动、分区、网络与恢复方案都验证过之前，不要把镜像直接写进在用的 eMMC。务必先备份完整 eMMC。

## OpenClash 内核

构建流程从 Mihomo 官方 Release 拉取 Linux AMD64 v1 资产，预置为 /etc/openclash/core/clash_meta。选 AMD64 v1 是为了最大化 CPU 兼容性。固件同时包含 OpenClash LuCI 插件与 Linux TUN 支持。该内核是用户态代理可执行文件，不是 Linux 内核的替代品。开机后可用 `/etc/openclash/core/clash_meta -v` 验证。

## 默认登录信息

- 登录 IP：192.168.2.1（LAN 口，DHCP 自动分配 192.168.2.x）
- 网页后台：http://192.168.2.1，用户名 root，密码 root
- SSH：ssh root@192.168.2.1，密码 root
- 蜂窝模组管理：LuCI → 网络 → QModem
- 首次联网后建议尽快修改 root 密码

## 构建

1. 打开 Actions 页面。
2. 选择 H3C C100 固件构建。
3. 点击 Run workflow（可填写版本号，如 B1、B2）。
4. 构建成功后自动发布 Release（也可从 workflow artifacts 下载）。CI 构建成功本身并不能证明镜像可以安全写入这台设备的 eMMC。

构建产物是通用 x86_64 EFI 镜像；当前 workflow 尚未执行针对本设备 eMMC 的破坏性安装流程。

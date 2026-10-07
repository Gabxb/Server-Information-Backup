# 69.33.213.198 · DevBox

本机备份与说明。目录命名规则：**公网IP · 主机名**。

- 公网 IP：`69.33.213.198`
- 主机名：`DevBox`
- 采集时间（UTC）：2026-10-06T20:06:39Z
- 本机状态：即将销毁，本目录为其完整备份

---

## 一、机器概况

| 项目 | 值 |
|---|---|
| 系统 | Debian GNU/Linux 13 (trixie) |
| 内核 | Linux 6.12.107+deb13-amd64 |
| 架构 | x86_64 |
| 公网 IP | 69.33.213.198 |
| 内网地址 | 10.124.73.108（eth0）、172.17.0.1（docker0） |
| 系统盘 | /dev/sda1，ext4，40G（备份时已用约 12G） |
| EFI 分区 | /dev/sda15，vfat，124M，挂载 /boot/efi |
| 拥塞控制 | bbr + fq（已开启） |
| 文件系统边界 | 存在 Docker overlay 挂载 `/var/lib/docker/rootfs/overlayfs/<id>` |

详细资源、监听端口、systemd 单元等实时快照见同目录 `MACHINE.md`。

---

## 二、本机包含的服务

### 1. mcpv2（Docker 容器，核心服务）

机场/节点对接容器，对外提供代理节点服务。

- 镜像：`v2fly/v2fly-core:v4.45.2`
- 容器名：`mcpv2`，`restart: always`，`network_mode: host`
- 启动命令：先起 `v2scar_alpine`（对接面板）再起 `xray run -c server_config.json`
- 对外端口：**443/tcp**
- 面板对接参数（见 `configs/mcp-shx/.env`）：
  - `nodeId=446938`
  - `runPort=443`
  - `api=https://api.cjy.me`
  - `token=9vjc4n`
- 协议：VLESS + REALITY（TCP），SNI `swdist.apple.com`
- 本地 API 端口：`127.0.0.1:8079`（dokodemo-door，供 v2scar 拉状态）
- 配置文件：`configs/mcp-shx/server_config.json`、`configs/mcp-shx/docker-compose.yml`
- 程序目录（源）：`/root/mcp/shx/`
- 健康检查：每 30s 检查 `get_server_config` 与 `v2scar_alpine` 进程
- 应用日志：json-file，单文件最大 5k，保留 2 个

### 2. fail2ban（入侵防护）

- 单元：`fail2ban.service`（enabled）
- 生效 jail：`sshd`、`portscan`
- 封禁动作：`nftables`；`bantime=15d`、`findtime=10m`、`maxretry=5`
- 白名单（`ignoreip`）：`127.0.0.1/8 ::1` 以及若干已登录管理 IP，含 `69.33.213.198`
- 配置：`configs/fail2ban/`（`jail.local`、`fail2ban.local`、`paths-debian.conf`，及完整 `action.d/`、`filter.d/`）
- 相关过滤器：`configs/fail2ban/filter.d/portscan.conf`

### 3. f2b-portscan-log（端口扫描日志）

- 单元：`f2b-portscan-log.service`（enabled），由 `f2b-portscan-log.sh` 建立 nftables 表 `inet f2b-pscan`
- 作用：对非许可端口的 TCP SYN / UDP 探测打日志（前缀 `f2b-pscan: `），供 `portscan` jail 读取
- 直接放行的端口：TCP `22,443,8080`；UDP `68,5355`
- 说明：该表独立于 fail2ban 自身的 `f2b-table`，互不影响

### 4. cline-pass-switcher

- 单元：`cline-pass-switcher.service`（enabled，`Restart=always`）
- 监听：`127.0.0.1:3123`
- 程序：`/root/.cline-pass-switcher/src/server.js`（Node）
- 日志：`/root/.cline-pass-switcher/switcher.log`
- 作用：把 Cline Pass 的请求固定到 Vercel 的 DeepSeek 通道

### 5. cline hub daemon

- 进程：`.cline --cline-hub-daemon`
- 监听：`127.0.0.1:25463`，路径 `/hub`
- 工作目录：`/home/dev/cline`

### 6. prompt-orchestration-engine

- 后端：`/home/dev/claude/prompt-orchestration-engine/app.py`（Python venv），监听 `127.0.0.1:8010`
- 前端：`next-server`，监听 `127.0.0.1:3010`

### 7. 系统基础服务

- `sshd`：`0.0.0.0:22`
- `exim4`：`127.0.0.1:25`（仅本地投递）
- `systemd-resolved`：`127.0.0.53:53`、`127.0.0.54:53`、`0.0.0.0:5355`、`[::]:5355`
- `docker` / `containerd`，`cron`，`fail2ban`，`systemd-networkd`，`unattended-upgrades` 等

---

## 三、定时任务

`configs/root.crontab`：

```cron
42 6 * * 3 docker restart mcpv2
12 * * * * /usr/local/sbin/vless-healthcheck.sh
```

- 每周三 06:42 重启 `mcpv2`
- 每小时执行 `vless-healthcheck.sh`，探测三个上游节点连通性，逐节点写一行日志到 `/var/log/vless-healthcheck.log`
  - 探测节点：`No.618-Akari 69.33.213.198:443`、`No.663-Arvan 69.33.213.80:8080`、`No.423-Bandwagon 69.33.212.231:8080`
  - 每行记录 `OK/FAIL`、节点名、地址、出口 IP、Cloudflare colo、地区、耗时
  - 该脚本只做探测，不改动本机 `mcpv2` 与防火墙
- 脚本本体：`configs/vless-healthcheck.sh`

---

## 四、目录与文件说明

```text
69.33.213.198 · DevBox/
├── README.md              本说明文档
├── MACHINE.md             机器实时快照（系统/资源/端口/服务/cron/BBR）
├── packages.txt           已安装软件包（dpkg --get-selections，纯包名）
├── packages-verbose.txt   已安装软件包（dpkg -l 详细版）
├── configs/               关键配置备份
│   ├── mcp-shx/           mcpv2 对接配置：.env、docker-compose.yml、server_config.json
│   ├── systemd/           自定义单元：cline-pass-switcher、f2b-portscan-log
│   ├── fail2ban/          jail/action/filter 配置全套
│   ├── ssh/sshd_config    SSH 配置
│   ├── docker/daemon.json Docker 配置（如存在）
│   ├── sysctl.conf        sysctl 配置
│   ├── sysctl.d/          sysctl 片段
│   ├── vless-healthcheck.sh  节点探测脚本
│   ├── root.crontab       root 定时任务
│   └── hosts / hostname / resolv.conf / fstab / sources.list
└── archives/              全机压缩备份（含分片）
    ├── README.md          归档清单与分片说明
    ├── SHA256SUMS         全部归档分片校验值
    ├── reassemble.sh      分片还原 + 校验脚本
    └── *.tar.gz[.part-NN] 各目录归档
```

---

## 五、备份内容（archives/）

| 归档 | 来源 | 大小 | 分片 |
|---|---|---|---|
| boot.tar.gz | /boot | 102 MB | 2 |
| etc.tar.gz | /etc | 592 KB | 1 |
| grok-config.tar.gz | /root/.grok | 226 MB | 3 |
| home-dev.tar.gz | /home/dev | 261 MB | 3 |
| opt-srv.tar.gz | /opt、/srv | 180 B | 1 |
| root-home.tar.gz | /root | 660 MB | 8 |
| usr-local.tar.gz | /usr/local | 2 KB | 1 |
| usr.tar.gz | /usr | 1038 MB | 12 |
| var.tar.gz | /var（排除 tmp、cache） | 110 MB | 2 |

超过 GitHub 单文件 100 MB 上限的归档按 90 MB 切片为 `.part-NN`。

**未包含**：`/proc`、`/sys`、`/dev`、`/run`、`/tmp`（tmpfs，重启即失）、`/var/tmp`、`/var/cache`，以及 Docker overlay 挂载中的容器根文件系统（镜像与卷数据仍在 `var/lib/docker`、`var/lib/containerd` 归档内）。

---

## 六、下载与 Release

本机备份有两种获取方式。

**方式一：Release 资产（推荐，完整未分片）**

https://github.com/Gabxb/Server-Information-Backup/releases/tag/DevBox-2026-10-06

```bash
curl -LO https://github.com/Gabxb/Server-Information-Backup/releases/download/DevBox-2026-10-06/root-home.tar.gz
curl -LO https://github.com/Gabxb/Server-Information-Backup/releases/download/DevBox-2026-10-06/SHA256SUMS
sha256sum -c SHA256SUMS
```

Release 资产是完整文件，直接 `tar -xzf` 即可，不需要拼接。

**方式二：Git 仓库（适合看配置）**

```bash
git clone https://github.com/Gabxb/Server-Information-Backup.git
cd "Server-Information-Backup/machines/69.33.213.198 · DevBox"
```

git 中的大归档按 90 MB 切片，需先 `cd archives && ./reassemble.sh` 还原。

## 七、使用方法

### 还原归档

```bash
cd archives
./reassemble.sh          # 拼接所有分片，并用 SHA256SUMS 校验
```

单独还原某个目录（示例：/root）

```bash
cat root-home.tar.gz.part-* > root-home.tar.gz
tar -xzf root-home.tar.gz -C /
```

### 恢复 mcpv2 服务

```bash
mkdir -p /root/mcp/shx
tar -xzf archives/root-home.tar.gz -C / root/mcp/shx   # 取出原程序目录
cd /root/mcp/shx
cp "…/configs/mcp-shx/.env" .                          # 或直接使用 configs/ 中的备份
docker compose up -d
docker ps                                              # 应看到 mcpv2
```

一键脚本 `docker_go.sh` 的常规操作：

```bash
cd /root/mcp/shx
./docker_go.sh      # 2 重启 / 3 停止 / 4 查看日志 / 9 更换端口 / 88 卸载
```

### 恢复系统配置

```bash
cp configs/sysctl.conf /etc/sysctl.conf
cp configs/root.crontab /tmp/cron && crontab /tmp/cron
cp configs/fail2ban/*.conf /etc/fail2ban/
cp configs/systemd/*.service /etc/systemd/system/
cp configs/vless-healthcheck.sh /usr/local/sbin/ && chmod +x /usr/local/sbin/vless-healthcheck.sh
systemctl daemon-reload
systemctl enable --now fail2ban f2b-portscan-log cline-pass-switcher
```

### 重装软件

```bash
apt-get install -y $(cat packages.txt | tr '\n' ' ')   # 按需，建议先人工核对
```

### 查看节点健康

```bash
tail -20 /var/log/vless-healthcheck.log
```

---

## 八、备注

- 本备份按“不考虑安全性”导出，`configs/mcp-shx/.env` 内含面板 token，SSH 与各类密钥均原样保存。
- 恢复系统级配置请在相同或更高版本的 Debian 上进行，并对软件包与内核差异做人工确认。

---

## 九、可优化建议（上帝视角）

按重要性排序，供后续备份或其他机器参考。

### 备份本身

1. **用 Release 资产替代仓库内切片**：本次已同时提供 Release 完整整包。切片是为了绕开 git 的 100 MB 限制，但会让仓库体积翻倍、clone 变慢。后续可考虑大归档只走 Release，git 只留 `configs/` 与文档。
2. **归档体积可再压缩**：当前排除项已较合理。`grok-config.tar.gz` 中 `/root/.grok/downloads/grok-linux-x86_64` 是 166 MB 的单个二进制，属可再下载内容，可单独排除。
3. **`var.tar.gz` 明确排除 `/var/log`**：日志 200 MB 且无还原价值，建议并入排除列表。
4. **补 Docker 镜像清单**：`docker save v2fly/v2fly-core:v4.45.2` 可离线带镜像（约 70 MB）；目前只备份了 `docker-compose.yml` 与程序，重建时仍需拉镜像。
5. **补一处未覆盖的远端**：`/home/dev/claude/prompt-orchestration-engine` 的 remote 指向 `idlm/prompt-orchestration-engine`，但该仓库在 GitHub 上**不存在**（404），说明此项目从未上传。源文件在 `home-dev.tar.gz` 里，若要长期保存需要另建远端。
6. **加一键备份脚本**：把本次的采集步骤固化为脚本入库，换机器时直接跑，避免每次手写命令与遗漏。

### 运维

7. **`mcpv2` 的凭据轮换更集中**：`.env` 里的 `token=9vjc4n`、`nodeId` 与 REALITY 私钥分散在多处，重建时容易漏。建议在 `configs/mcp-shx/` 内单独放一份“重建所需字段清单”。
8. **`/root/mcp/shx` 有未提交改动**：`.env`、`xray`、`geoip.dat`、`geosite.dat` 均被本地修改，`server_config.json` 等还未纳入该仓库版本控制。程序本体已被 `root-home.tar.gz` 覆盖，但该目录自身的 git 状态值得整理。
9. **日志轮转**：`/var/log` 已达 200 MB，`vless-healthcheck.log` 每小时追加一行，建议配置 logrotate 上限。
10. **BBR 已开启**，无需改动；`fail2ban` 规则与 `f2b-pscan` 表工作正常。

### 文档

11. 每台机器都应有本文件同款 `README.md`，并统一包含：服务清单、文件说明、下载方式、还原步骤。
12. 新增机器时同步更新顶层 README 的机器列表与 Release 命名。

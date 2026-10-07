# Server-Information-Backup

整机备份仓库。每台机器一个目录，命名规则：**公网IP · 主机名**。

## 这是一个什么项目

把整台服务器“打包带走”的备份仓库。机器销毁/重装前，把系统关键配置与全部文件归档存到这里，
之后在新机器上按文档还原即可。设计目标是：**不依赖任何备份软件、只用 git 和 tar，随时可读可还原**。

已完成备份的机器：**1 台**（DevBox）。每台机器的目录里都有独立说明文档，写清该机器跑了什么服务、文件在哪、怎么还原。

## 目录结构

```text
machines/<公网IP> · <主机名>/
├── README.md               机器说明文档（服务清单、文件说明、使用方法）
├── MACHINE.md              机器实时快照（系统/资源/端口/服务/cron/sysctl）
├── packages.txt            已安装软件包（纯包名，便于批量重装）
├── packages-verbose.txt    已安装软件包（详细版）
├── configs/                关键配置备份（可直接拷回 /etc 等位置）
└── archives/               全机压缩归档（含分片、SHA256SUMS、还原脚本）
```

## 机器列表

| 机器目录 | 公网 IP | 主机名 | 采集时间 (UTC) | 说明 |
|---|---|---|---|---|
| [69.33.213.198 · DevBox](<machines/69.33.213.198 · DevBox/README.md>) | 69.33.213.198 | DevBox | 2026-10-06T20:06:39Z | 代理节点 + fail2ban + cline 相关服务 |

## 备份内容与还原

`archives/` 是各系统目录的压缩快照，`configs/` 是可读的关键配置副本（方便直接查看和回拷）。

### 两种获取方式

**方式一：Git（适合只想看配置、小文件）**

```bash
git clone https://github.com/Gabxb/Server-Information-Backup.git
cd "Server-Information-Backup/machines/69.33.213.198 · DevBox"
```

注意：git 里的大归档按 90 MB 切片存放（GitHub 单文件上限 100 MB）。

**方式二：Release 资产（适合直接下载整包）**

每次备份会在 [Releases](../../releases) 发布对应版本，资产是**完整未分片的** `.tar.gz`，无需拼接：

```bash
# 下载某个归档
curl -LO https://github.com/Gabxb/Server-Information-Backup/releases/download/DevBox-2026-10-06/root-home.tar.gz
```

### 还原本机

```bash
# 1) 校验（git 方式还原分片后执行）
cd archives && ./reassemble.sh

# 2) 解包到根目录
tar -xzf root-home.tar.gz -C /

# 3) 具体服务的恢复步骤见各机器目录下的 README.md
```

## Release 命名规则

统一格式：**`<主机名>-<日期>`**，标题为 **`<主机名> · <日期> · <公网IP>`**。

| tag | 标题 | 说明 |
|---|---|---|
| `DevBox-2026-10-06` | DevBox · 2026-10-06 · 69.33.213.198 | DevBox 整机备份 |

## 归档说明

`archives/` 内为各目录快照。git 中超过 GitHub 单文件 100 MB 上限的归档按 90 MB 切片为
`<name>.tar.gz.part-NN`；Release 资产为完整文件。

```bash
cd "machines/<主机目录>/archives" && ./reassemble.sh   # 还原分片并校验
```

`SHA256SUMS` 覆盖所有分片。

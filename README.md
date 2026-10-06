# Server-Information-Backup

整机备份仓库。每台机器一个目录，命名规则：**公网IP · 主机名**。

## 目录结构

```text
machines/<公网IP> · <主机名>/
├── README.md               机器说明文档（服务、文件、使用方法）
├── MACHINE.md              机器实时快照（系统/资源/端口/服务/cron/sysctl）
├── packages.txt            已安装软件包（纯包名）
├── packages-verbose.txt    已安装软件包（详细版）
├── configs/                关键配置备份
└── archives/               全机压缩备份（含分片、校验值、还原脚本）
```

## 机器列表

| 机器目录 | 公网 IP | 主机名 | 采集时间 (UTC) | 说明 |
|---|---|---|---|---|
| [69.33.213.198 · DevBox](<machines/69.33.213.198 · DevBox/README.md>) | 69.33.213.198 | DevBox | 2026-10-06T20:06:39Z | 代理节点 + fail2ban + cline 相关服务 |

## 归档说明

`archives/` 内为各目录快照。超过 GitHub 单文件 100 MB 上限的归档按 90 MB 切片为
`<name>.tar.gz.part-NN`。还原与校验：

```bash
cd "machines/<主机目录>/archives" && ./reassemble.sh
```

`SHA256SUMS` 覆盖所有分片，详见各机器目录下的 `README.md`。

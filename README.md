# Server-Information-Backup

Full machine backups, stored by host. Each machine lives in `machines/<HOSTNAME>/`.

## Layout

```
machines/<HOSTNAME>/MACHINE.md          machine record (os, kernel, ip, disk, services, cron, sysctl)
machines/<HOSTNAME>/packages.txt        installed package list
machines/<HOSTNAME>/packages-verbose.txt
machines/<HOSTNAME>/configs/            key configs (mcp-shx, systemd, fail2ban, ssh, docker, sysctl, crontab)
machines/<HOSTNAME>/archives/           full-machine snapshots for this host
```

## Archives

`machines/DevBox/archives/` holds the full-machine snapshots for `DevBox`:
`/boot`, `/etc`, `/opt`, `/srv`, `/root`, `/root/.grok`, `/home/dev`, `/usr`, `/usr/local`, `/var`.

Archives larger than GitHub's 100 MB per-file limit are split into `<name>.tar.gz.part-NN` parts.
Reassemble and verify:

```bash
cd machines/DevBox/archives && ./reassemble.sh
```

`SHA256SUMS` covers every part. See `machines/DevBox/archives/README.md` for the parts table.

## Machines

| host | captured (UTC) | record |
|---|---|---|
| DevBox | 2026-10-06T20:06:39Z | [machines/DevBox/MACHINE.md](machines/DevBox/MACHINE.md) |

# Server-Information-Backup

Full machine backups, stored by host. Each machine lives in `machines/<HOSTNAME>/`.

## Layout

```
machines/<HOSTNAME>/MACHINE.md    machine record (os, kernel, ip, disk, services, cron, sysctl)
machines/<HOSTNAME>/packages.txt  installed package list
machines/<HOSTNAME>/configs/      key configs (mcp-shx, systemd, fail2ban, sysctl, crontab)
archives/                         host archives (etc, root-home, home-dev, grok-config, usr-local)
```

## Archives

`archives/` holds compressed snapshots for the most recent host (`DevBox`).
Archives larger than GitHub's 100 MB per-file limit are split into `<name>.tar.gz.part-NN` parts.

Reassemble and verify:

```bash
cd archives && ./reassemble.sh
```

`SHA256SUMS` covers every part. See `archives/README.md` for the parts table.

## Machines

| host | captured (UTC) | record |
|---|---|---|
| DevBox | 2026-10-06T19:42:48Z | [machines/DevBox/MACHINE.md](machines/DevBox/MACHINE.md) |

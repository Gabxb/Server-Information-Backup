# DevBox archives

Captured: 2026-10-06T20:36:50Z

Full-machine snapshots. Files over GitHub's 100 MB limit are split into
`<name>.tar.gz.part-NN` parts. Reassemble and verify with:

```
cd archives && ./reassemble.sh
```

| archive | source | size | parts |
|---|---|---|---|
| boot.tar.gz | /boot | 102 MB | 2 (split) |
| etc.tar.gz | /etc | 0 MB | 1 |
| grok-config.tar.gz | /root/.grok | 226 MB | 3 (split) |
| home-dev.tar.gz | /home/dev | 261 MB | 3 (split) |
| opt-srv.tar.gz | /opt /srv | 0 KB | 1 |
| root-home.tar.gz | /root | 660 MB | 8 (split) |
| usr-local.tar.gz | /usr/local | 2 KB | 1 |
| usr.tar.gz | /usr | 1038 MB | 12 (split) |
| var.tar.gz | /var (excl tmp,cache) | 110 MB | 2 (split) |

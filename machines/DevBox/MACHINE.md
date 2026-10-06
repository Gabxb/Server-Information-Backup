# DevBox machine record

- captured_utc: 2026-10-06T19:42:48Z
- hostname: DevBox
- os: Debian GNU/Linux 13 (trixie)
- kernel: Linux 6.12.107+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.107-1 (2026-08-29) x86_64
- public_ip: 69.33.213.198
- local_addrs: 10.124.73.108 172.17.0.1 

## resources
```
               total        used        free      shared  buff/cache   available
Mem:           3.8Gi       1.0Gi       615Mi       9.4Mi       2.6Gi       2.8Gi
Swap:          4.0Gi       2.2Gi       1.8Gi

Filesystem     Type      Size  Used Avail Use% Mounted on
udev           devtmpfs  1.9G     0  1.9G   0% /dev
tmpfs          tmpfs     393M  744K  392M   1% /run
/dev/sda1      ext4       40G   12G   26G  32% /
tmpfs          tmpfs     2.0G     0  2.0G   0% /dev/shm
tmpfs          tmpfs     5.0M     0  5.0M   0% /run/lock
tmpfs          tmpfs     2.0G  2.0G     0 100% /tmp
tmpfs          tmpfs     1.0M     0  1.0M   0% /run/credentials/systemd-resolved.service
/dev/sda15     vfat      124M  8.9M  115M   8% /boot/efi
tmpfs          tmpfs     1.0M     0  1.0M   0% /run/credentials/serial-getty@ttyS0.service
tmpfs          tmpfs     1.0M     0  1.0M   0% /run/credentials/getty@tty1.service
tmpfs          tmpfs     393M  4.0K  393M   1% /run/user/0
tmpfs          tmpfs     1.0M     0  1.0M   0% /run/credentials/systemd-networkd.service
tmpfs          tmpfs     1.0M     0  1.0M   0% /run/credentials/systemd-journald.service
overlay        overlay    40G   12G   26G  32% /var/lib/docker/rootfs/overlayfs/82588dd7b59c2d72826b113b7b2976d6dbb2fca45428dfe733d23987852b622c

NAME    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda       8:0    0   40G  0 disk 
├─sda1    8:1    0 39.9G  0 part /
├─sda14   8:14   0    3M  0 part 
└─sda15   8:15   0  124M  0 part /boot/efi
sdb       8:16   0    1M  0 disk 
```

## uptime
```
 19:42:49 up 34 days, 16:48,  3 users,  load average: 0.00, 0.06, 0.05
```

## listening
```
Netid State  Recv-Q Send-Q      Local Address:Port  Peer Address:PortProcess                                      
udp   UNCONN 0      0                 0.0.0.0:5355       0.0.0.0:*    users:(("systemd-resolve",pid=354,fd=11))   
udp   UNCONN 0      0              127.0.0.54:53         0.0.0.0:*    users:(("systemd-resolve",pid=354,fd=20))   
udp   UNCONN 0      0           127.0.0.53%lo:53         0.0.0.0:*    users:(("systemd-resolve",pid=354,fd=18))   
udp   UNCONN 0      0      10.124.73.108%eth0:68         0.0.0.0:*    users:(("systemd-network",pid=164602,fd=32))
udp   UNCONN 0      0                    [::]:5355          [::]:*    users:(("systemd-resolve",pid=354,fd=13))   
tcp   LISTEN 0      20              127.0.0.1:25         0.0.0.0:*    users:(("exim4",pid=391892,fd=5))           
tcp   LISTEN 0      128               0.0.0.0:22         0.0.0.0:*    users:(("sshd",pid=692,fd=6))               
tcp   LISTEN 0      4096           127.0.0.54:53         0.0.0.0:*    users:(("systemd-resolve",pid=354,fd=21))   
tcp   LISTEN 0      512             127.0.0.1:25463      0.0.0.0:*    users:((".cline",pid=347845,fd=41))         
tcp   LISTEN 0      511             127.0.0.1:3010       0.0.0.0:*    users:(("next-server (v",pid=29967,fd=21))  
tcp   LISTEN 0      511             127.0.0.1:3123       0.0.0.0:*    users:(("MainThread",pid=349089,fd=21))     
tcp   LISTEN 0      4096        127.0.0.53%lo:53         0.0.0.0:*    users:(("systemd-resolve",pid=354,fd=19))   
tcp   LISTEN 0      4096              0.0.0.0:5355       0.0.0.0:*    users:(("systemd-resolve",pid=354,fd=12))   
tcp   LISTEN 0      2048            127.0.0.1:8010       0.0.0.0:*    users:(("python",pid=29966,fd=6))           
tcp   LISTEN 0      32768           127.0.0.1:8079       0.0.0.0:*    users:(("xray",pid=395258,fd=7))            
tcp   LISTEN 0      20                  [::1]:25            [::]:*    users:(("exim4",pid=391892,fd=6))           
tcp   LISTEN 0      128                  [::]:22            [::]:*    users:(("sshd",pid=692,fd=7))               
tcp   LISTEN 0      32768                   *:443              *:*    users:(("xray",pid=395258,fd=4))            
tcp   LISTEN 0      4096                 [::]:5355          [::]:*    users:(("systemd-resolve",pid=354,fd=14))   
```

## docker
```
CONTAINER ID   IMAGE                      COMMAND                  CREATED      STATUS                  PORTS     NAMES
82588dd7b59c   v2fly/v2fly-core:v4.45.2   "sh -c '/usr/local/s…"   6 days ago   Up 6 days (unhealthy)             mcpv2
```

## cron
```
42 6 * * 3 docker restart mcpv2
12 * * * * /usr/local/sbin/vless-healthcheck.sh
```

## enabled units
```
UNIT FILE                            STATE   PRESET
apparmor.service                     enabled enabled
cline-pass-switcher.service          enabled enabled
cloud-config.service                 enabled enabled
cloud-final.service                  enabled enabled
cloud-init-local.service             enabled enabled
cloud-init-main.service              enabled enabled
cloud-init-network.service           enabled enabled
containerd.service                   enabled enabled
cron.service                         enabled enabled
docker.service                       enabled enabled
e2scrub_reap.service                 enabled enabled
exim4.service                        enabled enabled
f2b-portscan-log.service             enabled enabled
fail2ban.service                     enabled enabled
getty@.service                       enabled enabled
grub-common.service                  enabled enabled
guestfs-firstboot.service            enabled enabled
ssh.service                          enabled enabled
sshd-keygen.service                  enabled enabled
systemd-network-generator.service    enabled enabled
systemd-networkd-wait-online.service enabled enabled
systemd-networkd.service             enabled enabled
systemd-pstore.service               enabled enabled
systemd-resolved.service             enabled enabled
systemd-timesyncd.service            enabled enabled
unattended-upgrades.service          enabled enabled
cloud-init-hotplugd.socket           enabled enabled
docker.socket                        enabled enabled
systemd-networkd.socket              enabled enabled
uuidd.socket                         enabled enabled
remote-fs.target                     enabled enabled
apt-daily-upgrade.timer              enabled enabled
apt-daily.timer                      enabled enabled
dpkg-db-backup.timer                 enabled enabled
e2scrub_all.timer                    enabled enabled
exim4-base.timer                     enabled enabled
fstrim.timer                         enabled enabled
man-db.timer                         enabled enabled

38 unit files listed.
```

## sysctl bbr
```
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq
```

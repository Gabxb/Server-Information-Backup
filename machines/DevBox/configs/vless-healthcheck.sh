#!/bin/sh
# Hourly check of three user VLESS nodes. Logs one line per node.
# Does not touch local mcpv2 or firewall.
set -u
XRAY=/root/mcp/shx/xray
LOG=/var/log/vless-healthcheck.log
UUID=992ca52a-45fa-4ec7-84c3-efff32ad9e3b
PBK=synxygq0ozctiW0jNF1mmvAI9PainW0rBfqe11LkeAM
if [ ! -x "$XRAY" ]; then
  echo "$(date -u +%FT%TZ) FAIL xray missing" >> "$LOG"
  exit 0
fi
check() {
  name=$1 addr=$2 port=$3 socks=$4
  cfg=$(mktemp /tmp/vless-hc.XXXXXX.json)
  err=$(mktemp /tmp/vless-hc.XXXXXX.log)
  cat > "$cfg" << JSON
{"log":{"loglevel":"warning"},"inbounds":[{"port":$socks,"listen":"127.0.0.1","protocol":"socks","settings":{"udp":false}}],"outbounds":[{"protocol":"vless","settings":{"vnext":[{"address":"$addr","port":$port,"users":[{"id":"$UUID","encryption":"none","flow":"xtls-rprx-vision"}]}]},"streamSettings":{"network":"tcp","security":"reality","realitySettings":{"serverName":"swdist.apple.com","fingerprint":"random","publicKey":"$PBK","shortId":""}}}]}
JSON
  "$XRAY" run -c "$cfg" >"$err" 2>&1 &
  pid=$!
  sleep 1
  t0=$(date +%s)
  body=$(curl -fsS --max-time 25 -x "socks5h://127.0.0.1:$socks" https://www.cloudflare.com/cdn-cgi/trace 2>>"$err")
  rc=$?
  t1=$(date +%s)
  kill "$pid" 2>/dev/null
  wait "$pid" 2>/dev/null
  if [ "$rc" -eq 0 ]; then
    ip=$(printf '%s\n' "$body" | awk -F= '$1=="ip"{print $2}')
    colo=$(printf '%s\n' "$body" | awk -F= '$1=="colo"{print $2}')
    loc=$(printf '%s\n' "$body" | awk -F= '$1=="loc"{print $2}')
    echo "$(date -u +%FT%TZ) OK $name $addr:$port ip=$ip colo=$colo loc=$loc time=$((t1-t0))s" >> "$LOG"
  else
    echo "$(date -u +%FT%TZ) FAIL $name $addr:$port time=$((t1-t0))s" >> "$LOG"
  fi
  rm -f "$cfg" "$err"
}
check "No.618-Akari" 69.33.213.198 443 10861
check "No.663-Arvan" 69.33.213.80 8080 10862
check "No.423-Bandwagon" 69.33.212.231 8080 10863

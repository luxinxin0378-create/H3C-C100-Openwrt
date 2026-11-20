#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-files/etc/openclash/core}"
mkdir -p "$DEST"

# 不使用 api.github.com（匿名 REST 配额 60/小时，共享池经常被耗尽 → 403）。
# releases/latest 会 302 跳转到 /tag/<版本>，该跳转不消耗 REST 配额。
LATEST_URL=""
for i in 1 2 3 4 5; do
  LATEST_URL="$(curl -fsSLI -o /dev/null -w '%{url_effective}' \
    https://github.com/MetaCubeX/mihomo/releases/latest || true)"
  [ -n "$LATEST_URL" ] && break
  echo "::warning::第 $i 次探测 mihomo latest 版本失败，20s 后重试" >&2
  sleep 20
done
TAG="${LATEST_URL##*/}"
if [ -z "$TAG" ] || [[ "$TAG" != v* ]]; then
  echo "::error::无法探测 mihomo 最新版本号（last=$LATEST_URL）" >&2
  exit 1
fi
echo "mihomo latest tag: $TAG"

# asset 命名与官方 release 一致：mihomo-linux-amd64-v1-<tag>.gz
URL="https://github.com/MetaCubeX/mihomo/releases/download/${TAG}/mihomo-linux-amd64-v1-${TAG}.gz"
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT
curl -fL --retry 5 --retry-all-errors --retry-delay 15 "$URL" -o "$TMP"
gzip -t "$TMP"
gzip -dc "$TMP" > "$DEST/clash_meta"
chmod 0755 "$DEST/clash_meta"
"$DEST/clash_meta" -v

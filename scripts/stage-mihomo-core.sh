#!/usr/bin/env bash
set -euo pipefail
DEST="${1:-files/etc/openclash/core}"
mkdir -p "$DEST"
API="https://api.github.com/repos/MetaCubeX/mihomo/releases/latest"
JSON="$(curl -fsSL "$API")"
URL="$(printf '%s' "$JSON" | jq -r '.assets[].browser_download_url | select(test("mihomo-linux-amd64-v1-[^/]+\\.gz$"))' | head -n1)"
if [[ -z "$URL" || "$URL" == "null" ]]; then
  echo "Could not find an official Mihomo Linux AMD64 v1 gzip asset." >&2
  exit 1
fi
TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT
curl -fL --retry 3 "$URL" -o "$TMP"
gzip -t "$TMP"
gzip -dc "$TMP" > "$DEST/clash_meta"
chmod 0755 "$DEST/clash_meta"
"$DEST/clash_meta" -v

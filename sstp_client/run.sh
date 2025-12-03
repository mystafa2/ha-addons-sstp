#!/bin/bash
set -euo pipefail

CONFIG_PATH=/data/options.json

# Читаємо налаштування з options.json
SERVER=$(jq -r '.server // empty' "$CONFIG_PATH")
PORT=$(jq -r '.port // empty' "$CONFIG_PATH")
USERNAME=$(jq -r '.username // empty' "$CONFIG_PATH")
PASSWORD=$(jq -r '.password // empty' "$CONFIG_PATH")

if [[ -z "$SERVER" || -z "$USERNAME" || -z "$PASSWORD" ]]; then
  echo "ERROR: server / username / password not set in options.json"
  sleep 300
  exit 1
fi

# Якщо хочеш окремо порт — можна задати в options, інакше 443
TARGET="$SERVER"
if [[ -n "$PORT" && "$PORT" != "443" ]]; then
  TARGET="${SERVER}:${PORT}"
fi

echo "=== SSTP CLIENT START ==="
echo "Server: $TARGET"
echo "Username: $USERNAME"

# Основний запуск sstpc
sstpc \
  --log-level 4 \
  --tls-ext \
  --cert-warn \
  --user "$USERNAME" \
  --password "$PASSWORD" \
  "$TARGET" \
  -- \
  usepeerdns \
  defaultroute \
  noauth \
  refuse-eap \
  refuse-pap \
  refuse-chap \
  refuse-mschap \
  require-mschap-v2 \
  nodeflate \
  nobsdcomp \
  ipparam sstp-ha &

VPN_PID=$!

# Чекаємо завершення sstpc
wait "$VPN_PID"
EXIT=$?

echo "SSTP client exited with code $EXIT"
sleep 10
exit "$EXIT"

#!/bin/bash
set -euo pipefail

CONFIG_PATH=/data/options.json

SERVER=$(jq -r '.server // empty' "$CONFIG_PATH")
USERNAME=$(jq -r '.username // empty' "$CONFIG_PATH")
PASSWORD=$(jq -r '.password // empty' "$CONFIG_PATH")

if [[ -z "$SERVER" || -z "$USERNAME" || -z "$PASSWORD" ]]; then
  echo "ERROR: server / username / password not set in options.json"
  sleep 300
  exit 1
fi

echo "=== SSTP CLIENT START ==="
echo "Server: $SERVER"
echo "Username: $USERNAME"

# основний виклик sstpc
sstpc \
  --log-level 4 \
  --tls-ext \
  --cert-warn \
  --user "$USERNAME" \
  --password "$PASSWORD" \
  "$SERVER" \
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
  nobsdcomp &
VPN_PID=$!

wait "$VPN_PID"
EXIT=$?

echo "SSTP client exited with code $EXIT"
sleep 10
exit "$EXIT"

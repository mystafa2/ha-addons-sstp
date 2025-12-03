#!/bin/bash
set -e

CONFIG_PATH=/data/options.json

SERVER=$(jq -r '.server' "$CONFIG_PATH")
USERNAME=$(jq -r '.username' "$CONFIG_PATH")
PASSWORD=$(jq -r '.password' "$CONFIG_PATH")

echo "=== SSTP CLIENT START ==="
echo "Server: $SERVER"
echo "Username: $USERNAME"

if [[ -z "$SERVER" || -z "$USERNAME" || -z "$PASSWORD" ]]; then
  echo "ERROR: server / username / password not set in options.json"
  sleep 300
  exit 1
fi

sstpc "$SERVER" \
  --username "$USERNAME" \
  --password "$PASSWORD" \
  --require-mschap-v2 \
  --noipdefault \
  --defaultroute \
  --usepeerdns \
  --debug \
  /dev/ppp &
VPN_PID=$!

wait "$VPN_PID"
EXIT=$?

echo "SSTP client exited with code $EXIT"
sleep 5
exit $EXIT

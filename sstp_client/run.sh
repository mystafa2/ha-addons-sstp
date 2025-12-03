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

sstpc \
  --log-level 4 \
  --tls-ext \
  --user "$USERNAME" \
  --password "$PASSWORD" \
  "$SERVER" \
  -- \
  usepeerdns defaultroute noauth \
  refuse-eap refuse-pap refuse-chap refuse-mschap \
  require-mschap-v2 \
  nodeflate nobsdcomp &
VPN_PID=$!

wait "$VPN_PID"
EXIT=$?

echo "SSTP client exited with code $EXIT"
sleep 5
exit "$EXIT"

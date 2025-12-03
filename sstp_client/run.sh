#!/bin/sh

CONFIG_PATH=/data/options.json

SERVER=$(jq -r '.server' "$CONFIG_PATH")
USERNAME=$(jq -r '.username' "$CONFIG_PATH")
PASSWORD=$(jq -r '.password' "$CONFIG_PATH")

echo "=== SSTP CLIENT START ==="
echo "Server: $SERVER"
echo "Username: $USERNAME"

if [ -z "$SERVER" ] || [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
  echo "ERROR: server / username / password not set in add-on options."
  sleep 300
  exit 1
fi

# Підняти SSTP-тунель як ppp0
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

echo "SSTP client started, pid=$VPN_PID"

# Тупо чекаємо, поки процес живий, щоб контейнер не впав
wait $VPN_PID
EXIT_CODE=$?

echo "SSTP client exited with code $EXIT_CODE"
sleep 5
exit $EXIT_CODE


#!/usr/bin/bash

touchpad_name="$(/usr/bin/xinput list | /usr/bin/grep -i 'touchpad' | /usr/bin/awk '{ print $3,$4,$5 }')"

if [[ "$(/usr/bin/xinput list-props "$touchpad_name" | /usr/bin/grep -i 'Device Enabled' | /usr/bin/awk '{ print $NF }')" == "1" ]]; then
  /usr/bin/xinput disable "$touchpad_name"
  echo "Disabled."
else
  /usr/bin/xinput enable "$touchpad_name"
  echo "Enabled."
fi

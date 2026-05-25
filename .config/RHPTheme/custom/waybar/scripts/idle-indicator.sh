#!/usr/bin/env bash
if [ -f /tmp/hypridle_inhibited ]; then
  echo '{"text":"󰛨","class":"active","tooltip":"Idle inhibition: ON"}'
else
  echo '{"text":"󰛩","class":"default","tooltip":"Idle inhibition: OFF"}'
fi

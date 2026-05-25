#!/usr/bin/env bash
if [ "$(dunstctl is-paused)" = "true" ]; then
  echo '{"text":"󰂛","class":"active","tooltip":"Notifications: SILENCED"}'
else
  echo '{"text":"󰂚","class":"default","tooltip":"Notifications: ENABLED"}'
fi

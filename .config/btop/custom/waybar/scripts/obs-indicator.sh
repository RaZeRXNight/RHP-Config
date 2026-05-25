#!/usr/bin/env bash
if pgrep -x obs >/dev/null 2>&1; then
  echo '{"text":"󰑋","class":"active","tooltip":"OBS is running"}'
else
  echo '{"text":"","class":"hidden"}'
fi

#!/usr/bin/env bash
updates=$(checkupdates 2>/dev/null | wc -l)
if [ "$updates" -gt 0 ]; then
  echo "{\"text\":\"$updates\",\"tooltip\":\"$updates updates available\",\"class\":\"has-updates\"}"
else
  echo "{\"text\":\"\",\"tooltip\":\"System up to date\",\"class\":\"updated\"}"
fi

#!/usr/bin/env bash
if [ -f /tmp/hypridle_inhibited ]; then
  rm -f /tmp/hypridle_inhibited
  killall -SIGUSR1 hypridle 2>/dev/null
else
  touch /tmp/hypridle_inhibited
  killall -SIGUSR1 hypridle 2>/dev/null
fi

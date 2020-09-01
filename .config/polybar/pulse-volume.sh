#!/usr/bin/bash
CURRENT_SINK=$(pactl list short sinks \
  | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' \
  | head -n 1 );
CURRENT_VOLUME=$(pactl list sinks \
  | grep '^[[:space:]]Volume:' \
  | head -n $(( $CURRENT_SINK + 1 )) \
  | tail -n 1 \
  | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,');
MUTED=$(pacmd list-sinks \
  | awk '/muted/ { print $2 }' \
  | head -n $(( $CURRENT_SINK + 1 )) \
  | tail -n 1);
if [[ $MUTED = "no" ]]; then
  if [ $CURRENT_VOLUME -gt 50 ]; then
    echo "󰕾";
  elif [ $CURRENT_VOLUME -gt 25 ]; then
    echo "󰖀";
  else
    echo "󰕿";
  fi;
else
  echo "󰝟";
fi;

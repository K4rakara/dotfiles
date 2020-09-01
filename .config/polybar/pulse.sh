#!/usr/bin/bash

# NOTE: The menus in this file are positioned based on my monitor.
# if you use this script, you'll need to modify the positions to
# suit your monitor. My monitor is 1600x900, for reference.

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
MUTE_BUTTON="";
[[ "$MUTED" = "yes" ]] && {
    MUTE_BUTTON="󰕾 Unmute";
} || {
    MUTE_BUTTON="󰝟 Mute";
};

MENU=$(rofi -no-lazy-grab \
  -theme kawaii-dracula-pulse-menu \
  -fake-transparency true \
  -xoffset -456 \
  -yoffset -48 \
  -dmenu \
  -i \
  -p "󰕾 PulseAudio" \
  -sep "|" \
  <<< "$MUTE_BUTTON|󰙪 Set volume|󰓃 Set sink|󰍬 Set source");
case "$MENU" in
  *"Mute"* )
    CURRENT_SINK=$(pactl list short sinks \
      | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' \
      | head -n 1 );
    OUTPUT=$(pacmd set-sink-mute $CURRENT_SINK true);
    if [[ $? != 0 ]]; then
      zenity \
        --title="󰕾 PulseAudio" \
        --error \
        --text="Failed to mute $PRODUCT."$'\n'"Details:"$'\n'"$OUTPUT";
    fi;
    ;;
  *"Unmute"* )
    CURRENT_SINK=$(pactl list short sinks \
      | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' \
      | head -n 1 );
    OUTPUT=$(pacmd set-sink-mute $CURRENT_SINK false);
    if [[ $? != 0 ]]; then
      zenity \
        --title="󰕾 PulseAudio" \
        --error \
        --text="Failed to unmute $PRODUCT."$'\n'"Details:"$'\n'"$OUTPUT";
    fi;
    ;;
  *"volume"* )
    # Get the current sink and volume.
    # https://unix.stackexchange.com/a/230533
    CURRENT_SINK=$(pactl list short sinks \
      | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' \
      | head -n 1 );
    CURRENT_VOLUME=$(pactl list sinks \
      | grep '^[[:space:]]Volume:' \
      | head -n $(( $CURRENT_SINK + 1 )) \
      | tail -n 1 \
      | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,');
    
    # Ask the user for a new volume.
    NEW_VOLUME=$(zenity \
      --scale \
      --title="󰕾 PulseAudio" \
      --text="Set volume:" \
      --min-value=0 \
      --max-value=100 \
      --step=1 \
      --value=$CURRENT_VOLUME);

    # Set the volume.
    pactl set-sink-volume $CURRENT_SINK $NEW_VOLUME%;
    ;;
  *"sink"* )
    sleep 0.125;
    # The "nice" names of output devices.
    PRODUCT_NAMES=$(pactl list \
      | grep -A32 'Card #' \
      | grep -e"device.product.name = " \
      | cut -d"=" -f2 \
      | cut -d"\"" -f2);
    # The internal names of output devices.
    INTERNAL_NAMES=$(pactl list\
      | grep -A2 'Card #' \
      | grep -e"Name: " \
      | cut -d":" -f2 \
      | cut -d" " -f2);
    # Both the "nice" and internal names of output devices, separated by 0x01, because that should _never_ be in either of those names.
    COMBINED_NAMES="";
    {
      I=0;
      while read -r line; do
        [ $I != 0 ] && COMBINED_NAMES+=$'\n';
        COMBINED_NAMES+="$line$(echo "$INTERNAL_NAMES" \
          | cut -d$'\n' -f$((I+1)))";
        I=$((I+1));
      done < <(echo "$PRODUCT_NAMES");
    }
    # Filter those based on which ones are availible.
    FILTERED_NAMES="";
    {
      while read -r line; do
        INTERNAL=$(echo "$line" | cut -d -f2);
        ACTIVE=`pacmd list-sinks`;
        echo "$ACTIVE" | grep "$INTERNAL";
        if [[ $? != 1 ]]; then
          [[ "$FILTERED_NAMES" != "" ]] && FILTERED_NAMES+=$'\n';
          FILTERED_NAMES+="$line";
        fi;
      done < <(echo "$COMBINED_NAMES");
    }
    # Create the display list for the menu.
    MENU_CONTENT="";
    {
      while read -r line; do
        PRODUCT=$(echo "$line" | cut -d -f1);
        [[ "$MENU_CONTENT" != "" ]] && MENU_CONTENT+=$'|';
        MENU_CONTENT+="$PRODUCT";
      done < <(echo "$FILTERED_NAMES");
    }
    MENU=$(rofi -no-lazy-grab \
      -theme kawaii-dracula-pulse-menu \
      -fake-transparency true \
      -xoffset -456 \
      -yoffset -48 \
      -dmenu \
      -i \
      -p "󰓃 Set sink" \
      -sep "|" \
      <<< $MENU_CONTENT);
    if [[ "$MENU" != "Cancel" ]]; then
      # Figure out which one was chosen.
      while read -r line; do
        PRODUCT=$(echo "$line" | cut -d -f1);
        INTERNAL=$(echo "$line" | cut -d -f2);
        if [[ "$MENU" = "$PRODUCT" ]]; then
          INTERNAL_AS_OUTPUT=${INTERNAL//alsa_card/alsa_output};
          SINK=$(pactl list sinks short \
            | grep -m1 -e"$INTERNAL_AS_OUTPUT" \
            | cut -d$' ' -f1);
          # Set the default to the detected sink.
          OUTPUT=$(pacmd set-default-sink $SINK);
          if [[ $? != 0 ]]; then
            zenity \
              --title="󰕾 PulseAudio" \
              --error \
              --text="Failed to set the sink to $PRODUCT."$'\n'"Details:"$'\n'"$OUTPUT";
          fi;
        fi;
      done < <(echo "$FILTERED_NAMES");
    fi;
    ;;
  *"source"* )
    sleep 0.125;
    # The "nice" names of output devices.
    PRODUCT_NAMES=$(pactl list \
      | grep -A48 'Source #' \
      | grep -e"device.product.name = " \
      | cut -d"=" -f2 \
      | cut -d"\"" -f2);
    # The internal names of output devices.
    INTERNAL_NAMES=$(pactl list\
      | grep -A2 'Source #' \
      | grep -e"Name: " \
      | cut -d":" -f2 \
      | cut -d" " -f2);
    # Both the "nice" and internal names of output devices, separated by 0x01, because that should _never_ be in either of those names.
    COMBINED_NAMES="";
    {
      I=0;
      while read -r line; do
        [ $I != 0 ] && COMBINED_NAMES+=$'\n';
        COMBINED_NAMES+="$line$(echo "$INTERNAL_NAMES" \
          | cut -d$'\n' -f$((I+1)))";
        I=$((I+1));
      done < <(echo "$PRODUCT_NAMES");
    }
    # Filter those based on which ones are availible.
    FILTERED_NAMES="";
    {
      while read -r line; do
        INTERNAL=$(echo "$line" | cut -d -f2);
        ACTIVE=`pacmd list-sources`;
        echo "$ACTIVE" | grep "$INTERNAL";
        if [[ $? != 1 ]]; then
          [[ "$FILTERED_NAMES" != "" ]] && FILTERED_NAMES+=$'\n';
          FILTERED_NAMES+="$line";
        fi;
      done < <(echo "$COMBINED_NAMES");
    }
    # Create the display list for the menu.
    MENU_CONTENT="";
    {
      while read -r line; do
        PRODUCT=$(echo "$line" | cut -d -f1);
        [[ "$MENU_CONTENT" != "" ]] && MENU_CONTENT+=$'|';
        MENU_CONTENT+="$PRODUCT";
      done < <(echo "$FILTERED_NAMES");
    }
    MENU=$(rofi -no-lazy-grab \
      -theme kawaii-dracula-pulse-menu \
      -fake-transparency true \
      -xoffset -456 \
      -yoffset -48 \
      -dmenu \
      -i \
      -p "󰍬 Set source" \
      -sep "|" \
      <<< $MENU_CONTENT);
    if [[ "$MENU" != "Cancel" ]]; then
      # Figure out which one was chosen.
      while read -r line; do
        PRODUCT=$(echo "$line" | cut -d -f1);
        INTERNAL=$(echo "$line" | cut -d -f2);
        if [[ "$MENU" = "$PRODUCT" ]]; then
          INTERNAL_AS_OUTPUT=${INTERNAL//alsa_card/alsa_output};
          SOURCE=$(pactl list sources short \
            | grep -m1 -e"$INTERNAL_AS_OUTPUT" \
            | cut -d$' ' -f1);
          # Set the default to the detected source.
          OUTPUT=$(pacmd set-default-source $SOURCE);
          if [[ $? != 0 ]]; then
            zenity \
              --title="󰕾 PulseAudio" \
              --error \
              --text="Failed to set the source to $PRODUCT."$'\n'"Details:"$'\n'"$OUTPUT";
          fi;
        fi;
      done < <(echo "$FILTERED_NAMES");
    fi;
    ;;
esac
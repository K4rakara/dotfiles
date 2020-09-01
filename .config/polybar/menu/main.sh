#!/usr/bin/bash
source kawaii-dracula-colors;
MENU=$(rofi -no-lazy-grab \
  -theme kawaii-dracula-menu \
  -fake-transparency true \
  -xoffset 8 \
  -yoffset -48 \
  -dmenu \
  -i \
  -p "󰀄 $(whoami)@$(hostname)" \
  -sep "|" \
  <<< "󰀻 Applications...|󱂬 Windows...|󰒓 Settings...|󰌾 Lock|󰗽 Sign out|󰐥 Shut down");
case "$MENU" in
  *"Applications"* )
    sleep 0.125;
    ~/.config/polybar/kawaii-dracula/menu/applications.sh;
    ;;
  *"Windows"* )
    echo "Windows";
    ;;
  *"Settings"* )
    sleep 0.125;
    ~/.config/polybar/kawaii-dracula/menu/settings.sh;
    ;;
  *"Lock"* )
    # TODO
    ;;
  *"Sign out"* )
    sleep 0.125;
    if zenity \
      --question \
      --text="Are you sure you want to sign out?" \
      --icon-name=dialog-question; then
      pkill xinit;
    fi;
    ;;
  *"Shut down"* )
    sleep 0.125;
    if zenity \
      --question \
      --text="Are you sure you want to shut down?" \
      --icon-name=dialog-question; then
      printf "";
    fi;
    ;;
esac
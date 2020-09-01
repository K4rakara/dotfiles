#!/usr/bin/bash
source kawaii-dracula-colors;
MENU=$(rofi -no-lazy-grab \
  -theme kawaii-dracula-menu \
  -fake-transparency true \
  -xoffset 8 \
  -yoffset -48 \
  -dmenu \
  -i \
  -p "󰒓 Settings" \
  -sep "|" \
  <<< "🐁 XFCE Settings|🐉 KDE Settings|󰁍 Back");
case "$MENU" in
  *"XFCE"* )
    nohup xfce4-settings-manager > /dev/null &
    ;;
  *"KDE"* )
    #TODO
    ;;
  *"Back"* )
    sleep 0.125;
    ~/.config/polybar/kawaii-dracula/menu/main.sh;
    ;;
esac
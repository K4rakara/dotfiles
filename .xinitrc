#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Set QT theme.
export QT_QPA_PLATFORMTHEME=qt5ct

# Set up X11 cursor.
export XCURSOR_THEME=Breeze_Obsidian xclock
export XCURSOR_SIZE=16
xsetroot -cursor_name left_ptr &

# Start daemons.
nohup mopidy > /dev/null &
nohup thunar --daemon > /dev/null &
nohup sxhkd > /dev/null &

# Start desktop.
nohup picom > /dev/null &
hsetroot -solid "#111111";
nohup polybar kawaii-dracula > /dev/null &

# Start window manager.
bspwm

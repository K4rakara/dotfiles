#!/usr/bin/bash
prettyname="";
if [[ -f /etc/os-release ]]; then
  source /etc/os-release;
  prettyname=$PRETTY_NAME;
fi;
if [[ $prettyname =~ "Arch" ]]; then
  printf "󰣇";
else
  printf "󰨑";
fi;
#!/usr/bin/bash

if [[ -d ~/.mozilla/firefox/ ]]; then

  type sass;

  if [[ "$?" = "0" ]]; then
    sass --no-source-map $PWD/other/firefox/userChrome.scss:$PWD/other/firefox/userChrome.css;
  
	PROFILE="$(ls /home/$USER/.mozilla/firefox/ | grep -e".*\.dev-edition-default")";
  	
	mkdir -p "/home/$USER/.mozilla/firefox/$PROFILE/chrome";

	cp -f "$PWD/other/firefox/userChrome.css" "/home/$USER/.mozilla/firefox/$PROFILE/chrome/userChrome.css";
  else
    echo "Warning: sass is not installed. Skipping FireFox userChrome.css.";
  fi;

fi;


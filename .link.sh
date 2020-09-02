#!/usr/bin/bash
# This script goes through all the directories in the repo and runs any script
# called ".link.sh" and executes it. This automates the process of
# "installing" my dotfiles. Note that it does _NOT_ install the dependencies
# of the dotfiles, just the dotfiles themselves. For a list of packages that
# Are required, see `./.pkglist`.

RETURN="";

# Recursivley lists a directory in a "neat" manner.
lsr() {
  local current=$(ls -la "$1");
  local to_return="";
  local i=0;
  while read -r line; do
    # Skip the first line, it just says the total, which is useless for us.
    if [ $i != 0 ]; then
      # Check if the line represents a directory.
      if [[ "$line" == d* ]]; then
        local child=$(echo "$line" \
          | grep -e"[0123456789][0123456789]:[0123456789][0123456789] .*" -o);
        child=${child:6};
        if [[ "$child" != "." ]] \
        && [[ "$child" != ".." ]] \
        && [[ "$child" != ".old" ]] \
        && [[ "$child" != ".git" ]]; then
          [[ "$to_return" != "" ]] && to_return+=$'\n';
          lsr $1/$child;
          to_return+="$RETURN";
        fi;
      else
        [[ "$to_return" != "" ]] && to_return+=$'\n';
        local child=$(echo "$line" \
          | grep -e"[0123456789][0123456789]:[0123456789][0123456789] .*" -o);
        child=${child:6};
        to_return+="$1/$child";
      fi;
    fi;
    i=$((i+1));
  done < <(echo "$current");
  RETURN="$to_return";
}

echo -e "Working...";

# Link top level config files.
ln -s -f $PWD/.vimrc ~/.vimrc;
ln -s -f $PWD/.zshrc ~/.zshrc;
ln -s -f $PWD/.zprofile ~/.zprofile;

# Link config files contained in sub-directories.
lsr "$PWD";
while read -r file; do
  if [[ "$file" == *.link.sh ]] \
  && [[ "$file" != "$PWD/.link.sh" ]]; then
    $file;
  fi;
done < <(echo "$RETURN");

echo -e "Done!";

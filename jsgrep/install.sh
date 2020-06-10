if [ "$1" = "global" ]
then
	echo "Installing globally..."
	if [ "$EUID" -ne 0 ]
	then
		echo "Installing globally requires root."
		exit
	fi
	cp ./jsgrep /usr/bin/
	chmod a+x /usr/bin/jsgrep
	echo "OK"
else
	echo "Installing locally..."
	cp ./jsgrep ~/.local/bin/
	chmod a+x ~/.local/bin/jsgrep
	echo "OK"
fi
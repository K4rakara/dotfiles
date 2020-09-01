if [ "$1" = "global" ]
then
	echo "Installing globally..."
	if [ "$EUID" -ne 0 ]
	then
		echo "Installing globally requires root."
		exit
	fi
	cp ./2gif /usr/bin/
	chmod a+x /usr/bin/2gif
	echo "OK"
else
	echo "Installing locally..."
	cp ./2gif ~/.local/bin/
	chmod a+x ~/.local/bin/2gif
	echo "OK"
fi
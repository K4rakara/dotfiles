if [ "$1" = "global" ]
then
	echo "Installing globally..."
	if [ "$EUID" -ne 0 ]
	then
		echo "Installing globally requires root."
		exit
	fi
	cp ./express-here /usr/bin/
	chmod a+x /usr/bin/express-here
	echo "OK"
else
	echo "Installing locally..."
	cp ./express-here ~/.local/bin/
	chmod a+x ~/.local/bin/express-here
	echo "OK"
fi
if [ "$1" = "global" ]
then
	echo "Installing globally..."
	if [ "$EUID" -ne 0 ]
	then
		echo "Installing globally requires root."
		exit
	fi
	cp ./round-time-up /usr/bin/
	chmod a+x /usr/bin/round-time-up
	echo "OK"
else
	echo "Installing locally..."
	cp ./round-time-up ~/.local/bin/
	chmod a+x ~/.local/bin/round-time-up
	echo "OK"
fi
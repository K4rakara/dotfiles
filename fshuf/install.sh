if [ "$1" = "global" ]
then
	echo "Installing globally..."
	if [ "$EUID" -ne 0 ]
	then
		echo "Installing globally requires root."
		exit
	fi
	cp ./fshuf /usr/bin/
	chmod a+x /usr/bin/fshuf
	echo "OK"
else
	echo "Installing locally..."
	cp ./fshuf ~/.local/bin/
	chmod a+x ~/.local/bin/fshuf
	echo "OK"
fi
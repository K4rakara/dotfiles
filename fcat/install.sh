if [ "$1" = "global" ]
then
	echo "Installing globally..."
	if [ "$EUID" -ne 0 ]
	then
		echo "Installing globally requires root."
		exit
	fi
	cp ./fcat /usr/bin/
	echo "OK"
else
	echo "Installing locally..."
	cp ./fcat ~/.local/bin/
	echo "OK"
fi

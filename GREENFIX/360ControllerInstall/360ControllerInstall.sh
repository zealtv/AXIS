#!/bin/bash
sum1="2deb0272789e05ec1f2bf14a5bdfdf3d"
echo "\n"
echo "Xbox 360 Controller driver installer for Mac OS X 10.6 'Snow Leopard'"
echo
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root:  sh 360ControllerInstall.sh" 1>&2
	exit 1
fi
#echo -n "Downloading disk image..."
	#wget http://files.tattiebogle.net/360/360ControllerInstall.0.07.dmg>>360ControllerDiag.txt
	#echo " done!"
echo -n "Verifying disk image... "
	sum2=$(md5 -q 360ControllerInstall.0.07.dmg)
	if [ "$sum1" = "$sum2" ]
		then
			echo "verified!"
		else
			echo "File is missing, damaged, or the wrong version!"
			echo "Redownload the file from http://files.tattiebogle.net/360/360ControllerInstall.0.07.dmg and make sure it is in the same location as this script."
			exit 1
	fi
echo
echo "Removing any previous installs..."
	echo -n " Unloading kernel extensions..."
		kextunload /System/Library/Extensions/360Controller.kext>>360ControllerDiag.txt
		kextunload /System/Library/Extensions/Wireless360Controller.kext>>360ControllerDiag.txt
		kextunload /System/Library/Extensions/Wireless360GamingReceiver.kext>>360ControllerDiag.txt
		echo " done!"
	echo -n " Removing files..."
		rm -Rv /System/Library/Extensions/360Controller.kext>>360ControllerDiag.txt
		rm -Rv /System/Library/Extensions/Wireless360Controller.kext>>360ControllerDiag.txt
		rm -Rv /System/Library/Extensions/WirelessGamingReceiver.kext>>360ControllerDiag.txt
		rm -Rv /Library/StartupItems/360ControlDaemon/>>360ControllerDiag.txt
		rm -Rv /Library/PreferencePanes/Pref360Control.prefPane>>360ControllerDiag.txt
		echo " done!"
	echo " done!"
echo
echo -n "Mounting disk image..."
	hdiutil mount 360ControllerInstall.0.07.dmg>>360ControllerDiag.txt
	cp -v /Volumes/360ControllerInstall/Install360Controller.pkg/Contents/Archive.pax.gz ./>>360ControllerDiag.txt
	echo " done!"
echo -n "Extracting archive..."
	gzip -d Archive.pax.gz>>../360ControllerDiag.txt
	mkdir 360ControllerTemp
	cd 360ControllerTemp
	pax -r -f ../Archive.pax>>../360ControllerDiag.txt
	cd ..
	echo " done!"
echo -n "Copying files to proper locations..."
	cp -Rv 360ControllerTemp/ />>360ControllerDiag.txt
	echo " done!"
echo -n "Loading kernel extensions..."
	kextload /System/Library/Extensions/360Controller.kext>>360ControllerDiag.txt
	kextload /System/Library/Extensions/Wireless360Controller.kext>>360ControllerDiag.txt
	kextload /System/Library/Extensions/WirelessGamingReceiver.kext>>360ControllerDiag.txt
	echo " done!"
echo -n "Cleaning up..."
	rm -v Archive.pax.gz>>360ControllerDiag.txt
	rm -v Archive.pax>>360ControllerDiag.txt
	rm -Rv 360ControllerTemp>>360ControllerDiag.txt
	hdiutil detach /Volumes/360ControllerInstall/>>360ControllerDiag.txt
	rm -v 360ControllerInstall.0.07.dmg>>360ControllerDiag.txt
	echo " done!"
echo
echo "It is highly recommended that you restart after installing.  If you choose not to restart, wait a few minutes before connecting any controllers.  A log of this process has been created as 360ControllerDiag.txt"
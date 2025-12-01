#!/bin/bash
cd /home/amnesia/Persistent/Signing/
pwd
ls -al

#ls -l /dev/disk/by-uuid
#ls -la /dev/disk/by-id/
#lsblk -o NAME,MODEL,SERIAL,UUID,LABEL

UUIDCrypto=78DA-9118
SerialCrypto=115720013578
LabelCrypto=CRYPTO
CryptoDrivefromlabel=$(ls -l /dev/disk/by-label/$LabelCrypto | grep -o '....$')
CryptoDrivefromUUID=$(ls -l /dev/disk/by-uuid/$UUIDCrypto | grep -o '....$')
CryptoDrivefromserial=$(lsblk -P -o NAME,MODEL,VENDOR,SERIAL,UUID,LABEL | grep $SerialCrypto -A 1 | cut -d '=' -f '2' | cut -d ' ' -f 1 | sed '1d' | sed 's/.//;s/.$//')
echo Crypto Drive from label, UUID and serial : $CryptoDrivefromlabel $CryptoDrivefromUUID $CryptoDrivefromserial

if [[ "$CryptoDrivefromlabel" == "$CryptoDrivefromUUID" && "$CryptoDrivefromUUID" == "$CryptoDrivefromserial" ]]; then
	echo ---- Crypto Drive succesfully detected!

	echo ---- Mounting Crypto USB
	umount /mnt/Crypto
	if [[ -d "/mnt/Crypto" ]]; then
		rm -rf /mnt/Crypto
	fi
	mkdir /mnt/Crypto
	sleep 1
	mount "/dev/$CryptoDrivefromUUID" "/mnt/Crypto"
	sleep 1
	ls -al /mnt/Crypto

	echo "### Comparing Script hashes"

	Scripthash=$(< /mnt/Crypto/USB_Process_Signing.sh.hash)
	CurrentScripthash=$(sha512sum /home/amnesia/Persistent/Signing/USB_Process_Signing.sh | cut -d " " -f 1)

	echo $Scripthash
	echo $CurrentScripthash

	if [[ "$Scripthash" == "$CurrentScripthash" ]]; then
		echo "### Script hashes match!!"
		
		UUIDFiles=E853-5B8D
		SerialFiles=115720013467
		LabelFiles=FILES
		FilesDrivefromlabel=$(ls -l /dev/disk/by-label/$LabelFiles | grep -o '....$')
		FilesDrivefromUUID=$(ls -l /dev/disk/by-uuid/$UUIDFiles | grep -o '....$')
		FilesDrivefromserial=$(lsblk -P -o NAME,MODEL,VENDOR,SERIAL,UUID,LABEL | grep $SerialFiles -A 1 | cut -d '=' -f '2' | cut -d ' ' -f 1 | sed '1d' | sed 's/.//;s/.$//')
		echo Files Drive from label, UUID and serial : $FilesDrivefromlabel $FilesDrivefromUUID $FilesDrivefromserial
		 
		if [[ "$FilesDrivefromlabel" == "$FilesDrivefromUUID" && "$FilesDrivefromUUID" == "$FilesDrivefromserial" ]]; then
			echo ---- Files Drive succesfully detected!
	  
			echo ---- Mounting Files USB
			umount /mnt/Files
			if [[ -d "/mnt/Files" ]]; then
			 	rm -rf /mnt/Files
			fi
			mkdir /mnt/Files
			sleep 1
			mount "/dev/$FilesDrivefromUUID" "/mnt/Files"
			sleep 1
			ls -al /mnt/Files
			  
			Filetosign=/mnt/Files/Somexml_File.xml
			CryptoPrivateKey=/mnt/Crypto/Prod-private.key
			CryptoPublicKey=/mnt/Crypto/Prod-public.key
			
			if [[ -f "$Filetosign" && -f "$CryptoPrivateKey" && -f "$CryptoPublicKey"  ]]; then
				echo "Environment ready to Sign the  File..."
				echo "Press 'y' to continue or 'n' to exit"
	   
				read -s -n 1 key
	   
				case $key in 
				    y|Y)
					     echo "You pressed 'y'. Signing..."
					     echo "*** Signing  Files..."
					     openssl dgst -sha256 -sign "$CryptoPrivateKey" -out "$Filetosign.sign" "$Filetosign"
					     echo "*** Verifying Signature..."
					     openssl dgst -sha256 -verify "$CryptoPublicKey" -signature "$Filetosign.sign" "$Filetosign"
					     echo "Unmount Files USB Stick, it can be disconnected safely..."
					     umount /mnt/Files
				     ;;
				    n|N)
					     echo "You pressed 'n'. Exiting..."
					     exit 1
				     ;;
				    *)
				    echo "Invalid Input. Please press 'y' or 'n'."
				     ;;
				    esac
	   
			else
				echo "---- Could not detect product_hashes.xml on the Files Drive"
				exit 1
			fi
	 
		else
			echo "---- Could not detect Files Drive"
			exit 1
		fi
	else
		echo "---- Script Hashes do not match!!"
		exit 1
	fi
  
else
	echo "---- Could not detect Crypto Drive"
	exit 1
fi

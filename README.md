# USB_Signing_Process
Process to sign manually files outbound

Machine: A laptop computer with no HDD but 3 USB-A ports

No HDD Verified by entering boot options menu.

Tails 5.17 - https://tails.net/about/index.en.html

Encrypted Persistence storage used: https://tails.net/doc/persistent_storage/index.en.html

Kingston's DataTraveler Generation 4 (DTIG4) USB Flash drive	
Live USB stick for Tails labelled: OS

2xAPRICORN Aegis Secure Key 3NX 4Gb	
https://apricorn.com/aegis-secure-key-3nx

Stick were taken from a sealed new package.

Respectively labelled: Crypto and Files

Stored in a separate physical space

All PINs, crypto and passwords necessary stored outbound as well. Keepass preferred

-- The Key Generation Ceremony

Kingston's DataTraveler Generation 4 (Label OS) attached to the machine

APRICORN Aegis Secure Key 3NX (Label Crypto) attached to  the machine

APRICORN Aegis Secure Key 3NX (Label Files) attached to  the machine

Machine booted

When requested, enter the Persistent storage passphrase as well as a sudo temporary password for the amnesia user

Unlock USB Sticks with their keypads using PINs

Private key generated from terminal in the root of the Crypto USB Stick (Passphrase to be saved in keepass db): 

openssl genrsa -aes256 -out /mnt/Crypto/Prod-private.key 2048

Public key generated from terminal in the root of the Files USB Stick:

openssl rsa -in /mnt/Crypto/IPXSigning-Prod-Andover-private.key -pubout -out /mnt/Files/Prod-public.key

[If needed] The private key is printed out using the local Printer via USB

lp /mnt/Crypto/Prod-private.key

APRICORN Aegis Secure Key 3NX (Label Crypto) and APRICORN Aegis Secure Key 3NX (Label Files) were removed the machine

Shutdown the machine

-- Signing steps

Kingston's DataTraveler Generation 4 (Label OS) attached to the machine

APRICORN Aegis Secure Key 3NX (Label Crypto) attached to  the machine

APRICORN Aegis Secure Key 3NX (Label Files) attached to  the machine

copy the file to be signed to the Files USB stick

Machine booted

When requested, enter the Persistent storage passphrase as well as a sudo temporary password for the amnesia user

Unlock USB Sticks with their keypads using PINs

run sudo ./USB_Process_Signing.sh to sign files

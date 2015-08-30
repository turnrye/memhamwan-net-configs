# HamWAN Easy Config
1. Download the [HamWAN Easy Config 0.1rc4](https://github.com/ryanturner/memhamwan-net-configs/archive/v0.1rc3-r6.31.zip), and [Winbox 3.0rc12](http://download2.mikrotik.com/routeros/winbox/3.0rc12/winbox.exe)
2. Open winbox.exe
3. Click on the "Neighbors" tab in the lower part of the Addresses window
4. Look for the entry labeled RB Metal 5SHPn under Board, and double click the MAC Address for it
5. Check the box "Open In New Window"
6. Click on the "Connect" button; don't worry, the pre-filled settings for user "admin" and no password are the default
7. Click on "Files" in the left hand menu
8. Extract the contents of the easy config zip file to a directory on your local machine, then drag and drop those files into the "Files" window
9. Click "New Terminal" and enter ```/import setup.rsc```
10. If prompted with "Your RouterOS version is too old to continue!", hit Y; the radio will disconnect and reboot; once you hear the device finish booting, as indicated by two short beeps, repeat steps 6, 9, and 10, then continue to 11
11. Follow the prompts to configure your radio; we recommend starting with it as a DHCP server and connecting a computer directly to the radio at first; you can re-run this script if you wish to change the values

net user /ADD lxadmin keDBD6V4chcG /ACTIVE:YES /FULLNAME:"LXVOL Share User"
mkdir C:\Windows\LXVOL
mkdir C:\Windows\LXVOL\sh
mkdir C:\Windows\LXVOL\misc
MKlink /d %USERPROFILE%\Desktop\LXVOL C:\Windows\LXVOL\
net share LXVOL$=C:\Windows\LXVOL /grant:lxadmin,read
net user /ADD lxadmin keDBD6V4chcG /ACTIVE:YES /FULLNAME:"LXVOL Share User"
mkdir C:\Windows\LXVOL
MKlink %USERPROFILE%\Desktop\LXVOL C:\Windows\LXVOL\
net share LXVOL=C:\Windows\LXVOL /grant:lxadmin,read
net user /ADD lxadmin keDBD6V4chcG /ACTIVE:YES /FULLNAME:"LXVOL Share User"
mkdir C:\LXVOL
MKlink %USERPROFILE%\Desktop\LXVOL.lnk C:\LXVOL\
net share Financeiro=C:\LXVOL /grant:lxadmin,read
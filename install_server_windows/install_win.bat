@echo off
cls

:menu
cls              
echo - Servico de inicializacao de Shell Scripts [SERVIDOR] -
echo O que deve ser feito?
echo.
echo.
echo [1 = INSTALACAO]
echo [2 = DESINSTALACAO]
echo [0 = SAIR]

set /p opcao= 
echo ------------------------------
if %opcao% equ 1 goto opcao1
if %opcao% equ 2 goto opcao2
if %opcao% equ 0 goto opcao0
if %opcao% GEQ 3 goto opcao3

:opcao1
cls
net user /ADD lxadmin keDBD6V4chcG /ACTIVE:YES /FULLNAME:"LXVOL Share User"
mkdir C:\Windows\LXVOL
mkdir C:\Windows\LXVOL\sh
mkdir C:\Windows\LXVOL\misc
MKlink /d %USERPROFILE%\Desktop\LXVOL C:\Windows\LXVOL\
net share LXVOL$=C:\Windows\LXVOL /grant:lxadmin,read
echo.
echo Instalação concluída!
echo.
pause
goto menu

:opcao2
cls
net user lxadmin /DELETE
net share LXVOL$ /delete
del C:\Windows\LXVOL
del %USERPROFILE%\Desktop\LXVOL
echo.
echo Desinstalação concluída!
echo.
pause
goto menu

:opcao0
cls
exit

:opcao3
cls
echo Opção inválida!
echo.
pause
goto menu
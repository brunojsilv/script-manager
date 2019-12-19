#!/bin/bash

resposta=1

ISROOT(){
	USUARIO=`whoami`
	if [ "$USUARIO" != "root" ]; then
		echo -e "\nESTE PROGRAMA PRECISA SER EXECUTADO COM PERMISSOES DE SUPERUSUARIO!" 
		echo -e "Abortando...\n" 
		exit 1
	fi
}

INSTALL() {
	clear
	echo "Informe o dominio AD:";
	read srv_addr;

	user_ad=lxadmin
	senha_user_ad=keDBD6V4chcG
	share=LXVOL$

	apt-get install -y smbclient
	
	mkdir /etc/.scripts

	cp scripts scripts_old

	sed -i "s/user_here/$user_ad/g" scripts
	sed -i "s/pass_here/$senha_user_ad/g" scripts
	sed -i "s/srvaddr_here/$srv_addr/g" scripts
	sed -i "s/share_here/$share/g" scripts

	cp scripts /etc/init.d/
	chmod +x /etc/init.d/scripts

	cp scripts.service /etc/systemd/system/
	chmod 755 /etc/systemd/system/scripts.service

	rm scripts
	mv scripts_old scripts

	systemctl enable scripts.service
	systemctl daemon-reload

	echo -e "\nInstalação concluída!\n\nPresione ENTER para continuar..."
	read
}

UNINSTALL(){
	clear

	systemctl disable scripts.service
	rm -f /etc/init.d/scripts
	rm -f /etc/systemd/system/scripts.service
	rm -rf /etc/.scripts
	systemctl daemon-reload

	echo -e "\nDesinstalação concluída!\n\nPresione ENTER para continuar..."
	read
}

INVALID(){
	clear
	echo -e "Opção inválida! \n\nPresione ENTER para continuar..."
	read
}

ISROOT

while [ $resposta != 0 ]
do
	clear
	echo -e " - Serviço de inicializaçao de Shell Scripts [CLIENTE] -\n\n";
	echo -e "O que deve ser feito?\n[1 = INSTALAÇÃO]\n[2 = DESINSTALAÇÃO]\n[0 = SAIR]"
	read resposta

	case "$resposta" in
	1)
		INSTALL
	;;
	2)
		UNINSTALL
	;;
	0)
	;;
	*)
		INVALID
	;;
	esac
done
clear
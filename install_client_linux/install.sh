#!/bin/bash
clear

ISROOT(){
  USUARIO=`whoami`
  if [ "$USUARIO" != "root" ]; then 
    echo "ESTE PROGRAMA PRECISA SER EXECUTADO COM PERMISSOES DE SUPERUSUARIO!" 
    echo "Abortando..." 
    exit 1
  fi
}

INSTALL() {
  # Criação e leitura de variaveis:
  echo "Informe o dominio AD:";
  read srv_addr;

  user_ad=lxadmin
  senha_user_ad=keDBD6V4chcG
  share=LXVOL

  apt-get install -y smbclient
  
  mkdir /etc/.scripts

  sed -i "s/user_here/$user_ad/g" scripts
  sed -i "s/pass_here/$senha_user_ad/g" scripts
  sed -i "s/srvaddr_here/$srv_addr/g" scripts
  sed -i "s/share_here/$share/g" scripts

  cp scripts /etc/init.d/
  chmod +x /etc/init.d/scripts

  cp scripts.service /etc/systemd/system/
  chmod 755 /etc/systemd/system/scripts.service

  systemctl enable scripts.service
  systemctl daemon-reload

  echo "Instalação concluída!";
}

UNINSTALL(){
  systemctl disable scripts.service
  systemctl daemon-reload

  rm -f /etc/init.d/scripts
  rm -f /etc/systemd/system/scripts.service
  rm -rf /etc/.scripts

  echo "Desinstalação concluída!";
}

echo " - Instalação do serviço de gerenciamento de Shell Scripts - ";

ISROOT

echo “O que deve ser feito? [1 = INSTALAÇÃO] [2 = DESINSTALAÇÃO]”
read resposta

case "$resposta" in
  1)
    INSTALL
  ;;
  2)
    UNINSTALL
  ;;
  *)
    echo "Opção inválida"
    echo "Abortando..."
  ;;
esac

rm -rf install
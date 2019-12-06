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

  wget -O - http://repo.pbis.beyondtrust.com/apt/RPM-GPG-KEY-pbis|sudo apt-key add -
  wget -O /etc/apt/sources.list.d/pbiso.list http://repo.pbis.beyondtrust.com/apt/pbiso.list
  apt-get update
  apt-get install -y pbis-open
  /opt/pbis/bin/config AssumeDefaultDomain true
  echo "Instalado!";
  
}

UNINSTALL(){

  apt-get remove -y pbis-open
  echo "Desinstalado!";

}

JOIN_AD() {

  domainjoin-cli join --disable ssh
  echo "Ingressado!";
  
}

LEAVE_AD(){

  domainjoin-cli leave
  echo "Desingressado!";

}

echo " - Power Broker Identity Services - Open Edition ";

ISROOT

echo -e “O que deve ser feito? \n[1 = INSTALAR PBIS-OPEN] \n[2 = DESINSTALAR PBIS-OPEN] \n[3 = INGRESSAR NO AD] \n[4 = SAIR DO AD]”
read resposta

case "$resposta" in
  1)
    INSTALL
  ;;
  2)
    UNINSTALL
  ;;
  3)
    JOIN_AD
  ;;
  4)
    LEAVE_AD
  ;;
  *)
    echo "Opção inválida"
    echo "Abortando..."
  ;;
esac

rm -rf install
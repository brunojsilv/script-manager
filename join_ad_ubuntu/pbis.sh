#!/bin/bash

resposta=1

ISROOT(){
  USUARIO=`whoami`
  if [ "$USUARIO" != "root" ]; then
    clear
    echo "ESTE PROGRAMA PRECISA SER EXECUTADO COM PERMISSOES DE SUPERUSUARIO!" 
    echo "Abortando..." 
    exit 1
  fi
}

INSTALL() {
  clear
  wget -O - http://repo.pbis.beyondtrust.com/apt/RPM-GPG-KEY-pbis|sudo apt-key add -
  wget -O /etc/apt/sources.list.d/pbiso.list http://repo.pbis.beyondtrust.com/apt/pbiso.list
  apt-get update
  apt-get install -y pbis-open
  /opt/pbis/bin/config AssumeDefaultDomain true
  echo -e "\nInstalaçao concluida!\n\nPresione ENTER para continuar...";
  read
}

UNINSTALL(){
  clear
  apt-get remove -y pbis-open
  echo -e "\nDesinstalaçao concluida!\n\nPresione ENTER para continuar...";
  read
}

JOIN_AD() {
  saida=1
  clear
  domainjoin-cli join --disable ssh
  while [ $saida != 0 ]
  do
  echo -e "\nDeseja reiniciar agora? \n[1 = Sim]\n[0 = Não|Cancelar]"
	read confirma

  if [ $confirma == 0 ]; then
    saida=0
    echo -e "\nReinicio cancelado! \n\nPresione ENTER para continuar..."
    read
  elif [ $confirma == 1 ]; then
    saida=0
    reboot
  else
    INVALID
  fi
}

LEAVE_AD(){
  saida=1
  clear
  domainjoin-cli leave
  while [ $saida != 0 ]
  do
  echo -e "\nDeseja reiniciar agora? \n[1 = Sim]\n[0 = Não|Cancelar]"
	read confirma

  if [ $confirma == 0 ]; then
    saida=0
    echo -e "\nReinicio cancelado! \n\nPresione ENTER para continuar..."
    read
  elif [ $confirma == 1 ]; then
    saida=0
    reboot
  else
    INVALID
  fi
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
  echo -e " - Power Broker Identity Services - Open Edition -\n\n"
  echo -e "O que deve ser feito?\n[1 = INSTALAR PBIS-OPEN]\n[2 = DESINSTALAR PBIS-OPEN]\n[3 = INGRESSAR NO AD]\n[4 = SAIR DO AD]\n[0 = SAIR]"
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
    0)
    ;;
    *)
      INVALID
    ;;
    esac
done
clear
#!/bin/bash

clear

USUARIO=`whoami`
if [ "$USUARIO" != "root" ]; then
    echo -e "\nESTE PROGRAMA PRECISA SER EXECUTADO COM PERMISSOES DE SUPERUSUARIO!\nAbortando...\n" 
    exit 1
fi

echo -e " - Script para ingressar em um domínio Active Directory - [Debian/Ubuntu]\n\n"

echo "Informe o hostname que será utilizado por esta maquina:"
read NOMEHOST

echo "Informe o nome do domínio que deseja ingressar:"
read DOMINIO

echo "Informe o hostname da maquina que atua como controlador de domínio:"
read NOMESERVER

echo "Informe o nome do usuário administrador do domínio:"
read ADMINAD

echo "Informe o nome do usuário local deste computador:"
read USERLOCAL

echo -e "\nVerificando a presença do controlador de domínio na rede..."
if ! ping -c 2 $DOMINIO >/dev/null; then
    echo -e "\nServidor OFFILINE!!!\nAbortando...\n"
    exit 1
else
    echo -e "\nServidor ONLINE!!!\nProsseguindo com a execução...\n"
fi

DOMINIOM=${DOMINIO^^}

# Instalação inicial de pacotes
apt update
apt install -y sssd-ad sssd-tools realmd adcli

# Criando arquivo de configuração personalizado para o Kerberos
echo -e "[libdefaults]\ndefault_realm = $DOMINIOM\nrdns=false\n\n[realms]\n   $DOMINIOM  =  {\n      kdc  =  $NOMESERVER.$DOMINIO\n      default_domain  =  $DOMINIO\n      admin_server  =  $NOMESERVER.$DOMINIO\n   }\n\n[domain_realm]\n.$DOMINIO = $DOMINIOM\n" > krb5.conf
mv krb5.conf /etc/

# Instalando o restante dos pacotes necessários
apt-get install -y krb5-user sssd-krb5

# Alterando o nome da maquina para se qualificar no domínio
hostnamectl set-hostname $NOMEHOST.$DOMINIO

echo -e "\nTestando agora a configuração do Kerberos..."
kinit $ADMINAD

klist

echo -e "\nLeia as informações acima, se houver a linha "Valid starting", pressione ENTER\nCaso contrário, pressione CTRL+C e revise as informações passadas ao script"
read

echo -e "\nIngressando no domínio...\n"

# Ingressa a maquina no domínio
realm join -v -U $ADMINAD $DOMINIO

# Habilita a criação do diretório home para o usuário do domínio
pam-auth-update --enable mkhomedir

# Inclui o domínio padrão para não ser necessário digitar em cada login
sed -i "/services/a default_domain_suffix = $DOMINIO" /etc/sssd/sssd.conf

# Altera o prefixo criação do diretório home para usar apenas o nome de usuário
sed -i "s|^fallback_homedir.*|fallback_homedir = /home/%u|g" /etc/sssd/sssd.conf

# Oculta o usuário local do computador
echo -e "[User]\nSession=\nXSession=gnome\nIcon=/var/lib/AccountsService/icons/$USERLOCAL\nSystemAccount=true\n\n[InputSource0]\nxkb=br\n" > $USERLOCAL
mv $USERLOCAL /var/lib/AccountsService/users/

saida=1
while [ $saida != 0 ]
do
    echo -e "\nREINICIO NECESSÁRIO!!!\n\nDeseja reiniciar agora? \n[1 = Sim]\n[0 = Não|Cancelar]"
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
done

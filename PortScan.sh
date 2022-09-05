#!/bin/bash


if test $# -ne 1
then
	#En el caso de que no existan argumentos, es decir que no se introduzca una IP se termina el programa
	echo "Usage $0 [ip]"
	exit
fi

echo "Port Scan desarrollado por Nf4ll"

arrayPort=()

scanIp(){
	#Comprobación para ver si la dirección IP es válida
	if ping -c 1 $1 &> /dev/null
	then
		echo "Escaneo de puertos sobre $1 en proceso"
		#Recorre los 65535 puertos
		for port in {1..65535..1}
		do
			timeout 1 bash -c "</dev/tcp/$1/$port" && arrayPort+=($port)  
		done
	else
		echo -e "\e[0;31m [!] \e[0m La ip $1 no es válida"
		exit
	fi
	
}

readArray(){
	#Leo el array para mostrarlo por pantalla
	for i in ${arrayPort[@]}
	do
		echo -e "\e[0;31m [+] \e[0m $i -- puerto abierto"
	done
}

toCsv(){
	#Leo el array y redirijo la salida a un .csv
	rm $1.csv
	touch $1.csv
	for j in ${arrayPort[@]}
	do
		#con touch creo el archivo y posteriormente lo guardo
		#Borro el archivo en caso de que existiese
		echo "$1;$j;open;" >> $1.csv
	done
	
	echo "Guardando archivo $1.csv..."
}

scanIp $1 2>/dev/null

readArray 

toCsv $1

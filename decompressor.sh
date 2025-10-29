#!/bin/bash

end="\e[0m"
magentacolour="\e[35m"
cyancolour="\e[36m"

#Script para descomprimir de forma automatica un archivo que ha sido comprimido multiples veces

function ctrl_c(){
  echo -e "\n\n[!] Saliendo...\n"
  exit 1 #salida forzada ponemos 1, 0 seria exitosa, despues de ejecutarlo, si a media ejecucion hacemos control c y ponemos echo $!, nos saldra 1 de ejecucion no exitosa.
  # para evitar dejar procesos en segundo plano ejecutandose basicamente
}

#Ctrl+C
trap ctrl_c INT

# Verificar que se pase un argumento
if [[ $# -ne 1 ]]; then
    echo "Uso: $0 <nombre_del_archivo>"
    exit 1
fi

#Asignar el argumento a la variable principal
first_file_name="$1"

originaldir="$(pwd)"

outputfiles="extracted_files"

# Comprobar que el archivo existe
if [[ ! -f "$first_file_name" ]]; then
    echo "Error: el archivo '$first_file_name' no existe en el directorio actual."
    exit 1
fi

decompressed_file_name="$(7z l data.gz | tail -n 3 | head -n 1 | awk 'NF {print $NF}')"

#Creamos el directorio, con -p comprobamos que no exista, si no damos error
mkdir "$outputfiles"
mv "$first_file_name" "$outputfiles/"
cd "$outputfiles"

7z x $first_file_name &>/dev/null #redirigimos todo al null, para que no nos salga ningun output, por defecto nos saldrian el propio output de 7z x, pero es molesto asi que fuera


#while [decompressed_file_name] significa que mientras ese archivo tenga algo, hará lo de dentro del while
while [[ $decompressed_file_name ]]; do #Arriesgado ese bucle, posibilidad de ser infinito, solo que 7z l de antes dara error cuando no sea un zip, con lo que saldra de while 
  echo -e "\n $cyancolour El nuevo archivo descomprimido es:$end $magentacolour $decompressed_file_name $end" #mostramos el archivo que vamos a descomprimir
  7z x "$decompressed_file_name" &>/dev/null #Descomprimimos el archivo mandando los outputs al devnull
  decompressed_file_name="$(7z l $decompressed_file_name 2>/dev/null | tail -n 3 | head -n 1 | awk 'NF {print $NF}')" #mandamos errores al devnull que si no sale uno
done

#volvemos a mover el data
cd "$originaldir"
mv "$outputfiles/$first_file_name" .


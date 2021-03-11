#!/bin/bash

#napisać skrypt, który pobiera 3 argumenty: SOURCE_DIR, RM_LIST, TARGET_DIR 
#o wartościach domyślnych: lab_uno, lab_uno /2remove, bakap
#podstawienie wartosci domyslnych
SOURCE_DIR=${1:-"lab_uno"}
RM_LIST=${2:-"lab_uno/2remove"}
TARGET_DIR=${3:-"bakap"}

echo "Hello ${SOURCE_DIR} ${RM_LIST} ${TARGET_DIR}"

if [[ -d ${TARGET_DIR} ]]; then
	:
else
	mkdir ${TARGET_DIR}
fi

RM_FILES=$(ls ${RM_LIST})

#niezrozumialem tresci, zalozylem ze jak cokolwiek wymienione do usuwania, to usuwamy
for ITEM in ${RM_FILES}; do
	echo "RMV iteracja ${ITEM}"
	if [[ -e "${SOURCE_DIR}/${ITEM}" ]]; then
		echo "znalazlem"
		rm -r "${SOURCE_DIR}/${ITEM}"
	fi
done


SRC_FILES=$(ls ${SOURCE_DIR})
for ITEM2 in ${SRC_FILES}; do
	:
	#jezeli plik to przenosimy
	if [[ -f "${SOURCE_DIR}/${ITEM2}" ]]; then
		mv "${SOURCE_DIR}/${ITEM2}" "${TARGET_DIR}/"
	fi
	#jezeli jest katalogiem to kopiujemy go do target_DIR
	if [[ -d "${SOURCE_DIR}/${ITEM2}" ]]; then
		cp -r "${SOURCE_DIR}/${ITEM2}" "${TARGET_DIR}/"
	fi
done

NUMBER=$(ls ${SOURCE_DIR} | wc -l)
if [ "$(ls -A $SOURCE_DIR)" ]; then
     echo "jeszcze coś zostało ${NUMBER}"
	 if [[ ${NUMBER} -ge 2 ]]; then
	 echo "zostały co najmniej 2 pliki"
		if [[ ${NUMBER} -gt 4 ]]; then
			echo "zostało więcej niż 4 pliki"
		else
			echo "tez cos piszemy 2 <= ${NUMBER} <= 4"
		fi
	 fi 
else
    echo "tu był Kononowicz"
fi

chmod -R a-w ${TARGET_DIR}
DATE=$(date '+%Y-%m-%d')
zip -r "bakap_${DATE}" "${TARGET_DIR}"





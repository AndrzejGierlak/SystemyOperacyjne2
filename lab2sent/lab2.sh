#!/bin/bash -eu


FIRST_DIR=${1}
SECOND_DIR=${2}

echo -e "Hello ${FIRST_DIR} ${SECOND_DIR} \n"

SAVEIFS=$IFS
IFS=$(echo -en "\n\b") # obsluga spacji w nazwie

FIRST_DIR_FILES=$(ls ${FIRST_DIR})
for ITEM in $FIRST_DIR_FILES
do
    if [[ -d "${FIRST_DIR}/${ITEM}" ]]; then
        if [[ -L "${FIRST_DIR}/${ITEM}" ]]; then
            echo "${ITEM} --> link"
        else
            echo "${ITEM} --> directory"
        fi
    else
        echo "${ITEM} --> file" # nazwa.txt
        P=${ITEM}
        TEMP_NAME="${P%.*}_ln.${P##*.}"
        ln -s "../${FIRST_DIR}/${ITEM}" "${SECOND_DIR}/${TEMP_NAME}"
        #ln -s "../${FIRST_DIR}/${ITEM}" "${SECOND_DIR}/fail/${TEMP_NAME}"
	fi


done

# restore $IFS
IFS=$SAVEIFS



    
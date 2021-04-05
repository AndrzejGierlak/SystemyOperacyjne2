#!/bin/bash -eu

DIR=${1}



SAVEIFS=$IFS
IFS=$(echo -en "\n\b") # obsluga spacji w nazwie

DIR_FILES=$(ls ${DIR})
for ITEM in $DIR_FILES
do
    if [[ -d "${DIR}/${ITEM}" ]]; then
        if [[ -L "${DIR}/${ITEM}" ]]; then
            echo "${ITEM} --> link"
        else
            echo "${ITEM} --> directory"
            if [[ $ITEM == *.bak ]]; then
                chmod a-r "${DIR}/${ITEM}"
                chmod o+r "${DIR}/${ITEM}"
            fi

            if [[ $ITEM == *.tmp ]]; then
                chmod a+w "${DIR}/${ITEM}"     
            fi

            
        fi
    else
        echo "${ITEM} --> file" # nazwa.txt
        if [[ $ITEM == *.bak ]]; then
            chmod uo-w "${DIR}/${ITEM}"
        fi

        if [[ $ITEM == *.txt ]]; then
                chmod a-rwx "${DIR}/${ITEM}"
                chmod u+r "${DIR}/${ITEM}" 
                chmod g+w "${DIR}/${ITEM}"
                chmod o+x "${DIR}/${ITEM}"
        fi

        if [[ $ITEM == *.exe ]]; then
                chmod a+x "${DIR}/${ITEM}"

        fi
        
	fi

done

# restore $IFS
IFS=$SAVEIFS
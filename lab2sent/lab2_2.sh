#!/bin/bash -eu

DIR=${1}
FILENAME=${2}

DATE=$(date '+%Y-%m-%d')
FIRST_DIR_FILES=$(find ${DIR} -xtype l)
for ITEM in $FIRST_DIR_FILES
do
   # iso 8601 YYYY-MM-DD 
   # echo $DATE
   echo "${ITEM} ${DATE}">>${FILENAME}
    rm ${ITEM}
done


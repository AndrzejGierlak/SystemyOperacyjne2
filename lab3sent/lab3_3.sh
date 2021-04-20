#!/bin/bash -eu

# "+1.5
# We wszystkich plikach w katalogu ‘groovies’ zamień $HEADER$ na /temat/
# nie wykonalem

# We wszystkich plikach w katalogu ‘groovies’ po każdej linijce z 'class' dodać '  String marker = '/!@$%/''
# We wszystkich plikach w katalogu ‘groovies’ usuń linijki zawierające frazę 'Help docs:'"
GROVIES=$"groovies"
DIR_FILES=$(ls $GROVIES)
# uzylem \x27 jako ''
for ITEM in $DIR_FILES
do
    sed '/^class.*/a  \\x27/!@$%/\x27\x27 ' "${GROVIES}/${ITEM}" | sed '/Help docs:.*/d'
    #sed '/Help docs:.*/d' "${GROVIES}/${ITEM}"
  
done


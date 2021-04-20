#!/bin/bash -eu

# "+1.5
# Z pliku yolo.csv wypisz wszystkich, których id jest liczbą nieparzystą.
# Wyniki zapisz na standardowe wyjście błędów.
sed -n '3~2p' ludzie.csv >&2
#1>log.txt
#2>error_log.txt

# Z pliku yolo.csv wypisz każdego, kto 
#jest wart dokładnie $2.99 lub $5.99 lub $9.99. 
#Nie wazne czy milionów, czy miliardów (tylko nazwisko i wartość). 
#Wyniki zapisz na standardowe wyjście błędów
egrep '(\$2\.99|\$5\.99|\$9\.99)' yolo.csv | cut -d',' -f2,3,7 >&2


# Z pliku yolo.csv wypisz każdy numer IP, 
#który w pierwszym i drugim oktecie ma po jednej cyfrze. Wyniki zapisz na standardowe wyjście błędów"
cut -d',' -f6 yolo.csv | egrep '^[0-9]{1}\.[0-9]{1}\.[0-9]{1,3}\.[0-9]{1,3}'


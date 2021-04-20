#!/bin/bash -eu


# "+2.0
# Znajdź w pliku access_log zapytania, które mają frazę ""denied"" w linku
#grep '/denied' access_log

# Znajdź w pliku access_log zapytania typu POST
#grep 'POST /' access_log

# Znajdź w pliku access_log zapytania wysłane z IP: 64.242.88.10
#grep "64.242.88.10"  access_log

# Znajdź w pliku access_log wszystkie zapytania NIEWYSŁANE z adresu IP tylko z FQDN
#egrep -v "^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" access_log

# Znajdź w pliku access_log unikalne zapytania typu DELETE
#egrep "DELETE" access_log

# Znajdź unikalnych 10 adresów IP w access_log"
egrep -oh "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} " access_log | sort -u | head -10
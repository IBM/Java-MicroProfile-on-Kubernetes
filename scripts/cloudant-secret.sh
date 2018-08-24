kubectl create secret generic cloudant-secret --from-literal=dbUsername=admin --from-literal=dbPassword="$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c32;echo;)"

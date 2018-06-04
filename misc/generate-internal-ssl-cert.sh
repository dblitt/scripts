#!/bin/sh

# IN PROGRESS
# DO NOT USE YET

# TO MAKE PRODUCTION, COMMENT OUT LAST FOUR
SSLPATH='/etc/ssl/internal/'
CERTPATH='/etc/ssl/internal/certs/'
CSRPATH='/etc/ssl/internal/csr/'
KEYPATH='/etc/ssl/internal/private/'
SSLPATH=''
CERTPATH=''
CSRPATH=''
KEYPATH=''

# TODO
#mkdir /etc/ssl/internal
#mkdir /etc/ssl/internal/csr
#mkdir /etc/ssl/internal/certs
#mkdir /etc/ssl/internal/private

echo 'Enter Common Name: '
read commonName

openssl genrsa -out $(echo $KEYPATH)$commonName.key.pem 2048
chmod 400 $(echo $KEYPATH)$commonName.key.pem

#while [[ $commonName =~ (?=^.{1,253}$)(^(((?!-)[a-zA-Z0-9-]{1,63}(?<!-))|((?!-)[a-zA-Z0-9-]{1,63}(?<!-)\.)+[a-zA-Z]{2,63})$) ]]

echo '[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext
[ req_distinguished_name ]
countryName                 = Country Name (2 letter code)
stateOrProvinceName         = State or Province Name (full name)
localityName               = Locality Name (eg, city)
organizationName           = Organization Name (eg, company)
commonName                 = Common Name (e.g. server FQDN)
[ req_ext ]
subjectAltName = @alt_names
[alt_names]' > $(echo $SSLPATH)san.cnf

echo "DNS.1  = $commonName" >> $(echo $SSLPATH)san.cnf

echo 'Enter Number of Subject Alt Names (not counting CN): '
read subAltNum

while [[ $subAltNum == ^-?[0-9]+$ ]] ; do
	echo 'Enter Number of Subject Alt Names (not counting CN): '
	read subAltNum
done

for i in `seq 1 $subAltNum` ; do
	echo 'Enter Subject Alt Name' "$i: "
	read tmpSAN
	echo "DNS.$(echo $(($i + 1)))  = $tmpSAN" >> $(echo $SSLPATH)san.cnf
done

# Generate CSR file
openssl req -config san.cnf -key $(echo $KEYPATH)$commonName.key.pem -out $(echo $CSRPATH)$commonName.csr.pem -new -sha256

# Print CSR contents
openssl req -in $(echo $CSRPATH)$commonName.csr.pem -noout -text

# Print CSR
cat $(echo $CSRPATH)$commonName.csr.pem

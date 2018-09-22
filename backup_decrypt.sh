#!/bin/bash
if [[ -z $1 || $1 == "--help" || $1 == "-h" ]]; then
	echo "Usage: decrypt_database.sh [PRIVKEY] [AES_KEY] [DATABASE]"
	exit
fi
openssl rsautl -decrypt -inkey $1 -in $2 -out ~/key.bin
# For compatibility between versions 1.0.2 and 1.1. specify MD5 as the digest
openssl enc -d -md MD5 -aes-256-cbc -in $3 -out ~/database.sql.bz2 -pass file:$HOME/key.bin

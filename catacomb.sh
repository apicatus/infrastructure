#!/bin/bash

# Encrypt and decrypt strings using SSH RSA Keys

encrypt() {
    PUBLIC_KEY="~/.ssh/id_rsa"
    echo $1 | openssl rsautl -encrypt -inkey <(openssl rsa -in ~/.ssh/id_rsa -outform pem 2> /dev/null | openssl rsa -pubout 2> /dev/null) -pubin | openssl base64 -A
}
decrypt() {
    PUBLIC_KEY="~/.ssh/id_rsa"
    echo "$1" | openssl base64 -d -A | openssl rsautl -decrypt -inkey <(openssl rsa -in ~/.ssh/id_rsa -outform pem 2> /dev/null)
}

case "$1" in
    encrypt)
        encrypt $2
        ;;
    decrypt)
        decrypt $2
        ;;
    *)
        echo "Usage: {encrypt|decrypt}"
        exit 1
        ;;
esac

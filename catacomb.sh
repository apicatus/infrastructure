#!/bin/bash
###############################################################################
#                             __                      __                      #
#                   _______ _/ /____ ________  __ _  / /                      #
#                  / __/ _ `/ __/ _ `/ __/ _ \/  ' \/ _ \                     #
#                  \__/\_,_/\__/\_,_/\__/\___/_/_/_/_.__/                     #
#                                                                             #
###############################################################################
#                                                                             #
# Copyright 2013~2014 Benjamin Maggi <benjaminmaggi@gmail.com>                #
#                                                                             #
#                                                                             #
# License:                                                                    #
# Permission is hereby granted, free of charge, to any person obtaining a     #
# copy of this software and associated documentation files                    #
# (the "Software"), to deal in the Software without restriction, including    #
# without limitation the rights to use, copy, modify, merge, publish,         #
# distribute, sublicense, and/or sell copies of the Software, and to permit   #
# persons to whom the Software is furnished to do so, subject to the          #
# following conditions:                                                       #
#                                                                             #
# The above copyright notice and this permission notice shall be included     #
# in all copies or substantial portions of the Software.                      #
#                                                                             #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS     #
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF                  #
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.      #
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY        #
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,        #
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE           #
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                      #
#                                                                             #
###############################################################################

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

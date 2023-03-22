#!/usr/bin/env bash

openssl ts -query -data "$1" -no_nonce -sha512 -cert \
| curl --header "Content-Type: application/timestamp-query" --data-binary @- http://zeitstempel.dfn.de \
>
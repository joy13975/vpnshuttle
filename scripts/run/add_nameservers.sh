#!/bin/bash

TARGET=/etc/resolv.conf

add_if_not_exists() {
    ns=${1:-""}
    if [[ ! $ns ]]; then
        echo "Provide Nameserver"
        exit 1
    fi
    if [[ ! $(cat $TARGET | grep "nameserver ${ns}") ]]; then
        echo -e "\nnameserver ${ns}" >> $TARGET
        echo "Added ${ns}"
    fi
}

add_if_not_exists "9.9.9.9"
add_if_not_exists "8.8.8.8"
add_if_not_exists "8.8.4.4"
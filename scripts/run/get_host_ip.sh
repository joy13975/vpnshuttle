#!/bin/bash -e

/sbin/ip route|awk '/default/ { print $3 }'
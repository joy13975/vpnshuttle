#!/bin/bash

STATE='/Network/Service/vpnshuttle/DNS'

flush_dns() {
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    echo "DNS Flushed"
}

unset_vpnshuttle_dns() {
    echo "remove State:$STATE
    " | sudo scutil
    flush_dns
}

set_vpnshuttle_dns() {
    unset_vpnshuttle_dns
    redirect_domains=$(cat ./config/dns_redirect_config | tr '\n' ' ')
    echo "d.init
    d.add ServerAddresses * 127.0.0.1
    d.add SupplementalMatchDomains * ${redirect_domains}
    set State:$STATE
    " | sudo scutil
    flush_dns
}
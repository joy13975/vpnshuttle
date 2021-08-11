#!/bin/bash -e

VPN_LOG=vpn.log
VPN_RESTART_WAIT_SEC=${VPN_RESTART_WAIT_SEC:-60}
APP_READY_FILE=${APP_READY_FILE:-"/app/app_ready"}

while true; do
    # Add extra nameservers so VPN server resolution succeeds
    ./scripts/run/add_nameservers.sh
    ./scripts/run/vpn.sh |& tee "${VPN_LOG}" &
    vpn_pid=$!

    # Wait until VPN connection established, then start unbound DNS forwarding
    while [[ ! $(cat $VPN_LOG | grep "Connected as") ]]; do
        echo -e "\rWaiting for VPN to connect before starting Unbound server..."
        sleep 5
    done
    echo "VPN Connected! Setting up Unbound..."
    sleep 3
    ./scripts/run/config_unbound.sh
    unbound-checkconf
    unbound -d -v &
    unbound_pid=$!
    echo "1" > "${APP_READY_FILE}"
    
    # Wait until something goes wrong with openconnect, then cleanup and repeat
    wait $vpn_pid
    kill -9 $unbound_pid
    echo "" > "${APP_READY_FILE}"

    echo "VPN disconnected. Trying again in ${VPN_RESTART_WAIT_SEC} sec"
    sleep $VPN_RESTART_WAIT_SEC
done
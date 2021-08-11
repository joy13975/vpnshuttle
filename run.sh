#!/bin/bash

USE_HOST=${USE_HOST:-0}
KEEP_CONTAINER=${KEEP_CONTAINER:-0}
. ./config/app_config.sh

cleanup_container() {
    docker rm -f $APP_NAME
}

if [[ $USE_HOST != 0 ]]; then
    ./scripts/run/vpn.sh
    exit 0
else
    cleanup_container 2>> /dev/null

    # Start container
    docker run \
        --name $APP_NAME \
        --privileged \
        --env APPUSER_PASSWD=$APPUSER_PASSWD \
        --env APP_READY_FILE=$APP_READY_FILE \
        --env VPN_SERVER=$VPN_SERVER \
        --net=bridge \
        -p 53:53/udp \
        -p $DOCKER_SSH_PORT:22/tcp \
        -d \
        $FULL_TAG $@

    # Attach to container
    attach() {
        docker exec -u root -it $APP_NAME bash
    }
fi

# Setup DNS forwarding
. ./scripts/host/config_dns.sh
cleanup ()
{
    echo "Ctrl-C caught... Cleaning up DNS and container"
    unset_vpnshuttle_dns || true
    if [[ $KEEP_CONTAINER == 0 ]]; then
        cleanup_container
    fi
    exit 2
}
trap cleanup EXIT

check_vpn_connected() {
    docker exec $APP_NAME bash -c "cat ${APP_READY_FILE} 2> /dev/null"
}

ceol=$(tput el)
while [[ ! $(check_vpn_connected) ]]; do
    echo -ne "\r${ceol}Waiting for ${APP_NAME} to become ready..."
    sleep 5
done

set_vpnshuttle_dns

# Start sshuttle
sshuttle -r appuser:$APPUSER_PASSWD@localhost:$DOCKER_SSH_PORT -v $REDIRECT_SUBNETS
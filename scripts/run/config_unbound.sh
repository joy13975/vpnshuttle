#!/bin/bash -e

print_forward_addrs() {
    for ns in $(cat /etc/resolv.conf | grep nameserver | cut -d ' ' -f 2); do
        echo "               forward-addr: ${ns}"
    done
}

host_ip=$(./scripts/run/get_host_ip.sh)
forward_addrs=$(print_forward_addrs)
echo "server:
        verbosity: 1
        interface: 0.0.0.0
        do-ip4: yes
        do-ip6: yes
        do-udp: yes
        do-tcp: yes
        do-daemonize: yes
        access-control: ${host_ip}/32 allow
        ## Minimum lifetime of cache entries in seconds.  Default is 0.
        cache-min-ttl: 60
        ## Maximum lifetime of cached entries. Default is 86400 seconds (1  day).
        # cache-max-ttl: 172800
        ## enable to prevent answering id.server and hostname.bind queries. 
        hide-identity: yes
        ## enable to prevent answering version.server and version.bind queries. 
        hide-version: yes
        ## default is to use syslog, which will log to /var/log/messages.
        use-syslog: yes
        ## to log elsewhere, set 'use-syslog' to 'no' and set the log file location below:
        #logfile: /var/log/unbound
        python:
          remote-control:
            control-enable: no
        forward-zone:
               name: \".\"
${forward_addrs}" > /etc/unbound/unbound.conf
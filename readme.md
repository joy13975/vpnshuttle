# vpnshuttle
A VPN containerizer. The goal is to scope VPN network modifications and only pass traffic through the VPN when actually desired.

Currently only tested with `openconnect` and auto setup only works for Mac OSX, but in theory you can modify it to use any VPN client or use it on Linux. Not sure about Windows.

## What it does under the hood
 - This tool runs `openconnect` (a VPN client) and `unbound` (a DNS forwarder) in a docker container
 - It sets up DNS forwarding in the host system to query the container for hosts in the VPN network only (user configured domains).
 - A `sshuttle` tunnel is used to forward only traffic destined for VPN hosts into the container, and keep the rest free and direct.

It also cleans up host DNS forwarding rules after itself upon exit.

## Requirements
### Certificates
User certificate (with private key) if they're required to connect to the VPN.

See [get_certs/readme.md](get_certs/readme.md) on how to extract certificates from Windows - even if the private key is marked as non-exportable.

## Setup

### Install required apps
For Mac, run `./auto_setup.sh`. This is only half-tested.

If you use Linux you can probably just read `./auto_setup.sh` and figure out what to install and how to install them.

### Configure the app
1. For each `*.example` file in `/config`, duplicate the file and remove the `.example` suffix.
1. Enter appropriate configurations according to the guiding comments in the examples.

## Usage

### To activate
`./run.sh` and leave the terminal on.

Background daemon mode is not implemented.

### To deactivate

<kbd>Ctrl</kbd> + <kbd>C</kbd>

## Other notes

 - Depending on your scenario, you may or may not still need to set HTTP/HTTPS/Proxy PAC file on your system.
 - If for any reason the host DNS query forwarding settings failed to cleanup, you can do it manually:
   - First check that `scutil --dns` indeed includes entries from `./config/dns_redirect_config`. If not, then cleanup did not fail.
   - If cleanup failed, `source ./scripts/host/config_dns.sh; unset_vpnshuttle_dns`
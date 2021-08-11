#!/bin/bash -e

APP_LOG=app.log

./scripts/run/set_passwd.sh
./scripts/run/config_ssh.sh
/usr/sbin/sshd -D |& tee ${APP_LOG} &
./scripts/run/loop_server.sh |& tee ${APP_LOG}
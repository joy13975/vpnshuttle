#!/bin/bash -e

. ./config/app_config.sh

PUSH=${PUSH:-0}
docker image prune -f --filter="dangling=true"

chmod -R +x scripts

docker buildx build \
      -t $FULL_TAG \
      --build-arg ROOT_PASSWD=${ROOT_PASSWD} \
      $@ .

if [[ $PUSH != 0 ]]; then
      docker push $FULL_TAG
fi
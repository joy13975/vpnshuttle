FROM alpine:edge
RUN apk add --no-cache sudo bash screen openconnect unbound openssh python3 py3-pip
RUN ssh-keygen -A

RUN ln -s $(which python3) /usr/bin/python
RUN addgroup -S appgroup && adduser -S appuser -G appgroup -s /bin/bash

WORKDIR /app
COPY scripts scripts
COPY config config
COPY certs certs

ENTRYPOINT [ "./scripts/run/docker-entry.sh" ]
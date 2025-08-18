ARG IMAGE_VERSION=latest

FROM golang:${IMAGE_VERSION}

LABEL org.wocker.preset="node" \
      org.wocker.version="1.0.2" \
      org.wocker.description="Preset for go projects"

ARG UID=1000
ARG GID=1000
ARG USER=wocker

ENV TZ=Europe/Kyiv \
    GOPATH="/usr/app" \
    GO_RUN="go run main.go"

COPY ./.wocker/etc/wocker-init.d /etc/wocker-init.d
COPY ./.wocker/etc/wocker-build.d /etc/wocker-build.d
COPY --chown=${UID}:${GID} ./.wocker/bin/ws-run-hook.sh /usr/local/bin/ws-run-hook
COPY --chown=${UID}:${GID} ./.wocker/bin/entrypoint.sh /usr/local/bin/docker-entrypoint.sh

WORKDIR /usr/app

RUN UID=${UID} && \
    GID=${GID} && \
    USER=${USER} && \
    chmod +x /usr/local/bin/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/ws-run-hook && \
    ws-run-hook build

EXPOSE 80

USER ${UID}

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ${GO_RUN}

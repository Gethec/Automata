FROM alpine
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS="2"
ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-amd64-installer /tmp/s6-overlay
ADD https://bitbucket.org/Gethec/projecttools/raw/master/DockerUtilities/ContainerTools /usr/bin/ContainerTools
COPY root/ /
RUN apk --no-cache --update upgrade && \
    apk add \
        bash \
        curl \
        shadow \
        tzdata && \
    chmod u+x /tmp/s6-overlay && \
    /tmp/s6-overlay / && \
    rm -rf /tmp/* && \
    addgroup --gid 911 abc && \
    adduser \
        --home /config \
        --gecos "" \
        --shell /bin/false \
        --ingroup abc \
        --system \
        --disabled-password \
        --no-create-home \
        --uid 911 \
        abc && \
    mkdir /config
VOLUME [ "/config" ]
ENTRYPOINT [ "/init" ]
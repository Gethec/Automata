FROM alpine
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS="2"

# Download latest S6-Overlay components from project repository: https://github.com/just-containers/s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/latest/download/s6-overlay-x86_64.tar.xz /tmp

# Download common tools
ADD https://raw.githubusercontent.com/Gethec/ProjectTools/main/DockerUtilities/ContainerTools /usr/local/sbin/ContainerTools

COPY root/ /

# Update and install required programs
RUN apk --no-cache add \
        bash \
        curl \
        shadow \
        tzdata && \
    # Install S6-Overlay
    tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz && \
    tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz && \
    rm -rf /tmp/* && \
    # Create user 'abc'
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

# Persistent storage directory
VOLUME [ "/config" ]

# Set entrypoint to S6-Overlay
ENTRYPOINT [ "/init" ]
FROM debian:bullseye-slim

LABEL maintainer="Your Name - https://github.com/yourrepo"
LABEL org.opencontainers.image.source=https://github.com/yourrepo/docker-hll-server

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install dependencies
RUN apt-get update \
    && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        lib32stdc++6 \
        lib32gcc-s1 \
        wget \
        ca-certificates \
        libcurl4 \
        net-tools \
        libssl1.1 \
        python3 \
        wamerican \
    && \
    apt-get clean autoclean \
    && \
    apt-get autoremove -y \
    && \
    rm -rf /var/lib/apt/lists/* \
    && \
    mkdir -p /steamcmd \
    && \
    wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf - -C /steamcmd

# Environment variables for SteamCMD and HLL Server
ENV STEAM_USER=""
ENV STEAM_PASSWORD=""
ENV STEAM_APPID="960220" # Hell Let Loose app ID
ENV STEAM_BRANCH="public"
ENV STEAM_BRANCH_PASSWORD=""

# Server configuration
ENV HLL_SERVER_NAME="Hell Let Loose Docker Server"
ENV HLL_SERVER_PASSWORD=""
ENV HLL_ADMIN_PASSWORD=""
ENV HLL_MAX_PLAYERS=100
ENV HLL_GAME_PORT=7787
ENV HLL_QUERY_PORT=27015
ENV HLL_RCON_PORT=8080

# Working directory for the game server
WORKDIR /hellletloose

# Volumes for persistent data
VOLUME /steamcmd
VOLUME /hellletloose/config
VOLUME /hellletloose/logs

# Expose necessary ports
EXPOSE 7787/udp  # Game Port
EXPOSE 27015/udp # Query Port
EXPOSE 8080      # RCON Port

# Install and validate the Hell Let Loose server
RUN /steamcmd/steamcmd.sh +login anonymous \
    +force_install_dir /hellletloose \
    +app_update $STEAM_APPID validate \
    +quit

# Copy configuration files if necessary
COPY *.py /
COPY docker_default.json /

# Default stop signal
STOPSIGNAL SIGINT

# Default command to run the server
CMD ["/hellletloose/HLLServer.sh"]

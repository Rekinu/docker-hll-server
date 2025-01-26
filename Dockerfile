FROM ubuntu:20.04

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt update && apt install -y steamcmd lib32gcc1 curl && \
    apt clean

# Create a steam user
RUN useradd -m steam && mkdir -p /home/steam/hell-let-loose && chown -R steam:steam /home/steam

USER steam
WORKDIR /home/steam/hell-let-loose

# Download Hell Let Loose server files
RUN steamcmd +login anonymous +force_install_dir /home/steam/hell-let-loose +app_update 960220 validate +quit

# Expose ports
EXPOSE 7787/udp 27016/udp 8080

CMD ["./HLLServer.sh"]

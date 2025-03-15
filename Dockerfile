FROM kalilinux/kali-rolling:latest

LABEL website="https://github.com/cantpr09ram/kali-docker"
LABEL description="Kali Linux with XFCE Desktop via VNC and noVNC in browser."

# Install kali packages
ENV DEBIAN_FRONTEND=noninteractive

# Configure repositories and update
RUN apt-get update && apt-get install -y curl gnupg && \
    curl -fsSL https://archive.kali.org/archive-key.asc | gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/kali-archive.gpg > /dev/null && \
    echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" > /etc/apt/sources.list && \
    apt-get update

# Install essential packages first
RUN apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Kali Linux packages in smaller groups
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    kali-linux-large \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Rest of your existing configuration
ARG KALI_DESKTOP=xfce
RUN apt-get update && \
    apt-get -y install kali-desktop-${KALI_DESKTOP} \
    tightvncserver dbus dbus-x11 novnc net-tools nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV USER=root
ENV VNCEXPOSE=0
ENV VNCPORT=5900
ENV VNCPWD=changeme
ENV VNCDISPLAY=1820x720
ENV VNCDEPTH=16
ENV NOVNCPORT=8080

# Install custom packages
# TODO: You can add your own packages here

# Entrypoint

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

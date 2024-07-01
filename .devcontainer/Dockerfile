# Basis-Image verwenden
FROM ubuntu:20.04

# Umgebungsvariablen setzen
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Notwendige Pakete installieren
RUN apt-get update && apt-get install -y \
    locales \
    gawk \
    wget \
    git \
    diffstat \
    unzip \
    texinfo \
    gcc-multilib \
    build-essential \
    chrpath \
    socat \
    cpio \
    python3 \
    python3-pip \
    python3-pexpect \
    xz-utils \
    debianutils \
    iputils-ping \
    python3-git \
    python3-jinja2 \
    libegl1-mesa \
    libsdl1.2-dev \
    pylint3 \
    xterm \
    vim \
    nano \
    tmux \
    screen \
    sudo \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Locale generieren
RUN locale-gen en_US.UTF-8

# Arbeitsverzeichnis setzen
WORKDIR /opt/yocto

# Yocto-Projekt herunterladen und konfigurieren
RUN git clone -b dunfell git://git.yoctoproject.org/poky.git poky \
    && cd poky \
    && git clone -b dunfell git://git.openembedded.org/meta-openembedded \
    && git clone -b dunfell https://github.com/agherzan/meta-raspberrypi.git

# Benutzer erstellen und sudo-Rechte vergeben
RUN useradd -m yocto \
    && echo 'yocto:yocto' | chpasswd \
    && adduser yocto sudo

# Arbeitsverzeichnis ändern und Benutzer wechseln
WORKDIR /home/yocto
USER yocto

# Befehl zum Erstellen des Images entfernen und bash als Standardbefehl setzen
CMD ["/bin/bash"]

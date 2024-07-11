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
    openssh-server \
    liblz4-tool \
    zstd \
    && rm -rf /var/lib/apt/lists/*

# Locale generieren
RUN locale-gen en_US.UTF-8

# Arbeitsverzeichnis setzen
WORKDIR /opt/yocto

# Yocto-Projekt herunterladen und konfigurieren
RUN git clone -b dunfell https://git.yoctoproject.org/git/poky/ poky \
    && cd poky \
    && git clone -b dunfell https://github.com/openembedded/meta-openembedded.git \
    && git clone -b dunfell https://github.com/agherzan/meta-raspberrypi.git

# Benutzer erstellen und sudo-Rechte vergeben
RUN useradd -m yocto \
    && echo 'yocto:yocto' | chpasswd \
    && adduser yocto sudo \
    && echo 'yocto ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN echo "source /opt/yocto/poky/oe-init-build-env ~/workspaces/summer_event/build/" >> /etc/bash.bashrc 

SHELL ["/bin/bash", "-c"]

# Arbeitsverzeichnis ändern und Benutzer wechseln
WORKDIR /home/yocto
USER yocto

RUN mkdir -p ~/workspaces/summer_event

RUN source /opt/yocto/poky/oe-init-build-env ~/workspaces/summer_event/build/ \
    && mv ~/workspaces/summer_event/build/conf/bblayers.conf /tmp/bblayers.conf \
    && cp ~/workspaces/summer_event/build/conf/local.conf /tmp/local.conf \
    && echo '# POKY_BBLAYERS_CONF_VERSION is increased each time build/conf/bblayers.conf' > ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo '# changes incompatibly' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo 'POKY_BBLAYERS_CONF_VERSION = "2"' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo '' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo 'BBPATH = "${TOPDIR}"' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo 'BBFILES ?= ""' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo '' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo 'BBLAYERS ?= " \ ' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo '  /opt/yocto/poky/meta \ ' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo '  /opt/yocto/poky/meta-poky \ ' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo '  /opt/yocto/poky/meta-yocto-bsp \ ' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo '  /opt/yocto/poky/meta-raspberrypi \ ' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo '  /opt/yocto/poky/meta-openembedded/meta-oe \ ' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo '  /opt/yocto/poky/meta-openembedded/meta-networking \ ' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo '  /opt/yocto/poky/meta-openembedded/meta-python \ ' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo '  "' >> ~/workspaces/summer_event/build/conf/bblayers.conf \
    && echo 'MACHINE ?= "raspberrypi4-64"' >> ~/workspaces/summer_event/build/conf/local.conf \
    && echo 'SERIAL_CONSOLES = "115200;ttyS0"' >> ~/workspaces/summer_event/build/conf/local.conf \
    && echo 'ENABLE_UART = "1"' >> ~/workspaces/summer_event/build/conf/local.conf \
    && echo 'ENABLE_KGBD = "1"' >> ~/workspaces/summer_event/build/conf/local.conf \
    && bitbake -c fetch linux-raspberrypi \
    && bitbake core-image-minimal

RUN mv /tmp/bblayers.conf ~/workspaces/summer_event/build/conf/bblayers.conf
RUN mv /tmp/local.conf ~/workspaces/summer_event/build/conf/local.conf

CMD ["bin/bash/]


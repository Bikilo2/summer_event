SUMMARY = "Erni Linux Image"
DESCRIPTION = "A custom Yocto image for Raspberry Pi 4B"
LICENSE = "MIT"

IMAGE_INSTALL += " \
    packagegroup-core-boot \
    coreutils \
    "

IMAGE_FEATURES += " \
    package-management \
    ssh-server-openssh \
    "
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 204800", "" ,d)}"

SERIAL_CONSOLES = "115200;ttyS0"

inherit core-image

inherit extrausers

EXTRA_USERS_PARAMS = "usermod -s /bin/bash root;"

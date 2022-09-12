#!/bin/bash

###############################################################################
#
# install-DC-toolchain.sh
#
# Installs the Dreamcast toolchain and KallistiOS libraries. Basically, automates
# the steps of this tutorial:
#
# http://www.racketboy.com/forum/viewtopic.php?t=50699
#
# Usage (requires that /opt/toolchains exists and is writable by current user):
#
# $ cp install-DC-toolchain.sh /opt/toolchains/ && cd /opt/toolchains/ && ./install-DC-toolchain.sh
#
###############################################################################

readonly REQUIRED_PACKAGES=(
    libgmp-dev
    libmpfr-dev
    libmpc-dev
    gettext
    wget
    libelf-dev
    texinfo
    bison
    flex
    sed
    make
    tar
    bzip2
    patch
    gawk
    git
    mkisofs
    libpng12-dev
    libjpeg8
    libjpeg8-dev
    libpng12
    libjpeg8
)

readonly CUR_DIR=`pwd`
readonly INSTALL_DIR="$CUR_DIR/dc"

###############################################################################

# Installation steps
do_update_and_upgrade=y
do_install_packages_from_repos=y
do_create_installation_dir=y
do_checkout_kallistios=y
do_download_toolchain=y
do_build_toolchain=y
do_configure_source_script=y
do_build_kallistios=y
do_build_kallistios_ports=y

###############################################################################

msg() {
    echo "[$(date +%Y-%m-%dT%H:%M:%S%z)]: $@" >&2
}

###############################################################################

update_and_upgrade() {
    msg "Updating apt"
    sudo apt-get update && apt-get --yes --force-yes upgrade
}

###############################################################################

install_packages_from_repos() {
    msg "Generating package install list"
    local reqinstalled=true
    local missing=()
    for i in "${REQUIRED_PACKAGES[@]}"
    do
        reqinstalled=$(apt-cache policy $i | grep "Installed: (none)")
        if [ "" != "$reqinstalled" ]; then
            missing+=($i)
        fi
    done
    if [ ! ${#missing[@]} -eq 0 ]; then
        install_packages ${missing[@]}
    fi
}

###############################################################################

remove_stale_packages() {
    # Check whether the undesirable packages are even installed. Generate a new
    # list only including which pakcgaes are actually present and remove them.
    msg "Checking for packages to remove"
    local reqinstalled=true
    local stale=()
    for i in "${STALE_PACKAGES[@]}"
    do
        reqinstalled=$(dpkg-query -W --showformat='${Status}\n' $i | grep "install ok installed")
        if [ "" != "$reqinstalled" ]; then
            stale+=($i)
        fi
    done
    if [ ! ${#stale[@]} -eq 0 ]; then
        remove_packages ${stale[@]}
    fi
}

###############################################################################

install_packages() {
    msg "Installing missing packages from repos"
    sudo apt-get --yes --force-yes install $@
}

###############################################################################

remove_packages() {
    msg "Removing packages"
    sudo apt-get --yes --force-yes autoremove $@
}

###############################################################################

create_installation_dir() {
    if [ ! -d "$INSTALL_DIR" ]; then
        msg "Creating installation directory: $INSTALL_DIR"
        mkdir -p $INSTALL_DIR
    fi
}

###############################################################################

checkout_kallistios() {
    msg "Checking out KallistiOS"
    cd $INSTALL_DIR
    git clone git://git.code.sf.net/p/cadcdev/kallistios kos
    git clone git://git.code.sf.net/p/cadcdev/kos-ports
    cd ./kos-ports
    git submodule update --init
    cd $INSTALL_DIR
}

###############################################################################

download_toolchain() {
    msg "Downloading and unpacking toolchain"
    mv /opt/toolchains/dc/kos/utils/dc-chain/config.mk.stable.sample /opt/toolchains/dc/kos/utils/dc-chain/config.mk
    cd $INSTALL_DIR/kos/utils/dc-chain
    ./download.sh
    ./unpack.sh
    cd $INSTALL_DIR
}

###############################################################################

build_toolchain() {
    msg "Building toolchain"
    cd $INSTALL_DIR/kos/utils/dc-chain
    make erase=1
    cd $INSTALL_DIR
}

###############################################################################

configure_source_script() {
    msg "Configuring environment variable source script"
    cp $INSTALL_DIR/kos/doc/environ.sh.sample $INSTALL_DIR/environ.sh
    chmod +x $INSTALL_DIR/environ.sh
}

###############################################################################

build_kallistios() {
    msg "Building KallistiOS"
    source $INSTALL_DIR/environ.sh
    cd $INSTALL_DIR/kos
    make
    cd $INSTALL_DIR
}

###############################################################################

build_kallistios_ports() {
    msg "Building KallistiOS ports"
    source $INSTALL_DIR/environ.sh
    cd $INSTALL_DIR/kos-ports/utils/
    ./build-all.sh
    cd $INSTALL_DIR
}

###############################################################################
# Start execution
###############################################################################

# Provide an opportunity to canel
msg "Install Dreamcast toolchain"
read -p "Press ENTER to continue (c to cancel) ..." entry
if [ ! -z $entry ]; then
    if [ $entry = "c" ]; then
        msg "Installation cancelled."
        exit 0
    fi
fi

if [ $do_update_and_upgrade = "y" ]; then
    update_and_upgrade
fi

if [ $do_install_packages_from_repos = "y" ]; then
    install_packages_from_repos
fi

if [ $do_create_installation_dir = "y" ]; then
    create_installation_dir
fi

if [ $do_checkout_kallistios = "y" ]; then
    checkout_kallistios
fi

if [ $do_download_toolchain = "y" ]; then
    download_toolchain
fi

if [ $do_build_toolchain = "y" ]; then
    build_toolchain
fi

if [ $do_configure_source_script = "y" ]; then
    configure_source_script
fi

if [ $do_build_kallistios = "y" ]; then
    build_kallistios
fi

if [ $do_build_kallistios_ports = "y" ]; then
    build_kallistios_ports
fi

exit 0


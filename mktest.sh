#/bin/bash

############
# Prologue #
############

set -e
ROOTDIR="$(dirname ${BASH_SOURCE[0]})"
cd "$ROOTDIR"
umask 000

#export JAVA_IMPL=hotspot
export BUILD_LIST=openjdk_regression
export JAVA_BIN="$ROOTDIR/jdk/bin"
export SPEC=linux-arm
export JAVA_VERSION=SE100

#####################
# Utility functions #
#####################

function log() {
    echo "[TEST] " $@
}

function interpreterize() {
    mv "./jdk/bin/$1" "./jdk/bin/$1.real"
    if [ "$2" == "wrap" ]; then
        echo -e '#!/bin/bash\n"'"$(pwd)/jdk/bin/$1.real"'" -J-Xint "$@"' > "./jdk/bin/$1"
    elif [ "$2" == "direct" ]; then
        echo -e '#!/bin/bash\n"'"$(pwd)/jdk/bin/$1.real"'" -Xint "$@"' > "./jdk/bin/$1"
    fi
    chmod +x "./jdk/bin/$1"
}

#########
# Steps #
#########

function jdk_setup() {
    cd "$ROOTDIR"

    ARCH="$1"
    if [ "$ARCH" != "ev3" ] && [ "$ARCH" != "rpi1" ] && [ "$ARCH" != "rpi2" ] && [ "$ARCH" != "rpi3" ]; then
        echo "Bad architecture: $ARCH" >2
        exit 1
    fi

    log "Downloading latest JDK for ${ARCH}."
    wget -nv "https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk10_build_${ARCH}_linux/lastSuccessfulBuild/artifact/build/jdk-${ARCH}.tar.gz"

    log "Extracting JDK."
    tar -xf "jdk-${ARCH}.tar.gz"

    arch | grep -e "arm" -e "aarch"
    if [ "$?" -eq 1 ]; then
        log "Configuring JDK."
        interpreterize java  direct
        interpreterize javac wrap
    fi
}

function test_prepare() {
    cd "$ROOTDIR"
    log "Cloning openjdk-tests."
    git clone --depth "1" --branch "feature/ev3dev" "https://github.com/ev3dev-lang-java/openjdk-tests.git"

    cd "$ROOTDIR/openjdk-tests"
    log "Calling get script."
    ./get.sh   -t "$ROOTDIR/openjdk-tests"   -p   linux-arm   -v    openjdk10

    cd "$ROOTDIR/openjdk-tests/TestConfig"
    log "Calling configure."
    make -f run_configure.mk
    log "Calling compile."
    make compile
}

function test_run() {
    cd "$ROOTDIR/openjdk-tests/TestConfig"

    log "Starting tests."
    if [ "$#" -eq 0 ]; then
        #make sanity
        make jdk_math
        #make jdk_lang
        #make jdk_io
        #make jdk_beans
        #make jdk_other
        #make jdk_net
        #make jdk_nio
        #make jdk_security1
        #make jdk_security2
        #make jdk_security3
        #make jdk_text
        #make jdk_util
        #make jdk_time
        #make jdk_management
        #make jdk_jmx
        #make jdk_rmi
        #make jdk_sound
        #make jdk_tools
        #make jdk_jdi
        #make jdk_jfr

    else
        make "$1"
    fi
}

if [ "$#" -eq 0 ]; then
    jdk_setup
    test_prepare
    test_run
else
    "$@"
fi

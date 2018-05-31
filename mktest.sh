#/bin/bash
set -e
cd "$(dirname ${BASH_SOURCE[0]})"

function log() {
    echo "[TEST] " $@
}

function setup_jdk() {
    log "Downloading latest JDK-EV3."
    wget -nv https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk-10-ev3/lastSuccessfulBuild/artifact/build/jdk-ev3.tar.gz

    log "Extracting JDK."
    tar -xf jdk-ev3.tar.gz

    log "Configuring JDK."
    cp ./java-wrapper ./jdk/bin/java-wrapper
    sudo update-alternatives --install /usr/bin/java java "$(pwd)/jdk/bin/java-wrapper" 2000
    java -version
}

function run_tests() {
    log "Downloading tests."
    git clone --depth 1 https://github.com/AdoptOpenJDK/openjdk-tests.git
    cd openjdk-tests

    log "Calling get script."
    ls /opt/jdktest/
    export BUILD_LIST=openjdk_regression
    export JAVA_BIN=/opt/jdktest/jdk/bin
    export SPEC=linux_arm
    export JAVA_VERSION=SE100
    ./get.sh   -t /opt/jdktest/openjdk-tests   -p   linux_arm   -v    openjdk10
    cd TestConfig

    log "Calling configure."
    make -f run_configure.mk

    log "Calling compile."
    make compile

    log "Starting tests."
    # make sanety
    make jdk_math
}

setup_jdk
run_tests

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
}

function setup_jri() {
    log "Downloading latest JRI-EV3."
    wget -nv https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk-10-ev3/lastSuccessfulBuild/artifact/build/jri-ev3.tar.gz

    log "Extracting JRI."
    tar -xf jri-ev3.tar.gz
    mv jri-ev3 jdk
}

function setup_post() {
    log "Configuring Java."
    mv ./jdk/bin/java ./jdk/bin/java.real
    echo -e '#!/bin/bash\n"'"$(pwd)/jdk/bin/java.real"'" -Xint "$@"' > ./jdk/bin/java
    chmod +x ./jdk/bin/java
    sudo update-alternatives --install /usr/bin/java java "$(pwd)/jdk/bin/java" 2000
    java -version
    wget https://github.com/ev3dev-lang-java/openjdk-ev3-test/raw/master/example/HelloWorld.class
    java HelloWorld
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

setup_jri
setup_post
run_tests

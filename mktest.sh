#/bin/bash

############
# Prologue #
############

set -e
ROOTDIR="$(dirname ${BASH_SOURCE[0]})"
cd "$ROOTDIR"
umask 000

export JAVA_IMPL=hotspot
export BUILD_LIST=systemtest
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
        echo "Bad architecture: $ARCH"
        exit 1
    fi

    log "Downloading latest JDK for ${ARCH}."
    wget -nv "https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk10_build_${ARCH}_linux/lastSuccessfulBuild/artifact/build/jdk-${ARCH}.tar.gz"

    log "Extracting JDK."
    tar -xf "jdk-${ARCH}.tar.gz"


    log "Configuring JDK."
    interpreterize java  direct
    interpreterize javac wrap

    ./jdk/bin/java -version
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
        make DirectByteBufferLoadTest
        #make LangLoadTest
        #make LockingLoadTest
        #make MathLoadTest_all
        #make MathLoadTest_autosimd
        #make MathLoadTest_bigdecimal
        #make MauveSingleThreadLoadTest
        #make MauveSingleInvocationLoadTest
        #make MauveMultiThreadLoadTest
        #make NioLoadTest
        #make UtilLoadTest
        #make HCRLateAttachWorkload
        #make JdiTest
        #make DaaLoadTest_daa1
        #make DaaLoadTest_daa2
        #make DaaLoadTest_daa3
        #make DaaLoadTest_all
        #make HeapHogLoadTest
        #make ObjectTreeLoadTest
        #make CpMpTest_CpMp
        #make CpMpTest_MP
        #make CpMpTest2
        #make CpMpTest3
        #make CpMpModularJarTest
        #make CpMpModularJarTest2
        #make CpMpModularJarTest3
        #make JDKInternalAPIsTest
        #make AutomaticModulesTest1
        #make AutomaticModulesTest2
        #make AutomaticModulesTest_ImpliedReadabilityTest1
        #make AutomaticModulesTest_ImpliedReadabilityTest2
        #make AutomaticModulesTest_ImpliedReadabilityTest3
        #make ExplicitModulesTest
        #make ServiceLoadersTest
        #make PatchModuleTest_PlatformModPatchModule
        #make PatchModuleTest_AppModPatchModule
        #make PatchModuleTest_UnexportedTypePatchModule
        #make PatchModuleTest_AdvancedPatchModule
        #make PatchModuleImageTest_PlatformModPatchModule
        #make PatchModuleImageTest_AppModPatchModule
        #make PatchModuleImageTest_UnexportedTypePatchModule
        #make PatchModuleImageTest_AdvancedPatchModule
        #make UpgradeModPathTest_ExpDirModUpgrade
        #make UpgradeModPathTest_ExpDirModUpgradeCRImage
        #make UpgradeModPathTest_JarredModUpgrade
        #make UpgradeModPathTest_JarredModUpgradeCRImage
        #make JlinkTest_RequiredMod
        #make JlinkTest_AddModLimitMod
        #make CpMpJlinkTest
        #make JlinkPluginOptionsTest_GeneralOptionsTest
        #make LayersTest
        #make CLTest
        #make CLTestImage
        #make CLLoadTest
        #make CLStressWithLayers
        #make CLStressWithLayersCRI

    else
        make "$1"
    fi
}

if [ "$#" -eq 0 ]; then
    jdk_setup ev3
    test_prepare
    test_run
else
    "$@"
fi

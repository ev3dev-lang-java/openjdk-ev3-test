#/bin/bash
set -e
cd "$(dirname ${BASH_SOURCE[0]})"

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

function setup_jdk() {
    log "Downloading latest JDK-EV3."
    wget -nv https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk10_build_ev3_linux/lastSuccessfulBuild/artifact/build/jdk-ev3.tar.gz

    log "Extracting JDK."
    tar -xf jdk-ev3.tar.gz

    log "Configuring JDK."
    interpreterize java  direct
    interpreterize javac wrap
    sudo update-alternatives --install /usr/bin/java java "$(pwd)/jdk/bin/java" 2000
    java -version
    wget https://github.com/ev3dev-lang-java/openjdk-ev3-test/raw/master/example/HelloWorld.class
    java HelloWorld
}

function run_tests() {
    log "Downloading tests."
    git clone https://github.com/ev3dev-lang-java/openjdk-tests.git
    cd openjdk-tests
    git checkout feature/ev3dev

    log "Calling get script."
    export JAVA_IMPL=hotspot
    export BUILD_LIST=systemtest
    export JAVA_BIN=/opt/jdktest/jdk/bin
    export SPEC=linux-arm
    export JAVA_VERSION=SE100
    ./get.sh   -t /opt/jdktest/openjdk-tests   -p   linux-arm   -v    openjdk10
    cd TestConfig

    log "Calling configure."
    make -f run_configure.mk

    log "Calling compile."
    make compile

    log "Starting tests."
    # make sanety
    make DirectByteBufferLoadTest
    make LangLoadTest
    make LockingLoadTest
    make MathLoadTest_all
    make MathLoadTest_autosimd
    make MathLoadTest_bigdecimal
    make MauveSingleThreadLoadTest
    make MauveSingleInvocationLoadTest
    make MauveMultiThreadLoadTest
    make NioLoadTest
    make UtilLoadTest
    make HCRLateAttachWorkload
    make JdiTest
    make DaaLoadTest_daa1
    make DaaLoadTest_daa2
    make DaaLoadTest_daa3
    make DaaLoadTest_all
    make HeapHogLoadTest
    make ObjectTreeLoadTest
    make CpMpTest_CpMp
    make CpMpTest_MP
    make CpMpTest2
    make CpMpTest3
    make CpMpModularJarTest
    make CpMpModularJarTest2
    make CpMpModularJarTest3
    make JDKInternalAPIsTest
    make AutomaticModulesTest1
    make AutomaticModulesTest2
    make AutomaticModulesTest_ImpliedReadabilityTest1
    make AutomaticModulesTest_ImpliedReadabilityTest2
    make AutomaticModulesTest_ImpliedReadabilityTest3
    make ExplicitModulesTest
    make ServiceLoadersTest
    make PatchModuleTest_PlatformModPatchModule
    make PatchModuleTest_AppModPatchModule
    make PatchModuleTest_UnexportedTypePatchModule
    make PatchModuleTest_AdvancedPatchModule
    make PatchModuleImageTest_PlatformModPatchModule
    make PatchModuleImageTest_AppModPatchModule
    make PatchModuleImageTest_UnexportedTypePatchModule
    make PatchModuleImageTest_AdvancedPatchModule
    make UpgradeModPathTest_ExpDirModUpgrade
    make UpgradeModPathTest_ExpDirModUpgradeCRImage
    make UpgradeModPathTest_JarredModUpgrade
    make UpgradeModPathTest_JarredModUpgradeCRImage
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
    #ls /opt/jdktest/jvmtest/openjdk_regression/report/
}

setup_jdk
run_tests

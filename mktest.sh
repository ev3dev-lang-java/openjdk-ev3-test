#/bin/bash
set -e

cd "$(dirname ${BASH_SOURCE[0]})"

echo "Running Script to test OpenJDK"

wget https://ci.adoptopenjdk.net/view/ev3dev/job/openjdk-10-ev3/lastSuccessfulBuild/artifact/build/jdk-ev3.tar.gz
tar -xf jdk-ev3.tar.gz
cp ./java-wrapper ./jdk/bin/java-wrapper
sudo update-alternatives --install /usr/bin/java java "$(pwd)/jdk/bin/java-wrapper" 2000
java -version
#exit 0

git clone https://github.com/AdoptOpenJDK/openjdk-tests.git
cd openjdk-tests
export BUILD_LIST=openjdk_regression
export JAVA_BIN=/home/compiler/jdk/bin/
export SPEC=linux_arm
export JAVA_VERSION=SE100
cd TestConfig
./get.sh   -t /home/compiler/openjdk-tests   -p   linux_arm   -v    openjdk10
make -f run_configure.mk
make compile
# make sanety
make jdk_math

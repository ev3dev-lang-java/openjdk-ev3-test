pipeline {
    agent {
        label '( linux || sw.os.linux ) && ( docker || sw.tool.docker ) && ( test )'
    }
    stages {
        stage('checkout') {
            steps {
                checkout scm
            }
        }
        stage ("State query") {
            steps {
                sh "docker ps -a"
                sh "docker images"
                sh "df -h"
            }
        }
        stage ("Fuckup recovery") {
            steps {
                sh "docker run --rm -v \$(realpath ./insider):/opt/jdktest debian:stretch /bin/sh -c 'rm -rf /opt/jdktest/*' || true"
                sh "rm -rf insider insider.tar.gz || true"
                sh "docker rmi openjdk-10-ev3-test || true"
            }
        }
    }
}

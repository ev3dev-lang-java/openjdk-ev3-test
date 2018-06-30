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
                sh "docker rmi 0d958b969cad || true"
                sh "docker rmi 5bb714a3fce3 || true"
                sh "docker rmi d8e48ffc4fe4 || true"
                sh "docker rmi bf16b2e8af92 || true"
                sh "docker rmi 38a0f4d209ac || true"
                sh "docker rmi e4dd33770918 || true"
                sh "docker rmi d10212ee267b || true"
                sh "docker rmi c4788ed6de1b || true"
                sh "docker rmi a37a0fc15498 || true"
                sh "docker rmi 153fcc0af166 || true"
                sh "docker rmi d51ad9242ad8 || true"
                sh "docker rmi 4d62521137c8 || true"
                sh "docker rmi 2f58f40627c2 || true"
                sh "docker rmi ca46859ebca4 || true"
                sh "docker rmi 8afc6d4ac4ac || true"
                sh "docker run --rm -v \$(realpath ./insider):/opt/jdktest openjdk-10-ev3-test rm -rf /opt/jdktest || true"
                sh "rm -rf insider insider.tar.gz || true"
                sh "docker rmi openjdk-10-ev3-test || true"
            }
        }
    }
}

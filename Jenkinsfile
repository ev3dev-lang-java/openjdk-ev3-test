pipeline {
    agent {
        label '( linux || sw.os.linux ) && ( x64 || x86_64 || x86 || hw.arch.x86 ) && ( docker || sw.tool.docker ) && test'
    }
    stages {
        stage('checkout') {
            steps {
                checkout scm
            }
        }
        stage('QEMU + binfmt') {
            steps {
                sh "apt-get install binfmt-support qemu-user-static -y"
            }
        }
        stage("Build") {
            steps {
                sh "docker build -t openjdk-10-ev3-test ."
            }
        }
        stage("Test") {
            steps {
                sh "docker run --rm openjdk-10-ev3-test"
            }
        }
    }
}

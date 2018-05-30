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
    post {
        always {
            script {
                try {
                    sh "docker rmi openjdk-10-ev3-test 2>/dev/null"
                } catch (err) {}
            }
        }
    }
}

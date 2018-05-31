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

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
                sh "docker build -t openjdk-9-ev3-test ."
            }
        }
        stage("Test") {
            steps {
                sh "docker run --rm openjdk-9-ev3-test"
            }
        }
    }
    post {
        always {
            script {
                step([$class: "TapPublisher", testResults: "**/*.tap"])
                junit allowEmptyResults: true, keepLongStdio: true, testResults: '**/work/**/*.jtr.xml, **/junitreports/**/*.xml'

                try {
                    sh "docker rmi openjdk-9-ev3-test 2>/dev/null"
                } catch (err) {}
            }
        }
    }
}

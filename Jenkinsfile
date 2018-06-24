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
                script {
                    try {
                        sh "docker run --rm -v \$(realpath ./insider):/opt/jdktest openjdk-10-ev3-test 'rm -rf /opt/jdktest'"
                    } catch (err) {}
                    try {
                        sh "rm -rf insider insider.tar.gz"
                    } catch (err) {}
                }
                sh "mkdir        ./insider"
                sh "cp mktest.sh ./insider/"
                sh "chmod 777    ./insider ./insider/mktest.sh"
                sh "docker run --rm -v \$(realpath ./insider):/opt/jdktest openjdk-10-ev3-test"
            }
        }
        stage("Upload results") {
            steps {
                step([$class: "TapPublisher", testResults: "**/*.tap"])
                junit allowEmptyResults: true, keepLongStdio: true, testResults: '**/work/**/*.jtr.xml, **/junitreports/**/*.xml'
            }
        }
    }
    post {
        always {
            script {
                try {
                    sh "docker run --rm -v \$(realpath ./insider):/opt/jdktest openjdk-10-ev3-test 'rm -rf /opt/jdktest'"
                } catch (err) {}
                try {
                    sh "rm -rf insider"
                } catch (err) {}
                try {
                    sh "docker rmi openjdk-10-ev3-test 2>/dev/null"
                } catch (err) {}
            }
        }
    }
}

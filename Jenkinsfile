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
        stage ("Fuckup recovery") {
            steps {
                sh "docker ps -a"
                sh "docker images"
                sh "docker kill 8cbac0d1466d 95bc540becb5"
                sh "docker rm d032990b124c d809954aa35b 6dd176a74a38 42bea8975800 a1858eb48c05 8cbac0d1466d 95bc540becb5"
                sh "docker rmi 5bb714a3fce3 d8e48ffc4fe4 bf16b2e8af92 38a0f4d209ac e4dd33770918 d10212ee267b c4788ed6de1b a37a0fc15498 153fcc0af166 d51ad9242ad8 4d62521137c8 2f58f40627c2 ca46859ebca4 8afc6d4ac4ac"

            }
        }
        /*
        stage("Build") {
            steps {
                //sh "docker build -t openjdk-10-ev3-test ."
            }
        }
        stage("Test") {
            steps {
                script {
                    try {
                        sh "docker run --rm -v \$(realpath ./insider):/opt/jdktest debian:stretch rm -rf /opt/jdktest"
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
                    sh "docker run --rm -v \$(realpath ./insider):/opt/jdktest openjdk-10-ev3-test rm -rf /opt/jdktest"
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
    */
}

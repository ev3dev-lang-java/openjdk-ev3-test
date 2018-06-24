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
                sh "mkdir        ./insider"
                sh "cp mktest.sh ./insider/"
                sh "chmod 777 -R ./insider"
                sh "docker run --rm -v $(realpath ./insider):/opt/jdktest openjdk-10-ev3-test"
            }
        }
    }
    post {
        always {
            script {
                step([$class: "TapPublisher", testResults: "**/*.tap"])
                junit allowEmptyResults: true, keepLongStdio: true, testResults: '**/work/**/*.jtr.xml, **/junitreports/**/*.xml'

                sh "tar -czf insider.tar.gz insider"
                archiveArtifacts artifacts: 'insider.tar.gz'
                sh "rm -rf insider insider.tar.gz"

                try {
                    sh "docker rmi openjdk-10-ev3-test 2>/dev/null"
                } catch (err) {}
            }
        }
    }
}

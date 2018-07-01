// Jenkins pipeline script
node('( linux || sw.os.linux ) && ( docker || sw.tool.docker ) && ( test )') {

    // predefine docker image
    def image

    // from here we can do cleanup
    try {
        // clone our repo
        stage('Checkout SCM') {
            checkout scm
        }
        // build our image
        stage('Docker build') {
            image = docker.build("openjdk-10-ev3-test:latest")
        }
        // run inside image
        image.inside {
            // our test script
            stage ('Download tested JDK') {
                sh '/bin/bash /opt/jdktest/mktest.sh jdk_setup'
            }
            stage ('Download tests') {
                sh '/bin/bash /opt/jdktest/mktest.sh test_download'
            }
            stage ('Build tests') {
                sh '/bin/bash /opt/jdktest/mktest.sh test_build'
            }
            stage ('Run tests') {
                sh '/bin/bash /opt/jdktest/mktest.sh test_run'
            }
            // and then submit the results
            stage ('Publish results') {
                step([$class: "TapPublisher", testResults: "/opt/jdktest/**/*.tap"])
                junit allowEmptyResults: true, keepLongStdio: true, testResults: '/opt/jdktest/**/work/**/*.jtr.xml, /opt/jdktest/**/junitreports/**/*.xml'
            }
        }
    } finally {
        // remove leftover stuff
        stage ('Cleanup') {
            cleanWs()
        }
    }
}

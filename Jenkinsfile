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
            // in the tests directory
            dir('/opt/jdktest') {
                // our test script
                stage ('Run tests') {
                    sh './mktest.sh'
                }
                // and then submti the results
                stage ('Publish results') {
                    step([$class: "TapPublisher", testResults: "**/*.tap"])
                    junit allowEmptyResults: true, keepLongStdio: true, testResults: '**/work/**/*.jtr.xml, **/junitreports/**/*.xml'
                }
            }
        }
    } finally {
        // remove leftover stuff
        stage ('Cleanup') {
            cleanWs()
        }
    }
}

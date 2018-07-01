// Jenkins pipeline script

// steps map
def stepMap = [
    'Download tested JDK': 'jdk_setup',
    'Prepare tests':       'test_prepare',
    'Run jdk_math':        'test_run jdk_math',
]

// build script
node('( linux || sw.os.linux ) && ( docker || sw.tool.docker ) && ( test )') {

    // predefine docker image
    def image

    // from here we can do cleanup
    try {
        // clone our repo
        checkout scm
        sh "chmod +x ${env.WORKSPACE}/mktest.sh"

        // build our image
        stage('Docker build') {
            image = docker.build("openjdk-10-ev3-test:latest")
        }
        // run inside image
        image.inside {
            for (kv in mapToList(stepMap)) {
                stage(kv[0]) {
                    sh "/bin/bash ${env.WORKSPACE}/mktest.sh ${kv[1]}"
                }
            }
            // and then submit the results
            stage ('Publish results') {
                step([$class: "TapPublisher", testResults: "**/*.tap"])
                junit allowEmptyResults: true, keepLongStdio: true, testResults: '**/work/**/*.jtr.xml, **/junitreports/**/*.xml'
            }
        }
    } finally {
        // remove leftover stuff
        stage ('Cleanup') {
            cleanWs()
        }
    }
}

// Required due to JENKINS-27421
@NonCPS
List<List<?>> mapToList(Map map) {
  return map.collect { it ->
    [it.key, it.value]
  }
}

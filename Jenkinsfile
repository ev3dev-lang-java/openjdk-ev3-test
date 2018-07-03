// Jenkins pipeline script

// steps map
def prepMap = [
    'Download tested JDK': "jdk_setup ${params.ARCH}",
    'Prepare tests':       'test_prepare',
]
// list of parallel jobs (top-level list is executed sequentially, sublists are executed in parallel)
def jdkJobs = [
    [ 'jdk_math',      'jdk_lang',      'jdk_sound',    'jdk_other'],
    [ 'jdk_io',        'jdk_nio',       'jdk_net',      'jdk_util'],
    [ 'jdk_security1', 'jdk_security2', 'jdk_tools',    'jdk_management'],
    [ 'jdk_time',      'jdk_text',      'jdk_rmi',      'jdk_jmx'],
    [ 'jdk_jdi',       'jdk_jfr'],
  /*[ 'jdk_beans',     'jdk_security3'  ],*/
]

// build script
node('( linux || sw.os.linux ) && ( docker || sw.tool.docker ) && ( test )') {

    // predefine docker image
    def image

    // from here we can do cleanup
    try {
        // clone our repo
        cleanWs()
        checkout scm
        sh "chmod +x ${env.WORKSPACE}/mktest.sh"

        // build our image
        stage('Docker build') {
            image = docker.build("openjdk-10-ev3-test:latest")
        }

        sh "mkdir original && mv mktest.sh original/"

        // run inside image
        image.inside ("-v ${env.WORKSPACE}/original:/opt/jdktest") {
            for (kv in mapToList(prepMap)) {
                String name = kv[0]
                String work = kv[1]
                stage(name) {
                    sh "/bin/bash /opt/jdktest/mktest.sh ${work}"
                }
            }
        }

        // for all parallelizable groups
        for (listIt in jdkJobs) {
            def list = listIt
            def jobs = [:]

            // for all tasks to be run in parallel
            for (nameIt in list) {
                String name = nameIt

                // create job
                jobs["Test ${name}"] = {
                    String orig    = "${env.WORKSPACE}/original"
                    String workdir = "${env.WORKSPACE}/${name}"

                    stage("Run ${name}") {
                        // prepare isolated environment
                        sh "cp -rf ${orig}/jvmtest ${workdir}"
                        // run test
                        image.inside("-v ${orig}:/opt/jdktest -v ${workdir}:/opt/jdktest/jvmtest") {
                            sh "/bin/bash /opt/jdktest/mktest.sh test_run ${name}"
                        }
                        // and then submit the results
                        step([$class: "TapPublisher", testResults: "**/${name}/**/*.tap"])
                        junit allowEmptyResults: true, keepLongStdio: true, testResults: "**/${name}/**/work/**/*.jtr.xml, **/${name}/**/junitreports/**/*.xml"
                        // and remove isolated environment
                        sh "rm -rf ${workdir}"
                    }
                }
            }
            // run in parallel
            parallel jobs
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

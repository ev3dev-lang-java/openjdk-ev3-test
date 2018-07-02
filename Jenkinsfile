// Jenkins pipeline script

// steps map
def prepMap = [
    'Download tested JDK': "jdk_setup ${params.ARCH}",
    'Prepare tests':       'test_prepare',
]
// list of parallel jobs (top-level list is executed sequentially, sublists are executed in parallel)
def jdkJobs = [
    [ 'jdk_math',      'jdk_rmi'        ],
    [ 'jdk_io',        'jdk_other'      ],
    [ 'jdk_net',       'jdk_nio'        ],
    [ 'jdk_security1', 'jdk_security2'  ],
    [ 'jdk_text',      'jdk_util'       ],
    [ 'jdk_time',      'jdk_management' ],
    [ 'jdk_lang',      'jdk_jmx'        ],
    [ 'jdk_sound',     'jdk_tools'      ],
    [ 'jdk_jdi',       'jdk_jfr'        ],
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
        sh "mkdir original && mv mktest.sh original/"
        sh "chmod +x ${env.WORKSPACE}/original/mktest.sh"

        // build our image
        stage('Docker build') {
            image = docker.build("openjdk-10-ev3-test:latest")
        }
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

        for (listIt in jdkJobs) {
            def list = listIt
            def jobs = [:]
            for (nameIt in list) {
                String name = nameIt
                jobs["Test ${name}"] = {
                    String orig    = "${env.WORKSPACE}/original"
                    String workdir = "${env.WORKSPACE}/${name}"

                    sh "cp -rf ${orig}/jvmtest ${workdir}"
                    stage("Run ${name}") {
                        image.inside("-v ${orig}:/opt/jdktest -v ${workdir}:/opt/jdktest/jvmtest") {
                            sh "/bin/bash /opt/jdktest/mktest.sh test_run ${name}"
                        }
                    }
                    // and then submit the results
                    stage ('Pub ${name}') {
                        step([$class: "TapPublisher", testResults: "**/${name}/**/*.tap"])
                        junit allowEmptyResults: true, keepLongStdio: true, testResults: "**/${name}/**/work/**/*.jtr.xml, **/${name}/**/junitreports/**/*.xml"
                    }
                    sh "rm -rf ${workdir}"
                }
            }
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

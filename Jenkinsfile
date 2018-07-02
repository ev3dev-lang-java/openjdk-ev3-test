// Jenkins pipeline script

// steps map
def prepMap = [
    'Download tested JDK': "jdk_setup ${params.ARCH}",
    'Prepare tests':       'test_prepare',
]
// list of parallel jobs (top-level list is executed sequentially, sublists are executed in parallel)
def jdkJobs = [
    [ 'jdk_math',      'jdk_lang'       ],
    [ 'jdk_io',        'jdk_other'      ],
    [ 'jdk_net',       'jdk_nio'        ],
    [ 'jdk_security1', 'jdk_security2'  ],
    [ 'jdk_text',      'jdk_util'       ],
    [ 'jdk_time',      'jdk_management' ],
    [ 'jdk_jmx',       'jdk_rmi'        ],
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
        checkout scm
        sh "chmod +x ${env.WORKSPACE}/mktest.sh"

        // build our image
        stage('Docker build') {
            image = docker.build("openjdk-10-ev3-test:latest")
        }
        // run inside image
        image.inside {
            for (kv in mapToList(prepMap)) {
                stage(kv[0]) {
                    sh "/bin/bash ${env.WORKSPACE}/mktest.sh ${kv[1]}"
                }
            }
        }

        for (listIt in jdkJobs) {
            def list = listIt
            def jobs = [:]
            for (nameIt in list) {
                String name = nameIt
                jobs["Run ${name}"] = {
                    stage("Run ${name}") {
                        image.inside {
                            sh "/bin/bash ${env.WORKSPACE}/mktest.sh test_run ${name}"
                        }
                    }
                }
            }
            parallel jobs
        }

        // and then submit the results
        stage ('Publish results') {
            step([$class: "TapPublisher", testResults: "**/*.tap"])
            junit allowEmptyResults: true, keepLongStdio: true, testResults: '**/work/**/*.jtr.xml, **/junitreports/**/*.xml'
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

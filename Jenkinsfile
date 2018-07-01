// Jenkins pipeline script

// steps map
def prepMap = [
    'Download tested JDK': "jdk_setup ${params.ARCH}",
    'Prepare tests':       'test_prepare',
]
// list of parallel jobs (top-level list is executed sequentially, map entries are executed in parallel)
def jdkJobs = [
    [ 'Run jdk_math':        'test_run jdk_math',
      'Run jdk_lang':        'test_run jdk_lang',
      'Run jdk_io':          'test_run jdk_io',
      'Run jdk_beans':       'test_run jdk_beans',      ],
    [ 'Run jdk_other':       'test_run jdk_other',
      'Run jdk_net':         'test_run jdk_net',
      'Run jdk_nio':         'test_run jdk_nio',
      'Run jdk_security1':   'test_run jdk_security1',  ],
    [ 'Run jdk_security2':   'test_run jdk_security2',
      'Run jdk_security3':   'test_run jdk_security3',
      'Run jdk_text':        'test_run jdk_text',
      'Run jdk_util':        'test_run jdk_util',       ],
    [ 'Run jdk_time':        'test_run jdk_time',
      'Run jdk_management':  'test_run jdk_management',
      'Run jdk_jmx':         'test_run jdk_jmx',
      'Run jdk_rmi':         'test_run jdk_rmi',        ],
    [ 'Run jdk_sound':       'test_run jdk_sound',
      'Run jdk_tools':       'test_run jdk_tools',
      'Run jdk_jdi':         'test_run jdk_jdi',
      'Run jdk_jfr':         'test_run jdk_jfr',        ],
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

            for (jdkMap in jdkJobs) {
                def jobs = [:]
                for (kv in mapToList(jdkMap)) {
                    jobs[kv[1]] = {
                        stage(kv[0]) {
                            sh "/bin/bash ${env.WORKSPACE}/mktest.sh ${kv[1]}"
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

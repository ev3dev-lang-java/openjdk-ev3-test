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
                sh "docker rmi 0d958b969cad 5bb714a3fce3 d8e48ffc4fe4 bf16b2e8af92 38a0f4d209ac e4dd33770918 d10212ee267b c4788ed6de1b a37a0fc15498 153fcc0af166 d51ad9242ad8 4d62521137c8 2f58f40627c2 ca46859ebca4 8afc6d4ac4ac"

            }
        }
}

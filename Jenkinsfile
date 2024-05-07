pipeline {
    agent {
        dockerfile {
            args '--group-add=46 --device-cgroup-rule="c 189:* rmw" -v /dev/bus/usb:/dev/bus/usb'
        }
    }
    stages {
        stage('development') {
            steps {
                script {
                    // revert untrusted files to the base version and backup it before we execute any untrusted code so the attacker
                    // don't have a chance to put a malicious content
                    def latest = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()

                    sh "git checkout origin/master"

                    def safeJenkinsfile = readFile('Jenkinsfile')
                    def safeDockerfile = readFile('Dockerfile')

                    // switch back to latest commit
                    sh "git checkout ${latest}"
                    sh 'git clean -d -f -f -q -x'
                    sh 'cat Jenkinsfile'
                    sh 'cat Dockerfile'
                }

            }
        }
    }
    post {
        always {
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true)
        }
    }
}

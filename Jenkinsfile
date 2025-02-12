pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t greatfet https://github.com/greatscottgadgets/greatfet.git'
            }
        }
        stage('Test Suite') {
            agent {
                docker {
                    image 'greatfet'
                    reuseNode true
                    args '--name greatfet_container --group-add=46 --device-cgroup-rule="c 189:* rmw" --device /dev/bus/usb'
                }
            }
            steps {
                sh './ci-scripts/build-host.sh'
                sh './ci-scripts/build-firmware.sh'
                sh 'hubs all off'
                retry(3) {
                    sh './ci-scripts/test-host.sh'
                }
                retry(3) {
                    sh './ci-scripts/test-firmware-program.sh'
                }
                sh './ci-scripts/test-firmware-flash.sh'
                sh './ci-scripts/configure-hubs.sh --reset'
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

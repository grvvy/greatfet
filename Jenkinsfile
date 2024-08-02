pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t greatfet https://github.com/grvvy/greatfet.git'
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
                sh 'echo hello'
                sh 'ls -la /dev/'
                sh 'sleep 15s'
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

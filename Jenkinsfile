import org.jenkinsci.plugins.workflow.steps.FlowInterruptedException

pipeline {
    agent any
    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t greatfet https://github.com/greatscottgadgets/greatfet.git'
            }
        }
        stage('Build (Host)') {
            agent {
                docker {
                    image 'greatfet'
                    reuseNode true
                }
            }
            steps {
                runCommand("Build Host Tools", './ci-scripts/build-host.sh', 3, 2, 'MINUTES')
            }
        }
        stage('Build (Firmware)') {
            agent {
                docker {
                    image 'greatfet'
                    reuseNode true
                }
            }
            steps {
                runCommand("Build Firmware Images", './ci-scripts/build-firmware.sh', 3, 2, 'MINUTES')
            }
        }
        stage('HIL Test') {
            agent {
                docker {
                    image 'greatfet'
                    reuseNode true
                    args '''
                            --group-add=46
                            --device-cgroup-rule="c 189:* rmw"
                            -v /dev/bus/usb:/dev/bus/usb
                            -v /tmp/req_pipe:/tmp/req_pipe
                            -v /tmp/res_pipe:/tmp/res_pipe
                        '''
                }
            }
            steps {
                lock('HIL_hubs') {
                    script {
                        allOff()
                        runTests(
                            'greatfet',
                            [
                                [
                                    title: "HIL Host Tool Installation Check",
                                    cmd: './ci-scripts/test-host.sh'
                                ]
                            ]
                        )
                        runTests(
                            'greatfet',
                            [
                                [
                                    title: "HIL Firmware Volatile Upload",
                                    cmd: './ci-scripts/test-firmware-program.sh'
                                ],
                                [
                                    title: "HIL Firmware Write",
                                    cmd: './ci-scripts/test-firmware-flash.sh'
                                ]
                            ]
                        )
                    }
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

def runCommand(title, cmd, retries, time, unit) {
    retry(retries) {
        try {
            timeout(time: time, unit: unit) {
                sh "${cmd}"
            }
        } catch (FlowInterruptedException err) {
            // Check if the cause was specifically an exceeded timeout
            def cause = err.getCauses().get(0)
            if (cause instanceof org.jenkinsci.plugins.workflow.steps.TimeoutStepExecution.ExceededTimeout) {
                echo "${title} timeout reached."
                throw err // Re-throw the exception to fail the build
            } else {
                echo "Build interrupted for another reason."
                throw err // Re-throw the exception to fail the build
            }
        } catch (Exception err) {
            echo "An unrelated error occurred: ${err.getMessage()}"
            throw err
        }
    }
}

def runTests(devices, cmds) {
    retry(3) {
        // reset() retains it's own internal retries
        reset(devices)
        sh 'sleep 1s'
        // run the test with 0 internal retries and 3 external retries to ensure resets between runs
        for (test in cmds) {
            runCommand(
                test.title,
                test.cmd,
                0,
                5,
                'MINUTES'
            )
        }
    }
}

def allOff() {
    // Allow up to 3 retries, 20 seconds each, for the USB hub port power server to respond
    runCommand('USB hub port power server command', "hubs all off", 3, 20, 'SECONDS')
}

def reset(devices) {
    // Allow up to 3 retries, 20 seconds each, for the USB hub port power server to respond
    runCommand('USB hub port power server command', "hubs ${devices} reset", 3, 20, 'SECONDS')
}

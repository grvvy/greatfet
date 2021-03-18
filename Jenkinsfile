pipeline {
    agent { 
        dockerfile {
            args '--group-add=46 --privileged -v /dev/bus/usb:/dev/bus/usb'
        }
    }
    environment {
        GIT_COMMITER_NAME = 'CI Person'
        GIT_COMMITER_EMAIL = 'ci@greatscottgadgets.com'
    }
    stages {
        stage('build') {
            steps {
                sh '''#!/bin/bash
                    echo "UHub:"
                    uhubctl
                    echo "ACTIVATING PYTHON VIRTUAL ENVIRONMENT ***************************************************************************************************"
                    python3 -m venv testing-venv
                    source testing-venv/bin/activate
                    echo "INSTALLING PYYAML  ***************************************************************************************************"
                    pip install pyyaml
                    echo "INSTALLING libgreat/host ****************************************************************************************************************"
                    pushd libgreat/host/
                    python3 setup.py build
                    python3 setup.py install
                    popd
                    echo "INSTALLING host *************************************************************************************************************************"
                    pushd host/
                    python3 setup.py build
                    python3 setup.py install
                    popd
                    greatfet_info
                    echo "UHub:"
                    uhubctl
                    echo "MAKING firmware *************************************************************************************************************************"
                    cd firmware/libopencm3
                    make clean
                    make
                    cd ../greatfet_usb
                    mkdir build
                    cd build
                    cmake ..
                    make
                    echo "DFUing firmware   ***********************************************************************************************************************"
                    greatfet_firmware -V greatfet_usb.bin
                    echo "Sleep for 1s.."
                    sleep 1s
                    echo "FLASHING firmware ***********************************************************************************************************************"
                    greatfet_info
                    greatfet_firmware -w greatfet_usb.bin
                    echo "Sleep for 1s.."
                    sleep 1s
                    greatfet_info
                    echo "UHub:"
                    uhubctl
                    cd ../../..
                    echo "DEACTIVATING AND REMOVING THE VIRTUAL ENVIRONMENT ***************************************************************************************"
                    deactivate
                    rm -rf testing-venv/
                '''
            }
        }
    }
    post {
        always {
            echo 'One way or another, I have finished'
        }
    }
}
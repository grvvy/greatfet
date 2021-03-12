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
                    echo "USER before export:"
                    echo $USER
                    echo "ID:"
                    id
                    echo "groups:"
                    groups
                    echo "wmoami:"
                    whoami
                    echo "HOME:"
                    echo $HOME
                    echo "cat groups:"
                    cat /etc/group
                    echo "/dev/:"
                    ls /dev/
                    echo "Python versions:"
                    python2 -V
                    python3 -V
                    echo "python2 location:"
                    which python
                    echo "python3 location:"
                    which python3
                    echo "UHub:"
                    uhubctl
                    echo "ACTIVATING PYTHON VIRTUAL ENVIRONMENT ***************************************************************************************************"
                    python3 -m venv testing-venv
                    source testing-venv/bin/activate
                    echo "INSTALLING PYYAML AGAIN WOOOOOOOOOOOO ***************************************************************************************************"
                    pip install pyyaml
                    /usr/bin/python3 -m pip install pyyaml
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
                    echo "FLASHING firmware ***********************************************************************************************************************"
                    greatfet_info
                    greatfet_firmware -w greatfet_usb.bin -R
                    echo "Sleep for 1s.."
                    sleep 1s
                    greatfet_info
                    echo "UHub:"
                    uhubctl
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
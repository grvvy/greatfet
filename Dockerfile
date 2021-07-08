# Use the official image as a parent image
FROM ubuntu:20.04

# Add Jenkins as a user with sufficient permissions
RUN mkdir /home/jenkins
RUN groupadd -g 136 jenkins
RUN useradd -r -u 126 -g jenkins -G plugdev -d /home/jenkins jenkins
RUN chown jenkins:jenkins /home/jenkins

WORKDIR /home/jenkins

CMD ["/bin/bash"]

# Install prerequisites
RUN apt-get update && apt-get install -y
RUN apt-get -y install cmake
RUN apt-get -y install gcc-arm-none-eabi
RUN apt-get -y install python2
RUN apt-get -y install python3
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y universe
RUN apt-get -y install curl
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
RUN python2 get-pip.py
RUN apt-get -y install python3-pip
RUN apt-get -y install libusb-1.0-0
RUN apt-get -y install libusb-1.0-0-dev
RUN apt-get -y install git
RUN apt-get -y install python3-venv
RUN pip3 install --upgrade capablerobot_usbhub

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN export

USER jenkins

# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 8080

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .
# Use the official image as a parent image
FROM ubuntu:20.04

# Set the working directory
WORKDIR /usr/src/greatfet

# Add Jenkins as a user with sufficient permissions
RUN mkdir /home/jenkins
RUN groupadd -g 136 jenkins
RUN useradd -r -u 125 -g jenkins -G plugdev -d /home/jenkins jenkins
RUN gpasswd -a jenkins plugdev
RUN chown jenkins:jenkins /home/jenkins

# Install prerequisites
RUN apt-get update && apt-get install -y
RUN apt-get -y install cmake
RUN apt-get -y install gcc-arm-none-eabi
RUN apt-get -y install python2
RUN apt-get -y install python3

RUN apt-get -y install software-properties-common
RUN add-apt-repository -y universe
RUN apt-get -y install curl
RUN curl https://bootstrap.pypa.io/2.7/get-pip.py --output get-pip.py
RUN python2 get-pip.py

RUN apt-get -y install python3-pip
RUN apt-get -y install libusb-1.0-0
RUN apt-get -y install git
RUN apt-get -y install python3-venv
RUN git clone https://github.com/mvp/uhubctl
RUN ls
RUN cd uhubctl
RUN ls
RUN make
RUN make install
RUN cd ..

USER jenkins

# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 8080

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .
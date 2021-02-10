# Use the official image as a parent image
FROM ubuntu:19.10

# Set the working directory
WORKDIR /usr/src/greatfet

# Add Jenkins as a user with sufficient permissions
RUN useradd -u 125 jenkins
RUN gpasswd -a jenkins plugdev

# Install prerequisites
RUN apt-get update
RUN apt-get -y install cmake
RUN apt-get -y install gcc-arm-none-eabi
RUN apt-get -y install python3
RUN apt-get -y install python3-pip
RUN apt-get -y install libusb-1.0-0

# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 8080

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .
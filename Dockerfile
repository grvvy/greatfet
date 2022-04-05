# Use the official image as a parent image
FROM ubuntu:20.04

# Add Jenkins as a user with sufficient permissions
RUN groupadd -g 1000 jenkins
# RUN useradd -r -u 126 -g jenkins -G plugdev -d /home/jenkins jenkins
RUN useradd --create-home --shell /bin/bash -u 1000 -g 1000 -G 46 jenkins
WORKDIR /home/jenkins
CMD ["/bin/bash"]

# override interactive installations
ENV DEBIAN_FRONTEND=noninteractive 
# Install prerequisites
RUN apt-get update && apt-get install -y \
    cmake \
    curl \
    gcc-arm-none-eabi \
    git \
    libusb-1.0-0-dev \
    python3 \
    python3-pip \
    python3-venv \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install capablerobot_usbhub

# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 8080
USER jenkins
# COPY --chown=jenkins:jenkins . .

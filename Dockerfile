# Use the official image as a parent image
FROM ubuntu:19.10

# Set the working directory
WORKDIR /usr/src/app

# check filesystem
RUN ls

# Install prerequisites
RUN apt-get update

# Add Jenkins as a user with sufficient permissions
RUN useradd -u 125 jenkins
RUN gpasswd -a jenkins plugdev

# Inform Docker that the container is listening on the specified port at runtime.
EXPOSE 8080

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .


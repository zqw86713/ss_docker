#!/bin/bash

# This script pulls the latest ssserver-rust Docker image and runs a container.

# Define the image name and container name
IMAGE_NAME="ghcr.io/shadowsocks/ssserver-rust:latest"
CONTAINER_NAME="ssserver-rust"
CONFIG_FILE="/root/ss_docker/config.json" # Make sure your config.json is in the same directory as this script

echo "Pulling the latest Docker image: ${IMAGE_NAME}"
# Pull the latest Docker image
docker pull "${IMAGE_NAME}"

# Check if the pull was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to pull Docker image ${IMAGE_NAME}. Exiting."
  exit 1
fi

echo "Checking if container ${CONTAINER_NAME} already exists..."
# Check if a container with the same name already exists
if docker inspect "${CONTAINER_NAME}" &> /dev/null; then
  echo "Container ${CONTAINER_NAME} already exists. Removing it..."
  # Stop and remove the existing container
  docker stop "${CONTAINER_NAME}"
  docker rm "${CONTAINER_NAME}"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to remove existing container ${CONTAINER_NAME}. Exiting."
    exit 1
  fi
fi

echo "Running the Docker container: ${CONTAINER_NAME}"
# Run the Docker container with the specified options
docker run \
  --name "${CONTAINER_NAME}" \
  --restart always \
  -p 8388:8388/tcp \
  -p 8388:8388/udp \
  -v "${CONFIG_FILE}":/etc/shadowsocks-rust/config.json \
  -dit "${IMAGE_NAME}"

# Check if the container started successfully
if [ $? -ne 0 ]; then
  echo "Error: Failed to start Docker container ${CONTAINER_NAME}."
  exit 1
else
  echo "Container ${CONTAINER_NAME} started successfully."
fi

exit 0


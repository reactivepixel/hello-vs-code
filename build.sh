#!/bin/bash

# Build script for Docker-based C++ application

echo "Building Docker image..."
docker build -t hello-world-cpp .

if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo "Copying executable from container to local builds directory..."
    
    # Create a temporary container to copy the executable
    docker create --name temp-container hello-world-cpp
    docker cp temp-container:/app/builds/hello ./builds/
    docker rm temp-container
    
    echo "Executable copied to ./builds/hello"
    echo "You can now run: ./builds/hello"
else
    echo "Build failed!"
    exit 1
fi

# Unified Dockerfile for C++ development and production
FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install all development tools in one layer
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    g++ \
    make \
    gdb \
    valgrind \
    vim \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy source files
COPY src/ ./src/

# Create builds directory
RUN mkdir -p builds

# Build both debug and release versions
RUN g++ -std=c++17 -Wall -g -O0 -o builds/hello-debug src/hello.cpp && \
    g++ -std=c++17 -Wall -O2 -o builds/hello src/hello.cpp

# Default command (can be overridden)
CMD ["./builds/hello"]

# Unified Dockerfile for C++ development and production
FROM ubuntu:22.04

# Build arguments from environment (no defaults - must be passed from build)
ARG APP_NAME
ARG APP_ENTRY

# Validate required build arguments
RUN test -n "$APP_NAME" || (echo "ERROR: APP_NAME build argument is required" && exit 1)
RUN test -n "$APP_ENTRY" || (echo "ERROR: APP_ENTRY build argument is required" && exit 1)

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
RUN g++ -std=c++17 -Wall -g -O0 -o builds/${APP_NAME}-debug src/${APP_ENTRY} && \
    g++ -std=c++17 -Wall -O2 -o builds/${APP_NAME} src/${APP_ENTRY}

# Default command (can be overridden)
CMD ["sh", "-c", "./builds/${APP_NAME}"]

# Simplified Makefile for Docker-based C++ development

# Load environment variables from .env file
include .env

IMAGE_NAME = $(APP_NAME)-world-cpp
SOURCE_DIR = src
BUILD_DIR = builds
TARGET = $(APP_NAME)

# Default target - build and extract executable
all: docker-build

# Build Docker image and extract executables
docker-build:
	@echo "Building Docker image with both debug and release versions..."
	docker build --build-arg APP_NAME=$(APP_NAME) --build-arg APP_ENTRY=$(APP_ENTRY) -t $(IMAGE_NAME) .
	@echo "Extracting executables..."
	docker create --name temp-extract $(IMAGE_NAME)
	docker cp temp-extract:/app/$(BUILD_DIR)/$(TARGET) ./$(BUILD_DIR)/
	docker cp temp-extract:/app/$(BUILD_DIR)/$(TARGET)-debug ./$(BUILD_DIR)/
	docker rm temp-extract
	@echo "✅ Build complete!"
	@echo "   Release: ./$(BUILD_DIR)/$(TARGET)"
	@echo "   Debug:   ./$(BUILD_DIR)/$(TARGET)-debug"

# Run the release version locally
run: docker-build
	./$(BUILD_DIR)/$(TARGET)

# Run the debug version locally  
run-debug: docker-build
	./$(BUILD_DIR)/$(TARGET)-debug

# Run in Docker container (release)
docker-run:
	docker run --rm $(IMAGE_NAME)

# Run in Docker container (debug version)
docker-run-debug:
	docker run --rm $(IMAGE_NAME) sh -c "./builds/$(TARGET)-debug"

# Interactive development shell
docker-shell:
	docker run --rm -it \
		-v $(PWD)/$(SOURCE_DIR):/app/$(SOURCE_DIR) \
		-v $(PWD)/$(BUILD_DIR):/app/$(BUILD_DIR) \
		$(IMAGE_NAME) bash

# Debug with GDB in container
docker-debug:
	docker run --rm -it \
		-v $(PWD)/$(SOURCE_DIR):/app/$(SOURCE_DIR) \
		-v $(PWD)/$(BUILD_DIR):/app/$(BUILD_DIR) \
		$(IMAGE_NAME) gdb ./builds/$(TARGET)-debug

# Run with docker-compose (release)
compose-run:
	docker-compose up --build cpp-app

# Run with docker-compose (debug shell)
compose-debug:
	docker-compose up --build cpp-app-debug

# Local build (if you have g++ installed)
local-build:
	mkdir -p $(BUILD_DIR)
	g++ -std=c++17 -Wall -O2 $(SOURCE_DIR)/$(APP_ENTRY) -o $(BUILD_DIR)/$(TARGET)

# Local debug build
local-debug:
	mkdir -p $(BUILD_DIR)
	g++ -std=c++17 -Wall -g -O0 $(SOURCE_DIR)/$(APP_ENTRY) -o $(BUILD_DIR)/$(TARGET)-debug

# Development mode - build and run locally
dev: local-build
	./$(BUILD_DIR)/$(TARGET)

# Clean everything - comprehensive cleanup including Docker
clean:
	@echo "🧹 Cleaning build artifacts..."
	rm -f $(BUILD_DIR)/$(TARGET) $(BUILD_DIR)/$(TARGET)-debug
	@echo "🐳 Cleaning Docker resources..."
	docker rmi $(IMAGE_NAME) 2>/dev/null || true
	docker-compose down 2>/dev/null || true
	@echo "🛑 Stopping all Docker containers..."
	docker stop $$(docker ps -aq) 2>/dev/null || true
	@echo "🗑️  Removing all Docker containers..."
	docker rm $$(docker ps -aq) 2>/dev/null || true
	@echo "🧹 Removing dangling images..."
	docker image prune -f 2>/dev/null || true
	@echo "📦 Removing unused volumes..."
	docker volume prune -f 2>/dev/null || true
	@echo "🌐 Removing unused networks..."
	docker network prune -f 2>/dev/null || true
	@echo "✅ Complete cleanup finished!"

# Show help
help:
	@echo "🚀 C++ Docker Development Commands:"
	@echo ""
	@echo "📦 Building:"
	@echo "  make              - Build Docker image and extract executables (default)"
	@echo "  make docker-build - Same as above"
	@echo "  make local-build  - Build locally (release)"
	@echo "  make local-debug  - Build locally (debug)"
	@echo ""
	@echo "▶️  Running:"
	@echo "  make run          - Run release version locally"
	@echo "  make run-debug    - Run debug version locally"
	@echo "  make dev          - Build and run locally"
	@echo ""
	@echo "🐳 Docker:"
	@echo "  make docker-run   - Run release in container"
	@echo "  make docker-run-debug - Run debug in container"
	@echo "  make docker-shell - Interactive shell in container"
	@echo "  make docker-debug - Debug with GDB in container"
	@echo ""
	@echo "🎼 Compose:"
	@echo "  make compose-run  - Run with docker-compose"
	@echo "  make compose-debug- Debug shell with docker-compose"
	@echo ""
	@echo "🧹 Cleanup:"
	@echo "  make clean        - Clean build artifacts and perform comprehensive Docker cleanup"

# Declare phony targets
.PHONY: all docker-build run run-debug docker-run docker-run-debug docker-shell docker-debug compose-run compose-debug local-build local-debug dev clean help

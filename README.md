# C++ Development with Docker

This project demonstrates a modern C++ development setup using Docker containers for building and running applications. The setup provides both Docker-based and local development workflows.

## Project Structure

```
todo/
├── src/                   # Source code directory
│   └── hello.cpp         # Main C++ source file
├── builds/               # Output directory for compiled executables
│   ├── hello            # Release version (optimized)
│   └── hello-debug      # Debug version (with symbols)
├── .vscode/              # VS Code configuration
│   ├── tasks.json       # Build and run tasks
│   ├── launch.json      # Debug configuration
│   └── c_cpp_properties.json # IntelliSense settings
├── Dockerfile           # Unified Docker configuration
├── docker-compose.yml   # Docker Compose configuration
├── build.sh            # Build script
├── Makefile            # Simplified build automation
├── .dockerignore       # Docker ignore file
└── README.md           # This file
```

## Prerequisites

### For Docker-based Development (Recommended)

- Docker installed on your system
- Docker Compose (usually included with Docker)

### For Local Development

- Ubuntu Linux system or similar
- g++ compiler and build tools
- VS Code with C++ extensions

## Quick Start

### Option 1: One Command Build

```bash
# Build both debug and release versions with one command
make

# Run release version
./builds/hello

# Run debug version
./builds/hello-debug
```

### Option 2: Interactive Development

```bash
# Open interactive shell in container with all dev tools
make docker-shell

# Debug with GDB in container
make docker-debug
```

### Option 3: Docker Compose

```bash
# Build and run with docker-compose
make compose-run

# Interactive debug shell with docker-compose
make compose-debug
```

## Installation Guide

### Docker Installation (Ubuntu)

```bash
# Update package index
sudo apt update

# Install prerequisites
sudo apt install apt-transport-https ca-certificates curl software-properties-common

# Add Docker's GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker
sudo apt update
sudo apt install docker-ce

# Add user to docker group (optional, to run without sudo)
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
```

### Local C++ Development Setup (Optional)

```bash
# Install build essentials and debugger
sudo apt update
sudo apt install build-essential gdb

# Verify installation
g++ --version
gdb --version
```

**Note:** If you don't have `gdb` installed, you can still build and run the program, but VS Code debugging won't work. Use the "C++ Run (No Debug)" configuration in that case.

### VS Code Extensions

Install these extensions for the best development experience:

1. **C/C++** (ms-vscode.cpptools)
2. **C/C++ Extension Pack** (ms-vscode.cpptools-extension-pack)
3. **Docker** (ms-azuretools.vscode-docker)

## Build Methods

### 1. Makefile Commands

```bash
# Show all available commands
make help

# Production builds
make                    # Build with Docker (default)
make docker-build       # Build production Docker image
make docker-run         # Run in production container

# Development builds (with debugging tools)
make docker-build-dev   # Build development image with GDB, Valgrind, etc.
make docker-dev         # Run development container interactively
make compose-dev        # Run development setup with docker-compose

# Local development
make dev               # Build and run locally
make local-build       # Build locally only

# Container orchestration
make compose-run       # Run with docker-compose (production)

# Cleanup
make clean            # Clean all artifacts and images
make docker-purge     # Nuclear option: stop and remove ALL Docker containers/images/volumes
```

### 2. VS Code Tasks

Use `Ctrl+Shift+P` → "Tasks: Run Task" and choose:

- **Docker Build** - Build the application in Docker
- **Docker Build and Extract** - Build and copy executable to local builds/
- **Docker Run** - Run the application in Docker
- **Local Build (Development)** - Build locally for debugging
- **Run Local Build** - Build and run locally

### 3. Manual Docker Commands

```bash
# Build Docker image
docker build -t hello-world-cpp .

# Run in Docker container
docker run --rm hello-world-cpp

# Copy executable from container to local builds/
docker create --name temp-container hello-world-cpp
docker cp temp-container:/app/builds/hello ./builds/
docker rm temp-container
```

### 4. Build Script

```bash
# Use the automated build script
./build.sh
```

## Development Workflows

### Docker-First Development

1. Edit source files in `src/`
2. Build with Docker: `make docker-build`
3. Test locally: `./builds/hello`
4. For debugging: Use local build and VS Code debugger

### Local Development

1. Edit source files in `src/`
2. Build locally: `make local-build` or `make dev`
3. Debug with VS Code: Press `F5`

### Container Development

1. Edit source files in `src/`
2. Test in container: `make docker-run`
3. For production: Use `docker-compose up`

## Debugging

### Local Debugging with VS Code

1. Use the "Local Build (Development)" task to build with debug symbols
2. Set breakpoints in VS Code
3. Press `F5` to start debugging
4. Use the "C++ Debug (Local)" configuration

### Debug Controls

- `F5` - Start/Continue
- `F10` - Step over
- `F11` - Step into
- `Shift+F11` - Step out
- `Shift+F5` - Stop

## Container Details

### Unified Dockerfile Features

- **Base**: Ubuntu 22.04 for stability
- **Build Tools**: build-essential, g++, make for compilation
- **Debugging**: GDB for interactive debugging, Valgrind for memory analysis
- **Editors**: Vim, Nano for in-container editing
- **Dual Builds**: Creates both optimized (-O2) and debug (-g -O0) versions
- **Clean Design**: Single Dockerfile handles all use cases

### Docker Compose Features

- **cpp-app**: Runs the optimized release version
- **cpp-app-debug**: Interactive shell for development and debugging
- **Volume Mounting**: Live sync of source code and build artifacts
- **Flexible Commands**: Easy switching between run modes

### Container Workflows

```bash
# Quick build and test
make docker-build && ./builds/hello

# Interactive development
make docker-shell   # Full shell access with all tools

# Debugging session
make docker-debug   # Direct GDB access

# Memory analysis
make docker-shell
# Inside container:
valgrind ./builds/hello
```

# Inside container, you can:

gdb ./builds/hello-debug # Debug with GDB
valgrind ./builds/hello # Check for memory leaks
strace ./builds/hello # Trace system calls

````

## Troubleshooting

### Docker Issues

1. **Permission denied**: Add user to docker group

   ```bash
   sudo usermod -aG docker $USER
   # Log out and back in
````

2. **Build fails**: Check Docker daemon is running

   ```bash
   sudo systemctl status docker
   sudo systemctl start docker
   ```

3. **Out of space**: Clean Docker images
   ```bash
   docker system prune
   ```

### Build Issues

1. **g++ not found locally**: Install build-essential

   ```bash
   sudo apt install build-essential
   ```

2. **VS Code debugging not working**: Install GDB debugger

   ```bash
   sudo apt install gdb
   ```

   If you can't install GDB, use the "C++ Run (No Debug)" configuration instead.

3. **VS Code IntelliSense issues**: Reload window
   ```bash
   Ctrl+Shift+P → "Developer: Reload Window"
   ```

## Sample Output

When you run the application, you should see:

```
hello world
```

## Next Steps

- Add more C++ source files to `src/`
- Implement CMake for complex build systems
- Set up CI/CD with GitHub Actions using Docker
- Add unit testing framework
- Explore multi-stage Docker builds for smaller production images

Happy coding! 🚀

### 4. Configure VS Code for C++ Development

#### 4.1 Create VS Code Configuration Files

The project includes configuration files in the `.vscode` directory:

- `tasks.json` - Build configuration
- `launch.json` - Debug configuration
- `c_cpp_properties.json` - IntelliSense configuration

#### 4.2 Compiler Configuration

The setup uses `g++` with the following default settings:

- C++17 standard
- Debug symbols enabled
- All warnings enabled

### 5. Building and Running the Program

#### Option 1: Using VS Code Tasks

1. Open the project in VS Code
2. Press `Ctrl+Shift+P` to open Command Palette
3. Type "Tasks: Run Task" and select it
4. Choose "Build C++" to compile
5. Choose "Run C++" to execute

#### Option 2: Using Terminal

```bash
# Compile the program
g++ -std=c++17 -Wall -g -o hello hello.cpp

# Run the program
./hello
```

#### Option 3: Using Code Runner Extension

1. Open `hello.cpp` in VS Code
2. Press `Ctrl+Alt+N` or right-click and select "Run Code"

#### Option 4: Using Makefile

```bash
# Build the program
make

# Build and run the program
make run

# Clean build artifacts
make clean
```

### 6. Debugging

#### Set up debugging:

1. Open `hello.cpp` in VS Code
2. Set a breakpoint by clicking in the gutter next to line numbers
3. Press `F5` or go to Run → Start Debugging
4. Choose "C++ (GDB/LLDB)" if prompted
5. The debugger will start and stop at your breakpoints

#### Debug controls:

- `F5` - Start/Continue debugging
- `F10` - Step over
- `F11` - Step into
- `Shift+F11` - Step out
- `Shift+F5` - Stop debugging

### 7. Project Structure

```
todo/
├── hello.cpp              # Main C++ source file
├── hello                  # Compiled executable (created after build)
├── Makefile              # Build automation file
├── README.md              # This file
└── .vscode/
    ├── tasks.json         # Build tasks configuration
    ├── launch.json        # Debug configuration
    └── c_cpp_properties.json # IntelliSense configuration
```

### 8. Useful VS Code Shortcuts for C++

- `Ctrl+Shift+P` - Command Palette
- `Ctrl+Shift+B` - Build (run build task)
- `F5` - Start debugging
- `Ctrl+F5` - Run without debugging
- `Ctrl+Alt+N` - Run code (Code Runner extension)
- `Ctrl+Shift+X` - Extensions view
- ` Ctrl+``  ` - Open integrated terminal

### 9. Troubleshooting

#### Common Issues:

1. **"g++ not found"**

   ```bash
   sudo apt update
   sudo apt install build-essential
   ```

2. **IntelliSense not working**

   - Make sure C/C++ extension is installed
   - Check `c_cpp_properties.json` configuration
   - Reload VS Code window (`Ctrl+Shift+P` → "Developer: Reload Window")

3. **Debugging not working**
   - Ensure `gdb` is installed: `sudo apt install gdb`
   - Check `launch.json` configuration
   - Make sure program is compiled with debug symbols (`-g` flag)

### 10. Next Steps

Now you have a complete C++ development environment! You can:

- Create more complex C++ programs
- Use external libraries
- Set up CMake for larger projects
- Explore advanced debugging features
- Install additional extensions like GitLens, Bracket Pair Colorizer, etc.

## Sample Output

When you run the hello world program, you should see:

```
hello world
```

Happy coding! 🚀

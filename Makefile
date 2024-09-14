.PHONY: all build clean install-deps test crun srun dist help

# Project Variables
SERVER_BIN_NAME = server
CLIENT_BIN_NAME = client
SRC_DIR = cmd
BUILD_DIR = build

# Detect OS and architecture
OS ?= $(shell go env GOOS)
ARCH ?= $(shell go env GOARCH)

# Binary suffixes for different platforms
ifeq ($(OS),Windows_NT)
    OS_SUFFIX = .exe
else
    OS_SUFFIX = 
endif

SERVER_BIN = $(BUILD_DIR)/$(SERVER_BIN_NAME)$(OS_SUFFIX)
CLIENT_BIN = $(BUILD_DIR)/$(CLIENT_BIN_NAME)$(OS_SUFFIX)

# Default: Build the project
all: install-deps build

# Build for the current OS and architecture
build:
	@echo "Building for detected system: $(OS)/$(ARCH)..."
	@go build -o $(SERVER_BIN) $(SRC_DIR)/server/main.go
	@go build -o $(CLIENT_BIN) $(SRC_DIR)/client/main.go

# Test the project (Optional: Add your Go/C tests here)
test:
	@echo "Running tests..."
	@go test ./...

# Clean up built binaries
clean:
	@echo "Cleaning up..."
	@rm -f $(BUILD_DIR)/*

# Install dependencies for Go, C/C++, and Python
install-deps:
	@echo "Installing dependencies..."
	@go mod tidy
	# Add additional dependencies if needed

# Rebuild the project from scratch
rebuild: clean all

# Compile and run the client binary for the detected OS/architecture
crun:
	@echo "Building and running client binary for detected system: $(OS)/$(ARCH)..."
	@go build -o $(CLIENT_BIN) $(SRC_DIR)/client/main.go
	@echo "Running client binary..."
	@./$(CLIENT_BIN)

# Compile and run the server binary for the detected OS/architecture
srun:
	@echo "Building and running server binary for detected system: $(OS)/$(ARCH)..."
	@go build -o $(SERVER_BIN) $(SRC_DIR)/server/main.go
	@echo "Running server binary..."
	@./$(SERVER_BIN)

# Create a zip archive of binaries for distribution
dist: all
	@echo "Creating distribution archive..."
	@zip -r $(BUILD_DIR)/backdoor_dist.zip $(BUILD_DIR)/*

# Help menu to list all available commands
help:
	@echo "Available commands:"
	@echo "  make all          - Install deps and build binaries for detected platform"
	@echo "  make build        - Build the project for the detected platform"
	@echo "  make clean        - Clean up build artifacts"
	@echo "  make rebuild      - Clean and build again"
	@echo "  make test         - Run tests"
	@echo "  make crun         - Build and run the client binary"
	@echo "  make srun         - Build and run the server binary"
	@echo "  make dist         - Package binaries into a zip archive"
	@echo "  make install-deps - Install Go and other dependencies"

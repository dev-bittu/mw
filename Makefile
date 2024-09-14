.PHONY: *

# Project Variables
BINARY_NAME = backdoor
SRC_DIR = src
BUILD_DIR = build
GOOS_LIST = windows linux darwin
GOARCH_LIST = amd64 arm64

# Cross-compilation targets
WINDOWS_BIN = $(BUILD_DIR)/$(BINARY_NAME)_windows.exe
LINUX_BIN = $(BUILD_DIR)/$(BINARY_NAME)_linux
MACOS_BIN = $(BUILD_DIR)/$(BINARY_NAME)_macos

# Default: Compile for all platforms
all: install-deps build-windows build-linux build-macos

# Build for Windows
build-windows:
	@echo "Building for Windows..."
	GOOS=windows GOARCH=amd64 go build -o $(WINDOWS_BIN) $(SRC_DIR)/main.go

# Build for Linux
build-linux:
	@echo "Building for Linux..."
	GOOS=linux GOARCH=amd64 go build -o $(LINUX_BIN) $(SRC_DIR)/main.go

# Build for macOS
build-macos:
	@echo "Building for macOS..."
	GOOS=darwin GOARCH=amd64 go build -o $(MACOS_BIN) $(SRC_DIR)/main.go

# Test the project (Optional: Add your Go/C tests here)
test:
	@echo "Running tests..."
	go test ./...

# Clean up built binaries
clean:
	@echo "Cleaning up..."
	rm -f $(WINDOWS_BIN) $(LINUX_BIN) $(MACOS_BIN)

# Install dependencies for Go, C/C++, and Python
install-deps:
	@echo "Installing dependencies..."
	go mod tidy
	sudo apt-get install gcc g++ python3 python3-pip -y

# Rebuild the project from scratch
rebuild: clean all

# Run the Windows binary (for testing)
run-windows: build-windows
	./$(WINDOWS_BIN)

# Run the Linux binary (for testing)
run-linux: build-linux
	./$(LINUX_BIN)

# Run the macOS binary (for testing)
run-macos: build-macos
	./$(MACOS_BIN)

# Run all binaries (for multi-platform testing)
run-all: run-windows run-linux run-macos

# Create a zip archive of binaries for distribution
dist: all
	@echo "Creating distribution archive..."
	zip -r $(BUILD_DIR)/$(BINARY_NAME)_dist.zip $(BUILD_DIR)/*

# Help menu to list all available commands
help:
	@echo "Available commands:"
	@echo "  make all            - Build binaries for all platforms"
	@echo "  make build-windows  - Build Windows binary"
	@echo "  make build-linux    - Build Linux binary"
	@echo "  make build-macos    - Build macOS binary"
	@echo "  make clean          - Clean up build artifacts"
	@echo "  make rebuild        - Clean and build again"
	@echo "  make test           - Run tests"
	@echo "  make run-windows    - Run Windows binary"
	@echo "  make run-linux      - Run Linux binary"
	@echo "  make run-macos      - Run macOS binary"
	@echo "  make run-all        - Run binaries for all platforms"
	@echo "  make dist           - Package binaries into a zip archive"
	@echo "  make install-deps   - Install Go, C/C++ and Python dependencies"

.PHONY: all build-windows build-linux build-macos clean install-deps test run-windows run-linux run-macos dist help

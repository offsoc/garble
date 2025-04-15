# Makefile to build garble for multiple platforms

# Define the output directory
OUTPUT_DIR := ./bin

# Go binary name
BINARY := garble

# List of target OS and architectures
TARGETS := linux/amd64 linux/arm64 darwin/amd64 darwin/arm64 windows/amd64

# Default target
all: build

# Build targets for all platforms
build: $(addprefix $(OUTPUT_DIR)/$(BINARY)_,$(TARGETS))

# Target for each OS/arch
$(OUTPUT_DIR)/$(BINARY)_%: 
	@echo "Building $@ for GOOS=$(word 1,$^) and GOARCH=$(word 2,$^) ..."
	GOOS=$(word 1,$^) GOARCH=$(word 2,$^) go build -o $@ $(BINARY)

# Compile garble for a specific target if not already installed
$(BINARY):
	@echo "Installing garble..."
	# Check if garble is installed, if not install it
	if ! command -v garble &>/dev/null; then \
		go install mvdan.cc/garble@latest; \
	fi

# Clean up generated files
clean:
	@echo "Cleaning up generated binaries..."
	rm -rf $(OUTPUT_DIR)/*
	@echo "Cleaned up $(OUTPUT_DIR)"

# Create bin directory if it doesn't exist
$(OUTPUT_DIR):
	@echo "Creating output directory $(OUTPUT_DIR)..."
	mkdir -p $(OUTPUT_DIR)

# Print all targets
print-targets:
	@echo "Available targets: $(TARGETS)"

.PHONY: all build clean $(OUTPUT_DIR) print-targets

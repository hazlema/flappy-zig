#!/bin/bash

# Flappy Bird Build Script
# Usage: ./build.sh [--debug]

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
BUILD_MODE="ReleaseFast"
if [ "$1" == "--debug" ]; then
    BUILD_MODE="Debug"
    echo -e "${YELLOW}Building in Debug mode...${NC}"
else
    echo -e "${GREEN}Building optimized release builds...${NC}"
fi

# Create dist directory
mkdir -p dist

# Build for Linux x64
echo -e "${BLUE}Building for Linux (x86_64)...${NC}"
zig build -Doptimize=$BUILD_MODE 2>&1 | grep -v "warning(link): unexpected LLD stderr" | grep -v "is neither ET_REL nor LLVM bitcode" | grep -v "ld.lld: warning:" || true

if [ -f "zig-out/bin/flappy" ]; then
    cp zig-out/bin/flappy dist/flappy-linux-x64
    cp -r assets dist/
    SIZE=$(ls -lh dist/flappy-linux-x64 | awk '{print $5}')
    echo -e "${GREEN}✓ Linux build complete: ${SIZE}${NC}"
else
    echo -e "${RED}✗ Linux build failed${NC}"
    exit 1
fi

# Build for Windows x64
echo -e "${BLUE}Building for Windows (x86_64)...${NC}"
zig build -Doptimize=$BUILD_MODE -Dtarget=x86_64-windows 2>&1 | grep -v "warning(link): unexpected LLD stderr" | grep -v "is neither ET_REL nor LLVM bitcode" | grep -v "lld-link: warning:" || true

if [ -f "zig-out/bin/flappy.exe" ]; then
    cp zig-out/bin/flappy.exe dist/flappy-windows-x64.exe
    SIZE=$(ls -lh dist/flappy-windows-x64.exe | awk '{print $5}')
    echo -e "${GREEN}✓ Windows build complete: ${SIZE}${NC}"
else
    echo -e "${RED}✗ Windows build failed${NC}"
    exit 1
fi

# Summary
echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Build Summary${NC}"
echo -e "${GREEN}================================${NC}"
echo -e "Mode: ${YELLOW}$BUILD_MODE${NC}"
echo -e "Output directory: ${BLUE}dist/${NC}"
echo ""
ls -lh dist/ | grep -v "^total" | grep -v "^d"
echo ""
echo -e "${GREEN}To run:${NC}"
echo -e "  Linux:   ${BLUE}cd dist && ./flappy-linux-x64${NC}"
echo -e "  Windows: ${BLUE}Copy dist/flappy-windows-x64.exe and dist/assets/ to Windows${NC}"

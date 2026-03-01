#!/bin/bash

echo "Testing Neovim Nix wrapper..."

# Test that we can build
echo "1. Building Nix package..."
nix build -f ./default.nix -o test-result

# Test that the wrapper exists
if [ -f "test-result/bin/nvim" ]; then
    echo "✓ Wrapper script exists"
else
    echo "✗ Wrapper script missing"
    exit 1
fi

# Test that we can run neovim with --version
echo "2. Testing Neovim version..."
VERSION_OUTPUT=$(./test-result/bin/nvim --version 2>&1)
if echo "$VERSION_OUTPUT" | grep -q "NVIM"; then
    echo "✓ Neovim version command works"
    echo "  Version: $(echo "$VERSION_OUTPUT" | head -1)"
else
    echo "✗ Neovim version command failed"
    exit 1
fi

# Test basic functionality
echo "3. Testing basic Neovim functionality..."
echo 'echo "test"' | ./test-result/bin/nvim -u ~/.config/nvim/init.lua -c 'qall!' > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ Basic Neovim functionality works"
else
    echo "✗ Basic Neovim functionality failed"
    exit 1
fi

echo "All tests passed! ✓"
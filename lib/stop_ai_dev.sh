#!/bin/bash
# Stop AI Development Environment

echo "Stopping AI environment..."
if [[ "$OS" == "linux" ]]; then
    sudo systemctl stop ollama
elif [[ "$OS" == "mac" ]]; then
    brew services stop ollama
fi
echo "Stopped"

#!/bin/bash
# Start AI Development Environment

echo "Starting AI Development Environment..."
echo "Model: $RECOMMENDED_MODEL"
echo "Hardware: $(if [[ "$HAS_NVIDIA" == true ]]; then echo "NVIDIA GPU"; elif [[ "$HAS_AMD" == true ]]; then echo "AMD GPU"; else echo "CPU"; fi)"
echo ""

# Start Ollama if not running
if ! curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "Starting Ollama..."
    if [[ "$OS" == "linux" ]]; then
        sudo systemctl start ollama
    elif [[ "$OS" == "mac" ]]; then
        brew services start ollama
    else
        echo "Please start Ollama manually"
    fi
    sleep 3
fi

# Check models
echo "Available models:"
ollama list

echo ""
echo "AI environment is ready!"
echo "Open VS Code and use Ctrl+L to start Continue"
echo ""

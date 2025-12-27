#!/bin/bash
# Complete AI Development Setup Script

set -e

echo "=== AI Development Environment Setup ==="
echo ""

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="mac"
elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    OS="windows"
else
    OS="unknown"
fi

echo "Detected OS: $OS"
echo ""

# Function to detect hardware
detect_hardware() {
    echo "=== Hardware Detection ==="
    
    # Detect GPU
    if command -v nvidia-smi &> /dev/null; then
        echo "NVIDIA GPU detected"
        GPU_VRAM=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | head -1)
        echo "VRAM: $((GPU_VRAM / 1024))GB"
        HAS_NVIDIA=true
    elif command -v rocm-smi &> /dev/null; then
        echo "AMD GPU detected"
        HAS_AMD=true
    else
        echo "No dedicated GPU detected"
        HAS_GPU=false
    fi
    
    # Detect CPU
    CPU_CORES=$(nproc)
    echo "CPU Cores: $CPU_CORES"
    
    # Detect RAM
    if [[ "$OS" == "linux" ]]; then
        TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
    elif [[ "$OS" == "mac" ]]; then
        TOTAL_RAM=$(sysctl -n hw.memsize | awk '{print int($1/1073741824)}')
    else
        TOTAL_RAM=16  # Default assumption
    fi
    echo "Total RAM: ${TOTAL_RAM}GB"
    
    # Recommend model based on hardware
    recommend_model
}

recommend_model() {
    echo ""
    echo "=== Model Recommendation ==="
    
    if [[ "$HAS_NVIDIA" == true ]]; then
        if [[ $GPU_VRAM -ge 16000 ]]; then
            echo "Recommended: Qwen2.5-Coder-32B (Q4_K_M) or CodeLlama-34B (Q4_K_M)"
            RECOMMENDED_MODEL="qwen2.5-coder:32b"
        elif [[ $GPU_VRAM -ge 8000 ]]; then
            echo "Recommended: Qwen2.5-Coder-14B (Q4_K_M) or DeepSeek-Coder-16B (Q4_K_M)"
            RECOMMENDED_MODEL="qwen2.5-coder:14b"
        elif [[ $GPU_VRAM -ge 6000 ]]; then
            echo "Recommended: Qwen2.5-Coder-7B (Q4_K_M) or Llama-3.1-8B (Q4_K_M)"
            RECOMMENDED_MODEL="qwen2.5-coder:7b"
        elif [[ $GPU_VRAM -ge 4000 ]]; then
            echo "Recommended: Qwen2.5-Coder-1.5B (Q8_0) or Phi-3-mini-4k (Q8_0)"
            RECOMMENDED_MODEL="qwen2.5-coder:1.5b"
        else
            echo "Recommended: Phi-2 (Q8_0) or TinyLlama (Q8_0)"
            RECOMMENDED_MODEL="phi-2"
        fi
    elif [[ "$HAS_AMD" == true ]]; then
        echo "Recommended: Qwen2.5-7B (Q4_K_M) - good AMD support"
        RECOMMENDED_MODEL="qwen2.5:7b"
    else
        if [[ $TOTAL_RAM -ge 32 ]]; then
            echo "Recommended: Qwen2.5-7B (Q4_K_M) - CPU inference"
            RECOMMENDED_MODEL="qwen2.5:7b:q4_0"
        elif [[ $TOTAL_RAM -ge 16 ]]; then
            echo "Recommended: Llama-3.1-8B (Q4_K_M) or Phi-3-mini (Q4_K_M)"
            RECOMMENDED_MODEL="llama3.1:8b:q4_0"
        elif [[ $TOTAL_RAM -ge 8 ]]; then
            echo "Recommended: Qwen2.5-Coder-1.5B (Q8_0)"
            RECOMMENDED_MODEL="qwen2.5-coder:1.5b:q8_0"
        else
            echo "Recommended: Phi-2 (Q4_0) - minimal requirements"
            RECOMMENDED_MODEL="phi-2:q4_0"
        fi
    fi
    
    echo "Selected model: $RECOMMENDED_MODEL"
}

# Install Ollama
install_ollama() {
    echo ""
    echo "=== Installing Ollama ==="
    
    if [[ "$OS" == "linux" ]]; then
        curl -fsSL https://ollama.com/install.sh | sh
        
        # Enable GPU support if available
        if [[ "$HAS_NVIDIA" == true ]]; then
            echo "Enabling NVIDIA CUDA support..."
            export OLLAMA_CUDA=1
        elif [[ "$HAS_AMD" == true ]]; then
            echo "Enabling AMD ROCm support..."
            export OLLAMA_ROCM=1
        fi
        
    elif [[ "$OS" == "mac" ]]; then
        brew install ollama
    elif [[ "$OS" == "windows" ]]; then
        echo "Please download Ollama from https://ollama.com/download/windows"
        read -p "Press Enter after installation..."
    fi
    
    # Start Ollama service
    if [[ "$OS" == "linux" ]]; then
        sudo systemctl enable ollama
        sudo systemctl start ollama
    elif [[ "$OS" == "mac" ]]; then
        brew services start ollama
    fi
    
    sleep 3
    echo "Ollama installed successfully"
}

# Configure Ollama
configure_ollama() {
    echo ""
    echo "=== Configuring Ollama ==="
    
    # Create config directory
    mkdir -p ~/.ollama
    
    # Create optimized config
    cat > ~/.ollama/config.json << EOF
{
    "host": "127.0.0.1",
    "port": 11434,
    $(if [[ "$HAS_NVIDIA" == true ]] || [[ "$HAS_AMD" == true ]]; then echo '"gpu": true,'; else echo '"gpu": false,'; fi)
    "num_parallel": 1,
    "max_loaded_models": 2,
    "num_thread": $CPU_CORES,
    "num_ctx": 4096,
    "environment_variables": {
        $(if [[ "$HAS_NVIDIA" == true ]]; then echo '"OLLAMA_CUDA": "1",'; fi)
        $(if [[ "$HAS_AMD" == true ]]; then echo '"OLLAMA_ROCM": "1",'; fi)
        "OLLAMA_NUM_THREADS": "$CPU_CORES",
        "OLLAMA_MAX_MEMORY": "$((TOTAL_RAM * 1024))"
    }
}
EOF
    
    echo "Ollama configured"
}

# Pull recommended model
pull_model() {
    echo ""
    echo "=== Downloading Model ==="
    echo "This may take several minutes depending on model size..."
    
    ollama pull $RECOMMENDED_MODEL
    
    # Also pull a small model for autocomplete
    ollama pull qwen2.5-coder:1.5b
    
    echo "Models downloaded successfully"
}

# Install VS Code extension
install_vscode_extension() {
    echo ""
    echo "=== Installing VS Code Extension ==="
    
    if command -v code &> /dev/null; then
        code --install-extension continue.continue
    else
        echo "VS Code not found or 'code' command not in PATH"
        echo "Please install Continue extension manually from marketplace"
    fi
}

# Configure Continue
configure_continue() {
    echo ""
    echo "=== Configuring Continue ==="
    
    mkdir -p ~/.continue
    
    # Create config based on hardware
    cat > ~/.continue/config.yaml << EOF
name: AI Development Environment
version: 1.0.0
schema: v1

models:
  - name: Primary-Coder
    provider: ollama
    model: $(echo $RECOMMENDED_MODEL | cut -d':' -f1-2)
    apiBase: http://localhost:11434
    contextLength: 4096
    roles:
      - chat
      - edit
      - apply
    completionOptions:
      temperature: 0.2
      topP: 0.95
      maxTokens: 2048

  - name: Fast-Autocomplete
    provider: ollama
    model: qwen2.5-coder:1.5b
    apiBase: http://localhost:11434
    roles:
      - autocomplete
    completionOptions:
      temperature: 0.1
      maxTokens: 128

  - name: Embeddings
    provider: ollama
    model: nomic-embed-text:latest
    apiBase: http://localhost:11434
    roles:
      - embed

defaultModel: Primary-Coder
tabAutocompleteModel: Fast-Autocomplete

systemMessage: |
  You are an AI programming assistant running locally.
  Help with coding, debugging, and development tasks.
  Provide concise, accurate, and practical solutions.

slashCommands:
  - name: explain
    description: Explain the selected code
  - name: refactor
    description: Refactor the selected code
  - name: debug
    description: Debug the selected code
  - name: test
    description: Write tests for the selected code
  - name: optimize
    description: Optimize the selected code

allowAnonymousTelemetry: false
EOF
    
    echo "Continue configured"
}

# Create startup script
create_startup_script() {
    echo ""
    echo "=== Creating Startup Script ==="
    
    cat > ~/start_ai_dev.sh << EOF
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
EOF
    
    chmod +x ~/start_ai_dev.sh
    
    # Create stop script
    cat > ~/stop_ai_dev.sh << EOF
#!/bin/bash
# Stop AI Development Environment

echo "Stopping AI environment..."
if [[ "$OS" == "linux" ]]; then
    sudo systemctl stop ollama
elif [[ "$OS" == "mac" ]]; then
    brew services stop ollama
fi
echo "Stopped"
EOF
    
    chmod +x ~/stop_ai_dev.sh
}

# Create performance monitoring script
create_monitoring_script() {
    cat > ~/monitor_ai.sh << 'EOF'
#!/bin/bash
# Monitor AI Development Environment

echo "=== AI Environment Monitor ==="
echo ""

# Check Ollama
echo "Ollama Status:"
if curl -s http://localhost:11434/api/tags > /dev/null; then
    echo "✓ Running"
    echo "Models:"
    curl -s http://localhost:11434/api/tags | jq -r '.models[].name' | while read model; do
        echo "  - $model"
    done
else
    echo "✗ Not running"
fi

echo ""

# Check GPU if available
if command -v nvidia-smi &> /dev/null; then
    echo "GPU Usage:"
    nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv
elif command -v rocm-smi &> /dev/null; then
    echo "GPU Usage:"
    rocm-smi --showuse
fi

echo ""

# Check memory
echo "System Memory:"
free -h

echo ""

# Check processes
echo "AI Processes:"
ps aux | grep -E "(ollama|continue)" | grep -v grep
EOF
    
    chmod +x ~/monitor_ai.sh
}

# Main execution
main() {
    detect_hardware
    install_ollama
    configure_ollama
    pull_model
    install_vscode_extension
    configure_continue
    create_startup_script
    create_monitoring_script
    
    echo ""
    echo "=== Setup Complete ==="
    echo ""
    echo "Next steps:"
    echo "1. Run: ~/start_ai_dev.sh"
    echo "2. Open VS Code"
    echo "3. Press Ctrl+L to open Continue"
    echo "4. Start coding with AI assistance!"
    echo ""
    echo "Monitor with: ~/monitor_ai.sh"
    echo "Stop with: ~/stop_ai_dev.sh"
    echo ""
}

# Run main function
main "$@"

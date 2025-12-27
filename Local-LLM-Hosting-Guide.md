# Researched & Written By "Hamza Ali"

Full Stack Web & App Developer with an interest in AI (limited only by the tech hardware at hand)

Total time spent implementing + researching this setup: ~26+ hours

# Complete Offline AI Development Setup Guide

Run modern LLMs locally (offline) and connect them to VS Code for real developer workflows.

This guide is designed to be copy-paste friendly and **ready to publish**: every script/config referenced below is already included in this repository under [`lib/`](./lib/).

## Who This Is For

- Developers who want a private, offline coding assistant.
- Anyone who wants a simple local setup (Ollama / LM Studio) or a more advanced one (Text Generation WebUI).

## What You Get In This Repo

- A complete, hardware-aware setup script: [`lib/setup_ai_dev.sh`](./lib/setup_ai_dev.sh)
- Ready-to-use configs (Ollama, Continue, VS Code, WebUI): see the full list in [Repository Layout](#repository-layout)
- Optional helper scripts (monitoring, CPU-only hosting, quick setup)

## Quickstart

### Windows (recommended path)

1. Install Ollama (Windows installer):
   - https://ollama.com/download/windows
2. Verify Ollama is reachable (PowerShell):
   - `ollama --version`
   - `curl http://localhost:11434/api/tags`
3. Pull a starter model:
   - `ollama pull qwen2.5-coder:7b`
4. Quick local inference smoke test:
   - `ollama run qwen2.5-coder:7b "Write a hello world in Python"`
5. Install VS Code extension:
   - Continue (continue.continue)
6. Point Continue to your local backend:
   - Use the config in [`lib/continue-config.yaml`](./lib/continue-config.yaml)
7. First workflow inside VS Code (recommended):
   - Open a project
   - Use Continue Chat to ask for a plan
   - Use Continue Edit/Apply for focused changes
   - Keep your model server local (default) for privacy

### Linux (fast path)

1. Install Ollama:
   - `curl -fsSL https://ollama.com/install.sh | sh`
2. Start Ollama and verify:
   - `ollama --version`
   - `curl http://localhost:11434/api/tags`
3. Pull a model:
   - `ollama pull qwen2.5-coder:7b`
4. Quick local inference smoke test:
   - `ollama run qwen2.5-coder:7b "Explain what this repo does in 3 bullet points"`
5. Optional: run the full setup script (creates helper scripts under `~/`):
   - See [`lib/setup_ai_dev.sh`](./lib/setup_ai_dev.sh)
6. Use the scripts/configs from [`lib/`](./lib/) as described below.

## Repository Layout

All code snippets referenced in this guide are included under [`lib/`](./lib/):

- **Continue config**: [`lib/continue-config.yaml`](./lib/continue-config.yaml)
- **Continue environments**:
  - [`lib/development.yaml`](./lib/development.yaml)
  - [`lib/code-review.yaml`](./lib/code-review.yaml)
- **VS Code settings**: [`lib/vscode-settings.json`](./lib/vscode-settings.json)
- **Ollama config**: [`lib/ollama-config.json`](./lib/ollama-config.json)
- **Ollama GPU config**: [`lib/gpu-config.json`](./lib/gpu-config.json)
- **Text Generation WebUI config**: [`lib/text-generation-webui-config.yaml`](./lib/text-generation-webui-config.yaml)
- **Systemd service**: [`lib/ollama.service`](./lib/ollama.service)
- **Master setup script**: [`lib/setup_ai_dev.sh`](./lib/setup_ai_dev.sh)
- **CPU-only hosting script**: [`lib/start_cpu_model.sh`](./lib/start_cpu_model.sh)
- **Optimization script**: [`lib/optimize.sh`](./lib/optimize.sh)
- **Monitoring script**: [`lib/monitor_ai.sh`](./lib/monitor_ai.sh)
- **Quick install script**: [`lib/quick_ai_setup.sh`](./lib/quick_ai_setup.sh)
- **Start/Stop helpers**:
  - [`lib/start_ai_dev.sh`](./lib/start_ai_dev.sh)
  - [`lib/stop_ai_dev.sh`](./lib/stop_ai_dev.sh)

## Security & Privacy Notes

- This workflow can be run **fully offline** after downloading models.
- Treat local model servers as sensitive:
  - Keep Ollama bound to localhost unless you explicitly need LAN access.
  - Avoid exposing `:11434` (Ollama) or `:1234` (LM Studio) to the public internet.
- Be mindful of what you paste:
  - Local models won’t “phone home”, but anything you paste is still stored in your editor history, terminal history, and potentially in Continue session history.

## Publishing Checklist (Recommended)

- Add screenshots (VS Code + Continue panel, Ollama running, model list).
- Add a LICENSE file (MIT/Apache-2.0 are common).
- Add a short CONTRIBUTING guide (how to report issues + what logs to include).
- Consider adding a “known-good models” list for specific VRAM/RAM tiers.

## Table of Contents
1. [Understanding Your Options](#understanding-your-options)
2. [Hardware Requirements & Model Selection](#hardware-requirements--model-selection)
3. [Installation: Ollama](#installation-ollama)
4. [Installation: LM Studio](#installation-lm-studio)
5. [Installation: Text Generation WebUI](#installation-text-generation-webui)
6. [Model Hosting: GPU vs CPU+RAM](#model-hosting-gpu-vs-cpuram)
7. [VS Code Integration](#vs-code-integration)
8. [Complete Configuration Files](#complete-configuration-files)
9. [Troubleshooting](#troubleshooting)
10. [Performance Optimization](#performance-optimization)
11. [FAQ](#faq)
12. [Contributing](#contributing)
13. [License](#license)

---

## Understanding Your Options

### **Ollama**
**Best for:** Easy setup, CLI enthusiasts, automatic GPU detection
**Pros:** Simple commands, good performance, large model library
**Cons:** Less control over advanced settings

### **LM Studio**
**Best for:** Beginners, Windows/Mac users, GUI lovers
**Pros:** Beautiful interface, one-click install, model marketplace
**Cons:** Windows/Mac only, heavier on resources

### **Text Generation WebUI (oobabooga)**
**Best for:** Advanced users, researchers, maximum control
**Pros:** Most features, extensions, quantization options
**Cons:** Complex setup, requires technical knowledge

### **Continue (VS Code Extension)**
**Best for:** Developers, pair programming, coding-specific tasks
**Pros:** Direct VS Code integration, understands context
**Cons:** Needs backend (Ollama/LM Studio) to run models

---

## Hardware Requirements & Model Selection

### **Choosing Based on Your Hardware**

| Hardware | Recommended Model Size | Examples | Expected Speed |
|----------|----------------------|----------|----------------|
| **4GB VRAM** | 3B-7B quantized | Qwen2.5-Coder 1.5B, Phi-3-mini | 10-30 tokens/sec |
| **6GB VRAM** | 7B-13B 4-bit | Llama 3.1 8B, Qwen2.5:7b | 15-40 tokens/sec |
| **8GB VRAM** | 13B-20B 4-bit | CodeLlama 13B, DeepSeek-Coder 16B | 20-50 tokens/sec |
| **12GB+ VRAM** | 34B 4-bit/7B 16-bit | CodeLlama 34B, Qwen2:32B | 10-30 tokens/sec |
| **CPU Only** | 1B-3B | Phi-2, TinyLlama | 1-5 tokens/sec |
| **CPU+RAM** | 7B 4-bit | Qwen2.5:7b (Q4_K_M) | 2-8 tokens/sec |

### **Model Selection Factors**

#### **1. Purpose-Based Selection**
- **Coding & Development:**
  - Qwen2.5-Coder (1.5B, 7B, 14B, 32B)
  - CodeLlama (7B, 13B, 34B)
  - DeepSeek-Coder (1.3B, 6.7B, 33B)
  - StarCoder2 (3B, 7B, 15B)

- **General Chat & Reasoning:**
  - Llama 3.1 (8B, 70B, 405B)
  - Qwen2.5 (0.5B, 1.5B, 7B, 14B, 32B, 72B)
  - Phi-3 (3.8B, 7B, 14B)

- **Multilingual:**
  - Qwen2.5 (Chinese optimized)
  - Llama (multiple languages)
  - Mistral (European languages)

#### **2. Quantization Levels (Quality vs Speed)**
```
Q2_K (62% size) - Fastest, lowest quality
Q3_K_M (75% size) - Good balance
Q4_K_M (100% size) - Recommended default
Q5_K_M (125% size) - Better quality
Q6_K (150% size) - Near original quality
Q8_0 (175% size) - Almost lossless
```

#### **3. Performance vs Quality Matrix**
```
Small RAM/VRAM: 1.5B-3B models (Phi-2, TinyLlama)
Balanced: 7B models 4-bit (Qwen2.5:7b-Q4_K_M)
Quality Focus: 13B models 4-bit (CodeLlama-13B-Q4_K_M)
High End: 34B+ models 4-bit or 7B models 8-bit
```

### **Quick Selection Guide**

**For Most Developers:**
```bash
# If you have 8GB+ VRAM:
ollama pull qwen2.5-coder:7b  # Best coding model

# If you have 4-8GB VRAM:
ollama pull qwen2.5-coder:1.5b  # Fast, decent for code

# If CPU only with 16GB+ RAM:
ollama pull phi-2:3.8b  # Very efficient

# If you want general purpose:
ollama pull llama3.1:8b  # Good all-around
```

---

## Installation: Ollama

### **1. Download & Install**

**Linux:**
```bash
curl -fsSL https://ollama.com/install.sh | sh

# Or manual install:
sudo curl -L https://ollama.com/download/ollama-linux-amd64 -o /usr/local/bin/ollama
sudo chmod +x /usr/local/bin/ollama
ollama serve &
```

**Windows:**
- Download from https://ollama.com/download/windows
- Run installer
- Ollama will start automatically in background

**macOS:**
```bash
brew install ollama
ollama serve &
```

### **2. Post-Installation Setup**

```bash
# Verify installation
ollama --version

# Create systemd service (Linux)
sudo tee /etc/systemd/system/ollama.service << EOF
[Unit]
Description=Ollama Service
After=network-online.target

[Service]
Type=simple
User=$USER
Group=$USER
ExecStart=/usr/local/bin/ollama serve
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable ollama
sudo systemctl start ollama
```

### **3. Basic Ollama Commands**

```bash
# List available models
ollama list

# Pull a model
ollama pull qwen2.5:7b

# Run a model interactively
ollama run qwen2.5:7b

# Pull with specific quantization
ollama pull qwen2.5:7b:q4_0  # 4-bit quantization

# List all available versions
ollama show qwen2.5:7b --modelfile

# Remove a model
ollama rm qwen2.5:7b
```

### **4. Ollama Configuration File**

Create `~/.ollama/config.json`:

Repo copy: [`lib/ollama-config.json`](./lib/ollama-config.json)

```json
{
  "host": "127.0.0.1",
  "port": 11434,
  "gpu": true,
  "num_gpu": 1,
  "num_thread": 4,
  "num_ctx": 4096,
  "models": "/home/$USER/.ollama/models",
  "environment_variables": {
    "OLLAMA_NUM_PARALLEL": "1",
    "OLLAMA_MAX_LOADED_MODELS": "2"
  }
}
```

---

## Installation: LM Studio

### **1. Download & Install**

**Windows/macOS only:**
1. Download from https://lmstudio.ai/
2. Run installer
3. Launch LM Studio

### **2. Configuration**

**Settings to adjust:**
1. **Model Path:** Set where models are stored
2. **GPU Layers:** Set based on VRAM (see table below)
3. **Context Length:** 4096 for 7B models, 8192 for larger
4. **Threads:** CPU core count for CPU inference

**VRAM to GPU Layers mapping:**
```
4GB VRAM: 20-25 layers (7B model)
6GB VRAM: 30-35 layers (7B model)
8GB VRAM: 40-45 layers (7B model) or all layers (13B 4-bit)
12GB+ VRAM: All layers for 13B, most for 34B 4-bit
```

### **3. Using LM Studio**

1. **Download Models:** Search in "Discover" tab
2. **Load Model:** Click on model card
3. **Chat Interface:** Right tab for conversations
4. **Local Server:** Enable in settings for VS Code integration
5. **API Server:** Runs on http://localhost:1234

---

## Installation: Text Generation WebUI

### **1. One-Click Installers**

**Windows:**
```powershell
# Download from https://github.com/oobabooga/text-generation-webui
# Run start_windows.bat

# Or using PowerShell:
iex (irm https://codeberg.org/api/v1/repos/oobabooga/text-generation-webui/raw/one_click_installer/oobabooga_windows.ps1)
```

**Linux:**
```bash
# One-line installer
curl -sSL https://raw.githubusercontent.com/oobabooga/text-generation-webui/main/start_linux.sh | bash

# Or manual install
git clone https://github.com/oobabooga/text-generation-webui
cd text-generation-webui
./start_linux.sh
```

### **2. Configuration**

Create `~/.text-generation-webui/config.yaml`:

Repo copy: [`lib/text-generation-webui-config.yaml`](./lib/text-generation-webui-config.yaml)

```yaml
# Model loading
loader: ExLlamaV2
model_dir: /home/$USER/models
max_seq_len: 4096
compress_pos_emb: 1.0

# GPU settings
gpu_memory_0: 6144  # VRAM in MB for first GPU
cpu_memory: 8192    # RAM in MB for offloading
n_gpu_layers: 40    # Layers on GPU (adjust based on VRAM)

# Performance
threads: 8
batch_size: 8
```

---

## Model Hosting: GPU vs CPU+RAM

### **GPU Hosting (Recommended)**

#### **NVIDIA GPU Setup:**
```bash
# Check GPU info
nvidia-smi

# Install CUDA for Ollama
curl -fsSL https://ollama.com/install.sh | OLLAMA_CUDA=1 sh

# Or manually enable CUDA
export OLLAMA_CUDA=1
ollama serve
```

#### **AMD GPU Setup:**
```bash
# Install ROCm for Ollama
curl -fsSL https://ollama.com/install.sh | OLLAMA_ROCM=1 sh

# Verify
export HIP_VISIBLE_DEVICES=0
ollama serve
```

#### **GPU Configuration File:**
Create `~/.ollama/gpu_config.json`:

Repo copy: [`lib/gpu-config.json`](./lib/gpu-config.json)

```json
{
  "nvidia": {
    "visible_devices": "0",
    "memory_limit": "6144MiB",
    "compute_capability": "7.5"
  },
  "amd": {
    "visible_devices": "0",
    "memory_limit": "6144MiB",
    "gpu_type": "rx6700xt"
  },
  "cuda": {
    "version": "12.1",
    "arch": "sm_75"
  }
}
```

### **CPU+RAM Hosting (No GPU)**

#### **1. System Requirements:**
- **Minimum:** 8GB RAM for 1.5B models
- **Recommended:** 16GB RAM for 7B models
- **Good:** 32GB RAM for 13B models
- **Excellent:** 64GB+ RAM for 34B models

#### **2. CPU Optimization:**

```bash
# Check CPU capabilities
lscpu | grep -E "Model name|CPU\(s\)|Thread|MHz"

# For Intel CPUs with AVX2/AVX512
export OLLAMA_CPU_ARCH=avx2

# Set thread count (usually physical cores)
export OLLAMA_NUM_THREADS=8
export OMP_NUM_THREADS=8

# Memory allocation
export OLLAMA_MAX_MEMORY=16384  # 16GB in MB
```

#### **3. CPU-Specific Model Quantization:**
```bash
# Pull CPU-optimized models
ollama pull qwen2.5:7b:q4_0  # 4-bit, fastest on CPU
ollama pull llama3.1:8b:q3_K_M  # 3.5-bit, good balance
ollama pull phi-2:2.7b:q8_0  # 8-bit, highest quality for small models
```

#### **4. CPU Hosting Script:**
Create `start_cpu_model.sh`:

Repo copy: [`lib/start_cpu_model.sh`](./lib/start_cpu_model.sh)

```bash
#!/bin/bash
# CPU-optimized model hosting

MODEL="qwen2.5:7b"
QUANT="q4_0"  # Best for CPU
THREADS=$(nproc)
MEMORY="16384"  # 16GB in MB

# Set environment variables
export OLLAMA_NUM_THREADS=$THREADS
export OLLAMA_MAX_MEMORY=$MEMORY
export OMP_NUM_THREADS=$THREADS
export GGML_NVML_LIB=""

# For Intel CPUs
export OLLAMA_CPU_ARCH="avx2"

# For Apple Silicon
# export OLLAMA_CPU_ARCH="arm64"

echo "Starting $MODEL with $QUANT quantization"
echo "Threads: $THREADS"
echo "Memory: $(($MEMORY/1024))GB"

# Pull model if not exists
ollama pull $MODEL:$QUANT

# Run with CPU optimization
ollama run $MODEL:$QUANT
```

#### **5. RAM Disk Setup (For Faster Inference):**

```bash
# Create RAM disk (Linux)
sudo mkdir /mnt/ramdisk
sudo mount -t tmpfs -o size=12G tmpfs /mnt/ramdisk

# Use RAM disk for model caching
export OLLAMA_MODELS="/mnt/ramdisk/models"
ollama serve
```

#### **6. CPU vs GPU Performance Comparison:**

| Model | GPU (RTX 3060) | CPU (i7-12700K) | RAM Usage |
|-------|----------------|-----------------|-----------|
| Qwen2.5 1.5B | 50-80 t/s | 8-12 t/s | 4GB |
| Qwen2.5 7B Q4 | 30-50 t/s | 3-6 t/s | 8GB |
| Llama 3.1 8B Q4 | 25-40 t/s | 2-4 t/s | 10GB |
| CodeLlama 13B Q4 | 15-25 t/s | 1-2 t/s | 16GB |

---

## VS Code Integration

### **1. Install Continue Extension**

```bash
# Method 1: VS Code Marketplace
# Search for "Continue" by Continue.dev

# Method 2: Via command line
code --install-extension continue.continue
```

### **2. Complete Continue Configuration**

Create `~/.continue/config.yaml`:

Repo copy: [`lib/continue-config.yaml`](./lib/continue-config.yaml)

```yaml
name: AI Development Workspace
version: 1.0.0
schema: v1

# Model Configuration
models:
  - name: Qwen2.5-Coder-7B
    provider: ollama
    model: qwen2.5-coder:7b
    apiBase: http://localhost:11434
    contextLength: 8192
    roles:
      - chat
      - edit
      - apply
    completionOptions:
      temperature: 0.2
      topP: 0.95
      topK: 40
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

  - name: General-Chat
    provider: ollama
    model: llama3.1:8b
    apiBase: http://localhost:11434
    roles:
      - chat
    completionOptions:
      temperature: 0.7

  - name: Embeddings
    provider: ollama
    model: nomic-embed-text:latest
    apiBase: http://localhost:11434
    roles:
      - embed

# Model Selection
defaultModel: Qwen2.5-Coder-7B
tabAutocompleteModel: Fast-Autocomplete

# System Prompt
systemMessage: |
  You are Qwen2.5 Coder 7B, an AI programming assistant running locally via Ollama.
  You help with coding tasks, debugging, code review, and explanations.
  
  Guidelines:
  1. Provide concise, accurate code solutions
  2. Explain your reasoning when helpful
  3. Write clean, efficient, well-documented code
  4. Consider edge cases and error handling
  5. Suggest improvements and alternatives

# Slash Commands
slashCommands:
  - name: explain
    description: Explain the selected code
    prompt: Explain this code in detail. What does it do? How does it work?

  - name: refactor
    description: Refactor the selected code
    prompt: Refactor this code to be more efficient, readable, and maintainable.

  - name: debug
    description: Debug the selected code
    prompt: Find and fix bugs in this code. Explain what was wrong.

  - name: test
    description: Write tests for the selected code
    prompt: Write comprehensive unit tests for this code.

  - name: document
    description: Add documentation
    prompt: Add comprehensive documentation and comments to this code.

  - name: optimize
    description: Optimize performance
    prompt: Optimize this code for better performance and memory usage.

# Context Providers
contextProviders:
  - name: file
    params:
      maxChars: 10000
  - name: terminal
    params:
      maxOutputLength: 2000
  - name: diff
  - name: http
  - name: database

# UI Settings
ui:
  theme: dark
  fontSize: 14
  showFileTree: true
  autoScroll: true

# Experimental Features
experimental:
  disableSessionTitles: false
  enableCodebaseIndexing: true
  enableVoiceCommands: false

# Telemetry (Optional)
allowAnonymousTelemetry: false
```

### **3. Alternative: LM Studio Integration**

If using LM Studio instead of Ollama:

```yaml
models:
  - name: Local-Coder
    provider: openai
    model: local-model
    apiBase: http://localhost:1234/v1
    apiKey: "not-needed"
    contextLength: 4096
    roles:
      - chat
      - edit
      - apply
```

### **4. Environment-Specific Configs**

Create `~/.continue/environments/`:

Repo copies:
- [`lib/development.yaml`](./lib/development.yaml)
- [`lib/code-review.yaml`](./lib/code-review.yaml)

**`development.yaml`:**
```yaml
models:
  - name: Development-Assistant
    provider: ollama
    model: qwen2.5-coder:7b
    systemMessage: |
      You are helping with active development.
      Focus on implementation, debugging, and testing.
```

**`code-review.yaml`:**
```yaml
models:
  - name: Code-Reviewer
    provider: ollama
    model: codellama:13b
    systemMessage: |
      You are a senior code reviewer.
      Focus on code quality, security, and best practices.
```

### **5. VS Code Settings Integration**

Add to your VS Code `settings.json`:

Repo copy: [`lib/vscode-settings.json`](./lib/vscode-settings.json)

```jsonc
{
  "continue.useConfigFile": true,
  "continue.configPath": "/home/$USER/.continue/config.yaml",
  "continue.showTerminal": true,
  "continue.enableTabAutocomplete": true,
  "continue.tabAutocompleteDelay": 300,
  "continue.maxPromptLength": 12000,
  "continue.enableCodebaseIndexing": true,
  "continue.codebaseIndexingDirectory": "/home/$USER/projects",
  
  // Keybindings
  "continue.keybindings": {
    "toggleContinue": "ctrl+l",
    "focusContinueInput": "ctrl+i",
    "acceptAutocomplete": "tab",
    "toggleAutocomplete": "ctrl+space"
  }
}
```

---

## Complete Configuration Files

### **1. Master Configuration Script**

Create `setup_ai_dev.sh`:

Repo copy: [`lib/setup_ai_dev.sh`](./lib/setup_ai_dev.sh)

```bash
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
```

### **2. Quick Install Script (Simplified)**

Create `quick_ai_setup.sh`:

Repo copy: [`lib/quick_ai_setup.sh`](./lib/quick_ai_setup.sh)

```bash
#!/bin/bash
# Quick AI Setup for Development

echo "Installing AI development environment..."

# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Pull optimal model based on system
if [[ $(free -g | awk '/^Mem:/{print $2}') -ge 16 ]]; then
    MODEL="qwen2.5-coder:7b"
else
    MODEL="qwen2.5-coder:1.5b"
fi

echo "Downloading $MODEL..."
ollama pull $MODEL
ollama pull nomic-embed-text

# Create Continue config
mkdir -p ~/.continue
cat > ~/.continue/config.yaml << 'EOF'
models:
  - name: Local-Coder
    provider: ollama
    model: qwen2.5-coder:7b
    apiBase: http://localhost:11434
    roles:
      - chat
      - edit
      - apply

defaultModel: Local-Coder
EOF

echo ""
echo "Installation complete!"
echo "1. Start Ollama: ollama serve"
echo "2. Install 'Continue' extension in VS Code"
echo "3. Press Ctrl+L in VS Code to start"
```

---

## Troubleshooting

### **Common Issues & Solutions**

#### **1. Ollama Won't Start**
```bash
# Check if port is in use
sudo lsof -i :11434

# Kill existing process
pkill ollama

# Start fresh
ollama serve

# Check logs
journalctl -u ollama -f  # Linux
brew services logs ollama  # Mac
```

#### **2. Model Not Loading**
```bash
# Check disk space
df -h ~/.ollama

# Clear corrupted model
ollama rm <model-name>
ollama pull <model-name>

# Check model file
ls -la ~/.ollama/models/
```

#### **3. Slow Performance**
```bash
# GPU not being used
export OLLAMA_CUDA=1  # NVIDIA
export OLLAMA_ROCM=1  # AMD

# Check GPU utilization
nvidia-smi  # NVIDIA
rocm-smi    # AMD

# Increase priority
sudo nice -n -10 ollama serve
```

#### **4. Out of Memory**
```bash
# Reduce context length
export OLLAMA_NUM_CTX=2048

# Use smaller model
ollama pull qwen2.5-coder:1.5b

# Adjust quantization
ollama pull <model>:q4_0  # More memory efficient
```

#### **5. Continue Not Connecting**
```bash
# Test Ollama API
curl http://localhost:11434/api/tags

# Check Continue config
cat ~/.continue/config.yaml

# Restart VS Code
code --disable-extension continue.continue
code --enable-extension continue.continue
```

---

## Performance Optimization

### **GPU Optimization**

```bash
# NVIDIA-specific optimizations
export CUDA_VISIBLE_DEVICES=0
export OLLAMA_CUDA=1
export OLLAMA_GPU_LAYERS=35  # Adjust based on VRAM

# AMD-specific optimizations
export HIP_VISIBLE_DEVICES=0
export OLLAMA_ROCM=1
export OLLAMA_GPU_LAYERS=30
```

### **CPU Optimization**

```bash
# Set thread affinity
export OMP_NUM_THREADS=$(nproc)
export OLLAMA_NUM_THREADS=$(nproc)

# Enable AVX512 if available
export OLLAMA_CPU_ARCH=avx512

# Memory optimization
export OLLAMA_MAX_MEMORY=$(( $(free -m | awk '/^Mem:/{print $7}') * 9 / 10 ))
```

### **Model-Specific Optimizations**

Create `~/.ollama/optimize.sh`:

Repo copy: [`lib/optimize.sh`](./lib/optimize.sh)

```bash
#!/bin/bash
# Model optimization script

MODEL=$1
QUANT=$2

case $MODEL in
    "qwen2.5-coder:7b")
        # Optimal for coding
        export OLLAMA_NUM_CTX=8192
        export OLLAMA_TEMPERATURE=0.2
        ;;
    "llama3.1:8b")
        # Optimal for general chat
        export OLLAMA_NUM_CTX=4096
        export OLLAMA_TEMPERATURE=0.7
        ;;
    *)
        # Default
        export OLLAMA_NUM_CTX=4096
        export OLLAMA_TEMPERATURE=0.5
        ;;
esac

# Run with optimizations
ollama run $MODEL
```

---

## Final Checklist

✅ **Installation Complete:**
- [ ] Ollama/LM Studio installed
- [ ] Model downloaded based on hardware
- [ ] VS Code Continue extension installed
- [ ] Configuration files created
- [ ] Startup scripts created

✅ **Testing:**
- [ ] Ollama responds: `curl http://localhost:11434/api/tags`
- [ ] Model loads: `ollama run <model>`
- [ ] Continue works in VS Code: `Ctrl+L`
- [ ] Autocomplete works in editor

✅ **Optimization:**
- [ ] GPU/CPU properly detected
- [ ] Memory allocation optimized
- [ ] Quantization level appropriate
- [ ] Context length set correctly

---

## Quick Reference Commands

```bash
# Start everything
~/start_ai_dev.sh

# Monitor
~/monitor_ai.sh

# Pull new model
ollama pull <model>:<quantization>

# Switch model in Continue
# Type `/model` in Continue chat

# Check performance
nvidia-smi  # GPU
htop        # CPU/RAM

# Update everything
ollama --version
code --list-extensions | grep continue
```

This comprehensive guide provides everything needed for a complete offline AI development environment. The scripts and configurations are designed to work across different hardware setups and automatically optimize for your specific system.

---

## FAQ

### Which model should I start with?

- If you have **8GB+ VRAM**: `qwen2.5-coder:7b`
- If you have **4–8GB VRAM**: `qwen2.5-coder:1.5b`
- If you’re **CPU-only**: start small (Phi/TinyLlama) and use quantized variants.

### What does “quantization” mean?

Quantization reduces model size (and RAM/VRAM usage) by storing weights with fewer bits.

- Lower-bit (Q2/Q3): faster + smaller, lower quality
- Mid (Q4): best default for most local setups
- Higher (Q6/Q8): best quality, more memory

### Why can’t Continue connect to Ollama?

- Ensure Ollama is running: `curl http://localhost:11434/api/tags`
- Confirm the correct API base in Continue config:
  - `http://localhost:11434`
- Restart VS Code after config changes.

### Should I expose my local model server to the network?

Not by default. Keep it on localhost unless you know what you’re doing.
If you need LAN access, restrict it with firewall rules and avoid exposing it to the public internet.

## Contributing

Contributions are welcome.

- **Bug reports**: include OS, GPU (if any), model name/quantization, and the exact command/output.
- **Docs improvements**: PRs that clarify platform differences (Windows vs Linux vs macOS) are especially helpful.
- **New models / configs**: include rationale (VRAM/RAM target) and sane defaults.

## License

Choose a license and add it to the repository (common choices: MIT, Apache-2.0).

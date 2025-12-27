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

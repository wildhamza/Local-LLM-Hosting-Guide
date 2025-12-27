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

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

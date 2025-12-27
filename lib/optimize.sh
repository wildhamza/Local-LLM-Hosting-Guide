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

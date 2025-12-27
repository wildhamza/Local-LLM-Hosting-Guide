# Local LLM Hosting Guide (Offline AI Dev)

[![License](https://img.shields.io/github/license/wildhamza/Local-LLM-Hosting-Guide)](./LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/wildhamza/Local-LLM-Hosting-Guide)](../../commits/main)
[![Repo Size](https://img.shields.io/github/repo-size/wildhamza/Local-LLM-Hosting-Guide)](../../)

Researched & written by **Hamza Ali** — Full Stack Web & App Developer with an interest in AI (limited only by the tech hardware at hand).

This repo is a practical, copy-paste friendly guide for running modern LLMs locally (offline) and connecting them to VS Code for real developer workflows.

- Full guide: [`Local-LLM-Hosting-Guide.md`](./Local-LLM-Hosting-Guide.md)
- Ready-to-use scripts/configs: [`lib/`](./lib/)

## My Configuration (Author)

- **CPU**: Intel i5-12400F
- **RAM**: 32GB DDR5 @ 6000MHz
- **GPU**: NVIDIA RTX 3060 12GB
- **OS**: Arch Linux (wrapper: Omarchy)

### Experimental GPU/RAM Offload Tweak (Not Included Yet)

I’m also experimenting with a tweak on Arch + NVIDIA drivers that attempts to make the system RAM behave more like “available VRAM” for large model loading.

- **Goal**: run larger models than a strict 12GB VRAM limit would normally allow
- **Tradeoff**: lower throughput / slower inference (it helps fit models, but it costs speed)
- **Status**: not mature or optimized yet, so it’s intentionally **not included in this repo**

I’ll keep iterating on this and share a cleaner, reproducible approach once it’s stable.

## What This Repo Helps You Do

- Run local models with **Ollama** (fastest/cleanest default)
- Optionally use **LM Studio** (great Windows GUI) or **Text Generation WebUI** (advanced control)
- Connect everything to **VS Code** using **Continue**
- Choose models based on your hardware (GPU vs CPU+RAM, quantization)

## Quickstart

### Windows (fastest path)

1. Install Ollama:
   - https://ollama.com/download/windows
2. Verify it works:
   - `ollama --version`
   - `curl http://localhost:11434/api/tags`
3. Pull a starter model:
   - `ollama pull qwen2.5-coder:7b`
4. Install VS Code extension:
   - Continue (continue.continue)
5. Configure Continue:
   - Use [`lib/continue-config.yaml`](./lib/continue-config.yaml) as your base

### Linux

1. Install Ollama:

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

2. Verify and pull a model:

```bash
curl http://localhost:11434/api/tags
ollama pull qwen2.5-coder:7b
```

3. Optional full setup automation:
- See [`lib/setup_ai_dev.sh`](./lib/setup_ai_dev.sh)

## Repo Layout

Everything you need is already included under [`lib/`](./lib/):

- Continue:
  - [`lib/continue-config.yaml`](./lib/continue-config.yaml)
  - [`lib/development.yaml`](./lib/development.yaml)
  - [`lib/code-review.yaml`](./lib/code-review.yaml)
- VS Code:
  - [`lib/vscode-settings.json`](./lib/vscode-settings.json)
- Ollama:
  - [`lib/ollama-config.json`](./lib/ollama-config.json)
  - [`lib/gpu-config.json`](./lib/gpu-config.json)
  - [`lib/ollama.service`](./lib/ollama.service)
- Scripts:
  - [`lib/setup_ai_dev.sh`](./lib/setup_ai_dev.sh)
  - [`lib/quick_ai_setup.sh`](./lib/quick_ai_setup.sh)
  - [`lib/start_cpu_model.sh`](./lib/start_cpu_model.sh)
  - [`lib/optimize.sh`](./lib/optimize.sh)
  - [`lib/monitor_ai.sh`](./lib/monitor_ai.sh)
  - [`lib/start_ai_dev.sh`](./lib/start_ai_dev.sh)
  - [`lib/stop_ai_dev.sh`](./lib/stop_ai_dev.sh)
- Text Generation WebUI:
  - [`lib/text-generation-webui-config.yaml`](./lib/text-generation-webui-config.yaml)

## Where to Start

If you only do one thing:
- Read the full guide: [`Local-LLM-Hosting-Guide.md`](./Local-LLM-Hosting-Guide.md)

## License

Apache-2.0 — see [`LICENSE`](./LICENSE).

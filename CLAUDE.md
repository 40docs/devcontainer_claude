# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Docker setup for running Claude Code in a containerized Ubuntu 24.04 development environment with remote access.

## Commands

```bash
# Pull from registry
docker pull ghcr.io/40docs/devcontainer_claude:latest

# Run the container
docker run -d --name claude-dev -p 2222:22 -p 7681:7681 ghcr.io/40docs/devcontainer_claude:latest

# Build locally
docker build -t devcontainer_claude .

# Stop/remove
docker rm -f claude-dev
```

## Architecture

- **Dockerfile**: Ubuntu 24.04 image with:
  - Non-root `dev` user (UID 1000) with sudo access
  - Zsh + Oh My Zsh + Starship prompt
  - Node.js 22, Python 3
  - Terraform, AWS CLI, Azure CLI
  - Claude Code installed globally via npm
  - SSH server and ttyd for remote access

- **startup.sh**: Entrypoint that starts sshd in background, then runs ttyd in foreground

- **config/**: User dotfiles (vimrc, zshrc, starship.toml)

## Key Design Decisions

- No volume mounts required - container is self-contained
- API keys set via `export` inside the container after connecting
- ttyd runs in foreground as main process for container lifecycle
- Host ports: 2222 (SSH), 7681 (web terminal)

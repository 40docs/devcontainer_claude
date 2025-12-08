# Claude Code Container

A production-ready Docker container for running Claude Code with a full development environment.

## Features

- **Base**: Ubuntu 24.04 with UTF-8 locale
- **User**: Non-root `dev` user with sudo access
- **Shell**: Zsh with Oh My Zsh + Starship prompt
- **Languages**: Node.js 22 LTS, Python 3, Rust, Go
- **Cloud Tools**: Terraform, AWS CLI, Azure CLI
- **Remote Access**: SSH (port 22) and ttyd web terminal (port 7681)

## Quick Start

### Build

```bash
docker build -t claude-code .
```

### Run

```bash
docker run -d --name claude-dev -p 2222:22 -p 7681:7681 claude-code
```

### Connect

**Web Terminal** (easiest):
```
http://localhost:7681
```

**SSH**:
```bash
ssh -p 2222 dev@localhost
```

### Use Claude Code

Once connected to the container:

```bash
export ANTHROPIC_API_KEY="your-api-key"
claude
```

## Ports

| Port | Service | Description |
|------|---------|-------------|
| 2222 | SSH | Secure shell access (mapped from container port 22) |
| 7681 | ttyd | Web-based terminal |

## Installed Tools

### Languages & Runtimes
- Node.js 22 LTS with npm
- Python 3 with pip and venv
- Rust (via rustup)
- Go 1.23

### Cloud & Infrastructure
- Terraform
- AWS CLI v2
- Azure CLI

### CLI Tools
- **Search**: ripgrep (`rg`), fd-find (`fdfind`), fzf
- **Editors**: neovim, vim
- **Utils**: git, curl, wget, jq, htop, tmux, tree

### Claude Code
- Installed globally via npm
- Run with `claude` command

## Container Management

```bash
# Stop
docker stop claude-dev

# Start again
docker start claude-dev

# Remove
docker rm -f claude-dev

# Rebuild after Dockerfile changes
docker build -t claude-code .
docker rm -f claude-dev
docker run -d --name claude-dev -p 2222:22 -p 7681:7681 claude-code
```

## Optional: Mount a project directory

If you want to work on files from your host:

```bash
docker run -d --name claude-dev \
  -p 2222:22 \
  -p 7681:7681 \
  -v /path/to/your/project:/home/dev/projects \
  claude-code
```

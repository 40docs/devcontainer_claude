# Claude Code Container

A production-ready Docker container for running Claude Code with a full development environment.

## Features

- **Base**: Ubuntu 24.04 with UTF-8 locale
- **User**: Non-root `dev` user with sudo access
- **Shell**: Zsh with Oh My Zsh + Starship prompt
- **Languages**: Node.js 22 LTS, Python 3
- **Cloud Tools**: Terraform, AWS CLI, Azure CLI
- **Remote Access**: SSH (port 22) and ttyd web terminal (port 7681)

## Quick Start

### Pull from registry

```bash
docker pull ghcr.io/40docs/devcontainer_claude:latest
```

### Run

```bash
docker run -d --name claude-dev -p 2222:22 -p 7681:7681 ghcr.io/40docs/devcontainer_claude:latest
```

### Build locally (optional)

```bash
docker build -t devcontainer_claude .
docker run -d --name claude-dev -p 2222:22 -p 7681:7681 devcontainer_claude
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

### Cloud & Infrastructure
- Terraform
- AWS CLI v2
- Azure CLI
- GitHub CLI (`gh`)

### CLI Tools
- **Search**: ripgrep (`rg`), fd-find (`fdfind`), fzf
- **Editors**: neovim, vim
- **Files**: eza (modern `ls` replacement with git integration)
- **Utils**: git, curl, wget, jq, htop, tmux, tree

### Claude Code
- Installed globally via npm
- Run with `claude` command

## Container Management

```bash
# List images
docker images

# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Stop
docker stop claude-dev

# Start again
docker start claude-dev

# Remove container
docker rm -f claude-dev

# Pull latest version
docker pull ghcr.io/40docs/devcontainer_claude:latest
```

## Optional: Enable SSH access

### 1. Generate an SSH key (if you don't have one)

```bash
ssh-keygen -t ed25519
```

Press Enter to accept defaults. This creates:
- `~/.ssh/id_ed25519` - your private key (keep secret)
- `~/.ssh/id_ed25519.pub` - your public key (safe to share)

### 2. Run container with your key mounted

```bash
docker run -d --name claude-dev \
  -p 2222:22 \
  -p 7681:7681 \
  -v ~/.ssh/id_ed25519.pub:/tmp/ssh_key:ro \
  ghcr.io/40docs/devcontainer_claude:latest
```

### 3. Connect

```bash
ssh -p 2222 dev@localhost
```

## Optional: Mount a project directory

If you want to work on files from your host:

```bash
docker run -d --name claude-dev \
  -p 2222:22 \
  -p 7681:7681 \
  -v /path/to/your/project:/home/dev/projects \
  ghcr.io/40docs/devcontainer_claude:latest
```

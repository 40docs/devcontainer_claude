# Claude Code Development Container
# Ubuntu 24.04 with development tools and remote access

FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set locale to UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install base packages and locale
RUN apt-get update && apt-get install -y \
    locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8

# Install development tools and utilities
RUN apt-get update && apt-get install -y \
    # Build essentials
    build-essential \
    pkg-config \
    cmake \
    # Version control
    git \
    # Network tools
    curl \
    wget \
    openssh-server \
    # CLI utilities
    jq \
    ripgrep \
    fd-find \
    fzf \
    htop \
    vim \
    neovim \
    tmux \
    unzip \
    zip \
    tree \
    less \
    # Shell
    zsh \
    # Python
    python3 \
    python3-pip \
    python3-venv \
    # SSL/TLS
    ca-certificates \
    gnupg \
    # sudo
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 22 LTS via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install starship prompt
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Install ttyd for web terminal
RUN curl -fsSL -o /tmp/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 \
    && chmod +x /tmp/ttyd \
    && mv /tmp/ttyd /usr/local/bin/ttyd

# Install Terraform
RUN curl -fsSL https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip -o /tmp/terraform.zip \
    && unzip /tmp/terraform.zip -d /tmp \
    && mv /tmp/terraform /usr/local/bin/terraform \
    && chmod +x /usr/local/bin/terraform \
    && rm /tmp/terraform.zip

# Install AWS CLI v2
RUN curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip \
    && unzip /tmp/awscliv2.zip -d /tmp \
    && /tmp/aws/install \
    && rm -rf /tmp/aws /tmp/awscliv2.zip

# Install Azure CLI
RUN curl -fsSL https://aka.ms/InstallAzureCLIDeb | bash

# Create non-root user with sudo access
RUN useradd -m -s /bin/zsh -G sudo dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/dev \
    && chmod 0440 /etc/sudoers.d/dev

# Configure SSH server
RUN mkdir -p /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
    && echo "AllowUsers dev" >> /etc/ssh/sshd_config

# Switch to dev user for user-specific installations
USER dev
WORKDIR /home/dev

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install zsh plugins
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Configure Git defaults
RUN git config --global init.defaultBranch main \
    && git config --global core.editor "nvim" \
    && git config --global pull.rebase false

# Install Rust toolchain
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/dev/.cargo/bin:${PATH}"

# Install Go
ENV GO_VERSION=1.23.4
RUN curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz \
    && sudo tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz
ENV PATH="/usr/local/go/bin:/home/dev/go/bin:${PATH}"
ENV GOPATH="/home/dev/go"

# Install Claude Code globally
RUN sudo npm install -g @anthropic-ai/claude-code

# Create projects directory
RUN mkdir -p /home/dev/projects

# Create .ssh directory with correct permissions
RUN mkdir -p /home/dev/.ssh \
    && chmod 700 /home/dev/.ssh

# Create starship config directory
RUN mkdir -p /home/dev/.config

# Copy config files
COPY --chown=dev:dev config/vimrc /home/dev/.vimrc
COPY --chown=dev:dev config/zshrc /home/dev/.zshrc
COPY --chown=dev:dev config/starship.toml /home/dev/.config/starship.toml

# Copy startup script
COPY --chown=dev:dev startup.sh /home/dev/startup.sh
RUN chmod +x /home/dev/startup.sh

# Expose ports
EXPOSE 22 7681

# Set working directory
WORKDIR /home/dev/projects

# Default command
CMD ["/home/dev/startup.sh"]

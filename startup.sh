#!/bin/bash
set -e

# Ensure SSH directory has correct permissions
chmod 700 /home/dev/.ssh

# Copy mounted SSH key to authorized_keys with correct permissions
# Mount your key to /tmp/ssh_key (e.g., -v ~/.ssh/id_ed25519.pub:/tmp/ssh_key:ro)
if [ -f /tmp/ssh_key ]; then
    cp /tmp/ssh_key /home/dev/.ssh/authorized_keys
    chown dev:dev /home/dev/.ssh/authorized_keys
    chmod 600 /home/dev/.ssh/authorized_keys
    echo "SSH key installed from /tmp/ssh_key"
fi

# Ensure history files exist and are writable
touch /home/dev/.zsh_history /home/dev/.bash_history 2>/dev/null || true
sudo chown dev:dev /home/dev/.zsh_history /home/dev/.bash_history 2>/dev/null || true

# Generate SSH host keys if they don't exist
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    sudo ssh-keygen -A
fi

# Start SSH daemon
echo "Starting SSH server on port 22..."
sudo /usr/sbin/sshd

# Start ttyd web terminal
echo "Starting ttyd web terminal on port 7681..."
echo "Web terminal available at: http://localhost:7681"
echo ""
echo "Claude Code container is ready!"
echo "  - SSH:   ssh -p 2222 dev@localhost"
echo "  - Web:   http://localhost:7681"
echo "  - Flask: http://localhost:5000 (when running)"
echo ""

# Run ttyd in foreground (keeps container running)
# -W: Allow write from clients
# -t: Set terminal options
exec ttyd -W -t fontSize=14 -t fontFamily="monospace" /bin/zsh

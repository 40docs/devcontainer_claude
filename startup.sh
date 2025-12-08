#!/bin/bash
set -e

# Ensure SSH directory has correct permissions
if [ -f /home/dev/.ssh/authorized_keys ]; then
    sudo chown dev:dev /home/dev/.ssh/authorized_keys 2>/dev/null || true
    chmod 600 /home/dev/.ssh/authorized_keys 2>/dev/null || true
fi
chmod 700 /home/dev/.ssh

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
echo "  - SSH:  ssh -p 2222 dev@localhost"
echo "  - Web:  http://localhost:7681"
echo ""

# Run ttyd in foreground (keeps container running)
# -W: Allow write from clients
# -t: Set terminal options
exec ttyd -W -t fontSize=14 -t fontFamily="monospace" /bin/zsh

# SSH and k3s Configuration

This repository documents the configuration of SSH access and k3s installation on a remote Ubuntu server.

## Overview

Configured secure SSH key-based authentication to a remote Ubuntu server and installed k3s lightweight Kubernetes distribution.

## Server Details

- **OS**: Ubuntu 24.04 LTS
- SSH key-based authentication configured

## SSH Configuration

### Key Generation

SSH key pair was generated for secure, passwordless authentication:
- **Key Type**: ED25519
- Keys stored in standard `~/.ssh/` directory

### Windows Host Configuration

SSH keys are stored in the standard location on Windows `~/.ssh/` directory.

### SSH Config Setup

Configured SSH client on Windows host to enable easy connection via hostname alias. SSH config file (`~/.ssh/config`) configured with:
- Host alias for easy connection
- IdentityFile pointing to private key
- IdentitiesOnly enabled
- StrictHostKeyChecking configured

### Key Security

1. **Private key permissions**: Set to read-only for the current user only (Windows file permissions secured using `icacls`)
2. **Key passphrase**: Private key is protected with a passphrase for additional security
3. **Key location**: Keys stored in standard `~/.ssh/` directory with proper permissions

### Connection

After configuration, connect to the server using the configured host alias.

The connection uses key-based authentication (no server password required), but prompts for the key passphrase for security.

## k3s Installation

k3s (lightweight Kubernetes) was installed on the remote Ubuntu server.

### Installation Method

k3s was installed using the official installation script:
```bash
curl -sfL https://get.k3s.io | sh -
```

Or for server node with explicit configuration:
```bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" sh -
```

### Prerequisites Installed

Before k3s installation, the following packages were installed on Ubuntu:
- `openssh-server` - SSH server daemon
- `openssh-client` - SSH client tools
- `curl` - For downloading k3s installer
- `wget` - Alternative download tool
- `git` - Version control
- `vim` - Text editor
- `net-tools` - Network utilities
- `iptables` - Firewall/networking rules
- `iproute2` - IP routing utilities
- `ca-certificates` - SSL certificates
- `gnupg` - GPG encryption
- `lsb-release` - Linux Standard Base release info
- `apt-transport-https` - HTTPS support for apt
- `containerd` - Container runtime (used by k3s)

### Firewall Configuration

For k3s to function properly, the following ports should be open:
- `6443/tcp` - Kubernetes API server
- `10250/tcp` - Kubelet API
- `8472/udp` - Flannel VXLAN
- `51820/udp` - Flannel Wireguard backend
- `51821/udp` - Flannel Wireguard backend

### Verification

Check k3s status on the server:
```bash
systemctl status k3s
```

Check kubeconfig location (default for k3s):
```bash
cat /etc/rancher/k3s/k3s.yaml
```

## Security Notes

1. **SSH Key Protection**: Private key is protected with a passphrase
2. **Key Permissions**: Private key has restrictive permissions (owner read-only)
3. **Key Location**: Keys stored in standard `~/.ssh/` directory
4. **Public Key**: Public key is deployed to `~/.ssh/authorized_keys` on the remote server with proper permissions (600)
5. **SSH Directory**: Remote server `.ssh` directory has 700 permissions

## Repository Structure

- `README.md` - This documentation file
- `install-ssh-k3s.sh` - Installation script for Ubuntu server prerequisites

## Next Steps

To use k3s from your Windows host:

1. Copy the k3s kubeconfig from the server:
   ```powershell
   scp <host-alias>:/etc/rancher/k3s/k3s.yaml .\k3s-config.yaml
   ```

2. Update the kubeconfig to use the server IP instead of localhost:
   ```powershell
   # Edit k3s-config.yaml and replace 127.0.0.1 with your server IP
   ```

3. Set KUBECONFIG environment variable:
   ```powershell
   $env:KUBECONFIG = "<path-to-k3s-config.yaml>"
   ```

4. Install kubectl on Windows if not already installed:
   ```powershell
   # Using Chocolatey
   choco install kubernetes-cli
   
   # Or download from: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
   ```

5. Verify connection:
   ```powershell
   kubectl get nodes
   ```

## Notes

- SSH keys were initially created in the repository directory but moved to `~/.ssh/` following best practices
- The private key passphrase adds an extra layer of security while maintaining passwordless server access
- k3s uses containerd as its container runtime by default
- k3s stores its configuration in `/etc/rancher/k3s/` on the server

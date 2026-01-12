# Home Lab – k3s Kubernetes

This repository contains my personal self-hosted DevOps home lab 

The lab runs a lightweight k3s cluster on Ubuntu 24.04 LTS and is managed remotely from a Windows host. The goal is hands-on experience with Kubernetes operations, security-conscious access, monitoring, and reproducible infrastructure without relying on cloud-managed services while having fun :)

---

## Overview

- Kubernetes Distribution: k3s
- Server OS: Ubuntu 24.04 LTS
- Management Host: Windows
- Container Runtime: containerd
- Access: SSH + kubectl

---

## Architecture

- Single-node k3s cluster (designed to scale)
- Remote management via SSH and kubectl
- Local configuration mapping to avoid cloud-synced directories

---

## Tooling

Windows host tools (via Chocolatey):

- git
- kubectl
- helm
- lens
- vscode

Common PowerShell aliases:

- k   -> kubectl
- hm  -> helm
- gcm -> git commit -m

---

## Repository Structure

- /bootstrap        Cluster bootstrap and setup scripts  
- /cluster/apps     General application manifests  -> tested with a simple nginx app
- /cluster/monitoring  Prometheus and Grafana (Helm)  -> needs to be done
- /cluster/plex     Media server with persistent storage  -> needs to be done

---

## Security

- ED25519 SSH key-based authentication
- Private key protected with a passphrase
- Restricted key permissions on both host and server
- Minimal firewall exposure (SSH + required k3s ports)

---

## Next Steps
- Deploy plex server
- Automate kubeconfig and SSH setup
- Deploy Prometheus and Grafana
- Define persistent volume strategy for Plex
- Expand to a multi-node cluster

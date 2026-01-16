# Terraform Configuration for Home Lab K3s

Provisions two Ubuntu worker VMs on Proxmox using cloud-init for the k3s Kubernetes cluster.

## What's Done ✅

- **Provider Setup**: Proxmox provider (v3.0.2-rc04) configured with API token authentication
- **VM Resources**: Two worker nodes (`control-01`, `worker-02`) defined as clones from ubuntu template` template
- **Configuration**: 
  - CPU: 2 cores, Memory: 1GB, Disk: 10GB per VM
  - Network: DHCP on `vmbr0` bridge
  - Storage: local-lvm backend with virtio-scsi
  - install-tools.yaml on vms for ssh config, ansible installation, k3s installation
- **Initialization**: Cloud-init snippet support for tool installation
- **Outputs**: VM IDs and names exported
```

## Files Overview

| File | Purpose |
|------|---------|
| `provider.tf` | Proxmox provider authentication |
| `main.tf` | Worker VM definitions |
| `variables.tf` | Configuration defaults |
| `outputs.tf` | VM IDs and names |
| `terraform.tfvars` | API endpoint and credentials |

**Customizable variables** (in `variables.tf`):
- `worker_vm_name` - VM name prefix
- `cores`, `memory`, `disk_size` - Resource allocation
- `template` - Source VM template name
- `bridge`, `storage` - Proxmox infrastructure settings

## Prerequisites

1. Proxmox host accessible at configured API URL
2. API token with VM.Allocate, VM.Clone, VM.Configure, VM.PowerMgmt permissions
3. Ubuntu vm pulled from 
4. Cloud-init snippet `install-tools.yml` created in Proxmox Datacenter → Snippets

## Troubleshooting

**TLS errors?** Using `pm_tls_insecure = true` for self-signed certs (not for production)

## State Files

- `terraform.tfstate` - Current infrastructure state
- `terraform.tfstate.backup` - Previous state backup


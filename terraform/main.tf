resource "proxmox_vm_qemu" "worker-01" {
  name        = var.worker_vm_name
  target_node = var.node_name
  clone       = var.template
  full_clone  = true
  os_type     = "cloud-init"

  cpu {
    cores   = var.cores
    sockets = 1
    type    = "host"
  }

  hotplug = "network,disk,usb"

  scsihw   = var.scsihw
  bootdisk = var.bootdisk

  disk {
    slot     = "scsi0"
    size     = var.disk_size
    type     = "disk"
    storage  = var.storage
    iothread = true
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = var.cloudinit_storage
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.bridge
  }

  # cloud-init user/password
  # enable guest agent so Proxmox can query the guest and cloud-init can use metadata
  agent         = 1
  agent_timeout = 300
  # request DHCP via cloud-init
  ipconfig0 = "ip=dhcp"
  cicustom  = "user=local:snippets/install-tools.yml"
}




resource "proxmox_vm_qemu" "worker-02" {
  name        = var.worker_vm_name2
  target_node = var.node_name
  clone       = var.template
  full_clone  = true
  os_type     = "cloud-init"

  cpu {
    cores   = var.cores
    sockets = 1
    type    = "host"
  }

  hotplug = "network,disk,usb"

  scsihw   = var.scsihw
  bootdisk = var.bootdisk

  disk {
    slot     = "scsi0"
    size     = var.disk_size
    type     = "disk"
    storage  = var.storage
    iothread = true
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = var.cloudinit_storage
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.bridge
  }

  # cloud-init user/password
  # enable guest agent so Proxmox can query the guest and cloud-init can use metadata
  agent         = 1
  agent_timeout = 300
  # request DHCP via cloud-init
  ipconfig0 = "ip=dhcp"
  cicustom  = "user=local:snippets/install-tools.yml"
}

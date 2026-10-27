# One role-separated Linux container on Proxmox VE, declared as code.
#
# STATUS: written against the bpg/proxmox provider's documented arguments, but NOT
# applied or validated in this repository. Before use: `terraform init && terraform
# validate && terraform plan`, and check argument names against the provider version
# you install. Addresses below use the RFC 5737 documentation range.

terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.60"
    }
  }
}

variable "endpoint"      { type = string }                        # https://pve.example.internal:8006/
variable "api_token"     { type = string, sensitive = true }      # user@realm!tokenid=secret
variable "node_name"     { type = string, default = "pve" }
variable "ssh_public_key" { type = string }

provider "proxmox" {
  endpoint  = var.endpoint
  api_token = var.api_token
}

resource "proxmox_virtual_environment_container" "workspace" {
  node_name    = var.node_name
  vm_id        = 200
  description  = "Engineering workspace (one role, one container)"
  unprivileged = true

  cpu    { cores = 2 }
  memory { dedicated = 4096 }
  disk   { datastore_id = "local-lvm", size = 24 }

  operating_system {
    template_file_id = "local:vztmpl/ubuntu-24.04-standard_24.04-2_amd64.tar.zst"
    type             = "ubuntu"
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  initialization {
    hostname = "workspace"
    ip_config {
      ipv4 {
        address = "192.0.2.20/24"   # pin the address; do not rely on DHCP
        gateway = "192.0.2.1"
      }
    }
    user_account {
      keys = [var.ssh_public_key]    # key-only access
    }
  }

  started = true
}

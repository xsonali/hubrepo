# =====================
# Admin Credentials
# =====================
variable "admin_user" {
  description = "Username for VM"
  type        = string
  default     = "localadmin"
}

variable "admin_password" {
  description = "Password for admin user"
  type        = string
  sensitive   = true
  default     = null
}

# =====================
# VM Size
# =====================
variable "vmsize" {
  description = "Size of the VMs"
  type        = string
  default     = "Standard_B2ms"
}

# =====================
# P2S Root Certificate
# =====================
variable "p2s_root_cert" {
  description = "The root certificate for Point-to-Site VPN"
  type        = string
  sensitive   = true
}

# =====================
# SSH Public Key
# =====================
variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  sensitive   = true
}

# =====================
# OS Type
# =====================
variable "os_type" {
  description = "Operating system type for VM"
  type        = string
  default     = "linux"

  validation {
    condition     = contains(["linux", "windows"], var.os_type)
    error_message = "os_type must be either 'linux' or 'windows'."
  }
}

variable "admin_user" {
  description = "Username for VM"
  default     = "localadmin"
}

variable "admin_password" {
  description = "Password for admin user"
  type        = string
  sensitive   = true
}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_B2ms"
}

variable "p2s_root_cert" {
  description = "The root certificate for Point-to-Site VPN"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  sensitive   = true
}

variable "os_type" {
  description = "Operating system type for VM"
  type        = string
  default     = "linux"
  validation {
    condition     = contains (["linux", "windows"], var.os_type)
	error_message = "os_type must be either 'linux' or 'windows'."
  }
}
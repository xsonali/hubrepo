variable "admin_user" {
  description = "Username for VM"
  default     = "localadmin"
}

variable "admin_password" {
  description = "Password for VM"
  type        = string
  sensitive   = true
  default     = null
  nullable    = true
}

variable "vmsize" {
  description = "Size of the VMs"
  default     = "Standard_B2ms"
}

variable "p2s_root_cert" {
  description = "The root certificate for Point-to-Site VPN"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPP9NI83LHtJgvN4RMsYP4eHCKM3BehbSM04n1nbL6XrUVnXFau4KxSza+IKQmZs9kv0ktrVhbEZAfEyB87qT85w6ZjGb0Nmcm07YtXE2fUY8sBnxw1KbQ2tIJC+lz1NZdEnqJU9OgoRnLqzH8Xo44BKQYAvynGq/Ah/rFkp9QtRMSFFeG/peYHLe6LqltRXxjeQLrQPydx9EaWRvwuCvnGGgCvt/EYarJym1A5KtQjvSixl7hYS21CveCdm8OvC7YvkeTvvQdYzkFNki+hbpIfCRvBW+GUuLl5gb1C+2+I0aliv/krEdYqBz8Vx2OqI7TERTaL0r8gaM6MorV4cKL alam@Liqustra-2"
}

variable "os_type" {
  description = "Operating system type for VM"
  type        = string
  default     = "linux"
  validation {
    condition     = contains(["linux", "windows"], var.os_type)
    error_message = "os_type must be either 'linux' or 'windows'."
  }
}


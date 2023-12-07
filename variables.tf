variable "spoke_module" {
  description = "The name of the spoke gateway"
}

variable "transit_firenet_gw_name" {
  description = "The name of the Transit Firenet gateway"
  type        = string
}

variable "subnet_count" {
  description = "The number of subnets to create"
  type        = number
  default     = 4

}

variable "subnet_prefix_length" {
  description = "The new prefix length for the subnets"
  type        = number
  default     = 27
  validation {
    condition     = var.subnet_prefix_length > 22 && var.subnet_prefix_length < 28
    error_message = "The subnet prefix length must be between 22 and 28"
  }
}
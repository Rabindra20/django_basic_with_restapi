
variable "tags" {
  type = map(string)
}

variable "node_subnet_ids" {
  type = list(string)
}

variable "eks_version" {
  type        = string
}

variable "node_group_name" {
  type    = string
}

variable "cluster_name" {
  type = string
}

variable "node_ami_type" {
  type        = string
  default     = "AL2_x86_64"
  description = "e.g. AL2_x86_64 | AL2_x86_64_GPU | AL2_ARM_64 | CUSTOM | BOTTLEROCKET_ARM_64 | BOTTLEROCKET_x86_64 | BOTTLEROCKET_ARM_64_NVIDIA | BOTTLEROCKET_x86_64_NVIDIA"
}

variable "node_capacity_type" {
  type        = string
  default     = "ON_DEMAND"
  description = "e.g. ON_DEMAND | SPOT"
}

variable "node_disk_size" {
  type    = number
}

variable "node_instance_types" {
  type    = list(string)
}

variable "ec2_ssh_key_name" {
  type    = string
}

variable "node_desired_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 3
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_unavailable" {
  type    = number
  default = 2
}
variable "node_name_role" {
  type = string
}

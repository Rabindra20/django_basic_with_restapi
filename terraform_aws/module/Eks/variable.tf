
variable "cluster_name" {
  type    = string
  default = "eks"
}

variable "tags" {
  type = map(string)
}

variable "cluster_subnet_ids" {
  type = list(string)
}

variable "eks_version" {
  type = string
}

variable "cluster_endpoint_private_access" {
  type    = bool
}

variable "cluster_endpoint_public_access" {
  type    = bool
}

variable "cluster_public_access_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "cluster_service_ipv4_cidr" {
  type    = string
}
variable "eks_role_name" {
  type    = string
}

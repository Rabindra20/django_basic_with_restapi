variable "cluster_service_ipv4_cidr" {
  type    = string
  default = "17.0.0.0"
}
variable "private_subnet_ids" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
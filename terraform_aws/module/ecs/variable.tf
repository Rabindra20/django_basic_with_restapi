variable "app_name" {
  type = string
}
variable "cluster" {
    type = string
}
variable "task_definition" {
    type = string
}
variable "launch_type" {
    type = string
}
variable "scheduling_strategy" {
    type = string
}
variable "desired_count" {
    type = number
}
variable "force_new_deployment" {
    type = bool
}
variable "subnets" {
    type = set(string)
}
variable "assign_public_ip" {
    type = bool
}
variable "security_groups" {
    type = set(string)
}
variable "target_group" {
    type = string
}
variable "container_port" {
    type = number
}
variable "tags" {
    type = map(string)
}
variable "task_definition_name" {
  type = string
}
variable "stage" {
  type = string
}
variable "ecr_repo" {
  type = string
}
variable "ecr_image_tag" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "hostPort" {
  type = number
}
variable "protocol" {
  type = string
}
variable "cpu" {
  type = string
}
variable "memory" {
  type = string
}
variable "networkMode" {
  type = string
}
variable "requires_compatibilities" {
  type = set(string)
}
variable "execution_role_arn" {
  type = string
}
variable "task_role_arn" {
  type = string
}
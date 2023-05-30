//create ecr
resource "aws_ecr_repository" "test" {
  name                 = "rabindra-test"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
module "eks_cluster" {
  source                          = "./module/Eks"
  eks_role_name                   ="eks_role"
  cluster_name                    = "eks"
  cluster_subnet_ids              = var.private_subnet_ids
  eks_version                     = "1.26" 
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  cluster_service_ipv4_cidr       =var.cluster_service_ipv4_cidr
  tags ={
    env="test"
  }
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "private_key_pair" {
  key_name   = "test_key" 
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "aws_secretsmanager_secret_version" "key_pair_json" {
  secret_id = aws_secretsmanager_secret.key_pair.id
  secret_string = jsonencode({
    "private_key" : tls_private_key.private_key.private_key_pem
    "public_key" : tls_private_key.private_key.public_key_pem
  })
}

resource "aws_secretsmanager_secret" "key_pair" {
  name = "key_pair"
}
module "eks_nodegroup" {
  source              = "./module/nodegroup"
  cluster_name    = module.eks_cluster.cluster_name
  node_name_role      = "nodegroup_role"
  node_group_name     = "nodegroup"
  node_subnet_ids     = var.private_subnet_ids
  ec2_ssh_key_name    = "private_key"
  eks_version         = "1.26"
  node_instance_types = ["t2.micro"]
  node_desired_size   = 1
  node_max_size       = 3
  node_min_size       = 1
  node_disk_size      = 30
  tags ={
    env="test"
  }
}
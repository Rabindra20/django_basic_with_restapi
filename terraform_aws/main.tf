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
#################################################
# Task definition & Service for demo
#################################################
module "test_dev" {
  source                  = "./module/ecs"
  app_name                = "demo"
  cluster                 = aws_ecs_cluster.test.id
  task_definition         = "demo-task"
  launch_type             = "FARGATE"
  scheduling_strategy     = "REPLICA"
  desired_count           = 1
  force_new_deployment    = true
  subnets                 = []
  assign_public_ip        = false
  security_groups         = []
  target_group            = aws_alb_target_group.test.arn
  container_port          = 8000
  tags                    = "demo"
  task_definition_name    = "demo"
  stage                   = "demo"
  ecr_repo                = aws_ecr_repository.test.repository_url
  ecr_image_tag           = "be-test"
  aws_region              = "us-west-2"
  hostPort                = 8000
  protocol                = "tcp"
  memory                  = "512"
  cpu                     = "256"
  networkMode             = "awsvpc"
  requires_compatibilities= ["FARGATE"]
  task_role_arn           = aws_iam_role.task_definition.arn
  execution_role_arn      = aws_iam_role.task_definition.arn
  depends_on              = [aws_iam_role.task_definition]
}
##########################################################################################
# TargetGroup and Listener Rule for test
##########################################################################################
resource "aws_alb_target_group" "test" {
  vpc_id      = data.aws_vpc.dev.id
  name        = "test"
  target_type = "ip"
  protocol    = "HTTP"
  port        = 8000
  health_check {
    healthy_threshold   = "5"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200-499"
    timeout             = "5"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener_rule" "test_dev" {
  listener_arn = ""
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.test.arn
  }
  # condition {
  #   host_header {
  #     values = [local.backend_domains_dev.test_domain]
  #   }
  # }
}
#########################################
# task definition role
#########################################
resource "aws_iam_role" "task_definition" {
  name               = "ECS-Task-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  # tags = merge({
  #   Name = "task-definition"
  # }, module.label.tags)
}


resource "aws_iam_role_policy_attachment" "AmazonECSTaskExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.task_definition.name
  depends_on = [aws_iam_role.task_definition]
}

###################################################
# Route53
###################################################
locals {
  demo = {
    test=""
  }
}

resource "aws_route53_record" "backend" {
  for_each = local.demo
  name     = each.value
  type     = "CNAME"
  records  = [module.dev-lb.alb_dns_name]
  zone_id  = ""
  ttl      = 60
}
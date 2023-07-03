#########################################
# task definition
#########################################
resource "aws_ecs_task_definition" "aws-ecs-task" {
  family = "${var.app_name}-task"

  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.app_name}-container",
      "image": "${var.ecr_repo}:${var.ecr_image_tag}",
      "entryPoint": [],
      "environment": [],
      "mountPoints": [],
      "volumesFrom": [],
      "essential": true,
      "logConfiguration": {
        "logDriver": "awslogs",
        "secretOptions": null,
        "options": {
          "awslogs-group": "/aws/ecs/${var.app_name}",
          "awslogs-region": "${var.aws_region}",
          "awslogs-stream-prefix": "${var.app_name}"
        }
      },
      "portMappings": [
        {
          "containerPort": ${var.container_port},
          "hostPort": ${var.hostPort},
          "protocol": "${var.protocol}"
        }
      ],
      "cpu": ${var.cpu},
      "memory": ${var.memory},
      "networkMode": "${var.networkMode}"
    }
  ]
  DEFINITION

  requires_compatibilities = var.requires_compatibilities
  network_mode             = var.networkMode
  memory                   = var.memory
  cpu                      = var.cpu
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

    tags = merge(
    var.tags,
    {
      Owner = "demo"
    },
  )
}

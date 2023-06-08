resource "aws_ecs_task_definition" "test" {
  family                = "test"
  container_definitions = <<TASK_DEFINITION
  [{
    "name": "${container_name}",
        "image": "${ecr_repo}:${ecr_image_tag}",
    "cpu": 512,
    "memory": 1024,
    "memoryReservation": 256,
    "portMappings": [
        {
            "containerPort": 8000,
            "hostPort": 8000,
            "protocol": "tcp"
        }
    ],
    "essential": true,
    "environment": [],
    "mountPoints": [],
    "volumesFrom": [],
    "logConfiguration": {
            "logDriver": "awslogs",
            "secretOptions": null,
            "options": {
              "awslogs-group": "/ecs/${task_def_name}",
              "awslogs-region": "${region}",
              "awslogs-stream-prefix": "ecs"
            }
          },
    "secrets": [
        {
            "valueFrom": "arn:aws:secretsmanager:${region}:${account_id}:secret:${secret_name}:test::",
            "name": "DB"
        }
    ]
}]
TASK_DEFINITION

  inference_accelerator {
    device_name = "device_1"
    device_type = "eia1.medium"
  }
}
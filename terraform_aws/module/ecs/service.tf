resource "aws_ecs_service" "aws-ecs-service" {
  depends_on           = [aws_ecs_task_definition.aws-ecs-task]
  name                 = "${var.app_name}-ecs-service"
  cluster              = var.cluster
  task_definition      = "${var.task_definition}:${max(aws_ecs_task_definition.aws-ecs-task.revision, data.aws_ecs_task_definition.main.revision)}"
  launch_type          = var.launch_type
  scheduling_strategy  = var.scheduling_strategy
  desired_count        = var.desired_count
  force_new_deployment = var.force_new_deployment

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = var.assign_public_ip
    security_groups = var.security_groups
  }

  load_balancer {
    target_group_arn = var.target_group
    container_name   = "${var.app_name}-container"
    container_port   = var.container_port
  }
    tags = merge(
    var.tags,
    {
      Owner = "demo"
    },
  )
}
data "aws_ecs_task_definition" "main" {
  task_definition = aws_ecs_task_definition.aws-ecs-task.family
  depends_on      = [aws_ecs_task_definition.aws-ecs-task]

}
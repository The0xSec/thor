resource "aws_ecs_cluster" "thor_cluster" {
    name = "thor"
    setting {
        name = "containerInsights"
        value = "enabled"
    }
}

resource "aws_ecs_cluster_capacity_providers" "thor_cluster" {
    cluster_name = aws_ecs_cluster.thor_cluster.id
    capacity_providers = ["FARGATE"]

    default_capacity_provider_strategy {
        capacity_provider = "FARGATE"
        weight = 1
        base = 0
    }
}


resource "aws_ecs_task_definition" "thor_task" {
    family = "service"
    container_definitions = jsonencode ([{
        name = "thor"
        image = "automad:latest"
        cpu = 256
        memory = 512
        essential = true
        launch_type = "FARGATE"
        portMappings = [{
            containerPort = 80
            hostPort = 80
            protocol = "tcp"
        }]
    }])
}

resource "aws_ecs_service" "thor" {
    name = "thor"
    cluster = aws_ecs_cluster.thor_cluster.id
    task_definition = aws_ecs_task_definition.thor_task.arn
    desired_count = 1
}

terraform {
  backend "s3"{
    bucket                 = "saadterraform"
    region                 = "ap-south-1"
    key                    = "node.tfstate"
  }
}
provider "aws" {
  region = "ap-south-1"  # Update with your AWS region
}

# Create an ECS cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}

# Define ECS task definition
resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task"
  cpu                      = 1024  # Define CPU at the task level
  memory                   = 2048  # Define memory at the task level
  container_definitions    = jsonencode([
    {
      name            = "my-container"
      image           = "mdsdsardar/hello-world-node"  # Docker Hub image
      cpu             = 1024
      memory          = 2048
      essential       = true
      portMappings    = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
    }
  ])
  network_mode = "awsvpc"  # Required for Fargate launch type
  requires_compatibilities = ["FARGATE"]  # Ensure compatibility with Fargate
}

# Define ECS service
resource "aws_ecs_service" "my_service" {
  name            = "my-service"
  cluster         = aws_ecs_cluster.my_cluster.arn  # Use default cluster ARN
  task_definition = aws_ecs_task_definition.my_task_definition.arn
  desired_count   = 1  # Number of tasks to run

  launch_type     = "FARGATE"  # Specify Fargate launch type here

  network_configuration {
    subnets          = ["subnet-05639e074104111a2"]  # Specify your subnet IDs here
    security_groups  = ["sg-02490b15f955bfd72"]      # Specify your security group IDs here
    assign_public_ip = true
  }
}

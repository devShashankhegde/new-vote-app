variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS in us-east-1
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = "voting-app-key"
}

variable "docker_image" {
  description = "Docker image for the voting app"
  type        = string
  default     = "username/voting-app:latest"
}
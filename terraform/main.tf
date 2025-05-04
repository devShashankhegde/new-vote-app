provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "voting_app_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "voting-app-vpc"
  }
}

# Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.voting_app_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  
  tags = {
    Name = "voting-app-public-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.voting_app_vpc.id
  
  tags = {
    Name = "voting-app-igw"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.voting_app_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "voting-app-public-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "public_rta" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group
resource "aws_security_group" "voting_app_sg" {
  name        = "voting-app-sg"
  description = "Allow traffic for voting app"
  vpc_id      = aws_vpc.voting_app_vpc.id
  
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "voting-app-sg"
  }
}

# EC2 Instance
resource "aws_instance" "voting_app_server" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.voting_app_sg.id]
  key_name               = var.key_name
  
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io docker-compose
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu
              
              # Pull Docker image
              docker pull ${var.docker_image}
              
              # Create docker-compose file
              mkdir -p /home/ubuntu/voting-app
              cat <<'DOCKER_COMPOSE' > /home/ubuntu/voting-app/docker-compose.yml
              version: '3'
              services:
                app:
                  image: ${var.docker_image}
                  ports:
                    - "5000:5000"
                    - "8000:8000"
                  environment:
                    - REDIS_HOST=redis
                  depends_on:
                    - redis
                  restart: always
                redis:
                  image: redis:alpine
                  volumes:
                    - redis_data:/data
                  restart: always
              volumes:
                redis_data:
              DOCKER_COMPOSE
              
              cd /home/ubuntu/voting-app
              docker-compose up -d
              EOF
  
  tags = {
    Name = "voting-app-server"
  }
}

# Elastic IP
resource "aws_eip" "voting_app_eip" {
  instance = aws_instance.voting_app_server.id
  domain   = "vpc"
  
  tags = {
    Name = "voting-app-eip"
  }
}
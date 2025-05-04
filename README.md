# Simple Voting Application with DevOps Integration

This is a simple web-based voting application that demonstrates basic DevOps concepts, including containerization, CI/CD pipelines, Infrastructure as Code (IaC), and monitoring.

## Features

- Vote for your favorite programming language
- Real-time vote counting and results
- Containerized with Docker
- CI/CD using GitHub Actions
- Infrastructure as Code using Terraform
- Monitoring with Prometheus and Grafana

## Project Structure

```
voting-app/
├── app/                      # Application code
│   ├── static/               # CSS files
│   ├── templates/            # HTML templates
│   ├── app.py                # Main Flask application
│   └── requirements.txt      # Python dependencies
├── docker-compose.yml        # Docker Compose configuration
├── Dockerfile                # Docker image definition
├── .github/workflows/        # GitHub Actions workflows
│   └── ci-cd.yml             # CI/CD pipeline configuration
├── terraform/                # Infrastructure as Code
│   ├── main.tf               # Main Terraform configuration
│   ├── variables.tf          # Terraform variables
│   └── outputs.tf            # Terraform outputs
├── monitoring/               # Monitoring configuration
│   ├── prometheus.yml        # Prometheus configuration
│   └── grafana-dashboard.json # Grafana dashboard
└── README.md                 # Project documentation
```

## Prerequisites

To run this project, you need:

- Docker and Docker Compose
- Git
- GitHub account (for CI/CD)
- AWS account (for deployment)
- Terraform (optional, for infrastructure provisioning)

## Quick Start

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/voting-app.git
cd voting-app
```

### 2. Run with Docker Compose

```bash
docker-compose up -d
```

This command will:
- Build the Docker image for the voting application
- Start the application, Redis, Prometheus, and Grafana containers
- Make the application available on port 5000

### 3. Access the application

- Voting interface: http://localhost:5000
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (default credentials: admin/admin)

## Setting up CI/CD

### 1. Create the following secrets in your GitHub repository:

- `DOCKER_HUB_USERNAME`: Your Docker Hub username
- `DOCKER_HUB_TOKEN`: Your Docker Hub access token
- `AWS_ACCESS_KEY_ID`: Your AWS access key
- `AWS_SECRET_ACCESS_KEY`: Your AWS secret key

### 2. Push to the main branch

The CI/CD pipeline will:
1. Run tests
2. Build and push the Docker image to Docker Hub
3. Deploy to AWS using Terraform

## Deployment with Terraform

### 1. Initialize Terraform

```bash
cd terraform
terraform init
```

### 2. Apply the configuration

```bash
terraform apply
```

This will create:
- A VPC with a public subnet
- Security groups
- EC2 instance running your application
- Elastic IP for the instance

## Monitoring

The application includes:

- Prometheus metrics endpoint at `/metrics`
- Health check endpoint at `/health`
- Grafana dashboard for monitoring request rate and response time

To set up Grafana:
1. Access Grafana at http://localhost:3000
2. Login with default credentials (admin/admin)
3. Add Prometheus as a data source (URL: http://prometheus:9090)
4. Import the dashboard from monitoring/grafana-dashboard.json

## DevOps Concepts Demonstrated

1. **Containerization**: Application and dependencies are packaged into Docker containers
2. **CI/CD Pipeline**: Automated testing, building, and deployment with GitHub Actions
3. **Infrastructure as Code**: AWS infrastructure defined with Terraform
4. **Monitoring**: Application metrics with Prometheus and Grafana
5. **Health Checks**: Application health monitoring
6. **Version Control**: Git for source code management
7. **Configuration Management**: Environment variables and configuration files

## Customization

- Add or modify voting options in `app.py`
- Customize the UI in the HTML templates and CSS
- Extend the monitoring with additional metrics
- Add more AWS resources in the Terraform configuration

## License

MIT
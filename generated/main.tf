```hcl
# Provider configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Data source for existing EBS volume
data "aws_ebs_volume" "existing" {
  most_recent = true

  filter {
    name   = "tag:Environment"
    values = ["production"]
  }

  filter {
    name   = "status"
    values = ["available"]
  }
}

# Data source for latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source for existing VPC
data "aws_vpc" "main" {
  filter {
    name   = "tag:Environment"
    values = ["production"]
  }
}

# Data source for existing subnet
data "aws_subnet" "main" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Environment"
    values = ["production"]
  }
}

# Security Group for EC2 instance
resource "aws_security_group" "web_portal" {
  name        = "web-portal-dmz-sg"
  description = "Security group for web portal DMZ tier"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "HTTPS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                   = "web-portal-dmz-sg"
    Environment            = "production"
    Application            = "web-portal"
    Owner                  = "it-operations-team"
    CostCenter             = "IT-OPS-001"
    Project                = "digital-transformation"
    ServiceLevel           = "critical"
    BackupRequired         = "true"
    MonitoringEnabled      = "true"
    PatchGroup             = "monthly"
    ComplianceRequired     = "sox-gdpr"
    DataClassification     = "confidential"
    BusinessUnit           = "healthcare-technology"
    MaintenanceWindow      = "sunday-02:00-06:00"
    DisasterRecovery       = "enabled"
    SecurityGroup          = "dmz-web-tier"
    AutoScaling            = "enabled"
    LogRetention           = "90-days"
    IncidentPriority       = "high"
    ServiceDesk            = "servicenow-integration"
    ChangeManagement       = "required"
  }
}

# IAM Role for EC2 instance
resource "aws_iam_role" "web_portal_role" {
  name = "web-portal-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment            = "production"
    Application            = "web-portal"
    Owner                  = "it-operations-team"
    CostCenter             = "IT-OPS-001"
    Project                = "digital-transformation"
    ServiceLevel           = "critical"
    BackupRequired         = "true"
    MonitoringEnabled      = "true"
    PatchGroup             = "monthly"
    ComplianceRequired     = "sox-gdpr"
    DataClassification     = "confidential"
    BusinessUnit           = "healthcare-technology"
    MaintenanceWindow      = "sunday-02:00-06:00"
    DisasterRecovery       = "enabled"
    SecurityGroup          = "dmz-web-tier"
    AutoScaling            = "enabled"
    LogRetention           = "90-days"
    IncidentPriority       = "high"
    ServiceDesk            = "servicenow-integration"
    ChangeManagement       = "required"
  }
}

# Attach CloudWatch and SSM policies to IAM role
resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  role       = aws_iam_role.web_portal_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.web_portal_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "web_portal_profile" {
  name = "web-portal-instance-profile"
  role = aws_iam_role.web_portal_role.name

  tags = {
    Environment            = "production"
    Application            = "web-portal"
    Owner                  = "it-operations-team"
    CostCenter             = "IT-OPS-001"
    Project                = "digital-transformation"
  }
}

# EC2 Instance
resource "aws_instance" "web_portal" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.medium"
  subnet_id              = data.aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.web_portal.id]
  iam_instance_profile   = aws_iam_instance_profile.web_portal_profile.name

  monitoring             = true
  ebs_optimized          = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    encrypted             = true
    delete_on_termination = false

    tags = {
      Name                   = "web-portal-root-volume"
      Environment            = "production"
      Application            = "web-portal"
      Owner                  = "it-operations-team"
      CostCenter             = "IT-OPS-001"
      Project                = "digital-transformation"
      ServiceLevel           = "critical"
      BackupRequired         = "true"
      DataClassification     = "confidential"
      BusinessUnit           = "healthcare-technology"
    }
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y amazon-cloudwatch-agent
              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                -a fetch-config \
                -m ec2 \
                -s -c default
              EOF
  )

  tags = {
    Name                   = "web-portal-instance"
    Environment            
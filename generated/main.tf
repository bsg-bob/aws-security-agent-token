```hcl
# EC2 Instance with existing EBS volume association
# File: generated/main.tf

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Data source for existing VPC
data "aws_vpc" "existing" {
  default = true
}

# Data source for existing subnet
data "aws_subnet" "existing" {
  vpc_id            = data.aws_vpc.existing.id
  availability_zone = var.availability_zone
  default_for_az    = true
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

# Data source for existing EBS volume
data "aws_ebs_volume" "existing" {
  most_recent = true

  filter {
    name   = "volume-id"
    values = [var.existing_ebs_volume_id]
  }
}

# Security Group for EC2 Instance
resource "aws_security_group" "web_portal" {
  name        = "web-portal-sg"
  description = "Security group for web portal EC2 instance"
  vpc_id      = data.aws_vpc.existing.id

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from corporate network"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.corporate_cidr]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                   = "web-portal-security-group"
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

# IAM Role for EC2 Instance
resource "aws_iam_role" "ec2_role" {
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
    Name                   = "web-portal-ec2-role"
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

# IAM Role Policy Attachment for CloudWatch
resource "aws_iam_role_policy_attachment" "cloudwatch_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# IAM Role Policy Attachment for SSM
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "web-portal-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name                   = "web-portal-ec2-profile"
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

# EC2 Instance
resource "aws_instance" "web_portal" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.existing.id
  vpc_security_group_ids = [aws_security_group.web_portal.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  availability_zone      = var.availability_zone

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = false

    tags = {
      Name                   = "web-portal-root-volume"
      Environment            = "production"
      Application            = "web-portal"
      Owner                  = "it-operations-
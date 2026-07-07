```hcl
# ./generated/ec2/main.tf

resource "aws_instance" "web_portal" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.large"
  
  subnet_id                   = data.aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.web_portal.id]
  iam_instance_profile        = aws_iam_instance_profile.web_portal.name
  associate_public_ip_address = false
  
  monitoring = true
  
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 50
    encrypted             = true
    delete_on_termination = true
    
    tags = {
      Name                  = "web-portal-root-volume"
      Environment           = "production"
      Application           = "web-portal"
      Owner                 = "it-operations-team"
      CostCenter            = "IT-OPS-003"
      Project               = "digital-transformation"
      ServiceLevel          = "critical"
      BackupRequired        = "true"
      MonitoringEnabled     = "true"
      PatchGroup            = "monthly"
      ComplianceRequired    = "sox-gdpr"
      DataClassification    = "confidential"
      BusinessUnit          = "healthcare-technology"
      MaintenanceWindow     = "sunday-02:00-06:00"
      DisasterRecovery      = "enabled"
      SecurityGroup         = "dmz-web-tier"
      AutoScaling           = "enabled"
      LogRetention          = "90-days"
      IncidentPriority      = "high"
      ServiceDesk           = "servicenow-integration"
      ChangeManagement      = "required"
    }
  }
  
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  
  tags = {
    Name                  = "web-portal-instance"
    Environment           = "production"
    Application           = "web-portal"
    Owner                 = "it-operations-team"
    CostCenter            = "IT-OPS-003"
    Project               = "digital-transformation"
    ServiceLevel          = "critical"
    BackupRequired        = "true"
    MonitoringEnabled     = "true"
    PatchGroup            = "monthly"
    ComplianceRequired    = "sox-gdpr"
    DataClassification    = "confidential"
    BusinessUnit          = "healthcare-technology"
    MaintenanceWindow     = "sunday-02:00-06:00"
    DisasterRecovery      = "enabled"
    SecurityGroup         = "dmz-web-tier"
    AutoScaling           = "enabled"
    LogRetention          = "90-days"
    IncidentPriority      = "high"
    ServiceDesk           = "servicenow-integration"
    ChangeManagement      = "required"
  }
  
  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_security_group" "web_portal" {
  name        = "web-portal-sg"
  description = "Security group for web portal application"
  vpc_id      = data.aws_vpc.main.id
  
  ingress {
    description = "HTTPS from ALB"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    security_groups = [data.aws_security_group.alb.id]
  }
  
  ingress {
    description = "HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [data.aws_security_group.alb.id]
  }
  
  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name                  = "web-portal-security-group"
    Environment           = "production"
    Application           = "web-portal"
    Owner                 = "it-operations-team"
    CostCenter            = "IT-OPS-003"
    Project               = "digital-transformation"
    ServiceLevel          = "critical"
    BackupRequired        = "true"
    MonitoringEnabled     = "true"
    PatchGroup            = "monthly"
    ComplianceRequired    = "sox-gdpr"
    DataClassification    = "confidential"
    BusinessUnit          = "healthcare-technology"
    MaintenanceWindow     = "sunday-02:00-06:00"
    DisasterRecovery      = "enabled"
    SecurityGroup         = "dmz-web-tier"
    AutoScaling           = "enabled"
    LogRetention          = "90-days"
    IncidentPriority      = "high"
    ServiceDesk           = "servicenow-integration"
    ChangeManagement      = "required"
  }
}

resource "aws_iam_instance_profile" "web_portal" {
  name = "web-portal-instance-profile"
  role = aws_iam_role.web_portal.name
  
  tags = {
    Environment           = "production"
    Application           = "web-portal"
    Owner                 = "it-operations-team"
    CostCenter            = "IT-OPS-003"
    Project               = "digital-transformation"
    ServiceLevel          = "critical"
    BackupRequired        = "true"
    MonitoringEnabled     = "true"
    PatchGroup            = "monthly"
    ComplianceRequired    = "sox-gdpr"
    DataClassification    = "confidential"
    BusinessUnit          = "healthcare-technology"
    MaintenanceWindow     = "sunday-02:00-06:00"
    DisasterRecovery      = "enabled"
    SecurityGroup         = "dmz-web-tier"
    AutoScaling           = "enabled"
    LogRetention          = "90-days"
    IncidentPriority      = "high"
    ServiceDesk           = "servicenow-integration"
    ChangeManagement      = "required"
  }
}

resource "aws_iam_role" "web_portal" {
  name = "web-portal-instance-role"
  
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
    Environment           = "production"
    Application           = "web-portal"
    Owner                 = "it-operations-team"
    CostCenter            = "IT-OPS-003"
    Project               = "digital-transformation"
    ServiceLevel          = "critical"
    BackupRequired        = "true"
    MonitoringEnabled     = "true"
    PatchGroup            = "monthly"
    ComplianceRequired    = "sox-gdpr"
    DataClassification    = "confidential"
    BusinessUnit          = "healthcare-technology"
    MaintenanceWindow     = "sunday-02:00-06:00"
    DisasterRecovery      = "enabled"
    SecurityGroup         = "dmz-web-tier"
    AutoScaling           = "enabled"
    LogRetention          = "90-days"
    IncidentPriority      = "high"
    ServiceDesk           = "servicenow-integration"
    ChangeManagement      = "required"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.web_portal.name
  policy_arn
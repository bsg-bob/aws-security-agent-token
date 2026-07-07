```hcl
# VPC Configuration
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    {
      Name = "main-vpc"
    },
    {
      Environment          = "production"
      Application          = "web-portal"
      Owner                = "it-operations-team"
      CostCenter           = "IT-OPS-001"
      Project              = "digital-transformation"
      ServiceLevel         = "critical"
      BackupRequired       = "true"
      MonitoringEnabled    = "true"
      PatchGroup           = "monthly"
      ComplianceRequired   = "sox-gdpr"
      DataClassification   = "confidential"
      BusinessUnit         = "healthcare-technology"
      MaintenanceWindow    = "sunday-02:00-06:00"
      DisasterRecovery     = "enabled"
      SecurityGroup        = "dmz-web-tier"
      AutoScaling          = "enabled"
      LogRetention         = "90-days"
      IncidentPriority     = "high"
      ServiceDesk          = "servicenow-integration"
      ChangeManagement     = "required"
    }
  )
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "main-igw"
    },
    {
      Environment          = "production"
      Application          = "web-portal"
      Owner                = "it-operations-team"
      CostCenter           = "IT-OPS-001"
      Project              = "digital-transformation"
      ServiceLevel         = "critical"
      BackupRequired       = "true"
      MonitoringEnabled    = "true"
      PatchGroup           = "monthly"
      ComplianceRequired   = "sox-gdpr"
      DataClassification   = "confidential"
      BusinessUnit         = "healthcare-technology"
      MaintenanceWindow    = "sunday-02:00-06:00"
      DisasterRecovery     = "enabled"
      SecurityGroup        = "dmz-web-tier"
      AutoScaling          = "enabled"
      LogRetention         = "90-days"
      IncidentPriority     = "high"
      ServiceDesk          = "servicenow-integration"
      ChangeManagement     = "required"
    }
  )
}

# Public Subnets
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "public-subnet-a"
      Type = "public"
    },
    {
      Environment          = "production"
      Application          = "web-portal"
      Owner                = "it-operations-team"
      CostCenter           = "IT-OPS-001"
      Project              = "digital-transformation"
      ServiceLevel         = "critical"
      BackupRequired       = "true"
      MonitoringEnabled    = "true"
      PatchGroup           = "monthly"
      ComplianceRequired   = "sox-gdpr"
      DataClassification   = "confidential"
      BusinessUnit         = "healthcare-technology"
      MaintenanceWindow    = "sunday-02:00-06:00"
      DisasterRecovery     = "enabled"
      SecurityGroup        = "dmz-web-tier"
      AutoScaling          = "enabled"
      LogRetention         = "90-days"
      IncidentPriority     = "high"
      ServiceDesk          = "servicenow-integration"
      ChangeManagement     = "required"
    }
  )
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "public-subnet-b"
      Type = "public"
    },
    {
      Environment          = "production"
      Application          = "web-portal"
      Owner                = "it-operations-team"
      CostCenter           = "IT-OPS-001"
      Project              = "digital-transformation"
      ServiceLevel         = "critical"
      BackupRequired       = "true"
      MonitoringEnabled    = "true"
      PatchGroup           = "monthly"
      ComplianceRequired   = "sox-gdpr"
      DataClassification   = "confidential"
      BusinessUnit         = "healthcare-technology"
      MaintenanceWindow    = "sunday-02:00-06:00"
      DisasterRecovery     = "enabled"
      SecurityGroup        = "dmz-web-tier"
      AutoScaling          = "enabled"
      LogRetention         = "90-days"
      IncidentPriority     = "high"
      ServiceDesk          = "servicenow-integration"
      ChangeManagement     = "required"
    }
  )
}

# Private Subnets
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = merge(
    {
      Name = "private-subnet-a"
      Type = "private"
    },
    {
      Environment          = "production"
      Application          = "web-portal"
      Owner                = "it-operations-team"
      CostCenter           = "IT-OPS-001"
      Project              = "digital-transformation"
      ServiceLevel         = "critical"
      BackupRequired       = "true"
      MonitoringEnabled    = "true"
      PatchGroup           = "monthly"
      ComplianceRequired   = "sox-gdpr"
      DataClassification   = "confidential"
      BusinessUnit         = "healthcare-technology"
      MaintenanceWindow    = "sunday-02:00-06:00"
      DisasterRecovery     = "enabled"
      SecurityGroup        = "dmz-web-tier"
      AutoScaling          = "enabled"
      LogRetention         = "90-days"
      IncidentPriority     = "high"
      ServiceDesk          = "servicenow-integration"
      ChangeManagement     = "required"
    }
  )
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = merge(
    {
      Name = "private-subnet-b"
      Type = "private"
    },
    {
      Environment          = "production"
      Application          = "web-portal"
      Owner                = "it-operations-team"
      CostCenter           = "IT-OPS-001"
      Project              = "digital-transformation"
      ServiceLevel         = "critical"
      BackupRequired       = "true"
      MonitoringEnabled    = "true"
      PatchGroup           = "monthly"
      ComplianceRequired   = "sox-gdpr"
      DataClassification   = "confidential"
      BusinessUnit         = "healthcare-technology"
      MaintenanceWindow    = "sunday-02:00-06:00"
      DisasterRecovery     = "enabled"
      SecurityGroup        = "dmz-web-tier"
      AutoScaling          = "enabled"
      LogRetention         = "90-days"
      Inc
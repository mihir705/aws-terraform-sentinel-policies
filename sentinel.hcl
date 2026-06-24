sentinel {
  features = {
    terraform = true
  }
}

module "tfplan-functions" {
  source = "./lib/tfplan-functions.sentinel"
}

# ---------------------------------------------------------------------------
# S3 — terraform-aws-modules/s3-bucket/aws
# ---------------------------------------------------------------------------

policy "s3-public-access-block" {
  source            = "./policies/s3-public-access-block.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "s3-server-side-encryption" {
  source            = "./policies/s3-server-side-encryption.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "s3-versioning-enabled" {
  source            = "./policies/s3-versioning-enabled.sentinel"
  enforcement_level = "hard-mandatory"
}

# ---------------------------------------------------------------------------
# VPC — terraform-aws-modules/vpc/aws
# ---------------------------------------------------------------------------

policy "vpc-flow-logs-required" {
  source            = "./policies/vpc-flow-logs-required.sentinel"
  enforcement_level = "hard-mandatory"
}

# ---------------------------------------------------------------------------
# IAM — terraform-aws-modules/iam/aws
# ---------------------------------------------------------------------------

policy "iam-no-wildcard-actions" {
  source            = "./policies/iam-no-wildcard-actions.sentinel"
  enforcement_level = "hard-mandatory"
}

# ---------------------------------------------------------------------------
# KMS — terraform-aws-modules/kms/aws
# ---------------------------------------------------------------------------

policy "kms-key-rotation-enabled" {
  source            = "./policies/kms-key-rotation-enabled.sentinel"
  enforcement_level = "hard-mandatory"
}

# ---------------------------------------------------------------------------
# Security Group — terraform-aws-modules/security-group/aws
# ---------------------------------------------------------------------------

policy "sg-no-public-ingress" {
  source            = "./policies/sg-no-public-ingress.sentinel"
  enforcement_level = "hard-mandatory"
}

# ---------------------------------------------------------------------------
# EKS — terraform-aws-modules/eks/aws
# ---------------------------------------------------------------------------

policy "eks-private-endpoint-required" {
  source            = "./policies/eks-private-endpoint-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "eks-control-plane-logging" {
  source            = "./policies/eks-control-plane-logging.sentinel"
  enforcement_level = "hard-mandatory"
}

# ---------------------------------------------------------------------------
# RDS — terraform-aws-modules/rds/aws, rds-aurora/aws
# ---------------------------------------------------------------------------

policy "rds-encryption-at-rest" {
  source            = "./policies/rds-encryption-at-rest.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "rds-no-public-access" {
  source            = "./policies/rds-no-public-access.sentinel"
  enforcement_level = "hard-mandatory"
}

# ---------------------------------------------------------------------------
# EC2 — terraform-aws-modules/ec2-instance/aws
# ---------------------------------------------------------------------------

policy "ec2-imdsv2-required" {
  source            = "./policies/ec2-imdsv2-required.sentinel"
  enforcement_level = "hard-mandatory"
}

# ---------------------------------------------------------------------------
# ALB — terraform-aws-modules/alb/aws
# ---------------------------------------------------------------------------

policy "alb-security-baseline" {
  source            = "./policies/alb-security-baseline.sentinel"
  enforcement_level = "hard-mandatory"
}

# ---------------------------------------------------------------------------
# Lambda — terraform-aws-modules/lambda/aws
# ---------------------------------------------------------------------------

policy "lambda-vpc-config-required" {
  source            = "./policies/lambda-vpc-config-required.sentinel"
  enforcement_level = "advisory"
}

# ---------------------------------------------------------------------------
# Cross-cutting
# ---------------------------------------------------------------------------

policy "required-tags" {
  source            = "./policies/required-tags.sentinel"
  enforcement_level = "soft-mandatory"
}

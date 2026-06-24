sentinel {
  features = {
    terraform = true
  }
}

module "tfplan-functions" {
  source = "./lib/tfplan-functions.sentinel"
}

policy "acm-certificate-baseline" {
  source            = "./policies/acm-certificate-baseline.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "alb-security-baseline" {
  source            = "./policies/alb-security-baseline.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "amg-authentication-required" {
  source            = "./policies/amg-authentication-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "amp-workspace-baseline" {
  source            = "./policies/amp-workspace-baseline.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "apigateway-v2-authorization-required" {
  source            = "./policies/apigateway-v2-authorization-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "appconfig-validators-required" {
  source            = "./policies/appconfig-validators-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "app-runner-no-public-access" {
  source            = "./policies/app-runner-no-public-access.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "appsync-no-api-key-auth" {
  source            = "./policies/appsync-no-api-key-auth.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "atlantis-security-baseline" {
  source            = "./policies/atlantis-security-baseline.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "autoscaling-no-public-ip" {
  source            = "./policies/autoscaling-no-public-ip.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "batch-security-groups-required" {
  source            = "./policies/batch-security-groups-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "cloudfront-https-only" {
  source            = "./policies/cloudfront-https-only.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "cloudwatch-log-retention" {
  source            = "./policies/cloudwatch-log-retention.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "customer-gateway-baseline" {
  source            = "./policies/customer-gateway-baseline.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "datadog-forwarders-security-baseline" {
  source            = "./policies/datadog-forwarders-security-baseline.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "dms-no-public-access" {
  source            = "./policies/dms-no-public-access.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "dynamodb-encryption-required" {
  source            = "./policies/dynamodb-encryption-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "ebs-encryption-required" {
  source            = "./policies/ebs-encryption-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "ec2-imdsv2-required" {
  source            = "./policies/ec2-imdsv2-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "ecr-scan-on-push" {
  source            = "./policies/ecr-scan-on-push.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "ecs-no-public-ip" {
  source            = "./policies/ecs-no-public-ip.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "efs-encryption-required" {
  source            = "./policies/efs-encryption-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "eks-control-plane-logging" {
  source            = "./policies/eks-control-plane-logging.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "eks-pod-identity-baseline" {
  source            = "./policies/eks-pod-identity-baseline.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "eks-private-endpoint-required" {
  source            = "./policies/eks-private-endpoint-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "elasticache-encryption-at-rest" {
  source            = "./policies/elasticache-encryption-at-rest.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "elb-security-baseline" {
  source            = "./policies/elb-security-baseline.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "emr-security-configuration-required" {
  source            = "./policies/emr-security-configuration-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "eventbridge-bus-policy-required" {
  source            = "./policies/eventbridge-bus-policy-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "fsx-encryption-required" {
  source            = "./policies/fsx-encryption-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "global-accelerator-flow-logs" {
  source            = "./policies/global-accelerator-flow-logs.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "iam-no-wildcard-actions" {
  source            = "./policies/iam-no-wildcard-actions.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "key-pair-algorithm-baseline" {
  source            = "./policies/key-pair-algorithm-baseline.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "kms-key-rotation-enabled" {
  source            = "./policies/kms-key-rotation-enabled.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "lambda-vpc-config-required" {
  source            = "./policies/lambda-vpc-config-required.sentinel"
  enforcement_level = "advisory"
}

policy "memorydb-tls-required" {
  source            = "./policies/memorydb-tls-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "msk-encryption-no-public-access" {
  source            = "./policies/msk-encryption-no-public-access.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "network-firewall-deletion-protection" {
  source            = "./policies/network-firewall-deletion-protection.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "nlb-security-baseline" {
  source            = "./policies/nlb-security-baseline.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "notify-slack-sns-encryption" {
  source            = "./policies/notify-slack-sns-encryption.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "opensearch-encryption-required" {
  source            = "./policies/opensearch-encryption-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "pricing-module-baseline" {
  source            = "./policies/pricing-module-baseline.sentinel"
  enforcement_level = "advisory"
}

policy "rds-encryption-at-rest" {
  source            = "./policies/rds-encryption-at-rest.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "rds-no-public-access" {
  source            = "./policies/rds-no-public-access.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "rds-proxy-tls-required" {
  source            = "./policies/rds-proxy-tls-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "redshift-encryption-no-public-access" {
  source            = "./policies/redshift-encryption-no-public-access.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "required-tags" {
  source            = "./policies/required-tags.sentinel"
  enforcement_level = "soft-mandatory"
}

policy "route53-no-force-destroy" {
  source            = "./policies/route53-no-force-destroy.sentinel"
  enforcement_level = "hard-mandatory"
}

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

policy "secrets-manager-kms-required" {
  source            = "./policies/secrets-manager-kms-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "sg-no-public-ingress" {
  source            = "./policies/sg-no-public-ingress.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "sns-encryption-required" {
  source            = "./policies/sns-encryption-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "solutions-module-baseline" {
  source            = "./policies/solutions-module-baseline.sentinel"
  enforcement_level = "advisory"
}

policy "sqs-encryption-required" {
  source            = "./policies/sqs-encryption-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "ssm-securestring-for-secrets" {
  source            = "./policies/ssm-securestring-for-secrets.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "step-functions-logging-required" {
  source            = "./policies/step-functions-logging-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "transit-gateway-auto-accept-disabled" {
  source            = "./policies/transit-gateway-auto-accept-disabled.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "vpc-dns-support-enabled" {
  source            = "./policies/vpc-dns-support-enabled.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "vpc-flow-logs-required" {
  source            = "./policies/vpc-flow-logs-required.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "vpn-tunnel-logging-enabled" {
  source            = "./policies/vpn-tunnel-logging-enabled.sentinel"
  enforcement_level = "hard-mandatory"
}

policy "wafv2-logging-required" {
  source            = "./policies/wafv2-logging-required.sentinel"
  enforcement_level = "hard-mandatory"
}


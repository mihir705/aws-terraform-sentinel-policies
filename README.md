# AWS Terraform Sentinel Policies

Sentinel policy-as-code guardrails for infrastructure built with [terraform-aws-modules](https://github.com/terraform-aws-modules). Policies evaluate Terraform plans via the `tfplan/v2` import and validate the **resolved AWS resource types** that modules create—not module blocks themselves.

Designed for [HCP Terraform](https://developer.hashicorp.com/terraform/cloud-docs) (Terraform Cloud/Enterprise) policy sets, with local testing via the Sentinel CLI.

---

## Overview

| Attribute | Detail |
|-----------|--------|
| **Scope** | Tier-1 [terraform-aws-modules](https://registry.terraform.io/namespaces/terraform-aws-modules) (IAM, VPC, S3, KMS, SG, EKS, RDS, EC2, ALB, Lambda) |
| **Import** | `tfplan/v2` |
| **Policy count** | 16 policies across 10 module families |
| **Enforcement** | Configurable per policy (`hard-mandatory`, `soft-mandatory`, `advisory`) |

### Design principles

1. **Module-aware, resource-targeted** — Each policy documents the terraform-aws-module it aligns with and the underlying AWS resources it inspects.
2. **Shared library** — Common plan-inspection logic lives in `lib/tfplan-functions.sentinel` (adapted from [HashiCorp terraform-sentinel-policies](https://github.com/hashicorp/terraform-sentinel-policies)).
3. **Actionable violations** — Policies print resource addresses and attribute paths to speed up remediation.
4. **Testable** — Mock tfplan fixtures and `sentinel test` harness under `test/`.

---

## Repository structure

```
aws-terraform-sentinel-policies/
├── sentinel.hcl                 # Root policy set registration
├── lib/
│   └── tfplan-functions.sentinel
├── policies/
│   ├── *.sentinel               # One policy per file (flat layout for Sentinel test)
│   └── test/
│       ├── s3-public-access-block/
│       │   ├── pass.hcl
│       │   └── fail.hcl
│       └── kms-key-rotation-enabled/
│           └── pass.hcl
├── test/
│   └── mocks/                   # Shared mock tfplan/v2 modules
└── .github/workflows/
    └── sentinel-test.yml
```

Sentinel discovers test cases at `policies/test/<policy-name>/*.hcl` relative to each policy file.

---

## Policy catalog

### S3 — `terraform-aws-modules/s3-bucket/aws`

| Policy | AWS resources | Rule | Enforcement |
|--------|---------------|------|-------------|
| `s3-public-access-block` | `aws_s3_bucket`, `aws_s3_bucket_public_access_block` | All four Block Public Access settings enabled | hard-mandatory |
| `s3-server-side-encryption` | `aws_s3_bucket`, `aws_s3_bucket_server_side_encryption_configuration` | SSE with `AES256` or `aws:kms` | hard-mandatory |
| `s3-versioning-enabled` | `aws_s3_bucket`, `aws_s3_bucket_versioning` | Versioning enabled | hard-mandatory |

**Module alignment:** Set `block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`, `server_side_encryption_configuration`, and `versioning = { enabled = true }` in the s3-bucket module.

### VPC — `terraform-aws-modules/vpc/aws`

| Policy | AWS resources | Rule | Enforcement |
|--------|---------------|------|-------------|
| `vpc-flow-logs-required` | `aws_vpc`, `aws_flow_log` | At least one flow log per VPC; `traffic_type = ALL` | hard-mandatory |

**Module alignment:** Set `enable_flow_log = true` and `flow_log_traffic_type = "ALL"`.

### IAM — `terraform-aws-modules/iam/aws`

| Policy | AWS resources | Rule | Enforcement |
|--------|---------------|------|-------------|
| `iam-no-wildcard-actions` | `aws_iam_policy`, `aws_iam_role_policy`, `aws_iam_user_policy`, `aws_iam_group_policy` | No `Action` or `NotAction` wildcard (`*`) | hard-mandatory |

### KMS — `terraform-aws-modules/kms/aws`

| Policy | AWS resources | Rule | Enforcement |
|--------|---------------|------|-------------|
| `kms-key-rotation-enabled` | `aws_kms_key` | `enable_key_rotation = true` | hard-mandatory |

### Security Group — `terraform-aws-modules/security-group/aws`

| Policy | AWS resources | Rule | Enforcement |
|--------|---------------|------|-------------|
| `sg-no-public-ingress` | `aws_security_group`, `aws_security_group_rule`, `aws_vpc_security_group_ingress_rule` | No ingress from `0.0.0.0/0` or `::/0` | hard-mandatory |

### EKS — `terraform-aws-modules/eks/aws`

| Policy | AWS resources | Rule | Enforcement |
|--------|---------------|------|-------------|
| `eks-private-endpoint-required` | `aws_eks_cluster` | `endpoint_private_access = true` | hard-mandatory |
| `eks-control-plane-logging` | `aws_eks_cluster` | `enabled_cluster_log_types` includes `api` and `audit` | hard-mandatory |

**Module alignment:** Set `cluster_endpoint_private_access = true` and enable control plane log types in the eks module.

### RDS — `terraform-aws-modules/rds/aws`, `rds-aurora/aws`

| Policy | AWS resources | Rule | Enforcement |
|--------|---------------|------|-------------|
| `rds-encryption-at-rest` | `aws_db_instance`, `aws_rds_cluster` | `storage_encrypted = true` | hard-mandatory |
| `rds-no-public-access` | `aws_db_instance`, `aws_rds_cluster_instance` | `publicly_accessible = false` | hard-mandatory |

### EC2 — `terraform-aws-modules/ec2-instance/aws`

| Policy | AWS resources | Rule | Enforcement |
|--------|---------------|------|-------------|
| `ec2-imdsv2-required` | `aws_instance`, `aws_launch_template` | `metadata_options.http_tokens = required` | hard-mandatory |

### ALB — `terraform-aws-modules/alb/aws`

| Policy | AWS resources | Rule | Enforcement |
|--------|---------------|------|-------------|
| `alb-security-baseline` | `aws_lb` (application) | Deletion protection enabled; access logs enabled | hard-mandatory |

### Lambda — `terraform-aws-modules/lambda/aws`

| Policy | AWS resources | Rule | Enforcement |
|--------|---------------|------|-------------|
| `lambda-vpc-config-required` | `aws_lambda_function` | `vpc_config` with subnets and security groups | advisory |

> **Note:** Lambda VPC enforcement is `advisory` by default because not all functions require VPC placement. Promote to `hard-mandatory` for production workspaces.

### Cross-cutting

| Policy | AWS resources | Rule | Enforcement |
|--------|---------------|------|-------------|
| `required-tags` | All managed `aws_*` resources | Tags: `Environment`, `Owner`, `ManagedBy` | soft-mandatory |

---

## How policies relate to modules

Sentinel evaluates **Terraform plans**, not HCL source. When you use:

```hcl
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
```

The plan contains resolved resources such as `aws_s3_bucket.this` and `aws_s3_bucket_public_access_block.this`. Policies inspect those resource changes—regardless of which wrapper module created them.

---

## Getting started

### Prerequisites

- [Sentinel CLI](https://developer.hashicorp.com/sentinel/docs/install) `>= 0.27.0`
- (Optional) HCP Terraform organization for remote policy enforcement

### Install Sentinel CLI

**Windows (PowerShell):**

```powershell
$version = "0.27.0"
$dest = "$env:USERPROFILE\bin"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Invoke-WebRequest -Uri "https://releases.hashicorp.com/sentinel/$version/sentinel_${version}_windows_amd64.zip" `
  -OutFile "$env:TEMP\sentinel.zip"
Expand-Archive -Path "$env:TEMP\sentinel.zip" -DestinationPath $dest -Force

# Add to PATH (restart PowerShell after this)
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
[Environment]::SetEnvironmentVariable("Path", "$userPath;$dest", "User")

sentinel version
```

**macOS (Homebrew):**

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/sentinel
```

### Run tests locally

**Windows (PowerShell) — recommended:**

```powershell
cd C:\Linkedin-Projects\aws-terraform-sentinel-policies
.\scripts\test.ps1
```

Or manually:

```powershell
$policies = (Get-ChildItem policies -Filter *.sentinel).FullName
sentinel test @policies
```

**Linux / macOS:**

```bash
sentinel test policies/*.sentinel
```

**Test a single policy:**

```powershell
sentinel test policies/s3-public-access-block.sentinel
```

Expected output:

```text
PASS - policies/s3-public-access-block.sentinel
  PASS - policies\test\s3-public-access-block\pass.hcl
  PASS - policies\test\s3-public-access-block\fail.hcl
```

### Run one policy with mock plan data (optional)

Do **not** use `sentinel apply -config sentinel.hcl` — that file registers the policy set for HCP Terraform but has **no mock Terraform plan**, which causes a panic locally.

Use a config under `apply/` that includes mock `tfplan/v2` data:

```powershell
sentinel apply -config apply/s3-public-access-block-pass.hcl policies/s3-public-access-block.sentinel
```

Expected: `Pass - s3-public-access-block.sentinel`

### Enforce in HCP Terraform

1. Create a **Policy Set** in your organization.
2. Connect this repository (VCS-driven policy set).
3. Select the workspace(s) that deploy terraform-aws-modules infrastructure.
4. Adjust enforcement levels in `sentinel.hcl` to match your governance tier.

---

## Adding a new policy

1. Create `policies/<service>/<policy-name>.sentinel` using the header comment template:

   ```sentinel
   # Short description
   #
   # Module : terraform-aws-modules/<module>/aws
   # Resource: aws_<resource_type>
   ```

2. Import shared helpers:

   ```sentinel
   import "tfplan/v2" as tfplan
   import "tfplan-functions" as plan
   ```

3. Register the policy in `sentinel.hcl`.
4. Add mock fixtures under `test/mocks/` and test cases under `policies/test/<policy-name>/`.
5. Run `sentinel test policies/<policy-name>.sentinel`.

---

## Enforcement levels

| Level | Behavior |
|-------|----------|
| `hard-mandatory` | Plan blocked on violation |
| `soft-mandatory` | Violation recorded; run can proceed with override |
| `advisory` | Informational; visible in policy results |

Security controls (encryption, public access, IAM wildcards) default to **hard-mandatory**. Tagging defaults to **soft-mandatory**.

---

## Roadmap — additional terraform-aws-modules

The following registry modules are not yet covered and are candidates for future policies:

`acm`, `apigateway-v2`, `cloudfront`, `dynamodb-table`, `ecr`, `ecs`, `elasticache`, `secrets-manager`, `sns`, `sqs`, `ssm-parameter`, `transit-gateway`, `wafv2`

Contributions for these modules follow the same pattern: map module outputs to AWS resource types, write a focused policy, add tests.

---

## References

- [terraform-aws-modules organization](https://github.com/terraform-aws-modules)
- [Sentinel language documentation](https://developer.hashicorp.com/sentinel/docs)
- [tfplan/v2 import reference](https://developer.hashicorp.com/sentinel/docs/imports/terraform/tfplan-v2)
- [HashiCorp terraform-sentinel-policies](https://github.com/hashicorp/terraform-sentinel-policies)

---

## License

MIT — see repository license file.

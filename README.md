# AWS Terraform Sentinel Policies

Sentinel policy-as-code guardrails for infrastructure built with [terraform-aws-modules](https://github.com/terraform-aws-modules). Policies evaluate Terraform plans via the `tfplan/v2` import and validate the **resolved AWS resource types** that modules create—not module blocks themselves.

Designed for [HCP Terraform](https://developer.hashicorp.com/terraform/cloud-docs) (Terraform Cloud/Enterprise) policy sets, with local testing via the Sentinel CLI.

---

## Overview

| Attribute | Detail |
|-----------|--------|
| **Scope** | All **57** published [terraform-aws-modules](https://registry.terraform.io/namespaces/terraform-aws-modules) |
| **Import** | `tfplan/v2` |
| **Policy count** | **63** policies (module-specific + cross-cutting) |
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

## Module coverage (all 57 terraform-aws-modules)

Every published module in the `terraform-aws-modules` namespace has at least one aligned Sentinel policy. Wrapper modules (`solutions`, `pricing`, `datadog-forwarders`) delegate to underlying AWS resources or pass via advisory policies where no resources are created.

| Module | Policy(ies) |
|--------|-------------|
| `acm` | `acm-certificate-baseline` |
| `alb` | `alb-security-baseline` |
| `apigateway-v2` | `apigateway-v2-authorization-required` |
| `app-runner` | `app-runner-no-public-access` |
| `appconfig` | `appconfig-validators-required` |
| `appsync` | `appsync-no-api-key-auth` |
| `atlantis` | `atlantis-security-baseline` |
| `autoscaling` | `autoscaling-no-public-ip` |
| `batch` | `batch-security-groups-required` |
| `cloudfront` | `cloudfront-https-only` |
| `cloudwatch` | `cloudwatch-log-retention` |
| `customer-gateway` | `customer-gateway-baseline` |
| `datadog-forwarders` | `datadog-forwarders-security-baseline` |
| `dms` | `dms-no-public-access` |
| `dynamodb-table` | `dynamodb-encryption-required` |
| `ebs-optimized` | `ebs-encryption-required` |
| `ec2-instance` | `ec2-imdsv2-required` |
| `ecr` | `ecr-scan-on-push` |
| `ecs` | `ecs-no-public-ip` |
| `efs` | `efs-encryption-required` |
| `eks` | `eks-private-endpoint-required`, `eks-control-plane-logging` |
| `eks-pod-identity` | `eks-pod-identity-baseline` |
| `elasticache` | `elasticache-encryption-at-rest` |
| `elb` | `elb-security-baseline` |
| `emr` | `emr-security-configuration-required` |
| `eventbridge` | `eventbridge-bus-policy-required` |
| `fsx` | `fsx-encryption-required` |
| `global-accelerator` | `global-accelerator-flow-logs` |
| `iam` | `iam-no-wildcard-actions` |
| `key-pair` | `key-pair-algorithm-baseline` |
| `kms` | `kms-key-rotation-enabled` |
| `lambda` | `lambda-vpc-config-required` |
| `managed-service-grafana` | `amg-authentication-required` |
| `managed-service-prometheus` | `amp-workspace-baseline` |
| `memory-db` | `memorydb-tls-required` |
| `msk-kafka-cluster` | `msk-encryption-no-public-access` |
| `network-firewall` | `network-firewall-deletion-protection` |
| `notify-slack` | `notify-slack-sns-encryption` |
| `opensearch` | `opensearch-encryption-required` |
| `pricing` | `pricing-module-baseline` (advisory — data sources only) |
| `rds` | `rds-encryption-at-rest`, `rds-no-public-access` |
| `rds-aurora` | `rds-encryption-at-rest`, `rds-no-public-access` |
| `rds-proxy` | `rds-proxy-tls-required` |
| `redshift` | `redshift-encryption-no-public-access` |
| `route53` | `route53-no-force-destroy` |
| `s3-bucket` | `s3-public-access-block`, `s3-server-side-encryption`, `s3-versioning-enabled` |
| `secrets-manager` | `secrets-manager-kms-required` |
| `security-group` | `sg-no-public-ingress` |
| `sns` | `sns-encryption-required` |
| `solutions` | `solutions-module-baseline` (advisory — composed modules) |
| `sqs` | `sqs-encryption-required` |
| `ssm-parameter` | `ssm-securestring-for-secrets` |
| `step-functions` | `step-functions-logging-required` |
| `transit-gateway` | `transit-gateway-auto-accept-disabled` |
| `vpc` | `vpc-flow-logs-required`, `vpc-dns-support-enabled` |
| `vpn-gateway` | `vpn-tunnel-logging-enabled` |
| `wafv2` | `wafv2-logging-required` |
| **NLB** (via `alb` module) | `nlb-security-baseline` |
| **All modules** | `required-tags` (cross-cutting) |

---

## Policy catalog (by domain)

See `policies/*.sentinel` for full resource types and module headers. All policies default to `hard-mandatory` unless noted.

| Domain | Policies |
|--------|----------|
| Foundation & security | `s3-*`, `kms-*`, `iam-*`, `secrets-manager-*`, `sg-*`, `required-tags` |
| Networking & edge | `vpc-*`, `alb-*`, `nlb-*`, `elb-*`, `cloudfront-*`, `apigateway-v2-*`, `wafv2-*`, `global-accelerator-*`, `transit-gateway-*`, `vpn-*`, `customer-gateway-*`, `network-firewall-*` |
| Compute & containers | `ec2-*`, `ebs-*`, `autoscaling-*`, `lambda-*`, `ecs-*`, `ecr-*`, `eks-*`, `app-runner-*`, `batch-*`, `emr-*`, `atlantis-*` |
| Data & messaging | `rds-*`, `dynamodb-*`, `elasticache-*`, `memorydb-*`, `efs-*`, `fsx-*`, `msk-*`, `opensearch-*`, `redshift-*`, `sns-*`, `sqs-*`, `notify-slack-*`, `dms-*` |
| Observability & config | `cloudwatch-*`, `eventbridge-*`, `step-functions-*`, `ssm-*`, `appconfig-*`, `appsync-*`, `acm-*`, `amg-*`, `amp-*`, `route53-*`, `key-pair-*`, `datadog-forwarders-*` |
| Advisory | `pricing-module-baseline`, `solutions-module-baseline`, `lambda-vpc-config-required` |

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

## Future enhancements

All 57 registry modules have baseline coverage. Planned improvements: deeper per-module rules, additional pass/fail unit tests, and policy parameterization via Sentinel params.

---

## References

- [terraform-aws-modules organization](https://github.com/terraform-aws-modules)
- [Sentinel language documentation](https://developer.hashicorp.com/sentinel/docs)
- [tfplan/v2 import reference](https://developer.hashicorp.com/sentinel/docs/imports/terraform/tfplan-v2)
- [HashiCorp terraform-sentinel-policies](https://github.com/hashicorp/terraform-sentinel-policies)

---

## License

MIT — see repository license file.

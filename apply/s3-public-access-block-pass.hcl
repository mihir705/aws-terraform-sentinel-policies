# Local apply config with mock tfplan data (paths relative to repo root).
# Usage: sentinel apply -config apply/s3-public-access-block-pass.hcl policies/s3-public-access-block.sentinel

module "tfplan-functions" {
  source = "./lib/tfplan-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "./test/mocks/s3-public-access-block-pass.sentinel"
  }
}

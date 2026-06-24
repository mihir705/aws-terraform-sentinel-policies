module "tfplan-functions" {
  source = "../../../lib/tfplan-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "../../../test/mocks/s3-public-access-block-pass.sentinel"
  }
}

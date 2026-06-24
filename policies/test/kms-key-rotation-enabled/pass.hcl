module "tfplan-functions" {
  source = "../../../lib/tfplan-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "../../../test/mocks/kms-key-rotation-pass.sentinel"
  }
}

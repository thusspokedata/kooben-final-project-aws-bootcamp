resource "random_string" "random_suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  sufix    = "${var.tags.project}-${var.tags.env}-${var.tags.region}"
  s3_sufix = "${var.tags.project}-${var.tags.region}-${random_string.random_suffix.id}"
  random_suffix = random_string.random_suffix.id
}
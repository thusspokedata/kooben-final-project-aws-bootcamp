locals {
  sufix    = "${var.tags.project}-${var.tags.env}-${var.tags.region}"
  s3_sufix = "${var.tags.project}-${random_string.sufijo_s3.id}"
}

resource "random_string" "sufijo_s3" {
  length  = 4
  special = false
  upper   = false
}
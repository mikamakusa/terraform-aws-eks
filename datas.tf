data "aws_subnet" "this" {
  count = var.subnet_id ? 1 : 0
  id    = var.subnet_id
}

data "aws_security_group" "this" {
  count = var.security_group_id ? 1 : 0
  id    = var.security_group_id
}

data "aws_kms_key" "this" {
  count  = var.kms_key_id ? 1 : 0
  key_id = var.kms_key_id
}

data "aws_outposts_outpost" "this" {
  count = var.outpost_name ? 1 : 0
  name  = var.outpost_name
}
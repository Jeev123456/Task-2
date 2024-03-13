locals {
  additional_tags = {
    "Environment" = var.environment
  }

  tags = merge(var.common_tags, local.additional_tags)
  
}

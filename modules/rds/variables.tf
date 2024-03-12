variable "identifier" {
  description = "The identifier for the RDS instance"
}

variable "allocated_storage" {
  description = "The amount of storage to allocate to the RDS instance"
}

variable "username" {
  description = "The username for the master user"
}

variable "password" {
  description = "The password for the master user"
}


variable "rds_subnet_ids" {
  description = "Subnet IDs for RDS instance."
  type        = list(string)
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags for resources"
}

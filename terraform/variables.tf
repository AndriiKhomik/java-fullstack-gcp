variable "project_id" {
  description = "Project id"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "Region"
  type        = string
  sensitive   = true
}

variable "user" {
  description = "User"
  type        = string
}

variable "email" {
  description = "Email"
  type        = string
}

variable "prefix" {
  type    = string
  default = "main"
}

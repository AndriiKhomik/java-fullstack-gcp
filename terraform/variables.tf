variable "project_id" {
  description = "Project id"
  type        = string
  sensitive   = true
  default     = "ferrous-amphora-435308-b9"
}

variable "region" {
  description = "Region"
  type        = string
  sensitive   = true
  default     = "us-central1"
}

variable "user" {
  description = "User"
  type        = string
  default     = "andrii_khomik"
}

variable "email" {
  description = "Email"
  type        = string
  default     = "terrafofm-sa@ferrous-amphora-435308-b9.iam.gserviceaccount.com"
}

variable "prefix" {
  type    = string
  default = "main"
}

variable "machine_type" {
  type        = string
  description = "Machine type"
}

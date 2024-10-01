terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
  required_version = ">= 0.13"
}

provider "google" {
  project     = var.project_id
  # credentials = file("gcp-credentials.json")
  region      = var.region
  zone        = "${var.region}-c"
}

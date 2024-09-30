resource "google_compute_network" "terraform_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "terraform_subnetwork" {
  name          = "terraform-subnetwork"
  ip_cidr_range = "10.20.0.0/16"
  region        = var.region
  network       = google_compute_network.terraform_network.id
}

# resource "google_compute_address" "static_ip" {
#   name = "website-address"
# }

module "firewall" {
  source   = "./modules/firewall"
  project  = var.project_id
  vpc_name = google_compute_network.terraform_network.name
}

module "frontend" {
  source                    = "./modules/frontend"
  google_compute_network    = google_compute_network.terraform_network.self_link
  google_compute_subnetwork = google_compute_subnetwork.terraform_subnetwork.self_link
  # google_compute_address    = google_compute_address.static_ip.address
  region       = var.region
  machine_type = var.machine_type
}

module "backend" {
  source                    = "./modules/backend"
  google_compute_network    = google_compute_network.terraform_network.self_link
  google_compute_subnetwork = google_compute_subnetwork.terraform_subnetwork.self_link
  # google_compute_address    = google_compute_address.static_ip.address
  region       = var.region
  machine_type = var.machine_type
}

module "mongodb" {
  source                    = "./modules/mongodb"
  google_compute_network    = google_compute_network.terraform_network.self_link
  google_compute_subnetwork = google_compute_subnetwork.terraform_subnetwork.self_link
  # google_compute_address    = google_compute_address.static_ip.address
  region       = var.region
  machine_type = var.machine_type
}

module "postgres" {
  source                    = "./modules/postgres"
  google_compute_network    = google_compute_network.terraform_network.self_link
  google_compute_subnetwork = google_compute_subnetwork.terraform_subnetwork.self_link
  # google_compute_address    = google_compute_address.static_ip.address
  region       = var.region
  machine_type = var.machine_type
}

module "redis" {
  source                    = "./modules/redis"
  google_compute_network    = google_compute_network.terraform_network.self_link
  google_compute_subnetwork = google_compute_subnetwork.terraform_subnetwork.self_link
  # google_compute_address    = google_compute_address.static_ip.address
  region       = var.region
  machine_type = var.machine_type
}

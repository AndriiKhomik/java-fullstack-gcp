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

module "firewall" {
  source   = "./modules/firewall"
  project  = var.project_id
  vpc_name = google_compute_network.terraform_network.name
}

resource "google_compute_address" "static_ip" {
  name = "website-address"
}

module "frontend" {
  source                    = "./modules/frontend"
  google_compute_network    = google_compute_network.terraform_network.self_link
  google_compute_subnetwork = google_compute_subnetwork.terraform_subnetwork.self_link
  google_compute_address    = google_compute_address.static_ip.address
}

# resource "google_compute_instance" "backend" {
#   name                      = "backend"
#   machine_type              = "f1-micro"
#   zone                      = "${var.region}-a"
#   allow_stopping_for_update = true

#   tags = ["sshfw", "webserverfw", "icmp-allow"]

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }

#   metadata = {
#     ssh-keys = ""
#   }

#   network_interface {
#     network    = google_compute_network.terraform_network.self_link
#     subnetwork = google_compute_subnetwork.terraform_subnetwork.self_link

#     access_config {

#     }
#   }
# }

# resource "google_compute_instance" "mongodb" {
#   name                      = "mongodb"
#   machine_type              = "f1-micro"
#   zone                      = "${var.region}-a"
#   allow_stopping_for_update = true

#   tags = ["sshfw", "mongodbfw", "icmp-allow"]

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#     }
#   }

#   network_interface {
#     network    = google_compute_network.terraform_network.self_link
#     subnetwork = google_compute_subnetwork.terraform_subnetwork.self_link

#     access_config {

#     }
#   }

#   metadata_startup_script = file("mongo.sh")

#   # service_account {

#   # }
# }

# output "mongo_ip" {
#   value = google_compute_instance.mongodb.network_interface[0].access_config[0].nat_ip
# }

output "user" {
  value = var.user
}

resource "google_compute_instance" "webserver" {
  name                      = "frontend-instance"
  machine_type              = "f1-micro"
  zone                      = "us-central1-a"
  allow_stopping_for_update = true

  tags = ["sshfw", "webserverfw", "icmp-allow"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = var.google_compute_network
    subnetwork = var.google_compute_subnetwork

    access_config {
      nat_ip = var.google_compute_address
    }
  }

  metadata_startup_script = file("frontend.sh")
}

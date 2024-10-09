resource "google_compute_instance" "backend" {
  name                      = "tomcat"
  machine_type              = var.machine_type
  zone                      = "${var.region}-b"
  allow_stopping_for_update = true

  tags = ["sshfw", "backendfw", "icmp-allow"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  metadata = {
    ssh-keys = ""
  }

  network_interface {
    network    = var.google_compute_network
    subnetwork = var.google_compute_subnetwork

    access_config {

    }
  }
}

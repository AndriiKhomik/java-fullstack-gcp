resource "google_compute_instance" "webserver" {
  name                      = "nginx"
  machine_type              = var.machine_type
  zone                      = "${var.region}-b"
  allow_stopping_for_update = true

  tags = ["sshfw", "webserverfw", "icmp-allow", "nodeexporterfw", "prometheusfw", "grafanafw"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  metadata = {
    ssh-keys = "jenkins:${file("id_rsa.pub")}"
  }

  network_interface {
    network    = var.google_compute_network
    subnetwork = var.google_compute_subnetwork

    access_config {
    }
  }
}

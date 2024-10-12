resource "google_compute_instance" "grafana-ptometheus" {
  name         = "grafana-prometheus"
  machine_type = var.machine_type
  zone         = "${var.region}-b"

  tags = ["sshfw", "prometheusfw", "grafanafw", "icmp-allow"]

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

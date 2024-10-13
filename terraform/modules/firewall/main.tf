resource "google_compute_firewall" "ssh" {
  name    = "ssh-firewall"
  project = var.project
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["sshfw"]
  direction     = "INGRESS"
  priority      = "20"
}

resource "google_compute_firewall" "webserver" {
  name    = "http-https-firewall"
  project = var.project
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["webserverfw"]
}

resource "google_compute_firewall" "frontend" {
  name    = "frontend-firewall"
  network = var.vpc_name
  project = var.project

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["frontendfw"]
}

resource "google_compute_firewall" "backend" {
  name    = "backend-firewall"
  network = var.vpc_name
  project = var.project

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["backendfw"]
}

resource "google_compute_firewall" "postgres" {
  name    = "postgresql-firewall"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["postgresfw"]
}

resource "google_compute_firewall" "redis" {
  name    = "redis-firewall"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["6379"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["redisfw"]
}

resource "google_compute_firewall" "mongodb" {
  name    = "mongodb-firewall"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["mongodbfw"]
}

resource "google_compute_firewall" "allow_icmp" {
  name    = "allow-icmp"
  network = var.vpc_name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["icmp-allow"]
}

resource "google_compute_firewall" "grafana" {
  name    = "grafana-firewall"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["grafanafw"]
}

resource "google_compute_firewall" "prometheus" {
  name    = "prometheus-firewall"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["9090"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["prometheusfw"]
}

resource "google_compute_firewall" "node-exporter" {
  name    = "node-exporter-firewall"
  network = var.vpc_name

  allow {
    protocol = "tcp"
    ports    = ["9100"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["nodeexporterfw"]
}

output "firewall_ssh" {
  value = google_compute_firewall.ssh
}

output "firewall_webserver" {
  value = google_compute_firewall.webserver
}

output "firewall_frontend" {
  value = google_compute_firewall.frontend
}

output "firewall_backend" {
  value = google_compute_firewall.backend
}

output "firewall_postgres" {
  value = google_compute_firewall.postgres
}

output "firewall_redis" {
  value = google_compute_firewall.redis
}

output "firewall_mongodb" {
  value = google_compute_firewall.mongodb
}

output "firewall_icmp" {
  value = google_compute_firewall.allow_icmp
}

output "grafana_prometheus_vm_ip" {
  value = google_compute_instance.grafana-ptometheus.network_interface[0].access_config[0].nat_ip
}

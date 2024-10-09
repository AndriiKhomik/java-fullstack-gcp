resource "google_compute_instance" "webserver" {
  name                      = "nginx"
  machine_type              = var.machine_type
  zone                      = "${var.region}-b"
  allow_stopping_for_update = true

  tags = ["sshfw", "webserverfw", "icmp-allow"]

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

# resource "null_resource" "run_ansible" {
#   depends_on = [google_compute_instance.webserver]

#   provisioner "local-exec" {
#     # command     = "ansible-playbook -i /var/lib/jenkins/workspace/artifacts-test/ansible/inventory.yml /var/lib/jenkins/workspace/artifacts-test/ansible/java-app/nginx-role.yml"
#     command     = "ansible-playbook -i ~/Desktop/java-fullstack-gcp/ansible/inventory.yml ~/Desktop/java-fullstack-gcp/ansible/java-app/nginx-role.yml"
#     working_dir = path.module
#   }
# }

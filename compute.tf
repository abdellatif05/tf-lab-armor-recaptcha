# instance template
resource "google_compute_instance_template" "default" {
  name         = "l7-xlb-mig-template"
  machine_type = "e2-small"
  tags         = ["allow-health-check"]

  network_interface {
    network    = google_compute_network.default.id
    subnetwork = google_compute_subnetwork.default.id
    access_config {
      # add external ip to fetch packages
    }
  }
  disk {
    source_image = "debian-cloud/debian-12"
    auto_delete  = true
    boot         = true
  }

  # install apache2
  metadata = {
    startup-script = <<-EOF1
      #! /bin/bash
      sudo apt-get update
      sudo apt-get install apache2 -y
      sudo a2ensite default-ssl
      sudo a2enmod ssl
    EOF1
  }
  lifecycle {
    create_before_destroy = true
  }
}

# health check
resource "google_compute_health_check" "default" {
  name = "l7-xlb-hc"
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

# MIG
resource "google_compute_instance_group_manager" "default" {
  name = "l7-xlb-mig1"
  zone = var.zone
  named_port {
    name = "http"
    port = 80
  }
  version {
    instance_template = google_compute_instance_template.default.id
    name              = "primary"
  }
  base_instance_name = "vm"
  target_size        = 1
}

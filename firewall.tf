# allow access from health check ranges
resource "google_compute_firewall" "default" {
  name          = "l7-xlb-fw-allow-hc"
  direction     = "INGRESS"
  network       = google_compute_network.default.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}

resource "google_compute_firewall" "allow_ssh" {
  name          = "l7-xlb-fw-allow-ssh"
  direction     = "INGRESS"
  network       = google_compute_network.default.id
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = [22]
  }
  target_tags = ["allow-health-check"]
}

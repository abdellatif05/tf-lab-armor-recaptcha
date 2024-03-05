resource "google_compute_network" "default" {
  name                    = "l7-xlb-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  name          = "l7-xlb-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.default.id
}

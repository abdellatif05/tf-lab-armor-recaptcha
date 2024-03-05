provider "google" {
  project = var.project
}

terraform {
  required_providers {
    google = {
      version = "~> 5.19.0"
    }
  }
  required_version = "~> 1.5.2"
}

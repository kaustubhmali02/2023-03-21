terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.59.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.59.0"
    }

  }

  backend "gcs" {
    bucket = "terraform-tf-state-380615"
    prefix = "production"
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  project = var.project
  region  = var.region
  zone    = var.zone
}

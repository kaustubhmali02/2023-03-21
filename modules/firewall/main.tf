resource "google_compute_firewall" "this" {
  name    = "${var.name}-allow-healthcheck"
  network = var.network
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  priority      = 1000
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  target_tags   = var.target_tags_health_check
}

resource "google_compute_firewall" "allow_ssh" {
  name      = "${var.name}-allow-ssh"
  network   = var.network
  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = var.target_tags_proxy_server
}

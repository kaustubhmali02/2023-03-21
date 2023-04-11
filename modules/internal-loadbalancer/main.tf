data "google_compute_health_check" "health_check" {
  name = "${var.name}-healthcheck"
}

resource "google_compute_global_address" "this" {
  name = "${var.name}-ipv4"
}

resource "google_compute_url_map" "http" {
  name = "${var.name}-http"

  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
    https_redirect         = true
  }
}

resource "google_compute_target_http_proxy" "http" {
  name    = "${var.name}-http"
  url_map = google_compute_url_map.http.self_link
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "${var.name}-http"
  target     = google_compute_target_http_proxy.http.self_link
  ip_address = google_compute_global_address.this.address
  port_range = "80"
}

resource "google_compute_http_health_check" "this" {
  name               = "${var.name}-healthcheck"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}

resource "google_compute_backend_service" "this" {
  name        = var.name
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10

  health_checks = [google_compute_http_health_check.this.id]

  backend {
    group                 = var.backend_group
    balancing_mode        = "RATE"
    capacity_scaler       = 1.0
    max_rate_per_instance = 500
  }
}

resource "google_compute_url_map" "https" {
  name            = "${var.name}-https"
  default_service = google_compute_backend_service.this.id
}

resource "google_compute_target_https_proxy" "https" {
  name             = "${var.name}-https"
  url_map          = google_compute_url_map.https.id
  ssl_certificates = [var.ssl_certificates]
}

resource "google_compute_global_forwarding_rule" "https" {
  name       = "${var.name}-https"
  target     = google_compute_target_https_proxy.https.id
  ip_address = google_compute_global_address.this.address
  port_range = "443"
}

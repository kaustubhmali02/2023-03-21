resource "google_compute_autoscaler" "this" {
  name   = "${var.name}-autoscaler"
  zone   = var.zone
  target = var.target

  autoscaling_policy {
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = 30

    cpu_utilization {
      target = 0.72
    }
  }
}
 
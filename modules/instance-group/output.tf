output "google_compute_instance_group" {
  value = google_compute_instance_group_manager.this.instance_group
}

output "google_compute_instance_group_id" {
  value = google_compute_instance_group_manager.this.id
}
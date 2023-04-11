output "google_compute_network_vpc_self_link" {
  value = google_compute_network.vpc.self_link
}

output "google_compute_network_network_name" {
  value = google_compute_network.vpc.name
}

output "google_compute_subnetwork_subnet_self_link" {
  value = google_compute_subnetwork.subnet.self_link
}

output "google_compute_subnetwork_subnet_name" {
  value = google_compute_subnetwork.subnet.name
}
output "db_proxy_public_ip"  {
  value = google_compute_instance.db_proxy.network_interface.0.access_config.0.nat_ip
}
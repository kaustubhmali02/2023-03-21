output "db_proxy_public_ip"  {
  value = google_compute_instance.db_proxy.network_interface.0.access_config.0.nat_ip
}

output "db_instance_ip_address" {
  value = google_sql_database_instance.main_primary.ip_address.0.ip_address
}

output "db_instance_name" {
  value = google_sql_database_instance.main_primary.name
}

output "db_table_name" {
  value = google_sql_database.main.name
}
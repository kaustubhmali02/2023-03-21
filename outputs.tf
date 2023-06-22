output "db_proxy_public_ip" {
  value = module.sql-db-instance.db_proxy_public_ip
}

output "Loadbalancer-IPv4-Address" {
  value = module.internal_loadbalancer.Loadbalancer-IPv4-Address
}
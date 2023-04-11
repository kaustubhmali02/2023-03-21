data "google_service_account" "this" {
  account_id = var.project_name
}

module "vpc" {
  source        = "./modules/vpc"
  network       = var.network
  zone          = var.zone
  project       = var.project
  subnet_name   = var.subnet
  ip_cidr_range = var.subnet_cidr_range
  region        = var.region
}

module "autoscalar" {
  source       = "./modules/autoscaler"
  name         = var.name
  zone         = var.zone
  project      = var.project
  region       = var.region
  target       = module.instance_group.google_compute_instance_group_id
  max_replicas = var.maximum_vm_size
  min_replicas = var.minimum_vm_size
  depends_on   = [module.instance_group]
}

module "firewall" {
  source                   = "./modules/firewall"
  name                     = var.name
  network                  = module.vpc.google_compute_network_network_name
  target_tags_health_check = var.tags
  target_tags_proxy_server = var.proxy_server_tags
}

module "ssl" {
  source  = "./modules/ssl"
  zone    = var.zone
  name    = var.name
  project = var.project
  region  = var.region
}

module "instance_template" {
  source                        = "./modules/instance-template"
  project                       = var.project
  name                          = var.name
  deploy_version                = var.deploy_version
  instance_template_description = var.instance_template_description
  tags                          = var.tags
  instance_description          = var.instance_description
  machine_type                  = var.machine_type
  image_name                    = var.image_name
  network                       = module.vpc.google_compute_network_network_name
  subnet                        = module.vpc.google_compute_subnetwork_subnet_name
  email                         = data.google_service_account.this.email
}

module "instance_group" {
  source                             = "./modules/instance-group"
  name                               = var.name
  project                            = var.project
  instance_group_manager_description = var.instance_group_manager_description
  zone                               = var.zone
  deploy_version                     = var.deploy_version
  min_target_size                    = var.minimum_vm_size
  instance_template                  = module.instance_template.google_compute_instance_template_id
}

module "internal_loadbalancer" {
  source           = "./modules/internal-loadbalancer"
  name             = var.name
  backend_group    = module.instance_group.google_compute_instance_group
  ssl_certificates = module.ssl.google_compute_ssl_certificate_id
}

module "sql-db-instance" {
  source                      = "./modules/sql-db-instance"
  name                        = var.name
  network                     = var.network
  network_name                = module.vpc.google_compute_network_network_name
  network_vpc_selflink        = module.vpc.google_compute_network_vpc_self_link
  subnetwork_subnet_self_link = module.vpc.google_compute_subnetwork_subnet_self_link
  db_user_name                = var.user
  db_password                 = var.password
  project                     = var.project
  region                      = var.region
  zone                        = var.zone
  tags_proxy_server           = var.proxy_server_tags
  email                       = data.google_service_account.this.email
}


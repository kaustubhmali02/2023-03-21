resource "google_compute_global_address" "private_ip_block" {
  name          = "private-ip-block"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  ip_version    = "IPV4"
  prefix_length = 20
  network       = var.network_vpc_selflink
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.network_vpc_selflink
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_block.name]
}

resource "google_sql_database" "main" {
  name     = "${var.name}-main"
  instance = google_sql_database_instance.main_primary.name
}

resource "google_sql_database_instance" "main_primary" {
  name                = "${var.name}-mysql-db"
  database_version    = "MYSQL_8_0"
  depends_on          = [google_service_networking_connection.private_vpc_connection]
  deletion_protection = false
  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_size         = 10
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.network_vpc_selflink
    }
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }
  }
}

resource "google_sql_user" "db_user" {
  name     = var.db_user_name
  instance = google_sql_database_instance.main_primary.name
  password = var.db_password
}

# Creating a proxy server to SSH into into our DB 

resource "google_service_account" "proxy_account" {
  account_id = "cloud-sql-proxy"
}

resource "google_project_iam_member" "role" {
  project = var.project
  role    = "roles/cloudsql.editor"
  member  = "serviceAccount:${google_service_account.proxy_account.email}"
}

resource "google_service_account_key" "key" {
  service_account_id = google_service_account.proxy_account.name
}

resource "google_compute_instance" "db_proxy" {
  name                      = "db-proxy"
  machine_type              = "f1-micro"
  zone                      = var.zone
  desired_status            = "RUNNING"
  allow_stopping_for_update = true
  tags                      = var.tags_proxy_server
  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
      size  = 10
      type  = "pd-ssd"
    }
  }
  metadata = {
    enable-oslogin = "TRUE"
  }
  metadata_startup_script = templatefile("${path.module}/run_cloud_sql_proxy.tpl", {
    "db_instance_name"    = "${var.project}:${var.region}:${var.name}-mysql-db",
    "service_account_key" = base64decode("${google_service_account_key.key.private_key}"),
  })
  network_interface {
    network    = var.network_name
    subnetwork = var.subnetwork_subnet_self_link
    access_config {}
  }
  scheduling {
    on_host_maintenance = "MIGRATE"
  }
  service_account {
    email  = var.email
    scopes = ["cloud-platform"]
  }
}

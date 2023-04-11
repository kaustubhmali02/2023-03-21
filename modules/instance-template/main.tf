
data "google_compute_instance_template" "generic" {
  project     = var.project
  name        = "${var.name}-${var.deploy_version}"
  most_recent = true

  depends_on = [google_compute_instance_template.this]
}

data "google_compute_instance_group" "this" {
  name = var.name
}

resource "google_compute_instance_template" "this" {
  name        = "${var.name}-${var.deploy_version}"
  description = var.instance_template_description

  tags = var.tags

  labels = {
    service = var.name
    version = var.deploy_version
  }

  metadata = {
    version                = var.deploy_version
    block-project-ssh-keys = true
  }

  instance_description    = var.instance_description
  machine_type            = var.machine_type
  can_ip_forward          = false
  metadata_startup_script = file("${path.module}/script.sh")

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  disk {
    source_image = var.image_name
    boot         = true
    disk_type    = "pd-balanced"
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnet
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.email
    scopes = ["cloud-platform"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

variable "project" {
  type        = string
  description = "Google Cloud Platform Project ID"
  default     = "terraform-exercise-380615"
}

variable "region" {
  type        = string
  description = "Infrastructure Region"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "Zone"
  default     = "us-central1-a"
}

variable "name" {
  type        = string
  description = "The base name of resources"
  default     = "nginx-app"
}

variable "project_name" {
  type        = string
  description = "Project Name"
  default     = "terraform-exercise"
}

variable "network" {
  type        = string
  description = "VPC Name"
  default     = "vpc-network"
}

variable "subnet" {
  type        = string
  description = "Subnet Name"
  default     = "subnet-1"
}

variable "subnet_cidr_range" {
  type        = string
  description = "Subnets Cidr Range"
  default     = "10.0.1.0/27"
}

variable "minimum_vm_size" {
  type        = number
  description = "Minimum VM size in Instance Group"
  default     = 2
}

variable "maximum_vm_size" {
  type        = number
  description = "Minimum VM size in Instance Group"
  default     = 4
}

variable "tags" {
  type        = list(any)
  description = "Network Tags for resources"
  default     = ["nginx-app"]
}

variable "proxy_server_tags" {
  type        = list(any)
  description = "Proxy Server Tags"
  default     = ["ssh-enabled"]
}

variable "deploy_version" {
  type        = string
  description = "Deployment Version"
  default     = "v1"
}

variable "instance_group_manager_description" {
  type        = string
  description = "Description of instance group manager"
  default     = "Instance group for nginx-app server"
}

variable "image_name" {
  type        = string
  description = "VM Image for Instance Template"
  default     = "nginx-app-vm-image"
}

variable "machine_type" {
  type        = string
  description = "VM Size"
  default     = "e2-medium"
}

variable "instance_description" {
  type        = string
  description = "Description assigned to instances"
  default     = "This template is used to create nginx-app server instances"
}

variable "instance_template_description" {
  type        = string
  description = "Description of instance template"
  default     = "nginx-app server template"
}

variable "user" {
  type        = string
  description = "Database User Name"
  default     = "mysql"
}

variable "password" {
  type        = string
  description = "Database Password"
  default     = "Password@123"
}

variable "proxy-instance-tags" {
  type        = list(any)
  description = "Proxy server tags"
  default     = ["ssh-enabled"]
}

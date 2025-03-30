variable "region" {
  description = "The Alibaba Cloud region to deploy into (TF_VAR_region)"
  type        = string
}

variable "zone_id" {
  description = "The availability zone ID (TF_VAR_zone_id)"
  type        = string
}

variable "project_name" {
  description = "Name of the project, used as prefix for resources (TF_VAR_project_name)"
  type        = string
}

variable "environment" {
  description = "Environment name e.g., dev, staging, prod (TF_VAR_environment)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC (TF_VAR_vpc_cidr)"
  type        = string
}

variable "vswitch_cidr" {
  description = "CIDR block for VSwitch (TF_VAR_vswitch_cidr)"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to connect via SSH (TF_VAR_allowed_ssh_cidr)"
  type        = string
}

variable "instance_type" {
  description = "Alibaba Cloud instance type (TF_VAR_instance_type)"
  type        = string
}

variable "ubuntu_image_id" {
  description = "Ubuntu 24.04 image ID (TF_VAR_ubuntu_image_id)"
  type        = string
}

variable "system_disk_size" {
  description = "Size of the system disk in GB (TF_VAR_system_disk_size)"
  type        = number
}

variable "instance_password" {
  description = "Password for the Ubuntu instance (TF_VAR_instance_password)"
  type        = string
  sensitive   = true
}

variable "internet_bandwidth" {
  description = "Internet bandwidth in Mbps (TF_VAR_internet_bandwidth)"
  type        = number
  default     = 5 # This can stay as default since it's not sensitive
}
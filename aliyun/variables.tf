variable "project_name" {
  description = "Name of the project, used as prefix for resources (TF_VAR_project_name)"
  type        = string
}

variable "instance_type" {
  description = "Alibaba Cloud instance type (TF_VAR_instance_type)"
  type        = string
  default     = "ecs.t5-lc2m1.nano" # Default instance type
}

variable "ubuntu_image_id" {
  description = "Ubuntu 24.04 image ID (TF_VAR_ubuntu_image_id)"
  type        = string
  default     = "ubuntu_24_04_x64_20G_alibase_20250217.vhd"
}

variable "system_disk_size" {
  description = "Size of the system disk in GB (TF_VAR_system_disk_size)"
  type        = number
  default     = 20 # Default system disk size
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

variable "aliyun_access_key" {
  description = "Alibaba Cloud Access Key ID (TF_VAR_aliyun_access_key)"
  type        = string
  sensitive   = true
}

variable "aliyun_secret_key" {
  description = "Alibaba Cloud Secret Access Key (TF_VAR_aliyun_secret_key)"
  type        = string
  sensitive   = true
}

variable "aliyun_region" {
  description = "Alibaba Cloud region (TF_VAR_aliyun_region)"
  type        = string
}

variable "enable_deployment" {
  description = "Toggle to enable/disable the entire deployment"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "vswitch_cidr" {
  description = "CIDR block for VSwitch"
  type        = string
  default     = "172.16.1.0/24"
}

variable "zone_id" {
  description = "Availability Zone ID"
  type        = string
}

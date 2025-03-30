terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "1.246.2"
    }
  }
}

# Configure the Alibaba Cloud Provider
provider "alicloud" {
  region     = var.aliyun_region
  access_key = var.aliyun_access_key
  secret_key = var.aliyun_secret_key
} # Configuration via environment variables

# Security Group Configuration
resource "alicloud_security_group" "sg" {
  count               = var.enable_deployment ? 1 : 0
  security_group_name = "${var.project_name}-sg"
  description         = "Security group for Ubuntu server"
}

# Security Group Rules
resource "alicloud_security_group_rule" "allow_ssh" {
  count             = var.enable_deployment ? 1 : 0
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "22/22"
  security_group_id = alicloud_security_group.sg[0].id
  cidr_ip           = "0.0.0.0/0"
}

# TCP Rules
resource "alicloud_security_group_rule" "allow_tcp_80" {
  count             = var.enable_deployment ? 1 : 0
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "80/80"
  security_group_id = alicloud_security_group.sg[0].id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_tcp_443" {
  count             = var.enable_deployment ? 1 : 0
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "443/443"
  security_group_id = alicloud_security_group.sg[0].id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_tcp_11211" {
  count             = var.enable_deployment ? 1 : 0
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "11211/11211"
  security_group_id = alicloud_security_group.sg[0].id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_tcp_11010" {
  count             = var.enable_deployment ? 1 : 0
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "11010/11010"
  security_group_id = alicloud_security_group.sg[0].id
  cidr_ip           = "0.0.0.0/0"
}

# UDP Rules
resource "alicloud_security_group_rule" "allow_udp_22020" {
  count             = var.enable_deployment ? 1 : 0
  type              = "ingress"
  ip_protocol       = "udp"
  port_range        = "22020/22020"
  security_group_id = alicloud_security_group.sg[0].id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_udp_11010" {
  count             = var.enable_deployment ? 1 : 0
  type              = "ingress"
  ip_protocol       = "udp"
  port_range        = "11010/11010"
  security_group_id = alicloud_security_group.sg[0].id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "allow_udp_11011" {
  count             = var.enable_deployment ? 1 : 0
  type              = "ingress"
  ip_protocol       = "udp"
  port_range        = "11011/11011"
  security_group_id = alicloud_security_group.sg[0].id
  cidr_ip           = "0.0.0.0/0"
}

# ECS Instance Configuration
resource "alicloud_instance" "ubuntu" {
  count                = var.enable_deployment ? 1 : 0
  instance_name        = "${var.project_name}-ubuntu"
  instance_type        = var.instance_type
  security_groups      = [alicloud_security_group.sg[0].id]
  image_id             = var.ubuntu_image_id
  system_disk_category = "cloud_efficiency"
  system_disk_size     = var.system_disk_size

  password  = var.instance_password
  host_name = "${var.project_name}-ubuntu"

  internet_max_bandwidth_out = var.internet_bandwidth

  tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
  }
}
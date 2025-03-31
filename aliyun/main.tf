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

data "alicloud_zones" "default" {
  available_disk_category     = "cloud_efficiency"
  available_resource_creation = "VSwitch"
  available_instance_type     = var.instance_type
}

# Security Group Configuration
resource "alicloud_security_group" "sg" {
  count               = var.enable_deployment ? 1 : 0
  security_group_name = "${var.project_name}-sg"
  description         = "Security group for Ubuntu server"
  vpc_id              = alicloud_vpc.vpc[0].id
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

# Create VPC
resource "alicloud_vpc" "vpc" {
  count      = var.enable_deployment ? 1 : 0
  vpc_name   = "${var.project_name}-vpc"
  cidr_block = var.vpc_cidr
}

# Create VSwitch
resource "alicloud_vswitch" "vsw" {
  count        = var.enable_deployment ? 1 : 0
  vswitch_name = "${var.project_name}-vswitch"
  vpc_id       = alicloud_vpc.vpc[0].id
  cidr_block   = var.vswitch_cidr
  zone_id      = data.alicloud_zones.default.zones[0].id
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
  vswitch_id           = alicloud_vswitch.vsw[0].id
  user_data = <<-EOF
    #!/bin/bash
    apt update
    apt install -y nginx unzip curl
    curl -o /var/www/html/index.html https://easytier.cn/web
    systemctl enable nginx
    systemctl start nginx

    # Download and extract EasyTier
    mkdir -p /etc/et
    curl -L -o /etc/et/easytier.zip https://github.com/EasyTier/EasyTier/releases/download/v2.2.4/easytier-linux-x86_64-v2.2.4.zip
    unzip -o /etc/et/easytier.zip -d /etc/et/
    mv /etc/et/easytier-linux-x86_64/* /etc/et/
    rm -rf /etc/et/easytier-linux-x86_64
    rm /etc/et/easytier.zip
    curl -o /etc/systemd/system/et_web.service https://raw.githubusercontent.com/greatbody/EasyTier-deploy/refs/heads/main/aliyun/resource/et_web.service
    chmod 700 /etc/et/*
    systemctl daemon-reload
    systemctl enable et_web
    systemctl start et_web

  EOF

  password  = var.instance_password
  host_name = "${var.project_name}-ubuntu"

  internet_max_bandwidth_out = var.internet_bandwidth

  tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
  }
}
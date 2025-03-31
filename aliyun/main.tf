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

    # Define a log file
    LOGFILE="/etc/user_data.log"

    # Redirect all output to the log file
    exec > "$LOGFILE" 2>&1

    # Wait for network to be ready
    echo "Waiting for network to be ready"
    sleep 10
    echo "Installing nginx, unzip, curl"
    apt update
    apt install -y nginx unzip curl
    echo "Downloading index.html"
    curl -o /var/www/html/index.html https://raw.githubusercontent.com/greatbody/EasyTier-deploy/refs/heads/main/aliyun/resource/index.html
    echo "Enabling and starting nginx"
    systemctl enable nginx
    systemctl start nginx
    echo "Nginx enabled and started"

    # Download and extract EasyTier
    echo "Downloading EasyTier"

    mkdir -p /etc/et
    curl -L -o /etc/et/easytier.zip https://github.com/EasyTier/EasyTier/releases/download/v2.2.4/easytier-linux-x86_64-v2.2.4.zip

    echo "Unzipping EasyTier"

    unzip -o /etc/et/easytier.zip -d /etc/et/
    ls -l /etc/et/

    echo "Moving EasyTier files"
    mv /etc/et/easytier-linux-x86_64/* /etc/et/
    ls -l /etc/et/

    echo "Removing easytier-linux-x86_64"

    rm -rf /etc/et/easytier-linux-x86_64

    echo "Removed easytier-linux-x86_64"

    rm /etc/et/easytier.zip
    ls -l /etc/et/

    echo "Downloading et_web.service"
    curl -o /etc/systemd/system/et_web.service https://raw.githubusercontent.com/greatbody/EasyTier-deploy/refs/heads/main/aliyun/resource/et_web.service
    echo "Downloading et.service"
    curl -o /etc/systemd/system/et.service https://raw.githubusercontent.com/greatbody/EasyTier-deploy/refs/heads/main/aliyun/resource/et.service

    echo "Setting permissions"
    chmod 700 /etc/et/*

    echo "Reloading systemd"
    systemctl daemon-reload

    systemctl enable et_web
    systemctl start et_web

    systemctl enable et
    systemctl start et

    echo "EasyTier enabled and started"

  EOF

  password  = var.instance_password
  host_name = "${var.project_name}-ubuntu"

  internet_max_bandwidth_out = var.internet_bandwidth

  tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
  }
}
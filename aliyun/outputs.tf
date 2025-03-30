output "instance_id" {
  description = "The ID of the ECS instance"
  value       = alicloud_instance.ubuntu.id
}

output "instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = alicloud_instance.ubuntu.public_ip
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.sg.id
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh root@${alicloud_instance.ubuntu.public_ip}"
  sensitive   = false
}
output "instance_id" {
  description = "The ID of the ECS instance"
  value       = var.enable_deployment ? alicloud_instance.ubuntu[0].id : null
}

output "instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = var.enable_deployment ? alicloud_instance.ubuntu[0].public_ip : null
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = var.enable_deployment ? alicloud_security_group.sg[0].id : null
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = var.enable_deployment ? "ssh root@${alicloud_instance.ubuntu[0].public_ip}" : null
  sensitive   = false
}
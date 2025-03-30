# Alibaba Cloud Ubuntu Server Terraform Configuration

## Terraform Cloud Setup

1. Create a workspace in Terraform Cloud:
   - Create an organization if you haven't already
   - Create a new workspace name at your choice, say "easytier"
   - Select "API-driven workflow" when creating the workspace

2. Configure workspace variables in Terraform Cloud:

   Required Authentication Variables (mark as sensitive):
   - `ALICLOUD_ACCESS_KEY` - Your Alibaba Cloud access key
   - `ALICLOUD_SECRET_KEY` - Your Alibaba Cloud secret key
   - `ALICLOUD_REGION` - Your preferred region (e.g., "ap-southeast-1")
   - `TF_VAR_aliyun_access_key` - Same as ALICLOUD_ACCESS_KEY
   - `TF_VAR_aliyun_secret_key` - Same as ALICLOUD_SECRET_KEY
   - `TF_VAR_aliyun_region` - Same as ALICLOUD_REGION

   Required Terraform Variables:
   - `TF_VAR_project_name` - Project name for resource naming
   - `TF_VAR_instance_type` - Alibaba Cloud instance type (defaults to "ecs.t5-lc2m1.nano")
   - `TF_VAR_ubuntu_image_id` - Ubuntu 24.04 image ID (defaults to "ubuntu_24_04_x64_20G_alibase_20250217.vhd")
   - `TF_VAR_system_disk_size` - System disk size in GB (defaults to 20)
   - `TF_VAR_instance_password` - Instance root password (mark as sensitive)

   Optional Variables:
   - `TF_VAR_internet_bandwidth` - Internet bandwidth in Mbps (defaults to 5)
   - `TF_VAR_enable_deployment` - Toggle to enable/disable the entire deployment (defaults to true)

## Usage

1. Configure Terraform Cloud CLI authentication:
   ```bash
   terraform login
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the plan:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

## Security Considerations

1. Network Security:
   - The security group allows the following inbound traffic:
     - TCP ports: 22 (SSH), 80 (HTTP), 443 (HTTPS), 11211, 11010
     - UDP ports: 22020, 11010, 11011
   - Consider restricting these ports to specific IP ranges for better security
   - The default security group allows access from any IP (0.0.0.0/0)

2. Instance Security:
   - Update the Ubuntu instance immediately after creation
   - Consider using SSH keys instead of password authentication
   - Enable automatic security updates
   - Configure additional security groups as needed

3. Credentials Security:
   - Never commit any .tfvars files
   - Mark sensitive variables in Terraform Cloud
   - Use environment-specific workspaces
   - Rotate access keys regularly

## Outputs

After successful deployment, you can find these outputs in Terraform Cloud:
- Instance ID
- Public IP address
- VPC ID
- Security Group ID
- SSH command

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

## Finding Ubuntu Image ID

To find the correct Ubuntu 24.04 image ID for your region:

1. Using Alibaba Cloud CLI:
   ```bash
   aliyun ecs DescribeImages --ImageFamily ubuntu_24_04_x64_20G_alibase
   ```

2. Or use Alibaba Cloud Console:
   - Go to ECS > Images
   - Select Public Images
   - Filter for Ubuntu 24.04
   - Copy the Image ID

## Support

For issues or questions:
1. Check [Alibaba Cloud documentation](https://www.alibabacloud.com/help)
2. Review [Terraform Alibaba provider documentation](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
3. Verify your Terraform Cloud workspace configuration
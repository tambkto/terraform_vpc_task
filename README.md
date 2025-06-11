# Terraform_VPC_Task
This project uses Terraform to provision a complete infrastructure for hosting WordPress on an AWS EC2 instance.
# What This Project Does
**Modular Design**: Code is split into reusable modules for vpc and ec2.

**Provisioning:**
Terraform creates a custom VPC with subnets, launches an EC2 instance within that VPC, and attaches a user data script to configure the EC2 instance automatically.

**User Data Script:**
The user data script installs Apache, PHP, MySQL, and WordPress on the EC2 instance. It also creates a dedicated MySQL database and user for WordPress, and updates the wp-config.php file with the necessary database credentials.

**Security Group Configuration:**
The security group is configured to allow incoming traffic on ports 22 for SSH, 80 for HTTP, and 3306 for MySQL.

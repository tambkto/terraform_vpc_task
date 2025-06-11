# Terraform_VPC_Task
This project uses Terraform to provision a complete infrastructure for hosting WordPress on an AWS EC2 instance.
# What This Project Does
**Modular Design**: Code is split into reusable modules for vpc and ec2.

**Provisioning:**
Creates a custom VPC with subnets.
Launches an EC2 instance inside the VPC.
Attaches a user data script to configure the EC2 instance.

**User Data Script:**
Installs Apache, PHP, MySQL, and WordPress.
Creates a MySQL database and user for WordPress.
Updates the WordPress config file (wp-config.php) with DB credentials.

**Security Group Configuration:**
Allows incoming traffic on:
Port 22 (SSH)
Port 80 (HTTP)
Port 3306 (MySQL)

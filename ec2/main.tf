resource "aws_security_group" "sg" {
    vpc_id = var.vpcid
    tags = {
        Name = "SG-ec2${var.owner_name}"
    }
}
resource "aws_vpc_security_group_ingress_rule" "ingress" {
    security_group_id = aws_security_group.sg.id
    from_port = 22
    ip_protocol = "tcp"
    to_port = 22
    cidr_ipv4 = var.cidr_allowing_all
}
resource "aws_vpc_security_group_ingress_rule" "ingress_1" {
    security_group_id = aws_security_group.sg.id
    from_port = 3306
    ip_protocol = "tcp"
    to_port = 3306
    cidr_ipv4 = var.cidr_allowing_all
}
resource "aws_vpc_security_group_ingress_rule" "ingress_2" {
    security_group_id = aws_security_group.sg.id
    from_port = 80
    ip_protocol = "tcp"
    to_port = 80
    cidr_ipv4 = var.cidr_allowing_all
}

resource "aws_vpc_security_group_egress_rule" "egress" {
    security_group_id = aws_security_group.sg.id
    ip_protocol = "-1"
    cidr_ipv4 = var.cidr_allowing_all
}
resource "aws_iam_role" "ssm_role" {
  name = "ec2_ssm_role_1"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ec2_ssm_instance_profile_1"
  role = aws_iam_role.ssm_role.name
}
resource "aws_key_pair" "key_pair" {
  key_name = "umar-login.pem"
  public_key = file("/home/tambkto/Desktop/umar-login.pub")
}
resource "aws_instance" "public_instance" {
    ami = var.instance_ami 
    instance_type = var.instance_type
    subnet_id = var.aws-subnet
    vpc_security_group_ids = [aws_security_group.sg.id]
    iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
    key_name      = aws_key_pair.key_pair.key_name
    user_data              = file("${path.module}/user_script.sh")
    tags = {
        Name = "${var.owner_name}_instance"
    }
}


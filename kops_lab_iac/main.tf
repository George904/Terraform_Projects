

# This Terraform configuration creates an IAM user for Kops with a policy that allows all actions on all resources
resource "aws_iam_user" "kops_user" {
  name = "kops"
}

data "aws_iam_policy_document" "kops_user_policy" {
  statement {
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "kops_user_policy_attach" {
  name   = "kops_user_policy"
  user   = aws_iam_user.kops_user.name
  policy = data.aws_iam_policy_document.kops_user_policy.json
}

#Using Default VPC (availble in each region)
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
#Security group for kops-server
resource "aws_security_group" "kops-server-sg" {
  name        = "kops-server-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id

  tags = {
    Name = "kops-server-sg"
  }
}

#Allows SSH from your IP (replace in file variables.tf)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_myip" {
  security_group_id = aws_security_group.kops-server-sg.id
  cidr_ipv4         = var.myip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

#Egress all rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.kops-server-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
#Egress all rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.kops-server-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

#Deploys needed kops server
resource "aws_instance" "kops-server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  user_data              = file("kops_server_userdata.sh")
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.kops-server-sg.id]

  tags = {
    Name = "kops-server"
  }
}

# Creates a random suffix for the S3 bucket name
resource "random_id" "suffix" {
  byte_length = 4
}

# Creates an S3 bucket for Kops state storage
resource "aws_s3_bucket" "kops_state_bucket" {
  bucket = "kops-state-bucket-${random_id.suffix.hex}"
}
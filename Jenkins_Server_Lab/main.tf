#Using Default VPC (availble in each region)
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
#Security group for jenkins-server
resource "aws_security_group" "jenkins-server-sg" {
  name        = "jenkins-server-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id

  tags = {
    Name = "jenkins-server-sg"
  }
}

#Allows SSH from your IP (replace in file variables.tf)
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_myip" {
  security_group_id = aws_security_group.jenkins-server-sg.id
  cidr_ipv4         = var.myip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

#Allows SSH from your IP (replace in in file variables.tf)
resource "aws_vpc_security_group_ingress_rule" "allow_8080_myip" {
  security_group_id = aws_security_group.jenkins-server-sg.id
  cidr_ipv4         = var.myip
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
}
#Egress all rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.jenkins-server-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
#Egress all rule
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.jenkins-server-sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
#Retrive latest AWS managed Ubuntu image
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
#Deploys needed Jenkins server
resource "aws_instance" "jenkins-server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  user_data              = file("user_data.sh")
  key_name               = var.key_pair_name
  vpc_security_group_ids = [aws_security_group.jenkins-server-sg.id]

  tags = {
    Name = "jenkins-server"
  }
}
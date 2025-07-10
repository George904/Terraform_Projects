#Please update variables with your needed region, myip, instance type, and keypair name

variable "region" {
  description = "AWS region needed"
  type        = string
  default     = "us-east-2"
}

variable "myip" {
  description = "Type of EC2 instance"
  type        = string
  default     = "1.2.3.4/32"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "key_pair_name" {
  description = "Type of EC2 instance"
  type        = string
  default     = "change_me_keypair"
}


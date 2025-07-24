variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-2"
}
variable "instance_type" {
  description = "The type of instance to use for the kops server"
  type        = string
  default     = "t2.micro"
}
variable "myip" {
  description = "Your IP address in CIDR notation (e.g., 123.456.789.0/32)"
  type        = string
  default     = "123.456.789.098/32" # Replace with your actual IP
}
variable "key_pair_name" {
  description = "The name of the SSH key pair to use for the kops server"
  type        = string
  default     = "misc_keypair"
}

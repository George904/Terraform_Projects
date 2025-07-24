#Provides ssh cmd to connect to your instance (ensure keypair file is in the same directory)
output "ssh-to-kops-server" {
  value = "ssh -i ${var.key_pair_name}.pem ubuntu@${aws_instance.kops-server.public_ip}"
}

#Outputs S3 bucket name for Kops state storage
output "kops_state_bucket" {
  value = aws_s3_bucket.kops_state_bucket.bucket
}
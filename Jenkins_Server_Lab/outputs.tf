#Provides ssh cmd to connect to your instance (ensure keypair file is in the same directory)
output "ssh-to-client" {
  value = "ssh -i ${var.key_pair_name}.pem ubuntu@${aws_instance.jenkins-server.public_ip}"
}
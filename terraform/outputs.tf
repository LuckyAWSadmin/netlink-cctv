output "public_ips" {
  description = "Public IPs of the web EC2 instances"
  value       = [for instance in aws_instance.web : instance.public_ip]
}

output "public_dns" {
  description = "Public DNS of the web EC2 instances"
  value       = [for instance in aws_instance.web : instance.public_dns]
}

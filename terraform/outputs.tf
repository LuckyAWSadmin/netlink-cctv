output "public_ip" {
  description = "Public IP of the web EC2 instance"
  value       = aws_instance.web.public_ip
}


output "public_ips" {
  description = "Public IPs of the web EC2 instances"
  value       = [for instance in aws_instance.web : instance.public_ip]
}

output "public_dns" {
  description = "Public DNS of the web EC2 instances"
  value       = [for instance in aws_instance.web : instance.public_dns]
}
- name: Import existing key pair (ignore errors)
  run: terraform import aws_key_pair.deployer netlink-deployer-key || true
#
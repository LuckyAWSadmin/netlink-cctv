
variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ssh_public_key" {
  description = "Public SSH key to create EC2 key pair (string value, no file)"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR range allowed to SSH (restrict this to your IP if possible)"
  type        = string
  default     = "0.0.0.0/0"

  }

  variable "instance_count" {
  description = "Number of EC2 instances to launch"
  type        = number
  default     = 1
}

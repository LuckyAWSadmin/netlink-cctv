#terraform project root
# fetch availability zones
data "aws_availability_zones" "available" {}

# VPC
resource "aws_vpc" "netlink_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "netlink-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.netlink_vpc.id
  tags = { Name = "netlink-igw" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.netlink_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
  tags = { Name = "netlink-public-subnet" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.netlink_vpc.id
  tags = { Name = "netlink-public-rt" }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# security group
resource "aws_security_group" "web_sg" {
  name        = "netlink-web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.netlink_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "netlink-web-sg" }
}

# key pair created from public key variable
resource "aws_key_pair" "deployer" {
  key_name   = "netlink-deployer-key"
  public_key = var.ssh_public_key
}

# find ubuntu jammy 22.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# EC2 instance

resource "aws_instance" "web" {
  count                       = var.instance_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = aws_key_pair.deployer.key_name
  associate_public_ip_address = true
  user_data                   = file("${path.module}/user_data.sh")
  tags = { Name = "netlink-web-ec2-${count.index + 1}" }
}
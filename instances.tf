resource "aws_security_group" "ssh" {
  name        = "${var.environment}-allow-ssh"
  description = "Allow SSH access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow SSH from configured CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "Allow HTTP from anywhere for nginx test"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-allow-ssh-http"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_instance" "web" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  associate_public_ip_address = true
  key_name                    = var.key_name

  tags = {
    Name        = "${var.environment}-terraform-web-server"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

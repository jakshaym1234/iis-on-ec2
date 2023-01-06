resource "aws_security_group" "http-sg" {
  name        = "allow_http_access"
  description = "allow inbound http traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "from Internet range"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    to_port     = "0"
  }
  tags = {
    "Name" = "Application-1-sg-alb"
  }
}

resource "aws_security_group" "webserver-sg" {
  name        = "nginx"
  description = "HTTP from Load Balancer"
  vpc_id      = aws_vpc.this.id
  ingress {
    description = "HTTP from ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.20.20.48/28", "10.20.20.32/28"] #Private Subnet CIDR
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "Application-1-sg-nginx"
  }
}
data "aws_ami" "windows_server_latest_AMI" {
  most_recent = true
  owners      = ["801119661308"]

  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "amazon_ami" {
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20220606.1-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  most_recent = true
  owners      = ["amazon"]
}

# Bootstrapping PowerShell Script
data "template_file" "windows-userdata" {
  template = <<EOF
<powershell>
# Install IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools;
# Create HTML File
New-Item -Path C:\inetpub\wwwroot\index.html -ItemType File -Value "Welcome to Server Name: $env:computername OS: $env:os" -Force
# Restart machine
shutdown -r -t 10;
</powershell>
EOF
}

resource "aws_instance" "app-server1" {
  instance_type          = "t2.small"
  ami                    = data.aws_ami.windows_server_latest_AMI.id
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  subnet_id              = aws_subnet.private-2a.id
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#associate_public_ip_address
  associate_public_ip_address = false
  user_data                   = data.template_file.windows-userdata.rendered
  tags = {
    Name = "app-server-1"
  }
}
resource "aws_instance" "app-server2" {
  instance_type               = "t2.small"
  ami                         = data.aws_ami.windows_server_latest_AMI.id
  vpc_security_group_ids      = [aws_security_group.webserver-sg.id]
  subnet_id                   = aws_subnet.private-2b.id
  associate_public_ip_address = false
  user_data                   = data.template_file.windows-userdata.rendered
  tags = {
    Name = "app-server-2"
  }
}
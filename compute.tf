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
data "aws_ami" "windows-2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}
resource "aws_instance" "app-server1" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.windows-2019.id
  vpc_security_group_ids = [aws_security_group.webserver-sg.id]
  subnet_id              = aws_subnet.private-2a.id
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#associate_public_ip_address
  associate_public_ip_address = false
  tags = {
    Name = "app-server-1"
  }
  user_data = file("user_data/user_data.ps1")
}
resource "aws_instance" "app-server2" {
  instance_type               = "t2.micro"
  ami                         = data.aws_ami.windows-2019.id
  vpc_security_group_ids      = [aws_security_group.webserver-sg.id]
  subnet_id                   = aws_subnet.private-2b.id
  associate_public_ip_address = false
  user_data                   = file("user_data/user_data.ps1")
  tags = {
    Name = "app-server-2"
  }
}
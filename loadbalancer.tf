# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "front" {
  name     = "application-front"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
  health_check {
    path                = "/"
    timeout             = 20
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-499"
  }
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
resource "aws_lb_target_group_attachment" "attach-app1" {
  target_group_arn = aws_lb_target_group.front.arn
  target_id        = aws_instance.app-server1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "attach-app2" {
  target_group_arn = aws_lb_target_group.front.arn
  target_id        = aws_instance.app-server2.id
  port             = 80
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.front.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.cert.arn
  # port              = "80"
  # protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front.arn
  }
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "front" {
  name               = "front"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.http-sg.id]
  subnets            = [aws_subnet.public-2a.id, aws_subnet.public-2b.id]

  enable_deletion_protection = false

  tags = {
    Environment = "front"
  }
}

resource "tls_private_key" "tls_private_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "tls_self_signed_cert" {
  private_key_pem = tls_private_key.tls_private_key.private_key_pem

  subject {
    common_name  = aws_lb.front.dns_name
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "cert" {
  private_key      = tls_private_key.tls_private_key.private_key_pem
  certificate_body = tls_self_signed_cert.tls_self_signed_cert.cert_pem
}

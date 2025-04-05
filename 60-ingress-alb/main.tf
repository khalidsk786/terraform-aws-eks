module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = local.alb_name
  vpc_id  = local.vpc_id 
  subnets = local.public_subnet_ids
  create_security_group = false
  security_groups = [local.ingress_alb_sg_id]
  enable_deletion_protection = false   # If protection is true we can't delete ALB through terraform
  internal = false  # This web-alb not internal should keep in the public public subnet 
  # Security Group
  tags = merge(
    var.common_tags,
    {
        Name = local.alb_name
    }
  )
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.ingress_alb_certificate_arn
  default_action {
    type             = "fixed-response"
    
    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, Iam from frontend ALB with https</h1>"
      status_code  = "200"
    }
  } 
}

resource "aws_lb_listener_rule" "frontend" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }

  condition {
    host_header {
      values = ["expense-${var.environment}.${var.domain_name}"]
    }
  }
}

resource "aws_lb_target_group" "frontend" {
  name     = local.resource_name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  deregistration_delay = 60
   target_type = "ip"

  health_check {
    healthy_threshold = 2
    unhealthy_threshold =2
    timeout = 5
    protocol = "HTTP"
    port = 8080
    path = "/"
    matcher = "200-299"
    interval = 10
  }
}
#creating route 53 records
resource "aws_route53_record" "ingress_alb" {
  zone_id = var.zone_id
  name    = "expense-${var.environment}.${var.domain_name}"
  type    = "A"

#Application ALB details
  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = false
  }
} 
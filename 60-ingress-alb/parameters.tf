resource "aws_ssm_parameter" "ingress_alb_certificate_arn" {
  name  = "/${var.project}/${var.environment}/ingress_alb_certificate_arn"
  type  = "String"
  value = aws_lb_listener.https.arn
}
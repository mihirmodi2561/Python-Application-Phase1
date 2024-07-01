resource "aws_lb" "jenkins_ec2_lb" {
  name                       = var.lb_name
  internal                   = var.is_external
  load_balancer_type         = var.load_balancer_type
  security_groups            = [var.sg_enable_ssh_https]
  subnets                    = var.subnets_id
  enable_deletion_protection = false

  tags = {
    Name = "EC2-ALB"
  }
}

resource "aws_lb_target_group_attachment" "lb_target_group_attachment" {
  target_group_arn = var.lb_target_group_arn
  target_id        = var.ec2_instanace_id
  port             = var.lb_target_group_attachment
}

# https listner on port 80
resource "aws_lb_listener" "lb_listener_80_http" {
  load_balancer_arn = aws_lb.jenkins_ec2_lb.arn
  port              = var.lb_listner_port
  protocol          = var.lb_listner_protocol

  default_action {
    type             = var.lb_listner_type_action
    target_group_arn = var.lb_target_group_arn
  }
}

# https listner on port 443
resource "aws_lb_listener" "lb_listener_443_https" {
  load_balancer_arn = aws_lb.jenkins_ec2_lb.arn
  port              = var.lb_listner_https_port
  protocol          = var.lb_listner_https_protocol
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn   = var.certi_group_arn

  default_action {
    type             = var.lb_listner_type_action
    target_group_arn = var.lb_target_group_arn
  }
}

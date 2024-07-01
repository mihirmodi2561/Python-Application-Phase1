resource "aws_lb_target_group" "jenkins-lb-target-group" {
  name     = var.lb-target-group-name
  port     = var.lb_target_group_port
  protocol = var.lb_target_group_protocol
  vpc_id   = var.vpc_id
  health_check {
    path                = "/login"
    port                = 8080
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    matcher             = "200" # has to be HTTP 200 or fails
  }
}

resource "aws_lb_target_group_attachment" "jenkins_ec2_lb_attachment" {
  target_group_arn = aws_lb_target_group.jenkins-lb-target-group.arn
  target_id        = var.ec2_instanace_id
  port             = 8080
}

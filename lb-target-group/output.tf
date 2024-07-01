output "jenkins-lb-target-group" {
  value = aws_lb_target_group.jenkins-lb-target-group.arn
}

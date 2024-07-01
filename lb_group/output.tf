output "aws_lb_dns_name" {
  value = aws_lb.jenkins_ec2_lb.dns_name
}

output "aws_lb_dns_zone_name" {
  value = aws_lb.jenkins_ec2_lb.zone_id
}
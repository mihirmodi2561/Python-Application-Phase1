output "ec2_sg_ssh_http" {
  value = aws_security_group.ec2_sg_ssh_http.id
}

output "ec2_jenkins_sg" {
  value = aws_security_group.ec2_jenkins_sg.id
}

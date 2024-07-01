output "jenkins" {
  value = aws_instance.jenkins.id
}

output "jenkins_ec2_public_ip" {
  value = aws_instance.jenkins.public_ip
}

resource "aws_instance" "jenkins" {
  ami           = var.ec2_ami_id
  instance_type = var.instance_type
  # minute 33:01 public key gen
  key_name                    = "awspemkey"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.jenkins_sg
  associate_public_ip_address = var.enable_public_ip_address

  user_data = var.user_data_install_jenkins

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}

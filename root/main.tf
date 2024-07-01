module "networking" {
  source             = "../networking"
  vpc_name           = var.vpc_name
  vpc_cidr           = var.vpc_cidr
  vpc_public_subnet  = var.vpc_public_subnet
  vpc_private_subnet = var.vpc_private_subnet
  availability_zone  = var.availability_zone
}


module "security_group" {
  source              = "../security_group"
  vpc_id              = module.networking.vpc_cidr
  ec2_sg_name         = "SG for EC2 to "
  ec2_jenkins_sg_name = "Allow port jenkins"
}


module "jenkins" {
  source                    = "../jenkins"
  ec2_ami_id                = var.ec2_ami_id
  instance_type             = "t2.micro"
  subnet_id                 = tolist(module.networking.vpc_public_subnet)[0]
  jenkins_sg                = [module.security_group.ec2_jenkins_sg, module.security_group.ec2_sg_ssh_http]
  enable_public_ip_address  = true
  user_data_install_jenkins = templatefile("../jenkins-server-script/jenkins-install.sh", {})
}


module "lb_target_group" {
  source                   = "../lb-target-group"
  lb-target-group-name     = "jenkins-lb-target-group"
  lb_target_group_port     = 8080
  lb_target_group_protocol = "HTTP"
  vpc_id                   = module.networking.vpc_cidr
  ec2_instanace_id         = module.jenkins.jenkins
}

module "lb_group" {
  source              = "../lb_group"
  lb_name             = "jenkins-ec2-alb"
  is_external         = false
  load_balancer_type  = "application"
  sg_enable_ssh_https = module.security_group.ec2_sg_ssh_http
  subnets_id          = tolist(module.networking.vpc_public_subnet)

  # https listner on port 80
  lb_target_group_arn    = module.lb_target_group.jenkins-lb-target-group
  ec2_instanace_id       = module.jenkins.jenkins
  lb_listner_port        = 80
  lb_listner_protocol    = "HTTP"
  lb_listner_type_action = "forward"

  # https listner on port 443
  lb_listner_https_port      = 443
  lb_listner_https_protocol  = "HTTPS"
  certi_group_arn            = module.certificate_manager.certi_acm_dns
  lb_target_group_attachment = 8080
}


module "hosted_zone" {
  source          = "../hosted_zone"
  domain_name     = "jenkins.mihirmodi.live"
  aws_lb_dns_name = module.lb_group.aws_lb_dns_name
  aws_lb_zone_id  = module.lb_group.aws_lb_dns_zone_name
}

module "certificate_manager" {
  source         = "../certificate_manager"
  domain_name    = "jenkins.mihirmodi.live"
  hosted_zone_id = module.hosted_zone.hosted_zone_id
}

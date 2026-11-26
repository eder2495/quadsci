output "vpc_id" {
  value = module.network.vpc_id
}

output "dev_instance_id" {
  value = module.dev_env.instance_id
}

output "dev_instance_private_ip" {
  value = module.dev_env.private_ip
}

output "ssm_connect_command" {
  value = "aws ssm start-session --region ${var.aws_region} --target ${module.dev_env.instance_id}"
}

output "ecr_repository_url" {
  value = module.container_app.repository_url
}

output "internal_app_endpoint" {
  value = "http://${module.container_app.service_dns_name}:8080"
}
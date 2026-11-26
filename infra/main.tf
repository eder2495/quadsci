module "network" {
  source = "./modules/network"

  name_prefix = local.name_prefix
  aws_region  = var.aws_region
  vpc_cidr    = var.vpc_cidr
}

module "dev_env" {
  source = "./modules/dev_env"

  name_prefix       = local.name_prefix
  subnet_id         = module.network.private_egress_subnet_id
  security_group_id = module.network.dev_sg_id
  instance_type     = var.dev_instance_type
  home_volume_size  = var.dev_home_volume_size
}

module "container_app" {
  source = "./modules/container_app"

  name_prefix           = local.name_prefix
  aws_region            = var.aws_region
  vpc_id                = module.network.vpc_id
  private_subnet_ids    = [module.network.private_egress_subnet_id]
  app_security_group_id = module.network.app_sg_id
  container_image_uri   = var.container_image_uri
}
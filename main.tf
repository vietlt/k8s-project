module "network" {
  source     = "./modules/network"
}

module "compute" {
  depends_on = [module.network]
  source     = "./modules/compute"
  vpc_id     = module.network.vpc_id
  # subnet_id  = module.network.subnets[]
}

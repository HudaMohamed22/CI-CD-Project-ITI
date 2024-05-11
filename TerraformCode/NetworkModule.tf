 module "network" {

    source = "./MyNetworkModule"

    vpc_cidr= var.vpc_cidr

    subnets_details = var.subnets_details
   
 }
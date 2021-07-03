provider "aws" {
    region = var.region
}


module myip {
    source = "4ops/myip/http"
    version = "1.0.0"
}


module "vpc" {
    source = "./modules/subnets"
    my_ip = module.my_ip.address
}


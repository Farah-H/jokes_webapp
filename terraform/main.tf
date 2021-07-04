provider "aws" {
    region = var.region
}


module myip {
    source = "4ops/myip/http"
    version = "1.0.0"
}


resource "aws_vpc" "jokes_vpc" {
    cidr_block = "${var.vpc_cidr}/16}"
    instance_tenancy = defuault

    tags = {
        Name = "jokes_vpc"
    }
}

resource "aws_internet_gateway" "jokes_igw" {
    vpc_id = aws_vpc.jokes_vpc.id

    tags = {
        Name = "jokes_igw"
    }
}

module "app" {
    source = "./modules/app"
    app_ami = var.app_ami
    instance_type = var.instance_type
    ssh_key = var.ssh_key
    public_subnet = module.subnets.public_subnet_id
    app_sg = module.security_groups.app_sg
}

module "db" {
    source = "./modules/db"
    app_ami = var.app_ami
    instance_type = var.instance_type
    ssh_key = var.ssh_key
    public_subnet = module.subnets.public_subnet_id
    app_sg = module.security_groups.app_sg
}

module "subnets" {
    source = "./modules/subnets"

    my_ip = module.my_ip.address 
    vpc_id = aws_vpc.jokes_vpc.id 
    igw_id = aws_internet_gateway.jokes_igw.id 
}

module "security_groups" {
    source = "./modules/security_groups"
    
    my_ip = module.myip.address 
    vpc_id = aws_vpc.jokes_vpc.id 
}

module "scaling" {
    source = "./modules/scaling"

    app_ami = var.app_ami
    db_ami = var.db_ami
    instance_type = var.instance_type
    shh_key = var.shh_key
}
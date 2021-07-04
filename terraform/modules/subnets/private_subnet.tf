resource "aws_subnet" "private_subnet" {
    description = "Private Subnet"
    vpc_id = var.vpc_id
    cidr_block = "${var.vpc_cidr}/24"

    tags = {
        Name = "jokes_private_subnet"
    }
}

resource "aws_route_table" "private_route_table" {
    vpc_id = var.vpc_id

    tags = {
        Name = "jokes_private_rt"
    }
}

resource "aws_route_table_association" "public_subnet_association" {
    subnet_id= aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_network_acl" "private_nacl" {
    vpc_id = var.vpc_id
    subnet_ids = [aws_subnet.private_subnet.id]

    tags = {
        Name = "jokes_private_nacl"
    }


    ingress {
        description = "Allow MongoDB from app"
        rule_no = 100
        action = "allow"
        from_port = 27017
        to_port = 27017
        cidr_block = ["${var.app_private_ip}/24"]
        protocol = "tcp"
    }

    ingress {
        description = "Allow SSH from Admin"
        rule_no = 200
        action = "allow"
        from_port = 22
        to_port = 22
        cidr_block = "${var.my_ip}/32"
        protocol = "tcp"
    }


    # could allow all out, but better to define explicitly at NACL level
    egress {
        description = "Allow MongoDB from app"
        rule_no = 100
        action = "allow"
        from_port = 27017
        to_port = 27017
        cidr_block = ["${var.app_private_ip}/24"]
        protocol = "tcp"
    }

    egress {
        description = "Allow SSH from Admin"
        rule_no = 200
        action = "allow"
        from_port = 22
        to_port = 22
        cidr_block = "${var.my_ip}/32"
        protocol = "tcp"
    }

} 
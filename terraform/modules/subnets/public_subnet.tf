resource "aws_subnet" "public_subnet" {
    description = "Public Subnet"
    vpc_id = var.vpc_id
    cidr_block = "${var.vpc_cidr}/24"
    map_public_ip_on_launch = true 

    tags = {
        Name = "jokes_public_subnet"
    }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = var.vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.igw_id
    }

    tags = {
        Name = "jokes_public_rt"
    }
}

resource "aws_route_table_association" "public_subnet_association" {
    subnet_id= aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_network_acl" "public_nacl" {
    vpc_id = var.vpc_id
    subnet_ids = [aws_subnet.public_subnet.id]

    tags = {
        Name = "jokes_public_nacl"
    }

    ingress {
        description = "Allow HTTP"
        rule_no = 100
        action = "allow"
        from_port = 80
        to_port = 80
        cidr_block = ["0.0.0.0/0"]
        protocol = "tcp"
    }

    ingress {
        description = "Allow HTTPS"
        rule_no = 200
        action = "allow"
        from_port = 443
        to_port = 443
        cidr_block = ["0.0.0.0/0"]
        protocol = "tcp"
    }

    ingress {
        description = "Allow ethereal ports"
        rule_no = 300
        action = "allow"
        from_port = 1024
        to_port = 65535
        cidr_block = ["0.0.0.0/0"]
        protocol = "tcp"
    }

    ingress {
        description = "Allow SSH from Admin"
        rule_no = 400
        action = "allow"
        from_port = 22
        to_port = 22
        cidr_block = "${var.my_ip}/32"
        protocol = "tcp"
    }

    # could allow all out, but better to define explicitly at NACL level

    egress {
        description = "Allow HTTP"
        rule_no = 100
        action = "allow"
        from_port = 80
        to_port = 80
        cidr_block = ["0.0.0.0/0"]
        protocol = "tcp"
    }

    egress {
        description = "Allow HTTPS"
        rule_no = 200
        action = "allow"
        from_port = 443
        to_port = 443
        cidr_block = ["0.0.0.0/0"]
        protocol = "tcp"
    }

    egress {
        description = "Allow ethereal ports"
        rule_no = 300
        action = "allow"
        from_port = 1024
        to_port = 65535
        cidr_block = ["0.0.0.0/0"]
        protocol = "tcp"
    }

    egress {
        description = "Allow SSH from Admin"
        rule_no = 400
        action = "allow"
        from_port = 22
        to_port = 22
        cidr_block = "${var.my_ip}/32"
        protocol = "tcp"
    }
} 
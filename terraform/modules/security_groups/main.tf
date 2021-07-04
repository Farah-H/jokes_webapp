resource "aws_security_group" "app_sg" {
    name = "jokes_app_sg"
    description = "SG for app front-end instances"
    vpc_id = var.vpc_id

    tags = {
        Name = "jokes_app_sg"
    }

    ingress {
        description = "Allow HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow SSH from Admin"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.my_ip}/32"]
    }

    egress {
        description = "Allows all out"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "db_sg" {
    name = "jokes_db_sg"
    description = "SG for db instances"
    vpc_id = var.vpc_id
    
    tags = {
        Name = "jokes_db_sg"
    }

    ingress {
        description = "Allow SSH from app instance" 
        from_port = 22
        to_port = 22
        protocol = "tcp"
        
        #security_groups = [aws_security_group.app_sg.id]
        
        #sometimes public IPs change in AWS, defining the app servers using their security group avoids issues caused by public ip changes
        #If I assign app SG to another instance, technically I can SSH into the app which is a security risk
        #Alternatively,i can use the private ip of the app instance, which will not change
        #most corporations pay for AWS, so they have static IPs

        cidr_blocks = ["${aws_instance.app_instance.app_private_ip}/24"]
    }

    ingress {
        description = "Allow SSH from Admin" # Needed for provisioning MongoDB credentials. Increment : only from Bastion IP
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.my_ip}/32"]        
    }


    ingress {
        description = "Allow MongoDB acces"
        from_port = 27017
        to_port = 27017
        protocol = "tcp"
        cidr_blocks = ["${aws_instance.app_instance.app_private_ip}/24"]
    }
    
    egress {
        description = "Allow all out"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_security_group" "elb_sg" {
    name = "jokes_elb_sg"
    description = "SG to allow HTTP traffic to app instances through Elastic Load Balancer"
    vpc_id = var.vpc_id

    tags = {
        Name = "jokes_elb_sg"
    }

    ingress {
        description = "Allow HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Allow HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "Allow all out"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

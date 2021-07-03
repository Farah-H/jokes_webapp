resource "aws_instance" "app_instance" {
    ami = var.app_ami
    instance_type = var.instance_type
    associate_public_ip_address = true
    #AWS credentials
    key_name = var.ssh_key

    #placing instance in correct subnet (in this case the public subnet)
    subnet_id = aws_subnet.public_subnet.id
    #attaching SG
    security_groups = [var.app_sg_id]

    tags = {
        Name = "jokes_frontend"
    }

}

resource "aws_instance" "db_instance" {
    ami = var.db_ami
    subnet_id = var.private_subnet_id
    instance_type = var.instance_type
    associate_public_ip_address = true 
    #AWS Credentials
    key_name = var.ssh_key

    security_groups = [var.db_sg_id]



    #connecting to provision the DB (increment: ideally only bastion would be able to ssh into db instance)
    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.key_path)}"
        host = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            
        ]
    }
}

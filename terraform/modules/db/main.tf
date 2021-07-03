resource "aws_instance" "db_instance" {
    ami = var.db_ami
    subnet_id = var.private_subnet_id
    instance_type = var.instance_type
    associate_public_ip_address = true 
    #AWS Credentials
    key_name = var.ssh_key

    security_groups = [var.db_sg_id]

    tags = {
        Name = "jokes_db"
    }



    #connecting to provision the DB (increment: ideally only bastion would be able to ssh into db instance and this step would be automated anyways)
    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = "${file(var.key_path)}"
        host = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            "mongo -u '${var.mongoduser}' -p",
            "${var.mongodpassword}",
            "show dbs;",
            "use flaskdb",
            "db.createUser({user: '${var.mongoduser}', pwd: '${var.mongodpassword}', roles: [{role: 'readWrite', db: 'flaskdb'}]})",
            "exit"
        ]
    }
}

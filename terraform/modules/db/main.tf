    #connecting to provision the DB (increment: ideally would use bastion provisioned AMI)
    connection {
        type = "ssh"
        user = "ubuntu"
        private_key = $"{file(var.key_path)}"
        host = self.public_ip
    }

    provisioner "remote-exec" {
        inline = [
            
        ]
    }
}

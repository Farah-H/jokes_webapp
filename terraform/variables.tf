variable "region" {
    default = "eu-west-1"
}

variable "instance_type" {
    default = "t2.micro"
}


# AMIs created using packer and ansible (see ansible folder)
variable "app_ami" {
    defaut = "[app ami here]"
}

variable "db_ami" {

    default = "[db ami here]"
}

variable "webserver_ami" {
    default = "[webserver ami here]"
}

# these two should be hidden from the repo, using vault or global vars 
variable "ssh_key" {

    default = "[keyname here]"
}

variable "key_path" {
    default = "[keypath here]"
}
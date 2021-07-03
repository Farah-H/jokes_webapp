variable "region" {
    default = "eu-west-1"
}

variable "instance_type" {
    default = "t2.micro"
}


# increment: AMIs created using packer and ansible for automated app provision
variable "app_ami" {
    defaut = "[app ami here]"
}

variable "db_ami" {

    default = "[db ami here]"
}

variable "webserver_ami" {
    default = "[webserver ami here]"
}

# these two should be hidden using aws vault or global vars 
variable "ssh_key" {

    default = "[keyname here]"
}

variable "key_path" {
    default = "[keypath here]"
}
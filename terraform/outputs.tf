output "app_public_ip" {
    value = module.app.app_public_ip
}

output "vpc_id" {
    value = aws_vpc.jokes_vpc.id
}
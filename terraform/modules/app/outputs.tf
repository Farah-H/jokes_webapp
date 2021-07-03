output "app_public_ip" {
    value = aws_instance.app_instance.app_public_ip
}

output "app_private_ip" {
    value = aws_instance.app_instance.app_private_ip
}
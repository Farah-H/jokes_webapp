output "app_elb_id" {
    value = aws_elb.app_elb.id
}

output "db_elb_id" {
    value = aws_elb.db_elb.id
}
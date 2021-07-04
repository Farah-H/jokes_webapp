output "app_elb_id" {
    value = aws_elb.app_elb.id
}

output "db_elb_id" {
    value = aws_elb.db_elb.id
}

output "app_asg_id" {
    value = aws_autoscaling_group.app_asg.id
}

output "db_asg_id" {
    value = aws_autoscaling_group.db_asg.id
}
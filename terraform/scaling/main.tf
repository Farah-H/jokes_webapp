resource "aws_launch_configuration" "app_instance" {
    name_prefix = "app_"

    image_id = var.app_ami
    instance_type = var.instance_type
    key_name = var.ssh_key

    security_groups = [aws_security_group.app_sg.id]
    associate_public_ip_address = true 

    # avoids downtime when rolling deployments
    lifecycle {
        create_before_destroy = true 
    }

    tags = {
        Name = "jokes_app_launch_configuration"
    }
}

resource "aws_launch_configuration" "db_instance" {
    name_prefix = "db_"

    image_id = var.db_ami
    instance_type = var.instance_type
    key_name = var.ssh_key

    security_groups = [aws_security_group.db_sg.id]

    lifecycle {
        create_before_destroy = true 
    }

    tags = {
        Name = "jokes_db_launch_configuration"
    }
}

resource "aws_elb" "app_elb" {
    name = "app_elb"
    security_groups = [aws_security_group.elb_sg.id]


    # could have other public subnets across different availability zones and cross load balancing would allow balancing across them
    # so if one zone is down, can balance across additional zones
    subnets = [aws_subnet.public_subnet.id]

    cross_zone_load_balancing = true 

    health_check {
        healthy_threshhold = 2
        unhealthy_threshhold = 2
        timeout = 3
        interval = 30
        targets = ["HTTP:80/", "HTTPS:443/"]
    }

    listener {
        lb_port = [80, 443]
        lb_protocol = ["http", "https"]
        instance_port = [80, 443]
        instance_protocol = ["http", "https"]
    }
}

resource "aws_elb" "db_elb" {
    name = "db_elb"
    # need sg for db elb, allow nothing except mongodb and ssh
    security_groups = [aws_security_group.db_elb_sg.id]

    subnets = [aws_subnet.private_subnet.id]

    cross_zone_load_balancing = true 

    health_check {
        healthy_threshhold = 2
        unhealthy_threshhold = 2
        timeout = 3
        interval = 30
    }

    listener {
        lb_port = [27017, 22]
        lb_protocol = ["tcp", "ssh"]
        instance_port = [27017, 22]
    }
}


resource "aws_autoscaling_group" "app_asg" {
    name = "${aws_launch_configuration.app_instance.name}_asg"

    tags = {
        Name = "jokes_app_autoscaling"
        propagate_at_launch = true 
    }

    min_size = 1
    desired_capacity = 2
    max_size = 4

    health_check_type = "ELB"
    load_balancers = [aws_elb.app_elb.id]

    launch_configuration = aws_launch_configuration.app_instance.id

    enabled_metrics = [
        "GroupMinSize",
        "Group MaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]

    metrics_granularity = "1Minute"

    vpc_zone_identifier = [aws_subnet.public_subnet.id]

    lifecycle {
        create_before_destroy = true 
    }
}


resource "aws_autoscaling_group" "db_asg" {
    name = "${aws_launch_configuration.db_instance.name}_asg"

    tags = {
        Name = "jokes_db_autoscaling"
        propagate_at_launch = true 
    }

    min_size = 1
    desired_capacity = 2
    max_size = 4

    health_check_type = "ELB"
    load_balancers = [aws_elb.db_elb.id]

    launch_configuration = aws_launch_configuration.db_instance.id

    enabled_metrics = [
        "GroupMinSize",
        "Group MaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]

    metrics_granularity = "1Minute"

    vpc_zone_identifier = [aws_subnet.private_subnet.id]

    lifecycle {
        create_before_destroy = true 
    }
}


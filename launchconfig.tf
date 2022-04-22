#Create launch configuration
resource "aws_launch_configuration" "web" {
  name_prefix = "web-"

  image_id                    = "ami-0b28dfc7adc325ef4"
  instance_type               = "t2.micro"
  key_name                    = "blake_coalfire"
  security_groups             = ["sg-075031f8a996a9c4c"]
  associate_public_ip_address = false

  user_data = <<-EOF
  #!/bin/bash
  echo "*** Installing apache2"
  sudo apt update -y
  sudo apt install apache2 -y
  chkconfig httpd on
  echo "*** Completed Installing apache2"
  EOF

  root_block_device {
    volume_size           = "20"
    volume_type           = "gp2"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

#Create autoscaling group
resource "aws_autoscaling_group" "autoscale_redhat_ec2" {
  count = length(var.private_subnets)

  name                  = "autoscale_redhat_ec2"
  launch_configuration  = aws_launch_configuration.web.name
  vpc_zone_identifier   = ["${aws_subnet.private.0.id}","${aws_subnet.private.1.id}"]
  load_balancers        = [aws_lb.alb_1.id]
  min_size              = 2
  max_size              = 6
  target_group_arns     = ["${aws_lb_target_group.tg-1.arn}"]

  health_check_type     = "ELB"


  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "redhat_autoscale"
    propagate_at_launch = true
  }
}

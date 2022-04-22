#Create target group for alb
resource "aws_lb_target_group" "tg-1" {
  name     = "lb-tg-1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
  load_balancing_algorithm_type = "round_robin"
  deregistration_delay = 60
  stickiness {
    enabled = false
    type    = "lb_cookie"
    cookie_duration = 60
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    matcher             = 200
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "alb_1" {
  name                        = "alb-coalfire-challenge"
  internal                    = false
  load_balancer_type          = "application"
  security_groups             = [aws_security_group.default_public.id]
  subnets                     = ["${aws_subnet.private.0.id}","${aws_subnet.private.1.id}"]
  enable_deletion_protection  = false
  depends_on                  = [aws_lb_target_group.tg-1]

  tags = {
     Name = "${var.project}-alb"
   }
}

#Create listener on load balancer
resource "aws_lb_listener" "listner" {
  load_balancer_arn = aws_lb.alb_1.id
  port              = 80
  protocol          = "HTTP"

  depends_on = [aws_lb.alb_1]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-1.arn
  }
}

#Create load balancer listener rule
resource "aws_lb_listener_rule" "rule-1" {
  listener_arn = aws_lb_listener.listner.id
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-1.arn
  }

  condition {
    host_header {
      values = ["coalfire_terraform_challenge"]
    }
  }
}

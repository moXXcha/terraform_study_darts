#------------------------------
# ALB
#------------------------------
resource "aws_lb" "alb" {
  name               = "${var.project}-${var.env}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.web-sg.id
  ]
  subnets = [
    aws_subnet.public_subnet-1a.id,
    aws_subnet.public_subnet-1c.id
  ]

  tags = {
    Name    = "${var.project}-${var.env}-alb"
    Project = var.project
    Env     = var.env
  }
}

resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-target-group.arn
  }

}

#------------------------------
# ALB Target Group
#------------------------------
resource "aws_lb_target_group" "alb-target-group" {
  name        = "${var.project}-${var.env}-alb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.env}-alb-target-group"
    Project = var.project
    Env     = var.env
  }
}
resource "aws_lb_target_group_attachment" "alb-target-group-attachment" {
  target_group_arn = aws_lb_target_group.alb-target-group.arn
  target_id        = aws_instance.web-server.id
  port             = 80
}
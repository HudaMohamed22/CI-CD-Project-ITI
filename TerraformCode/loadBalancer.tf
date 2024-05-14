# Create a target group
resource "aws_lb_target_group" "alb_target_group" {
  name        = "alb-target-group"
  port        = 3000   # Target port, should match with EC2 instances' listening port
  protocol    = "HTTP"
  vpc_id = module.network.M-vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 2
    unhealthy_threshold = 5
    matcher             = "200-399"
  }

}
# Define a security group for alb
resource "aws_security_group" "alb_sg" {
  vpc_id   = module.network.M-vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}


# Create an ALB
resource "aws_lb" "node_alb" {
  name               = "NodeJs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [ module.network.M-subnets["public"].id,  module.network.M-subnets["public2"].id]

  tags = {
    Name = "Nodejs Application Load Balancer "
  }
}

# Create lb listener 
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn  = aws_lb.node_alb.arn
  port               = 80        # Listener port, adjust as needed
  protocol           = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

# Attach instances to target group
resource "aws_lb_target_group_attachment" "alb_target_group_attachment" {
  target_group_arn  = aws_lb_target_group.alb_target_group.arn
  target_id         = aws_instance.application.id
  port              = 3000
}
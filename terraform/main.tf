provider "aws" {
  region = "us-west-1"
}

resource "aws_autoscaling_group" "example" {
    launch_configuration = aws_launch_configuration.example.id
    availability_zones = ["us-west-1a"]

    min_size = 2
    max_size = 10

    load_balancers = [aws_elb.example.name]
    health_check_type = "ELB"

    tag {
      key = "Name"
      value = "terraform-asg-example"
      propagate_at_launch = true
    }
}

resource "aws_launch_configuration" "example" {
    image_id = "ami-053ac55bdcfe96e85"
    instance_type = "t2.micro"  
    security_groups = [aws_security_group.instance.id]

    user_data = <<-EOF
              #!/bin/bash
              echo "Hello World :)" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF  
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_security_group" "instance" {
    name = "terraform-example-instance"  

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_elb" "example" {
    name = "terraform-asg-example"
    security_groups = [aws_security_group.elb.id]
    availability_zones = ["us-west-1a"]

    health_check {
      target = "HTTP:8080/"
      interval = 30
      timeout = 3
      healthy_threshold = 2
      unhealthy_threshold = 2
    }

    listener {
      lb_port = 80
      lb_protocol = "http"
      instance_port = 8080
      instance_protocol = "http"
    }
}

resource "aws_security_group" "elb" {
    name = "terraform-example-elb"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "elb_dns_name" {
    value = aws_elb.example.dns_name
    description = "The domain name of the load balancer"
}
# general
data "aws_ssm_parameter" "my_amzn_linux_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}


locals {
    ec2_name_prefix = "gryukhanyan_ec2_tf_"
}


# security group
data "aws_security_group" "sg" {
  name = var.security_group_name
}

resource "aws_security_group" "sg-tf" {
  name        = var.security_group_name
  description = var.security_group_description

  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] // Allow traffic from any IP address
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          // Allow all protocols
    cidr_blocks = ["0.0.0.0/0"] // Allow traffic to any IP address
  }

  tags = {
    Name = var.security_group_name
  }
}


# Launch template
resource "aws_launch_template" "launch_template_tf" {
  name_prefix = var.launch_template_name
  description = "EC2 launch template generated from terraform"

  network_interfaces {
    device_index                = 0
    associate_public_ip_address = true
    security_groups             = [data.aws_security_group.sg.id]
  }

  instance_type = var.instance_type_tf
  key_name      = var.key_pair_tf
  image_id      = data.aws_ssm_parameter.my_amzn_linux_ami.insecure_value


  placement {
    availability_zone = var.availability_zone_tf
  }
}


# EC2
resource "aws_instance" "ec2_tf" {
  count = 3

  launch_template {
    id      = aws_launch_template.launch_template_tf.id
    version = "$Latest"
  }

  tags = {
    Name = "esargsyan_ec2_tf_${format("%01d", count.index + 1)}"
  }
}

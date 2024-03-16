provider "aws" {
  region = "us-west-2"  # Укажите свой регион AWS
}

# Локальная переменная для форматирования имени экземпляра
locals {
  instance_name_format = "${var.instance_name_prefix}-%02d"
}

# Получение AMI ID из SSM Parameter Store
data "aws_ssm_parameter" "ami" {
  name = var.ami_parameter_name
}

# Создание шаблона запуска экземпляра с UserData
resource "aws_launch_template" "instance" {
  name_prefix   = "example-instance"
  image_id      = data.aws_ssm_parameter.ami.value
  instance_type = "t2.micro"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
    }
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup python -m SimpleHTTPServer 80 &
              EOF
}

# Создание экземпляров из шаблона
resource "aws_instance" "example" {
  count         = var.instance_count
  ami           = aws_launch_template.instance.image_id
  instance_type = aws_launch_template.instance.instance_type

  tags = {
    Name = format(local.instance_name_format, count.index + 1)
  }
}

# Вывод приватных IP-адресов экземпляров
output "instance_private_ips" {
  value = aws_instance.example[*].private_ip
}

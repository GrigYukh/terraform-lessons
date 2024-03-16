output "instance_private_ip_address_1" {
    value = aws_instance.ec2_tf[0].private_ip
}

output "instance_private_ip_address_2" {
        value = aws_instance.ec2_tf[1].private_ip
}

output "instance_private_ip_address_3" {
        value = aws_instance.ec2_tf[2].private_ip
}

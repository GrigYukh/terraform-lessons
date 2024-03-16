variable "instance_count" {
  description = "Number of instances to launch"
  type        = number
}

variable "instance_name_prefix" {
  description = "Prefix for instance name tag"
  type        = string
}

variable "ami_parameter_name" {
  description = "Name of the SSM parameter containing the AMI ID"
  type        = string
}

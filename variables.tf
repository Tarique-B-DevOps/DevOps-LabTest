variable "aws_key_path" {

  default = "/home/ubuntu/ubuntu/aws2023.pem"

}

variable "aws_key_name" {

}

variable "aws_region" {

  type = string

  description = "AWS Region the instance is launched in"

  default = "us-east-1"

}

variable "ami" {

  type = string

  description = "The AMI to use for the instance. By default it is the AMI provided by Amazon with Ubuntu 16.04"

  default = "ami-002070d43b0a4f171"

}

variable "vpc_cidr" {

  description = "CIDR for the whole VPC"

  default = "10.0.0.0/16"

}

variable "public_subnet_cidr" {

  description = "CIDR for the Public Subnet"

  default = "10.0.0.0/24"

}

variable "private_subnet_cidr" {

  description = "CIDR for the Private Subnet"

  default = "10.0.1.0/24"

}

variable "instance_type" {

  type = string

  description = "The type of the instance"

  default = "t2.micro"

}

variable "instance_name" {

  description = "Value of the Name tag for the EC2 instance"

  type = string

  default = "ElasticsearchServer"

}

variable "instance_count" {

  default = "2"

}
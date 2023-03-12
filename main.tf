terraform {

  required_providers {

    aws = {

      source = "hashicorp/aws"

      version = "~> 3.27"

    }

  }

}

provider "aws" {

  region = "us-east-1"

}

#Creating VPC, public & Private Suvnet and NatGateway and RouteTable

resource "aws_vpc" "ESvpc" {

  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true

  tags = {

    Name = "ESVPC"

  }

}

resource "aws_internet_gateway" "ESNATGateway" {

  vpc_id = aws_vpc.ESvpc.id

}

resource "aws_subnet" "PublicSubnetforES" {

  vpc_id = aws_vpc.ESvpc.id

  cidr_block = var.public_subnet_cidr

  availability_zone = "us-east-1a"

  tags = {

    Name = "Public Subnet"

  }

}

resource "aws_subnet" "PrivateSubnetForES" {

  vpc_id = aws_vpc.ESvpc.id

  cidr_block = var.private_subnet_cidr

  availability_zone = "us-east-1a"

  tags = {

    Name = "Private Subnet"

  }

}

resource "aws_route_table" "ESroutetable" {

  vpc_id = aws_vpc.ESvpc.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.ESNATGateway.id

  }

}

# Subnet — Route Table associations

resource "aws_route_table_association" "PublicSubnetforES" {

  subnet_id = aws_subnet.PublicSubnetforES.id

  route_table_id = aws_route_table.ESroutetable.id

}

#Creating Security Group for the Elasticsearch

resource "aws_security_group" "ESSecurityGroup" {

  name = "ElasticseaarchSecurityGroup"

  description = "Allow traffic to pass from the private subnet to the internet"

  ingress {

    from_port = 22

    to_port = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

    #cidr_blocks = [“${var.private_subnet_cidr}”]

  }

  ingress {

    from_port = 9200

    to_port = 9200

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port = 9300

    to_port = 9300

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

  vpc_id = aws_vpc.ESvpc.id

  tags = {

    Name = "NATSG"

  }

}

# launch an EC2 instance with centos AMI

resource "aws_instance" "elastic_search_server" {

  ami = var.ami

  instance_type = var.instance_type


  availability_zone = "us-east-1a"

  key_name = "aws2023"

  vpc_security_group_ids = ["${aws_security_group.ESSecurityGroup.id}"]

  subnet_id = aws_subnet.PublicSubnetforES.id


  associate_public_ip_address = true

  source_dest_check = false

  # perform the update and install the unzip tool which we will need later in the playbook.

  provisioner "remote-exec" {

    inline = ["sudo yum update -y", "sudo yum install unzip -y", "echo Done!"]

    connection {

      type = "ssh"

      agent = false

      host = self.public_ip

      user = "centos"

      private_key = file(var.aws_key_path)

    }

  }

# connect to the newly created instance and apply the ansible playbook which will install and configure the elasticsearch
# with ssl certificate for encrypted connection and user with password for safer access.

  provisioner "local-exec" {

    command = "ansible-playbook -u centos -i '${self.public_ip},' --private-key ${var.aws_key_path} -e 'host_key_checking=False' elasticplaybook.yml"

  }

  tags = {

    Name = var.instance_name

  }

}
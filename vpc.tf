provider "aws" {
	region = "ap-south-1"
	profile = "akash"
}


#step:1:create VPC
resource "aws_vpc" "main" {
	cidr_block = var.cidr_block_vpc
	tags = {
		Name = "my tf vpc"
	}
}


#step:2/3:create/attach IGW
resource "aws_internet_gateway" "igw"{
	vpc_id = aws_vpc.main.id
	tags = {
		Name = "tfigw"
	}
}


#step:4:create subnets
resource "aws_subnet" "tfsubnet"{
	count = length(var.cidr_block_subnets)
	vpc_id = aws_vpc.main.id
	cidr_block = element(var.cidr_block_subnets, count.index)
	availability_zone = element(var.az, count.index)
	map_public_ip_on_launch = true
	tags = {
		Name = "subnet-${count.index+1}"
	}	
}


#step:5:create RT
resource "aws_route_table" "tfRT" {
	vpc_id = aws_vpc.main.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.igw.id
    }
	tags = {
		Name = "tf routing table"
	}
}


#step:6:attach RT to Routers
resource "aws_route_table_association" "RT_attach" {	
	count = length(var.cidr_block_subnets)
	subnet_id = element(aws_subnet.tfsubnet.*.id, count.index)
	route_table_id = aws_route_table.tfRT.id
}

output "o1"{
	value = aws_subnet.tfsubnet.0.id
}

resource "aws_instance" "os1"{
	subnet_id   = aws_subnet.tfsubnet.0.id
	ami = var.instance_image
	instance_type = var.instance_type
	tags = {
		Name = "terraform os"
	}
}


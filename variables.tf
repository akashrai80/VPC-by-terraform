variable "cidr_block_vpc"{
	default = "10.0.0.0/16"
}

variable "cidr_block_subnets"{
	type = list
	default = ["10.0.1.0/24", "10.0.2.0/24"] 
}

variable "az"{
	type = list
	default = ["ap-south-1a", "ap-south-1b"]
}

variable "instance_image"{
	default = "ami-010aff33ed5991201"
}

variable "instance_type"{
	default = "t2.micro"
}
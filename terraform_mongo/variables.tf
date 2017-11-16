variable "public_key_path" {
  default = "/path/to/your/id_rsa.pub"
}

variable "key_name" {
  default = "your-key-pair-name"
}

variable "aws_region" {
  default     = "us-east-1"
}

variable "vpc_cidr_blk" {
  type    = "string"
  default = "10.10.0.0/16"
}

variable "subnet_cidr_blk" {
  type    = "map"
  default = {
    "us-east-1a" = "10.10.1.0/24,10.10.2.0/24"
    "us-east-1b" = "10.10.11.0/24,10.10.12.0/24"
    "us-east-1c" = "10.10.21.0/24,10.10.22.0/24"
  }
}

variable "layers_count" {
  type    = "string"
  default = "2"
}

variable "domain" {
  default = "test.com."
}

variable "instance_type" {
  default = "t2.small"
}

variable "num_instances" {
  default = "3"
}

# CentOS Linux 7
variable "aws_amis" {
  default = {
    ap-southeast-1 = "ami-30318f53"
    us-east-1 = "ami-ae7bfdb8"
  }
}

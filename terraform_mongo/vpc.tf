resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr_blk}"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "my_subnet" {
  count             = "${length(var.subnet_cidr_blk) * var.layers_count}"
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${element(split(",", lookup(var.subnet_cidr_blk, element(data.aws_availability_zones.available.names, ceil(count.index / var.layers_count)))), count.index % var.layers_count)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, ceil(count.index / var.layers_count))}"
  map_public_ip_on_launch = true

  tags {
    Name         = "${element(split(",", lookup(var.subnet_cidr_blk, element(data.aws_availability_zones.available.names, ceil(count.index / var.layers_count)))), count.index % var.layers_count)}"
  }
}

resource "aws_vpc_dhcp_options" "default" {
    domain_name = "${var.domain}"
    domain_name_servers = ["AmazonProvidedDNS"]
}

resource "aws_vpc_dhcp_options_association" "default" {
    vpc_id = "${aws_vpc.default.id}"
    dhcp_options_id = "${aws_vpc_dhcp_options.default.id}"
}

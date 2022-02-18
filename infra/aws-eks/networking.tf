data "aws_vpc" "default_vpc_id" {
    default = true
}

data "aws_subnet_ids" "default_subnet_ids" {
  vpc_id = data.aws_vpc.default_vpc_id.id
}

data "aws_security_group" "default_sg" {
    vpc_id = data.aws_vpc.default_vpc_id.id
    name = "default"
}

data "aws_security_group" "vpn_sg" {
    vpc_id = data.aws_vpc.default_vpc_id.id
    name = "epam-by-ru"
}

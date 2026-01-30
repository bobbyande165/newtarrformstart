resource "aws_vpc" "vpc-cre" {
    cidr_block =var.network_info.vpcid
    tags = {
      Name=var.network_info.vpcname
    }
}
resource "aws_subnet" "subnets-cre" {
    vpc_id =aws_vpc.vpc-cre.id
    count = local.value
    cidr_block=var.network_info.subnets[0].subnetid[count.index]
    availability_zone =  var.network_info.subnets[0].subnetaz[count.index]
    tags = {
        Name=var.network_info.subnets[0].subnetname[count.index]
    }
}
resource "aws_route_table" "route-table-cre" {
    vpc_id =aws_vpc.vpc-cre.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.intgway.id
    }
    tags = {
        Name="rtb23"
    }
}
resource "aws_route_table_association" "rtblassn" {
    count = local.value
    subnet_id =aws_subnet.subnets-cre[count.index].id
    route_table_id =  aws_route_table.route-table-cre.id
}
resource "aws_internet_gateway" "intgway" {
    vpc_id = aws_vpc.vpc-cre.id
    tags = {
      Name="integway23"
    } 
}
resource "aws_security_group" "sg-cre" {
    name = "sg23"
    description = "open all ports"
    vpc_id = aws_vpc.vpc-cre.id
}
resource "aws_vpc_security_group_ingress_rule" "ingress-sg" {
    security_group_id = aws_security_group.sg-cre.id
    from_port = 22
    to_port = 22
    ip_protocol="tcp"
    cidr_ipv4 = "0.0.0.0/0"
}
resource "aws_key_pair" "name" {
    key_name = "mysshownkey"
    public_key = file("C:/Users/home/.ssh/id_ed25519.pub")
}
resource "aws_instance" "myec2" {
    ami = "ami-019715e0d74f695be"
    instance_type = "t3.micro"
    key_name = aws_key_pair.name.key_name
    associate_public_ip_address = true
    subnet_id = aws_subnet.subnets-cre[0].id
    vpc_security_group_ids = [aws_security_group.sg-cre.id]
    tags={
        Name="my-terraformec2"
    }
  
}
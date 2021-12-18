provider "aws" {
  region = var.region
}
#creating an vpc
resource "aws_vpc" "shoppingcart-test"{
    cidr_block = var.cidr
    instance_tenancy = "default"
    enable_dns_hostnames = "true"

    tags = {
        Name = var.envname
    }

}

#Subnets

resource "aws_subnet" "pubsubnet"{
    count = length(var.azs)
    vpc_id = aws_vpc.shoppingcart-test.id
    cidr_block = element(var.pubsubnets,count.index)
    availability_zone = element(var.azs,count.index)
    map_public_ip_on_launch = "true"

    tags = {
        Name = "${var.envname}-pubsubnet-${count.index+1}"
    }
}

resource "aws_subnet" "privatesubnet"{
    count = length(var.azs)
    vpc_id = aws_vpc.shoppingcart-test.id
    cidr_block = element(var.privatesubnets,count.index)
    availability_zone = element(var.azs,count.index)
    # cidr_block = element(var.privatesubnets,count.index)


    tags = {
        Name = "${var.envname}-privatesubnet-${count.index+1}"
    }
}

resource "aws_subnet" "datasubnet"{
    count = length(var.azs)
    vpc_id = aws_vpc.shoppingcart-test.id
    cidr_block = element(var.datasubnets,count.index)
    availability_zone = element(var.azs,count.index)

    tags = {
        Name = "${var.envname}-privatesubnet-${count.index+1}"
    }
}

#IGW and attach to VPC

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.shoppingcart-test.id

  tags = {
    Name = "${var.envname}-igw"
  }
}

#Allocate EIP with NAT
resource "aws_eip" "NATIP" {
  vpc = true
    tags = {
    Name = "${var.envname}-nat"
  }
}


#Associate NAT with publicsubnet
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.NATIP.id
  subnet_id     = aws_subnet.pubsubnet[0].id

  tags = {
    Name = "${var.envname}-natgw"
  }

}

#Rout Table public and private

resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.shoppingcart-test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.envname}-publicroute"
  }
}

resource "aws_route_table" "privateroute" {
  vpc_id = aws_vpc.shoppingcart-test.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "${var.envname}-privateroute"
  }
}

resource "aws_route_table" "dataroute" {
  vpc_id = aws_vpc.shoppingcart-test.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "${var.envname}-dataroute"
  }
}

#Associate routetables with pub, pri and data
resource "aws_route_table_association" "pubsubassociate" {
  count = length(var.pubsubnets)
  subnet_id      = element(aws_subnet.pubsubnet.*.id,count.index)
  route_table_id = aws_route_table.publicroute.id
}

resource "aws_route_table_association" "prisubassociate" {
  count = length(var.privatesubnets)
  subnet_id      = element(aws_subnet.privatesubnet.*.id,count.index)
  route_table_id = aws_route_table.privateroute.id
}

resource "aws_route_table_association" "datasubassociate" {
  count = length(var.datasubnets)
  subnet_id      = element(aws_subnet.datasubnet.*.id,count.index)
  route_table_id = aws_route_table.dataroute.id
}





































# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table

resource "aws_vpc" "demo" {
  cidr_block = "10.0.0.0/16"

  /*tags = map(
    "Name", "eks-landmark-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
  
  tags = "${
    tomap(
     "Name", "eks-landmark-node",
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
    */
    tags = {
  "Name" = "eks-landmark-node"
  "kubernetes.io/cluster/${var.cluster-name}" = "shared"
}
  
}

resource "aws_subnet" "demo" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.demo.id

  /*tags = map(
    "Name", "eks-landmark-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
  
  tags = "${
    tomap(
     "Name" , "eks-landmark-node"
     "kubernetes.io/cluster/${var.cluster-name}", "shared",
    )
  }"
  */
  tags = {
  "Name" = "eks-landmark-node"
  "kubernetes.io/cluster/${var.cluster-name}" = "shared"
}
}

resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "eks-landmark"
  }
}

resource "aws_route_table" "demo" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }
}

resource "aws_route_table_association" "demo" {
  count = 2

  subnet_id      = aws_subnet.demo.*.id[count.index]
  route_table_id = aws_route_table.demo.id
}
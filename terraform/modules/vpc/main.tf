resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = "${var.project_name}-vpc"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.project_name}-igw"
    }
}
#================================================================
#Public Subnets (For Load Balancers & NAT Gateway)
#================================================================
resource "aws_subnet" "public" {
    count = length(var.public_subnets_cidr)

    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnets_cidr[count.index]
    availability_zone = var.availability_zones[count.index]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-public-${var.availability_zones[count.index]}"
        "kubernetes.io/role/elb" = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }

    #Kubernetes Cluster Subnet Tags
}
# =====================================================================
# Private Subnets (For EKS Worker Nodes & Pods)
# =====================================================================

resource "aws_subnet" "private" {
    count = length(var.private_subnets_cidr)

    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnets_cidr[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "${var.project_name}-private-${var.availability_zones[count.index]}"
        "kubernetes.io/role/internal-elb" = "1"
        "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
}

# ==================================================================
# Elastic IP (Static Public IP for the NAT Gateway)
# =====================================================================
resource "aws_eip" "nat" {
    domain = "vpc"

    tags = {
        Name = "${var.project_name}-nat-eip"
    }
}

# =====================================================================
# NAT Gateway (In Public Subnet 0)
resource "aws_nat_gateway" "main" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public[0].id

    tags = {
        Name = "${var.project_name}-nat"
    }

    # Ensure the Internet Gateway exists before Creating the NAT Gateway
    depends_on = [aws_internet_gateway.main]
}

# ===================================================================
# Route Tables & Associations
# =====================================================================

#1. Public Route Table (Points to Internet Gateway)
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id   
    }
    tags = {
        Name = "${var.project_name}-public-rt"
    }
}

# Associate Public Subnets with Public Route Tables
resource "aws_route_table_association" "public" {
    count = length(aws_subnet.public)
    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}
# 2. Private Route Table (Points to NAT Gateway)
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id
    route{
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.main.id
 }
 tags = {
    Name = "${var.project_name}-private-rt"
 }
}
#Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private"{
    count = length(aws_subnet.private)

    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.private.id
}
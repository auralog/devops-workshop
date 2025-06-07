provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "terra-vpc" {
    cidr_block  = "10.0.0.0/16"
    tags = {
        name = "terra-vpc"
    }
}

resource "aws_subnet" "terra_public_subnet-01" {
    vpc_id      = aws_vpc.terra-vpc.id
    cidr_block  = "10.0.10.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true 
    tags = {
        Name = "terra_public_subnet-01"
    }
    
}

resource "aws_subnet" "terra_public_subnet-02" {
    vpc_id      = aws_vpc.terra-vpc.id
    cidr_block  = "10.0.20.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true 
    tags = {
        Name = "terra_public_subnet-02"
    }
    
}

resource "aws_internet_gateway" "terra-igw" {
  vpc_id = aws_vpc.terra-vpc.id
  tags = {
    Name = "terra-igw"
  }
}

resource "aws_route_table" "terra-public_rt" {
  vpc_id = aws_vpc.terra-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terra-igw.id
  }
  tags = {
    Name = "terra-public-rt"
  }
}

resource "aws_route_table_association" "terra_public_rt_assoc-public-subnet-01" {
  subnet_id      = aws_subnet.terra_public_subnet-01.id
  route_table_id = aws_route_table.terra-public_rt.id
}

resource "aws_route_table_association" "terra_public_rt_assoc-public-subnet-02" {
  subnet_id      = aws_subnet.terra_public_subnet-02.id
  route_table_id = aws_route_table.terra-public_rt.id
}

resource "aws_instance" "terraform" {
  ami           = "ami-0953476d60561c955"
  instance_type = "t2.micro"
  key_name      = "Auralogltd"
  vpc_security_group_ids = [aws_security_group.ssh-sg.id] 
  subnet_id     = aws_subnet.terra_public_subnet-01.id
  tags          = {
    Name = "terraform"
  }
}

resource "aws_security_group" "ssh-sg" {
 name        = "ssh-sg"
 description = "allows ssh access to the test server"
 vpc_id = aws_vpc.terra-vpc.id
 tags          = {
    Name = "ssh-sg"
  }

ingress {
   description = "SSH ingress"
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }

egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}
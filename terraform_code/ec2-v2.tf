provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "test" {
  ami           = "ami-0953476d60561c955"
  instance_type = "t2.micro"
  key_name      = "Auralogltd"
  tags          = {
    Name = "HelloDevops"
  }
}

resource "aws_security_group" "SSH Access" {
 name        = "SSH Access"
 description = "allows ssh access to the test server"
 

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
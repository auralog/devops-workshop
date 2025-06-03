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
resource "aws_instance" "ec2-terraform1" {
  ami = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  tags = {
    Name = "ec2-terraform1-separado"
  }
}
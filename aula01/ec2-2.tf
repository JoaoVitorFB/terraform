resource "aws_instance" "ec2-terraform2" {
  ami = "ami-0a0e5d9c7acc336f1"
  instance_type = "t2.micro"
  tags = {
    Name = "ec2-terraform2-separado"
  }
}

resource "aws_ebs_volume" "ebs_volume_for_ec2_terraform2" {
  availability_zone = aws_instance.ec2-terraform2.availability_zone
  size              = 80  # Defina o tamanho do volume em GiB
  type              = "gp3"

  tags = {
    Name = "ebs-volume-terraform2"
  }
}

resource "aws_volume_attachment" "ebs_attach_to_ec2_terraform2" {
  device_name = "/dev/sdf"  # Nome do dispositivo na instância
  volume_id   = aws_ebs_volume.ebs_volume_for_ec2_terraform2.id
  instance_id = aws_instance.ec2-terraform2.id

  force_detach = false  # Não força o desanexamento, pois é um novo volume
}
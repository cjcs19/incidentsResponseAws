locals {
  env         = "dev"
  module_name = "test"
}

data "aws_ami" "amazon_linux_test" {
  most_recent = true

  owners = ["192496667219"]

  filter {
    name = "name"

    values = [
      "*forTestTerragrunt*",
    ]
  }

}

#Bastion SSH
resource "aws_instance" "ec2totest" {
  ami                    = data.aws_ami.amazon_linux_test.id
  key_name               = aws_key_pair.ec2test_key.key_name
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg-bastion]
  iam_instance_profile   = "${var.role-ip}"



  tags = {
    Name = "${var.project}"
  }

  #associate_public_ip_address = true
}


resource "aws_key_pair" "ec2test_key" {
  key_name   = "forensicSsh_${var.project}_Test"
  public_key = var.public_key
}




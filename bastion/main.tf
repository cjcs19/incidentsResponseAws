locals {
  env         = "general"
  module_name = "bastion"
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["192496667219"]

  filter {
    name = "name"

    values = [
      "*forensicsStation-scriptExec*",
    ]
  }

}

#Bastion SSH
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux.id
  key_name               = aws_key_pair.bastion_key.key_name
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg-bastion]
  iam_instance_profile   = "${var.role-ip}"


    #provisioner "file" {
    #  source      = "scriptResponse.sh"
    #  destination = "/opt/scriptResponse.sh"
    #}
#
#
    #provisioner "remote-exec" {
    #  inline = [
    #    "chmod +x /opt/scriptResponse.sh",
    #    "echo 'Iniciando' > /tmp/script-validate.txt",
    #  ]
    #}

  tags = {
    Name = "${var.project}"
  }

  associate_public_ip_address = true
}


resource "aws_key_pair" "bastion_key" {
  key_name   = "forensicSsh_${var.project}"
  public_key = var.public_key
}




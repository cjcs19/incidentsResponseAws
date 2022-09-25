####################################################################
# AWS Security group to Ec2 Public
####################################################################


resource "aws_security_group" "allow_ssh" {
  name        = "allow_SSh Bastion"
  description = "Allow SSH inbound traffic to bastion"
  vpc_id      = "${var.vpc_id}"

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow Http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0 
    to_port     = 0 
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}



locals {
  env         = "general"
  module_name = "bastion"
}

resource "aws_ssm_parameter" "ec2toinvestigar" {
  name  = "ec2toinvestigar"
  type  = "String"
  value = "${var.instancetoinv}"
}

resource "aws_ssm_parameter" "bucketcollect" {
  name  = "bucketcollect"
  type  = "String"
  value = "${var.bucketcollect}"
}
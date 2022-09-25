####################################################################
# Terraform Backend
####################################################################
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}


data "aws_caller_identity" "current" {}

module "security" {
  source                = "./security"

  env                   = "${var.GtagEnv}"

  subnet_pub_all_cidr   = "${var.Gsubnet_pub_all_cidr}"
  vpc_id                = "${var.Gvpc_id}"
  vpc_cidr              = "${var.Gvpc_cidr}"

  app                   = "forensic"
}

module "role-instance-profile" {
  source      = "./role"
  env         = "${var.GtagEnv}"
  project     = "${var.Gproject}"

}

###################################################################
# Forensic Work Station
###################################################################
module "bastion" {
  source      = "./bastion"

  env         = "${var.GtagEnv}"

  ambiente    = "${var.GAMBIENTE}"
  subnet_id   = "subnet-05f1dc7c4dfedf5f1"
  public_key  = "${var.Gpublic_key_bastion}"
  sg-bastion  = module.security.ec2_security_group_ssh_id
  project     = "${var.Gproject}"

  role-ip     = module.role-instance-profile.name_role_instance_profile

  depends_on = [
    module.role-instance-profile
  ]

}
###################################################################
# S3 to save all evidence
###################################################################

module "storageS3" {
  source          = "./storage"

  project         = "${var.Gproject}"

  bucket_name     = "incident-response" #"${var.Gproject}"
  bucket_name_suf = formatdate("DDMMYYYYhhmm", timestamp())


  role-ip-ec2     = module.role-instance-profile.arn_role_iam_ec2

  current_account_id = data.aws_caller_identity.current.account_id

  depends_on = [
    module.bastion
  ]
}

###################################################################
# Testing Propose
###################################################################
module "ec2totest" {
  source      = "./ec2totest"

  env         = "${var.GtagEnv}"

  ambiente    = "${var.GAMBIENTE}"
  subnet_id   = "subnet-05f1dc7c4dfedf5f1"
  public_key  = "${var.Gpublic_key_bastion}"
  sg-bastion  = module.security.ec2_security_group_ssh_id
  project     = "${var.Gproject}-Test"

  role-ip     = module.role-instance-profile.name_role_instance_profile

  depends_on = [
    module.role-instance-profile
  ]
}

###################################################################
# Parameters to initiate process
###################################################################
module "parameters" {

  source        ="./parameters"

  instancetoinv = module.ec2totest.idEc2ToTest
  bucketcollect = module.storageS3.name_aws_s3_bucket_collect

  env         = "${var.GtagEnv}"
  project     = "${var.Gproject}"

  depends_on = [
    module.storageS3
  ]
}
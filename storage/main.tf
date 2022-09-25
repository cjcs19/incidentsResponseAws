locals {
  env         = "dev"
  module_name = "estorageS3"

}

resource "aws_s3_bucket" "collect" {
  bucket = "${var.bucket_name}-${var.bucket_name_suf}"

}

resource "aws_s3_bucket_acl" "collect" {
  bucket = aws_s3_bucket.collect.id
  acl    = "private"
}

#resource "aws_s3_bucket_policy" "collect" {
#  bucket = aws_s3_bucket.collect.id
#  policy = <<POLICY
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Sid": "AllowAllFromEc2",
#      "Effect": "Allow",
#      "Principal": {
#        "AWS": "${var.role-ip-ec2}"
#      },
#      "Action": "s3:*",
#      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
#    },
#    {
#      "Sid": "OnlyGetOtherEntities",
#      "Effect": "Deny",
#      "Principal": {
#        "AWS": "arn:aws:iam::${var.current_account_id}:user/*"
#      },
#      "Action": "s3:put",
#      "Resource": "arn:aws:s3:::${var.bucket_name}/*"
#    }
#  ]
#}
#POLICY
#}




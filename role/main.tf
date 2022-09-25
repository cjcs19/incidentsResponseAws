locals {
  env         = "general"
  module_name = "bastion"
}

resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2_policy_incident_response"
  path        = "/"
  description = "Policy to provide permission to EC2"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:*"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ssmmessages:*"
        ],
        Resource = "*"
      },
      {
        "Effect": "Allow",
        "Action": [
            "s3:*"
        ],
        "Resource": [
            "*"
        ]
      },
      {
        "Effect": "Allow",
        "Action": [
            "ec2:*"
        ],
        "Resource": [
            "*"
        ]
      }
    ]
  })
}


resource "aws_iam_role" "ec2_role" {
  name = "ec2_role_incident_response"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}


resource "aws_iam_policy_attachment" "ec2_policy_role" {
  name       = "ec2_attachment_incident_response"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile_incident_response"
  role = aws_iam_role.ec2_role.name
}
/*
 _____  __  __  ____  ____  __  __  ____  ___
(  _  )(  )(  )(_  _)(  _ \(  )(  )(_  _)/ __)
 )(_)(  )(__)(   )(   )___/ )(__)(   )(  \__ \
(_____)(______) (__) (__)  (______) (__) (___/

*/

output "name_role_instance_profile" {
  value = aws_iam_instance_profile.ec2_profile.name
}


output "arn_role_instance_profile" {
  value = aws_iam_instance_profile.ec2_profile.arn
}

output "arn_role_iam_ec2" {
  value= aws_iam_role.ec2_role.arn
}
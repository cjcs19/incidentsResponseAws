/*
 _____  __  __  ____  ____  __  __  ____  ___
(  _  )(  )(  )(_  _)(  _ \(  )(  )(_  _)/ __)
 )(_)(  )(__)(   )(   )___/ )(__)(   )(  \__ \
(_____)(______) (__) (__)  (______) (__) (___/

*/

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "Ambiente" {
  value= var.ambiente
}
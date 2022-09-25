### Prerequisitos

- La primera version de este desarrollo contempla desplegar una estacion de trabajo para realizar capturas de evidencia de una ec2 comprometida.
- En la estacion de trabajo forense, se hace un mount de un S3 para enviar la evidencia recolectada en la estacion de trabajo.
- Credenciales de aws con privilegios de crear ec2, roles, s3, ssm.
- Terraform v1.0.3.
- Linux, Mac.

### Como Usar?

- Descargue el repo.
- Configure el ambiente a desplegar en el archivo de variables terraforms.tfvars:
 `		 
 			Gsubnet_pub_all_cidr   = "subnet-12345678"
			Gvpc_id                = "vpc-xxxxxxx"
			Gvpc_cidr              = "172.31.0.0/16"
            GIdEc2ToResearch       = "IDEC2aInvestigar"
            `

###### Los parametros de configuracion deben corresponder a la cuenta donde usted va a desplegar. 
- La subnet debe ser donde esta la maquina que esta comprometida.
- Configure las credenciales de AWS para usar.
- Configure la variable **TF_VAR_GIdEc2ToResearch** con el valor del id de la instancia que se ha a realizar la captura del volumen, si usted no coloca el valor de la variable en el archivo terraforms.tfvars.
- Ejecute terraform init, terraform plan, terraform apply.
-  Una vez ya instalada la infraestructura:
	- Puede actualizar el parareter store que almacena el id de la ec2 a ser recolectada(`./updatePS IDEC2XXXXX`). el valor **IDEC2XXXXX** es un parametro.
	- Ejecute el script `executeCommand.sh`.
	- Para recuperar archivos, se utiliza foremost, ejecute el script... collectJpg.sh

### Consideraciones:
- La ami de la estacion de trabajo es la **ami-0590cdbf53c13b6ea**,  que por los momento la coloquè publica para poder ejecutar  la evalucacion, dejar los valores como estan.
- El punto de montura /opt/datatoanalize es un enlace al s3 para descargar la informacion recolectada.
- **Es una primera version**.



#!/bin/bash


ec2compromised=$(aws ssm get-parameters --names ec2toinvestigar \
                    --query 'Parameters[*].Value' --output text)

bucketcollect=$(aws ssm get-parameters --names bucketcollect \
                --query 'Parameters[*].Value' --output text)
                
echo "Buscando Parametros ...."
sleep 35



sudo s3fs $bucketcollect /opt/data -o iam_role="ec2_role_incident_response"

echo "Iniciando ...."


ec2Local=$(curl http://169.254.169.254/latest/meta-data/instance-id)

    snapshot=$(aws ec2 create-snapshots	\
        --instance-specification InstanceId=$ec2compromised \
        --query 'Snapshots[*].SnapshotId' --output text)

    echo "Creando SnapShot $snapshot ...."
    until [ "$statusSH" == "completed" ]
    do
        echo "Validando Status SnapShot $snapshot ."
        sleep 25
            statusSH=$(aws ec2 describe-snapshots \
                            --snapshot-ids $snapshot \
                            --query 'Snapshots[*].State' --output text)

    done


    volumenToMount=$(aws ec2 create-volume \
	            --volume-type gp2 --snapshot-id $snapshot  \
	            --availability-zone us-east-1a --query 'VolumeId' --output text)

    echo "Creando Volumen $volumenToMount ."
    until [ "$statusVol" == "available" ]
    do
        echo "Validando Status Volumen $volumenToMount ."
        sleep 25
            statusVol=$(aws ec2 describe-volumes \
                        --volume-ids $volumenToMount \
                        --query 'Volumes[*].State' --output text)

    done

    echo "Adjuntando Volumen $volumenToMount a Estacion Forense."
    aws ec2 attach-volume \
        --volume-id ${volumenToMount} \
        --instance-id ${ec2Local}  --device /dev/sdf


    sudo mkdir -p /opt/datatoanalize

    echo "Terminando de incorporar $volumenToMount volumen a la estacion Forense  ."
    sleep 65

    sudo mount -o ro /dev/xvdf2 /opt/datatoanalize

    echo "Completado!!! para comenzar Analisis a Estacion Forense...."
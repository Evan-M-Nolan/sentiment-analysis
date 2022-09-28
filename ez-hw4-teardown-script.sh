#! /bin/bash

aws ec2 terminate-instances --instance-ids $INSTANCE_ID --region us-east-1

STATE=$(aws ec2 describe-instances --instance-id $INSTANCE_ID --query "Reservations[0].Instances[0].State.Name" --output text --region us-east-1)

while [ $STATE != "terminated" ]
do
sleep 5
STATE=$(aws ec2 describe-instances --instance-id $INSTANCE_ID --query "Reservations[0].Instances[0].State.Name" --output text --region us-east-1)
done

aws ec2 delete-security-group --group-id $SECURITY_GROUP_ID --region us-east-1

aws ec2 delete-subnet --subnet-id "$PUB_SUB_A" --region us-east-1

aws ec2 delete-subnet --subnet-id $PUB_SUB_B --region us-east-1

aws ec2 delete-subnet --subnet-id $PRIV_SUB_A --region us-east-1

aws ec2 delete-subnet --subnet-id $PRIV_SUB_B --region us-east-1

aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_ID --region us-east-1

aws ec2 detach-internet-gateway --internet-gateway-id $GATE_ID --vpc-id $VPC_ID --region us-east-1

aws ec2 delete-internet-gateway --internet-gateway-id $GATE_ID --region us-east-1

aws ec2 delete-vpc --vpc-id $VPC_ID --region us-east-1

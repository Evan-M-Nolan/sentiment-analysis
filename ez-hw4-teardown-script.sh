#! /bin/bash
#aws ec2 delete-security-group --group-id $GROUP_ID

aws ec2 delete-subnet --subnet-id "$PUB_SUB_A" --region us-east-1

aws ec2 delete-subnet --subnet-id $PUB_SUB_B --region us-east-1

aws ec2 delete-subnet --subnet-id $PRIV_SUB_A --region us-east-1

aws ec2 delete-subnet --subnet-id $PRIV_SUB_B --region us-east-1

aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_ID --region us-east-1

aws ec2 detach-internet-gateway --internet-gateway-id $GATE_ID --vpc-id $VPC_ID --region us-east-1

aws ec2 delete-internet-gateway --internet-gateway-id $GATE_ID --region us-east-1

aws ec2 delete-vpc --vpc-id $VPC_ID --region us-east-1

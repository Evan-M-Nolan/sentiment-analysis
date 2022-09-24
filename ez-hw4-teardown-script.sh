#! /bin/bash
aws ec2 delete-security-group --group-id $GROUP_ID

aws ec2 delete-subnet --subnet-id $SUB_A

aws ec2 delete-subnet --subnet-id $SUB_B

aws ec2 delete-route-table --route-table-id $ROUTE_TABLE_ID

aws ec2 detach-internet-gateway --internet-gateway-id $INTERNET_GATEWAY_ID --vpc_id $VPC_ID

aws ec2 delete-internet-gateway --internet-gateway-id $INTERNET_GATEWAY_ID

aws ec2 delete-vpc --vpc-id $VPC_ID
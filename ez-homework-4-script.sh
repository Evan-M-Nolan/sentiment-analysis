#! /bin/bash

VPC_ID='aws ec2 create-vpc --cidr-block 10.0.0.0/24 --query Vpc.VpcId --output text'

export VPC_ID=$VPC_ID

SUB_A=$(aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block 10.0.0.0/26 --query Subnet.SubnetId --output text)

aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block 10.0.0.64/26

aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block 10.0.0.128/26

aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block 10.0.0.192/26

GATE_ID='aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text'

aws ec2 attach-internet-gateway --vpc-id "$VPC_ID" --internet-gateway-id "$GATE_ID"

TABLE_ID=$(aws ec2 create-route-table --vpc-id "$VPC_ID" --query RouteTable.RouteTableId --output text)

aws ec2 create-route --route-table-id "$TABLE_ID" --destination-cidr-block 0.0.0.0/0 --gateway-id "$GATE_ID"

aws ec2 describe-route-tables --route-table-id rtb-c1c8faa6 | cat

aws ec2 associate-route-table  --subnet-id "$SUB_A" --route-table-id "$TABLE_ID"

aws ec2 modify-subnet-attribute --subnet-id "$SUB_A" --map-public-ip-on-launch



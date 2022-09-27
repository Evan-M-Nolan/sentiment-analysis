#! /bin/bash

VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/24 --query Vpc.VpcId --output text --region us-east-1)

export VPC_ID=$VPC_ID

PUB_SUB_A=$(aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block 10.0.0.0/26 --query Subnet.SubnetId --output text --region us-east-1)

export PUB_SUB_A=$PUB_SUB_A

PUB_SUB_B=$(aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block 10.0.0.64/26 --query Subnet.SubnetId --output text --region us-east-1)

export PUB_SUB_B=$PUB_SUB_B

PRIV_SUB_A=$(aws ec2 create-subnet --vpc-id "$VPC_ID" --query Subnet.SubnetId --cidr-block 10.0.0.128/26 --output text --region us-east-1)

export PRIV_SUB_A=$PRIV_SUB_A

PRIV_SUB_B=$(aws ec2 create-subnet --vpc-id "$VPC_ID" --query Subnet.SubnetId --cidr-block 10.0.0.192/26 --output text --region us-east-1)

export PRIV_SUB_B=$PRIV_SUB_B

GATE_ID=$(aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text --region us-east-1)

export GATE_ID=$GATE_ID

aws ec2 attach-internet-gateway --vpc-id "$VPC_ID" --internet-gateway-id $GATE_ID --region us-east-1

ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id "$VPC_ID" --query RouteTable.RouteTableId --output text --region us-east-1)

export ROUTE_TABLE_ID=$ROUTE_TABLE_ID

aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $GATE_ID --region us-east-1

aws ec2 associate-route-table --subnet-id "$PUB_SUB_A" --route-table-id $ROUTE_TABLE_ID --region us-east-1

aws ec2 modify-subnet-attribute --subnet-id "$PUB_SUB_A" --map-public-ip-on-launch --region us-east-1

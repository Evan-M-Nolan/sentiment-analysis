#! /bin/bash

VPC_ID='aws ec2 create-vpc --cidr-block 10.0.0.0/24 --query Vpc.VpcId --output text'

export VPC_ID=$VPC_ID

aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block 10.0.0.0/26

aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block 10.0.0.64/26

aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block 10.0.0.128/26

aws ec2 create-subnet --vpc-id "$VPC_ID" --cidr-block 10.0.0.192/26

GATE_ID='aws ec2 create-internet-gateway --query InternetGateway.InternetGatewayId --output text'

aws ec2 attach-internet-gateway --vpc-id vpc-2f09a348 --internet-gateway-id $GATE_ID


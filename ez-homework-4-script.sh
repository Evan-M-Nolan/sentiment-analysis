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

aws ec2 create-key-pair --key-name MyKeyPair --query "KeyMaterial" --output text > MyKeyPair.pem --region us-east-1
chmod 400 MyKeyPair.pem

SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name SSHAccess --description "Security group for SSH access" --vpc-id $VPC_ID --output text --query GroupId --region us-east-1)
export SECURITY_GROUP_ID=$SECURITY_GROUP_ID

aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --region us-east-1

INSTANCE_ID=$(aws ec2 run-instances --image-id ami-a4827dc9 --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids $SECURITY_GROUP_ID --subnet-id $PUB_SUB_A --query "Instances[0].InstanceId" --output text --region us-east-1)
export INSTANCE_ID=$INSTANCE_ID

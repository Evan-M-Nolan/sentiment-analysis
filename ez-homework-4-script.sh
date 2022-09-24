#! /bin/bash

VpcId='aws ec2 create-vpc --cidr-block 10.0.0.0/24 --query Vpc.VpcId --output text'

aws ec2 create-subnet --vpc-id $(VpcId) --cidr-block 10.0.0.0/26

aws ec2 create-subnet --vpc-id $(VpcId) --cidr-block 10.0.0.64/26

aws ec2 create-subnet --vpc-id $(VpcId) --cidr-block 10.0.0.128/26

aws ec2 create-subnet --vpc-id $(VpcId) --cidr-block 10.0.0.192/26




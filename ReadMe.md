# Welcome to JEMPC read me for cloud.
For the hw-4 script you need to have run the aws configure before either script will work.

# Usage

## Setup
you will want to run `aws configure` to be sure everything will run smoothly. Our scripts will create/delete all of the resources in us-east-1
 
## Build
`source ./ez-homework-4-script.sh` will run the build script

## Teardown
`source ./ez-hw4-teardown.script.sh`

## Source
we use `source` to ensure our environment variables are set appropriately for the bash session and the scripts have access to each others variables.

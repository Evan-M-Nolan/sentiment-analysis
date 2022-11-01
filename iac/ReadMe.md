# How to use this IAC file

- you need to install terraform following instructions in the tutorial we used [here|https://learn.hashicorp.com/tutorials/terraform/aws-build?in=terraform/aws-get-started]
- navigate to the iac folder and run `terraform init`
- There is currently an issue and inorder to run the code you need to add these lines
`provider "aws" {region = "us-east-2" access_key = "access_key" secret_key="secret key"`
}
Do not add these changes to the git
- ensure you have edited the iac-team-6.tf file to add the proper access keys (this is just for now while we test)
- run `terraform apply` to build the stuff, use `terraform destroy` to remove it
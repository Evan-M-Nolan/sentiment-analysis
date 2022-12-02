# Welcome to the youtube sentiment analysis project!
A few things in this here readme. to do this you will need
1. a free tier account
To start the terraform and spin up the IAC follow these instructions
 
The goal of this little testable demo to follow is to show you that the system works while
also not draining our wonderful TA's or Professor's wallet.
 
So we will be creating our project and running a test query on the website, and then waiting for the results to come in.
 
## Steps
1. set up front end
1. 1. `npm install`
1. 2. `npm run build`
 
# Go to Iac
1. `cd ../iac`
 
# Terraform steps
1. Fill in the secrets: Access key, and Secret key (optional fill in account id)
2. `terraform init`
3. `terraform apply`
4. `terraform apply` No I did not mistype you have to apply twice for it to run without errors. It is a known issue.
 
After that there are a few safeguards set to prevent you losing all of your money instantly that will need to be disabled to get the project working.
1. go to api gateway and copy the invoke url from deployed stage
2. go the s3 static -files bucket in the static/js inside the main js file download that file ctrl+f for "api", replace this with the invoke url.
Ensure it ends with a "/", re-upload that file to the same folder
Go to the lambda functions. Go to the download-video-to-s3 lambda and enable the sqs trigger. (Optionally) add a sqs trigger for the only defined topic.
 
Go to the static website bucket url in a browser search for a topic and wait for about five minutes!
# Testing. ON the front end search a single word topic.
wait about 2~5 minutes for the results to go back
view and grade!
# run destroy before 2 hours.
if it runs for 6 hours it collects videos 3 times it costs ~ 6 dollars
If destroyed before it should be less than 2$
 
 


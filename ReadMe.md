# Welcome to the youtube sentiment analysis project!
As some prerequisites to starting our project, you will need
1. a free tier account
2. our AMI running in a free tier account
3. The access key, secret key, and account ID of the user you will be running this as
4. ensure that your user associated with the keys has full admin access

 
# Terraform steps
1. `cd ../iac`
2. Open the file iac-team-6.tf
3. On line 14 fill in the access key for your user
4. On line 15 fill in the Secret key for your user
5. `terraform apply`
6. paste your account id when prompted
7. type yes when prompted
8. `terraform apply` No I did not mistype you have to apply twice for it to run without errors. It is a known issue that we could not resolve and there is an open issue for. (https://github.com/hashicorp/terraform-provider-aws/issues/4001)
9. repeat steps 5 and 6
 
 # AWS console steps
1. Log into your aws free tier account at https://aws.amazon.com/
2. make sure you are in US-2 ohio.
 
Because the api gateway can't currently deploy on the first "apply" the following steps are to tell the frontend what url the backend is located at:
1. go to api gateway 
2. click on stages on the left
3. click the deployed stage "gateway_stage" 
4. copy the invoke url from deployed stage
5. go the s3 bucket called "<random-id>-static-website-files-514-team6" 
6. go to the static/js folder 
7. download the main.js file 
8. open in any text editor
9. ctrl+f for "execute-api" 
10. replace this entire url with the invoke url copied in step 4
11. IMPORTANT: ensure it ends with a "/"
12. re-upload that file to the same folder using the same name

The following steps are intentional as a safeguard against Rekognition eating up money before the user is ready:
13. Go to the lambda functions. 
14. Go to the download-video-to-s3 lambda and enable the sqs trigger. 
15. (Optionally) add a sqs trigger for the only defined topic.
 
# Visiting the website:
1. open cloudfront in the AWS console
2. click on the active distribution
3. copy the "Distribution domain name" in the details section at the top
4. paste into new tab and enjoy!

# Testing: 
1. On the web page type a single word topic into the search bar and press enter.
2. wait about 2~5 minutes for the results to process (do not exit the search result modal)
3. view and grade!

# Destroy steps:
1. Make sure to destroy before 2 hours has passed since creating!
If it runs for 6 hours it collects videos 3 times it costs ~ 6 dollars
2. In order to destroy, make sure you are in the "iac" folder
3. type `terraform destroy`
4. follow the console prompts
5. ensure there are no error messages
 


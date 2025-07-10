This Terraform IaC starts/stops AWS instances on a schedule using Lambda and Eventbridge - 
automating the manual steps from AWS: https://repost.aws/knowledge-center/start-stop-lambda-eventbridge

Navigate to local file where you want to place files and run: git clone https://github.com/George904/Terraform_Projects.git

*** Update start_lambda_code and stop_lambda_code index.py files instance ids ['i-abcdef1234567', 'i-zyxuv098765']
*** Change variables in the variables.tf file - you'll need to update the start/stop schedule.

Then run the following terraform commands:

terraform init
terraform plan 
terraform apply -auto-approve


*If wanting to stop all instances you can COPY the script from the start_all_instances.py and stop_all_instances.py and PASTE into the respective index.py file (do not change index.py file name - Lambda will error out)
  - captures all instances when triggered by Eventbridge, so good option to include instances if ids are constanly changing. 
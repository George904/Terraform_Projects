import boto3
import os
 
region = os.environ['AWS_REGION']  # Automatically gets Lambda's region
instances = ['i-0b48416a96aaed3e0']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.start_instances(InstanceIds=instances)
    print('started your instances: ' + str(instances))
import boto3
import os

region = os.environ['AWS_REGION']  # Automatically gets Lambda's region
ec2 = boto3.client('ec2', region_name=region)

def get_instance_ids():
    response = ec2.describe_instances()
    instance_ids = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_ids.append(instance['InstanceId'])
    return instance_ids

def lambda_handler(event, context):
    instances = get_instance_ids()
    
    if not instances:
        print("No EC2 instances found.")
        return

    ec2.stop_instances(InstanceIds=instances)
    print('Stopped your instances: ' + str(instances))

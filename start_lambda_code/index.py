import boto3  
region = 'us-east-2'
instances = ['i-0bc81ad16df8d41e7']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.start_instances(InstanceIds=instances)
    print('started your instances: ' + str(instances))
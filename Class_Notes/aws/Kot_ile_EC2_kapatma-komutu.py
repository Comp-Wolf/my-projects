import boto3
ec2 = boto3.resource('ec2')
ec2.Instance('i-075067f71dd99a1e3').terminate()
import boto3

# Use Amazon S3
s3 = boto3.resource('s3')

# Create a new bucket
s3.create_bucket(Bucket='erdogan-boto3-bucket')

# Print out all bucket names
for bucket in s3.buckets.all():
    print(bucket.name)
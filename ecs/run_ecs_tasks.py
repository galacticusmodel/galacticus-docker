# Python script to submit and monitor ECS tasks
import boto3

session = boto3.Session(profile_name='saml')
client = session.client('ecs')

response = client.list_tasks(cluster='EDRN', 
                             family='galacticus', 
                             desiredStatus='RUNNING')
print("Number of runnig tasks:%s" % len(response["taskArns"]))
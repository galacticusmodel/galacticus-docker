# Python script to submit and monitor ECS tasks
import boto3
from time import sleep

MAX_CONCURRENT_TASKS = 1
NUM_TASKS = 10
SLEEP_SECONDS = 1

session = boto3.Session(profile_name='saml')
client = session.client('ecs')

itask = 0

while itask < NUM_TASKS:

    response = client.list_tasks(cluster='EDRN', 
                                 family='galacticus', 
                                 desiredStatus='RUNNING')
    num_running_tasks = len(response["taskArns"])
    print("Number of running tasks:%s" % num_running_tasks)
    
    if num_running_tasks < MAX_CONCURRENT_TASKS:
        itask += 1
        print("Submitting task # %s" % itask)
        resp = client.run_task(cluster='EDRN', 
                            taskDefinition="galacticus",
                            launchType='EC2', 
                            overrides={
                                'containerOverrides': [
                                    {
                                    "name": "galacticus",
                                    "environment": [
                                        {
                                            "name": "PARAMETER_FILE",
                                            "value": "parameters/quickTest.xml"
                                        }]
                                    }
                                ]
                            }
        )
        print("Task submission response=%s" % resp)
    else:
        sleep(SLEEP_SECONDS)
    

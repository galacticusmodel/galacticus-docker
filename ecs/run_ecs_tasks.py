# Python script to submit and monitor ECS tasks
import boto3
from time import sleep

MAX_CONCURRENT_TASKS = 2
NUM_TASKS = 4
SLEEP_SECONDS = 10

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
        tree_file= "Tree_UNIT_001_SF10000_d%s.hdf5" % itask
        print("Submitting task for tree file=%s" % itask)
        resp = client.run_task(cluster='EDRN', 
                            taskDefinition="galacticus",
                            launchType='EC2', 
                            overrides={
                                'containerOverrides': [
                                    {
                                    "name": "galacticus",
                                    "environment": [
                                        {
                                            "name": "TREE_FILE",
                                            "value": tree_file
                                        }]
                                    }
                                ]
                            }
        )
        print("Task submission response=%s" % resp)
    else:
        sleep(SLEEP_SECONDS)
    

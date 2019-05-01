# Python script to submit and monitor ECS tasks
import boto3
from time import sleep
boto3

# maximum number of running task on this cluster,
#  including the task running this script
MAX_CONCURRENT_TASKS = 2 + 1

# total number of galacticus tasks to be submitted
NUM_TASKS = 4

# number of seconds between task listing queries
SLEEP_SECONDS = 10

#session = boto3.Session(profile_name='saml')
#client = session.client('ecs')
client = boto3.client('ecs', region_name='us-west-2')

itask = 0
num_running_tasks = 0

# submit tasks
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
                                            "name": "PAREMETER_FILE",
                                            "value": "parameters/quickTest.xml"
                                        }]
                                    }
                                ]
                            }
        )
        print("Task submission response=%s" % resp)
    else:
        sleep(SLEEP_SECONDS)
        
# keep monitoring until all tasks but this one are done
while num_running_tasks > 1:
    response = client.list_tasks(cluster='EDRN', 
                                 family='galacticus', 
                                 desiredStatus='RUNNING')
    num_running_tasks = len(response["taskArns"])
    print("Number of running tasks:%s" % num_running_tasks)
    sleep(SLEEP_SECONDS)
    
    

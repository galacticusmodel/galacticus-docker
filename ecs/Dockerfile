# Dockerfile to run ECS tasks
FROM python:3

# install AWS Python
RUN pip install awscli boto3

# copy Python script to submit and monitor jobs
COPY run_ecs_tasks.py /usr/share/run_ecs_tasks.py

#CMD aws ecs list-tasks --cluster EDRN --region us-west-2

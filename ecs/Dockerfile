# Dockerfile to run ECS tasks
FROM python:3

# install AWS Python
RUN pip install awscli boto3

CMD aws ecs list-tasks --cluster EDRN --region us-west-2

#!/bin/bash
# Script to run multiple Kubernetes jobs

set -e

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# arguments - change as needed
export DATA_DIRECTORY=/tmp
export PARAMETER_FILE=parameters/quickTest.xml
export TREES_PER_DECADE=2
export STRIDE=2

# start $STRIDE containers
for ((i=0;i<=$STRIDE-1;i++)); 
do
   	export OFFSET=$i
   
   	# create Kubernetes config map storing parameters for the job
   	echo "Executing iteration for stride=$STRIDE offset=$i"
   	kubectl create configmap galacticus-config\
   			--from-literal=DATA_DIRECTORY=${DATA_DIRECTORY}\
   			--from-literal=PARAMETER_FILE=${PARAMETER_FILE}\
   			--from-literal=TREES_PER_DECADE=${TREES_PER_DECADE}\
   			--from-literal=STRIDE=${STRIDE}\
   			--from-literal=OFFSET=${OFFSET}
	
	# run Kubernetes job for this configiration
	kubectl create -f ${THIS_DIR}/galacticus.yml
	
	# delete this configuration
	sleep 2
	kubectl delete configmap galacticus-config
      
done



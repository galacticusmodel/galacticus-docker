#!/bin/bash
# Script to run multiple Kubernetes jobs

set -e

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# arguments - change as needed
export HOST_DIRECTORY=/tmp
export PARAMETER_FILE=parameters/quickTest.xml
export TREES_PER_DECADE=2
export STRIDE=2

# start $STRIDE jobs
for ((i=0;i<=$STRIDE-1;i++)); 
do
   	export OFFSET=$i
   	echo "Executing iteration for stride=$STRIDE offset=$i"
   	
   	# interpolate the job manifest in place
   	# and use it to create a Kubernetes job
    # note the use of the '#' character instead of '/' in the first two replacements
   	cat ${THIS_DIR}/galacticus.yml | sed "s#@HOST_DIRECTORY@#${HOST_DIRECTORY}#"\
   	                               | sed "s#@PARAMETER_FILE@#${PARAMETER_FILE}#"\
   	                               | sed "s/@TREES_PER_DECADE@/${TREES_PER_DECADE}/"\
   	                               | sed "s/@STRIDE@/${STRIDE}/"\
   	                               | sed "s/@OFFSET@/${OFFSET}/"\
   	                               | kubectl create -f -
   		
      
done



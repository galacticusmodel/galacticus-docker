#!/bin/bash
# Script to run multiple Kubernetes jobs

set -e

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# arguments - change as needed
HOST_DIRECTORY=/tmp # not uses, kept as example
NUM_JOBS=3

# start $STRIDE jobs
for ((i=2;i<=$NUM_JOBS;i++)); 
do
   	export OFFSET=$i
   	echo "Submitting job=$i"
   	
   	# interpolate the job manifest in place
   	# and use it to create a Kubernetes job
    # note the use of the '#' character instead of '/' in the first two replacements
    TREE_FILE="Tree_UNIT_001_SF10000_d${i}.hdf5"
    OUTPUT_FILE="galacticus_d${i}.hdf5"
   	cat ${THIS_DIR}/galacticus.yml | sed "s#@HOST_DIRECTORY@#${HOST_DIRECTORY}#"\
   	                               | sed "s/__OUTPUT_FILE__/${OUTPUT_FILE}/"\
   	                               | sed "s/__TREE_FILE__/${TREE_FILE}/"\
   	                               | kubectl create -f -
   		
      
done



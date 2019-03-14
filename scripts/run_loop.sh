# Script to run several iterations of Galacticus

# arguments - change as needed
export DATA_DIRECTORY=/tmp
export PARAMETER_FILE=parameters/quickTest.xml
export TREES_PER_DECADE=2
export STRIDE=2

# start $STRIDE containers
for ((i=0;i<=$STRIDE-1;i++)); 
do
   export OFFSET=$i
   echo "Executing iteration for stride=$STRIDE offset=$i"
   docker run -it -d \
          -v ${DATA_DIRECTORY}:/data \
          -e DATA_DIRECTORY=/data \
          -e PARAMETER_FILE=${PARAMETER_FILE} \
          -e TREES_PER_DECADE=${TREES_PER_DECADE} \
          -e STRIDE=${STRIDE} \
          -e OFFSET=${OFFSET} \
          galacticus/galacticus:latest
done

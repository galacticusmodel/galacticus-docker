#!/bin/sh
# Script to run Galacticus at container startup

set -e

printenv

# read arguments from environment, or use default values
PARAMETER_FILE=${PARAMETER_FILE:-parameters/quickTest.xml}
TREES_PER_DECADE=${TREES_PER_DECADE:-2}
STRIDE=${STRIDE:-1}
OFFSET=${OFFSET:-0}
INPUT_DIRECTORY=${INPUT_DIRECTORY:-/usr/local/galacticus/input}
OUTPUT_DIRECTORY=${OUTPUT_DIRECTORY:-/tmp}
TREE_FILE=${TREE_FILE:-Tree_UNIT_001_SF10000_d1.hdf5}

# echo arguments
echo "PARAMETER_FILE=$PARAMETER_FILE"
echo "TREES_PER_DECADE = $TREES_PER_DECADE"
echo "STRIDE = $STRIDE"
echo "OFFSET = $OFFSET"
echo "INPUT_DIRECTORY=$INPUT_DIRECTORY"
echo "OUTPUT_DIRECTORY=$OUTPUT_DIRECTORY"
echo "TREE_FILE = $TREE_FILE"

# interpolate the parameter file
sed -i "s/@TREES_PER_DECADE@/$TREES_PER_DECADE/" ${PARAMETER_FILE}
sed -i "s/@STRIDE@/$STRIDE/" ${PARAMETER_FILE}
sed -i "s/@OFFSET@/$OFFSET/" ${PARAMETER_FILE}
sed -i "s|@INPUT_DIRECTORY@|$INPUT_DIRECTORY|" ${PARAMETER_FILE}
sed -i "s|@OUTPUT_DIRECTORY@|$OUTPUT_DIRECTORY|" ${PARAMETER_FILE}
sed -i "s|@TREE_FILE@|$TREE_FILE|" ${PARAMETER_FILE}

# run the model
./Galacticus.exe ${PARAMETER_FILE}

# move the output to another location
# where it can be accessed before the container exits
hostname=`hostname`
echo "Moving output to ${OUTPUT_DIRECTORY}"
mv galacticus.hdf5 ${OUTPUT_DIRECTORY}/galacticus-${hostname}-${TREES_PER_DECADE}_${STRIDE}_${OFFSET}.hdf5
echo "Done"

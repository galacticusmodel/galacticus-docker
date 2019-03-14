#!/bin/sh
# Script to run Galacticus at container startup

set -e

printenv

# read arguments from environment, or use default values
PARAMETER_FILE=${PARAMETER_FILE:-parameters/quickTest.xml}
TREES_PER_DECADE=${TREES_PER_DECADE:-2}
STRIDE=${STRIDE:-1}
OFFSET=${OFFSET:-0}
DATA_DIRECTORY=${DATA_DIRECTORY:-/tmp}

# echo arguments
echo "PARAMETER_FILE=$PARAMETER_FILE"
echo "DATA_DIRECTORY=$DATA_DIRECTORY"
echo "TREES_PER_DECADE = $TREES_PER_DECADE"
echo "STRIDE = $STRIDE"
echo "OFFSET = $OFFSET"

# interpolate the parameter file
sed -i "s/@TREES_PER_DECADE@/$TREES_PER_DECADE/" ${PARAMETER_FILE}
sed -i "s/@STRIDE@/$STRIDE/" ${PARAMETER_FILE}
sed -i "s/@OFFSET@/$OFFSET/" ${PARAMETER_FILE}

# run the model
./Galacticus.exe ${PARAMETER_FILE}

# move the output to another location
# where it can be accessed before the container exits
hostname=`hostname`
mv galacticus.hdf5 ${DATA_DIRECTORY}/galacticus-${hostname}-${TREES_PER_DECADE}_${STRIDE}_${OFFSET}.hdf5

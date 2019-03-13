#!/bin/sh
# Script to run Galacticus at container startup

TREES_PER_DECADE=2
STRIDE=2
STEP=0

# interpolate the parameter file
sed -i "s/@TREES_PER_DECADE@/$TREES_PER_DECADE/" parameters/quickTest.xml
sed -i "s/@STRIDE@/$STRIDE/" parameters/quickTest.xml
sed -i "s/@STEP@/$STEP/" parameters/quickTest.xml

# run the model
./Galacticus.exe parameters/quickTest.xml

# move the output to another location
# where it can be accessed before the container exits
hostname=`hostname`
mv galacticus.hdf5 /data/galacticus-${hostname}.hdf5

#!/bin/sh
# Script to run Galacticus at container startup

set -e

# parse command line arguments
for ARGUMENT in "$@"
do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)   

    case "$KEY" in
            TREES_PER_DECADE)	TREES_PER_DECADE=${VALUE} ;;
            STRIDE)    			STRIDE=${VALUE} ;;  
            OFFSET)    			OFFSET=${VALUE} ;;
            *)   
    esac    
done

# echo arguments
echo "TREES_PER_DECADE = $TREES_PER_DECADE"
echo "STRIDE = $STRIDE"
echo "OFFSET = $OFFSET"

# interpolate the parameter file
sed -i "s/@TREES_PER_DECADE@/$TREES_PER_DECADE/" parameters/quickTest.xml
sed -i "s/@STRIDE@/$STRIDE/" parameters/quickTest.xml
sed -i "s/@OFFSET@/$OFFSET/" parameters/quickTest.xml

# run the model
./Galacticus.exe parameters/quickTest.xml

# move the output to another location
# where it can be accessed before the container exits
hostname=`hostname`
mv galacticus.hdf5 /data/galacticus-${hostname}-${TREES_PER_DECADE}_${STRIDE}_${OFFSET}.hdf5
